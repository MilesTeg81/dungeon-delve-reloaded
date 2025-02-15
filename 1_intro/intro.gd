extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var counter = 0
var step = 0

#$Downloads/DownloadLog.text = globals.downloadlog
# Called when the node enters the scene tree for the first time.
func _ready():
	#loadpck.uniprint
	if globals.javascript_active == false:
		if globals.debug2:
			$Downloads.show()
		else:
			$Downloads.hide()
	$Downloads/DownloadInfo.text = loadpck.DownloadInfoTitle
	$countdown.text = ""
	$countdown.percent_visible = 0

func _process(_delta):
	loadpck.pck_downloadmanager()
	$Downloads/DownloadLog.text = loadpck.DownloadLogs

func _physics_process(_delta):
	#counter = int($countdown.text)
	# Amazing Intro Movie:
	if counter < 9000:
		counter += 1
		step = counter/60 
		if step == 1:
			$countdown.text = "A world in darkness..."
			fadein($countdown)
		if counter == 60:
			$TitleMusic.play()
		if step == 4:
			$countdown.percent_visible = 0
		if step == 5:
			$countdown.text = "where evil reigns..."
			fadein($countdown)
		if step == 7:
			$countdown.percent_visible = 0
		if step == 8:
			$countdown.text = "There is no escape."
			fadein($countdown)
		if step == 10:
			$countdown.percent_visible = 0
		if step == 11:
			$countdown.text = "Only one Rule:"
			fadein($countdown)
		if step == 13:
			$countdown.text = "Always\n"
		if counter == 900:
			$countdown.text += "stay\n"
		if counter == 1080:
			$countdown.text += "FUNKY!"
		#if counter == 1800:
		if counter == 10:
			counter=9000
			get_tree().change_scene("res://2_menu/start-menu.tscn")
		#	$countdown.hide()

func _on_Button_pressed():
	get_tree().change_scene("res://2_menu/start-menu.tscn")

func _on_TouchScreenButton_pressed():
	get_tree().change_scene("res://2_menu/start-menu.tscn")

func fadein(node):
	node.percent_visible += 0.02

