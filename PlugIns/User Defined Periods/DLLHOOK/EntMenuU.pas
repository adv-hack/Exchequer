unit EntMenuU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, Menus, IniFiles, APIUtil, StrUtil, MenuProc, IncludeCustMenu;

Procedure CustomMenus (EntInfo : ptrEntCustomInfo); Export;
Procedure CloseCustomMenus; Export;

implementation

Uses
  {MenuManager, ToolProc,} ChainU;

{ Called by the FormCreate of the applications main form }
Procedure CustomMenus (EntInfo : ptrEntCustomInfo);
Var
  TmpItem : TMenuItem;
  I       : Integer;
  ErrMsg, Capt : ANSIString;
Begin
  { link in to the EXE's application instance }
  OldApp := Application;
  Application := EntInfo^.AppInst;

  { Link in to the EXE's screen instance }
  OldScr := Screen;
  Screen := EntInfo^.ScrnInst;

  gEntInfo := EntInfo^;

  { Customise menus here }
//  RWMenuManager.mmMainMenu := EntInfo.EntMenus;
//  RWMenuManager.mmNewMenuFunc := EntInfo.NewMenu;

  DLLChain.CustomMenus (EntInfo);
End;

{ Called by Enterprise during shutdown }
Procedure CloseCustomMenus; Export;
Begin
//  slUsers.Free;
  slCompanies.Free;

  { Restore the original Application Instance }
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
  { Initialise the temporary application handle so we can tell if its been set }
  OldApp := Nil;
  OldScr := Nil;
//  frmMenuDesigner := nil;

Finalization
  { free the menu event object and restore the DLL's application instance }
  If Assigned (EntMenuObj) Then EntMenuObj.Free;
  If Assigned (OldApp) Then Application := OldApp;
  If Assigned (OldScr) Then Screen := OldScr;
end.
