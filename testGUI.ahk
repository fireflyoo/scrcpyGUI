
#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

FMenu := Menu()
FMenu.Add("退出(&X)", MenuHandler)
SMenu := Menu()
SMenu.Add("显示提示(&T)", MenuHandler)
SMenu.Add("自动隐藏至任务栏(&H)", MenuHandler)
SMenu.Add("启动程序时自动尝试打开最近设备(&A)", MenuHandler)
SMenu.Add("打开配置文件（高级）(&O)", MenuHandler)
AMenu := Menu()
AMenu.Add("更新日志(&L)", MenuHandler)
AMenu.Add("帮助(&H)", MenuHandler)
AMenu.Add("关于(&A)", MenuHandler)
MenuBar_Storage := MenuBar()
MenuBar_Storage.Add("文件(&F)", FMenu)
MenuBar_Storage.Add("设置(&S)", SMenu)
MenuBar_Storage.Add("关于(&A)", AMenu)
myGui := Gui()
myGui.MenuBar := MenuBar_Storage
SB := myGui.Add("StatusBar", , "共有-1个设备在线。")
Tab := myGui.Add("Tab3", "x11 y6 w534 h477", ["镜像管理", "镜像配置", "结果输出"])
Tab.UseTab(1)
myGui.Add("GroupBox", "x30 y30 w500 h100", "连接管理")
Radio1 := myGui.Add("Radio", "x40 y60 w70 h23", "网络连接")
Radio2 := myGui.Add("Radio", "x40 y93 w70 h23 +Checked", "USB连接")
Edit1 := myGui.Add("Edit", "x110 y60 w150 h21")
ogcButton := myGui.Add("Button", "x110 y91 w80 h23", "刷新")
myGui.Add("GroupBox", "x30 y160 w500 h240", "设备清单")
ogcListView := myGui.Add("ListView", "x35 y180 w450 h108")
ogcButton := myGui.Add("Button", "x40 y450 w80 h23", "双击设备连接")
ogcButton := myGui.Add("Button", "x230 y450 w80 h23", "测试")
Tab.UseTab(2)
myGui.Add("GroupBox", "x30 y30 w500 h400", "连接配置")
myGui.Add("Text", "x40 y60 w120 h23 +Right", "窗口标题")
Edit1 := myGui.Add("Edit", "x200 y60 w120 h21")
CheckBox1 := myGui.Add("CheckBox", "x40 y91 w120 h23 +Right", "镜像录屏")
CheckBox2 := myGui.Add("CheckBox", "x200 y91 w120 h23 +Checked +Disabled", "录屏时打开镜像")
myGui.Add("Text", "x40 y124 w120 h23 +Right", "录屏文件路径")
Edit2 := myGui.Add("Edit", "x200 y124 w120 h21 +Disabled", "C:\Users\Fen\AppData\Roaming\ScrcpyGui\20231111101021.mkv")
myGui.Add("Text", "x40 y155 w120 h23 +Right", "镜像传输比特率")
myGui.Add("Slider", "x200 y155 w120 h32 Range0-100", "50")
Edit3 := myGui.Add("Edit", "x340 y155 w34 h21", "8,000")
myGui.Add("UpDown", "x372 y155 w17 h21 -16")
myGui.Add("Text", "x40 y186 w120 h23 +Right", "等比最大分辨率")
myGui.Add("Slider", "x200 y186 w120 h32 Range0-100", "50")
Edit4 := myGui.Add("Edit", "x340 y186 w34 h21", "0")
myGui.Add("UpDown", "x372 y186 w17 h21 -16")
myGui.Add("Text", "x40 y217 w120 h23 +Right", "剪切屏幕")
Edit5 := myGui.Add("Edit", "x200 y217 w120 h21", "0")
Edit6 := myGui.Add("Edit", "x350 y217 w120 h21", "0")
Edit7 := myGui.Add("Edit", "x200 y248 w120 h21", "0")
Edit8 := myGui.Add("Edit", "x350 y248 w120 h21", "0")
myGui.Add("Text", "x40 y279 w120 h23 +Right", "其他设置")
CheckBox3 := myGui.Add("CheckBox", "x200 y279 w73 h23", "窗口置顶")
CheckBox4 := myGui.Add("CheckBox", "x323 y279 w181 h23 +Checked", "电脑控制（取消勾选仅查看）")
CheckBox5 := myGui.Add("CheckBox", "x200 y322 w120 h23", "显示手机点按位置")
CheckBox6 := myGui.Add("CheckBox", "x200 y345 w187 h23", "渲染所有帧（会增加延迟）")
CheckBox7 := myGui.Add("CheckBox", "x200 y378 w199 h23 +Checked", "打开镜像时关闭手机屏幕")
Edit9 := myGui.Add("Edit", "x40 y440 w400", " -b 8000k -m 0 -S")
Tab.UseTab(3)
myGui.Add("GroupBox", "x30 y30 w500 h100", "运行测试")
runEdit := myGui.Add("Edit","x60 y60 w300")
runButton := myGui.Add("Button",,"运行")
myGui.Add("GroupBox", "x30 y160 w500 h240", "运行输出")
runOutput := myGui.AddText("x60 y190","Output Here")
Radio1.OnEvent("Click", OnEventHandler)
Radio2.OnEvent("Click", OnEventHandler)
Edit1.OnEvent("Change", OnEventHandler)
ogcButton.OnEvent("Click", OnEventHandler)
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "ScrcpyGui 0.1 (Clone)"
myGui.Show()

MenuHandler(*)
{
;	ToolTip("Click! This is a sample action.`n", 77, 277)
;	SetTimer () => ToolTip(), -3000 ; tooltip timer
}

OnEventHandler(*)
{
;	ToolTip("Click! This is a sample action.`n"
;	. "Active GUI element values include:`n"
;	. "Radio1 => " Radio1.Value "`n"
;	. "Radio2 => " Radio2.Value "`n"
;	. "Edit1 => " Edit1.Value "`n"
;	. "ogcButton => " ogcButton.Text "`n"
;	. "ogcButton => " ogcButton.Text "`n"
;	. "ogcButton => " ogcButton.Text "`n", 77, 277)
;	SetTimer () => ToolTip(), -3000 ; tooltip timer
}
