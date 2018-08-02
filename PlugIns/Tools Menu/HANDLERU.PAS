unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  Enterprise01_TLB, APIUtil, CustWinU, CustAbsU, uEntMenu, ToolProc, ToolBTFiles
  , DataModule, FileUtil, SQLUtils, EntLicence,
{$IFNDEF REMOVE_VRW}
  MenuManager,
{$ENDIF}
  uSettingsSQL;

const
  OPEN_INITIAL_COMPANY = 10;
  OPEN_NEW_COMPANY = 9;
  CLOSE_COMPANY = 8;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  ActiveX, Menus, Dialogs, Forms, Windows, SysUtils, ChainU, RepTreeIF, RptEngDll;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
type
  THookPointRec = record
    WindowID : integer;
    HandlerID : integer;
  end;
const
  NO_OF_HOOK_POINTS = 3;
var
  iEID : byte;
  iHook, iPos : integer;
  aHookPoints : array [1..NO_OF_HOOK_POINTS] of THookPointRec;
Begin
  CustomOn := True;

  CoInitialize(nil); // NF: 27/10/2005 This was put in to fix the crashing (216) when exiting Exchequer after opening a graph and when not using the sentimail plug-in. Phew !

  With TAbsCustomHandlers01(CustomHandlers) Do Begin

    // OPEN_INITIAL_COMPANY
    aHookPoints[1].WindowID := wiSystemOps;
    aHookPoints[1].HandlerID := OPEN_INITIAL_COMPANY;

    // OPEN_NEW_COMPANY
    aHookPoints[2].WindowID := wiSystemOps;
    aHookPoints[2].HandlerID := OPEN_NEW_COMPANY;

    // CLOSE_COMPANY
    aHookPoints[3].WindowID := wiSystemOps;
    aHookPoints[3].HandlerID := CLOSE_COMPANY;

    // Enable Hooks
    For iHook := 1 to NO_OF_HOOK_POINTS do begin
      SetHandlerStatus(aHookPoints[iHook].WindowID, aHookPoints[iHook].HandlerID, EventEnabled);
    end;{for}

  End; { With }

  asAppDir := GetEnterpriseDirectory;

  // CJS: 22/10/2007 - sMiscDirLocation was not being set. This caused problems
  //                   under the SQL Emulator.
  // CJS 2013-04-02 - ABSEXCH-14153 - path error on local drive in SQL edition -
  //                   this path is now set in ExecCustomHandler()
  // uSettingsSQL.sMiscDirLocation := asAppDir;

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);

  LongTimeFormat := 'hh:nn:ss.zzz';

  bSQL := UsingSQL;
  SQLDataModule := nil;

End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  oSettings.DisconnectADO;

  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);

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
        CreateToolsMenu;
        AddToolsOptions;
        AddUserTools;

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

  //v6.30.142
(*  procedure GetCurrentCompanyCode;
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
*)
  procedure GetCurrentCompanyCode;
  var
    iPos : integer;
  begin{GetCurrentCompanyCode}
//    CurrentCompanyRec.Code := '';
    asCompanyCode := '';
    For iPos := 0 to slCompanies.Count-1 do
    begin
      if UpperCase(WinGetShortPathName(Trim(TCompanyInfo(slCompanies.Objects[iPos]).CompanyRec.Path)))
      = UpperCase(WinGetShortPathName(Trim(asCompanyPath)))
      then begin
//        CurrentCompanyRec := TCompanyInfo(slCompanies.Objects[iPos]).CompanyRec;
        asCompanyCode := TCompanyInfo(slCompanies.Objects[iPos]).CompanyRec.Code;
        break;
      end;{if}
    end;{for}
  end;{GetCurrentCompanyCode}

  Procedure GetCurrentUserName;
  begin{GetCurrentUserName}
    sCurrentUserName := EventData.UserProfile.upUserId;

    if trim(sCurrentUserName) = '' then
    begin
      MsgBox('The user profile for the currently logged in user has not been initialised.' + #13#13
      + 'Due to this, you will no longer have access to the Visual Report Writer, or any user tools that have been specifically setup for your use.' + #13#13
      + 'To rectify this problem, you will need to edit and save the user profile record.' + #13#13
      + 'This is done from the menu option "Tools - Utilities - Passwords"'
      ,mtWarning,[mbOK], mbOK, 'User Profile Problem');
    end;

  end;{GetCurrentUserName}

Begin
  { Handle Hook Events here }
  With EventData Do Begin
    // A 'Hook Event' has occurred
    Case WinId Of
      // System Operation hook points
      wiSystemOps : begin
        case HandlerId of
          OPEN_INITIAL_COMPANY, OPEN_NEW_COMPANY :
          begin

//            Application.ProcessMessages;  // I am hoping that this helps the redraw of the toolbar in exchequer

            // v6.30.142
            asCompanyPath := IncludeTrailingPathDelimiter(Setup.ssDataPath);
            GetCompanyCodeFromCustomisation;

            { CJS 2013-04-02 - ABSEXCH-14153 - path error on local drive in SQL edition }
            uSettingsSQL.sMiscDirLocation := asCompanyPath;

            if bSQL then
            begin
              if (SQLDataModule = nil) then SQLDataModule := TSQLDataModule.Create(nil);
              SQLDataModule.Connect(asCompanyPath);
              FillCompanyListSQL(asCompanyPath);
              oToolkit := nil;
            end
            else
            begin
              SQLDataModule := nil; {.046}
              InitToolkit(asCompanyPath);

              // v6.30.142
              if Trim(asCompanyCode) = '' then GetCurrentCompanyCode;
            end;{if}

            // v6.30.142
//            GetCurrentCompanyCode;

            GetCurrentUserName;

            {$IFNDEF REMOVE_VRW}
              RWMenuManager.MoveReportWriterOptions;
            {$ENDIF}

            AddUserOptions;

            {$IFNDEF REMOVE_VRW}
              RWMenuManager.mmDataPath := asCompanyPath;

              if bSQL then
              begin
                // SQL Optimisation

                // VRW released ?
                RWMenuManager.mmVRWLicenced := EnterpriseLicence.elModules[modVisualRW] in [mr30Day, mrFull];

                // RW released ?
                RWMenuManager.mmRWLicenced := EnterpriseLicence.elModules[modRepWrt] in [mr30Day, mrFull];
              end
              else
              begin
                RWMenuManager.mmVRWLicenced := not ((oToolkit.SystemSetup.ssReleaseCodes
                as ISystemSetupReleaseCodes2).rcVisualReportWriter = rcDisabled); // VRW released

                RWMenuManager.mmRWLicenced := not ((oToolkit.SystemSetup.ssReleaseCodes
                as ISystemSetupReleaseCodes2).rcReportWriter = rcDisabled); // RW released
              end;{if}


              RWMenuManager.mmVRWAvailable := RWMenuManager.mmVRWLicenced // VRW released
              and ((UserProfile.upSecurityFlags[193] <> 0)
              or (UpperCase(trim(UserProfile.upUserId)) = 'SYSTEM'));  // User level Access to Report Writer

              RWMenuManager.mmUserId := UserProfile.upUserId;
              RWMenuManager.SetupMenus;
            {$ENDIF}

            If Assigned (oToolkit) then oToolkit.CloseToolkit;
            oToolkit := NIL;
          end;

          CLOSE_COMPANY : begin
            asCompanyCode := '';
            asCompanyPath := '';

            if bSQL then
            begin
              if Assigned(SQLDataModule) then
              begin
                SQLDataModule.Disconnect;
                SQLDataModule.Free;
                SQLDataModule := nil;
              end;{if}
//            end
//            else
//            begin
//              CloseFiles;
            end;{if}
            CloseFiles;

            {$IFNDEF REMOVE_VRW}
              RWMenuManager.RemoveMenus;
              RWMenuManager.mmDataPath := '';
              RWMenuManager.mmUserId := '';
            {$ENDIF}

            oSettings.Free;
          end;
        end;{case}
      end;
    end;{case}
  end;{with}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
