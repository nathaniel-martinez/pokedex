const path = require("path");
const pathFinder = require("." + path.sep+ "env_interface" + path.sep + "pathfinder");
const express = require("express");
const app = express();
const port = 3000;
//const port = readPort(); write readPort function to read port from configuration file

//Add public styling files
//app.use("/public", express.static(pathFinder.getStylePath()));
//app.use("/public", express.static(pathFinder.getPublicPath()));

app.get("/", (req, res) => {
	res.redirect("trainers");
});

//selectable list of trainers
app.get("/trainers", (req, res) => {
	let selectorPath = pathFinder.getViewsPath(true, "selector.ejs");

	res.set('Content-Type', 'text/html');
	res.sendFile(selectorPath);
});

//link css file to trainers selector
app.get("/trainers/style.css", (req, res) => {
	let selectorStylePath = pathFinder.getStylePath(true, "selector.css");

	res.set('content-type', 'text/css');
	res.sendFile(selectorStylePath);
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

/*
app.get("/:trainerName/:pokemonName", (req, res) => {
	let trainerName = req.params.trainerName;
	let pokemonName = req.params.pokemonName;
	//res.send(pokeRender(trainerName, pokeName)) Polymorphic html generator that gets
	//different info based on trainerName and pokemonName passed to it
	//go back button to trainer
	res.send("<h1>trainer: " + trainerName + "</h1>\n<h2>pokemon: " + pokemonName + "</h2>");
});
*/

app.listen(port, () => {
	console.log(`Pokedex server has started on port: ${port}`);
});
