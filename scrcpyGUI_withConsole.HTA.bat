<!-- :: Batch section
@echo off
    chcp 65001
    setlocal enableextensions disabledelayedexpansion
:start
    rem Defined which tokens we need and the delimiter between them
    for /F "tokens=1,2 delims=|" %%a in ('mshta.exe "%~F0"') do (
        set "IP=%%a"
        set "Option=%%b"
    )
 @echo on
    scrcpy --tcpip=%IP% %Option%
    goto start
-->
<!DOCTYPE html>
<HTML><HEAD>
<HTA:APPLICATION SCROLL="no" SYSMENU="no" >
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv=content-type content='charset=utf-8' />
<meta http-equiv=msthemecompatible content=yes />
<TITLE>Scrcpy</TITLE>
<SCRIPT language="JavaScript">
    window.resizeTo(374,400);
    function callShellApplication(command){
        var shell = new ActiveXObject("WScript.Shell"),
        exec = shell.Exec(command);

        output.innerHTML = exec.StdOut.ReadAll().replace(/\r\n/g, '<br>');
		error.innerHTML = exec.StdErr.ReadAll().replace(/\r\n/g,'<br>');
    }
    function wireless() {
        new ActiveXObject("Scripting.FileSystemObject")
            .GetStandardStream(1)
            .WriteLine(
                [ // Array of elements to return joined with the delimiter
                      document.getElementById("IP").value
                    , (checkbox0.checked ? checkbox0.value:'')+' '+(checkbox1.checked ? checkbox1.value : '')
                ].join('|')
            );
        window.close();
    };
    window.onload=function () {

}
</SCRIPT>
</HEAD>
<BODY>
   <h3>SCRCPY</h3>
    <input id="IP"  list="IPS">
    <datalist id="IPS">
		<option value="scaner02"/>
		<option value="scaner03"/>
		<option value="alioth"/>
    </datalist>
   <fieldset>
    <legend>配置</legend>
    <input type="checkbox" id="checkbox0" value="--turn-screen-off" checked><lable>自动息屏</lable>
    <input type="checkbox" id="checkbox1" value="--stay-awake" checked><lable title="只在USB有线下有效">保持唤醒</lable>
    </fieldset>
    <button onclick="wireless()">无线连接启动</button>

    <fieldset >
    </fieldset>
</BODY>
</HTML>