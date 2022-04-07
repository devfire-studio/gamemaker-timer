# DESCRIPTION
This is a small GameMaker Studio system to control time counting in an easy and practical way, its intention is to be simple and to attend the most basic needs in counter control.
# HOW TO USE:
1 - Drop the `Timer.gml` file into your project, or copy its contents into any script in your project.
<br>
2 - Use the examples below to understand how to use:
# QUICK START
Let's create a cooldown system for our `obj_player` object's attack:


1 - In this example we will create an object called `obj_player` (put whatever name you want or use an existing object) and within CREATE EVENT we will instantiate our Timer class (`new Timer()`). We'll use the default values, so you don't need to pass anything as a parameter when you start the class:
### CREATE EVENT
```gml
timer = new Timer();
```
 2 - Now in the STEP EVENT, right at the beginning let's use the function inside our timer called `update()`, it will be responsible for doing all the hard work of updating the system for us:
### STEP EVENT
```gml
timer.update()
```
3 - From here on STEP EVENT in the timers are already updated, so we can continue.
- First we should check if the timer value named `attack_cooldown` has already been completed or if it doesn't exist, so the `obj_player` can make the attack, otherwise it will have to wait for the timer to finish. the attack input will be the left mouse button `mb_left`.

If the timer doesn't exist yet, don't worry, because we haven't told you the name or value of the timer we want to use, our player will be able to start attacking:
```gml
if (mouse_check(mb_left)) {
    /// CHECK IF TIMER IS OVER
    if (timer.isOver("attack_cooldown")) {
        // YOUR ATTACK CODE HERE
        show_message("Attack done!");
        // NOW LET'S RESET OUR TIMER TO 120 FRAMES OR THE SAME AS 2 SECONDS
        timer.set("Attack done!", 120);
    }
}
```
4 - The attack cooldown system is done!

# MORE FEATURES
### new Time()
- useDeltaTime: true or false - Use or not delta_time
- defaultOption: struct - Change default option values of created timers
  - target: The target value the timer should reach
  - rate: Number of frames used to reach the target value
  - repeating: Number of cycles that must be repeated
  - callback: Accept a function to be executed at the end of each cycle

```gml
// YOU CAN CHANGE THESE VALUES AS YOU LIKE, BUT THESE ARE THE DEFAULTS
newDefaultOptions = {
    target: 0,
    rate: 1,
    repeating: 0,
    callback: noone,
    callback_param: noone,
}
useDeltaTime = true;
timer = new Timer(useDeltaTime, newDefaultOptions );
```

### UPDATE
Required to have in any "step" event, this will update all timers, clear unnecessary timers automatically and execute the callback if exists.
```gml
timer.update();
```

### SET
Shortened mode will work like a countdown, from 30 to 0.
```gml
timer.set("delay", 120); // 2 seconds
```
If you want to use more options you must pass a struct as third parameter. This struct should contain one or more `defaultOptions` items to be the new timer options that will be created as the `set` function.

This timer will work like a counter, from 0 to 120 and repeate 2 times:
```gml
options = {
    target: 120,
    rate: 1,
    repeating: 2,
    callback: noone,
    callback_param: noone,
}
time.set("delay", 0, options);  // 2 seconds
```
Or you can just default to the values you don't want to use:
```gml
time.set("delay", 0, { target: 120, repeating: 2 }); // 2 seconds
```
### GET
Returns the value of the timer with the name passed as parameter.
```gml
timer.get("delay");	
```
### isOver
Returns true if the timer value is over, otherwise returns false.
```gml
timer.isOver("delay");
```
### isOut
Returns true only once if the timer value is up, otherwise returns false.
```gml
timer.isOut("delay");
```
### debug
Returns the number of active timers, their contents, and set to true or false to display the return automatically on the console
```gml
timer.debug([showOnConsole]);
```
# Future features
- Other ?

# Bugs and suggestions
Feel free to create an issue.

Use as you wish!
