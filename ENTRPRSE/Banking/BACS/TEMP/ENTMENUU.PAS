unit EntMenuU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, Menus, IniFiles;

Type
  {$I CustMenu.Pas}

  TTestMenuObj = Class(TObject)
    IniOptions : TIniFile;

    hTestMenu   : TMainMenu;
    hNewMenu   : NewMenuFunc;

    ToolsMenu  : TMenuItem;

    Constructor Create;
    Destructor  Destroy; Override;
    procedure CreateToolsMenu;
    procedure AddToolsOptions;
    Procedure AddUserTools;

    { menu event handlers }
    procedure MenuOpt_Tools_UserClick(Sender: TObject);
    procedure MenuOpt_Tools_OptionsClick(Sender: TObject);
    procedure UpdateToolsMenu(Sender: TObject);
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
      hTestMenu := EntInfo^.EntMenus;
      hNewMenu := EntInfo^.NewMenu;

      { create tools menu }
      CreateToolsMenu;
      AddToolsOptions;
{      AddUserTools;}
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
{  IniOptions := TIniFile.Create (ExtractFilePath(Application.ExeName) + 'EntTools.Dat');}
End;

Destructor TTestMenuObj.Destroy;
Begin
  { Fee INI file access object }
{  IniOptions.Free;}

  Inherited Destroy;
End;

{ Create tools menu, and insert before the Help menu }
procedure TTestMenuObj.CreateToolsMenu;
Begin
  { Add DLL Module Name to start of control name to provide unique control name }
  ToolsMenu := hNewMenu('Test', DLLChain.ModuleName + '_Menu_Test');
  ToolsMenu.AutoHotKeys := maManual;
  ToolsMenu.AutoLineReduction := maManual;
  ToolsMenu.GroupIndex := 95;
  ToolsMenu.HelpContext := 550;
  ToolsMenu.Hint := 'Test';
  hTestMenu.Items.Insert (hTestMenu.Items.Count - 1, ToolsMenu);
End;

{ Adds the options to the tools menu }
procedure TTestMenuObj.AddToolsOptions;
Var
  TmpItem : TMenuItem;
Begin
  { Add a '&Options' menu item to the Tools menu }
  TmpItem := hNewMenu('&Options', DLLChain.ModuleName + '_MenuOpt_Tools_Options');
  TmpItem.HelpContext := 550;
  TmpItem.Hint := 'Allows the modification of the Test menu';
  TmpItem.OnClick := TestMenuObj.MenuOpt_Tools_OptionsClick;
  ToolsMenu.Add (TmpItem);

  { Add a '----' menu item to the Tools menu }
  TmpItem := hNewMenu('-', DLLChain.ModuleName + '_MenuOpt_Tools_SepBar');
  TmpItem.HelpContext := 550;
  ToolsMenu.Add (TmpItem);
End;

Procedure TTestMenuObj.AddUserTools;
Var
  NumItems, I          : LongInt;
  TitleStr, Str1, Str2 : ShortString;
  TmpItem              : TMenuItem;
Begin
End;

{ Click Event handler for the user defined Tools menu options }
procedure TTestMenuObj.MenuOpt_Tools_UserClick(Sender: TObject);
Var
  Str1, FPath                 : ShortString;
  cmdFile, cmdPath, cmdParams : PChar;
  Flags                       : SmallInt;
Begin
  ShowMessage('Click');
End;

{ Click Event handler for the Tools options menu option }
procedure TTestMenuObj.MenuOpt_Tools_OptionsClick(Sender: TObject);
begin
end;

procedure TTestMenuObj.UpdateToolsMenu(Sender: TObject);
Var
  TempMenu : TMenuItem;
  I        : SmallInt;
Begin
End;

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
