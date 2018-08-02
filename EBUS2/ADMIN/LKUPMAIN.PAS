unit LkUpMain;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, StdCtrls, ExtCtrls, SBSPanel, SupListU, GlobVar, BtSupU1,
  eBusCnst, EBusBtrv,
  EBusUtil, Buttons, BtrvList, LkUpTrad;

type
  TLookupList = class(TGenList)
    private
      function TraderCodeToType(TraderCode : string) : string;
      function TraderCodeToName(TraderCode : string) : string;
    public
      function SetCheckKey : Str255; override;
      function OutLine(Col : byte) : str255; override;
  end;

  TfrmLookupMain = class(TForm)
    sbxMain: TScrollBox;
    pnlCode: TSBSPanel;
    pnlName: TSBSPanel;
    pnlListControls: TSBSPanel;
    pnlColumnHeaders: TSBSPanel;
    pnlCodeHead: TSBSPanel;
    pnlNameHead: TSBSPanel;
    mnuPopup: TPopupMenu;
    mnuPopupSep1: TMenuItem;
    mniProperties: TMenuItem;
    mnuPopupSep2: TMenuItem;
    mniSaveOnExit: TMenuItem;
    mniEditLookups: TMenuItem;
    mniAddGlobalLookups: TMenuItem;
    mniAddLookups: TMenuItem;
    pnlButtons: TSBSPanel;
    sbxButtons: TScrollBox;
    btnAdd: TButton;
    btnEdit: TButton;
    btnClose: TButton;
    pnlType: TSBSPanel;
    pnlTypeHead: TSBSPanel;
    btnAddGlobal: TButton;
    btnDelete: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure mniPropertiesClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mniSaveOnExitClick(Sender: TObject);
    procedure mnuPopupPopup(Sender: TObject);
    procedure HeadersMouseDownExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MoveAlignColsExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure EditEvent(Sender: TObject);
    procedure AddEvent(Sender: TObject);
    procedure AddGlobalEvent(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    FormStuff : TFormStuff;
    frmLookupDetails : TfrmCodeLookup;
    BtrieveCompany : TEBusBtrieveCompany;
    fActiveTrader : string;
    procedure RefreshList;
    procedure LinkLookupForm;
    procedure ActiveLineChanged;
    procedure EditLine(ShowSubForm : boolean);
    procedure ShowLookupsPerTrader(ShowSubForm : boolean);
    procedure WMCustGetRec(var Message : TMessage); message WM_CustGetRec;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMSysCommand(var Message : TMessage); message WM_SysCommand;
    procedure WMFormCloseMsg(var Message : TMessage); message WM_FormCloseMsg;
    procedure ShowFormSize;
  end;

var
  frmLookupMain: TfrmLookupMain;

implementation

{$R *.DFM}

uses
  EBusVar, CmpCtrlU, BtrvU2, UseDLLU, ColCtrlU, EBusLkup,
  EBusLook, StrUtil, AdmnUtil, UseTKit, EntUtil, EntLkup,
  MainF;

const
  DEF_CLIENT_HEIGHT = 195;
  DEF_CLIENT_WIDTH = 461;
  BASE_FORM_LETTER = 'A';

//-----------------------------------------------------------------------

function TLookupList.SetCheckKey : Str255;
begin
  FillChar(Result, Sizeof(Result), 0);
  with EBusLookupRec, LookUpGeneric do
    Result := RecPFix + SubType;
end;

//-----------------------------------------------------------------------

function TLookupList.TraderCodeToType(TraderCode : string) : string;
var
  TraderDetails : TBatchCURec;
begin
  if Trim(TraderCode) = '' then
    Result := 'Global'
  else
  begin
    if GetTraderDetailsFromCode(Trim(TraderCode), TraderDetails) = 0 then
      case TraderDetails.CustSupp of
        'C' : Result := 'Customer';
        'S' : Result := 'Supplier';
      end
    else
      Result := 'Unknown'
  end;
end; // TLookupList.TraderCodeToType

//-----------------------------------------------------------------------

function TLookupList.TraderCodeToName(TraderCode : string) : string;
begin
  if Trim(TraderCode) = '' then
    Result := 'Global default'
  else
    Result := GetTraderNameFromCode(Trim(TraderCode));
end;

//-----------------------------------------------------------------------

function TLookupList.OutLine(Col : byte) : str255;
begin
  with EBusLookupRec.LookupGeneric do
    case Col of
      0: if Trim(OurTraderCode) ='' then
           Result := 'Global'
         else
           Result := Trim(OurTraderCode);
      1: Result := TraderCodeToType(OurTraderCode);
      2: Result := TraderCodeToName(OurTraderCode);
    end; // case
end; // TLookupList.OutLine

//=======================================================================

procedure TfrmLookupMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with FormStuff do
    StoreFormProperties(Self, FormStuff, bStoreCoord, bSetDefaults, bLastCoord, BASE_FORM_LETTER);
  FormStuff.Free;
  CloseEBusCompanyFile(EBsL);
  Action := caFree;
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.RefreshList;
begin
  with FormStuff.aMULCtrlO[0] do
    if MUListBox1.Row <> 0 then
      PageUpDn(0, true)
    else
      InitPage;
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.WMCustGetRec(var Message : TMessage);
begin
  with Message do
    case WParam of
      0:  // Double click
          EditEvent(self);
      1: // Row with data gets focus
         // Message relaying to avoid problems with mouse up event
         begin
           PostMessage(Self.Handle, WM_FormCloseMsg,1000+WParam,0);
         end;
      2:  // Right click
          mnuPopup.PopUp(LParamLo, lParamHi);
      200: // Add / update performed
          with FormStuff.aMulCtrlO[0] do
            AddNewRow(MUListBoxes[0].Row, false);
      300: // Delete performed
          RefreshList;
      EBUS_FORM_CLOSE:
        begin
          frmLookupDetails := nil;
          RefreshList;
        end;
    end;
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.WMFormCloseMsg(var Message  :  TMessage);
begin
  // Avoids problem with coordination between parent and child form refresh
  with Message do
    case WParam of
      1001 : ActiveLineChanged; // LinkLookupForm;
    end;
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.btnDeleteClick(Sender: TObject);
var
  Prompt,
  TraderCode : string;
begin
  with FormStuff.aMulCtrlO[0] do
    if ValidLine then
    begin
      GetSelRec(false);
      TraderCode := EBusLookupRec.LookUpGeneric.OurTraderCode;
      if Trim(TraderCode) = '' then
        Prompt := 'global lookups'
      else
        Prompt := 'all lookups for ' + Trim(TraderCode);
      if ConfirmRecordDelete(Prompt) then
        with TEBusBtrieveLookup.Create do
        try
          FileLocation := IncludeTrailingBackSlash(IncludeTrailingBackSlash
                          (GetCompanyDirFromCode(CurCompSettings.CompanyCode)) + EBUS_DIR);
          OpenFile;
          OurTraderCode := TraderCode;
          IndexNumber := 2;
          Status := FindRecord(B_GetGEq);
          while (Status = 0) and (OurTraderCode = TraderCode) do
          begin
            Status := DeleteRecord(false);
            if Status = 0 then
              FindRecord(B_GetGEq);
          end;
          CloseFile;
        finally
          Free;
        end;

      if MUListBox1.Row <> 0 then
        PageUpDn(0, true)
      else
        InitPage;
    end;
end; // TfrmCompanies.btnDeleteClick

//-----------------------------------------------------------------------

procedure TfrmLookupMain.ShowLookupsPerTrader(ShowSubForm : boolean);
// Pre : ShowSubForm = true => display sub-form if not currently shown
begin
  if not Assigned(frmLookupDetails) and ShowSubForm then
  begin
    frmLookupDetails := TfrmCodeLookup.Create(self);
    frmLookupDetails.RefreshDetails(fActiveTrader);
  end;

  LinkLookupForm;
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.LinkLookupForm;
begin
  with FormStuff.aMULCtrlO[0] do
    RefreshLine(MUListBoxes[0].Row, false);

  if Assigned(frmLookupDetails) then
    frmLookupDetails.RefreshDetails(fActiveTrader);
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.WMSysCommand(var Message : TMessage);
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
end; // TfrmCompanies.WMSysCommand

//-----------------------------------------------------------------------

procedure TfrmLookupMain.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
begin
  with Message.MinMaxInfo^ do
  begin
    ptMinTrackSize.X := DEF_CLIENT_WIDTH + 8;
    ptMinTrackSize.Y := DEF_CLIENT_HEIGHT + 27;
  end;
  Message.Result := 0;
  Inherited;
end; // TfrmCompanies.WMGetMinMaxInfo

//-----------------------------------------------------------------------

procedure TfrmLookupMain.HeadersMouseDownExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[0].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[0].VisiList.MoveLabel(X,Y);
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, 0);
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.FormResize(Sender: TObject);
begin
  DoFormResize(Self,FormStuff);
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.FormCreate(Sender: TObject);
begin
  Status := OpenEBusCompanyFile(EBsL, CurCompSettings.CompanyCode, true);

  FormStuff := TFormStuff.Create(1);
  ClientHeight := DEF_CLIENT_HEIGHT;
  ClientWidth := DEF_CLIENT_WIDTH;

  with FormStuff do
  begin
    bFillList := true;
    SetLength(aColumns[0], 3);
    aColumns[0,0].ColPanel := pnlCode;
    aColumns[0,0].HeadPanel := pnlCodeHead;
    aColumns[0,1].ColPanel := pnlType;
    aColumns[0,1].HeadPanel := pnlTypeHead;
    aColumns[0,2].ColPanel := pnlName;
    aColumns[0,2].HeadPanel := pnlNameHead;

    aFileNos[0] := EBsL;
    asbMain[0] := sbxMain;
    apanTitle[0] := pnlColumnHeaders;
    asbButtons[0] := sbxButtons;
    apanButtons[0] := pnlButtons;
    aMULCtrlO[0] := TLookupList.Create(Self);
    apanScrollBar[0] := pnlListControls;
    aiKeys[0] := 0;

    // Leave the include filter blank
    // aFilters[0,1,1] := NdxWeight;  // Exclude filter

    aKeyStart[0] := LOOKUP_TYPE_TRADER + LOOKUP_SUBTYPE_NONE;
//    aKeyEnd[0] := LOOKUP_TYPE_TRADER + LOOKUP_SUBTYPE_NONE;

    ReadFormProperties(Self, FormStuff, BASE_FORM_LETTER);
    DoFormResize(Self,FormStuff);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.mnuPopupPopup(Sender: TObject);
var
  OnAValidLine : boolean;
begin
  OnAValidLine := FormStuff.aMulCtrlO[0].ValidLine;
  mniSaveOnExit.Checked := FormStuff.bStoreCoord;
  mniEditLookups.Enabled := OnAValidLine;
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.mniSaveOnExitClick(Sender: TObject);
begin
  FormStuff.bStoreCoord := not FormStuff.bStoreCoord;
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.mniPropertiesClick(Sender: TObject);
begin
  with FormStuff do
    ListProperties(Self, aMULCtrlO[0], bSetDefaults, 'Company Properties');
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.ShowFormSize;
begin
  if MessageDlg('Client settings', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    ShowMessage(Format('Client Height = %d' + #13#10 + 'Client Width = %d',
      [ClientHeight, ClientWidth]))
  else
    ShowMessage(Format('Height = %d' + #13#10 + 'Width = %d',
      [Height, Width]))
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.EditLine(ShowSubForm : boolean);
begin
  with FormStuff.aMulCtrlO[0] do
    if ValidLine then
    begin
      GetSelRec(false);
      fActiveTrader := EBusLookupRec.LookUpGeneric.OurTraderCode;
      ShowLookupsPerTrader(ShowSubForm);
    end;
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.EditEvent(Sender: TObject);
begin
  EditLine(true);
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.ActiveLineChanged;
begin
  EditLine(false);
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.AddEvent(Sender: TObject);
var
  TraderCode : string20;
begin
  TraderCode := '';

  if DoGetCust(frmMain,{self,} CurCompSettings.CompanyPath, TraderCode, TraderCode, trdEither,
                vmShowList, true) then
(*  if DoGetCust(self, CurCompSettings.CompanyPath, TraderCode, TraderCode, trdEither,
    vmShowList, true) then *)
  begin
    fActiveTrader := TraderCode;
    ShowLookupsPerTrader(true);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmLookupMain.AddGlobalEvent(Sender: TObject);
begin
  fActiveTrader := StringOfChar(' ', SizeOf(EBusLookupRec.LookupGeneric.OurTraderCode) -1);
  ShowLookupsPerTrader(true);
end;

//-----------------------------------------------------------------------


end.
