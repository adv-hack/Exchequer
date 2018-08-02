unit CustTypU;

interface

Uses Classes, Forms, Graphics, CustAbsU, ExWrap1U, GlobVar, VarConst, BtKeys1U,
     WinMapU, Windows;

{$H-}   { Huge Strings Off }


Const
  //EntClassVersion : cuStr8 = '5.71.044';
  //EntClassVersion : cuStr8 = '6.01.046';
  // MH 06/08/2012 v7.0 ABSEXCH-12414: Changed to 7.0.057
  //PR: 25/02/2013 v7.0.2 ABSEXCH-13449 Changed to 7.0.058
  //PR: 21/08/2013 v7.X MRD Changed to 7.0.059
  // MH 15/10/2013 v7.0.7 Delivery Postcode Mods Changed to 7.0.060
  // MH 26/11/2013 v7.0.8 Consumer Ledger support - changed to 7.0.061
  // MH 05/03/2014 v7.0.9 ABSEXCH-10398: Redirected to the correct 20 character YourRef field - changed to 7.0.062
  //EntClassVersion : cuStr8 = '7.0.062';
  // MH 08/09/2014 v7.1 ABSEXCH-15052: Added support for Stock Is EC Service flag
  //EntClassVersion : cuStr8 = '7.1.063';
  // MH 02/01/2015 v7.1 ABSEXCH-15855: Added Address Description Fields into System Setup - User Fields
  //EntClassVersion : cuStr8 = '8.0.065';
  // MH 11/05/2015 Exch2015R1 ABSEXCH-16419: Merged v7.0.14 Customisation Changes
  //EntClassVersion : cuStr8 = '8.0.066';
  // MH 20/01/2016 Exch2016R1 ABSEXCH-17114: Customisation mods for Intrastat changes
  //EntClassVersion : cuStr8 = '9.0.067';
  // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
  //EntClassVersion : cuStr8 = '9.1.068';

  // MH 16/01/2017 2017-R1 ABSEXCH-18100: Added 'v' to keep sorting order with move from '9' to '10'
  //                                      As we are limited to 8 chars we have dropped the '.' between
  //                                      the Major/Minor version numbers.
  //EntClassVersion : cuStr8 = 'v100.069';        // v10.0.069

  // MH 06/09/2017 2017-R2 ABSEXCH-18855: Added new User Profile fields into Customisation
  //EntClassVersion : cuStr8 = 'v101.070';   

  // MH 12/03/2018 2018-R1 ABSEXCH-19872: Corrected version number
  //EntClassVersion : cuStr8 = 'v110.071';   

  // MH 17/04/2018 2018-R1.1: Updated version number
  // MH 20/04/2018 2018-R1.1: Removed 4th digit of Exchequer version as it was overflowing the string
  //                          causing the last digit ('2') to be lost.
//  EntClassVersion : cuStr8 = 'v1101.072';
  EntClassVersion : cuStr8 = 'v110.072';

Type
  cuCharSet = Set Of Char;

  WinHandleType = Array [1..WinHandle_NumHandlers] Of Byte;

  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TCustomHandlers = Class(TAbsCustomHandlers01)
  Private
    WinHandlers : Array [1..WinHandle_NumWindows] Of WinHandleType;
    {$IFDEF COMCU}
    COMHandlers : Array [1..WinHandle_NumWindows] Of WinHandleType;
    {$ENDIF}
  Protected
    Function GetClassVersion : cuStr8; OverRide;
  Public
    AbMsgs      : TStringList;

    Constructor Create;
    Destructor  Destroy; OverRide;

    Procedure AddAboutString(Const AbStr : ShortString); OverRide;
    Function  CheckHandlerStatus (Const WinId, HandlerId : LongInt) : Byte;
    Procedure SetHandlerStatus(Const WinId, HandlerId : LongInt;
                               Const Status           : Byte); OverRide;
    Procedure SetCOMHandlerStatus(Const WinId, HandlerId : LongInt);

    Function GotHandler (Const WinId, HandlerId : LongInt) : Boolean;
    Function GotCOMHandler (Const WinId, HandlerId : LongInt) : Boolean;

    // TAbsCustomHandlers01
    Function HookPointEnabled (Const WindowId, HandlerId : LongInt) : WordBool; OverRide;
  End; { Type }

  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TEnterpriseSystem = Class(TAbsEnterpriseSystem09)
  Private
    FBatchSerial : TAbsBatchSerial3;
    FMultiBin    : TAbsMultiBin2;
    FSetup       : TAbsSetup10;
    FCustomer    : TAbsCustomer4;     { Customer Details }
    FSupplier    : TAbsCustomer4;     { Supplier Details }
    FCostCentre  : TAbsCCDept;        { Cost Centre Details }
    FDepartment  : TAbsCCDept;        { Department Details }
    FTransaction : TAbsInvoice8;      { Transaction Details }
    FStock       : TAbsStock4;        { Stock Details }
    FGLCode      : TAbsGLCode;        { General Ledger Details }
    FJob         : TAbsJob5;
    FMiscData    : TAbsMiscData;      { Miscellaneous Data object }
    FUserProfile : TAbsUserProfile5;  { v5.00 User Profile }
    FJobCosting  : TAbsJobCosting;    { v5.50 Job costing sub-object }
    FTelesales   : TAbsTelesales;     { v5.50 Telesales sub-object }
    FLocation    : TAbsLocation;      { v5.70 Location sub-object }
    FPaperless   : TAbsPaperless;     { v5.70 Location sub-object }
    FStockLoc    : TAbsStockLocation; { v5.70 Stock-Location sub-object }

    Function GetDataChanged : Boolean;
  Protected
    Function GetClassVersion : cuStr8; Override;
    Function GetCurrencyVer : Byte; Override;
    Function GetModuleVer : Byte; Override;
    Function GetAcStkAnalOn : Boolean; Override;
    Function GetEBusinessOn : Boolean; Override;
    Function GetJobCostOn : Boolean; Override;
    Function GetPaperlessOn : Boolean; Override;
    Function GetRepWrtOn : Boolean; Override;
    Function GetTelesalesOn : Boolean; Override;
    Function GetUserName : cuStr8; Override;

    Function GetCostCentre : TAbsCCDept; Override;
    Function GetCustomer : TAbsCustomer; Override;
    Function GetDepartment : TAbsCCDept; Override;
    Function GetGLCode : TAbsGLCode; Override;
    Function GetJob : TAbsJob; Override;
    Function GetSetup : TAbsSetup; Override;
    Function GetStock : TAbsStock; Override;
    Function GetSupplier : TAbsCustomer; Override;
    Function GetTransaction : TAbsInvoice; Override;

    Function GetMiscData : TAbsMiscData; Override;
    Function GetUserProfile : TAbsUserProfile; Override;

    { Added in Class Version 4.31.002 }
    Function GetBatchSerial : TAbsBatchSerial; Override;

    // HM 20/02/03: Added support for TAbsEnterpriseSystem02
    Function GetCustomer2 : TAbsCustomer2; Override;
    Function GetJobCosting : TAbsJobCosting; Override;
    Function GetSetup2 : TAbsSetup2; Override;
    Function GetSupplier2 : TAbsCustomer2; Override;
    Function GetTelesales : TAbsTelesales; Override;
    Function GetTransaction2 : TAbsInvoice2; Override;

    // HM 10/09/03: Added support for TAbsEnterpriseSystem03 (v5.52)
    Function GetBatchSerial2 : TAbsBatchSerial2; Override;
    Function GetBin : TAbsMultiBin; Override;
    Function GetSetup3 : TAbsSetup3; Override;
    Function GetStock2 : TAbsStock2; Override;

    // v5.70 - 26/07/05 - TAbsEnterpriseSystem04
    Function GetBatchSerial3 : TAbsBatchSerial3; Override;
    Function GetBin2 : TAbsMultiBin2; Override;
    Function GetLocation : TAbsLocation; Override;
    Function GetPaperless : TAbsPaperless; Override;
    Function GetStock3 : TAbsStock3; Override;
    Function GetStockLocation : TAbsStockLocation; Override;

    // v6.9 30/11/2011 - TAbsEnterpriseSystem06
    Function GetCustomer3 : TAbsCustomer3; Override;
    Function GetSetup4 : TAbsSetup9; Override;
    Function GetStock4 : TAbsStock4; Override;
    Function GetSupplier3 : TAbsCustomer3; Override;
    Function GetTransaction3 : TAbsInvoice8; Override;
    Function GetUserProfile2 : TAbsUserProfile2; Override;

    // v7.0 12/07/2012 TAbsEnterpriseSystem07
    Function GetUserProfile3 : TAbsUserProfile3; Override;

    //PR: 09/09/2013 ABSEXCH-14598 TAbsEnterpriseSystem08
    function GetCustomer4 : TAbsCustomer4; Override;
    function GetSetup10 : TAbsSetup10; Override;
    function GetSupplier4 : TAbsCustomer4; Override;
    //HV 09/02/2018 2017R1 ABSEXCH-19407: Extended UserProfile and GDPR License support in Plug-in. TAbsEnterpriseSystem09
    function GetUserProfile5: TAbsUserProfile5; override;
    function GetGDPROnLicense: Boolean; override;
  Public
    {LocalBtr : TdExLocalPtr;}
    ThisBtrNo : LongInt;          { CId number for Btr }
    LocalBtr  : TdMTExLocalPtr;

    ResetDocTotals,
    NeedDocRefs,
    SetDocRefs: Boolean;

    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create(Const WindowId, EventId : LongInt);
    Destructor  Destroy; OverRide;

    Procedure AssignExLocal(Const ExLocal : TdExLocal);

    // HM 13/11/00: Added routine to check that OurRef/Folio have been allocated
    Procedure CheckTransRef;

    { Inherited Functions }
    Function entRound(Num : Double; Decs : SmallInt) : Double; Override;

    Function entGetTaxNo(Vcode   :  Char) : CuVATIndex; Override;

    Function entCalc_PcntPcnt(PAmount,Pc1,Pc2  :  Real;
                              PCh1,PCh2        :  Char)  :  Real; Override;

    Function entCalc_PcntPcntAD(Amount             : Double;   // Net Value
                                Discount           : Double;   // Line Discount
                                DiscountChr        : Char;     // Line Discount Flag
                                Discount2          : Double;   // Line Discount 2 (Multi-Buy)
                                Discount2Chr       : Char;     // Line Discount 2 Flag
                                Discount3          : Double;   // Line Discount 3 (TTD/VBD)
                                Discount3Chr       : Char;     // Line Discount 3 Flag
                                SettleDiscount     : Double;   // Settlement Discount
                                SettleDiscountFlag : Char      // Settlement Discount Flag
                                ) : Double; Override;
    Procedure entActivate; Override;

    { Common Functions used by Record Classes }
    Procedure DataAccessErrDlg (Const AccRead : Boolean;
                                Const VarName : ShortString);
    Procedure CustomException (Const ExMsg : ShortString);
    Procedure FunctionException (Const ExField : ShortString);
    Procedure NotImplException (Const PropName : ShortString);
    Procedure VersionException (Const ExField : ShortString);
    Function  CustExists(Const AcCode : ShortString; Const ValidTypes : cuCharSet) : Boolean;
    Function  CustExists2(Const AcCode : ShortString; Var ValidTypes : cuCharSet) : Boolean;
    Function  StockExists(Const StCode : ShortString; Const ValidTypes : cuCharSet) : Boolean;
    Function  CheckForRec(KeyS       : Str255;
                          Fnum, KeyP : Integer) :  Boolean;
    Function  ValidCCy (Const Ccy : Byte) : Boolean;
    Function  ValidNomCode (Const NomCode : LongInt; Mode : Byte) : Boolean;
    Function  ValidDate (Const Date : cuLongDate) : Boolean;
    Function  ValidYear(Const Year : Byte) : Boolean;
    Function  ValidPeriod(Const Period : Byte) : Boolean;
  End; { TEnterpriseSystem }


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses Variants, Dialogs, SysUtils, BtrvU2, EtDateU, EtMiscU, BTSupU1, ComnU2,
     oCust, oInv, oCC, oIDetail, oStock, oSetup, oGLCode, oBatch,
     oBin, oLoc, oPaper, oStkLoc,
     oJobCost, oJob, oMiscDat, oUserPro, ExBTTH1U, VarRec2U, oTeleHdr,
     // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
     MadExcept;

Var
  CommandPool : TBits;


{ Validates the Window ID and Returns the remapped Id }
Function ValidWinMapping(Const WinId : LongInt; Var WinMapId : LongInt) : Boolean;
Var
  tWinId : LongInt;
Begin
  { Get Array Id for WinId }
  tWinId   := WinId;
  WinMapId := -1;
  Result := GetWinMapping(WinMapId, tWinId);
End;


{-----------------------------------------------------------------------------}


{ Creates and Initialises an Instance of the Recursion Checker }
Constructor TCustomHandlers.Create;
Begin
  Inherited Create;

  { Initialise all handlers to Off }
  FillChar (WinHandlers, SizeOf (WinHandlers), #0);
  {$IFDEF COMCU}
  FillChar (COMHandlers, SizeOf (COMHandlers), #0);
  {$ENDIF}

  { Create About Messages List }
  AbMsgs := TStringList.Create;
End;


Destructor TCustomHandlers.Destroy;
Begin
  AbMsgs.Free;

  Inherited Destroy;
End;

{ Sets a Handler Status flag }
Procedure TCustomHandlers.SetHandlerStatus(Const WinId, HandlerId : LongInt;
                                           Const Status           : Byte);
Const
  ErrMsg = 'The customisation has attempted to activate an invalid ';
  NotMsg = '), please notify your Customisation Technical Support.';
Var
  WinMapId : LongInt;
Begin
  If ValidWinMapping(WinId, WinMapId) Then Begin
    If (HandlerId >= 1) And (HandlerId <= WinHandle_NumHandlers) Then Begin
      { OK Id's }
      WinHandlers[WinMapId][HandlerId] := Status;
    End { If }
    Else Begin
      MessageDlg (ErrMsg + 'Handler Id (' + IntToStr(HandlerId) + NotMsg, mtError, [mbOk], 0);
    End; { If }
  End { If }
  Else Begin
    MessageDlg (ErrMsg + 'Window Id (' + IntToStr(WinId) + NotMsg, mtError, [mbOk], 0);
  End; { Else }
End;

{ HM 14/02/00: Added to allow separate table of COM hooks to be maintained }
Procedure TCustomHandlers.SetCOMHandlerStatus(Const WinId, HandlerId : LongInt);
{$IFDEF COMCU}
Const
  ErrMsg = 'The COM Customisation has attempted to activate an invalid ';
  NotMsg = '), please notify your Customisation Technical Support.';
Var
  WinMapId : LongInt;
Begin { SetCOMHandlerStatus }
  If ValidWinMapping(WinId, WinMapId) Then Begin
    If (HandlerId >= 1) And (HandlerId <= WinHandle_NumHandlers) Then Begin
      { OK Id's }
      COMHandlers[WinMapId][HandlerId] := 1;
    End { If }
    Else Begin
      MessageDlg (ErrMsg + 'Handler Id (' + IntToStr(HandlerId) + NotMsg, mtError, [mbOk], 0);
    End; { If }
  End { If }
  Else Begin
    MessageDlg (ErrMsg + 'Window Id (' + IntToStr(WinId) + NotMsg, mtError, [mbOk], 0);
  End; { Else }
{$ELSE}
Begin { SetCOMHandlerStatus }
{$ENDIF}
End; { SetCOMHandlerStatus }

{ Checks a Handler Status flag }
Function TCustomHandlers.CheckHandlerStatus (Const WinId, HandlerId : LongInt) : Byte;
{Var
  WinMapId : LongInt;}
Begin
  Result := 0;

  (*
  If ValidWinMapping(WinId, WinMapId) And
     ((HandlerId >= 1) And (HandlerId <= WinHandle_NumHandlers)) Then
    Result := WinHandlers[WinMapId][HandlerId];
  *)

  If GotHandler (WinId, HandlerId) Or GotCOMHandler (WinId, HandlerId) Then
    Result := 1;
End;

{ Checks a Handler Status flag }
Function TCustomHandlers.GotHandler (Const WinId, HandlerId : LongInt) : Boolean;
Var
  WinMapId : LongInt;
Begin { GotHandler }
  Result := False;

  If ValidWinMapping(WinId, WinMapId) And ((HandlerId >= 1) And (HandlerId <= WinHandle_NumHandlers)) Then
    Result := (WinHandlers[WinMapId][HandlerId] <> 0);
End; { GotHandler }

{ Checks a Handler Status flag }
Function TCustomHandlers.GotCOMHandler (Const WinId, HandlerId : LongInt) : Boolean;
Var
  WinMapId : LongInt;
Begin { GotCOMHandler }
  Result := False;

  {$IFDEF COMCU}
  If ValidWinMapping(WinId, WinMapId) And ((HandlerId >= 1) And (HandlerId <= WinHandle_NumHandlers)) Then
    Result := (COMHandlers[WinMapId][HandlerId] <> 0);
  {$ENDIF}
End; { GotCOMHandler }

{ Adds a string to an internal list which is shown on the About Dialog }
Procedure TCustomHandlers.AddAboutString(Const AbStr : ShortString);
Begin
  AbMsgs.Add(AbStr);
End;

{ Returns the version number of the customisation classes supplied to ExecCustomHandler }
Function TCustomHandlers.GetClassVersion : cuStr8;
Begin { GetClassVersion }
  Result := EntClassVersion;
End; { GetClassVersion }

Function TCustomHandlers.HookPointEnabled (Const WindowId, HandlerId : LongInt) : WordBool;
Begin { HookPointEnabled }
  Result := GotHandler (WindowId, HandlerId) Or GotCOMHandler (WindowId, HandlerId);
End; { HookPointEnabled }

{-----------------------------------------------------------------------------}


Constructor TEnterpriseSystem.Create(Const WindowId, EventId : LongInt);
Var
  WinMapId : LongInt;
Begin
  Inherited Create;

  ValidStatus := True;
  BoResult:=False;
  InEditMode:=False;
  DblResult   :=0.0;
  IntResult   :=0;
  FillChar(StrResult,Sizeof(StrResult),0);
  VarResult:=UnAssigned;

  { Check WindowId is valid, but use Window Id not the remapped Window Id }
  If ValidWinMapping(WindowId, WinMapId) Then
    WinId := WindowId
  Else
    MessageDlg ('TEnterpriseSystem.Create - Invalid Window Id', mtError, [mbOk], 0);

  If (EventId >= 1) And (EventId <= WinHandle_NumHandlers) Then
    HandlerId := EventId
  Else
    MessageDlg ('TEnterpriseSystem.Create - Invalid Event Id', mtError, [mbOk], 0);

  { Create EXLocal object }
  ThisBtrNo := 80 + CommandPool.OpenBit;
  // HM 16/08/00: Corrected setting of Command Pool as wasn't subtracting 80, this meant
  // that embedded hooks had same Btrieve Client Id all the time, causing hook 2 to destroy
  // Hook 1's data files!
  CommandPool[ThisBtrNo - 80] := True;
  New(LocalBtr, Create(ThisBtrNo));
  LocalBtr^.Open_System(1,TotFiles);

  { Create Sub-Objects }
  FSetup := TSetup.Create;
  FCustomer := TCustomer.Create(Self, True);    { Customer Details }
  FSupplier := TCustomer.Create(Self, False);   { Supplier Details }
  FCostCentre := TCCDept.Create(Self, True);
  FDepartment := TCCDept.Create(Self, False);
  FTransaction := TInvoice.Create(Self);
  FStock := TStock.Create(Self);
  FGLCode := TGLCode.Create(Self);
  FBatchSerial := TBatchSerial.Create(Self);
  FJob := TJob.Create(Self);
  FMiscData := TMiscData.Create(Self);
  FUserProfile := TUserProfile.Create(Self);
  FJobCosting  := TJobCosting.Create(Self, FJob);
  FTelesales   := TTelesales.Create(Self);
  FMultiBin    := TMultiBin.Create(Self);
  FLocation    := TLocation.Create(Self);
  FPaperless   := TPaperless.Create(Self);
  FStockLoc    := TStockLocation.Create(Self);
  NeedDocRefs:=False;
  SetDocRefs:=False;
  ResetDocTotals:=False;
End;

Destructor TEnterpriseSystem.Destroy;
Begin
  { Free Sub-Objects }
  Customer.Free;
  Supplier.Free;
  CostCentre.Free;
  Department.Free;
  Transaction.Free;
  Stock.Free;
  Setup.Free;
  GLCode.Free;
  FBatchSerial.Free;
  FJob.Free;
  FMiscData.Free;
  FreeAndNIL(FUserProfile);
  FreeAndNIL(FJobCosting);
  FreeAndNIL(FTelesales);
  FreeAndNIL(FMultiBin);
  FreeAndNIL(FLocation);
  FreeAndNIL(FPaperless);
  FreeAndNIL(FStockLoc);

  Dispose (LocalBtr, Destroy);
  CommandPool[ThisBtrNo - 80] := False;

  Inherited Destroy;
End;

{ 4Copies record info from ExLocal into the relevent bits of the object }
Procedure TEnterpriseSystem.AssignExLocal(Const ExLocal : TdExLocal);
Begin
  With ExLocal Do Begin
    ValidStatus:=True;
    BoResult:=False;
    InEditMode:=False;
    DblResult   :=0.0;
    IntResult   :=0;
    FillChar(StrResult,Sizeof(StrResult),0);
    VarResult:=UnAssigned;

    TCustomer(FCustomer).Assign (WinId, HandlerId, LCust);
    TCustomer(FSupplier).Assign (WinId, HandlerId, LCust);
    TCCDept(FCostCentre).Assign (WinId, HandlerId, LPassword);
    TCCDept(FDepartment).Assign (WinId, HandlerId, LPassword);
    TInvoice(FTransaction).Assign (WinId, HandlerId, LInv, LId);
    TStock(FStock).Assign (WinId, HandlerId, LStock);
    TGLCode(FGLCode).Assign (WinId, HandlerId, LNom);
    TBatchSerial(FBatchSerial).Assign (WinId, HandlerId, LMiscRecs^);
    TJob(FJob).Assign (WinId, HandlerId, ExLocal);
    TMiscData(FMiscData).Assign (WinId, HandlerId);
    TUserProfile(FUserProfile).Assign (WinId, HandlerId);
    TJobCosting(FJobCosting).Assign(WinId, HandlerId, ExLocal);
    TTelesales(FTelesales).Assign(WinId, HandlerId, LMLocCtrl^);
    TMultiBin(FMultiBin).Assign(WinId, HandlerId, LMLocCtrl^);
    TLocation(FLocation).Assign(WinId, HandlerId, LMLocCtrl^);
    TPaperless(FPaperless).Assign(WinId, HandlerId, ExLocal);
    TStockLocation(FStockLoc).Assign(WinId, HandlerId, LMLocCtrl^);

    InEditMode:=LastEdit;

    // 13/11/2000 EL: Pass in state of next docs nos so that the hook can assign them if any new lines are added

    NeedDocRefs:=LNeedRefs;
  End; { With }
End;

{ Returns True if any of the Sub-Records have been changed }
Function TEnterpriseSystem.GetDataChanged : Boolean;
Begin
  Result := Customer.DataChanged Or Supplier.DataChanged Or
            CostCentre.DataChanged Or Transaction.DataChanged Or
            Department.DataChanged Or Stock.DataChanged Or
            GLCode.DataChanged Or BatchSerial.Datachanged Or
            Job.DataChanged or FMiscData.DataChanged Or
            FUserProfile.DataChanged Or

            // HM 10/09/03 v5.52
            FMultiBin.Datachanged Or

            // MH 26/07/05 - v5.70
            FLocation.DataChanged Or FPaperLess.DataChanged Or FStockLoc.DataChanged Or

            // v5.50 - Added Job Costing Detail and Telesales
            FJobCosting.CISVoucher.Datachanged Or
            FJobCosting.Employee.Datachanged Or
// HM 17/03/03: Moved into Job object to prevent AccessRights issues
//            FJobCosting.Job2.jrActual.Datachanged Or
//            FJobCosting.Job2.jrBudget.Datachanged Or
//            FJobCosting.Job2.jrRetention.Datachanged Or
            FJobCosting.JobAnalysis.Datachanged Or
            FJobCosting.TimeRate.Datachanged Or
            FTelesales.DataChanged;
// HM 17/03/03: Moved into Job object to prevent AccessRights issues
//            FTelesales.teSalesLine.DataChanged;
End;

{ Rounds the specified Number to the specified Deimal Places }
Function TEnterpriseSystem.entRound(Num : Double; Decs : SmallInt) : Double;
Begin
  Result := Round_Up(Num, Decs);
End;



Function TEnterpriseSystem.entGetTaxNo(Vcode   :  Char) : cuVATIndex;

Var
  n         :  VATType;

Begin
  n:=GetVATNo(VCode,#0);

  Result:=cuVATIndex(Ord(n));

end;

//-------------------------------------------------------------------------

Function TEnterpriseSystem.entCalc_PcntPcnt(PAmount,Pc1,Pc2  :  Real;
                                            PCh1,PCh2        :  Char)  :  Real;


Begin
  Result:=Calc_PcntPcnt(PAmount,Pc1,Pc2,PCh1,PCh2);
end;

//------------------------------

Function TEnterpriseSystem.entCalc_PcntPcntAD(Amount             : Double;   // Net Value
                                              Discount           : Double;   // Line Discount
                                              DiscountChr        : Char;     // Line Discount Flag
                                              Discount2          : Double;   // Line Discount 2 (Multi-Buy)
                                              Discount2Chr       : Char;     // Line Discount 2 Flag
                                              Discount3          : Double;   // Line Discount 3 (TTD/VBD)
                                              Discount3Chr       : Char;     // Line Discount 3 Flag
                                              SettleDiscount     : Double;   // Settlement Discount
                                              SettleDiscountFlag : Char) : Double;  // Settlement Discount Flag
Begin // entCalc_PcntPcntAD
  Result := Calc_PcntPcntAD(Amount, Discount, DiscountChr,
                                    Discount2, Discount2Chr,
                                    Discount3, Discount3Chr,
                                    SettleDiscount, SettleDiscountFlag);
End; // entCalc_PcntPcntAD

//-------------------------------------------------------------------------

{ Displays a data access error dialog for when they try to read N/A data }
{ or write to a read only variable                                       }
Procedure TEnterpriseSystem.DataAccessErrDlg (Const AccRead : Boolean;
                                              Const VarName : ShortString);
Var
  Tmp1 : ShortString;
Begin
  // MH 23/09/2014 Order Payments: Added MadExcept logging to improve support situation
  Try
    If AccRead Then Tmp1 := 'read' Else Tmp1 := 'write to';

    Raise ERightsError.Create ('Customisation Rights Error' + #10#13#10#13 +
                               'An error occured attempting to ' + Tmp1 + ' the ' + VarName);
  Except
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
End;

{ Raises a Validation Exception }
Procedure TEnterpriseSystem.CustomException (Const ExMsg : ShortString);
Begin
  // MH 23/09/2014 Order Payments: Added MadExcept logging to improve support situation
  Try
  Raise EValidationError.Create ('Customisation Validation Error' + #10#13#10#13 + 'An error occured validating the ' + ExMsg);
  Except
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
End;
End;


{ Raises a Validation Exception }
Procedure TEnterpriseSystem.VersionException (Const ExField : ShortString);
Begin
  // MH 23/09/2014 Order Payments: Added MadExcept logging to improve support situation
  Try
    Raise EVersionError.Create ('Version Error - An error occured attempting to access data (' + ExField + ') not available in this version');
  Except
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
End;


{ Raises a Function Exception }
Procedure TEnterpriseSystem.FunctionException (Const ExField : ShortString);
Begin
  // MH 23/09/2014 Order Payments: Added MadExcept logging to improve support situation
  Try
    Raise EFunctionError.Create ('Function Error - An error occured attempting to access a function (' + ExField + ') that is not available');
  Except
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
End;


Procedure TEnterpriseSystem.NotImplException (Const PropName : ShortString);
Begin
  // MH 23/09/2014 Order Payments: Added MadExcept logging to improve support situation
  Try
    Raise ENotImplemented.Create ('Function Not Implemented - The Set function for the property ' + PropName + ' has not been implemented - please notify your technical support');
  Except
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
End;



{ Checks to see if a specific record exists }
Function TEnterpriseSystem.CheckForRec(KeyS       : Str255;
                                       Fnum, KeyP : Integer)  :   Boolean;
Var
  CStatus           : SmallInt;
  TmpStat, TmpKPath : Integer;
  TmpRecAddr        : LongInt;
Begin
  With LocalBtr^ Do Begin
    { Save file position }
    TmpKPath:=GetPosKey;
    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    { See if record exists }
    CStatus:=LFind_Rec(B_GetEq+B_KeyOnly,Fnum,KeyP,KeyS);

    Result:=(CStatus=0);

    { Restore file position }
    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
  End; { With }
end;


{ Returns True if the Currency Number is valid }
Function TEnterpriseSystem.ValidCCy (Const Ccy : Byte) : Boolean;
Begin
  {$IFDEF MC_On}
    // CA 15/04/2013 v7.0.3  ABSEXGENERIC-288: CC/Dept Cost Allocation plug-in not respecting currency
    // Removed (Not Ccy In [10,20,30]))
    Result := ((Ccy >= 1) And (Ccy <= CurrencyType)) ;
  {$ELSE}
    Result := (Ccy = 0);
  {$ENDIF}
End;


{ Returns True if the nominal code exists                             }
{ Modes: 0 = 0 or Valid GL Code                                       }
{        1 = 0 or Valid GL Code of types BankNHCode or PLNHCode       }
{        2 = Valid GL Code of types BankNHCode or PLNHCode            }
{        3 = Valid GL Code of type C and not a Sys Setup Control Code }
Function TEnterpriseSystem.ValidNomCode (Const NomCode : LongInt; Mode : Byte) : Boolean;
Const
  FNum    = NomF;
  KeyPath = NomCodeK;
Var
  TmpStat, TmpKPath : Integer;
  TmpRecAddr        : LongInt;
  KeyS              : Str255;
  CStatus           : SmallInt;

  { Lifted from InvListU. Returns True if Code is used by setup }
  Function Check_NCCodes(NCode : LongInt; AllowDr : Boolean)   :   Boolean;
  Var
    n        :  NomCtrlType;
    NCC      :  LongInt;
    FoundOk  :  Boolean;
  Begin
    FoundOk:=BOff;

    For  n:=InVAT to FreightNC do
      With Syss do Begin
        NCC:=NomCtrlCodes[n];

        FoundOk:=((NCC=NCode)  and (((N<>Debtors) and (N<>Creditors)) or (Not AllowDr)));

        If (FoundOk) then
          Break;
      End; { With }

    Result := FoundOk;
  end;

Begin
  Result := (NomCode = 0) And (Mode In [0, 1]);

  If (Not Result ) Then
    With LocalBtr^ Do Begin
      KeyS := FullNomKey (NomCode);

      { Save current details }
      LastNom  := LNom;
      TmpKPath := GetPosKey;
      TmpStat  := LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      If (Mode = 0) Then
        CStatus:=LFind_Rec(B_GetEq+B_KeyOnly,Fnum,KeyPath,KeyS)
      Else
        CStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);
      Result:=(CStatus=0);

      If Result Then
        Case Mode Of
          0 : { Any Type - Not Bothered };
          1,
          2 : Result := (LNom.NomType In [BankNHCode,PLNHCode]);
          3 : Result := (LNom.NomType = CtrlNHCode) And (Not Check_NCCodes(LNom.NomCode, False));
        End; { Case }

      { Restore file position }
      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
      LNom := LastNom;
    End; { With }
End;


{ Returns True if a Customer/Supplier exists of the Specified Type }
Function TEnterpriseSystem.CustExists2(Const AcCode : ShortString; Var ValidTypes : cuCharSet) : Boolean;
Const
  FNum    = CustF;
  KeyPath = CustCodeK;
Var
  TmpStat, TmpKPath : Integer;
  TmpRecAddr        : LongInt;
  KeyS              : Str255;
  CStatus           : SmallInt;
Begin
  KeyS := FullCustCode (Trim(AcCode));

  With LocalBtr^ Do Begin
    { Save current details }
    LastCust := LCust;
    TmpKPath := GetPosKey;
    TmpStat  := LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    If (ValidTypes = []) Then
      CStatus:=LFind_Rec(B_GetEq+B_KeyOnly,Fnum,KeyPath,KeyS)
    Else
      CStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);
    Result:=(CStatus=0);

    If Result And (ValidTypes <> []) Then
      Result := (LCust.CustSupp In ValidTypes);
    ValidTypes := [LCust.CustSupp];

    { Restore file position }
    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
    LCust := LastCust;
  End; { With }
End;


Function TEnterpriseSystem.CustExists(Const AcCode : ShortString; Const ValidTypes : cuCharSet) : Boolean;
Var
  TmpSet : cuCharSet;
Begin
  TmpSet := ValidTypes;
  Result := CustExists2(AcCode, TmpSet);
End;


{ Returns True if the Stock Exists and is of the specified type(s) }
Function TEnterpriseSystem.StockExists(Const StCode : ShortString; Const ValidTypes : cuCharSet) : Boolean;
Const
  FNum    = StockF;
  KeyPath = StkCodeK;
Var
  TmpStat, TmpKPath : Integer;
  TmpRecAddr        : LongInt;
  KeyS              : Str255;
  CStatus           : SmallInt;
Begin
  KeyS := FullStockCode(Trim(StCode));

  With LocalBtr^ Do Begin
    { Save current details }
    LastStock := LStock;
    TmpKPath := GetPosKey;
    TmpStat  := LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    If (ValidTypes = []) Then
      CStatus:=LFind_Rec(B_GetEq+B_KeyOnly,Fnum,KeyPath,KeyS)
    Else
      CStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);
    Result:=(CStatus=0);

    If Result And (ValidTypes <> []) Then
      Result := (LStock.StockType In ValidTypes);

    { Restore file position }
    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
    LStock := LastStock;
  End; { With }
End;


{ Returns True if the data is valid }
Function TEnterpriseSystem.ValidDate (Const Date : cuLongDate) : Boolean;
Var
  Td, Tm, Ty : Word;
Begin
  DateStr(Date,Td,Tm,Ty);

  Result := ((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));
End;


{ Returns True if the Year is valid }
Function TEnterpriseSystem.ValidYear(Const Year : Byte) : Boolean;
Begin
  Result := (Year >= 1) And (Year <= 150);
End;


{ Returns True if the Period is valid }
Function TEnterpriseSystem.ValidPeriod(Const Period : Byte) : Boolean;
Begin
  Result := (Period >= 1) And (Period <= Syss.PrinYr);
End;

Function TEnterpriseSystem.GetCurrencyVer : Byte;
Begin
  {$IFDEF MC_On}
    If EuroVers Then
      Result := 1   { Euro }
    Else
      Result := 2;  { Global }
  {$ELSE}
    Result := 0;    { Prof }
  {$ENDIF}
End;

Function TEnterpriseSystem.GetModuleVer : Byte;
Begin
  {$IFDEF SOP}
    {$IFDEF STK}
      Result := 1  { Stock }
    {$ELSE}
      Result := 2   { SPOP }
    {$ENDIF}
  {$ELSE}
    Result := 0  { Standard }
  {$ENDIF}
End;

Function TEnterpriseSystem.GetAcStkAnalOn : Boolean;
Begin
  Result := AnalCuStk;
End;

Function TEnterpriseSystem.GetEBusinessOn : Boolean;
Begin
  Result := eBusModule;
End;

Function TEnterpriseSystem.GetJobCostOn : Boolean;
Begin
  Result := JBCostOn;
End;

Function TEnterpriseSystem.GetPaperlessOn : Boolean;
Begin
  Result := eCommsModule;
End;

Function TEnterpriseSystem.GetRepWrtOn : Boolean;
Begin
  Result := RepWrtOn;
End;

Function TEnterpriseSystem.GetTelesalesOn : Boolean;
Begin
  Result := TeleSModule;
End;

Function TEnterpriseSystem.GetClassVersion : cuStr8;
Begin
  Result := EntClassVersion;
End;

Function TEnterpriseSystem.GetUserName : cuStr8;
Begin
  Result := EntryRec.Login;
End;

//------------------------------

Function TEnterpriseSystem.GetBatchSerial : TAbsBatchSerial;
Begin { GetBatchSerial }
  Result := FBatchSerial;
End; { GetBatchSerial }

Function TEnterpriseSystem.GetBatchSerial2 : TAbsBatchSerial2;
Begin { GetBatchSerial2 }
  Result := FBatchSerial;
End; { GetBatchSerial2 }

Function TEnterpriseSystem.GetBatchSerial3 : TAbsBatchSerial3;
Begin { GetBatchSerial3 }
  Result := FBatchSerial;
End; { GetBatchSerial3 }

//------------------------------

Function TEnterpriseSystem.GetBin : TAbsMultiBin;
Begin { GetBin }
  Result := FMultiBin;
End; { GetBin }

Function TEnterpriseSystem.GetBin2 : TAbsMultiBin2;
Begin { GetBin2 }
  Result := FMultiBin;
End; { GetBin2 }

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetLocation : TAbsLocation;
Begin { GetLocation }
  Result := FLocation;
End; { GetLocation }

//------------------------------

Function TEnterpriseSystem.GetCostCentre : TAbsCCDept;
Begin
  Result := FCostCentre;
End;

Function TEnterpriseSystem.GetCustomer : TAbsCustomer;
Begin
  Result := FCustomer;
End;

Function TEnterpriseSystem.GetDepartment : TAbsCCDept;
Begin
  Result := FDepartment;
End;

Function TEnterpriseSystem.GetGLCode : TAbsGLCode;
Begin
  Result := FGLCode;
End;

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetStock : TAbsStock;
Begin
  Result := FStock;
End;

Function TEnterpriseSystem.GetStock2 : TAbsStock2;
Begin
  Result := FStock;
End;

Function TEnterpriseSystem.GetStock3 : TAbsStock3;
Begin // GetStock3
  Result := FStock;
End; // GetStock3

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetSupplier : TAbsCustomer;
Begin
  Result := FSupplier;
End;

Function TEnterpriseSystem.GetTransaction : TAbsInvoice;
Begin
  Result := FTransaction;
End;

Function TEnterpriseSystem.GetJob : TAbsJob;
Begin
  Result := FJob;
End;

Function TEnterpriseSystem.GetMiscData : TAbsMiscData;
Begin
  Result := FMiscData;
End;

Function TEnterpriseSystem.GetUserProfile : TAbsUserProfile;
Begin
  Result := FUserProfile;
End;

Procedure TEnterpriseSystem.entActivate;
Begin { entActivate }
  SetForegroundWindow (Application.MainForm.Handle);
End; { entActivate }


// HM 13/11/00: Added routine to check that OurRef/Folio have been allocated
Procedure TEnterpriseSystem.CheckTransRef;

Var
  DocBtr  :  TdPostExLocalPtr;
  DCid    :  LongInt;

Begin { CheckTransRef }
  If (NeedDocRefs) and (Not SetDocRefs) then {We need to assign our own hard refs}
  Begin
    { Create EXLocal object }
    If (WinId=102000) and (HandlerId=1) then
    Begin
      DCId := 80 + CommandPool.OpenBit;
      CommandPool[DCId - 80] := True;
      New(DocBtr, Create(DCId));
      Try
        DocBtr^.Open_System(InvF,InvF);
        DocBtr^.Open_System(IncF,IncF);

        With DocBtr^,TInvoice(FTransaction),Invoice do
        Begin
          LInv:=Invoice;

          If (NomAuto) then
            LSetNextDocNos(LInv,BOn)
          else
            SetNextAutoDocNos(LInv,BOn);

          Invoice:=LInv;
          SetDocRefs:=True;
          SetRecChanged(True);
        end;
      Finally
        Dispose (DocBtr, Destroy);
        CommandPool[DCId - 80] := False;

      end; {Try..}
    end
    else
    Begin
      Raise Exception.Create ('Customisation Error' + #10#13#10#13 +
                               'An error occured attempting to allocate new transaction numbers during event '+IntToStr(WinId)+
                               ','+IntToStr(HandlerID));

    end;
  end;
End; { CheckTransRef }

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetCustomer2 : TAbsCustomer2;
Begin { GetCustomer2 }
  Result := FCustomer;
End; { GetCustomer2 }

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetJobCosting : TAbsJobCosting;
Begin { GetJobCosting }
  Result := FJobCosting;
End; { GetJobCosting }

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetPaperless : TAbsPaperless;
Begin // GetPaperless
  Result := FPaperless;
End; // GetPaperless

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetStockLocation : TAbsStockLocation;
Begin // GetStockLocation
  Result := FStockLoc;
End; // GetStockLocation

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetSetup : TAbsSetup;
Begin
  Result := FSetup;
End;

Function TEnterpriseSystem.GetSetup2 : TAbsSetup2;
Begin { GetSetup2 }
  Result := FSetup;
End; { GetSetup2 }

Function TEnterpriseSystem.GetSetup3 : TAbsSetup3;
Begin { GetSetup3 }
  Result := FSetup;
End; { GetSetup3 }

Function TEnterpriseSystem.GetSetup4 : TAbsSetup9;
Begin // GetSetup4
  Result := FSetup;
End; // GetSetup4

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetSupplier2 : TAbsCustomer2;
Begin { GetSupplier2 }
  Result := FSupplier;
End; { GetSupplier2 }

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetTelesales : TAbsTelesales;
Begin { GetTelesales }
  Result := FTelesales;
End; { GetTelesales }

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetTransaction2 : TAbsInvoice2;
Begin { GetTransaction2 }
  Result := FTransaction;
End; { GetTransaction2 }

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetCustomer3 : TAbsCustomer3;
Begin // GetCustomer3
  Result := FCustomer;
End; // GetCustomer3

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetStock4 : TAbsStock4;
Begin // GetStock4
  Result := FStock;
End; // GetStock4

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetSupplier3 : TAbsCustomer3;
Begin // GetSupplier3
  Result := FSupplier;
End; // GetSupplier3

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetTransaction3 : TAbsInvoice8;
Begin // GetTransaction3
  Result := FTransaction;
End; // GetTransaction3

//-------------------------------------------------------------------------

Function TEnterpriseSystem.GetUserProfile2 : TAbsUserProfile2;
Begin // GetUserProfile2
  Result := FUserProfile;
End; // GetUserProfile2

//=========================================================================
//PR: 12/07/2012 ABSEXCH-12452
Function TEnterpriseSystem.GetUserProfile3 : TAbsUserProfile3;
Begin // GetUserProfile3
  Result := FUserProfile;
End; // GetUserProfile3



function TEnterpriseSystem.GetCustomer4: TAbsCustomer4;
begin
  Result := FCustomer;
end;

function TEnterpriseSystem.GetSetup10: TAbsSetup10;
begin
  Result := FSetup;
end;

function TEnterpriseSystem.GetSupplier4: TAbsCustomer4;
begin
  Result := FSupplier;
end;

//HV 09/02/2018 2017R1 ABSEXCH-19407: Extended UserProfile and GDPR License support in Plug-in.
function TEnterpriseSystem.GetUserProfile5: TAbsUserProfile5;
begin
  Result := FUserProfile;
end;

//HV 09/02/2018 2017R1 ABSEXCH-19407: Extended UserProfile and GDPR License support in Plug-in.
function TEnterpriseSystem.GetGDPROnLicense: Boolean;
begin
  Result := GDPROn;
end;

Initialization
  CommandPool := TBits.Create;
Finalization
  CommandPool.Free;
end.
