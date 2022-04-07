/// @description
// SIMPLE INPUT CONTROL SYSTEM
input.xmove = keyboard_check(ord("D")) - keyboard_check(ord("A"));
input.ymove = keyboard_check(ord("S")) - keyboard_check(ord("W"));
input.xview = lengthdir_x(1, point_direction(x, y, mouse_x, mouse_y));
input.yview = lengthdir_y(1, point_direction(x, y, mouse_x, mouse_y));
input.attack = mouse_check_button(mb_left);

// HERE THE UPDATE FUNCTION WILL UPDATE OUR TIMER SYSTEM
timer.update();

if (input.attack == true) {
	// "isOver" WILL BE TURE IF TIMER WITH NAME "attack_cooldown" NOT EXISTS OR REACH 0.
	if (timer.isOver("attack_cooldown")) {
		
		// SIMPLE ATTACK THAT CREATE ANOTHER OBJECT
		var _slash = instance_create_depth(x, y, depth, obj_slash);
		_slash.image_angle = point_direction(0, 0, input.xview, input.yview);
		
		// RESET OUR COOLDOWN TIMER TO 60 FRAMES (1 SECONDS).
		timer.set("attack_cooldown", 60);
		
		// AFTER 15 FRAMES (0.25 SECONDS) THE SLASH INSTANCE WILL BE DESTROYED
		timer.set("slash_destroy", 15, { callback: instance_destroy, callback_param: _slash });
	}	
}

// SIMPLE MOVEMENT SYSTEM
hspd /= 2;
vspd /= 2;
hspd += input.xmove * moveSpd;
vspd += input.ymove * moveSpd;
x += hspd;
y += vspd;
