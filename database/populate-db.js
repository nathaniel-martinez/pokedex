const Sequelize = require("sequelize");
const pg = require("pg");


const database = "pokedex-db";
const username = "poke-user";
const password = "password";
const host = "localhost";

const sequelize = new Sequelize(database, username, password);
/**
 * This function starts a connection with the pokemon database, and if that database does not
 * exist it creates it
 * @param: none
 * @output: none
 */
async function startConnection(){
	const database = "pokedexdb";
	const username = "pokeuser";
	const password = "password";
	const host = "localhost";

	let 
}
