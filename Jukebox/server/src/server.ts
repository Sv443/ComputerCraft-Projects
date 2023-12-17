import express from "express";
import "dotenv/config";

const { env } = process;
const app = express();

export async function initServer() {
  app.use(express.json());

  app.get("*", (req, res) => {
    console.log(`>> ${req.method} ${req.url}`);
    console.log(`  Params:  ${JSON.stringify(req.params)}`);
    console.log(`  Headers: ${JSON.stringify(req.headers)}`);
    console.log();
    res.send("Hello World!");
  });

  if(!env.HTTP_PORT || isNaN(Number(env.HTTP_PORT)))
    throw new Error("Invalid environment variable HTTP_PORT. Check the .env file.");

  app.listen(env.HTTP_PORT, () => {
    console.log(`\nServer listening on port ${env.HTTP_PORT}\n`);
  });
}
