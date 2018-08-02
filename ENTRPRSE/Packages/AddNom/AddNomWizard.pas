unit AddNomWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , AddNomPROC, Dialogs, ExtCtrls, StdCtrls, Grids, NomLine, EnterToTab
  , uExDatasets, TKPickList, ComCtrls, NumEdit, Mask, TEditVal, Enterprise01_TLB
  , Menus, BorBtns, StrUtil, PeriodYearUtil;

const
  TOT_NET_AMOUNT = 1;
  TOT_VAT_AMOUNT = 2;
  TOT_GROSS_AMOUNT = 3;

  F_BANK_ACCOUNT = 1;
  F_BANK_TO = 2;
  F_COSTCENTRE = 3;
  F_DEPARTMENT = 4;
  NO_OF_FIELDS_TO_VALIDATE = 10;

type
  TTXType = (ttPayment, ttReceipt, ttTransfer, ttRecurring, ttStandard);

  TfrmAddNomWizard = class(TForm)
    panBitmap: TPanel;
    Shape1: TShape;
    Image1: TImage;
    btnNext: TButton;
    btnBack: TButton;
    btnCancel: TButton;
    nbPages: TNotebook;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    sbLines: TScrollBox;
    HeaderControl1: THeaderControl;
    edBankAccount: TEdit;
    lBankAccount: TLabel;
    Label6: TLabel;
    edDate: TDateTimePicker;
    edPY: TEditPeriod;
    Label7: TLabel;
    edReference: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edCC: TEdit;
    edDept: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edCurrencyRate: TNumEdit;
    lStartDate: TLabel;
    edStartDate: TDateTimePicker;
    edStartPY: TEditPeriod;
    lIncPeriods: TLabel;
    edIncPeriods: TNumEdit;
    lEndDate: TLabel;
    edEndDate: TDateTimePicker;
    lEndPY: TLabel;
    edEndPY: TEditPeriod;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lIncDays: TLabel;
    edIncDays: TNumEdit;
    lStartPY: TLabel;
    lBankTo: TLabel;
    edBankTo: TEdit;
    cmbCurrency: TComboBox;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    lBankAccountDesc: TLabel;
    lBankToDesc: TLabel;
    lCC: TLabel;
    lDept: TLabel;
    rbStandard: TBorRadio;
    rbRecurring: TBorRadio;
    rbTransfer: TBorRadio;
    rbReceipt: TBorRadio;
    rbPayment: TBorRadio;
    cbDateKeepDate: TBorCheckEx;
    cbPYKeepDate: TBorCheckEx;
    cbAutoCreate: TBorCheckEx;
    rbDate: TBorRadio;
    rbPY: TBorRadio;
    Panel1: TPanel;
    lBankAccountH: TLabel;
    edBankAccountH: TEdit;
    lBankToH: TLabel;
    edBankToH: TEdit;
    Label14: TLabel;
    edDateH: TDateTimePicker;
    Label15: TLabel;
    edReferenceH: TEdit;
    Label16: TLabel;
    cmbCurrencyH: TComboBox;
    Label17: TLabel;
    edCurrencyRateH: TNumEdit;
    edTotNetAmount: TNumEdit;
    edTotVatAmount: TNumEdit;
    edTotGrossAmount: TNumEdit;
    Label5: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ChangeAutoMode(Sender: TObject);
    procedure TXTypeChange(Sender: TObject);
    procedure nbPagesPageChanged(Sender: TObject);
    procedure edBankAccountExit(Sender: TObject);
    procedure edCCExit(Sender: TObject);
    procedure edDeptExit(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure cmbCurrencyChange(Sender: TObject);
    function edPYShowPeriod(Sender: TObject; const EPr: Byte): String;
    function edPYConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
    procedure edDateExit(Sender: TObject);
  private
//    bChangeMessaging, bALT, bOK, bTabBackwards : boolean;
    bOK : boolean;
    bFormActive : boolean;
    lstLines : TList;
    slVATCodes : TStringList;
//    OriginalAppMessage : TMessageEvent;
    TXType : TTXType;
//    procedure AppMessage (var Msg: TMsg; var Handled: Boolean);
    aValidation : array [1..NO_OF_FIELDS_TO_VALIDATE] of ValidationRec;
    aTotals : array [TOT_NET_AMOUNT..TOT_GROSS_AMOUNT] of Real;
    procedure AddNewLine;
    procedure EnableDisable;
    procedure FrameAddNewLine(Sender: TObject);
    procedure RecalcTotals(Sender: TObject);
    procedure DoTidyUp;
    Procedure TabToControl(bTabToNext : boolean);
    Procedure MoveUpDownGrid(bUp : boolean);
//    function WantChildKey(Child: TControl; var Message: TMessage): Boolean; override;
  public
    hNomDaybookHandle : HWnd;
  end;

var
  frmAddNomWizard: TfrmAddNomWizard;

  procedure ShowAddNomWizard(const DataPath, UserID : AnsiString); export;

implementation
uses
  APIUtil, KeyUtils, MiscUtil;

{$R *.dfm}

procedure ShowAddNomWizard(const DataPath, UserID : AnsiString);
var
  hTemp : Hwnd;
begin
//  showmessage('ShowAddNomWizard : ' + DataPath + ' / ' + UserId);

  StartToolkit(DataPath);

  if screen.activeform <> nil
  then hTemp := screen.activeform.handle;

  if frmAddNomWizard = nil
  then frmAddNomWizard := TfrmAddNomWizard.Create(Application.MainForm)
  else frmAddNomWizard.BringToFront;
  frmAddNomWizard.hNomDaybookHandle := hTemp;

end;

procedure TfrmAddNomWizard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  DoTidyUp;
  Action := caFree;

(*
  showmessage('FormClose');

  Application.OnMessage := OriginalAppMessage;

  // Highlight New Nom in daybook
  if bOK then PostMessage(hNomDaybookHandle, WM_User+$2, 129, 266{= new tx folio no});

  Action := caFree;

  ClearList(lstLines);
  ClearList(slVATCodes);
  lstLines.Free;
  slVATCodes.Free;

  oToolkit.CloseToolkit;
  oToolkit := nil;

//  bFormActive := FALSE;
  frmAddNomWizard := nil;
  *)
end;

procedure TfrmAddNomWizard.btnBackClick(Sender: TObject);
begin
  nbPages.PageIndex := nbPages.PageIndex -1;

  // Skip Auto Settings if not Recurring transaction
  if (nbPages.PageIndex = 2) and (TXType <> ttRecurring)
  then nbPages.PageIndex := nbPages.PageIndex - 1;

  EnableDisable;
end;

procedure TfrmAddNomWizard.btnNextClick(Sender: TObject);
var
  iPos : integer;
begin
  if btnNext.Caption = '&Finish' then
  begin
    // OK Create NOM
    bOK := TRUE;
    Close;
  end else
  begin
    if TXType = ttStandard then
    begin
      PostMessage(hNomDaybookHandle, WM_User+$2, 100, 0);  // Should open the normal Add Nom dialog
      bOK := TRUE;
      Close;
    end else
    begin

      // Validate Fields
      case nbPages.PageIndex of
        1 : begin
          For iPos := 1 to 4 do
          begin
            if (iPos = F_BANK_TO) and (TXType <> ttTransfer) then
            begin
              // Skip Validation
            end else
            begin
              if not aValidation[iPos].FieldOK
              then begin
                MsgBox('An invalid value has been enter in the following field : '
                + #13#13#9 + aValidation[iPos].Description + #13#13
                + 'Please enter a valid value into this field'
                ,mtError,[mbOK],mbOK,'Validation Error');
                TEdit(aValidation[iPos].FieldControl).Color := ERROR_COLOR;
                ActiveControl := aValidation[iPos].FieldControl;
                Exit;
              end;{if}
            end;{if}
          end;{for}
        end;
      end;{case}

      // Next Page
      nbPages.PageIndex := nbPages.PageIndex +1;

      // Skip Auto Settings if not Recurring transaction
      if (nbPages.PageIndex = 2) and (TXType <> ttRecurring)
      then nbPages.PageIndex := nbPages.PageIndex + 1;

      EnableDisable;
    end;
  end;{if}
end;

procedure TfrmAddNomWizard.btnCancelClick(Sender: TObject);
begin
  if MsgBox('Are you sure you want to cancel the Add Journal Wizard ?'
  ,mtConfirmation, [mbYes, mbNo], mbNo, 'Add Journal Wizard') = mrYes
  then Close;
end;

procedure TfrmAddNomWizard.FormCreate(Sender: TObject);

  procedure CreateVATCodeList;
  Const
    aVATCodes : Array [1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
  var
    iPos : smallint;
    sPos : string;
  begin{CreateVATCodeList}
    slVATCodes := TStringList.Create;
    For iPos := Low(aVATCodes) To High(aVATCodes) Do begin
      sPos := aVATCodes[iPos];
      slVATCodes.AddObject(oToolkit.SystemSetup.ssVATRates[sPos].svDesc + ' ('
      + oToolkit.SystemSetup.ssVATRates[sPos].svCode + ')'
      ,TVATInfo.Create(oToolkit.SystemSetup.ssVATRates[sPos].svRate
      , oToolkit.SystemSetup.ssVATRates[sPos].svCode));
    end;{for}

    slVATCodes.AddObject('Dispatches (D)'
    ,TVATInfo.Create(oToolkit.SystemSetup.ssVATRates['D'].svRate, 'D'));

  end;{CreateVATCodeList}

var
  iPos : integer;
  
begin
//  TABKeyTrap.ShortCut := ShortCut(vk_Tab,[]);

//  bFormActive := FALSE;
//  bChangeMessaging := TRUE;
//  bTabBackwards := FALSE;
//  bALT := FALSE;
  bOK := FALSE;

  For iPos := 1 to NO_OF_FIELDS_TO_VALIDATE do
  begin
    aValidation[iPos].FieldOK := FALSE;

    case iPos of
      F_BANK_ACCOUNT : begin
        aValidation[iPos].FieldControl := edBankAccount;
        aValidation[iPos].Description := 'Bank Account';
      end;
      F_BANK_TO : begin
        aValidation[iPos].FieldControl := edBankTo;
        aValidation[iPos].Description := 'Bank To';
      end;
      F_COSTCENTRE : begin
        aValidation[iPos].FieldControl := edCC;
        aValidation[iPos].Description := 'Cost Centre';
      end;
      F_DEPARTMENT : begin
        aValidation[iPos].FieldControl := edDept;
        aValidation[iPos].Description := 'Department';
      end;
    end;{case}
  end;{for}

//  Application.OnMessage := AppMessage;
  nbPages.PageIndex := 0;
//  sgLines.Cells[0,0] := 'Narrative';
//  sgLines.Cells[1,0] := 'Nominal';
//  sgLines.Cells[2,0] := 'Cost Centre';
//  sgLines.Cells[3,0] := 'Department';
//  sgLines.Cells[4,0] := 'VAT Code';
//  sgLines.Cells[5,0] := 'Net Amount';
//  sgLines.Cells[6,0] := 'VAT Amount';
//  sgLines.Cells[7,0] := 'Gross';

  FillCurrencyCombo(cmbCurrency, 1);
  cmbCurrencyChange(cmbCurrency);
  cmbCurrencyH.Items := cmbCurrency.Items;

  lstLines := TList.Create;
  CreateVATCodeList;
  AddNewLine;

  edTotNetAmount.Value := 0;
  edTotVATAmount.Value := 0;
  edTotGrossAmount.Value := 0;

  edDate.Date := Date;
  
//  edPY.EPeriod
//  edPY.EYear
//  edPY.PeriodsInYear := oToolkit.SystemSetup.ssPeriodsInYear;
//  edPY.EditMask := 00/0000;0;
//  lbHandles.Items.Add('*' + IntToStr(Self.Handle));
end;

procedure TfrmAddNomWizard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

begin
(*  case Key of

    16 : bTabBackwards := TRUE; // Shift
    18 : bALT := TRUE; // Alt

    // 'B' key for Back
    66 : begin
      if bALT then btnBack.Click;
    end;

    // 'C' key for Cancel
    67 : begin
      if bALT then btnCancel.Click;
    end;

    // 'N' key for Next
    78 : begin
      if bALT then btnNext.Click;
    end;

    // Cursor Keys

    9 : begin // Tab Key Down
      // Tabs do not work in this scenario
      // : MDI form in a DLL when not shown modally
//      PostMessage(Handle,wm_NextDlgCtl,Ord(bTabBackwards),0); // Tab to Next / Previous control

      // Make sure the fram knows that the last control movement was a tab
      if (ActiveControl.Parent is TfNomLine)
      then (ActiveControl.Parent as TfNomLine).Tabbed := TRUE;
    end;{if}

    VK_LEFT..VK_DOWN : begin
      if (ActiveControl.Parent is TfNomLine) then
      begin
        case Key of
          VK_LEFT : (ActiveControl.Parent as TfNomLine).CursorLeft;

          VK_UP : begin
            if (ActiveControl is TCustomEdit) then
            begin
              if (ActiveControl.Parent as TfNomLine).Tag = 0 then
              begin
                // First Line - Tab to previous control
                TabToControl(FALSE);
              end else
              begin
                // Go to edit field above current edit field
                MoveUpDownGrid(TRUE);
              end;{if}
            end;{if}
          end;

          VK_RIGHT : (ActiveControl.Parent as TfNomLine).CursorRight;

          VK_DOWN : begin
            if (ActiveControl is TCustomEdit) then
            begin
              if (ActiveControl.Parent as TfNomLine).Tag = (lstLines.Count -1) then
              begin
                // Last Line - Tab to next control
                TabToControl(TRUE);
              end else
              begin
                // Go to edit field below current edit field
                MoveUpDownGrid(FALSE);
              end;{if}
            end;{if}
          end;
        end;{case}
      end else
      begin
        // Tab to Next / Previous control
        PostMessage(Handle,wm_NextDlgCtl,Ord(Key in [VK_LEFT, VK_UP]),0);
      end;{if}
    end;
  end;{case}*)
end;

procedure TfrmAddNomWizard.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
{  case Key of
    16 : bTabBackwards := FALSE;
    18 : bALT := FALSE;
  end;{case}
end;

procedure TfrmAddNomWizard.Button2Click(Sender: TObject);
begin
  AddNewLine;
end;
(*
function TfrmAddNomWizard.WantChildKey(Child: TControl;
  var Message: TMessage): Boolean;
begin
  If (Message.Msg = WM_KEYDOWN) and (Message.WParam = VK_TAB) Then
    Self.Caption := 'Tabbie Tabbie!!'
  Else;
//    Self.Caption := TimeToStr(Now);

  Result := Inherited WantChildKey(child,Message);
end;

procedure TfrmAddNomWizard.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
//  if bFormActive then
//  begin

//lbHandles.Items.Add('M');

//lbHandles.ItemIndex := lbHandles.Items.Count -1;

    If (Msg.message = WM_KEYDOWN) then
    begin

//lbHandles.Items.Add('M:' + IntToStr(Msg.hwnd));
//lbHandles.Items.Add('A:' + IntToStr(ActiveControl.Handle));

//if (Msg.hwnd = ActiveControl.Handle) then
//begin

      case Msg.wParam of

        9 : begin // Tab Key Down
          // Tabs do not work in this scenario
          // : MDI form in a DLL when not shown modally
          PostMessage(Handle,wm_NextDlgCtl,Ord(bTabBackwards),0); // Tab to Next / Previous control

          // Make sure the fram knows that the last control movement was a tab
          if (ActiveControl.Parent is TfNomLine)
          then (ActiveControl.Parent as TfNomLine).Tabbed := TRUE;
        end;{if}

        // Trap Enter Key
        13 : begin  // Enter Key down
          if (ActiveControl is TButton) then
          begin
            // The 'Click' event does not appear to trigger on buttons when you press enter
            (ActiveControl as TButton).Click;
          end else
          begin
            // Replace Enter with Tab
            if ReplaceEntersForControl(ActiveControl)
            then PostMessage(Handle,wm_NextDlgCtl,0,0); // Tab to Next control
          end;{if}

          // Make sure the fram knows that the last control movement was a tab
          if (ActiveControl.Parent is TfNomLine)
          then (ActiveControl.Parent as TfNomLine).Tabbed := TRUE;
        end;

        // Trap Escape Key

        27 : begin  // Escape Key down
          // The 'Click' event does not appear to trigger on buttons that have cancel set to true, when you press ESC
          btnCancel.Click;
        end;

        // 'B' key for Back
        66 : begin
          if bALT then btnBack.Click;
        end;

        // 'N' key for next
        78 : begin
          if bALT then btnNext.Click;
        end;

      end;{case}
//end;{if}
    end;{if}
//  end;{if}
end;
*)
procedure TfrmAddNomWizard.FormActivate(Sender: TObject);
begin
//  bFormActive := TRUE;
{  if bChangeMessaging then
  begin
    OriginalAppMessage := Application.OnMessage;
    Application.OnMessage := AppMessage;
  end;}
end;

procedure TfrmAddNomWizard.FormDeactivate(Sender: TObject);
begin
//  bFormActive := FALSE;
{  if bChangeMessaging
  then Application.OnMessage := OriginalAppMessage;}
end;

procedure TfrmAddNomWizard.AddNewLine;
var
  fNewLine : TfNomLine;
begin
  fNewLine := TfNomLine.Create(self);
  lstLines.Add(fNewLine);

  with fNewLine do
  begin
    Name := Name + IntToStr(lstLines.Count);
    Parent := sbLines;
    Top := (Height * (lstLines.Count -1) + 1) - sbLines.VertScrollBar.ScrollPos;
    Left := 1;
    Tag := lstLines.Count -1;
    OnAddNewLine := FrameAddNewLine;
    OnRecalcTotals := RecalcTotals;
    Initialise;
    cmbVatCode.Items := slVATCodes;
    cmbVatCode.ItemIndex := 0;
  end;{with}
end;

procedure TfrmAddNomWizard.EnableDisable;
begin
  if nbPages.PageIndex = 0
  then btnBack.Enabled := FALSE;

  if nbPages.PageIndex = (nbPages.Pages.Count -1)
  then btnNext.Caption := '&Finish' // last page
  else btnNext.Caption := '&Next  >>'; // other pages

  if nbPages.PageIndex > 0
  then btnBack.Enabled := TRUE;
end;

procedure TfrmAddNomWizard.FrameAddNewLine(Sender: TObject);
begin
  if (Sender as TfNomLine).Tag = (lstLines.Count -1) then
  begin
    AddNewLine;
    ActiveControl := TfNomLine(lstLines[lstLines.Count -1]).edDesc;
  end;{if}
end;

procedure TfrmAddNomWizard.RecalcTotals(Sender: TObject);
var
  iPos : integer;
begin
  For iPos := TOT_NET_AMOUNT to TOT_GROSS_AMOUNT
  do aTotals[iPos] := 0;

  For iPos := 0 to lstLines.Count -1 do
  begin
    aTotals[TOT_NET_AMOUNT] := aTotals[TOT_NET_AMOUNT]
    + TfNomLine(lstLines[iPos]).edNetAmount.Value;

    aTotals[TOT_VAT_AMOUNT] := aTotals[TOT_VAT_AMOUNT]
    + TfNomLine(lstLines[iPos]).edVATAmount.Value;

    aTotals[TOT_GROSS_AMOUNT] := aTotals[TOT_GROSS_AMOUNT]
    + StrToFloatDef(TfNomLine(lstLines[iPos]).lGrossAmount.Caption, 0);
  end;{for}

  edTotNetAmount.Value := aTotals[TOT_NET_AMOUNT];
  edTotVATAmount.Value := aTotals[TOT_VAT_AMOUNT];
  edTotGrossAmount.Value := aTotals[TOT_GROSS_AMOUNT];
end;

procedure TfrmAddNomWizard.DoTidyUp;
begin
//  Application.OnMessage := OriginalAppMessage;
//  bChangeMessaging := FALSE;

  // Highlight New Nom in daybook
  if bOK then PostMessage(hNomDaybookHandle, WM_User+$2, 129, 266{= new tx folio no});

  if lstLines <> nil then
  begin
    ClearList(lstLines);
    lstLines.Free;
    lstLines := nil;
  end;{if}

  if slVATCodes <> nil then
  begin
    ClearList(slVATCodes);
    slVATCodes.Free;
    slVATCodes := nil;
  end;{if}

  if oToolkit <> nil then
  begin
    oToolkit.CloseToolkit;
    oToolkit := nil;
  end;

  bFormActive := FALSE;
  frmAddNomWizard := nil;
end;


procedure TfrmAddNomWizard.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  DoTidyUp;
end;

procedure TfrmAddNomWizard.ChangeAutoMode(Sender: TObject);
begin
  lStartDate.enabled := rbDate.checked;
  edStartDate.enabled := lStartDate.enabled;
  lIncDays.enabled := lStartDate.enabled;
  edIncDays.enabled := lStartDate.enabled;
  cbDateKeepDate.enabled := lStartDate.enabled;
  lEndDate.enabled := lStartDate.enabled;
  edEndDate.enabled := lStartDate.enabled;

  lStartPY.enabled := not lStartDate.enabled;
  edStartPY.enabled := lStartPY.enabled;
  lIncPeriods.enabled := lStartPY.enabled;
  edIncPeriods.enabled := lStartPY.enabled;
  cbPYKeepDate.enabled := lStartPY.enabled;
  lEndPY.enabled := lStartPY.enabled;
  edEndPY.enabled := lStartPY.enabled;

  if cbPYKeepDate.enabled then cbPYKeepDate.Font.Color := Font.Color
  else cbPYKeepDate.Font.Color := clGrayText;
  cbPYKeepDate.Repaint;

  if cbDateKeepDate.enabled then cbDateKeepDate.Font.Color := Font.Color
  else cbDateKeepDate.Font.Color := clGrayText;
  cbDateKeepDate.Repaint;

end;

procedure TfrmAddNomWizard.TXTypeChange(Sender: TObject);
begin
  if rbPayment.Checked then TXType := ttPayment;
  if rbReceipt.Checked then TXType := ttReceipt;
  if rbTransfer.Checked then TXType := ttTransfer;
  if rbRecurring.Checked then TXType := ttRecurring;
  if rbStandard.Checked then TXType := ttStandard;
end;

procedure TfrmAddNomWizard.nbPagesPageChanged(Sender: TObject);
begin
  // Enable / Disable Fields for transafers
  lBankTo.Visible := TXType = ttTransfer;
  edBankTo.Visible := lBankTo.Visible;

  lBankToH.Visible := lBankTo.Visible;
  edBankToH.Visible := edBankTo.Visible;

  // Change bank account descriptions for transfers
  if TXType = ttTransfer then
  begin
    lBankAccount.Caption := 'Bank From :';
    aValidation[F_BANK_ACCOUNT].Description := 'Bank From';
  end else
  begin
    lBankAccount.Caption := 'Bank Account :';
    aValidation[F_BANK_ACCOUNT].Description := 'Bank Account';
  end;
  lBankAccountH.Caption := lBankAccount.Caption;

  // Copy Values from Bank Account page to header of nom lines page
  edBankAccountH.Text := edBankAccount.Text;
  edBankToH.Text := edBankTo.Text;
  edDateH.Date := edDate.Date;
  edReferenceH.Text := edReference.Text;
  cmbCurrencyH.ItemIndex := cmbCurrency.ItemIndex;
  edCurrencyRateH.Value := edCurrencyRate.Value;

  // Set Active control to the best control on the new page
  case nbPages.PageIndex of
    0: begin
      if rbPayment.Checked then ActiveControl := rbPayment;
      if rbReceipt.Checked then ActiveControl := rbReceipt;
      if rbTransfer.Checked then ActiveControl := rbTransfer;
      if rbRecurring.Checked then ActiveControl := rbRecurring;
      if rbStandard.Checked then ActiveControl := rbStandard;
    end;

    1: ActiveControl := edBankAccount;

    2: begin
      if rbDate.Checked then ActiveControl := rbDate
      else ActiveControl := rbPY;
    end;

    3: TfNomLine(lstLines[lstLines.Count-1]).FocusControlWithTag(1);
  end;{case}
end;

procedure TfrmAddNomWizard.edBankAccountExit(Sender: TObject);
var
  oGL : IGeneralLedger;
  iGLCode : integer;

  procedure UpdateGLDesc;
  begin{UpdateGLDesc}
    if oGL = nil then
    begin
      if (TWincontrol(Sender).Name = 'edBankAccount')
      then lBankAccountDesc.Caption := '';
      if (TWincontrol(Sender).Name = 'edBankTo')
      then lBankToDesc.Caption := '';
    end else
    begin
      if (TWincontrol(Sender).Name = 'edBankAccount')
      then lBankAccountDesc.Caption := oGL.glName;
      if (TWincontrol(Sender).Name = 'edBankTo')
      then lBankToDesc.Caption := oGL.glName;
    end;
  end;{UpdateGLDesc}

begin
  oGL := ValidateGLCode(TEdit(Sender));
  if oGL = nil then
  begin
    if (ActiveControl <> btnCancel) and (ActiveControl <> btnBack) then
    begin
      with TfrmTKPickList.CreateWith(self, oToolkit) do begin

        mlList.Columns[0].DataType := dtInteger;
        plType := plGLCode;
        iGLCode := StrToIntDef(TEdit(Sender).Text,0);

        if (iGLCode = 0) and (TEdit(Sender).Text <> '0') then
          begin
            sFind := TEdit(Sender).Text;
            iSearchCol := 1;
          end
        else begin
          sFind := mlList.FullNomKey(iGLCode);
          iSearchCol := 0;
        end;{if}
        mlList.Columns[1].IndexNo := 1;

    //    sFind := edGLCode.Text;
        if showmodal = mrOK then
        begin
          oGL := ctkDataSet.GetRecord as IGeneralLedger;
          TEdit(Sender).Text := IntToStr(oGL.glCode);
//          UpdateGLDesc;
{          if (TWincontrol(Sender).Name = 'edBankAccount')
          then lBankAccountDesc.Caption := oGL.glName;
          if (TWincontrol(Sender).Name = 'edBankTo')
          then lBankToDesc.Caption := oGL.glName;}
        end else
        begin

        end;{if}

        release;

        oGL := ValidateGLCode(TEdit(Sender));
        aValidation[TWincontrol(Sender).Tag].FieldOK := oGL <> nil;

      end;{with}
    end;{if}
  end;{if}

  // Update Description
  if (TWincontrol(Sender).Name = 'edBankAccount')
  then lBankAccountDesc.Caption := TEdit(Sender).Hint;
  if (TWincontrol(Sender).Name = 'edBankTo')
  then lBankToDesc.Caption := TEdit(Sender).Hint;
end;

procedure TfrmAddNomWizard.edCCExit(Sender: TObject);
var
  oCC : ICCDept;
begin
  oCC := ValidateCostCentre(TEdit(Sender));
  if oCC = nil then
  begin
//    if ActiveControl = edDept then
    if (ActiveControl <> btnCancel) and (ActiveControl <> btnBack) then
    begin
      with TfrmTKPickList.CreateWith(self, oToolkit) do begin
        plType := plCC;
        sFind := edCC.Text;
        iSearchCol := 0;
        mlList.Columns[1].IndexNo := 1;
        if showmodal = mrOK then
        begin
          oCC := ctkDataSet.GetRecord as ICCDept;
          edCC.Text := oCC.cdCode;
//          lCC.Caption := oCC.cdName;
        end else
        begin
//          lCC.Caption := '';
        end;{if}
        release;

        oCC := ValidateCostCentre(edCC);
      end;{with}
    end;{if}
  end;{if}

  aValidation[TWincontrol(Sender).Tag].FieldOK := oCC <> nil;
  lCC.Caption := edCC.Hint;
end;

procedure TfrmAddNomWizard.edDeptExit(Sender: TObject);
var
  oDept : ICCDept;
begin
  oDept := ValidateDepartment(TEdit(Sender));
  if oDept = nil then
  begin
    if (ActiveControl <> btnCancel) and (ActiveControl <> btnBack) then
    begin
      with TfrmTKPickList.CreateWith(self, oToolkit) do begin
        plType := plDept;
        sFind := edDept.Text;
        iSearchCol := 0;
        mlList.Columns[1].IndexNo := 1;
        if showmodal = mrOK then
        begin
          oDept := ctkDataSet.GetRecord as ICCDept;
          edDept.Text := oDept.cdCode;
//          lDept.Caption := oDept.cdName;
        end else
        begin
//          lDept.Caption := '';
        end;{if}
        release;

        oDept := ValidateDepartment(TEdit(Sender));
      end;{with}
    end;{if}
  end;{if}

  aValidation[TWincontrol(Sender).Tag].FieldOK := oDept <> nil;
  lDept.Caption := TEdit(Sender).Hint;
end;


Procedure TfrmAddNomWizard.TabToControl(bTabToNext : boolean);
var
  lstTabOrder : TList;

  Function FindTabControl(iStartPos, iEndPos : integer) : TWinControl;
  var
//      bActiveControlFound : boolean;
    iInc, iPos : integer;
  begin{FindTabControl}
    Result := nil;

    if iStartPos < iEndPos then iInc := 1
    else iInc := -1;

    iPos := iStartPos;
    While (iPos <> iEndPos) do
    begin
      if (TWinControl(lstTabOrder[iPos]).parent is TForm)
      and TWinControl(lstTabOrder[iPos]).TabStop then
      begin
        Result := TWinControl(lstTabOrder[iPos]);
        Exit;
      end;
      iPos := iPos + iInc;
    end;{while}
  end;{FindTabControl}

var
  iPos : integer;
  NewActiveControl : TWinControl;

begin{TabToControl}
  NewActiveControl := nil;
  lstTabOrder := TList.Create;
  GetTabOrderList(lstTabOrder);
  For iPos := 0 to lstTabOrder.Count -1
  do begin
    if TWinControl(lstTabOrder[iPos]).Name = 'sbLines' then
    begin
      if bTabToNext then
      begin
        // Find Next Tab Control
        NewActiveControl := FindTabControl(iPos+1, lstTabOrder.Count -1);
        if NewActiveControl = nil then NewActiveControl := FindTabControl(0, iPos-1);
      end else
      begin
        // Find Previous Tab Control
        NewActiveControl := FindTabControl(iPos-1, 0);
        if NewActiveControl = nil then NewActiveControl := FindTabControl(lstTabOrder.Count -1, iPos+1);
      end;{if}

      if NewActiveControl <> nil then
      begin
        ActiveControl := NewActiveControl;
        break;
      end;{if}

    end;{if}
  end;{for}
  lstTabOrder.Free;
end;{TabToControl}

Procedure TfrmAddNomWizard.MoveUpDownGrid(bUp : boolean);
var
  iCurrentLine : integer;
begin{MoveUpDownGrid}
  iCurrentLine := TWinControl(ActiveControl.Parent).Tag;
  if bUp then TfNomLine(lstLines[iCurrentLine-1]).FocusControlWithTag(ActiveControl.Tag)
  else TfNomLine(lstLines[iCurrentLine+1]).FocusControlWithTag(ActiveControl.Tag)
end;{MoveUpDownGrid}

procedure TfrmAddNomWizard.FormShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  if ActiveControl <> nil then
  begin

//Caption := TWinControl(ActiveControl).Name;

    case Msg.CharCode of

      // TAB pressed
      VK_TAB : begin
//        if (TWinControl(ActiveControl).name = 'edNetAmount') then
//        begin
      //    Showmessage('tab');
//          (ActiveControl.Parent as TfNomLine).Tabbed := TRUE;
//        end;{if}

        // Make sure the fram knows that the last control movement was a tab
        if (ActiveControl.Parent is TfNomLine)
        then (ActiveControl.Parent as TfNomLine).Tabbed := TRUE;
      end;

      // Return / Enter pressed
      VK_RETURN : begin
        if (ActiveControl is TButton) then
        begin
    //      // The 'Click' event does not appear to trigger on buttons when you press enter
    //      (ActiveControl as TButton).Click;
        end else
        begin
          // Replace Enter with Tab
          if ReplaceEntersForControl(ActiveControl)
          then PostMessage(Handle,wm_NextDlgCtl,0,0); // Tab to Next control
        end;{if}

        // Make sure the fram knows that the last control movement was a tab
        if (ActiveControl.Parent is TfNomLine)
        then (ActiveControl.Parent as TfNomLine).Tabbed := TRUE;
      end;

      // Up, Down, Left, Right pressed
      VK_LEFT..VK_DOWN : begin
        if (ActiveControl.Parent is TfNomLine) then
        begin
          case Msg.CharCode of
            VK_LEFT : (ActiveControl.Parent as TfNomLine).CursorLeft;

            VK_UP : begin
              if (ActiveControl is TCustomEdit) then
              begin
                if (ActiveControl.Parent as TfNomLine).Tag = 0 then
                begin
                  // First Line - Tab to previous control
                  TabToControl(FALSE);
                end else
                begin
                  // Go to edit field above current edit field
                  MoveUpDownGrid(TRUE);
                end;{if}
              end;{if}
            end;

            VK_RIGHT : (ActiveControl.Parent as TfNomLine).CursorRight;

            VK_DOWN : begin
              if (ActiveControl is TCustomEdit) then
              begin
                if (ActiveControl.Parent as TfNomLine).Tag = (lstLines.Count -1) then
                begin
                  // Last Line - Tab to next control
                  TabToControl(TRUE);
                end else
                begin
                  // Go to edit field below current edit field
                  MoveUpDownGrid(FALSE);
                end;{if}
              end;{if}
            end;
          end;{case}
        end else
        begin
{          if (ActiveControl = btnBack) and (Msg.CharCode in [VK_LEFT, VK_UP])
          or (ActiveControl = btnNext) and (nbPages.PageIndex = 0) and (Msg.CharCode in [VK_LEFT, VK_UP])
          or (ActiveControl = btnCancel) and (Msg.CharCode in [VK_RIGHT, VK_UP])
          then begin
            case nbPages.PageIndex of
              0: ActiveControl := rbPayment;
              1: ActiveControl := edBankAccount;
              2: ActiveControl := rbDate;
              3: ActiveControl := sbLines;
            end;{case}
{          end;{if}

          if (not (ActiveControl is TRadioButton))
          and (not (ActiveControl is TBorRadio))
          and (not (ActiveControl is TBorCheck))
          and (not ((ActiveControl is TComboBox){ and (Msg.CharCode in [VK_UP, VK_DOWN])}))
          and (not (ActiveControl is TButton))
          and (not (ActiveControl is TDateTimePicker))
          and (not ((ActiveControl is TEdit) and (Msg.CharCode in [VK_LEFT, VK_RIGHT])))
          and (not ((ActiveControl is TEditPeriod) and (Msg.CharCode in [VK_LEFT, VK_RIGHT])))
          then
          begin
            PostMessage(Handle,wm_NextDlgCtl,Ord(Msg.CharCode in [VK_LEFT, VK_UP]),0); // Tab to Next / Previous control
//            FillChar(Msg, SizeOf(Msg), #0);
          end;
        end;{if}
      end;
    end;{case}
  end;{if}
end;

////////////////////////
// EXPORTED FUNCTIONS //
////////////////////////
exports ShowAddNomWizard;

procedure TfrmAddNomWizard.cmbCurrencyChange(Sender: TObject);
begin
  if cmbCurrency.ItemIndex >= 0
  then edCurrencyRate.Value := TCurrencyInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).Rate;
end;

function TfrmAddNomWizard.edPYShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  Result:=PPr_Pr(EPr);
(*
    If oToolkit.SystemSetup.ssShowPeriodsAsMonths then
    begin
//      GenStr:=LJVar(MonthAry[Pr2Mnth(Period)],3);
      case ePr of
        1 : Result:='Jan';
        2 : Result:='Feb';
        3 : Result:='Mar';
        4 : Result:='Apr';
        5 : Result:='May';
        6 : Result:='Jun';
        7 : Result:='Jul';
        8 : Result:='Aug';
        9 : Result:='Sep';
        10 : Result:='Oct';
        11 : Result:='Nov';
        12 : Result:='Dec';
      end;
      edPY.ViewMask := '000/0000;0;'
    end else
    begin
//      GenStr:=SetN(Period)
      Result:= PadString(psLeft, IntToStr(EPr), '0', 2);
      edPY.ViewMask := '00/0000;0;';
    end;
*)
end;

function TfrmAddNomWizard.edPYConvDate(Sender: TObject;
  const IDate: String; const Date2Pr: Boolean): String;
begin
//  Result:=ConvInpPr(IDate,Date2Pr,@ExLocal);
end;

procedure TfrmAddNomWizard.edDateExit(Sender: TObject);
begin
//  If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
{  With I1PrYrF do
  Begin
    Date2Pr(TransDate,AcPr,AcYr,@ExLocal);
    InitPeriod(AcPr,AcYr,BOn,BOn);
  end;}
end;

initialization
  frmAddNomWizard := nil;


end.

