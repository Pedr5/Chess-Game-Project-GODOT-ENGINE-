
extends HBoxContainer

var colorArray = []
var i = 0
var color
class colorDuo:
	var l
	var d
	
func _ready():
	color = colorDuo.new()
	color.l = "dadada"
	color.d = "848484"
	colorArray.append(color)
	color = colorDuo.new()
	color.l = "c1d3dd"
	color.d = "65899d"
	colorArray.append(color)
	color = colorDuo.new()

	color.l = "ffe1be"
	color.d = "9b7259"
	colorArray.append(color)
	color = colorDuo.new()

	color.l = "d1e6d4"
	color.d = "618965"
	colorArray.append(color)
	i = FileConfig.colorIndex
	print("index is :",i)
	setColor()
func setColor():
	$tileColor.setColor(colorArray[i].l,colorArray[i].d)
	FileConfig.colorIndex = i
func _on_Next_pressed():
	i += 1
	if i == colorArray.size():
		i = 0
	setColor()

func _on_Previous_pressed():
	i -= 1
	if i < 0:
		i = colorArray.size() - 1
	setColor()

