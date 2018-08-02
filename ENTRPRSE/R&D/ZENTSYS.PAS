unit ZEntSys;
{$WARN SYMBOL_PLATFORM OFF}
interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Forms, Windows, CustInit, Enterprise_TLB, CustTypU, ZSetup,
  CustIntU, CustAbsU, oSetup, ZVer, ZSysFunc, ZUserPro;

type
  TCOMCustomisation = class(TAutoObject,
                            IConnectionPointContainer,
                            ICOMCustomisation,
                            ICOMCustomisation2,
                            ICOMCustomisation3,
                            ICOMCustomisation4,
                            ICOMCustomisation5,
                            ICOMCustomisation6)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FSinkList: TList;
    FEvents: ICOMCustomisationEvents;

    { Setup Sub Class }
    FSetupD5       : TAbsSetup;     { Delphi customisation object for data access }
    FSetupO        : TComSetup;     { COM Class }
    FSetupI        : IComSetup4;    { COM Interface }

    { Version SubClass }
    FVerInfoO      : TCOMVersion;   { COM Class }
    FVerInfoI      : ICOMVersion2;  { COM Interface }

    FSysFuncO      : TCOMSysFunc;   { COM Class }
    FSysFuncI      : ICOMSysFunc;   { COM Interface }

    { User Profile Sub Class }
    //PR: 18/08/2011 Changed for UserProfile2.  ABSEXCH-7994
    FUserProfileD5 : TAbsUserProfile2;     { Delphi customisation object for data access }
    FUserProfileO  : TComUserProfile;     { COM Class }
    FUserProfileI  : IComUserProfile2;     { COM Interface }

    hEntSysObj     : TEnterpriseSystem;

    Function CheckInSendMessage (Const WId, HId : LongInt) : Boolean;
    Function GetConnectionenumerator : IEnumConnections;
  public
    { Running Object Table handle }
    FRotValue : Integer;

    procedure Initialize; override;
    Destructor Destroy; override;

    { Internal method called when a hook needs to be executed }
    Procedure OnHookEvent(EntSysObj : TEnterpriseSystem; EventData : ICOMEventData);

    { Internal method called to close the clients when shutting down Enterprise }
    Procedure OnCloseEvent;

    { Internal method used during threading to marshal clients for across-apartment calls }
    Procedure MarshalClients(Const ThreadIdx : Byte);

    Procedure OnThreadEvent(Const ThreadIdx : Byte;
                                  EntSysObj : TEnterpriseSystem;
                                  EventData : ICOMEventData);
  protected
    { Protected declarations }
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;

    { Properties }
    function  Get_UserName: WideString; safecall;
     function  Get_ClassVersion: WideString; safecall;
    function entCalc_PcntPcnt(PAmount, Pc1, Pc2: Double; const PCh1,
      PCh2: WideString): Double; safecall;
    function entRound(Num: Double; Decs: Integer): Double; safecall;
    function entGetTaxNo(const VCode: WideString): TVATIndex; safecall;
    procedure AddAboutString(const AboutText: WideString); safecall;
    procedure EnableHook(WindowId, HandlerId: Integer); safecall;
    function Get_SystemSetup: ICOMSetup; safecall;
    function Get_VersionInfo: ICOMVersion; safecall;
    function Get_SysFunc: ICOMSysFunc; safecall;

    { ICOMCustomisation2 }
    procedure AddLabelCustomisation(WindowId: Integer; TextId: Integer; const Caption: WideString); safecall;
    procedure AddLabelCustomisationEx(WindowId: Integer; TextId: Integer;
                                      const Caption: WideString; const FontName: WideString;
                                      FontSize: Integer; FontBold: WordBool; FontItalic: WordBool;
                                      FontUnderline: WordBool; FontStrikeOut: WordBool;
                                      FontColorRed: Integer; FontColorGreen: Integer;
                                      FontColorBlue: Integer); safecall;

    { ICOMCustomisation3 }
    function Get_UserProfile: ICOMUserProfile; safecall;
    function HookPointEnabled(WindowId: Integer; HandlerId: Integer): WordBool; safecall;

    // ICOMCustomisation4
    function Get_SystemSetup2: ICOMSetup3; safecall;

    // ICOMCustomisation5
    function Get_SystemSetup3: ICOMSetup4; safecall;

    // ICOMCustomisation6
    function entCalc_PcntPcntAD(Amount: Double; Discount: Double; const DiscountChr: WideString;
                            Discount2: Double; const Discount2Chr: WideString;
                            Discount3: Double; const Discount3Chr: WideString;
                            SettleDiscount: Double; const SettleDiscountFlag: WideString): Double; safecall;

  end;

  MarshalType = Record
    Marshalled : Boolean;
    Clients    : Array[1..20] Of Pointer;
  End; { MarshalType }

Var
  { COM Customisation object }
  ComEntSys     : TCOMCustomisation = Nil;

  // MH 13/01/2011 v6.6 ABSEXCH-10553: Increased from 0..2 to 0..3 as EL is incorrectly setting the Thread Idx to 3 in various places
  ClientMarshal : Array [0..3] Of MarshalType;


{$IFNDEF COMCU}
  WARNING: This module should not be included in your program
{$ENDIF}

implementation

uses ComServ, GlobVar, VarConst, ZUtils, Comnu2, ETMiscU, BTSupU1,
     Excep2U, oUserPro;


Procedure AddCustomText (Const WindowId, TextId                                   : LongInt;
                         Const Caption, FontName                                  : ShortString;
                         Const FontSize                                           : SmallInt;
                         Const FontBold, FontItalic, FontUnderline, FontStrikeOut : WordBool;
                         Const FontColorRed, FontColorGreen, FontColorBlue        : SmallInt); StdCall; External 'EntCustm.Dll';

{-------------------------------------------------------------------------------------------------}

procedure TCOMCustomisation.Initialize;
begin { Initialize }
  inherited Initialize;

  { Store Reference handle to object }
  ComEntSys := Self;

  { Setup in running objects table }
  RegisterActiveObject(Self, CLASS_COMCustomisation, ActiveObject_Strong, FROTValue);

  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckMulti, EventConnect)
  else FConnectionPoint := nil;

  { Initialise sub-objects }
  FSetupO := Nil;
  FSetupI := Nil; { Setting Interface to Nil will cause Destroy }

  FVerInfoO := Nil;
  FVerInfoI := Nil; { Setting Interface to Nil will cause Destroy }

  FSysFuncO := Nil;
  FSysFuncI := Nil; { Setting Interface to Nil will cause Destroy }

  FUserProfileO := NIL;
  FUserProfileI := NIL; { Setting Interface to Nil will cause Destroy }
end; { Initialize }

{-----------------------------------------}

Destructor TCOMCustomisation.Destroy;
Begin { Destroy }
  { Destroy sub-ojects }
  FSetupO  := Nil;
  FSetupI  := Nil; { Setting Interface to Nil will cause Destroy }

  FVerInfoO := Nil;
  FVerInfoI := Nil; { Setting Interface to Nil will cause Destroy }

  FSysFuncO := Nil;
  FSysFuncI := Nil; { Setting Interface to Nil will cause Destroy }

  FUserProfileO := NIL;
  FUserProfileI := NIL; { Setting Interface to Nil will cause Destroy }

  If Assigned(FSetupD5) Then
    FreeAndNil (FSetupD5);

  If Assigned(FUserProfileD5) Then
    FreeAndNil (FUserProfileD5);

  hEntSysObj := Nil;

  { Remove global Reference handle to object }
  ComEntSys := Nil;

  { Unregister from the ROT }
  //RevokeActiveObject (FROTValue, Nil);

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

procedure TCOMCustomisation.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as ICOMCustomisationEvents;
  if FConnectionPoint <> nil then
     FSinkList := FConnectionPoint.SinkList;
end;

{-------------------------------------------------------------------------------------------------}

// HM 23/10/01: Check WINAPI to determine if possible to call COM
//              Customisation, and wait if not possible.
//              Returns True if COM is Blocked
Function TCOMCustomisation.CheckInSendMessage (Const WId, HId : LongInt) : Boolean;
Var
  FiniTime, TimeNow : Double;

  { Calculates the current time in seconds }
  Function xoCurrentTime : Double;
  Var
    wHour, wMin, wSec, wMSec  : Word;
    lHour, lMin, lSec, lMSec : LongInt;
  begin
    { Get current time }
    DecodeTime(Now, wHour, wMin, wSec, wMSec);

    { Copy fields into longs to force compiler to work in LongInt mode  }
    { otherwise you can get Range Check Errors as it works in Word mode }
    lHour := wHour;
    lMin  := wMin;
    lSec  := wSec;
    lMSec := wMSec;

    { Calculate number of seconds since midnight }
    Result := (lSec + (60 * (lMin + (lHour * 60)))) + (lMSec * 0.001);
  End;

Begin { CheckInSendMessage }
  Result := False;//InSendMessage;

  If Result Then Begin
    // Start timeout loop - hopefully will free within 10 seconds (NOTE: Unlikely)
    FiniTime := xoCurrentTime + 10;

    Repeat
      Application.ProcessMessages;

      Result := InSendMessage;
    Until (Not Result) Or (xoCurrentTime >= FiniTime);

    If Result Then Begin
      // COM Blocked and loop timed out - display useful message
      MessageDlg('The Customisation sub-system is temporarily blocked and has been ' +
                 'unable to process the customisation for event ' + Format ('%d.%d.', [WId, HId]) +
                 #13#13 +
                 'Please contact your Technical Support for advice', mtError, [mbOk], 0);

      // Write Log error message
      AddErrorLog('The Customisation sub-system is blocked and cannot execute',
                  'the COM Clients for event ' + Format ('%d.%d.', [WId, HId]),
                  0);
    End; { If Result }
  End; { If Result }
End; { CheckInSendMessage }

{-------------------------------------------------------------------------------------------------}

Procedure TCOMCustomisation.OnHookEvent(EntSysObj : TEnterpriseSystem; EventData : ICOMEventData);
Var
  Ec          : IEnumConnections;
  ConnectData : TConnectData;
  Fetched     : Cardinal;
Begin { OnHookEvent }
  Try
    Ec := GetConnectionEnumerator;
    If Assigned(Ec) Then Begin
      { Store handle to EntSysObj }
      hEntSysObj := EntSysObj;

      { Copy handle into sub-objects }
      // Assigned(FSetupO) Then FSetupO.InitSetup(hEntSysObj);

      // HM 23/10/01: Check to see if thread locked - preventing COM Usage
      If (Not CheckInSendMessage(EntSysObj.WinId, EntSysObj.HandlerId)) Then Begin
        While (Ec.Next (1, ConnectData, @Fetched) = S_OK) Do
          If ConnectData.pUnk <> Nil Then
            (ConnectData.pUnk As ICOMCustomisationEvents).OnHook(EventData);
      End; { If (Not CheckInSendMessage) }
    End; { If Assigned(FEvents) }
  Except
    On Ex:Exception Do
      MessageDlg ('An error has occurred in the COM Customisation for event ' +
                  IntToStr(EntSysObj.WinId) + '.' + IntToStr(EntSysObj.HandlerId) + '.' + #10#13#10#13 +
                  '''' + Ex.Message + '''' + #10#13#10#13 +
                  'Please notify your Technical Support.', mtError, [mbOk], 0);
  End;
End; { OnHookEvent }

{-----------------------------------------}

Procedure TCOMCustomisation.OnCloseEvent;
Var
  Ec : IEnumConnections;
  ConnectData : TConnectData;
  Fetched : Cardinal;
Begin { OnCloseEvent }
  Try
    Ec := GetConnectionEnumerator;
    If Assigned(Ec) Then Begin

      While (Ec.Next (1, ConnectData, @Fetched) = S_OK) Do
        If ConnectData.pUnk <> Nil Then
          (ConnectData.pUnk As ICOMCustomisationEvents).OnClose;
    End; { If Assigned(FEvents) }
  Except
    On Ex:Exception Do
      MessageDlg ('An error has occured in the COM Customisation for the Close Event ' + #10#13#10#13 +
                  'Please notify your Technical Support.', mtError, [mbOk], 0);
  End;
End; { OnCloseEvent }

{-------------------------------------------------------------------------------------------------}

function TCOMCustomisation.Get_UserName: WideString;
Begin { Get_UserName }
  // HM 16/10/00: Modified as wasn't available until a hook was executing
  //Result := hEntSysObj.UserName;
  Result := EntryRec.Login;
End; { Get_UserName }

{-----------------------------------------}

function TCOMCustomisation.Get_ClassVersion: WideString;
Begin { Get_ClassVersion }
  Result := EntClassVersion;
End; { Get_ClassVersion }

{-----------------------------------------}

Function TCOMCustomisation.GetConnectionenumerator : IEnumConnections;
Var
  Container : IConnectionPointContainer;
  Cp        : IConnectionPoint;
Begin
  Result := Nil;

  OLECheck(QueryInterface(IConnectionPointContainer, Container));
  OLECheck (Container.FindConnectionPoint (AutoFactory.EventIID, Cp));
  Cp.EnumConnections (Result);
End;

//-------------------------------------------------------------------------

function TCOMCustomisation.entCalc_PcntPcnt(PAmount, Pc1, Pc2: Double;
  const PCh1, PCh2: WideString): Double;
Var
  Ch1, Ch2 : Char;
begin
  If (Length(PCh1) > 0) Then
    Ch1 := Chr(Ord(PCh1[1]))    { Convert WideChar To Char! }
  Else
    Ch1 := ' ';
  If (Length(PCh2) > 0) Then
    Ch2 := Chr(Ord(PCh2[1]))    { Convert WideChar To Char! }
  Else
    Ch2 := ' ';

  // HM 16/10/00: Modified as wasn't available until a hook was executing
  //Result := hEntSysObj.entCalc_PcntPcnt(PAmount, Pc1, Pc2, Ch1, Ch2);
  Result:=Calc_PcntPcnt(PAmount,Pc1,Pc2,Ch1,Ch2);
end;

//------------------------------

function TCOMCustomisation.entCalc_PcntPcntAD(Amount: Double;
                                              Discount: Double; const DiscountChr: WideString;
                                              Discount2: Double; const Discount2Chr: WideString;
                                              Discount3: Double; const Discount3Chr: WideString;
                                              SettleDiscount: Double; const SettleDiscountFlag: WideString): Double;
Begin // entCalc_PcntPcntAD
  Result := Calc_PcntPcntAD(Amount, Discount, WideStrToChar (DiscountChr, C0),
                                    Discount2, WideStrToChar (Discount2Chr, C0),
                                    Discount3, WideStrToChar (Discount3Chr, C0),
                                    SettleDiscount, WideStrToChar (SettleDiscountFlag, C0));
End; // entCalc_PcntPcntAD

//-------------------------------------------------------------------------

function TCOMCustomisation.entRound(Num: Double; Decs: Integer): Double;
begin
  // HM 16/10/00: Modified as wasn't available until a hook was executing
  //Result := hEntSysObj.entRound(Num, Decs);
  Result := Round_Up(Num, Decs);
end;

{-----------------------------------------}

function TCOMCustomisation.entGetTaxNo(const VCode: WideString): TVATIndex;
Var
  n         : VATType;
begin
  // HM 16/10/00: Modified as wasn't available until a hook was executing
  //hEntSysObj.entGetTaxNo(WideStrToChar (VCode, ' '));
  n:=GetVATNo(WideStrToChar(VCode,#0),#0);
  Result:=Ord (cuVATIndex(Ord(n)));
end;

{-----------------------------------------}

procedure TCOMCustomisation.AddAboutString(const AboutText: WideString);
Var
  ShortStr : ShortString;
begin
  ShortStr := AboutText;
  CustomHandlers.AddAboutString (ShortStr);
end;

{-----------------------------------------}

procedure TCOMCustomisation.EnableHook(WindowId, HandlerId: Integer);
begin
  CustomHandlers.SetCOMHandlerStatus(WindowId, HandlerId);
end;

{-----------------------------------------}

function TCOMCustomisation.Get_SystemSetup3: ICOMSetup4;
begin
If Assigned(FSetupD5) Then
  FreeAndNIL(FSetupD5);

  If (Not Assigned(FSetupD5)) Then Begin
    FSetupD5 := TSetup.Create;
  End; { If (Not Assigned(FSetupD5)) }

  If (Not Assigned(FSetupO)) Then Begin
    { Create and initialise Customer Details }
    FSetupO := TComSetup.Create;
    FSetupO.InitSetup(FSetupD5);

    FSetupI := FSetupO;
  End; { If (Not Assigned(FCustomer)) }
FSetupO.InitSetup(FSetupD5);

  Result := FSetupI;
end;

function TCOMCustomisation.Get_SystemSetup: ICOMSetup;
begin
  Result := Get_SystemSetup2;
end;

function TCOMCustomisation.Get_SystemSetup2: ICOMSetup3;
begin
  Result := Get_SystemSetup3;
end;

{-----------------------------------------}

function TCOMCustomisation.Get_VersionInfo: ICOMVersion;
begin
  If (Not Assigned(FVerInfoO)) Then Begin
    { Create and initialise Version Details }
    FVerInfoO := TCOMVersion.Create;
    FVerInfoI := FVerInfoO;
  End; { If (Not Assigned(FVerInfoO)) }

  Result := FVerInfoI;
end;

{-----------------------------------------}

function TCOMCustomisation.Get_SysFunc: ICOMSysFunc;
begin
  If (Not Assigned(FSysFuncO)) Then Begin
    { Create and initialise Version Details }
    FSysFuncO := TCOMSysFunc.Create;
    FSysFuncI := FSysFuncO;
  End; { If (Not Assigned(FSysFuncO)) }

  Result := FSysFuncI;
end;

{-----------------------------------------}

{ Internal method used during threading to marshal clients for across-apartment calls }
Procedure TCOMCustomisation.MarshalClients(Const ThreadIdx : Byte);
Var
  Cnt, I : SmallInt;
Begin { MarshalClients }
  // Check not already marshalled
  If (Not ClientMarshal[ThreadIdx].Marshalled) Then Begin
    // Check there are clients
    If (FSinkList.Count > 0) Then
      With ClientMarshal[ThreadIdx] Do Begin
        // Init counter pointing to next cell in Array
        Cnt := 1;

        // run through attached client sinks
        For I := 0 To Pred(FSinkList.Count) Do
          // checck for terminated clients
          If Assigned(FSinkList[I]) Then Begin
            { Exception handling to hide AV's caused by clients having been closed }
            Try
              { Marshal events interface }
              coMarshalInterThreadInterfaceInStream (ICOMCustomisationEvents,
                                                     (IUnknown(FSinkList[I]) As ICOMCustomisationEvents),
                                                     IStream(Clients[Cnt]));
              Inc (Cnt);
            Except
              { Hide exceptions caused by clients }
              On Exception Do
                ;
            End;
          End; { If Assigned(FSinkList[I]) }
      End; { With ClientMarshal[ThreadIdx] }

    // Mark as marshalled
    ClientMarshal[ThreadIdx].Marshalled := True;
  End; { If (Not ClientMarshal[ThreadIdx].Marshalled) }
End; { MarshalClients }

{-------------------------------------------------------------------------------------------------}

Procedure TCOMCustomisation.OnThreadEvent(Const ThreadIdx : Byte;
                                                EntSysObj : TEnterpriseSystem;
                                                EventData : ICOMEventData);
Var
  ClientI  : ICOMCustomisationEvents;
  I        : SmallInt;
  {Ec         : IEnumConnections;
  ConnectData : TConnectData;
  Fetched     : Cardinal;}
Begin { OnThreadEvent }
  // Check it is marshalled
  If ClientMarshal[ThreadIdx].Marshalled Then Begin
    With ClientMarshal[ThreadIdx] Do
      // Run through client sink interface array
      For I := Low(Clients) To High(Clients) Do
        // Check is interface is assigned
        If Assigned(Clients[I]) Then Begin
          // Convert into a valid interface
          coGetInterfaceAndReleaseStream (IStream(Clients[I]),        // Convert Clients[I]
                                          ICOMCustomisationEvents,    // into a client event sink
                                          ClientI);                   // and store in ClientI for use

          // reset client event as has now been used and is invalid
          Clients[I] := Nil;

          // Call event
          ClientI.OnHook(EventData);

          // remove any reference count to client event sink interface
          ClientI := Nil;
        End; { If Assigned(FClientMarshal[ThreadIdx, I]) }

    // Interfaces have been released - mark as unmarshalled
    ClientMarshal[ThreadIdx].Marshalled := False;
  End; { If ClientMarshal[ThreadIdx].Marshalled }
End; { OnThreadEvent }

{-------------------------------------------------------------------------------------------------}

procedure TCOMCustomisation.AddLabelCustomisation (      WindowId      : Integer;
                                                         TextId        : Integer;
                                                   const Caption       : WideString);
Begin { AddLabelCustomisation }
  // Pass customisation information into EntCustm.Dll for storage and use
  AddCustomText (WindowId, TextId, Caption, '', 0, False, False, False, False, 0, 0, 0);
End; { AddLabelCustomisation }

procedure TCOMCustomisation.AddLabelCustomisationEx (      WindowId       : Integer;
                                                           TextId         : Integer;
                                                     const Caption        : WideString;
                                                     const FontName       : WideString;
                                                           FontSize       : Integer;
                                                           FontBold       : WordBool;
                                                           FontItalic     : WordBool;
                                                           FontUnderline  : WordBool;
                                                           FontStrikeOut  : WordBool;
                                                           FontColorRed   : Integer;
                                                           FontColorGreen : Integer;
                                                           FontColorBlue  : Integer);
Begin { AddLabelCustomisation }
  // Pass customisation information into EntCustm.Dll for storage and use
  AddCustomText (WindowId, TextId, Caption, FontName, FontSize,
                 FontBold, FontItalic, FontUnderline, FontStrikeOut,
                 FontColorRed, FontColorGreen, FontColorBlue);
End; { AddLabelCustomisation }

{-------------------------------------------------------------------------------------------------}

function TCOMCustomisation.Get_UserProfile: ICOMUserProfile;
begin
  If (Not Assigned(FUserProfileD5)) Then Begin
    FUserProfileD5 := TUserProfile.Create(hEntSysObj);
    TUserProfile(FUserProfileD5).Assign(0, 0);
  End; { If (Not Assigned(FUserProfileD5)) }

  If (Not Assigned(FUserProfileO)) Then Begin
    { Create and initialise Customer Details }
    FUserProfileO := TComUserProfile.Create;
    FUserProfileO.InitProfile(FUserProfileD5);

    FUserProfileI := FUserProfileO;
  End; { If (Not Assigned(FUserProfileO)) }

  Result := FUserProfileI;
end;

{-------------------------------------------------------------------------------------------------}

function TCOMCustomisation.HookPointEnabled(WindowId: Integer; HandlerId: Integer): WordBool;
begin
  // Return TRUE if either system is using the Hook Point
  Result := CustomHandlers.GotHandler (WindowId, HandlerId) Or
            CustomHandlers.GotCOMHandler (WindowId, HandlerId);
end;

{-------------------------------------------------------------------------------------------------}

initialization
  FillChar (ClientMarshal, SizeOf(ClientMarshal), #0);

  If COMCustomisationEnabled Then Begin
    // NOTE: Will get runtime error 217 here if .TLB has different name to .EXE!
    TAutoObjectFactory.Create(ComServer, TCOMCustomisation, Class_COMCustomisation,
      ciSingleInstance, tmApartment {tmFree} {tmBoth});
  End; { If COMCustomisationEnabled }
end.
