class_name MapTools extends Node

## 获取指定坐标位置的图块自定义属性
## 参数：map_pos: Vector2i，地图坐标
## 返回值：Dictionary，键为图块自定义属性名称，值为图块自定义属性值
## 返回值示例：{"isMove": true, "isAttack": false}
static func get_tiles_custom_data(map_pos: Vector2i, tilemap: TileMapLayer) -> Dictionary:
	if not has_tile_at_position(map_pos, tilemap):
		return {}
	# 1.获取当前图集
	var tile_set: TileSet = tilemap.tile_set
	# 2.获取当前图集的图集资源
	var tile_set_source: TileSetSource = tile_set.get_source(0)
	# 3.获取坐标位置下的图块ID
	var tile_id: Vector2i = tilemap.get_cell_atlas_coords(map_pos)
	# 4.获取图块的所有自定义属性
	var all_data: Dictionary = {}
	for layer_index in range(tile_set.get_custom_data_layers_count()):
		var layer_name: String = tile_set.get_custom_data_layer_name(layer_index)
		var tile_data: TileData = tile_set_source.get_tile_data(tile_id, 0)
		var custom_data: Variant = tile_data.get_custom_data(layer_name)
		all_data[layer_name] = custom_data
	return all_data

## 检查指定地图坐标是否有图块
## 参数：map_pos: Vector2i，地图坐标
## 返回值：bool，是否有图块
## 示例：
## 输入：Vector2i(1, 1)
## 输出：true
static func has_tile_at_position(map_pos: Vector2i, tilemap: TileMapLayer) -> bool:
	var source_id = tilemap.get_cell_source_id(map_pos)
	return source_id != -1


# region 坐标转换
## 将屏幕坐标转换为TileMapLayout地图坐标
## 参数：screen_pos: Vector2，屏幕坐标
## 返回值：Vector2i，地图坐标
## 示例：
## 输入：Vector2(100, 100)
## 输出：Vector2i(1, 1)
static func screen_to_map(screen_pos: Vector2, tilemap: TileMapLayer) -> Vector2i:
	# 将屏幕坐标转换为全局坐标
	var global_pos = tilemap.get_viewport().get_canvas_transform().affine_inverse() * screen_pos
	# 将全局坐标转换为TileMap坐标
	var map_pos = tilemap.local_to_map(tilemap.to_local(global_pos))
	return map_pos

## 将TileMapLayout地图坐标转换为全局坐标
## 参数：map_pos: Vector2i，地图坐标
## 返回值：Vector2，全局坐标
## 示例：
## 输入：Vector2i(1, 1)
## 输出：Vector2(100, 100)
static func map_to_global(map_pos: Vector2i, tilemap: TileMapLayer) -> Vector2:
	var global_pos = tilemap.to_global(tilemap.map_to_local(map_pos))
	return global_pos

## 将TileMapLayout地图坐标转换为屏幕坐标
## 参数：map_pos: Vector2i，地图坐标
## 返回值：Vector2，屏幕坐标
## 示例：
## 输入：Vector2i(1, 1)
## 输出：Vector2(100, 100)
static func map_to_screen(map_pos: Vector2i, tilemap: TileMapLayer) -> Vector2:
	var global_pos = map_to_global(map_pos, tilemap)
	var screen_pos = tilemap.get_viewport().get_canvas_transform() * global_pos
	return screen_pos

## 获取鼠标在地图上的位置
## 参数：tilemap: TileMapLayer，地图
## 返回值：Vector2i，地图坐标
## 示例：
## 输入：TileMapLayer
## 输出：Vector2i(1, 1)
static func get_mouse_map_position(tilemap: TileMapLayer) -> Vector2i:
	var mouse_pos = tilemap.get_viewport().get_mouse_position()
	return screen_to_map(mouse_pos, tilemap)
# endregion 坐标转换
