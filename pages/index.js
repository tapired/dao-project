import Login from "../components/Login";
import { useMoralis, useChain } from "react-moralis";
import { useState, useEffect } from "react";
import { useRouter } from 'next/router'

export default function Home() {
  const { isAuthenticated, logout, chainId } = useMoralis();
  const { switchNetwork,account} = useChain();
  const [rinkeby, setRinkeby] = useState(false);
  const router = useRouter()
  useEffect(() => {
    if (chainId != "0xa869") {
      setRinkeby(true);
    } else if (chainId === "0xa869") {
      setRinkeby(false);
    }
    
  }, [chainId]);
 
 
  return (
    <div className="w-full flex flex-col">
      {isAuthenticated ? (
        <div className="p-10 md:px-10 lg:px-30 xl:px-120 z-10 justify-between flex font-bold">
          <p className="text-bold  py-1 bg-black text-white  rounded-xl w-36 m-4 text-center">
            You are logged in
          </p>

          {rinkeby ? (
            <button onClick={() => switchNetwork("0xa869")} className="bg-blue-600 px-3 rounded-3xl text-extrabold cursor-pointer">
              Switch to Fuji
            </button>
          ) : (
            <></>
          )}
          <button
            onClick={logout}
            className="bg-red-500 px-3 py-1 rounded-3xl text-extrabold self-end cursor-pointer"
          >
            Sign Out
          </button>
          <button onClick={()=>router.push('/employee')}>Employee</button>
          <button onClick={()=>router.push('/public')}>Public</button>
        </div>
      ) : (
        <Login />
      )}
    </div>
  );
}
