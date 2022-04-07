/// @function       Timer(useDeltaTime, defaultOption)
/// @argument		[useDeltaTime]
/// @argument		[defaultOptions]:{[target],[rate],[repeating],[callback],[callback_param]}
function Timer(_useDdeltaTime = true, _defaultOptions = {}) constructor {
	/*
	*	@description A new timer collection system is created,
	*	where each timer in the collection can function as a countdown
	*	or counter depending on the input values passed as parameters
	*	using the 'set' method and retrieved by the 'get' method. There
	*	are the other auxiliary methods 'isOver' and 'isOut'. This
	*	system can uses delta_timer and it is in version V0.3.0.
	*/
	// Toggle use or not delta_time
	useDeltaTime = _useDdeltaTime;
	// Store all timers
	timers = [];
	/// @function       _structCopy(struct)
	/// @description    Return a copy of a struct.
	_structCopy = function(_struct) {
		var _struct2 = {};
		_structMerge(_struct2, _struct);
		return _struct2;
	}
	/// @function       _structMerge(struct1, struct2)
	/// @description    Put the values of the struct2 into struct1
	_structMerge = function(_struct1, _struct2) {
		var _keys2 = variable_struct_get_names(_struct2);
		for (var i = 0; i < array_length(_keys2); i++) {
			var _key = _keys2[i];
			_struct1[$_key] = _struct2[$_key];
		}
		return _struct1;
	};
	/// @function       _approach(a, b, amount, useDeltaTime)
	/// @description    Approach a value with b value by amount value and can use delta_time.
	_approach = function(_a, _b, _amount, _useDeltaTime = useDeltaTime) {
		if (_useDeltaTime) _amount *= (delta_time/1000000)*60;
		if (_a < _b) {
			_a += _amount;
			if (_a > _b) return _b;
		} else {
			_a -= _amount;
			if (_a < _b) return _b;
		}
		return _a;
	};
	// When instantiated the class can receive new default options, receiving the new options are
	// mergeable with the old ones. The default options are used when creating a new timer in the "set" method.
	defaultOptions = _structMerge({ target: 0, rate: 1, repeating: 0, callback: noone, callback_param: noone }, _defaultOptions);
	/// @function       update()
	/// @description    Will update, run callbacks, count repeatable timers and clear useless times.
	update = function () {
		for (var i = 0; i < array_length(timers); i++) {
			if (!timers[i].isOver) {
				var _rate = timers[i].rate;
				var _target = timers[i].target;
				timers[i].time = _approach(timers[i].time, _target, _rate);
				if (timers[i].time == _target) {
					timers[i].isOver = true;
					timers[i].repeating -= 1;
					if (timers[i].callback != noone) {
						var _cbParam = timers[i].callback_param;
						if (_cbParam != noone) {
							timers[i].callback(_cbParam);
						} else {
							timers[i].callback();
						}
					}
				}
			} else if (timers[i].repeating > 0) {
				timers[i].time = timers[i].inititalTime;
				timers[i].isOver = false;
			} else {
				array_delete(timers, i, 1);
				i = max(0, i-1);
			}
		}
	};
	/// @function       set(name, time, options)
	/// @description    The value of 'time' will approach to 'target' by 'rate' every frame and execute the callback function if its exists.
	/// @param			name
	/// @param			time
	/// @param			[options]:{[target],[rate],[repeating],[callback],[callback_param]}
	set = function (_name, _time, _options = {}) {
		_options = _structMerge(_structCopy(defaultOptions), _options);
		for (var i = 0; i < array_length(timers); i++) {
			if (timers[i].name == _name) {
				timers[i].time = _time;
				timers[i].isOver = false;
				if (is_struct(_options)) {
					timers[i] = _structMerge(timers[i], _options);
				}
				return true;
			}
		}
		var _newTime = _structMerge({
			name: _name,
			time: _time,
			isOver: false,
			inititalTime: _time,
		}, _options);
		array_push(timers, _newTime);
		return _newTime;
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
	/// @param			showOnConsole
	debug = function (_showOnConsole = true) {
		var _result = {
			array: timers,
			array_size: array_length(timers)
		}
		if (_showOnConsole) {
			show_debug_message(
				"[" + string(other.id) + "]: " + string(_result)
			);
		}
		return _result;
	}
}