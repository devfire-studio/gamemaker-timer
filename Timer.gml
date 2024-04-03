/**
 * @func   Time(input)
 * @param  {Struct}      								_input Input structure containing properties for the time object.
 * @description
 *   Constructor function for a Time object. This object represents a unit
 *   of time with a name, a duration in ticks, an optional number of repeats,
 *   an optional callback function to execute when the time expires, and
 *   an optional use of delta time (default is true).
 */
function Time(_input = {}) constructor {
  name        = string(_input[$ "name"])
  ticks       = _input[$ "ticks"]
  repeats     = _input[$ "repeats"]     ?? 0
  callback    = _input[$ "callback"]    ?? undefined
  use_dt      = _input[$ "use_dt"]      ?? true
  init_ticks  = self.ticks
}

/**
 * @func   Timer(timers)
 * @param  {Array<Struct.Time>}      		_timers
 * @description
 *   Constructor function for a Timer object. This object manages multiple Time
 *   objects and updates them over time. It provides methods to add, update,
 *   and retrieve information about individual timers.
*/
function Timer(_timers = []) constructor {
  timers      = _timers
  
  /**
  * @func update()
  * @return {Struct.Timer}
  * @description
  *   Updates the timers based on elapsed time. This method decrements the
  *   tick count for each active timer. If a timer reaches zero ticks, it
  *   executes its associated callback function (if provided) and manages
  *   repetitions accordingly.
  */
  update = function() {
    for (var i = 0; i < array_length(timers); i++) {
      if (timers[i].ticks == -1) {
        array_delete(timers, i, 1)
        i = max(0, i-1)
        continue
      }
      timers[i].ticks -= !!timers[i].use_dt ? (delta_time/1000000) * 60 : 1 // decease 1 second
      if (timers[i].ticks <= 0) {
        if (is_method(timers[i][$ "callback"])) {
          timers[i].callback(timers[i], i)
        }
        if (timers[i].repeats-1 > 0) {
          timers[i].repeats--
          timers[i].ticks = timers[i].init_ticks
          continue
        }
        timers[i].ticks = -1
      }
    }
    return self
  }
  
  /**
  * @func   add(Time)
  * @param  {Struct.Time}     					_time
  * @return {Struct.Timer}
  * @description
  *   Adds a new time object to the timer's internal list. If a time object
  *   with the same name already exists, it will be replaced.
  */
  add = function(_time) {
    _time = new Time(_time)
    for (var i = 0; i < array_length(timers); i++) {
      if (timers[i].name == _time.name) {
        timers[i] = _time
        return self
      }
    }
    array_push(timers, _time)
    return self
  }
  
  /**
  * @func   set(name, ticks, callback)
  * @param  {String | Id.Instance}      _name
  * @param  {Real}          						_ticks
  * @param  {Function}      						_callback
  * @return {Struct.Timer}
  * @description
  *   Sets or updates a timer with a specific name, ticks, and callback.
  *   This method creates or updates a timer with the provided name,
  *   duration, and callback function. If a timer with the same name
  *   already exists, it will be updated with the new values.
  */
  set = function(_name, _ticks, _callback = undefined) {
    add({
      name      : string(_name),
      ticks     : _ticks,
      callback  : _callback,
    })
    return self
  }
  
  /**
  * @func   get(name)
  * @param  {String | Id.Instance}      _name
  * @description
  *   Gets the remaining ticks for a timer with the specified name.
  *   If no timer is found with the provided name, it returns -1.
  */
  get = function(_name) {
    _name = string(_name)
    for (var i = 0; i < array_length(timers); i++) {
      if (timers[i][$ "name"] == _name) {
        return timers[i][$ "ticks"]
      }
    }
    return -1
  }
  
  /**
  * @func   over(name, ticks, callback)
  * @param  {String | Id.Instance}      _name
  * @param  {Real}                      _ticks
  * @param  {Function}                  _callback
  * @return {Bool}
  * @description
  *   Checks if a timer with the specified name has expired. If the timer has expired, this
  *   method optionally resets its tick count and executes a callback function. If the timer
  *   doesn't exist, it creates a new one with the provided name and ticks.
  */
  over = function(_name, _ticks = undefined, _callback = undefined) {
    _name = string(_name)
    for (var i = 0; i < array_length(timers); i++) {
      if (timers[i].name == _name) {
        if (timers[i].ticks <= 0) {
          if (is_method(_callback)) {
            _callback(timers[i], i)
          }
          if (is_numeric(_ticks)) {
            timers[i].ticks = _ticks
          }
          return true
        }
        return false
      }
    }
    if (is_numeric(_ticks)) {
      set(_name, _ticks)
    }
    return true
  }
}
