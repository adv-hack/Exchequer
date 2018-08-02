unit DllConv;
{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

function SP_CHECKCONVERSION(P     : Pointer;
                            PSize : longint;
                            Consolidate : Boolean) : SmallInt;
                            STDCALL  EXPORT;

function SP_CONVERTTRANSACTION(P     : Pointer;
                               PSize : longint;
                               Consolidate : Boolean) : SmallInt;
                            STDCALL  EXPORT;

function SP_COPYTRANSACTION(RefNo : PChar) : SmallInt;
                            STDCALL  EXPORT;

function SP_REVERSETRANSACTION(RefNo : PChar) : SmallInt;
                            STDCALL  EXPORT;

function SP_BACKTOBACKORDER(P : Pointer;
                            OutP : Pointer;
                            PSize : LongInt;
                            var OutPSize : LongInt;
                            RefNo : PChar) : SmallInt;
                            STDCALL  EXPORT;

function SP_UPDATERECONCILEFLAG(RecordPos : Longint;
                                NewValue  : SmallInt) : SmallInt;
                                STDCALL  EXPORT;


implementation

uses
  ConvDocU,
  BTrvU2,
  VarConst,
  DelvRunU,
  SysU1,
  BtKeys1U,
  SysUtils,
  GlobVar,
  DllMiscU,
  VarCnst3,
  SOPCT5U,
  SpDllSup,
  BtSupU1,
  Forms,
  EtMiscU,
  Classes,
  ExBtTh1U,
  PostingU,
  ComnU2,
  EtStrU,
  EtDateU,
  Dialogs,

  oProcessLock;

{.$I SPDLL.INC}


type
  ConvTypeRec = Record
    FromType  : string[3];
    ToType    : string[3];
    Mode      : SmallInt;
    Func      : SmallInt;
  end;

const
  ccCheck = 0;
  ccConvert = 1;

  //Changes to MaxConvTypes and ConvTypes must be reflected in oConvert.pas for Com Tk
  MaxConvTypes = 10;


  ConvTypes : Array[1..MaxConvTypes] of ConvTypeRec = (
                 (FromType : 'PQU'; ToType : 'POR'; Mode : 14; Func : 1),
                 (FromType : 'SQU'; ToType : 'SOR'; Mode : 14; Func : 1),
                 (FromType : 'PQU'; ToType : 'PIN'; Mode : 6; Func : 1),
                 (FromType : 'SQU'; ToType : 'SIN'; Mode : 6; Func : 1),
                 (FromType : 'POR'; ToType : 'PDN'; Mode : 1; Func : 2),
                 (FromType : 'SOR'; ToType : 'SDN'; Mode : 1; Func : 2),
                 (FromType : 'POR'; ToType : 'PIN'; Mode : 3; Func : 2),
                 (FromType : 'SOR'; ToType : 'SIN'; Mode : 3; Func : 2),
                 (FromType : 'PDN'; ToType : 'PIN'; Mode : 2; Func : 3),
                 (FromType : 'SDN'; ToType : 'SIN'; Mode : 2; Func : 3)
                 );

function  CheckConvert(P     : Pointer;
                       PSize : longint;
                       Consolidate : Boolean;
                       CheckMode : Byte) : SmallInt;
var
  ValidCheck : Boolean;
  KeyS : String[255];
  ConvRec : TBatchConvRec;
  RecCount, i : longint;
  Res : SmallInt;
  Mode, Func : SmallInt;
  RunForm : TSOPRunFrm; //DelvRunU.pas
  AtLeastOneError : Boolean;
  BF : integer;
  RNo : LongInt;
  DocHedS : String[3];
  DocHed : DocTypes;

  //PR: 06/06/2017 ABSEXCH-18683 v2017 R1
  GotProcessLock : Boolean;

  function cvDocToOk : Boolean;
  //Checks that it's a legal conversion - ConvTypes array specifies what can
  //be converted. Also sets the function to be called and the mode parameter
  var
    sFrom, sTo : string;
    k : integer;
  begin
    Result := False;
    sTo := ConvRec.cvDocToType;
    sFrom := Copy(ConvRec.cvDocFrom, 1, 3);
    for k := 1 to MaxConvTypes do
    begin
      if (sTo = ConvTypes[k].ToType) and
         (sFrom = ConvTypes[k].FromType) then
      begin
        Mode := ConvTypes[k].Mode;
        Func := ConvTypes[k].Func;
        Result := True;
        Break;
      end;
    end;
  end;

  function SetDocType : Boolean;
  //Convert string doctype (eg 'PIN', 'SIN') to DocTypes (SIN,PIN,etc)
  var
    k : DocTypes;
  begin
    Result := False;
    for k := SIN to PRN do
      if DocCodes[k] = DocHedS then
      begin
        DocHed := k;
        Result := True;
        Break;
      end;
  end;

  function CheckConsolidate : Boolean;
  {If we want to consolidate the conversions then all docs to must be the same type,
   as must all docs from.}
  var
    k : integer;
    DFrom, DTo : string;
  begin
    Result := True;
    for k := 0 to RecCount - 1 do
    begin
      Move(Pointer(Longint(P) + (k * SizeOf(TBatchConvRec)))^, ConvRec, SizeOf(TBatchConvRec));
      if k = 0 then
      begin
        DFrom := Copy(ConvRec.cvDocFrom, 1, 3);
        DTo := ConvRec.cvDocToType;

      end
      else
      if (Copy(ConvRec.cvDocFrom, 1, 3) <> DFrom) or (ConvRec.cvDocToType <> DTo) then
      begin
        Result := False;
        Break;
      end;
    end;
  end;

  function HasPickedQty : Boolean;
  Var
    KeyS,
    KeyChk  :  Str255;
    Res : Integer;
  Const
    FNum = IDetailF;
    KeyPath = IdFolioK;
  Begin

    Result := False;

    KeyChk := FullNomKey(Inv.FolioNum);
    KeyS := KeyChk;

    Res := Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (Res = 0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Result) do
    With Id do
    Begin
      Application.ProcessMessages;

      Result:=(Round_Up(QtyPick+QtyPWOff+QtyWoff,Syss.NoQtyDec)<>0);

      If (Not Result) then
        Res  := Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}



  end; {Func..}


begin
  GotProcessLock := False;
  RNo := 0;
  if P <> nil then
  begin
    DeductMLoc:=(ExSyss.UseMLoc);       { Deduct from Location Stock Y/N }

    RecCount := PSize div SizeOf(TBatchConvRec);
    ValidCheck := (RecCount * SizeOf(TBatchConvRec)) - PSize = 0;


    if ValidCheck then
    begin
      if Consolidate then
        ValidCheck := CheckConsolidate;

      if ValidCheck then
      begin
        //PR: 06/06/2017 ABSEXCH-18683 v2017 R1 Add process locking

        //Only need process locking if we're converting to Invoice so
        //move first record into ConvRec for checking
        Move(P^, ConvRec, SizeOf(TBatchConvRec));

        if (CheckMode = ccConvert) and ((ConvRec.cvDocToType = 'SIN') or (ConvRec.cvDocToType = 'PIN')) then
        begin
          //Set user id
          if Trim(EntryRec.Login) = '' then
            EntryRec.Login := 'COMToolkit';
            
          if not GetProcessLockWithRetry(plInvoiceDeliveries) then
          begin
            Result := 30009;
            EXIT;
          end
          else
            GotProcessLock := True;
        end;

        Try
          AtLeastOneError := False;
          RunForm := TSOPRunFrm.Create(nil);
          if Consolidate then
          begin
            Move(Pointer(Longint(P))^, ConvRec, SizeOf(TBatchConvRec));
            DocHedS := ConvRec.cvDocToType;
            SetDocType;

          end;

          //PR: 21/04/2015 ABSEXCH-16337 Moved SetNextSOPRunNo call here so it works for not consolidated too.
          if CheckMode = ccConvert then
            RNO := SetNextSOPRunNo(DocHed, True, 0);

          Try
            for i := 0 to RecCount -1 do
            begin
              Move(Pointer(Longint(P) + (i * SizeOf(TBatchConvRec)))^, ConvRec, SizeOf(TBatchConvRec));
              if cvDocToOK then
              begin
              //Find transaction
                KeyS := ConvRec.cvDocFrom;
                ConvRec.cvStatus := Find_Rec(B_GetEq, F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyS);
                if (Func = 2) then
                  if not HasPickedQty then
                    ConvRec.cvStatus := 30003;
                if (CheckMode = ccConvert) and (ConvRec.cvStatus = 0) then
                begin
                  RunForm.ConvDate := ConvRec.cvDate;
                  Case Func of
                    //Quotes to invoices or orders
                    1  :  begin
                            if Quo_To_Inv(InvF,InvOurRefK, Mode ) then
                            begin
                              ConvRec.cvStatus := 0;
                              ConvRec.cvDocTo := Inv.OurRef;
                            end
                            else
                              ConvRec.cvStatus := 30005;
                          end;
                    //2 - Orders to delivery notes or invoices
                    2  :  begin
                            RunForm.SOP_ProcessDel(Consolidate, not Consolidate, BF, RNo, '',
                                                        InvF, InvRNoK, InvOurRefK, Mode);
                            begin
                              ConvRec.cvStatus := RunForm.ErrCode;
                              ConvRec.cvDocTo := RunForm.ToDoc;
                            end;
                          end;
                    //3 - Delivery notes to invoices
                    3  :  begin
                            RunForm.SOP_ConvertDel(Consolidate, not Consolidate, BF, RNo,
                                                        InvF, InvRNoK, InvOurRefK, Mode);
                            begin
                              ConvRec.cvStatus := RunForm.ErrCode;
                              ConvRec.cvDocTo := RunForm.ToDoc;
                            end;
                          end;
                  end; //Case
                end;
              end
              else
                ConvRec.cvStatus := 30002;

              AtLeastOneError := AtLeastOneError or (ConvRec.cvStatus <> 0);


              Move(ConvRec, Pointer(Longint(P) + (i * SizeOf(TBatchConvRec)))^, SizeOf(TBatchConvRec));
            end; //For i
            //PR: 18/09/2017 ABSEXCH-19205 Shouldn't call RunForm.SOP_RevealRun when
            //CheckMode is ccCheck, since this function finalises the created Invoices
            //which don't yet exist, so causes problems. It searches for transactions with
            //a BatchLink of RNo which hasn't been set yet, so finds transactions with
            //a BatchLink of #0#0#0#0 + 'xIN and amends them, recalculating
            //the totals and setting RunNo to 0, hence bringing them out of history.
            if (CheckMode = ccConvert) and Consolidate and (Func in [2, 3]) then
              //Reveal
              RunForm.SOP_RevealRun(SOP_RunNo(RNo,DocHed),0,Mode,InvF,InvBatchK);
          Finally
            RunForm.Free;
          End;
          if AtLeastOneError then
          begin
            if RecCount > 1 then
              Result := 30001
            else
              Result := ConvRec.cvStatus;
          end
          else
            Result := 0;
        Finally
          if GotProcessLock then
            RemoveCurrentProcessLock(plInvoiceDeliveries);
        End;
      end
      else
        Result := 30006;
    end
    else
      Result := 32766;
  end
  else
    Result := 32767;
end;

function SP_CHECKCONVERSION(P     : Pointer;
                            PSize : longint;
                            Consolidate : Boolean) : SmallInt;
begin
  Result := CheckConvert(P, PSize, Consolidate, ccCheck);
end; { SP_CHECKCONVERSION }

function SP_CONVERTTRANSACTION(P     : Pointer;
                               PSize : longint;
                               Consolidate : Boolean) : SmallInt;
begin
  Result := CheckConvert(P, PSize, Consolidate, ccConvert);

end;{ SP_CONVERTTRANSACTION }

function CopyReverse(RefNo : PChar; Mode : Byte) : SmallInt;
var
  KeyS : String[255];
  Res : SmallInt;
begin
  KeyS := StrPas(RefNo);

  Res := Find_Rec(B_GetEq, F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyS);

  if Res = 0 then
  begin
    Try
      ContraCopy_Doc(Inv.FolioNum, Mode, '');
      StrPCopy(RefNo, Inv.OurRef);
      Result := 0;
    Except
      Result := 30005;
    End;
  end
  else
    Result := 30004;

end;

function SP_COPYTRANSACTION(RefNo : PChar) : SmallInt;
begin
  Result := CopyReverse(RefNo, 1);
end;

function SP_REVERSETRANSACTION(RefNo : PChar) : SmallInt;
begin
  Result := CopyReverse(RefNo, 2);
end;

procedure CopyB2BRec(TkRec : TBatchB2BRec; var EntRec : B2BInpRec);
begin
  EntRec.MultiMode := WordBoolToBool(TkRec.bbMultipleSuppliers);
  EntRec.IncludeLT := 0;

  if WordBoolToBool(TkRec.bbIncludeNormalLines) then
    EntRec.IncludeLT := EntRec.IncludeLT or 1;
  if WordBoolToBool(TkRec.bbIncludeLabourLines) then
    EntRec.IncludeLT := EntRec.IncludeLT or 2;
  if WordBoolToBool(TkRec.bbIncludeMaterialLines) then
    EntRec.IncludeLT := EntRec.IncludeLT or 4;
  if WordBoolToBool(TkRec.bbIncludeFreightLines) then
    EntRec.IncludeLT := EntRec.IncludeLT or 8;
  if WordBoolToBool(TkRec.bbIncludeDiscountLines) then
    EntRec.IncludeLT := EntRec.IncludeLT or 16;


  EntRec.QtyMode := TkRec.bbQtyMode;
  EntRec.SuppCode := TkRec.bbSuppCode;
  EntRec.AutoPick := WordBoolToBool(TkRec.bbAutoPick);
end;


function SP_BACKTOBACKORDER(P : Pointer;
                            OutP : Pointer;
                            PSize : LongInt;
                            var OutPSize : LongInt;
                            RefNo : PChar) : SmallInt;
var
  LInv : InvRec;
  LAddr : LongInt;
  TkRec : TBatchB2BRec;
  EntRec : B2BInpRec;
  Res : SmallInt;
  KeyS : String[255];

  function CheckSuppCode : Boolean;
  begin
    Result := CheckRecExsists(TkRec.bbSuppCode,CustF,CustCodeK) and
              (Cust.CustSupp = 'S');
  end;

begin
  if P <> nil then
  begin
    if PSize = SizeOf(TBatchB2BRec) then
    begin
      Move(P^, TkRec, PSize);
      KeyS := StrPas(RefNo);

      If Find_Rec(B_GetEq, F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyS) = 0 then
      begin
        if CheckSuppCode then
        begin
          if Ex_GetRecordAddress(InvF, LAddr) = 0 then
          begin
            LInv := Inv;
            FillChar(EntRec, SizeOf(EntRec), #0);

            CopyB2BRec(TkRec, EntRec);
            B2BList := TStringList.Create;
            Try
              Try
                Generate_MB2BPOR(LInv, LAddr, EntRec);
                SetB2BReturn(OutP, OutPSize);
                Result := 0;
              Except
                Result := 30001;
              End;
            Finally
              B2BList.Free;
            End;

          end
          else
            Result := 30004;
        end
        else
          Result := 30002;

      end
      else
        Result := 30004;


    end
    else
      Result := 32766;
  end
  else
    Result := 32767;

end;

function DoUpdateReconcile(NewValue : SmallInt) : SmallInt;
const
  KeyPath = IdFolioK;
var
  MTPost   :  ^TEntPost;
  ReExLocal:  tdPostExLocalPtr;

  Cnst    :  Integer;
  LAddr,
  TNCode  :  LongInt;
  LVal
          :  Real;
  PBal    :  Double;
  Rstatus :  Byte;
  Loop    :  Boolean;
  Locked  :  Boolean;
  KeyS    :  Str255;
  TmpID   :  IDetail;

begin
  Result := 0;
  MTPost := nil;
  New(ReExLocal,Create(10));
  try
    //Make the ID unique so if we're in a plug-in we don't interfere with Exchequer's ExLocal 10.
    Prime_ClientIdRec(ReExLocal^.ExClientId^,'SP',10);
    With ReExLocal^ do
      Open_System(NomF,NHistF);
  except
    Dispose(ReExLocal,Destroy);
    ReExLocal:=nil;
  end; {Except}

  Try
    If Assigned(ReExLocal)  then
    Begin
      New(MTPost,Create(nil));
      try
        MTPost.MTExLocal:=ReExLocal;
      except
        Dispose(MTPost,Destroy);
        MTPost:=nil;
      end;
      Loop:=BOff;


      With Id do
      Begin
        RStatus := NewValue;

        Cnst:=0;  LVal:=0;  PBal:=0;  TNCode:=0;

        Locked:=BOff;

        If (RStatus<>Reconcile) then
        Begin
          OK := GetMultiRec(B_GetDirect,B_SingLock,KeyS,IdFolioK,IDetailF,SilentLock,Locked);
          If (Ok) and (Locked) then
          Begin
            If (Reconcile=ReconC) then
              Cnst:=-1
            else
              If (Reconcile In NotClearedSet) and (RStatus = ReconC) then
                Cnst:=1;



            If (Cnst<>0) then
            Begin

              LVal:=DetLTotal(Id,Not Syss.SepDiscounts,BOff,0.0)*Cnst;

                If (Assigned(MTPost)) then
                Begin
                  MTPost.LPost_To_Nominal(FullNomKey(NomCode),0,0,LVal,Currency,PYr,PPr,1,BOff,BOn,BOff,CXrate,PBal,TNCode,UseORate);

                    If (Syss.PostCCNom) and (Syss.UseCCDep) then
                    Begin
                      Repeat
                        If (Not EmptyKeyS(CCDep[Loop],ccKeyLen,BOff)) then
                        Begin
                          MTPost.LPost_To_CCNominal(FullNomKey(NomCode),0,0,LVal,Currency,PYr,PPr,1,BOff,BOn,BOff,
                                            CXRate,PostCCKey(Loop,CCDep[Loop]),UseORate);


                          If (Syss.PostCCDCombo) then {* Post to combination *}
                            MTPost.LPost_To_CCNominal(FullNomKey(NomCode),0,0,LVal,Currency,PYr,PPr,1,BOff,BOn,BOff,
                                              CXRate,PostCCKey(Loop,CalcCCDepKey(Loop,CCDep)),UseORate);

                        end;
                        Loop:=Not Loop;

                      Until (Not Loop);
                    end;

                end;

            end;
            Reconcile:=RStatus;

            If (Reconcile=ReconC) then
              ReconDate:=Today
            else
              ReconDate:=MaxUntilDate;

            Result := Put_Rec(F[IDetailF], IDetailF, RecPtr[IDetailF]^, KeyPath);

          end;

        end; {If locked..}
      end; {With..}

    end;
  Finally
    If (Assigned(ReExLocal)) then
      Dispose(ReExLocal,Destroy);

    If (Assigned(MTPost)) then
      Dispose(MTPost,Destroy);
  End;

end;

function SP_UPDATERECONCILEFLAG(RecordPos : longint;
                                NewValue  : SmallInt) : SmallInt;
var
  KeyS, Key1 : Str255;
  LockResult, IdLocked : boolean;
  InvLocked : Boolean;
begin
  Result:=32767;

  //Check new value
  if (NewValue >= 0) and (NewValue <= 3) then
  begin
    //Get the transaction line using the record position, then find the header record from
    //the folio number on the line and lock it.
    SetDataRecOfs(IDetailF,RecordPos);

    Result :=GetDirect(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,0);

    { Get specified Transaction }
    if Result = 0 then
    begin
      Key1 := FullNomKey(Id.FolioRef);
      Result := Find_Rec(B_GetEQ, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, Key1);

      If (Result=0) Then
      Begin
        InvLocked := False;
        LockResult := GetMultiRec(B_GetDirect,B_SingLock,KeyS,InvFolioK,InvF,SilentLock,InvLocked);
        if (Not LockResult) or (LockResult and not InvLocked) then
          Result := 84;

        If (Result=0) And InvLocked Then
        Begin
          Result := DoUpdateReconcile(NewValue);

          if InvLocked then
            Find_Rec(B_Unlock,F[InvF],InvF,RecPtr[InvF]^,InvFolioK,Key1);
        end;
      end;
    end
    else
    begin
      if Result in [0, 9] then
      Result := 4;
      Result := 32000 + Result;
    end;

  end
  else
    Result := 30000;
end;

Initialization

end.
