{ Declaration of the NewMenuItem function type }
NewMenuFunc = Function (MenCap, MenName : ShortString) : TMenuItem Of Object;

{ Structure passed into Custom Menus }
ptrEntCustomInfo = ^EntCustomInfo;
EntCustomInfo = Record
  AppInst  : TApplication;           { Enterprise Application Instance }
  EntMenus : TMainMenu;              { Enterprise Main Menu object }
  NewMenu  : NewMenuFunc;            { Function to return new menu option }
  ScrnInst : TScreen;                { Enterprise Screen Instance }
  Spare    : Array [1..1004] Of Char;{ Reserved for future use }
End; { EntCustomInfo }


{ Procedures to setup in dll:                                   }
{                                                               }
{   Procedure CustomMenus (EntInfo : ptrEntCustomInfo); Export; }
{   Procedure CloseCustomMenus; Export;                         }

