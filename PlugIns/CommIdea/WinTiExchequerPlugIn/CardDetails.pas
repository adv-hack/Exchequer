unit CardDetails;

interface

uses
  CustAbsU, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Enterprise01_TLB, Dialogs, StrUtil, StdCtrls, ExtCtrls, AuthSORProc, MiscUtil,
  TEditVal, EnterToTab;

type
  TCardTypeInfo = Class
    CC : String3;
    Dept : String3;
    GLCode : integer;
  end;

  TfrmCardDetails = class(TForm)
    Label5: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    lAuthorise: TLabel;
    lCcy: TLabel;
    edAmount: TCurrencyEdit;
    panDetails: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lSecurityNo: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edExpiryDate: TEdit;
    edStartDate: TEdit;
    edCardNo: TEdit;
    edIssueNo: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    edSecurityNo: TEdit;
    edAddress1: TEdit;
    edAddress2: TEdit;
    edAddress3: TEdit;
    edAddress4: TEdit;
    edPostcode: TEdit;
    cmbCardType: TComboBox;
    Bevel3: TBevel;
    Button17: TButton;
    Button18: TButton;
    EnterToTab1: TEnterToTab;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
  private
    { Private declarations }
    procedure EnableDisable;
    procedure SetCardDetails(sAmount, sCardNo, sStartDate, sExpiryDate, sIssueNo, sCV2 : string);
  public
    rAmount : real;
    iCardType, iTXMode : integer;
    LEventData : TAbsEnterpriseSystem;
    sNote, sSRC, sAuthorisationCode : string;
  end;

var
  frmCardDetails: TfrmCardDetails;

implementation
uses
  CommideaInt, Inifiles, Authorise, GfxUtil, JPeg;

{$R *.dfm}

procedure TfrmCardDetails.Button1Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 1';
  SetCardDetails('1.00', '4929123123123', '', '1210', '', '');
end;

procedure TfrmCardDetails.Button2Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 2';
  SetCardDetails('2.02', '4000000000000002', '', '1210', '', '');
end;

procedure TfrmCardDetails.Button3Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 3';
  SetCardDetails('3.02', '4000000000000002', '', '1210', '', '');
end;

procedure TfrmCardDetails.Button4Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 4';
  SetCardDetails('4.00', '6767051323183400359', '', '1210', '0', '');
end;

procedure TfrmCardDetails.Button5Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 5';
  SetCardDetails('5.00', '6759820000000019', '1201', '1210', '', '');
end;

procedure TfrmCardDetails.Button6Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 6';
  SetCardDetails('6.00', '5301250070000191', '', '1210', '', '');
end;

procedure TfrmCardDetails.Button7Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 7';
  SetCardDetails('7.00', '6767051323183400359', '', '1210', '1', '');
end;

procedure TfrmCardDetails.Button8Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 8';
  SetCardDetails('8.00', '4917480000000008', '', '1210', '', '');
end;

procedure TfrmCardDetails.Button9Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 9';
  SetCardDetails('9.05', '4929321321321', '', '1210', '', '');
end;

procedure TfrmCardDetails.Button10Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 10';
  SetCardDetails('10.00', '5301250070000191', '', '1210', '', '');
end;

procedure TfrmCardDetails.Button11Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 11';
  SetCardDetails('-11.00', '4012001038488884', '', '1210', '', '');
end;

procedure TfrmCardDetails.Button12Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 12';
  SetCardDetails('-12.00', '5453010000074468', '', '1210', '', '');
end;

procedure TfrmCardDetails.Button13Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 13';
  SetCardDetails('-13.00', '4012001037141112', '', '1210', '', '');
end;

procedure TfrmCardDetails.Button14Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 15';
  SetCardDetails('120.00', '4539790008', '', '1210', '', '');
end;

procedure TfrmCardDetails.Button15Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 16';
  SetCardDetails('125.00', '4000000000000006', '', '1210', '', '');
end;

procedure TfrmCardDetails.Button16Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 21';
  SetCardDetails('150.00', '5301250070000191', '', '1210', '', '000');
end;

procedure TfrmCardDetails.btnOKClick(Sender: TObject);

  function CreateSRC : string;
  var
    oSRC : ITransaction;
    iResult : integer;
    CardTypeInfo : TCardTypeInfo;
  begin{CreateSRC}
    oSRC := oToolkit.Transaction.Add(dtSRC);

    with oSRC do
    begin
      thAcCode := LEventData.Transaction.thAcCode;
      ImportDefaults;
      thYourRef := LEventData.Transaction.thOurRef;
      thNetValue := StrToFloatDef(edAmount.Text, 0);
      thCurrency := SetupRec.SterlingCcy;

      if iTXMode = AM_REFUND
      then thNetValue := -thNetValue;

      with thLines.Add as ITransactionLine2 do
      begin
        tlPayment := True;
        tlStockCode := sAuthorisationCode;
        tlNetValue := thNetValue;

        if iTXMode = AM_REFUND then
        begin
          // Refunds
          tlGLCode := SetupRec.SalesLineGLCode;
          tlCostCentre := SetupRec.SalesLineCC;
          tlDepartment := SetupRec.SalesLineDept;
        end else
        begin
          // Payments
          CardTypeInfo := TCardTypeInfo(cmbCardType.Items.Objects[cmbCardType.ItemIndex]);
          tlGLCode := CardTypeInfo.GLCode;
          tlCostCentre := CardTypeInfo.CC;
          tlDepartment := CardTypeInfo.Dept;
        end;{if}

        Save;
      end;{with}

      iResult := Save(True);

      if iResult = 0 then
      begin
        Result := thOurRef;
        iResult := oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex(thOurRef));
        if iResult = 0 then
        begin
          AddNote(oToolkit.Transaction, LEventData.UserName, TimeToScreenTime(Time)
          + ' ' + LEventData.Transaction.thOurRef + ' ' + sAuthorisationCode + ' : '
          + MoneyToStr(thNetValue));
        end;{if}
      end else
      begin
        ShowMessage('Unable to store Sales Receipt' + #13#13
        + 'Error ' + IntToStr(iResult) + ' : ' + QuotedStr(oToolkit.LastErrorString));
      end;{if}

    end;{with}

    oSRC := nil;
  end;{CreateSRC}

var
  iModalResult : integer;

begin
  if btnOK.Enabled then
  begin
    btnOK.Enabled := FALSE; {.005} // To stop them from double clicking
    btnOK.Refresh;
    case iTXMode of
      AM_PAYMENT, AM_REFUND : begin
        btnOK.Enabled := FALSE;
        btnCancel.Enabled := FALSE;

        frmAuthorise := TfrmAuthorise.Create(self);
        with frmAuthorise do
        begin
          try
            sCardSwipe := RemoveAllChars(edCardNo.Text,' ') + '/'
            +  RemoveAllChars(Trim(edStartDate.Text), '/') + '/'
            +  RemoveAllChars(Trim(edExpiryDate.Text), '/') + '/'
            +  Trim(edIssueNo.Text) + '/'
            +  Trim(edSecurityNo.Text); //CV2

            rOS := StrToFloatDef(edAmount.Text, 0);
            if iTXMode = AM_REFUND then rOS := -rOS;

            {.004}
            sLAuthCode := 'T_' + LEventdata.Transaction.thOurRef; // We set this to the OurRef of the transation. This is used for the filename in the new RTI system.

            ShowModal;

            case iResult of
              CR_OK : begin
                sNote := '';
                sAuthorisationCode := sLAuthCode;
                rAmount := rOS;
                sSRC := CreateSRC;
                iModalResult := mrOK;
              end;

              CR_REFERRED : sNote := 'RTI : Card referred, and refused.';
              CR_DECLINED : sNote := 'RTI : Card declined, please try another card.';
              CR_REFUSED : sNote := 'RTI : Card refused by operator.';

              else begin
                if sError = '' then sNote := 'RTI : Unknown Error'
                else sNote := 'RTI Error : ' + sError;
              end;
            end;{case}

            if (sNote <> '') then iModalResult := mrCancel;

          finally
            Release;
          end;{try}
        end;{with}

        ModalResult := iModalResult;
      end;

      AM_UPFRONT : begin
        ModalResult := mrOK;
      end;
    end;{case}
    btnOK.Enabled := TRUE; {.005} // re-enable button
  end;{if}
end;

procedure TfrmCardDetails.FormCreate(Sender: TObject);
begin
  edAmount.DisplayFormat := '#########0.00';
  sAuthorisationCode := '';
  iCardType := 0;
  sNote := '';
end;

procedure TfrmCardDetails.FormDestroy(Sender: TObject);
begin
  ClearList(cmbCardType.Items);
end;

procedure TfrmCardDetails.EnableDisable;
begin
  btnOK.Enabled := (cmbCardType.ItemIndex >= 0) or (iTXMode = AM_REFUND);
end;

procedure TfrmCardDetails.FormShow(Sender: TObject);
var
  AuthSORINI : TInifile;
  slCardTypes : TStringList;
  CardTypeInfo : TCardTypeInfo;
  iPos : integer;
  sCardType : string;
begin
  cmbCardType.Enabled := iTXMode in [AM_PAYMENT, AM_UPFRONT];
  cmbCardType.Enabled := cmbCardType.Enabled;

  if cmbCardType.Enabled then
  begin
    AuthSORINI := TInifile.Create(LEventData.Setup.ssDataPath + INIFileName);
    slCardTypes := TStringList.Create;

    // Get Card Types
    AuthSORINI.ReadSectionValues('CardTypes', slCardTypes);
    For iPos := 0 to slCardTypes.Count-1 do
    begin
      sCardType := Trim(Copy(slCardTypes[iPos], Pos('=',slCardTypes[iPos])+1, 255));
      CardTypeInfo := TCardTypeInfo.Create;
      CardTypeInfo.GLCode := AuthSORINI.ReadInteger(sCardType, 'GLCode', 0);
      CardTypeInfo.CC := AuthSORINI.ReadString(sCardType, 'CC', '');
      CardTypeInfo.Dept := AuthSORINI.ReadString(sCardType, 'Dept', '');
      cmbCardType.Items.AddObject(sCardType, CardTypeInfo);
    end;{for}

    // select first item in combo
    if (cmbCardType.Items.Count > iCardType)
    then  cmbCardType.ItemIndex := iCardType;

    slCardTypes.Free;
    AuthSORINI.Free;
  end;

  if iTXMode = AM_REFUND then edSecurityNo.Text := '';
  edSecurityNo.enabled := iTXMode in [AM_PAYMENT, AM_UPFRONT];
  lSecurityNo.enabled := edSecurityNo.enabled;

  EnableDisable;
end;

procedure TfrmCardDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  ClearList(cmbCardType.Items);
end;

procedure TfrmCardDetails.SetCardDetails(sAmount, sCardNo, sStartDate, sExpiryDate, sIssueNo, sCV2 : string);
begin
  edAmount.Text := sAmount;
  edCardNo.Text := sCardNo;
  edStartDate.Text := sStartDate;
  edExpiryDate.Text := sExpiryDate;
  edIssueNo.Text := sIssueNo;
  edSecurityNo.text := sCV2;

  if iTXMode = AM_REFUND then edSecurityNo.Text := '';
end;

procedure TfrmCardDetails.Button17Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 22';
  SetCardDetails('155.00', '4000000000000002', '', '1210', '', '999');
end;

procedure TfrmCardDetails.Button18Click(Sender: TObject);
begin
  lAuthorise.Caption := 'Test 12 #2 from Mark';
  SetCardDetails('105.00', '6759820000000019', '1201', '1206', '1', '');
end;

end.
