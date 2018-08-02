unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  DataModule, SQLUtils, CustWinU, CustAbsU, CCDeptU, Classes;

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem03); Export;
  Procedure LocalMessageDlg(const sMessage : string);

implementation

Uses
  APIUtil, BTFile, Dialogs, SysUtils, ChainU, PISecure, PIMisc, ExchequerRelease;

var
  bHookEnabled : boolean;

Const
  OPEN_INITIAL_COMPANY = 10;
  OPEN_NEW_COMPANY = 9;
  CLOSE_COMPANY = 8;

  EventDisabled = 0;
  EventEnabled  = 1;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
var
  iEID : byte;
  iPos : integer;
  slAboutText : TStringList;
begin
  CustomOn := True;

  //Check Plug-In Security
  bHookEnabled := PICheckSecurity('EXCHCCDEPT000006', 'd 6na0nF4Fqafdp1', sPlugInName
  , '', stSystemOnly, ptDLL, DLLChain.ModuleName);

  if bHookEnabled then begin

    With CustomHandlers Do Begin
      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(sPlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
      slAboutText.Free;

      { Define Handlers }
      for iEID := 18 to 24 do SetHandlerStatus(EnterpriseBase + 4000, iEID, EventEnabled);

      // open close company hooks
      SetHandlerStatus (EnterpriseBase + MiscBase + 2, OPEN_INITIAL_COMPANY, EventEnabled);
      SetHandlerStatus (EnterpriseBase + MiscBase + 2, OPEN_NEW_COMPANY, EventEnabled);
      SetHandlerStatus (EnterpriseBase + MiscBase + 2, CLOSE_COMPANY, EventEnabled);
    End; { With }

  end;{if}

  bSQL := UsingSQL;

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  // v6.30.141 - ABSEXCH-9495
  if Assigned(SQLDataModule) then
  begin
    SQLDataModule.Disconnect;
    SQLDataModule.Free;
    SQLDataModule := nil;
  end;{if}
  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem03);

  procedure GetCompanyCodeFromCustomisation;
  var
    bV63 : boolean;
  begin{GetCompanyCodeFromCustomisation}
    // v6.30.040 - In v6.3 we have access to the company code in the customisation object model
    bV63 := EventData.ClassVersion >= '6.3.048';
    if bV63
    then asCompanyCode := TAbsSetup7(EventData.Setup).ssCompanyCode
    else asCompanyCode := '';
  end;{GetCompanyCodeFromCustomisation}

var
  rTemp : real;
Begin
  { Handle Hook Events here }
  if bHookEnabled then begin

    with EventData do begin
      if Setup.ssUseCCDep then begin
        case WinId of
          {Before enterprise validates a transaction line}
          EnterpriseBase + 4000 : begin
//            if (HandlerID in [18..21,23,24]) then
            if (HandlerID in [18..24]) then
            begin
              with Transaction, thLines.thCurrentLine do
              begin
                ValidStatus := TRUE;
                BoResult := TRUE;
                if (AccessRights <> NotAvailable) then
                begin
                  rTemp := EntInvLTotal(TRUE,0);
//                    if (rTemp <> 0) then begin
                  if (rTemp <> 0) or (Transaction.thinvdoched in [cuPPY, cuSRC]) then
                  begin
                    BoResult := CCDeptValid(tlCostCentre, tlDepartment, tlVATCode, tlGLCode, Setup.ssDataPath, tlLineNo, LocalMessageDlg, bSQL);
                  end;{if}
                end;{if}
              end;{with}
            end
            else
            begin
//              if (HandlerID = 22) then begin
                ValidStatus := TRUE;
                BoResult := TRUE;
//              end;{if}
            end;{if}
          end;

          EnterpriseBase + MiscBase + 2 : begin
            case EventData.HandlerId of
              OPEN_NEW_COMPANY, OPEN_INITIAL_COMPANY : begin
                GetCompanyCodeFromCustomisation;
                asCompanyPath := EventData.Setup3.ssDataPath;
                if not OpenFiles(EventData.Setup3.ssDataPath, FALSE, bSQL) then
                begin
                  MsgBox('The call to OpenFiles(' + EventData.Setup3.ssDataPath
                  + ') in CCCustom.Dll Failed.', mtError, [mbOK], mbOK, 'CCCustom.Dll error')
                end else
                begin
                  if FileExists(EventData.Setup3.ssDataPath + CCDEPTINI)
                  then RunConversion(EventData.Setup3.ssDataPath);
                end;{if}
              end;

              CLOSE_COMPANY :
              begin
                CloseFiles;
                asCompanyCode := '';

                // v6.30.141 - ABSEXCH-9495
                if Assigned(SQLDataModule) then
                begin
                  SQLDataModule.Disconnect;
                  SQLDataModule.Free;
                  SQLDataModule := nil;
                end;{if}
              end;
            end;{case}
          end;

        end;{case}
      end;{if}
    end;{with}
  end;{if}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

{Callback Procedure used to show the error messages}
Procedure LocalMessageDlg(const sMessage : string);
begin
  MessageDlg(sMessage, mtWarning, [mbOK], 0);
end;

end.
