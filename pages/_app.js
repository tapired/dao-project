import "../styles/globals.css";
import { MoralisProvider } from "react-moralis";
function MyApp({ Component, pageProps }) {
  return (
    <MoralisProvider
      appId="KfPq8FLC8aykIFkhUgFCyo2JpIIurTVdshadgbKL"
      serverUrl="https://1pds2t2v5jkw.usemoralis.com:2053/server"
    >
      {<Component {...pageProps} />}
    </MoralisProvider>
  );
}

export default MyApp;
