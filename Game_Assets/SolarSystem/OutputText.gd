extends Node2D

var textOpen = false
var outTextArr = []
var outTextArrIn = 0
signal textFinished

func outputText(strin,textColor="w"):
	var wordlist = strin.split(" ")
	var lineNumber = 1
	var oldstringLine = ""
	var stringLine = ""
	var lineArr = []
	for word in wordlist:
		if "\n" in word:
			word = word.replace("\n","")
			stringLine += word
			lineArr.append(stringLine)
			oldstringLine = ""
			stringLine = ""
			continue
		stringLine += word + " "
		if 24 < len(stringLine):
			var partOfWord = false
			while 24 < len(word):
				var newWord = word.substr(0,24 - len(oldstringLine))
				oldstringLine += newWord + "-"
				lineArr.append(oldstringLine)
				oldstringLine = ""
				stringLine = ""
				word = newWord
				partOfWord = true
			
			if not partOfWord:
				lineArr.append(oldstringLine)
			
			stringLine = word + " "
			oldstringLine = word + " "
		else:
			oldstringLine = stringLine
	lineArr.append(oldstringLine)
	var fullText = textColor
	var lineInd = 1
	for line in lineArr:
		fullText += line + "\n"
		lineInd += 1
		if (lineInd % 20) == 0:
			outTextArr.append(fullText)
			fullText = textColor
	outTextArr.append(fullText)
	var outTextArrNoEmptyStr = []
	for textOut in outTextArr:
		if textOut.strip_edges() == "":
			pass
		else:
			outTextArrNoEmptyStr.append(textOut.strip_edges())
	outTextArr = outTextArrNoEmptyStr
	textOpen = true
	openAfterAni()

func openAfterAni():
	$arrowBounce.visible = true
	$OutputText.visible = true
	$arrowBounce/arrowBouncePlayer.play("Arrow_Bounce")
	sendTextToBox()


func sendTextToBox():
	var lineBuff = outTextArr[outTextArrIn]
	var colorStr = lineBuff.substr(0, 1)
	lineBuff = lineBuff.lstrip(colorStr)
	if colorStr == "w":
		$OutputText/Label.add_color_override("font_color",Color.white)
	elif colorStr == "r":
		$OutputText/Label.add_color_override("font_color",Color.red)
	elif colorStr == "b":
		$OutputText/Label.add_color_override("font_color",Color.blue)
	elif colorStr == "g":
		$OutputText/Label.add_color_override("font_color",Color.green)
	elif colorStr == "k":
		$OutputText/Label.add_color_override("font_color",Color.black)
	elif colorStr == "c":
		$OutputText/Label.add_color_override("font_color",Color.cyan)
	elif colorStr == "o":
		$OutputText/Label.add_color_override("font_color",Color.orange)
	elif colorStr == "q":
		$OutputText/Label.add_color_override("font_color",Color.deeppink)
	elif colorStr == "p":
		$OutputText/Label.add_color_override("font_color",Color.gray)
	elif colorStr == "G":
		$OutputText/Label.add_color_override("font_color",Color.lightslategray)
	else:
		$OutputText/Label.add_color_override("font_color",Color.white)
	$OutputText/Label.text = lineBuff

func closeTextBox():
	textOpen = false
	outTextArr = []
	outTextArrIn = 0
	$OutputText/Label.text = ""
	$arrowBounce.visible = false
	$OutputText.visible = false

func closeText():
	closeTextBox()
	emit_signal("textFinished")

func isSpeakDialogOpen():
	return textOpen

func triggerNextEvent():
	if outTextArrIn < (len(outTextArr) - 1):
		outTextArrIn = outTextArrIn + 1
		sendTextToBox()
	else:
		closeText()