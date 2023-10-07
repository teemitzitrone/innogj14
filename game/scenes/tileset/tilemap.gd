extends TileMap

# Layer IDs
var ground_layer = 0
var object_layer = 1
var effects_layer = 2

# tiles ids
var grass = 1
var crystal_terrain = 8
var bushes = 13
var bushes_snall = 14
var trees = 15

var neighbours = [
        Vector2.UP,
        Vector2.UP + Vector2.LEFT,
        Vector2.LEFT,
        Vector2.LEFT + Vector2.DOWN,
        Vector2.DOWN,
        Vector2.DOWN + Vector2.RIGHT,
        Vector2.RIGHT,
        Vector2.RIGHT + Vector2.UP
]

# Custom Datas
var is_breakable = "breakable"

var player : Node2D

func _ready():
    get_tree().get_current_scene().child_entered_tree.connect(_on_child_entered_tree)
    _complete_map()

func _unhandled_input(_event):
    if player && Input.is_action_just_pressed('action'):
        var action_map_position = local_to_map(player.global_position)
        _break_nearest_crystal(action_map_position)

func _break_nearest_crystal(pos: Vector2):
    for neighbour in neighbours:
        var position_to_check = pos + neighbour
        var tile_data : TileData = get_cell_tile_data(object_layer, position_to_check)
        if tile_data && tile_data.get_custom_data(is_breakable):
            set_cell(object_layer, position_to_check, -1)
            set_cell(effects_layer, position_to_check, -1)
            G.crystal_broken.emit()
            break

func _complete_map():
    var tiles = get_used_cells(ground_layer)
    _scatter_objects(tiles)
    _add_collision_border(tiles)

func _scatter_objects(tiles: Array):
    var objects = [crystal_terrain, bushes, bushes_snall, trees]
    var object_count = tiles.size() / 4 # 25% of map are poulated
    for i in object_count:
        var source_id = objects[randi() % objects.size()]
        var coords = tiles[randi() % tiles.size()]
        set_cell(object_layer, coords, source_id, Vector2.ZERO)
        if source_id == crystal_terrain:
            set_cell(effects_layer, coords, source_id, Vector2.DOWN)

func _add_collision_border(tiles):
    for tile in tiles:
        for neighbour in neighbours:
            if get_cell_source_id(ground_layer, tile + Vector2i(neighbour)) == -1:
                set_cell(ground_layer, tile + Vector2i(neighbour), grass, Vector2(9, 1))

func _on_child_entered_tree(node: Node):
    if node.get_groups().has('kitty'):
        player = node
        get_tree().get_current_scene().child_entered_tree.disconnect(_on_child_entered_tree)
