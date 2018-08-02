unit Comps;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, StdCtrls, ExtCtrls, SBSPanel, SupListU, GlobVar, BtSupU1,
  eBusCnst, Company, EBusBtrv,
  EBusUtil, Buttons, BtrvList;

type
  TCompanyList = class(TGenList)
    public
      Companies : PCompanies;
      function SetCheckKey : Str255; override;
      function OutLine(Col : byte) : str255; override;
      constructor Create(AOwner : TComponent);
      destructor  Destroy; //override;
  end;

  TfrmCompanies = class(TForm)
    sbxMain: TScrollBox;
    pnlCode: TSBSPanel;
    pnlDesc: TSBSPanel;
    pnlListControls: TSBSPanel;
    pnlColumnHeaders: TSBSPanel;
    pnlCodeHead: TSBSPanel;
    pnlDescHead: TSBSPanel;
    mnuPopup: TPopupMenu;
    mnuPopupSep1: TMenuItem;
    mniProperties: TMenuItem;
    mnuPopupSep2: TMenuItem;
    mniSaveOnExit: TMenuItem;
    mniEdit: TMenuItem;
    mniActivate: TMenuItem;
    mniAdd: TMenuItem;
    mniDelete: TMenuItem;
    pnlButtons: TSBSPanel;
    sbxButtons: TScrollBox;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnActivate: TButton;
    btnClose: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShowEditForm(Sender: TObject);
    procedure ActivateClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure mniPropertiesClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mniSaveOnExitClick(Sender: TObject);
    procedure mnuPopupPopup(Sender: TObject);
    procedure HeadersMouseDownExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MoveAlignColsExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    CompList : TCompanyList;
    FormStuff : TFormStuff;
    frmOneCompany : TfrmOneCompany;
    BtrieveCompany : TEBusBtrieveCompany;
    procedure WMCustGetRec(var Message : TMessage); message WM_CustGetRec;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMSysCommand(var Message : TMessage); message WM_SysCommand;
    function  CompaniesToAdd : boolean;
    procedure ShowFormSize;
  end;

var
  frmCompanies: TfrmCompanies;

implementation

{$R *.DFM}

uses
  EBusVar, CmpCtrlU, {EBusMain, }BtrvU2, UseDLLU, ColCtrlU{,
  LkupBtrv}, StrUtil, AdmnUtil;

const
  DEF_CLIENT_HEIGHT = 195;
  DEF_CLIENT_WIDTH = 379;
  BASE_FORM_LETTER = 'A';

//-----------------------------------------------------------------------

function TCompanyList.SetCheckKey : Str255;
begin
  FillChar(Result,Sizeof(Result),0);
  with EBusRec do
    Result := RecPfix + SubType;
end;

//-----------------------------------------------------------------------

function TCompanyList.OutLine(Col : byte) : str255;
begin
  with EBusRec, EBusCompany do
    case Col of
      0: Result := EBusCode1; // Enterprise multi-company code
      1: Result := GetCompanyDescription(EBusCode1, Companies); // Company name
    end; // case
end; // TCompanyList.OutLine

//-----------------------------------------------------------------------

constructor TCompanyList.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  new(Companies);
  InitialiseCompaniesRec(Companies);
end;

//-----------------------------------------------------------------------

destructor TCompanyList.Destroy;
begin
  dispose(Companies);
  inherited Destroy;
end;

//=======================================================================

procedure TfrmCompanies.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with FormStuff do
    StoreFormProperties(Self, FormStuff, bStoreCoord, bSetDefaults, bLastCoord, BASE_FORM_LETTER);
  Action := caFree;
end;

//-----------------------------------------------------------------------

procedure TfrmCompanies.WMCustGetRec(var Message : TMessage);
begin
  with Message do
    case WParam of
      0:  // Double click
          ShowEditForm(self);
      2:  // Right click
          mnuPopup.PopUp(LParamLo, lParamHi);
      200: // Add / update performed
        with FormStuff.aMulCtrlO[0] do
          AddNewRow(MUListBoxes[0].Row, false);
      300: // Delete performed
        with FormStuff.aMULCtrlO[0] do
          if MUListBox1.Row <> 0 then
            PageUpDn(0, true)
          else
            InitPage;
      800 : frmOneCompany := nil;
    end;
end; // TfrmCompanies.WMCustGetRec

//-----------------------------------------------------------------------

function TfrmCompanies.CompaniesToAdd : boolean;
// Post : Returns true if companies present in the Multi-Company Manager
//        haven't been set-up in the E-Business module
var
  Companies : PCompanies;
  i,
  CompCount,
  NoCompanies : longint;
begin
  new(Companies);
  CompCount := 0;
  if InitialiseCompaniesRec(Companies, NoCompanies) = 0 then
    for i := 1 to NoCompanies do
      with Companies^[i] do
        if not CompanyBeenSetUp(CompCode) then
          inc(CompCount);
  dispose(Companies);
  Result := CompCount > 0;
end; // TfrmCompanies.CompaniesToAdd

//-----------------------------------------------------------------------

procedure TfrmCompanies.ShowEditForm(Sender: TObject);
var
  ShowForm : boolean;
  ShowMode : TFormActivate;
  LockRec  : boolean;
  LockPos  : longint;
  CompCode : string;
begin
  // If the company form is already open - ignore any further requests to show it
  if Assigned(frmOneCompany) then
    exit;

  ShowForm := false;
  ShowMode := actShow;
  CompCode := '';
  LockPos := 0;

  with FormStuff.aMulCtrlO[0] do
  begin
    GetSelRec(false);
    BtrieveCompany := TEBusBtrieveCompany.Create(true);
    BtrieveCompany.OpenFile;
    BtrieveCompany.CompanyCode := EBusRec.EBusCode1;

    if (Sender = btnAdd) or (Sender = mniAdd) then
    begin
      ShowForm := CompaniesToAdd;
      if not ShowForm then
        MessageDlg('There are no additional companies in the Exchequer' + CRLF +
                   'Multi-Company Manager to add to the E-Business Module',
                   mtInformation, [mbOK], 0);
      ShowMode := actAdd;
    end;

    if ((Sender = btnEdit) or (Sender = mniEdit) or (Sender = self)) and ValidLine then
    begin
      ShowMode := actEdit;
      LockRec := true;
      if BtrieveCompany.FindRecord(LockRec, LockPos) = 0 then
        ShowForm := true
      else
        WarnRecordLocked;
    end;
  end; // with

  if ShowForm then
  begin
    frmOneCompany := TfrmOneCompany.Create(self);
    frmOneCompany.Display(ShowMode, BtrieveCompany, LockPos);
  end;
end; // TfrmCompanies.ShowEditForm

//-----------------------------------------------------------------------

procedure TfrmCompanies.ActivateClick(Sender: TObject);
begin
  // This populates the Btrieve record with the values in the currently selected
  // row of the Btrieve list.
  with CompList do
  begin
    if not ValidLine then
      exit;
    GetSelRec(false);
    //ActivateCompany(EBusRec.EBusCode1);
  end;

  // frmEBusinessMain.UpdateActiveCompanyInfo;
  // frmEBusinessMain.PopulateCompanyList;
end;

//-----------------------------------------------------------------------

procedure TfrmCompanies.DeleteClick(Sender: TObject);
const
  FNum = EBsF;
begin
  with FormStuff.aMulCtrlO[0] do
    if ValidLine and ConfirmRecordDelete('this record') then
    begin
      GetSelRec(false);

      if Delete_Rec(F[FNum], FNum, 0) in [84, 85] then
        WarnRecordLocked
      else
        if MUListBox1.Row <> 0 then
          PageUpDn(0, true)
        else
          InitPage;
    end;
end; // TfrmCompanies.btnDeleteClick

//-----------------------------------------------------------------------

procedure TfrmCompanies.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmCompanies.WMSysCommand(var Message : TMessage);
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

procedure TfrmCompanies.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
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

procedure TfrmCompanies.HeadersMouseDownExecute(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[0].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

//-----------------------------------------------------------------------

procedure TfrmCompanies.HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[0].VisiList.MoveLabel(X,Y);
end;

//-----------------------------------------------------------------------

procedure TfrmCompanies.MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, 0);
end;

//-----------------------------------------------------------------------

procedure TfrmCompanies.FormResize(Sender: TObject);
begin
  DoFormResize(Self,FormStuff);
end;

//-----------------------------------------------------------------------

procedure TfrmCompanies.FormCreate(Sender: TObject);
begin
  FormStuff := TFormStuff.Create(1);
  ClientHeight := DEF_CLIENT_HEIGHT;
  ClientWidth := DEF_CLIENT_WIDTH;

  with FormStuff do
  begin
    bFillList := true;
    SetLength(aColumns[0], 2);
    aColumns[0,0].ColPanel := pnlCode;
    aColumns[0,0].HeadPanel := pnlCodeHead;
    aColumns[0,1].ColPanel := pnlDesc;
    aColumns[0,1].HeadPanel := pnlDescHead;
(*    aColumns[0,2].ColPanel := pnlDNet;
    aColumns[0,2].HeadPanel := pnlDNetHead; *)
(*
    if not DRAGNET_AVAILABLE then
      Include(aHideColumns, 2); *)

    aFileNos[0] := EBsF;
    asbMain[0] := sbxMain;
    apanTitle[0] := pnlColumnHeaders;
    asbButtons[0] := sbxButtons;
    apanButtons[0] := pnlButtons;
    CompList := TCompanyList.Create(Self);
    aMULCtrlO[0] := CompList;
    apanScrollBar[0] := pnlListControls;
    aiKeys[0] := 0;
    aKeyStart[0] := EBUS_RECPFIX_ENTERPRISE + EBUS_SUBTYPE_COMPANY;
    aKeyEnd[0] := EBUS_RECPFIX_ENTERPRISE + EBUS_SUBTYPE_COMPANY;
    //  aKeyStart[0] := PadString(psRight, EBUS_RECPFIX_ENTERPRISE + EBUS_SUBTYPE_COMPANY,' ', 42);
    //  aKeyStart[0] := SpacePad(EBUS_ENTERPRISE + EBUS_COMPANY, 3);

    ReadFormProperties(Self, FormStuff, BASE_FORM_LETTER);
    DoFormResize(Self,FormStuff);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmCompanies.FormDestroy(Sender: TObject);
begin
  FormStuff.Free;
end;

//-----------------------------------------------------------------------

procedure TfrmCompanies.mnuPopupPopup(Sender: TObject);
var
  OnAValidLine : boolean;
begin
  OnAValidLine := FormStuff.aMulCtrlO[0].ValidLine;
  mniSaveOnExit.Checked := FormStuff.bStoreCoord;
  mniDelete.Enabled := OnAValidLine;
  mniEdit.Enabled := OnAValidLine;
  mniActivate.Enabled := OnAValidLine;
end;

//-----------------------------------------------------------------------

procedure TfrmCompanies.mniSaveOnExitClick(Sender: TObject);
begin
  FormStuff.bStoreCoord := not FormStuff.bStoreCoord;
end;

//-----------------------------------------------------------------------

procedure TfrmCompanies.mniPropertiesClick(Sender: TObject);
begin
  with FormStuff do
    ListProperties(Self, aMULCtrlO[0], bSetDefaults, 'Company Properties');
end;

//-----------------------------------------------------------------------

procedure TfrmCompanies.ShowFormSize;
begin
  if MessageDlg('Client settings', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    ShowMessage(Format('Client Height = %d' + #13#10 + 'Client Width = %d',
      [ClientHeight, ClientWidth]))
  else
    ShowMessage(Format('Height = %d' + #13#10 + 'Width = %d',
      [Height, Width]))
end;

//-----------------------------------------------------------------------

end.
