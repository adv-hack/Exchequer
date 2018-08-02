unit ToolOpt;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Inifiles, ExtCtrls, Menus, shellAPI;

type
  TEntMenuObj = Class(TObject)
  Public
    { menu event handlers }
    procedure MenuOpt_Tools_UserClick(Sender: TObject);
  End; { EntMenuObj }


  TListObj = Class(TObject)
    Title   : ShortString;
    Path    : ShortString;
    Startup : ShortString;
    Params  : ShortString;
  End; { TListObj }

  TToolsOptions = class(TForm)
    Panel1: TPanel;
    btnClose: TButton;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    Panel2: TPanel;
    ToolsList: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure ToolsListClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FOnUpdateTools : TNotifyEvent;
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    Procedure EditProperties(Add : Boolean);
    Function  GetListObj(Add : Boolean) : TListObj;
  public
    Property OnUpdateTools : TNotifyEvent read FOnUpdateTools write FOnUpdateTools;
  end;

Procedure AddUserTools(ToolsMenu : TMenuItem);

implementation

uses
  VarConst, ToolDetF;

{$R *.DFM}

Var
  IniOptions : TIniFile;
  EntMenuObj : TEntMenuObj;
  SepLineStr : ShortString;


Procedure AddUserTools(ToolsMenu : TMenuItem);
Var
  NumItems, I          : LongInt;
  {TitleStr, Str1, Str2 : ShortString;}
  TmpItem              : TMenuItem;
Begin
  { Delete off any existing tools }
  If (ToolsMenu.Count > 1) Then
    For I := 2 To Pred(ToolsMenu.Count) Do Begin
      TmpItem := ToolsMenu.Items[2];
      ToolsMenu.Delete(2);
      TmpItem.Free;
    End; { For }

  { Add on new tools }
  NumItems := IniOptions.ReadInteger('ToolsMenu','Options',0);

  If (NumItems > 0) Then Begin
    For I := 1 To NumItems Do Begin
      { add menu option }
      TmpItem := TMenuItem.Create (ToolsMenu);
      With TmpItem Do Begin
        Caption := IniOptions.ReadString('ToolsTitles','Opt'+IntToStr(I),'');
        Name := 'MenuOpt_Tools_Option' + IntToStr(I);
        Tag := I;
        OnClick := EntMenuObj.MenuOpt_Tools_UserClick;
      End; { With }
      ToolsMenu.Add (TmpItem);
    End; { For I }
  End; { If (NumTools > 0) }
End;


{----------------------------------------------------------------------------}


{ Click Event handler for the user defined Tools menu options }
procedure TEntMenuObj.MenuOpt_Tools_UserClick(Sender: TObject);
Var
  Str1                        : ShortString;
  cmdFile, cmdPath, cmdParams : PChar;
  Flags                       : SmallInt;
Begin
  With TMenuItem(Sender) Do Begin
    { Build access string for .INI file }
    Str1 := 'Opt'+IntToStr(Tag);

    cmdFile   := StrAlloc(255);
    cmdPath   := StrAlloc(255);
    cmdParams := StrAlloc(255);

    StrPCopy (cmdFile,   IniOptions.ReadString('ToolsCmds',Str1,''));
    StrPCopy (cmdParams, IniOptions.ReadString('ToolsParams',Str1,''));
    StrPCopy (cmdPath,   IniOptions.ReadString('ToolsStartup',Str1,''));

    Flags := SW_SHOWNORMAL;

    ShellExecute (Application.MainForm.Handle, NIL, cmdFile, cmdParams, cmdPath, Flags);

    StrDispose(cmdFile);
    StrDispose(cmdPath);
    StrDispose(cmdParams);
  End; { With }
End;


{----------------------------------------------------------------------------}


procedure TToolsOptions.FormCreate(Sender: TObject);
Var
  NumItems, I : LongInt;
  Str1        : ShortString;
  ListObj     : TListObj;
begin
  ClientHeight := 220;
  ClientWidth  := 375;

  { load ini file in }
  NumItems := IniOptions.ReadInteger('ToolsMenu','Options',0);

  If (NumItems > 0) Then
    For I := 1 To NumItems Do Begin
      { Add user tools option }
      Str1 := 'Opt'+IntToStr(I);

      ListObj := TListObj.Create;
      With ListObj Do Begin
        Title   := IniOptions.ReadString('ToolsTitles',Str1,'');
        Path    := IniOptions.ReadString('ToolsCmds',Str1,'');
        Params  := IniOptions.ReadString('ToolsParams',Str1,'');
        Startup := IniOptions.ReadString('ToolsStartup',Str1,'');
      End; { With }

      If (ListObj.Title <> '-') Then Begin
        ToolsList.Items.AddObject (ListObj.Title +
                                   #9 +
                                   ListObj.Path,
                                   ListObj);
      End { If (ListObj.Title <> '-') }
      Else Begin
        ToolsList.Items.AddObject (SepLineStr, ListObj);
      End; { Else }
    End; { For }
end;

{ Close dialog }
procedure TToolsOptions.btnCloseClick(Sender: TObject);
begin
  Close;
end;

{ Add a new tool }
procedure TToolsOptions.btnAddClick(Sender: TObject);
begin
  EditProperties(True);
end;

{ Edit currently selected tool }
procedure TToolsOptions.btnEditClick(Sender: TObject);
begin
  If (ToolsList.ItemIndex > -1) Then
    EditProperties(False);
end;

{ Delete currently selected tool }
procedure TToolsOptions.btnDeleteClick(Sender: TObject);
begin
  If (ToolsList.ItemIndex > -1) Then
    With GetListObj(False) Do
      If (MessageDlg('Are you sure you want to delete ''' + Title + '''?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
        ToolsList.Items.Delete (ToolsList.ItemIndex);
end;

{ Extracts the title from the current row of the list }
Function TToolsOptions.GetListObj(Add : Boolean) : TListObj;
Begin
  If Add Then Begin
    Result := TListObj.Create;
    Result.Title   := '';
    Result.Path    := '';
    Result.Startup := '';
    Result.Params  := '';
  End { If }
  Else Begin
    { Get ListObj from list }
    Result := TListObj(ToolsList.Items.Objects[ToolsList.ItemIndex]);
  End; { Else }
End;

{ Adds/Edits an option }
Procedure TToolsOptions.EditProperties(Add : Boolean);
Var
  ListObj : TListObj;
Begin
  ToolDetails := TToolDetails.Create(Self);
  Try
    ListObj := GetListObj(Add);

    If (Not Add) And (ToolsList.ItemIndex > -1) Then Begin
      { Display tools details }
      ToolDetails.edtTitle.Text := ListObj.Title;
      ToolDetails.edtPath.Text := ListObj.Path;
      ToolDetails.edtStart.Text := ListObj.Startup;
      ToolDetails.edtParams.Text := ListObj.Params;

      ToolDetails.edtPathExit(Self);
    End; { If }

    ToolDetails.ShowModal;

    If ToolDetails.OK Then Begin
      ListObj.Title   := ToolDetails.edtTitle.Text;
      ListObj.Path    := ToolDetails.edtPath.Text;
      ListObj.Startup := ToolDetails.edtStart.Text;
      ListObj.Params  := ToolDetails.edtParams.Text;

      If Add Then Begin
        If (ListObj.Title <> '-') Then Begin
          ToolsList.Items.AddObject (ListObj.Title +
                                     #9 +
                                     ListObj.Path,
                                     ListObj);
        End { If (ListObj.Title <> '-') }
        Else Begin
          ToolsList.Items.AddObject (SepLineStr, ListObj);
        End; { Else }
      End { If }
      Else Begin
        If (ListObj.Title <> '-') Then Begin
          ToolsList.Items[ToolsList.ItemIndex] := ListObj.Title + #9 + ListObj.Path;
        End { If (ListObj.Title <> '-') }
        Else Begin
          ToolsList.Items[ToolsList.ItemIndex] := SepLineStr;
        End; { Else }
      End; { Else }
    End; { If }
  Finally
    ToolDetails.Free;
  End; { Try }
End;

{ Move currently selected tool up 1 }
procedure TToolsOptions.btnMoveUpClick(Sender: TObject);
Var
  Idx : LongInt;
begin
  { make sure we have a tool selected and it isn't the top tool }
  If (ToolsList.ItemIndex > 0) Then Begin
    Idx := ToolsList.ItemIndex;
    ToolsList.Items.Move (Idx, Pred(Idx));
    ToolsList.ItemIndex := Pred(Idx);
  End; { If }

  ToolsListClick(Self);
end;

{ Move currently selected tool down 1 }
procedure TToolsOptions.btnMoveDownClick(Sender: TObject);
Var
  Idx : LongInt;
begin
  { make sure we have a tool selected and it isn't the bottom tool }
  If (ToolsList.ItemIndex > -1) And (ToolsList.ItemIndex < Pred(ToolsList.Items.Count)) Then Begin
    Idx := ToolsList.ItemIndex;
    ToolsList.Items.Move (Idx, Succ(Idx));
    ToolsList.ItemIndex := Succ(Idx);
  End; { If }

  ToolsListClick(Self);
end;

procedure TToolsOptions.ToolsListClick(Sender: TObject);
begin
  { enable if it isn't the top tool }
  btnMoveUp.Enabled := (ToolsList.ItemIndex > 0) And
                       (ToolsList.Items.Count > 1);

  { enable if it isn't the bottom tool }
  btnMoveDown.Enabled := (ToolsList.ItemIndex > -1) And
                         (ToolsList.ItemIndex < Pred(ToolsList.Items.Count)) And
                         (ToolsList.Items.Count > 1);
end;


procedure TToolsOptions.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
Var
  ListObj : TListObj;
  Str1    : ShortString;
  I       : Smallint;
begin
  { Save Tool Options }
  IniOptions.WriteInteger('ToolsMenu', 'Options', ToolsList.Items.Count);
  IniOptions.EraseSection('ToolsTitles');
  IniOptions.EraseSection('ToolsCmds');
  IniOptions.EraseSection('ToolsParams');
  IniOptions.EraseSection('ToolsStartup');
  If (ToolsList.Items.Count > 0) Then
    For I := 0 To Pred (ToolsList.Items.Count) Do Begin
      Str1 := 'Opt'+IntToStr(I + 1);

      ListObj := TListObj(ToolsList.Items.Objects[I]);
      With ListObj Do Begin
        IniOptions.WriteString('ToolsTitles', Str1, Title);
        IniOptions.WriteString('ToolsCmds',   Str1, Path);
        IniOptions.WriteString('ToolsParams', Str1, Params);
        IniOptions.WriteString('ToolsStartup', Str1, Startup);
      End; { With }

      ToolsList.Items.Objects[I] := Nil;
      ListObj.Free;
    End; { For }

  { reload tools options }
  If Assigned (FOnUpdateTools) Then
    FOnUpdateTools(Self);
end;


{ NOTE: FormClose is only called when the form is closed manually, it is not }
{       called when Enterprise is closed whilst it is open. don't know why.  }
procedure TToolsOptions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  { De-Allocate memory automatically }
  Action := caFree;
end;

procedure TToolsOptions.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 300;
    ptMinTrackSize.Y := 220;
  end;{with}
  Message.Result := 0;
  inherited;
end;

Initialization
  IniOptions := TIniFile.Create (sEXEDir + 'WCATools.Dat');
  EntMenuObj := TEntMenuObj.Create;

  FillChar(SepLineStr, SizeOf(SepLineStr), Ord('-'));
  SepLineStr[0] := #255;
Finalization
  EntMenuObj.Destroy;
  IniOptions.Free;
end.
