class_name UserFlags
extends Resource

var last_time : float = 5999999
var best_time : float = 5999999
var play_tutorial_msgs : bool = true

func set_tutorial(value:bool=true) -> void:
	play_tutorial_msgs = value

func submit_time(new_time:float) -> void:
	last_time = new_time
	if new_time < best_time:
		best_time = new_time

func get_best_time_string() -> String:
	return get_string_from_msecs(best_time)

func get_last_time_string() -> String:
	return get_string_from_msecs(last_time)

func get_string_from_msecs(value:int) -> String:
	if value >= 5999999:
		return "99:59:999"
	var total : String
	var msecs = value%1000
	var secs = (value%(60*1000))/1000
	var mins = (value/(60*1000))%100
	total = "%02d:%02d:%03d" % [mins, secs, msecs]
	return total
