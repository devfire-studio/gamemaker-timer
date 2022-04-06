# DESCRIPTION
This is a small GameMaker Studio system to control time counting in an easy and practical way, its intention is to be simple and to attend the most basic needs in counter control.

# HOW TO USE:
1 - Drop the `Timer.gml` file into your project, or copy its contents into any script in your project.
<br>
2 - Use the examples below to understand how to use:

## EXAMPLE OF THE EASIEST WAY
### CREATE EVENT
```
timer = new Timer();
```
### STEP EVENT
```
timer.update();

if (timer.isOver("attack_cooldown")) {
    // Your attack code here
    timer.set("attack_cooldown", 120);
}
```

## OTHER WAYS
### CREATE EVENT
Creates a new instance of the Timer class, passing as only parameter whether to use delta_time (true) or not (false), by default the value is true.
```
timer = new Timer();
```

New timer with delta_time
```
timer = new Timer(true);
```
New timer without delta_time
```
timer = new Timer(false);
```

### ANY STEP EVENT
Required to have in any "step" event, this will update all timers and clear unnecessary timers automatically.
```
timer.update();
```

### ANY EVENT
Will set 30 to 0 decreasing 1 per frame, thus being a "countdown".
```
timer.set("delay", 30, 0, 1);
```
Shortened mode for "countdown".
```
timer.set("delay", 30);
```
Will add 0 to 30 by adding 1 per frame, thus being a counter.
```
timer.set("delay", 0, 30, 1);
```
Shortened form for "counter".
```
timer.set("delay", 0, 30);
```
Countdown mode decreasing by 2 per frame.
```
timer.set("delay", 60, 0, 2)
```
Returns the value of the timer with the name passed as parameter.
```
timer.get("delay");	
```
Returns true if the timer value is over, otherwise returns false.
```
timer.isOver("delay");
```
Returns true only once if the timer value is up, otherwise returns false.
```
timer.isOut("delay");
```
Returns the number of active timers, their contents, and set to true or false to display the return automatically on the console
```
timer.debug(show_on_console);
```
# Future features
- Add callback option to execute when timer runs out.
- Add option to repeat timer, being -1 infinitely, 0 or 1 execute once and N execute N times.
- Other ?

# Bugs and suggestions
Feel free to create an issue.
