import { NextApiRequest, NextApiResponse } from "next";
import parse from "json-to-ast";

export default (req: NextApiRequest, res: NextApiResponse) => {
  const data = parse(req.query.json as string, {
    loc: false
  });
  res.status(200).json(data);
};
