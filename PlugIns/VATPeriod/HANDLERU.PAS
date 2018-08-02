unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses Classes, CustWinU, CustAbsU;


{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

Var
  bPlugInEnabled : Boolean = False;

implementation

Uses Dialogs, SysUtils, ChainU, PISecure, PIMisc, VatPrObj, VatPView, ComObj, Enterprise01_TLB,
     ActiveX, ExchequerRelease;

Const
  EventDisabled = 0;
  EventEnabled  = 1;
  {$IFDEF EX600}
    // CA 09/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
    sVersionNo = '014';
//    sVersionNo = 'v6.00.012';
  {$ELSE}
    sVersionNo = 'v5.70.012';
  {$ENDIF}


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Var
  slAboutText : TStringList;
  iPos        : SmallInt;
Begin
  CustomOn := True;

  // Check Release Code status of the Plug-In
{$IFDEF MCKECH}
  bPlugInEnabled := True;
{$ELSE}
  bPlugInEnabled := PICheckSecurity('EXCHVATPER000015',     // sSystemCode
                                    'D£Hf%aHazxyaE54y"',     // sSecurityCode
                                    'Exchequer VAT Period Plug-in', // sDescription
                                    '',      // sVersionNo
                                    stSystemOnly,           // iSecurityType
                                    ptDLL,                  // PluginType
                                    DLLChain.ModuleName);   // sPluginPath}
{$ENDIF}

  If bPlugInEnabled Then
    With CustomHandlers Do Begin
      { Define About Box Message }
      slAboutText := TStringList.Create;
      Try
        PIMakeAboutText ('VAT Period Plug-in', // sName
                         ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)',                     // sVersionNo : string;
                         slAboutText);                          // AboutText

        If (slAboutText.Count > 0) Then
          For iPos := 0 To Pred(slAboutText.Count) Do
            AddAboutString (slAboutText[iPos]);
      Finally
        FreeAndNIL(slAboutText);
      End;

      { Define Handlers }
      SetHandlerStatus(wiMisc + 1, 2, EventEnabled);
      SetHandlerStatus(wiMisc + 1, 3, EventEnabled);
      SetHandlerStatus(wiMisc + 1, 4, EventEnabled);
      SetHandlerStatus(wiMisc + 1, 5, EventEnabled);
      SetHandlerStatus(wiMisc + 1, 6, EventEnabled);
      FToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

      { Call other Hook DLL's to get their customisation }
      DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
    End; { With }
End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
  if Assigned(FToolkit) then
  begin
    FToolkit.CloseToolkit;
    FToolkit := nil;
  end;

  CoUninitialize;
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
var
  TempS : string;
Begin
  { Handle Hook Events here }
  if bPlugInEnabled then
    If (EventData.WinId = wiMisc + 1) And (EventData.HandlerId in [2..6]) then
    begin
      VatPeriod.CompanyDir := EventData.Setup.ssDataPath;
      VatPeriod.OpenCompany;

      Case EventData.HandlerId of
        2  :  begin
                EventData.StrResult :=
                        VatPeriod.GetTransactionPeriod(EventData.Transaction.thTransDate, 1);
                EventData.ValidStatus := True;
              end;
        3  :  begin
                EventData.StrResult :=
                        VatPeriod.GetTransactionPeriod(EventData.Transaction.thTransDate, 0);
                EventData.ValidStatus := True;
              end;
        4  :  begin
                 Temps := Copy(EventData.StrResult, 3, 4) + Copy(EventData.StrResult, 1, 2);
                 VatPeriod.Index := 0;
                 if VatPeriod.GetEqual(TempS) = 0 then
                 begin
                    EventData.ValidStatus := True;
                   EventData.StrResult := VatPeriod.EndDate;
                 end
                 else
                 begin
                   EventData.StrResult := 'Invalid!';
                   EventData.ValidStatus := True;
                 end;
              end;
        5  :  begin
                //Return current period
                EventData.StrResult := VatPeriod.CurrentPeriod;
                EventData.ValidStatus := True;
              end;
        6  :  begin
                //Show admin form
                frmPeriodList := TfrmPeriodList.Create(nil);
                with frmPeriodList do
                Try
                  LoadList;
                  ShowModal;
                Finally
                  Free;
                End;
              end;
      end; //case

    end; { If }

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
