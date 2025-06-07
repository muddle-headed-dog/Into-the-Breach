class_name MapTools extends Node

# 获取全局逻辑相机
static func get_logic_camera() -> Camera2D:
	return Engine.get_main_loop().root.get_node("LogicCamera")

## 检查指定地图坐标是否有图块
## 参数：map_pos: Vector2i，地图坐标
## 参数：tilemap: TileMapLayer，地图
## 返回值：bool，是否有图块
## 示例：
## 输入：Vector2i(1, 1)
## 输出：true
static func has_tile_at_position(map_pos: Vector2i, tilemap: TileMapLayer) -> bool:
	return tilemap.get_cell_source_id(map_pos) != -1

## 获取指定坐标位置的图块自定义属性
## 参数：map_pos: Vector2i，地图坐标
## 返回值：Dictionary，键为图块自定义属性名称，值为图块自定义属性值
## 返回值示例：{"isMove": true, "isAttack": false}
static func get_tiles_custom_data(map_pos: Vector2i, tilemap: TileMapLayer) -> Dictionary:
	if not has_tile_at_position(map_pos, tilemap):
		return {}

	# 1.获取图集
	var tile_set = tilemap.tile_set

	# 2.通过图块源获取图集数据
	var tile_set_source = tile_set.get_source(tilemap.get_cell_source_id(map_pos))

	# 3.获取图块ID
	var tile_id = tilemap.get_cell_atlas_coords(map_pos)

	var all_data: Dictionary = {}
	for layer_index in range(tile_set.get_custom_data_layers_count()):
		var layer_name: String = tile_set.get_custom_data_layer_name(layer_index)

		# 确保图块数据存在
		var tile_data: TileData = tile_set_source.get_tile_data(tile_id, 0)
		var custom_data: Variant = tile_data.get_custom_data(layer_name)
		all_data[layer_name] = custom_data

	return all_data


#region 坐标转换
## 使用逻辑相机将屏幕坐标转换为全局坐标 (推荐)
## 参数：screen_pos: Vector2，屏幕坐标
## 返回值：Vector2，全局坐标
static func logic_screen_to_global(screen_pos: Vector2) -> Vector2:
	return get_logic_camera().get_viewport().get_canvas_transform().affine_inverse() * screen_pos

## 使用逻辑相机将全局坐标转换为屏幕坐标 (推荐)
## 参数：global_pos: Vector2，全局坐标
## 返回值：Vector2，屏幕坐标
static func logic_global_to_screen(global_pos: Vector2) -> Vector2:
	return get_logic_camera().get_viewport().get_canvas_transform() * global_pos

## 使用逻辑相机将屏幕坐标转换为地图坐标 (推荐)
## 参数：screen_pos: Vector2，屏幕坐标
## 参数：tilemap: TileMapLayer，地图
## 返回值：Vector2i，地图坐标
static func logic_screen_to_map(screen_pos: Vector2, tilemap: TileMapLayer) -> Vector2i:
	return tilemap.local_to_map(tilemap.to_local(logic_screen_to_global(screen_pos)))

## 使用逻辑相机将地图坐标转换为屏幕坐标 (推荐)
## 参数：map_pos: Vector2i，地图坐标
## 参数：tilemap: TileMapLayer，地图
## 返回值：Vector2，屏幕坐标
static func logic_map_to_screen(map_pos: Vector2i, tilemap: TileMapLayer) -> Vector2:
	return logic_global_to_screen(tilemap.to_global(tilemap.map_to_local(map_pos)))

## 使用逻辑相机获取图块创建位置 (推荐)
## 参数：map_pos: Vector2i，地图坐标
## 参数：tile_offset: int，图块偏移量
## 参数：tilemap: TileMapLayer，地图
## 返回值：Vector2，图块创建位置
static func logic_get_tile_create_pos(map_pos: Vector2i, tile_offset: int, tilemap: TileMapLayer) -> Vector2:
	return tilemap.to_global(tilemap.map_to_local(map_pos) + Vector2(0, tile_offset))

## 将全局坐标转换为TileMapLayout地图坐标
## 参数：global_pos: Vector2，全局坐标
## 参数：tilemap: TileMapLayer，地图
## 返回值：Vector2i，地图坐标
## 示例：
## 输入：Vector2(100, 100)
## 输出：Vector2i(1, 1)
static func global_to_map(global_pos: Vector2, tilemap: TileMapLayer) -> Vector2i:
	return tilemap.local_to_map(tilemap.to_local(global_pos))

## 将TileMapLayout地图坐标转换为全局坐标
## 参数：map_pos: Vector2i，地图坐标
## 参数：tilemap: TileMapLayer，地图
## 返回值：Vector2，全局坐标
## 示例：
## 输入：Vector2i(1, 1)
## 输出：Vector2(100, 100)
static func map_to_global(map_pos: Vector2i, tilemap: TileMapLayer) -> Vector2:
	return tilemap.to_global(tilemap.map_to_local(map_pos))

#endregion 坐标转换
