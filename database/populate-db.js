const { Sequelize, DataType } = require("sequelize");
const path = require("path");
const absPath = require("." + path.sep + "enviroment-interface" + path.sep + "pathfinder.js");
const trainerJSON = require(absPath(["server-data", "trainers.json"]));

async function populateDb() {
	const database = "pokedexdb";
	const username = "pokedexuser";
	const password = "pokedex";
	const databaseAddr = "localhost";
	const sequelize = new Sequelize(database, username, password, {
		host: databaseAddr,
		dialect: 'postgres'
	});

	try {
		await sequelize.authenticate();
		console.log('Connection has been established successfully.');
	} catch (error) {
		console.error('Unable to connect to the database:', error);
	}

	//Creating and Connecting to the tables
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

	//Populating the tables
	console.log(trainerJSON);
}

popoulateDb();