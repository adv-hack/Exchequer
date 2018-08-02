unit LkUpTrad;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, StdCtrls, ExtCtrls, SBSPanel, SupListU, GlobVar, BtSupU1,
  EBusUtil, Buttons, BtrvList, EBusLkup, EBusLook, EBusCnst, LkupSing;

type
  TEBusLookup = class(TGenList)
    private
      fLookupType : char;
      procedure SetLookupType(Value : char);
    public
      function SetCheckKey : Str255; override;
      function OutLine(Col : byte) : str255; override;
      property LookupType : char read fLookupType write SetLookupType;
  end;

  TfrmCodeLookup = class(TForm)
    mnuPopup: TPopupMenu;
    mnuPopupSep1: TMenuItem;
    mniProperties: TMenuItem;
    mnuPopupSep2: TMenuItem;
    mniSaveOnExit: TMenuItem;
    mniEdit: TMenuItem;
    mniAdd: TMenuItem;
    mniDelete: TMenuItem;
    pnlButtons: TSBSPanel;
    btnClose: TButton;
    sbxButtons: TScrollBox;
    btnDelete: TButton;
    btnEdit: TButton;
    btnAdd: TButton;
    pgcLookups: TPageControl;
    tabCurrency: TTabSheet;
    tabVAT: TTabSheet;
    sbxCMain: TScrollBox;
    pnlCOur: TSBSPanel;
    pnlCThr: TSBSPanel;
    pnlCDes: TSBSPanel;
    pnlCurColHeaders: TSBSPanel;
    pnlCOurHd: TSBSPanel;
    pnlCThrHd: TSBSPanel;
    pnlCDesHd: TSBSPanel;
    sbxVMain: TScrollBox;
    pnlVOur: TSBSPanel;
    pnlVThr: TSBSPanel;
    pnlVDes: TSBSPanel;
    pnlVATColHeaders: TSBSPanel;
    pnlVOurHd: TSBSPanel;
    pnlVThrHd: TSBSPanel;
    pnlVDesHd: TSBSPanel;
    pnlCurListControls: TSBSPanel;
    pnlVATListControls: TSBSPanel;
    btnAuto: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShowEditForm(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure mniSaveOnExitClick(Sender: TObject);
    procedure mnuPopupPopup(Sender: TObject);
    procedure mniPropertiesClick(Sender: TObject);
    procedure HeadersMouseDownExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MoveAlignColsExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pgcLookupsChange(Sender: TObject);
    procedure btnAutoClick(Sender: TObject);
  private
    frmOneLookup   : TfrmOneLookup;
    FormStuff      : TFormStuff;
    fBtrieveLookup : TEBusBtrieveLookupTraderRef;
    fActiveTrader  : string;
    procedure WMCustGetRec(var Message : TMessage); message WM_CustGetRec;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMSysCommand(var Message : TMessage); message WM_SysCommand;
    function  TraderCodeToDescription(TraderCode : string) : string;
    function  OpenBtrieveLookup(var Lookup : TEBusBtrieveLookupTraderRef) : integer;
    function  GetListIndex : integer;
    procedure SetFormCaption;
    procedure CheckAutoEnabled;
    procedure RefreshOneLine(Edited : boolean);
    procedure RefreshList;
  public
    procedure RefreshDetails(ActiveTrader : string);
  end;

var
  frmCodeLookup: TfrmCodeLookup;

implementation

{$R *.DFM}

uses
  EBusVar, CmpCtrlU, EBusBtrv, BtrvU2, ETStrU, ColCtrlU, AdmnUtil, EntUtil,
  ISOCurr, UseDLLU, UseTKit;

//-----------------------------------------------------------------------

const
  DEF_CLIENT_HEIGHT = 219;
  DEF_CLIENT_WIDTH = 520;
  BASE_FORM_LETTER = 'B';

//-----------------------------------------------------------------------

procedure TEBusLookup.SetLookupType(Value : char);
begin
  fLookupType := Value;
end;

//-----------------------------------------------------------------------

function TEBusLookup.SetCheckKey : Str255;
begin
  FillChar(Result, Sizeof(Result),0);
  with EBusLookupRec, LookUpGeneric do
    Result := RecPfix + SubType + OurTraderCode;
end; // TEBusLookupList.SetCheckKey

//-----------------------------------------------------------------------

function TEBusLookup.OutLine(Col : byte) : str255;
begin
  try
    with EBusLookupRec.LookupGeneric do
      case Col of
        0: if LookupType = LOOKUP_TYPE_CURRENCY then
             Result := Format('%s - %s', [Trim(OurItemCode),
                         GetCurrencyDescription(StrToInt(Trim(OurItemCode)))])
           else
             Result := Format('%s - %s', [Trim(OurItemCode),
                         GetVATDescription(Trim(OurItemCode)[1])]);
        1: Result := TheirItemCode;
        2: Result := Description;
      end; // case
  except
    Result := '';
  end;
end; // TEBusLookup.OutLine

//=======================================================================

procedure TfrmCodeLookup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with FormStuff do
    StoreFormProperties(Self, FormStuff, bStoreCoord, bSetDefaults, bLastCoord, BASE_FORM_LETTER);
  SendMessage((Owner as TForm).Handle, WM_CustGetRec, EBUS_FORM_CLOSE, FORM_LOOKUP_DETAIL);
  FormStuff.Free;
  Action := caFree;
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.WMCustGetRec(var Message : TMessage);
begin
  with Message do
    case WParam of
      0:  // Double click
          ShowEditForm(self);
      2:  // Right click
          mnuPopup.PopUp(LParamLo, lParamHi);
      200: // Add / update performed
          RefreshOneLine(LParam=1);
      300: // Delete performed
          RefreshList;
      800: frmOneLookup := nil;
    end;  // case
end; // TfrmCodeLookup.WMCustGetRec

//-----------------------------------------------------------------------

function TfrmCodeLookup.GetListIndex : integer;
begin
  if pgcLookups.ActivePage = tabCurrency then
    Result := 0
  else
    Result := 1;
end;

//-----------------------------------------------------------------------

function TfrmCodeLookup.OpenBtrieveLookup(var Lookup : TEBusBtrieveLookupTraderRef) : integer;
begin
  if GetListIndex = 0 then
    Lookup := TEBusBtrieveLookupCurrency.Create(true)
  else
    Lookup := TEBusBtrieveLookupVAT.Create(true);

  Lookup.FileLocation := IncludeTrailingBackSlash(IncludeTrailingBackSlash
                           (GetCompanyDirFromCode(CurCompSettings.CompanyCode)) +
                            EBUS_DIR);
  Result := Lookup.OpenFile;
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.ShowEditForm(Sender: TObject);
var
  ShowForm : boolean;
  ShowMode : TFormActivate;
  LockRec  : boolean;
  LockPos  : longint;
begin
  // If the lookups setup form is already open then ignore any further requests
  if assigned(frmOneLookup) then
    exit;

  ShowForm := false;
  ShowMode := actShow;
  LockPos := 0;

  OpenBtrieveLookup(fBtrieveLookup);

  with FormStuff.aMULCtrlO[GetListIndex] do
  begin
    GetSelRec(false);

    fBtrieveLookup.OurTraderCode := fActiveTrader;//OurTraderCode;
    fBtrieveLookup.OurItemCode :=  EBusLookupRec.LookUpGeneric.OurItemCode;

    if (Sender = btnAdd) or (Sender = mniAdd) then
    begin
      ShowForm := true;
      ShowMode := actAdd;
    end;

    if ((Sender = btnEdit) or (Sender = mniEdit) or (Sender = self)) and ValidLine then
    begin
      ShowMode := actEdit;
      LockRec := true;

      Status:=GetPos(F[ScanFileNum],ScanFileNum,LockPos);


      {if fBtrieveLookup.FindRecord(LockRec, LockPos) = 0 then}

      If (Status=0) and (fBtrieveLookup.FindDirectRecord(LockPos,B_MultNWLock)=0) then
        ShowForm := true
      else
        WarnRecordLocked;
    end;
  end; // with

  if ShowForm then
  begin
    frmOneLookup := TfrmOneLookup.Create(self);
    frmOneLookup.Display(ShowMode, fBtrieveLookup, LockPos);
  end;
end; // TfrmCodeLookup.ShowEditForm

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.DeleteClick(Sender: TObject);
var
  BtrieveLookup : TEBusBtrieveLookupTraderRef;
begin
  with FormStuff.aMULCtrlO[GetListIndex] do
    if ValidLine and ConfirmRecordDelete('this record') then
    begin
      GetSelRec(false);
      OpenBtrieveLookup(BtrieveLookup);
      with BtrieveLookup do
      begin
        OurTraderCode := EBusLookupRec.LookUpGeneric.OurTraderCode;
        OurItemCode := EBusLookupRec.LookUpGeneric.OurItemCode;
        if FindRecord = 0 then
          if DeleteRecord in [84,85] then
            WarnRecordLocked
          else
            if MUListBox1.Row <> 0 then
              PageUpDn(0, true)
            else
              InitPage;
        BtrieveLookup.CloseFile;
        BtrieveLookup.Free;
      end;
    end;
end; // TfrmCodeLookup.DeleteClick

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.WMSysCommand(var Message : TMessage);
// Notes : Prevent the form from maximising when the maximise title bar
//         button is clicked.  Standard Enterprise behaviour for an MDI child.
begin
  with Message do
    case WParam of
      SC_Maximize :
        begin
          Self.ClientHeight := DEF_CLIENT_HEIGHT;
          Self.ClientWidth := DEF_CLIENT_WIDTH;
          WParam := 0;
        end;
    end; // case
  inherited;
end; // TfrmDragNetCatalogue.WMSysCommand

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
begin
  with Message.MinMaxInfo^ do
  begin
    ptMinTrackSize.X := 531;
    ptMinTrackSize.Y := 226;
  end;
  Message.Result := 0;
  Inherited;
end; // TfrmCodeLookup.WMGetMinMaxInfo

//-----------------------------------------------------------------------

function TfrmCodeLookup.TraderCodeToDescription(TraderCode : string) : string;
begin
  if Trim(TraderCode) = '' then
    Result := 'Global default'
  else
    Result := Format('%s, %s', [Trim(TraderCode), GetTraderNameFromCode(Trim(TraderCode))]);
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.SetFormCaption;
begin
  with EBusLookupRec, LookUpGeneric do
    Caption := Format('Code Lookups - %s', [TraderCodeToDescription(fActiveTrader)]);
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.RefreshDetails(ActiveTrader : string);
var
  i : integer;
  Key0, Key1 : string;
begin
  with FormStuff do
  begin
    fActiveTrader := ActiveTrader;
    with EBusLookupRec, LookUpGeneric do
    begin
      Key0 := LOOKUP_TYPE_CURRENCY + LOOKUP_SUBTYPE_NONE + fActiveTrader;
      aKeyStart[0] := Key0;
      aKeyEnd[0] := Key0;
      aKeyLength[0] := Length(Key0);
      Key1 := LOOKUP_TYPE_VAT + LOOKUP_SUBTYPE_NONE + fActiveTrader;
      aKeyStart[1] := Key1;
      aKeyEnd[1] := Key1;
      aKeyLength[1] := Length(Key1);
    end;
    for i := 0 to 1 do
      aMULCtrlO[i].StartList(aFileNos[i], aiKeys[i], aKeyStart[i], aKeyEnd[i],
        '', aKeyLength[i], FALSE);
    SetFormCaption;
    CheckAutoEnabled;
  end;
end; // TfrmCodeLookup.RefreshDetails

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.FormCreate(Sender: TObject);
begin
  FormStuff := TFormStuff.Create(2);

  ClientHeight := DEF_CLIENT_HEIGHT;
  ClientWidth := DEF_CLIENT_WIDTH;

  with FormStuff do
  begin
    bFillList := false;

    // Currency list
    SetLength(aColumns[0], 3);
    aColumns[0,0].ColPanel := pnlCOur;
    aColumns[0,0].HeadPanel := pnlCOurHd;
    aColumns[0,1].ColPanel := pnlCThr;
    aColumns[0,1].HeadPanel := pnlCThrHd;
    aColumns[0,2].ColPanel := pnlCDes;
    aColumns[0,2].HeadPanel := pnlCDesHd;

    aFileNos[0] := EBsL;
    asbMain[0] := sbxCMain;
    apanTitle[0] := pnlCurColHeaders;
    asbButtons[0] := sbxButtons;
    apanButtons[0] := pnlButtons;
    aMULCtrlO[0] := TEBusLookup.Create(self);
    (aMULCtrlO[0] as TEBusLookup).LookupType := LOOKUP_TYPE_CURRENCY;
    apanScrollBar[0] := pnlCurListControls;
    aiKeys[0] := 0;
    (*
    with EBusLookupRec, LookUpGeneric do
    begin
      aKeyStart[0] := LOOKUP_TYPE_CURRENCY + LOOKUP_SUBTYPE_NONE + {fActiveTrader;} OurTraderCode;
      aKeyEnd[0] := LOOKUP_TYPE_CURRENCY + LOOKUP_SUBTYPE_NONE + {fActiveTrader; } OurTraderCode;
    end; *)

    // VAT list
    SetLength(aColumns[1], 3);
    aColumns[1,0].ColPanel := pnlVOur;
    aColumns[1,0].HeadPanel := pnlVOurHd;
    aColumns[1,1].ColPanel := pnlVThr;
    aColumns[1,1].HeadPanel := pnlVThrHd;
    aColumns[1,2].ColPanel := pnlVDes;
    aColumns[1,2].HeadPanel := pnlVDesHd;

    aFileNos[1] := EBsL;
    asbMain[1] := sbxVMain;
    apanTitle[1] := pnlVATColHeaders;
    asbButtons[1] := sbxButtons;
    apanButtons[1] := pnlButtons;
    aMULCtrlO[1] := TEBusLookup.Create(self);
    (aMULCtrlO[1] as TEBusLookup).LookupType := LOOKUP_TYPE_VAT;

    apanScrollBar[1] := pnlVATListControls;
    aiKeys[1] := 0;
    (*
    with EBusLookupRec, LookUpGeneric do
      aKeyStart[1] := LOOKUP_TYPE_VAT + LOOKUP_SUBTYPE_NONE + OurTraderCode;
//    aKeyEnd[1] := LOOKUP_TYPE_VAT + LOOKUP_SUBTYPE_NONE; *)
    ReadFormProperties(Self, FormStuff, BASE_FORM_LETTER);
    DoFormResize(Self,FormStuff);

    pgcLookups.ActivePage := tabCurrency;
    SetFormCaption;
  end;
end; // TfrmCodeLookup.FormCreate;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.mniSaveOnExitClick(Sender: TObject);
begin
  FormStuff.bStoreCoord := not FormStuff.bStoreCoord;
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.mnuPopupPopup(Sender: TObject);
var
  OnAValidLine : boolean;
begin
  OnAValidLine := FormStuff.aMulCtrlO[GetListIndex].ValidLine;
  mniSaveOnExit.Checked := FormStuff.bStoreCoord;
  mniDelete.Enabled := OnAValidLine;
  mniEdit.Enabled := OnAValidLine;
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.mniPropertiesClick(Sender: TObject);
begin
  with FormStuff do
    ListProperties(Self, aMULCtrlO[GetListIndex], bSetDefaults, 'Lookups Properties');
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.HeadersMouseDownExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[GetListIndex].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[GetListIndex].VisiList.MoveLabel(X,Y);
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, GetListIndex);
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.FormResize(Sender: TObject);
begin
  DoFormResize(Self,FormStuff);
  pgcLookups.Width := ClientWidth - pnlButtons.Width - 4;
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.CheckAutoEnabled;
begin
  btnAuto.Enabled := (pgcLookups.ActivePage = tabCurrency) and (Trim(fActiveTrader) = '');
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.pgcLookupsChange(Sender: TObject);
begin
  CheckAutoEnabled;
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.btnAutoClick(Sender: TObject);
var
  CurrNum : integer;
  CurrencyRec : TBatchCurrRec;
  CurrLookup : TEBusBtrieveLookupTraderRef;
  LockRec  : boolean;
  LockPos  : longint;
begin
  if MessageDlg('For convenience, this function will automatically add or update ' +
             'any global currency lookups that have an identical Exchequer '+
             '''Screen Symbol'' and ISO currency code.' + #13#10 +
             'Do you wish to continue?', mtConfirmation, [mbOK, mbCancel], 0) = mrOK then
  with TISOCurrencyList.Create do
    try
      for CurrNum := 1 to MAX_CURRENCY_INDEX do
        if Ex_GetCurrency(@CurrencyRec, SizeOf(CurrencyRec), CurrNum) = 0 then
          if CurrencyCodeExists(CurrencyRec.ScreenSymb) then
            if OpenBtrieveLookup(CurrLookup) = 0 then
              with CurrLookup do
              begin
                OurTraderCode := '';
                OurItemCode := IntToStr(CurrNum);
                LockRec := true;
                if FindRecord(LockRec, LockPos) = 0 then
                begin
                  TheirItemCode := CurrencyRec.ScreenSymb;
                  Description := CurrencyRec.Name;
                  UpdateRecord;
                  UnlockRecord(LockPos);
                end
                else
                begin
                  OurTraderCode := '';
                  OurItemCode := IntToStr(CurrNum);
                  TheirItemCode := CurrencyRec.ScreenSymb;
                  Description := CurrencyRec.Name;
                  AddRecord;
                end;
                CloseFile;
                Free;
              end;
      RefreshList;        
    finally
      Free;
    end;
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.RefreshList;
// Notes : This routine refreshes the whole list - use for deletes
//         and updates that affect multiple rows.
begin
 with FormStuff.aMulCtrlO[GetListIndex] do
   if (MUListBox1.Row <> 0) and (PageKeys[0] <> 0) then
     PageUpDn(0, true)
   else
     InitPage;
end;

//-----------------------------------------------------------------------

procedure TfrmCodeLookup.RefreshOneLine(Edited: boolean);
begin
 with FormStuff.aMulCtrlO[GetListIndex] do
   if (MUListBox1.Row <> 0) and (PageKeys[0] <> 0) then
     AddNewRow(MUListBoxes[0].Row, Edited)
   else
     InitPage;
end;

end.

