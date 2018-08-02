unit EntWindowSettings;
{Contains the Interface into the new Window Positioning System. This unit should be the only one that is used by forms which
 use the system, and all access should be through an IWindowSettings interface returned by the function
   GetWindowsInterface.

 The Define 'NoBtrieveList' can be used by programs which don't use EL's lists in order to avoid compiling most of Exchequer in.}
//PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Turn off platform warnings
{$WARN SYMBOL_PLATFORM OFF}
interface

uses
  EntSettings, EntParentSettings, EntColumnSettings, Forms, Controls, ComCtrls, uMultiList, CommCtrl, Windows;

const
  //mrRestoreDefaults is used by NF's settings dialog  - X:\COMPON\MultiList\EditSettEnt.pas
  mrRestoreDefaults = mrRetry;

  //Indicates to DeleteSettings whether we are deleting settings for Window, User or Exe
  dsWindow = 1;
  dsUser   = 2;
  dsExe    = 3;

type
  IWindowSettings = Interface
    //Getters/Setters
    function GetExeName : string;
    function GetUserName : string;
    function GetWindowName : string;

    function GetCompanyPath: string;

    function GetUseDefaults: Boolean;

    function GetListOffset : Integer;
    procedure SetListOffset(Value : Integer);

    //"Public" functions

    //Load from and save to database
    function LoadSettings : Integer;
    function SaveSettings(SaveWindowPos : Boolean) : Integer;

    //Procedures to store and set Windows & Components

    //Window settings
    procedure SettingsToWindow(const AForm : TCustomForm);
    procedure WindowToSettings(const AForm : TCustomForm);

    //AParent is the container for the controls - eg TPanel, TTabSheet. ExampleControl is the control
    //whose colour/font we want to use. For TMultiList or TMulCtrl (BtrieveList) both AParent and ExampleControl
    //should be the same list control
    procedure SettingsToParent(const AParent : TWinControl);
    procedure ParentToSettings(const AParent : TWinControl; ExampleControl : TWinControl);

    //Edit Colours/Fonts for a container - parameters are the same as ParentToSettings. Returns mrOK or mrCancel
    //or mrRestoreDefaults (mrRestoreDefaults can be ignored by the caller, as the required action has already been
    //taken in the function.
    //Uses NF's settings dialog  - X:\COMPON\MultiList\EditSettEnt.pas
    function Edit(const AParent : TWinControl; const ExampleControl : TWinControl) : TModalResult;

    //Deletes all settings for the user in all 3 tables
    procedure DeleteAllSettingsForUser;
    //Deletes all settings for all users
    procedure DeleteAllSettings;
    procedure DeleteWindowSettings;
    //Properties

    //Key fields - read only to stop them being changed once settings have been loaded
    property ExeName : string read GetExeName;
    property UserName : string read GetUserName;
    property WindowName : string read GetWindowName;

    property CompanyPath : string read GetCompanyPath;

    //Use defaults - automatically set to true if no settings could be read
    property UseDefaults : Boolean read GetUseDefaults;

    //There is a ListOfSet variable on all EL's list forms which specifies the width of the divider - AFAIK it is always 10,
    //which this property will default to. However, it's worth allowing it to be changed just in case.
    //The only place it will be used is in TWindowSettings.SettingsToBtrieveList where it is used in the
    //call to VisiList.SetHedPanel
    property ListOffset : Integer read GetListOffset write SetListOffset;

  end;

  function GetWindowSettings(const sDataPath   : string;
                             const sExeName    : string;
                             const sUserID     : string;
                             const sWindowName : string) : IWindowSettings; overload;

  //Declaration for use in Enter1 - takes most of the parameters from global data
  {$IFNDEF NoBtrieveLists}
   function GetWindowSettings(const sWindowName : string) : IWindowSettings; overload;
  {$ENDIF NoBtrieveLists}

implementation

uses
  SQLUtils, Classes, Contnrs, BtKeys1U, EtMiscU, EtStrU,
  {$IFNDEF NoBtrieveLists}
   GlobVar,
   VarConst,
   SBSComp,
   SBSComp2,
  {$ENDIF NoBtrieveLists}
  SysUtils, EditSettEnt, ApiUtil, Dialogs, ExtCtrls,

  //Units required for Pervasive data access
  EntSettingsPervasive, BTUtil, BTConst, BtrvU2,

  //Units required for MS-SQL data access
  Variants, SQLCallerU, DB, ADODB, ADOConnect;

//Queries for MS-SQL version
const
  S_DEF_QUERY = 'SELECT * FROM [COMPANY].[%S] WHERE ';
  S_WINDOW_QUERY = 'wpExeName = ''%s'' AND wpUserName = ''%s'' AND wpWindowName = ''%s''';
  S_PARENT_QUERY = 'psExeName = ''%s'' AND psUserName = ''%s'' AND psWindowName = ''%s''';
  S_COLUMN_QUERY = 'csExeName = ''%s'' AND csUserName = ''%s'' AND csWindowName = ''%s''';

var
  WPClientIds : TBits;

type
  TParentArray = Array of TWinControl;

  TBaseWindowSettingsObject = Class(TInterfacedObject)
  private
    FExeName        : string;
    FUserName       : string;
    FWindowName     : string;
    FWindowPosition : TWindowPositionRec;
    FCompanyPath    : string;
    FParentArray    : TParentArray;
    FWindowPositionLoaded : Boolean;
    FListOffset     : Integer;
    function BuildWindowKey : string;
    function BuildUserKey : string;
    function BuildExeKey : string;
    function BuildParentKey(const Value : string) : string;
    function BuildColumnKey(const ParentKey : string; ColumnNo : Integer) : string;
    function GetUseDefaults: Boolean;
    function GetCompanyPath: string;
    procedure SetCompanyPath(const Value: string);
    procedure SettingsToMultiList(const AList : TMultiList);
    procedure MultiListToSettings(const AList : TMultiList);
    procedure SettingsToListView(const AList : TListView);
    procedure ListViewToSettings(const AList : TListView);
    {$IFNDEF NoBtrieveLists}
    procedure SettingsToBtrieveList(const AList : TMULCtrl);
    procedure BtrieveListToSettings(const AList : TMULCtrl);
    {$ENDIF NoBtrieveLists}
    procedure DeleteSettings(WhichSettings : Integer = dsWindow); virtual;
    function GetListOffset: Integer;
    procedure SetListOffset(Value: Integer);
  protected
    FParents : TObjectList;
    FColumns : TObjectList;
    FIsDirty : Boolean;
    FUseDefaults : Boolean;
    FResetToDefaults : Boolean;

    function GetExeName : string;
    procedure SetExeName(const Value : string);

    function GetUserName : string;
    procedure SetUserName(const Value : string);

    function GetWindowName : string;
    procedure SetWindowName(const Value : string);

    function GetLeft : Integer;
    procedure SetLeft(Value : Integer);

    function GetTop : Integer;
    procedure SetTop(Value : Integer);

    function GetWidth : Integer;
    procedure SetWidth(Value : Integer);

    function GetHeight : Integer;
    procedure SetHeight(Value : Integer);

    function LoadSettings : Integer; virtual;
    function SaveSettings(SaveWindowPos : Boolean) : Integer; virtual;

    function ParentRec(const ParentName : string) : TParentSettings;
    function ColumnRec(const ParentName : string; ColumnNo : Integer) : TColumnSettings;

    function LoadWindowPosition  : Integer; virtual; abstract;
    function LoadParentSettings  : Integer; virtual; abstract;
    function LoadColumnSettings  : Integer; virtual; abstract;

    function SaveWindowPosition  : Integer; virtual; abstract;
    function SaveParentSettings  : Integer; virtual; abstract;
    function SaveColumnSettings  : Integer; virtual; abstract;

    property ExeName : string read FExeName write SetExeName;
    property UserName : string read FUserName write SetUserName;
    property WindowName : string read FWindowName write SetWindowName;


    property Left : Integer read GetLeft write SetLeft;
    property Top : Integer read GetTop write SetTop;
    property Width : Integer read GetWidth write SetWidth;
    property Height : Integer read GetHeight write SetHeight;

    function AddParent(const sName : string) : TParentSettings;
    function AddColumn(const sParentName : string; iColNo : Integer) : TColumnSettings;

    property CompanyPath : string read GetCompanyPath write SetCompanyPath;

    procedure SettingsToWindow(const AForm : TCustomForm);
    procedure WindowToSettings(const AForm : TCustomForm);

    procedure SettingsToParent(const AParent : TWinControl);
    procedure ParentToSettings(const AParent : TWinControl; ExampleControl : TWinControl);

    function Edit(const AParent : TWinControl; const ExampleControl : TWinControl) : TModalResult;
    property ListOffset : Integer read GetListOffset write SetListOffset;

  public
    constructor Create(const sDataPath   : string;
                       const sExeName    : string;
                       const sUserID     : string;
                       const sWindowName : string);
    destructor Destroy; override;
    property UseDefaults : Boolean read GetUseDefaults;
  end;

  TPervasiveWindowSettingsObject = Class(TBaseWindowSettingsObject, IWindowSettings)
  private
    FWindowFileVar : TFileVar;
    FParentFileVar : TFileVar;
    FColumnFileVar : TFileVar;
    FClientID : TClientIDRec;
    FiCID : Integer;

    procedure OpenFiles;
    procedure CloseFiles;
  protected
    function LoadWindowPosition  : Integer; override;
    function LoadParentSettings  : Integer; override;
    function LoadColumnSettings  : Integer; override;

    function SaveWindowPosition  : Integer; override;
    function SaveParentSettings  : Integer; override;
    function SaveColumnSettings  : Integer; override;

    procedure DeleteSettings(WhichSettings : Integer = dsWindow); override;
    procedure DeleteAllSettingsForUser;
    procedure DeleteAllSettings;
    procedure DeleteWindowSettings;
   public
    constructor Create(const sDataPath   : string;
                       const sExeName    : string;
                       const sUserID     : string;
                       const sWindowName : string);
    destructor Destroy; override;
  end;

  TSQLWindowSettingsObject = Class(TBaseWindowSettingsObject, IWindowSettings)
  private
    FClientID : TClientIDRec;
    FiCID : Integer;
    FCompanyCode : string;
  protected
    FWindowCaller : TSQLCaller;
    FParentCaller : TSQLCaller;
    FColumnCaller : TSQLCaller;

    function LoadWindowPosition  : Integer; override;
    function LoadParentSettings  : Integer; override;
    function LoadColumnSettings  : Integer; override;

    function SaveWindowPosition  : Integer; override;
    function SaveParentSettings  : Integer; override;
    function SaveColumnSettings  : Integer; override;


    function WindowQuery(const PFix : string) : string;

    procedure RecordToParent(const AParentObj : TParentSettings);
    procedure ParentToRecord(const AParentObj : TParentSettings);

    procedure RecordToColumn(const AColumnObj : TColumnSettings);
    procedure ColumnToRecord(const AColumnObj : TColumnSettings);

    procedure DeleteSettings(WhichSettings : Integer = dsWindow); override;
    procedure DeleteAllSettingsForUser;
    procedure DeleteAllSettings;
    procedure DeleteWindowSettings;
  public
    constructor Create(const sDataPath   : string;
                       const sExeName    : string;
                       const sUserID     : string;
                       const sWindowName : string);
    destructor Destroy; override;
  end;


//  ========================================================================================================================  //


function GetWindowSettings(const sDataPath   : string;
                           const sExeName    : string;
                           const sUserID     : string;
                           const sWindowName : string) : IWindowSettings;
begin
  if SQLUtils.UsingSQL then
    Result := TSQLWindowSettingsObject.Create(sDataPath, sExeName, sUserID, sWindowName)
  else
    Result := TPervasiveWindowSettingsObject.Create(sDataPath, sExeName, sUserID, sWindowName);
end;

{$IFNDEF NoBtrieveLists}
function GetWindowSettings(const sWindowName : string) : IWindowSettings;
begin
  Result := GetWindowSettings(SetDrive, ExtractFilename(GetModuleName(HInstance)), EntryRec.LogIn, sWindowName);
end;
{$ENDIF NoBtrieveLists}


Procedure Prime_ClientIdRec(Var  CIdRec  :  TClientIdRec;
                                 AId     :  String;
                                 TId     :  SmallInt);
Begin
  FillChar(CIDRec,Sizeof(CIdRec),0);

  With CIDRec do
  Begin
    APPId[1]:=AId[1];
    APPId[2]:=AId[2];

    TaskId:=TId;
  end;
end;


{ TBaseWindowSettingsObject }

function TBaseWindowSettingsObject.BuildColumnKey(const ParentKey : string; ColumnNo : Integer): string;
begin
  Result := BuildParentKey(ParentKey) + FullNomKey(ColumnNo) + '!';
end;

function TBaseWindowSettingsObject.BuildParentKey(const Value : string) : string;
begin
  Result := BuildWindowKey + LJVar(Value, COMP_NAME_LENGTH);
end;

function TBaseWindowSettingsObject.BuildWindowKey: string;
begin
  Result := FExeName + FUserName + FWindowName;
end;

function TBaseWindowSettingsObject.ColumnRec(const ParentName: string;
  ColumnNo: Integer): TColumnSettings;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to FColumns.Count - 1 do
    with (FColumns[i] as TColumnSettings)do
    if (UpperCase(Trim(csParentName)) = UpperCase(Trim(ParentName))) and (csColumnNo = ColumnNo) then
    begin
      Result := FColumns[i] as TColumnSettings;
      Break;
    end;
end;

constructor TBaseWindowSettingsObject.Create(const sDataPath   : string;
                                             const sExeName    : string;
                                             const sUserID     : string;
                                             const sWindowName : string);
begin
  inherited Create;
  FParents := TObjectList.Create;
  FParents.OwnsObjects := True;

  FColumns := TObjectList.Create;
  FColumns.OwnsObjects := True;

  FillChar(FWindowPosition, SizeOf(FWindowPosition), 0);
  FIsDirty := False;
  FUseDefaults := False;
  FWindowPositionLoaded := False;
  FResetToDefaults := False;
  FListOffset := 10;

  ExeName := sExeName;
  UserName := sUserID;
  WindowName := sWindowName;
  CompanyPath := sDataPath;



end;

destructor TBaseWindowSettingsObject.Destroy;
begin
  FParents.Free;
  FColumns.Free;
  inherited;
end;

function TBaseWindowSettingsObject.GetCompanyPath: string;
begin
  Result := FCompanyPath;
end;

function TBaseWindowSettingsObject.GetExeName: string;
begin
  Result := FExeName;
end;

function TBaseWindowSettingsObject.GetHeight: Integer;
begin
  Result := FWindowPosition.wpHeight;
end;

function TBaseWindowSettingsObject.GetLeft: Integer;
begin
  Result := FWindowPosition.wpLeft;
end;

function TBaseWindowSettingsObject.GetTop: Integer;
begin
  Result := FWindowPosition.wpTop;
end;

function TBaseWindowSettingsObject.GetUseDefaults: Boolean;
begin
  Result := FUseDefaults;
end;

function TBaseWindowSettingsObject.GetUserName: string;
begin
  Result := FUserName;
end;

function TBaseWindowSettingsObject.GetWidth: Integer;
begin
  Result := FWindowPosition.wpWidth;
end;

function TBaseWindowSettingsObject.GetWindowName: string;
begin
  Result := FWindowName;
end;

function TBaseWindowSettingsObject.ParentRec(
  const ParentName: string): TParentSettings;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to FParents.Count - 1 do
    if UpperCase(Trim((FParents[i] as TParentSettings).psName)) = UpperCase(Trim(ParentName)) then
    begin
      Result := FParents[i] as TParentSettings;
      Break;
    end;
end;

procedure TBaseWindowSettingsObject.SetCompanyPath(const Value: string);
begin
  FCompanyPath := IncludeTrailingBackslash(Value);
end;

procedure TBaseWindowSettingsObject.SetExeName(const Value: string);
begin
  FExeName := LJVar(UpperCase(Value), EXE_NAME_LENGTH);
  FWindowPosition.wpExeName := FExeName;
end;

procedure TBaseWindowSettingsObject.SetHeight(Value: Integer);
begin
  if FWindowPosition.wpHeight <> Value then
  begin
    FWindowPosition.wpHeight := Value;
    FIsDirty := True;
  end;
end;

procedure TBaseWindowSettingsObject.SetLeft(Value: Integer);
begin
  if FWindowPosition.wpLeft <> Value then
  begin
    FWindowPosition.wpLeft := Value;
    FIsDirty := True;
  end;
end;

procedure TBaseWindowSettingsObject.SetTop(Value: Integer);
begin
  if FWindowPosition.wpTop <> Value then
  begin
    FWindowPosition.wpTop := Value;
    FIsDirty := True;
  end;
end;

procedure TBaseWindowSettingsObject.SetUserName(const Value: string);
begin
  FUserName := LJVar(Value, USER_NAME_LENGTH);
  FWindowPosition.wpUserName := FUserName;
end;

procedure TBaseWindowSettingsObject.SetWidth(Value: Integer);
begin
  if FWindowPosition.wpWidth <> Value then
  begin
    FWindowPosition.wpWidth := Value;
    FIsDirty := True;
  end;
end;

procedure TBaseWindowSettingsObject.SetWindowName(const Value: string);
begin
  FWindowName := LJVar(Value, COMP_NAME_LENGTH);
  FWindowPosition.wpWindowName := FWindowName;
end;

//PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Set result to avoid warnings
function TBaseWindowSettingsObject.SaveSettings(SaveWindowPos : Boolean): Integer;
begin
  Result := 0;
  if not FResetToDefaults then
  begin
      if SaveWindowPos then
        Result := SaveWindowPosition;
      Result := Result + SaveParentSettings;
      if SaveWindowPos then
        Result := Result + SaveColumnSettings;
  end;
end;

//PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Set result to avoid warnings
function TBaseWindowSettingsObject.LoadSettings: Integer;
begin
  Result := LoadWindowPosition +
  LoadParentSettings +
  LoadColumnSettings;
  FUseDefaults := (FParents.Count = 0) and (FColumns.Count = 0) and not FWindowPositionLoaded;
end;

function TBaseWindowSettingsObject.AddColumn(const sParentName : string; iColNo : Integer): TColumnSettings;
begin
  Result := ColumnRec(sParentName, iColNo);
  if not Assigned(Result) then
  begin
    Result := TColumnSettings.Create(FExeName, FUserName, FWindowName);
    Result.csParentName := sParentName;
    Result.csColumnNo := iColNo;
    FColumns.Add(Result);
  end;
end;

function TBaseWindowSettingsObject.AddParent(const sName : string): TParentSettings;
begin
  Result := ParentRec(sName);
  if not Assigned(Result) then
  begin
    Result := TParentSettings.Create(FExeName, FUserName, FWindowName);
    Result.psName := sName;
    FParents.Add(Result);
  end;
end;

procedure TBaseWindowSettingsObject.SettingsToWindow(
  const AForm: TCustomForm);
begin
  if FWindowPositionLoaded then
  begin
    AForm.Left   := Left;
    AForm.Top    := Top;
    AForm.ClientWidth  := Width;
    AForm.ClientHeight := Height;
  end;
end;

procedure TBaseWindowSettingsObject.WindowToSettings(
  const AForm: TCustomForm);
begin
  Left   := AForm.Left;
  Top    := AForm.Top;
  Width  := AForm.ClientWidth;
  Height := AForm.ClientHeight;
end;

procedure TBaseWindowSettingsObject.ParentToSettings(
  const AParent: TWinControl; ExampleControl: TWinControl);
var
  ParentObj : TParentSettings;
begin
  if not Assigned(AParent) or not Assigned(ExampleControl) then
    EXIT;

  ParentObj := ParentRec(AParent.Name);

  if not Assigned(ParentObj) then
    ParentObj := AddParent(AParent.Name);

  if Assigned(ParentObj) then
    ParentObj.ControlToSettings(ExampleControl);

  if ExampleControl is TMultiList then
    MultiListToSettings(ExampleControl as TMultiList)
  {$IFNDEF NoBtrieveList}
  else
  if ExampleControl is TMULCtrl then
    BtrieveListToSettings(ExampleControl as TMULCtrl)
  {$ENDIF NoBtrieveList}
  else
  if ExampleControl is TListView then
    ListViewToSettings(ExampleControl as TListView)
    ;
end;

procedure TBaseWindowSettingsObject.SettingsToParent(
  const AParent: TWinControl);
var
  ParentObj : TParentSettings;
begin
  ParentObj := ParentRec(AParent.Name);

  if Assigned(ParentObj) then
  begin
    ParentObj.SettingsToControl(AParent);

    if AParent is TMultiList then
      SettingsToMultiList(AParent as TMultiList)
    {$IFNDEF NoBtrieveList}
    else
    if AParent is TMULCtrl then
      SettingsToBtrieveList(AParent as TMULCtrl)
    {$ENDIF NoBtrieveList}
    else if AParent is TListView then
      SettingsToListView(AParent as TListView)
    ;
  end;
end;

procedure TBaseWindowSettingsObject.SettingsToMultiList(const AList : TMultiList);
var
  i : Integer;
  ColumnObj : TColumnSettings;
  Cols : TBits;
begin
  //Use TBits to store which columns we've moved - that way if we moved 0 to 1, we don't then load col 1 and move it to 0!
  Cols := TBits.Create;
  Try
    Cols.Size := AList.Columns.Count;

    for i := 0 to AList.Columns.Count - 1 do
    begin
      ColumnObj := ColumnRec(AList.Name, i);
      if Assigned(ColumnObj) then
      begin
        //Set Width
        AList.DesignColumns[i].Width := ColumnObj.csWidth;

        if not Cols[i] and (i <> ColumnObj.csOrder) then
        begin
          //Set Position
          AList.MoveColumn(i, ColumnObj.csOrder);
          Cols[ColumnObj.csOrder] := True;
        end;
      end;
    end;
  Finally
    Cols.Free;
  End;
end;

procedure TBaseWindowSettingsObject.MultiListToSettings(const AList : TMultiList);
var
  i : integer;
  ColumnObj : TColumnSettings;
begin
  for i := 0 to AList.Columns.Count - 1 do
  begin
    ColumnObj := ColumnRec(AList.Name, i);

    if not Assigned(ColumnObj) then
      ColumnObj := AddColumn(AList.Name, i);

    if Assigned(ColumnObj) then
    begin
      ColumnObj.csWidth := AList.DesignColumns[i].Width;
      ColumnObj.csOrder := AList.RunTimeIndexes[i];
    end;
  end;
end;

//-------------------------------------------------------------------------

procedure TBaseWindowSettingsObject.SettingsToListView(const AList : TListView);
var
  i, iCol : Integer;
  ColumnObj : TColumnSettings;
  ListViewColumn : TListColumn;
  ColumnOrder: array of Integer;
  // MH 08/06/2015 v7.0.14 ABSEXCH-16506: Don't set column orders if any of the column details are missing
  bSetColumnOrders : Boolean;
Begin // SettingsToListView
  // MH 08/06/2015 v7.0.14 ABSEXCH-16506: Don't set column orders if any of the column details are missing
  bSetColumnOrders := True;

  // Use a dynamic array to store the column order which is then sent by windows message into the listview
  SetLength(ColumnOrder, AList.Columns.Count);

  // Run through the columns in design-time order (I maps onto the column ID)
  For I := 0 to AList.Columns.Count - 1 do
  Begin
    // Get the previously saved record from the settings table
    ColumnObj := ColumnRec(AList.Name, i);
    If Assigned(ColumnObj) then
    begin
      // Find the correct column in the ListView for those settings
      ListViewColumn := NIL;
      For iCol := 0 To (AList.Columns.Count - 1) Do
      Begin
        If (AList.Columns[iCol].ID = I) Then
        Begin
          ListViewColumn := AList.Columns[iCol];
          Break;
        End; // If (AList.Columns[iCol].ID = I)
      End; // For iCol

      If Assigned(ListViewColumn) Then
      Begin
        // Add the fixed column number into the column order array in the correct position
        ColumnOrder[ColumnObj.csOrder] := ListViewColumn.ID;

        // Update the width
        ListViewColumn.Width := ColumnObj.csWidth;
      End; // If Assigned(ListViewColumn)
    End // If Assigned(ColumnObj)
    Else
      // MH 08/06/2015 v7.0.14 ABSEXCH-16506: Don't set column orders if any of the column details are missing
      bSetColumnOrders := False;
  End; // For I

  // MH 08/06/2015 v7.0.14 ABSEXCH-16506: Don't set column orders if any of the column details are missing
  If bSetColumnOrders Then
    // Send the column order array into the lsitview
    ListView_SetColumnOrderArray(AList.Handle, AList.Columns.Count, PInteger(ColumnOrder));
End; // SettingsToListView

//------------------------------

procedure TBaseWindowSettingsObject.ListViewToSettings(const AList : TListView);
var
  I, iOrder : integer;
  ColumnObj : TColumnSettings;
  ListViewColumn : TListColumn;
  ColumnOrder: array of Integer;
Begin // ListViewToSettings
  // Use a dynamic array to store the column order
  SetLength(ColumnOrder, AList.Columns.Count);
  // Get the column order array from the lsitview
  ListView_GetColumnOrderArray(AList.Handle, AList.Columns.Count, PInteger(ColumnOrder));

  // Run through the columns in design-time order
  For I := 0 to AList.Columns.Count - 1 Do
  Begin
    // Get a reference to the column
    ListViewColumn := AList.Columns[i];

    // Load/create the settings for the column - use the fixed ID number and NOT the index which
    // changes as columns are dragged around
    ColumnObj := ColumnRec(AList.Name, ListViewColumn.ID);
    If (Not Assigned(ColumnObj)) Then
      ColumnObj := AddColumn(AList.Name, ListViewColumn.ID);

    If Assigned(ColumnObj) Then
    Begin
      ColumnObj.csWidth := ListViewColumn.Width;

      // Use the ColumnOrder array to determine the columns position at runtime
      For iOrder := Low(ColumnOrder) To High(ColumnOrder) Do
        If (ColumnOrder[iOrder] = ListViewColumn.ID) Then
        Begin
          ColumnObj.csOrder := iOrder;
          Break;
        End; // If (ColumnOrder[iOrder] = ListViewColumn.ID)
    End; // If Assigned(ColumnObj)
  End; // For I
End; // ListViewToSettings

//-------------------------------------------------------------------------

{$IFNDEF NoBtrieveLists}
procedure TBaseWindowSettingsObject.SettingsToBtrieveList(const AList : TMULCtrl);
var
  i : Integer;
  ColumnObj : TColumnSettings;
  Cols : TList;
  APanel, APanel2 : TPanel;
  SList : TStringList;
begin

  Cols := TList.Create; //Create a list to hold the columns in the revised order as specified by ColumnObj.csColOrder
  Try
    for i := 0 to AList.VisiList.Count - 1 do
      Cols.Add(nil);

    for i := 0 to AList.VisiList.Count - 1 do
    begin
      ColumnObj := ColumnRec(AList.Name, i);
      if Assigned(ColumnObj) then
      begin
        AList.VisiList.VisiRec := AList.VisiList.List[i];

        //Set positions on List Panel
        APanel := AList.VisiList.VisiRec.PanelObj as TPanel;
        APanel.Width := ColumnObj.csWidth;
        APanel.Left := ColumnObj.csLeft;
        APanel.Top := ColumnObj.csTop;
        APanel.Height := ColumnObj.csHeight;

        //Set positions on Label Panel
        APanel2 := AList.VisiList.VisiRec.LabelObj as TPanel;
        APanel2.Width := ColumnObj.csWidth;
        APanel2.Left := ColumnObj.csLeft;

        AList.VisiList.VisiRec.ColOrder := i;


        Cols[ColumnObj.csOrder] := AList.VisiList.Items[i];

      end;
    end;

    if (Cols[0]<>nil) then
    for i := 0 to AList.VisiList.Count - 1 do
    begin
      If (Cols[i]<>nil) then
        AList.VisiList.Items[i] := Cols[i];
    end;

    //Resize the label panel to fit
    if Assigned(AList.VisiList.LabHedPanel) then
      AList.VisiList.SetHedPanel(FListOffset);
  Finally
    Cols.Free;
  End;
end;

procedure TBaseWindowSettingsObject.BtrieveListToSettings(const AList : TMULCtrl);
var
  i, c : integer;
  APanel, APanel2 : TPanel;
  ColumnObj : TColumnSettings;
begin
  if Assigned(AList) then
  begin
    //We index the columns using their original position in the list (identified by ColOrder) then
    //store their current position in the ColumnObj.csOrder field
    for i := 0 to AList.VisiList.Count - 1 do
    begin
      AList.VisiList.VisiRec := AList.VisiList.List[i];

      c := AList.VisiList.VisiRec.ColOrder;
      ColumnObj := ColumnRec(AList.Name, c);

      if not Assigned(ColumnObj) then
        ColumnObj := AddColumn(AList.Name, c);

      if Assigned(ColumnObj) then
      begin
        APanel := AList.VisiList.VisiRec.PanelObj as TPanel;
        APanel2 := AList.VisiList.VisiRec.LabelObj as TPanel;

        ColumnObj.csWidth := APanel.Width;
        ColumnObj.csLeft := APanel.Left;
        ColumnObj.csTop := APanel.Top;
        ColumnObj.csHeight := APanel.Height;

        ColumnObj.csOrder := i;

      end;
    end;
  end;
end;
{$ENDIF NoBtrieveLists}

procedure TBaseWindowSettingsObject.DeleteSettings(WhichSettings : Integer = dsWindow);
begin
  FillChar(FWindowPosition, SizeOf(FWindowPosition), 0);
  FParents.Clear;
  FColumns.Clear;
end;


function TBaseWindowSettingsObject.Edit(const AParent : TWinControl; const ExampleControl : TWinControl): TModalResult;
var
  FrmEditSettingsEnt : TFrmEditSettingsEnt;
  ParentObj : TParentSettings;
begin{Edit}
  Result := mrCancel;
  FrmEditSettingsEnt := TFrmEditSettingsEnt.create(application);
  with FrmEditSettingsEnt do begin
    try
      //Have we already got a record for this parent?
      ParentObj := ParentRec(AParent.Name);

      //If not create one and populate it from ExampleControl
      if not Assigned(ParentObj) then
      begin
        ParentToSettings(AParent, ExampleControl);
        ParentObj := ParentRec(AParent.Name);
      end;

      //Set fields of form from Parent Record
      if Assigned(ParentObj) then
      begin

        panFields.Color := ParentObj.psBackgroundColor;
        panFields.Font.Name := ParentObj.psFontName;
        panFields.Font.Color := ParentObj.psFontColor;
        panFields.Font.Size := ParentObj.psFontSize;
        panFields.Font.Style := ParentObj.psFontStyle;

        if (AParent is TMultiList) {$IFNDEF NoBtrieveList} or (AParent is TMulCtrl) {$ENDIF NoBtrieveList} then
        begin
          lFields.Caption := 'List';


          panHeader.Font.Name := ParentObj.psHeaderFontName;
          panHeader.Font.Color := ParentObj.psHeaderFontColor;
          panHeader.Font.Size := ParentObj.psHeaderFontSize;
          panHeader.Font.Style := ParentObj.psHeaderFontStyle;


          panHighlight.Color := ParentObj.psHighlightBackgroundColor;
          panHighlight.Font.Color := ParentObj.psHighlightFontColor;
          panHighlight.Font.Style := ParentObj.psHighlightFontStyle;

          if AParent is TMultiList then
            panMultiSelectStuff.Visible := (AParent as TMultiList).Options.MultiSelection
          else
            panMultiSelectStuff.Visible := False;

          if panMultiSelectStuff.Visible then
          begin
            panMultiSelect.Color := ParentObj.psMultiSelectBackgroundColor;
            panMultiSelect.Font.Color := ParentObj.psMultiSelectFontColor;
            panMultiSelect.Font.Style := ParentObj.psMultiSelectFontStyle;
          end
          else
            Height := 278;

        end
        else
        begin
          Height := 278;
          lFields.Caption := 'Fields';
          lListHeadings.Enabled := FALSE;
          lHighlightBar.Enabled := FALSE;

          btnHeaderFont.Enabled := FALSE;
          btnHighlightColour.Enabled := FALSE;
          btnHighlightFont.Enabled := FALSE;
          panMultiSelectStuff.Visible := FALSE;
        end;

        Result := Showmodal;

        case Result of
          mrOK :
            begin
              ParentObj.psBackgroundColor := panFields.Color;
              ParentObj.psFontName := panFields.Font.Name;
              ParentObj.psFontColor := panFields.Font.Color;
              ParentObj.psFontSize := panFields.Font.Size;
              ParentObj.psFontStyle := panFields.Font.Style;

              if (AParent is TMultiList) {$IFNDEF NoBtrieveList} or (AParent is TMulCtrl) {$ENDIF NoBtrieveList} then
              begin
                ParentObj.psHeaderFontName := panHeader.Font.Name;
                ParentObj.psHeaderFontColor := panHeader.Font.Color;
                ParentObj.psHeaderFontSize := panHeader.Font.Size;
                ParentObj.psHeaderFontStyle := panHeader.Font.Style;

                ParentObj.psHighlightBackgroundColor := panHighlight.Color;
                ParentObj.psHighlightFontColor := panHighlight.Font.Color;
                ParentObj.psHighlightFontStyle := panHighlight.Font.Style;

                if panMultiSelectStuff.Visible then
                begin
                  ParentObj.psMultiSelectBackgroundColor := panMultiSelect.Color;
                  ParentObj.psMultiSelectFontColor := panMultiSelect.Font.Color;
                  ParentObj.psMultiSelectFontStyle := panMultiSelect.Font.Style;
                end
              end;
              ParentObj.SettingsToControl(AParent);

              //PR: 05/08/2011 Set UseDefaults to False after an edit.
              FUseDefaults := False;
            end;

          mrRestoreDefaults :
            begin
              MsgBox('You will need to close the current window, in order for defaults to be restored.'
              + #13#13 + 'Your defaults will take effect the next time you open this window.'
              , mtInformation, [mbOK], mbOK, 'Restore Defaults');
              DeleteSettings;
              FResetToDefaults := True;
            end;
        end;{case}

      end; //If Assigned(ParentObj)
    finally
      Release;
    end;{try}
  end;{with}
end;


function TBaseWindowSettingsObject.BuildUserKey: string;
begin
  Result := FExeName + FUserName;
end;

function TBaseWindowSettingsObject.BuildExeKey: string;
begin
  Result := FExeName;
end;

function TBaseWindowSettingsObject.GetListOffset: Integer;
begin
  Result := FListOffset;
end;

procedure TBaseWindowSettingsObject.SetListOffset(Value: Integer);
begin
  FListOffset := Value;
end;

{ TPervasiveWindowSettingsObject }

procedure TPervasiveWindowSettingsObject.CloseFiles;
begin
  BTCloseFile(FWindowFileVar, @FClientID);
  BTCloseFile(FParentFileVar, @FClientID);
  BTCloseFile(FColumnFileVar, @FClientID);
end;

constructor TPervasiveWindowSettingsObject.Create(const sDataPath   : string;
                                                  const sExeName    : string;
                                                  const sUserID     : string;
                                                  const sWindowName : string);
begin
  inherited;
  FiCID := WPClientIDs.OpenBit;
  WPClientIDs[FiCID] := True;
  Prime_ClientIDRec(FClientID, 'WP', FiCID);
  OpenFiles;
end;

procedure TPervasiveWindowSettingsObject.DeleteAllSettings;
begin
  DeleteSettings(dsExe);
end;

procedure TPervasiveWindowSettingsObject.DeleteAllSettingsForUser;
begin
  DeleteSettings(dsUser);
end;

procedure TPervasiveWindowSettingsObject.DeleteWindowSettings;
begin
  DeleteSettings(dsWindow);
end;

procedure TPervasiveWindowSettingsObject.DeleteSettings(WhichSettings : Integer = dsWindow);
var
  Buffer : Array[0..PARENT_REC_SIZE] of Byte;

  procedure DeleteRecs(var WhichFile : TFileVar);
  var
    Res : Integer;
    KeyS, KeyChk : TStr255;
  begin
    Case WhichSettings of
      dsWindow : KeyS := BuildWindowKey;
      dsUser   : KeyS := BuildUserKey;
      dsExe    : KeyS := BuildExeKey;
    end; //case

    KeyChk := UpperCase(KeyS);
    Res := BTFindRecord(B_GetGEq, WhichFile, Buffer, SizeOf(Buffer), 0, KeyS, @FClientID);

    while (Res = 0) and (Copy(UpperCase(KeyS), 1, Length(KeyChk)) = KeyChk) do
    begin
      BTDeleteRecord(WhichFile, Buffer, SizeOf(Buffer), 0, @FClientID);

      Res := BTFindRecord(B_GetGEq, WhichFile, Buffer, SizeOf(Buffer), 0, KeyS, @FClientID);
    end;
  end;

begin
  //Delete all records for given window name in each of the three files
  DeleteRecs(FWindowFileVar);
  DeleteRecs(FParentFileVar);
  DeleteRecs(FColumnFileVar);

  inherited;
end;

destructor TPervasiveWindowSettingsObject.Destroy;
var
  i : Integer;
begin
  CloseFiles;
  WPClientIDs[FiCID] := False;
  inherited;
end;

function TPervasiveWindowSettingsObject.LoadColumnSettings: Integer;
var
  Res : Integer;
  ColumnRec : TColumnSettingsRec;
  ColumnObj : TColumnSettings;
  KeyS, KeyChk : TStr255;
begin
  //Read all column records for this window and load as TColumnSettings objects into the FColumnsList
  KeyS := BuildWindowKey;
  KeyChk := KeyS;
  Res := BTFindRecord(B_GetGEq, FColumnFileVar, ColumnRec, SizeOf(ColumnRec), 0, KeyS, @FClientID);

  while (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) do
  begin
    ColumnObj := TColumnSettings.Create(FExeName, FUserName, FWindowName);
    ColumnObj.SettingsRec := ColumnRec;
    FColumns.Add(ColumnObj);

    Res := BTFindRecord(B_GetNext, FColumnFileVar, ColumnRec, SizeOf(ColumnRec), 0, KeyS, @FClientID);
  end;
  Result := 0;
end;

function TPervasiveWindowSettingsObject.LoadParentSettings: Integer;
var
  Res : Integer;
  ParentRec : TParentSettingsRec;
  ParentObj : TParentSettings;
  KeyS, KeyChk : TStr255;
begin
  //Read all parent records for this window and load as TParentSettings objects into the FParentsList
  KeyS := BuildWindowKey;
  KeyChk := KeyS;
  Res := BTFindRecord(B_GetGEq, FParentFileVar, ParentRec, SizeOf(ParentRec), 0, KeyS, @FClientID);

  while (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) do
  begin
    ParentObj := TParentSettings.Create(FExeName, FUserName, FWindowName);
    ParentObj.SettingsRec := ParentRec;
    FParents.Add(ParentObj);

    Res := BTFindRecord(B_GetNext, FParentFileVar, ParentRec, SizeOf(ParentRec), 0, KeyS, @FClientID);
  end;
  Result := 0;
end;

function TPervasiveWindowSettingsObject.LoadWindowPosition: Integer;
var
  KeyS : TStr255;
begin
  KeyS := BuildWindowKey;
  Result :=  BTFindRecord(B_GetEq, FWindowFileVar, FWindowPosition, SizeOf(FWindowPosition), 0, KeyS, @FClientID);
  FWindowPositionLoaded := Result = 0;
end;


procedure TPervasiveWindowSettingsObject.OpenFiles;
var
  Res : Integer;
begin
  Res := BTOpenFile(FWindowFileVar, CompanyPath + WindowFileName, 0, @FClientId, OwnerName^);
  Res := Res + BTOpenFile(FParentFileVar, CompanyPath + ParentFileName, 0, @FClientId, OwnerName^);
  Res := Res + BTOpenFile(FColumnFileVar, CompanyPath + ColumnFileName, 0, @FClientId, OwnerName^);
  if Res <> 0 then //Do what?
    ;
end;

function TPervasiveWindowSettingsObject.SaveColumnSettings: Integer;
var
  KeyS : TStr255;
  Res, i : Integer;
  ColumnObj : TColumnSettings;
  ColumnRec : TColumnSettingsRec;
begin
  Result := 0;
  for i := 0 to FColumns.Count - 1 do
  begin
    ColumnObj := TColumnSettings(FColumns[i]);

    if ColumnObj.IsDirty then
    begin
      KeyS := BuildColumnKey(ColumnObj.csParentName, ColumnObj.csColumnNo);
      Res := BTFindRecord(B_GetEq, FColumnFileVar, ColumnRec, SizeOf(ColumnRec), 0, KeyS, @FClientID);
      ColumnRec := ColumnObj.SettingsRec;
      if Res = 0 then
        Res := BTUpdateRecord(FColumnFileVar, ColumnRec, SizeOf(ColumnRec), 0, KeyS, @FClientID)
      else
        Res := BTAddRecord(FColumnFileVar, ColumnRec, SizeOf(ColumnRec), 0, @FClientID);
    end;
  end;
end;

function TPervasiveWindowSettingsObject.SaveParentSettings: Integer;
var
  KeyS : TStr255;
  Res, i : Integer;
  ParentObj : TParentSettings;
  ParentRec : TParentSettingsRec;
begin
  Result := 0;
  for i := 0 to FParents.Count - 1 do
  begin
    ParentObj := TParentSettings(FParents[i]);

    if ParentObj.IsDirty then
    begin
      KeyS := BuildParentKey(ParentObj.psName);
      Res := BTFindRecord(B_GetEq, FParentFileVar, ParentRec, SizeOf(ParentRec), 0, KeyS, @FClientID);
      ParentRec := ParentObj.SettingsRec;
      if Res = 0 then
        Res := BTUpdateRecord(FParentFileVar, ParentRec, SizeOf(ParentRec), 0, KeyS, @FClientID)
      else
        Res := BTAddRecord(FParentFileVar, ParentRec, SizeOf(ParentRec), 0, @FClientID);
    end;
  end;
end;


function TPervasiveWindowSettingsObject.SaveWindowPosition: Integer;
var
  TempWindowPosition : TWindowPositionRec;
  Res : Integer;
  KeyS : TStr255;
begin
  KeyS := BuildWindowKey;
  Result :=  BTFindRecord(B_GetEq, FWindowFileVar, TempWindowPosition, SizeOf(FWindowPosition), 0, KeyS, @FClientID);
  if Result = 0 then
    Result := BTUpdateRecord(FWindowFileVar, FWindowPosition, SizeOf(FWindowPosition), 0, KeyS, @FClientID)
  else
    Result := BTAddRecord(FWindowFileVar, FWindowPosition, SizeOf(FWindowPosition), 0, @FClientID);
end;

{ TSQLWindowSettingsObject }


procedure TSQLWindowSettingsObject.ColumnToRecord(
  const AColumnObj: TColumnSettings);
begin
  with AColumnObj do
  begin
     FColumnCaller.Records.FieldByName('csExeName').Value := FExeName;
     FColumnCaller.Records.FieldByName('csUserName').Value := FUserName;
     FColumnCaller.Records.FieldByName('csWindowName').Value := FWindowName;
     FColumnCaller.Records.FieldByName('csParentName').Value := csParentName;
     FColumnCaller.Records.FieldByName('csColumnNo').Value := csColumnNo;
     FColumnCaller.Records.FieldByName('csLeft').Value := csLeft ;
     FColumnCaller.Records.FieldByName('csWidth').Value := csWidth ;
     FColumnCaller.Records.FieldByName('csTop').Value := csTop;
     FColumnCaller.Records.FieldByName('csHeight').Value := csHeight;
     FColumnCaller.Records.FieldByName('csOrder').Value := csOrder;
     FColumnCaller.Records.FieldByName('DummyChar').Value := iDummyChar;
  end;
end;

constructor TSQLWindowSettingsObject.Create(const sDataPath   : string;
                                            const sExeName    : string;
                                            const sUserID     : string;
                                            const sWindowName : string);
begin
  inherited;
  FiCID := WPClientIDs.OpenBit;
  WPClientIDs[FiCID] := True;
  Prime_ClientIDRec(FClientID, 'WP', FiCID);

  FCompanyCode := GetCompanyCode(sDataPath);

  // CJS 2011-07-19: ABSEXCH-11620 - Use global SQL connection
  FWindowCaller := TSQLCaller.Create(GlobalADOConnection);
  FParentCaller := TSQLCaller.Create(GlobalADOConnection);
  FColumnCaller := TSQLCaller.Create(GlobalADOConnection);
end;

procedure TSQLWindowSettingsObject.DeleteAllSettings;
var
  sDeleteQuery : AnsiString;
begin
  Try
    sDeleteQuery := Format('DELETE FROM [COMPANY].[%s] WHERE wpExeName = ''%s''; ' +
                           'DELETE FROM [COMPANY].[%s] WHERE psExeName = ''%s''; ' +
                           'DELETE FROM [COMPANY].[%s] WHERE csExeName = ''%s'';', [WindowTableName,Trim(FExeName),
                                                                                    ParentTableName, Trim(FExeName),
                                                                                    ColumnTableName, Trim(FExeName)]);
    FWindowCaller.ExecSQL(sDeleteQuery, FCompanyCode);
  Except
  End;
  inherited DeleteSettings;
end;

procedure TSQLWindowSettingsObject.DeleteAllSettingsForUser;
var
  sDeleteQuery : AnsiString;
begin
  Try
    sDeleteQuery := Format('DELETE FROM [COMPANY].[%s] WHERE wpExeName = ''%s'' AND wpUserName  = ''%s''; ' +
                           'DELETE FROM [COMPANY].[%s] WHERE psExeName = ''%s'' AND psUserName  = ''%s''; ' +
                           'DELETE FROM [COMPANY].[%s] WHERE csExeName = ''%s'' AND csUserName  = ''%s''; ',
                            [WindowTableName, Trim(FExeName), Trim(FUserName),
                             ParentTableName, Trim(FExeName), Trim(FUserName),
                             ColumnTableName, Trim(FExeName), Trim(FUserName)]);
    FWindowCaller.ExecSQL(sDeleteQuery, FCompanyCode);
  Except
  End;
  inherited DeleteSettings;
end;

procedure TSQLWindowSettingsObject.DeleteWindowSettings;
begin
 DeleteSettings(dsWindow);
end;

procedure TSQLWindowSettingsObject.DeleteSettings(WhichSettings : Integer = dsWindow);
var
  sDeleteQuery : AnsiString;
begin
  inherited;
  Try
    sDeleteQuery := Format('DELETE FROM [COMPANY].[%s] WHERE %s; ' +
                           'DELETE FROM [COMPANY].[%s] WHERE %s; ' +
                           'DELETE FROM [COMPANY].[%s] WHERE %s; ',
                            [WindowTableName, WindowQuery('wp'),
                             ParentTableName, WindowQuery('ps'),
                             ColumnTableName, WindowQuery('cs')]);
    FWindowCaller.ExecSQL(sDeleteQuery, FCompanyCode);
  Except
  End;

end;

destructor TSQLWindowSettingsObject.Destroy;
begin
  FColumnCaller.Free;
  FParentCaller.Free;
  FWindowCaller.Free;
  inherited;
end;

function TSQLWindowSettingsObject.LoadColumnSettings: Integer;
var
  ColumnObj : TColumnSettings;
begin
  FColumnCaller.Select(Format(S_DEF_QUERY + S_COLUMN_QUERY, [ColumnTableName, FExeName, FUserName, FWindowName]), FCompanyCode);
  FColumnCaller.Records.First;
  while not FColumnCaller.Records.EOF do
  begin
    ColumnObj := TColumnSettings.Create(FExeName, FUserName, FWindowName);
    RecordToColumn(ColumnObj);
    FColumns.Add(ColumnObj);

    FColumnCaller.Records.Next;
  end;
  Result := 0;
end;

function TSQLWindowSettingsObject.LoadParentSettings: Integer;
var
  ParentObj : TParentSettings;
begin
  FParentCaller.Select(Format(S_DEF_QUERY + S_PARENT_QUERY, [ParentTableName, FExeName, FUserName, FWindowName]), FCompanyCode);
  FParentCaller.Records.First;
  while not FParentCaller.Records.EOF do
  begin
    ParentObj := TParentSettings.Create(FExeName, FUserName, FWindowName);
    RecordToParent(ParentObj);
    FParents.Add(ParentObj);

    FParentCaller.Records.Next;
  end;
  Result :=0;
end;

function TSQLWindowSettingsObject.LoadWindowPosition: Integer;
begin
  FWindowCaller.Select(Format(S_DEF_QUERY + S_WINDOW_QUERY, [WindowTableName, FExeName, FUserName, FWindowName]), FCompanyCode);
  FWindowPositionLoaded := FWindowCaller.Records.RecordCount > 0;
  if FWindowPositionLoaded then
  begin
    FWindowCaller.Records.First;
    FWindowPosition.wpLeft := FWindowCaller.Records.FieldByName('wpLeft').Value;
    FWindowPosition.wpTop := FWindowCaller.Records.FieldByName('wpTop').Value;
    FWindowPosition.wpWidth := FWindowCaller.Records.FieldByName('wpWidth').Value;
    FWindowPosition.wpHeight := FWindowCaller.Records.FieldByName('wpHeight').Value;
  end;
  Result := 0;
end;

procedure TSQLWindowSettingsObject.ParentToRecord(
  const AParentObj: TParentSettings);
begin
  with AParentObj do
  begin
    FParentCaller.Records.FieldByName('psExeName').Value := FExeName;
    FParentCaller.Records.FieldByName('psUserName').Value := FUserName;
    FParentCaller.Records.FieldByName('psWindowName').Value := FWindowName;
    FParentCaller.Records.FieldByName('psName').Value := psName;
    FParentCaller.Records.FieldByName('psBackGroundColor').Value := psBackGroundColor;
    FParentCaller.Records.FieldByName('psFontName').Value := psFontName;
    FParentCaller.Records.FieldByName('psFontSize').Value := psFontSize;
    FParentCaller.Records.FieldByName('psFontColor').Value := psFontColor;
    FParentCaller.Records.FieldByName('psFontStyle').Value := StyleToByte(psFontStyle);

    FParentCaller.Records.FieldByName('psHeaderBackGroundColor').Value := psHeaderBackGroundColor;
    FParentCaller.Records.FieldByName('psHeaderFontName').Value := psHeaderFontName;
    FParentCaller.Records.FieldByName('psHeaderFontSize').Value := psHeaderFontSize;
    FParentCaller.Records.FieldByName('psHeaderFontColor').Value := psHeaderFontColor;
    FParentCaller.Records.FieldByName('psHeaderFontStyle').Value := StyleToByte(psHeaderFontStyle);

    FParentCaller.Records.FieldByName('psHighlightBackgroundColor').Value := psHighlightBackgroundColor;
    FParentCaller.Records.FieldByName('psHighlightFontColor').Value := psHighlightFontColor;
    FParentCaller.Records.FieldByName('psHighlightFontStyle').Value := StyleToByte(psHighlightFontStyle);

    FParentCaller.Records.FieldByName('psMultiSelectBackgroundColor').Value := psMultiSelectBackgroundColor;
    FParentCaller.Records.FieldByName('psMultiSelectFontColor').Value := psMultiSelectFontColor;
    FParentCaller.Records.FieldByName('psMultiSelectFontStyle').Value := StyleToByte(psMultiSelectFontStyle);
  end;
end;

procedure TSQLWindowSettingsObject.RecordToColumn(
  const AColumnObj: TColumnSettings);
begin
  with AColumnObj do
  begin
    csParentName := FColumnCaller.Records.FieldByName('csParentName').Value;
    csColumnNo := FColumnCaller.Records.FieldByName('csColumnNo').Value;
    csLeft  := FColumnCaller.Records.FieldByName('csLeft').Value;
    csWidth  := FColumnCaller.Records.FieldByName('csWidth').Value;
    csTop := FColumnCaller.Records.FieldByName('csTop').Value;
    csHeight := FColumnCaller.Records.FieldByName('csHeight').Value;
    csOrder := FColumnCaller.Records.FieldByName('csOrder').Value;
  end;
end;

procedure TSQLWindowSettingsObject.RecordToParent(
  const AParentObj: TParentSettings);
begin
  with AParentObj do
  begin
     psName := FParentCaller.Records.FieldByName('psName').Value;
     psBackGroundColor := FParentCaller.Records.FieldByName('psBackGroundColor').Value;
     psFontName := FParentCaller.Records.FieldByName('psFontName').Value;
     psFontSize := FParentCaller.Records.FieldByName('psFontSize').Value;
     psFontColor := FParentCaller.Records.FieldByName('psFontColor').Value;
     psFontStyle := ByteToStyle(FParentCaller.Records.FieldByName('psFontStyle').Value);

     psHeaderBackGroundColor := FParentCaller.Records.FieldByName('psHeaderBackGroundColor').Value;
     psHeaderFontName := FParentCaller.Records.FieldByName('psHeaderFontName').Value;
     psHeaderFontSize := FParentCaller.Records.FieldByName('psHeaderFontSize').Value;
     psHeaderFontColor := FParentCaller.Records.FieldByName('psHeaderFontColor').Value;
     psHeaderFontStyle := ByteToStyle(FParentCaller.Records.FieldByName('psHeaderFontStyle').Value);

     psHighlightBackgroundColor := FParentCaller.Records.FieldByName('psHighlightBackgroundColor').Value;
     psHighlightFontColor := FParentCaller.Records.FieldByName('psHighlightFontColor').Value;
     psHighlightFontStyle := ByteToStyle(FParentCaller.Records.FieldByName('psHighlightFontStyle').Value);

     psMultiSelectBackgroundColor := FParentCaller.Records.FieldByName('psMultiSelectBackgroundColor').Value;
     psMultiSelectFontColor := FParentCaller.Records.FieldByName('psMultiSelectFontColor').Value;
     psMultiSelectFontStyle := ByteToStyle(FParentCaller.Records.FieldByName('psMultiSelectFontStyle').Value);
     IsDirty := False;
  end;
end;

function TSQLWindowSettingsObject.SaveColumnSettings: Integer;
var
  i : Integer;
  ColumnObj : TColumnSettings;
begin
  try
    //In case if the Dataset is not active after reconnection
    if not FColumnCaller.Records.Active then
      FColumnCaller.Records.Open;
    for i := 0 to FColumns.Count - 1 do
    begin
      ColumnObj := TColumnSettings(FColumns[i]);

      if ColumnObj.IsDirty then
      begin
        if FColumnCaller.Records.Locate('csParentName;csColumnNo',
                                      VarArrayOf([Trim(ColumnObj.csParentName), ColumnObj.csColumnNo]), []) then
          FColumnCaller.Records.Edit
        else
          FColumnCaller.Records.Insert;

        ColumnToRecord(ColumnObj);
        FColumnCaller.Records.Post;
      end;
    end;
  except
    on E: Exception do
    begin
      //RB 29/06/2017 2017-R2 ABSEXCH-18914: SQL connection fixes from Delphi end.
      if E.Message = CONNECTION_FAILURE then
      begin
        if ResetConnection(SetDrive) then
          SaveParentSettings;
      end;
    end;
  end;
  Result := 0;
end;

function TSQLWindowSettingsObject.SaveParentSettings: Integer;
var
  i : Integer;
  ParentObj : TParentSettings;
begin
  try
    //In case if the Dataset is not active after reconnection
    if not FParentCaller.Records.Active then
      FParentCaller.Records.Open;
    for i := 0 to FParents.Count - 1 do
    begin
      ParentObj := TParentSettings(FParents[i]);

      if ParentObj.IsDirty then
      begin
        if FParentCaller.Records.Locate('psName', Trim(ParentObj.psName), []) then
          FParentCaller.Records.Edit
        else
          FParentCaller.Records.Insert;

        ParentToRecord(ParentObj);

        FParentCaller.Records.Post;
      end;
    end;
  except
    on E: Exception do
    begin
      //RB 29/06/2017 2017-R2 ABSEXCH-18914: SQL connection fixes from Delphi end.
      if E.Message = CONNECTION_FAILURE then
      begin
        if ResetConnection(SetDrive) then
          SaveParentSettings;
      end;
    end;
  end;
  Result := 0;
end;

function TSQLWindowSettingsObject.SaveWindowPosition: Integer;
var
  sQuery : AnsiString;
begin
  try
    //In case if the Dataset is not active after reconnection
    if not FWindowCaller.Records.Active then
      FWindowCaller.Records.Open;

    if FWindowCaller.Records.RecordCount = 0 then
      FWindowCaller.Records.Insert
    else
      FWindowCaller.Records.Edit;

    FWindowCaller.Records.FieldByName('wpExeName').Value := FExeName;
    FWindowCaller.Records.FieldByName('wpUserName').Value := FUserName;
    FWindowCaller.Records.FieldByName('wpWindowName').Value := FWindowName;

    FWindowCaller.Records.FieldByName('wpLeft').Value := Left;
    FWindowCaller.Records.FieldByName('wpTop').Value := Top;
    FWindowCaller.Records.FieldByName('wpWidth').Value := Width;
    FWindowCaller.Records.FieldByName('wpHeight').Value := Height;

    FWindowCaller.Records.Post;
  except
    on E: Exception do
    begin
      //RB 29/06/2017 2017-R2 ABSEXCH-18914: SQL connection fixes from Delphi end.
      if E.Message = CONNECTION_FAILURE then
      begin
        if ResetConnection(SetDrive) then
          SaveWindowPosition;
      end;
    end;
  end;
  Result := 0;
end;

function TSQLWindowSettingsObject.WindowQuery(const PFix : string) : string;
begin
  Result := Format('(%sExeName = ''%s'') and (%sUserName = ''%s'') and (%sWindowName = ''%s'')',
                  [PFix, Trim(ExeName),
                   PFix, Trim(UserName),
                   PFix, Trim(WindowName)]);
end;

Initialization
  WPClientIds := TBits.Create;
  WPClientIds.Size := 64;
  WPClientIds[0] := True; // Don't use 0, start from 1.

end.

