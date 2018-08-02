unit JChkUseU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel,
  GlobVar,VarConst, ExWrap1U;

type
  TJCCUseForm = class(TForm)
    SetPanel: TSBSPanel;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Running,
    PrevHState,
    fResult
            :  Boolean;

    fMode   :  Byte;

    fKey    :  Str255;

    Function Been_Used(Const Mode  :  Byte;
                       Const KeyAC :  Str255)  :  Boolean;


  public
    { Public declarations }

    Procedure Prime_ChkJCUsed(Mode      :  Byte;
                              KeyAC     :  Str255;
                          Var UsedResult:  Boolean);



  end;



  Function Ent_BeenUsed(Mode  :  Byte;
                        KeyAC :  Str255)  :  Boolean;


  Function Cert_Expired(EmplCode  :  Str20;
                        CompDate  :  LongDate;
                        ViaSupp,
                        ShowErr   :  Boolean)  :  Boolean;

Type
  tCISFind  =  Record
                 Found  :  Boolean;
                 ECode  :  Str20;
               end;

  taCISFind =  Array[4..6] of tCISFind;



Function Check_CISEmployee(EmplCode  :  Str20;
                       Var Taxable   :  Boolean)  :  Str20;

Function Resolve_CISTaxCode(EmplCType  :  Byte; AnalCCode  :  Char)  :  Char;

Function Check_AnyEmployee(EmplCode  :  Str20)  :  Str20;

Function CheckCISGLCodes(FromForm  :  Byte)  :  Boolean;

procedure CalculateCISTax(var BInv: InvRec;
                          var Materials, Taxable, TaxValue: Double;
                          UpdateLine: Boolean);

Procedure Calc_CISTax(Var BInv    :   InvRec;
                      Var Materials,
                          Taxable,
                          TaxValue:   Double;
                          UpLine  :   Boolean);

Function Calc_CISTaxInv(Var  BInv    :  InvRec;
                             UpDate  :  Boolean)  :  Double;

Procedure Reset_DOCCIS(Var BInv   :  InvRec;
                           ResetE :  Boolean);

Function Calc_NewCISPeriod(LastVDate  :  LongDate;
                           NoMnths    :  Integer)  :  LongDate;

Procedure Close_CurrCISPeriod;

Procedure Calc_CISEOYRange(Var SDate, EDate  :  LongDate;
                               AMonth        :  Boolean);

Procedure Set_DocCISDate(Var  InvR      :    InvRec;
                              UnalMode  :    Boolean);

Function CISVTypeName(CVT  :  Byte)  :  Str10;

Function CIS340VTypeName(CVT  :  Byte)  :  Str10;

Function CISVTypeOrd(CVT  :  Byte;
                     From :  Boolean)  :  Byte;

Procedure Match_Voucher(InvR    :  InvRec;
                        VFolio  :  Str10;
                        AddT,
                        AddN,
                        AddG    :  Real;
                        Mode    :  Byte);


  Function  Delete_Application(InvR       :  InvRec;
                               ShowMsg    :  Boolean;
                               ScanFileNum,
                               Keypath    :  Integer;
                           Var ExLocal    :  TdExLocal)  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  VarRec2U,
  VarJCstU,
  BtrvU2,
  BTSupU1,
  BTKeys1U,
  CurrncyU,
  {$IFDEF SOP}
    BOMCmpU,
  {$ENDIF}

  ComnUnit,
  MiscU,
  InvListU,
  SysU3,

  JobSup1U,
  ExThrd2U,
  GenWarnU,

  {$IFDEF JAP}
    JobSup2U,

    {$IFDEF C_On}
      LedgSupU,
      NoteSupU,
    {$ENDIF}

   {$IFDEF LTR}
     Letters,
   {$ENDIF}

   InvCT2SU,

  {$ENDIF}

  SysU2;


{$R *.DFM}


procedure TJCCUseForm.FormCreate(Sender: TObject);
begin
  Running:=BOff;
end;

Procedure TJCCUseForm.Prime_ChkJCUsed(Mode      :  Byte;
                                      KeyAC     :  Str255;
                                  Var UsedResult:  Boolean);

Begin
  fMode:=Mode;
  fKey:=KeyAC;

  SetPanel.Caption:='Please Wait... Checking if code '+Trim(fKey)+' has already been used.';

  SetAllowHotKey(BOff,PrevHState);
  Set_BackThreadMVisible(BOn);


  ShowModal;

  UsedResult:=fResult;

  SetAllowHotKey(BOn,PrevHState);
  Set_BackThreadMVisible(BOff);


end;



{ ====== Function to determine if a payrate/Analcode/JobType can be deleted ===== }

{ Check modes  1  =  Job Type
               2  =  AnalCode
               3  =  PayRate }


Function TJCCUseForm.Been_Used(Const Mode  :  Byte;
                               Const KeyAC :  Str255)  :  Boolean;

Const
  Fnum      =  JobF;
  Keypath   =  JobCodeK;



Var
  KeyChk,
  KeyChk2,
  KeyChk3,
  KeyS      :  Str255;

  Fnum2,
  Keypath2,
  Fnum3,
  Keypath3  :  Integer;

  FoundOk   :  Boolean;



Begin
  FNum2 := 0;
  KeyPath2 := 0;

  FNum3 := 0;
  KeyPath3 := 0;

  KeyChk:='';



  FoundOk:=BOff;

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

  While (StatusOk) and (Not FoundOk) do
  With JobRec^ do
  Begin
    Application.ProcessMessages;

    Case Mode of

      2  :  Begin

              {Budget}

              KeyChk:=PartCCKey(JBRCode,JBBCode)+FullJDStkKey(JobCode,KeyAC);

              {Actual}

              KeyChk2:=PartCCKey(JBRCode,JBECode)+FullJDAnalKey(JobCode,KeyAC);

              Fnum2:=JCtrlF;
              Keypath2:=JCK;

              Fnum3:=JDetlF;
              Keypath3:=JDAnalK;
            end;

      3  :  Begin {Pay Rates }

              {Budget}

              KeyChk:=PartCCKey(JBRCode,JBSCode)+FullJDStkKey(JobCode,KeyAC);

              {Actual}

              KeyChk2:=PartCCKey(JBRCode,JBECode)+FullJDStkKey(JobCode,KeyAC);

              {Employee PayRate}

              KeyChk3:=PartCCKey(JBRCode,JBSubAry[4])+FullJDStkKey(JobCode,KeyAC);

              Fnum2:=JCtrlF;
              Keypath2:=JCK;

              Fnum3:=JDetlF;
              Keypath3:=JDStkK;

            end;
    end; {Case..}
    Case Mode of

      1    : Begin {* Check for matching jobtype *}

               FoundOk:=CheckKey(JobAnal,KeyAC,Length(JobAnal),BOff);

             end;

      2,3  :  Begin

                FoundOk:=CheckExsists(KeyChk,Fnum2,Keypath2);

                If (Not FoundOk) then
                  FoundOk:=CheckExsists(KeyChk2,Fnum3,Keypath3);

                If (Not FoundOk) and (Mode=3) then
                  FoundOk:=CheckExsists(KeyChk3,Fnum2,Keypath2);

              end;


    end; {Case..}


    If (Not FoundOk) then
      Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);



  end; {While..}

  Been_Used:=FoundOk;



end; {Func..}


procedure TJCCUseForm.FormActivate(Sender: TObject);
begin
  If (Not Running) then
  Begin
    Running:=BOn;

    UpDate;

    fResult:=Been_Used(fMode,fKey);

    PostMEssage(Self.Handle,WM_Close,0,0);
  end;
end;


{ === Function to create the in use with a dialog === }

Function Ent_BeenUsed(Mode  :  Byte;
                      KeyAC :  Str255)  :  Boolean;


Var
  PopUp  :  TJCCUseForm;


Begin
  PopUp:=TJCCuseForm.Create(Application.MainForm);

  Try
    PopUp.Prime_ChkJCUsed(Mode,KeyAC,Result);

  Finally

    PopUp.Free;
  end; {try..}


end;


{ == Function to determine if a supplier has any expired cert ==}

{!!!! Note this routine is replicated for thread safe operation within BPayLstU & AllocS2U !!!!}

Function Cert_Expired(EmplCode  :  Str20;
                      CompDate  :  LongDate;
                      ViaSupp,
                      ShowErr   :  Boolean)  :  Boolean;


Const
  Fnum     =  JMiscF;
  Keypath  =  JMTrdK;

Var
  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr : LongInt;

  KeyChk,
  KeyS       : Str255;

  LOk        : Boolean;


Begin
  Result:=BOff;  LOk:=BOff;

  KeyS:=''; KeyChk:='';

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  If (ViaSupp) then
  Begin
    KeyChk:=PartCCKey(JARCode,JASubAry[3])+FullCustCode(EmplCode);
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not Result) do
    With JobMisc^,EmplRec do
    Begin
      Application.ProcessMessages;

      Result:=Cert_Expired(EmpCode,CompDate,BOff,ShowErr);

      If (Not Result) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

    end;

  end
  else
  With JobMisc^,EmplRec do
  Begin
    KeyS:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(EmplCode));

    If (EmplCode<>EmpCode) then
      LOk:=CheckRecExsists(KeyS,Fnum,JMK)
    else
      LOk:=BOn;

    If (LOk) then
    Begin
      Result:=(CertExpiry<CompDate) and (Trim(CertExpiry)<>'') and (Etype=EmplSubCode) and (CISType<>4) and (Not CIS340) ;
    end;

    If (Result) and (ShowErr) then
      CustomDlg(Application.MainForm,'Warning!','Certificate Expired',
                                    #13+#13+'The Certificate for '+dbFormatName(EmpCode,EmpName)+#13+
                                    'expired on '+POutDate(CertExpiry),mtWarning,[mbOk]);


  end;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);
end;



  { == These rotuines replicated in JobPostU for thread safe operation == }

  Function Find_CISEmployee(EmplCode  :  Str20;
                            ViaSupp,
                            IgnoreCIS :  Boolean)  :  taCISFind;


  Const
    Fnum     =  JMiscF;
    Keypath  =  JMTrdK;

  Var
    n          : Byte;
    TmpStat,
    TmpKPath   : Integer;
    TmpRecAddr : LongInt;

    KeyChk,
    KeyS       : Str255;

    LOk        : Boolean;

    CISFind    : taCISFind;


  Begin
    FillChar(Result,Sizeof(Result),#0);
    FillChar(CISFind,Sizeof(CISFind),#0);

    KeyS:=''; KeyChk:='';

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    If (ViaSupp) then
    Begin
      KeyChk:=PartCCKey(JARCode,JASubAry[3])+FullCustCode(EmplCode);
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not Result[4].Found) do
      With JobMisc^,EmplRec do
      Begin
        Application.ProcessMessages;

        CISFind:=Find_CISEmployee(EmpCode,BOff,IgnoreCIS);

        For n:=Low(CISFind) to High(CISFind) do
          If (Not Result[n].Found) and (CISFind[n].Found) then
            Result[n]:=CISFind[n];

        If (Not Result[4].Found) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

      end;

    end
    else
    With JobMisc^,EmplRec do
    Begin
      KeyS:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(EmplCode));

      If (EmplCode<>EmpCode) then
        LOk:=CheckRecExsists(KeyS,Fnum,JMK)
      else
        LOk:=BOn;

      If (LOk) then
      Begin
        Case CISType of

          1,4  :  With Result[4] do
                  Begin
                    Found:=BOn;
                    ECode:=EmpCode;
                  end;

          2,5  :  With Result[5] do
                  Begin
                    Found:=BOn;
                    ECode:=EmpCode;
                  end;

          3    :  With Result[6] do
                  Begin
                    Found:=BOn;
                    ECode:=EmpCode;
                  end;

          else    If (IgnoreCIS) then
                  With Result[4] do
                  Begin
                    Found:=BOn;
                    ECode:=EmpCode;
                  end;

        end; {Case..}
      end;


    end;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);
  end;


  { == From three poss cases, return code in order of priority == }

  Function Check_CISEmployee(EmplCode  :  Str20;
                         Var Taxable   :  Boolean)  :  Str20;

  Var
    n          : Byte;

    CISFind    : taCISFind;

  Begin
    Result:=''; Taxable:=BOff;

    CISFind:=Find_CISEmployee(EmplCode,BOn,BOff);

    For n:=Low(CISFind) to High(CISFind) do
    If (CISFInd[n].Found) then
    Begin
      Result:=CISFind[n].ECode;

      Taxable:=(n=Low(CISFind));

      Break;
    end;
  end;


Function Get_SubRec(EmplCode  :  Str20)  :  EmplType;


Const
  Fnum     =  JMiscF;
  Keypath  =  JMTrdK;

Var
  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr : LongInt;

  KeyChk,
  KeyS       : Str255;

  LOk        : Boolean;


Begin
  Blank(Result,Sizeof(Result));

  LOk:=BOff;

  KeyS:=''; KeyChk:='';

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);


  With JobMisc^,EmplRec do
  Begin
    KeyS:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(EmplCode));

    If (EmplCode<>EmpCode) then
      LOk:=CheckRecExsists(KeyS,Fnum,JMK)
    else
      LOk:=BOn;

    If (LOk) then
    Begin
      Result:=EmplRec;
    end;

  end;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);
end;


Function Resolve_CISTaxCode(EmplCType  :  Byte; AnalCCode  :  Char)  :  Char;

Var
  EmplCCode  :  Char;

Begin
  Case EmplCType of {Txlate Sub CIS Type to Tax rate equivalent }
    1  :  EmplCcode:='T';
    4  :  EmplCCode:='C';
    else  EmplCCodE:=C0;
  end; {Case..}

  If (EmplCCode=C0) or (AnalCCode=C0) then {If AnalCode is Zero, this is a non taxable item}
    Result:=AnalCCode
  else
    Result:=EmplCCode;

  If (EmplCCode<>C0) and (AnalCcode<>C0) then {Resolve difference by rules based on Sub Contractor being the lead on tax code}
  Begin
    If (GetCISCType(EmplCcode)=Technical) then {If Sub code higher, default to higher as must be un verified, else defer to anal code}
      Result:=EmplCCode
    else
      If (AnalCCode In ['C','T',C0]) then
        Result:=AnalCCode
      else
        Result:=EmplCCode;

  end;
end;


  { == From three poss cases, return code in order of priority == }

  Function Check_AnyEmployee(EmplCode  :  Str20)  :  Str20;

  Var
    n          : Byte;

    CISFind    : taCISFind;

  Begin
    Result:='';

    CISFind:=Find_CISEmployee(EmplCode,BOn,BOn);

    For n:=Low(CISFind) to High(CISFind) do
    If (CISFInd[n].Found) then
    Begin
      Result:=CISFind[n].ECode;

      Break;
    end;
  end;

  { == Procedure to reset all doc's CIS settings == }

  Procedure Reset_DOCCIS(Var BInv   :  InvRec;
                             ResetE :  Boolean);

  Begin
    With BInv do
    Begin
      If (JBCostOn) and (CISOn) then
      Begin
        If (ResetE) then
          FillChar(CISEmpl,Sizeof(CISEmpl),#0);

        CISManualTax:=BOff;
        CISTax:=0.0;
        FillChar(CISDate,Sizeof(CISDate),#0);
      end;

    end;
  end;

  { == Function to check all CIS G/L Codes are present == }

Function CheckCISGLCodes(FromForm  :  Byte)  :  Boolean;

Var
  Loop     :  Boolean;

  n        :  CISTaxType;

  FoundLong:  LongInt;

  FoundCode:  Str20;

  Msg      :  String;

Begin
  Result:=BOff;

  For n:=CISStart to CISEnd do
  With SyssCIS.CISRates.CISRate[n] do
  Begin
    {$B-}
    Result:=(GLCode<>0) and (GetNom(Application.Mainform,Form_Int(GLCode,0),FoundLong,-1));

    If (not Result) then
      Msg:='G/L Code '+Form_Int(GLCode,0)+' for '+CCCISName^+' rate code '+Code+', '+Desc+' is not a valid G/L code.'
    else
      If (Syss.UseCCDep) then
      Begin
        For Loop:=BOff to BOn do
        Begin
          Result:=(RCCDep[Loop]<>'') and (GetCCDep(Application.Mainform,RCCDep[Loop],FoundCode,Loop,-1));

          If (not Result) then
          Begin
            Msg:=CostCtrRTitle[Loop]+' Code '+RCCDep[Loop]+' for '+CCCISName^+' rate code '+Code+', '+Desc+' is not a valid '+CostCtrRTitle[Loop]+' code.';

            Break;
          end;

        end;

      end;

      If (Not Result) then
        Break;

    end;

  If (Not Result) then
  Begin
    If (FromForm=1) then
      Msg:=Msg+#13+'The '+CCCISName^+' calculation for this transaction has not been completed.';

    ShowMessage(Msg);

  end;
end;



{$IFDEF EX603}

    { == Proc to scan Lines to work out Irish Reverse Charge VAT == }
    { == Reproduced inside JobPostU.pas, for thread safe operation == }

  Procedure Calc_RCTReverseVAT(Var BInv    :   InvRec;
                                   UpLine  :   Boolean);

  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;

  Var
    LOk,CalcTax,
    DLineOk,
    ResetCIS
               : Boolean;
    B_Func,
    TmpStat,
    TmpKPath   : Integer;

    AGLCode,
    TmpRecAddr : LongInt;

    VATRate    : VATType;


    LineVAT,
    VATRatio,
    LineTaxValue,
    VATRateLine,
    LineTotal  : Double;

    FoundCode  : Str20;

    KeyChk,
    KeyS       : Str255;

    AutoLine,
    TmpId      : IDetail;

    ProcessCISDoc
               : Boolean;

    Function Calc_RCTVATTotal(IdR    :  IDetail;
                              tMode  :  Byte)  :  Double;

    Begin
      With IdR do
        Result:=Round_Up(VAT,2);
    end;



  Begin
    LineTotal:=0.0; LineVAT:=0.0;  VATRatio:=0.0; ResetCIS:=(UpLine and (BInv.CISHolder=0));

    LineTaxValue:=0.0; VATRateLine:=0.0;

    ProcessCISDoc:=BOff;

    DLineOk:=BOff;

    AGLCode:=0;

    B_Func:=B_GetNext;

    With BInv do                                                                                                                      {* V6.03 Disconnect RCT calculation *}
    If (InvDocHed In CISDocSet+[PQU]+JAPJAPSplit-JAPSalesSplit) and (CISOn) and (JBCostOn) and ((Not CISManualTax) or (CISHolder<>3))
       and (CurrentCountry=IECCode) and (SyssCIS^.CISRates.RCTUseRCV) then
    Begin
      Begin

        If (CISEmpl='') then
          CISEmpl:=Check_CISEmployee(CustCode,CalcTax)
        else
        Begin
          KeyS:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(CISEmpl));


          LOk:=CheckRecExsists(KeyS,JMiscF,JMK);


          {$B-}
            If (LOk) then
              CalcTax:=(Not (JobMisc^.EmplRec.CISType In [0]))
            else
            Begin
              CISEmpl:=Check_CISEmployee(CustCode,CalcTax);

              CalcTax:=(CISEmpl<>'') and (Not (JobMisc^.EmplRec.CISType In [0]));
            end;
          {$B+}

        end;
      end;

      If ((CISEmpl<>'') or (ProcessCISDoc)) or (UpLine) then {* We have a CIS situation *}
      Begin
        If (CheckCISGLCodes(1)) then
        Begin
          TmpId:=Id;
          TmpKPath:=GetPosKey;

          TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

          KeyChk:=FullNomKey(FolioNum);

            If (InvDocHed In JAPSplit) then
              KeyS:=FullIdKey(FolioNum,JALRetLineNo)
            else
              KeyS:=FullIdKey(FolioNum,1);


          Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

          While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
          With Id do
          Begin
            Application.ProcessMessages;

            B_Func:=B_GetNext;

            {$B-}
            If ((CISEmpl<>'') or (ProcessCISDoc) ) {and (Not EmptyKey(AnalCode,AnalKeyLen)) and (Not EmptyKey(JobCode,JobKeyLen))
               and (GetJobMisc(Application.MainForm,AnalCode,FoundCode,2,-1))} and (AutoLineType<2) then
            {$B+}
            {With JobMisc^,JobAnalRec do
            If ((JAType>=2) and (CISTaxRate<>C0))
              or ((LineNo=JALDedLineNo) and (CISTaxRate<>C0))
              or (RevenueType>=2)  then}
            {Its overhead, material or labour}
            Begin
              LineTotal:=0.0;

              If (UpLine) then
              Begin
                {If (CISTaxRate<>C0) then}
                Begin

                  If (CalcTax) then
                  Begin
                    CISRateCode:=C0;
                    CISRate:=0.0;

                    Begin
                      AGLCode:=Syss.NomCtrlCodes[INVat];
                    end;

                    AutoLine:=Id;
                  end;

                  {Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

                  Report_BError(Fnum,Status);}

                end;
              end;

              If (CalcTax) then
              Begin

                Begin
                  If (Not ManVAT) then
                  Begin

                    LineTaxValue:=LineTaxValue+Round_Up((VAT*(1+(-2*Ord(LineNo<0)))),2);
                  end
                  else
                  Begin {!!! This would need changing to the LDef_InvCalc version for the thread safe version of this}
                    Def_InvCalc; {Work out goods vat split}

                    VATRate:=GetVAtNo(VATcode,VATIncFlg);

                    VATRatio:=DivWChk(LineTotal,InvNetAnal[VATRate]);

                    LineVAT:=Round_Up((InvVATAnal[VATRate]*VatRatio),2);

                    LineTaxValue:=LineTaxValue+Round_Up((LineVAT),2);
                  end;
                end;

              end;


              ResetCIS:=BOff;

            end;


            If (UpLine) and (AutoLineType=3) then {* Delete any auto manufactured Reverse Charge lines *}
            Begin
              {* Check a new line is required before auto deleting *}
              DLineOk:=((Round_Up(VAT,2)=Round_Up(LineTaxValue,2)) or (CISManualTax))

                       and (JobCode='') and (AnalCode='') and ((VATCode=VATZCode) or (VATCode=SyssCIS^.CISRates.RCTRCV1))

                       and (Qty=-1.0) and (QtyMul=1.0);

              If (Not DLineOk) then
              Begin
                AutoLine:=Id;

                Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

                Report_BError(Fnum,Status);

                If (IdDocHed In JAPSplit) then
                  B_Func:=B_GetNext
                else
                  B_Func:=B_GetGEq;
              end;
            end;

            Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

          end; {While..}


          If (UpLine) then
          Begin

            If (LineTaxValue<>0.0) and (AutoLine.FolioRef=FolioNum) and (Not DLineOk) then {Decrease value of transaction by Tax amount}
            With Id do
            Begin
              ResetRec(Fnum);

              FolioRef:=FolioNum;

              IdDocHed:=InvDocHed;

              AutoLineType:=3;

              If (IdDocHed In JAPSplit) then
              Begin
                LineNo:=JALDedLineNo;
                Payment:=DocPayType[SIN];
                Reconcile:=1;
              end
              else
              Begin
                LineNo:=ILineCount;
                Payment:=DocPayType[InvDocHed];
              end;

              ABSLineNo:=LineNo;

              ILineCount:=ILineCount+2;

              {If (AGLCode<>0) then
                NomCode:=AGLCode
              else
                NomCode:=AutoLine.NomCode;}

              NetValue:=0.0;

              VAT:=LineTaxValue;

              If (Not (IdDocHed In JAPJAPSplit-JAPSalesSplit)) then
                VAT:=VAT*DocNotCnst;

              With SyssCIS^.CISRates do
              If (RCTRCV1 In VATSet) then
                VATCode:=RCTRCV1
              else
                VATCode:=VATZCode;

              Qty:=1.0; QtyMul:=1.0;

              CCDep:=AutoLine.CCDep;

              Desc:=CCVATName^+' Automatic RCT Reverse Charge deduction.';


              PriceMulX:=1.0;

              CustCode:=BInv.CustCode;

              Currency:=BInv.Currency;

              CXRate:=BInv.CXRate;

              CurrTriR:=BInv.CurrTriR;

              PYr:=BInv.ACYr;
              PPr:=BInv.AcPr;

              {$IFDEF STK}
                LineType:=StkLineType[IdDocHed];
              {$ENDIF}

              DocPRef:=OurRef;

              Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

              Report_BError(Fnum,Status);
            end;
          end;

          TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
          Id:=TmpId;
        end; {If..}
      end; {If..GL Codes OK}
    end; {If..}
  end; {Proc..}

{$ENDIF}


// CJS 2014-03-18 - ABSEXCH-14289 - incorrect CIS Calculation when CITB Deduction is set to 1.5%
// Heavily-amended version of Calc_CISTax(), to correct the calculations for
// CITB deductions
procedure CalculateCISTax(var BInv: InvRec;
                          var Materials, Taxable, TaxValue: Double;
                          UpdateLine: Boolean);
var
  LOk,CalcTax,
  DLineOk,
  ResetCIS
             : Boolean;
  B_Func,
  TmpStat,
  TmpKPath   : Integer;

  AGLCode,
  TmpRecAddr : LongInt;

  VATRate    : VATType;

  CISLoop,
  CISRateType: CISTaxType;

  LineVAT,
  LineNV,
  VATRatio,
  LineTaxValue,
  VATRateLine,
  LineGExclude: Double;

  ACCDep     : CCDepType;

  FoundCode  : Str20;

  KeyChk,
  KeyS       : Str255;

  AutoLine,
  TmpId      : IDetail;

  ProcessCISDoc
             : Boolean;

  LineTotal: Double;
  CISRateCodeToUse: Char;

  // -------------------------------------------------------------------------

  function Calc_CISLineTotal(IdR: IDetail): Double;
  begin
    // If Job Application and not Certified
    if (IdR.IdDocHed In JAPSplit) and not BInv.PDiscTaken then
    begin
      // Temporarily switch to Applied value (store original Net Value in LineNV)
      Switch_JAPLineTotal(IdR, BInv, True, LineNV, 0);

      // Calculate line total
      Result := Round_Up(InvLTotal(IdR, True, 0), 2);

      // Restore original Net Value from LineNV
      Switch_JAPLineTotal(IdR, BInv, False, LineNV, 0);
    end
    else
      // If not a Job Application, or if Certified
      Result := Round_Up(InvLTotal(IdR, True, 0), 2);
  end;

  // -------------------------------------------------------------------------
  // Line Validation routines
  // -------------------------------------------------------------------------
  function TaxIsOk: Boolean;
  begin
    Result := ((Round_Up(BInv.CISTax,2)=Round_Up(LineTaxValue,2)) or (BInv.CISManualTax));
  end;
  // -------------------------------------------------------------------------
  function ValueIsOk: Boolean;
  begin
    Result := ((Round_Up(BInv.CISTax,2)=Round_Up(Id.NetValue,2)) or Id.LiveUplift);
  end;
  // -------------------------------------------------------------------------
  function JobCodeIsOk: Boolean;
  begin
    Result := (Trim(Id.JobCode) = '') and (Trim(Id.AnalCode) = '');
  end;
  // -------------------------------------------------------------------------
  function VATCodeIsOk: Boolean;
  begin
    Result := ((Id.VATCode=VATZCode) or (Id.VATCode=SyssCIS^.CISRates.CISVATCode))
  end;
  // -------------------------------------------------------------------------
  function LineNoIsOk: Boolean;
  begin
    {$IFDEF EX603} // Due to reverse VAT we cannot guarantee line no, and AutoLineType should be enough
    Result := ((Id.LineNo=(BInv.ILineCount-2)) or (Id.LineNo=JALDedLineNo) or (CurrentCountry=IECCode));
    {$ELSE}
    Result := ((Id.LineNo=(BInv.ILineCount-2)) or (Id.LineNo=JALDedLineNo));
    {$ENDIF}
  end;
  // -------------------------------------------------------------------------
  function QtyIsOk: Boolean;
  begin
    Result := (Id.Qty = -1.0) and (Id.QtyMul = 1.0);
  end;
  // -------------------------------------------------------------------------

Begin
  Materials        := 0.0;
  Taxable          := 0.0;
  TaxValue         := 0.0;
  LineVAT          := 0.0;
  VATRatio         := 0.0;
  LineNV           := 0.0;
  LineTaxValue     := 0.0;
  LineGExclude     := 0.0;
  VATRateLine      := 0.0;
  Taxable          := 0.0;
  LineTotal        := 0.0;
  ProcessCISDoc    := BOff;
  DLineOk          := BOff;
  CISRateType      := Construct;
  AGLCode          := 0;
  CalcTax          := False;
  ResetCIS         := (UpdateLine and (BInv.CISHolder=0));

  Blank(ACCDep,Sizeof(ACCDep));

  B_Func := B_GetNext;

  With BInv do                                                                                                                      {* V6.03 Disconnect RCT calculation *}
  // CISDocSet    = [PIN,PCR,PJI,PJC,PPI,PRF]
  // JAPJAPSplit  = [JSA,JPA]
  If (InvDocHed In CISDocSet+JAPJAPSplit) and (CISOn) and (JBCostOn) and ((Not CISManualTax) or (CISHolder<>3)) {$IFDEF EX603} {and (CurrentCountry<>IECCode)} {$ENDIF} then
  Begin
    // JAPSalesSplit = [JST,JSA]
    If (InvDocHed In JAPSalesSplit) then
    Begin
      // Sales

      // Use the CIS configuration from System Setup to determine whether CIS
      // Tax must be calculated
      CalcTax := (SyssCIS^.CISRates.JCISType in [1, 4]);

      // For Sales Applications only, the ProcessCISDoc flag can be set to
      // True if the company is CIS-Taxable
      ProcessCISDoc := CalcTax;
    end
    else
    Begin
      // Purchases

      If (CISEmpl = '') then
        // There is no CIS Employee against this Purchase Application, so
        // search via the Supplier instead
        CISEmpl := Check_CISEmployee(CustCode, CalcTax)
      else
      Begin
        // Search for the Employee record
        KeyS := Strip('R', [#0], PartCCKey(JARCode, JASubAry[3]) + FullEmpCode(CISEmpl));
        LOk  := CheckRecExsists(KeyS, JMiscF, JMK);

        {$B-}
        If (LOk) then
          // Is the Employee CIS-Taxable?
          CalcTax := (JobMisc^.EmplRec.CISType In [1, 4])
        else
        Begin
          // If no Employee was found, search for the Employee via the
          // Supplier code instead
          CISEmpl := Check_CISEmployee(CustCode, CalcTax);

          // Is the Employee CIS-Taxable?
          CalcTax := (JobMisc^.EmplRec.CISType In [1, 4]);
        end;
        {$B+}
      end;

      if (CISEmpl <> '') then
      begin
        // Locate the employee record...
        with Get_SubRec(CISEmpl) do
        begin
          // Determine the CIS rate type for the employee (High, Low, or none)
          case CISType of
            1  :  CISRateCodeToUse := 'T';
            4  :  CISRateCodeToUse := 'C';
            else CISRateCodeToUse  := #0;
          end; {Case..}
        end;
        CISRateType := GetCISCType(CISRateCodeToUse);
      end;
    end;

    If ((CISEmpl<>'') or (ProcessCISDoc)) or (UpdateLine) then {* We have a CIS situation *}
    Begin
      // Validate all the CIS Nominal Codes before continuing
      If (CheckCISGLCodes(1)) then
      Begin
        // Save the current record position of the Details file
        TmpId    := Id;
        TmpKPath := GetPosKey;
        TmpStat  := Presrv_BTPos(IDetailF,TmpKPath,F[IDetailF],TmpRecAddr,BOff,BOff);

        KeyChk := FullNomKey(FolioNum);

        // JAPSplit = [JCT, JST, JPT, JSA, JPA]; {Job Application set}
        If (InvDocHed In JAPSplit) then
          // Search for the first Retention or Deduction line (line numbers of
          // -3 or -2)
          KeyS := FullIdKey(FolioNum, JALRetLineNo)
        else
          // Search for the first normal line
          KeyS := FullIdKey(FolioNum, 1);

        // Work through all the transaction lines against this Application
        Status := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IDFolioK, KeyS);
        while (StatusOk) and (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) do
        with Id do
        begin
          Application.ProcessMessages;

          B_Func := B_GetNext;

          // CJS 2014-02-19 - ABSEXCH-13900 - resetting CIS Tax on footer tab.
          // Default to no CIS Tax. If CIS Tax is required, the next section
          // will set it up.
          CISRateCode := C0;
          CISRate     := 0.0;

          {$B-}
          If ((CISEmpl<>'') or (ProcessCISDoc))      // There is an Employee, or the company is CIS-Taxable
             and (Not EmptyKey(AnalCode,AnalKeyLen)) // An Analysis Code is assigned
             and (Not EmptyKey(JobCode,JobKeyLen))   // A Job Code is assigned
             and (GetJobMisc(Application.MainForm,AnalCode,FoundCode,2,-1)) // The Analysis Code record can be found
             and {$IFDEF EX603} (Not (AutoLineType In [2,3])) {$ELSE} (AutoLineType<>2) {$ENDIF} then
          {$B+}
          With JobMisc^,JobAnalRec do
          If (JAType>=2)  // Overhead, Materials, or Labour
             or ((Not UpdateLine) and (CISRateCode <> #0))  // Rate Code assigned
             or ((LineNo=JALDedLineNo) and (CISTaxRate <> #0)) // Taxable Deduction line
             or (RevenueType>=2) // Revenue type is anything other than simple Revenue
            then
          Begin
            LineTotal := Calc_CISLineTotal(Id);

            If (UpdateLine) then
            Begin
              // If the Analysis Code is CIS-applicable...
              If (CISTaxRate <> #0) then
              Begin
                // ...and if the company or employee is CIS-taxable...
                If (CalcTax) then
                Begin
                  // ...copy the CIS Rate details to the transaction line
                  CISRateCode := CISTaxRate;

                  // Look up the CIS Rates matching the rate code, from system
                  // settings
                  With SyssCIS^.CISRates.CISRate[CISRateType] do
                  Begin
                    CISRate := Rate;
                    AGLCode := GLCode;
                    ACCDep  := RCCDep;
                  end;

                  AutoLine := Id;
                end
                else
                Begin
                  // Not CIS-taxable
                  CISRateCode := C0;
                  CISRate     := 0.0;
                end;

                Status := Put_Rec(F[IDetailF], IDetailF, RecPtr[IDetailF]^, IDFolioK);
                Report_BError(IDetailF,Status);

                //SS:14/07/2017:2017-R2:ABSEXCH-17373:Issue with CIS Tax on JPA linked to JCT if retention percentage changed on JPA.
                if not (InvDocHed in JAPSalesSplit) then
                begin
                  if  (NetValue = 0) and ((QtyPWOff <> 0) or (QtyDel <> 0)) then
                  begin
                    Calc_AddCIS(BInv, Id, LineTotal, BInv.TransMode);
                    LineTotal := LineTotal - CISAdjust;
                  end;
                end;    

              end;
            end;

            // If this line attracts CIS tax (i.e. it is a Labour line)...
            If (CISRateCode <> #0) then
            Begin
              // ...add it to the totals
              Taxable := Taxable + LineTotal;
              LineTaxValue := LineTaxValue + Round_Up(LineTotal * CISRate, 2);
            end
            else
            Begin
              // ...otherwise if it is an Overhead2 line, add it to excluded values
              If (AnalHed = 13) then
                LineGExclude := LineGExclude + LineTotal
              else
                // ...otherwise it must be a Materials line
                Materials := Materials + LineTotal;
            end;

            ResetCIS := False;

          end;

          // Delete any auto manufactured CIS lines
          If (UpdateLine) and (AutoLineType = 2) then
          Begin
            // Check that a new line is required before auto deleting
            {$B-}
            DLineOk := TaxIsOk     and
                       ValueIsOk   and
                       JobCodeIsOk and
                       VATCodeIsOk and
                       LineNoIsOk  and
                       QtyIsOk;
            {$B+}
            If (Not DLineOk) then
            Begin
              AutoLine := Id;

              Status := Delete_Rec(F[IDetailF], IDetailF, IDFolioK);

              Report_BError(IDetailF, Status);

              // Go back to the start of the transaction lines and work through
              // them again
              B_Func := B_GetGEq;
            end;
          end;

          Status := Find_Rec(B_Func, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IDFolioK, KeyS);

        end; { while (StatusOK)... }

        If (UpdateLine) then
        Begin
          If (CISHolder = 0) then
          Begin
            // If this is a Purchase Application, or the calculate-on-gross flag
            // is turned off, apply any CIS Adjustment...
            if not (InvDocHed in JAPSalesSplit) or not SyssCIS.CISRates.CalcCISOnGross then
            begin
              //SS:04/10/2017:2017-R2:ABSEXCH-19206:Incorrect CIS Tax is calculated in Job Purchase Application when Retention Type is 'Practical'
              if TransMode = 2 then
                CISGross := Taxable
              else
                CISGross := Taxable - CalculateCISAdjustment(BInv, Taxable, BInv.TransMode);
            end
            else
              // ...otherwise use the unadjusted value
              CISGross := Taxable;

            CISGExclude := LineGExclude;
          end;

          If (Not CISManualTax) then
            CISTax := Round_Up(CISGross * SyssCIS^.CISRates.CISRate[CISRateType].Rate, 2);

          // If there is CIS Tax, we need to add a 'Tax Withheld' line
          if (CISTax <> 0.0) and (AutoLine.FolioRef = FolioNum) and (not DLineOk) then {Decrease value of transaction by Tax amount}
          with Id do
          begin
            ResetRec(IDetailF);

            // Copy details from the header
            FolioRef := BInv.FolioNum;
            IdDocHed := BInv.InvDocHed;
            CustCode := BInv.CustCode;
            Currency := BInv.Currency;
            CXRate   := BInv.CXRate;
            CurrTriR := BInv.CurrTriR;
            PYr      := BInv.ACYr;
            PPr      := BInv.AcPr;
            DocPRef  := BInv.OurRef;

            // Set up other details
            AutoLineType := 2;
            NetValue     := CISTax;
            Qty          := -1;
            QtyMul       := 1.0;
            PriceMulX    := 1.0;

            // JAPSplit = [JCT,JST,JPT,JSA,JPA]
            if (IdDocHed In JAPSplit) then
            begin
              LineNo    := JALDedLineNo;
              Payment   := DocPayType[SIN];
              Reconcile := 1; // Line mode = Deduction
            end
            else
            begin
              LineNo  := BInv.ILineCount;
              Payment := DocPayType[BInv.InvDocHed];
            end;
            ABSLineNo := LineNo;

            If (AGLCode <> 0) then
              NomCode := AGLCode
            else
              NomCode := AutoLine.NomCode;

            With SyssCIS^.CISRates do
            If (CISVATCode In VATSet) then
              VATCode := CISVATCode
            else
              VATCode := VATZCode;

            If (ACCDep[BOff]<>'') then
              CCDep := ACCDep
            else
              CCDep := AutoLine.CCDep;

            Desc := CCCISName^ + ' tax withheld from ' +
                    Form_Real(CISGross, 0, 2) + ' liable for deduction.';

            {$IFDEF STK}
            LineType := StkLineType[IdDocHed];
            {$ENDIF}

            Status := Add_Rec(F[IDetailF], IDetailF, RecPtr[IDetailF]^, IDFolioK);
            Report_BError(IDetailF, Status);

            BInv.ILineCount := BInv.ILineCount + 2;

          end;
        end; { if UpdateLine... }

        // Restore the Details table record position
        TmpStat := Presrv_BTPos(IDetailF, TmpKPath, F[IDetailF], TmpRecAddr, BOn, BOff);
        Id      := TmpId;
      end; { if CheckCISGLCodes(1)... }
    end; { if (CISEmpl<>'')... }

    If (ResetCIS) and (Not CISManualTax) then
      Reset_DOCCIS(BInv, BOff);
  end; {If..}

  {$IFDEF EX603} {* Apply Reverse Charge Lines *}
  Calc_RCTReverseVAT(BInv, UpdateLine);
  {$ENDIF}
end;


// CJS 2014-03-18 - ABSEXCH-14289 - incorrect CIS Calculation when CITB Deduction is set to 1.5%
// This Calc_CISTax() procedure is no longer used (see CalculateCISTax() above).

{ == Proc to scan Lines to work out materials and taxables == }
{ == Reproduced inside JobPostU.pas, for thread safe operation == }

Procedure Calc_CISTax(Var BInv    :   InvRec;
                      Var Materials,
                          Taxable,
                          TaxValue:   Double;
                          UpLine  :   Boolean);

Const
  Fnum     =  IDetailF;
  Keypath  =  IDFolioK;

Var
  LOk,CalcTax,
  DLineOk,
  ResetCIS
             : Boolean;
  B_Func,
  TmpStat,
  TmpKPath   : Integer;

  AGLCode,
  TmpRecAddr : LongInt;

  VATRate    : VATType;

  CISLoop,
  CISRateType: CISTaxType;

  CISGrossTotal
             : Array[CISTaxType] of Double;

  LineVAT,
  LineNV,
  VATRatio,
  LineTaxValue,
  VATRateLine,
  AppsVAT,
  LineGExclude,
  LineTotal  : Double;

  ACCDep     : CCDepType;

  FoundCode  : Str20;

  KeyChk,
  KeyS       : Str255;

  AutoLine,
  TmpId      : IDetail;

  ProcessCISDoc
             : Boolean;

  Function Calc_CISLineTotal(IdR    :  IDetail;
                             tMode  :  Byte)  :  Double;

  Begin
    With IdR do
      If (IdDocHed In JAPSplit) and (Not BInv.PDiscTaken) then {*Act on applied value *}
      Begin
        Switch_JAPLineTotal(IdR,BInv,BOn,LineNV,0);

        Result:=Round_Up(InvLTotal(IdR,BOn,0),2);

        Switch_JAPLineTotal(IdR,BInv,BOff,LineNV,0);
      end
      else
        Result:=Round_Up(InvLTotal(IdR,BOn,0),2);


  end;

  // -------------------------------------------------------------------------
  // CJS 10/11/2010 - Line Validation routines (to replace a convoluted
  // Boolean expression and make it easier to trace any problems).
  // -------------------------------------------------------------------------
  function TaxIsOk: Boolean;
  begin
    Result := ((Round_Up(BInv.CISTax,2)=Round_Up(LineTaxValue,2)) or (BInv.CISManualTax));
  end;
  // -------------------------------------------------------------------------
  function ValueIsOk: Boolean;
  begin
    Result := ((Round_Up(BInv.CISTax,2)=Round_Up(Id.NetValue,2)) or Id.LiveUplift);
  end;
  // -------------------------------------------------------------------------
  function JobCodeIsOk: Boolean;
  begin
    Result := (Trim(Id.JobCode) = '') and (Trim(Id.AnalCode) = '');
  end;
  // -------------------------------------------------------------------------
  function VATCodeIsOk: Boolean;
  begin
    Result := ((Id.VATCode=VATZCode) or (Id.VATCode=SyssCIS^.CISRates.CISVATCode))
  end;
  // -------------------------------------------------------------------------
  function LineNoIsOk: Boolean;
  begin
    {$IFDEF EX603} // Due to reverse VAT we cannot guarantee line no, and AutoLineType should be enough
    Result := ((Id.LineNo=(BInv.ILineCount-2)) or (Id.LineNo=JALDedLineNo) or (CurrentCountry=IECCode));
    {$ELSE}
    Result := ((Id.LineNo=(BInv.ILineCount-2)) or (Id.LineNo=JALDedLineNo));
    {$ENDIF}
  end;
  // -------------------------------------------------------------------------
  function QtyIsOk: Boolean;
  begin
    Result := (Id.Qty=-1.0) and (Id.QtyMul=1.0);
  end;
  // -------------------------------------------------------------------------

Begin
  Materials:=0.0; Taxable:=0.0; TaxValue:=0.0;  LineTotal:=0.0; LineVAT:=0.0;  VATRatio:=0.0; ResetCIS:=(UpLine and (BInv.CISHolder=0));

  LineNV:=0.0; LineTaxValue:=0.0; LineGExclude:=0.0; VATRateLine:=0.0;

  Blank(CISGrossTotal,Sizeof(CISGrossTotal));

  ProcessCISDoc:=BOff;

  DLineOk:=BOff;

  CISRateType:=Construct;  AGLCode:=0; Blank(ACCDep,Sizeof(ACCDep));

  B_Func:=B_GetNext;

  With BInv do                                                                                                                      {* V6.03 Disconnect RCT calculation *}
  // CISDocSet    = [PIN,PCR,PJI,PJC,PPI,PRF]
  // JAPJAPSplit  = [JSA,JPA]
  If (InvDocHed In CISDocSet+JAPJAPSplit) and (CISOn) and (JBCostOn) and ((Not CISManualTax) or (CISHolder<>3)) {$IFDEF EX603} {and (CurrentCountry<>IECCode)} {$ENDIF} then
  Begin
    // JAPSalesSplit = [JST,JSA]
    If (InvDocHed In JAPSalesSplit) then {* Work out simulated tax for contractor *}
    Begin
      // Use the CIS configuration from System Setup to determine whether CIS
      // Tax must be calculated
      CalcTax:=(SyssCIS^.CISRates.JCISType In [1,4]);

      // For Sales Applications only, the ProcessCISDoc flag can be set to
      // True, if the company is CIS-Taxable
      ProcessCISDoc:=CalcTax;
    end
    else
    Begin

      If (CISEmpl='') then
        // There is no CIS Employee against this Purchase Application, so
        // search via the Supplier instead
        CISEmpl := Check_CISEmployee(CustCode, CalcTax)
      else
      Begin
        // Search for the Employee record
        KeyS:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(CISEmpl));
        LOk:=CheckRecExsists(KeyS,JMiscF,JMK);

        {$B-}
          If (LOk) then
            // Is the Employee CIS-Taxable?
            CalcTax := (JobMisc^.EmplRec.CISType In [1,4])
          else
          Begin
            // If no Employee was found, search for the Employee via the
            // Supplier code instead
            CISEmpl := Check_CISEmployee(CustCode,CalcTax);

            // Is the Employee CIS-Taxable?
            CalcTax := (JobMisc^.EmplRec.CISType In [1,4])
          end;
        {$B+}

      end;
    end;

    If ((CISEmpl<>'') or (ProcessCISDoc)) or (UpLine) then {* We have a CIS situation *}
    Begin
      // Validate all the CIS Nominal Codes before continuing
      If (CheckCISGLCodes(1)) then
      Begin
        // Save the current record position of the Details file
        TmpId    := Id;
        TmpKPath := GetPosKey;
        TmpStat  := Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

        KeyChk:=FullNomKey(FolioNum);

        // JAPSplit = [JCT, JST, JPT, JSA, JPA]; {Job Application set}
        If (InvDocHed In JAPSplit) then
          // Search for the first Retention or Deduction line (line numbers of
          // -3 or -2)
          KeyS:=FullIdKey(FolioNum, JALRetLineNo)
        else
          // Search for the first normal line
          KeyS:=FullIdKey(FolioNum, 1);

        // Work through all the transaction lines against this Application
        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
        With Id do
        Begin
          Application.ProcessMessages;

          B_Func:=B_GetNext;

          AppsVAT:=0.0;

          // CJS 2014-02-19 - ABSEXCH-13900 - resetting CIS Tax on footer tab.
          // Default to no CIS Tax. If CIS Tax is required, the next section
          // will set it up.
          CISRateCode := C0;
          CISRate     := 0.0;

          {$B-}
          If ((CISEmpl<>'') or (ProcessCISDoc))      // There is an Employee, or the company is CIS-Taxable 
             and (Not EmptyKey(AnalCode,AnalKeyLen)) // An Analysis Code is assigned
             and (Not EmptyKey(JobCode,JobKeyLen))   // A Job Code is assigned
             and (GetJobMisc(Application.MainForm,AnalCode,FoundCode,2,-1)) // The Analysis Code record can be found 
             and {$IFDEF EX603} (Not (AutoLineType In [2,3])) {$ELSE} (AutoLineType<>2) {$ENDIF} then
          {$B+}
          With JobMisc^,JobAnalRec do
          If (JAType>=2)  // Overhead, Materials, or Labour
             or ((Not UpLine) and (CISRateCode<>C0))  // Rate Code assigned
             or ((LineNo=JALDedLineNo) and (CISTaxRate<>C0)) // Taxable Deduction line
             or (RevenueType>=2) // Revenue type is anything other than simple Revenue
            then
          Begin
            LineTotal:=Calc_CISLineTotal(Id,0);

            If (UpLine) then
            Begin
              // If the Analysis Code is CIS-applicable...
              If (CISTaxRate<>C0) then
              Begin
                // ...and if the company or employee is CIS-taxable...
                If (CalcTax) then
                Begin
                  // ...copy the Analysis CIS Tax Code to the transaction line
                  CISRateCode:=CISTaxRate;

                  // If the new CIS340 UK rules are in force (always the case
                  // now)...
                  If (CurrentCountry<>IECCode) and (CIS340) then
                  Begin
                    // ...locate the employee record...
                    With Get_SubRec(CISEmpl) do
                      If (EmpCode=CISEmpl) then
                      Begin
                        // ...and determine which actual tax code to use --
                        // either the one from the Employee or the one from
                        // the Analysis Code
                        CISRateCode:=Resolve_CISTaxCode(CISType,CISTaxRate);
                      end;
                  end;

                  // Look up the CIS Rates matching the rate code, from system
                  // settings
                  CISRateType := GetCISCType(CISRateCode);
                  With SyssCIS^.CISRates.CISRate[CISRateType] do
                  Begin
                    CISRate:=Rate;
                    AGLCode:=GLCode;
                    ACCDep:=RCCDep;
                  end;

                  AutoLine:=Id;
                end
                else
                Begin
                  // Not CIS-taxable
                  CISRateCode:=C0;
                  CISRate:=0.0;
                end;

                Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

                Report_BError(Fnum,Status);

                // CJS 2014-02-12 - ABSEXCH-14946 - JSA Retention and CIS Tax
                //                  Calculation - Apply deductions and
                //                  retentions to non-sales applications only
                // CJS 2014-03-05 - ABSEXCH-15114 - system switch for CIS calculation
                if not (InvDocHed in JAPSalesSplit) or not SyssCIS.CISRates.CalcCISOnGross then
                  Calc_AddCIS(BInv, Id, LineTotal, BInv.TransMode); {*EN560 pass in correct imode*}

                LineTotal := LineTotal - CISAdjust;

              end;
            end;

            If (CISRateCode<>C0) then
            Begin
              Taxable:=Taxable+LineTotal;

              {$IFDEF EX603}
                If (True=False) then {* Do not work out RCT with VAT from v6.03 onwards *}
              {$ELSE}

              If (CurrentCountry=IECCode) then

              {$ENDIF}
              Begin
                If (Not ManVAT) then
                Begin
                  {* v5.61.001 Calculate VAT element of CISAdjust as well *}
                  VATRateLine:=TrueReal(SyssVAT^.VATRates.VAT[GetVATNo(VatCode,VATIncFlg)].Rate,10);

                  AppsVAT:=Round_Up(CISAdjust*VATRateLine,2);
                  {}

                  LineTaxValue:=LineTaxValue+Round_Up((LineTotal+VAT-AppsVAT)*CISRate,2);
                  CISGrossTotal[CISRateType]:=CISGrossTotal[CISRateType]+Round_Up((LineTotal+VAT-AppsVAT),2);
                end
                else
                Begin {!!! This would need changing to the LDef_InvCalc version for the thread safe version of this}
                  Def_InvCalc; {Work out goods vat split}

                  VATRate:=GetVAtNo(VATcode,VATIncFlg);

                  VATRatio:=DivWChk(LineTotal,InvNetAnal[VATRate]);

                  LineVAT:=Round_Up((InvVATAnal[VATRate]*VatRatio),2);

                  LineTaxValue:=LineTaxValue+Round_Up((LineTotal+LineVAT)*CISRate,2);

                  CISGrossTotal[CISRateType]:=CISGrossTotal[CISRateType]+Round_Up((LineTotal+VAT),2);
                end;
              end
              else
              Begin
                // CJS 2014-03-04 - ABSEXCH-11892 - CIS Rounding - do not
                // truncate at this point
                LineTaxValue:=LineTaxValue+Round_Up(LineTotal*CISRate,2);
                CISGrossTotal[CISRateType]:=CISGrossTotal[CISRateType]+Round_Up((LineTotal),2);
              end;

            end
            else
            Begin
              If (AnalHed=13) {and (Not CalcTax)} then {For all CIS types, exclude Overhead2 type analysis lines with no CIS implications}
                LineGExclude:=LineGExclude+LineTotal
              else
                Materials:=Materials+LineTotal;

            end;


            ResetCIS:=BOff;

          end;


          If (UpLine) and (AutoLineType=2) then {* Delete any auto manufactured CIS lines *}
          Begin
            {* Check a new line is required before auto deleting *}
            // CJS 10/11/2010 - Replaced line validation expression with
            // function calls, for clarity.
            {$B-}
            DLineOk := TaxIsOk     and
                       ValueIsOk   and
                       JobCodeIsOk and
                       VATCodeIsOk and
                       LineNoIsOk  and
                       QtyIsOk;
            {$B+}
            If (Not DLineOk) then
            Begin
              AutoLine:=Id;

              Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

              Report_BError(Fnum,Status);

              B_Func:=B_GetGEq;
            end;
          end;

          Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end; {While..}

        For CISLoop:=Low(CISGrossTotal) to High(CISGrossTotal) do
        Begin
          // CJS 2014-03-04 - ABSEXCH-11892 - CIS Rounding - do not
          // truncate at this point
          TaxValue:=TaxValue+Round_Up(CISGrossTotal[CISLoop]*SyssCIS^.CISRates.CISRate[CISLoop].Rate,2);
        end; {Loop..}

        If (UpLine) then
        Begin
          If (Not CISManualTax) then
          Begin
            CISTax:=TaxValue;
          end;

          If (CISHolder=0) then
          Begin
            CISGross:=Taxable;  {If we do not proctect here, special transactions like retentions or self billing get reset to zero}

            CISGExclude:=LineGExclude;

          end;

          If (CISTax<>0.0) and (AutoLine.FolioRef=FolioNum) and (Not DLineOk) then {Decrease value of transaction by Tax amount}
          With Id do
          Begin
            ResetRec(Fnum);

            FolioRef:=FolioNum;

            IdDocHed:=InvDocHed;

            AutoLineType:=2;

            If (IdDocHed In JAPSplit) then
            Begin
              LineNo:=JALDedLineNo;
              Payment:=DocPayType[SIN];
              Reconcile:=1;
            end
            else
            Begin
              LineNo:=ILineCount;
              Payment:=DocPayType[InvDocHed];
            end;

            ABSLineNo:=LineNo;

            ILineCount:=ILineCount+2;

            If (AGLCode<>0) then
              NomCode:=AGLCode
            else
              NomCode:=AutoLine.NomCode;

            NetValue:=CISTax;

            With SyssCIS^.CISRates do
            If (CISVATCode In VATSet) then
              VATCode:=CISVATCode
            else
              VATCode:=VATZCode;

            Qty:=-1; QtyMul:=1.0;

            If (ACCDep[BOff]<>'') then
              CCDep:=ACCDep
            else
              CCDep:=AutoLine.CCDep;

            Desc:=CCCISName^+' tax withheld from '+Form_Real(CISGross,0,2)+' liable for deduction.';


            PriceMulX:=1.0;

            CustCode:=BInv.CustCode;

            Currency:=BInv.Currency;

            CXRate:=BInv.CXRate;

            CurrTriR:=BInv.CurrTriR;

            PYr:=BInv.ACYr;
            PPr:=BInv.AcPr;

            {$IFDEF STK}
              LineType:=StkLineType[IdDocHed];
            {$ENDIF}

            DocPRef:=OurRef;

            Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

            Report_BError(Fnum,Status);
          end;
        end;

        TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
        Id:=TmpId;
      end; {If..}
    end; {If..GL Codes OK}

    If (ResetCIS) and (Not CISManualTax) then
      Reset_DOCCIS(BInv,BOff);
  end; {If..}

  {$IFDEF EX603} {* Apply Reverse Charge Lines *}
    Calc_RCTReverseVAT(BInv,UpLine);
  {$ENDIF}
end; {Proc..}


{ == Procedure to Intercept CIS Tax Calculation == }

Function Calc_CISTaxInv(Var  BInv    :  InvRec;
                             UpDate  :  Boolean)  :  Double;

Var
  Materials,
  Taxable,
  TaxValue  :   Double;

Begin
  Materials:=0.0; Taxable:=0.0; TaxValue:=0.0;

  // CJS 2014-03-18 - ABSEXCH-14289 - incorrect CIS Calculation when CITB Deduction is set to 1.5%
  CalculateCISTax(BInv,Materials,Taxable,TaxValue,UpDate);

  Result:=Materials+Taxable;
end;





  Function Calc_NewCISPeriod(LastVDate  :  LongDate;
                           NoMnths    :  Integer)  :  LongDate;

  Var
    Vd,Vm,Vy  :  Word;

  Begin
    DateStr(LastVDate,Vd,Vm,Vy);

    AdjMnth(Vm,Vy,NoMnths);

    If (vd>MonthDays[Vm]) or (CurrentCountry=IECCode) then
    Begin
      vd:=MonthDays[Vm];

      if ((int(Vy/4)*4)<>Vy) and (Vm=2) then  {* Adjust for leap year *}
        Vd:=Pred(Vd);
    end;
    
    Result:=StrDate(Vy,Vm,Vd);
  end;




  { ================= Routine to Close Current Period ============== }

  Procedure Close_CurrCISPeriod;

  Var
    Locked   :  Boolean;



  Begin

    Locked:=BOn;

    GetMultiSys(BOn,Locked,CISR);


    With SyssCIS.CISRates do
    Begin

      CISReturnDate:=CurrPeriod;

      CurrPeriod:=Calc_NewCISPeriod(CISReturnDate,CISInterval);

    end; {With..}

    PutMultiSys(CISR,BOn);

  end; {Proc..}

  {Proc to calculate start and end date of return}

  Procedure Calc_CISEOYRange(Var SDate, EDate  :  LongDate;
                                 AMonth        :  Boolean);
  Var
    CM,CY, CD  :  Word;
    AYr        :  Integer;

  Begin
    If (CISOn) then
    With SyssCIS.CISRates do
    Begin
      CY:=Part_Date('Y',CurrPeriod);
      CM:=Part_Date('M',CurrPeriod);
      CD:=Part_Date('D',CurrPeriod);

      If (AMonth) then
      Begin
        AdjMnth(CM,CY,-1);

        SDate:=StrDate(CY,Cm,Cd);

        If (CIS340) then
          SDate:=CalcDueDate(SDate,1);
      end
      else
      Begin
        If (CM<04) then
          AYr:=-1
        else
          AYr:=1;

        SDate:=StrDate(CY+AYr,04,Cd);
      end;

      EDate:=CurrPeriod;

    end {With..}
    else
    Begin
      SDate:=SimplePr2Date(01,Syss.CYr);

      EDate:=Today;
    end;
  end;

  { ============== Return CIS Period ============== }

  Function CalcCISDate(DDate  :  LongDate)  :  LongDate;

  Var
    VDate  :  LongDate;

  Begin
    With SyssCIS.CISRates do
    Begin

      If (CurrPeriod<>'') then
        VDate:=CurrPeriod
      else
        VDate:=Today;


      If (DDate>VDate) then
        While (DDate>VDate) and (CISInterval<>0) do
          VDate:=Calc_NewCISPeriod(VDate,CISInterval);

    end; {With..}

    Result:=VDate;

  end; {Func..}


  { ====== Set Doc CIS Date Status based on allocation routine ====== }

  Procedure Set_DocCISDate(Var  InvR      :    InvRec;
                                UnalMode  :    Boolean);

  Begin
    With InvR do
    {$B-}
    If (CISOn) and (InvDocHed In CISDocSet) and (RunNo>0) then
    {$B+}
    Begin
      If (CurrSettled<>CISDeclared) or (UnalMode and (CISDeclared<>0.0)) then
      Begin
        If (SyssCIS^.CISRates.CISAutoSetPr) then
          CISDate:=CalcCISDate(Today)
        else
          CISDate:=SyssCIS^.CISRates.CurrPeriod;
      end
      else
        Blank(CISDate,SizeOf(CISDate));


    end; {Correct mode}
  end;


  { == Return CIS Voucher type == }
  Function CISVTypeName(CVT  :  Byte)  :  Str10;

  Begin
    // ****  HM 09/01/03: Duplicated in DicLinkU  ****

    If (CurrentCountry=IECCode) then
    Begin
      Case CVT of
        4  :  Result:='RCTDC';
        else  Result:='RCT47';
      end;

    end
    else
    Begin
      Case CVT of
        5  :  Result:='Zero Rate';
        6  :  Result:='CIS24';
        else  Result:='Low/High';
      end;

    end;

    // ****  HM 09/01/03: Duplicated in DicLinkU  ****
  end;


  { == Return CIS Voucher type == }
  Function CIS340VTypeName(CVT  :  Byte)  :  Str10;

  Begin
    // ****  HM 09/01/03: Duplicated in DicLinkU  ****

    If (CurrentCountry=IECCode) then
    Begin
      Result:=CISVTypeName(CVT);
    end
    else
    Begin
      Case CVT of

        0  :  Result:='N/A';
        1  :  Result:='High';
        4  :  Result:='Low';
        2,5
           :  Result:='Zero Rate';
        6  :  Result:='CIS24';

        else  Result:='Low/High';

      end;

    end;

    // ****  HM 09/01/03: Duplicated in DicLinkU  ****
  end;


  { == Return CIS Voucher Mode == }

  Function CISVTypeOrd(CVT  :  Byte;
                       From :  Boolean)  :  Byte;

  Begin
    Result:=0;

    If (From) then
    Begin
      Case CVT of
        0  :  Result:=5;
        1  :  Result:=6;
        2  :  Result:=4;
      end; {Case..}

    end
    else
    Begin
      Case CVT of
        4  :  Result:=2;
        5  :  Result:=0;
        6  :  Result:=1;
      end; {Case..}
    end;


  end;


{ == Generate Match for voucher. == }
{Reproduced in CISSup2U for thread safe operation. LMatch_Voucher}

  Procedure Match_Voucher(InvR    :  InvRec;
                          VFolio  :  Str10;
                          AddT,
                          AddN,
                          AddG    :  Real;
                          Mode    :  Byte);

  Const
    Fnum      = PWrdF;
    Keypath   = PWK;



  Begin

    Case Mode of

      8
             :  With Password do
                With MatchPayRec do
                Begin

                  ResetRec(Fnum);

                  RecPFix:=MatchTCode;
                  SubType:=MatchCCode;

                  DocCode:=InvR.OurRef;
                  PayRef:=VFolio;

                  AltRef:=InvR.YourRef;

                  SettledVal:=AddT*DocCnst[InvR.InvDocHed];

                  OwnCVal:=AddG*DocCnst[InvR.InvDocHed];

                  RecOwnCVal:=AddN*DocCnst[InvR.InvDocHed];

                  MCurrency:=InvR.Currency;

                  MatchType:=MatchCCode;

                  Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

                  Report_BError(Fnum,Status);

                end;
      end; {Case..}

  end; {Proc..}


  {$IFDEF JAP}
    { == Proc to Delete application Transaction == }

    Function  Delete_Application(InvR       :  InvRec;
                                 ShowMsg    :  Boolean;
                                 ScanFileNum,
                                 Keypath    :  Integer;
                             Var ExLocal    :  TdExLocal)  :  Boolean;

    Var
      LOK,
      Locked :  Boolean;
      MbRet  :  Word;
      KeyS   :  Str255;
      LAddr  :  LongInt;
      BInv   :  InvRec;


    Begin
      Result:=BOff;

      Blank(BInv,Sizeof(BInv));

      With InvR do
      Begin
        BInv.InvDocHed:=InvDocHed; BInv.OurRef:=OurRef;  BInv.NomAuto:=NomAuto;

        LOK:=((InvDocHed In JAPSplit-JAPJAPSplit) and (Round_Up(TotalOrdered+PostDiscAm+TotOrdOS+TotalReserved,2)=0.0)) or
             ((InvDocHed In JAPJAPSplit) and ((RunNo=JSAUPRunNo) or (RunNo=JPAUPRunNo))) and (Not PrintedDoc);

        If (ShowMsg) then
        Begin
          If (LOk) then
            MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Transaction',
                             mtConfirmation,[mbOk,mbCancel],0)
          else
            MbRet:=MessageDlg('It is not possible to delete this Transaction',
                             mtInformation,[mbOk],0);
        end
        else
          mbRet:=mrOk;


      end; {With..}

      If (LOk) and (mbRet=mrOk) then
      With ExLocal do
      Begin

        //PR: 21/06/2012 ABSEXCH-11528 Moved so that balance is updated before transaction is deleted, allowing
        //vat on o/s to be calculated.
        With InvR do
          If (NomAuto) and (InvDocHed In JAPOrdSplit)  and ((InvDocHed<>JST) or EmptyKey(InvR.DeliverRef,DocKeyLen)) then {* Update customer comitted value *}
            UpdateCustAppBal(InvR,BInv);

        LInv:=InvR;

        LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,Keypath,ScanFileNum,BOff,Locked,LAddr);

        If (LOk) and (Locked) then
        Begin
          Status:=Delete_Rec(F[ScanFileNum],ScanFileNum,Keypath);

          Report_BError(ScanFileNum,Status);

          If (StatusOk) then {* Delete any dependant links etc *}
          Begin
            Result:=BOn;

            DeleteLinks(FullIdkey(InvR.FolioNum,JALRetLineNo),IdetailF,Sizeof(InvR.FolioNum),IdFolioK,BOff);


            {$IFDEF C_On}

              Delete_Notes(NoteDCode,FullNomKey(InvR.FolioNum)); {* Auto Delete Notes *}

              Remove_MatchPay(InvR.OurRef,DocMatchTyp[BOn],MatchSCode,BOff); {* Delete matching *}

            {$ENDIF}

            {$IFDEF LTR}
              DeleteLetters (LetterDocCode,FullNomKey(InvR.FolioNum));

            {$ENDIF}



          end;
        end;
      end;
    end; {PRoc..}
  {$ENDIF}

end.
