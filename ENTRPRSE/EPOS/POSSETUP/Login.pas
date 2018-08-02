unit Login;

{ nfrewer440 16:26 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, APIUtil, UseDLLU, Inifiles, SSetup;

type
  TFrmLogin = class(TForm)
    cmbCompany: TComboBox;
    edUserName: TEdit;
    edPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPasswordExit(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edUserNameExit(Sender: TObject);
  private
    procedure CheckLogin(bShowMessages : boolean);
    Procedure WMSysCommand(Var Message : TMessage); Message WM_SysCommand;
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation
uses
  EPOSKey, TKUtil, EPOSProc, GlobVar, BtrvU2, EPOSCnst, BTSupU1, EPOSComn, PSProc,
  MainF, CentData;

{$R *.DFM}

procedure TFrmLogin.FormCreate(Sender: TObject);
var
  iPos, iLockPos : integer;
  sWinUserName : string;
  oCentTillInfo : TCentralTillInfo;
begin
  {Get company path from TRADE.INI}
  with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'TRADE.INI') do begin
    try
      eBSetDrive := IncludeTrailingBackslash(ReadString('Settings', 'CompanyPath', ''));
      sCentralTradePath := eBSetDrive + 'TRADE\';
    finally
      Free;
    end;{try}
  end;{with}

  FillCompanyCombo(cmbCompany);
(*
//  if sBtrvFilename <> 'TRADEC00.DAT' then begin // NF: 27/04/2007 Removed as file is not SQL compatible

//    if OpenEPOSBtrv(EPOSSysF) then // NF: 27/04/2007 Removed as file is not SQL compatible
    if OpenEPOSBtrv(EPOSCentF) then
      begin
        {Get and lock record}
//        if GetEPOSRec(EPOSSysF, FALSE, iLockPos) = 0 then // NF: 27/04/2007 Removed as file is not SQL compatible
        if GetEPOSRec(EPOSCentF, FALSE, iLockPos) = 0 then
          begin
//            if EposSysRec.EposSetup.TillCompany = '' then // NF: 27/04/2007 Removed as file is not SQL compatible
            if EposCentRec.EposSetup.TillCompany = '' then
              begin
                // Select Main Company
                For iPos := 0 to cmbCompany.Items.Count - 1 do begin
                  if Trim(UpperCase(TCompanyInfo(cmbCompany.Items.Objects[iPos]).CompanyRec.CompPath))
                  = Trim(UpperCase(eBSetDrive))
                  then cmbCompany.ItemIndex := iPos;
                end;{for}
              end
            else begin
              // Select the Till's Company
              For iPos := 0 to cmbCompany.Items.Count - 1 do begin
//                if (TCompanyInfo(cmbCompany.Items.Objects[iPos]).CompanyRec.CompCode = EposSysRec.EposSetup.TillCompany) // NF: 27/04/2007 Removed as file is not SQL compatible
                if (TCompanyInfo(cmbCompany.Items.Objects[iPos]).CompanyRec.CompCode = EposCentRec.EposSetup.TillCompany)
                then cmbCompany.ItemIndex := iPos;
              end;{for}
            end;{if}

            // Only enable the combo if you are running from the Central Directory
//            cmbCompany.Enabled := sBtrvFilename = 'TRADEC00.DAT'; // NF: 27/04/2007 Removed as file is not SQL compatible
            cmbCompany.Enabled := bRunningFromCentral;

          end
        else PostMessage(Self.Handle,WM_Close,0,0);{on startup, close form on record lock}
      end
    else begin
      PostMessage(Self.Handle,WM_Close,0,0);{on startup, close form on cannot find btrieve file}
    end;{if}

//  end;{if}
*)

  oCentTillInfo := TCentralTillInfo.Load(iTillNo);
  if oCentTillInfo <> nil then
  begin
    if oCentTillInfo.SetupRec.TillCompany = '' then
      begin
        // Select Main Company
        For iPos := 0 to cmbCompany.Items.Count - 1 do begin
          if Trim(UpperCase(TCompanyInfo(cmbCompany.Items.Objects[iPos]).CompanyRec.CompPath))
          = Trim(UpperCase(eBSetDrive))
          then cmbCompany.ItemIndex := iPos;
        end;{for}
      end
    else begin
      // Select the Till's Company
      For iPos := 0 to cmbCompany.Items.Count - 1 do begin
        if (TCompanyInfo(cmbCompany.Items.Objects[iPos]).CompanyRec.CompCode = oCentTillInfo.SetupRec.TillCompany)
        then cmbCompany.ItemIndex := iPos;
      end;{for}
    end;{if}

    // Only enable the combo if you are running from the Central Directory
    cmbCompany.Enabled := bRunningFromCentral;

    oCentTillInfo.Unload;
  end
  else
  begin
    PostMessage(Self.Handle,WM_Close,0,0);{on startup, close form on record lock}
  end;{if}

  sWinUserName := WinGetUserName;
  if DoesUserExist(sWinUserName, Trim(TCompanyInfo(cmbCompany.Items.Objects
  [cmbCompany.ItemIndex]).CompanyRec.CompPath), TRUE) then edUserName.Text := sWinUserName;
end;

procedure TFrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
//  If (Key = VK_F1) and (Not (ssAlt In Shift)) then Application.HelpCommand(HELP_Finder,0);
end;

procedure TFrmLogin.edPasswordExit(Sender: TObject);
begin
//PR: 12/10/2017 v2017 R2 ABSEXCH-18858 Don't validate until OK pressed to
//be consistent with Exchequer login
end;

procedure TFrmLogin.CheckLogin(bShowMessages : boolean);
var
  iStatus : smallint;
  NewActiveControl : TEdit;
  sMessage : string;
  asCompPath : ANSIString;

  procedure GetSecurityOptions;
  begin{GetSecurityOptions}
    aAllowedTo[atAccessAdmin] := CheckSecurity(328);
    aAllowedTo[atSetupSystem] := CheckSecurity(329);
    aAllowedTo[atRunReports] := CheckSecurity(330);
    aAllowedTo[atSeeAllLayaways] := CheckSecurity(407);
    aAllowedTo[atDeleteLayaways] := CheckSecurity(408);
  end;{GetSecurityOptions}

begin{CheckLogin}
  sUserName := UpperCase(edUserName.Text);

  {OpenDLL}
  screen.cursor := crHourglass;
  asCompPath := Trim(TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec.CompPath);
  iStatus := SetToolkitPath(PChar(asCompPath));
  if iStatus = 0 then
    begin
      iStatus := Ex_InitDLL;
      if iStatus = 0 then
        begin
          if OverrideTKIniFile then
          begin
            {Check that the username and password are valid for enterprise}
            iStatus := EX_CHECKPASSWORD(PChar(edUserName.Text), PChar(edPassWord.Text));
            sMessage := '';
            //PR: 12/10/2017 v2017 R2 ABSEXCH-18858 Amend to deal with changed error codes
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
                    {Login OK}
                    //PR: 24/11/2017 ABSEXCH-19463 Get Exchequer UserID in case
                    //this system is Windows Authentication
                    sUserName := GetExchequerUserID(edUserName.Text);

                    GetSecurityOptions;

                    if AllowedTo(atAccessAdmin) then begin

                      sCurrCompPath := Trim(TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec.CompPath);

                      sGlobalCompanyPath := sCurrCompPath;
                      CurrCompanyRec := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec;
                      edUserName.Text := '';
                      edPassWord.Text := '';

                      {Set Btrieve File paths}
                      SetDrive := sCurrCompPath;
                      iTillNo := GetTillNo;

                      // NF: 27/04/2007 Removed as file is not SQL compatible
//                      sBtrvFilename := GetTillFilename; 
//                      if sBtrvFilename = 'TRADEC-1.DAT' then abort;

                      sVATText := Ex_GetTaxWord;

                      ModalResult := mrOK;
                    end;{if}
                  end
                else begin
                  if bShowMessages then ShowTKError('EX_CHECKPASSWORD', 120, iStatus); {other error}
                end;{if}
              end;
            end;{case}

            if sMessage <> '' then begin
              {Login error}
              if bShowMessages then begin
                MsgBox(sMessage, mtError,[mbOK],mbOK,'Incorrect Login');
                ActiveControl := NewActiveControl;
                NewActiveControl.SelectAll;
              end;{if}
            end;{if}
            Ex_CloseData;
          end;{if}
        end
      else begin
        if bShowMessages then MsgBox('The DLL Toolkit failed to open with the error code : ' + IntToStr(iStatus),mtError
        ,[mbOK],mbOK,'Toolkit Open Error');
      end;{if}
    end
  else begin
    if bShowMessages then MsgBox('Unable to change the path of the DLL Toolkit (' + asCompPath + ')' + #13#13 + 'Error code : ' + IntToStr(iStatus),mtError
    ,[mbOK],mbOK,'Toolkit Path Error');
  end;{if}
  screen.cursor := crDefault;
end;

procedure TFrmLogin.btnOKClick(Sender: TObject);
begin
  CheckLogin(TRUE);
end;

procedure TFrmLogin.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmLogin.edUserNameExit(Sender: TObject);
begin
//PR: 12/10/2017 v2017 R2 ABSEXCH-18858 Don't validate user in isolation
//from password
end;

Procedure TFrmLogin.WMSysCommand(Var Message : TMessage);
Var
  MsgText : ANSIString;
Begin // WMSysCommand
  If (Message.WParam = SC_MINIMIZE) Then
  Begin
    // This is needed to get the window to minimize to the task bar instead of the desktop
    Application.Minimize;
    Message.Result := 0;
  End // If (Message.WParam = SC_MINIMIZE)
  Else
    Inherited;
End; // WMSysCommand


initialization
  Application.Title := 'Epos Setup';

end.
