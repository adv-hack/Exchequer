unit EntMenuU;

{ prutherford440 15:10 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Menu Customisation Unit - Allows standard Enterprise menus to be modified }

interface

Uses Forms, Menus;

Type

  {$I CustMenu.Pas }

Procedure CustomMenus (EntInfo : ptrEntCustomInfo); Export;
Procedure CloseCustomMenus; Export;

implementation

Uses ChainU;

Var
  OldApp      : TApplication;
  OldScr      : TScreen;

{ Called by the FormCreate of the applications main form }
Procedure CustomMenus (EntInfo : ptrEntCustomInfo);
Begin
  { link in to the EXE's application instance }
  OldApp := Application;
  Application := EntInfo^.AppInst;

  { Link in to the EXE's screen instance }
  OldScr := Screen;
  Screen := EntInfo^.ScrnInst;

  { Customise menus here }


  DLLChain.CustomMenus (EntInfo);
End;

{ Called by Enterprise during shutdown }
Procedure CloseCustomMenus;
Begin

  { Deallocate memory here }

  If Assigned (OldApp) Then Begin
    Application := OldApp;
    OldApp := Nil;
  End; { If }

  { Restore the original Screen Instance }
  If Assigned (OldScr) Then Begin
    Screen := OldScr;
    OldScr := Nil;
  End; { If }

  { call next dll in chain }
  DLLChain.CloseCustomMenus;
End;


Initialization
  OldApp := Nil;
  OldScr := Nil;
Finalization
  If Assigned (OldApp) Then Application := OldApp;
  If Assigned (OldScr) Then Screen := OldScr;
end.
