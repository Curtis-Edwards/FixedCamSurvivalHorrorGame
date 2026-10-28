# game_manager.gd
extends Node

var main_scene: MainScene

var game_world: GameWorld

var ui: GameUI

var player: Player

var inventory: InventorySystem = preload("res://data/inventory/player_inventory.tres")
var item_box: InventorySystem = preload("res://data/inventory/player_item_box.tres")

var interaction_prompt: InteractionPrompt

func _ready() -> void:
	inventory.initialize()
	item_box.initialize()
	
	inventory.add_item(Globals.ITEMS["pistol"], 1)
	inventory.add_item(Globals.ITEMS["pistol_ammo"], 10)
	
	item_box.add_item(Globals.ITEMS["shotgun"], 1)
	item_box.add_item(Globals.ITEMS["shotgun_ammo"], 4)
	item_box.add_item(Globals.ITEMS["g_herb"], 1)
	
