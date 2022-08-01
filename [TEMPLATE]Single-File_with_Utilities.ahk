;=============================================================================;
;=======| AHK  SCRIPT  TEMPLATE |====================| By: JaydenS115 |=======;
;=============================================================================;
;=| Description:  Template for AutoHotkey Scripts. Includes formatting,     |=;
;=|               initialization of common settings, and script utilities.  |=;
;=============================================================================;

;#include <ExampleLib>
GoSub, INIT_SETTINGS
GoSub, INIT_GLOBAL_CONSTRUCTS
return  ; END - Auto-execute Section

;~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~;
;------- GLOBAL CONSTRUCTS ---------------------------------(AUTO-EXEC)-------;
INIT_GLOBAL_CONSTRUCTS:


return  ; END - Global Construct Initialization

;~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~;
;------- MAIN SECTION --------------------------------------------------------;




;~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~;
;------- FUNCTION DEFINITIONS ------------------------------------------------;




;~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~;
;------- SCRIPT UTILITIES ----------------------------------------------------;

; Quick Suspend Toggle & Emergency Exit  --  Alt+Esc
;     Press to toggle Suspend of the script, double-tap to Exit script.
$!Esc::
	Suspend, Permit  ; (this thread is exempt from suspension,
	Critical, On     ;  and will not be interrupted)
	
	KeyWait, Esc, T0.20     ; check for double-tap of Escape
	if( !ErrorLevel ) {
		KeyWait, Esc, T0.20 D
		if( !ErrorLevel ) {  ; if successful double-tap,
			SoundPlay, %A_WinDir%\Media\chord.wav, WAIT
			ExitApp -1       ; terminate the script
		}
	}
	
	if( !A_IsSuspended ) {       ; If script not currently suspended,
		Suspend, On              ;     suspend hotkeys,
		Critical, Off            ;
		OnSuspend(true)          ;     and notify any relevant constructs
	} else {                     ; Else,
		Suspend, Off             ;     re-enable hotkeys,
		Critical, Off            ;
		OnSuspend(false)         ;     and notify any relevant constructs
	}

	KeyWait, Esc  ; Avoid hold-repeat behavior of ESC key
return


; OnSuspend ( bool )  --  Can be called when performing a controlled suspend,
;                         to notify any constructs within this definition.
;                         Parameter indicates new Suspend state (true == On)
OnSuspend( _NewSuspendState )
{ 	global  ; Assume-global mode
	/*
		Any actions to do upon Suspend / Un-Suspend go here
	*/
return
}

;~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~;
;------- SETTING INITIALIZATION ----------------------------(AUTO-EXEC)-------;
INIT_SETTINGS:
 #Requires AutoHotkey v1.1.34+

 Edit           ; Automatically open script in editor
;#KeyHistory 0  ; Disable key history
 #NoEnv         ; Avoid checking if empty variables are environment variables
 #Persistent    ; Script runs until explicitly stopped
 #SingleInstance Force  ; Automatically replace old script instances
 #UseHook On    ; Use keyboard hook by default (unless explicitly disabled)
 #Warn All      ; Enable all warnings, shown as default in message box
 SetWorkingDir, %A_ScriptDir%  ; Ensures a consistent starting directory

 SendMode, Input       ; Send == SendInput
 SetBatchLines, 10ms   ; Execution Rate := [default]
 SetControlDelay, 20   ; Control Delay  := [default]
 SetKeyDelay,          ; Key Delay      := [default]
 SetMouseDelay, 10     ; Mouse Delay    := [default]
 SetTitleMatchMode, 2  ; WinTitle match if it contains the substring anywhere

return  ; END - Setting Initialization

;~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~;
;~=~=~=~| https://github.com/JaydenS115 |~=~=~=~=~=~=~=~| 01 AUG 2022 |~=~=~=~;
;~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~;