class_name TurnManager extends Node

# 回合状态枚举
enum TURN_PHASE {
  DEPLOYMENT, # 部署回合
  ENVIRONMENT, # 环境回合
  PLAYER, # 玩家回合
  ENEMY, # 敌人回合
}

## 玩家实体
#const player_entity = preload("res://Scripts/player_unit.gd")
## 敌人实体
#const enemy_entity = preload("res://Scripts/enemy_unit.gd")
#
#
## 当前回合状态
#var cur_turn_phase: TURN_PHASE = TURN_PHASE.DEPLOYMENT
## 当前回合数
#var cur_turn_count: int = 1
#
## 玩家单位列表
#var player_units: Array = []
## 敌人单位列表
#var enemy_units: Array = []
### 玩家单位行动力,Vector2i x表示移动行动力，y表示攻击行动力
#var player_unit_action_points: Dictionary[Unit, Vector2i] = {}
#
## 初始化
#func _init():
	#on_deployment()
#
### 注册单位
#func register_unit(unit: Unit):
	#if unit is player_entity:
		#player_units.append(unit)
	#elif unit is enemy_entity:
		#enemy_units.append(unit)
#
### 移除单位
#func remove_unit(unit: Unit):
	#if unit is player_entity:
		#player_units.erase(unit)
	#elif unit is enemy_entity:
		#enemy_units.erase(unit)
#
##	进入部署回合
#func on_deployment():
	#print("进入部署回合")
	## 显示可部署区域（固定区域）
	## 添加玩家和敌人单位
	## 设置初始位置
	## 进行玩家部署
