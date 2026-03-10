; Keep variables in here as constants even though we could map the WRAM section directly
; Makes it easier to name things for reference without worrying about conflicts, but it does make debugging a bit harder

DEF    MenuStateCounter   EQU $c6c7
DEF    MenuStateIndex     EQU $c6c8
DEF    MenuStateSubIndex  EQU $c6c9

DEF    MainMenuPosition   EQU $c6f0
DEF    InfoMenuPosition   EQU $c6f1

DEF    TempStateIndex   EQU $c750 ; Used for various asynchronous operations (e.g. for exiting the menu)