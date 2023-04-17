extends RichTextLabel

var color: Color
var binds: int
var symbol: String


func bake():
	text = "[color=#" + color.to_html() + "]" + tr(symbol) + "[/color]"
	if binds > 1:
		text += " x" + str(binds)
	
	text += "[p]"
	text += tr("MOLECULA_" + symbol)
	
	if text == "MOLECULA_" + symbol:
		visible = false
