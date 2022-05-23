// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract DAO is Ownable, ReentrancyGuard {

    struct EmployeeForm {
        string id;
        uint nonce;
    }
    struct CompanyInfo {
        uint256 initializedAt;
        uint256 companyId;
        address owner;
        string companyName;
        bool active;
    }
    struct ProposalInfo {
        uint256 initializedAt;
        uint256 deadLine;
        uint256 totalVoted;
        uint8[] inputTargets;
        address creator;
        bool active;
    }
    uint256 index = 1;
    mapping(uint256 => CompanyInfo) public companyDescription; // start from 1
    mapping(address => mapping(uint256 => bool)) public isEmployee; // checks for employee of a spesific company
    mapping(address => mapping(uint256 => bool)) public formerEmployee;
    mapping(uint256 => mapping(address => uint256)) public votedProposals; // checks for an employee votes for the companys polls
    mapping(uint256 => uint256) public proposalsCreated; // proposals created for a company
    mapping(uint256 => uint256) public onGoingProposals; // proposals ongoing for a company
    mapping(address => ProposalInfo[]) public allProposals; // allproposals of a company
    uint256 companyRegistered; // to keep track of all registered companies

    mapping(uint256 => mapping(bytes32 => address)) private approvedHashes;

    function setHashes(EmployeeForm[] calldata employeeForm, uint256 _companyIndex) external {
      require(companyDescription[_companyIndex].owner == msg.sender, "only authorized");

      for (uint i=0; i <= employeeForm.length; i++) {
        bytes32 hashedForm = _getMessageHash(employeeForm[i].id, employeeForm[i].nonce);
        if (approvedHashes[_companyIndex][hashedForm] != address(0)) continue;
        approvedHashes[_companyIndex][hashedForm] = address(this);
      }
    }

    function signCompany(string memory _name, address _companyRepresenter) external onlyOwner {
        require(companyDescription[index].companyId == 0); // not initialized before
        require(_companyRepresenter != address(0));

        companyDescription[index] = CompanyInfo({
            initializedAt: block.timestamp,
            companyId: index,
            owner: _companyRepresenter,
            companyName: _name,
            active: true
        });
        index++;
        companyRegistered++;
    }

    function signEmployee(uint256 _companyIndex, string memory _id, uint _nonce) external {
       bytes32 _hash = _getMessageHash(_id, _nonce);
       require(approvedHashes[_companyIndex][_hash] == address(this));
        require(
            isEmployee[msg.sender][_companyIndex] == false,
            "already employee"
        );
        require(msg.sender != address(0));
        isEmployee[msg.sender][_companyIndex] = true;
        approvedHashes[_companyIndex][_hash] == address(0);
    }

    function kickEmployee(uint256 _companyIndex, string memory _id, uint _nonce) external {
      require(companyDescription[_companyIndex].owner == msg.sender, "only authorized");
      bytes32 _hash = _getMessageHash(_id, _nonce);
      require(approvedHashes[_companyIndex][_hash] != address(0), "not an employee");

      address employee = approvedHashes[_companyIndex][_hash];
      approvedHashes[_companyIndex][_hash] = address(this);
      isEmployee[employee][_companyIndex] = false; // fire
      formerEmployee[employee][_companyIndex] = true;
    }

    function createProposalFromCompany(
        uint256 _companyIndex,
        uint256 _deadLine,
        uint8 _inputTargets
    ) external {
        require(companyDescription[_companyIndex].owner == msg.sender, "only authorized");
        require(block.timestamp < _deadLine, "!time");

        uint8[] memory array = new uint8[](_inputTargets);
        for (uint256 i; i < _inputTargets; i++) {
            array[i] = 0;
        }
        allProposals[msg.sender].push(
            ProposalInfo(block.timestamp, _deadLine, 0, array, msg.sender, true)
        );
        proposalsCreated[_companyIndex]++;
        onGoingProposals[_companyIndex]++;
    }

    function submitEmployeeVote(
        uint256 _companyIndex,
        address _proposalCreator,
        uint256 _proposalIndex,
        uint256 _input
    ) external  {
        require(isEmployee[msg.sender][_companyIndex] == true, "!employee");
        require(
            allProposals[_proposalCreator][_proposalIndex].active == true,
            "!deadLine"
        );
        require(block.timestamp <= allProposals[_proposalCreator][_proposalIndex].deadLine);
        allProposals[_proposalCreator][_proposalIndex].inputTargets[_input]++;
        allProposals[_proposalCreator][_proposalIndex].totalVoted++;
        votedProposals[_companyIndex][msg.sender]++;
    }


    function _getMessageHash(
        string memory _id,    // id number of the company of the employee
        uint _nonce           // random number that company will assign to employee
    ) internal view returns (bytes32) {
        return keccak256(abi.encodePacked(_id, _nonce, address(this)));
    }

    // [{("A",1), ("B",2)}]

}
