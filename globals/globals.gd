extends Node

# Collision masks
const PLAYER_COL: int = 1


# Items
const ITEMS: Dictionary[StringName, ItemDefinition] = {
	&"pistol": preload("res://scenes/items/item_resources/1xx_weapons/00_pistol/pistol.tres"),
	&"shotgun": preload("res://scenes/items/item_resources/1xx_weapons/01_shotgun/shotgun.tres"),
	&"pistol_ammo": preload("res://scenes/items/item_resources/2xx_ammo/00_pistol_ammo/pistol_ammo.tres"),
	&"shotgun_ammo": preload("res://scenes/items/item_resources/2xx_ammo/01_shotgun_ammo/shotgun_ammo.tres"),
	&"g_herb": preload("res://scenes/items/item_resources/3xx_recovery/00_green_herb/green_herb.tres"),
	&"r_herb": preload("res://scenes/items/item_resources/3xx_recovery/01_red_herb/red_herb.tres"),
	&"gr_herb": preload("res://scenes/items/item_resources/3xx_recovery/02_GR_herb/green_red_herb.tres"),
	&"gg_herb": preload("res://scenes/items/item_resources/3xx_recovery/03_GG_herb/green_green_herb.tres"),
	&"blue_tablet_l": preload("res://scenes/items/item_resources/4xx_key_items/01_blue_tablet_left/blue_tablet_left.tres"),
	&"blue_tablet_r": preload("res://scenes/items/item_resources/4xx_key_items/02_blue_tablet_right/blue_tablet_right.tres"),
	&"blue_tablet": preload("res://scenes/items/item_resources/4xx_key_items/03_blue_tablet/blue_tablet.tres"),
	&"spade_key": preload("res://scenes/items/item_resources/4xx_key_items/04_spade_key/spade_key.tres"),
	&"diamond_key": preload("res://scenes/items/item_resources/4xx_key_items/05_diamond_key/diamond_key.tres"),
}
