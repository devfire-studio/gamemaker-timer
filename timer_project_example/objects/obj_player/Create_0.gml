/// @description 
/*
*	YOU CAN CHANGE THESE VALUES AS YOU LIKE, BUT THESE ARE THE DEFAULTS
*	newDefaultOptions = {
*	    target: 0,
*	    rate: 1,
*	    repeating: 0,
*	    callback: noone,
*	    callback_param: noone,
*	}
*	useDeltaTime = true;
*	timer = new Timer(useDeltaTime, newDefaultOptions );
*/
timer = new Timer(); // THIS WILL BE THE SAME AS THE ABOVE CODE

// WE WILL CREATE A CALLBACK FUNCTION THET SPAWN A "DUST" OBJECT
var _callback = function() {
	instance_create_depth(
		x + random_range(-8, 8),
		y + random_range(-8, 8),
		depth-1,
		obj_particle
	);
}
// THE TIMER WILL EXECUTE THE CALLBACK AND CREATE A "DUST" EACH 5 FRAMES 100 TIMES
timer.set("dust", 5, { repeating: 100, callback: _callback });

// MOVEMENT VARIABLES
moveSpd = 2;
hspd = 0;
vspd = 0;

// INPUT VARIABLES
input = {
	xmove: 0,
	ymove: 0,
	xview: 0,
	yview: 0,
	attack: 0,
}
