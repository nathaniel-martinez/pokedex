const os = require("os");
const cp = require("child_process");
const path = require("path");
const absPath = require("." + path.sep + "enviroment-interface" + path.sep + "pathfinder.js");
const { Sequelize, DataType } = require("sequelize");
const trainerJSON = require(absPath(["server-data", "trainers.json"]));


if(process.platform == "linux"){
	/*let fun = pathFinder.getEnvInterfacePath(true, "setup.sh");

	let echo = cp.spawnSync('sh', [fun], { cwd: pathFinder.getEnvInterfacePath(), stdio: 'inherit', encoding: 'utf-8' });*/
	populateDb()
}
else if(process.platform = "darwin"){
	populateDb()
}
else if(process.platform = "win32"){
	populateDb()
}


