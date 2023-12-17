import { initServer } from "./server.js";
import pkg from "../package.json" assert { type: "json" };

async function init() {
  console.log(`> Jukebox Server by Sv443\n> ${pkg.author.url}\n`);

  let stage: string | null = "server";
  try {
    await initServer();
    stage = null;
  }
  catch(err) {
    if(stage)
      console.error(`\n> Error in ${stage}: \x1b[31m${err}\x1b[0m\n`);
    else
      console.error(`\n> General error: \x1b[31m${err}\x1b[0m\n`);
    setImmediate(() => process.exit(1));
  }
}

init();
