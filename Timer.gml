/// @func   Time(input)
/// @param  {Struct.Time}   _input
/// @description
/// Constructor function for a Time object. This object represents a unit
/// of time, a duration in ticks, an optional number of repeats,
/// an optional callback function to execute when the time expires,
/// an optional use of delta time (default is true), and an optional
/// initial ticks used to reset the time when repeat (default is creation ticks).
function Time(_input) constructor {
  ticks           = _input[$ "ticks"]           ?? -1
  repeats         = _input[$ "repeats"]         ?? 0
  callback        = _input[$ "callback"]        ?? undefined
  dt_enabled      = _input[$ "dt_enabled"]      ?? true
  default_ticks   = _input[$ "default_ticks"]   ?? _input[$ "ticks"]
}

/// @func   Timer(timers)
/// @param  {Struct.Time}   _timers
/// @description
/// Constructor function for a Timer object. This object manages multiple Time
/// objects and updates them over time. It provides methods to add, update,
/// and retrieve information about individual timers.
function Timer(_timers = {}) constructor {
  timers = _timers
  
  /// @func   update()
  /// @return {Struct.Timer}
  /// @description
  /// Updates the timers based on elapsed time. This method decrements the
  /// tick count for each active timer. If a timer reaches zero ticks, it
  /// executes its associated callback function (if provided) and manages
  /// repetitions accordingly.
  update = function() {
    var _keys = struct_get_names(timers)
    for (var i = 0; i < array_length(_keys); i++) {
      var _key = _keys[i]
      var _time = timers[$ _key]
      if (_time.ticks == -1) {
        struct_remove(timers, _key)
        _keys = struct_get_names(timers)
        i--
        continue
      }
      _time.ticks -= _time.dt_enabled ? (delta_time/1000000) * 60 : 1
      if (_time.ticks <= 0) {
        _time.ticks = 0
        if (is_method(_time.callback)) {
          _time.callback(_time, i)
        }
        if (_time.repeats > 0) {
          _time.repeats -= 1
          _time.ticks = _time.default_ticks
          continue
        }
        _time.ticks = -1
      }
    }
    return self
  }
  
  /// @func   set(_key, _timer)
  /// @param  {String}            _key
  /// @param  {Struct.Time}       _time
  /// @return {Struct.Timer}
  /// @description
  /// Sets a timer with a specific key. If a timer with the same key
  /// already exists, it will be replaced with the new time.
  set = function(_key, _time) {
    timers[$ string(_key)] = new Time(_time)
    return self
  }
  
  /// @func   get(_key, _timer)
  /// @param  {String}            _key
  /// @return {Struct.Time}
  /// @description
  /// Gets the time object with the specified key. If no timer is
  /// found, it returns undefined.
  get = function(_key) {
    return timers[$ string(_key)]
  }
  
  /// @func   over(_key, _timer)
  /// @param  {String}               _key
  /// @param  {Real | Struct.Time}   _ticks_or_time
  /// @return {Bool}
  /// @description
  /// Checks if a time with the specified key has expired. If the time has expired, this
  /// method optionally resets its tick count and executes a callback function. If the timer
  /// doesn't exist, it creates a new one with the provided name and ticks.
  over = function(_key, _ticks_or_time = undefined) {
    var _time = get(_key)
    if (_time) {
      return bool(_time.ticks <= 0)
    }
    if (_ticks_or_time != undefined) {
      set(_key, is_numeric(_ticks_or_time) ? { ticks: _ticks_or_time } : _ticks_or_time)
    }
    return false
  }
}
