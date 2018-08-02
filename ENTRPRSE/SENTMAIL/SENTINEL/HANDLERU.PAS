unit HandlerU;

{ prutherford440 15:09 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface


Uses CustWinU, CustAbsU, ChainU;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Dialogs, SysUtils, ElDlHkU, Classes, BtrvU2, GlobVar, ElEvDefs, PIMisc, ElObjs, ElVar,
     Enterprise01_TLB, ComObj, ActiveX;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

  OpenFirstCo = 10;
  OpenNewCo = 9;
  CloseCo = 8;

var
  DataPath : String;
  CHandlers : TAbsCustomHandlers;

procedure OpenDataFiles;
var
  KeyS : String[255];
  Res : SmallInt;
begin
  if Trim(DataPath) <> '' then
    SetDrive := IncludeTrailingBackSlash(Trim(DataPath));
  Res := Open_File(F[ElertF],
           SetDrive + FileNames[ElertF], 0);

  if Res = 0 then
  begin
    FillChar(KeyS, SizeOf(KeyS), #0);
    Keys := IntKey(1);

    Res := Find_Rec(B_GetGEq, F[ElertF],ElertF,RecPtr[ElertF]^, {elIdxElertName}elIdxEvent, KeyS);

    while Res = 0 do
    begin

      if ElertRec.elType = 'E' then
         CHandlers.SetHandlerStatus(ElertRec.elWindowID, ElertRec.elHandlerID, EventEnabled);

      Res := Find_Rec(B_GetNext, F[ElertF],ElertF,RecPtr[ElertF]^, {elIdxElertName}elIdxEvent, KeyS);
    end;
  end;
  Open_File(F[LineF],
           SetDrive + FileNames[LineF], 0);

end;

procedure CloseDataFiles;
begin
  Close_File(F[ElertF]);
  Close_File(F[LineF]);
end;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
var
  i : integer;
  T : TstringList;
  FToolkit : IToolkit;
Begin
  CustomOn := True;
  //PR 20/11/02 Put CoInitialize in to try to stop crash on exit in W2K after displaying graph.
  CoInitialize(nil);
{  FToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
  DataPath := Trim(FToolkit.Enterprise.enCompanyPath);
  FToolkit := nil;                                    }
  CHandlers := CustomHandlers;
  with CustomHandlers  do
  begin
    T := TStringList.Create;
    PIMakeAboutText('Sentimail Plug-In', ElVersion + ' (DLL)', T);

    for i := 0 to T.Count - 1 do
      AddAboutString(T[i]);
    T.Free;

    //Enable change company hook
    SetHandlerStatus(wiMisc + 2, OpenFirstCo, EventEnabled);
    SetHandlerStatus(wiMisc + 2, OpenNewCo, EventEnabled);
    SetHandlerStatus(wiMisc + 2, CloseCo, EventEnabled);
  end;

  DefineFiles('');
  ThisElert := TElertObject.CreateNoFile;
  ThisLine := TEvent.CreateNoFile;

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
  CloseDataFiles;

  if Assigned(ThisElert) then
    ThisElert.Free;
  if Assigned(ThisLine) then
    ThisLine.Free;
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Begin
  { Handle Hook Events here }
  with EventData do
  begin
    //Check here for change of company
    if (WinId = wiMisc + 2) and (HandlerID in [OpenNewCo, OpenFirstCo, CloseCo]) then
    begin
      if HandlerID = CloseCo then
        CloseDataFiles;
      DataPath := Trim(Setup.ssDataPath);
      OpenDataFiles;
    end
    else //pass through to Elert processing
      ProcessEvent(EventData);
  end;
  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
