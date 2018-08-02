unit HandlerU;

{ nfrewer440 15:19 19/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

uses
  CustWinU, CustAbsU, UDPInt;

// Following functions required to be Exported by Enterprise

  procedure InitCustomHandler(var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
  procedure TermCustomHandler; Export;
  procedure ExecCustomHandler(const EventData : TAbsEnterpriseSystem); Export;

//  procedure LocalMessageDlg(sMessage : string);

implementation

uses
  Forms, APIUtil, MenuProc, Dialogs, SysUtils, ChainU, Classes, PISecure
  , PIMisc, EntLicence, Windows, ExchequerRelease;

var
  bHookEnabled : boolean;

const
  OPEN_INITIAL_COMPANY = 10;
  OPEN_NEW_COMPANY = 9;
  CLOSE_COMPANY = 8;

  EventDisabled = 0;
  EventEnabled  = 1;

//------------------------------------------------------------------------------

procedure InitCustomHandler(var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
// Called by Enterprise to initialise the Customisation
type
  THookPointRec = record
    WindowID : integer;
    HandlerID : integer;
  end;
const
  sPlugInName = 'Exchequer User-Defined Periods Plug-In';
  {$IFDEF EX600}
    // CA 09/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
    sVersionNo = '030';
//    sVersionNo = 'v6.00.028';
  {$ELSE}
    sVersionNo = 'v5.71.028';
  {$ENDIF}
  NO_OF_HOOK_POINTS = 5;
var
  slAboutText : TStringList;
  iEID : byte;
  iHook, iPos : integer;
  aHookPoints : array [1..NO_OF_HOOK_POINTS] of THookPointRec;
begin
  CustomOn := True;

  if EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct] then
  begin
    // Always Enabled for Lite
    bHookEnabled := TRUE;
  end else
  begin
    //Check Plug-In Security
    bHookEnabled := PICheckSecurity('EXCHPERIOD000005', 'SfSAh4g2GdYS4bgS', sPlugInName
    , '', stSystemOnly, ptDLL, DLLChain.ModuleName);
  end;{if}

  if bHookEnabled then begin
{    PeriodCalc := TPeriodCalc.Create;
    PeriodCalc.EntMessageDlg := LocalMessageDlg;

    if PeriodCalc.UsePlugIn then begin}
    with CustomHandlers do begin

      if not (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct])  then
      begin
        { Set About Message }
        slAboutText := TStringList.Create;
        PIMakeAboutText(sPlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
        for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
        slAboutText.Free;
      end;{if}

      // OPEN_INITIAL_COMPANY
      aHookPoints[1].WindowID := wiSystemOps;
      aHookPoints[1].HandlerID := OPEN_INITIAL_COMPANY;

      // OPEN_NEW_COMPANY
      aHookPoints[2].WindowID := wiSystemOps;
      aHookPoints[2].HandlerID := OPEN_NEW_COMPANY;

      // CLOSE_COMPANY
      aHookPoints[3].WindowID := wiSystemOps;
      aHookPoints[3].HandlerID := CLOSE_COMPANY;

      //
//      aHookPoints[4].WindowID := wiTransaction;
//      aHookPoints[4].HandlerID := 8;

      //
      aHookPoints[4].WindowID := wiTransaction;
      aHookPoints[4].HandlerID := 80;

      aHookPoints[5].WindowID := wiTransaction;
      aHookPoints[5].HandlerID := 81;


      // Enable Hooks
      For iHook := 1 to NO_OF_HOOK_POINTS do begin
        SetHandlerStatus(aHookPoints[iHook].WindowID, aHookPoints[iHook].HandlerID, EventEnabled);
      end;{for}

//SetHandlerStatus(102000, 106, EventEnabled);

    end;{with}
{    end;{if}
  end;{if}

  // Call other Hook DLLs to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
end;

//------------------------------------------------------------------------------

procedure TermCustomHandler;
// Called by Enterprise to End the Customisation
begin
  // Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  if bHookEnabled then begin
{    PeriodCalc.EntMessageDlg := nil;
    PeriodCalc.Free;}
  end;{if}
end;

//------------------------------------------------------------------------------

procedure ExecCustomHandler(const EventData : TAbsEnterpriseSystem);
// Called by Enterprise whenever a Customised Event happen
{var
  PeriodCalc : TPeriodCalc;}
var
  iPeriod, iYear : byte;
  sDate : shortstring;

  Procedure AddUserOptions;
  var
    ErrMsg, Capt : ANSIString;
  begin{AddUserOptions}
    Try
      { Create object containing menu event handlers }
      EntMenuObj := TEntMenuObj.Create;

      With EntMenuObj Do Begin
        { Take local copy of Enterprise handles }
        EnterpriseMenu := gEntInfo.EntMenus;
        hNewMenu := gEntInfo.NewMenu;

        { create tools menu }
        CreateRunAdminOption;
//        AddToolsOptions;
//        AddUserTools;

      End; { With }
    Except
      { handle any exceptions }
      On Ex:Exception Do Begin
        ErrMsg := 'The following error occured in the Menu Customisation:' + #10#13#10#13 + '''' + Ex.Message + '''.';
        Capt := 'Error in ' + DLLChain.ModuleName + '.DLL';
        Application.MessageBox (PCHAR(ErrMsg),
                                PCHAR(Capt),
                                (MB_OK Or MB_ICONSTOP));
      End; { On }
    End;{except}
  end;{AddUserOptions}

  procedure GetCurrentCompanyCode;
  var
    iPos : integer;
  begin{GetCurrentCompanyCode}
    CurrentCompanyRec.Code := '';
    For iPos := 0 to slCompanies.Count-1 do begin
      if UpperCase(WinGetShortPathName(Trim(TCompanyInfo(slCompanies.Objects[iPos]).CompanyRec.Path)))
      = UpperCase(WinGetShortPathName(Trim(EventData.Setup.ssDataPath)))
      then begin
        CurrentCompanyRec := TCompanyInfo(slCompanies.Objects[iPos]).CompanyRec;
        break;
      end;{if}
    end;{for}
  end;{GetCurrentCompanyCode}

begin
  if bHookEnabled then begin
    try
      { Handle Hook Events here }
      With EventData Do Begin
        // A 'Hook Event' has occurred
        Case WinId Of
          // System Operation hook points
          wiSystemOps : begin
            case HandlerId of
              OPEN_INITIAL_COMPANY, OPEN_NEW_COMPANY : begin

                InitToolkit(Setup.ssDataPath);
                GetCurrentCompanyCode;
                AddUserOptions;

//                GetCurrentUserName;

//                RWMenuManager.MoveReportWriterOptions;

//                AddUserOptions;

//                RWMenuManager.mmDataPath := Setup.ssDataPath;

//                RWMenuManager.mmVRWLicenced := not ((oToolkit.SystemSetup.ssReleaseCodes
//                as ISystemSetupReleaseCodes2).rcVisualReportWriter = rcDisabled); // VRW released

//                RWMenuManager.mmRWLicenced := not ((oToolkit.SystemSetup.ssReleaseCodes
//                as ISystemSetupReleaseCodes2).rcReportWriter = rcDisabled); // RW released

//                RWMenuManager.mmVRWAvailable := RWMenuManager.mmVRWLicenced // VRW released
//                and ((UserProfile.upSecurityFlags[193] <> 0)
//                or (UpperCase(trim(UserProfile.upUserId)) = 'SYSTEM'));  // User level Access to Report Writer

//                RWMenuManager.mmUserId := UserProfile.upUserId;
//                RWMenuManager.SetupMenus;

                If Assigned (oToolkit) then oToolkit.CloseToolkit;
                oToolkit := NIL;
              end;

              CLOSE_COMPANY : begin
//                CloseFiles;

//                  RWMenuManager.RemoveMenus;
//                  RWMenuManager.mmDataPath := '';
//                  RWMenuManager.mmUserId := '';

//                oSettings.Free;
              end;
            end;{case}
          end;

          EnterpriseBase + 2000 : begin
            case HandlerId of

              {8,} 80 : begin

                if GetUDPeriodYear(Setup.ssDataPath, Transaction.thTransDate, iPeriod, iYear) then
                begin
                  Transaction.thPeriod := iPeriod;
                  Transaction.thYear := iYear;
                end;{if}


      (*          PeriodCalc := TPeriodCalc.Create(Setup.ssDataPath);
                PeriodCalc.EntMessageDlg := LocalMessageDlg;

                with PeriodCalc do begin

                  EntVersion := 'v5.00';
                  LoggedInUser := UserName;
                  TransDate := Transaction.thTransDate;

                  if PeriodCalc.UsePlugIn then begin
                    if ConvertDateToPeriod then begin
                      Transaction.thPeriod := Period;
                      Transaction.thYear := Year;
                    end;{if}
                  end;{if}

                end;{with}

                PeriodCalc.EntMessageDlg := nil;
                PeriodCalc.Free;*)
              end;

              81 : begin
                //If TX is an auto TX then set the date to the first date in the period

                if Copy(EventData.Transaction.thOurRef,9,1) = 'A' then
                begin
                  // it is an auto TX
                  if GetDateFromUDPY(Setup.ssDataPath, sDate, Transaction.thPeriod, Transaction.thYear) then
                  begin
                    Transaction.thTransDate := sDate;
                  end;{if}
                end;{if}

{                if GetUDPeriodYear(Setup.ssDataPath, Transaction.thTransDate, iPeriod, iYear) then
                begin
                  Transaction.thPeriod := iPeriod;
                  Transaction.thYear := iYear;
                end;{if}
              end;


  {            106 : begin
                showmessage(Transaction.thOurRef);
              end;}
            end;{case}
          end;

        end;{case}
      end;{with}
    except
      on Ex:Exception Do
        MessageDlg ('An error occurred processing the period hook:' + #13#10 +
          Ex.Message, mtError, [mbOk], 0);
    end; // except
  end;{if}

  // Pass onto other Hook DLL's
  DLLChain.ExecCustomHandler(EventData);
end;

//------------------------------------------------------------------------------
{
procedure LocalMessageDlg(sMessage : string);
begin
  MessageDlg(sMessage,mtError,[mbOK],0);
end;
}

end.
