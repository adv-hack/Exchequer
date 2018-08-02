unit uSystemSettingsExport;

interface

uses
  Classes, SysUtils, ComObj, Controls, Variants,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uExportBaseClass
  ;

{$I ice.inc}

type
  TSystemSettingsExport = class(_ExportBase)
  protected
    function BuildXmlRecord(pSys: Pointer): Boolean; override;
  public
    function LoadFromDB: Boolean; override;
  end;

implementation

uses
  uEXCHBaseClass,
  BtKeys1U;

{ TSystemSettingsExport }

function TSystemSettingsExport.BuildXmlRecord(pSys: Pointer): Boolean;
var
  RootNode: IXMLDomNode;
  MessageNode, RecNode, SubNode: IXMLDomNode;
  i: Integer;
const
  AS_CDATA: Boolean = True;
begin
  Result := False;

  { The supplied pointer should be a pointer to a System Settings record
    structure. }
  with SysRec(pSys^) do
  begin

    { Create an XML Document handler, and load the template XML file -- the
      correct XML file spec should already have been assigned to the XMLFile
      property by the calling routine. }
    CreateXMLDoc;

    RootNode := ActiveXMLDoc.Doc.documentElement;

    if (RootNode <> nil) then
    try
      MessageNode := _GetNodeByName(RootNode,    'message');
      RecNode     := _GetNodeByName(MessageNode, 'sysrec');

      { Add the details. }

      _SetNodeValueByName(RecNode, 'ssperiodsinyear',                   PrinYr);
      _SetNodeValueByName(RecNode, 'sscompanyname',                     UserName);
      _SetNodeValueByName(RecNode, 'sslastaudityr',                     AuditYr);
      _SetNodeValueByName(RecNode, 'ssmanupdreordercost',               ManROCP);
      _SetNodeValueByName(RecNode, 'ssvatreturncurrency',               VATCurr);
      _SetNodeValueByName(RecNode, 'sscostdecimals',                    NoCosDec);
      _SetNodeValueByName(RecNode, 'ssshowstkpriceasmargin',            ShowStkGP);
      _SetNodeValueByName(RecNode, 'sslivestockcosval',                 AutoValStk);
      _SetNodeValueByName(RecNode, 'sssdnshowpickedonly',               DelPickOnly);
      _SetNodeValueByName(RecNode, 'ssuselocations',                    UseMLoc);
      _SetNodeValueByName(RecNode, 'sssetbomserno',                     EditSinSer);
      _SetNodeValueByName(RecNode, 'sswarndupliyourref',                WarnYRef);
      _SetNodeValueByName(RecNode, 'ssuselocdeladdress',                UseLocDel);
      _SetNodeValueByName(RecNode, 'ssbudgetbyccdept',                  PostCCNom);
      _SetNodeValueByName(RecNode, 'sscurrencytolerance',               AlTolVal);
      _SetNodeValueByName(RecNode, 'sscurrencytolerancemode',           AlTolMode);
      _SetNodeValueByName(RecNode, 'ssdebtchasemode',                   DebtLMode);
      _SetNodeValueByName(RecNode, 'ssautogenvariance',                 AutoGenVar);
      _SetNodeValueByName(RecNode, 'ssautogendisc',                     AutoGenDisc);
      _SetNodeValueByName(RecNode, 'sscompanycountrycode',              USRCntryCode);
      _SetNodeValueByName(RecNode, 'sssalesdecimals',                   NoNetDec);
      _SetNodeValueByName(RecNode, 'ssdebtchaseoverdue',                WksODue);
      _SetNodeValueByName(RecNode, 'sscurrentperiod',                   CPr);
      _SetNodeValueByName(RecNode, 'sscurrentyear',                     CYr);
      _SetNodeValueByName(RecNode, 'sstradeterm',                       TradeTerm);
      _SetNodeValueByName(RecNode, 'ssseparatecurrencystatements',      StaSepCr);
      _SetNodeValueByName(RecNode, 'ssstatementagingmethod',            StaAgeMthd);
      _SetNodeValueByName(RecNode, 'ssstatementuseinvoicedate',         StaUIDate);
      _SetNodeValueByName(RecNode, 'ssquotesallocatestock',             QUAllocFlg);
      _SetNodeValueByName(RecNode, 'ssdeductbomcomponents',             DeadBOM);
      _SetNodeValueByName(RecNode, 'ssauthorisationmethod',             AuthMode);
      _SetNodeValueByName(RecNode, 'ssuseintrastat',                    IntraStat);
      _SetNodeValueByName(RecNode, 'ssanalysedesconly',                 AnalStkDesc);
      _SetNodeValueByName(RecNode, 'ssdefaultstockvalmethod',           AutoStkVal);
      _SetNodeValueByName(RecNode, 'ssdisplayupdatecosts',              AutoBillUp);
      _SetNodeValueByName(RecNode, 'ssautochequeno',                    AutoCQNo);
      _SetNodeValueByName(RecNode, 'ssstatementincnotdue',              IncNotDue);
      _SetNodeValueByName(RecNode, 'ssforcebatchtotalbalancing',        UseBatchTot);
      _SetNodeValueByName(RecNode, 'ssdisplaystocklevelwarning',        UseStock);
      _SetNodeValueByName(RecNode, 'ssstatementnoteentry',              AutoNotes);
      _SetNodeValueByName(RecNode, 'sshidemenuopt',                     HideMenuOpt);
      _SetNodeValueByName(RecNode, 'ssuseccdept',                       UseCCDep);
      _SetNodeValueByName(RecNode, 'ssholdsettlementdisctransactions',  NoHoldDisc);
      _SetNodeValueByName(RecNode, 'sssettransperiodbydate',            AutoPrCalc);
      _SetNodeValueByName(RecNode, 'ssstopovercreditlimit',             StopBadDr);
      _SetNodeValueByName(RecNode, 'ssusesrcpayinref',                  UsePayIn);
      _SetNodeValueByName(RecNode, 'ssusepasswords',                    UsePasswords);
      _SetNodeValueByName(RecNode, 'ssprompttoprintreciept',            PrintReciept);
      _SetNodeValueByName(RecNode, 'ssexternalcustomers',               ExternCust);
      _SetNodeValueByName(RecNode, 'ssqtydecimals',                     NoQtyDec);
      _SetNodeValueByName(RecNode, 'ssexternalsinentry',                ExternSIN);
      _SetNodeValueByName(RecNode, 'ssdisablepostingtopreviousperiods', False);
//      _SetNodeValueByName(RecNode, 'ssdisablepostingtopreviousperiods', PrevPrOff);
      _SetNodeValueByName(RecNode, 'sspercdiscounts',                   DefPcDisc);
      _SetNodeValueByName(RecNode, 'ssnumericaccountcodes',             TradCodeNum);
      _SetNodeValueByName(RecNode, 'ssupdatebalanceonposting',          UpBalOnPost);
      _SetNodeValueByName(RecNode, 'ssshowinvoicedisc',                 ShowInvDisc);
      _SetNodeValueByName(RecNode, 'sssplitdiscountsingl',              SepDiscounts);
      _SetNodeValueByName(RecNode, 'ssdocreditstatuscheck',             UseCreditChk);
      _SetNodeValueByName(RecNode, 'ssdocreditlimitcheck',              UseCRLimitChk);
      _SetNodeValueByName(RecNode, 'ssautoclearpayments',               AutoClearPay);
      _SetNodeValueByName(RecNode, 'sscurrencyratetype',                TotalConv);
      _SetNodeValueByName(RecNode, 'ssshowperiodsasmonths',             DispPrAsMonths);
      _SetNodeValueByName(RecNode, 'ssdirectcustomer',                  DirectCust);
      _SetNodeValueByName(RecNode, 'ssdirectsupplier',                  DirectSupp);
      _SetNodeValueByName(RecNode, 'sssettlementdiscount',              SettleDisc);
      _SetNodeValueByName(RecNode, 'sssettlementdays',                  SettleDays);
      _SetNodeValueByName(RecNode, 'ssneedbomcostingupdate',            NeedBMUp);
      _SetNodeValueByName(RecNode, 'ssinputpackqtyonline',              InpPack);
      _SetNodeValueByName(RecNode, 'ssdefaultvatcode',                  VATCode);
      _SetNodeValueByName(RecNode, 'sspaymentterms',                    PayTerms);
      _SetNodeValueByName(RecNode, 'ssstatementageinginterval',         StaAgeInt);
      _SetNodeValueByName(RecNode, 'sskeepquotedate',                   QuoOwnDate);
      _SetNodeValueByName(RecNode, 'ssfreestockexcludessor',            FreeExAll);
      _SetNodeValueByName(RecNode, 'ssseparatedirecttranscounter',      DirOwnCount);
      _SetNodeValueByName(RecNode, 'ssstatementshowmatchedinmonth',     StaShowOS);
      _SetNodeValueByName(RecNode, 'ssliveoldestdebt',                  LiveCredS);
      _SetNodeValueByName(RecNode, 'ssbatchppy',                        BatchPPY);
      _SetNodeValueByName(RecNode, 'ssdefaultbankgl',                   DefBanknom);
      _SetNodeValueByName(RecNode, 'ssusedefaultbankaccount',           UseDefBank);
      _SetNodeValueByName(RecNode, 'ssyearstartdate',                   MonWk1);
      _SetNodeValueByName(RecNode, 'sslastauditdate',                   AuditDate);
      _SetNodeValueByName(RecNode, 'ssbanksortcode',                    UserSort);
      _SetNodeValueByName(RecNode, 'ssbankaccountno',                   UserAcc);
      _SetNodeValueByName(RecNode, 'ssbankaccountref',                  UserRef);
      _SetNodeValueByName(RecNode, 'ssbankname',                        UserBank);
      _SetNodeValueByName(RecNode, 'sscompanyphone',                    DetailTel);
      _SetNodeValueByName(RecNode, 'sscompanyfax',                      DetailFax);
      _SetNodeValueByName(RecNode, 'sscompanyvatregno',                 UserVATReg);

      SubNode := _GetChildNodeByName(RecNode, 'sscompanyaddress');
      SubNode.removeChild(_GetChildNodeByName(SubNode, 'sscompanyaddressline'));
      for i := Low(DetailAddr) to High(DetailAddr) do
      begin
        _AddLeafNode(SubNode, 'sscompanyaddressline', DetailAddr[i], AS_CDATA);
      end;

      SubNode := _GetChildNodeByName(RecNode, 'ssdebtchasedays');
      SubNode.removeChild(_GetChildNodeByName(SubNode, 'ssdebtchaseday'));
      for i := Low(DebTrig) to High(DebTrig) do
      begin
        _AddLeafNode(SubNode, 'ssdebtchaseday', DebTrig[i]);
      end;

      SubNode := _GetChildNodeByName(RecNode, 'sstermsoftrade');
      SubNode.removeChild(_GetChildNodeByName(SubNode, 'sstermoftrade'));
      for i := Low(TermsOfTrade) to High(TermsOfTrade) do
      begin
        _AddLeafNode(SubNode, 'sstermoftrade', TermsOfTrade[i], AS_CDATA);
      end;

      _SetNodeValueByName(RecNode, 'sspickingorderallocatesstock',      UsePick4All);
      _SetNodeValueByName(RecNode, 'ssusedoskeys',                      TxLateCR);
      _SetNodeValueByName(RecNode, 'sshideenterpriselogo',              HideExLogo);
      _SetNodeValueByName(RecNode, 'ssconservememory',                  ConsvMem);
      _SetNodeValueByName(RecNode, 'ssprotectyourref',                  ProtectYRef);
      _SetNodeValueByName(RecNode, 'sssdndateistaxpointdate',           SDNOwnDate);
      _SetNodeValueByName(RecNode, 'ssautopostuplift',                  UseUpliftNC);
      _SetNodeValueByName(RecNode, 'sswopdisablewip',                   UseWIss4All);
      _SetNodeValueByName(RecNode, 'ssworallocstockonpick',             UseSTDWOP);
      _SetNodeValueByName(RecNode, 'ssworcopystknotes',                 WOPStkCopMode);
      _SetNodeValueByName(RecNode, 'ssfilterbybinlocation',             FiltSNoBinLoc);
      _SetNodeValueByName(RecNode, 'sskeepbinhistory',                  KeepBinHist);
      _SetNodeValueByName(RecNode, 'ssbinmask',                         BinMask);
      _SetNodeValueByName(RecNode, 'sspostccnom',                       PostCCNom);
      _SetNodeValueByName(RecNode, 'sspostccdcombo',                    PostCCDCombo);
      _SetNodeValueByName(RecNode, 'ssstauidate',                       StaUIDate);
      _SetNodeValueByName(RecNode, 'sspurchuidate',                     PurchUIDate);
//      _SetNodeValueByName(RecNode, 'ssbkthemeno',                       BKThemeNo);
      _SetNodeValueByName(RecNode, 'ssdefsrcbanknom',                   DefSRCBankNom);
      _SetNodeValueByName(RecNode, 'ssduplivsec',                       DupliVSec);
      _SetNodeValueByName(RecNode, 'ssseprunpost',                      SepRunPost);
      _SetNodeValueByName(RecNode, 'ssshowqtystree',                    ShowQtySTree);
//      _SetNodeValueByName(RecNode, 'ssusebktheme',                      UseBKTheme);
      _SetNodeValueByName(RecNode, 'ssuseglclass',                      UseGLClass);
      _SetNodeValueByName(RecNode, 'sswarnjc',                          WarnJC);

      Result := True;

      ActiveXMLDoc.Load(StringReplace(ActiveXMLDoc.Doc.xml, #9#13#10, '', [rfReplaceAll]));
      ActiveXMLDoc.RemoveComments;

      { Add the resulting XML to the list (in this instance, there will only
        be one XML entry in the list). }
      List.Add(ActiveXMLDoc);

    except
      on E: Exception do
        DoLogMessage('TSystemSettingsExport.BuildXmlRecord', cBUILDINGXMLERROR, 'Error: ' +
          E.message);
    end
    else
      DoLogMessage('TSystemSettingsExport.BuildXmlRecord', cINVALIDXMLNODE);
  end;
end;

function TSystemSettingsExport.LoadFromDB: Boolean;
var
  FuncRes: LongInt;
  Key: ShortString;
  ErrorCode: Integer;
  SyssPtr: ^SysRec;
begin
  Result := False;
  ErrorCode := 0;

  { Get the identifier for the main record (the System Settings tables holds
    multiple types of information -- the identifier allows the program to
    locate the correct record for specific information). }
  Key := SysNames[SYSR];

  SetDrive := DataPath;

  Clear;

  { Open the System Settings table... }
  FuncRes := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  if (FuncRes = 0) then
  begin

    { ...and find the main System Settings record. }
    FuncRes := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key);
    Result := (FuncRes = 0);

    if (Result) then
    begin
      { ...and build the required XML record from the VAT details. }
      SyssPtr := @Syss;
      BuildXMLRecord(SyssPtr);
    end
    else
      ErrorCode := cEXCHLOADINGVALUEERROR;

    FuncRes := Close_File(F[SysF]);
  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TSystemSettingsExport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));

end;

end.
