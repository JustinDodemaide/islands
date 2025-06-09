extends StateMachine

func start_game(parameters:Dictionary):
	SignalBus.game_params = parameters
	get_tree().change_scene_to_file("res://GameHandler/GameHandler.tscn")
