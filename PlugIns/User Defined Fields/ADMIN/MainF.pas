unit MainF;

{ nfrewer440 09:40 03/09/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , ComCtrls, ImgList, Menus, ExtCtrls, StdCtrls, UDefProc, FileUtil, VarConst
  , ADODB, SQLUtils, GlobVar, Inifiles, BTrvU2, uSettingsSQL, APIUtil, DataModule;

type
  TCompanyInfo = Class
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;{with}

  TNodeData = Class(TObject)
  Private
//    FCaption   : ShortString;
//    FEnabled   : Boolean;
//    FEnforced  : Boolean;
//    FMode : integer;
//    FFieldFolio : Integer;
    FNode      : TTreeNode;
    FNodeName  : ShortString;
    FStrings   : TStrings;
    FFieldRec : TFieldRec;
  Protected
    Procedure SetCaption(Value : ShortString);
    function GetCaption : ShortString;
//    Procedure SetEnabled(Value : Boolean);
    Procedure SetMode(iMode : integer);
    function GetMode : integer;
    function GetFieldFolio : integer;
  Public
    Constructor Create(FieldRec : TFieldRec;
                       Node      : TTreeNode);
    Destructor Destroy; Override;
    Procedure StoreSettings(SQLDataModule : TSQLDataModule);

    Property ndCaption  : ShortString Read GetCaption Write SetCaption;
    Property ndFieldFolio : integer Read GetFieldFolio;
//    Property ndEnabled  : Boolean Read FEnabled Write SetEnabled;
//    Property ndEnforced : Boolean Read FEnforced Write FEnforced;
    Property ndMode : integer Read GetMode Write SetMode;
    Property ndNode     : TTreeNode Read FNode;
    Property ndNodeName : ShortString Read FNodeName;
//    Property ndStrings  : TStrings Read FStrings Write FStrings;
  End; { TNodeData }

  {----------------------------------------------}

  TfrmUserDefList = class(TForm)
    imglstOutline: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Exit1: TMenuItem;
    tvFieldLst: TTreeView;
    Panel1: TPanel;
    Label2: TLabel;
    pmMain: TPopupMenu;
    mnuProperties: TMenuItem;
    Label1: TLabel;
    cmbCompany: TComboBox;
    lKey: TLabel;
    Contents1: TMenuItem;
    Setup1: TMenuItem;
    DateFormat1: TMenuItem;
    Debug1: TMenuItem;
    RunConversion1: TMenuItem;
    ExportDatabase1: TMenuItem;
    UDEntitydat1: TMenuItem;
    UDField1: TMenuItem;
    UDItemdat1: TMenuItem;
    N2: TMenuItem;
    Properties2: TMenuItem;
    SaveCoordinates2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure tvFieldLstDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure cmbCompanyChange(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
    procedure DateFormat1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RunConversion1Click(Sender: TObject);
    procedure UDEntitydat1Click(Sender: TObject);
    procedure UDField1Click(Sender: TObject);
    procedure UDItemdat1Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure pmMainPopup(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    sCompanyPath : String;
    bSQL, bRestore : boolean;
//    SQLDataModule : TSQLDataModule;  //v6.30.053 - ABSEXCH-9853 removed as it was clashing with the same named variable in DataModule.pas
    Procedure InitField(Const FieldRec : TFieldRec; Node : TTreeNode);
    Procedure InitHeader(Node : TTreeNode);
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    procedure FillCompanyList(cmbComp : TComboBox);
    procedure FillTreeView;
    procedure ClearTreeView;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
  public
    { Public declarations }
  end;

var
  frmUserDefList: TfrmUserDefList;

implementation

{$R *.DFM}

Uses
  EntLicence, BTProc, StrUtil, DetailF, DateForm, ETStrU, ExchequerRelease;

Const
  ImgClear  = 0;
  ImgClosed = 1;
  ImgOpen   = 2;
  ImgYes    = 3;
  ImgNo     = 4;
  ImgWindow = 5;

type
  TCompanyType = Record
    CompCode : string[6];
    CompName : string[45];
    CompPath : string[100];
    CompSpare : array [1..100] of char;
  end;

  TCompanies = Array[1..200] of TCompanyType;
  PCompanies = ^TCompanies;

  function EX_GETCOMPANY(COMPDIR : PCHAR; PARRAY : POINTER; VAR PARRAYSIZE : LONGINT) : SMALLINT; stdCall; external 'EntComp.dll';

{Var
  IniF : TIniFile;}

{-----------------------------------------------------------------------}

Constructor TNodeData.Create(FieldRec : TFieldRec;
                             Node      : TTreeNode);
Var
//  StrValue    : ShortString;
  iStatus : SmallInt;
//  FieldRec : TFieldRec;
  ListItemRec : TListItemRec;
  KeyS : Str255;
Begin { Create }
  Inherited Create;

//  FFieldFolio := FieldRec.fiFolioNo;
  FFieldRec := FieldRec;

  FNode := Node;
  FNodeName := FNode.Text;

//  if FieldRec.fiFolioNo <> MU_BIN_ENTITY then FStrings := TStringList.Create;

//  KeyS := FullNomKey(FieldFolio) + IDX_DUMMY_CHAR;
//  iStatus := Find_Rec(B_GetEq, F[FieldF], FieldF, FieldRec, fiFolioIdx, KeyS);

//  if iStatus = 0 then
//  begin

//    ndCaption := Trim(IniF.ReadString (FieldFolio, 'WindowCaption', ''));
    ndCaption := FieldRec.fiWindowCaption;
//    ndMode := IniF.ReadInteger(FieldFolio, 'Mode', -1);
    ndMode := FieldRec.fiValidationMode;
//    ndFieldFolio := FieldRec.fiFolioNo;
//    FillSLWithListItems(FieldRec.fiFolioNo, FStrings);
{    FillChar(Keys,Sizeof(KeyS),#0);
    KeyS := FullNomKey(FieldRec.fiFolioNo);
    iStatus := Find_Rec(B_GetGEq, F[ListItemF], ListItemF, ListItemRec, liFieldFolioLineIdx, KeyS);
    while (iStatus = 0) and (ListItemRec.liFieldFolio = FieldRec.fiFolioNo) do begin
      FStrings.Add (ListItemRec.liDescription);
      iStatus := Find_Rec(B_GetNext, F[ListItemF], ListItemF, ListItemRec, liFieldFolioLineIdx, KeyS);
    end;{while}
//  end;{if}
End; { Create }

{-------------------------------------------}

Destructor TNodeData.Destroy;
Begin { Destroy }
//  if FFieldRec.fiFolioNo <> MU_BIN_ENTITY then FStrings.Destroy;
  Inherited Destroy;
End; { Destroy }

{-------------------------------------------}

function TNodeData.GetCaption: ShortString;
begin
  Result := FFieldRec.fiWindowCaption;
end;

function TNodeData.GetMode: integer;
begin
  Result := FFieldRec.fiValidationMode;
end;

function TNodeData.GetFieldFolio: integer;
begin
  Result := FFieldRec.fiFolioNo;
end;

Procedure TNodeData.SetCaption(Value : ShortString);
Begin { SetCaption }
  FFieldRec.fiWindowCaption := Value;
  FNode.Text := FNodeName;

  If (FFieldRec.fiWindowCaption <> '')
  and (FFieldRec.fiWindowCaption <> 'Multi-Bin')
  then FNode.Text := FNode.Text + ' - ' + FFieldRec.fiWindowCaption;
End; { SetCaption }

{-------------------------------------------}
(*
Procedure TNodeData.SetEnabled(Value : Boolean);
Begin { SetEnabled }
  FEnabled := Value;

  With FNode Do Begin
    If FEnabled Then
      ImageIndex := ImgYes
    Else
      ImageIndex := ImgNo;

    SelectedIndex := ImageIndex;
  End; { With Node }
End; { SetEnabled }
*)

Procedure TNodeData.SetMode(iMode : integer);
Begin { SetEnabled }
  FFieldRec.fiValidationMode := iMode;

  With FNode Do Begin
    case FFieldRec.fiValidationMode of
      PM_DISABLED : ImageIndex := ImgNo;
      PM_MANDATORY_LIST, PM_OPTIONAL_LIST, PM_VALIDATION_ONLY
      , PM_MANDATORY_DATE, PM_OPTIONAL_DATE : ImageIndex := ImgYes;
    end;{case}

    SelectedIndex := ImageIndex;
  End; { With Node }
End; { SetEnabled }

{-------------------------------------------}

{ Write Data back to .INI file }

Procedure TNodeData.StoreSettings(SQLDataModule : TSQLDataModule);
Var
  iPos, iStatus : integer;
  Keys : str255;
  FieldRec : TFieldRec;
  ListItemRec : TListItemRec;
Begin { StoreSettings }
  if Assigned(SQLDataModule) then
  begin
    // SQL
    SQLDataModule.SQLUpdateField(FFieldRec);
  end
  else
  begin
    // Pervasive

    // find Field Rec
    FillChar(Keys,Sizeof(KeyS),#0);
    KeyS := FullNomKey(FFieldRec.fiFolioNo) + IDX_DUMMY_CHAR;
    iStatus := Find_Rec(B_GetEq, F[FieldF], FieldF, FieldRec, fiFolioIdx, KeyS);
    if iStatus = 0 then
    begin
      // update field rec
      FieldRec := FFieldRec;
      iStatus := Put_Rec(F[FieldF], FieldF, FieldRec, fiFolioIdx);
      if iStatus = 0 then
      begin
        //
      end else
      begin
        ShowBTError(iStatus, 'Put_Rec', FileNames[FieldF]);
      end;{if}
    end else
    begin
      ShowBTError(iStatus, 'Find_Rec', FileNames[FieldF]);
    end;{if}
  end;{if}
End; { StoreSettings }

{-----------------------------------------------------------------------}

procedure TfrmUserDefList.FormCreate(Sender: TObject);
{Var
  L, T, H : LongInt;}

begin
  bRestore := FALSE;

  LoadAllSettings;

  sCompanyPath := '';
  if (UpperCase(Copy(Paramstr(1),1,10)) = '/COMPPATH=')
  then sCompanyPath := WinGetShortPathName(uppercase(trim(IncludeTrailingBackslash(Copy(Paramstr(1),11,255)))));

  FillCompanyList(cmbCompany);

  asCompanyPath := IncludeTrailingBackslash(Trim(TCompanyInfo(cmbCompany.Items.Objects
  [cmbCompany.ItemIndex]).Path));

  bSQL := UsingSQL;
{  if bSQL then
  begin
    SQLDataModule := TSQLDataModule.Create(nil);
    SQLDataModule.Connect(asCompanyPath);
  end;{if}

  if OpenFiles(asCompanyPath) then begin
    RunConversion;
//    if FileExists(asCompanyPath + INI_FILENAME)
//    then MoveFile(PChar(asCompanyPath + INI_FILENAME), PChar(asCompanyPath + 'ENTUSERF.ONO'));
  end;{if}
//  AddMuBinSupport;
//  AddAppsAndValsSupport;
//  AddReturnsSupport;

//  IniF := TIniFile.Create(IncludeTrailingBackslash(Trim(TCompanyInfo(cmbCompany.Items.Objects
//  [cmbCompany.ItemIndex]).Path)) + INI_FILENAME);

//sDateFormat := IniF.ReadString('General', 'DateFormat','dd/mm/yyyy');

  Caption := Application.Title;
  if sCompanyPath <> '' then Caption := Caption + ' (Trade)';
  Icon := application.Icon;

  { Read Window Settings from .INI }
(*  With IniF Do Begin
    { Left }
    L := ReadInteger ('Admin', 'Left',   Self.Left);
    If (L >= 0) Then Begin
       If ((L + Self.Width) < Screen.Width) Then
         Self.Left := L
       Else
         Self.Left := Screen.Width - Self.Width;
    End { If }
    Else
      Self.Left := 1;

    { Top }
    T := ReadInteger ('Admin', 'Top',    Self.Top);
    If (T >= 0) Then
      Self.Top := T
    Else
      Self.Top := 1;

    { Height }
    H := ReadInteger ('Admin', 'Height', Self.Height);
    If ((Self.Top + H) < Screen.Height) Then
      Self.Height := H
    Else Begin
      { Overruns edge }
      If (H < Screen.Height) Then Begin
        Self.Top := Screen.Height - H;
        Self.Height := H;
      End { If }
      Else Begin
        Self.Top := 1;
        Self.Height := Screen.Height - 2;
      End; { Else }
    End; { Else }
  End; { With }*)

//  FillTreeView;
  cmbCompanyChange(cmbCompany);

  {$IFDEF EX600}
    lKey.Caption := '* Only available in Exchequer v5.00.002 and above';
  {$ENDIF}
end;

{-------------------------------------------}

procedure TfrmUserDefList.FormDestroy(Sender: TObject);
begin

  ClearTreeView;

  if bSQL and Assigned(SQLDataModule) then
  begin
    SQLDataModule.Disconnect;
    SQLDataModule.Free;
  end;{if}
  { Write settings to .INI
  With IniF Do Begin
    WriteInteger ('Admin', 'Left',   Self.Left);
    WriteInteger ('Admin', 'Top',    Self.Top);
    WriteInteger ('Admin', 'Height', Self.Height);
  End; { With IniF }
end;

{-------------------------------------------}

Procedure TfrmUserDefList.InitHeader(Node : TTreeNode);
Begin { InitHeader }
  With Node Do Begin
    Data := Nil;

    ImageIndex := ImgWindow;
    SelectedIndex := ImgWindow;
  End; { With Node }
End; { InitHeader }

{-------------------------------------------}

Procedure TfrmUserDefList.InitField(Const FieldRec : TFieldRec;
                                 Node      : TTreeNode);
Begin { InitField }
  With Node Do Begin
    { Create sub-class to contain data }
    Node.Data := TNodeData.Create(FieldRec, Node);

    { Make any enabled fields visible automatically }
    If TNodeData(Node.Data).ndMode <> PM_DISABLED Then
      Node.Parent.Expanded := True;
  End; { With Node }
End; { InitField }

{-------------------------------------------}

procedure TfrmUserDefList.tvFieldLstDblClick(Sender: TObject);
begin
  { Check a node is selected }
  If Assigned(tvFieldLst.Selected) Then
    { Check it is a field node, not a category node }
    If Assigned(tvFieldLst.Selected.Data) Then
      { display edit dialog }
      frmDetails.DisplayNodeData(tvFieldLst.Selected, SQLDataModule);
end;

{-------------------------------------------}

procedure TfrmUserDefList.About1Click(Sender: TObject);
begin
  {$IFDEF EX600}
      // CA 09/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated    v6.9.059
      // MH 19/06/2014 v7.0.11 ABSEXGENERIC-356: Updated version number for Louise - no code changes
    MessageDlg ('Exchequer User-Defined Field Plug-In Configuration' + #13#13 +
                ExchequerModuleVersion (emGenericPlugIn, '064') + #13#13 +
                DoubleAmpers(GetCopyrightMessage) + #13 +
                'All rights reserved.', mtInformation, [mbOk], 0);
  {$ELSE}
    MessageDlg ('Exchequer User-Defined Field Plug-In Configuration'+ #13#13
    + 'v5.71.057' + #13#13 + GetCopyrightMessage + #13
    + 'All rights reserved.', mtInformation, [mbOk], 0);
  {$ENDIF}

  {NOTE: the a denotes a change in the admin module, but not in the main plug-in, so that the number still matches the plug-in}
end;

procedure TfrmUserDefList.Exit1Click(Sender: TObject);
begin
  Close;
end;

Procedure TfrmUserDefList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ do Begin
//    ptMinTrackSize.X:=Self.Width;
    ptMinTrackSize.X := 377;
    ptMinTrackSize.Y := 190;

//    ptMaxTrackSize.X:=Self.Width;
    ptMaxTrackSize.X := 377;
    ptMaxTrackSize.Y := 1000;
  end;

  Message.Result:=0;

  Inherited;
end;

procedure TfrmUserDefList.FillCompanyList(cmbComp : TComboBox);
var
  CompDir : array[0..255] of char;
  CompArray : PCompanies;
  iArrayItems, iPos : longint;
  iStatus : smallint;
  CompanyInfo : TCompanyInfo;
begin
  new(CompArray);
  StrPCopy(CompDir, ExtractFilePath(Application.ExeName));
  StrPCopy(CompDir, GetEnterpriseDirectory);
  iArrayItems := SizeOf(CompArray^);
  iStatus := EX_GETCOMPANY(CompDir, CompArray, iArrayItems);
  if iStatus = 0 then
    begin
      for iPos := 1 to iArrayItems do begin
        with CompArray^[iPos] do begin

          CompanyInfo := TCompanyInfo.Create;
          with CompanyInfo do begin
            Name := CompName;
            Code := CompCode;
            Path := CompPath;
          end;{with}
          cmbComp.Items.AddObject(CompName, CompanyInfo);
        end;{with}
      end;{for}

      if cmbComp.Items.Count > 0 then begin
        cmbComp.ItemIndex := 0; // select first company
        if sCompanyPath <> '' then begin
          // select company that matches path that was passed in as command line param.
          For iPos := 0 to cmbComp.Items.Count - 1 do begin
            if (UpperCase(IncludeTrailingBackslash(Trim(TCompanyInfo(cmbCompany.Items.Objects[iPos]).Path)))
            = sCompanyPath) then cmbComp.ItemIndex := iPos;
          end;{for}
        end;{if}
      end;{if}

      cmbComp.Enabled := (sCompanyPath = '') and (cmbComp.Items.Count > 1);

    end
  else ShowMessage('Error ' + IntToStr(iStatus) + ' occurred whilst reading the company list');
  dispose(CompArray);
end;

procedure TfrmUserDefList.cmbCompanyChange(Sender: TObject);
begin
//  IniF.Destroy;
//  IniF := TIniFile.Create(IncludeTrailingBackslash(Trim(TCompanyInfo(cmbCompany.Items.Objects
//  [cmbCompany.ItemIndex]).Path)) + 'ENTUSERF.INI');

  Screen.cursor := crHourGlass;

  if bSQL and Assigned(SQLDataModule) then
  begin
    SQLDataModule.Disconnect;
    SQLDataModule.Free;
  end;{if}

  CloseFiles;
  asCompanyPath := IncludeTrailingBackslash(Trim(TCompanyInfo(cmbCompany.Items.Objects
  [cmbCompany.ItemIndex]).Path));

  if bSQL then
  begin
    SQLDataModule := TSQLDataModule.Create(nil);
    SQLDataModule.Connect(asCompanyPath);
  end
  else
  begin
    SQLDataModule := nil;
  end;{if}

  if OpenFiles(asCompanyPath) then begin
    RunConversion;
//    if FileExists(asCompanyPath + INI_FILENAME)
//    then MoveFile(PChar(asCompanyPath + INI_FILENAME), PChar(asCompanyPath + 'ENTUSERF.ONO'));
  end;{if}
//  AddMuBinSupport;
//  AddAppsAndValsSupport;
//  AddReturnsSupport;

  FillTreeView;

  Screen.cursor := crDefault;
end;

procedure TfrmUserDefList.FillTreeView;
var
  iCounter : integer;
  NewNode : TTreeNode;

(*  procedure InitialiseTreeView;
  var
    NewNode : TTreeNode;
    iField : byte;
  begin
    With tvFieldLst, Items Do Begin
      NewNode := Add(nil, 'Customer');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Supplier');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Transaction Line (All Types)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Transaction Header (All Types)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Sales Invoice Headers (SIN, SCR, SJI, SJC, SRI, SRF)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Sales Invoice Lines (SIN, SCR, SJI, SJC, SRI, SRF)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Sales Receipt Headers (SRC)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Sales Receipt Lines (SRC)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Sales Quotation Headers (SQU)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Sales Quotation Lines (SQU)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Sales Order & Delivery Note Headers (SOR, SDN)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Sales Order & Delivery Note Lines (SOR, SDN)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Purchase Invoice Headers (PIN, PCR, PJI, PJC, PPI, PRF)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Purchase Invoice Lines (PIN, PCR, PJI, PJC, PPI, PRF)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Purchase Payment Headers (PPY)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Purchase Payment Lines (PPY)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Purchase Quotation Headers (PQU)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Purchase Quotation Lines (PQU)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Purchase Order & Delivery Note Headers (POR, PDN)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Purchase Order & Delivery Note Lines (POR, PDN)');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Nominal Headers (NOM) *');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Nominal Lines (NOM) *');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Stock Record *');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Stock Adjustment Headers (ADJ) *');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Stock Adjustment Lines (ADJ) *');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Works Order Headers (WOR) *');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Works Order Lines (WOR) *');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Job Record');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Employee Record *');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Timesheet Headers (TSH) *');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

      NewNode := Add(nil, 'Timesheet Lines (TSH) *');
      For iField := 1 to 4 do AddChild(NewNode,'Field ' + intToStr(iField));

    end;{with}
  end;{InitialiseTreeView}*)

  function GetNextItemNo : integer;
  begin
    inc(iCounter);
    Result := iCounter;
  end;

  function SkipCategory(EntityRec : TEntityRec) : boolean;
  begin{SkipCategory}
    Result := FALSE;

    // Don't show SOP fields for non-SOP systems
{    if ((EntityRec.etDescription = aEntityDescs[9]) // SQUHead
    or (EntityRec.etDescription = aEntityDescs[10]) // SQULine
    or (EntityRec.etDescription = aEntityDescs[17]) // PQUHead
    or (EntityRec.etDescription = aEntityDescs[18]))// PQULine
    and (EnterpriseLicence.elModuleVersion in [mvBase, mvStock])
    then Result := TRUE;}

    // Don't show SOP fields for non-SOP systems
    // {.o45a} Fixed so that it disables the SOR/POR entries, NOT the SQU/PQU entries
    if ((EntityRec.etDescription = aEntityDescs[11]) // SORHead
    or (EntityRec.etDescription = aEntityDescs[12]) // SORLine
    or (EntityRec.etDescription = aEntityDescs[19]) // PORHead
    or (EntityRec.etDescription = aEntityDescs[20]))// PORLine
    and (EnterpriseLicence.elModuleVersion in [mvBase, mvStock])
    then Result := TRUE;

    // Don't show Stock fields for non-stock systems
    if ((EntityRec.etDescription = aEntityDescs[23])
    or (EntityRec.etDescription = aEntityDescs[24])
    or (EntityRec.etDescription = aEntityDescs[25])
    or (EntityRec.etDescription = ENTITY_MUBIN))
    and (EnterpriseLicence.elModuleVersion in [mvBase])
    then Result := TRUE;

    // Don't show WOR fields for non-WOR systems
    if ((EntityRec.etDescription = aEntityDescs[26])
    or (EntityRec.etDescription = aEntityDescs[27]))
    and ((EnterpriseLicence.elModules[modStdWOP] in [mrNone])
    and (EnterpriseLicence.elModules[modProWOP] in [mrNone]))
    then Result := TRUE;

    // Don't show JC fields for non-JC systems
    if ((EntityRec.etDescription = aEntityDescs[28])
    or (EntityRec.etDescription = aEntityDescs[29])
    or (EntityRec.etDescription = aEntityDescs[30])
    or (EntityRec.etDescription = aEntityDescs[31]))
    and (EnterpriseLicence.elModules[modJobCost] in [mrNone])
    then Result := TRUE;

    // Don't show Apps&Vals fields for non-Apps&Vals systems
    if ((EntityRec.etDescription = aAVTXTypeDesc[1])
    or (EntityRec.etDescription = aAVTXTypeDesc[2])
    or (EntityRec.etDescription = aAVTXTypeDesc[3])
    or (EntityRec.etDescription = aAVTXTypeDesc[4])
    or (EntityRec.etDescription = aAVTXTypeDesc[5])
    or (EntityRec.etDescription = aAVTXTypeDesc[6])
    or (EntityRec.etDescription = aAVTXTypeDesc[7])
    or (EntityRec.etDescription = aAVTXTypeDesc[8])
    or (EntityRec.etDescription = aAVTXTypeDesc[9])
    or (EntityRec.etDescription = aAVTXTypeDesc[10]))
    and (EnterpriseLicence.elModules[modAppVal] in [mrNone])
    then Result := TRUE;

    // Don't show Returns fields for non-Returns systems
    if ((EntityRec.etDescription = aTXTypeDesc[1])
    or (EntityRec.etDescription = aTXTypeDesc[2])
    or (EntityRec.etDescription = aTXTypeDesc[3])
    or (EntityRec.etDescription = aTXTypeDesc[4]))
    and (EnterpriseLicence.elModules[modGoodsRet] in [mrNone])
    then Result := TRUE;
  end;{SkipCategory}

var
  iStatus : integer;
  EntityRec : TEntityRec;
  FieldRec : TFieldRec;
  KeyS, KeyS2 : str255;
  bSkip : boolean;
  qFields, qCategories : TADOQuery;
begin
  { Expand all categories & Read properties from .INI }
  With tvFieldLst, Items Do Begin

    ClearTreeView;

    if Assigned(SQLDataModule) then
    begin
      // SQL
      // NF: Yes, I know this is not the best or most efficient way of doing this, but in the interests of getting this done rapidly, and incurring less bugs, it is easier & safer to convert the existing pervasive code....

      qCategories := SQLDataModule.SQLGetAllCategories;

      iCounter := -1;

      qCategories.First;
      while not qCategories.Eof do begin

        // populate entity record
        FillChar(EntityRec, SizeOf(EntityRec), #0);
        EntityRec.etFolioNo := qCategories.FieldByName('etFolioNo').AsInteger;
        EntityRec.etDescription := qCategories.FieldByName('etDescription').AsString;
        EntityRec.etType := 'C';
        EntityRec.etFormat := qCategories.FieldByName('etFormat').AsString;
        EntityRec.etDummyChar := IDX_DUMMY_CHAR;

        if not SkipCategory(EntityRec) then
        begin
          NewNode := Add(nil, EntityRec.etDescription);
          InitHeader(Items[GetNextItemNo]);

          // Get Fields for Entity
          qFields := SQLDataModule.SQLGetAllFieldsForEntity(EntityRec.etFolioNo);

          qFields.First;
          while not qFields.Eof do
          begin
            // populate field rec
            FillChar(FieldRec, SizeOf(FieldRec), #0);
            FieldRec.fiFolioNo := qFields.FieldByName('fiFolioNo').AsInteger;
            FieldRec.fiEntityFolio := EntityRec.etFolioNo;
            FieldRec.fiLineNo := qFields.FieldByName('fiLineNo').AsInteger;
            FieldRec.fiDescription := qFields.FieldByName('fiDescription').AsString;
            FieldRec.fiValidationMode := qFields.FieldByName('fiValidationMode').AsInteger;
            FieldRec.fiWindowCaption := qFields.FieldByName('fiWindowCaption').AsString;
            FieldRec.fiLookupRef := qFields.FieldByName('fiLookupRef').AsString;
            FieldRec.fiDummyChar := IDX_DUMMY_CHAR;

            AddChild(NewNode, FieldRec.fiDescription);
            InitField(FieldRec, Items[GetNextItemNo]);

            qFields.Next;
          end;{while}

          qFields.Close;
          qFields := nil;
        end;{if}

        qCategories.Next;
      end;{while}

      qCategories.Close;
      qCategories := nil;
    end
    else
    begin
      // Pervasive

      iCounter := -1;

      // Get all Entities
      FillChar(Keys,Sizeof(KeyS),#0);
      iStatus := Find_Rec(B_GetFirst, F[EntityF], EntityF, EntityRec, etFolioIdx, KeyS);
      while (iStatus = 0) do begin

        if EntityRec.etType = ET_CATEGORY then begin

          if not SkipCategory(EntityRec) then
          begin
            NewNode := Add(nil, EntityRec.etDescription);
            InitHeader(Items[GetNextItemNo]);

            // Get Fields for Entity
            FillChar(Keys2,Sizeof(KeyS2),#0);
            KeyS2 := FullNomKey(EntityRec.etFolioNo);
            iStatus := Find_Rec(B_GetGEq, F[FieldF], FieldF, FieldRec, fiEntityFolioIdx, KeyS2);

            while (iStatus = 0) and (EntityRec.etFolioNo = FieldRec.fiEntityFolio) do
            begin
              AddChild(NewNode, FieldRec.fiDescription);
              InitField(FieldRec, Items[GetNextItemNo]);
              iStatus := Find_Rec(B_GetNext, F[FieldF], FieldF, FieldRec, fiEntityFolioIdx, KeyS2);
            end;{while}
          end;{if}
        end;{if}

        iStatus := Find_Rec(B_GetNext, F[EntityF], EntityF, EntityRec, etFolioIdx, KeyS);
      end;{while}
    end;{if}
  End;{ With tvFieldLst }
end;

procedure TfrmUserDefList.ClearTreeView;
var
  NodeData : TNodeData;
  I        : SmallInt;
begin
  { De-allocate all NodeData items }
  If (tvFieldLst.Items.Count > 0) Then
    For I := 0 To Pred(tvFieldLst.Items.Count) Do
      With tvFieldLst.Items[I] Do
        If Assigned(Data) Then Begin
          NodeData := TNodeData(Data);
          NodeData.Destroy;

          Data := Nil;
        End; { If Assigned(Data) }

  tvFieldLst.Items.Clear;
end;

procedure TfrmUserDefList.Contents1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;

procedure TfrmUserDefList.DateFormat1Click(Sender: TObject);
begin
  with TfrmDateFormat.create(self) do begin
    SetCombos(GetDateFormat(SQLDataModule));
    if showmodal = mrOK then begin
      SetDateFormat(cmbFormat.Items[cmbFormat.ItemIndex], SQLDataModule);
    end;{if}
    release;
  end;{with}
end;

procedure TfrmUserDefList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
//  With IniF Do Begin
//    EraseSection ('General');
//WriteString('General', 'DateFormat', sDateFormat);
//    UpdateFile;
//  End; { With IniF }
end;

procedure TfrmUserDefList.RunConversion1Click(Sender: TObject);
begin
  RunConversion;
//  AddMuBinSupport;
//  AddAppsAndValsSupport;
//  AddReturnsSupport;
end;

procedure TfrmUserDefList.UDEntitydat1Click(Sender: TObject);
var
  KeyS : str255;
  EntityRec  : TEntityRec;
  iStatus : integer;
  sFileName : string;
begin
  sFileName := asCompanyPath + 'UDEntity.txt';
  DeleteFile(sFileName);
  FillChar(KeyS, SizeOf(KeyS), #0);
  iStatus := Find_Rec(B_GetFirst, F[EntityF], EntityF, EntityRec, TWinControl(Sender).Tag, KeyS);
  while iStatus = 0 do begin
    with EntityRec do begin
      AddLineToFile(IntToStr(etFolioNo) + ' '
      + etDescription + ' '
      + etType + ' '
      + etFormat + ' '
      + etDummyChar
      , sFileName);
    end;{with}

    iStatus := Find_Rec(B_GetNext, F[EntityF], EntityF, EntityRec, TWinControl(Sender).Tag, KeyS);
  end;{while}
  ShowMessage('File Export Completed (' + sFileName + ')');
end;

procedure TfrmUserDefList.UDField1Click(Sender: TObject);
var
  KeyS : str255;
  FieldRec  : TFieldRec;
  iStatus : integer;
  sFileName : string;
begin
  sFileName := asCompanyPath + 'UDField.txt';
  DeleteFile(sFileName);
  FillChar(KeyS, SizeOf(KeyS), #0);
  iStatus := Find_Rec(B_GetFirst, F[FieldF], FieldF, FieldRec, TWinControl(Sender).Tag, KeyS);
  while iStatus = 0 do begin
    with FieldRec do begin
      AddLineToFile(PadString(psRight, IntToStr(fiFolioNo), ' ', 4) + ' '
      + PadString(psRight, IntToStr(fiEntityFolio), ' ', 4) + ' '
      + PadString(psRight, IntToStr(fiLineNo), ' ', 4) + ' '
      + PadString(psRight, fiDescription, ' ', 20) + ' '
      + PadString(psRight, IntToStr(fiValidationMode), ' ', 4) + ' '
      + PadString(psRight, fiWindowCaption, ' ', 30) + ' '
      + PadString(psRight, StringToCodes(fiLookupRef), ' ', 10) + ' '
      + fiDummyChar
      , sFileName);
    end;{with}

    iStatus := Find_Rec(B_GetNext, F[FieldF], FieldF, FieldRec, TWinControl(Sender).Tag, KeyS);
  end;{while}
  ShowMessage('File Export Completed (' + sFileName + ')');
end;

procedure TfrmUserDefList.UDItemdat1Click(Sender: TObject);
var
  KeyS : str255;
  ListItemRec  : TListItemRec;
  iStatus : integer;
  sFileName : string;
begin
  sFileName := asCompanyPath + 'UDItem.txt';
  DeleteFile(sFileName);
  FillChar(KeyS, SizeOf(KeyS), #0);
  iStatus := Find_Rec(B_GetFirst, F[ListItemF], ListItemF, ListItemRec, TWinControl(Sender).Tag, KeyS);
  while iStatus = 0 do begin
    with ListItemRec do begin
      AddLineToFile(IntToStr(liFieldFolio) + ' '
      + IntToStr(liLineNo) + ' '
      + liDescription + ' '
      + liDummyChar
      , sFileName);
    end;{with}

    iStatus := Find_Rec(B_GetNext, F[ListItemF], ListItemF, ListItemRec, TWinControl(Sender).Tag, KeyS);
  end;{while}
  ShowMessage('File Export Completed (' + sFileName + ')');
end;

procedure TfrmUserDefList.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, cmbCompany) of
    mrOK : oSettings.ColorFieldsFrom(cmbCompany, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmUserDefList.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(cmbCompany, Self.Name);
  if SaveCoordinates2.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmUserDefList.LoadAllSettings;
begin
  sMiscDirLocation := GetEnterpriseDirectory;
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, cmbCompany);
  oSettings.ColorFieldsFrom(cmbCompany, Self);
end;

procedure TfrmUserDefList.pmMainPopup(Sender: TObject);
begin
  mnuProperties.enabled := Assigned(tvFieldLst.Selected) and Assigned(tvFieldLst.Selected.Data);
end;

procedure TfrmUserDefList.FormResize(Sender: TObject);
begin
  lKey.Top := ClientHeight - 19;
  tvFieldLst.Height := ClientHeight - 96;
end;

Initialization
{  IniF := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ENTUSERF.INI');}
Finalization
//  IniF.Destroy;
end.

