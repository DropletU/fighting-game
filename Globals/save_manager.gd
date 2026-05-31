extends Node

## The path to the save index file.
const SAVEDATA:="res://Text Files/Save Files/save_data.cfg"
## The current config file holding all the current saves information.
var current_file = ConfigFile.new()
## An index config file that holds the last used save file, as well as a list of 
## all save files.
var save_index = ConfigFile.new()

func _ready() -> void:
	if not FileAccess.file_exists(SAVEDATA):
		save_index.save(SAVEDATA)
	save_index.load(SAVEDATA)
	

## Clears the [member current_file] and adds metadata for the new file to it.
## It then saves [member current_file] into the new file, and adds it to the 
## [member save_index].
## If a slot with the same name already exists, an error will be pushed and nothing
## will happen.
func add_new_save(slot_name: String, difficulty: String):
	if save_index.has_section("slots"):
		if slot_name in save_index.get_section_keys("slots"):
			push_error("File with name "+slot_name+" already exists.")
			return
	if not slot_name:
		push_error("No slot name was given.")
		return
	if slot_name.length()>32:
		push_error("Name is too long.")
		return
	var path = _get_path_with_name(slot_name)
	current_file.clear()
	add_data("meta", "name", slot_name)
	add_data("meta", "date_added", Time.get_datetime_dict_from_system())
	add_data("meta", "last_saved", Time.get_datetime_dict_from_system())
	add_data("meta", "completion", 0.0)
	add_data("meta", "difficulty", difficulty)
	save_index.set_value("slots", slot_name, path)
	save_to_disk(path)
	

## Adds data to the save dictionary the player is currently using. [br]
## If you wish to save the dictionary to disk, call [method save_to_disk] after this. [br]
## Note that you cannot set [member value] to [code]null[/code] as it will delete the key
## value pair instead. If you wish to delete it, refer to [method delete_data]
func add_data(section: String, key: String, value):
	if value==null:
		push_error("Value given was null. If you wish to delete this value, call delete_data() instead.")
		return
	current_file.set_value(section, key, value)
	

## Gets data from the [member current_file] directly. [br]
## You are recommended to give a [member default] value to avoid errors.
func get_data(section: String, key: String, default = null):
	if not current_file.has_section_key(section, key) and default==null:
		push_warning("Member current_file does not have section "+section+" or key "+key+" and no default was given.")
	return current_file.get_value(section, key, default)
	

## Removes data from the save dictionary the player is currently using. [br]
## If you wish to save the dictionary to disk, call [method save_to_disk] after this. [br][br]
## Note that the [member section] may be deleted if you are deleting the last
## key value pair inside it.
func delete_data(section: String, key: String):
	if not current_file.has_section_key(section, key):
		push_warning("Member current_file does not have section "+section+" or key "+key+".")
	current_file.set_value(section, key, null)
	

## Saves the contents of [member current_file] into the current save file. [br]
## If [member use_last] is set to false and no valid path is given, an error will
## be pushed and the game will not save.
func save_to_disk(save_path:="", use_last:=true):
	if save_path=="" or not FileAccess.file_exists(save_path):
		if use_last:
			save_path=save_index.get_value("meta", "last_used", save_path)
		else:
			push_error("No valid path was given and was instructed to not use the last path.")
			return
	current_file.set_value("meta", "last_saved", Time.get_datetime_dict_from_system())
	current_file.save(save_path)
	

## Loads the data from the save file based on the [member save_name] given into
## [member current_file]. [br]
## Note that this does not return the save file, if you wish to access it, refer
## to [member current_file].
func load_from_disk(save_name: String):
	var path = save_index.get_value("slots", save_name)
	if not FileAccess.file_exists(path):
		push_error("Cannot load file "+path+" as it does not exist.")
		return
	current_file.load(path)
	save_index.set_value("meta", "last_used", save_name)
	

## Clears [member current_file]. [br]
## WARNING: This does not save the game. If you wish to save before clearing, call
## [method save_to_disk] first.
func clear_data():
	current_file.clear()
	

## Returns whether [member current_file] has the section key pair given.
func has_data(section: String, key: String):
	return current_file.has_section_key(section, key)
	

## Returns whether the save file exists or not based off of [member file_name].
func save_file_exists(file_name: String):
	var path = _get_path_with_name(file_name)
	if not FileAccess.file_exists(path):
		return false
	return true
	

func _get_path_with_name(file_name: String):
	var initial_path: = "res://Text Files/Save Files/"
	return initial_path+file_name+".cfg"
	
