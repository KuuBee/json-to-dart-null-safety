import axios from "axios";
import { GetStaticProps, NextPage } from "next";
import Head from "next/head";
import { ChangeEvent, useState } from "react";
import styles from "../styles/Home.module.scss";
import { GenerateDart } from "../utils/toDart";
import SyntaxHighlighter from "react-syntax-highlighter";

const Home: NextPage = () => {
  const [inputVal, setInputVal] = useState(
    JSON.stringify({
      a_test: 1,
      b: "bb",
      c: true,
      d: null,
      e: {
        aa: 1,
        bb: "bbb",
        cc: false,
        dd: null,
        ee: {
          aaa: 3,
          bbb: "bbb",
          ccc: true,
          ddd: null
        }
      },
      f: [1, 2, 3, 4, 5, 6],
      g: ["a", "b", "c", "d"],
      h: [
        {
          h1: "h1",
          h2: 2,
          h3: true,
          h4: "h4",
          h5: null,
          h6: [1, 2, 3, null],
          h7: null,
          h8: null
        },
        {
          h1: "h1",
          h2: 431,
          h3: false,
          h4: null,
          h5: null,
          h6: null,
          h7: [
            {
              hh1: 1,
              hh2: "2",
              hh3: true,
              hh4: "h4",
              hh5: null,
              hh6: [1, 2, 3, null]
            },
            null
          ],
          h8: {
            hh1: 1,
            hh2: false,
            hh3: null
          }
        },
        {
          h1: "h1",
          h2: 431,
          h3: false,
          h4: null,
          h5: null,
          h6: null,
          h7: [
            {
              hh1: 1,
              hh2: "2",
              hh3: true,
              hh4: "h4",
              hh5: null,
              hh6: [1, 2, 3, null]
            },
            null
          ],
          h8: {
            hh1: 1,
            hh2: false,
            hh3: "null"
          }
        }
      ]
    })
  );
  const [outputVal, setOututVal] = useState<string>("");
  const inputChange = async (val: ChangeEvent<HTMLTextAreaElement>) => {
    setInputVal(val.target.value);
    const jsonStr = val.target.value;
    toAst(jsonStr);
  };
  const toAst = async (val: string) => {
    try {
      const res = JSON.stringify(JSON.parse(val), null, 2);
      setInputVal(res);
      const { data } = await axios.get(
        "http://localhost:3000/api/json-to-ast",
        {
          params: { json: res }
        }
      );
      const a = new GenerateDart();
      const resCode = a.toDart(data);
      setOututVal(resCode);
      console.log(data);
    } catch (error) {
      console.error("错误的JSON格式:\n", error);
    }
  };
  return (
    <div className={styles.container}>
      <Head>
        <title>JSON to Dart</title>
        <link rel="icon" href="/favicon.ico" />
        <meta name='description' content="JSON to dart null safety" />
        <meta name='keywords' content="JSON Dart null safety" />
      </Head>
      <main>
        <h1>
          <span>JSON to Dart</span>
          <span style={{ color: "red" }}> null safety</span>
        </h1>
        <div className={styles.content}>
          <textarea
            className={styles.input}
            name=""
            id=""
            value={inputVal}
            onChange={inputChange}
          ></textarea>
          <SyntaxHighlighter language="dart" className={styles.output}>
            {outputVal}
          </SyntaxHighlighter>
        </div>
      </main>
    </div>
  );
};
Home.getInitialProps = async () => {
  return { a: 1 };
};
export default Home;
