UNIT DLLSrBOM;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{* For Serial No/ Batch No and BOM functions *}

{F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 03/09/98                      }
{                                                              }
{                     Internal Export Module                   }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

Interface

Uses
  GlobVar,
  {$IFDEF WIN32}
  VarRec2U,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst,
  VarCnst3;

FUNCTION EX_GETSTOCKBOM(P               :  POINTER;
                        PSIZE           :  LONGINT;
                        SEARCHKEY       :  PCHAR;
                        SEARCHMODE      :  SMALLINT) : SMALLINT;
                        {$IFDEF WIN32} STDCALL; {$ENDIF}
                        EXPORT;

FUNCTION EX_STORESTOCKBOM(P               :  POINTER;
                          PSIZE           :  LONGINT;
                          SEARCHKEY       :  PCHAR) : SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF}
                          EXPORT;

FUNCTION EX_STOREEACHBOMLINE(P          :  POINTER;
                             PSIZE      :  LONGINT;
                             SEARCHMODE :  SMALLINT)  :  SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXPORT;

FUNCTION EX_GETLINESERIALNOS(P               :  POINTER;
                             PSIZE           :  LONGINT;
                             SEARCHKEY       :  PCHAR;
                             SEARCHLINENO    :  LONGINT;
                             SEARCHMODE      :  SMALLINT) : SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXPORT;



FUNCTION EX_GETSERIALBATCH(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXPORT;


FUNCTION EX_STORESERIALBATCH(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXPORT;


FUNCTION EX_USESERIALBATCH(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXPORT;

FUNCTION EX_UNUSESERIALBATCH(P          :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXPORT;

FUNCTION EX_DELETESERIALBATCH(P            :  POINTER;
                              PSIZE        :  LONGINT)  :  SMALLINT;
                              {$IFDEF WIN32} STDCALL; {$ENDIF}
                              EXPORT;

FUNCTION EX_UPDATESERIALBATCHCOST(P            :  POINTER;
                                  PSIZE        :  LONGINT;
                                  CURRENCY     :  SMALLINT;
                                  COST         :  DOUBLE;
                                  DAILYRATE    :  DOUBLE;
                                  COMPANYRATE  :  DOUBLE)  :  SMALLINT;
                                  {$IFDEF WIN32} STDCALL; {$ENDIF}
                                  EXPORT;





{$IFDEF COMTK}
  // HM 12/03/01: Split out copy routine so it could be shared with the COM toolkit
  Procedure CopyExSerialToTkSerial (Const ExSerial : SerialType; Var TkSerial : TBatchSerialRec);
  function GetSerialInDate(Const ExSerial : SerialType) : string;
{$ENDIF}


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
{$IFDEF WIN32}
  BtrvU2,
  BTSupU1,
  SysU2,
  ComnU2,
  CurrncyU,
  BtKeys1U,
{$ELSE}
  BtrvU16,
  BTSup1,
  BTSup2,
{$ENDIF}
  BTS1,
  DLLErrU,
  Dialogs,
  SysUtils,
  DllMiscU,
  DLSQLSup,

  //PR: 02/11/2011 v6.9
  AuditNotes,
  AuditNoteIntf,

  InvCtSuU,

  //PR: 25/01/2012 ABSEXCH-12240
  CRECache,

  //PR: 16/02/2012 ABSEXCH-9795
  Dll01U;                        



Procedure BomToExBom(Var ExBOMRec : TBatchBOMRec;
                         KPath    : SmallInt);

Const
  Fnum       = StockF;
  IdxKeyPath = StkFolioK;

Var
  KeyStockLink : Str255;
  Status       : SmallInt;

Begin

  With ExBOMRec do
  begin
    If (KPath=0) then
      StockCode:=PassWord.BillMatRec.FullStkCode
    else
    begin

      {using StockLink field and find in Stock file with StkFolioK key to get BOM Stock Code}
      KeyStockLink:=LJVar(PassWord.BillMatRec.StockLink,20);

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,IdxKeyPath,KeyStockLink);
      If (Status=0) then
        StockCode:=Stock.StockCode;

    end;

    QtyUsed:=PassWord.BillMatRec.QtyUsed;
    QtyCost:=PassWord.BillMatRec.QtyCost;
  end;
end;

{ ============= End of BomToExBom ============== }


// HM 15/03/01: Extended to support variable size arrays
Function  Get_BOMLines(KeyPath   : SmallInt;
                       FolioNo   : LongInt;
                       Var P     : Pointer;
                       Const MaxBOMLine : SmallInt) : SmallInt;
Const
  Fnum  = PWrdF;
  Msg   : Array[0..1] of SmallInt = (30003,30004);
  {
  30003 = 'No component stock codes for this stock code !',
  30004 = 'This stock code is not used as a component !'
  }
  //MaxBOMLine = 500;  {Maximum Array Lines}

Type
  VariableArrayType = Array [1..5000] Of TBatchBOMRec;

Var
  KeyFolio,
  KeyChk,
  KeyS        : Str255;

  Iline       : SmallInt;

  // HM 15/03/01: Extended to support variable size arrays
  //ExBOMRec    : ^TBatchBOMLinesRec;
  ExBOMRec    : ^VariableArrayType;
Begin

  Iline:=0;

  ExBOMRec:=P;
  //FillChar(ExBOMRec^,SizeOf(ExBOMRec^),#0);
  FillChar(ExBOMRec^,MaxBOMLine * SizeOf(TBatchBOMRec),#0);

  {BOM Index Key}
  KeyS:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(FolioNo)));
  KeyChk:=KeyS;

  UseVariant(F[FNum]);
  Result:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  If (Result<>0) then
    Result:=Msg[KeyPath]  { 30003 or 30004 }
  else
  begin

    // HM 15/03/01: Modified ILine check to be '<' instead of '<=' as was causing Range Check Error
    While ((Result=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (ILine < MaxBOMLine)) do
    begin

      Inc(Iline);
      BomToExBom(ExBomRec^[Iline],KeyPath);

      UseVariant(F[FNum]);
      Result:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {while..}
  end; {if..}

end; {func..}

{ ============= End of Get_BOMLines ============== }

FUNCTION EX_GETSTOCKBOM(P               :  POINTER;
                        PSIZE           :  LONGINT;
                        SEARCHKEY       :  PCHAR;
                        SEARCHMODE      :  SMALLINT) : SMALLINT;

{If SearchMode=0, use PWK index key (List of Stock Codes for defined BOM Stock Code Search Key) }
{If SearchMode=1, use HelpNdxK (List of BOM Stock Codes using defined Stock Code Search Key) }

{Error Code Ref.
30001 - Invalid Stock Code
30002 - Invalid Stock Type ("M" for SearchMode 0 and must not be "G" for SearchMode 1)
30003 - There is no stock component for defined BOM Stock Code.
30004 - Defined Stock Code is not used as a component.
}

Const
  SearchPath    : Array[0..1] of SmallInt = (PWK,HelpNdxK);

  Fnum          = StockF;
  KeyPath       = StkCodeK;

Var
  KeyS          : Str255;
  TStockFolio   : LongInt;

  Status        : Boolean;

Begin
  LastErDesc:='';

  If (TestMode) Then
  begin
    ShowMessage ('Ex_GetStockBOM:' + #10#13 +
                  'PSize: ' + IntToStr(PSize) + #10#13 +
                  'SearchKey: ' + StrPas(SearchKey) + #10#13 +
                  'SearchMode: ' + IntToStr(SearchMode));

  end; { If }

  Result:=32767;

  // HM 15/03/01: Extended to support variable size arrays
  If (P<>Nil) and (PSize<>0) {and (PSize<=SizeOf(TBatchBOMLinesRec)) }and
     ((PSize Mod SizeOf(TBatchBOMRec))=0) And ((PSize Div SizeOf(TBatchBOMRec)) <= 5000) then
  begin

    If (Not (SearchMode in [0..1])) then
      SearchMode:=0;

    {KeyS:=StrPas(SearchKey);
     KeyS:=LJVar(SearchKey,StkLen);}
    KeyS:=FullStockCode(StrPas(SearchKey));
    Result:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (Result<>0) then
      Result:=30001 { Invalid Stock Code }
    else
    begin
      Status:=BOff;
      If SearchMode=SearchPath[0] then
         Status:=(Stock.StockType=BillMatSCode)   {'M'}
      else
         Status:=(Stock.StockType<>StkGrpCode);   {'G'}

      If (Not Status) then
         Result:=30002 { Invalid Stock Type }
      else
      begin

        TStockFolio:=Stock.StockFolio;

        {start for BOM Lines ..}

        // HM 15/03/01: Extended to support variable size arrays
        Result:=Get_BOMLines(SearchPath[SearchMode],TStockFolio,P, PSize Div SizeOf(TBatchBOMRec))

      end; {If Status ..}
    end;  {If Result<>0 ..}

  end
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(46,Result);

end;

{ ============= End of Ex_GetStockBOM ============== }

Procedure SRToExSR(Var ExSRLinesRec : TBatchSRRec;
                       TSearchMode  : SmallInt);

begin

  With ExSRLinesRec do
  begin
    SerialNo:=MiscRecs^.SerialRec.SerialNo;
    BatchNo:=MiscRecs^.SerialRec.BatchNo;
    DateOut:=MiscRecs^.SerialRec.DateOut;
    SerCost:=MiscRecs^.SerialRec.SerCost;
    SerSell:=MiscRecs^.SerialRec.SerSell;
    CurCost:=MiscRecs^.SerialRec.CurCost;
    CurSell:=MiscRecs^.SerialRec.CurSell;
    InMLoc:=MiscRecs^.SerialRec.InMLoc;
    OutMLoc:=MiscRecs^.SerialRec.OutMLoc;
    BuyQty:=MiscRecs^.SerialRec.BuyQty;
    QtyUsed:=MiscRecs^.SerialRec.QtyUsed;
    Sold:=BoolToWordBool(MiscRecs^.SerialRec.Sold);
  end;

end;

{ ============= End of SRToExSR ==================== }

Function Get_LineSerial(Var P       : Pointer;
                            SRefNo  : Str255;
                            SFolio  : LongInt;
                            SMode   : SmallInt ) : SmallInt;
{ To get Serial No / Batch No by defined Keys }
Const
  Fnum         = MiscF;

  { Index Key 0 -> searchMode=0 }
  {     "     1 -> SearchMode=1 and defined SerialNo }
  {     "     2 -> SearchMode=1 and defined BatchNo }

  MaxLines     = 500;

  KeySSub      = MFIFOCode+MSernSub;

  ErMsg        : Array[BOff..BOn] of SmallInt = (30005,30006);
  { 30005 = Invalid Transaction No.    30006 = Invalid Serial / Batch No. }

  SrNoLen      = 20;
  BatchLen     = 10;

Var
  KeyChk,
  KeyS         : Str255;

  Status,
  ILine        : SmallInt;

  ExSRLinesRec : ^TBatchSRLinesRec;

  ErMode,
  ValidCheck   : Boolean;

  { CJS 2012-11-13 - ABSEXCH-13585 - APF UpdateUplift fails on inserted lines }
  FuncRes: LongInt;
begin

  Result:=0;

  Iline:=0;

  ExSRLinesRec:=P;
  FillChar(ExSRLinesRec^,SizeOf(ExSRLinesRec^),#0);

  { By Transaction No }
  If (SMode=0) then
  begin
    ErMode:=BOff;
    SRefNo:=LJVar(SRefNo,DocLen);        {for DocNo. check range}
    KeyS:=KeySSub+FullNomKey(SFolio);
    KeyChk:=KeyS;
    UseVariant(F[FNum]);
    Result:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,SMode,KeyS); {Tran.No}
  end
  else
  { SMode=1 -> By Serial No or Batch No }
  begin
    { Search by Serial No first }
    ErMode:=BOn;
    KeyS:=KeySSub+LJVar(SRefNo,SrNoLen);
    KeyChk:=KeyS;
    UseVariant(F[FNum]);
    Result:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,SMode,KeyS); {Serial No}

    If (Result<>0) then
    { Search by Batch No }
    begin
      SMode:=MiscBtcK; {Index key by batch no = MiscBtcK = 2}
      KeyS:=KeySSub+UpperCase(SRefNo); {*** To confirm for LJVar ***}
      {KeyS:=KeySSub+LJVar(SRefNo,LoginLen); }
      KeyChk:=KeyS;
      UseVariant(F[FNum]);
      Result:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,SMode,KeyS); {Batch No}
    end;
  end;

  If (Result<>0) then
    Result:=ErMsg[ErMode]
  else
  begin
    { CJS 2012-11-13 - ABSEXCH-13585 - APF UpdateUplift fails on inserted lines }
    FuncRes := 0;
    While ((FuncRes=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (ILine<=MaxLines)) do
    begin

      If (SMode=0) then
      begin
        With MiscRecs^, SerialRec do
        begin
          ValidCheck:=((InDoc=SRefNo) or (OutDoc=SRefNo)) and (StkFolio = SFolio);
        end;
      end
      else
        ValidCheck:=BOn;

      If (ValidCheck) then
      begin
        Inc(Iline);
        SRToExSR(ExSRLinesRec^[Iline],SMode);
      end;

      UseVariant(F[FNum]);
      FuncRes:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,SMode,KeyS);

    end; { while ..}
  end; { If Status<>0 of Misc file ..}


end;

{ ============= End of GetLineSerial ============== }

Function  Get_SerialByTran(Var P               :  Pointer;
                               SearchKey       :  PChar;
                               SearchLineNo    :  LongInt;
                               SearchMode      :  SmallInt) : SmallInt;
{ To get Search Key for Transaction No option }
Const
  Fnum         = InvF;
  SearchPath   = InvOurRefK; { OurRef }

  Fnum1        = IdetailF;
  SearchPath1  = IdFolioK; { FolioRef+LineNo }

  Fnum2        = StockF;
  SearchPath2  = StkCodeK; { StockCode }

Var
  RefNo,
  KeyS         : Str255;

  TmpStat,
  TmpKPath
               : Integer;
  TmpRecAddr   : LongInt;
  TmpFn        : FileVar;

Begin

  { Preserve Inv File Record Position - on 21.05.97 }

  TmpFn:=F[Fnum];
  TmpKPath:=GetPosKey;
  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);

  { Search in Inv file with OurRef Key, get FolioNum }

  KeyS:=LJVar(StrPas(SearchKey),DocLen);
  RefNo:=KeyS;

  Result:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath,KeyS);

  { Reposition Inv File record }
  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

  If (Result<>0) then
    Result:=30001 { Invalid Transaction No }
  else
  begin
    { Search in Id file with FolioNum+LineNo, get StockCode }
    KeyS:='';
    KeyS:=FullNomKey(Inv.FolioNum)+FullNomKey(SearchLineNo);
    Result:=Find_Rec(B_GetEq,F[Fnum1],Fnum1,RecPtr[Fnum1]^,SearchPath1,KeyS);

    If (Result<>0) then
      Result:=30002 { Invalid Line Number }
    else
    begin
      { Search in Stock file with StockCode, get StockFolioNo }
      KeyS:='';
      KeyS:=FullStockCode(Id.StockCode);
      Result:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,SearchPath2,KeyS);

      If (Result<>0) then
        Result:=30003 { No Stock Code for this Transaction No and Line No }
      else
      begin

        If (Stock.StkValType<>MSernSub) then {MSernSub='R'}
          Result:=30004 { Invalid Stock Valuation Type }
        else
          Result:=Get_LineSerial(P,RefNo,Stock.StockFolio,SearchMode);

      end; { If Result<>0 of Stock file ..}

    end; { If Result<>0 of ID file ..}

  end;  {If Result<>0 of Inv file ..}

end;

{ ============= End of Get_SerialByTran ============== }

FUNCTION EX_GETLINESERIALNOS(P               :  POINTER;
                             PSIZE           :  LONGINT;
                             SEARCHKEY       :  PCHAR;
                             SEARCHLINENO    :  LONGINT;
                             SEARCHMODE      :  SMALLINT) : SMALLINT;

{If SearchMode=0, SearchKey=Tran.No[SIN,PIN..]    SearchLineNo=Line No}
{If SearchMode=1, SearchKey=SerialNo/BatchNo      SearchLineNo=0}

{Error Code Ref.
30001	- Invalid Transaction Number
30002	- Invalid Line Number
30003	- There is no Stock Code for defined Transaction and Line number.
30004	- Invalid Stock Valuation Type, must be "R"
30005   - Invalid Transaction No.
30006   - Invalid Serial / Batch No.
}

begin

  LastErDesc:='';
  If TestMode then
  Begin
      ShowMessage ('Ex_GetLineSerialNos :' + #10#13 +
                    'PSize: ' + IntToStr(PSize) + #10#13 +
                    'SearchKey: ' + StrPas(SearchKey) + #10#13 +
                    'SearchLineNo: '+IntToStr(SearchLineNo) + #10#13 +
                    'SearchMode: ' + IntToStr(SearchMode));

  End; { If TestMode }

  If (Not (SearchMode in [0..1])) then
    SearchMode:=0;

  Result:=32767;

  If (P<>Nil) and (PSize<>0) and (PSize<=Sizeof(TBatchSRLinesRec)) and
     ((PSize Mod SizeOf(TBatchSRRec)=0)) then
  begin

    { By Transaction }
    If (SearchMode=0) then
      Result:=Get_SerialByTran(P,SearchKey,SearchLineNo,SearchMode)
    else
      { By SerialNo/BatchNo - ignore SearchLineNo}
      Result:=Get_LineSerial(P,StrPas(SearchKey),0,SearchMode);  {SearchLineNo is not used for this condition}

  end
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(47,Result);

end; { Ex_GetLineSerialNos..}

{ ============= End of Ex_GetLineSerialNos ============== }

  { ============ Procedure to Calculate Cost Price ============ }


  Procedure Calc_BillCost(QtyUsed,
                          QtyCost  :  Real;
                          Mode     :  Boolean;
                      Var StockR   :  StockRec);
  Var
    DCnst  :  Integer;

  Begin

    If (Mode) then
      DCnst:=1
    else
      DCnst:=-1;

    With StockR do
    Begin
      CostPrice:=(CostPrice+((QtyUsed*QtyCost)*DCnst));
    end; {With..}

  end; {Proc..}


{ =========================================== }

// HM 15/03/01: Extended to support variable size arrays
Function  Store_BOMLines(TmpStock  : StockRec;
                         P         : Pointer;
                         Const MaxBOMLine : SmallInt) : Integer;
{* Parent Stock Code, Parent Stock Folio & BOMLines Pointer *}

Const
  Fnum1       = StockF;
  KeyPath1    = StkCodeK;
  Fnum2       = PWrdF;
  KeyPath2    = PWK;
  //MaxBOMLine  = 500;  {Maximum Array Lines}

Type
  VariableArrayType = Array [1..5000] Of TBatchBOMRec;
  BillLinkArrayType = Array [1..5000] Of Str10;

Var
  KeyChk,
  KeyS        : Str255;

  CountLine,
  Iline       : SmallInt;

  // HM 15/03/01: Extended to support variable size arrays
  //ExBOMRec    : ^TBatchBOMLinesRec;
  ExBOMRec    : ^VariableArrayType;
  //BillLinkAr  : Array[1..MaxBOMLine] of Str10;
  BillLinkAr  : ^BillLinkArrayType;

  AllRecOK,
  ValidHed,
  ValidCheck  : Boolean;

  LineStkCode : Str20;

Begin

  Iline:=1;
  CountLine:=0;
  Result:=0;
  ExBOMRec:=P;
  AllRecOK:=BOn;
  ValidCheck:=BOn;
  ValidHed:=BOn;

  New (BillLinkAr);
  FillChar(BillLinkAr^,SizeOf(BillLinkAr^),#32);

  {* Start Validation *}

  While ((ValidCheck) and (ILine<=MaxBOMLine)) and (Not EmptyKey(ExBoMRec^[ILine].StockCode,StkLen)) do
  begin
    {* BOM Line Stock Code*}
    LineStkCode:=FullStockCode(ExBoMRec^[ILine].StockCode);

    {* BOM Line Stock Code Must Not Be = Parent Stock Code *}
    ValidCheck:=(Not CheckKey(LineStkCode,TmpStock.StockCode,StkLen,BOn));
    GenSetError(ValidCheck,30101,Result,ValidHed);

    {* Check Line Stock Code *}
    If (ValidCheck) then
    begin
      ValidCheck:=(CheckRecExsists(LineStkCode,Fnum1,KeyPath1));
      GenSetError(ValidCheck,30102,Result,ValidHed);
    end;
    {* Check Stock Type <> Group Code*}
    If (ValidCheck) then
    begin
      ValidCheck:=(Stock.StockType<>StkGrpCode);  {'G' Group Code}
      GenSetError(ValidCheck,30103,Result,ValidHed);
    end;

    {* Calculate BOM Line QtyCost & Assign Parent Stock's Currency & Folio No. *}
    If (ValidCheck) then
    begin
      With ExBOMRec^[ILine] do
      begin
        QtyCost:=Round_Up(Calc_StkCP(Currency_ConvFT(Stock.CostPrice,Stock.PCurrency,TmpStock.PCurrency,
                                                     UseCoDayRate),Stock.BuyUnit,Stock.CalcPack),Syss.NoCosDec);

        // HM 02/03/01: This should be unit cost not total cost
        //QtyCost:=Round_Up((QtyUsed*QtyCost),Syss.NoNetDec);

        // HM 05/03/01: Removed this as it should be Cost decimals not Sales decimals
        //QtyCost:=Round_Up(QtyCost,Syss.NoNetDec);

        BillLinkAr[ILine]:=FullNomKey(Stock.StockFolio);
      end;
    end;

    If (Not ValidCheck) and (AllRecOK) then
       AllRecOK:=BOff;

    Inc(ILine);
    Inc(CountLine); {* at least one BOM record *}

  end; {while..}

  {* If no BOM Lines errors & at least one line,
     Delete current BOM Lines and Add as new Lines *}

  //PR 14/11/2006: Removed CountLine > 0 check so that if an empty array was passed in, we can delete all existing lines
  If (AllRecOK) {and (CountLine>0)} then
  begin
    ValidCheck:=BOn;
    {BOM Index Key for PWrdF }
    KeyS:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(TmpStock.StockFolio)));
    KeyChk:=KeyS;
    Result:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS);

    While ((Result=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))) do
    begin
      {* Delete all *}

      {$IFDEF WIN32}
      If (GetMultiRec(B_GetEq,B_SingLock,KeyS,KeyPath2,Fnum2,SilentLock,GlobLocked)) then
      begin
        Result:=0;
        // If not locked and user hits cancel return code 84
        if not GlobLocked then
          Result := 84;
      end;
      {$ELSE}
      Result:=(GetMultiRec(B_GetEq,B_SingLock,KeyS,KeyPath2,Fnum2,SilentLock,GlobLocked));
      {$ENDIF}

      //PR: 05/09/2016 ABSEXCH-17714 Changed to check Result rather than Status
      If (Result = 0) and (GlobLocked) then
        Result:=Delete_Rec(F[Fnum2],Fnum2,KeyPath2);

      ValidCheck:=(Result=0);

      Result:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS);

    end;

    GenSetError(ValidCheck,30104,Result,ValidHed); {* Unable to Lock Records *}

    {* Add New BOM Lines *}

    //PR 14/11/2006: Added check that array passed in wasn't empty
    If (ValidCheck) and (CountLine > 0) then
    begin
      {* Reinit Parent BOM Stock BLineCount as 0, CostPrice as 0 *}
      KeyS:=TmpStock.StockCode;

      {$IFDEF WIN32}
      If (GetMultiRec(B_GetEq,B_SingLock,KeyS,KeyPath1,Fnum1,SilentLock,GlobLocked)) then
      begin
        Result:=0;
        // If not locked and user hits cancel return code 84
        if not GlobLocked then
          Result := 84;
      end;
      {$ELSE}
      Result:=(GetMultiRec(B_GetEq,B_SingLock,KeyS,KeyPath1,Fnum1,SilentLock,GlobLocked));
      {$ENDIF}

      If (Result=0) and (GlobLocked) then
      begin

        Stock.BLineCount:=0;
        Stock.CostPrice:=0;

        ILine:=1;
        While ((ValidCheck) and (ILine<=CountLine)) do
        begin
          ReSetRec(Fnum2);
          With PassWord.BillMatRec do
          begin

            PassWord.RecPfix:=BillMatTCode;
            PassWord.SubType:=BillMatSCode;
            StockLink:=Full_StkBOMKey(Stock.StockFolio,ILine);     {* Parent Stock Folio *}
            BillLink:=BillLinkAr[ILine];
            QtyUsed:=ExBOMRec^[ILine].QtyUsed;
            QtyCost:=ExBOMRec^[ILine].QtyCost;
            QCurrency:=Stock.PCurrency;                            {* Parent Stock Cost Currency *}
            FullStkCode:=FullStockCode(ExBoMRec^[ILine].StockCode);

            {* Add in PwrdF *}
            Result:=Add_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);
            ValidCheck:=(Result=0);

            {* Calculate Parent BOM Stock Cost Price *}
            If (ValidCheck) then
            begin
              Inc(Stock.BLineCount);
              Calc_BillCost(QtyUsed,QtyCost,BOn,Stock);
            end;

          end;
          Inc(ILine);

        end; {While..}
        {* Update Parent BOM Stock Record with new BLineCount & Cost Price *}
        Result:=Put_Rec(F[Fnum1],Fnum1,RecPtr[Fnum1]^,KeyPath1);

      end; {If Lock..}

    end; {If ValidCheck for Add Records.. }

  end; {If ValidCheck..}

  Dispose (BillLinkAr);

end; {Store_BOMLines..}

{ ============= End of Get_BOMLines ============== }


{ =============== Store Stock BOM =================== }

FUNCTION EX_STORESTOCKBOM(P           :  POINTER;
                          PSIZE       :  LONGINT;
                          SEARCHKEY   :  PCHAR) : SMALLINT;
(* *)
Const
  Fnum          = StockF;
  KeyPath       = StkCodeK;

Var
  KeyS          : Str255;
  TStockCode    : Str20;
  TStockFolio   : LongInt;
  Status        : Boolean;

Begin
  LastErDesc:='';
  If TestMode Then
  Begin
      ShowMessage ('Ex_StoreStockBOM:' + #10#13 +
                    'PSize: ' + IntToStr(PSize) + #10#13 +
                    'SearchKey: ' + StrPas(SearchKey));

  End; { If }

  Result:=32767;

  // HM 15/03/01: Extended to support variable size arrays
  //PR 14/11/2006: Removed checks for P<>nil and PSize <> 0 to allow all boms to be deleted.
  If {(P<>Nil) and (PSize<>0) and (PSize<=SizeOf(TBatchBOMLinesRec)) and}
     ((PSize Mod SizeOf(TBatchBOMRec))=0) And ((PSize Div SizeOf(TBatchBOMRec)) <= 5000) Then
  begin

    KeyS:=FullStockCode(StrPas(SearchKey));
    Result:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (Result<>0) then
      Result:=30001 { Invalid Parent Stock Code }
    else
    begin
      Status:=(Stock.StockType=BillMatSCode);   {'M'}

      If (Not Status) then
         Result:=30002 { Invalid Parent Stock Code Type }
      else
      begin

        {start for BOM Lines ..}
        Result:=Store_BOMLines(Stock,P,PSize Div SizeOf(TBatchBOMRec));

        //PR: 02/11/2011 v6.9 Add Audit Note indicating parent stock item has been changed.
        if Result = 0 then
          AuditNote.AddNote(anStock, Stock.StockFolio, anEdit);
      end; {If Status ..}
    end;  {If found ..}
  end
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(50,Result);

end; { Ex_StoreStockBOM ..}

{ ======================= }

{* just for the validation *}
function ExBOMToBOM_Each(TEachBOM  :  TBatchBOMImportRec;
                     Var TStock    :  StockRec)  :  Integer;
var
  ValidCheck,
  ValidHed    :  Boolean;

begin

  ValidCheck:=BOff;
  ValidHed:=BOn;
  Result:=0;

  With TEachBOM do
  begin

    {* Check Parent Stock Code *}
    PStockCode:=LJVar(UpCaseStr(PStockCode),StkLen);
    ValidCheck:=CheckRecExsists(PStockCode,StockF,StkCodeK);
    GenSetError(ValidCheck,30001,Result,ValidHed);

    {* Parent Stock Type must be M for BOM *}
    If (ValidCheck) then
    begin
      TStock:=Stock;
      ValidCheck:=(Stock.StockType=BillMatSCode);
      GenSetError(ValidCheck,30002,Result,ValidHed);
    end; {if..}

    {* Check Material Stock Code *}
    MStockCode:=LJVar(UpCaseStr(MStockCode),StkLen);
    ValidCheck:=CheckRecExsists(MStockCode,StockF,StkCodeK);
    GenSetError(ValidCheck,30003,Result,ValidHed);

    {* Material Stock Code must not be the Group Code *}
    If (ValidCheck) then
    begin
      ValidCheck:=(Stock.StockType<>StkGrpCode);
      GenSetError(ValidCheck,30004,Result,ValidHed);
    end; {if..}

    {* Parent and Material Stock Must not be the same *}
    VAlidCheck:=(Not CheckKey(PStockCode,MStockCode,StkLen,BOn));
    GenSetError(ValidCheck,30005,Result,ValidHed);
  end; {with..}
end; {func..}

{* Store BOM Line ..*}
function StoreBOM_Each(EachBOM   :  TBatchBOMImportRec;
                       TStock    :  StockRec )  :  Integer;
Const
  Fnum1   =  StockF;
  KPath1  =  StkCodeK;

  Fnum2   =  PWrdF;
  KPath2  =  PWK;

Var
  ValidHed,
  ValidCheck  :  Boolean;
  TmpPassWord :  PassWordRec;
  KeyS        :  Str255;

begin
  ValidHed:=BOn;
  ValidCheck:=BOff;

  ResetRec(PWrdF);
  With Password.BillMatRec do
  begin

    Password.RecPFix:=BillMatTCode;
    Password.SubType:=BillMatSCode;

    FullStkCode:=Stock.StockCode;  {* Component Stock Code *}

    QtyUsed:=EachBOM.QtyUsed;     {* Qty. Used *}

    QtyCost:=Round_Up(Calc_StkCP(Currency_ConvFT(Stock.CostPrice,Stock.PCurrency,TStock.PCurrency,UseCoDayRate),
                      Stock.BuyUnit,Stock.CalcPack),Syss.NoCosDec);

    {* Closed *}
    {QtyCost:=Round_Up((QtyUsed*QtyCost),Syss.NoNetDec); {* Qty. Cost *}

    BillLink:=FullNomKey(Stock.StockFolio);  {* Component Stock Folio *}

    {* Delete current all components *}
    If WordBoolToBool(EachBOM.DeleteStat) then
    begin
      TmpPassWord:=PassWord;

      KeyS:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(TStock.StockFolio)));

      DeleteLinks(KeyS,Fnum2,Length(KeyS),Kpath2,BOff);

      PassWord:=TmpPassWord;

    end; {if..}

    {* ReInit. Parent Stock's BLineCount and Cost Price as Zero *}

    KeyS:=TStock.StockCode;

    {$IFDEF WIN32}
    If (GetMultiRec(B_GetEq,B_SingLock,KeyS,KPath1,Fnum1,SilentLock,GlobLocked)) then
    begin
      Result:=0;
      // If not locked and user hits cancel return code 84
      if not GlobLocked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetEq,B_SingLock,KeyS,KPath1,Fnum1,SilentLock,GlobLocked));
    {$ENDIF}

    If (Result=0) and (GlobLocked) then
    begin

      If WordBoolToBool(EachBOM.DeleteStat) then
      begin
        Stock.BLineCount:=0;
        Stock.CostPrice:=0;
      end; {if..}

      {* Add Component Record into PWrdF File *}
      StockLink:=Full_StkBOMKey(Stock.StockFolio,(Stock.BLineCount+1));
      QCurrency:=Stock.PCurrency;

      Status:=Add_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Kpath2);

      ValidCheck:=(Status=0);

      GenSetError(ValidCheck,30100+Status,Result,ValidHed);

      {* Calculate Parent Stock Cost Price *}

      If (Status=0) then
      begin
        Inc(Stock.BLineCount);
        Calc_BillCost(QtyUsed,QtyCost,BOn,Stock);
      end; {if..}

      {* Update Parent Stock Record *}

      Status:=Put_Rec(F[Fnum1],Fnum1,RecPtr[Fnum1]^,Kpath1);
      GenSetError(ValidCheck,30200+Status,Result,ValidHed);

    end; {if..}

  end; {with..}

end; {func..}


{* For Each BOM Line Import Only, to be the same as Import Module *}

FUNCTION EX_STOREEACHBOMLINE(P          :  POINTER;
                             PSIZE      :  LONGINT;
                             SEARCHMODE :  SMALLINT)  :  SMALLINT;
Var
  EachBOM  :  ^TBatchBOMImportRec;
  TmpStock :  StockRec;

begin
  LastErDesc:='';

  If TestMode Then
  Begin
    EachBOM:=P;
    ShowMessage('Ex_StoreEachBOMLine:' + #10#13 +
                'P^.PStockCode: ' + EachBOM^.PStockCode + #10#13 +
                'P^.MStockCode: ' + EachBOM^.MStockCode + #10#13 +
                'PSize: ' + IntToStr(PSize));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchBOMImportRec)) then
  Begin

    EachBOM:=P;

    FillChar(TmpStock,SizeOf(TmpStock),#0);    {* for Parent Stock Record *}

    Result:=ExBOMToBOM_Each(EachBOM^,TmpStock);

    If (SearchMode<>CheckMode) and (Result=0) then
    begin

      Result:=StoreBOM_Each(EachBOM^, TmpStock);

      //PR: 02/11/2011 v6.9 Add Audit Note indicating parent stock item has been changed.
      if Result = 0 then
        AuditNote.AddNote(anStock, Stock.StockFolio, anEdit);
    end; {if..}

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(94,Result);

end;  {func..}

(*  26.02.2001 .. to test for getting record by Stock Code

{* To get Serial No Record *}
function SerToExSer(Var ExSerRec  :  TBatchSerialRec;
                        SMode     :  Integer)  :  Integer;
Const
  Fnum  =  MiscF;

  KeySSub  =  MFIFOCode+MSernSub;

  KPath    :  Array[BOff..BOn] of Integer  = (MiscBtcK,MiscNdxK);

  SrNoLen  =  20;
  BatchLen =  10;

var
  BySerial,
  ValidCheck,
  ValidHed    :  Boolean;

  KeyChk,
  KeyS        :  Str255;

  StkStat     :  Integer;

begin

  ValidCheck:=BOff;
  ValidHed:=BOn;
  Result:=0;

  With ExSerRec do
  begin

    {* By Serial No *}
    BySerial:=(Not Emptykey(SerialNo,SrNoLen));


    {* Find Record *}
    KeyS:='';
    If (BySerial) then
      KeyS:=KeySSub+LJVar(UpCaseStr(Strip('B',[#32],SerialNo)),SrNoLen)
    else
      KeyS:=KeySSub+LJVar(UpCaseStr(Strip('B',[#32],BatchNo)),BatchLen);

    KeyChk:=KeyS;

    Status:=Find_Rec(SMode,F[Fnum],Fnum,RecPtr[Fnum]^,KPath[BySerial],KeyS);

    ValidCheck:=(Status=0) and
                ((BySerial) or
                ((Not BySerial) and (Not EmptyKey(BatchNo,BatchLen)) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))));

    GenSetError(ValidCheck,30001,Result,ValidHed);

    If (ValidCheck) then
    begin
      SerialNo:=MiscRecs^.SerialRec.SerialNo;
      BatchNo:=MiscRecs^.SerialRec.BatchNo;
      InDoc:=MiscRecs^.SerialRec.InDoc;
      OutDoc:=MiscRecs^.SerialRec.OutDoc;
      Sold:=Ord(MiscRecs^.SerialRec.Sold);
      DateIn:=MiscRecs^.SerialRec.DateIn;
      SerCost:=MiscRecs^.SerialRec.SerCost;
      SerSell:=MiscRecs^.SerialRec.SerSell;
      {* Get Stock Code *}
      KeyS:=Strip('B',[#0],FullNomKey(MiscRecs^.SerialRec.StkFolio));
      ValidCheck:=CheckRecExsists(KeyS,StockF,StkFolioK);
      If (ValidCheck) then
        StockCode:=Stock.StockCode;
      DateOut:=MiscRecs^.SerialRec.DateOut;
      SoldABSLine:=MiscRecs^.SerialRec.SoldLine;
      CurCost:=MiscRecs^.SerialRec.CurCost;
      CurSell:=MiscRecs^.SerialRec.CurSell;
      BuyABSLine:=MiscRecs^.SerialRec.BuyLine;
      BatchRec:=Ord(MiscRecs^.SerialRec.BatchRec);
      BuyQty:=MiscRecs^.SerialRec.BuyQty;
      QtyUsed:=MiscRecs^.SerialRec.QtyUsed;
      BatchChild:=Ord(MiscRecs^.SerialRec.BatchChild);
      InMLoc:=MiscRecs^.SerialRec.InMLoc;
      OutMLoc:=MiscRecs^.SerialRec.OutMLoc;
      {SerCRates:=MiscRecs^.SerialRec.SerCRates;}
      CoRate:=MiscRecs^.SerialRec.SerCRates[BOff];
      DailyRate:=MiscRecs^.SerialRec.SerCRates[BOn];
      InOrdDoc:=MiscRecs^.SerialRec.InOrdDoc;
      OutOrdDoc:=MiscRecs^.SerialRec.OutOrdDoc;
      InOrdLine:=MiscRecs^.SerialRec.InOrdLine;
      OutOrdLine:=MiscRecs^.SerialRec.OutOrdLine;
      DateUseX:=MiscRecs^.SerialRec.DateUseX;

    end; {if..}
  end; {with..}
end; {func..}
*)

function GetSerialInDate(Const ExSerial : SerialType) : string;
var
  Res : Integer;
  KeyS : Str255;
  TmpKPath,
  TmpStat     :  Integer;
  TmpFn       :  FileVar;
  TmpRecAddr  :  Longint;
begin
  Result := ExSerial.DateIn;
  if (Trim(Result) = '') and (Trim(ExSerial.InDoc) <> '') then
  begin
    //Store existing transaction pos
    TmpFn:=F[InvF];
    TmpKPath:=GetPosKey;
    TmpStat:=Presrv_BTPos(InvF,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);
    Try

      KeyS := ExSerial.InDoc;
      Res := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, KeyS);

      if Res = 0 then
        Result := Inv.TransDate;
    Finally
      TmpStat:=Presrv_BTPos(InvF,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);
    End;

  end;
end;


// HM 12/03/01: Split out copy routine so it could be shared with the COM toolkit
Procedure CopyExSerialToTkSerial (Const ExSerial : SerialType; Var TkSerial : TBatchSerialRec);
Var
  ValidCheck : Boolean;
  KeyS       : Str255;
Begin { CopyExSerialToTkSerial }
  FillChar (TkSerial, SizeOf(TkSerial), #0);

  With TkSerial Do Begin
    SerialNo := ExSerial.SerialNo;
    BatchNo := ExSerial.BatchNo;
    InDoc := ExSerial.InDoc;
    OutDoc := ExSerial.OutDoc;
    Sold := BoolToWordBool(ExSerial.Sold);
    if Trim(ExSerial.DateIn) <> '' then
      DateIn := ExSerial.DateIn
    else
      DateIn := GetSerialInDate(ExSerial);
    SerCost := ExSerial.SerCost;
    SerSell := ExSerial.SerSell;
    {* Get Stock Code *}
//    KeyS := Strip('B',[#0],FullNomKey(ExSerial.StkFolio));
    KeyS := Strip('R',[#0],FullNomKey(ExSerial.StkFolio));
    ValidCheck := CheckRecExsists(KeyS,StockF,StkFolioK);
    If (ValidCheck) then
      StockCode := Stock.StockCode;
    DateOut := ExSerial.DateOut;
    SoldABSLine := ExSerial.SoldLine;
    CurCost := ExSerial.CurCost;
    CurSell := ExSerial.CurSell;
    BuyABSLine := ExSerial.BuyLine;
    BatchRec := BoolToWordBool(ExSerial.BatchRec);
    BuyQty := ExSerial.BuyQty;
    QtyUsed := ExSerial.QtyUsed;
    BatchChild := BoolToWordBool(ExSerial.BatchChild);
    InMLoc := ExSerial.InMLoc;
    OutMLoc := ExSerial.OutMLoc;
    {SerCRates:=ExSerial.SerCRates;}
    CoRate := ExSerial.SerCRates[BOff];
    DailyRate := ExSerial.SerCRates[BOn];
    InOrdDoc := ExSerial.InOrdDoc;
    OutOrdDoc := ExSerial.OutOrdDoc;
    InOrdLine := ExSerial.InOrdLine;
    OutOrdLine := ExSerial.OutOrdLine;
    DateUseX :=  ExSerial.DateUseX;
    InBinCode := ExSerial.InBinCode;
    {$IFDEF COMTK}
    ReturnDoc := ExSerial.RetDoc;
    Returned := ExSerial.ReturnSNo;
    ReturnDocLine := ExSerial.RetDocLine;
    BatchRetQty := ExSerial.BatchRetQty;
    {$ENDIF}
  End; { With TkSerial }
End; { CopyExSerialToTkSerial }


{* To get Serial No Record *}
function SerToExSer(Var ExSerRec  :  TBatchSerialRec;
                        SMode     :  Integer)  :  Integer;
Const
  Fnum  =  MiscF;

  KeySSub  =  MFIFOCode+MSernSub;

  {KPath    :  Array[BOff..BOn] of Integer  = (MiscBtcK,MiscNdxK);}

  KPath    :  Array[1..3] of Integer  = (MiscNdxK,MiscBtcK,MIK);  { Serial,Bathc,Stock}

  SrNoLen  =  20;
  BatchLen =  10;

var

  {BySerial,}
  ValidCheck,
  ValidHed    :  Boolean;

  KeyChk,
  KeyS        :  Str255;

  StkStat     :  Integer;

  IndexBy     :  Byte;

begin

  ValidCheck:=BOff;
  ValidHed:=BOn;
  Result:=0;

  With ExSerRec do
  begin
    (*
    {* By Serial No *}
    BySerial:=(Not Emptykey(SerialNo,SrNoLen));

    {* Find Record *}
    KeyS:='';
    If (BySerial) then
      KeyS:=KeySSub+LJVar(UpCaseStr(Strip('B',[#32],SerialNo)),SrNoLen)
    else
      KeyS:=KeySSub+LJVar(UpCaseStr(Strip('B',[#32],BatchNo)),BatchLen);
    *)

    If (Not Emptykey(SerialNo,SrNoLen)) then
      IndexBy:=1
    else
      If (Not EmptyKey(BatchNo,BatchLen)) then
        IndexBy:=2
      else
        If (Not EmptyKey(StockCode,StkLen)) then
          IndexBy:=3
        else
          IndexBy:=0;

    ValidCheck:=(IndexBy In [1..3]);

    GenSetError(ValidCheck,30002,Result,ValidHed);

    If (ValidCheck) then
    begin

      Case IndexBy of
        1 : KeyS:=KeySSub+LJVar(UpCaseStr(Strip('B',[#32],SerialNo)),SrNoLen);
        2 : KeyS:=KeySSub+LJVar(UpCaseStr(Strip('B',[#32],BatchNo)),BatchLen);
        3 : begin
              KeyS:=LJVar(UpperCase(StockCode),StkLen);
              ValidCheck:=CheckRecExsists(KeyS,StockF,StkCodeK);
              GenSetError(ValidCheck,30003,Result,ValidHed);
              if (ValidCheck) then
              begin
                {$IFDEF TC}
                  // NF: 26/05/06 Special Fix / New functionality
                  // We now allow the sold flag to be passed in, so we can find sold or unsold serial nos.
                  if WordBoolToBool(ExSerRec.Sold)
                  then KeyS := KeySSub + FullNomKey(Stock.StockFolio) + #1
                  else KeyS := KeySSub + FullNomKey(Stock.StockFolio) + #0;
                {$ELSE}
                  KeyS:=KeySSub+FullNomKey(Stock.StockFolio);
                {$ENDIF}
              end;{if}
            end;
      end; {Case..}

      KeyChk:=KeyS;

      KeyS := SetKeyString(SMode, FNum, KeyS);

      UseVariant(F[FNum]);
      Status:=Find_Rec(SMode,F[Fnum],Fnum,RecPtr[Fnum]^,KPath[IndexBy],KeyS);

      KeyStrings[FNum] := KeyS;

      ValidCheck:=(Status=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));

      GenSetError(ValidCheck,30001,Result,ValidHed);

    end; {if..}


    If (ValidCheck) then
    begin
      CopyExSerialToTkSerial (MiscRecs^.SerialRec, ExSerRec);

      // HM 06/09/01: Set Record Position
      If (GetPos(F[FNum], FNum, ExSerRec.RecPos) <> 0) Then
        ExSerRec.RecPos := 0;
    end; {if..}
  end; {with..}
end; {func..}

{* Get Serial No *}
FUNCTION EX_GETSERIALBATCH(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHMODE   :  SMALLINT)  :  SMALLINT;

Var
  SerRec  :  ^TBatchSerialRec;

begin
  LastErDesc:='';
  If TestMode then
  begin
    SerRec:=P;
    ShowMessage('Ex_GetSerialNo : ' + #10#13 +
                'P^.SerialNo    : ' + SerRec^.SerialNo + #10#13 +
                'P^.BatchNo     : ' + SerRec^.BatchNo + #10#13 +
                'PSize: ' + IntToStr(PSize));
  end; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchSerialRec)) then
  Begin

    SerRec:=P;

    Result:=SerToExSer(SerRec^,SearchMode);

    //PR: 16/02/2012 Reset Discount File variable to MiscF. ABSEXCH-9795
    if Result = 0 then
      CurrentDiscountFileNo := MiscF;


  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(95,Result);

end;  {func..}


{* For Purchases Serial/Batch *}

function StoreExSerToSer(ExSer  :  TBatchSerialRec;
                         SMode  :  SmallInt )  :  Integer;

Const
  Fnum   =  MiscF;
  Fnum1  =  IDetailF;

  KeySSub  =  MFIFOCode+MSernSub;

  KPath    :  Array[BOff..BOn] of Integer  = (MiscNdxK,MiscBtcK);

  SrNoLen  =  20;
  BatchLen =  10;

Var
  ByBatch,
  FindBatch,
  ValidCheck,
  ValidHed    :  Boolean;

  TLKey,
  KeyChk,
  KeyS        :  Str255;

  Td,Tm,Ty    :  Word;

  TmpSMode    :  SmallInt;

  TMiscRec,
  SwpSerRec   :  MiscRec;

  InDocFolio  :  LongInt;

  TmpRecAddr  :  LongInt;

  TmpKPath,
  TmpStat     :  Integer;
  TmpFn       :  FileVar;

  TmpInvKPath    :  Integer;
  TmpInvFn       :  FileVar;
  TmpInvRecAddr  :  LongInt;

  TmpStockKPath    :  Integer;
  TmpStockFn       :  FileVar;
  TmpStockRecAddr  :  LongInt;

  ThisStockRecAddr : longint;

  OldCurr     : Byte; //PR: 17/02/2011

  {TmpSerRec   :  SerialType;}
  //PR: 24/11/2011 If we're updating a batch we need to know what the additional qty is to update the trans line.
  UpdateQty : Double;
  NewDocFolio : longint;
  NewOurRef : string;
  NewLineNo : longint;

  //PR: 03/02/2012 Need to lock stock record before updating it.
  LineFound : Boolean;
  StockLocked, SilentLock : Boolean;
  TempRes : Integer;

  NewAmnt : Double;

  function FindTransLine : Boolean;
  begin
    Result := True;
    TmpFn:=F[Fnum1];
    TmpKPath:=GetPosKey;
    TmpStat:=Presrv_BTPos(IDetailF,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);
    TmpStat:=Presrv_BTPos(InvF,TmpInvKPath,TmpInvFn,TmpInvRecAddr,BOff,BOff);
    TmpStat:=Presrv_BTPos(StockF,TmpStockKPath,TmpStockFn,TmpStockRecAddr,BOff,BOff);

    //PR: 25/11/2011 If we're updating a batch record then the InDoc will be the doc that originally
    //brought the batch in.  The new doc/line is in NewOurRef/NewLineNo
    //PR: 06/01/2012 ByBatch hasn't been set at the point this is called, so change to check for blank serialno  ABSEXCH-12169
    if (Trim(ExSer.SerialNo) = '') and (SMode = B_Update) and (NewOurRef <> '') and (NewLineNo <> 0) then
    begin
      KeyS := LjVar(NewOurRef,DocLen);
      Result := CheckRecExsists(KeyS,InvF,InvOurRefK);
      if Result then
        TLKey := FullIDKey(Inv.FolioNum, NewLineNo);
    end
    else
    begin  //PR: 30/11/2011 Was using InDocFolio for adding, which isn't set at this point.
      KeyS := LjVar(ExSer.InDoc,DocLen);
      Result := CheckRecExsists(KeyS,InvF,InvOurRefK);
      TLKey:=FullIDKey(Inv.FolioNum,ExSer.BuyABSLine);
    end;

    if Result then
    begin
      Status:=Find_Rec(B_GetEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK,TLKey);

      ValidCheck:=(Status=0);
    end;
  end;

begin
  OldCurr := 0;
  ValidCheck:=BOff;
  ValidHed:=BOn;
  Result:=0;

  //PR: 17/02/2011 If we're updating then fill the record with the existing fields to catch
  //any that aren't available in the tk record. In the COM Toolkit we already have the
  //correct record in MiscRecs at this point.
  {$IFDEF COMTK}
  if SMode = B_Update then
    TMiscRec := MiscRecs^
  else
  {$ENDIF}
  Fillchar(TMiscRec,SizeOf(TMiscRec),#0);

  {$IFDEF COMTK}
     NewOurRef := ExSer.LatestInDoc;
     NewLineNo := ExSer.LatestBuyLine;
  {$ELSE}
     NewOurRef := '';
     NewLineNo := 0;
  {$ENDIF}

  With TMiscRec.SerialRec do
  begin

    LineFound := FindTransLine;
    UpdateQty := ExSer.BuyQty - BuyQty;


    SerialNo:=LJVar(UpCaseStr(Strip('B',[#32],ExSer.SerialNo)),SrNoLen);
    BatchNo:=LjVar(UpCaseStr(Strip('B',[#32],ExSer.BatchNo)),BatchLen);

    {* Assign only for for Buy fields ...*}
    InDoc:=ExSer.InDoc;           {Pur. TransDocNo.}
    BuyLine:=ExSer.BuyABSLine;    {to be replaced with Id.ABSLineNo.}
    DateIn:=ExSer.DateIn;         {Date}
    SerCost:=ExSer.SerCost;       {Cost Price }
    CurCost:=ExSer.CurCost;       {Currency}
    InMLoc:=LJVar(UpperCase(ExSer.InMLoc),MLocKeyLen);    {Location}
    BuyQty:=ExSer.BuyQty;         {Qty}
    InOrdDoc:=ExSer.InOrdDoc;     {POR No.}
    InOrdLine:=ExSer.InOrdLine;   {POR Line No.}

    InBinCode := ExSer.InBinCode;

    //PR: 24/11/2011 copy out fields as well, since if we have a job code on the line, the stock is booked out again
    //automatically
    OutDoc := ExSer.OutDoc;
    SoldLine := ExSer.SoldABSLine;
    OutMLoc := ExSer.OutMLoc;
    DateOut := ExSer.DateOut;
    CurSell := ExSer.CurCost;
    Sold    := WordBoolToBool(ExSer.Sold);
    SerSell := ExSer.SerSell;

    //PR: 02/12/2011 Live team are setting sold to False regardless, so reset it here.
    if LineFound and (Trim(Id.JobCode) <> '') then
    begin
      Sold := True;
      if Trim(BatchNo) <> '' then
        QtyUsed := ExSer.BuyQty;
    end;


    {$IFDEF COMTK}
    RetDoc := ExSer.ReturnDoc;
    ReturnSno := ExSer.Returned;
    RetDocLine := ExSer.ReturnDocLine;
    BatchRetQty := ExSer.BatchRetQty;
    {$ENDIF}
    {Batch Record without Serial No}
    ByBatch:=(Emptykey(SerialNo,SrNoLen));
    BatchRec:=ByBatch;

    SerCRates[BOff]:=ExSer.CoRate;
    SerCRates[BOn]:=ExSer.DailyRate;

    SetTriRec(CurCost,SUseORate,SerTriR);  { for v4.31 }

    DateUseX:=ExSer.DateUseX;

//    Sold:=BOff;     //PR: 24/11/2011 Sold can be true when adding

    {* must be Insert or Check or Import Mode *}
    //PR: 17/02/2011 Allow updates through COM Toolkit
    {$IFNDEF COMTK}
    If (Not (SMode In [B_Insert, CheckMode, ImportMode])) then
      SMode:=B_Insert;
    {$ENDIF}

    {* Stock Code ... This has to be first so that Stock Folio can be compared ..*}

    KeyS:=LJVar(UpCaseStr(ExSer.StockCode),StkLen);

    //PR: 06/02/2012 Change to use Find_Rec rather than CheckRecExists, as
    //we need to be positioned on the stock record to update the cost price.
    TempRes:=Find_Rec(B_GetEq,F[StockF],StockF,RecPtr[StockF]^,0,KeyS);

    //PR: 13/03/2012 ABSEXWEBEX-2359 Only lock stock record if blank job code and not Serial Batch Average
    if (TempRes = 0) and (Trim(Id.JobCode) = '') and (Stock.SerNoWAvg <> 1) and
       (SMode<>CheckMode) then {* Attempt to lock record after we have found it *}
    begin
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,0,StockF,False,StockLocked)) then
        TempRes:=0;
      if (TempRes = 0) and not StockLocked then
        TempRes := 84;
    end;
    ValidCheck := TempRes in [0, 84];

//    ValidCheck:=CheckRecExsists(KeyS,StockF,StkCodeK);
    GenSetError(ValidCheck,30001,Result,ValidHed);

    If (ValidCheck) then
    begin
      StkFolio:=Stock.StockFolio;
      {* Type must be P/M/X *}
      ValidCheck:=(Stock.StockType In [StkStkCode,StkDListCode,StkBillcode]);
      GenSetError(ValidCheck,30002,Result,ValidHed);
    end; {if ..}

    {* Serial No or Batch No should be assigned *}
    //PR 17/12/01 Bugfix - allow same serialno for different stock items
    If (Not ByBatch) then
//      KeyS:=KeySSub+FullNomKey(StkFolio)+Char(Ord(Sold))+SerialNo
//     Move below to check sold & unsold
    else
      KeyS:=KeySSub+BatchNo;

    {* Find the record *}
    ValidCheck:=BOn;

    {* Need to validate for only Serial No *}
    If (Not ByBatch) then
    begin
      KeyS:=KeySSub+FullNomKey(StkFolio)+#0+SerialNo; {unsold}
      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,{KPath[ByBatch]}MIK,KeyS);
      {$IFDEF COMTK}
       if SMode = B_Update then
       begin
         ValidCheck:=(Status = 0); //PR: 17/02/2011 Allow update of SerialBatch record
         GenSetError(ValidCheck,30019,Result,ValidHed);
       end
       else
      {$ENDIF}
       begin
         ValidCheck:=(Status<>0);
         GenSetError(ValidCheck,30003,Result,ValidHed);
       end;
    end;

    if ValidCheck then
      OldCurr := MiscRecs.SerialRec.CurCost; //Retain old currency to check for currency change - if it changes we need
                                             //to reset the exchange rates.


    If (Not ByBatch) then
      BuyQty:=0  {no need to specify Byu Qty}
    else
    begin
      if SMode <> B_Update then //PR: 18/02/2011 Don't validate BuyQty when updating as could be 0 or -ve in Exchequer
      begin
        ValidCheck:=(BuyQty>0);
        GenSetError(ValidCheck,30004,Result,ValidHed);
      end;
    end;

    {$IFNDEF COMTK}
      KeyS:=Copy(InDoc,1,3);
      { 09.10.2000 - Closed for POR requested by ISN, approved by EL.
      ValidCheck:=(KeyS<>DocCodes[POR]) and (DocTypeFCode(KeyS) In PurchSplit);}
      //PR 12/11/02 Allow SCR as input doc (requested by Mario). 6/12/02 Add SJC + ADJ
      //16/04/03 Add WOR for Cooper Parry
      ValidCheck:=(DocTypeFCode(KeyS) In PurchSplit+[SCR, SJC, ADJ, WOR, SRN]);
      GenSetError(ValidCheck,30005,Result,ValidHed);
    {$ELSE}
      // HM 12/03/01: Extended for COM Toolkit to support no input doc, and ADJ/POR input docs
      //PR: 17/02/2011 If updating then don't validate doc type - it can't be set in tk update object and
      //isn't validated in Exchequer so could be totally invalid.
      If (Trim(InDoc) <> '') and (SMode <> B_Update) Then Begin
        KeyS:=Copy(InDoc,1,3);
        ValidCheck:=(DocTypeFCode(KeyS) In [SCR, SJC, ADJ, WOR, SRN] + PurchSplit);
      End; { If (Trim(KeyS) <> '') }
    {$ENDIF}
    GenSetError(ValidCheck,30005,Result,ValidHed);


    {$IFDEF COMTK}
    // HM 12/03/01: Extended for COM Toolkit to support no input doc
    //PR: 17/02/2011 If updating then don't validate doc type - it can't be set in tk update object and
    //isn't validated in Exchequer so could be totally invalid.
    If (Trim(InDoc) <> '') and (SMode <> B_Update) Then
    {$ENDIF}
    Begin
      KeyS:=LjVar(InDoc,DocLen);
      ValidCheck:=CheckRecExsists(KeyS,InvF,InvOurRefK);
      If (ValidCheck) then
        InDocFolio:=Inv.FolioNum
      else
        InDocFolio:=0;

      GenSetError(ValidCheck,30006,Result,ValidHed);

      ValidCheck:=(BuyLine>0) and ((DocTypeFCode(KeyS) <> WOR) or (BuyLine = 1));  {* Id ABSLine No *}
//      ValidCheck:=(BuyLine>0);  {* Id ABSLine No *}
      GenSetError(ValidCheck,30007,Result,ValidHed);

      {Check by Folio+LineNo in IDetailsF }
      KeyS:=FullIDKey(Inv.FolioNum,BuyLine);
      ValidCheck:=CheckRecExsists(KeyS,IDetailF,IdLinkK);
      GenSetError(ValidCheck,30008,Result,ValidHed);
    End;

    {In Location ..}
    //PR: 17/02/2011 If updating then don't validate location - it can't be set in tk update object and
    //could be blank in exchequer if doc isn't populated.
    ValidCheck:=((EmptyKey(InMLoc,LocKeyLen)) and (Not Syss.UseMLoc)) or (SMode = B_Update);

    If (Not ValidCheck) then
      ValidCheck:=(CheckRecExsists(MLocFixCode[True]+LJVar(InMLoc,LocKeyLen),MLocF,MLK));

    GenSetError(ValidCheck,30009,Result,ValidHed);

    {InDate}
    //PR: 17/02/2011 If updating then don't validate date in - it can't be set in tk update object and
    //could be blank in exchequer if doc isn't populated.
    If (DateIn<>'') and (SMode <> B_Update) then
    begin
//      DateStr(DateIn,Td,Tm,Ty);
//      ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));
      //PR: 17/02/2011 Change to use correct validation
      ValidCheck := ValidDate(DateIn);
      GenSetError(ValidCheck,30010,Result,ValidHed);
    end;

    {Cost Price Currency ...}
    ValidCheck:=BOn;
    If (ExSyss.MCMode) then
      ValidCheck:=((CurCost>=1) and (CurCost<=CurrencyType))
    else
      CurCost:=0;

    GenSetError(ValidCheck,30011,Result,ValidHed);


    If (ExSyss.MCMode) then
      CurSell:=CurCost
    else
      CurSell:=0;


    {Currency Rates..}
    If (ExSyss.MCMode) and (SMode <> B_Update) then
    Begin
      ValidCheck:=(SerCRates[BOn]<>0);
      GenSetError(ValidCheck,30012,Result,ValidHed);

      If (Not UseCoDayRate) then
      Begin
        ValidCheck:=(SerCRates[BOff]<>0);
        GenSetError(ValidCheck,30013,Result,ValidHed);
      end;

      {* Set to floating ... Need to Confirm !!!
      If (Not (Inv.InvDocHed In NomSplit)) then
        CXRate[BOff]:=0;
      *}

    end
    else
    Begin
      {to confirm which currency should be used }
      //PR: 17/02/2011 if updating and currency changed then set ex rate automatically
      if (SMode <> B_Update) or (OldCurr <> CurCost) then
      begin
        SerCRates:=SyssCurr^.Currencies[CurCost].CRates;
        SetTriRec(CurCost,SUseORate,SerTriR);  { for v4.31 }
      end;
    end; {if..}

    {InOrdDoc... Must be POR }
    //PR: 17/02/2011 If updating then don't validate doc type - it can't be set in tk update object and
    //isn't validated in Exchequer so could be totally invalid.
    If (Not EmptyKey(InOrdDoc,DocLen)) and (SMode <> B_Update) then
    begin
      KeyS:=Copy(InOrdDoc,1,3);
      ValidCheck:=(KeyS=DocCodes[POR]);    {* must be POR *}
      GenSetError(ValidCheck,30014,Result,ValidHed);

      KeyS:=LjVar(InOrdDoc,DocLen);
      ValidCheck:=CheckRecExsists(KeyS,InvF,InvOurRefK);
      GenSetError(ValidCheck,30015,Result,ValidHed);      {* must exist *}

      ValidCheck:=(InOrdLine>0);  {* Order Line No *}
      GenSetError(ValidCheck,30016,Result,ValidHed);

      {Check by Folio+LineNo in IDetailF }
      KeyS:=FullIDKey(Inv.FolioNum,InOrdLine);
      ValidCheck:=CheckRecExsists(KeyS,IDetailF,IdLinkK);
      GenSetError(ValidCheck,30017,Result,ValidHed);

    end; {if..}

    {* Check DateUseX *}
    //PR: 17/11/2011 Exchequer can save Use By Date (DateUseX) to '00000000', so allow through ABSEXCH-11968/12153
    If (DateUseX<>'') and (DateUseX <> '00000000') then
    begin
//      DateStr(DateUseX,Td,Tm,Ty);
//      ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));
      //PR: 17/02/2011 Change to use correct validation
      ValidCheck := ValidDate(DateUseX);
      GenSetError(ValidCheck,30018,Result,ValidHed);
    end;

    {* --------- Save ------------ *}
    If (Result=0) and (SMode<>CheckMode) then
    begin
      SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);  { In BTKeys1U but with PF_On  }
      TMiscRec.RecMfix:=MFIFOCode;
      TMiscRec.SubType:=MSERNSub;
      if SMode <> B_Update then
        NLineCount:=1;  //PR: 17/02/2011 If updating then keep existing notes line count.


      //PR: 09/02/2011 NoteFolio wasn't being set - this is used to link child batch records to their parent
      //PR: 25/09/2014 ABSEXCH-15655 This needs to be done before MiscRecs^:=TMiscRec
      if ByBatch and (SMode <> B_Update) then
        GetNextCount(SKF,BOn,BOff,0, NoteFolio, '');


      MiscRecs^:=TMiscRec;

      {$IFDEF COMTK}
      if SMode = B_Update then
        Status := Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0)
      else
      {$ENDIF}
      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);
      ValidCheck:=(Status=0);

      GenSetError(ValidCheck,30100+Status,Result,ValidHed);

      { To update Serial Qty in the transaction line }
      { 03.11.2000 - added for internal usage. Default = False = Update it }

      //PR: 25/11/2011 Added to allow updating a batch to update the tlSerialQty ABSEXCH-
      If (Not WordBoolToBool(ExSer.DoNotUpdateTL)) and ((SMode <> B_Update) or ByBatch) then
      begin
        //PR: Moved code for finding line into FindTransLine function above as we need to check the
        //line earlier to see whether it has a job code or not. ABSEXCH=10254

        If LineFound then
        With Id do
        begin
          //PR: 11/10/2012 ABSEXCH-13371 SerialQty wasn't getting updated for lines with Serial No because
          //BuyQty is only populated on Batches
          if ByBatch then
          begin
            if (SMode = B_Update) then
              SerialQty:=SerialQty + UpdateQty  //PR: 24/11/2011
            else
              SerialQty:=SerialQty+ExSer.BuyQty;
          end
          else //PR: 30/10/2013 ABSEXCH-14707/ABSEXCH-14400 Was previously setting SerialQty to 1 rather than adding 1.
            SerialQty := SerialQty + 1;

          Status:=Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK);

          ValidCheck:=(Status=0);
          GenSetError(ValidCheck,30020,Result,ValidHed);


          //PR: ABSEXCH-12379 Need to update cost on stock record when adding serial batch. (ReOrder and Stock location
          //don't get updated until delivery.}
          //PR: 28/02/2012 ABSEXCH-12555 (ABSWEXWEBEX-2359): 1. Don't set cost if we have a job code. 2. Use ex rates
          //from transaction if appropriate
          //PR: 24/05/2012 ABSEXCH-12919 Shouldn't set cost price for SerialBatchAverage.
          if (Result= 0) and (Trim(JobCode) = '') and (Stock.SerNoWAvg <> 1) then
          begin
            if StockLocked then
            with ExSer do
            begin
              //If we're overwriting exchange rates or we have a company rate system then take rate from currency table.
              if ExSyss.UseExCrRate or not UseCoDayRate then
                Stock.CostPrice:=Round_Up(Currency_ConvFT(SerCost,CurCost,Stock.PCurrency,UseCoDayRate)*Stock.BuyUnit,Syss.NoCosDec)
              else
              begin
                //Take rate from line
                NewAmnt := Conv_TCurr(SerCost,Inv.CXRate[UseCoDayRate],CurCost,0,BOff);

                Stock.CostPrice := Conv_TCurr(NewAmnt,SyssCurr^.Currencies[Stock.PCurrency].CRates[UseCoDayRate],Stock.PCurrency,0,BOn);
              end;
              Status:=Put_Rec(F[StockF],StockF,RecPtr[StockF]^,0);
            end
            else
              Status := 84;

            ValidCheck:=(Status=0);
            GenSetError(ValidCheck,30021,Result,ValidHed);
          end;

        end; {if..}

      end; { if DoNotUpdateTL..}

      if StockLocked then
        Find_Rec(B_Unlock, F[StockF], StockF, RecPtr[StockF]^, 0, KeyS);

      TmpStat:=Presrv_BTPos(IDetailF,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);
      TmpStat:=Presrv_BTPos(InvF,TmpInvKPath,TmpInvFn,TmpInvRecAddr,BOn,BOff);

      TmpStat:=Presrv_BTPos(StockF,TmpStockKPath,TmpStockFn,TmpStockRecAddr,BOn,BOff);



    end; {if Result=0 ..}

  end; {with..}

  //PR: 25/01/2012 ABSEXCH-12440 After CheckRecExists line record was added to cache, but not cleared so if this is called
  //again for the same line then tlSerialQty isn't updated. Clear cache so next time we re-read the line from the db.
  ClearCRECache;

end; {func..}

{* -------- Store Serial/Batch No ----------- *}

FUNCTION EX_STORESERIALBATCH(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHMODE   :  SMALLINT)  :  SMALLINT;
{ Ex_StoreSerialBatch is only for IN Serial/Batch No. i.e. only Purchases Document
  and Buy Qty. should be assigned and it will always be inserted as new line,
  there is no calculation of total inserted qty to be updated in the transaction
  line .. }

Var
  SerRec  :  ^TBatchSerialRec;

begin
  LastErDesc:='';
  If TestMode then
  begin
    SerRec:=P;
    ShowMessage('Ex_StoreSerialNo : ' + #10#13 +
                'P^.SerialNo    : ' + SerRec^.SerialNo + #10#13 +
                'P^.BatchNo     : ' + SerRec^.BatchNo + #10#13 +
                'PSize: ' + IntToStr(PSize));
  end; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchSerialRec)) then
  Begin

    SerRec:=P;
    {* Convertion and Validation ..*}
    Result:=StoreExSerToSer(SerRec^, SearchMode );

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(96,Result);

end;  {func..}


{* UseSerialBatch conversion from External record to Exch. Record *}
function UseExSerToSer(ExSer  :  TBatchSerialRec;
                       SMode  :  SmallInt)  :  Integer;

{ IN information has to be assigned so that Buy Qty can be used for validation
  of Sold Status }

Const
  Fnum   =  MiscF;
  Fnum1  =  IDetailF;

  KeySSub  =  MFIFOCode+MSernSub;

  KPath    :  Array[BOff..BOn] of Integer  = (MiscNdxK,MiscBtcK);

  SrNoLen  =  20;
  BatchLen =  10;

Var
  ByBatch,
  FindBatch,
  ValidCheck,
  ValidHed    :  Boolean;

  TLKey,
  KeyChk,
  KeyS        :  Str255;

  Td,Tm,Ty    :  Word;

  TmpFn     :  FileVar;

  TmpStat,
  TmpKPath
            :  Integer;

  OutDocFolio,
  TmpRecAddr,
  TrecAddress :  LongInt;

  Locked      : Boolean;
  SoldChar    : Char;

  //PR: 27/02/2012 ABSEXCH-12023
  sOurRef     : Str255;
  InvRecAddr  : longint;
  InvKPath    : Integer;
  InvFileVar  : FileVar;

  // Check the Batch Record matches the specified criteria
  Function WantBatch : Boolean;
  Begin { WantBatch }
    With MiscRecs^ Do
      Result := (SerialRec.StkFolio = Stock.StockFolio) And                   // Stock Folio Number
                (Not MiscRecs^.SerialRec.BatchChild) And                      // Batch Headers Only
               ((Not Syss.UseMLoc) Or (SerialRec.InMLoc = ExSer.InMLoc)) And  // Check Location Code if used
               (Trim(SerialRec.InDoc) = Trim(ExSer.InDoc)) and
               (SerialRec.BuyLine = ExSer.BuyABSLine); {and
               ((SerialRec.BuyQty - SerialRec.QtyUsed) >= ExSer.QtyUsed);}     // Enough available
  End; { WantBatch }

begin
  LastErDesc:='';
  ValidCheck:=BOff;
  ValidHed:=BOn;
  Result:=0;

  ReSetRec(Fnum);
  With MiscRecs^.SerialRec do
  begin

    ExSer.SerialNo:=LJVar(UpCaseStr(Strip('B',[#32],ExSer.SerialNo)),SrNoLen);
    ExSer.BatchNo:=LjVar(UpCaseStr(Strip('B',[#32],ExSer.BatchNo)),BatchLen);

    {Batch Record without Serial No}
    ByBatch:=(EmptyKey(ExSer.SerialNo,SrNOLen));

    {* must be Update or Internal usage for Check or Import Mode *}
    If (Not (SMode In [B_Update, CheckMode, ImportMode])) then
      SMode:=B_Update;

    {* Stock Code .... *}
    KeyS:=LJVar(UpCaseStr(ExSer.StockCode),StkLen);
    ValidCheck:=CheckRecExsists(KeyS,StockF,StkCodeK);
    GenSetError(ValidCheck,30001,Result,ValidHed);

    {* Type must be P/M/X *}
    ValidCheck:=(Stock.StockType In [StkStkCode,StkDListCode,StkBillcode]);
    GenSetError(ValidCheck,30002,Result,ValidHed);

    If (ExSer.RecPos <> 0) And ByBatch Then Begin
      // Record Position is set - use it to find the correct Batch record
      Move(ExSer.RecPos,MiscRecs^,SizeOf(ExSer.RecPos));
      UseVariant(F[FNum]);
      Status := GetDirect(F[FNum],FNum,RecPtr[FNum]^,KPath[ByBatch],0);
      If (Status = 0) Then
        // Check that it is a valid record
        If (Not WantBatch) Then
          Status := 1;
    End { If (ExSerRec.RecPos <> 0) Then }
    Else
      // Load the Serial/Batch record the conventional way
      Status := -1;

    If (Status <> 0) Then Begin
      if WordBoolToBool(ExSer.Sold) then
        SoldChar := #1
      else
        SoldChar := #0;

      {* Serial No or Batch No should be assigned *}
      If (Not ByBatch) then
        //PR 17/12/01 Bugfix - make sure that serialno is for correct stock item
//        KeyS:=KeySSub+FullNomKey(Stock.StockFolio)+Char(Ord(ExSer.Sold))+ExSer.SerialNo
        KeyS:=KeySSub+FullNomKey(Stock.StockFolio)+SoldChar+ExSer.SerialNo
      else
        KeyS:=KeySSub+ExSer.BatchNo;

      {* If By Serial, the record must exist and has not been sold *}
      If (Not ByBatch) then
      begin
        // Serial Numbers
        UseVariant(F[FNum]);
        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,{KPath[ByBatch]}MIK,KeyS);
        ValidCheck:=(Status=0);
      end
      else
      begin
        // Batch Numbers
        KeyChk:=KeyS;
        FindBatch:=BOff;
        UseVariant(F[FNum]);
        Status := Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KPath[ByBatch],KeyS);
        While (Status = 0) And (Not FindBatch) do begin
          (* HM 06/09/01: Extended for more accurate (correct!) checking
          ValidCheck:=(CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and
                       (MiscRecs^.SerialRec.StkFolio=Stock.StockFolio);
          *)
          ValidCheck := (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) And             // Batch Number
                        WantBatch;

          FindBatch:=(Status=0) and (ValidCheck);

          If (Status = 0) And (Not FindBatch) Then
          begin
            UseVariant(F[FNum]);
            Status := Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KPath[ByBatch],KeyS);
          end;
        end; {while..}

        ValidCheck:=FindBatch;

      end; {if..}
    End; { If (Result <> 0) }

    GenSetError(ValidCheck,30003,Result,ValidHed);

    {* Sold status must be False *}
    //PR 8/11/05 - except if coming in on an SRN, in which case Sold must be true.
    ValidCheck:=(Not MiscRecs^.SerialRec.Sold) {$IFDEF COMTK}xor (DocTypeFCode(Copy(ExSer.ReturnDoc,1,3)) = SRN){$ENDIF};
    GenSetError(ValidCheck,30004,Result,ValidHed);

    { Check OUT Document }
    KeyS:=Copy(ExSer.OutDoc,1,3);
    { 18.07.2000 - Allow SOR requested by Simply Business ...
    ValidCheck:=(KeyS<>DocCodes[SOR]) and (DocTypeFCode(KeyS) In SalesSplit);}
    //PR 21/02/03 Add Adjs for Malta

    //PR: 31/10/2011 v6.9 Added PCR, PRF & PJC. ABSEXCH-11953
    ValidCheck:=(DocTypeFCode(KeyS) In SalesSplit + StkAdjSplit + [WOR, PRN, PCR, PRF, PJC]);

    GenSetError(ValidCheck,30005,Result,ValidHed);

    KeyS:=LjVar(ExSer.OutDoc,DocLen);
    ValidCheck:=CheckRecExsists(KeyS,InvF,InvOurRefK);

    {03.11.2000 }
    If (ValidCheck) then
      OutDocFolio:=Inv.FolioNum
    else
      OutDocFolio:=0;

    GenSetError(ValidCheck,30006,Result,ValidHed);

    ValidCheck:=(ExSer.SoldABSLine>0) and ((DocTypeFCode(KeyS) <> WOR) or (ExSer.SoldABSLine <> 1));  {* Id Line No *}
//    ValidCheck:=(ExSer.SoldABSLine>0);  {* Id Line No *}
    GenSetError(ValidCheck,30007,Result,ValidHed);

    {Check by Folio+LineNo in IDetailsF }
    TLKey:=FullIDKey(Inv.FolioNum,ExSer.SoldABSLine);
    {Closed on 19.07.2000 for getting error 44 if this function is used immediately after
     Ex_StoreTrans with B_Update...
    ValidCheck:=CheckRecExsists(TLKey,IDetailF,IdLinkK);}

    Status:=Find_Rec(B_GetEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK,TLKey);
    GenSetError(ValidCheck,30008,Result,ValidHed);

    {Out Location ..}
    ValidCheck:=((EmptyKey(ExSer.OutMLoc,LocKeyLen)) and (Not Syss.UseMLoc));

    If (Not ValidCheck) then
      ValidCheck:=(CheckRecExsists(MLocFixCode[True]+LJVar(ExSer.OutMLoc,LocKeyLen),MLocF,MLK));

    GenSetError(ValidCheck,30009,Result,ValidHed);

    {OutDate}
    DateStr(ExSer.DateOut,Td,Tm,Ty);
    ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));
    GenSetError(ValidCheck,30010,Result,ValidHed);

   {Selling Price Currency ...}
    ValidCheck:=BOn;
    If (ExSyss.MCMode) then
      ValidCheck:=((ExSer.CurSell>=1) and (ExSer.CurSell<=CurrencyType))
    else
      ExSer.CurSell:=0;

    GenSetError(ValidCheck,30011,Result,ValidHed);

    {Currency Rates..}
    If (ExSyss.MCMode) then
    Begin

      ValidCheck:=(ExSer.CoRate<>0);
      GenSetError(ValidCheck,30012,Result,ValidHed);

      If (Not UseCoDayRate) then
      Begin
        ValidCheck:=(ExSer.DailyRate<>0);
        GenSetError(ValidCheck,30013,Result,ValidHed);
      end;

      {* Set to floating ... Need to Confirm !!!
      If (Not (Inv.InvDocHed In NomSplit)) then
        CXRate[BOff]:=0;
      *}

    end
    else
    Begin
      {to confirm which currency should be used }
      ExSer.CoRate:=SyssCurr^.Currencies[CurCost].CRates[BOn];
      ExSer.DailyRate:=SyssCurr^.Currencies[CurCost].CRates[BOff];

    end; {if..}

    {OutOrdDoc...}
    If (Not EmptyKey(ExSer.OutOrdDoc,DocLen)) then
    begin
      KeyS:=Copy(ExSer.OutOrdDoc,1,3);
      ValidCheck:=(KeyS=DocCodes[SOR]);    {* must be SOR *}
      GenSetError(ValidCheck,30014,Result,ValidHed);

      KeyS:=LjVar(ExSer.OutOrdDoc,DocLen);
      ValidCheck:=CheckRecExsists(KeyS,InvF,InvOurRefK);
      GenSetError(ValidCheck,30015,Result,ValidHed);      {* must exist *}

      ValidCheck:=(ExSer.OutOrdLine>0);  {* Order Line No *}
      GenSetError(ValidCheck,30016,Result,ValidHed);

      {Check by Folio+LineNo in IDetailF }
      KeyS:=FullIDKey(Inv.FolioNum,ExSer.OutOrdLine);
      ValidCheck:=CheckRecExsists(KeyS,IDetailF,IdLinkK);
      GenSetError(ValidCheck,30017,Result,ValidHed);

    end; {if..}

    {* Check DateUseX *}
    //PR: 17/11/2011 Exchequer can save Use By Date (DateUseX) to '00000000', so allow through ABSEXCH-11968/12153
    If (ExSer.DateUseX<>'') and (DateUseX <> '00000000') then
    begin
      DateStr(ExSer.DateUseX,Td,Tm,Ty);
      ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));
      GenSetError(ValidCheck,30018,Result,ValidHed);
    end;

    {* 22.09.99 - Check for QtyUsed because it has to be updated in TL record *}
    // HM 06/09/01: Changed to test for > 0 only - code does not correctly handle - quantties
    ValidCheck := (ExSer.QtyUsed > 0);
    GenSetError(ValidCheck,30019,Result,ValidHed);

    {* --------- Save ------------ *}
    // HM 06/09/01: Added record locking
    If (Result=0) and (SMode<>CheckMode) then
    begin
      Locked:=BOff;
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,KPath[ByBatch],FNum,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    End; { If (Result=0) and (SMode<>CheckMode) }

    If (Result=0) and (SMode<>CheckMode) then
    begin
      If (Not ByBatch) then
      begin

        OutDoc:=ExSer.OutDoc;          {Sales TransDocNo.}
        SoldLine:=ExSer.SoldABSLine;      {to be replaced with Id.ABSLineNo.}
        DateOut:=ExSer.DateOut;        {Date}
        SerSell:=ExSer.SerSell;        {Selling Price}
        CurSell:=ExSer.CurSell;        {Currency}
        OutMLoc:=ExSer.OutMLoc;        {Location}
        {QtyUsed:=ExSer.QtyUsed;        {Quantity}
        QtyUsed:=0;
        OutOrdDoc:=ExSer.OutOrdDoc;    {SOR No.}
        OutOrdLine:=ExSer.OutOrdLine;  {SOR Line No.}
        Sold:=BOn;
        SerCRates[BOn]:=ExSer.CoRate;
        SerCRates[BOff]:=ExSer.DailyRate;
        {$IFDEF COMTK}
        RetDoc := ExSer.ReturnDoc;
        RetDocLine := ExSer.ReturnDocLine;
        BatchRetQty := ExSer.BatchRetQty;
        ReturnSNo := ExSer.Returned;
        {$ENDIF}
        SetTriRec(CurCost,SUseORate,SerTriR);  { for v4.31 }

        DateUseX:=ExSer.DateUseX;

      end
      else
      begin
        QtyUsed:=QtyUsed+ExSer.QtyUsed;
        Sold:=(BuyQty<=QtyUsed);
      end; {if..}

      SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);  { In BTKeys1U but with PF_On  }

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KPath[ByBatch]);

      ValidCheck:=(Status=0);
      GenSetError(ValidCheck,30100+Status,Result,ValidHed);

      {* Create New Line with BatchChild:=True *}
      If (ByBatch) then
      begin
        QtyUsed:=ExSer.QtyUsed;
        BatchChild:=BOn;
        NLineCount:=1;

        //PR: 09/02/2011 Need to set ChildNFolio to link to parent batch. (ABSEXCH-9346)
        ChildNFolio := NoteFolio;
        NoteFolio := 0;


        OutDoc:=ExSer.OutDoc;          {Sales TransDocNo.}
        SoldLine:=ExSer.SoldABSLine;      {to be replaced with Id.ABSLineNo.}
        DateOut:=ExSer.DateOut;        {Date}
        SerSell:=ExSer.SerSell;        {Selling Price}
        CurSell:=ExSer.CurSell;        {Currency}
        OutMLoc:=ExSer.OutMLoc;        {Location}
        OutOrdDoc:=ExSer.OutOrdDoc;    {SOR No.}
        OutOrdLine:=ExSer.OutOrdLine;  {SOR Line No.}
        Sold:=BOn;
        SerCRates[BOn]:=ExSer.CoRate;
        SerCRates[BOff]:=ExSer.DailyRate;

        SetTriRec(CurCost,SUseORate,SerTriR);  { for v4.31 }

        DateUseX:=ExSer.DateUseX;

        SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);  { In BTKeys1U but with PF_On  }

        Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

        ValidCheck:=(Status=0);
        GenSetError(ValidCheck,30200+Status,Result,ValidHed);

      end; {If ByBatch ..}

      { 03.11.2000 - added for internal usage. Default = False = Update it }

      If (Not WordBoolToBool(ExSer.DoNotUpdateTL)) then
      begin

        TmpFn:=F[Fnum1];
        TmpKPath:=GetPosKey;
        TmpStat:=Presrv_BTPos(Fnum1,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);

        {* 22.09.99 - Update TL's SerialQty field. *}

        {03.11.2000 - closed and used OutDocFolio
        TLKey:=FullIDKey(Inv.FolioNum,ExSer.SoldABSLine);}
        TLKey:=FullIDKey(OutDocFolio,ExSer.SoldABSLine);

        Status:=Find_Rec(B_GetEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK,TLKey);

       {Closed on 19.07.2000 for getting error 44 if this function is used immediately after
        Ex_StoreTrans with B_Update...
        ValidCheck:=CheckRecExsists(TLKey,IDetailF,IdLinkK);}

        ValidCheck:=(Status=0);

        If (ValidCheck) then
        With Id do
        begin
          //PR 24/04/03 On ADJs & WORs SerialQty can be negative
          if (Qty >= 0) then
            SerialQty:=SerialQty+Abs(ExSer.QtyUsed)
          else
            SerialQty:=SerialQty-Abs(ExSer.QtyUsed);

          //PR: 24/02/2012 Set line cost from Serial/Batch record. Need to update header total cost as well. ABSEXCH-12023
          //PR: 08/11/2012 ABSEXCH-13684 Extend for out stock adjustments.
          If (ExSyss.AutoSetStkCost) and ((Inv.InvDocHed In SalesSplit) or ((Inv.InvDocHed = ADJ) and (Id.Qty < 0))) then
          begin
            //Store current position in Inv file.
            TmpStat:=Presrv_BTPos(InvF,InvKPath,InvFileVar,InvRecAddr,BOff,BOff);

            //Find and lock invoice header record
            sOurRef := LjVar(ExSer.OutDoc, DocLen);
            Status := Find_Rec(B_GetEq + B_SingLock, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, sOurRef);
            if Status = 0 then
            begin
              //Remove old cost price from Inv total
              Inv.TotalCost := Inv.TotalCost - Round_Up(Id.Qty * Id.CostPrice, Syss.NoCosDec);

              //Serial cost -> Line cost
              Id.CostPrice := SerCost;

              //Add new cost to Inv total
              Inv.TotalCost := Inv.TotalCost + Round_Up(Id.Qty * Id.CostPrice, Syss.NoCosDec);

              //Save Inv header
              Status:=Put_Rec(F[InvF],InvF,RecPtr[InvF]^,InvOurRefK);

              //Restore file position
              TmpStat:=Presrv_BTPos(InvF,InvKPath,InvFileVar,InvRecAddr,BOn,BOff);
            end;

            ValidCheck := Status = 0;
            GenSetError(ValidCheck,30021,Result,ValidHed);
          end;


          Status:=Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK);
          ValidCheck:=(Status=0);
        end; {if..}

        TmpStat:=Presrv_BTPos(Fnum1,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

        GenSetError(ValidCheck,30020,Result,ValidHed);

      end; { if DoNotUpdateTL..}

    end; {if Result=0..}

  end; {with..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(97,Result);

end; {Ex_UseSerialBatch..}

{* ------------  Use Serial / Batch ------------- *}

FUNCTION EX_USESERIALBATCH(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHMODE   :  SMALLINT)  :  SMALLINT;

{ This function is only for OUT Serial/Batch No, i.e. for Sales TRansactions.
  If by Serial No, the line must exist and it will be updated as Sold Status.
  If by Batch, Batch No and Stock Code will be validated to be deducted and
  new Used line will be inserted. }

Var
  SerRec  :  ^TBatchSerialRec;

begin

  If TestMode then
  begin
    SerRec:=P;
    ShowMessage('Ex_UseSerialBatch : ' + #10#13 +
                'P^.SerialNo    : ' + SerRec^.SerialNo + #10#13 +
                'P^.BatchNo     : ' + SerRec^.BatchNo + #10#13 +
                'PSize: ' + IntToStr(PSize));
  end; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchSerialRec)) then
  Begin

    SerRec:=P;
    {* Convert and Do Validation ..*}
    Result:=UseExSerToSer(SerRec^, SearchMode);

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

end; {func..}

{* UnUseSerialBatch conversion from External record to Exch. Record *}
function UnUseExSerToSer(ExSer  :  TBatchSerialRec; Smode : SmallInt)  :  Integer;

{ IN information has to be assigned so that Buy Qty can be used for validation
  of Sold Status }

Const
  Fnum   =  MiscF;
  Fnum1  =  IDetailF;

  KeySSub  =  MFIFOCode+MSernSub;

  KPath    :  Array[BOff..BOn] of Integer  = (MiscNdxK,MiscBtcK);

  SrNoLen  =  20;
  BatchLen =  10;

Var
  ByBatch,
  FindBatch,
  ValidCheck,
  ValidHed    :  Boolean;

  TLKey,
  KeyChk,
  KeyS        :  Str255;

  Td,Tm,Ty    :  Word;

  TmpFn     :  FileVar;

  TmpStat,
  TmpKPath
            :  Integer;

  OutDocFolio,
  TmpRecAddr,
  TrecAddress,
  RetLineNo :  LongInt;

  Locked      : Boolean;

  //PR: 08/09/2014 ABSEXCH-15539
  BatchChildRecAddress : Integer;
  BatchFolioLink : Integer;

  // Check the Batch Record matches the specified criteria
  Function WantBatch : Boolean;
  Begin { WantBatch }
    With MiscRecs^ Do
      //PR: 08/09/2014 ABSEXCH-15539 Change to check child/parent folio link
      //PR: 25/09/2014 ABSEXCH-15655 Sometimes the folio link has not been set - in those cases
      //                             identify by In Doc, Stock and location
      if BatchFolioLink <> 0 then
        Result := BatchFolioLink = SerialRec.NoteFolio
      else
        Result := (SerialRec.StkFolio = Stock.StockFolio) And                   // Stock Folio Number
                  (SerialRec.InDoc = ExSer.InDoc) and
                  (Not MiscRecs^.SerialRec.BatchChild) And                      // Batch Headers Only
                 ((Not Syss.UseMLoc) Or (SerialRec.InMLoc = ExSer.InMLoc));  // Check Location Code if used
  End; { WantBatch }

  Function WantBatchChild : Boolean;
  Begin { WantBatch }
    With MiscRecs^ Do
    begin
      Result := (SerialRec.StkFolio = Stock.StockFolio) And                   // Stock Folio Number
                (MiscRecs^.SerialRec.BatchChild) And                      // Batch Headers Only
               ((Not Syss.UseMLoc) Or (SerialRec.InMLoc = ExSer.InMLoc));  // Check Location Code if used
      //Now check outdoc
      {$IFNDEF TC}
      Result := Result and (Trim(SerialRec.OutDoc) = Trim(ExSer.OutDoc));
      {$ELSE}
      Result := Result and (Trim(SerialRec.OutDoc) = Trim(ExSer.OutOrdDoc));
      {$ENDIF}

      //PR: 24/05/2012 ABSEXCH-11857 Extend to check Sold Line no.
      Result := Result and (SerialRec.SoldLine = ExSer.SoldABSLine);
    end;
  End; { WantBatch }


begin
  LastErDesc:='';
  ValidCheck:=BOff;
  ValidHed:=BOn;
  Result:=0;

  {Batch Record without Serial No}
  ByBatch:=(EmptyKey(ExSer.SerialNo,SrNOLen));

  //PR: 08/09/2014 ABSEXCH-15539 Moved code to find batch child here so that we can check the folio against
  //                             the parent folio
  if ByBatch then
  begin
    //Find child record
    FindBatch := False;
    //PR: 24/05/2012 ABSEXCH-11857 If we have the RecordPosition then use that, else use old way
    if ExSer.RecPos <> 0 then
    begin
      SetDataRecOfs(Fnum,ExSer.RecPos);
      Status := GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KPath[ByBatch],0);
      FindBatch := (Status = 0) and WantBatchChild;
    end;


    if not FindBatch then
    begin
      KeyS:=MakeSNKey(MiscRecs^.SerialRec.StkFolio,True{Sold},MiscRecs^.SerialRec.SerialNo);

      KeyChk:=KeyS;
      FindBatch:=BOff;
      Status := Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KPath[ByBatch],KeyS);

      While (Status = 0) And (Not FindBatch) do begin
        (* HM 06/09/01: Extended for more accurate (correct!) checking
        ValidCheck:=(CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and
                     (MiscRecs^.SerialRec.StkFolio=Stock.StockFolio);
        *)
        ValidCheck := (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) And             // Batch Number
                      WantBatchChild;

        FindBatch:=(Status=0) and (ValidCheck);

        If (Status = 0) And (Not FindBatch) Then
          Status := Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KPath[ByBatch],KeyS);
      end; {while..}
    end;

    if FindBatch then
    begin
      ValidCheck := True;
      
      //Store link to batch parent
      BatchFolioLink := MiscRecs^.SerialRec.ChildNFolio;

      //Store position of child record as we need to update or delete it below
      TmpKPath:=GetPosKey;
      TmpStat:=Presrv_BTPos(FNum, TmpKPath, F[FNum], BatchChildRecAddress, BOff, BOff);
    end;

    GenSetError(ValidCheck,30003,Result,ValidHed);
  end;

  ReSetRec(Fnum);

  //PR: 08/09/2014 ABSEXCH-15539 Don't want to continue if we didn't find BatchChild
  if ValidCheck or not ByBatch then
  With MiscRecs^.SerialRec do
  begin

    ExSer.SerialNo:=LJVar(UpCaseStr(Strip('B',[#32],ExSer.SerialNo)),SrNoLen);
    ExSer.BatchNo:=LjVar(UpCaseStr(Strip('B',[#32],ExSer.BatchNo)),BatchLen);


    {* must be Update or Internal usage for Check or Import Mode *}
    If (Not (SMode In [B_Update, CheckMode, ImportMode])) then
      SMode:=B_Update;

    {* Stock Code .... *}
    KeyS:=LJVar(UpCaseStr(ExSer.StockCode),StkLen);
    ValidCheck:=CheckRecExsists(KeyS,StockF,StkCodeK);
    GenSetError(ValidCheck,30001,Result,ValidHed);

    {* Type must be P/M/X *}
    ValidCheck:=(Stock.StockType In [StkStkCode,StkDListCode,StkBillcode]);
    GenSetError(ValidCheck,30002,Result,ValidHed);


    {* Serial No or Batch No should be assigned *}
    If (Not ByBatch) then
      //PR 17/12/01 Bugfix - make sure that serialno is for correct stock item
      KeyS:=KeySSub+FullNomKey(Stock.StockFolio)+Char(Ord(ExSer.Sold))+ExSer.SerialNo
    else
      KeyS:=KeySSub+ExSer.BatchNo;

    {* If By Serial, the record must exist and has been sold *}
    If (Not ByBatch) then
    begin
      // Serial Numbers
      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,{KPath[ByBatch]}MIK,KeyS);
      ValidCheck:=(Status=0);
    end
    else
    begin
      // Batch Numbers

      KeyChk:=KeyS;
      FindBatch:=BOff;
      Status := Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KPath[ByBatch],KeyS);
      While (Status = 0) And (Not FindBatch) do begin
        (* HM 06/09/01: Extended for more accurate (correct!) checking
        ValidCheck:=(CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and
                     (MiscRecs^.SerialRec.StkFolio=Stock.StockFolio);
        *)
        ValidCheck := (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) And             // Batch Number
                      WantBatch;

        FindBatch:=(Status=0) and (ValidCheck);

        If (Status = 0) And (Not FindBatch) Then
          Status := Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KPath[ByBatch],KeyS);
      end; {while..}

      ValidCheck:=FindBatch;

    end; {if..}

    GenSetError(ValidCheck,30003,Result,ValidHed);

    {* Sold status must be True *}

    if not ByBatch then
    begin
      ValidCheck:=(MiscRecs^.SerialRec.Sold);
      GenSetError(ValidCheck,30004,Result,ValidHed);
    end;


    ValidCheck := (ExSer.QtyUsed > 0);
    GenSetError(ValidCheck,30006,Result,ValidHed);

    {* --------- Save ------------ *}
    // HM 06/09/01: Added record locking
    If (Result=0) and (SMode<>CheckMode) then
    begin
      Locked:=BOff;
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,KPath[ByBatch],FNum,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    End; { If (Result=0) and (SMode<>CheckMode) }

    {$IFDEF TC}
        KeyChk := KeyS;
        RetLineNo := ExSer.SoldABSLine;
        KeyS:=LjVar(ExSer.OutDoc,DocLen);
        ValidCheck:=CheckRecExsists(KeyS,InvF,InvOurRefK);
        KeyS := KeyChk;
        {03.11.2000 }
        If (ValidCheck) then
          OutDocFolio:=Inv.FolioNum
        else
          OutDocFolio:=0;
    {$ENDIF}

    If (Result=0) and (SMode<>CheckMode) then
    begin
      //PR: 24/05/2012 ABSEXCH-11857 Moved assignment of RetLineNo and OutDocFolio so they are not only in Not ByBatch section.
      KeyChk := KeyS;
      RetLineNo := ExSer.SoldABSLine;
      KeyS:=LjVar(ExSer.OutDoc,DocLen);
      ValidCheck:=CheckRecExsists(KeyS,InvF,InvOurRefK);
      KeyS := KeyChk;
      {03.11.2000 }
      If (ValidCheck) then
        OutDocFolio:=Inv.FolioNum
      else
        OutDocFolio:=0;

      If (Not ByBatch) then
      begin
        Blank(OutDoc,Sizeof(OutDoc));
        Blank(DateOut,Sizeof(DateOut));
        Blank(OutMLoc,Sizeof(OutMLoc));
        SoldLine:=0;
        SerSell:=0;

        CurSell:=0;        {Currency}
        Blank(OutMLoc, SizeOf(OutMLoc));        {Location}
        QtyUsed:=0;
        Blank(OutOrdDoc, SizeOf(OutOrdDoc));    {SOR No.}
        OutOrdLine:=0;  {SOR Line No.}
        SerCRates[BOn]:=0;
        SerCRates[BOff]:=0;
        Blank(DateUseX, SizeOf(DateUseX));

        Sold:=False;

      end
      else
      begin
        QtyUsed:=QtyUsed - ExSer.QtyUsed;
        Sold:=(BuyQty<=QtyUsed);
      end; {if..}

      SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);  { In BTKeys1U but with PF_On  }

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KPath[ByBatch]);

      ValidCheck:=(Status=0);
      GenSetError(ValidCheck,30100+Status,Result,ValidHed);

      if ByBatch then
      begin
        //PR: 08/09/2014 ABSEXCH-15539 Moved code to find the child record to the start of the procedure

        if ValidCheck then
        begin
          //Reposition on batch child record
          TmpStat:=Presrv_BTPos(FNum, TmpKPath, F[FNum], BatchChildRecAddress, BOn, BOn);

          if QtyUsed = ExSer.QtyUsed then
            Status := Delete_Rec(F[Fnum], Fnum, KPath[ByBatch])
          else
          if QtyUsed < ExSer.QtyUsed then
            Status := 30005
          else
          begin
            Locked:=BOff;
            If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,KPath[ByBatch],FNum,SilentLock,Locked)) then
              Status:=0;
            // If not locked and user hits cancel return code 84
            if (Result = 0) and not Locked then
              Result := 84;

            if Result = 0 then
            begin
              QtyUsed := QtyUsed - ExSer.QtyUsed;
              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KPath[ByBatch]);
            end;

          end;
          //PR: 25/05/2012 ABSEXCH-11857 Don't add 30200 to successful save!
          if (Status <> 0) and (Status <> 30005) then
            Status := 30200 + Status;
          GenSetError(ValidCheck,Status,Result,ValidHed);
        end
        else
          GenSetError(ValidCheck,30200+Status,Result,ValidHed);

      end;

      {.$IFNDEF TC}

      If (Not WordBoolToBool(ExSer.DoNotUpdateTL)) then
      begin

        TmpFn:=F[Fnum1];
        TmpKPath:=GetPosKey;
        TmpStat:=Presrv_BTPos(Fnum1,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);

        {* 22.09.99 - Update TL's SerialQty field. *}

        {03.11.2000 - closed and used OutDocFolio
        TLKey:=FullIDKey(Inv.FolioNum,ExSer.SoldABSLine);}
        TLKey:=FullIDKey(OutDocFolio,RetLineNo);

        Status:=Find_Rec(B_GetEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK,TLKey);

       {Closed on 19.07.2000 for getting error 44 if this function is used immediately after
        Ex_StoreTrans with B_Update...
        ValidCheck:=CheckRecExsists(TLKey,IDetailF,IdLinkK);}

        ValidCheck:=(Status=0);

        If (ValidCheck) then
        With Id do
        begin
        {$IFNDEF TC}
//          SerialQty:=SerialQty + ExSer.QtyUsed;
          //PR: 28/02/2011 ABSEXCH-10955 On Sales transactions was increasing rather than decreasing SerialQty
          //Use DocCnst[Id.IdDocHed] as out Adjs have a negative SerialQty so can't just subtract QtyUsed.
          SerialQty:=SerialQty + (ExSer.QtyUsed * DocCnst[Id.IdDocHed]);
        {$ELSE}
          SerialQty:=SerialQty + ExSer.QtyUsed * DocCnst[Id.IdDocHed];
        {$ENDIF}
          Status:=Put_Rec(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdLinkK);
          ValidCheck:=(Status=0);
        end; {if..}

        TmpStat:=Presrv_BTPos(Fnum1,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

        GenSetError(ValidCheck,30020,Result,ValidHed);

      end; { if DoNotUpdateTL..}
      {.$ENDIF}



    end; {if Result=0..}

  end; {with..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(97,Result);

end; {Ex_UseSerialBatch..}



FUNCTION EX_UNUSESERIALBATCH(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHMODE   :  SMALLINT)  :  SMALLINT;

Var
  SerRec  :  ^TBatchSerialRec;

begin
  LastErDesc:='';
  If TestMode then
  begin
    SerRec:=P;
    ShowMessage('Ex_StoreSerialNo : ' + #10#13 +
                'P^.SerialNo    : ' + SerRec^.SerialNo + #10#13 +
                'P^.BatchNo     : ' + SerRec^.BatchNo + #10#13 +
                'PSize: ' + IntToStr(PSize));
  end; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchSerialRec)) then
  Begin

    SerRec:=P;
    {* Convertion and Validation ..*}
    Result:=UnUseExSerToSer(SerRec^, SearchMode);

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(96,Result);

end;  {func..}

function FindAndUpdateSerialBatch(ExSerRec   :  TBatchSerialRec;
                                  Currency   :  Byte;
                                  Cost,
                                  LCoRate,
                                  LDailyRate :  Double;
                                  WantDelete :  Boolean) : Integer;
Const
  Fnum  =  MiscF;

  KeySSub  =  MFIFOCode+MSernSub;

  {KPath    :  Array[BOff..BOn] of Integer  = (MiscBtcK,MiscNdxK);}

  KPath    :  Array[1..3] of Integer  = (MiscNdxK,MiscBtcK,MIK);  { Serial,Bathc,Stock}

  SrNoLen  =  20;
  BatchLen =  10;

var

  {BySerial,}
  ValidCheck,
  ValidHed,
  Locked      :  Boolean;

  KeyChk,
  KeyS,
  KeySk        :  Str255;

  StkStat     :  Integer;

  IndexBy     :  Byte;

begin

  ValidCheck:=BOff;
  ValidHed:=BOn;
  Result:=0;

  if not DataIsOpen then
    Result := 3
  else
  With ExSerRec do
  begin
    (*
    {* By Serial No *}
    BySerial:=(Not Emptykey(SerialNo,SrNoLen));

    {* Find Record *}
    KeyS:='';
    If (BySerial) then
      KeyS:=KeySSub+LJVar(UpCaseStr(Strip('B',[#32],SerialNo)),SrNoLen)
    else
      KeyS:=KeySSub+LJVar(UpCaseStr(Strip('B',[#32],BatchNo)),BatchLen);
    *)

    If (Not Emptykey(SerialNo,SrNoLen)) then
      IndexBy:=1
    else
      If (Not EmptyKey(BatchNo,BatchLen)) then
        IndexBy:=2
      else
{        If (Not EmptyKey(StockCode,StkLen)) then
          IndexBy:=3
        else}
          IndexBy:=0;

    ValidCheck:=(IndexBy In [1..2]);

    GenSetError(ValidCheck,30002,Result,ValidHed);

    if ValidCheck then
    begin

      If (ExSyss.MCMode) and not WantDelete then
        ValidCheck:=((Currency>=1) and (Currency <=CurrencyType))
      else
        Currency:=0;

      GenSetError(ValidCheck,30004,Result,ValidHed);
    end;

    If ValidCheck and (ExSyss.MCMode) then
    Begin
      if not WantDelete then
      begin
        ValidCheck:=(LDailyRate<>0);
        GenSetError(ValidCheck,30005,Result,ValidHed);

        If (Not UseCoDayRate) then
        Begin
          ValidCheck:=(LCoRate<>0);
          GenSetError(ValidCheck,30006,Result,ValidHed);
        end;

      end;
    end
    else
    Begin
      {to confirm which currency should be used }
      LCoRate:=SyssCurr^.Currencies[CurCost].CRates[Boff];
      LDailyRate:=SyssCurr^.Currencies[CurCost].CRates[BOn];
    end; {if..}


    If (ValidCheck) then
    begin

      Case IndexBy of
        1 : KeyS:=KeySSub+LJVar(UpCaseStr(Strip('B',[#32],SerialNo)),SrNoLen);
        2 : KeyS:=KeySSub+LJVar(UpCaseStr(Strip('B',[#32],BatchNo)),BatchLen);
      end; {Case..}

      KeyChk:=KeyS;

      if RecPos <> 0 then
      begin
        Move(RecPos,MiscRecs^,SizeOf(RecPos));
        UseVariant(F[Fnum]);
        Status := GetDirect(F[FNum],FNum,RecPtr[FNum]^,KPath[IndexBy],0);
        ValidCheck := (Status = 0) and (BatchNo = MiscRecs^.SerialRec.BatchNo) or (SerialNo = MiscRecs^.SerialRec.SerialNo);
      end;

      if Status <> 0 then
      begin
        UseVariant(F[Fnum]);
        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KPath[IndexBy],KeyS);

        ValidCheck:=(Status=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));
      end;

      if ValidCheck then
      begin
        KeySk:=LJVar(UpperCase(StockCode),StkLen);
        ValidCheck:=CheckRecExsists(KeySk,StockF,StkCodeK) and (Trim(StockCode) <> '');
        GenSetError(ValidCheck,30003,Result,ValidHed);
        If (ValidCheck) then
        begin
          //Found the right serial no, and stock exists. Now need to make sure we have the right stockcode
          ValidCheck := (Stock.StockFolio = MiscRecs^.SerialRec.StkFolio);

          while not ValidCheck and (Status=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
          begin
            UseVariant(F[Fnum]);
            Status := Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KPath[IndexBy],KeyS);

            ValidCheck :=(Status=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and
              (Stock.StockFolio = MiscRecs^.SerialRec.StkFolio)
          end;

          GenSetError(ValidCheck,30001,Result,ValidHed);
        end;
      end;

      if Status = 0 then
      begin
        UseVariant(F[Fnum]);
        If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,KPath[IndexBy],FNum,SilentLock,Locked)) then
          Status:=0;
      // If not locked and user hits cancel return code 84
        if (Status = 0) and not Locked then
        begin
          Status := 84;
          Result := 84;
        end;
      end;


      if Status = 0 then
      begin
        if WantDelete then
          Result := Delete_Rec(F[Fnum], Fnum, KPath[IndexBy])
        else
        begin
          MiscRecs^.SerialRec.SerCost := Cost;
          MiscRecs^.SerialRec.CurCost := Currency;
          MiscRecs^.SerialRec.SerCRates[Boff] := LCoRate;
          MiscRecs^.SerialRec.SerCRates[Bon] := LDailyRate;
          SetTriRec(Currency,MiscRecs^.SerialRec.SUseORate,MiscRecs^.SerialRec.SerTriR);

          Result := Put_Rec(F[Fnum], FNum, RecPtr[FNum]^, KPath[IndexBy]);
        end;
      end;

    end; {if..}
  end; //with
end;



FUNCTION EX_DELETESERIALBATCH(P            :  POINTER;
                              PSIZE        :  LONGINT)  :  SMALLINT;
                              {$IFDEF WIN32} STDCALL; {$ENDIF}
Var
  SerRec  :  ^TBatchSerialRec;

begin
  LastErDesc:='';
  If TestMode then
  begin
    SerRec:=P;
    ShowMessage('Ex_DeleteSerialBatch : ' + #10#13 +
                'P^.SerialNo    : ' + SerRec^.SerialNo + #10#13 +
                'P^.BatchNo     : ' + SerRec^.BatchNo + #10#13 +
                'PSize: ' + IntToStr(PSize));
  end; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchSerialRec)) then
  Begin

    SerRec:=P;
    {* Convertion and Validation ..*}
    Result:=FindAndUpdateSerialBatch(SerRec^, 0, 0, 0, 0, True{Delete});

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(179,Result);

end;  {func..}

FUNCTION EX_UPDATESERIALBATCHCOST(P            :  POINTER;
                                  PSIZE        :  LONGINT;
                                  CURRENCY     :  SMALLINT;
                                  COST         :  DOUBLE;
                                  DAILYRATE    :  DOUBLE;
                                  COMPANYRATE  :  DOUBLE)  :  SMALLINT;
                                  {$IFDEF WIN32} STDCALL; {$ENDIF}
Var
  SerRec  :  ^TBatchSerialRec;

begin
  LastErDesc:='';
  If TestMode then
  begin
    SerRec:=P;
    ShowMessage('Ex_UpdateSerialBatchCost : ' + #10#13 +
                'P^.SerialNo    : ' + SerRec^.SerialNo + #10#13 +
                'P^.BatchNo     : ' + SerRec^.BatchNo + #10#13 +
                'PSize: ' + IntToStr(PSize));
  end; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchSerialRec)) then
  Begin

    SerRec:=P;
    {* Convertion and Validation ..*}
    Result:=FindAndUpdateSerialBatch(SerRec^, Currency, Cost, CompanyRate, DailyRate, False);

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(180,Result);

end;  {func..}


end.

