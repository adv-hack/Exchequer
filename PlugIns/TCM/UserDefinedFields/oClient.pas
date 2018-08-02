unit oClient;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  UDefProc, ComObj, ActiveX, EnterpriseTradePlugIn_TLB, StdVcl, Windows
  , EnterpriseTrade_TLB;

type
  PHWND = ^HWND;

  TUserDefinedField = class(TAutoObject, IuserDefinedField, ITradeClient)
  protected
    procedure OnConfigure(const Config: ITradeConfiguration); safecall;
    procedure OnStartup(const BaseData: ITradeConnectionPoint); safecall;
    procedure OnCustomEvent(const EventData: ITradeEventData); safecall;
    procedure OnCustomText(const CustomText: ITradeCustomText); safecall;
    procedure OnShutdown; safecall;
  private
    lBaseData: ITradeConnectionPoint;
    ExecuteTXPlugIn : TExecuteTXPlugIn;
    _OpenFiles : TOpenFiles;
    _CloseFiles : TCloseFiles;
    hUsrFDlgDll : THandle;
    iLineButton, iHeaderButton : integer;
  end;

  function EnumWndProc (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;

implementation

uses
  FileUtil, HeaderUDFs, LineUDFs, ComServ, Forms, Controls, StrUtil, APIUtil
  , SysUtils, Dialogs;

//var
//  DataPath : string;

{ TUserDefinedField }

procedure TUserDefinedField.OnConfigure(const Config: ITradeConfiguration);
var
  hAdminWin : HWnd;

  function FindWindow : boolean;
  var
    StartTime : TTime;
  begin
    {Find Admin window}
    hAdminWin := 0;
    StartTime := Now;
    Repeat
      EnumWindows(@EnumWndProc, Longint(@hAdminWin));
//      DebugToFile(IntToStr(hAdminWin) + ', ' + FloatToStr(Now) + ', ' + FloatToStr((StartTime + (30 * (1/86400)) )));
    Until (hAdminWin <> 0) or (Now - (StartTime + (30 * (1/86400)) ) > 0);

    {Pop-up Admin}
//    if hAdminWin <> 0 then begin
//      BringWindowToTop(hAdminWin); {Bring Fax Admin Window To Front}
//      PostMessage(hAdminWin,WM_FormStateMsg,SC_RESTORE,0); {Restore Window if minimized (message handled in faxadmin)}
//    end;{if}

    Result := (hAdminWin <> 0);
  end;{FindWindow}

begin{OnConfigure}
  RunApp(Config.cfEnterpriseDirectory + 'USERHADM.EXE /COMPPATH=' + Config.cfDataDirectory, FALSE);
  if FindWindow then lBaseData.Functions.entActivateClient(hAdminWin);
//  DataPath := Config.cfDataDirectory;
end;

procedure TUserDefinedField.OnCustomEvent(const EventData: ITradeEventData);
var
  frmHeaderUDFs : TFrmHeaderUDFs;
  frmLineUDFs : TfrmLineUDFs;
  sDataPath : string;
begin
  sDataPath := lBaseData.SystemSetup.ssTradeCounter.ssTill
  [lBaseData.SystemSetup.ssTradeCounter.ssCurrentTillNo].ssCompany.coPath;

  if (EventData.edWindowId = twiTransaction) and (EventData.edHandlerId = iHeaderButton)
  and Assigned(ExecuteTXPlugIn) and Assigned(_CloseFiles) and Assigned(_OpenFiles) then
  begin
    frmHeaderUDFs := TfrmHeaderUDFs.Create(application);
    try
      with frmHeaderUDFs, EventData.Transaction do begin
        oBaseData := lBaseData;
        oEventData := EventData;
        _ExecuteTXPlugIn := ExecuteTXPlugIn;
        lBaseData.Functions.entActivateClient(frmHeaderUDFs.Handle);
        edUserDef1.Text := thUserField1;
        edUserDef2.Text := thUserField2;
        edUserDef3.Text := thUserField3;

        _OpenFiles(sDataPath);
        if ShowModal = mrOK then begin
          thUserField1 := edUserDef1.Text;
          thUserField2 := edUserDef2.Text;
          thUserField3 := edUserDef3.Text;
        end;{if}
        _CloseFiles;

      end;
    finally
      frmHeaderUDFs.Release;
    end;{try}

    SetForegroundWindow(lBaseData.Functions.fnTradehWnd);
  end;{if}

  if (EventData.edWindowId = twiTransactionLine) and (EventData.edHandlerId = iLineButton)
  and Assigned(ExecuteTXPlugIn) and Assigned(_CloseFiles) and Assigned(_OpenFiles) then
  begin
    frmLineUDFs := TfrmLineUDFs.Create(application);
    try
      with frmLineUDFs, EventData.Transaction.thLines.thCurrentLine do begin
        oBaseData := lBaseData;
        oEventData := EventData;
        _ExecuteTXPlugIn := ExecuteTXPlugIn;
        lBaseData.Functions.entActivateClient(frmLineUDFs.Handle);
        edUserDef1.Text := tlUserField1;
        edUserDef2.Text := tlUserField2;
        edUserDef3.Text := tlUserField3;
        edUserDef4.Text := tlUserField4;

        _OpenFiles(sDataPath);
        if ShowModal = mrOK then begin
          tlUserField1 := edUserDef1.Text;
          tlUserField2 := edUserDef2.Text;
          tlUserField3 := edUserDef3.Text;
          tlUserField4 := edUserDef4.Text;
        end;{if}
        _CloseFiles;

      end;
    finally
      frmLineUDFs.Release;
    end;{try}

    SetForegroundWindow(lBaseData.Functions.fnTradehWnd);
  end;{if}
end;

procedure TUserDefinedField.OnCustomText(const CustomText: ITradeCustomText);
begin
  if ((CustomText.ctWindowId = twiTransaction) and (CustomText.ctTextId = iHeaderButton))
  or ((CustomText.ctWindowId = twiTransactionLine) and (CustomText.ctTextId = iLineButton))
  then CustomText.ctText := '&User Fields';
end;

procedure TUserDefinedField.OnShutdown;
begin
  FreeLibrary(hUsrFDlgDll);
  lBaseData := nil;
end;

procedure TUserDefinedField.OnStartup(const BaseData: ITradeConnectionPoint);
var
  asDLLPath : ANSIString;
begin
  lBaseData := BaseData;

  {Find DLL}
  asDLLPath := lBaseData.SystemSetup.ssEnterprise.ssMainCompanyDir + 'UsrFDlg.Dll';
  hUsrFDlgDll := LoadLibrary(PChar(asDLLPath));
  if hUsrFDlgDll > HInstance_Error then
  begin
    ExecuteTXPlugIn := GetProcAddress(hUsrFDlgDll, 'ExecuteTXPlugIn');
    _OpenFiles := GetProcAddress(hUsrFDlgDll, 'OpenFiles');
    _CloseFiles := GetProcAddress(hUsrFDlgDll, 'CloseFiles');
  end;

  if not Assigned(ExecuteTXPlugIn) then MsgBox('UsrField.exe Cannot find the function "ExecuteTXPlugIn" in ' + asDLLPath
  , mtError, [mbOK], mbOK, 'Error finding function ExecuteTXPlugIn');

  if not Assigned(_OpenFiles) then MsgBox('UsrField.exe Cannot find the function "OpenFiles" in '
  + asDLLPath, mtError, [mbOK], mbOK, 'Error finding function OpenFiles');

  if not Assigned(_CloseFiles) then MsgBox('UsrField.exe Cannot find the function "CloseFiles" in '
  + asDLLPath, mtError, [mbOK], mbOK, 'Error finding function CloseFiles');

  with lBaseData do begin
    lBaseData.piCustomisationSupport := 'v1.00/Config';
    lBaseData.piName := 'User Defined Field Plug-In';

    {$IFDEF EX600}
    // CA 10/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
      lBaseData.piVersion := 'v7.0.05.004';
//      lBaseData.piVersion := 'v6.00.003';
    {$ELSE}
      lBaseData.piVersion := 'v5.71.003';
    {$ENDIF}

    if (not Assigned(ExecuteTXPlugIn)) and (not Assigned(_OpenFiles)) and (not Assigned(_CloseFiles))
    then lBaseData.piVersion := lBaseData.piVersion + ' - Cannot find correct UsrFDlg.dll';
    lBaseData.piAuthor := 'Advanced Enterprise Software';
    lBaseData.piCopyright := GetCopyrightMessage;
    lBaseData.piSupport := 'Contact your Exchequer helpline number';

    if Assigned(ExecuteTXPlugIn) and Assigned(_OpenFiles) and Assigned(_CloseFiles) then
    begin
      // Figure out which custom button to use for header
      if lBaseData.piHookPoints[twiTransaction, hpTXHeadCustom1] in [thsEnabled, thsEnabledOther] then
      begin
        if lBaseData.piHookPoints[twiTransaction, hpTXHeadCustom2] in [thsEnabled, thsEnabledOther]
        then iHeaderButton := -1
        else iHeaderButton := hpTXHeadCustom2;
      end else
      begin
        iHeaderButton := hpTXHeadCustom1;
      end;{if}

      // Figure out which custom button to use for line
      if lBaseData.piHookPoints[twiTransactionLine, hpTXLineCustom1] in [thsEnabled, thsEnabledOther] then
      begin
        if lBaseData.piHookPoints[twiTransactionLine, hpTXLineCustom2] in [thsEnabled, thsEnabledOther]
        then iLineButton := -1
        else iLineButton := hpTXLineCustom2;
      end else
      begin
        iLineButton := hpTXLineCustom1;
      end;{if}

      // enable hooks & Custom text
      if iHeaderButton <> -1 then
      begin
        lBaseData.piHookPoints[twiTransaction, iHeaderButton] := thsEnabled;
        lBaseData.piCustomText[twiTransaction, iHeaderButton] := thsEnabled;
      end;{if}

      if iLineButton <> -1 then
      begin
        lBaseData.piHookPoints[twiTransactionLine, iLineButton] := thsEnabled;
        lBaseData.piCustomText[twiTransactionLine, iLineButton] := thsEnabled;
      end;{if}
    end;{if}
  end;{with}

end;

function EnumWndProc (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
{ Callback function to identify the Admin window }
var
  ClassName : string;
  Tag       : THandle;
begin
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (Trim(ClassName));

  if (AnsiCompareText (ClassName, 'TfrmUserDefList') = 0) then begin
    Tag := GetWindowLong (Hwnd, GWL_USERDATA);
    if (Tag = 0) then begin
      FoundWnd^ := Hwnd;
      Result := False;
    end;{if}
  end;{if}
end;

initialization
  TAutoObjectFactory.Create(ComServer, TUserDefinedField, Class_UserDefinedField,
    ciSingleInstance, tmApartment);
end.
