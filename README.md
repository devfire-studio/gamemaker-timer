# GameMaker Studio 2 Timer Project

This repository contains a Timer management system for GameMaker Studio 2, written in GML (GameMaker Language). The system includes two main components: `Time` and `Timer`.

## Time

The `Time` object represents a unit of time with properties like name, duration (in ticks), an optional number of repeats, an optional callback function to execute when the time expires, and an optional use of delta time (default is true).

### Example

```js
var _time = new Time({
  name: "Timer",
  ticks: 1 * 60,
  repeats: 2,
  use_dt: true,
  callback: function () {
    // do something
  },
});
```

## Timer

The `Timer` object manages multiple `Time` objects and updates them over time. It provides methods to add, update, and retrieve information about individual timers.

### Methods

- `update()`: Updates the timers based on elapsed time.
- `add(_time)`: Adds a new time object to the timer's internal list.
- `set(_name, _ticks, _callback)`: Sets or updates a timer with a specific name, ticks, and callback.
- `get(_name)`: Gets the remaining ticks for a timer with the specified name.
- `over(_name, _ticks, _callback)`: Checks if a timer with the specified name has expired.

### Example

```js
/// Create event
timer = new Timer();

timer.add(
  new Time({
    name: "test 1",
    ticks: 1 * 60, // 1 second
    repeats: 2,
    use_dt: true,
    callback: function () {
      /// do something from test 1
    },
  })
);

/// Step event
timer.update();

timer.over("test 2", 1 * 60, function () {
  /// do something from test 2
});

if (timer.over("test 3", 1 * 60)) {
  /// do something from test 3
}

/// Draw GUI event
draw_text(32, 16, "Test 1: " + string(timer.get("test 1")));
draw_text(32, 32, "Test 2: " + string(timer.get("test 2")));
draw_text(32, 48, "Test 3: " + string(timer.get("test 3")));
```

## Usage exemples

### Character Ability Cooldowns

You can use timers to manage cooldowns for character abilities. For example, if a character has a special ability that can only be used every 30 seconds, you could use a timer to track this cooldown period.

```js
/// Create event
var timer = new Timer();

timer.set("AbilityCooldown", 30 * 60, function () {
  // code to reactivate the ability
});
```

### State machine

This code demonstrates the use of the timer in a state machine, a common pattern in game development for managing different states of a character or object.

```js
/// Create event
state = "idle";
timer = new Timer();

/// Step event
switch (state) {
  case "idle":
    if (
      keyboard_check_pressed("vk_space") &&
      timer.over("JumpAbilityCooldown")
    ) {
      state = "jump";
    }
    break;
  case "jump":
    // do something
    timer.set("JumpAbilityCooldown", 1.5 * 60);
    break;
}
```

## Contributing

Contributions are welcome!
