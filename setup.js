const os = require("os");
const cp = require("child_process");
const path = require("path");
const absPath = require("." + path.sep + "env_interface" + path.sep + "pathfinder.js");
const { Sequelize, DataType } = require("sequelize");
const trainerObjs = require(absPath(["server_data", "trainers.json"]));

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

	const Trainer = Sequelize.define("trainer", {
		name: {
			type: DataType.STRING,
			allowNull: false
		},
		img: {
			type: DataType.TEXT,
			allowNull: false
		}
	});

	const Pokemon = Sequelize.define("pokemon", {
		name: {
			type: DataType.STRING,
			allowNull: false
		},
		attrType: {
			type: DataType.STRING,
			allowNull: false
		},
		desc: {
			type: DataType.TEXT,
			allowNull: false
		},
		img: {
			type: DataType.TEXT,
			allowNull: false
		}
	});
	Pokemon.belongsToMany(Trainer, { through: 'PokemonTrainers' };
	Trainer.belongsToMany(Pokemon, { through: 'PokemonTrainers' };
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


