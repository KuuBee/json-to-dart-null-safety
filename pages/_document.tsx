import React from "react";
import Document, {
  Html,
  Head,
  Main,
  NextScript,
  DocumentContext
} from "next/document";
import createEmotionServer from "@emotion/server/create-instance";
import {theme} from "../core/theme";
import { ServerStyleSheets } from "@material-ui/core/styles";
import { cache } from "./_app";

const { extractCritical } = createEmotionServer(cache);

export default class MyDocument extends Document {
  render() {
    function GoogleAnalyzeScript() {
      if (process.env.NEXT_PUBLIC_ENV === "dev") return <></>;
      return (
        <>
          <script
            async
            src="https://www.googletagmanager.com/gtag/js?id=G-DX0RNN128J"
          ></script>
          <script
            dangerouslySetInnerHTML={{
              __html: `window.dataLayer = window.dataLayer || [];
              function gtag() {
                dataLayer.push(arguments);
              }
              gtag("js", new Date());
              gtag("config", "G-DX0RNN128J");`
            }}
          ></script>
        </>
      );
    }
    return (
      <Html lang="zh">
        <Head>
          {/* PWA primary color */}
          <meta name="theme-color" content={theme.palette.primary.main} />
          <meta name="description" content="JSON to dart null safety" />
          <meta name="keywords" content="JSON,Dart,nullSafety" />
          <meta name="renderer" content="webkit"></meta>
          <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap"
          />
          <link
            rel="icon"
            type="image/x-icon"
            href="https://autocode.icu/assets/favicon/favicon.ico"
          />
        </Head>
        <body>
          <Main />
          <NextScript />
          <GoogleAnalyzeScript />
        </body>
      </Html>
    );
  }
}

MyDocument.getInitialProps = async (ctx: DocumentContext) => {
  // Render app and page and get the context of the page with collected side effects.
  const sheets = new ServerStyleSheets();
  const originalRenderPage = ctx.renderPage;

  ctx.renderPage = () =>
    originalRenderPage({
      enhanceApp: (App) => (props) => sheets.collect(<App {...props} />)
    });

  const initialProps = await Document.getInitialProps(ctx);
  const styles = extractCritical(initialProps.html);

  return {
    ...initialProps,
    // Styles fragment is rendered after the app and page rendering finish.
    styles: [
      ...React.Children.toArray(initialProps.styles),
      sheets.getStyleElement(),
      <style
        key="emotion-style-tag"
        data-emotion={`css ${styles.ids.join(" ")}`}
        // eslint-disable-next-line react/no-danger
        dangerouslySetInnerHTML={{ __html: styles.css }}
      />
    ]
  };
};
