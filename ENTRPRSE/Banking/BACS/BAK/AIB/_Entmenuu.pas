unit EntMenuU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, IniFiles;

Type
  {$I CustMenu.Pas}

  TTestMenuObj = Class(TObject)
    IniOptions : TIniFile;

    hEntMenu   : TMainMenu;
    hNewMenu   : NewMenuFunc;

    TestMenu  : TMenuItem;

    Constructor Create;
    Destructor  Destroy; Override;
    procedure CreateOptsMenu;
    procedure AddTestOptions;
    { menu event handlers }
    procedure MenuOpt_Test_OptionsClick(Sender: TObject);
  End; { TestMenuObj }


Procedure CustomMenus (EntInfo : ptrEntCustomInfo); Export;
Procedure CloseCustomMenus; Export;


implementation

Uses ChainU;

Var
  TestMenuObj  : TTestMenuObj;
  OldApp      : TApplication;
  OldScr      : TScreen;


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

  Try
    { Create object containing menu event handlers }
    TestMenuObj := TTestMenuObj.Create;

    With TestMenuObj Do Begin
      { Take local copy of Enterprise handles }
      hEntMenu := EntInfo^.EntMenus;
      hNewMenu := EntInfo^.NewMenu;

      { create tools menu }
      CreateOptsMenu;
      AddTestOptions;
    End; { With }
  Except
    { handle any exceptions }
    On Ex:Exception Do Begin
      ErrMsg := 'The following error occured in the Menu Customisation:' + #10#13#10#13 + '''' + Ex.Message + '''.';
      Capt := 'Error in ' + DLLChain.ModuleName + '.DLL';
      Application.MessageBox (PCHAR(ErrMsg),
                              PCHAR(Capt),
                              (MB_OK Or MB_ICONSTOP));

    End; { On }
  End;

  DLLChain.CustomMenus (EntInfo);
End;

{ Called by Enterprise during shutdown }
Procedure CloseCustomMenus; Export;
Begin
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


{------------------------------------------------------------------------------}

Constructor TTestMenuObj.Create;
Begin
  Inherited Create;

  { Create INI file access object }
  IniOptions := TIniFile.Create (ExtractFilePath(Application.ExeName) + 'TestOpts.Dat');
End;

Destructor TTestMenuObj.Destroy;
Begin
  { Fee INI file access object }
  if Assigned(IniOptions) then
    IniOptions.Free;

  Inherited Destroy;
End;

{ Create tools menu, and insert before the Help menu }
procedure TTestMenuObj.CreateOptsMenu;
Begin
  { Add DLL Module Name to start of control name to provide unique control name }
  TestMenu := hNewMenu('EF&T', DLLChain.ModuleName + '_Test');
{  TestMenu.AutoHotKeys := maManual;
  TestMenu.AutoLineReduction := maManual;}
  TestMenu.Hint := 'Test Options';
  hEntMenu.Items.Insert (hEntMenu.Items.Count - 1, TestMenu);
End;

{ Adds the options to the tools menu }
procedure TTestMenuObj.AddTestOptions;
Var
  TmpItem : TMenuItem;
Begin
  { Add a '&Options' menu item to the Tools menu }
  TmpItem := hNewMenu('&Options', DLLChain.ModuleName + '_Test_Options');
  TmpItem.Hint := 'Test Specific options';
  TmpItem.OnClick := TestMenuObj.MenuOpt_Test_OptionsClick;
  TestMenu.Add (TmpItem);
End;


{ Click Event handler for the Tools options menu option }
procedure TTestMenuObj.MenuOpt_Test_OptionsClick(Sender: TObject);
var
  s : string;
begin
  ShowMessage('Click');
end;


Initialization
  { Initialise the temporary application handle so we can tell if its been set }
  OldApp := Nil;
  OldScr := Nil;
Finalization
  { free the menu event object and restore the DLL's application instance }
  If Assigned (TestMenuObj) Then TestMenuObj.Free;
  If Assigned (OldApp) Then Application := OldApp;
  If Assigned (OldScr) Then Screen := OldScr;
end.
