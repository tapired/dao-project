
import { MoralisProvider } from "react-moralis";
import "../styles/globals.css";
function MyApp({ Component, pageProps }) {
  return (
    <MoralisProvider
      appId= "8ErM1Zlb9NrT997bDq5tCmlCKUVWrdZQNvaU8beH"
      serverUrl= "https://fa5sncevcpp8.usemoralis.com:2053/server"
    >
      <Component {...pageProps} />
    </MoralisProvider>
  );
}
export default MyApp;
