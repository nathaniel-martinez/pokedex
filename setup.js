const os = require("os");
const cp = require("child_process");
const path = require("path");
const pathFinder = require("." + path.sep + "env_interface" + path.sep + "pathfinder.js");


if(process.platform == "linux"){
	let fun = '/home/yescomputer/Documents/Codeing/pokedex/env_interface/setup.sh';

	let echo = cp.spawnSync('sh', [fun], { stdio: 'inherit', encoding: 'utf-8' });
}
else if(process.platform = "darwin"){

}
else if(process.platform = "win32"){

}
