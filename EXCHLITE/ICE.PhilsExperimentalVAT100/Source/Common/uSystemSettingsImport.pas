unit uSystemSettingsImport;

interface

uses
  SysUtils,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  MSXML2_TLB,
  uBaseClass,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uImportBaseClass;

{$I ice.inc}

type
  TSystemSettingsImport = class(_ImportBase)
  protected
    procedure AddRecord(pNode: IXMLDOMNode); override;
  public
    function SaveListToDB: Boolean; override;
  end;

implementation

// ===========================================================================
// TSystemSettingsImport
// ===========================================================================

procedure TSystemSettingsImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. There is only one
  actual record in the System Settings file. }

  function GetCharValue(Node: IXMLDOMNode; NodeName: string): Char;
  var
    TempStr: string;
  begin
    TempStr := _GetNodeValue(Node, NodeName);
    if (Trim(TempStr) <> '') then
      Result := TempStr[1]
    else
      Result := ' ';
  end;

var
  FuncRes: LongInt;
  Key: ShortString;
  ErrorCode: Integer;
  SubNode: IXMLDOMNode;
  i: Integer;
begin
  ErrorCode := 0;

  { Get the identifier for the main System Settings record (the System Settings
    table holds multiple types of information -- the identifier allows the
    program to locate the correct record for specific information). }
  Key := SysNames[SYSR];

  SetDrive := DataPath;

  Clear;

  { Open the System Settings table... }
  FuncRes := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  if (FuncRes = 0) then
  begin

    { ...and find the main System Settings record. }
    FuncRes := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key);

    if (FuncRes = 0) then
    with Syss do
    begin
      { Read the System Settings details from the XML node. }
      PrinYr         := _GetNodeValue(pNode, 'ssperiodsinyear');
      UserName       := _GetNodeValue(pNode, 'sscompanyname');
      AuditYr        := _GetNodeValue(pNode, 'sslastaudityr');
      ManROCP        := _GetNodeValue(pNode, 'ssmanupdreordercost');
      VATCurr        := _GetNodeValue(pNode, 'ssvatreturncurrency');
      NoCosDec       := _GetNodeValue(pNode, 'sscostdecimals');
      ShowStkGP      := _GetNodeValue(pNode, 'ssshowstkpriceasmargin');
      AutoValStk     := _GetNodeValue(pNode, 'sslivestockcosval');
      DelPickOnly    := _GetNodeValue(pNode, 'sssdnshowpickedonly');
      UseMLoc        := _GetNodeValue(pNode, 'ssuselocations');
      EditSinSer     := _GetNodeValue(pNode, 'sssetbomserno');
      WarnYRef       := _GetNodeValue(pNode, 'sswarndupliyourref');
      UseLocDel      := _GetNodeValue(pNode, 'ssuselocdeladdress');
      PostCCNom      := _GetNodeValue(pNode, 'ssbudgetbyccdept');
      AlTolVal       := _GetNodeValue(pNode, 'sscurrencytolerance');
      AlTolMode      := _GetNodeValue(pNode, 'sscurrencytolerancemode');
      DebtLMode      := _GetNodeValue(pNode, 'ssdebtchasemode');
      AutoGenVar     := _GetNodeValue(pNode, 'ssautogenvariance');
      AutoGenDisc    := _GetNodeValue(pNode, 'ssautogendisc');
      USRCntryCode   := _GetNodeValue(pNode, 'sscompanycountrycode');
      NoNetDec       := _GetNodeValue(pNode, 'sssalesdecimals');
      WksODue        := _GetNodeValue(pNode, 'ssdebtchaseoverdue');
      CPr            := _GetNodeValue(pNode, 'sscurrentperiod');
      CYr            := _GetNodeValue(pNode, 'sscurrentyear');
      TradeTerm      := _GetNodeValue(pNode, 'sstradeterm');
      StaSepCr       := _GetNodeValue(pNode, 'ssseparatecurrencystatements');
      StaAgeMthd     := _GetNodeValue(pNode, 'ssstatementagingmethod');
      StaUIDate      := _GetNodeValue(pNode, 'ssstatementuseinvoicedate');
      QUAllocFlg     := _GetNodeValue(pNode, 'ssquotesallocatestock');
      DeadBOM        := _GetNodeValue(pNode, 'ssdeductbomcomponents');
      AuthMode       := GetCharValue(pNode,  'ssauthorisationmethod');
      IntraStat      := _GetNodeValue(pNode, 'ssuseintrastat');
      AnalStkDesc    := _GetNodeValue(pNode, 'ssanalysedesconly');
      AutoStkVal     := GetCharValue(pNode,  'ssdefaultstockvalmethod');
      AutoBillUp     := _GetNodeValue(pNode, 'ssdisplayupdatecosts');
      AutoCQNo       := _GetNodeValue(pNode, 'ssautochequeno');
      IncNotDue      := _GetNodeValue(pNode, 'ssstatementincnotdue');
      UseBatchTot    := _GetNodeValue(pNode, 'ssforcebatchtotalbalancing');
      UseStock       := _GetNodeValue(pNode, 'ssdisplaystocklevelwarning');
      AutoNotes      := _GetNodeValue(pNode, 'ssstatementnoteentry');
      HideMenuOpt    := _GetNodeValue(pNode, 'sshidemenuopt');
      UseCCDep       := _GetNodeValue(pNode, 'ssuseccdept');
      NoHoldDisc     := _GetNodeValue(pNode, 'ssholdsettlementdisctransactions');
      AutoPrCalc     := _GetNodeValue(pNode, 'sssettransperiodbydate');
      StopBadDr      := _GetNodeValue(pNode, 'ssstopovercreditlimit');
      UsePayIn       := _GetNodeValue(pNode, 'ssusesrcpayinref');
      UsePasswords   := _GetNodeValue(pNode, 'ssusepasswords');
      PrintReciept   := _GetNodeValue(pNode, 'ssprompttoprintreciept');
      ExternCust     := _GetNodeValue(pNode, 'ssexternalcustomers');
      NoQtyDec       := _GetNodeValue(pNode, 'ssqtydecimals');
      ExternSIN      := _GetNodeValue(pNode, 'ssexternalsinentry');
      PrevPrOff      := _GetNodeValue(pNode, 'ssdisablepostingtopreviousperiods');
      DefPcDisc      := _GetNodeValue(pNode, 'sspercdiscounts');
      TradCodeNum    := _GetNodeValue(pNode, 'ssnumericaccountcodes');
      UpBalOnPost    := _GetNodeValue(pNode, 'ssupdatebalanceonposting');
      ShowInvDisc    := _GetNodeValue(pNode, 'ssshowinvoicedisc');
      SepDiscounts   := _GetNodeValue(pNode, 'sssplitdiscountsingl');
      UseCreditChk   := _GetNodeValue(pNode, 'ssdocreditstatuscheck');
      UseCRLimitChk  := _GetNodeValue(pNode, 'ssdocreditlimitcheck');
      AutoClearPay   := _GetNodeValue(pNode, 'ssautoclearpayments');
      TotalConv      := GetCharValue(pNode,  'sscurrencyratetype');
      DispPrAsMonths := _GetNodeValue(pNode, 'ssshowperiodsasmonths');
      DirectCust     := _GetNodeValue(pNode, 'ssdirectcustomer');
      DirectSupp     := _GetNodeValue(pNode, 'ssdirectsupplier');
      SettleDisc     := _GetNodeValue(pNode, 'sssettlementdiscount');
      SettleDays     := _GetNodeValue(pNode, 'sssettlementdays');
      NeedBMUp       := _GetNodeValue(pNode, 'ssneedbomcostingupdate');
      InpPack        := _GetNodeValue(pNode, 'ssinputpackqtyonline');
      VATCode        := GetCharValue(pNode,  'ssdefaultvatcode');
      PayTerms       := _GetNodeValue(pNode, 'sspaymentterms');
      StaAgeInt      := _GetNodeValue(pNode, 'ssstatementageinginterval');
      QuoOwnDate     := _GetNodeValue(pNode, 'sskeepquotedate');
      FreeExAll      := _GetNodeValue(pNode, 'ssfreestockexcludessor');
      DirOwnCount    := _GetNodeValue(pNode, 'ssseparatedirecttranscounter');
      StaShowOS      := _GetNodeValue(pNode, 'ssstatementshowmatchedinmonth');
      LiveCredS      := _GetNodeValue(pNode, 'ssliveoldestdebt');
      BatchPPY       := _GetNodeValue(pNode, 'ssbatchppy');
      DefBanknom     := _GetNodeValue(pNode, 'ssdefaultbankgl');
      UseDefBank     := _GetNodeValue(pNode, 'ssusedefaultbankaccount');
      MonWk1         := _GetNodeValue(pNode, 'ssyearstartdate');
//      AuditDate      := _GetNodeValue(pNode, 'sslastauditdate');
      UserSort       := _GetNodeValue(pNode, 'ssbanksortcode');
      UserAcc        := _GetNodeValue(pNode, 'ssbankaccountno');
      UserRef        := _GetNodeValue(pNode, 'ssbankaccountref');
      UserBank       := _GetNodeValue(pNode, 'ssbankname');
      DetailTel      := _GetNodeValue(pNode, 'sscompanyphone');
      DetailFax      := _GetNodeValue(pNode, 'sscompanyfax');
      UserVATReg     := _GetNodeValue(pNode, 'sscompanyvatregno');

      SubNode := _GetChildNodeByName(pNode, 'sscompanyaddress');
      for i := 0 to SubNode.childNodes.length - 1 do
      begin
        if ((i + 1) <= High(DetailAddr)) then
          DetailAddr[i + 1] := SubNode.childNodes[i].text
        else
          break;
      end;

      SubNode := _GetChildNodeByName(pNode, 'ssdebtchasedays');
      for i := 0 to SubNode.childNodes.length - 1 do
      begin
        if ((i + 1) <= High(DebTrig)) then
          DebTrig[i + 1] := StrToIntDef(SubNode.childNodes[i].text, 0)
        else
          break;
      end;

      SubNode := _GetChildNodeByName(pNode, 'sstermsoftrade');
      for i := 0 to SubNode.childNodes.length - 1 do
      begin
        if ((i + 1) <= High(TermsOfTrade)) then
          TermsOfTrade[i + 1] := SubNode.childNodes[i].text
        else
          break;
      end;

      UsePick4All    := _GetNodeValue(pNode, 'sspickingorderallocatesstock');
      TxLateCR       := _GetNodeValue(pNode, 'ssusedoskeys');
      HideExLogo     := _GetNodeValue(pNode, 'sshideenterpriselogo');
      ConsvMem       := _GetNodeValue(pNode, 'ssconservememory');
      ProtectYRef    := _GetNodeValue(pNode, 'ssprotectyourref');
      SDNOwnDate     := _GetNodeValue(pNode, 'sssdndateistaxpointdate');
      UseUpliftNC    := _GetNodeValue(pNode, 'ssautopostuplift');
      UseWIss4All    := _GetNodeValue(pNode, 'sswopdisablewip');
      UseSTDWOP      := _GetNodeValue(pNode, 'ssworallocstockonpick');
      WOPStkCopMode  := _GetNodeValue(pNode, 'ssworcopystknotes');
      FiltSNoBinLoc  := _GetNodeValue(pNode, 'ssfilterbybinlocation');
      KeepBinHist    := _GetNodeValue(pNode, 'sskeepbinhistory');
      BinMask        := _GetNodeValue(pNode, 'ssbinmask');
      PostCCNom      := _GetNodeValue(pNode, 'sspostccnom');
      PostCCDCombo   := _GetNodeValue(pNode, 'sspostccdcombo');
      StaUIDate      := _GetNodeValue(pNode, 'ssstauidate');
      PurchUIDate    := _GetNodeValue(pNode, 'sspurchuidate');
//      BKThemeNo      := _GetNodeValue(pNode, 'ssbkthemeno');
      DefSRCBankNom  := _GetNodeValue(pNode, 'ssdefsrcbanknom');
      DupliVSec      := _GetNodeValue(pNode, 'ssduplivsec');
      SepRunPost     := _GetNodeValue(pNode, 'ssseprunpost');
      ShowQtySTree   := _GetNodeValue(pNode, 'ssshowqtystree');
//      UseBKTheme     := _GetNodeValue(pNode, 'ssusebktheme');
      UseGLClass     := _GetNodeValue(pNode, 'ssuseglclass');
      WarnJC         := _GetNodeValue(pNode, 'sswarnjc');
    end
    else
      ErrorCode := cEXCHLOADINGVALUEERROR;

  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TSystemSettingsImport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));


end;

// ---------------------------------------------------------------------------

function TSystemSettingsImport.SaveListToDB: Boolean;
var
  FuncRes: LongInt;
begin
  Result := True;
  { Write the System Settings details back to the database. }
  FuncRes := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TSystemSettingsImport.WriteDetails', cUPDATINGDBERROR, 'Error: ' + IntToStr(FuncRes));
    Result := False;
  end;
  FuncRes := Close_File(F[SysF]);
  if ((FuncRes <> 0) and (FuncRes <> 3)) then
  begin
    DoLogMessage('TSystemSettingsImport.WriteDetails: error closing file',
                 cCONNECTINGDBERROR, 'Error: ' + IntToStr(FuncRes));
    Result := False;
  end;
end;

// ---------------------------------------------------------------------------

end.
