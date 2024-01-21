const path = require("path");

/* This function finds the complete server side directory path for the project's local root.
 * This function also works independent of the operating system of the server.
 * This function must be ran from inside the project's local root in order to work
 * @param: None
 * @output: project's absolute local root file path
 */
function getLocalRoot(getFirstSep=true){
	let filePathArr = __dirname.split(path.sep);
	let localRootI = filePathArr.findIndex(x => x == "pokedex");
	if(getFirstSep){
		filePathArr = filePathArr.slice(0, localRootI+1);
	}
	else{
		filePathArr = filePathArr.slice(1, localRootI+1);
	}
	let localRootPath = filePathArr.join(path.sep);
	return localRootPath;
}

/* This function finds the path of the views directory regardless of operating system or
 * current filesystem location as long as the filesystem location is inside the project
 * @param: getFirstSep that when false removes the root file path seperator
 * @output: Absolute path of views directory
 */
function getViewsPath(getFirstSep=true){
	return getLocalRoot(getFirstSep) + path.sep + "views";
}

/* This function finds the path of the style directory regardless of operating system or
 * current filesystem location as long as the filesystem location is inside the project
 * @param: getFirstSep that when false removes the root file path seperator
 * @output: Absolute path of public directory
 */
function getStylePath(getFirstSep=true){
	return getLocalRoot(getFirstSep) + path.sep + "style";
}

module.exports = { getViewsPath, getStylePath };
