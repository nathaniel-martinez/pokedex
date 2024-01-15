const path = require("path");
const express = require("express");
const app = express();
const port = 3000;
//const port = readPort(); write readPort function to read port from configuration file


var viewsPath = path.resolve(".." + path.sep + "views");

app.get("/", (req, res) => {
	res.redirect("trainers");
});

//selectable list of trainers
app.get("/trainers", (req, res) => {
	let selectorPath = path.join(viewsPath, "selector.ejs");

	res.set('Content-Type', 'text/html');
	res.sendFile(selectorPath);
});

//individual trainer
app.get("/:trainerName", (req, res) => {
	let trainerName = req.params.trainerName;
	//res.send(trainerRender(trainerName)) Polymorphic html generator that gets
	//different info based on trainerName passed to it
	// Must include a list of pokemons to select
	// go back button to selection
	res.send("<h1>trainer: " + trainerName + "</h1>");
});

app.get("/:trainerName/:pokemonName", (req, res) => {
	let trainerName = req.params.trainerName;
	let pokemonName = req.params.pokemonName;
	//res.send(pokeRender(trainerName, pokeName)) Polymorphic html generator that gets
	//different info based on trainerName and pokemonName passed to it
	//go back button to trainer
	res.send("<h1>trainer: " + trainerName + "</h1>\n<h2>pokemon: " + pokemonName + "</h2>");
});

app.listen(port, () => {
	console.log(`Pokedex server has started on port: ${port}`);
});
