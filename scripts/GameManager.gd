extends Node

var current_day = 2
var day2_task_done = false
var day3_task_done = false
var ready_to_go_home = false
var washed_face = false
var spawn_location = ""
var day3_zombies_killed = 0
var day3_mission_goal = 5
var day3_mission_complete = false
var correct_task = 0
var is_interacting = false

func is_task_finished():
	if current_day == 2:
		return day2_task_done
	elif current_day == 3:
		return day3_task_done
	return true

func reset_game():
	current_day = 2
	washed_face = false
	day2_task_done = false
	day3_task_done = false
	spawn_location = ""
	
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
