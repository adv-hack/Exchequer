unit ABNAMRO1;

{ prutherford440 15:08 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }



interface

Uses Controls, Forms, StdCtrls, {TEditVal,} CustWinU, IniFiles, CustAbsU, ABNAMRO2;

Type

  TABNObj   =  Class
                 Private

                   PopDir       :  String;
                   ClieOpFile   :  TClieOpFile;
                   BTL91File    :  TBTL91File;

                   Function ReadIniValues  :  Boolean;



                 Public
                   Failed,
                   RecOrder      :  SmallInt;
                   RunAborted    :  Boolean;

                   EntCtrlRecs   :  TEntCliOpRecs;
                   ABNCtrlRecs   :  TCliOpRecs;

                   EntSWIFTRecs  :  TEntBTL91Recs;
                   SWIFTCtrlRecs :  TBTL91Recs;

                   ProcControl   :  TABNControl;

                   ABNIni        :  TIniFile;

                   Constructor Create;

                   Destructor  Destroy;

                   Function Init_File(Const EventData : TAbsEnterpriseSystem;
                                            VMode     :  Byte)  :  Boolean;

                   Procedure Close_File;

                   Procedure Erase_File;

                   Procedure ShowFileCreated;

                   Procedure GetEventData(Const EventData : TAbsEnterpriseSystem);

                   Function ValidateAccount(Const EventData : TAbsEnterpriseSystem)  :  Boolean;

                   Function Write_ClieOp(ThisRec  :  TClieOp)  :  Boolean;

                   Procedure ConvEntClieOp(ThisRec  :  TEntClieOp;
                                           CMode    :  Byte);

                   Function Write_BTL91(ThisRec  :  TBTL91)  :  Boolean;

                   Procedure ConvEntBTL91(ThisRec  :  TEntBTL91;
                                          CMode    :  Byte);

                   Procedure Write_Header(Const EventData : TAbsEnterpriseSystem);

                   Procedure Write_Payment(Const EventData : TAbsEnterpriseSystem);

                   Procedure Write_Footer(Const EventData : TAbsEnterpriseSystem);

               end; {Class}

Var
  ABNObj  :  TABNObj;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses Dialogs,SysUtils, FileUtil;

Const
  ABNINIFile  =  'ENTABNHK.INI';

  PayFile     :  Array[FALSE..TRUE] of String[11] = ('CLIEOP03.','BTL91.TXT');



  Function TABNObj.ReadIniValues  :  Boolean;

  var
    n          :  SmallInt;
    BankSec    :  String[10];
    IName      :  String;

  Begin
    FillChar(ProcControl,Sizeof(ProcControl),0);
    //PR 10/09/03 Change to get ini file from Enterprise dir rather than application dir.
    Iname := GetEnterpriseDirectory + ABNIniFile;
//    Iname:=ProperPath(ExtractFileDir(ParamStr(0)))+ABNIniFile;

    
    ABNIni:=TIniFile.Create(IName);

    try
      Result:=True;

      With ABNIni,ProcControl do
      Begin
        DomesticCGL[FALSE]:=ReadInteger('CONTROL','DOMESTIC_PAYMENT_GL',0);
        DomesticCGL[TRUE]:=ReadInteger('CONTROL','FOREIGN_PAYMENT_GL',0);
                                                  
        TestMode:=(ReadInteger('CONTROL','TEST_MODE',0)=1);

        DomesticDir[FALSE]:=ProperPath(ReadString('CONTROL','DOMESTIC_DIR',''));
        DomesticDir[TRUE]:=ProperPath(ReadString('CONTROL','FOREIGN_DIR',''));
        PayDesc:=ReadString('CONTROL','PAYMENT_DESC','WWW UPS Payment.');


        For n:=Low(Banks) to High(Banks) do
        With Banks[n] do
        Begin
          BankSec:='BANK'+IntToStr(n);
          EntGLCode:=ReadInteger(BankSec,'ENT_GL_CODE',0);
          SWIFTCode:=ReadString(BankSec,'SWIFT_CODE','');
          BANKName:=ReadString(BankSec,'BANK_NAME','');
          BankTown:=ReadString(BankSec,'BANK_TOWN','');
          ISOCountry:=ReadString(BankSec,'BANK_ISO_COUNTRY','');
          BankCountry:=ReadString(BankSec,'BANK_COUNTRY','');
          BankACNo:=ReadString(BankSec,'BANK_ACCOUNT_NO','');
          BANKXChange:=ReadString(BankSec,'BANK_EXCHANGE_CODE','ABNA');
          ISOCurrency:=ReadString(BankSec,'BANK_ISO_CURRENCY','');
        end;

      end;

    except
      ABNINI.Free;
      ABNIni:=nil;
      Result:=FALSE;

    end;


  end;


  Constructor TABNObj.Create;

  Begin
    FillChar(EntCtrlRecs,Sizeof(EntCtrlRecs),0);
    FillChar(ABNCtrlRecs,Sizeof(ABNCtrlRecs),#32);

    FillChar(SWIFTCtrlRecs,Sizeof(EntCtrlRecs),#32);
    FillChar(EntSWIFTRecs,Sizeof(EntSWIFTRecs),0);

    FillChar(ProcControl,Sizeof(ProcControl),0);


    RunAborted:=FALSE;
    RecOrder:=1;
    
    Failed:=Ord (Not ReadIniValues);
  end;


  Destructor TABNObj.Destroy;

  Begin
    Inherited;

    If (Assigned(ABNIni)) then
    Begin
      ABNIni.Free;
      ABNIni:=nil;

    end;

  end;


      { ====== Procedure to manage the control of Producing EDI File ==== }


Function TABNObj.Init_File(Const EventData : TAbsEnterpriseSystem;
                                 VMode     :  Byte)  :  Boolean;

Var
  FileOk   :  Boolean;

  n        :  Byte;
  SwapFileName

           :  ANSIString;

  TmpIO    :  Integer;


Begin

  {$I-}

  Try
    GetDir(0,PopDir);

    Report_IOError(IOResult,PopDir);

  except;
    PopDir:='';

  end;

  n:=1;

  FileOK:=FALSE;

  GetEventData(EventData);

  With ProcControl do
  Begin

    Repeat
      If (ForeignMode) then
        SwapFileName:='A'+Form_ZInt(n,2)+PayFile[ForeignMode]
      else
        SwapFileName:=PayFile[ForeignMode]+Form_ZInt(n,3);

      FileCounter:=n;

      Inc(n);

      FileOK:=(Not FileExists(DomesticDir[ForeignMode]+SwapFileName));
    Until (FileOK) or (n>99);


    If (FileOK) then
    Begin

      If (ForeignMode) then
      Begin
        Assign(BTL91File,DomesticDir[ForeignMode]+SwapFileName);
        ReWrite(BTL91file);
      end
      else
      Begin
        Assign(ClieOpFile,DomesticDir[ForeignMode]+SwapFileName);
        ReWrite(ClieOpFile);
      end;

      TmpIO:=IOResult;

      Report_IOError(TmpIO,DomesticDir[ForeignMode]+SwapFileName);

      Result:=(TmpIO=0);

      If (Result) then
        PayFileName:=SwapFileName;
    end
    else
    Begin
{      ShowMessage('Unable to create the file '+PayFile[ForeignMode]+#13+
                  'in '+DomesticDir[ForeignMode]);}
       ShowMessage('Maximum of 99 files has been reached in '+DomesticDir[ForeignMode]+
                   #13+'Please delete unneeded files.');
       ShowMessage('Payment run aborted');
       Result := False;
    end;
  end; {With..}

  {$I+}


end; {Proc..}



Procedure TABNObj.Close_File;

Begin
  {$I-}
  With ProcControl do
  Begin


    If (ForeignMode) then
    Begin
      Close(BTL91file);
    end
    else
    Begin
      Close(ClieOpFile);
    end;


    Report_IOError(IOResult,ProperPath(DomesticDir[ForeignMode])+PayFileName);

  Try
    ChDir(PopDir);


  except;
    Report_IOError(IOResult,PopDir);

  end;


  end;

  {$I+}

end;

Procedure TABNObj.ShowFileCreated;


Begin
  With ProcControl do
  Begin
    ShowMessage('Created electronic payment file '+#13+DomesticDir[ForeignMode]+PayFileName);

  end; {With..}
end;


Procedure TABNObj.Erase_File;

Begin
  {$I-}
  With ProcControl do
  Begin
    If (ForeignMode) then
    Begin
      Assign(BTL91File,DomesticDir[ForeignMode]+PayFileName);
      Erase(BTL91file);
    end
    else
    Begin
      Assign(ClieOpFile,DomesticDir[ForeignMode]+PayFileName);
      Erase(ClieOpFile);
    end;

    Report_IOError(IOResult,DomesticDir[ForeignMode]+PayFileName);
    RunAborted:=TRUE;

    {$I+}

  end; {with..}


end;

{ == Procedure to check and transfer control values ==}

Procedure TABNObj.GetEventData(Const EventData : TAbsEnterpriseSystem);

Var
  n  :  Byte;

Begin
  With EventData,ProcControl do
  Begin
    PayRun:=Stock.stStockFolio;
    CtrlGL:=Stock.stSalesGL;
    BankGL:=Stock.stCOSGL;
    SalesPurch:=Stock.stReOrderFlag;
    Amount:=entRound(Stock.stQtyFreeze,2);
    PayCurr:=Stock.stLocation;
    TMode:=Stock.stReOrderCur;
    PDate:=Stock.stLastUsed;

    ForeignMode:=(CtrlGL=DomesticCGL[TRUE]);

    BankMatch:=-1;

    For n:=Low(Banks) to High(Banks) do
    Begin
      If (Banks[n].EntGLCode=BankGL) then
      Begin
        BankMatch:=n;
        Break;

      end;

    end;

    If (BankMatch=-1) then {* Default to first *}
      BankMatch:=1;
  end;
end;


{ == Validate BACS Account == }

Function TABNObj.ValidateAccount(Const EventData : TAbsEnterpriseSystem)  :  Boolean;

Var
  ACNo  :  ShortString;
  V     :  Double;
  Code  :  Integer;


Begin
  With EventData do
    If (ProcControl.SalesPurch) then
      With Customer do
        ACNo:=Strip('A',['A'..'Z','a'..'z','-','.',',','+',':'],Trim(acBankSort)+Trim(acBankAcc)+Trim(acBankRef))
    else
      With Supplier do
        ACNo:=Strip('A',['A'..'Z','a'..'z','-','.',',','+',':'],Trim(acBankSort)+Trim(acBankAcc)+Trim(acBankRef));


  Val(ACNo,V,Code);

  Result:=((V<>0.0) and (Code=0)) and (ACNo<>'');

  //Modded 29/03/2000 so alpha codes allowed.
  //Modded 12/05/2000 so alpha codes stripped out

  If (Result) and (ProcControl.ForeignMode) then {* Check additional fields *}
  With EventData do
  Begin
    If (ProcControl.SalesPurch) then
      With Customer do
        Result:=(Trim(acArea)<>'') and (Trim(acTradeTerms[1])<>'') and (Trim(acTradeTerms[2])<>'')
    else
      With Supplier do
        Result:=(Trim(acArea)<>'') and (Trim(acTradeTerms[1])<>'') and (Trim(acTradeTerms[2])<>'');

  end;

end;



{ == Write Clieop Record == }


Function TABNObj.Write_ClieOp(ThisRec  :  TClieOp)  :  Boolean;

Var
  TmpIO  :  Integer;

Begin
  {$I-}
    Write(ClieOpFile,ThisRec);

    TmpIO:=IOResult;

    With ProcControl do
      Report_IOError(TmpIO,ProperPath(DomesticDir[FALSE])+PayFileName);

    Result:=(TmpIO=0);

  {$I+}
end;




{ == Transfer Local to File records == }

Procedure TABNObj.ConvEntClieOp(ThisRec  :  TEntClieOp;
                                CMode    :  Byte);


Begin
  With ABNCtrlRecs,Header do
  Begin
    FillChar(Header,Sizeof(Header),#32);

    Str2_Char(Form_ZInt(ThisRec.EInfoCode,Sizeof(InfoCode)),InfoCode,Sizeof(InfoCode));
    VariantCode:=ThisRec.EVariantCode;
    CRLF[1]:=#13; CRLF[2]:=#10;
  end;

  With ThisRec,ABNCtrlRecs do
  Case EInfoCode of
    1  :  With Header do
          Begin
            Str2_Char(ECreationDate,CreationDate,Sizeof(CreationDate));
            Str2_Char(EFileName,FileName,Sizeof(FileName));
            Str2_Char(ESenderID    ,SenderID    ,Sizeof(SenderID    ));
            Str2_Char(EFileID,FileID,Sizeof(FileID));

            DupCode:=Char(48+EDupCode);


            {SetCRLF(CRLF);}

            If (CMode=1) then
              Write_ClieOp(Header);

          end;
    10  : With BatchHed do
          Begin
            BatchHed:=Header;

            Str2_Char(Form_ZInt(ETransGroup,Sizeof(TransGroup)),TransGroup,Sizeof(TransGroup));
            Str2_Char(Form_ZPad(EIPACNo,Sizeof(IPACNo)),IPACNo,Sizeof(IPACNo));
            Str2_Char(Form_ZInt(ESerialNo,SizeOf(SerialNo)),SerialNo,Sizeof(SerialNo));
            Str2_Char(EDelCurr,DelCurr,Sizeof(DelCurr));

            //SetCRLF(CRLF3);

            If (CMode=1) then
              Write_ClieOp(BatchHed);

          end;

    20  : With FixedDesc do
          Begin
            ABNCtrlRecs.FixedDesc:=Header;

            Str2_Char(EFixedDesc,FixedDesc,Sizeof(FixedDesc));

            //SetCRLF(CRLF4);

            If (CMode=1) then
              Write_ClieOp(ABNCtrlRecs.FixedDesc);

          end;

    30  : With InstParty do
          Begin
            InstParty:=Header;

            NAW:=ENAW;
            Str2_Char(EReqDate,ReqDate,Sizeof(ReqDate));
            Str2_Char(EIPN,IPN,Sizeof(IPN));
            TestCode:=ETestCode;

            //SetCRLF(CRLF5);

            If (CMode=1) then
              Write_ClieOp(InstParty);

          end;

    100 : With TransInfo do
          Begin
            TransInfo:=Header;

            Str2_Char(ETransType,TransType,Sizeof(TransType));
            Str2_Char(Form_ZInt(Pennies(EAmount),SizeOf(Amount)),Amount,Sizeof(Amount));
            Str2_Char(Form_ZPad(EPayerACNo,Sizeof(PayerACNo)),PayerACNo,Sizeof(PayerACNo));
            Str2_Char(Form_ZPad(EPayeeACNo,Sizeof(PayeeACNo)),PayeeACNo,Sizeof(PayeeACNo));

            //SetCRLF(CRLF7);

            If (CMode=1) then
              Write_ClieOp(TransInfo);

          end;

    110 : With PayerName do
          Begin
            ABNCtrlRecs.PayerName:=Header;

            Str2_Char(EPayerName,PayerName,Sizeof(PayerName));

            //SetCRLF(CRLF8);

            If (CMode=1) then
              Write_ClieOp(ABNCtrlRecs.PayerName);

          end;

    113 : With PayerAddr do
          Begin
            ABNCtrlRecs.PayerAddr:=Header;

            Str2_Char(EPayerAddr,PayerAddr,Sizeof(PayerAddr));

            //SetCRLF(CRLF9);

            If (CMode=1) then
              Write_ClieOp(ABNCtrlRecs.PayerAddr);

          end;

    150 : With PayID do
          Begin
            PayID:=Header;

            Str2_Char(EPayerID,PayerID,Sizeof(PayerID));

            //SetCRLF(CRLF10);

            If (CMode=1) then
              Write_ClieOp(PayID);

          end;


    160 : With DescInfo do
          Begin
            DescInfo:=Header;

            Str2_Char(EDescription,Description,Sizeof(Description));

            //SetCRLF(CRLF11);

            If (CMode=1) then
              Write_ClieOp(DescInfo);

          end;

    170 : With PayeeName do
          Begin
            PayeeName:=Header;

            Str2_Char(EBenefitName,BenefitName,Sizeof(BenefitName));

            //SetCRLF(CRLF12);

            If (CMode=1) then
              Write_ClieOp(PayeeName);

          end;

    173 : With PayeeAddr do
          Begin
            ABNCtrlRecs.PayeeAddr:=Header;

            Str2_Char(EPayeeAddr,PayeeAddr,Sizeof(PayeeAddr));

            //SetCRLF(CRLF13);


            If (CMode=1) then
              Write_ClieOp(ABNCtrlRecs.PayeeAddr);

          end;


    9990: With BatchClose do
          Begin
            BatchClose:=Header;

            Str2_Char(Form_ZInt(Pennies(ETotalAmount),SizeOf(TotalAmount)),TotalAmount,Sizeof(TotalAmount));

            Str2_Char(Form_ZFloat2(ETotalACNos,SizeOf(TotalACNos)),TotalACNos,Sizeof(TotalACNos));
            Str2_Char(Form_ZInt(ENoTrans,SizeOf(NoTrans)),NoTrans,Sizeof(NoTrans));


            //SetCRLF(CRLF6);

            If (CMode=1) then
              Write_ClieOp(BatchClose);

          end;

    9999: With FileClose do
          Begin
            FileClose:=Header;

            //SetCRLF(CRLF2);


            If (CMode=1) then
              Write_ClieOp(FileClose);

          end;



  end; {Case..}
end;


{ == Write Clieop Record == }


Function TABNObj.Write_BTL91(ThisRec  :  TBTL91)  :  Boolean;

Var
  TmpIO  :  Integer;

Begin
  {$I-}
    Write(BTL91File,ThisRec);

    TmpIO:=IOResult;

    With ProcControl do
      Report_IOError(TmpIO,ProperPath(DomesticDir[TRUE])+PayFileName);

    Result:=(TmpIO=0);

  {$I+}
end;



{ == Transfer Local to File records == }

Procedure TABNObj.ConvEntBTL91(ThisRec  :  TEntBTL91;
                               CMode    :  Byte);


Begin
  With SWIFTCtrlRecs,LeadRec do
  Begin
    FillChar(LeadRec,Sizeof(LeadRec),#32);

    Str2_Char(Form_ZInt(ThisRec.ECode,Sizeof(Code)),Code,Sizeof(Code));

    CRLF1[1]:=#13; CRLF1[2]:=#10;
  end;

  With ThisRec,SWIFTCtrlRecs do
  Case ECode of
    11 :  With LeadRec do
          Begin
            Str2_Char(EExBank,ExBank,Sizeof(ExBank));

            MedCode:=EMedCode;
            Str2_Char(Form_ZInt(EVerNo,SizeOf(VerNo)),VerNo,Sizeof(VerNo));

            Str2_Char(EFCDate,FCDate,Sizeof(FCDate));

            Str2_Char(Form_ZInt(EBatchNo,SizeOf(BatchNo)),BatchNo,Sizeof(BatchNo));

            Str2_Char(EPrinName,PrinName,Sizeof(PrinName));
            Str2_Char(EPrinAddr,PrinAddr,Sizeof(PrinAddr));

            Str2_Char(EPrinTown,PrinTown,Sizeof(PrinTown));
            Str2_Char(EPrinCountry,PrinCountry,Sizeof(PrinCountry));

            Str2_Char(Form_ZInt(EBusSect,SizeOf(BusSect)),BusSect,Sizeof(BusSect));
            Str2_Char(EProcDate,ProcDate,Sizeof(ProcDate));

            If (CMode=1) then
              Write_BTL91(LeadRec);
          end;
    21  : With Payments do
          Begin
            Payments:=LeadRec;

            Str2_Char(Form_ZInt(EOrderNo,Sizeof(OrderNo)),OrderNo,Sizeof(OrderNo));
            Str2_Char(EISOPCurr,ISOPCurr,Sizeof(ISOPCurr));
            Str2_Char(Form_ZPad(EACNo,Sizeof(ACNo)),ACNo,Sizeof(ACNo));
            Str2_Char(EISOOCurr,ISOOCurr,Sizeof(ISOOCurr));
            Str2_Char(Form_ZInt(Pennies(EAmount*10),Sizeof(Amount)),Amount,Sizeof(Amount));
            Str2_Char(EProcDate2,ProcDate2,Sizeof(ProcDate2));
            DOMCCode :=Char(EDOMCCode+48);

            CORCCode:=Char(ECORCCode+48);
            PayMethod:=Char(EPayMethod+48);
            ProcCode:=Char(EProcCode+48);

            {CQCCode:=ECQCCode;  Not used as being set to zero which is an invalid charachter
            CQFCode:=ECQFCode;}

            Str2_Char(EPayInsC1,PayInsC1,Sizeof(PayInsC1));

            Str2_Char(EPayInsC2,PayInsC2,Sizeof(PayInsC2));
            Str2_Char(EPayInsC3,PayInsC3,Sizeof(PayInsC3));
            Str2_Char(EPayInsC4,PayInsC4,Sizeof(PayInsC4));
            PayCatC1:=EPayCatC1;
            Str2_Char(ENatP1C,NatP1C,Sizeof(NatP1C));
            Str2_Char(ENatP2C,NatP2C,Sizeof(NatP2C));
            Str2_Char(EDNBRegNo,DNBRegNo,Sizeof(DNBRegNo));
            Str2_Char(EArtNo,ArtNo,Sizeof(ArtNo));

            Str2_Char(ETradNo,TradNo,Sizeof(TradNo));


            If (CMode=1) then
              Write_BTL91(Payments);
          end;

    22  : With SubRec2 do
          Begin
            SubRec2:=LeadRec;

            Str2_Char(Form_ZInt(EOrderNo2,Sizeof(OrderNo2)),OrderNo2,Sizeof(OrderNo2));
            Str2_Char(EBenAcNo,BenAcNo,Sizeof(BenAcNo));
            Str2_Char(EBenName,BenName,Sizeof(BenName));
            Str2_Char(EBenAddr,BenAddr,Sizeof(BenAddr));
            Str2_Char(EBenTown,BenTown,Sizeof(BenTown));
            Str2_Char(EBenISOCountry,BenISOCountry,Sizeof(BenISOCountry));
            Str2_Char(EBenCountry,BenCountry,Sizeof(BenCountry));


            If (CMode=1) then
              Write_BTL91(SubRec2);
          end;

    23  : With SubRec3 do
          Begin
            SubRec3:=LeadRec;

            Str2_Char(Form_ZInt(EOrderNo3,Sizeof(OrderNo3)),OrderNo3,Sizeof(OrderNo3));
            Str2_Char(EBenSWIFT,BenSWIFT,Sizeof(BenSWIFT));
            Str2_Char(EBenBank,BenBank,Sizeof(BenBank));
            Str2_Char(EBenBAddr,BenBAddr,Sizeof(BenBAddr));
            Str2_Char(EBenBTown,BenBTown,Sizeof(BenBTown));
            Str2_Char(EBenBISOCountry,BenBISOCountry,Sizeof(BenBISOCountry));
            Str2_Char(EBenBCountry,BenBCountry,Sizeof(BenBCountry));


            If (CMode=1) then
              Write_BTL91(SubRec3);
          end;

    24  : With SubRec4 do
          Begin
            SubRec4:=LeadRec;
            Str2_Char(Form_ZInt(EOrderNo4,Sizeof(OrderNo4)),OrderNo4,Sizeof(OrderNo4));
            Str2_Char(EPayRef1,PayRef1,Sizeof(PayRef1));
            Str2_Char(EPayRef2,PayRef2,Sizeof(PayRef2));
            Str2_Char(EPayRef3,PayRef3,Sizeof(PayRef3));
            Str2_Char(EPayRef4,PayRef4,Sizeof(PayRef4));


            If (CMode=1) then
              Write_BTL91(SubRec4);
          end;


    31  : With TotalsRec do
          Begin
            TotalsRec:=LeadRec;

            Str2_Char(ETotCurr,TotCurr,Sizeof(TotCurr));
            Str2_Char(Form_ZInt(Pennies(ETotAmount*10),Sizeof(TotAmount)),TotAmount,Sizeof(TotAmount));
            Str2_Char(Form_ZInt(ETotCount,Sizeof(TotCount)),TotCount,Sizeof(TotCount));

            If (CMode=1) then
              Write_BTL91(TotalsRec);
          end;

    41  : With TerminalRec do
          Begin
            TerminalRec:=LeadRec;

            Str2_Char(Form_ZInt(ETotRecs,Sizeof(TotRecs)),TotRecs,Sizeof(TotRecs));
            Str2_Char(Form_ZInt(ETotOrders,Sizeof(TotOrders)),TotOrders,Sizeof(TotOrders));

            FillChar(DESHash,Sizeof(DESHash),#48);


            If (CMode=1) then
              Write_BTL91(TerminalRec);
          end;



  end; {Case..}
end;





Procedure TABNObj.Write_Payment(Const EventData : TAbsEnterpriseSystem);

Const
  TransType  :   Array[False..True] of String[4] = ('0005','1001');


Begin
  GetEventData(EventData);

  With ProcControl,EventData do
  Begin
    Case ForeignMode of
      FALSE  :  With EntCtrlRecs do
                Begin
                  With ETransInfo do
                  Begin
                    EInfoCode:=100;
                    EVariantCode:='A';
                    ETransType:=TransType[SalesPurch];
                    EAmount:=entRound(Amount,2);
                    EPayerACNo:=Trim(Banks[BankMatch].BankACNo);

                    If (SalesPurch) then
                      With Customer do
                        EPayeeACNo:=Strip('A',['A'..'Z','a'..'z','-','.',',','+',':'],Trim(acBankSort)+Trim(acBankAcc)+Trim(acBankRef))
                    else
                      With Supplier do
                        EPayeeACNo:=Strip('A',['A'..'Z','a'..'z','-','.',',','+',':'],Trim(acBankSort)+Trim(acBankAcc)+Trim(acBankRef));


                    ConvEntClieOp(ETransInfo,1);

                    With EBatchClose do
                    Begin
                      EInfoCode:=9990;
                      EVariantCode:='A';

                      ETotalAmount:=ETotalAmount+Amount;
                      Inc(ENoTrans);
                      ETotalACNos:=ETotalACNos+Round(StrToFloat(ETransInfo.EPAyerACNo)+StrToFloat(ETransInfo.EPayeeACNo));

                    end;

                  end;

                  With EDescInfo do
                  Begin
                    EInfoCode:=160;
                    EVariantCode:='A';

                    EDescription:=Transaction.thOurRef+'. Run '+IntToStr(PayRun);

                    ConvEntClieOp(EDescInfo,1);

                  end;

                  With EPayeeName do
                  Begin
                    EInfoCode:=170;
                    EVariantCode:='B';

                    If (SalesPurch) then
                      With Customer do
                        EBenefitName:=Trim(acCompany)
                    else
                      With Supplier do
                        EBenefitName:=Trim(acCompany);


                    ConvEntClieOp(EPayeeName,1);

                  end;

                  With EPayeeAddr do
                  Begin
                    EInfoCode:=173;
                    EVariantCode:='B';

                    If (SalesPurch) then
                      With Customer do
                        EBenefitName:=Trim(acAddress[2])
                    else
                      With Supplier do
                        EBenefitName:=Trim(acAddress[2]);


                    ConvEntClieOp(EntCtrlRecs.EPayeeAddr,1);

                  end;





                end;

      TRUE   :  With EntSWIFTRecs do
                Begin
                  With EPayments do
                  Begin
                    ECode:=21;
                    EOrderNo:=RecOrder;
                    EISOPCurr:=Banks[BankMatch].ISOCurrency;
                    EACNo:=Banks[BankMatch].BankACNo;
                    EISOOCurr:=PayCurr;
                    EAmount:=Amount;
                    EProcDate2:=PDate;
                    EDomCCode:=1;
                    ECORCCode:=3;
                    EPayMethod:=0;
                    EProcCode:=0;
                    EPayCatC1:='1';
                    ECQCCode:=#32; ECQFCode:=#32;

                    ConvEntBTL91(EPayments,1);
                  end;


                  With ESubRec2 do
                  Begin
                    ECode:=22;
                    EOrderNo2:=RecOrder;

                    If (SalesPurch) then
                      With Customer do
                        EBenACNo:=Strip('A',['A'..'Z','a'..'z','-','.',',','+',':'],Trim(acBankSort)+Trim(acBankAcc)+Trim(acBankRef))
                    else
                      With Supplier do
                        EBenACNo:=Strip('A',['A'..'Z','a'..'z','-','.',',','+',':'],Trim(acBankSort)+Trim(acBankAcc)+Trim(acBankRef));

                    If (SalesPurch) then
                      With Customer do
                        EBenName:=Trim(acCompany)
                    else
                      With Supplier do
                        EBenName:=Trim(acCompany);

                    If (SalesPurch) then
                      With Customer do
                        EBenAddr:=Trim(acAddress[1])
                    else
                      With Supplier do
                        EBenAddr:=Trim(acAddress[1]);

                    If (SalesPurch) then
                      With Customer do
                        EBenTown:=Trim(acAddress[2])
                    else
                      With Supplier do
                        EBenTown:=Trim(acAddress[2]);

                    If (SalesPurch) then
                      With Customer do
                        EBenISOCountry:=Trim(acArea)
                    else
                      With Supplier do
                        EBenISOCountry:=Trim(acArea);

                    ConvEntBTL91(ESubRec2,1);
                  end;

                  With ESubRec3 do
                  Begin
                    ECode:=23;
                    EOrderNo3:=RecOrder;


                    If (SalesPurch) then
                      With Customer do
                        EBenSWIFT:=Trim(acUserDef1)
                    else
                      With Supplier do
                        EBenSWIFT:=Trim(acUserDef1);

                    If (SalesPurch) then
                      With Customer do
                        EBenBank:=Trim(acTradeTerms[1])
                    else
                      With Supplier do
                        EBenBank:=Trim(acTradeTerms[1]);


                    If (SalesPurch) then
                      With Customer do
                        EBenBTown:=Trim(acTradeTerms[2])
                    else
                      With Supplier do
                        EBenBTown:=Trim(acTradeTerms[2]);

                    If (SalesPurch) then
                      With Customer do
                        EBenBISOCountry:=Trim(acArea)
                    else
                      With Supplier do
                        EBenBISOCountry:=Trim(acArea);


                    ConvEntBTL91(ESubRec3,1);
                  end;


                  With ESubRec4 do
                  Begin
                    ECode:=24;
                    EOrderNo4:=RecOrder;

                    EPayRef1:=Transaction.thOurRef+'. Run '+IntToStr(PayRun);
                    ConvEntBTL91(ESubRec4,1);
                  end;


                  With ETotalsRec do
                  Begin
                    ECode:=31;
                    ETotCurr:=PayCurr;

                    ETotAmount:=ETotAmount+Amount;
                    Inc(ETotCount);

                  end;


                  With ETerminalRec do
                  Begin
                    ETotRecs:=ETotRecs+4;

                    Inc(ETotOrders);
                    Inc(RecOrder);

                  end;



                end;

    end; {Case..}



  end; {With..}
end;



Procedure TABNObj.Write_Header(Const EventData : TAbsEnterpriseSystem);

Const
  SetTestMode  :  Array[False..True] of Char = ('P','T');

Begin
  GetEventData(EventData);

  With ProcControl,EventData do
  Begin
    Case ForeignMode of
      FALSE  :  With EntCtrlRecs do
                Begin
                  With EHeader do
                  Begin
                    EInfoCode:=1;
                    EVariantCode:='A';
                    ECreationDate:=Today(2);
                    EFileName:='CLIEOP03';
                    ESenderID:='EXCH1';
                    EFileID:=Copy(ECreationDate,1,2)+Form_ZInt(FileCounter,2);
                    EDupCode:=1;

                    ConvEntClieOp(EHeader,1);

                  end;

                  With EBatchHed do
                  Begin
                    EInfoCode:=10;
                    EVariantCode:='B';
                    ETransGroup:=10*Ord(SalesPurch);
                    EIPACNo:=Banks[BankMatch].BankACNo;
                    ESerialNo:=PayRun;
                    EDelCurr:=PayCurr;


                    ConvEntClieOp(EBatchHed,1);

                  end;


                  With EFixedDesc do
                  Begin
                    EInfoCode:=20;
                    EVariantCode:='A';
                    EFixedDesc:=PayDesc+'. Run   '+IntToStr(PayRun);


                    ConvEntClieOp(EntCtrlRecs.EFixedDesc,1);

                  end;


                  With EInstParty do
                  Begin
                    EInfoCode:=30;
                    EVariantCode:='B';
                    ENAW:='1';
                    EReqDate:=Date2CLieOp(PDate);
                    EIPN:=SetUp.ssUserName;

                    ETestCode:=SetTestMode[TestMode];

                    ConvEntClieOp(EInstParty,1);

                  end;


                end;

      TRUE   :  With EntSWIFTRecs do
                Begin
                  With ELeadRec do
                  Begin
                    ECode:=11;
                    EExBank:=Banks[BankMatch].BankXChange;

                    If (TestMode) then
                      EExBank[4]:='T';


                    EMedCode:='X';
                    EVerNo:=1;
                    EFCDate:=Today(1);
                    EBatchNo:=FileCounter;
                    EPrinName:=SetUp.ssUserName;
                    EPrinAddr:=SetUp.ssDetailAddr[1];
                    EPrinTown:=SetUp.ssDetailAddr[2];
                    EPrinCountry:=SetUp.ssDetailAddr[3];
                    EProcDate:=PDate;

                    ConvEntBTL91(ELeadRec,1);
                  end;


                  With ETerminalRec do
                  Begin
                    ECode:=41;

                    ETotRecs:=3;

                  end;


                end;

    end; {Case..}



  end; {With..}
end;



Procedure TABNObj.Write_Footer(Const EventData : TAbsEnterpriseSystem);

Begin
  With ProcControl,EventData do
  Begin
    Case ForeignMode of
      FALSE  :  With EntCtrlRecs do
                Begin
                    With EBatchClose do
                    Begin
                      ConvEntClieOp(EBatchClose,1);

                    end;


                    With EFileClose do
                    Begin
                      EInfoCode:=9999;
                      EVariantCode:='A';

                      ConvEntClieOp(EFileClose,1);

                    end;


                end;

      TRUE   :  With EntSWIFTRecs do
                Begin
                  With ETotalsRec do
                  Begin

                    ConvEntBTL91(ETotalsRec,1);
                  end;


                  With ETerminalRec do
                  Begin
                    ConvEntBTL91(ETerminalRec,1);
                  end;


                  
                end;

    end; {Case..}



  end; {With..}
end;


Initialization

  ABNObj:=Nil

Finalization

  If (Assigned(ABNObj)) then
  Begin
    ABNObj.Destroy;
    ABNObj:=nil;
  end;

end.
