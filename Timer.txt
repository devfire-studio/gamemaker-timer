/// @function       Timer(use_delta_time)
/// @argument		use_delta_time true
function Timer(_use_delta_time = true) constructor {
	/*
	* @description  A new timer collection system is created, where each timer
	*				in the collection can function as a countdown or counter
	*				depending on the input values passed as parameters using
	*				the 'set' method and retrieved by the 'get' method. There
	*				are the other auxiliary methods 'isOver' and 'isOut'. This system
	*				uses delta_timer and is in version v0.1.0.
	*/
	timers = [];
	use_delta_time = _use_delta_time;
	_approach = function(_time, _target, _rate) {
		if (use_delta_time) _rate *= (delta_time/1000000)*60;
		if (_time < _target) {
			_time += _rate;
			if (_time > _target) return _target;
		} else {
			_time -= _rate;
			if (_time < _target) return _target;
		}
		return _time;
	};
	/// @function       update()
	/// @description    Will update all timers.
	update = function () {
		for (var i = 0; i < array_length(timers); i++) {
			var _time = timers[i].time;
			var _isOver = timers[i].isOver;
			if (!_isOver) {
				var _rate = timers[i].rate;
				var _target = timers[i].target;
				timers[i].time = _approach(_time, _target, _rate);
				if (timers[i].time == _target) {
					timers[i].isOver = true;
				}
			} else {
				array_delete(timers, i, 1);
				i = max(0, i-1);
			}
		}
	};
	/// @function       set(name, time, {target}, {rate})
	/// @description    The value of 'time' will approach 'target' at the 'rate' every frame using delta_time.
	/// @param			name
	/// @param			initial_time
	/// @param			target_time 0
	/// @param			rate 1
	set = function (_name, _time, _target = 0, _rate = 1) {
		for (var i = 0; i < array_length(timers); i++) {
			if (timers[i].name == _name) {
				timers[i].time = _time;
				timers[i].isOver = false;
				return true;
			}
		}
		array_push(timers, {
			name: _name,
			time: _time,
			target: _target,
			rate: abs(_rate),
			isOver: false,
		});
		return false;
	};
	/// @function       get(name)
	/// @description    Returns the current value of the timer with the provided name.
	/// @param			name
	get = function (_name) {
		if (!is_string(_name)) return -1;
		for (var i = 0; i < array_length(timers); i++) {
			if (timers[i].name == _name) {
				return timers[i].timer;
			}
		}
		return -1;
	};
	/// @function       isOver(name)
	/// @description    Returns true if the timer reached its target value, or otherwise will return false.
	/// @param			name
	isOver = function (_name) {
		for (var i = 0; i < array_length(timers); i++) {
			if (timers[i].name == _name) {
				return timers[i].isOver;
			}
		}
		return true;
	};
	/// @function       isOut(name)
	/// @description    Returns true once when the timer value has reached its target value, or otherwise will return false.
	/// @param			name
	isOut = function (_name) {
		for (var i = 0; i < array_length(timers); i++) {
			if (timers[i].name == _name) {
				return timers[i].isOver;
			}
		}
		return false;
	};
	/// @function       debug()
	/// @description    Returns a struct with the value of the number of active timers and their contents.
	/// @param			show_on_console
	debug = function (_show_on_console = true) {
		var _result = {
			array: timers,
			array_size: array_length(timers)
		}
		if (_show_on_console) {
			show_debug_message(
				"[" + string(other.id) + "]: " + string(_result)
			);
		}
		return _result;
	}
}
