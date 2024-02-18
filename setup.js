const os = require("os");
const cp = require("child_process");
const path = require("path");
const absPath = require("." + path.sep + "env_interface" + path.sep + "pathfinder.js");
const { Sequelize, DataType } = require("sequelize");
const trainerObjs = require(getServerDataPath(["trainers.json"]));

async function populateDb(){
	const sequelize = new Sequelize("pokedexdb", "pokedexuser", "pokedex", {
	host: 'localhost',
	dialect: 'postgres'
	});

	try {
		await sequelize.authenticate();
		console.log('Connection has been established successfully.');
	} catch (error) {
		console.error('Unable to connect to the database:', error);
	}

	console.log(trainerObjs);
}


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


