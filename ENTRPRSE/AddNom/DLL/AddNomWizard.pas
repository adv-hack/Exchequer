unit AddNomWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids, VirtualTrees, NomLine, EnterToTab,
  uExDatasets, TKPickList, ComCtrls, NumEdit, Mask, TEditVal, Enterprise01_TLB;

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
    rbPayment: TRadioButton;
    rbReceipt: TRadioButton;
    rbTransfer: TRadioButton;
    rbRecurring: TRadioButton;
    rbStandard: TRadioButton;
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
    rbDate: TRadioButton;
    rbPY: TRadioButton;
    lStartDate: TLabel;
    edStartDate: TDateTimePicker;
    edStartPY: TEditPeriod;
    lIncPeriods: TLabel;
    edIncPeriods: TNumEdit;
    lEndDate: TLabel;
    edEndDate: TDateTimePicker;
    lEndPY: TLabel;
    edEndPY: TEditPeriod;
    cbAutoCreate: TCheckBox;
    cbPYKeepDate: TCheckBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lIncDays: TLabel;
    edIncDays: TNumEdit;
    cbDateKeepDate: TCheckBox;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vstLinesFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
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
  private
    bChangeMessaging, bALT, bOK, bTabBackwards : boolean;
    bFormActive : boolean;
    lstLines : TList;
    slVATCodes : TStringList;
    OriginalAppMessage : TMessageEvent;
    TXType : TTXType;
    procedure AppMessage (var Msg: TMsg; var Handled: Boolean);
    procedure AddNewLine;
    procedure EnableDisable;
    procedure FrameAddNewLine(Sender: TObject);
    procedure DoTidyUp;
//    function WantChildKey(Child: TControl; var Message: TMessage): Boolean; override;
  public
    hNomDaybookHandle : HWnd;
  end;

var
  frmAddNomWizard: TfrmAddNomWizard;

implementation
uses
  AddNomPROC, KeyUtils, MiscUtil;

{$R *.dfm}

procedure TfrmAddNomWizard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DoTidyUp;
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
  Close;
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

begin
  bFormActive := FALSE;
  bChangeMessaging := TRUE;
  bTabBackwards := FALSE;
  bALT := FALSE;
  bOK := FALSE;
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

  lstLines := TList.Create;
  CreateVATCodeList;
  AddNewLine;

//  lbHandles.Items.Add('*' + IntToStr(Self.Handle));
end;

procedure TfrmAddNomWizard.vstLinesFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
//  vstLines.EditNode(vstLines.FocusedNode,vstLines.FocusedColumn);
end;

procedure TfrmAddNomWizard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  Procedure TabToControl(bTabToNext : boolean);
  var
    lstTabOrder : TList;

    Function FindTabControl(iStartPos, iEndPos : integer) : TWinControl;
    var
      bActiveControlFound : boolean;
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

  Procedure MoveUpDownGrid(bUp : boolean);
  var
    iCurrentLine : integer;
  begin{MoveUpDownGrid}
    iCurrentLine := TWinControl(ActiveControl.Parent).Tag;
    if bUp then TfNomLine(lstLines[iCurrentLine-1]).FocusControlWithTag(ActiveControl.Tag)
    else TfNomLine(lstLines[iCurrentLine+1]).FocusControlWithTag(ActiveControl.Tag)
  end;{MoveUpDownGrid}

begin
  case Key of
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
  end;{case}
end;

procedure TfrmAddNomWizard.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
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
*)
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

procedure TfrmAddNomWizard.FormActivate(Sender: TObject);
begin
  bFormActive := TRUE;
  if bChangeMessaging then
  begin
    OriginalAppMessage := Application.OnMessage;
    Application.OnMessage := AppMessage;
  end;
end;

procedure TfrmAddNomWizard.FormDeactivate(Sender: TObject);
begin
  bFormActive := FALSE;
  if bChangeMessaging
  then Application.OnMessage := OriginalAppMessage;
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

procedure TfrmAddNomWizard.DoTidyUp;
begin
  Application.OnMessage := OriginalAppMessage;
  bChangeMessaging := FALSE;

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
//  DoTidyUp;
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
  lBankTo.Visible := TXType = ttTransfer;
  edBankTo.Visible := lBankTo.Visible;

  if TXType = ttTransfer then lBankAccount.Caption := 'Bank From :'
  else lBankAccount.Caption := 'Bank Account :';
end;

procedure TfrmAddNomWizard.edBankAccountExit(Sender: TObject);
var
  oGL : IGeneralLedger;
  iGLCode : integer;
begin
  if ((TWincontrol(Sender).Name = 'edBankAccount') and (ActiveControl = edBankTo))
  or (ActiveControl = edDate) then
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
      if showmodal = mrOK then begin
        oGL := ctkDataSet.GetRecord as IGeneralLedger;
        TEdit(Sender).Text := IntToStr(oGL.glCode);
        if (TWincontrol(Sender).Name = 'edBankAccount')
        then lBankAccountDesc.Caption := oGL.glName;
        if (TWincontrol(Sender).Name = 'edBankTo')
        then lBankToDesc.Caption := oGL.glName;
      end;
      release;

    end;{with}
  end;{if}
end;

procedure TfrmAddNomWizard.edCCExit(Sender: TObject);
var
  oCC : ICCDept;
begin
  if ActiveControl = edDept then
  begin
    with TfrmTKPickList.CreateWith(self, oToolkit) do begin
      plType := plCC;
      sFind := edCC.Text;
      iSearchCol := 0;
      mlList.Columns[1].IndexNo := 1;
      if showmodal = mrOK then begin
        oCC := ctkDataSet.GetRecord as ICCDept;
        edCC.Text := oCC.cdCode;
      end;{if}
      release;
    end;{with}
  end;{if}
end;

procedure TfrmAddNomWizard.edDeptExit(Sender: TObject);
var
  oDept : ICCDept;
begin
  if ActiveControl = cmbCurrency then
  begin
    with TfrmTKPickList.CreateWith(self, oToolkit) do begin
      plType := plDept;
      sFind := edDept.Text;
      iSearchCol := 0;
      mlList.Columns[1].IndexNo := 1;
      if showmodal = mrOK then begin
        oDept := ctkDataSet.GetRecord as ICCDept;
        edDept.Text := oDept.cdCode;
      end;{if}
      release;
    end;{with}
  end;{if}
end;

end.

