extends MarginContainer

var planetNameArr = ["Mercury","Venus","Earth","Mars","Tutorial","Introduction","Summary"]

func setStatTitle(cursor):
	$StatBox/StatTitle/StatTitleText.text = planetNameArr[cursor]
