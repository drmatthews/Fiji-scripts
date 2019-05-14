setBatchMode(true);
raw = getTitle();
print(raw);
x = -512
for (i = 0; i < 5; i++) {
	x = x + 512;
	y = -512;
	for (j = 0; j < 3; j++) {
		y = y + 512;
		print(x,y);
		selectWindow(raw);
		makeRectangle(x, y, 512, 512);
		run("Duplicate...", "duplicate");
	}
}
selectWindow(raw);
close();

run("Concatenate...", "all_open title=[Concatenated Stacks]");
run("Z Project...", "projection=[Sum Slices]");
setBatchMode(false);