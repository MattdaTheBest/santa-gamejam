extends CanvasLayer

@onready var h_box_container: HBoxContainer = $sceneTransition/HBoxContainer
const SHOP_SCENE = preload("res://shop_scene.tscn")

enum fadeType {CENTER_OUT, SIDES_CENTER, CENTER_SIDES, TOP_BOTTOM, DIAMOND, CHECKER}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#fadeOUT()
	pass # Replace with function body.

func get_fade_delay(x: int, y: int, col_count: int, row_count: int, type: int) -> float:
	var center_col = col_count / 2.0
	var center_row = row_count / 2.0

	match type:
		fadeType.CENTER_OUT:
			return sqrt((x - center_col) ** 2 + (y - center_row) ** 2)
		fadeType.SIDES_CENTER:
			var from_left = abs(x - 0)
			var from_right = abs(x - (col_count - 1))
			var dist = min(from_left, from_right)
			return dist
		fadeType.CENTER_SIDES:
			return abs(x - center_col)
		fadeType.TOP_BOTTOM:
			return y
		fadeType.DIAMOND:
			return abs(x - center_col) + abs(y - center_row)
		fadeType.CHECKER:
			return ((x + y) % 2) + ((x + y) / 2.0)
		_:
			return 0.0

func fadeIN(fade_type):
	var cols = h_box_container.get_children()
	var col_count = cols.size()
	var row_count = cols[0].get_child_count() if col_count > 0 else 0

	for x in range(col_count):
		var col = cols[x]
		for y in range(row_count):
			var node = col.get_child(y)
			var delay = get_fade_delay(x, y, col_count, row_count, fade_type)
			node.fadeIn(delay * 0.05)  # You can tweak the multiplier
				
func fadeOUT(fade_type := fadeType.CENTER_OUT):
	var cols = h_box_container.get_children()
	var col_count = cols.size()
	var row_count = cols[0].get_child_count() if col_count > 0 else 0

	for x in range(col_count):
		var col = cols[x]
		for y in range(row_count):
			var node = col.get_child(y)
			var delay = get_fade_delay(x, y, col_count, row_count, fade_type)
			node.fadeOut(delay * 0.05)

func changeSceneUI(newScene):
	fadeIN(randi() % fadeType.size())
	await get_tree().create_timer(1).timeout
	PlayerUi.reset()
	PlayerUi.appearUI()
	await get_tree().create_timer(1).timeout
	#get_tree().call_deferred("change_scene_to_packed", newScene)
	get_tree().change_scene_to_packed(newScene)

func changeSceneNOUI(newScene):
	fadeIN(randi() % fadeType.size())
	await get_tree().create_timer(1).timeout
	PlayerUi.reset()
	PlayerUi.hideUI()
	await get_tree().create_timer(1).timeout
	#get_tree().call_deferred("change_scene_to_packed", newScene)
	get_tree().change_scene_to_packed(newScene)
