RunTerminal(CmdLine, WorkingDir:="", Codepage:="CP0", Fn:=(Line,Index)=>Line) {
  Global A_Args
  DllCall("CreatePipe", "PtrP",&hPipeR:=0, "PtrP",&hPipeW:=0, "Ptr",0, "Int",0)
, DllCall("SetHandleInformation", "Ptr",hPipeW, "Int",1, "Int",1)
, DllCall("SetNamedPipeHandleState","Ptr",hPipeR, "UIntP",&PIPE_NOWAIT:=1, "Ptr",0, "Ptr",0)

, P8 := (A_PtrSize=8)
, SI:=Buffer(P8 ? 104 : 68, 0)                          ; STARTUPINFO structure
, NumPut("UInt", P8 ? 104 : 68, SI)                                     ; size of STARTUPINFO
, NumPut("UInt", STARTF_USESTDHANDLES:=0x100, SI, P8 ? 60 : 44)  ; dwFlags
, NumPut("Ptr", hPipeW, SI, P8 ? 88 : 60)                              ; hStdOutput
, NumPut("Ptr", hPipeW, SI, P8 ? 96 : 64)                              ; hStdError
, PI:=Buffer(P8 ? 24 : 16)                              ; PROCESS_INFORMATION structure

  If not DllCall("CreateProcess", "Ptr",0, "Str",CmdLine, "Ptr",0, "Int",0, "Int",True
                ,"Int",0x08000000 | DllCall("GetPriorityClass", "Ptr",-1, "UInt"), "Int",0
                ,"Ptr",WorkingDir ? StrPtr(WorkingDir) : 0, "Ptr",SI.ptr, "Ptr",PI.ptr)
     Return Format("{1:}", "", -1
                   ,DllCall("CloseHandle", "Ptr",hPipeW), DllCall("CloseHandle", "Ptr",hPipeR))

  DllCall("CloseHandle", "Ptr",hPipeW)
, A_Args.RunTerminal := { PID: NumGet(PI, P8 ? 16 : 8, "UInt") }
, File0 := FileOpen(hPipeR, "h", Codepage)

, LineNum := 1,  sOutput := "" , ExitCode := 0
  While (A_Args.RunTerminal.PID + DllCall("Sleep", "Int",0))
    and DllCall("PeekNamedPipe", "Ptr",hPipeR, "Ptr",0, "Int",0, "Ptr",0, "Ptr",0, "Ptr",0)
        While A_Args.RunTerminal.PID and !File0.AtEOF
			Line := File0.ReadLine(), sOutput .= Fn(Line, LineNum++)
  A_Args.RunTerminal.PID := 0
, hProcess := NumGet(PI, 0, "Ptr")
, hThread  := NumGet(PI, A_PtrSize, "Ptr")
, DllCall("GetExitCodeProcess", "Ptr",hProcess, "PtrP",&ExitCode)
, DllCall("CloseHandle", "Ptr",hProcess)
, DllCall("CloseHandle", "Ptr",hThread)
, DllCall("CloseHandle", "Ptr",hPipeR)

Return {StdOut: sOutput,ExitCode: ExitCode}
}
