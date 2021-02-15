;nombre: HY-ESG-AHK
;Autor: crisspro
;Año: 2021
;Licencia: GPL-3.0


ScriptNombre:= "HY-ESG-AHK"
VSTNombre:=  "HY-ESG"
VSTControl:= "JUCE"

xg:= 0
yg:= 0
VSTControlDetectado:= False
VSTNombreDetectado:= False

;construcción del menú
menu()
{
if (InStr(A_language,"0a") = "3")
{
Menu,Menu, Add, Inicializar todos los valores de los parámetros,Initialize
Menu,Menu, Add, Abrir la carpeta de preajustes,Open
Menu,Menu, Add, Elegir la carpeta de preajustes,Set
Menu,Menu, Add, Guardar,Save
Menu,Menu, Add, Guardar como...,Save_as
Menu,Menu, Add, Visitar hy- pluging,Visit1
Menu,Menu, Add, Visitar BPB,Visit2
Menu,Menu, Add, Reportar errores,Bug
}
else
{
Menu,Menu, Add, Initialize all param values,Initialize
Menu,Menu, Add, Open presets folder,Open
Menu,Menu, Add, Set presets folder,Set
Menu,Menu, Add, Save,Save
Menu,Menu, Add, Save as...,Save_as
Menu,Menu, Add, Visit hy- pluging,Visit1
Menu,Menu, Add, Visit BPB,Visit2
Menu,Menu, Add, Bug report,Bug
}
}

menu()

;funciones

;mensajes
;carga NVDA
nvdaSpeak(text)
{
Return DllCall("nvdaControllerClient" A_PtrSize*8 ".dll\nvdaController_speakText", "wstr", text)
}

hablar(es,en)
{
Lector:= "otro"
process, Exist, nvda.exe
if ErrorLevel != 0
{
Lector:= "nvda"
if (InStr(A_language,"0a") = "3")
nvdaSpeak(es)
else
nvdaSpeak(en)
}
process, Exist, jfw.exe
if ErrorLevel != 0
{
Lector:= "jaws"
Jaws := ComObjCreate("FreedomSci.JawsApi")
if (InStr(A_language,"0a") = "3")
Jaws.SayString(es)
else
Jaws.SayString(en)
}
If global Lector = "otro"
{
Sapi := ComObjCreate("SAPI.SpVoice")
Sapi.Rate := 5
Sapi.Volume :=90
if (InStr(A_language,"0a") = "3")
Sapi.Speak(es)
else
Sapi.Speak(en)
}
}

SetTitleMatchMode,2

;inicio
SoundPlay,sounds/start.wav, 1
hablar(ScriptNombre " activado",ScriptNombre " ready")

;detecta el plugin
loop
{
WinGet, VentanaID,Id,A
winget, controles, ControlList, A
IfWinActive,%VSTNombre%
{
VSTNombreDetectado:= True
loop, parse, controles, `n
{
if A_LoopField contains %VSTControl%
{
VSTControlDetectado:= True
ControlGetPos, x,y,a,b,%A_loopField%, ahk_id %VentanaID% 
xg:= x
yg:= y
break
}
else
VSTControlDetectado:= False
}
}
else
VSTNombreDetectado:= False
}


;atajos
#If VSTControlDetectado= True and VSTNombreDetectado= True 

;despliega el menú.
m::
Menu,Menu,Show
return

Save:
MouseClick,LEFT, xg+142, yg+17,1
Sleep 100
MouseClick,LEFT,xg+397, yg+17 
return

Save_as:
MouseClick,LEFT, xg+142, yg+17,1
Sleep 100
MouseClick,LEFT,xg+438, yg+19 
return

Initialize:
MouseClick,LEFT, xg+142, yg+17,1
Sleep 100
MouseClick,LEFT,xg+158, yg+39 
return

Set:
MouseClick,LEFT, xg+142, yg+17,1
Sleep 100
MouseClick,LEFT,xg+183, yg+67 
return

Open:
MouseClick,LEFT, xg+142, yg+17,1
Sleep 100
MouseClick,LEFT,xg+202, yg+79 
return

Visit1:
MouseClick,LEFT, xg+142, yg+17,1
Sleep 100
MouseClick,LEFT,xg+241, yg+132 
return

Visit2:
MouseClick,LEFT, xg+142, yg+17,1
Sleep 100
MouseClick,LEFT,xg+192, yg+156 
return

Bug:
MouseClick,LEFT, xg+142, yg+17,1
Sleep 100
MouseClick,LEFT,xg+201, yg+177 
return
return


;cambia al preset anterior.
a::
MouseClick,LEFT, xg+162, yg+17,1
hablar("anterior", "back")
return

;cambia al siguiente preset.
s::
MouseClick,LEFT, xg+ 348, yg+18,1
hablar("siguiente", "next")
return
 

;abre la ayuda.
f1::
if (InStr(A_language,"0a") = "3")
Run Documentation\es.html
else
Run Documentation\en.html
return

;sale del script.
^q:: 
SoundPlay,sounds/exit.wav,1
hablar(ScriptNombre " cerrado",ScriptNombre " closed")
ExitApp
return