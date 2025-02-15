extends Node

# loadpck is a HTML5-only pck-downloader lib
# ToDo: 
# - work independent (but still aware) of scenes

# stoppers:
# --- menu.pck required for 2_menu
#         (startmenu / settings / credits etc. / character creation/selection / 2nd intro )!!
# --- core.pck required for 1st level(s)!!
# -- show PLAYABLE at this point.
# --- [gameover.pck]  ?
# --- chapter_x.pck  ( level assets beyond 1st level(s)  )
# --- music_x.pck  (soundtrack beyond 1st level(s) )
# --- [optional videos]?


# Declare member variables here. 
var downloadcompleted = false
var DownloadInfoTitle = ""
var DownloadLogs = "Desktop-Export - no Javascript - no Downloads!"
var downloadstage = -1
# is export running Javascript? On localhost or online?
enum JSDomain {unknown, editor_runs_debug_browser, realhost, error}
var js_domain = JSDomain.unknown
var debug2 = globals.debug2

# Called when the node enters the scene tree for the first time.
func _ready():
	check_javascript_env()
	pck_downloadmanager()

func DownloadLog(message, linebreak = ""):
	DownloadLogs += message
	DownloadLogs += linebreak
	#globals.DownloadLog += "v"
	uniprint(message)

func pck_downloadmanager():
	#uniprint(str(globals.downloadstage))
	if globals.javascript_active: 
		if downloadstage == 0:

			tryloadpck("menu")
			downloadstage+=1
			if debug2:
				DownloadLog("Download Stage pck_downloadmanager1:" + str(downloadstage),"\n")
		elif downloadstage == 3:
			tryloadpck("core")
			downloadstage+=1
			if debug2:
				DownloadLog("Download Stage pck_downloadmanager2:" + str(downloadstage),"\n")
			DownloadLog("Game Playable!","\n")
			globals.playable=true
		elif downloadstage == 6:
			tryloadpck("music")
			downloadstage+=1
			if debug2:
				DownloadLog("Download Stage:")
				DownloadLog(str(downloadstage),"\n")
		elif downloadstage == 9:
			downloadstage+=1
			if debug2:
				DownloadLog("Download Stage:")
				DownloadLog(str(downloadstage),"\n")
			DownloadLog("All files loaded!")


func check_javascript_env():
	if OS.has_feature('JavaScript'):
		globals.javascript_active = true
		var location_href =  str(JavaScript.eval("window.location.href"))
		
		uniprint("full window.location.href: " + location_href)
		
		# What's the javascript runtime environment?		
		if location_href.ends_with("tmp_js_export.html"):
			# asuming godot editor runs debug of "runnable" webexport
			js_domain = JSDomain.editor_runs_debug_browser
			globals.urlpath = location_href.trim_suffix("tmp_js_export.html")
			#globals.urlpath += ""
			DownloadLogs=""
			uniprint("urlpath:" + globals.urlpath)
			#kickstart downloader
			downloadstage = 0
		elif location_href.ends_with("index.html"):
			# asuming a real domain/hoster (like itch.io / selfhosted )
			js_domain = JSDomain.realhost
			globals.urlpath = location_href.trim_suffix("index.html")
			#kickstart downloader
			downloadstage = 0
		else:
			# some custom hosting? Please adjust for your usecase.
			js_domain = JSDomain.error
			globals.urlpath = JSDomain.error
			uniprint("JSDomain Error!! URL not recognized!")
		DownloadInfoTitle = "Loading assets from " + str(globals.urlpath) + ":"
			
	else:
		print("The JavaScript singleton is NOT available")
		DownloadInfoTitle="The JavaScript singleton is NOT available"
	#DownloadLog(DownloadInfoTitle)
	uniprint(DownloadInfoTitle)


func tryloadpck(filename):
	DownloadLog("- ")
	DownloadLog(filename)
	var link = globals.urlpath + filename + ".pck"
	var path = "user://" + filename + ".pck"
	var success = import_pck(path,true)
	if success:
		uniprint("pck FOUND in UserFS of Browser")
		DownloadLog(" cached & imported.")
		uniprint("ToDo: Test for import?")
		downloadstage+=1
		DownloadLog("Stage tryloadpck:" + str(downloadstage) )
		#testfile?
		#var stream = load("res://assets/music/gameover_s.ogg")
		#  $Music.set_stream(stream)
		#  $Music.play(0.0)
	else:
		uniprint("pck NOT found locally in INDEXDB. Starting download.")
		download(link, path)
		#	return true
	
func import_pck(path,trycached=false):
	uniprint("Importing PCK: " + String(path) + "...")
	var success = ProjectSettings.load_resource_pack(path)
	if success:
		uniprint("Importing PCK: " + String(path) + " - successful!")
		if trycached:
			uniprint("(from cache)")
		downloadstage+=1
		DownloadLog("Stage import_pck:" + str(downloadstage) )
		return true
	else:
		uniprint("FAILED Importing PCK: " + String(path) + "! (" + String(success) + ")")
		DownloadLog("failed Importing PCK")
		if trycached:
			uniprint("(from cache)")
			DownloadLog("(from cache)","/n")
		return false

# Asset/pck downloader
func download(link, path):
	downloadcompleted =false
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	http_request.set_download_file(path)
	var request = http_request.request(link)
	uniprint("Downloading " + path + " from: "+ link)
	yield(get_tree().create_timer(0.2), "timeout")
	if request != OK:
		push_error("http request error: " + String(request))
	else:
		print("http request NO errors: " + String(request))
	var filesize = http_request.get_body_size()
	while downloadcompleted == false:
		uniprint(String(http_request.get_downloaded_bytes()) + " from " + str(filesize) \
		+ " (" + str(http_request.get_downloaded_bytes()/filesize) + "percent) requeststatus: " \
		+ String(request))
		yield(get_tree().create_timer(0.1), "timeout")
		DownloadLog(".")
	if downloadcompleted:
		uniprint("Download "+ path +" finished! Importing...")
		DownloadLog(" downloaded!")
		downloadstage+=1
		DownloadLog("Download Stage download:" + str(downloadstage),"\n")
		if import_pck(path):
			DownloadLog(" imported!")
			return true
		else:
			DownloadLog(" import failed!")
			return false


func _http_request_completed(result, _response_code, _headers, _body):
	print("Resultcode:"+ String(result))
	if result != OK:
		push_error("Download Failed")
	else:
		downloadcompleted = true
		uniprint("Download Successful")

#wrapper for a ingame console option
func uniprint(message):
	if globals.javascript_active:
		JavaScript.eval("console.log('"+message+"')")
	else:
		print(message)
