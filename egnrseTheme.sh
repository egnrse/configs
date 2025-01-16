# Custom Theme by egnrse
# (https://github.com/egnrse/configs)
# should be in sync with `egnrseTheme.css`,`egnrseTheme.conf`
# currently only supports colors
#
## COLORSCHEME:
# 	#0A060E
# 	#180E1E
# 	#350F3F
# 	#1C6579
# 	#35C1E7
# 	#FCD4F6
#
## AlertColors:
# 	#C1334A
# 	#280C1B
#
# bg - background
# fg - foreground
# br - border

# TODO: add `COL_` before the var names

Background="rgba(17,17,27,0.733)"	# #180E1EBB
MainText="#FCD4F6"
BgDark="rgba(10,6,14,0.733)" 		# #0A060EBB
TextDark="#1C6579"

Accent="#350F3F"

MainTextTransparent="rgba(252,212,246 ,0.733)"	# #FCD4F6
BackgroundSolid="#180E1E"
AccentTransparent="rgba(53,15,63,0.733)" 		# #350F3F

FocusFg="#35C1E7"
FocusBg="$MainText"
Focus2Fg="$FocusFg"
Focus2Bg="$Accent"

FocusBgTransparent=$MainTextTransparent

Border=$FocusFg
BorderDark=$Focus2Bg
Alert=#C1334A
AlertDark=#280C1B

#
# State Colors
#
green=#77DD77
yellow=#EEEE77
blue=#AA87FF

charging=$green
full=$MainText
good=$MainText
warning=$MainText
critical=$Alert
