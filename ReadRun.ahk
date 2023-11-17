ReadRun.PID := 0
ReadRun.ExitCode := unset

; compatible with Classic Style
RunCMD(CmdLine,Fn:=(line,index)=>line,joiner:="`r`n") {
    output:=""
    for line in ReadRun(CmdLine) {
        join := A_Index!=1 ? joiner : ""
        output .= join . Fn(line,A_index)
    }
    return output
}
ReadRun(P_CmdLine, P_WorkingDir := "", P_Codepage := "CP0", P_Slow := 1)
{
;  Modified from RunCMD Temp_v0.99 for ah2 By SKAN on D532/D67D @ autohotkey.com/r/?p=448912

;    Local  CRLF                  :=  Chr(13) Chr(10)
         hPipeR                :=  0
         hPipeW                :=  0
         PIPE_NOWAIT           :=  1
         HANDLE_FLAINHERIT   :=  1
         dwMask                :=  HANDLE_FLAINHERIT
         dwFlags               :=  HANDLE_FLAINHERIT

    DllCall("CreatePipe", "ptrp",&hPipeR, "ptrp",&hPipeW, "ptr",0, "int",0)
    DllCall("SetHandleInformation", "ptr",hPipeW, "int",dwMask, "int",dwFlags)
    DllCall("SetNamedPipeHandleState", "ptr",hPipeR, "uintp",PIPE_NOWAIT, "ptr",0, "ptr",0)

      B_OK                  :=  0
      P8                    :=  A_PtrSize=8
      STARTF_USESTDHANDLES  :=  0x100
;      STARTUPINFO
;      PROCESS_INFORMATION

    PROCESS_INFORMATION          :=  Buffer(P8 ?  24 : 16, 0)                  ;  PROCESS_INFORMATION
    STARTUPINFO                  :=  Buffer(P8 ? 104 : 68, 0)                  ;  STARTUPINFO

    NumPut("uint", P8 ? 104 : 68, STARTUPINFO)                                 ;  STARTUPINFO.cb
    NumPut("uint", STARTF_USESTDHANDLES, STARTUPINFO, P8 ? 60 : 44)            ;  STARTUPINFO.dwFlags
    NumPut("ptr",  hPipeW, STARTUPINFO, P8 ? 88 : 60)                          ;  STARTUPINFO.hStdOutput
    NumPut("ptr",  hPipeW, STARTUPINFO, P8 ? 96 : 64)                          ;  STARTUPINFO.hStdError

      CREATE_NO_WINDOW      :=  0x08000000
      PRIORITY_CLASS        :=  DllCall("GetPriorityClass", "ptr",-1, "uint")

    B_OK :=  DllCall( "CreateProcessW"
                    , "ptr", 0                                                 ;  lpApplicationName
                    , "ptr", StrPtr(P_CmdLine)                                 ;  lpCommandLine
                    , "ptr", 0                                                 ;  lpProcessAttributes
                    , "ptr", 0                                                 ;  lpThreadAttributes
                    , "int", True                                              ;  bInheritHandles
                    , "int", CREATE_NO_WINDOW | PRIORITY_CLASS                 ;  dwCreationFlags
                    , "int", 0                                                 ;  lpEnvironment
                    , "ptr", DirExist(P_WorkingDir) ? StrPtr(P_WorkingDir) : 0 ;  lpCurrentDirectory
                    , "ptr", STARTUPINFO                                       ;  lpStartupInfo
                    , "ptr", PROCESS_INFORMATION                               ;  lpProcessInformation
                    , "uint"
                    )

    DllCall("CloseHandle", "ptr",hPipeW)

    If  Not B_OK {
        DllCall("CloseHandle", "ptr",hPipeR)
        return  (&line)=>false

    }
    ReadRun.PID := NumGet(PROCESS_INFORMATION, P8 ? 16 : 8, "uint")

    ;  FileObj
    ;  Line                  :=  ""
    ;  LineNum               :=  1
      ExitCode :=  0

    FileObj  :=  FileOpen(hPipeR, "h", P_Codepage)
    P_Slow   :=  !! P_Slow

    Sleep_() =>  (Sleep(P_Slow), ReadRun.PID)

   state:=DllCall("PeekNamedPipe", "ptr",hPipeR, "ptr",0, "int",0, "ptr",0, "ptr",0, "ptr",0)
Fn(&Line) {
    while   state and   Sleep_() {
            if  ReadRun.PID and not FileObj.AtEOF {
                   Line           :=  FileObj.ReadLine()

                   return true
                 } else if FileObj.AtEOF {
                    state:=DllCall("PeekNamedPipe", "ptr",hPipeR, "ptr",0, "int",0, "ptr",0, "ptr",0, "ptr",0)
                 }
   }
    hProcess := NumGet(PROCESS_INFORMATION, 0, "ptr")
    hThread  := NumGet(PROCESS_INFORMATION, A_PtrSize, "ptr")
    DllCall("GetExitCodeProcess", "Ptr",hProcess, "PtrP",&ExitCode)
    DllCall("CloseHandle", "ptr",hProcess)
    DllCall("CloseHandle", "ptr",hThread)
    DllCall("CloseHandle", "ptr",hPipeR)
    ReadRun.PID:=0
    ReadRun.ExitCode:=ExitCode
    return false
}
return Fn
}
