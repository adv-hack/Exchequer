unit Login;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, APIUtil, UseDLLU, Inifiles, TXHead, IAeverButton,
  OoMisc, AdPort, DLLInt, GlobType, RunWarn, StrUtil, oMCMSec, FileUtil,
  VarRec2U, VarConst, LicRec, EntLic, EPOSCnst, DLLInc, CustomFieldsIntf;

const
  MAX_NO_COMPANIES = 40;

type

  TCompanies = Array[1..MAX_NO_COMPANIES] of TCompanyType;
  PCompanies = ^TCompanies;

  TCompanyInfo = Class
    CompanyRec : TCompanyType;
  end;

  TFrmLogin = class(TForm)
    cmbCompany: TComboBox;
    edUserName: TEdit;
    edPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Shape1: TShape;
    btnOK: TIAeverButton;
    btnCancel: TIAeverButton;
    lCopyright: TLabel;
    lUserCount: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPasswordExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edUserNameExit(Sender: TObject);
  private
    bRelogin, bConfirmExit, bDone, bReshow : boolean;
    MCMSecurity : TMCMSecurity;
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    procedure AbortTCM;
    procedure CheckLogin(bShowMessages : boolean);
//    function OverrideTKIniFile : boolean;
  public
    { Public declarations }
    constructor Create(Sender: TComponent; ReLogin : Boolean);
  end;

var
  FrmLogin: TFrmLogin;

  FUNCTION EX_GETCOMPANYID : LongInt; STDCALL; EXTERNAL 'ENTDLL32.DLL' INDEX 156;


implementation
uses
{$IFDEF TCCU}  // Trade Counter Customisation
  CustIntU,
{$ENDIF}
  PIAboutF, EPOSKey, TKUtil, EPOSProc, GlobVar, BtrvU2, BTSupU1, EPOSComn, ValCfg,
  BackGrnd, BTSupU2, TillName, GfxUtil, LicUtil, EntLicence, CentData;

{$R *.DFM}

Procedure TFrmLogin.WMSysCommand(Var Message  :  TMessage);
Var
  I : SmallInt;
begin
  With Message do begin
    Case WParam of
      CM_DisplayAbout : Begin
        With TfrmAbout.Create(Self) Do begin
          Try
            {$IFDEF TCCU}  // Trade Counter Customisation

            // Add the Plug-Ins into the About dialog
              if (TradeCustomisation.PlugInCount > 0) Then
              begin
                for I := 0 To Pred(TradeCustomisation.PlugInCount) Do
                begin
                  AddPlugIn(TradeCustomisation.PlugIns[I]);
                end;{for}
              end;{if}
            {$ENDIF}
            ShowModal;
          Finally
            Free;
          End;{try}
        End;{with}
      end;
    End; { Case }
  end;

  Inherited;
end;

procedure TFrmLogin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (ModalResult = mrCancel) and bConfirmExit and (not bRelogin) then begin
    CanClose := MyMsgBox('This will exit the Trade Counter System.' + #13 + #13 + 'Are you sure you want to do this ?'
    ,mtConfirmation,[mbYes,mbNo],mbNo,'Exit System') = mrYes;
  end;{if}
end;

constructor TFrmLogin.Create(Sender: TComponent; ReLogin : Boolean);
var
  sWinUserName : string;
  sKey : Str255;
  iPos, iStatus : smallint;
  SysMenuH       : HWnd;
  oCentTillInfo : TCentralTillInfo;

  procedure OpenTK;
  var
    asCompPath : ANSIString;

  begin{OpenTK}

    asCompPath := Trim(CurrCompanyRec.CompPath);
    sCurrCompName := Trim(CurrCompanyRec.CompName);
    sCurrCompPath := asCompPath;

    OpenLayawayFiles(FALSE);

    iStatus := SetToolkitPath(PChar(asCompPath));

    //GS 16/11/2011 ABSEXCH-12082: as we are using the new cusom fields settings object
    //outside of enter1.exe, we need to set the data path before it can be used
    SetCustomFieldsPath(asCompPath);

    if iStatus = 0 then
      begin

       {set multicurrency dependant on what files exist}
        if FileExists(sCurrCompPath + '\DEFMC044.SYS') then
          begin
            bMultiCurr := TRUE;
          end
        else begin
          if FileExists(sCurrCompPath + '\DEFPF044.SYS') then
            begin
              bMultiCurr := FALSE;
            end
          else begin
            {neither file exists : there is something wrong}
            MsgBox('Neither of the files DEFMC044.SYS or DEFPF044.SYS exist in the directory : '
            + sCurrCompPath + '.' + #13 + #13 + 'This is not a valid exchequer system path.'
            ,mtError,[mbOk],mbOK,'Currency Detection Error');
            iStatus := -1;
          end;{if}
        end;{if}

        if iStatus = 0 then begin
          iStatus := Ex_InitDLLPath(Pchar(asCompPath),bMultiCurr);
          if iStatus = 0 then
            begin
              iStatus := Ex_InitDLL;
              if iStatus = 0 then
                begin
                  {Get Enterprise System Setup Record}
                  iStatus := Ex_GetSysData(@TKSysRec, SizeOf(TKSysRec));
                  ShowTKError('Ex_GetSysData', 91, iStatus);

                  // Get All Enterprise System Setup Information
                  if Open_File(F[SysF], asCompPath + FileNames[SysF], 0) = 0
                  then begin
                    Init_AllSys;
                    Close_File(F[SysF]);
                  end;{if}

                  {Overrides the toolkit ini file settings with what WE want}
                  if OverrideTKIniFile then begin

                    bToolkitOpen := TRUE;

                    {$IFDEF TCCU}  // Trade Counter Customisation
                      StartCustomisation;
                    {$ENDIF}

                  end
                else begin
                  MyMsgBox('The DLL Toolkit failed to open with the error code : ' + IntToStr(iStatus),mtError
                  ,[mbOK],mbOK,'Toolkit Open Error');
                  AbortTCM;
                end;{if}
              end
            else begin
              MyMsgBox('The DLL Toolkit path was not set with the error code : ' + IntToStr(iStatus),mtError
              ,[mbOK],mbOK,'Toolkit InitPath Error');
              AbortTCM;
            end;{if}
          end;{if}
        end
      else begin
        MyMsgBox('Unable to change the path of the DLL Toolkit - error code : ' + IntToStr(iStatus),mtError
        ,[mbOK],mbOK,'Toolkit Path Error');
        AbortTCM;
      end;{if}
    end;{if}
  end;{OpenTK}

begin{TFrmLogin.Create}

  screen.cursor := crHourglass;

  inherited create(sender);

  bRelogin := Relogin;

  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);

  lCopyright.Caption := GetCopyrightMessage;
  bConfirmExit := TRUE;
  bDone := FALSE;
  Caption := 'User Login';

  if bRelogin then
    begin
      lUserCount.Caption := '';
      cmbCompany.Style := csDropDown;
      cmbCompany.Text := CurrCompanyRec.CompName + ' (' + CurrCompanyRec.CompCode + ')';
    end
  else begin

    if (sCurrCompPath <> '') then begin
      sbsForm_DeInitialise;
//      Ex_CloseData;
    end;{if}

    {Open Btrieve}
    SetDrive := sCurrCompPath;
    iTillNo := GetTillNo;

    // NF: 27/04/2007 Removed as file is not SQL compatible
//    sBtrvFilename := GetTillFilename;
//    if sBtrvFilename = 'TRADEC00.DAT' then

    if bRunningFromCentral then
      begin
        With TfrmRunWarning.Create(application) do begin
          ShowModal;
          Release;
        end;{with}
        AbortTCM;
        exit;
      end
    else begin

      oCentTillInfo := TCentralTillInfo.Load(iTillNo);

      // NF: 27/04/2007 Removed as file is not SQL compatible
//      if (not OpenEPOSBtrv(EPOSSysF)) then AbortTCM
      if oCentTillInfo = nil then AbortTCM
      else begin

// For creating the layaway files !
//SetDrive := 's:\temp\neil\enttrade\';
//Open_System(LayHeadF, LaySerialF);

        // NF: 27/04/2007 Removed as file is not SQL compatible
        {Get System Setup record}
{        sKey := 'S';
        iStatus := Find_Rec(B_GetGEq, F[EposSysF], EposSysF, RecPtr[EposSysF]^, 0, sKey);
        Report_BError(EposSysF,iStatus);
        SetupRecord := EposSysRec.EposSetup;
        iOrigTXType := SetupRecord.TransactionType;}

        SetupRecord := oCentTillInfo.SetupRec;
        iOrigTXType := SetupRecord.TransactionType;
        oCentTillInfo.Unload;

        if Trim(SetupRecord.TillCompany) = '' then
          begin
            MyMsgBox('A company has not been setup for this till in the Administration Module.' + #13 + #13
            + 'Please run the Administration program and enter a valid value into this field.',mtError,[mbOK],mbOK,'Configuration Error');
            AbortTCM;
            Exit;
          end
        else begin
          if slCompanies.Count < 1 then FillCompanyList(slCompanies);
          cmbCompany.Items := slCompanies;
          For iPos := 0 to cmbCompany.Items.Count - 1 do begin
            if (TCompanyInfo(cmbCompany.Items.Objects[iPos]).CompanyRec.CompCode = SetupRecord.TillCompany)
            then begin
              cmbCompany.ItemIndex := iPos;
              Break;
            end;{if}
          end;{for}
          CurrCompanyRec := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec;
        end;{if}
      end;{if}

      MCMSecurity := TMCMSecurity.Create(ssTrade,iCompanyID,GetTCMEnterpriseDirectory);
      if iCompanyID > 0 then begin
        MCMSecurity.RemoveLoginRef;
      end;{if}

      lUserCount.Caption := '(' + IntToStr(MCMSecurity.msLicencesUsed) + '/'
      + IntToStr(MCMSecurity.msLicenceCount) + ')';

    end;{if}

    sWinUserName := WinGetUserName;
    if (EnterpriseLicence.elModules[modEnhSec] <> mrNone)
    and (cmbCompany.ItemIndex <> -1) 
    and DoesUserExist(sWinUserName, Trim(TCompanyInfo(cmbCompany.Items.Objects
    [cmbCompany.ItemIndex]).CompanyRec.CompPath), not bToolkitOpen) then
    begin
      edUserName.Text := sWinUserName;
//      ActiveControl := edPassword;
    end;

    if not bToolkitOpen then OpenTK;

  end;{if}

  SysMenuH:=GetSystemMenu(Handle,False);
  AppendMenu(SysMenuH,MF_SEPARATOR,0,'');
  AppendMenu(SysMenuH,MF_String,CM_DisplayAbout,'&About Trade Counter');

  screen.cursor := crDefault;
end;

procedure TFrmLogin.btnOKClick(Sender: TObject);
begin
  if btnOK.enabled then CheckLogin(TRUE);
end;

procedure TFrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  EPOSKey.GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  EPOSKey.GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
  LocalKey := Key;
  Key := 0;

  {Trap function keys}
  If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
    begin
      case LocalKey of
//        VK_F1 : Application.HelpCommand(HELP_Finder,0);
        VK_F9 : begin
          if btnOK.Enabled then begin
            btnOK.SetFocus;
            btnOKClick(btnOK);
          end;{if}
        end;

        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TFrmLogin.edPasswordExit(Sender: TObject);
begin
//PR: 12/10/2017 v2017 R2 ABSEXCH-18858 Don't validate until OK pressed to be
//be consistent with Exchequer login
end;

procedure TFrmLogin.CheckLogin(bShowMessages : boolean);
var
  iStatus : smallint;
  NewActiveControl : TEdit;
  sMessage : string;
  bEntPro, bTabs : boolean;
  oTillInfo : TTillInfo;

  function SanityCheck : boolean;
  var
    sMessage : string;
  begin

    with SetupRecord do begin
      {Check for Generic Error}
      if (not (AfterTender in [0,1]))
      or (bEntPro and (TillCurrency <> 0))
      or ((not bEntPro) and ((TillCurrency < 1) or (TillCurrency > 90)))
      or (InvoicePrinter = '') or (ReceiptPrinter = '') or (OrderPrinter = '')
      or (RecPrintPaper < 0) or (InvPrintPaper < 0) or (OrderPrintPaper < 0)
      or ((SetupRecord.CCDeptMode = 2) and (Trim(SetupRecord.DefCostCentre) = ''))
      or ((SetupRecord.CCDeptMode = 2) and (Trim(SetupRecord.DefDepartment) = '')) then
        begin
          {Show Error}
          MyMsgBox('An error has been detected in the Configuration of the Trade Counter Module.' + #13
          + 'Please run the Administration program to setup this workstation.',mtError,[mbOK],mbOK,'Configuration Error');
        end
      else begin
        {Check for specific Error}
        sMessage := '';

        ValidatePrinting(sMessage);
        if sMessage = '' then ValidateGLCodes(sMessage);
        if sMessage = '' then ValidateDefaults(sMessage);

        if sMessage <> '' then
          begin
            {Show Error}
            MyMsgBox('An error has been detected in the following field of the Trade Counter Module configuration : '
            + sMessage + #13 + #13
            + 'Please run the Administration program and enter a valid value into this field.',mtError,[mbOK],mbOK,'Configuration Error');
          end
        else begin
          {Check the currency of the GL Codes Inputted}
          if not CheckGLCurrency(sMessage) then begin
            MyMsgBox('An error has been detected in the Configuration of the Trade Counter Module.' + #13
            + 'The currency of the following GL code field does not match the Till Currency : ' + sMessage + #13 + #13
            + 'Please run the Administration program and enter a valid value into this field.',mtError,[mbOK],mbOK,'Configuration Error');
          end;{if}
        end;{if}

        Result := sMessage = '';
      end;{if}
    end;{with}
  end;{SanityCheck}

  procedure GetSecurityOptions;
  begin
    aAllowedTo[atRunTradeCounter] := CheckSecurity(331);
    aAllowedTo[atWriteOff] := CheckSecurity(332);
    aAllowedTo[atDoDiscounts] := CheckSecurity(333);
    aAllowedTo[atEnterNegValue] := CheckSecurity(334);
    aAllowedTo[atEnterNegQty] := CheckSecurity(335);
    aAllowedTo[atTakeDeposits] := CheckSecurity(336);
    aAllowedTo[atFindTransactions] := CheckSecurity(337);
    aAllowedTo[atCopyTransactions] := CheckSecurity(339);
    aAllowedTo[atLeaveSerialNosOutstanding] := CheckSecurity(244);
    aAllowedTo[atModifyVATRates] := CheckSecurity(341);
    aAllowedTo[atSetPriceToZero] := CheckSecurity(340);
    aAllowedTo[atSeeAllLayaways] := CheckSecurity(407);
    aAllowedTo[atDeleteLayaways] := CheckSecurity(408);
    aAllowedTo[atFindNonTCMTXs] := CheckSecurity(409);
    aAllowedTo[atNegativeStock] := CheckSecurity(182);
    aAllowedTo[atLeaveBinsOutstanding] := CheckSecurity(430);
    aAllowedTo[atSellAtLessThanCost] := CheckSecurity(309);
    aAllowedTo[atDiscountToExceedSale] := CheckSecurity(310);
    aAllowedTo[atSeeGP] := CheckSecurity(143);
  end;{GetSecurityOptions}

  procedure GetCurrencySymbol;
  var
    iStatus : smallint;
    CurrRec : ^TBatchCurrRec;
    sSymbol : str255;

{    function IsEnterprisePro : boolean;
    var
      LicenceInfo : EntLicenceRecType;
      LicencePath : shortstring;
    begin{IsEnterprisePro}
{      LicencePath := GetMultiCompDir + EntLicFName;
      if ReadEntLic(LicencePath, LicenceInfo) then Result := LicenceInfo.licEntCVer = 0
      else Result := FALSE;
    end;{IsEnterprisePro}

  begin
    if bEntPro then sCurrencySym := ''
    else begin
      new(CurrRec);
      iStatus := Ex_GetCurrency(CurrRec, SizeOf(CurrRec^), SetupRecord.TillCurrency);
      ShowTKError('Ex_GetCurrency', 90, iStatus);
      if (iStatus = 0) and (CurrRec.Name <> '') then sSymbol := CurrRec.ScreenSymb;
      dispose(CurrRec);
      sSymbol := TxLatePound(sSymbol, TRUE);
      sCurrencySym := sSymbol;
    end;
  end;{GetCurrencySymbol}


  function CheckPassword : boolean;
  {Check that the username and password are valid for enterprise}
  begin
    iStatus := EX_CHECKPASSWORD(PChar(edUserName.Text), PChar(edPassWord.Text));
    sMessage := '';
    Result := FALSE;
    //PR: 07/09/2017 v2017 R2 ABSEXCH-18858 Amend to deal with changed error codes
    //from toolkit
    case iStatus of
      30001 : begin
        sMessage := 'You have entered an invalid user name or password';
        NewActiveControl := edUserName;
      end;

      30003 : begin
        sMessage := 'This user account is suspended';
        NewActiveControl := edUserName;
      end;

      else begin
        if iStatus = 0 then
          begin
            {valid user name and password}
            //PR: 27/11/2017 ABSEXCH-19463 Get Exchequer UserID in case
            //this system is Windows Authentication
            sUserName := GetExchequerUserID(edUserName.Text);
            GetSecurityOptions;
            if AllowedTo(atRunTradeCounter) then begin
              {Login OK}
            end;{if}
            Result := TRUE;
          end
        else begin
          if bShowMessages then ShowTKError('EX_CHECKPASSWORD', 120, iStatus); {other error}
        end;{if}
      end;

    end;{case}
  end;{CheckPassword}

  procedure ShowMeTheMessage;
  begin
    if sMessage <> '' then begin
      {Login error}
      if bShowMessages then begin
        MyMsgBox(sMessage, mtError,[mbOK],mbOK,'Incorrect Login');
        ActiveControl := NewActiveControl;
        NewActiveControl.SelectAll;
      end;{if}
    end;{if}
  end;{if}

begin{CheckLogin}

  bEntPro := IsEnterprisePro;

  if bRelogin then
    begin
      if CheckPassword then
        begin
          ModalResult := mrOK;
          bDone := TRUE;
        end
      else ShowMeTheMessage;
    end
  else begin

    {OpenDLL}
    if not bDone then begin
      ActiveControl := btnOK;
      screen.cursor := crHourglass;

      iTillNo := GetTillNo;

      {Check that the username and password are valid for Enterprise}
      if CheckPassWord then begin
        {Login OK}

        if iCompanyID < 0 then iCompanyID := EX_GETCOMPANYID;
        MCMSecurity.msCompanyId := iCompanyID; {set CompanyID in Security Object}

        if MCMSecurity.AddLoginRef then begin

          sVATText := Ex_GetTaxWord;

          edUserName.Text := '';
          edPassWord.Text := '';

          GetCurrencySymbol;

          {Get company path from TRADE.INI}
          with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'TRADE.INI') do begin
            try
              sCentralTradePath := IncludeTrailingBackslash(ReadString('Settings'
              , 'CompanyPath', '')) + 'TRADE\';
            finally
              Free;
            end;{try}
          end;{with}

          {Get Till Name}
          oTillInfo := TTillInfo.Load(FALSE);
          if (iTillNo <= oTillInfo.Names.Count) then
            begin
              sTillName := oTillInfo.Names[iTillNo - 1];
              oTillInfo.Unload;

              if SanityCheck then begin

                {Initialise SBSFORM.DLL}
                With SystemInfo Do Begin
                  ExVersionNo      := 11;
                  MainForm         := frmBackground;
                  AppHandle        := Application;
                  ExDataPath       := sCurrCompPath;
                  ControllerHandle := Nil;
                  DefaultFont      := Nil;
                  DebugOpen        := False;
                End; { With }

                bTabs := TRUE;
                if (not sbsForm_Initialise(SystemInfo, bTabs)) then begin
                  MsgBox('Failed to load the form designer DLL.',mtError,[mbOK],mbOK
                  ,'Form Designer');
                end;{if}

                // Gets the Location Record
                GetLocationRec(SetupRecord.DefStockLocation);

                GetUserProfileRec(sUserName);

                if bReshow and (Application.MainForm <> nil) then Application.MainForm.Visible := TRUE;

                ModalResult := mrOK;
                bDone := TRUE;

              end;{if}
            end
          else begin
            MsgBox('Error Reading Position ' + IntToStr(iTillNo) + ' of ' + IntToStr(oTillInfo.Names.Count) +
            ' in the Till List.', mtError,[mbOK],mbOK,'Till List Error');
          end;{if}
        end;{if}
      end;{if}
      ShowMeTheMessage;
      screen.cursor := crDefault;
    end;{if}
  end;{if}

end;
(*
function TFrmLogin.OverrideTKIniFile : boolean;
var
  iStatus : smallint;

  function OverrideSetting(Setting, Value : PChar) : boolean;
  begin
    Result := TRUE;
    iStatus := Ex_OverrideIni(Setting, Value);
    if iStatus <> 0 then Result := FALSE;
    ShowTKError('Ex_OverrideIni', 129, iStatus);
  end;

begin
  Result := TRUE;

  {get setting from enterprise system setup}
  if TKSysRec.CalPrFromDate then
    begin
      if not OverrideSetting('Auto_Set_Period', 'ON') then Result := FALSE;
    end
  else begin
    if not OverrideSetting('Auto_Set_Period', 'OFF') then Result := FALSE;
  end;

  if Result and (not OverrideSetting('Auto_Set_Stock_Cost', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Deduct_BOM_Stock', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Deduct_MultiLoc_Stock', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Overwrite_Trans_No', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Use_Ex_Currency', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Allow_Trans_Edit', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Update_Account_Bal', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Update_Stock_Levels', 'ON')) then Result := FALSE;
  if Result and (not OverrideSetting('Ignore_JobCost_Validation', 'OFF')) then Result := FALSE;
  if Result and (not OverrideSetting('Overwrite_Note_Pad', 'OFF')) then Result := FALSE;
end;
*)
procedure TFrmLogin.FormShow(Sender: TObject);
begin
  bReshow := sCurrCompPath <> '';
  if (sCurrCompPath <> '') and (not bRelogin)
  and (Application.MainForm <> nil) then Application.MainForm.Visible := FALSE;
end;

procedure TFrmLogin.Button1Click(Sender: TObject);
Var
  DummyMessage  :  TMessage;
Begin
  FillChar(DummyMessage,Sizeof(DummyMessage),0);
  FrmBackground.DrawBackGround(DummyMessage);
end;

procedure TFrmLogin.AbortTCM;
begin
  bConfirmExit := FALSE;
  ModalResult := mrCancel;
  PostMessage(handle, WM_Close, 0, 0);
end;{AbortTCM}

procedure TFrmLogin.FormDestroy(Sender: TObject);
begin
  FreeAndNil(MCMSecurity);
end;

procedure TFrmLogin.edUserNameExit(Sender: TObject);
begin
//PR: 07/09/2017 v2017 R2 ABSEXCH-18858 Don't validate user in isolation
//from password
end;

initialization
  bToolkitOpen := FALSE;
  Application.Title := 'EPOS';

end.
