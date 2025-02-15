extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var counter = 0
var step = 0

#$Downloads/DownloadLog.text = globals.downloadlog
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	loadpck.pck_downloadmanager()

		
func _physics_process(_delta):
	#counter = int($countdown.text)
	# Amazing Intro:
	if counter < 9000:
		counter += 1
		step = counter/60 
		if counter == 360:
			counter=9000
			get_tree().change_scene("res://1_intro/intro.tscn")
		#	$countdown.hide()
	#if counter < 60:
#		$Downloads/DownloadLog.text = loadpck.DownloadLogs
#		if $Powered_By_Godot.rect_position.y < 3800:
#			$Powered_By_Godot.rect_position.y += 6

func fadein(node):
	node.percent_visible += 0.02
