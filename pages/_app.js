import "../styles/globals.css";
import { MoralisProvider } from "react-moralis";
function MyApp({ Component, pageProps }) {
  return (
    <MoralisProvider
      appId="WwNs2bgb7lXGsfDtRJLVc8QBLqdSAm9tAdWcUZoc"
      serverUrl="https://x2vg8rj7k8ml.usemoralis.com:2053/server"
    >
      {<Component {...pageProps} />}
    </MoralisProvider>
  );
}

export default MyApp;
