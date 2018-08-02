unit HandlerU;

{$ALIGN 1}

interface

Uses Classes, CustWinU, CustAbsU;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Dialogs, SysUtils, ChainU, PIMisc, ExchequerRelease;


Const
  EventDisabled = 0;
  EventEnabled  = 1;

  {$IFDEF EX600}
    sVersionNo = '105';
  {$ELSE}
    sVersionNo = 'v5.52.104';
  {$ENDIF}

{ ================================================================ }




{ ================================================================ }


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Var
  slAboutText : TStringList;
  iPos        : SmallInt;
Begin
  CustomOn := True;

  With CustomHandlers Do Begin
    { Define About Box Message }
    slAboutText := TStringList.Create;
    Try
      PIMakeAboutText ('Exchequer Line Discount Decs Plug-In', // sName
                       ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)',                       // sVersionNo : string;
                       slAboutText);                            // AboutText

      If (slAboutText.Count > 0) Then
        For iPos := 0 To Pred(slAboutText.Count) Do
          AddAboutString (slAboutText[iPos]);
    Finally
      FreeAndNIL(slAboutText);
    End;

    (*
    AddAboutString ('Exchequer Enterprise Customisation Module');
    AddAboutString ('Copyright Exchequer Software Ltd. 1986 - 2000.');
    AddAboutString ('Set Line Discount decimals to Line Net Value decimals. v1.00 ');
    AddAboutString ('Custom events enabled.');
    *)

    { Define Handlers }
    SetHandlerStatus(EnterpriseBase + 4000, 50, EventEnabled);
  End; { With }

  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }

End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Begin
  Case EventData.WinId Of


    EnterpriseBase + 4000 : If (EventData.HandlerId=50) then
                            With EventData do
                            Begin
                              IntResult:=SetUp.ssNoNetDec;
                              ValidStatus:=True;

                            end;

  End; { Case }

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
