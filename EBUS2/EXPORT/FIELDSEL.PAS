unit FieldSel;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons
  , TEditVal, ComCtrls, Menus, CSVUtils, MiscUtil, ExtCtrls, APIUtil, FileUtil, Mask, eBusCnst;

type
  TStartMode = (smOpen, smNewStock, smNewCust, smNewStockGroup, smNewTX);

  TfrmFieldSelect = class(TForm)
    btnClose: TButton;
    btnLoad: TButton;
    btnSave: TButton;
    btnNew: TButton;
    pcFields: TPageControl;
    tsHeader: TTabSheet;
    tsLines: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Bevel1: TBevel;
    lbHedUnselected: TListBox;
    lbHedSelected: TListBox;
    btnHedSelect: TButton;
    btnHedUnSelect: TButton;
    btnHedMoveUp: TBitBtn;
    btnHedMoveDown: TBitBtn;
    Bevel4: TBevel;
    Label3: TLabel;
    btnLineMoveUp: TBitBtn;
    btnLineMoveDown: TBitBtn;
    lbLineSelected: TListBox;
    btnLineSelect: TButton;
    btnLineUnselect: TButton;
    lbLineUnselected: TListBox;
    Label6: TLabel;
    TabSheet1: TTabSheet;
    edDescription: TEdit;
    edFilename: TEdit;
    rbHeaders: TRadioButton;
    rbBothSeparate: TRadioButton;
    rbBothTogether: TRadioButton;
    cmbDelimit: TComboBox;
    cmbSeparate: TComboBox;
    cmbHeaderRow: TComboBox;
    lExportFormat: TLabel;
    panDelimit: TPanel;
    panSeparate: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lstStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure lstDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure MoveBetweenEvent(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnMoveUpDownClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edDescriptionChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lbHedUnselectedClick(Sender: TObject);
    procedure lbHedSelectedClick(Sender: TObject);
    procedure RadioChange(Sender: TObject);
    procedure cmbDelimitChange(Sender: TObject);
    procedure cmbSeparateChange(Sender: TObject);
    procedure cmbHeaderRowChange(Sender: TObject);
    procedure pcFieldsChange(Sender: TObject);
  private
    fAllFieldList : TStringList; // All available fields for an export
    // String = description of the field
    // Object = instance of TStr - string = Key name, Posn used for sorting selected items
    fCSVType : TExportType;         // Type of CSV working with
    fCurMapFileName : string;    // Name of the current mapping file
    SelectedItemIndex : integer;
    bChanged : boolean;
    procedure WMSysCommand(var Message : TMessage); message WM_SysCommand;
    procedure MoveWithinList(lbListBox : TListBox; NewItemIndex : integer);
    procedure MoveBetweenLists(Mode : byte);
    procedure CopyList(FromList, ToList : TStrings);
    procedure LoadMapFile;
    procedure SaveMapFile;
    procedure ReadFields(CSVType : TExportType);
    procedure SetString(Index : integer; const Value : string);
    function  FindKey(List : TStrings; const SearchStr : string) : integer;
    procedure AddIgnoreField(lbListBox : TListBox);
    procedure NewMapFile;
    procedure CheckSaveChanges;
    procedure GreyButtons;
    procedure GreyRadioButs;
    procedure DistributeFields(CSVType : TExportType; lbSelected, lbUnselected : TListBox);
    procedure DisplayDetails(MapFileRec : TMapFileRec);
  public
    StartMode : TStartMode;
    sMapFileDirectory : string;
    property CurMapFileName : string index 1 read fCurMapFileName write SetString;
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
  end;

{var
  frmFieldSelect: TfrmFieldSelect;}

implementation

{$R *.DFM}

uses
  GlobVar, {EBusVar, }BtrvU2, IniFiles, FileSel;

const
  DEF_CLIENT_HEIGHT = 277;
  DEF_CLIENT_WIDTH = 613;

type
  TStr = class
    private
      fStr : string;
      fPosn : integer;
      procedure SetInteger(Value : integer);
      procedure SetString(const Value : string);
    public
      property Str : string read fStr write SetString;
      property Posn : integer read fPosn write SetInteger;
      procedure Assign(NewValues : TStr);
      constructor Create(const s : string = '');
  end;

//-----------------------------------------------------------------------

constructor TStr.Create(const s : string = '');
begin
  inherited Create;
  fStr := s;
  Posn := -1;
end;

//-----------------------------------------------------------------------

procedure TStr.SetInteger(Value : integer);
begin
  fPosn := Value;
end;

//-----------------------------------------------------------------------

procedure TStr.SetString(const Value : string);
begin
  fStr := Value;
end;

//-----------------------------------------------------------------------

procedure TStr.Assign(NewValues : TStr);
begin
  fStr := NewValues.Str;
  Posn := NewValues.Posn;
end;

//=======================================================================

procedure TfrmFieldSelect.SetString(Index : integer; const Value : string);
begin
  case Index of
    1: begin
         fCurMapFileName := Value;
         edFilename.Text := Value;
       end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.MoveBetweenLists(Mode : byte);
var
  Posn : integer;
  FromList,
  ToList : TListBox;
  CurObj : TStr;
begin
  case Mode of
    1 : begin
      FromList := lbHedUnselected;
      ToList := lbHedSelected;
    end;

    2 : begin
      FromList := lbHedSelected;
      ToList := lbHedUnselected;
    end;

    3 : begin
      FromList := lbLineUnselected;
      ToList := lbLineSelected;
    end;

    4 : begin
      FromList := lbLineSelected;
      ToList := lbLineUnselected;
    end;
  end;{case}

  Posn := 0;
  with FromList do
  while Posn < Items.Count do
  begin
    if Selected[Posn] then
    begin
      // Don't add *** IGNORE *** to the unselected list
      if not ((TStr(Items.Objects[Posn]).Str = IGNORE_FIELD)
      and ((FromList = lbHedSelected) or (FromList = lbLineSelected))) then
        if TStr(Items.Objects[Posn]).Str = IGNORE_FIELD then
        begin // Copy *** IGNORE *** to the selected list
          CurObj := TStr.Create(IGNORE_FIELD);
          ToList.Items.AddObject(IGNORE_STRING, CurObj);
        end
        else
          ToList.Items.AddObject(Items.Strings[Posn], Items.Objects[Posn]);

      // Don't delete *** IGNORE *** from the unselected list
      if not ((TStr(Items.Objects[Posn]).Str = IGNORE_FIELD) and ((FromList = lbHedUnselected) or (FromList = lbLineUnselected))) then
        Items.Delete(Posn)
      else
        inc(Posn);
    end
    else
      inc(Posn);
  end; // while
end; // TfrmFieldSelect.MoveBetweenLists

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.MoveWithinList(lbListBox : TListBox; NewItemIndex : integer);
begin
  if SelectedItemIndex <> -1 then
    with lbListBox.Items do
    begin
      if abs(SelectedItemIndex - NewItemIndex) = 1 then
        Exchange(SelectedItemIndex, NewItemIndex)
      else
        if SelectedItemIndex <> NewItemIndex then
        begin
         if NewItemIndex = lbListBox.Items.Count then
           lbListBox.Items.AddObject(lbListBox.Items[SelectedItemIndex],
             lbListBox.Items.Objects[SelectedItemIndex]) else
           lbListBox.Items.InsertObject(NewItemIndex, lbListBox.Items[SelectedItemIndex],
             lbListBox.Items.Objects[SelectedItemIndex]);

          if NewItemIndex > SelectedItemIndex then
            lbListBox.Items.Delete(SelectedItemIndex)
          else
            lbListBox.Items.Delete(SelectedItemIndex+1)
        end;
    end;
  SelectedItemIndex := -1;
end; // TfrmFieldSelect.MoveWithinList

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.lstDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TListBox;
end;

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.lstStartDrag(Sender: TObject; var DragObject: TDragObject);
var
  i : integer;
begin
  with Sender as TListBox do
    if SelCount > 1 then
      DragCursor := crMultiDrag
    else
    begin
      DragCursor := crDrag;
      if (Sender = lbHedSelected) then
        for i := 0 to lbHedSelected.Items.Count -1 do
         if lbHedSelected.Selected[i] then
           SelectedItemIndex := i;
    end;
end; // TfrmFieldSelect.lstStartDrag

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.lstDragDrop(Sender, Source: TObject; X, Y: Integer);
{var
  XYPos : TPoint;
  NewItemIndex : integer;}
begin
  bChanged := TRUE;

  if (Sender is TListBox) and (Source is TListBox) and (Sender <> Source)
  then begin
    if Sender = lbHedSelected then MoveBetweenLists(1)
    else begin
      if Sender = lbHedUnselected then MoveBetweenLists(2)
      else begin
        if Sender = lbLineSelected then MoveBetweenLists(3)
        else begin
          if Sender = lbLineUnselected then MoveBetweenLists(4);
        end;{if}
      end;{if}
    end;{if}
  end;{if}

{  if (((Sender = lbHedSelected) and (Source = lbHedSelected))
  or ((Sender = lbLineSelected) and (Source = lbLineSelected)))
  and (TListBox(Sender).SelCount = 1) then begin
    XYPos.X := X;
    XYPos.Y := Y;
    NewItemIndex := TListBox(Sender).ItemAtPos(XYPos, false);
    // ItemAtPos can return -1 when a drop is possible
    if NewItemIndex = -1 then
    begin
      if Y < (TListBox(Sender).ItemHeight div 2) then
        NewItemIndex := 0;
      if Y > (TListBox(Sender).Height - (TListBox(Sender).ItemHeight div 2)) then
        NewItemIndex := (TListBox(Sender).Height div TListBox(Sender).ItemHeight);
    end;
    MoveWithinList(TListBox(Sender), NewItemIndex);
  end;}
  GreyButtons;
end;

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.MoveBetweenEvent(Sender: TObject);
var
  iMode : byte;
begin
  bChanged := TRUE;

  if (Sender = btnHedSelect) or (Sender = lbHedUnselected) then iMode := 1
  else begin
    if (Sender = btnHedUnselect) or (Sender = lbHedSelected) then iMode := 2
    else begin
      if (Sender = btnLineSelect) or (Sender = lbLineUnselected) then iMode := 3
      else begin
        if (Sender = btnLineUnselect) or (Sender = lbLineSelected) then iMode := 4;
      end;{if}
    end;{if}
  end;{if}

  MoveBetweenLists(iMode);
  GreyButtons;
end;

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.ReadFields(CSVType : TExportType);
// Action : Populates fAllFieldList with the appropriate section from DataDef.ini
var
  CurItem : string;
  CurObj : TObject;
  Keys : TStringList;
  i : integer;
begin
  ClearList(fAllFieldList);
  with TMemIniFile.Create(ExtractFilePath(Application.ExeName) + FIELD_DEFS_INI) do
  try
    Keys := nil;
    Keys := TStringList.Create;
    ReadSection(CSV_DESC[CSVType], Keys);
    for i := 0 to Keys.Count -1 do
    begin
      CurItem := ExtractCSVValue(ReadString(CSV_DESC[CSVType], Keys[i], ''), 3, Keys[i]);
      CurObj := TStr.Create(Keys[i]);
      fAllFieldList.AddObject(CurItem, CurObj);
    end;
  finally
    Keys.Free;
    Free;
  end;
end; // TfrmFieldSelect.ReadFields;

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.CopyList(FromList, ToList : TStrings);
var
  CurObj : TStr;
  i: integer;
begin
  ClearList(ToList);
  for i := 0 to FromList.Count -1 do
  begin
    if Assigned(FromList.Objects[i]) then
    begin
      CurObj := TStr.Create;
      CurObj.Assign(TStr(fAllFieldList.Objects[i]));
      ToList.AddObject(FromList[i], CurObj);
    end;
  end;
end;

//-----------------------------------------------------------------------

constructor TfrmFieldSelect.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  lbHedUnselected.Clear;
  lbHedSelected.Clear;
  fAllFieldList := TStringList.Create;
  SelectedItemIndex := -1;
end;

//-----------------------------------------------------------------------

destructor TfrmFieldSelect.Destroy;
begin
  ClearList(fAllFieldList);
  fAllFieldList.Free;

  lbHedUnselected.Items.BeginUpdate;
  ClearList(lbHedUnselected.Items);
  lbHedSelected.Items.EndUpdate;

  lbHedSelected.Items.BeginUpdate;
  ClearList(lbHedSelected.Items);
  lbHedSelected.Items.EndUpdate;

  inherited Destroy;  
end;

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.btnMoveUpDownClick(Sender: TObject);
var
  i,
  NewItemIndex : integer;
  lbListBox : TListBox;
begin
  bChanged := TRUE;

  if (Sender = btnHedMoveUp) or (Sender = btnHedMoveDown) then lbListBox := lbHedSelected
  else begin
    if (Sender = btnLineMoveUp) or (Sender = btnLineMoveDown) then lbListBox := lbLineSelected;
  end;{if}


  with lbListBox do
    if SelCount = 1 then
    begin
      for i := 0 to Items.Count -1 do
        if Selected[i] then
          SelectedItemIndex := i;

      if (Sender = btnHedMoveUp) or (Sender = btnLineMoveUp) then
        NewItemIndex := SelectedItemIndex -1
      else
        NewItemIndex := SelectedItemIndex +1;
      // Make sure ItemIndex within bounds
      if NewItemIndex < 0 then
        NewItemIndex := 0;
      if NewItemIndex = Items.Count then
        NewItemIndex := Items.Count -1;
      Selected[SelectedItemIndex] := false;
      MoveWithinList(lbListBox, NewItemIndex);
      Selected[NewItemIndex] := true;
    end;
{  lbListBox := nil;}
  GreyButtons;
end; // TfrmFieldSelect.btnHedMoveUpDownClick

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.btnLoadClick(Sender: TObject);
begin
  CheckSaveChanges;

  FrmSelectMapFile := TFrmSelectMapFile.Create(Self);
  try
    FrmSelectMapFile.sDirectory := sMapFileDirectory;
    FrmSelectMapFile.ExportType := etError;
    with FrmSelectMapFile do begin
      if ShowModal = mrOK then
        begin
          CurMapFileName := MapFileRec.Filename;
          LoadMapFile;
        end
      else begin
        if Sender is TForm then PostMessage(Self.Handle,WM_Close,0,0);{on startup, close form on Cancel click}
      end;
    end;{with}
  finally
    FrmSelectMapFile.Release;
  end;{try}
end;

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.btnSaveClick(Sender: TObject);
var
  sMapFileName : string;
begin
  sMapFileName := edFilename.Text;
  if Check83ValidFileWithExt(sMapFileName, 'MAP') then
    begin
      CurMapFileName := sMapFileName;
      SaveMapFile;
    end
  else begin
    MsgBox('Invalid Filename Entered. Please modify and try again.',mtError,[mbOK],mbOK,'Invalid Filename');
    pcFields.ActivePageIndex := 0;
    ActiveControl := edFilename;
  end;{if}
end;

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.SaveMapFile;
// Notes : Create the map file if it doesn't exist
//         Replaces the [Stock], [Account] etc. section with the new field order
var
  bContinue, MapFileOK : boolean;
  MapFile : TextFile;
  IgnoreCount,
  i, iPos : integer;
  KeyValue : string;
  CSVLineType : TExportType;
  abFound : array[1..4] of boolean;
begin
  bContinue := TRUE;
  For iPos := 1 to 4 do abFound[iPos] := FALSE;

  //Check validity of Header / Line exports
  if fCSVType = etTXHeader then
    begin
      if rbBothSeparate.Checked or rbBothTogether.Checked then begin
        {check transaction header fields}
        with lbHedSelected.Items do begin
          For iPos := 0 to Count - 1 do begin
            if TStr(Objects[iPos]).Str = 'OurRef' then abFound[1] := TRUE
            else begin
              if TStr(Objects[iPos]).Str = 'FolioNum' then abFound[2] := TRUE;
            end;{if}
          end;{for}
        end;{with}

        {check transaction line fields}
        with lbLineSelected.Items do begin
          For iPos := 0 to Count - 1 do begin
            if TStr(Objects[iPos]).Str = 'TransRefNo' then abFound[3] := TRUE
            else begin
              if TStr(Objects[iPos]).Str = 'FolioNum' then abFound[4] := TRUE;
            end;{if}
          end;{for}
        end;{with}

        bContinue := (abFound[1] and abFound[3]) or (abFound[2] and abFound[4]);
        if not bContinue then MsgBox('You have not selected the required fields for a Header / Line transaction export to take place.'
        + #13 + 'The following fields must be exported from the transaction header and the line.' + #13 + #13
        + #9 + '(Our reference AND Header our reference)'
        + #13 + 'OR' + #9 + '(Folio Number AND Folio No of Transaction Header)'
        ,mtError,[mbOK],mbOK,'Validation Error');
      end;{if}
    end
  else begin
    if (fCSVType = etStockHeader) and (rbBothSeparate.Checked or rbBothTogether.Checked) then begin
      {check stock fields}
      with lbHedSelected.Items do begin
        For iPos := 0 to Count - 1 do begin
          if TStr(Objects[iPos]).Str = 'StockCode' then abFound[1] := TRUE
        end;{for}
      end;{with}

      {check location fields}
      with lbLineSelected.Items do begin
        For iPos := 0 to Count - 1 do begin
          if TStr(Objects[iPos]).Str = 'lsStkCode' then abFound[2] := TRUE
        end;{for}
      end;{with}

      bContinue := abFound[1] and abFound[2];
      if not bContinue then MsgBox('You have not selected the required fields for a multi-location stock export to take place.'
      + #13 + 'The Stock Code fields must be exported from both the stock record and the location record.'
      ,mtError,[mbOK],mbOK,'Validation Error');
    end;{if}
  end;{if}

  if bContinue then begin
    // Create a blank file
    MapFileOK := true;
    if not FileExists(sMapFileDirectory + CurMapFileName) then
    begin
      AssignFile(MapFile, sMapFileDirectory + CurMapFileName);
      try
        rewrite(MapFile);
      except
        MessageDlg(Format('Could not create map file %s', [sMapFileDirectory + CurMapFileName]), mtError, [mbOK], 0);
        MapFileOK := false;
      end;
      CloseFile(MapFile);
    end;

    if MapFileOK then
    with TIniFile.Create(sMapFileDirectory + CurMapFileName) do
      try
        {write Header section}
        try
          EraseSection(CSV_DESC[fCSVType]);
        except ;
        end;
        IgnoreCount := 0;
        for i := 0 to lbHedSelected.Items.Count -1 do
        begin
          KeyValue := TStr(lbHedSelected.Items.Objects[i]).Str;
          if KeyValue = IGNORE_FIELD then
          begin
            inc(IgnoreCount);
            KeyValue := KeyValue + Format('%.2d', [IgnoreCount]);
          end;
          WriteString(CSV_DESC[fCSVType], KeyValue , '');
        end;

        {write lines section}

        if rbBothSeparate.Checked or rbBothTogether.Checked then begin
          CSVLineType := etError;
          if fCSVType = etStockHeader then CSVLineType := etStockLocation
          else begin
            if fCSVType = etTXHeader then CSVLineType := etTXLines;
          end;{if}

          if (CSVLineType <> etError) then begin
            try
              EraseSection(CSV_DESC[CSVLineType]);
            except ;
            end;
            IgnoreCount := 0;
            for i := 0 to lbLineSelected.Items.Count -1 do
            begin
              KeyValue := TStr(lbLineSelected.Items.Objects[i]).Str;
              if KeyValue = IGNORE_FIELD then
              begin
                inc(IgnoreCount);
                KeyValue := KeyValue + Format('%.2d', [IgnoreCount]);
              end;
              WriteString(CSV_DESC[CSVLineType], KeyValue , '');
            end;
          end;{if}
        end;{if}

        {[Details] section}
        WriteString('Details', 'Description' , edDescription.Text);
        WriteString('Details', 'Type' , CSV_DESC[fCSVType]);
        if fCSVType in [etTXHeader, etStockHeader] then begin
          if rbHeaders.checked then WriteString('Details', 'ExportFormat', 'HeadersOnly')
          else begin
            if rbBothSeparate.checked then WriteString('Details', 'ExportFormat', 'BothSeparate')
            else begin
              if rbBothTogether.checked then WriteString('Details', 'ExportFormat', 'BothTogether');
            end;{if}
          end;{if}
        end;{if}

        WriteInteger('Details', 'FieldDelimiter' , cmbDelimit.ItemIndex);
        WriteInteger('Details', 'FieldSeparator' , cmbSeparate.ItemIndex);
        WriteInteger('Details', 'HeaderRow' , cmbHeaderRow.ItemIndex);

        UpdateFile;
      finally
        Free;
      end;
    bChanged := FALSE;
  end;{if}
end;

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.btnNewClick(Sender: TObject);
{var
  Posn : TPoint;}
begin
  CheckSaveChanges;
  // Position pop-up menu over button
{  Posn := Point(1,1);
  with TControl(Sender) do
    Posn := ClientToScreen(Posn);
  mnuCSVType.PopUp(Posn.X, Posn.Y);}
end;

//-----------------------------------------------------------------------

function SortByPosition(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := TStr(List.Objects[Index1]).Posn - TStr(List.Objects[Index2]).Posn;
end;

//-----------------------------------------------------------------------

function TfrmFieldSelect.FindKey(List : TStrings; const SearchStr : string) : integer;
var
  i : integer;
begin
  Result := -1;
  for i := 0 to List.Count - 1 do
    if TStr(List.Objects[i]).Str = SearchStr then
    begin
      Result := i;
      break;
    end;
end;

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.LoadMapFile;
var
  MapFileRec : TMapFileRec;
begin
{  fCSVType := ReadMapFileType(sMapFileDirectory + CurMapFileName);}

  MapFileRec := GetMapFileRec(sMapFileDirectory + CurMapFileName);
  fCSVType := MapFileRec.ExportType;

  DisplayDetails(MapFileRec);

  DistributeFields(fCSVType, lbHedSelected, lbHedUnselected);
  case fCSVType of
    etStockHeader : DistributeFields(etStockLocation, lbLineSelected, lbLineUnselected);
    etTXHeader : DistributeFields(etTXLines, lbLineSelected, lbLineUnselected);
  end;{case}

  GreyRadioButs;
  bChanged := FALSE;
end; // procedure TfrmFieldSelect.LoadMapFile

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.WMSysCommand(var Message : TMessage);
// Notes : Prevent the form from maximising when the maximise title bar
//         button is clicked.  Standard Enterprise behaviour for an MDI child.
begin
  with Message do
    case WParam of
      SC_Maximize : WParam := 0;
    end;
  inherited;
end; // TfrmFieldSelect.WMSysCommand

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.NewMapFile;
begin
  case StartMode of
    smNewCust : fCSVType := etAccount;
    smNewStock : fCSVType := etStockHeader;
    smNewStockGroup : fCSVType := etStockGroup;
    smNewTX : fCSVType := etTXHeader;
  end;{case}

{  Caption := Format('Select %s fields',[CSV_DESC[fCSVType]]);}

  cmbDelimit.ItemIndex := 1;
  cmbSeparate.ItemIndex := 1;
  cmbHeaderRow.ItemIndex := 0;

  ReadFields(fCSVType);
  ClearList(lbHedSelected.Items);
  CopyList(fAllFieldList, lbHedUnselected.Items);

  if fCSVType in [etStockHeader, etTXHeader] then begin
    case fCSVType of
      etStockHeader : ReadFields(etStockLocation);
      etTXHeader : ReadFields(etTXLines);
    end;{case}
    ClearList(lbLineUnselected.Items);
    CopyList(fAllFieldList, lbLineUnselected.Items);
    AddIgnoreField(lbLineUnselected);
  end;{if}

  AddIgnoreField(lbHedUnselected);
  bChanged := FALSE;
end; // TfrmFieldSelect.mniCSVTypeClick

//-----------------------------------------------------------------------

procedure TfrmFieldSelect.AddIgnoreField(lbListBox : TListBox);
var
  CurObj : TStr;
begin
  CurObj := TStr.Create(IGNORE_FIELD);
  lbListBox.Items.AddObject(IGNORE_STRING, CurObj);
end;



//-----------------------------------------------------------------------

procedure TfrmFieldSelect.FormCreate(Sender: TObject);
begin
{  ClientHeight := DEF_CLIENT_HEIGHT;
  ClientWidth := DEF_CLIENT_WIDTH;}
  GreyButtons;
end;

procedure TfrmFieldSelect.FormShow(Sender: TObject);
begin
  case StartMode of
    smOpen : btnLoadClick(self);
    else NewMapFile;
  end;{case}

  GreyRadioButs;
  bChanged := FALSE;
end;

procedure TfrmFieldSelect.edDescriptionChange(Sender: TObject);
begin
  bChanged := TRUE;
end;

procedure TfrmFieldSelect.CheckSaveChanges;
begin
  if bChanged and (MsgBox('Changes have been made to this mapping file.' + #13 + #13
  + 'Do you wish to save these changes ?',mtConfirmation,[mbYes,mbNo],mbYes,'Save Changes') = mrYes)
  then btnSaveClick(nil);
  bChanged := FALSE;
end;

procedure TfrmFieldSelect.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CheckSaveChanges;
end;

procedure TfrmFieldSelect.GreyButtons;
begin
  btnHedSelect.Enabled := lbHedUnselected.SelCount > 0;
  btnHedUnSelect.Enabled := lbHedSelected.SelCount > 0;
  btnHedMoveUp.Enabled := (lbHedSelected.SelCount = 1) and (lbHedSelected.ItemIndex <> 0);
  btnHedMoveDown.Enabled := (lbHedSelected.SelCount = 1) and (lbHedSelected.ItemIndex <> lbHedSelected.Items.Count - 1);

  btnLineSelect.Enabled := lbLineUnselected.SelCount > 0;
  btnLineUnSelect.Enabled := lbLineSelected.SelCount > 0;
  btnLineMoveUp.Enabled := (lbLineSelected.SelCount = 1) and (lbLineSelected.ItemIndex <> 0);
  btnLineMoveDown.Enabled := (lbLineSelected.SelCount = 1) and (lbLineSelected.ItemIndex <> lbLineSelected.Items.Count - 1);
end;

procedure TfrmFieldSelect.lbHedUnselectedClick(Sender: TObject);
begin
  GreyButtons;
end;

procedure TfrmFieldSelect.lbHedSelectedClick(Sender: TObject);
begin
  GreyButtons;
end;

procedure TfrmFieldSelect.RadioChange(Sender: TObject);
begin
  bChanged := TRUE;
  tsLines.TabVisible := (fCSVType in [etStockHeader,etTXHeader]) and (not rbHeaders.Checked);
end;

procedure TfrmFieldSelect.GreyRadioButs;
begin
  rbHeaders.Enabled := fCSVType in [etStockHeader,etTXHeader];
  rbBothSeparate.Enabled := fCSVType in [etStockHeader,etTXHeader];
  rbBothTogether.Enabled := fCSVType in [etStockHeader,etTXHeader];
  lExportFormat.Enabled := fCSVType in [etStockHeader,etTXHeader];

  pcFields.ActivePageIndex := 0;
  case fCSVType of
    etStockHeader : begin
      tsHeader.Caption := 'Stock';
      tsLines.Caption := 'Location';
      rbHeaders.Caption := 'Stock Only';
      rbBothSeparate.Caption := 'Stock && Locations (separate files)';
      rbBothTogether.Caption := 'Stock && Locations (in one file)';
    end;{if}
    etAccount : tsHeader.Caption := 'Customer';
    etStockGroup : tsHeader.Caption := 'Stock Group';
    etTXHeader : begin
      tsHeader.Caption := 'Transaction Header';
      tsLines.Caption := 'Transaction Lines';
      rbHeaders.Caption := 'Headers only';
      rbBothSeparate.Caption := 'Headers && Lines (separate files)';
      rbBothTogether.Caption := 'Headers && Lines (in one file)';
    end;{if}
  end;
  RadioChange(nil);
  GreyButtons;
end;

procedure TfrmFieldSelect.DistributeFields(CSVType : TExportType; lbSelected, lbUnselected : TListBox);
var
  i : integer;
  MappedKeys : TStringList;  // All keys within chosen section
  SearchPos : integer;
  CurObj : TStr;
begin
  MappedKeys := TStringList.Create;
  with TMemIniFile.Create(sMapFileDirectory + CurMapFileName) do begin
    try
      ReadSection(CSV_DESC[CSVType], MappedKeys);
    finally
      Free;
    end;
  end;{with}

  // Read all the available keys for chosen section
  ReadFields(CSVType);

  lbUnselected.Items.BeginUpdate;
  lbSelected.Items.BeginUpdate;
  ClearList(lbUnselected.Items);
  ClearList(lbSelected.Items);

  // Loop through mapped keys
  for i := 0 to MappedKeys.Count -1 do
  begin
    CurObj := TStr.Create;
    SearchPos := FindKey(fAllFieldList,MappedKeys[i]);
    if SearchPos = -1 then
    begin
      // Mapped key not found in complete key list => ignore field
      CurObj.Str := IGNORE_FIELD;
      // Add to selected list box
      lbSelected.Items.AddObject(IGNORE_STRING, CurObj);
    end
    else
    begin
      // Mapped key found in complete key list => normal field
      CurObj.Assign(TStr(fAllFieldList.Objects[SearchPos]));
      // Add to selected list box
      lbSelected.Items.AddObject(fAllFieldList[SearchPos], CurObj);
      // Mark field as being used
      TStr(fAllFieldList.Objects[SearchPos]).Posn := i;
    end;
  end;

  // Add all fields which have not been marked as used to the unselected list box
  for i := 0 to fAllFieldList.Count -1 do
    if TStr(fAllFieldList.Objects[i]).Posn = -1 then
    begin
      CurObj := TStr.Create;
      CurObj.Assign(TStr(fAllFieldList.Objects[i]));
      lbUnselected.Items.AddObject(fAllFieldList[i], CurObj)
    end;

  AddIgnoreField(lbUnselected);
  lbUnselected.Items.EndUpdate;
  lbSelected.Items.EndUpdate;

  MappedKeys.Free;
end;

procedure TfrmFieldSelect.cmbDelimitChange(Sender: TObject);
begin
  bChanged := TRUE;
  case cmbDelimit.ItemIndex of
    0 : panDelimit.Caption := '';
    1 : panDelimit.Caption := '"';
    2 : panDelimit.Caption := '''';
  end;{case}
end;

procedure TfrmFieldSelect.cmbSeparateChange(Sender: TObject);
begin
  bChanged := TRUE;
  case cmbSeparate.ItemIndex of
    0 : panSeparate.Caption := '';
    1 : panSeparate.Caption := ',';
    2 : panSeparate.Caption := ';';
    3 : panSeparate.Caption := '#9';
  end;{case}
end;

procedure TfrmFieldSelect.DisplayDetails(MapFileRec : TMapFileRec);
begin
  {set radio button}
  with MapFileRec do begin
    EdDescription.Text := Description;
    if ExportType in [etStockHeader, etTXHeader] then begin
      case ExportFormat of
        efHeadersOnly : rbHeaders.Checked := TRUE;
        efBothSeparate : rbBothSeparate.Checked := TRUE;
        efBothTogether : rbBothTogether.Checked := TRUE;
      end;{case}
    end;{if}

    cmbDelimit.ItemIndex := FieldDelimiter;
    cmbSeparate.ItemIndex := FieldSeparator;
    cmbHeaderRow.ItemIndex := HeaderRow;

    cmbDelimitChange(nil);
    cmbSeparateChange(nil);
  end;{with}
end;


procedure TfrmFieldSelect.cmbHeaderRowChange(Sender: TObject);
begin
  bChanged := TRUE;
end;

procedure TfrmFieldSelect.pcFieldsChange(Sender: TObject);
begin
  case pcFields.ActivePageIndex of
    0: begin
         if (StartMode = smNewCust) or (fCSVType = etAccount) then
           pcFields.HelpContext := 57;
         if (StartMode = smNewTX) or (fCSVType in [etTXHeader, etTXLines]) then
           pcFields.HelpContext := 89;
       end;
    else
    begin
      if (StartMode = smNewCust) or (fCSVType = etAccount) then
        pcFields.HelpContext := 58;
      if (StartMode = smNewTX) or (fCSVType in [etTXHeader, etTXLines]) then
        pcFields.HelpContext := 91;
    end;
  end;
end;

end.
