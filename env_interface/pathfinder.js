const path = require("path");

/* This function finds the complete server side directory path for the project's local root.
 * This function also works independent of the operating system of the server.
 * This function must be ran from inside the project's local root in order to work
 * @param: [getFirstSep] that when false removes the root file path seperator
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

/*
 * Use this function to get any abs file path inside the project directory. This path must be
 * called with a working directory inside of the file path
 * @input: fileArr is an array with strings to the filePath
 * @output: an abs file path with the fileArr in the path
 * */
function getAbsPath(fileArr){
	absPath = getLocalRoot();
	for(file of fileArr){
		absPath = path.sep + file
	}
	return absPath
}

/* This function finds the path of the views directory regardless of operating system or
 * current filesystem location as long as the filesystem location is inside the project
 * @param: [getFirstSep] that when false removes the root file path seperator, [file name]
 * appended at end of path
 * @output: Absolute path of views directory
 */
function getViewsPath(getFirstSep=true, file=""){
	if(file != ""){
		return getLocalRoot(getFirstSep) + path.sep + "views" + path.sep + file;
	}
	else{
		return getLocalRoot(getFirstSep) + path.sep + "views";
	}
}

/* This function finds the path of the style directory regardless of operating system or
 * current filesystem location as long as the filesystem location is inside the project
 * @param: [getFirstSep] that when false removes the root file path seperator, [file name]
 * appended at end of path
 * @output: Absolute path of public directory
 */
function getStylePath(getFirstSep=true, file=""){
	if(file != ""){
		return getLocalRoot(getFirstSep) + path.sep + "style" + path.sep + file;
	}
	else{
		return getLocalRoot(getFirstSep) + path.sep + "style";
	}
}


/* This function finds the path of the env_interface directory regardless of operating system or
 * current filesystem location as long as the filesystem location is inside the project
 * @param: getFirstSep that when false removes the root file path seperator, [file name]
 * appended at end of path
 * @output: Absolute path of public directory
 */
function getEnvInterfacePath(file=""){
	if(file != ""){
		return getLocalRoot(true) + path.sep + "env_interface" + path.sep + file;
	}
	else{
		return getLocalRoot(true) + path.sep + "env_interface";
	}
}

/* This function finds the path of the postgre_files directory regardless of operating system or
 * current filesystem location as long as the filesystem location is inside the project
 * @param: getFirstSep that when false removes the root file path seperator, [file name / Path]
 * appended at end of path
 * @output: Absolute path of public directory
 */
function getPostgreFilesPath(file=""){
	if(file != ""){
		return getLocalRoot(true) + path.sep + "postgre_files" + path.sep + file;
	}
	else{
		return getLocalRoot(true) + path.sep + "postgre_files";
	}
}


/* This function finds the path of the server_data  directory regardless of operating system or
 * current filesystem location as long as the filesystem location is inside the project
 * @param: getFirstSep that when false removes the root file path seperator, [file name / Path]
 * appended at end of path
 * @output: Absolute path of public directory
 */
function getServerDataPath(file=""){
	if(file != ""){
		return getLocalRoot(true) + path.sep + "server_data" + path.sep + file;
	}
	else{
		return getLocalRoot(true) + path.sep + "server_data";
	}
}

export default getAbsPath;
