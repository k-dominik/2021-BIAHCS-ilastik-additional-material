/* little helper macro to stack two ilastik prediction images into a single h5 file
 *
 * written for the ilastik module
 * BIAHCS course 2021
 * some function definitions first
 * 
 */

function loadAndStack(cytoPrediction, nucleusPrediction) { 
	// loads the two images for cyto and nucleus prediction
	// both images are expected to have 2 channels
	// resulting image is named "merged"
	run("Import HDF5", "select=[" + cytoPrediction + "] datasetname=/exported_data axisorder=yxc");
	run("Stack to Images");
	selectWindow("1");
	rename("c1");
	selectWindow("2");
	rename("c2");

	run("Import HDF5", "select=[" + nucleusPrediction + "] datasetname=/exported_data axisorder=yxc");
	run("Stack to Images");
	selectWindow("1");
	rename("c3");
	selectWindow("2");
	rename("c4");
	run("Merge Channels...", "c1=c1 c2=c2 c3=c3 c4=c4 create");
	rename("merged");
}

inFolder = getDirectory("Choose the folder with cytoplasm and nucleus prediction images.");
filelist = getFileList(inFolder)

for (i = 0; i < lengthOf(filelist); i++) {
	inFile = filelist[i];
    if (endsWith(inFile, ".h5")) {
    	if (indexOf(inFile, "Cy5)_Probabilities") >= 0){
    		dapiFile = replace(inFile, "Cy5", "DAPI");
    		print("stacking " + inFile + " and " + dapiFile);
    		loadAndStack(inFolder + inFile, inFolder + dapiFile);

    		outFile = replace(inFile, "Cy5 - Cy5", "merged");
    		run("Export HDF5", "select=[" + inFolder + outFile +"] exportpath=[" + inFolder + outFile +"] datasetname=data compressionlevel=0 input=merged");
    		close("*");
    	}
    }
}

print("Done processing");
