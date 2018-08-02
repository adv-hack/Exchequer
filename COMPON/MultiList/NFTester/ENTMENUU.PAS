unit EntMenuU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, Menus, IniFiles, APIUtil;

Type
  {$I CustMenu.Pas}

  TEntMenuObj = Class(TObject)
  Private
    Constructor Create;
    Destructor  Destroy; Override;
  Public
    IniOptions : TIniFile;

    hEntMenu   : TMainMenu;
    hNewMenu   : NewMenuFunc;

    ToolsMenu  : TMenuItem;

    procedure CreateToolsMenu;
    procedure AddToolsOptions;
    Procedure AddUserTools;

    { menu event handlers }
    procedure MenuOpt_Tools_UserClick(Sender: TObject);
    procedure MenuOpt_Tools_OptionsClick(Sender: TObject);
    procedure UpdateToolsMenu(Sender: TObject);
  End; { EntMenuObj }


Procedure CustomMenus (EntInfo : ptrEntCustomInfo); Export;
Procedure CloseCustomMenus; Export;

implementation

Uses FToolOpt, ChainU;

Var
//  ToolsOptions: TToolsOptions;
  EntMenuObj  : TEntMenuObj;
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
    EntMenuObj := TEntMenuObj.Create;

    With EntMenuObj Do Begin
      { Take local copy of Enterprise handles }
      hEntMenu := EntInfo^.EntMenus;
      hNewMenu := EntInfo^.NewMenu;

      { create tools menu }
      CreateToolsMenu;
      AddToolsOptions;
      AddUserTools;
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

Constructor TEntMenuObj.Create;
Begin
  Inherited Create;

  { Create INI file access object }
  IniOptions := TIniFile.Create (ExtractFilePath(Application.ExeName) + 'EntTools.Dat');
End;

Destructor TEntMenuObj.Destroy;
Begin
  { Fee INI file access object }
  IniOptions.Free;

  Inherited Destroy;
End;

{ Create tools menu, and insert before the Help menu }
procedure TEntMenuObj.CreateToolsMenu;
Begin
  { Add DLL Module Name to start of control name to provide unique control name }
  ToolsMenu := hNewMenu('T&ools', DLLChain.ModuleName + '_Menu_Tools');
  ToolsMenu.AutoHotKeys := maManual;
  ToolsMenu.AutoLineReduction := maManual;
  ToolsMenu.GroupIndex := 95;
  ToolsMenu.HelpContext := 550;
  ToolsMenu.Hint := 'User Definable Tools';
  hEntMenu.Items.Insert (hEntMenu.Items.Count - 1, ToolsMenu);
End;

{ Adds the options to the tools menu }
procedure TEntMenuObj.AddToolsOptions;
Var
  TmpItem : TMenuItem;
Begin
  { Add a '&Options' menu item to the Tools menu }
  TmpItem := hNewMenu('&Options', DLLChain.ModuleName + '_MenuOpt_Tools_Options');
  TmpItem.HelpContext := 550;
  TmpItem.Hint := 'Allows the modification of the Tools menu';
  TmpItem.OnClick := EntMenuObj.MenuOpt_Tools_OptionsClick;
  ToolsMenu.Add (TmpItem);

  { Add a '----' menu item to the Tools menu }
  TmpItem := hNewMenu('-', DLLChain.ModuleName + '_MenuOpt_Tools_SepBar');
  TmpItem.HelpContext := 550;
  ToolsMenu.Add (TmpItem);
End;

Procedure TEntMenuObj.AddUserTools;
Var
  NumItems, I          : LongInt;
  TitleStr, Str1, Str2 : ShortString;
  TmpItem              : TMenuItem;
Begin
  NumItems := IniOptions.ReadInteger('ToolsMenu','Options',0);

  If (NumItems > 0) Then
    For I := 1 To NumItems Do Begin
      { Add user tools option }
      Str1 := 'Opt'+IntToStr(I);
      Str2 := 'MenuOpt_Tools_Option' + IntToStr(I);

      { Get title }
      TitleStr := IniOptions.ReadString('ToolsTitles',Str1,'');

      { add menu option }
      TmpItem := hNewMenu(TitleStr, DLLChain.ModuleName + '_' + Str2);
      TmpItem.HelpContext := 550;
      TmpItem.Tag := I;
      TmpItem.OnClick := EntMenuObj.MenuOpt_Tools_UserClick;
      ToolsMenu.Add (TmpItem);
    End;
End;

{ Click Event handler for the user defined Tools menu options }
procedure TEntMenuObj.MenuOpt_Tools_UserClick(Sender: TObject);
Var
  Str1, FPath                 : ShortString;
  cmdFile, cmdPath, cmdParams : PChar;
  Flags                       : SmallInt;
Begin
  With TMenuItem(Sender) Do Begin
    { Build access string for .INI file }
    Str1 := 'Opt'+IntToStr(Tag);

    cmdFile   := StrAlloc(255);
    cmdPath   := StrAlloc(255);
    cmdParams := StrAlloc(255);

    FPath := ExpandFileName(IniOptions.ReadString('ToolsStartup',Str1,''));

    {If (FPath = '.\') Then
      FPath := ExtractFilePath(Application.ExeName);}

    StrPCopy (cmdFile,   IniOptions.ReadString('ToolsCmds',Str1,''));
    StrPCopy (cmdParams, IniOptions.ReadString('ToolsParams',Str1,''));
    StrPCopy (cmdPath,   FPath);

    Flags := SW_SHOWNORMAL;

    ShellExecute (Application.MainForm.Handle, NIL, cmdFile, cmdParams, cmdPath, Flags);

    StrDispose(cmdFile);
    StrDispose(cmdPath);
    StrDispose(cmdParams);
  End; { With }
End;

{ Click Event handler for the Tools options menu option }
procedure TEntMenuObj.MenuOpt_Tools_OptionsClick(Sender: TObject);
Var
  hFaxAdminWin : HWnd;
begin
  if (ToolsOptions = nil) then
    begin
      ToolsOptions := TToolsOptions.Create(Application.MainForm);
      With ToolsOptions Do
        OnUpdateTools := UpdateToolsMenu;
    end
  else begin
    BringWindowToTop(ToolsOptions.Handle); {Bring Fax Admin Window To Front}
  end;{if}
  { NOTE: Is MDI child so it is automatically displayed }
end;

procedure TEntMenuObj.UpdateToolsMenu(Sender: TObject);
Var
  TempMenu : TMenuItem;
  I        : SmallInt;
Begin
  { Delete off any existing tools }
  If (ToolsMenu.Count > 1) Then
    For I := 2 To Pred(ToolsMenu.Count) Do Begin
      TempMenu := ToolsMenu.Items[2];
      ToolsMenu.Delete(2);
      TempMenu.Free;
    End; { For }

  { add on current tools }
  AddUserTools;
End;

Initialization
  { Initialise the temporary application handle so we can tell if its been set }
  OldApp := Nil;
  OldScr := Nil;
  ToolsOptions := nil;

Finalization
  { free the menu event object and restore the DLL's application instance }
  If Assigned (EntMenuObj) Then EntMenuObj.Free;
  If Assigned (OldApp) Then Application := OldApp;
  If Assigned (OldScr) Then Screen := OldScr;
end.
