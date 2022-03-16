// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

import "./helpers/ReentrancyGuard.sol";

contract DAO is ReentrancyGuard {
    struct CompanyInfo {
        uint256 initializedAt;
        uint256 companyId;
        uint256 proposalCreatorTokenRate;
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
    address private admin ;
    uint256 index = 1;
    uint256 constant CONSTANT_TOKEN_AMOUNT = 10**18;
    mapping(uint256 => CompanyInfo) public companyDescription; // start from 1
    mapping(address => mapping(uint256 => bool)) public isEmployee; // checks for employee of a spesific company
    mapping(uint256 => mapping(address => uint256)) public eveTokenOfCompany; // checks for an employee evetoken for the company
    mapping(uint256 => uint256) public proposalsCreated; // proposals created for a company
    mapping(uint256 => uint256) public onGoingProposals; // proposals ongoing for a company
    mapping(address => ProposalInfo[]) public allProposals; // allproposals of an employee
    uint256 companyRegistered; // to keep track of all registered companies
    constructor() {
      admin = msg.sender;
    }

    function setProposalCreatorTokenRate(uint256 _proposalCreatorTokenRate, uint256 _companyIndex) external {
       require(msg.sender == companyDescription[_companyIndex].owner, "!owner");
       companyDescription[_companyIndex].proposalCreatorTokenRate = _proposalCreatorTokenRate; // 10000/10000 is 1
    }

    function signCompany(string memory _name) external {
        // modifier here
        require(companyDescription[index].companyId == 0); // not initialized before

        companyDescription[index] = CompanyInfo({
            initializedAt: block.timestamp,
            companyId: index,
            proposalCreatorTokenRate: 1500,
            owner: msg.sender,
            companyName: _name,
            active: true
        });
        index++;
        companyRegistered++;
    }

    function signEmployee(uint256 _companyIndex, address _employee) external {
        require(
            companyDescription[_companyIndex].owner == msg.sender,
            "only authorized"
        );
        require(
            isEmployee[_employee][_companyIndex] == false,
            "already employee"
        );
        require(_employee != address(0));
        isEmployee[_employee][_companyIndex] = true;
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

    function createProposalFromEmployee(
        uint256 _companyIndex,
        uint256 _deadLine,
        uint8 _inputTargets
    ) external {
        require(isEmployee[msg.sender][_companyIndex] == true, "!employee");
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
    ) external nonReentrant {
        require(isEmployee[msg.sender][_companyIndex] == true, "!employee");
        require(
            allProposals[_proposalCreator][_proposalIndex].active == true,
            "!deadLine"
        );
        require(block.timestamp <= allProposals[_proposalCreator][_proposalIndex].deadLine);
        allProposals[_proposalCreator][_proposalIndex].inputTargets[_input]++;
        allProposals[_proposalCreator][_proposalIndex].totalVoted += CONSTANT_TOKEN_AMOUNT;
        eveTokenOfCompany[_companyIndex][msg.sender] += CONSTANT_TOKEN_AMOUNT;
    }
    function finishEmployeeProposal(
        uint256 _companyIndex,
        address _proposalCreator,
        uint256 _proposalIndex
    ) external {
      require(
          allProposals[_proposalCreator][_proposalIndex].active == true,
          "!finishedAlready"
      );
        require(allProposals[_proposalCreator][_proposalIndex].creator == msg.sender || msg.sender == admin, "!onlyCreator");
        require(block.timestamp >= allProposals[_proposalCreator][_proposalIndex].deadLine);
        allProposals[_proposalCreator][_proposalIndex].active == false;
        onGoingProposals[_companyIndex] --;
        eveTokenOfCompany[_companyIndex][msg.sender] = (allProposals[_proposalCreator][_proposalIndex].totalVoted * (companyDescription[_companyIndex].proposalCreatorTokenRate)/10000) + CONSTANT_TOKEN_AMOUNT;
    }
}
