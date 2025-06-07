class_name MapManager extends Node2D

## 区域
const area_scene = preload("res://Scene/area.tscn")
## 光标
const cursor_scene = preload("res://Scene/cursor.tscn")


## 地图
@onready var tilemap: TileMapLayer = $Map
@onready var area_parent: Node2D = $Map/AreaParent
@onready var cursor: Node2D = $Map/Cursor

## 寻路网格
var astar: AStarGrid2D = AStarGrid2D.new()

## 初始化
func _ready() -> void:
    generate_map()
    generate_astar_grid()
    _draw()

## 处理
func _process(delta: float) -> void:
    if Input.is_action_just_pressed("mouse_left"):
        # 获取屏幕位置（鼠标点击位置）
        # draw_area(Vector2i(1, 4), Color.RED)
        # prints("屏幕坐标:", get_viewport().get_mouse_position())
        # prints("全局坐标:", get_global_mouse_position())
        # prints("屏幕坐标:", MapTools.logic_global_to_screen(get_global_mouse_position()))
        # prints("全局坐标:", MapTools.logic_screen_to_global(get_viewport().get_mouse_position()))
        # prints("地图坐标:", MapTools.global_to_map(get_global_mouse_position(), tilemap))
        # prints("地图坐标:", MapTools.logic_screen_to_map(get_viewport().get_mouse_position(), tilemap))
        # prints("屏幕坐标:", MapTools.logic_map_to_screen(MapTools.logic_screen_to_map(get_viewport().get_mouse_position(), tilemap), tilemap))
        # prints("全局坐标:", MapTools.map_to_global(MapTools.global_to_map(get_global_mouse_position(), tilemap), tilemap))
        draw_area(MapTools.logic_screen_to_map(get_viewport().get_mouse_position(), tilemap), Color.RED)

## 生成地图
func generate_map() -> void:
    pass

## 生成寻路网格
func generate_astar_grid() -> void:
    astar.region = tilemap.get_used_rect()
    astar.cell_size = tilemap.tile_set.tile_size
    astar.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
    astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
    astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
    astar.offset = tilemap.transform.origin
    astar.update()

## 获取寻路网格
## 参数：start: Vector2i，起点,寻路网格ID，本质是地图坐标
## 参数：end: Vector2i，终点,寻路网格ID，本质是地图坐标
## 返回值：PackedVector2Array，寻路网格
func get_astar_path(start: Vector2i, end: Vector2i) -> PackedVector2Array:
    return astar.get_point_path(start, end)

## 绘制寻路网格
func _draw() -> void:
    for point in astar.get_point_data_in_region(astar.region):
        var global_pos = point["position"]
        if point["solid"] == true:
            draw_circle(global_pos, 5, Color.RED, false, 1)
        else:
            draw_circle(global_pos, 5, Color.GREEN)

## 绘制区域
func draw_area(map_pos: Vector2i, color: Color) -> void:
    if not MapTools.has_tile_at_position(map_pos, tilemap):
        return
    var area = area_scene.instantiate()
    var global_pos = MapTools.map_to_global(map_pos, tilemap)
    # 将全局坐标转换为area_parent的局部坐标
    area.position = area_parent.to_local(global_pos)
    area.modulate = color
    area_parent.add_child(area)
