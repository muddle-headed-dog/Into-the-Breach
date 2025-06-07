class_name EventBus extends Node

#region 回合管理信号
# 回合状态改变信号
signal phase_changed(new_phase)
# 回合开始信号
signal turn_started(turn_number)
# 环境回合开始信号
signal environment_phase_started
# 玩家回合开始信号
signal player_turn_started
# 敌人回合开始信号
signal enemy_turn_started
# 部署回合开始信号
signal deployment_phase_started
#endregion
