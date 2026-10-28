extends Node

# Collision masks
const PLAYER_COLLISION_LAYER: int = 1
const PLAYER_PROJECTILE_COLLISION_LAYER: int = 2
const ENEMY_COLLISION_LAYER: int = 3
const ENEMY_PROJECTILE_COLLISION_LAYER: int = 4
const STATIC_ENVIROMENT_COLLISION_LAYER: int = 5
const NON_STATIC_ENVIROMENT_COLLISION_LAYER: int = 6

const INTERACTABLE_COLLISION_LAYER: int = 9
const CAM_TRIGGER_AREA_COLLISION_LAYER: int = 10


const EMPTY_SLOT_TEXTURE: AtlasTexture = preload("res://assets/textures/empty.tres") 

# Items
const ITEMS: Dictionary[StringName, ItemDefinition] = {
	&"pistol": preload("res://data/items/1xx_weapons/00_pistol/pistol.tres"),
	&"shotgun": preload("res://data/items/1xx_weapons/01_shotgun/shotgun.tres"),
	&"pistol_ammo": preload("res://data/items/2xx_ammo/00_pistol_ammo/pistol_ammo.tres"),
	&"shotgun_ammo": preload("res://data/items/2xx_ammo/01_shotgun_ammo/shotgun_ammo.tres"),
	&"g_herb": preload("res://data/items/3xx_recovery/00_green_herb/green_herb.tres"),
	&"r_herb": preload("res://data/items/3xx_recovery/01_red_herb/red_herb.tres"),
	&"gr_herb": preload("res://data/items/3xx_recovery/02_GR_herb/green_red_herb.tres"),
	#&"gg_herb": preload(),
	#&"blue_tablet_l": preload("res://scenes/items/item_resources/4xx_key_items/01_blue_tablet_left/blue_tablet_left.tres"),
	#&"blue_tablet_r": preload("res://scenes/items/item_resources/4xx_key_items/02_blue_tablet_right/blue_tablet_right.tres"),
	#&"blue_tablet": preload("res://scenes/items/item_resources/4xx_key_items/03_blue_tablet/blue_tablet.tres"),
	#&"spade_key": preload("res://scenes/items/item_resources/4xx_key_items/04_spade_key/spade_key.tres"),
	#&"diamond_key": preload("res://scenes/items/item_resources/4xx_key_items/05_diamond_key/diamond_key.tres")
}

#var ROOMS: Dictionary[StringName, PackedScene] = {
	#&"room_a": load("res://scenes/rooms/test_layout_05/tl_05_room_a.tscn"),
	#&"room_b": load("res://scenes/rooms/test_layout_05/tl_05_room_b.tscn")
#}
