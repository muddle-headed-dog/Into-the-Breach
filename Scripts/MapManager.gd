class_name MapManager extends Node2D

## 区域
const area_scene = preload("res://Scene/area.tscn")
## 光标
const cursor_scene = preload("res://Scene/cursor.tscn")


## 地图
@onready var tilemap: TileMapLayer = $Map
@onready var area_parent: Node2D = $Map/AreaParent
@onready var cursor_parent: Node2D = $Map/CursorParent

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
        prints("屏幕坐标:", get_viewport().get_mouse_position())
        prints("全局坐标:", get_global_mouse_position())
        prints("屏幕坐标:", MapTools.logic_global_to_screen(get_global_mouse_position()))
        prints("全局坐标:", MapTools.logic_screen_to_global(get_viewport().get_mouse_position()))
        prints("地图坐标:", MapTools.global_to_map(get_global_mouse_position(), tilemap))
        prints("地图坐标:", MapTools.logic_screen_to_map(get_viewport().get_mouse_position(), tilemap))
        prints("屏幕坐标:", MapTools.logic_map_to_screen(MapTools.logic_screen_to_map(get_viewport().get_mouse_position(), tilemap), tilemap))
        prints("全局坐标:", MapTools.map_to_global(MapTools.global_to_map(get_global_mouse_position(), tilemap), tilemap))
        prints(MapTools.has_tile_at_position(MapTools.logic_screen_to_map(get_viewport().get_mouse_position(), tilemap), tilemap))
        draw_area(PackedVector2Array([MapTools.global_to_map(get_global_mouse_position(), tilemap)]), Color.RED, true)
        draw_cursor(MapTools.logic_screen_to_map(get_viewport().get_mouse_position(), tilemap), Color.BLUE)

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
## 参数：map_pos_array: PackedVector2Array，地图坐标数组
## 参数：color: Color，颜色
## 说明：如果区域存在，则更新区域位置，如果区域不存在，则创建区域
func draw_area(map_pos_array: PackedVector2Array, color: Color, is_update: bool = false) -> void:
    if is_update:
        for area in area_parent.get_children():
                if area.name.begins_with("Area_"):
                    area.queue_free()
        draw_area(map_pos_array, color, false)
    else:
        for map_pos in map_pos_array:
            if not MapTools.has_tile_at_position(map_pos, tilemap):
                return
            var area = area_scene.instantiate()
            var tile_offset = MapTools.get_tiles_custom_data(map_pos, tilemap).get("offset", 0)
            var global_pos = MapTools.logic_get_tile_create_pos(map_pos, tile_offset, tilemap)
            # 将全局坐标转换为area_parent的局部坐标
            area.position = area_parent.to_local(global_pos)
            area.modulate = color
            area.name = "Area_" + str(map_pos)
            area_parent.add_child(area)

## 绘制光标 
## 参数：map_pos: Vector2i，地图坐标
## 参数：color: Color，颜色
## 说明：如果光标存在，点击地图外则删除光标，点击地图内则更新光标位置
## 说明：如果光标不存在，则创建光标
func draw_cursor(map_pos: Vector2i, color: Color) -> void:
    if cursor_parent.get_child_count() == 0:
        var cursor = cursor_scene.instantiate()
        var tile_offset = MapTools.get_tiles_custom_data(map_pos, tilemap).get("offset", 0)
        var global_pos = MapTools.logic_get_tile_create_pos(map_pos, tile_offset, tilemap)
        # 将全局坐标转换为area_parent的局部坐标
        cursor.position = cursor_parent.to_local(global_pos)
        cursor.modulate = color
        cursor.name = "Cursor_" + str(map_pos)
        cursor_parent.add_child(cursor)
    else:
        if MapTools.has_tile_at_position(map_pos, tilemap):
            cursor_parent.get_child(0).position = cursor_parent.to_local(MapTools.logic_get_tile_create_pos(map_pos, MapTools.get_tiles_custom_data(map_pos, tilemap).get("offset", 0), tilemap))
            cursor_parent.get_child(0).modulate = color
            cursor_parent.get_child(0).name = "Cursor_" + str(map_pos)
        else:
            cursor_parent.get_child(0).queue_free()
