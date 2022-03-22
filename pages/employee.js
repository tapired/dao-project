import React from "react";
import { ethers } from "ethers";
import Web3Modal from "web3modal";
import { useState } from "react";
import { daoaddress } from "../config";

import Dao from "../artifacts/contracts/DAO.sol/DAO.json";

const employee = () => {
  const [url, setUrl] = useState("");
  const [companyid, setCompanyId] = useState("");
  const [adress, setAdress] = useState("");

  async function signCompany() {
    if (url.length > 1) {
      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const provider = new ethers.providers.Web3Provider(connection);
      const signer = provider.getSigner();

      let contract = new ethers.Contract(daoaddress, Dao.abi, signer);
      let company = await contract.companyDescription(2);
      console.log(company);
      let transaction = contract.signCompany(url);
    } else {
      alert("!!!!");
    }
  }
  async function signEmployee() {
    const web3Modal = new Web3Modal();
    const connection = await web3Modal.connect();
    const provider = new ethers.providers.Web3Provider(connection);
    const signer = provider.getSigner();
    let contract = new ethers.Contract(daoaddress, Dao.abi, signer);
    let company = await contract.signEmployee(companyid, adress);
  }

  return (
    <div className="flex flex-row justify-center items-center gap-x-5 mt-20">
      <input
        className="shadow appearance-none border border-red-500 rounded w-25 py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
        type="text"
        value={url}
        onChange={(e) => setUrl(e.target.value)}
      />
      <label>Company id</label>
      <input
        type="text"
        onChange={(e) => setCompanyId(e.target.value)}
        value={companyid}
      />
      <label>Adress</label>
      <input
        type="text"
        onChange={(e) => setAdress(e.target.value)}
        value={adress}
      />
      <button
        className="px-6 py-2 bg-black rounded-full text-white"
        onClick={signCompany}
      >
        Sign Company
      </button>
      <button
        className="px-6 py-2 bg-black rounded-full text-white"
        onClick={signEmployee}
      >
        Sign Employee
      </button>
      <button className="px-6 py-2 bg-black rounded-full text-white">
        Create Propasal as Company{" "}
      </button>
    </div>
  );
};

export default employee;
