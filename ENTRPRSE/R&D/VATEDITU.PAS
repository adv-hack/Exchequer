unit VATEdiTU;

{$I DEFOVR.Inc}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons,
  GlobVar,VARRec2U,VarConst,BtrvU2,BTSupU1,ExWrap1U, BTSupU3, BorBtns,

  {$IFDEF FRM}
    RPDevice,
    FrmThrdU,
  {$ENDIF}

  oIrishIntrastat,
  oIrishECSales,

  ReportAU,
  PostingU,

  //PR: 04/03/2014 ABSEXCH-15077
  IntrastatDataSearch;


Type   { BACS OutPut Files }

  // CJS 2014-05-15 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
  TLineDetails = record
    LineValue: Double;
    LineValueConsolidated: Double;  // Calculated after Delivery Charges are known
    LineWeight: Double;
    LineQuantity: Double;
    LocationCode: string;
    CommodityCode: string;
    Uplift: Double;
    StockUnitSupp: string;
    VATRegistrationCode: string;
    SSDCountry: string;
  end;
  PLineDetails = ^TLineDetails;

TSend_VATEDI      =  Object(TEntPost)

                     private
                       VEDIF     :   File of Char;

                       SMemo     :   TStringList;

                       PopDir    :   String;

                       ECReport  :   ^TECVATReport;

                       DontSendFile,
                       NewExport,
                       CouldHave,
                       XMLMode   :   Boolean;

                       CSVLines : TStringList;

                       // CJS 2014-05-15 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
                       fDataSearch : TIntrastatDataSearch;
                       fLineList: TList;

                       Function Init_EDIFile(FPath     :  Str255;
                                             TestMode  :  Boolean;
                                             VMode     :  Byte)  :  Boolean;

                       Procedure Close_EDIFile;

                       // CJS 2014-05-15 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
                       procedure ClearLineList;
                       Procedure Read_LineDetails(EDIRec  :  EDI1Type;
                                                  CustR   :  CustRec;
                                                  InvR    :  InvRec;
                                                  IdR     :  Idetail;
                                                  StockR  :  StockRec;
                                                  VATChk  :  Char);

                       Procedure Write_EDILines(EDIRec  :  EDI1Type;
                                                InvR    :  InvRec;
                                                VATChk  :  Char;
                                                DeliveryCharge: Double;
                                            Var SSDLNo  :  LongInt;
                                            Var NoSegs  :  LongInt;
                                            Var RepTot  :  AgedTyp;
                                            Var TmpIO   :  Integer);

                       Procedure Write_EDILine(EDILine  :  Str255;
                                               Term,
                                               AddCRLF   :  Boolean;
                                           Var TMPIO     :  Integer);

                       Procedure Write_EDIUNB(EDIRec  :  EDI1Type;
                                              VMode   :  Byte;
                                          Var TmpIO   :  Integer);

                       Procedure Write_EDIUNH(EDIRec  :  EDI1Type;
                                              VATEndD :  LongDate;
                                              VATChk  :  Char;
                                              VMode   :  Byte;
                                          Var NoSegs  :  LongInt;
                                          Var TmpIO   :  Integer);


                       Procedure Write_EDIUNH2(EDIRec  :  EDI1Type;
                                               VATChk  :  Char;
                                               NILRet  :  Boolean;
                                           Var NoSegs  :  LongInt;
                                           Var TmpIO   :  Integer);


                       Procedure Write_EDIESL(EDIRec  :  EDI1Type;
                                              CustR   :  CustRec;
                                              ESLValue:  Double;
                                              ESLLNo  :  LongInt;
                                              TriMode :  Boolean;
                                          Var TmpIO   :  Integer);

                       Procedure Write_EDICNT(EDIRec  :  EDI1Type;
                                          Var NoSegs  :  LongInt;
                                              VMode   :  Byte;
                                              RepTot  :  AgedTyp;
                                              NoITems :  LongInt;
                                          Var TmpIO   :  Integer);

                       Procedure Write_EDIUNZ(EDIRec  :  EDI1Type;
                                              NoSegs  :  LongInt;
                                          Var TmpIO   :  Integer);

//                       Procedure Write_EDISSD(EDIRec  :  EDI1Type;
//                                              CustR   :  CustRec;
//                                              InvR    :  InvRec;
//                                              IdR     :  Idetail;
//                                              StockR  :  StockRec;
//                                              VATChk  :  Char;
//                                              SSDLNo  :  LongInt;
//                                          Var NoSegs  :  LongInt;
//                                          Var RepTot  :  AgedTyp;
//                                          Var TmpIO   :  Integer);

                       Procedure Write_EDINIL(EDIRec  :  EDI1Type;
                                              VATChk  :  Char;
                                              VMode   :  Byte;
                                              SSDLNo  :  LongInt;
                                          Var NoSegs  :  LongInt;
                                          Var TmpIO   :  Integer);

                       Procedure Write_FixMsg(S  :  String);


                       Function CompressEDIFile(DPath     :  Str255;
                                                 TestMode  :  Boolean;
                                                 VEDIM     :  Byte;
                                                 SendEmail :  Boolean)  :  Boolean;

                       Function SendEDIEmail(Compressed   :  Boolean) :  Boolean;

                     public
                       {$IFDEF FRM}
                         PDevRec    :  TSBSPrintSetupInfo;
                       {$ENDIF}

                       CRepParam :   CVATRepPtr;

                       IncludeGoods: Boolean;
                       IncludeServices: Boolean;
                       CSVFile  : string;

                       CustTotals: TECTotals;

                       WizMode   :   Byte;


                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;


                       Function Generate_VATEDI_SSD(VATStartD,VATEndD  :  LongDate;
                                                    VMode              :  Byte;
                                                    VATChk             :  Char;
                                                Var NoSegs,
                                                    SSDLNo             :  LongInt;
                                                Var RepTotals          :  AgedTyp )  :  Boolean; Virtual;

                       Function Generate_VATEDI_ESL(VATStartD,VATEndD  :  LongDate;
                                                    VMode              :  Byte;
                                                    VATChk             :  Char)  :  Boolean; Virtual;

                       function Generate_VATCSV(VATStartD, VATEndD: LongDate): Boolean;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start  :  Boolean;

                   end; {Class..}


TSend_VATXML      =  Object(TSend_VATEDI)

                     private
                       oIrishXML      :  IIrishXMLIntrastat;
                       oECSLIrishXML  :  IIrishXMLVIES;

                       // MH 04/04/2012 v6.10.1 ABSEXCH-12554: Added Statistical Value Required field
                       FStatsValueRequired : Boolean;



                       Procedure Write_XMLUNH(EDIRec  :  EDI1Type;
                                              VATStartD,
                                              VATEndD :  LongDate;
                                              VATChk  :  Char;
                                              VMode   :  Byte;
                                          Var NoSegs  :  LongInt;
                                          Var TmpIO   :  Integer);

                       // MH 04/04/2012 v6.10.1 ABSEXCH-12580: Added IsDespatchExport parameter for statEuroValue calculation
                       Procedure Write_XMLSSD(EDIRec  :  EDI1Type;
                                              CustR   :  CustRec;
                                              InvR    :  InvRec;
                                              IdR     :  Idetail;
                                              StockR  :  StockRec;
                                              VATChk  :  Char;
                                              SSDLNo  :  LongInt;
                                          Var NoSegs  :  LongInt;
                                          Var RepTot  :  AgedTyp;
                                          Var TmpIO   :  Integer;
                                          Const IsDespatchExport : Boolean
                                          );

                       Function Generate_VATXML_SSD(VATStartD,VATEndD  :  LongDate;
                                                    VMode              :  Byte;
                                                    VATChk             :  Char;
                                                Var NoSegs,
                                                    SSDLNo             :  LongInt;
                                                Var RepTotals          :  AgedTyp     )  :  Boolean;

                     public
                       // MH 04/04/2012 v6.10.1 ABSEXCH-12554: Added Statistical Value Required field
                       Property StatsValueRequired : Boolean Read FStatsValueRequired Write FStatsValueRequired;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Function Generate_VATEDI_ESL(VATStartD,VATEndD  :  LongDate;
                                                    VMode              :  Byte;
                                                    VATChk             :  Char)  :  Boolean; Virtual;



                   end; {Class..}



  // MH 04/04/2012 v6.10.1 ABSEXCH-12554: Added support for Statistical Value Required flag
  Procedure AddVATXML2Thread(AOwner    :  TObject;
                             VMode     :  Byte;
                             VRepParam :   CVATRepPtr;
                             Const StatsValueReqd : Boolean
                            );

Procedure AddVATEDI2Thread(AOwner    :  TObject;
                           VMode     :  Byte;
                           VRepParam :   CVATRepPtr;
                           Filename  :  string = '';
                           IncludeGoods: Boolean = False;
                           IncludeServices: Boolean = False);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU2,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  ReportHU,
  SysU1,
  SysU2,
  SysU3,

  {$IFDEF FRM}
     PrintFrm,

     RPDefine,
  {$ENDIF}

  CommsInt,
  ExBtTh1U,
  ExpVED2U,

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  ExThrd2U;

const
  //PR: 04/03/2014 ABSEXCH-15077
  ECSSDDispatches = 1;
  ECSSDArrivals   = 2;





  { ========== TSend_VATEDI methods =========== }

  Constructor TSend_VATEDI.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOn;

    fPriority:=tpNormal;
    fSetPriority:=BOn;

    IsParentTo:=BOn;

    XMLMode:=BOff;

    SMemo:=TStringList.Create;

    New(ECReport,Create(AOwner));

    {$IFDEF FRM}
      FillChar(PDevRec,Sizeof(PDevRec),0);

      With PDevRec do
      Begin
        DevIdx:=-1;
        Preview:=BOn;
        NoCopies:=1;
      end;


    {$ENDIF}

    CouldHave:=BOff;
    DontSendFile:=BOff;
    NewExport:=BOn;

    New(CRepParam);

    Try
      FillChar(CRepParam^,Sizeof(CRepParam^),0);
    except
      Begin
        Dispose(CRepParam);
        CRepParam:=nil;
      end;
    end; {try..}

    CSVLines := TStringList.Create;

    // CJS 2014-05-15 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
    fDataSearch := TIntrastatDataSearch.Create;
    fLineList   := TList.Create;

  end;


  Destructor TSend_VATEDI.Destroy;
  var
    i: Integer;
  Begin

    // CJS 2014-05-15 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
    if Assigned(fLineList) then
    begin
      ClearLineList;
      FreeAndNil(fLineList);
    end;

    if Assigned(fDataSearch) then
      FreeAndNil(fDataSearch);

    {Free possibly causing application error when this finishes?}
    {SMemo.Free;}

    if (Assigned(CSVLines)) then
      FreeAndNil(CSVLines);

    If (Assigned(ECReport)) then
    Begin
      Dispose(ECReport,Destroy);
      ECReport:=nil;
    end;

    If (Assigned(CRepParam)) then
    Begin
      Dispose(CRepParam);
      CRepParam:=nil;
    end;


    Inherited Destroy;
  end;



  { ====== Procedure to manage the control of Producing EDI File ==== }


Function TSend_VATEDI.Init_EDIFile(FPath     :  Str255;
                                   TestMode  :  Boolean;
                                   VMode     :  Byte)  :  Boolean;

Var
  n        :  Byte;

  TmpIO    :  Integer;


Begin

  if (VMode = EC_SALES_EXPORT_MODE) then
  begin
    CSVLines.Clear;
    Result := True;
  end
  else
  begin
    {$I-}

    Try
      GetDir(0,PopDir);

      MTExLocal^.LReport_IOError(IOResult,PopDir);

    except;
      PopDir:=SetDrive;

    end;

    if (VMode = EC_SALES_EXPORT_MODE) then
      VMode := 0;

    Assign(VEDIF,BuildPath(FPath)+EDIFName(TestMode,VMode));

    ReWrite(VEDIF);

    TmpIO:=IOResult;

    MTExLocal^.LReport_IOError(TmpIO,EDIFName(TestMode,VMode));

    Init_EDIFile:=(TmpIO=0);

    {$I+}
  end;

end; {Proc..}

Procedure TSend_VATEDI.Close_EDIFile;

Begin
  if (WizMode = EC_SALES_EXPORT_MODE) then
  begin
    CSVLines.SaveToFile(CSVFile);
  end
  else
  begin
  {$I-}

    Close(VEDIF);

    MTExLocal^.LReport_IOError(IOResult,EDIFName(SyssEDI1^.EDI1Value.VTestMode,0));

    Try
      ChDir(PopDir);


    except;
      ChDir(SetDrive);
    end;

    MTExLocal^.LReport_IOError(IOResult,PopDir);



  {$I+}
  end;
end;




Procedure TSend_VATEDI.Write_EDILine(EDILine  :  Str255;
                                     Term,
                                     AddCRLF   :  Boolean;
                                 Var TMPIO     :  Integer);


Var
  n      :  Byte;
  TC     :  Char;

Begin
  {$I-}

  If (TmpIO=0) then
  Begin
    For n:=1 to Length(EDILine) do
    Begin
      Write(VEDIF,EDILine[n]);

      TmpIO:=IOResult;

      If (TMPIO<>0) then
        Break;
    end;

    If (Term) and (TMPIO=0) then
    Begin
      TC:=#39;

      Write(VEDIF,TC);

      TMPIO:=IOResult;
    end;

    If (AddCRLF) and (TMPIO=0) then
    Begin
      TC:=#13;

      Write(VEDIF,TC);

      TMPIO:=IOResult;

      TC:=#10;

      Write(VEDIF,TC);

      TMPIO:=IOResult;
    end;

    MTExLocal^.LReport_IOError(TmpIO,EDIFName(BOff,0));
  end;

  {$I+}

end;




{ ========== Write Specific Lines for ESL Export ========= }

Procedure TSend_VATEDI.Write_EDIUNB(EDIRec  :  EDI1Type;
                                    VMode   :  Byte;
                                Var TmpIO   :  Integer);

Var
  TimeR
         :  TimeTyp;

  GenStr :  Str255;

Begin
  GenStr:='';

  With EDIRec do
  Begin

    If (CurrentCountry<>IECCode) then
    Begin

      Write_EDILine('UNB+UNOA:2+'+VEDIFmtStr(VVANUID),BOff,BOff,TmpIO);

      If (VEDIMethod=1) and (VVanMode=3) then
        Write_EDILine(':ZZ',BOff,BOff,TmpIO);

      Write_EDILine('+'+VEDIFmtStr(VVANCEID),BOff,BOff,TmpIO);

      If (VEDIMethod=1) and (VVanMode=3) then
        Write_EDILine(':ZZ',BOff,BOff,TmpIO);

      GetCurrTime(TimeR);

      Write_EDILine('+'+ShortDate(Today)+':'+SetN(TimeR.HH)+SetN(TimeR.MM)+'+EXCH'+Today+'++',BOff,BOff,TmpIO);

      If (VTestMode) then
        Write_EDILine('TESDEC',BOn,VUseCRLF,TmpIO)
      else
        Write_EDILine('LIVDEC',BOn,VUseCRLF,TmpIO);
    end
    else
    Begin
      If ((VMode=0) or (VMode = EC_SALES_EXPORT_MODE)) then
        GenStr:='+REVIES'
      else
        GenStr:='+BINS';

      Write_EDILine('UNA:,?',BOn,VUseCRLF,TmpIO);

      Write_EDILine('UNB+UNOA:1+'+VEDIFmtStr(Syss.UserVATReg)+GenStr,BOff,BOff,TmpIO);

      GetCurrTime(TimeR);

      Write_EDILine('+'+ShortDate(Today)+':'+SetN(TimeR.HH)+SetN(TimeR.MM)+'+EXCH'+Today+'+VIESPAS',BOff,BOff,TmpIO);

      If (VTestMode) then
        Write_EDILine('+1',BOn,VUseCRLF,TmpIO)
      else
        Write_EDILine('',BOn,VUseCRLF,TmpIO);


    end;


  end; {With..}


end;


Procedure TSend_VATEDI.Write_EDIUNH(EDIRec  :  EDI1Type;
                                    VATEndD :  LongDate;
                                    VATChk  :  Char;
                                    VMode   :  Byte;
                                Var NoSegs  :  LongInt;
                                Var TmpIO   :  Integer);

Var
  UserVReg  :  Str50;

Begin
  With EDIRec do
  Begin
    UserVReg:=RetVATRegNo(Syss.UserVATReg);

    Case VEdiFACT of
      0  :  Begin
              Write_EDILine('UNH+EXCH'+Today+'+SEMDEC:1:912:UK:109401',BOn,VUseCRLF,TmpIO);

              Write_EDILine('BGM+++137:'+ShortDate(Today)+':101',BOn,VUseCRLF,TmpIO);

              Write_EDILine('DTM+156:'+Copy(VATEndD,3,4)+':609',BOn,VUseCRLF,TmpIO);

              Write_EDILine('NAD+DT+'+UserVReg,BOn,VUseCRLF,TmpIO);

              NoSegs:=NoSegs+4;
            end;
      1  :  Begin
              If (CurrentCountry<>IECCode) then
              Begin

                Write_EDILine('UNH+EXCH'+Today+'+CUSDEC:S:93A:UN:INSTAT',BOn,VUseCRLF,TmpIO);

                {* Duplaiced from SEMDEC for convinience *}

                Write_EDILine('BGM+896:',BOn,VUseCRLF,TmpIO);

                Write_EDILine('CST++'+VATChk+':176',BOn,VUseCRLF,TmpIO);

                Write_EDILine('DTM+137:'+ShortDate(Today),BOn,VUseCRLF,TmpIO);

                Write_EDILine('DTM+320:'+Copy(VATEndD,3,4),BOn,VUseCRLF,TmpIO);

                NoSegs:=NoSegs+5;

              end
              else
              Begin

                Write_EDILine('UNH+EXCH'+Today,BOff,BOff,TmpIO);

                Case VMode of
                  0, EC_SALES_EXPORT_MODE
                      :  Begin {* ECSL *}
                            Write_EDILine('+VIESRT:1:2:UN:IEVDEC',BOn,VUseCRLF,TmpIO);

                            Write_EDILine('BGM+EXCH'+Today,BOn,VUseCRLF,TmpIO);

                            Write_EDILine('DTM+137:'+ShortDate(Today),BOn,VUseCRLF,TmpIO);


                            Write_EDILine('NAD+DT+'+VEDIFmtStr(Syss.UserVATReg),BOn,VUseCRLF,TmpIO);

                            Write_EDILine('UNS+D',BOn,VUseCRLF,TmpIO);

                            Write_EDILine('NAD+SE+'+VEDIFmtStr(Syss.UserVATReg),BOn,VUseCRLF,TmpIO);

                            Write_EDILine('DTM+156:'+Copy(VATEndD,3,4),BOn,VUseCRLF,TmpIO);

                            Write_EDILine('GIS+'+VIEECSLP+':190',BOn,VUseCRLF,TmpIO);

                            NoSegs:=NoSegs+8;

                          end;

                  1,2  :  Begin {*SSD*}
                            Write_EDILine('+CUSDEC:1:911:UN:IEINST',BOn,VUseCRLF,TmpIO);

                            Write_EDILine('BGM+896+EXCH'+Today,BOn,VUseCRLF,TmpIO);

                            Write_EDILine('CST++'+VATChk+':176',BOn,VUseCRLF,TmpIO);

                            Write_EDILine('DTM+137:'+ShortDate(Today),BOn,VUseCRLF,TmpIO);

                            Write_EDILine('DTM+320:'+Copy(VATEndD,3,4),BOn,VUseCRLF,TmpIO);

                            Write_EDILine('NAD+DT+'+VEDIFmtStr(Syss.UserVATReg),BOn,VUseCRLF,TmpIO);

                            Write_EDILine('NAD+AE+'+VEDIFmtStr(Syss.UserVATReg),BOn,VUseCRLF,TmpIO);

                            Write_EDILine('COM+'+VEDIFmtStr(Syss.DetailTel)+':TE',BOn,VUseCRLF,TmpIO);

                            Write_EDILine('UNS+D',BOn,VUseCRLF,TmpIO);

                            NoSegs:=NoSegs+9;

                          end;

                end; {Case..}

              end;
            end;
    end; {case..}
  end; {With..}


end;


Procedure TSend_VATEDI.Write_EDIUNH2(EDIRec  :  EDI1Type;
                                     VATChk  :  Char;
                                     NILRet  :  Boolean;
                                 Var NoSegs  :  LongInt;
                                 Var TmpIO   :  Integer);

Var
  UserVReg  :  Str50;

Begin
  With EDIRec do
  Begin
    UserVReg:=RetVATRegNo(Syss.UserVATReg);

    Case VEdiFACT of
      0  :  Begin

            end;
      1  :  Begin
              If (CurrentCountry<>IECCode) then 
              Begin
                If (NILRet) then
                Begin
                  Write_EDILine('GIS+NIL:42',BOn,VUseCRLF,TmpIO);

                  Inc(NoSegs);
                end;

                Write_EDILine('NAD+DT+'+UserVReg,BOn,VUseCRLF,TmpIO);

                Write_EDILine('UNS+D',BOn,VUseCRLF,TmpIO);

                NoSegs:=NoSegs+2;
              end;
            end; {Case..}

    end; {case..}
  end; {With..}
end;


Procedure TSend_VATEDI.Write_EDIESL(EDIRec  :  EDI1Type;
                                    CustR   :  CustRec;
                                    ESLValue:  Double;
                                    ESLLNo  :  LongInt;
                                    TriMode :  Boolean;
                                Var TmpIO   :  Integer);

Const
  EDITriInd  :  Array[BOff..BOn] of Str5 = ('E0','E2');


Var
  UserVReg  :  Str50;

Begin
  With EDIRec do
  Begin
    Case VEdiFACT of
      0  :  Begin

              Write_EDILine('DMS+'+Form_Int(ESLLNo,0),BOn,VUseCRLF,TmpIO);

              UserVReg:=RetVATRegNo(CustR.VATRegNo);

              Write_EDILine('LOC+36:'+Copy(CustR.VATRegNo,1,2),BOn,VUseCRLF,TmpIO);

              Write_EDILine('NAD+BY+'+UserVReg,BOn,VUseCRLF,TmpIO);

              Write_EDILine('MOA+5+'+EDITriInd[TriMode]+':'+Form_Real(ESLValue,0,0),BOn,VUseCRLF,TmpIO);

            end;
      1  :  Begin

              If (CurrentCountry<>IECCode) then
              Begin

                {* Duplaiced from SEMDEC for convinience *}

                Write_EDILine('DMS+'+Form_Int(ESLLNo,0),BOn,VUseCRLF,TmpIO);

                UserVReg:=RetVATRegNo(CustR.VATRegNo);

                Write_EDILine('LOC+36:'+Copy(CustR.VATRegNo,1,2),BOn,VUseCRLF,TmpIO);

                Write_EDILine('NAD+BY+'+UserVReg,BOn,VUseCRLF,TmpIO);

                Write_EDILine('MOA+5+'+EDITriInd[TriMode]+':'+Form_Real(ESLValue,0,0),BOn,VUseCRLF,TmpIO);
              end
              else
              Begin
                Write_EDILine('LIN+'+Form_Int(ESLLNo,0),BOn,VUseCRLF,TmpIO);

                UserVReg:=VEDIFmtStr(Strip('A',[#32],CustR.VATRegNo));

                Write_EDILine('NAD+BY+'+UserVReg,BOn,VUseCRLF,TmpIO);

                Write_EDILine('MOA+38:'+Form_Real(ESLValue,0,0),BOn,VUseCRLF,TmpIO);

                If (TriMode) then
                Begin
                  Write_EDILine('GIS+T:200',BOn,VUseCRLF,TmpIO);
                end
              end;

            end;

    end; {case..}
  end; {With..}


end;



Procedure TSend_VATEDI.Write_EDICNT(EDIRec  :  EDI1Type;
                                Var NoSegs  :  LongInt;
                                    VMode   :  Byte;
                                    RepTot  :  AgedTyp;
                                    NoITems :  LongInt;
                                Var TmpIO   :  Integer);


Begin
  With EDIRec do
  Begin
    Case VEdiFACT of
      0  :  Begin

            end;
      1  :  Begin

              If (CurrentCountry=IECCode) then
              Begin
                Case VMode of
                  0, EC_SALES_EXPORT_MODE
                    :  Begin
                          Write_EDILine('CNT+02:'+Form_Int(NoItems,0),BOn,VUseCRLF,TmpIO);

                          Write_EDILine('CNT+20:'+Form_Real(RepTot[1],0,0),BOn,VUseCRLF,TmpIO);

                          NoSegs:=NoSegs+2;

                        end;

                  1,2 : Begin
                          Write_EDILine('UNS+S',BOn,VUseCRLF,TmpIO);

                          Write_EDILine('CNT+2:'+Form_Int(NoItems,0),BOn,VUseCRLF,TmpIO);

                          Write_EDILine('CNT+18:'+Form_Real(RepTot[2],0,0),BOn,VUseCRLF,TmpIO);

                          Write_EDILine('CNT+19:'+Form_Real(RepTot[3],0,0),BOn,VUseCRLF,TmpIO);

                          Write_EDILine('CNT+20:'+Form_Real(RepTot[1],0,0),BOn,VUseCRLF,TmpIO);

                          Write_EDILine('CNT+21:'+Form_Real(RepTot[4],0,0),BOn,VUseCRLF,TmpIO);


                          NoSegs:=NoSegs+6;


                        end;

                end; {case..}

              end;

            end;

    end; {case..}
  end; {With..}


end;


Procedure TSend_VATEDI.Write_EDIUNZ(EDIRec  :  EDI1Type;
                                    NoSegs  :  LongInt;
                                Var TmpIO   :  Integer);


Begin
  With EDIRec do
  Begin
    Case VEdiFACT of
      0  :  Begin
              Write_EDILine('UNT+'+Form_Int(NoSegs,0)+'+EXCH'+Today,BOn,VUseCRLF,TmpIO);

              Write_EDILine('UNZ+1'+'+EXCH'+Today,BOn,VUseCRLF,TmpIO);

            end;
      1  :  Begin

              If (CurrentCountry<>IECCode) then
              Begin
                Write_EDILine('UNS+S',BOn,VUseCRLF,TmpIO);

                Write_EDILine('UNT+'+Form_Int(NoSegs+1,0)+'+EXCH'+Today,BOn,VUseCRLF,TmpIO);

                Write_EDILine('UNZ+1'+'+EXCH'+Today,BOn,VUseCRLF,TmpIO);
              end
              else
              Begin

                Write_EDILine('UNT+'+Form_Int(NoSegs,0)+'+EXCH'+Today,BOn,VUseCRLF,TmpIO);

                Write_EDILine('UNZ+1'+'+EXCH'+Today,BOn,VUseCRLF,TmpIO);

              end;

            end;

    end; {case..}
  end; {With..}


end;


// CJS 2014-05-15 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
procedure TSend_VATEDI.ClearLineList;
var
  i: Integer;
begin
  if Assigned(fLineList) then
  begin
    try
      // Free the memory of any list items
      for i := 0 to (fLineList.Count - 1) do
        Dispose(fLineList.Items[i]);
    finally
      // Clear the actual entries
      fLineList.Clear;
    end;
  end;
end;

// CJS 2014-05-15 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
Procedure TSend_VATEDI.Read_LineDetails(EDIRec  :  EDI1Type;
                                       CustR   :  CustRec;
                                        InvR    :  InvRec;
                                        IdR     :  Idetail;
                                        StockR  :  StockRec;
                                        VATChk  :  Char);
Var
  UserVReg  :  Str50;
  LocCode   :  Str5;
  Rnum,
  Rnum2,
  Rnum3,
  Rnum4,
  StatUpLift:  Double;
  LineDetails: PLineDetails;
Begin
  New(LineDetails);
  With EDIRec do
  Begin
    If (VATChk = VATECDCode) then
    Begin
      // Dispatches
      LineDetails.LocationCode := '36';
      LineDetails.Uplift       := StockR.SSDDUplift;
    end
    else
    Begin
      // Arrivals
      LineDetails.LocationCode := '35';
      LineDetails.Uplift       := StockR.SSDAUpLift;
    end;

    LineDetails.StockUnitSupp := StockR.UnitSupp;
    // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
    LineDetails.CommodityCode := Copy(StockR.CommodCode, 1, 8);

    If (IdR.SSDUseLine) then
    Begin
      LineDetails.UpLift        := IdR.SSDUpLift;
      // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
      LineDetails.CommodityCode := Copy(IdR.SSDCommod, 1, 8);
    end;

    // Calculate the line value
    LineDetails.LineValue := DetLTotal(IdR, BOn, BOff, 0.0) * LineCnst(IdR.Payment);  { -ves not allowed, must use +ve only! }

    // Calculate the weight of the stock item(s)
    LineDetails.LineWeight := ForceNearestWhole(Calc_IdQty(IdR.Qty, IdR.QtyMul, IdR.UsePack) * IdR.LWeight, 2);

    // Calculate the total number of stock items
    LineDetails.LineQuantity := DivWChk((IdR.Qty * IdR.QtyMul), StockR.SuppSUnit);

    LineDetails.VATRegistrationCode := CustR.VATRegNo;
    LineDetails.SSDCountry := StockR.SSDCountry;
  end;
  fLineList.Add(LineDetails);
end;

Procedure TSend_VATEDI.Write_EDILines(EDIRec  :  EDI1Type;
                                      InvR    :  InvRec;
                                      VATChk  :  Char;
                                      DeliveryCharge: Double;
                                  Var SSDLNo  :  LongInt;
                                  Var NoSegs  :  LongInt;
                                  Var RepTot  :  AgedTyp;
                                  Var TmpIO   :  Integer);
var
  LineDetails: PLineDetails;
  Entry: Integer;
  LineCount: Integer;
  Adjustment: Double;
  LineTot: AgedTyp;
  UserVReg  :  Str50;
begin
  LineCount := fLineList.Count;
  for Entry := 0 to fLineList.Count - 1 do
  begin
    LineDetails := fLineList[Entry];
    if (LineCount > 0) and (DeliveryCharge > 0) then
    begin
      // The pro-rata Delivery Charge is the remaining Delivery Charge value
      // divided by the number of remaining items. We don't need to do anything
      // special to assign any stray pence to the final item, because the item
      // count that we are dividing by will be 1 at that point, leaving the
      // entire remaining value.
      Adjustment := DeliveryCharge / LineCount;

      // Decrement the remaining Delivery Charge and Item Count
      DeliveryCharge := DeliveryCharge - Adjustment;
      LineCount := LineCount - 1;

      // Apply the delivery charge adjustment
      LineDetails.LineValue := LineDetails.LineValue + Adjustment;
    end;

    // Calculate the final line totals and add them to the report total
    LineDetails.LineValueConsolidated :=
      ForceNearestWhole(Conv_VATCurr(LineDetails.LineValue, InvR.VATCRate[UseCoDayRate],
                                     XRate(InvR.OrigRates, BOff, InvR.Currency),
                                     InvR.Currency, InvR.UseORate), 2);

    LineTot[1] := LineDetails.LineValueConsolidated;
    LineTot[2] := LineDetails.LineWeight;
    Linetot[3] := LineDetails.LineQuantity;
    LineTot[4] := Round(LineTot[1] + (LineTot[1] * Pcnt(LineDetails.Uplift)));

    GrandAgedTotal(RepTot, LineTot);

    // Extract the two-character country code from the start of the Trader's
    // VAT Registration number
    UserVReg := VEDIFmtStr(Copy(LineDetails.VATRegistrationCode, 1, 2));

    // Write the line to the file
    Inc(SSDLNo);
    Case EDIRec.VEdiFACT of
      0  :  Begin // SEMDEC format

              // Customs Status (Commodity Code, Flow (A or D), Nature of Transaction
              Write_EDILine('CST++'+VEDIFmtStr(LineDetails.CommodityCode)+':122+'+VATChk+':105+'+SETN(InvR.TransNat)+':112',BOn,EDIRec.VUseCRLF,TmpIO);

              // Location (country code and company registration number)
              Write_EDILine('LOC+'+LineDetails.LocationCode+':'+UserVReg,BOn,EDIRec.VUseCRLF,TmpIO);

              // Monetary Amount (the line value, in whole pounds)
              Write_EDILine('MOA+5+123:'+Form_Real(LineDetails.LineValueConsolidated,0,0),BOn,EDIRec.VUseCRLF,TmpIO);

              // Measurement (net mass, in whole kilograms)
              Write_EDILine('MEA+AAR++G13:'+Form_Real(LineDetails.LineWeight,0,0),BOn,EDIRec.VUseCRLF,TmpIO);

              If (LineDetails.StockUnitSupp <> '') then
              Begin
                // Supplementary Measurement
                Write_EDILine('MEA+AAS+'+VEDIFmtStr(UpCaseStr(LineDetails.StockUnitSupp))+'+G14:'+Form_Real(LineDetails.LineQuantity,0,0),BOn,EDIRec.VUseCRLF,TmpIO);

                Inc(NoSegs);
              end;

              // Declarer's Reference (the transaction reference in Exchequer's case)
              Write_EDILine('RFF+ABE:'+VEDIFmtStr(InvR.OurRef),BOn,EDIRec.VUseCRLF,TmpIO);

              // Terms of Delivery (three-character code)
              Write_EDILine('TOD+++'+VEDIFmtStr(InvR.DelTerms),BOn,EDIRec.VUseCRLF,TmpIO);

              // ???  [This line-type is not mentioned in HMRC's SEMDEC format document]
              Write_EDILine('TDT+11++'+Form_Int(InvR.TransMode,0),BOn,EDIRec.VUseCRLF,TmpIO);

              NoSegs := NoSegs + 7;

            end;
      1  :  Begin // INSTAT format

              If (CurrentCountry<>IECCode) then
              Begin
                // Customs Status (Line Number, Nature of Transaction, Commodity Code)
                Write_EDILine('CST+'+Form_Int(SSDLNo,0)+'+'+SETN(InvR.TransNat)+':112+'+VEDIFmtStr(LineDetails.CommodityCode)+':122',
                             BOn,EDIRec.VUseCRLF,TmpIO);

                // Location (country code and company registration number)
                Write_EDILine('LOC+'+LineDetails.LocationCode+'+'+UserVReg,BOn,EDIRec.VUseCRLF,TmpIO);

                // Measurement (net mass, in whole kilograms)
                Write_EDILine('MEA+WT++KGM:'+Form_Real(LineDetails.LineWeight,0,0),BOn,EDIRec.VUseCRLF,TmpIO);

                If (LineDetails.StockUnitSupp <>'') then
                Begin
                  Write_EDILine('MEA+AAE++ICN:'+Form_Real(LineDetails.LineQuantity,0,0),BOn,EDIRec.VUseCRLF,TmpIO);
                  Inc(NoSegs);
                end;

                Write_EDILine('TDT+2++'+Form_Int(InvR.TransMode,0),BOn,EDIRec.VUseCRLF,TmpIO);

                Write_EDILine('MOA+38:'+Form_Real(LineDetails.LineValueConsolidated,0,0),BOn,EDIRec.VUseCRLF,TmpIO);


                Write_EDILine('RFF+ABE:'+VEDIFmtStr(InvR.OurRef),BOn,EDIRec.VUseCRLF,TmpIO);

                Write_EDILine('TOD+++'+VEDIFmtStr(InvR.DelTerms),BOn,EDIRec.VUseCRLF,TmpIO);

                NoSegs:=NoSegs+7;
              end
              else
              Begin
                Write_EDILine('CST+'+Form_Int(SSDLNo,0)+'+'+VEDIFmtStr(LineDetails.CommodityCode)+':122+'+Form_Int(InvR.TransNat,0)+':112',
                               BOn,EDIRec.VUseCRLF,TmpIO);

                Write_EDILine('LOC+'+LineDetails.LocationCode+'+'+UserVReg+':66',BOn,EDIRec.VUseCRLF,TmpIO);

                Write_EDILine('LOC+27+'+LineDetails.SSDCountry+':66',BOn,EDIRec.VUseCRLF,TmpIO);


                Write_EDILine('MEA+WT++KGM:'+Form_Real(LineDetails.LineWeight,0,0),BOn,EDIRec.VUseCRLF,TmpIO);

                If (LineDetails.StockUnitSupp <> '') then
                Begin
                  Write_EDILine('MEA+AAE++'+VEDIFmtStr(UpCaseStr(LineDetails.StockUnitSupp))+':'+Form_Real(LineDetails.LineQuantity,0,0),BOn,EDIRec.VUseCRLF,TmpIO);

                  Inc(NoSegs);
                end;

                Write_EDILine('TDT+2++'+Form_Int(InvR.TransMode,0),BOn,EDIRec.VUseCRLF,TmpIO);

                Write_EDILine('MOA+38:'+Form_Real(LineDetails.LineValueConsolidated,0,0),BOn,EDIRec.VUseCRLF,TmpIO);

                Write_EDILine('MOA+123:'+Form_Real(LineTot[4],0,0),BOn,EDIRec.VUseCRLF,TmpIO);

                Write_EDILine('RFF+ABE:'+VEDIFmtStr(InvR.OurRef),BOn,EDIRec.VUseCRLF,TmpIO);

                Write_EDILine('TOD+++'+VEDIFmtStr(InvR.DelTerms),BOn,EDIRec.VUseCRLF,TmpIO);

                NoSegs:=NoSegs+9;
              end;
            end;

    end; {case..}

  end;
end;

//Procedure TSend_VATEDI.Write_EDISSD(EDIRec  :  EDI1Type;
//                                    CustR   :  CustRec;
//                                    InvR    :  InvRec;
//                                    IdR     :  Idetail;
//                                    StockR  :  StockRec;
//                                    VATChk  :  Char;
//                                    SSDLNo  :  LongInt;
//                                Var NoSegs  :  LongInt;
//                                Var RepTot  :  AgedTyp;
//                                Var TmpIO   :  Integer);
//Var
//  UserVReg  :  Str50;
//  LocCode   :  Str5;
//  Rnum,
//  Rnum2,
//  Rnum3,
//  Rnum4,
//  StatUpLift
//            :  Double;
//  LineTot   :  AgedTyp;
//
//Begin
//  // With EDIRec,CustR,InvR,IdR,StockR do
//  With EDIRec, CustR, InvR do
//  Begin
//    If (VATChk = VATECDCode) then
//    Begin
//      // Dispatches
//      LocCode    := '36';
//      StatUpLift := StockR.SSDDUpLift;
//    end
//    else
//    Begin
//      // Arrivals
//      LocCode    := '35';
//      StatUpLift := StockR.SSDAUpLift;
//    end;
//
//    If (IdR.SSDUseLine) then
//    Begin
//      StatUpLift := IdR.SSDUpLift;
//      StockR.CommodCode := IdR.SSDCommod;
//      StockR.SuppSUnit  := IdR.SSDSPUnit;
//    end;
//
//    Blank(LineTot,Sizeof(LineTot));
//
//    // Calculate the line value
//    Rnum := DetLTotal(IdR, BOn, BOff, 0.0) * LineCnst(IdR.Payment);  { -ves not allowed, must use +ve only! }
//
//    { v2.30 Inv.OrigRates used so it is expressed in orig Co Rate }
//    { v5.52 On UK Intrastat round up to nearest 1 }
//
//    // Convert the line value to consolidated currency
//    Rnum2 := ForceNearestWhole(Conv_VATCurr(Rnum, VATCRate[UseCoDayRate],
//                                            XRate(InvR.OrigRates, BOff, InvR.Currency),
//                                            InvR.Currency, InvR.UseORate), 2);
//
//    // Calculate the weight of the stock item(s)
//    Rnum3 := ForceNearestWhole(Calc_IdQty(IdR.Qty, IdR.QtyMul, IdR.UsePack) * IdR.LWeight, 2);
//
//    // Calculate the total number of stock items
//    Rnum4 := DivWChk((IdR.Qty * IdR.QtyMul), StockR.SuppSUnit);
//
//    // Copy the values into the Line Totals array and then use this to update
//    // the grand totals
//    LineTot[1] := Rnum2;
//    LineTot[2] := Rnum3;
//    Linetot[3] := Rnum4;
//    LineTot[4] := Round(LineTot[1]+(LineTot[1]*Pcnt(StatUpLift)));
//
//    GrandAgedTotal(RepTot, LineTot);
//
//    // Extract the two-character country code from the start of the Trader's
//    // VAT Registration number
//    UserVReg := VEDIFmtStr(Copy(CustR.VATRegNo, 1, 2));
//
//    Case VEdiFACT of
//      0  :  Begin // SEMDEC format
//
//              // Customs Status (Commodity Code, Flow (A or D), Nature of Transaction
//              // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
//              Write_EDILine('CST++'+VEDIFmtStr(Copy(StockR.CommodCode, 1, 8))+':122+'+VATChk+':105+'+SETN(TransNat)+':112',BOn,VUseCRLF,TmpIO);
//
//              // Location (country code and company registration number)
//              Write_EDILine('LOC+'+LocCode+':'+UserVReg,BOn,VUseCRLF,TmpIO);
//
//              // Monetary Amount (the line value, in whole pounds)
//              Write_EDILine('MOA+5+123:'+Form_Real(Rnum2,0,0),BOn,VUseCRLF,TmpIO);
//
//              // Measurement (net mass, in whole kilograms)
//              Write_EDILine('MEA+AAR++G13:'+Form_Real(Rnum3,0,0),BOn,VUseCRLF,TmpIO);
//
//              If (StockR.UnitSupp <> '') then
//              Begin
//                // Supplementary Measurement
//                Write_EDILine('MEA+AAS+'+VEDIFmtStr(UpCaseStr(StockR.UnitSupp))+'+G14:'+Form_Real(Rnum4,0,0),BOn,VUseCRLF,TmpIO);
//
//                Inc(NoSegs);
//              end;
//
//              // Declarer's Reference (the transaction reference in Exchequer's case)
//              Write_EDILine('RFF+ABE:'+VEDIFmtStr(OurRef),BOn,VUseCRLF,TmpIO);
//
//              // Terms of Delivery (three-character code)
//              Write_EDILine('TOD+++'+VEDIFmtStr(DelTerms),BOn,VUseCRLF,TmpIO);
//
//              // ???  [This line-type is not mentioned in HMRC's SEMDEC format document]
//              Write_EDILine('TDT+11++'+Form_Int(TransMode,0),BOn,VUseCRLF,TmpIO);
//
//              NoSegs:=NoSegs+7;
//
//            end;
//      1  :  Begin // INSTAT format
//
//              If (CurrentCountry<>IECCode) then
//              Begin
//                // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
//                Write_EDILine('CST+'+Form_Int(SSDLNo,0)+'+'+SETN(TransNat)+':112+'+VEDIFmtStr(Copy(StockR.CommodCode, 1, 8))+':122',
//                             BOn,VUseCRLF,TmpIO);
//
//
//                Write_EDILine('LOC+'+LocCode+'+'+UserVReg,BOn,VUseCRLF,TmpIO);
//
//                Write_EDILine('MEA+WT++KGM:'+Form_Real(Rnum3,0,0),BOn,VUseCRLF,TmpIO);
//
//                If (StockR.UnitSupp<>'') then
//                Begin
//                  {Write_EDILine('MEA+AAE++'+VEDIFmtStr(UpCaseStr(UnitSupp))+':'+Form_Real(Rnum4,0,0),BOn,VUseCRLF,TmpIO);}
//
//                  Write_EDILine('MEA+AAE++ICN:'+Form_Real(Rnum4,0,0),BOn,VUseCRLF,TmpIO);
//
//                  Inc(NoSegs);
//                end;
//
//                Write_EDILine('TDT+2++'+Form_Int(TransMode,0),BOn,VUseCRLF,TmpIO);
//
//                Write_EDILine('MOA+38:'+Form_Real(Rnum2,0,0),BOn,VUseCRLF,TmpIO);
//
//
//                Write_EDILine('RFF+ABE:'+VEDIFmtStr(OurRef),BOn,VUseCRLF,TmpIO);
//
//                Write_EDILine('TOD+++'+VEDIFmtStr(DelTerms),BOn,VUseCRLF,TmpIO);
//
//                NoSegs:=NoSegs+7;
//              end
//              else
//              Begin
//                Write_EDILine('CST+'+Form_Int(SSDLNo,0)+'+'+VEDIFmtStr(StockR.CommodCode)+':122+'+Form_Int(TransNat,0)+':112',
//                               BOn,VUseCRLF,TmpIO);
//
//
//                Write_EDILine('LOC+'+LocCode+'+'+UserVReg+':66',BOn,VUseCRLF,TmpIO);
//
//                Write_EDILine('LOC+27+'+StockR.SSDCountry+':66',BOn,VUseCRLF,TmpIO);
//
//
//                Write_EDILine('MEA+WT++KGM:'+Form_Real(Rnum3,0,0),BOn,VUseCRLF,TmpIO);
//
//                If (StockR.UnitSupp<>'') then
//                Begin
//                  Write_EDILine('MEA+AAE++'+VEDIFmtStr(UpCaseStr(StockR.UnitSupp))+':'+Form_Real(Rnum4,0,0),BOn,VUseCRLF,TmpIO);
//
//                  Inc(NoSegs);
//                end;
//
//                Write_EDILine('TDT+2++'+Form_Int(TransMode,0),BOn,VUseCRLF,TmpIO);
//
//                Write_EDILine('MOA+38:'+Form_Real(Rnum2,0,0),BOn,VUseCRLF,TmpIO);
//
//                Write_EDILine('MOA+123:'+Form_Real(LineTot[4],0,0),BOn,VUseCRLF,TmpIO);
//
//
//                Write_EDILine('RFF+ABE:'+VEDIFmtStr(OurRef),BOn,VUseCRLF,TmpIO);
//
//                Write_EDILine('TOD+++'+VEDIFmtStr(DelTerms),BOn,VUseCRLF,TmpIO);
//
//                NoSegs:=NoSegs+9;
//              end;
//            end;
//
//    end; {case..}
//  end; {With..}
//
//
//end;


{ === Create Null Section === }

Procedure TSend_VATEDI.Write_EDINIL(EDIRec  :  EDI1Type;
                                    VATChk  :  Char;
                                    VMode   :  Byte;
                                    SSDLNo  :  LongInt;
                                Var NoSegs  :  LongInt;
                                Var TmpIO   :  Integer);

Var
  LocCode  :  Str5;

Begin

  If (VATChk=VATECDCode) then
      LocCode:='36'
    else
      LocCode:='35';

  With EDIRec do
  Case VMode of
    0, EC_SALES_EXPORT_MODE
      :  Begin
            Case VEdiFACT of
               0  :  Begin

                     end;

               1  :  Begin

                     end;

            end; {Case..}

          end;

    1,2 : If (CurrentCountry<>IECCode) then
          Begin
            Case VEdiFACT of
               0  :  Begin
                       Write_EDILine('CST++00000000:122+'+VATChk+':105+99:112',BOn,VUseCRLF,TmpIO);

                       Write_EDILine('LOC+'+LocCode+':  ',BOn,VUseCRLF,TmpIO);

                       Write_EDILine('MOA+5+123:0',BOn,VUseCRLF,TmpIO);

                       Write_EDILine('TOD+++   ',BOn,VUseCRLF,TmpIO);

                       Write_EDILine('TDT+11++0',BOn,VUseCRLF,TmpIO);

                       NoSegs:=NoSegs+5;
                     end;

               1  :  Begin
                       Write_EDILine('CST+1+99:112',BOn,VUseCRLF,TmpIO);

                       NoSegs:=NoSegs+1;
                     end;

            end; {Case..}

          end;



  end; {Case..}

end;


Procedure TSend_VATEDI.Write_FixMsg(S  :  String);

Begin
  If (Assigned(SMemo)) then
  Begin
    Try
      SMemo.Add(S);
    except
      SMemo.Free;
      SMemo:=nil;
    end; {try..}

  end; { Write to Memo }

end;


Function TSend_VATEDI.Generate_VATEDI_SSD(VATStartD,VATEndD  :  LongDate;
                                          VMode              :  Byte;
                                          VATChk             :  Char;
                                      Var NoSegs,
                                          SSDLNo             :  LongInt;
                                      Var RepTotals          :  AgedTyp     )  :  Boolean;


Const
  Fnum1       =  InvF;
  Keypath1    =  InvCustK;

  Fnum2       =  IdetailF;
  Keypath2    =  IdFolioK;

Var
  KeyS,
  KeyChk,
  KeyS2,
  KeyChk2,
  KeyCF       :  Str255;


  TmpIO       :  Integer;

  Lnum        :  LongInt;

  LineFail,
  Ok2Cont,
  TmpInclude  :  Boolean;

  // CJS 2014-05-15 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
  TotalDeliveryCharge: Double;
  LineValue: Double;

Begin

  Lnum:=0; Ok2Cont:=BOn;  TmpInclude:=BOff; LineFail:=BOff; TmpIO:=0;


  With MTExLocal^,LCust do
  Begin
    KeyChk:=FullCustType(CustCode,CustSupp);

    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum1,KeyPath1,KeyS);

    While (LStatusOk) and (Checkkey(KeyChk,KeyS,Length(KeyChk),BOn))  and (Not ThreadRec^.THAbort)  do
    With LInv do
    Begin

      // CJS 2014-05-16 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
      TotalDeliveryCharge := 0.0;

      {$B-}

      If (Not (SSDProcess In ['P','T'])) and (Assigned(ECReport)) and  (ECReport^.IncludeECInv(LInv,VATStartD,VATEndD)) then

      {$B+}

      Begin
        ShowStatus(2,'Calculating '+OurRef);


        KeyChk2:=FullNomKey(FolioNum);

        KeyS2:=FullIdKey(FolioNum,1);

        LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeyS2);


        While (LStatusOk) and (Checkkey(KeyChk2,KeyS2,Length(KeyChk2),BOn))  and (Not ThreadRec^.THAbort)  do
        With LId do
        Begin

          // CJS 2014-05-15 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
          if ((VATCode = VATChk) and (DocLTLink = 3)) then
          begin
            // Delivery Charge line. Do not include it directly in the
            // export, but accumulate the Delivery Charge details for
            // this transaction

            // Calculate the line value with the correct sign, to match
            // with the equivalent calculation in Write_EDILines.
            //
            // Don't convert to currency, as this will be done after the
            // value has been added to the lines in PrintReportLine.
            LineValue := (DetLTotal(LId,BOn,BOff,0.0)) * LineCnst(Payment);

            TotalDeliveryCharge := TotalDeliveryCharge + LineValue;
          end
          else if ((VATCode=VATChk) and (LineNo>0) and Is_FullStkCode(StockCode) and (Qty>0)) then
          Begin

            If (StockCode<>LStock.StockCode) then
              TmpInclude:=LGetMainRecPos(StockF,StockCode);

            LineFail:=BOff;

            If (TmpInclude) then
            With LStock do
            Begin
              // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
              If (CommodCode='') or (Length(CommodCode)<>8) or (Length(CommodCode)<>10) then
              Begin
                Write_FixMsg('The commodity/TARIC code for '+Strip('R',[#32],StockCode)+' on '+OurRef+' is not valid.');
                LineFail:=BOn;
              end;

              If (Not ValidDelTerms(DelTerms)) then
              Begin
                Write_FixMsg('The Delivery terms for '+OurRef+' are not valid.');
                LineFail:=BOn;
              end;

              If (Not ValidNatTran(TransNat)) then
              Begin
                Write_FixMsg('The Nature of Transaction for '+OurRef+' is not valid.');
                LineFail:=BOn;
              end;

              If (TransMode=0) then
              Begin
                Write_FixMsg('The Transport Mode for '+OurRef+' is not valid.');
                LineFail:=BOn;
              end;

              {* Only if being sent as SEMDEC, check unit supp, as INSTAT hard codes ICN *}

              If (UnitSupp<>'') and (Length(UnitSupp)>3) and
              ((SyssEDI1^.EDI1Value.VEdiFACT=0) or (CurrentCountry=IECCode)) then
              Begin
                Write_FixMsg('The SSD Unit Description for '+Strip('R',[#32],StockCode)+' on '+OurRef+
                             ' can only be 3 chars long.');

                Write_FixMsg('This entry will be included in the file.');
              end;


              TmpInclude:=(Not LineFail);
            end;

            If (TmpInclude) then
            Begin

              // CJS 2014-05-16 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
              Read_LineDetails(SyssEDI1^.EDI1Value, LCust, LInv, LId, LStock, VATChk);

              If (NewExport) then
              Begin
                NewExport:=BOff;

                Write_EDIUNH2(SyssEDI1^.EDI1Value,VATChk,BOff,NoSegs,TmpIO);
              end;

              // CJS 2014-05-16 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
              // Removed original calls (see Write_EDILines call below for the new version)
              {* Send SSD Line *}
              // Inc(SSDLNo);
              // Write_EDISSD(SyssEDI1^.EDI1Value,LCust,LInv,LId,LStock,VATChk,SSDLNo,NoSegs,RepTotals,TmpIO);

            end
            else
              CouldHave:=(Not TmpInclude) or (CouldHave);
          end;

          LStatus:=LFind_Rec(B_GetNext,Fnum2,KeyPath2,KeyS2);


        end; {Loop..}

        // CJS 2014-05-16 - ABSEXCH-15344 - Delivery Charges on Intrastat EDI Export
        Write_EDILines(SyssEDI1^.EDI1Value,LInv,VATChk,TotalDeliveryCharge,SSDLNo,NoSegs,RepTotals,TmpIO);
        // Clear down the list of transaction line details ready for the next
        // transaction
        ClearLineList;

      end;{If In Range }

      LStatus:=LFind_Rec(B_GetNext,Fnum1,KeyPath1,KeyS);

    end; {Inv Loop..}

  end; {With Cust Check Loop..}

  Generate_VATEDI_SSD:=Not ThreadRec^.THAbort;
end; {Proc..}



Function TSend_VATEDI.Generate_VATEDI_ESL(VATStartD,VATEndD  :  LongDate;
                                          VMode              :  Byte;
                                          VATChk             :  Char)  :  Boolean;

Const
  Fnum      =  CustF;
  Keypath   =  CustCntyK;

Var
  KeyChk,
  KeyS      :  Str255;

  AbortPrint,
  TmpInclude,
  Loop,
  Ok2Cont   :  Boolean;

  ThisEC,
  ThisECTri :  Double;

  //PR: 20/02/2014 ABSEXCH-15042 For new var parameter to Scan_4ECSales function
  DummyServices : Double;


  TMPIO     :  Integer;

  NOSegs,
  ESLLNo    :  LongInt;

  RepTotals :  AgedTyp;

  IncludeLine: Boolean;
Begin
  ThisEC := 0;
  TMPIO:=0; NOSegs:=0; ESLLNo:=0;  NewExport:=BOn;

  Loop:=BOff;
  Blank(RepTotals,Sizeof(RepTotals));
  KeyChk:=TradeCode[(VMode<>2)];
  KeyS:=KeyChk;

  With MTExLocal^ do
  Begin
    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    AbortPrint:=Not LStatusOk;

    Ok2Cont:=(Not ThreadRec^.THAbort);

    Write_EDIUNB(SyssEDI1^.EDI1Value,VMode,TMPIO);

    If (TMPIO=0) then
    Begin
      Write_EDIUNH(SyssEDI1^.EDI1Value,VATEndD,VATChk,VMode,NoSegs,TMPIO);
      {NoSEGS:=4+(1*SyssEDI1^.EDI1Value.VEDIFact); {* 7 for Instat *}
    end;

    While (Not AbortPrint) and (Ok2Cont) and (Checkkey(KeyChk,KeyS,Length(KeyChk),BOn)) and (TMPIO=0) do
    With LCust do
    Begin

      Ok2Cont:=(Not ThreadRec^.THAbort);

      TmpInclude:=((EECMember) and (CustSupp=TradeCode[VMode<>2])) and (Ok2Cont);

      If (TmpInclude) then
      Begin
        ShowStatus(1,'Processing '+dbFormatName(CustCode,Company));


        TmpInclude:=(VATRegNo[1] In ['A'..'Z']) and (VATRegNo[2] In ['A'..'Z']);


        If (Not TmpInclude) then
          Write_FixMsg('The country code is missing from the '+CCVATName^+' Reg No. for '+dbFormatName(CustCode,Company))
        else
        Begin
          TmpInclude:=(Length(Trim(VATRegNo))<=19) and (Length(Trim(VATRegNo))>2);

          If (Not TmpInclude) then
            Write_FixMsg('The '+CCVATName^+' Reg No. for '+dbFormatName(CustCode,Company)+' is not valid.');

        end;


        CouldHave:=(Not TmpInclude) or (CouldHave);
      end;

      Case VMode of

        0  :  If (TmpInclude) then
              Begin


                If (TmpInclude)  and (Assigned(ECReport)) then
                Begin

                  if (VMode = EC_SALES_EXPORT_MODE) then
                  begin
                    TmpInclude := ECReport.Calc_ECSales(CustCode, VATStartD, VATEndD, CustTotals);
                  end
                  else
                  begin
                    //PR: 20/02/2014 ABSEXCH-15042 Added new var parameter to Scan_4ECSales function
                    ThisEC:=ECReport^.Scan_4ECSales(CustCode,CustSupp,VATStartD,VATEndD,ThisECTri, DummyServices);
                    TmpInclude:=(ThisEC+ThisECTri<>0);
                  end;

                end;

                If (TmpInclude) then
                Begin
                  Loop:=BOff;

                  Repeat
                    if VMode = EC_SALES_EXPORT_MODE then
                    begin
                      IncludeLine := ((not Loop) and ((CustTotals.Goods + CustTotals.Services) <> 0.0)) or
                                     ((Loop) and ((CustTotals.TriangulatedGoods + CustTotals.TriangulatedServices) <> 0.0));
                    end
                    else
                      IncludeLine := ((Not Loop) and (ThisEC<>0.0)) or
                                     ((Loop) and (ThisECTri<>0.0));
                    If IncludeLine then
//                    If ((Not Loop) and (ThisEC<>0.0)) or ((Loop) and (ThisECTri<>0.0)) then
                    Begin

                      {* Perform a send *}
                      Inc(ESLLNo);

                      If (NewExport) then
                      Begin
                        NewExport:=BOff;

                        Write_EDIUNH2(SyssEDI1^.EDI1Value,VATChk,BOff,NoSegs,TmpIO);
                      end;

                      If (Loop) then  {*Subs tri value for non tri value*}
                        ThisEC:=ThisECTri;

                      Write_EDIESL(SyssEDI1^.EDI1Value,LCust,ThisEC,ESLLno,Loop,TmpIO);

                      {* Keep running total *}

                      RepTotals[1]:=RepTotals[1]+ThisEC;

                      If (TMPIO=0) then
                      Begin
                        NoSegs:=NoSegs+4;

                        If (CurrentCountry=IECCode) and (Not Loop) then
                          NoSegs:=NoSegs-1;
                      end;
                    end; {If send value}

                    Loop:=Not Loop;

                  Until (Not Loop) or (AbortPrint);
                end;
              end;
      1,2  :  If (TmpInclude) then
              Begin

                Ok2Cont:=Generate_VATEDI_SSD(VATStartD,VATEndD,VMode,VATChk,NoSegs,ESLLno,RepTotals);

              end;

      end; {Case..}



      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      AbortPrint:=Not LStatusOk;
    end; {While..}

    TmpInclude:=(Ok2Cont);

    If (TmpInclude) then
    Begin
      If (ESLLno=0) then
      Begin
        If (Not CouldHave) then
        Begin

          {* Terminate as Nil Return *}

          If (VMode<>0) and (VMode <> EC_SALES_EXPORT_MODE) then
          Begin
            Write_FixMsg(CCVATName^+' EDI export. No records found to export, so a nil return has been created.');
            Write_FixMsg('Although no records were found this file should still be sent.');

            Write_EDIUNH2(SyssEDI1^.EDI1Value,VATChk,BOn,NoSegs,TmpIO);

            Write_EDINIL(SyssEDI1^.EDI1Value,VATChk,VMode,ESLLno,NoSegs,TmpIO)
          end
          else
          Begin
            Write_FixMsg(CCVATName^+' EDI export. No records were found to export. DO NOT SEND THE FILE!');
            DontSendFile:=BOn;
          end;
        end
        else
        Begin
          Write_FixMsg(CCVATName^+' EDI export. No records found to export.');
          Write_FixMsg('However, there were errors in the data, which when corrected may');
          Write_FixMsg('provide enough data for a valid submission. Please correct and try again.');
        end;

      end
      else
      Begin
        Write_FixMsg('A total of '+Form_Int(ESLLNo,0)+' records have been placed in the EDI file.');
        Write_FixMsg('Please send this file as soon as possible.');
      end;


      Inc(NoSegs);  {* Allow for UNT Segment *}

      If (CurrentCountry=IECCode) then {* Write Count segment *}
        Write_EDICNT(SyssEDI1^.EDI1Value,NoSegs,VMode,RepTotals,ESLLNo,TmpIO);

      Write_EDIUNZ(SyssEDI1^.EDI1Value,NoSegs,TmpIO);
    end;

    Generate_VATEDI_ESL:=TmpInclude;
  end; {With..}

end;

function TSend_VATEDI.Generate_VATCSV(VATStartD, VATEndD: LongDate): Boolean;
const
  Fnum      =  CustF;
  Keypath   =  CustCntyK;
var
  KeyChk,
  KeyS      :  Str255;

  AbortPrint,
  TmpInclude,
  Ok2Cont   :  Boolean;

  LineCount : LongInt;

  IncludeLine: Boolean;

  procedure Write_TitleRecord;
  begin
    CSVLines.Add('HMCE_VAT_ESL_BULK_SUBMISSION_FILE');
  end;

  function ValidVATReg(BaseVatReg: string): string;
  var
    CharPos: Integer;
  const
    Numerics: set of Char = ['0','1','2','3','4','5','6','7','8','9'];
  begin
    Result := '';
    for CharPos := 1 to Length(BaseVatReg) do
    begin
      if (BaseVatReg[CharPos] in Numerics) then
        Result := Result + BaseVatReg[CharPos];
    end;
  end;

  procedure Write_HeaderRecord;
  var
    Line: string;
    CompanyName: string;
    d, m, y: Word;
  begin
    {
      * Your UK VAT Registration Number (nine digit numeric value)
        In Exchequer: \System Set-Up\Company\VAT Reg
      * Your subsidiary identifier if you have one (if you do not have a subsidiary ID enter '000')
        This doesn't exist in Exchequer, so set to '000'
      * The year for your declaration eg '2006'
      * The period quarter of your declaration eg '1', '2', '3', or '4' (monthly submitters should input their data into the relevant quarter eg January, February and March should be input into quarter 1)
      * The code 'GBP' (indicating that your declaration is made in pounds sterling)
      * Your contact name (mandatory) maximum of 35 characters (do not include the ampersand '&' symbol, eg A & N Other Ltd should be changed to A and N Other Ltd)
        In Exchequer there is no companywide contact, instead use Company name altered as stipulated
      * The indicator field (this will always be '0').
    }
    Line := ValidVATReg(Syss.UserVATReg) + ',' + '000';
    DateStr(VATEndD, d, m, y);
    Line := Line + ',' + IntToStr(y);
//    Line := Line + ',' + Format('%.2d', [((m - 1) div 3) + 1]);
    Line := Line + ',' + Format('%.2d', [m]);
    Line := Line + ',' + 'GBP';
    CompanyName := Trim(StringReplace(VEDIFmtStr(Syss.UserName), ' & ', ' and ', [rfReplaceAll]));
    CompanyName := StringReplace(CompanyName, '&', ' and ', [rfReplaceAll]);
    Line := Line + ',' + CompanyName;
    Line := Line + ',' + '0';
    CSVLines.Add(Line);
  end;

  procedure Write_LineRecord;
  var
    Line: string;
  begin
    Line := Copy(MTExLocal^.LCust.VATRegNo, 1, 2);
    Line := Line + ',' + Trim(Copy(MTExLocal^.LCust.VATRegNo, 3, 27));
    if ECReport.CRepParam.PrintTri then
      Line := Line + ',' + Trim(Form_Real(Trunc(CustTotals.TriangulatedGoods + CustTotals.TriangulatedServices), 0, 0)) + ',2'
    else if ECReport.CRepParam.PrintServices then
      Line := Line + ',' + Trim(Form_Real(Trunc(CustTotals.Services), 0, 0)) + ',3'
    else
      Line := Line + ',' + Trim(Form_Real(Trunc(CustTotals.Goods), 0, 0)) + ',0';
    CSVLines.Add(Line);
  end;

begin

  LineCount := 0;

  KeyChk := TradeCode[True];
  KeyS   := KeyChk;

  with MTExLocal^ do
  begin
    LStatus := LFind_Rec(B_GetGEq, Fnum, KeyPath, KeyS);

    AbortPrint := not LStatusOk;
    Ok2Cont    := (not ThreadRec^.THAbort);

    Write_TitleRecord;
    Write_HeaderRecord;

    while (not AbortPrint) and (Ok2Cont) and
          (Checkkey(KeyChk, KeyS, Length(KeyChk), BOn)) do
    with LCust do
    begin
      Ok2Cont := (not ThreadRec^.THAbort);

      TmpInclude := ((EECMember) and (CustSupp = TradeCode[True])) and (Ok2Cont);

      if (TmpInclude) then
      begin
        ShowStatus(1, 'Processing ' + dbFormatName(CustCode, Company));

        TmpInclude := (VATRegNo[1] In ['A'..'Z']) and
                      (VATRegNo[2] In ['A'..'Z']);

        if (not TmpInclude) then
          Write_FixMsg('The country code is missing from the ' + CCVATName^ +
                       ' Reg No. for ' + dbFormatName(CustCode, Company))
        else
        begin
          TmpInclude := (Length(Trim(VATRegNo)) <= 19) and
                        (Length(Trim(VATRegNo)) > 2);
          if (not TmpInclude) then
            Write_FixMsg('The ' + CCVATName^ + ' Reg No. for ' +
                         dbFormatName(CustCode, Company) + ' is not valid.');
        end;

        CouldHave := (not TmpInclude) or (CouldHave);
      end;

      if (TmpInclude)  and (Assigned(ECReport)) then
        TmpInclude := ECReport.Calc_ECSales(CustCode, VATStartD, VATEndD, CustTotals);

      if (TmpInclude) then
      begin
        // Goods line
        ECReport.CRepParam.PrintTri := False;
        ECReport.CRepParam.PrintServices := False;
        if (CustTotals.Goods <> 0.0) then
        begin
          Inc(LineCount);
          Write_LineRecord;
        end;

        // Triangulated line
        ECReport.CRepParam.PrintTri := True;
        if ((CustTotals.TriangulatedGoods + CustTotals.TriangulatedServices) <> 0.0) then
        begin
          Inc(LineCount);
          Write_LineRecord;
        end;

        // Services line
        ECReport.CRepParam.PrintTri := False;
        ECReport.CRepParam.PrintServices := True;
        if (CustTotals.Services <> 0.0) then
        begin
          Inc(LineCount);
          Write_LineRecord;
        end;
      end;

      LStatus := LFind_Rec(B_GetNext, Fnum, KeyPath, KeyS);

      AbortPrint := not LStatusOk;
    end;

    TmpInclude := (Ok2Cont);

    If (TmpInclude) then
    Begin
      If (LineCount = 0) then
      Begin
        If (Not CouldHave) then
        Begin
          {* Terminate as Nil Return *}
          Write_FixMsg(CCVATName^ + ' CSV export. No records were found to export. DO NOT SEND THE FILE!');
          DontSendFile:=BOn;
        end
        else
        Begin
          Write_FixMsg(CCVATName^ + ' CSV export. No records found to export.');
          Write_FixMsg('However, there were errors in the data, which when corrected may');
          Write_FixMsg('provide enough data for a valid submission. Please correct and try again.');
        end;
      end
      else
      Begin
        Write_FixMsg('A total of ' + Form_Int(LineCount, 0) + ' records have been placed in the CSV file.');
        Write_FixMsg('Please send this file as soon as possible.');
      end;
    end;
    Result := TmpInclude;
  end;

end;

Function  TSend_VATEDI.CompressEDIFile(DPath     :  Str255;
                                       TestMode  :  Boolean;
                                       VEDIM     :  Byte;
                                       SendEmail :  Boolean)  :  Boolean;

Var
  ZipO   : TEntZip;
  Res    : SmallInt;

  GenStr : Str255;

Begin
  Res:=0;
  ZipO := TEntZip.Create;
  Try
    With ZipO Do
    Begin
      DOSPaths          := BOn;
      OverwriteExisting := BOn;
      Recurse           := BOff;
      RemoveDots        := BOn;
      StripDrive        := BOn;
      StripPath         := BOn;
      ZipName           := BuildPath(DPath)+CAEFName+'.ZIP';

      Files.Add(SetDrive+EDIFName(TestMode,0));

      Res := Save;
    End; { With }
  Finally
    ZipO.Destroy;
  End; {Try..}

  If (Res<>0) then
    Write_FixMsg('It was not possible to compress the file for the following reason. '+ZipErr(Res))
  else
  Begin

    GenStr:='The compressed file '+BuildPath(DPath)+CAEFName+'.ZIP was created successfully.';

    If (VEDIM=0) or (Not SendEmail) then
      GenStr:=GenStr+'  Please send this file on its own.'
    else
      If (SendEmail) then
        GenStr:=GenStr+'  This file will be emailed.';

    Write_FixMsg(GenStr);
  end;

  Result:=(Res=0);
end;


Function TSend_VATEDI.SendEDIEmail(Compressed   :  Boolean) :  Boolean;

Var
  EmailO : TEntEmail;
  Res    : SmallInt;
  GenStr : Str255;
  Locked : Boolean;

Begin
  Res:=0;

  EmailO := TEntEmail.Create;
  Try
    With EmailO, SyssEDI1^.EDI1Value Do
    Begin
      If (Compressed) then
        GenStr:=BuildPath(VDirPath)+CAEFName+'.ZIP'
      else
      Begin
        GenStr:=BuildPath(VDirPath)+EDIFName(VTestMode,0);
      end;

      Attachments.Add(GenStr);

      Priority := VEPriority;

      Recipients.Add(VCEEmail);

      Sender := VUEmail;

      Locked:=BOff;

      If GetMultiSys(BOff,Locked,EDI2R) then
      Begin

        SenderName := SyssEDI2^.EDI2Value.EmName;
        SMTPServer := SyssEDI2^.EDI2Value.EmSMTP;
        UseMapi    := SyssEDI2^.EDI2Value.EmUseMAPI;

        If (SenderName<>'') and (SMTPServer<>'') and (VCEEmail<>'') and (VUEMail<>'') then
          Res := Send
        else
          Res:=4;
      end
      else
      Begin
        Res:=4;
      end;




    End; { With }
  Finally
    EmailO.Destroy;
  End;

  If (Res<>0) then
    Write_FixMsg('It was not possible to email the file for the following reason. '+EmailErr(Res))
  else
  Begin

    GenStr:='The file '+GenStr+' has been sent.';


    Write_FixMsg(GenStr);
  end;

  Result:=(Res=0);
end;




Procedure TSend_VATEDI.Process;
Var
  CompressedOk  :  Boolean;
  UsePath       :  String;

  Begin
    InMainThread:=BOn;

    CompressedOk:=BOff;

    Inherited Process;

    if (WizMode = EC_SALES_EXPORT_MODE) then
      ShowStatus(0,CRepParam^.EDIHedTit+' CSV Export')
    else
      ShowStatus(0,CRepParam^.EDIHedTit+' EDI Export');

    With CRepParam^ do
    Begin
      If (SyssEDI1^.EDI1Value.VCompress) and (Not XMLMode) then {* Create intermidiate file in main directory *}
        UsePath:=SetDrive
      else
        UsePath:=SyssEDI1^.EDI1Value.VDirPath;

      With SyssEDI1^.EDI1Value do
      {$B-}
      If (XMLMode) or (Init_EDIFile(UsePath,VTestMode,WizMode)) then
      {$B+}
      Begin
        if (WizMode = EC_SALES_EXPORT_MODE) then
          Generate_VATCSV(VATStartD, VATEndD)
        else
          Generate_VATEDI_ESL(VATStartD,VATEndD,WizMode,VATChk);

        If (Not XMLMode) then
          Close_EDIFile;


        If (Not ThreadRec^.THAbort) then
        Begin
          Write_FixMsg(CCVATName^+' export completed.');

          If (VCompress) and (Not DontSendFile) then
            CompressedOk:=CompressEDIFile(VDirPath,VTestMode,VEDIMethod,VSendEmail);


          If (VSendEmail) and (VEDIMethod=2) and (Not DontSendFile) then {* We need to send it directly *}
            SendEDIEmail(CompressedOk);
        end
        else
          Write_FixMsg(CCVATName^+' export ABORTED!');

      end
      else
        Write_FixMsg(CCVATName^+' export. Export file creation failed.');

    end;

  end;


  Procedure TSend_VATEDI.Finish;
  Begin

    {$IFDEF FRM}
      If (SMemo.Count>0) then
        AddMemoRep2Thread(PDevRec,SMemo,CRepParam^.EDIHedTit+' Export',Application.MainForm);

    {$ENDIF}

    If (Not ThreadRec^.THAbort) and ((WizMode=0) or (WizMode = EC_SALES_EXPORT_MODE)) and (Assigned(ECReport)) then
      ECReport^.Update_ECSales(CRepPAram^.VATEndD);


    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

  end;




  Function TSend_VATEDI.Start  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;
    RForm  :  Str10;
    UFont  :  TFont;

    Orient :  TOrientation;


  Begin
    Result:=BOn;  UFont:=nil;


    {$IFDEF FRM}
      If (Result) then
      Begin
        UFont:=TFont.Create;

        try
          UFont.Assign(Application.MainForm.Font);


          Orient:=poPortrait;

          Set_BackThreadMVisible(BOn);

          RForm:='';

          Result:=pfSelectPrinter(PDevRec,UFont,Orient);

          Set_BackThreadMVisible(BOff);

        Finally
          UFont.Free;
          UFont:=nil;
        end;

      end;

    {$ENDIF}

    If (Result) then
    Begin
      {$IFDEF EXSQL}
      if SQLUtils.UsingSQL then
      begin
        // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
        if (not Assigned(LPostLocal)) then
          Result := Create_LocalThreadFiles;

        If (Result) then
        begin
          MTExLocal := LPostLocal;

          If (Assigned(ECReport)) then
          begin
            ECReport^.MTExLocal:=MTExLocal;
            ECReport^.IncludeGoods := IncludeGoods;
            ECReport^.IncludeServices := IncludeServices;
          end;
        end;

      end
      else
      {$ENDIF}
      begin
        If (Not Assigned(PostExLocal)) then { Open up files here }
          Result:=Create_ThreadFiles;

        If (Result) then
        Begin
          MTExLocal:=PostExLocal;

          If (Assigned(ECReport)) then
          begin
            ECReport^.MTExLocal:=MTExLocal;
            ECReport^.IncludeGoods := IncludeGoods;
            ECReport^.IncludeServices := IncludeServices;
          end;

        end;
      end;
    End;
    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}

  end;

{ ============== }

  { ========== TSend_VATXML methods =========== }


  Procedure TSend_VATXML.Write_XMLUNH(EDIRec  :  EDI1Type;
                                      VATStartD,
                                      VATEndD :  LongDate;
                                      VATChk  :  Char;
                                      VMode   :  Byte;
                                  Var NoSegs  :  LongInt;
                                  Var TmpIO   :  Integer);

  Var

    n         :  Byte;
    pm,pme    :  Word;

    UserVReg  :  Str50;

  Begin
    n:=0;  pm:=0; pme:=0;

    With EDIRec do
    Begin
      UserVReg:=RetVATRegNo(Syss.UserVATReg);

      Case VMode of
        0, EC_SALES_EXPORT_MODE
            :  Begin {* ECSL *}
                  If (CurrentCountry<>IECCode) then
                  Begin

                  end
                  else
                  If (Assigned(oECSLIrishXML)) then
                  With OECSLIrishXML do
                  Begin
                    pm:=Part_Date('M',VATStartD);

                    If (Not (pm In [1..12])) then
                      pm:=1;

                    pme:=Part_Date('M',VATEndD);

                    If (Not (pme In [1..12])) then
                      pme:=1;

                    FormVersion:='1';
                    Language:='E';
                    PeriodStart:=Copy(Today,1,4)+'0101';
                    PeriodEnd:=Copy(Today,1,4)+'1231';

                    Period:=Copy(VATStartD,7,2)+' '+Copy(MonthAry[pm],1,3)+' '+Copy(VATStartD,3,2)+' - '+Copy(VATEndD,7,2)+' '+Copy(MonthAry[pme],1,3)+' '+Copy(VATEndD,3,2);

                    If (VIEECSLP='M') then
                      ReturnType:='Monthly'
                    else
                      If (VIEECSLP='Q') then
                        ReturnType:='Quarterly'
                      else
                        If (VIEECSLP='A1') then
                          ReturnType:='Annual-A1'
                        else
                          If (VIEECSLP='A2') then
                            ReturnType:='Annual-A2'
                          else
                            ReturnType:='Unknown';

                    ThirdParty:=False;
                    Tradernumber:=VEDIFmtStr(UserVreg);
                  end; {With..}
                end;

        1,2  :  Begin {*SSD*}
                  If (CurrentCountry<>IECCode) then
                  Begin

                  end
                  else
                    If (Assigned(oIrishXML)) then
                      With OIrishXML,PSIParty do
                      Begin
                        FormVersion:='1';
                        Language:='E';
                        PeriodStart:=Copy(Today,1,4)+'0101';
                        PeriodEnd:=Copy(Today,1,4)+'1231';

                        If (VATChk=VATECDCode) then
                          Flow:='D'
                        else
                          Flow:='A';

                        StatPeriod:=Copy(VATEndD,5,2)+Copy(VATEndD,1,4);
                        //PartyType:='PSI';
                        VATNumber:=VEDIFmtStr(UserVReg);
                        Name:=VEDIFmtStr(Syss.UserName);

                        For n:=1 to 3 do
                          Address[n]:=VEDIFmtStr(Syss.DetailAddr[n]);


                        If (UserProfile^.UserName='') or (Not UserProfile^.Loaded) then
                          Contact:=VEDIFmtStr(SyssEDI2^.EDI2Value.EmName)
                        else
                          Contact:=VEDIFmtStr(UserProfile^.UserName);

                        If (UserProfile^.EmailAddr='') or (Not UserProfile^.Loaded) then
                          email:=VEDIFmtStr(SyssEDI2^.EDI2Value.EmAddress)
                        else
                          email:=VEDIFmtStr(UserProfile^.EmailAddr);

                        Phone:=VEDIFmtStr(Syss.DetailTel);

                        // MH 04/04/2012 v6.10.1 ABSEXCH-12549: Added statsValueRequired attribute
                        StatsValueRequired := FStatsValueRequired;
                      end;
                end;

      end; {Case..}
    end; {With..}


  end;

  // MH 04/04/2012 v6.10.1 ABSEXCH-12580: Added IsDespatchExport parameter for statEuroValue calculation
  Procedure TSend_VATXML.Write_XMLSSD(EDIRec  :  EDI1Type;
                                      CustR   :  CustRec;
                                      InvR    :  InvRec;
                                      IdR     :  Idetail;
                                      StockR  :  StockRec;
                                      VATChk  :  Char;
                                      SSDLNo  :  LongInt;
                                  Var NoSegs  :  LongInt;
                                  Var RepTot  :  AgedTyp;
                                  Var TmpIO   :  Integer;
                                  Const IsDespatchExport : Boolean
                                  );

  Var
    UserVReg  :  Str50;
    Rnum,
    Rnum2,
    Rnum3,
    Rnum4,
    UWeight,
    StatUpLift
              :  Double;
    LineTot   :  AgedTyp;

  Begin
    If (Assigned(oIrishXML)) then
    With EDIRec,CustR,InvR,IdR,StockR,oIrishXML do
    Begin
      UWeight:=LWeight;

      If (VATChk=VATECDCode) then
      Begin
        StatUpLift:=SSDDUpLift;

        If (UWeight=0.0) then
          UWeight:=SWeight;

      end
      else
      Begin
        StatUpLift:=SSDAUpLift;

        If (UWeight=0.0) then
          UWeight:=PWeight;

      end;

      If (IdR.SSDUseLine) then
      Begin
        StatUpLift:=IdR.SSDUpLift;

        // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
        CommodCode := Copy(IdR.SSDCommod, 1, 8);
        SuppSUnit:=IdR.SSDSPUnit;
      end
      Else
        // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
        CommodCode := Copy(CommodCode, 1, 8);

      Blank(LineTot,Sizeof(LineTot));


      Rnum:=DetLTotal(IdR,BOn,BOff,0.0)*LineCnst(Payment);  {* -ves not allowed, must use +ve only! *}
                                                                {* v2.30 Inv.OrigRates used so it is expressed in orig Co Rate *}
                                                                {v5.52. On UK Intrastat round up to nearest 1}

      Rnum2:=ForceNearestWhole(Conv_VATCurr(Rnum,VATCRate[UseCoDayRate],
                      XRate(InvR.OrigRates,BOff,InvR.Currency),InvR.Currency,InvR.UseORate),2);


      Rnum3:=ForceNearestWhole(Calc_IdQty(Qty,QtyMul,UsePack)*UWeight,2);

      Rnum4:=DivWChk((Qty*QtyMul),StockR.SuppSUnit);


      LineTot[1]:=Rnum2;
      LineTot[2]:=Rnum3;
      Linetot[3]:=Rnum4;


      LineTot[4]:=Round(LineTot[1]+(LineTot[1]*Pcnt(StatUpLift)));

      GrandAgedTotal(RepTot,LineTot);

      UserVReg:=VEDIFmtStr(Copy(CustR.VATRegNo,1,2));


      If (CurrentCountry<>IECCode) then
      Begin


      end
      else
      Begin

        try
          With NewItem do
          Begin
            CtryConsignDestn:=UserVReg;

            // Although ctryOrigin is defined as Optional it isn't actually optional:-
            //
            //   The ctryOrigin value is only required for an 'Arrival' return.
            //   This value is not required for any of the following commodity codes :
            //
            //      99500000,99302400,99302700,99309900.
            //
            //   The country code can be either 2 alpha characters (i.e. NL) or
            //   3 numerics (i.e. 007).
            //
            // On 14/04/2009 we were told that supplying the Country of Origin for Despatches
            // would cause the XML to fail the validation.  (even though we had already got a pass!)
            //
            If (VATChk<>VATECDCode) then
              If (Trim(CommodCode) <> '99500000') And (Trim(CommodCode) <> '99302400') And
                 (Trim(CommodCode) <> '99302700') And (Trim(CommodCode) <> '99309900') Then
                ctryOrigin:=SSDCountry;

            NatureofTransaction:=TransNat;
            ModeofTransport:=TransMode;
            TermsofDelivery:=VEDIFmtStr(DelTerms);

            Code:=VEDIFmtStr(CommodCode);
            NetMass:=Rnum3;
            NetMassOpt:='M';
            suCode:=VEDIFmtStr(UpCaseStr(UnitSupp));
            suQuantity:=Rnum4;
            invEuroValue:=Rnum2;

            // MH 04/04/2012 v6.10.1 ABSEXCH-12580: Added calculation for statEuroValue attribute
            // CS 06/06/2012 v6.10.1 ABSEXCH-13033: Replaced Delphi's truncating 'Round' with
            //                                      rounding to zero decimal places.
            //                                      (492.50 was being truncated to 492 instead of
            //                                       rounding up to 493 -- see JIRA).
            If IsDespatchExport Then
              statEuroValue := Round_Up(RNum2 - (RNum2 * Pcnt(StatUpLift)), 0)
            Else
              statEuroValue := Round_Up(RNum2 + (RNum2 * Pcnt(StatUpLift)), 0);

            Save;

            inc(NoSegs);
          end;
        except

        end; {try..}


      end;
    end; {With..}


  end;


  Function TSend_VATXML.Generate_VATXML_SSD(VATStartD,VATEndD  :  LongDate;
                                            VMode              :  Byte;
                                            VATChk             :  Char;
                                        Var NoSegs,
                                            SSDLNo             :  LongInt;
                                        Var RepTotals          :  AgedTyp     )  :  Boolean;


  Const
    Fnum1       =  InvF;
    Keypath1    =  InvCustK;

    Fnum2       =  IdetailF;
    Keypath2    =  IdFolioK;

  Var
    KeyS,
    KeyChk,
    KeyS2,
    KeyChk2,
    KeyCF       :  Str255;


    TmpIO       :  Integer;

    Lnum        :  LongInt;

    LineFail,
    Ok2Cont,
    TmpInclude  :  Boolean;

    //PR: 04/03/2014 ABSEXCH-15077 Function to check VAT codes for Ireland.
    function ValidVatCode(VatC : Char) : Boolean;
    var
      ThisVAT : Char;
    begin
      if (CurrentCountry = IECCode) and (VMode in [ECSSDDispatches, ECSSDArrivals]) then
      begin
        with MTExLocal.LInv do
          ThisVAT := ISVatCodes[CustSupp = 'C'];

        Result := VatC = ThisVAT;
      end
      else
        Result := VatC = VatChk;
    end;

    // CJS 2014-10-14 - ABSEXCH-15666 - Exclude services from Irish VAT XML export report
    // ValidLine() returns False if the current transaction line should not be
    // included in the export, and should not be validated any further (to
    // suppress erroneous warnings against EC Service lines).
    function ValidLine: Boolean;
    begin
      Result := True;
      // Check for EC Service lines
      if (CurrentCountry = IECCode) and (VMode in [ECSSDDispatches, ECSSDArrivals]) then
        Result := not MTExLocal.LId.ECService;
      // Check for Acquisition/Dispatch VAT codes
      if Result then
        Result := ValidVATCode(MTExLocal.LId.VATCode);
    end;

    //PR: 04/03/2014 ABSEXCH-15077 Added function to direct include invoice call to appropriate function
    function IncludeECInv(InvR : InvRec; VATStartD, VATEndD : LongDate) : Boolean;
    begin
      if (CurrentCountry = IECCode) and (VMode in [ECSSDDispatches, ECSSDArrivals]) then
        Result := fDataSearch.IntraInvInclude(InvR,VATStartD,VATEndD, VMode = ECSSDArrivals)
      else
      begin
        if Assigned(ECReport) then
          Result :=  ECReport^.IncludeECInv(InvR,VATStartD,VATEndD)
        else
          Result := False;
      end;
    end;





  Begin

    Lnum:=0; Ok2Cont:=BOn;  TmpInclude:=BOff; LineFail:=BOff; TmpIO:=0;

    If (Assigned(oIrishXML)) then
    With MTExLocal^,LCust,oIrishXML do
    Begin
      KeyChk:=FullCustType(CustCode,CustSupp);

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum1,KeyPath1,KeyS);

      While (LStatusOk) and (Checkkey(KeyChk,KeyS,Length(KeyChk),BOn))  and (Not ThreadRec^.THAbort)  do
      With LInv do
      Begin


        {$B-}
                                               //PR: 04/03/2014 ABSEXCH-15077
        If (Not (SSDProcess In ['P','T'])) and IncludeECInv(LInv,VATStartD,VATEndD) then

        {$B+}

        Begin
          ShowStatus(2,'Calculating '+OurRef);


          KeyChk2:=FullNomKey(FolioNum);

          KeyS2:=FullIdKey(FolioNum,1);

          LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeyS2);


          While (LStatusOk) and (Checkkey(KeyChk2,KeyS2,Length(KeyChk2),BOn))  and (Not ThreadRec^.THAbort)  do
          With LId do
          Begin
            //PR: 04/03/2014 Change to use ValidVatCode function
            // CJS 2014-10-14 - ABSEXCH-15666 - Exclude services from Irish VAT XML export report
            // Replaced ValidVATCode() call with ValidLine() call
            If (ValidLine and (LineNo>0) and Is_FullStkCode(StockCode) and (Qty>0)) then
            Begin
              If (StockCode<>LStock.StockCode) then
                TmpInclude:=LGetMainRecPos(StockF,StockCode)
              Else
                TmpInclude := True;  // MH 12/05/2009: Added because TmpInclude was remaining false for a second run through with 1 stock item

              LineFail:=BOff;

              If (TmpInclude) then
              With LStock do
              Begin
                If (SSDUseLine) then
                Begin
                  // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                  CommodCode:=Copy(LId.SSDCommod, 1, 8);
                end
                Else
                  // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                  CommodCode:=Copy(CommodCode, 1, 8);


                If (CommodCode='') or (Length(Strip('A',[#32],VEDIFmtStr(CommodCode)))<>8) then
                Begin
                  Write_FixMsg('The commodity code '+CommodCode+' for '+Strip('R',[#32],StockCode)+' on '+OurRef+' is not valid.');
                  LineFail:=BOn;
                end;

                If (Not ValidDelTerms(DelTerms)) then
                Begin
                  Write_FixMsg('The Delivery terms for '+OurRef+' are not valid.');
                  LineFail:=BOn;
                end;

                If (Not ValidNatTran(TransNat)) then
                Begin
                  Write_FixMsg('The Nature of Transaction for '+OurRef+' is not valid.');
                  LineFail:=BOn;
                end;

                If (TransMode=0) then
                Begin
                  Write_FixMsg('The Transport Mode for '+OurRef+' is not valid.');
                  LineFail:=BOn;
                end;

                {* Only if being sent as SEMDEC, check unit supp, as INSTAT hard codes ICN *}

                If (UnitSupp<>'') and (Length(UnitSupp)>3) and
                ((CurrentCountry=IECCode)) then
                Begin
                  Write_FixMsg('The SSD Unit Description for '+Strip('R',[#32],StockCode)+' on '+OurRef+
                               ' can only be 3 chars long.');

                  Write_FixMsg('This entry will be included in the file.');
                end;


                TmpInclude:=(Not LineFail);
              end;

              If (TmpInclude) then
              Begin

                If (NewExport) then
                Begin
                  NewExport:=BOff;

                end;

                {* Send SSD Line *}
                Inc(SSDLNo);

                // MH 04/04/2012 v6.10.1 ABSEXCH-12580: Added IsDespatchExport parameter required for statEuroValue calculation
                Write_XMLSSD(SyssEDI1^.EDI1Value,LCust,LInv,LId,LStock,VATChk,SSDLNo,NoSegs,RepTotals,TmpIO, VMode = 1);

              end
              else
                CouldHave:=(Not TmpInclude) or (CouldHave);
            end;

            LStatus:=LFind_Rec(B_GetNext,Fnum2,KeyPath2,KeyS2);


          end; {Loop..}

        end;{If In Range }


        LStatus:=LFind_Rec(B_GetNext,Fnum1,KeyPath1,KeyS);

      end; {Inv Loop..}

    end; {With Cust Check Loop..}

    Generate_VATXML_SSD:=Not ThreadRec^.THAbort;
  end; {Proc..}



  Function TSend_VATXML.Generate_VATEDI_ESL(VATStartD,VATEndD  :  LongDate;
                                            VMode              :  Byte;
                                            VATChk             :  Char)  :  Boolean;

  Const
    Fnum      =  CustF;
    Keypath   =  CustCntyK;

    //PR: 20/02/2014 ABSEXCH-15042 Constants for EC Totals
    iGoods = 1;
    iTri = 2;
    iServices = 3;


  Var
    n         :  Byte;

    XMLFName,
    KeyChk,
    KeyS      :  Str255;

    PartyError,
    AbortPrint,
    TmpInclude : Boolean;

    //PR: 20/02/2014 ABSEXCH-15042 Changed Loop variable from Boolean to Byte
    Loop      :  Byte;
    ECTotals  : Array[iGoods..iServices] of Double;

    Ok2Cont   :  Boolean;

    ThisEC,
    ThisECTri :  Double;

    //PR: 20/02/2014 ABSEXCH-15042 For new var parameter to Scan_4ECSales function - returns service total for transaction
    ThisService : Double;


    TMPIO     :  Integer;

    NOSegs,
    ESLLNo    :  LongInt;

    RepTotals :  AgedTyp;

    //PR: 03/03/2014 ABSEXCH-15077
    AcType,
    bStart, bEnd : Boolean;


  Begin
    Result := False;
    TMPIO:=0; NOSegs:=0; ESLLNo:=0;  NewExport:=BOn;

//    Loop:=BOff;

    XMLFName:='';  n:=0;

    TmpInclude:=BOn;  PartyError:=BOff;

    Blank(RepTotals,Sizeof(RepTotals));

    //PR: 03/03/2014 ABSEXCH-15077 In order to include PCRs in arrivals and SCRs in dispatches,
    //                             we need to go through customers/suppliers. Ireland only.
    if (CurrentCountry <> IECCode) or (not VMode in [ECSSDDispatches, ECSSDArrivals]) then
    begin
      //Suppliers or Customers depending on mode
      bStart := VMode <> 2;
      bEnd := bStart;
    end
    else
    begin
      //Ireland - Suppliers and Customers
      bStart := False;
      bEnd := True;
    end;

    for AcType := bStart to bEnd do
    If (Assigned(oIrishXML)) then
    With MTExLocal^ do
    Begin
      KeyChk:=TradeCode[AcType];
      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      AbortPrint:=Not LStatusOk;

      Ok2Cont:=(Not ThreadRec^.THAbort);

      //PR: 04/03/2014 ABSEXCH-15077 This section should only be included once, at the start of the output file
      if AcType = bStart then
      begin
        Write_XMLUNH(SyssEDI1^.EDI1Value,VATStartD,VATEndD,VATChk,VMode,NoSegs,TMPIO);


        If (TmpInclude) and (Assigned(oIrishXML)) and ((VMode<>0) and (VMode <> EC_SALES_EXPORT_MODE)) then
        With oIrishXML.PSIParty do
        Begin
          TmpInclude:=(Name<>'');

          If (Not TmpInclude) then
            Write_FixMsg('Your Company Name is not set in System Setup. Please correct and regenerate this file.');

          For n:=1 to 2 do
            If (Address[n]='') and (TmpInclude) then
            Begin
              Write_FixMsg('At least the first two lines of your Company address must be set in System Setup. Please correct and regenerate this file.');

              TmpInclude:=BOff;
            end;


          If (Contact='') or (Email='') or (Phone='') then
          Begin
            Write_FixMsg('Your Contact Name, Telephone Number and Email Address must be set in System Setup. Please correct and regenerate this file.');

            TmpInclude:=BOff;
          end;

          If (VATNumber='') then
          Begin
            Write_FixMsg('Your VAT Registration No. must be set in VAT Setup. Please correct and regenerate this file.');

            TmpInclude:=BOff;
          end;

          If (Arrivals > 1) Or (Dispatch > 1) Then
          Begin
            Write_FixMsg('Your Arrivals/Dispatch settings are invalid (' + IntToStr(Arrivals) + '/' + IntToStr(Dispatch) + '). Please correct and regenerate this file.');

            TmpInclude:=BOff;
          end;
        end;

        If (TmpInclude) and (Assigned(oECSLIrishXML)) and ((VMode=0) or (VMode = EC_SALES_EXPORT_MODE)) then
        With oECSLIrishXML do
        Begin
          If (TraderNumber='') then
          Begin
            Write_FixMsg('Your VAT Registration No. must be set in VAT Setup. Please correct and regenerate this file.');

            TmpInclude:=BOff;
          end;
        end;

        PartyError:=Not TmpInclude;
      end; //if bStart

      While (Not AbortPrint) and (Ok2Cont) and (Checkkey(KeyChk,KeyS,Length(KeyChk),BOn)) and (TMPIO=0) do
      With LCust do
      Begin

        Ok2Cont:=(Not ThreadRec^.THAbort);

        TmpInclude:=((EECMember) and (CustSupp=TradeCode[AcType])) and (Ok2Cont);

        If (TmpInclude) then
        Begin
          ShowStatus(1,'Processing '+dbFormatName(CustCode,Company));


          TmpInclude:=(VATRegNo[1] In ['A'..'Z']) and (VATRegNo[2] In ['A'..'Z']);


          If (Not TmpInclude) then
            Write_FixMsg('The country code is missing from the '+CCVATName^+' Reg No. for '+dbFormatName(CustCode,Company))
          else
          Begin
            TmpInclude:=(Length(Trim(VATRegNo))<=19) and (Length(Trim(VATRegNo))>2);

            If (Not TmpInclude) then
              Write_FixMsg('The '+CCVATName^+' Reg No. for '+dbFormatName(CustCode,Company)+' is not valid.');

          end;



          CouldHave:=(Not TmpInclude) or (CouldHave);
        end;

        Case VMode of

          0, EC_SALES_EXPORT_MODE
            :  If (TmpInclude) and (Assigned(oECSLIrishXML)) then
                Begin


                  If (TmpInclude)  and (Assigned(ECReport)) then
                  Begin
                    //PR: 20/02/2014 ABSEXCH-15042 Added new var parameter to Scan_4ECSales function
                    ECTotals[iGoods] := ECReport^.Scan_4ECSales(CustCode,CustSupp,VATStartD,VATEndD,ECTotals[iTri], ECTotals[iServices]);

                    TmpInclude:=(ECTotals[iGoods] + ECTotals[iTri] + ECTotals[iServices] <> 0.0);

                  end;

                  If (TmpInclude) then
                  Begin
                    //PR: 20/02/2014 ABSEXCH-15042 Need to loop through 3 times to include Services
                    for Loop := iGoods to iServices do
                    begin
                      If ECTotals[Loop] <> 0.0 then
                      Begin

                        {* Perform a send *}
                        Inc(ESLLNo);

                        If (NewExport) then
                        Begin
                          NewExport:=BOff;

                        end;

                        If (CurrentCountry=IECCode) then
                        With oECSLIrishXML do
                        Begin
                        try
                          With NewItem do
                          Begin
                            CustomerNumber:=VEDIFmtStr(LCust.VATRegNo);
                            Triang   := Loop = iTri;
                            Services := Loop = iServices;
                            
                            {SS 29/06/2016 2016-R3
                          	ABSEXCH-15667:XML VIES statement - whilst going through the XML reports and comparing to printed statement rounding issue found.
                            Replace Round_Up with Trunc to keep amount in sync with the  printed statement.}
                            ValSupplies:=Trunc(ECTotals[Loop]);

                            Save;

                            inc(NoSegs);
                          end;
                        except

                        end; {try..}


                        end {With..}
                        else
                        Begin


                        end;

                        {* Keep running total *}

                        RepTotals[1]:=RepTotals[1]+ECTotals[Loop];

                        If (TMPIO=0) then
                        Begin
                          NoSegs:=NoSegs+4;

                          If (CurrentCountry=IECCode) and (Loop <> iTri) then
                            NoSegs:=NoSegs-1;
                        end;
                      end; {If send value}

                    end; //for loop


                  end;

                end;
        ECSSDDispatches,
        ECSSDArrivals
          :  If (TmpInclude) then
                Begin

                  Ok2Cont:=Generate_VATXML_SSD(VATStartD,VATEndD,VMode,VATChk,NoSegs,ESLLno,RepTotals);


                end;

        end; {Case..}



        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        AbortPrint:=Not LStatusOk;
      end; {While..}

      TmpInclude:=(Ok2Cont and (Not PartyError));

      //PR: 04/03/2014 ABSEXCH-15077 This section should only be included once, at the end of the output file
      If (TmpInclude) and (AcType = bEnd) then
      Begin
        Case VMode of
          0, EC_SALES_EXPORT_MODE
            :    XMLFName:=SyssEDI1^.EDI1Value.VDirPath+'\E'+Copy(VATEndD,1,6)+'.xml'

          else    If (Assigned(oIrishXML)) then
                    XMLFName:=SyssEDI1^.EDI1Value.VDirPath+'\'+oIrishXML.Flow+Copy(VATEndD,1,6)+'.xml'
                  else
                    XMLFName:='Error.xml';

        end; {Case..}

        If (ESLLno=0) then
        Begin
          If (Not CouldHave) then
          Begin

            {* Terminate as Nil Return *}

            If (VMode<>99) then
            Begin
              Write_FixMsg(CCVATName^+' export. No records found to export, so a nil return has been created.');
              Write_FixMsg('Although no records were found the file '+XMLFName+' should still be sent so a nil return can be filed.');

              Case VMode of
                0, EC_SALES_EXPORT_MODE  :  ;
                else  OIrishXML.ReturnType:=0;
              end; {Case..}

            end
            else
            Begin
              Write_FixMsg(CCVATName^+' export. No records were found to export. DO NOT SEND THE FILE!');
              DontSendFile:=BOn;
            end;
          end
          else
          Begin
            Write_FixMsg(CCVATName^+' export. No records found to export.');
            Write_FixMsg('However, there were errors in the data, which when corrected may');
            Write_FixMsg('provide enough data for a valid submission. Please correct and try again.');

            Case VMode of
                0, EC_SALES_EXPORT_MODE  :  ;
                else  OIrishXML.ReturnType:=0;
            end; {Case..}

          end;

        end
        else

        Begin
          Write_FixMsg('A total of '+Form_Int(ESLLNo,0)+' records have been placed in the XML file '+XMLFName);
          Write_FixMsg('Please send this file as soon as possible.');


          Case VMode of
            0, EC_SALES_EXPORT_MODE  :  ;
            else  OIrishXML.ReturnType:=1;
          end; {Case..}

        end;


        If (Not DontSendFile) then
        try
         Case VMode of
           0, EC_SALES_EXPORT_MODE
             :  With oECSLIrishXML do
                 Begin

                   Repeat
                     TmpIO:=SaveToFile(XMLFName);

                     If (TmpIO=1) then
                       SysUtils.DeleteFile(XMLFName);

                   Until (TmpIO =0) or (TmpIO=-1);

                   If (TmpIO<>0) then
                     Write_FixMsg('(An error ' + IntToStr(TmpIO) + ': ' + QuotedStr(oECSLIrishXML.LastError) + ' was returned whilst trying to save the XML File '+XMLFName);
                 end; {with..}

           1,2
              :  With oIrishXML do
                 Begin

                   Repeat
                     TmpIO:=SaveToFile(XMLFName);

                     If (TmpIO=1) then
                       SysUtils.DeleteFile(XMLFName);

                   Until (TmpIO =0) or (TmpIO=-1);

                   If (TmpIO<>0) then
                     Write_FixMsg('(An error ' + IntToStr(TmpIO) + ': ' + QuotedStr(oIrishXML.LastError) + ' was returned whilst trying to save the XML File '+XMLFName);
                 end; {with..}
         end; {Case..}

         except
           Write_FixMsg('An exception was generated trying to create the XML file.');

         end; {try..}

        Inc(NoSegs);  {* Allow for UNT Segment *}

      end;

      Generate_VATEDI_ESL:=TmpInclude;
    end; {With..}

  end;


  Constructor TSend_VATXML.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    XMLMode:=BOn;

    Try
      oIrishXML:=NewIrisXMLIntrastatIntf;
    except
      oIrishXML:=Nil;
    end; {try..}


    Try
      oECSLIrishXML:=NewIrisXMLVIESIntf;
    except
      oECSLIrishXML:=Nil;
    end; {try..}

    // MH 04/04/2012 v6.10.1 ABSEXCH-12554: Added Statistical Value Required field
    FStatsValueRequired := False;
  end;


  Destructor TSend_VATXML.Destroy;

  Begin

    oIrishXML:=Nil; {* Free object by default *}

    oECSLIrishXML:=Nil;

    Inherited Destroy;
  end;

{ ============== }


Procedure AddVATEDI2Thread(AOwner    :  TObject;
                           VMode     :  Byte;
                           VRepParam :   CVATRepPtr;
                           Filename  :  string;
                           IncludeGoods: Boolean;
                           IncludeServices: Boolean);



  Var
    LCheck_Batch :  ^TSend_VATEDI;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Batch,Create(AOwner));

      try
        LCheck_Batch^.IncludeGoods    := IncludeGoods;
        LCheck_Batch^.IncludeServices := IncludeServices;
        LCheck_Batch^.CSVFile         := Filename;
        With LCheck_Batch^ do
        Begin
          CRepParam^:=VRepParam^;
          WizMode:=VMode;

          If (Start) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LCheck_Batch,CCVATName^+' EDI');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Batch,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Batch,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


  // MH 04/04/2012 v6.10.1 ABSEXCH-12554: Added support for Statistical Value Required flag
  Procedure AddVATXML2Thread(AOwner    :  TObject;
                             VMode     :  Byte;
                             VRepParam :   CVATRepPtr;
                             Const StatsValueReqd : Boolean
                             );



  Var
    LCheck_Batch :  ^TSend_VATXML;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Batch,Create(AOwner));

      try
        With LCheck_Batch^ do
        Begin
          CRepParam^:=VRepParam^;
          WizMode:=VMode;

          // MH 04/04/2012 v6.10.1 ABSEXCH-12554: Added Statistical Value Required field
          StatsValueRequired := StatsValueReqd;

          If (Start) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LCheck_Batch,CCVATName^+' XML');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Batch,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Batch,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


end.
