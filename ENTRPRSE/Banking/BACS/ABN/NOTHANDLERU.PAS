unit HandlerU;

{ prutherford440 15:08 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

{ 07/02/2000  v1.00 Hook created }

interface

Uses Controls, Forms, StdCtrls, {TEditVal,} CustWinU, CustAbsU;


{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Dialogs, SysUtils, ChainU, ABNAMRO1, CheckSec;

Const
  EventDisabled = 0;
  EventEnabled  = 1;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Const
  BACSEvents  :  Array[1..8] of Byte =(1,10,20,30,31,50,60,70);
var
  iPos : integer;
  slAboutText : TStringList;
  n  :  Byte;
Begin
  CustomOn := True;

  With CustomHandlers Do Begin
    { Define About Box Message }
    AddAboutString ('ABN-AMRO, Electronic Payment Custom Hook.');
    AddAboutString ('Replacement BACS File.');

    AddAboutString ('Copyright Exchequer Software Ltd. 1986 - 2000.');
    AddAboutString ('Version: 2.00');

    { Define Handlers }

     For n:=Low(BACSEvents) to High(BACSEvents) do
       SetHandlerStatus(EnterpriseBase + 2050, BACSEvents[n], EventEnabled); { Enable all BACS events }

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
End;



{ Called by ExecCustomHandler to control Inv Hed Events }
Procedure BACSHooks(Const EventData : TAbsEnterpriseSystem);
Var
  Decs    : Byte;

Begin {  }
  With EventData  Do
  Begin

    Case EventData.HandlerId Of
      01   : Begin  {Can we handle Payment file requests?}
         //Check licence first.  If not licenced then don't create object and
         //nothing will happen
         if not CheckHookSecurity('Abnepf',9999,'ABN-Amro Electronic Payment Custom Hook')
         then
         begin
           ShowMessage('Invalid licence for ABN-Amro batch transactions' +
                   #13#10'Batch transaction will revert to default BACS format');
         end
         else
               If (Not Assigned(ABNObj)) then
               Begin
                 ABNObj:=TABNObj.Create;

                 try

                   BoResult:=(ABNObj.Failed=0);

                   If (Not BOResult) then
                     ShowMessage('It was not possible to read the file ENTABNHK.INI correctly.'+#13+
                                 'Payment run aborted.');
                 except;
                   ABNObj.Free;
                   ABNObj:=nil;
                   BoResult:=FALSE;

                 end; {try..}
               end
               else
                 BoResult:=(ABNObj.Failed=0);


             end;

      10   : Begin  {Create file, and write header records}
               If (Assigned(ABNObj)) then
               Begin
                 try
                   BoResult:=ABNObj.Init_File(EventData,0);

                   If (BoResult) then
                     ABNObj.Write_Header(EventData);

                 except
                   ABNObj.Free;
                   ABNObj:=nil;
                   BoResult:=FALSE;

                 end; {try..}
               end;
             end;
      20  :  Begin {Check each account has valid bank details}

               If (Assigned(ABNObj)) then
               Begin
                 try
                   BoResult:=ABNObj.ValidateAccount(EventData);
                 except
                   ABNObj.Free;
                   ABNObj:=nil;
                   BoResult:=FALSE;

                 end; {try..}
               end;
             end;


      30  :  Begin {Write each payment record}
               If (Assigned(ABNObj)) then
               Begin
                 try
                   ABNObj.Write_Payment(EventData);
                   BoResult:=TRUE;

                 except
                   ABNObj.Free;
                   ABNObj:=nil;
                   BoResult:=FALSE;

                 end; {try..}
               end;
             end;

      31  :  Begin {Write the contra or total records}
               If (Assigned(ABNObj)) then
               Begin
                 try
                   ABNObj.Write_Footer(EventData);
                   BoResult:=TRUE;

                 except
                   ABNObj.Free;
                   ABNObj:=nil;
                   BoResult:=FALSE;

                 end; {try..}
               end;
             end;

      50   : Begin {Close the payment file}
               If (Assigned(ABNObj)) then
               Begin
                 try
                   ABNObj.Close_File;
                   BoResult:=TRUE;

                 except
                   ABNObj.Free;
                   ABNObj:=nil;
                   BoResult:=FALSE;

                 end; {try..}
               end;
             end;


      70   : Begin{ If run aborted, erase the file and tidy up}

               If (Assigned(ABNObj)) then
               Begin
                 try
                   ABNObj.Erase_File;

                 except
                   ABNObj.Free;
                   ABNObj:=nil;
                   BoResult:=FALSE;

                 end; {try..}
               end;
             end;

      80   : Begin{ Tidy up object}

               If (Assigned(ABNObj)) then
               Begin
                 try
                   With ABNObj do
                     If (Not RunAborted) then
                       ShowFileCreated;
                 finally
                   ABNObj.Free;
                   ABNObj:=nil;
                   BoResult:=True;
                 end;
               end;
             end;


    End; { Case }

  End; { With }
End; { BACSooks }




{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Begin
  { Handle Hook Events here }
  Case EventData.WinId Of

     EnterpriseBase + 2050 : BACSHooks(EventData);
  End; { Case }

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

Initialization


end.
