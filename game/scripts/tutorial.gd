extends Node2D

signal finish_anim;

@onready var popUpText : Label = get_node("CanvasLayer/Container/Panel/Label");
@onready var popUpPanel : Panel = get_node("CanvasLayer/Container/Panel")
@onready var popUp : VBoxContainer = get_node("CanvasLayer/Container");
@onready var textIndex = 0;
@onready var target = $Target

var texts = [
	"WELCOME TO PROTECT LABIRAS!!",
	"YOUR MAIN OBJECTIVE IS TO PREVENT ENEMIES INVADING YOUR BASE, USING THIS CANNON",
	"TO SHOOT WITH THE CANNON, AIM AND SHOOT USING YOUR MOUSE. CONTROL THE POWER OF THE SHOT WHEN HOLDING THE LEFT MOUSE BUTTON, RELEASE IT TO SHOOT.",
	"DESTROY THE TARGET TO PROCEED!",
	"WELL DONE!!! NOW YOU'RE READY TO DESTROY THE REAL ENEMIES.\nCLICK THE BUTTON TO GO BACK TO THE MENU AND START YOUR GAME!"
];

func _ready():
	$AudioPlayer.play(Global.seek_music);
	$AudioPlayer.stream.set_loop(true);
	target.connect("targetDown", proceed_popup);
	popUp.visible = false;
	popUpText.text = texts[textIndex];
	Global.showingPopUp = false;
	_bg_start_anim();
	_camera_start_anim();
	await (get_tree().create_timer(1.5).timeout);
	Global.showingPopUp = true;
	panel_anim(popUpPanel, popUpPanel.custom_minimum_size, "in");

func _physics_process(delta):
	get_node("Cannon").set_physics_process(true);
	if Global.showingPopUp:
		get_node("Cannon").set_physics_process(false);
		popUp.visible = true;


func _bg_start_anim():
	var _bg : TextureRect = $BG/TextureRect;
	_bg.position.y = -60;
	var _tween = get_tree().create_tween();
	_tween.tween_property(
		_bg,
		"position",
		Vector2(0.0,-480.0),
		1.0
	).set_trans(Tween.TRANS_QUAD);


func _camera_start_anim():
	var _camera : Camera2D = $Camera2D;
	_camera.position.y = -600;
	var _tween = get_tree().create_tween();
	_tween.tween_property(
		_camera,
		"position",
		Vector2(654,140),
		1.0
	).set_trans(Tween.TRANS_QUAD);

func proceed_popup():
	Global.showingPopUp = true;
	popUp.visible = true;
	panel_anim(popUpPanel, Vector2(600,200), "in");
	

func _on_next_pressed():
	textIndex+=1;
	panel_anim(popUpPanel, popUpPanel.custom_minimum_size, "out")
	await finish_anim
	panel_anim(popUpPanel, Vector2(600,200), "in")
	match textIndex:
		5:
			textIndex = -1
			get_tree().change_scene_to_file("res://scenes/menu.tscn");
		4:
			popUp.visible = false
			Global.showingPopUp = false;
		
	popUpText.text = texts[textIndex];

func panel_anim(node, size, mode: String):
	var _tween = get_tree().create_tween();
	var node_size = node.custom_minimum_size;
	match mode:
		"in":
			node.custom_minimum_size.y = 0;
			_tween.tween_property(node, "custom_minimum_size", size, 0.25);
		"out":
			_tween.tween_property(node, "custom_minimum_size", Vector2(node_size.x, 0.0), 0.25);
	
	await _tween.finished;
	emit_signal("finish_anim");
