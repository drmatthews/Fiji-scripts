getDimensions(w, h, channels, slices, frames);
Stack.getPosition(channel, slice, frame);
print("   Chanels: "+channels);
print("   Slices: "+slices);
print("   Frames: "+frames);

// get total number of planes
imageCount = channels*slices*frames;
print(imageCount);

// do the rest without the images visisble - batch mode
setBatchMode(true);

// get image title
raw = getTitle();
print(raw);
// extract name and file extension for renaming later
name = substring(raw,0,lengthOf(raw)-4);
ext = substring(raw,lengthOf(name),lengthOf(raw));
print(name);
print(ext);

// start of looping
for (c = 0; c < channels; c++) {
	for (z = 0; z < slices; z++) {
		for (t = 0; t < frames; t++) { 
			// initialise x 
			x = -512; 
			// if we have multidimensional data we need to select the plane 
			if (imageCount > 1) {
				Stack.setPosition(c,z,t);
			}
			
			// loop over columns - phases
			p = 0;
			for (i = 0; i < 5; i++) {
				x = x + 512;
				y = -512;
				// loop over rows - rotations
				for (j = 0; j < 3; j++) {
					y = y + 512;
					print(x,y);
					// grab the main window
					selectWindow(raw);
					// make a rectangle ROI
					makeRectangle(x, y, 512, 512);
					// duplicate the region
					p += 1;
					run("Duplicate...", "duplicate");
					rename("image-"+p);
				}
			}
			// now concatenate one by one
			selectImage("image-1");
			rename("image-0");
			for (image = 1; image < 15; image++) { 
				run("Concatenate...", "stack1=image-" + (image - 1) + " stack2=image-" + (image + 1) + " title=image-" + image); 
				}
			
			// sum all the slices 
			run("Z Project...", "projection=[Sum Slices]");
			
			// put the projection into the hyperstack 
			} 
		} 
	} 
	// select the main window again 
	selectWindow(raw); 
	// close it 
	close(); 
	// if we have multi-dimensional data concantentate it 
	if (imageCount > 1) {
}
	for (i = 0; i < imageCount; i++) {
		// concatenate all the images into a stack
		run("Concatenate...", "all_open title=Concatenated");	
	}
	// set the correct dimensions
	Stack.setDimensions(channels, slices, frames);
}

rename(name+"_widefield");
setBatchMode(false);