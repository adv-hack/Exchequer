unit ftoolopt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Inifiles, ExtCtrls, Menus, uMultiList, ComCtrls, uSettings,
  Enterprise01_TLB, Mask, uExDatasets, uComTKDataset, uDBMultiList,
  uBtrieveDataset;

type
  TCustRec = Record
   {002}      CustCode   : string[10];    (*  customer code *)
   {012}      CustSupp   : Char;          {* Customer / Supplier Flag *}
   {014}      Company    : string[45];    (*  Company Name *)
  end;

  TListObj = Class(TObject)
    Title   : ShortString;
    Path    : ShortString;
    Startup : ShortString;
    Params  : ShortString;
  End; { TListObj }

  TToolsOptions = class(TForm)
    pmtab1: TPopupMenu;
    Properties1: TMenuItem;
    Edit1: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ToolsList: TMultiList;
    Edit2: TEdit;
    pmMain: TPopupMenu;
    EditProperties1: TMenuItem;
    TabSheet4: TTabSheet;
    edtab3: TEdit;
    pmtab3: TPopupMenu;
    EditProptab31: TMenuItem;
    pmtab4: TPopupMenu;
    MenuItem1: TMenuItem;
    MultiList1: TMultiList;
    Panel1: TPanel;
    Button1: TButton;
    edMain: TEdit;
    Panel2: TPanel;
    btnClose: TButton;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    MaskEdit1: TMaskEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    N1: TMenuItem;
    RestoreDefaults1: TMenuItem;
    N2: TMenuItem;
    RestoreDefaults2: TMenuItem;
    N3: TMenuItem;
    RestoreDefaults3: TMenuItem;
    N4: TMenuItem;
    RestoreDefaults4: TMenuItem;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    TabSheet5: TTabSheet;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    pmtab5: TPopupMenu;
    EditProperties2: TMenuItem;
    Panel3: TPanel;
    TabSheet6: TTabSheet;
    mlCustomers: TDBMultiList;
    cdsCustomers: TComTKDataset;
    pmtab6: TPopupMenu;
    MenuItem2: TMenuItem;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    TabSheet7: TTabSheet;
    mlDirectCust: TDBMultiList;
    bdsCust: TBtrieveDataset;
    SaveCoordinates1: TMenuItem;
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
    procedure ToolsListRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ToolsListScrollButtonKeyPress(Key: Char);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure EditProperties1Click(Sender: TObject);
    procedure EditProptab31Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SaveAllSettings;
    procedure RestoreDefaults4Click(Sender: TObject);
    procedure RestoreDefaults1Click(Sender: TObject);
    procedure RestoreDefaults2Click(Sender: TObject);
    procedure RestoreDefaults3Click(Sender: TObject);
    procedure EditProperties2Click(Sender: TObject);
    procedure cdsCustomersGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure mlCustomersRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure MenuItem2Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure mlCustomersCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure bdsCustGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
  private
    { Private declarations }
    IniOptions : TIniFile;
    bRestore : boolean;

    FOnUpdateTools : TNotifyEvent;

    oToolkit : IToolkit;

    function EditProperties(Add : Boolean) : boolean;
    Function  GetListObj(Add : Boolean) : TListObj;
    procedure EnableDisable;
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure LoadAllSettings;
  public
    { Public declarations }
    Property OnUpdateTools : TNotifyEvent read FOnUpdateTools write FOnUpdateTools;
  end;

var
  ToolsOptions: TToolsOptions;

implementation

uses
 ComObj, EntMenuU, ToolDetF;

{$R *.DFM}

Var
  SepLineStr : ShortString;

procedure TToolsOptions.LoadAllSettings;
var
  bSaveCoords : boolean;
begin
  oSettings.LoadForm(Self, bSaveCoords);
  SaveCoordinates1.checked := bSaveCoords;

  oSettings.LoadParentToControl(Self.Name, Self.Name, edMain);
  oSettings.ColorFieldsFrom(edMain, Self, 1);
  oSettings.LoadParentToControl(TabSheet1.Name, Self.Name, MaskEdit1);
  oSettings.ColorFieldsFrom(MaskEdit1, TabSheet1);
  oSettings.LoadParentToControl(TabSheet3.Name, Self.Name, edtab3);
  oSettings.ColorFieldsFrom(edtab3, TabSheet3);
  oSettings.LoadParentToControl(TabSheet5.Name, Self.Name, edit7);
  oSettings.ColorFieldsFrom(edit7, TabSheet5, 13);
//  oSettings.LoadParentToControl(TabSheet4.Name, Self.Name);

  oSettings.LoadList(ToolsList, Self.Name);
  ToolsList.RefreshList;

  oSettings.LoadList(MultiList1, Self.Name);
  MultiList1.RefreshList;

  oSettings.LoadList(mlCustomers, Self.Name);
  mlCustomers.RefreshList;
end;

procedure TToolsOptions.FormCreate(Sender: TObject);
Var
  NumItems, I : LongInt;
  Str1        : ShortString;
  ListObj     : TListObj;

  procedure InitToolkit;
  begin{InitToolkit}
    // Create COM Toolkit object
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) Then Begin
      oToolkit.OpenToolkit;

    End { If Assigned(oToolkit) }
    Else
      // Failed to create COM Object
      ShowMessage ('Cannot create COM Toolkit instance');
  end;{InitToolkit}


begin
  bRestore := FALSE;

//  oSettings.UserName := 'Neil';
//  oSettings.UserName := 'Dan';

  LoadAllSettings;

  //  ToolsList.ForceXPButtons;

  SetWindowLong(Handle, GWL_USERDATA, 1121);
//  ClientHeight := 233;
//  ClientWidth  := 482;
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
          ToolsList.DesignColumns[2].items.Add(ListObj.Params)
        end
      Else Begin
        ToolsList.DesignColumns[0].items.AddObject(SepLineStr, ListObj);
        ToolsList.DesignColumns[1].items.Add(SepLineStr);
        ToolsList.DesignColumns[2].items.Add(SepLineStr)
      End; { Else }
    End; { For }

    if ToolsList.ItemsCount > 0 then ToolsList.Selected := 0;


  oToolkit := nil;

  InitToolkit;

  // init customer list
  cdsCustomers.ToolkitObject := oToolkit.customer as IBtrieveFunctions2;
  mlCustomers.Dataset := cdsCustomers;

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
            ToolsList.DesignColumns[2].items.Add(ListObj.Params)
          End { If (ListObj.Title <> '-') }
        Else Begin
          ToolsList.DesignColumns[0].Items.AddObject(SepLineStr, ListObj);
          ToolsList.DesignColumns[1].Items.Add(SepLineStr);
          ToolsList.DesignColumns[2].items.Add(SepLineStr)
        End; { Else }
      End { If }
      Else Begin
        If (ListObj.Title <> '-') Then Begin
          ToolsList.DesignColumns[0].Items[ToolsList.Selected] := ListObj.Title;
          ToolsList.DesignColumns[1].Items[ToolsList.Selected] := ListObj.Path;
          ToolsList.DesignColumns[2].Items[ToolsList.Selected] := ListObj.Params;
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
{       called when Enterprise is closed whilst it is open. don't know why.  }
procedure TToolsOptions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
  { De-Allocate memory automatically }
  Action := caFree;
end;

procedure TToolsOptions.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(edMain, Self.Name);
  oSettings.SaveList(ToolsList, Self.Name);
  oSettings.SaveParentFromControl(MaskEdit1, Self.Name, TabSheet1.Name);
  oSettings.SaveParentFromControl(edtab3, Self.Name, TabSheet3.Name);
  oSettings.SaveParentFromControl(edit7, Self.Name, TabSheet5.Name);
  oSettings.SaveList(MultiList1, Self.Name);
  oSettings.SaveForm(Self, SaveCoordinates1.checked);
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
//  Label1.Caption := ToolsList.Columns[1].Items[ToolsList.Selected];
end;

procedure TToolsOptions.ToolsListRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnEditClick(btnEdit);
end;

procedure TToolsOptions.FormDestroy(Sender: TObject);
begin

  If Assigned(oToolkit) Then Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }

  ToolsOptions := nil;
end;

procedure TToolsOptions.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 286;
    ptMinTrackSize.Y := 202;
  end;{with}
  Message.Result := 0;
  inherited;
end;


procedure TToolsOptions.Button1Click(Sender: TObject);
begin
  oSettings.ExportBtrieveFileTo('Misc\settings.txt');
//  oSettings.debug;
//  showmessage(IntTostr(SizeOf(Tcolor)));
end;

procedure TToolsOptions.ToolsListScrollButtonKeyPress(Key: Char);
begin
  case Ord(Key) of
    VK_ESCAPE : Close; 
  end;{case}
end;

procedure TToolsOptions.Button4Click(Sender: TObject);
begin
  SaveAllSettings;
end;

procedure TToolsOptions.Button5Click(Sender: TObject);
var
  iPos : integer;
  sSelected : string;
begin
//  ToolsList.Colours.CellText := clBlue;
//  ToolsList.RefreshList;

//  ShowMessage(IntToStr(High(ToolsList.MultiSelected)));

  sSelected := '';
  For iPos := 0 to ToolsList.ItemsCount -1 do
  begin
    if ToolsList.MultiSelected[iPos] then sSelected := sSelected  + IntToStr(iPos) + ',';
  end;{for}

  showmessage(sSelected);
end;

procedure TToolsOptions.Button6Click(Sender: TObject);
var
  sSelected : string;
  iPos : integer;
begin
//oSettings.LoadList(ToolsList, Self.Name);

  sSelected := '';
  For iPos := 0 to mlCustomers.MultiSelected.Count -1 do
  begin
    sSelected := sSelected  + mlCustomers.MultiSelected[iPos] + ',';
  end;{for}

  showmessage(sSelected);
end;

procedure TToolsOptions.Button7Click(Sender: TObject);
{var
  iColumn : integer;}
begin
{  For iColumn := 0 to ToolsList.Columns.Count -1
  do ToolsList.DesignColumns[iColumn].Color := clWhite;;
  ToolsList.RefreshList;}

  ToolsList.MultiSelectAll;
end;

procedure TToolsOptions.Button8Click(Sender: TObject);
var
  iColumn : integer;
begin
{  For iColumn := 0 to ToolsList.Columns.Count -1
  do ToolsList.DesignColumns[iColumn].Color := clSkyBlue;
  ToolsList.RefreshList;}
  ToolsList.MultiSelectClear;
end;

procedure TToolsOptions.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(ToolsList, Self.Name, Maskedit1) of
    mrOK : oSettings.ColorFieldsFrom(MaskEdit1, TabSheet1);
    mrRestoreDefaults : RestoreDefaults1Click(RestoreDefaults1);
  end;{case}
end;

procedure TToolsOptions.EditProperties1Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, edMain) of
    mrOK : begin
      oSettings.SaveParentFromControl(edMain, Self.Name);
      LoadAllSettings;
    end;
  end;{case}
end;

procedure TToolsOptions.EditProptab31Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, edtab3) of
    mrOK : begin
      oSettings.ColorFieldsFrom(edtab3, tabsheet3);
    end;
  end;{case}
end;

procedure TToolsOptions.MenuItem1Click(Sender: TObject);
begin
  case oSettings.Edit(MultiList1, Self.Name, nil) of
    mrOK : begin
      oSettings.SaveList(MultiList1, Self.Name);
      LoadAllSettings;
    end;
  end;{case}
end;

procedure TToolsOptions.Button3Click(Sender: TObject);
begin
  LoadAllSettings;
end;

procedure TToolsOptions.RestoreDefaults4Click(Sender: TObject);
begin
  oSettings.RestoreFormDefaults(Self.Name);
  oSettings.RestoreParentDefaults(Self, Self.Name);
  bRestore := TRUE;
end;

procedure TToolsOptions.RestoreDefaults1Click(Sender: TObject);
begin
  oSettings.RestoreListDefaults(ToolsList, Self.Name);
  oSettings.RestoreParentDefaults(TabSheet1, Self.Name);
  bRestore := TRUE;
end;

procedure TToolsOptions.RestoreDefaults2Click(Sender: TObject);
begin
  oSettings.RestoreParentDefaults(TabSheet3, Self.Name);
  bRestore := TRUE;
end;

procedure TToolsOptions.RestoreDefaults3Click(Sender: TObject);
begin
  oSettings.RestoreListDefaults(MultiList1, Self.Name);
  oSettings.RestoreParentDefaults(TabSheet4, Self.Name);
  bRestore := TRUE;
end;

procedure TToolsOptions.EditProperties2Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, edit7) of
    mrOK : oSettings.ColorFieldsFrom(edit7, tabsheet5, 13);
  end;{case}
end;

procedure TToolsOptions.cdsCustomersGetFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
begin
  with (ID as IAccount) do begin
    case FieldName[1] of
      'C' : FieldValue := acCode;
      'D' : FieldValue := acCompany;
    end;{case}
  end;{with}
end;

procedure TToolsOptions.mlCustomersRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  with Sender as TDBMultiList
  do MultiSelect(DesignColumns[0].Items[Selected], RowIndex);
end;

procedure TToolsOptions.MenuItem2Click(Sender: TObject);
begin
  case oSettings.Edit(mlCustomers, Self.Name, nil) of
    mrOK : begin
      oSettings.SaveList(mlCustomers, Self.Name);
      LoadAllSettings;
    end;
  end;{case}
end;

procedure TToolsOptions.Button9Click(Sender: TObject);
begin
  mlCustomers.MultiSelectAll;
end;

procedure TToolsOptions.Button10Click(Sender: TObject);
begin
  mlCustomers.MultiSelectClear;
end;

procedure TToolsOptions.mlCustomersCellPaint(Sender: TObject; ColumnIndex,
  RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
  var TextBrush: TBrush; var TextAlign: TAlignment);
begin
//  if RowIndex mod 2 = 0 then TextFont.Color := clyellow;
end;

procedure TToolsOptions.bdsCustGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with TCustRec(PData^) do begin
    case FieldName[1] of
      'C' : FieldValue := CustCode;
      'D' : FieldValue := Company;
    end;{case}
  end;{with}
end;

Initialization
  FillChar(SepLineStr, SizeOf(SepLineStr), Ord('-'));
  SepLineStr[0] := #255;

end.

