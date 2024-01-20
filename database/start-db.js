const Sequelize = require("sequelize");
const pg = require("pg");

/**
 * This function starts a connection with the pokemon database, and if that database does not
 * exist it creates it
 * @param: none
 * @output: none
 */
async function startConnection(){
	const database = "pokedex-db";
	const username = "poke-user";
	const password = "password";
	const host = "localhost";

	let 
}
