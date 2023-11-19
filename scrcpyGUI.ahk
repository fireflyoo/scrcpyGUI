#Requires Autohotkey v2
#Include <ReadRun>
#SingleInstance
#Warn
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
SB := myGui.AddStatusBar( , "共有-1个设备在线。")
Tab := myGui.Add("Tab3", "x11 y6 w534 h477", ["镜像管理", "镜像配置", "结果输出"])
Tab.UseTab(1)
/*
GUI Option
绝对位置
x10 y10
xm+10 ym+10 ;考虑边缘留白

相对位置--以上一个控件为基准
x+10 y+10 右下相对位置
xp+10 yp+10 左上相对位置

相对位置--以Option里含Section的控件为基准
xs+10 ys+10 左上相对位置
*/
myGui.AddGroupBox("xm+10 ym+25 w500 h80", "无线连接")
t1IP := myGui.AddEdit("xp+5 yp+20 w200 r1")
t1Start := myGui.AddButton("xp y+5 +Default","连接")
t1Pair := myGui.AddButton("x+5 yp","配对")
myGui.AddGroupBox( "xm+10 y+20 w500 h185 Section", "设备清单")
LV := myGui.AddListView( "xp+5 yp+20 w485 r5",["SN","online","product","model","device","id"])
t1LaunchBTN := myGui.AddButton( "xp y+5 w80 h23", "投屏")
t1RefreshBTN := myGui.AddButton( "x+5 yp w80 h23", "刷新")
t1SwitchWifi := myGui.AddButton("x+5 yp w80 h23", "一键无线")
t1DeleteBTN := myGui.AddButton( "x+5 yp w80 h23", "删除")
CheckBox := []
CheckBox.push myGui.Add("CheckBox", "xs+5 y+5 h20 valways-on-top", "窗口置顶")
CheckBox.push myGui.Add("CheckBox", "x+5 yp h20 vno-control","禁止操控")
CheckBox.push myGui.Add("CheckBox", "x+5 yp h20 vno-audio", "禁投音频")
CheckBox.push myGui.Add("CheckBox", "x+5 yp h20 vturn-screen-off checked", "自动息屏")
CheckBox.push myGui.Add("CheckBox", "x+5 yp h20 vpower-off-on-close", "关后息屏")
CheckBox.push myGui.Add("CheckBox", "x+5 yp h20 vstay-awake", "保持唤醒")
t1Output := myGui.AddEdit("xm+10 y+15 w500 r10 ReadOnly")
Tab.UseTab(2)
myGui.AddGroupBox( "x30 ym+25 w500 h400 Section", "连接配置")


t2Options := myGui.Add("Edit", "x40 y440 w400", "")
Tab.UseTab(3)
myGui.AddGroupBox("x30 y30 w500 h100", "运行测试")
SB.SetParts(165,165), SB.SetText("`t<Esc> Cancel/Clear", 1),  SB.SetText("`t<Enter> ReadRun", 2)
t3Input := myGui.AddEdit("x60 y60 w300")
;t3Button := myGui.AddButton("Default","  运行  ")
t3Button := myGui.AddButton("","  运行  ")
t3Button2 := myGui.Addbutton("x+5 yp","终止/清空")
t3Output := myGui.AddEdit("x30 y160 w500 -Wrap +HScroll R20 ReadOnly")
t1RefreshBTN.OnEvent("Click",refreshDevices)
t3Button2.OnEvent("Click",myGui_StopOrClear)
t3Input.OnEvent("Focus",(*)=>t3Button.Opt("+Default"))
t3Input.OnEvent("LoseFocus",(*)=>t3Button.Opt("-Default"))
; myGui.AddGroupBox( "x30 y160 w500 h240", "运行输出")
t1IP.OnEvent("Focus",(*)=>t1Start.Opt("+Default"))
t1IP.OnEvent("LoseFocus",(*)=>t1Start.Opt("-Default"))
t1Start.OnEvent("Click",(*)=>RunCMDGUI("scrcpy --tcpip=" . t1IP.Text . Options(),t1Output))
t1Pair.OnEvent("Click",(*)=>RunCMDGUI("adb pair " . t1IP.Text,t1Output))
t1LaunchBTN.OnEvent("Click", LV_Launch02)
t1SwitchWifi.OnEvent("Click",LV_SwitchWifi)
t1DeleteBTN.OnEvent("Click",LV_Delete)
LV.OnEvent("DoubleClick",LV_Launch)
t3Button.OnEvent("Click",(*) => RunCMDGUI(t3Input.Text,t3Output))
myGui.OnEvent('Close', (*) => ExitApp())
myGui.OnEvent("Escape", myGui_StopOrClear)
myGui.Title := "ScrcpyGui 0.2"
myGui.Show()
init()
Options() {
  result:=""
  for option in CheckBox {
    if option.value {
      result .= A_Space . "--" . option.Name
    }
  }
  return result
}
init(){

  RunCMDGUI("adb start-server",t1Output)
  refreshDevices()
}
LV_Delete(*){
  text:=ListViewGetContent("Selected Col1",LV)

  RunCmdGUI("adb disconnect " . text,t1Output)
  rowNum:=LV.GetNext(0,"Focused")
  LV.Delete(rowNum)
;  LV.Delete
}
LV_Launch(myGUI,rowNum){
;  MsgBox LV.GetText(rowNum)
  text:=LV.GetText(rowNum)
  RunCMDGUI("scrcpy -s " . text . Options(),t1Output)
}
LV_Launch02(*){
;  MsgBox LV.GetText(rowNum)
  text:=ListViewGetContent("Selected Col1",LV)

  RunCmdGUI("scrcpy -s " . text . Options(),t1Output)
}

LV_SwitchWifi(*){
  text:=ListViewGetContent("Selected Col1",LV)

  out:=RunCMD("adb -s " . text . " shell ip route")
  RunCMDGUI("adb -s " . text . " tcpip 5555",t1Output)
  pos:=InStr(out,A_Space,1,,-2)
  ip:=SubStr(out,pos+1)
 RunCmdGUI("scrcpy" . Options() . " --tcpip=" . ip,t1Output)
;  RunCmdGUI("scrcpy -s " . text . " --tcpip" . Options(),t1Output)
}
refreshDevices(*){
  LV.Delete()
  for line in ReadRun("adb devices -l") {

    if (A_Index>1 and line!="") {
      Pos:=instr(line,A_Space)
      SN:=substr(line,1,Pos-1)
      line:=LTrim(substr(line,Pos))
      arr:=StrSplit(line,A_Space)
      for field in arr {
        if (A_Index>1)
          arr[A_Index]:=StrSplit(arr[A_Index],":")[2]
      }
      LV.add(,SN,arr*)
    }

 }
 LV.ModifyCol(1,"Auto")
 LV.ModifyCol(4,"Auto")
 LV.ModifyCol(5,"Auto")
}

RunCmdGUI(Cmd,OutputEdit)
{

  SB.SetText("Running...", 3)

  SendMessage 0xB1, -2, -1, OutputEdit   ;光标定位到输出框末尾
  EditPaste("> " . Cmd . "`r`n",OutputEdit)
  for line in ReadRun(A_Comspec . " /c " . Cmd) {
    EditPaste(line . "`r`n",OutputEdit)
  }

  SB.SetText("`tExitCode : " ReadRun.ExitCode, 3)
Return                                                            ; end of auto-execute section
}
myGui_StopOrClear(*){
  t3Input.Focus()
  If(ReadRun.PID) {
    ReadRun.PID := 0
    Return
  }
  SB.SetText("",3)
  t3Input.Value := ""
  t3Output.Value := ""
}
MenuHandler(*){
}
