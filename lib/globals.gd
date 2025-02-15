extends Node

const GRID_SIZE = 16

var player: KinematicBody2D
var map: TileMap
#var mapold: TileMap


var gold = 0
var depth = 1
var kills = 0

var DEBUG = OS.is_debug_build()


var debug2 = true
var javascript_active = false
var urlpath = ""
var playable = false
