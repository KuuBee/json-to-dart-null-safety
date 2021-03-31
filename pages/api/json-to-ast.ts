import { NextApiRequest, NextApiResponse } from "next";
import parse from "json-to-ast";

export default (req: NextApiRequest, res: NextApiResponse) => {
  if (req.method === "POST") {
    const data = parse(req.body.json as string, {
      loc: false
    });
    res.status(200).json({ data });
  } else {
    res.status(405).json({
      error: "error method"
    });
  }
};
