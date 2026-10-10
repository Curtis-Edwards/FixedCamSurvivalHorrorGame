# game_manager.gd
extends Node

var dev_panel: DevPanel

var main_scene: MainScene

var game_world: GameWorld

var ui: UI

var player: Player

var inventory: InventorySystem = preload("res://scenes/ui/inventory/inv_inventory.tres")
var item_box: InventorySystem = preload("res://scenes/ui/inventory/inv_item_box.tres")

var interaction_prompt: InteractionPrompt

func _ready() -> void:
	inventory.initialize()
	item_box.initialize()
	
	inventory.add_item(Globals.ITEMS["pistol"], 1)
	inventory.add_item(Globals.ITEMS["pistol_ammo"], 10)
	
	item_box.add_item(Globals.ITEMS["shotgun"], 1)
	item_box.add_item(Globals.ITEMS["shotgun_ammo"], 4)
	item_box.add_item(Globals.ITEMS["g_herb"], 1)
	
