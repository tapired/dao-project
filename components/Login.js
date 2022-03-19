
import { useMoralis } from "react-moralis";



function Login() {
  const { authenticate, authError, chainId} = useMoralis();
  
 
  
  return (
    
        
        <div className="container flex justify-center items-center">
          {authError && (
            <p >
              {authError.name}
              {authError.message}
            </p>
          )}
          <button
            onClick={authenticate}
            className="px-5 py-2 bg-black text-white rounded-3xl m-4 "
          >
            Login with Metamask
          </button>
        </div>
      
  );
}

export default Login;