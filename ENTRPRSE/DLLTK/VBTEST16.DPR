Library Vbtest16;

uses
  Dialogs,
  Forms,
  SysUtils;

{$R *.RES}


{$I ExchDLL.Inc}

{ Takes passed TBatchCURec and checks it for validity }
Procedure TESTCU (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  CuRec   : ^TBatchCURec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  CuRec := P;

  Cont := True;
  With CURec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchCURec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchCURec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (CustCode <> 'A1B2C3') Then Begin
        ShowMessage ('Error in TBatchCURec.CustCode ' + CustCode);
        Cont := False;
      End; { If }

    If Cont Then
      If (CustSupp <> 'D') Then Begin
        ShowMessage ('Error in TBatchCURec.CustSupp');
        Cont := False;
      End; { If }

    If Cont Then
      If (VATRegNo <> '12345') Then Begin
        ShowMessage ('Error in TBatchCURec.VATRegNo');
        Cont := False;
      End; { If }

    If Cont Then
      If (Phone <> 'AaBbCcDdEe') Then Begin
        ShowMessage ('Error in TBatchCURec.Phone');
        Cont := False;
      End; { If }

    If Cont Then
      If (Currency <> 587) Then Begin
        ShowMessage ('Error in TBatchCURec.Currency');
        Cont := False;
      End; { If }

    If Cont Then
      If (PayTerms <> 1087) Then Begin
        ShowMessage ('Error in TBatchCURec.PayTerms');
        Cont := False;
      End; { If }

    If Cont Then Begin
      DblTest := 1259.87;
      If (Discount <> DblTest) Then Begin
        ShowMessage ('Error in TBatchCURec.Discount - ' + Format ('%f10.5    %f10.5', [DblTest, Discount]));
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then
      If (PadChar2 <> #253) Then Begin
        ShowMessage ('Error in TBatchCURec.PadChar2');
        Cont := False;
      End; { If }

    If Cont Then
      If (PayType <> 'R') Then Begin
        ShowMessage ('Error in TBatchCURec.PayType');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar3 <> #254) Then Begin
        ShowMessage ('Error in TBatchCURec.PadChar3');
        Cont := False;
      End; { If }

    If Cont Then
      If (DefCOSNom <> 12394) Then Begin
        ShowMessage ('Error in TBatchCURec.DefCOSNom');
        Cont := False;
      End; { If }

    If Cont Then
      If (CCDSARef <> 'zZyY') Then Begin
        ShowMessage ('Error in TBatchCURec.CCDSARef');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchCURec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchCURec is OK');
End;


{ Takes passed TBatchTHRec and checks it for validity }
Procedure TESTTH (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  ThRec   : ^TBatchTHRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  ThRec := P;

  Cont := True;
  With ThRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchTHRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchTHRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (RunNo <> 846) Then Begin
        ShowMessage ('Error in TBatchTHRec.RunNo');
        Cont := False;
      End; { If }

    If Cont Then
      If (FolioNum <> 73614) Then Begin
        ShowMessage ('Error in TBatchTHRec.FolioNum');
        Cont := False;
      End; { If }

    If Cont Then
      If (AcPr <> 769) Then Begin
        ShowMessage ('Error in TBatchTHRec.AcPr');
        Cont := False;
      End; { If }

    If Cont Then
      If (LineCount <> 12769) Then Begin
        ShowMessage ('Error in TBatchTHRec.LineCount');
        Cont := False;
      End; { If }

    If Cont Then Begin
      DblTest := 83732.87;
      If (DiscAmount <> DblTest) Then Begin
        ShowMessage ('Error in TBatchTHRec.DiscAmount');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then
      If (PadChar2[1] <> #250) Or (PadChar2[2] <> #251) Then Begin
        ShowMessage ('Error in TBatchTHRec.PadChar2');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar3 <> #249) Then Begin
        ShowMessage ('Error in TBatchTHRec.PadChar3');
        Cont := False;
      End; { If }

    If Cont Then Begin
      DblTest := 37643.12;
      If (TotOrdOS <> DblTest) Then Begin
        ShowMessage ('Error in TBatchTHRec.TotOrdOS');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then
      If (CtrlNom <> 1024987) Then Begin
        ShowMessage ('Error in TBatchTHRec.CtrlNom');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchTHRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchTHRec is OK');
End;


{ Takes passed TBatchTLRec and checks it for validity }
Procedure TESTTL (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  TlRec   : ^TBatchTLRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  TlRec := P;

  Cont := True;
  With TlRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchTLRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchTLRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (TransRefNo <> 'AbCdEf') Then Begin
        ShowMessage ('Error in TBatchTLRec.TransRefNo');
        Cont := False;
      End; { If }

    If Cont Then Begin
      DblTest := 984719.86;
      If (CoRate <> DblTest) Then Begin
        ShowMessage ('Error in TBatchTLRec.CoRate');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then Begin
      DblTest := 9.42;
      If (Qty <> DblTest) Then Begin
        ShowMessage ('Error in TBatchTLRec.Qty');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then Begin
      DblTest := 17.51;
      If (VAT <> DblTest) Then Begin
        ShowMessage ('Error in TBatchTLRec.VAT');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then Begin
      DblTest := 128.99;
      If (CostPrice <> DblTest) Then Begin
        ShowMessage ('Error in TBatchTLRec.CostPrice');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then
      If (MLocStk <> '123') Then Begin
        ShowMessage ('Error in TBatchTLRec.MLocStk');
        Cont := False;
      End; { If }

    If Cont Then
      If (Reconcile <> 123) Then Begin
        ShowMessage ('Error in TBatchTLRec.Reconcile');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchTLRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchTLRec is OK');
End;


{ Takes passed TBatchTLRec and checks it for validity }
Procedure TESTTLINES (P      : POINTER;
                      PSIZE  : LONGINT); Export;
Var
  TlRec   : ^TBatchLinesRec;
  Cont    : Boolean;
  I       : SmallInt;
Begin
  TlRec := P;

  Cont := True;
  If ((PSize Mod SizeOf (TBatchTLRec)) <> 0) Then Begin
    ShowMessage ('Incorrect Array Length - not divisible by Record Length');
    Cont := False;
  End; { If }

  If Cont Then
    For I := 1 To (PSize Div SizeOf (TBatchTLRec)) Do Begin
      Cont := (TlRec^[I].LineNo = I);

      If (Not Cont) Then Begin
        ShowMessage ('Error in TBatchLinesRec at line ' + IntToStr(I) + ' - value ' + IntToStr(TlRec^[I].LineNo));
        Break;
      End; { If }
    End; { For }

  If Cont Then
    ShowMessage ('TBatchLinesRec is OK');
End;


{ Takes passed TSaleBandsRec and checks it for validity }
Procedure TESTSB (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  SBRec   : ^TSaleBandsRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  SBRec := P;

  Cont := True;
  With SBRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TSaleBandsRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TSaleBandsRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (Currency <> 1111) Then Begin
        ShowMessage ('Error in TSaleBandsRec.Currency');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar1[1] <> #253) Then Begin
        ShowMessage ('Error in TSaleBandsRec.PadChar1');
        Cont := False;
      End; { If }

    If Cont Then Begin
      DblTest := 84873.42;
      If (SalesPrice <> DblTest) Then Begin
        ShowMessage ('Error in TSaleBandsRec.SalesPrice');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then
      If (PadChar2[1] <> #254) Then Begin
        ShowMessage ('Error in TSaleBandsRec.PadChar2');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TSaleBandsRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TSaleBandsRec is OK');
End;


{ Takes passed TSaleBandAry and checks it for validity }
Procedure TESTSA (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  SaRec   : ^TSaleBandAry;
  Cont    : Boolean;
  I       : SmallInt;
Begin
  SaRec := P;

  Cont := True;
  If (PSize <> SizeOf (TSaleBandAry)) Then Begin
    ShowMessage ('Incorrect Array Length - ' + IntToStr(SizeOf (TSaleBandAry)) + ' expected');
    Cont := False;
  End; { If }

  If Cont Then
    For I := Low(SARec^) To High(SARec^) Do Begin
      Cont := (SaRec^[I].Currency = I);

      If (Not Cont) Then Begin
        ShowMessage ('Error in TSaleBandAry at line ' + IntToStr(I) + ' - value ' + IntToStr(SaRec^[I].Currency));
        Break;          
      End; { If }
    End; { For }

  If Cont Then
    ShowMessage ('TSaleBandAry is OK');
End;


{ Takes passed TBatchSKRec and checks it for validity }
Procedure TESTSK (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  SKRec   : ^TBatchSKRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  SKRec := P;

  Cont := True;
  With SKRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchSKRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchSKRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (StockCode <> '1234567890123456') Then Begin
        ShowMessage ('Error in TBatchSKRec.StockCode - ' + StockCode);
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar1[1] <> #244) Then Begin
        ShowMessage ('Error in TBatchSKRec.PadChar1');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar2[1] <> #245) Then Begin
        ShowMessage ('Error in TBatchSKRec.PadChar2');
        Cont := False;
      End; { If }

    If Cont Then Begin
      DblTest := 98472.84;
      If (CostPrice <> DblTest) Then Begin
        ShowMessage ('Error in TBatchSKRec.CostPrice');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then
      If (PadChar3[1] <> #246) Then Begin
        ShowMessage ('Error in TBatchSKRec.PadChar3');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar4 <> #247) Then Begin
        ShowMessage ('Error in TBatchSKRec.PadChar4');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar5 <> #248) Then Begin
        ShowMessage ('Error in TBatchSKRec.PadChar5');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar6 <> #249) Then Begin
        ShowMessage ('Error in TBatchSKRec.PadChar6');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar7 <> #250) Then Begin
        ShowMessage ('Error in TBatchSKRec.PadChar7');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar8 <> #251) Then Begin
        ShowMessage ('Error in TBatchSKRec.PadChar8');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar9[1] <> #252) Then Begin
        ShowMessage ('Error in TBatchSKRec.PadChar9');
        Cont := False;
      End; { If }

    If Cont Then
      If (StLocation <> 'AbC') Then Begin
        ShowMessage ('Error in TBatchSKRec.StLocation');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar10[1] <> #253) Then Begin
        ShowMessage ('Error in TBatchSKRec.PadChar10');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchSKRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchSKRec is OK');
End;


{ Takes passed THistoryBalRec and checks it for validity }
Procedure TESTHB (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  HBRec   : ^THistoryBalRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  HBRec := P;

  Cont := True;
  With HBRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (THistoryBalRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (THistoryBalRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar1[1] <> #253) Then Begin
        ShowMessage ('Error in THistoryBalRec.PadChar1');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar2[1] <> #254) Then Begin
        ShowMessage ('Error in THistoryBalRec.PadChar2');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in THistoryBalRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('THistoryBalRec is OK');
End;


{ Takes passed TBatchNomRec and checks it for validity }
Procedure TESTNM (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  NMRec   : ^TBatchNomRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  NMRec := P;

  Cont := True;
  With NMRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchNomRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchNomRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (NomCode <> 98237) Then Begin
        ShowMessage ('Error in TBatchNomRec.NomCode');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar1 <> #252) Then Begin
        ShowMessage ('Error in TBatchNomRec.PadChar1');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar2 <> #253) Then Begin
        ShowMessage ('Error in TBatchNomRec.PadChar2');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar3 <> #254) Then Begin
        ShowMessage ('Error in TBatchNomRec.PadChar3');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchNomRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchNomRec is OK');
End;


{ Takes passed TBatchBOMRec and checks it for validity }
Procedure TESTBOM (P      : POINTER;
                   PSIZE  : LONGINT); Export;
Var
  BMRec   : ^TBatchBOMRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  BMRec := P;

  Cont := True;
  With BMRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchBOMRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchBOMRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (StockCode <> 'kjhasdiuy') Then Begin
        ShowMessage ('Error in TBatchBOMRec.StockCode');
        Cont := False;
      End; { If }

    If Cont Then Begin
      DblTest := 92734.83;
      If (QtyCost <> DblTest) Then Begin
        ShowMessage ('Error in TBatchBOMRec.QtyCost');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchBOMRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchBOMRec is OK');
End;


{ Takes passed TBatchBOMLinesRec and checks it for validity }
Procedure TESTBOMLINES (P      : POINTER;
                        PSIZE  : LONGINT); Export;
Var
  BOMRec  : ^TBatchBOMLinesRec;
  Cont    : Boolean;
  DblTest : Double;
  I       : SmallInt;
Begin
  BOMRec := P;

  Cont := True;
  If (PSize <> SizeOf (TBatchBOMLinesRec)) Then Begin
    ShowMessage ('Incorrect Array Length - ' + IntToStr(SizeOf (TBatchBOMLinesRec)) + ' expected');
    Cont := False;
  End; { If }

  If Cont Then
    For I := Low(BOMRec^) To High(BOMRec^) Do Begin
      DblTest := I + 1;
      Cont := (BOMRec^[I].QtyUsed = DblTest);

      If (Not Cont) Then Begin
        ShowMessage ('Error in TBatchBOMLinesRec at line ' + IntToStr(I) + ' - value ' + FloatToStr(BOMRec^[I].QtyUsed));
        Break;
      End; { If }
    End; { For }

  If Cont Then
    ShowMessage ('TBatchBOMLinesRec is OK');
End;


{ Takes passed TBatchSRRec and checks it for validity }
Procedure TESTSR (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  SRRec   : ^TBatchSRRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  SRRec := P;

  Cont := True;
  With SRRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchSRRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchSRRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (SerialNo <> '2342') Then Begin
        ShowMessage ('Error in TBatchSRRec.SerialNo');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar1[1] <> #254) Then Begin
        ShowMessage ('Error in TBatchSRRec.PadChar1');
        Cont := False;
      End; { If }

    If Cont Then
      If (CurSell <> 225) Then Begin
        ShowMessage ('Error in TBatchSRRec.CurSell');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchSRRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchSRRec is OK');
End;


{ Takes passed TBatchJHRec and checks it for validity }
Procedure TESTJH (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  JHRec   : ^TBatchJHRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  JHRec := P;

  Cont := True;
  With JHRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchJHRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchJHRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (JobCode <> '9812374') Then Begin
        ShowMessage ('Error in TBatchJHRec.JobCode');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar2 <> #252) Then Begin
        ShowMessage ('Error in TBatchJHRec.PadChar2');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar3[1] <> #253) Then Begin
        ShowMessage ('Error in TBatchJHRec.PadChar3');
        Cont := False;
      End; { If }

    If Cont Then
      If (VATCode <> #254) Then Begin
        ShowMessage ('Error in TBatchJHRec.VATCode');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchJHRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchJHRec is OK');
End;


{ Takes passed TBatchSLRec and checks it for validity }
Procedure TESTSL (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  SLRec   : ^TBatchSLRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  SLRec := P;

  Cont := True;
  With SLRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchSLRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchSLRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (lsStkCode <> 'jlky34d') Then Begin
        ShowMessage ('Error in TBatchSLRec.lsStkCode');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar1[1] <> #252) Then Begin
        ShowMessage ('Error in TBatchSLRec.PadChar1');
        Cont := False;
      End; { If }

    If Cont Then Begin
      DblTest := 122393.83;
      If (lsQtyMax <> DblTest) Then Begin
        ShowMessage ('Error in TBatchSLRec.lsQtyMax');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then
      If (PadChar2[1] <> #253) Then Begin
        ShowMessage ('Error in TBatchSLRec.PadChar2');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar3[1] <> #254) Then Begin
        ShowMessage ('Error in TBatchSLRec.PadChar3');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchSLRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchSLRec is OK');
End;


{ Takes passed TBatchMLocRec and checks it for validity }
Procedure TESTML (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  MLRec   : ^TBatchMLocRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  MLRec := P;

  Cont := True;
  With MLRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchMLocRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchMLocRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (loCode <> 'QQQ') Then Begin
        ShowMessage ('Error in TBatchMLocRec.loCode');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar1 <> #254) Then Begin
        ShowMessage ('Error in TBatchMLocRec.PadChar1');
        Cont := False;
      End; { If }

    If Cont Then
      If (loNominal[1] <> 53917) Then Begin
        ShowMessage ('Error in TBatchMLocRec.loNominal[1]');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchMLocRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchMLocRec is OK');
End;


{ Takes passed TBatchMatchRec and checks it for validity }
Procedure TESTMATCH (P      : POINTER;
                     PSIZE  : LONGINT); Export;
Var
  MARec   : ^TBatchMatchRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  MARec := P;

  Cont := True;
  With MARec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchMatchRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchMatchRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (DebitRef <> 'DEBIT') Then Begin
        ShowMessage ('Error in TBatchMatchRec.DebitRef');
        Cont := False;
      End; { If }

    If Cont Then
      If (CreditCr <> -31411) Then Begin
        ShowMessage ('Error in TBatchMatchRec.CreditCr');
        Cont := False;
      End; { If }

    If Cont Then Begin
      DblTest := 739123.93;
      If (BaseVal <> DblTest) Then Begin
        ShowMessage ('Error in TBatchMatchRec.BaseVal');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchMatchRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchMatchRec is OK');
End;


{ Takes passed TBatchNotesRec and checks it for validity }
Procedure TESTNOTES (P      : POINTER;
                     PSIZE  : LONGINT); Export;
Var
  NORec   : ^TBatchNotesRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  NORec := P;

  Cont := True;
  With NORec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchNotesRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchNotesRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (NoteSort <> 'AbC') Then Begin
        ShowMessage ('Error in TBatchNotesRec.NoteSort');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar1 <> #254) Then Begin
        ShowMessage ('Error in TBatchNotesRec.PadChar1');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchNotesRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchNotesRec is OK');
End;


{ Takes passed TBatchCCDepRec and checks it for validity }
Procedure TESTCD (P      : POINTER;
                  PSIZE  : LONGINT); Export;
Var
  CDRec   : ^TBatchCCDepRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  CDRec := P;

  Cont := True;
  With CDRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchCCDepRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchCCDepRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (CCDepCode <> 'CCD') Then Begin
        ShowMessage ('Error in TBatchCCDepRec.CCDepCode');
        Cont := False;
      End; { If }

    If Cont Then
      If (CCDepDesc <> 'Abcdefghij') Then Begin
        ShowMessage ('Error in TBatchCCDepRec.CCDepDesc');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchCCDepRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchCCDepRec is OK');
End;


{ Takes passed TBatchStkPriceRec and checks it for validity }
Procedure TESTSTKPR (P      : POINTER;
                     PSIZE  : LONGINT); Export;
Var
  PRRec   : ^TBatchStkPriceRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  PRRec := P;

  Cont := True;
  With PRRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchStkPriceRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchStkPriceRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (StockCode <> '98wedaASD') Then Begin
        ShowMessage ('Error in TBatchStkPriceRec.StockCode');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar1[1] <> #254) Then Begin
        ShowMessage ('Error in TBatchStkPriceRec.PadChar1');
        Cont := False;
      End; { If }

    If Cont Then Begin
      DblTest := -76358.84;
      If (Price <> DblTest) Then Begin
        ShowMessage ('Error in TBatchStkPriceRec.Price');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchStkPriceRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchStkPriceRec is OK');
End;


{ Takes passed TBatchVATRec and checks it for validity }
Procedure TESTVAT (P      : POINTER;
                   PSIZE  : LONGINT); Export;
Var
  VATRec   : ^TBatchVATRec;
  Cont    : Boolean;
  DblTest : Double;
Begin
  VATRec := P;

  Cont := True;
  With VATRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchVATRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchVATRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (VATCode <> #252) Then Begin
        ShowMessage ('Error in TBatchVATRec.VATCode');
        Cont := False;
      End; { If }

    If Cont Then
      If (PadChar1[1] <> #253) Then Begin
        ShowMessage ('Error in TBatchVATRec.PadChar1');
        Cont := False;
      End; { If }

    If Cont Then Begin
      DblTest := 34729.34;
      If (VATRate <> DblTest) Then Begin
        ShowMessage ('Error in TBatchVATRec.VATRate');
        Cont := False;
      End; { If }
    End; { If }

    If Cont Then
      If (PadChar2[1] <> #254) Then Begin
        ShowMessage ('Error in TBatchVATRec.PadChar2');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchVATRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchVATRec is OK');
End;


{ Takes passed TBatchSysRec and checks it for validity }
Procedure TESTSYS (P      : POINTER;
                   PSIZE  : LONGINT); Export;
Var
  SyssRec  : ^TBatchSysRec;
  Cont     : Boolean;
Begin
  SyssRec := P;

  Cont := True;
  With SyssRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchSysRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchSysRec)) + ' expected');
        Cont := False;
      End; { If }

    If Cont Then
      If (UserName <> 'AaBbCc') Then Begin
        ShowMessage ('Error in TBatchSysRec.UserName');
        Cont := False;
      End; { If }

    If Cont Then
      If (UserSort <> '123456') Then Begin
        ShowMessage ('Error in TBatchSysRec.UserSort');
        Cont := False;
      End; { If }

    If Cont Then
      If (ExPr <> 31985) Then Begin
        ShowMessage ('Error in TBatchSysRec.ExPr');
        Cont := False;
      End; { If }

    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchSysRec.LastChar');
        Cont := False;
      End; { If }
  End; { With }

  If Cont Then
    ShowMessage ('TBatchSysRec is OK');
End;


{ Takes passed TBatchSysRec and checks it for validity }
Procedure TESTAUTOBANK (P      : POINTER;
                        PSIZE  : LONGINT); Export;
Var
  ABRec    : ^TBatchAutoBankRec;
  Cont     : Boolean;
  DblTest  : Double;
Begin
  ABRec := P;

  Cont := True;
  With ABRec^ Do Begin
    If Cont Then
      If (PSize <> SizeOf (TBatchAutoBankRec)) Then Begin
        ShowMessage ('Incorrect Record Length - ' + IntToStr(SizeOf (TBatchAutoBankRec)) + ' expected');
        Cont := False;
      End; { If }

    ShowMessage ('TESTAUTOBANK checks not written');
    (*
    If Cont Then
      If (UserName <> 'AaBbCc') Then Begin
        ShowMessage ('Error in TBatchAutoBankRec.UserName');
        Cont := False;
      End; { If }


    If Cont Then
      If (LastChar <> #255) Then Begin
        ShowMessage ('Error in TBatchAutoBankRec.LastChar');
        Cont := False;
      End; { If }
    *)
  End; { With }

  If Cont Then
    ShowMessage ('TBatchAutoBankRec is OK');
End;


Exports
  TESTCU        Index 1,
  TESTTH        Index 2,
  TESTTL        Index 3,
  TESTTLINES    Index 4,
  TESTSB        Index 5,
  TESTSA        Index 6,
  TESTSK        Index 7,
  TESTHB        Index 8,
  TESTNM        Index 9,
  TESTBOM       Index 10,
  TESTBOMLINES  Index 11,
  TESTSR        Index 12,
  TESTJH        Index 13,
  TESTSL        Index 14,
  TESTML        Index 15,
  TESTMATCH     Index 16,
  TESTNOTES     Index 17,
  TESTCD        Index 18,
  TESTSTKPR     Index 19,
  TESTVAT       Index 20,
  TESTSYS       Index 21,
  TESTAUTOBANK  Index 22;
Begin
end.
