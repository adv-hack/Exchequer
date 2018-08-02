unit ftoolopt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Inifiles, ExtCtrls, Menus, uMultiList;

type
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
    ToolsList: TMultiList;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ToolsListChangeSelection(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ToolsListRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ToolsListScrollButtonKeyPress(Key: Char);
  private
    { Private declarations }
    IniOptions : TIniFile;

    FOnUpdateTools : TNotifyEvent;

    function EditProperties(Add : Boolean) : boolean;
    Function  GetListObj(Add : Boolean) : TListObj;
    procedure EnableDisable;
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
  public
    { Public declarations }
    Property OnUpdateTools : TNotifyEvent read FOnUpdateTools write FOnUpdateTools;
  end;

var
  ToolsOptions: TToolsOptions;

implementation

uses
 EntMenuU, ToolDetF;

{$R *.DFM}

Var
  SepLineStr : ShortString;

procedure TToolsOptions.FormCreate(Sender: TObject);
Var
  NumItems, I : LongInt;
  Str1        : ShortString;
  ListObj     : TListObj;
begin
  SetWindowLong(Handle, GWL_USERDATA, 1121);
  ClientHeight := 233;
//  ClientWidth  := 482;
  ClientWidth  := 494;
  ToolsList.Anchors := [akLeft, akRight, akTop, akBottom];

  IniOptions := TIniFile.Create (ExtractFilePath(Application.ExeName) + 'EntTools.Dat');

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

      If (ListObj.Title <> '-') Then
        begin
          ToolsList.DesignColumns[0].items.AddObject(ListObj.Title, ListObj);
          ToolsList.DesignColumns[1].items.Add(ListObj.Path);
        end
      Else Begin
        ToolsList.DesignColumns[0].items.AddObject(SepLineStr, ListObj);
        ToolsList.DesignColumns[1].items.Add(SepLineStr);
      End; { Else }
    End; { For }

    if ToolsList.ItemsCount > 0 then ToolsList.Selected := 0;

  EnableDisable;
end;

{ Close dialog }
procedure TToolsOptions.btnCloseClick(Sender: TObject);
begin
  Close;
end;

{ Add a new tool }
procedure TToolsOptions.btnAddClick(Sender: TObject);
begin
  if EditProperties(True) then ToolsList.Selected := ToolsList.ItemsCount - 1;
end;

{ Edit currently selected tool }
procedure TToolsOptions.btnEditClick(Sender: TObject);
begin
  If (ToolsList.Selected > -1) Then
    EditProperties(False);
end;

{ Delete currently selected tool }
procedure TToolsOptions.btnDeleteClick(Sender: TObject);
begin
  If (ToolsList.Selected > -1) Then
    With GetListObj(False) Do
      If (MessageDlg('Are you sure you want to delete ''' + Title + '''?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
        ToolsList.DeleteRow(ToolsList.Selected);
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
    Result := TListObj(ToolsList.DesignColumns[0].Items.Objects[ToolsList.Selected]);
  End; { Else }
End;

{ Adds/Edits an option }
function TToolsOptions.EditProperties(Add : Boolean) : boolean;
var
  ListObj : TListObj;
begin
  ToolDetails := TToolDetails.Create(Self);
  Try
    ListObj := GetListObj(Add);

    If (Not Add) And (ToolsList.Selected > -1) Then Begin
      { Display tools details }
      ToolDetails.edtTitle.Text := ListObj.Title;
      ToolDetails.edtPath.Text := ListObj.Path;
      ToolDetails.edtStart.Text := ListObj.Startup;
      ToolDetails.edtParams.Text := ListObj.Params;

      ToolDetails.edtPathExit(Self);
    End; { If }

    ToolDetails.ShowModal;

    Result := ToolDetails.OK;

    If ToolDetails.OK Then Begin
      ListObj.Title   := ToolDetails.edtTitle.Text;
      ListObj.Path    := ToolDetails.edtPath.Text;
      ListObj.Startup := ToolDetails.edtStart.Text;
      ListObj.Params  := ToolDetails.edtParams.Text;

      If Add Then Begin
        If (ListObj.Title <> '-') Then
          Begin
            ToolsList.DesignColumns[0].Items.AddObject(ListObj.Title, ListObj);
            ToolsList.DesignColumns[1].Items.Add(ListObj.Path);
          End { If (ListObj.Title <> '-') }
        Else Begin
          ToolsList.DesignColumns[0].Items.AddObject(SepLineStr, ListObj);
          ToolsList.DesignColumns[1].Items.Add(SepLineStr);
        End; { Else }
      End { If }
      Else Begin
        If (ListObj.Title <> '-') Then Begin
          ToolsList.DesignColumns[0].Items[ToolsList.Selected] := ListObj.Title;
          ToolsList.DesignColumns[1].Items[ToolsList.Selected] := ListObj.Path;
        End { If (ListObj.Title <> '-') }
        Else Begin
          ToolsList.DesignColumns[0].Items[ToolsList.Selected] := SepLineStr;
          ToolsList.DesignColumns[1].Items[ToolsList.Selected] := SepLineStr;
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
  If (ToolsList.Selected > 0) Then Begin
    Idx := ToolsList.Selected;
//    ToolsList.DesignColumns[0].Items.Move (Idx, Pred(Idx));
    ToolsList.MoveRow(Idx, Pred(Idx));
    ToolsList.Selected := Pred(Idx);
  End; { If }

  EnableDisable;
end;

{ Move currently selected tool down 1 }
procedure TToolsOptions.btnMoveDownClick(Sender: TObject);
Var
  Idx : LongInt;
begin
  { make sure we have a tool selected and it isn't the bottom tool }
  If (ToolsList.Selected > -1) And (ToolsList.Selected < Pred(ToolsList.ItemsCount)) Then Begin
    Idx := ToolsList.Selected;
//    ToolsList.DesignColumns[0].Items.Move (Idx, Succ(Idx));
    ToolsList.MoveRow(Idx, Succ(Idx));
    ToolsList.Selected := Succ(Idx);
  End; { If }

  EnableDisable;
end;

procedure TToolsOptions.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
Var
  ListObj : TListObj;
  Str1    : ShortString;
  I       : Smallint;
begin
  { Save Tool Options }
  IniOptions.WriteInteger('ToolsMenu', 'Options', ToolsList.ItemsCount);
  IniOptions.EraseSection('ToolsTitles');
  IniOptions.EraseSection('ToolsCmds');
  IniOptions.EraseSection('ToolsParams');
  IniOptions.EraseSection('ToolsStartup');
  If (ToolsList.ItemsCount > 0) Then
    For I := 0 To Pred (ToolsList.ItemsCount) Do Begin
      Str1 := 'Opt'+IntToStr(I + 1);

      ListObj := TListObj(ToolsList.DesignColumns[0].Items.Objects[I]);
      With ListObj Do Begin
        IniOptions.WriteString('ToolsTitles', Str1, Title);
        IniOptions.WriteString('ToolsCmds',   Str1, Path);
        IniOptions.WriteString('ToolsParams', Str1, Params);
        IniOptions.WriteString('ToolsStartup', Str1, Startup);
      End; { With }

      ToolsList.DesignColumns[0].Items.Objects[I] := Nil;
      ListObj.Free;
    End; { For }

  { Close ini file }
  IniOptions.Free;

  { reload tools options }
  If Assigned (FOnUpdateTools) Then
    FOnUpdateTools(Self);
end;


{ NOTE: FormClose is only called when the form is closed manually, it is not }
{       called when Exchequer is closed whilst it is open. don't know why.  }
procedure TToolsOptions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  { De-Allocate memory automatically }
  Action := caFree;
end;

procedure TToolsOptions.EnableDisable;
begin
  btnMoveUp.Enabled := (ToolsList.Selected > 0); { enable if it isn't the top tool }
  btnMoveDown.Enabled := not (ToolsList.Selected = ToolsList.ItemsCount - 1); { enable if it isn't the bottom tool }
  btnEdit.Enabled := ToolsList.ItemsCount > 0;
  btnDelete.Enabled := ToolsList.ItemsCount > 0;

{  btnMoveUp.Enabled := (ToolsList.Selected > 0) And
                       (ToolsList.Columns[0].Items.Count > 1);

  { enable if it isn't the bottom tool }
{  btnMoveDown.Enabled := (ToolsList.Selected > -1) And
                         (ToolsList.Selected < Pred(ToolsList.Columns[0].Items.Count)) And
                         (ToolsList.Columns[0].Items.Count > 1);}
end;


procedure TToolsOptions.ToolsListChangeSelection(Sender: TObject);
begin
  EnableDisable;
end;

procedure TToolsOptions.Button2Click(Sender: TObject);
begin
  ToolsList.SortColumn(1, TRUE);
end;

procedure TToolsOptions.ToolsListRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnEditClick(btnEdit);
end;

procedure TToolsOptions.FormDestroy(Sender: TObject);
begin
  ToolsOptions := nil;
end;

procedure TToolsOptions.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 286;
    ptMinTrackSize.Y := 200;
  end;{with}
  Message.Result := 0;
  inherited;
end;


procedure TToolsOptions.Button1Click(Sender: TObject);
begin
  ToolsList.ClearItems;
end;

procedure TToolsOptions.ToolsListScrollButtonKeyPress(Key: Char);
begin
  showmessage(key);
end;

Initialization
  FillChar(SepLineStr, SizeOf(SepLineStr), Ord('-'));
  SepLineStr[0] := #255;

end.

