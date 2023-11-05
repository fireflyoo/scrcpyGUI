<!-- :: Batch section
@echo off
    chcp 65001
    setlocal enableextensions disabledelayedexpansion
    rem Defined which tokens we need and the delimiter between them
    for /F "tokens=1,2 delims=|" %%a in ('mshta.exe "%~F0"') do (
        set "CMD=%%a"
        set "Option=%%b"
    )
 @echo on
    %CMD% %Option% || PAUSE
goto :EOF
-->
<html>
<head>
    <HTA:APPLICATION SCROLL="yes" SYSMENU="no" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv=content-type content='charset=utf-8' />
    <meta http-equiv=msthemecompatible content=yes />
    <title>HTA Buttons</title>
    <script language="JScript">
    window.resizeTo(450,620);
    function execExit(cmd,option) {
        new ActiveXObject("Scripting.FileSystemObject")
            .GetStandardStream(1)
            .WriteLine(
                [ // Array of elements to return joined with the delimiter
                      cmd
                    , option
                ].join('|')
            );
        window.close();
    }
    function exec(command){
        var shell = new ActiveXObject("WScript.Shell"),
        exec = shell.Exec(command);
        return { Out: exec.StdOut.ReadAll(),
		         Err: exec.StdErr.ReadAll()
				 }
    }
	function getOptions() {
		var result=[];
		for(var i=0;i<options.length;i++){
			result.push(options[i].value)
		} 
		return " "+result.join(" ")
	}
	function wireless() {
		var result=execExit('scrcpy --tcpip='+IP.value,getOptions())
		out.innerText=result.Out
		err.innerText=result.Err
		}
	function refreshDevicesList() {
		var ls_devices=exec("adb devices").Out.split("\r\n").slice(1,-2).map(function (line){return line.split(/\s/)[0]})
		devices.options.length=0;
		ls_devices.forEach(function(item){
			devices.add(new Option(item,item))
		})
		if(devices.options.length!=0)devices.options[0].selected = true
	}
	function fromUsbToWifi() {
		var result=execExit('scrcpy -d --tcpip',getOptions())
		out.innerText=result.Out
		err.innerText=result.Err
	}

	window.onload = function () {
		refreshDevicesList();
		refresh.onclick=refreshDevicesList
	// /*Debug*/	out.innerText=ls_devices+ls_devices.length
		close_window.onclick=function () {
			window.close();
		}
		usb2wifi.onclick=fromUsbToWifi;
		launch.onclick=function() {
			var result=execExit('scrcpy -s '+devices.value,getOptions())
			out.innerText=result.Out
			err.innerText=result.Err
		}
		start.onclick=wireless;
	}
    </script>
    <style>
        *{color:gray}
		select{width:250px}
        button{background-color:black; border-color:white}
    </style>
</head>
<body bgcolor="black">
    <h1 style="font-size:40px;">Scrcpy</h1>   
    <hr>
    <button id="usb2wifi">一键无线</button>
    <button id="close_window">close</button>
    <hr>
	<br>
	<h3>Connect from IP</h3>
    <input type="text" id="IP"  placeholder="192.168.1.123:4567">
    <button id="start">Start</button><br>
	<h3>Connect from Device</h3>
	<select id="devices" size=5 ><select><br>
	<button id="launch">Launch</button><button id="refresh">Refresh</button>
	<fieldset>
    <legend>配置</legend>
    <input type="checkbox" name="options" value="--turn-screen-off" checked><lable>自动息屏</lable>
    <input type="checkbox" name="options" value="--stay-awake" checked><lable title="只在USB有线下有效">保持唤醒</lable>
	<input type="checkbox" name="options" value="--power-off-on-close" checked><lable title="">关后息屏</lable>
    <input type="checkbox" name="options" value="--always-on-top" checked><lable title="">窗口置顶</lable>
    </fieldset>
    <pre id="out"></pre>
	<pre id="err"></pre>
</body>
</html>
