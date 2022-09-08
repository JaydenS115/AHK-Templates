;=============================================================================;
;=======| AHK  SCRIPT  TEMPLATE  v2 |================| By: JaydenS115 |=======;
;=============================================================================;
;=| Description:  Template for AutoHotkey v2 Scripts. Includes formatting,  |=;
;=|               initialization of common settings, and script utilities.  |=;
;=============================================================================;

#Requires AutoHotkey v2.0-
;#Include <ExampleLibrary>

;~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~;
;------- GLOBAL CONSTRUCTS ---------------------------------------------------;




;~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~;
;------- MAIN SECTION --------------------------------------------------------;




;~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~;
;------- FUNCTION & CLASS DEFINITIONS ----------------------------------------;




;~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~;
;------- SCRIPT UTILITIES ----------------------------------------------------;

; NotifyOfSuspend ( )  --  Can be called after performing a Suspend command to
;                          notify constructs within this function definition.
;                          Use  A_IsSuspended  to retrieve the Suspend state.
NotifyOfSuspend()
{	global  ; Assume-global mode
    /*
        Any actions to do upon Suspend / Un-Suspend can go here

        This function is called whenever the Quick Suspend Toggle Hotkey
        (described below) is used to change the script's Suspend state
    */

}

; Alt+Esc [by default]  --  Quick Suspend Toggle / Emergency Exit Hotkey
 Hotkey_QuickSuspendOrExit  :=  "$!Esc"
;                           Press to toggle Suspend of the script,
;                           hold to Exit script.
#HotIf
Hotkey(Hotkey_QuickSuspendOrExit, SuspendToggleAndNotify, "On S P9999")

SuspendToggleAndNotify( ThisHotkey := "" )
{                   ; this hotkey is exempt from suspension,
    Critical("On")  ; and will not be interrupted

    static keyNameNoModifiers := StrSplit( Hotkey_QuickSuspendOrExit
                                 , " &" , "#!^+&<>*~$" , 2 ).Get(1, "Esc")

    if(ThisHotkey)  ; If this function is called by hotkey
    {
        keyReleased := KeyWait(keyNameNoModifiers, "T1")

        ; check for hold of hotkey to exit
            ; hold duration == 1 second
        if( !keyReleased )
        {
            Suspend(true)  ; Suspend hotkeys while exiting
            if( UTIL_QuickExitSound )
                SoundPlay(A_WinDir . "\Media\Speech Off.wav", "WAIT")
            Send("{Blind}{" . keyNameNoModifiers . " up}{Alt up}{Ctrl up}")
            ExitApp(-1)    ; If key held, terminate the script
        }
    }

    Suspend()        ; Toggle suspend status on single-press
    Critical("Off")  ; Now allow this thread to be interrupted

    ; Audio on Suspend toggle
    if( UTIL_QuickSuspendSound ) {
        if( A_IsSuspended ) {
            SoundPlay(A_WinDir . "\Media\Speech Sleep.wav")
        } else {
            SoundPlay(A_WinDir . "\Media\Speech On.wav")
        }
    }

    NotifyOfSuspend()  ; Notify any relevant constructs of new suspend status

    ; Suspended Overlay - shows a translucent message when script suspended
    if( UTIL_ShowSuspendOSD ) {
        static UTIL_SuspendOSD := ""
        if( !UTIL_SuspendOSD ) {  ; Create overlay window on first suspend
            UTIL_SuspendOSD := NewOSDWindow(UTIL_SuspendOSD_Alpha)
            UTIL_SuspendOSD.Add( "Text", "c000000 BackgroundFFFFFF"
                               . " Center +Border vText"
                               , " Suspended - " . A_ScriptName . " " )

            _SuspendOSDTextWidth := ""
            ControlGetPos(,, &_SuspendOSDTextWidth,, Util_SuspendOSD["Text"] )
            Util_SuspendOSD["Text"].Move( UTIL_SuspendOSD_XPos
                                          - _SuspendOSDTextWidth/2
                                        , UTIL_SuspendOSD_YPos )
        }
        if( A_IsSuspended ) {  ; Toggle visibility based on suspend state
            UTIL_SuspendOSD.Show("NoActivate")
        } else {
            UTIL_SuspendOSD.Hide()
        }
    }  ; End - Suspended Overlay code segment

    if(ThisHotkey)  ; If this function is called by hotkey
        KeyWait(keyNameNoModifiers)  ; Avoid any hold-to-repeat key behavior
}


; NewOSDWindow ( ControlAlpha )  --  Creates a transparent, always-on-top
;                                    display window, for showing
;                                    graphics and other controls.
;                                    Returns the new window object.
NewOSDWindow( ControlAlpha := 255 )
{
    ControlAlpha := Clamp( ControlAlpha, 0, 255 )

    OSDWindow := Gui( "+AlwaysOnTop -Caption +Disabled -DPIScale"
                    . " +LastFound -SysMenu +ToolWindow +E0x20" )
    OSDWindow.BackColor := 0x808080
    WinSetTransColor( Format("{1} {2}", OSDWindow.BackColor, ControlAlpha)
                    , OSDWindow )
    OSDWindow.Show("Hide x0 y0 w" . A_ScreenWidth . " h" . A_ScreenHeight)

    return  OSDWindow
}


; Clamp ( value , min , max )  --  Returns a value clamped between given
;                                  minimum and maximum numbers. Returns the
;                                  given value if it is between min and max.
Clamp( _Value, _Min, _Max )
{
    if( _Min   > _Max )
        Swap(_Min, _Max)
    if( _Value < _Min )
        return _Min
    if( _Value > _Max )
        return _Max
    return  _Value
}

; Swap ( var1 , var2 )  --  Swaps the values of the two arguments given.
Swap( &Var1, &Var2 )
{
    temp := Var1
    Var1 := Var2
    Var2 := temp
}


;~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~;
;------- SETTING INITIALIZATION ----------------------------------------------;

 Edit           ; Automatically open script in editor (useful when testing)
;KeyHistory 0   ; Disable key history
 Persistent     ; Script runs until explicitly stopped
 #SingleInstance Force   ; Automatically replace old script instances
 #Warn          ; Enable all warnings, shown as default in message box

 SendMode "Input"       ; Send == SendInput
 SetControlDelay   20   ; Control Delay  := default
 SetKeyDelay     0, 0   ; Key Delay      := smallest delay, smallest duration
 SetMouseDelay      0   ; Mouse Delay    := smallest delay
 SetTitleMatchMode  2   ; WinTitle match if contains substring anywhere

UTIL_QuickSuspendSound  := true   ; Play a sound when quick-suspend toggling
UTIL_QuickExitSound     := true   ; Play a sound when quick-exiting

UTIL_ShowSuspendOSD     := true   ; Show a visual overlay when suspended
UTIL_SuspendOSD_XPos    := (A_ScreenWidth  /  2)
UTIL_SuspendOSD_YPos    := (A_ScreenHeight - 25)
UTIL_SuspendOSD_Alpha   := 128


;~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~;
;~=~=~=~| https://github.com/JaydenS115 |~=~=~=~=~=~=~=~| 08 SEP 2022 |~=~=~=~;
;~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~;