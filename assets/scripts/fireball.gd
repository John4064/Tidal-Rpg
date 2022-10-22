extends Area2D

var tilemap
var speed = 80
var direction : Vector2
var attack_damage

func _ready():
	tilemap = get_tree().root.get_node("Root/TileMap")
	
func _process(delta):
	position = position + speed * delta * direction
