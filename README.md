# GameMaker Studio 2 Timer Project

This repository contains a Timer management system for GameMaker Studio 2, written in GML (GameMaker Language). The system includes two main components: `Time` and `Timer`.

## Time

The `Time` struct represents a unit of time with some properties like duration (in ticks), an optional number of repeats, an optional callback function to execute when the time expires, and an optional use of delta time (default is true).

### Properties

- `ticks`: The duration of the `Time` in ticks.
- `repeats`: The number of times the `Time` should repeat (default is 0, no repeat).
- `dt_enabled`: Whether to use delta time or not to decrement the ticks (default is true).
- `callback`: The callback function to execute when the time expires (default is undefined).
- `default_ticks`: The default ticks to reset the time when repeat (default is the creation ticks).

### Example

```js
var _time = new Time({
  ticks: 1 * 60, // it will run for 1 second
  repeats: 1, // it will resets the Time 1 time and run the callback 2 times.
  dt_enabled: true,
  callback: function () {
    // do something
  },
});
```

## Timer

The `Timer` manages multiple `Time` struct and updates them over time. It provides methods to update, set, and get information about individual times.

### Methods

- `update()`: Updates the all times based on elapsed time (recommended to be called every frame, like step event).
- `set(_key, _time)`: Sets a `Time` struct with a specific key, if the timer already exists, it will replace its properties.
- `get(_key)`: Gets the `Time` struct with the specified key.
- `over(_name, [_ticks_or_time])`: Runs `Time` repeatedly checking if a Time with the specified key has expired, optionally in seconds parameter if pass a number of ticks its create a new `Time` with this ticks or if pass a struct with `Time`'s properties it will create a new `Time` with these properties.

### Usage example

```js
/// Create event
timer = new Timer();

timer.set(
  "test 1",
  new Time({
    ticks: 1 * 60,
    repeats: 1,
    dt_enabled: true,
    callback: function (_key, _time) {
      show_debug_message(_key + ": " + json_stringify(_time));
    },
  })
);

/// Step event
timer.update();

if (timer.over("test 2", 1 * 60)) {
  show_debug_message("test 2: is over");
}

/// Draw GUI event
draw_text(32, 16, "Test 1: " + string(timer.get("test 1")));
draw_text(32, 32, "Test 2: " + string(timer.get("test 2")));
```

## Other use cases

### Character Ability Cooldowns

You can use timers to manage cooldowns for character abilities. For example, if a character has a special ability that can only be used every 30 seconds, you could use a timer to track this cooldown period.

```js
/// Create event
var timer = new Timer();
ability_is_ready = false;
ability_cooldown = 30 * 60; // 1800 ticks = 30 seconds

timer.set(
  "ability_cooldown",
  new Time({
    ticks: ability_cooldown,
    callback: method(self, function (_key, _time) {
      ability_is_ready = true;
      // do something more
    }),
  })
);
```

### State machine

This code demonstrates the use of the `Timer` in a state machine, a common pattern in game development for managing different states of a character or object.

```js
/// Create event
timer = new Timer();

image_speed = 0.5;
state = "idle";

attack_cooldown = 1.5 * 60; // 90 ticks = 1.5 seconds

sprite_idle = spr_idle; // an existing idle sprite
sprite_attacking = spr_attacking; // an existing attacking sprite

/// Step event
timer.update();

switch (state) {
  case "idle":
    if (sprite_index != sprite_idle) {
      sprite_index = sprite_idle;
      image_index = 0;
    }

    var _attack_key_pressed = keyboard_check_pressed("vk_space");
    var _attack_cooldown_over = timer.over("attack_cooldown");
    var _can_attack = _attack_key_pressed && _attack_cooldown_over;

    if (_can_attack) {
      state = "attacking";
    }
    break;

  case "attacking":
    if (sprite_index != sprite_attacking) {
      sprite_index = sprite_attacking;
      image_index = 0;
    }

    if (image_index >= image_number - 1) {
      timer.set("attack_cooldown", attack_cooldown);
      state = "idle";
    }
    break;
}
```

## Contributing

Contributions are welcome!
