unit InvListU;

{$UNDEF TRADEALTSB}
{$IFNDEF TRADE}
  {$IFDEF EBAD}
    {$DEFINE TRADEALTSB}
  {$ENDIF}
{$ENDIF}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ExtCtrls,Forms,
  Globvar,VARRec2U,VarConst,SBSComp,SupListU,

  //PR: 24/09/2013 MRD 1.1.15/16/16
  ConsumerUtils, PopUpSearchForm;

const
  HIDE_CONSUMERS = True;

  // MH 13/05/2014: Extended GetNom to support suppressing Inactive GL Codes
  SUPPRESS_INACTIVE_GLCODES = True;

type

  TCustList  =  Class(TGenList)
  private
    //PR: 24/09/2013 MRD 1.1.15/16 Add consumer mode to specify if consumers are included and how the code is displayed
    //                             Declared in ConsumerUtils.pas: TConsumerMode = (cmDontShow, cmShowShortCode, cmShowLongCode);
  public
    FConsumerMode : TConsumerMode;
    Function SetCheckKey  :  Str255; Override;

    Function StkMatchWCard(CustR   :  CustRec)  :  Char;

    Function SetFilter  :  Str255; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Function SetColCaption  :  Str255; Override;

    property ConsumerMode : TConsumerMode read FConsumerMode write FConsumerMode;
  end;




  TCustFind  =  Object

    MULCtrlO    :  TCustlist;

    //PR: 04/10/2013 MRD 1.1.17 Change to use new tabbed pop-up list
    PopUpList   :  TACPopUpList;
    AdvanceFind :  Boolean;

    Destructor Destroy;

    //PR: 24/09/2013 Added WantConsumers param MRD 1.1.15/16
    Constructor Create(AOwner   :  TComponent;
                       Fnum,
                       SKeyPath :  Integer;
                       Key2F    :  Str255;
                       LenSCode :  Integer;
                       XMode    :  Integer;
                       UseWC    :  Boolean;
                       KeyW     :  Str255;
                       CFilters :  FilterType;
                       WantConsumers : Boolean);


  end;




{Function GetCust(AOWner :  TComponent;
                 Want   :  Str20;
             Var Found  :  Str20;
                 IsCust :  Boolean;
                 Mode   :  Integer)  :  Boolean;}

Function GetCust(AOWner :  TComponent;
                 Want   :  Str20;
             Var Found  :  Str20;
                 IsCust :  Boolean;
                 Mode   :  Integer;
                 iIndexNo : Integer = -1;
                 HideConsumers
                          : Boolean = False)  :  Boolean;

{ ----------------------}

type

  TNomList  =  Class(TGenList)

    Function SetCheckKey  :  Str255; Override;

    Function Check_NCCodes(NCode  :  LongInt;
                           AllowDr:  Boolean)   :   Boolean;

    Function StkMatchWCard(NomR  :  NominalREc)  :  Char;

    Function SetFilter  :  Str255; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;

  TNomFind  =  Object

    MULCtrlO    :  TNomlist;
    PopUpList   :  TPopUpList;
    AdvanceFind :  Boolean;

    Destructor Destroy;

    Constructor Create(AOwner   :  TComponent;
                       Fnum,
                       SKeyPath :  Integer;
                       Key2F    :  Str255;
                       KLen     :  Integer;
                       NoUpCheck:  Boolean;
                       XMode    :  Integer;
                       UseWC    :  Boolean;
                       KeyW     :  Str255;
                       CFilters :  FilterType);


  end;



Function GetNom(AOWner :  TComponent;
                Want   :  Str20;
            Var Found  :  LongInt;
                Mode   :  Integer;
            Const SuppressInactive : Boolean = False)  :  Boolean;



{ ----------------------}

{$IFDEF PF_On}

  type

    TCCList  =  Class(TGenList)

      Function SetCheckKey  :  Str255; Override;

      Function StkMatchWCard(PasswordR  :  PassWordRec)  :  Char;

      Function SetFilter  :  Str255; Override;

      Function OutLine(Col  :  Byte)  :  Str255; Override;

    end;


    TCCFind  =  Object

      MULCtrlO    :  TCClist;
      PopUpList   :  TPopUpList;
      AdvanceFind :  Boolean;

      Destructor Destroy;

      Constructor Create(AOwner   :  TComponent;
                         Fnum,
                         SKeyPath :  Integer;
                         Key2F    :  Str255;
                         KLen     :  Integer;
                         XMode    :  Integer;
                         UseWC    :  Boolean;
                         KeyW     :  Str255;
                         CFilters :  FilterType);


    end;



  Function GetCCDep(AOWner :  TComponent;
                    Want   :  Str20;
                Var Found  :  Str20;
                    CCorDep:  Boolean;
                    Mode   :  Integer)  :  Boolean;


    { ----------------------}

  type

    TJobList  =  Class(TGenList)

      Function SetCheckKey  :  Str255; Override;

      Function StkMatchWCard(JobR  :  JobRecType)  :  Char;

      Function SetFilter  :  Str255; Override;

      Function OutLine(Col  :  Byte)  :  Str255; Override;

    end;

    TJobFind  =  Object

      MULCtrlO    :  TJoblist;
      PopUpList   :  TPopUpList;
      AdvanceFind :  Boolean;

      Destructor Destroy;

      Constructor Create(AOwner   :  TComponent;
                         Fnum,
                         SKeyPath :  Integer;
                         Key2F    :  Str255;
                         KLen     :  Integer;
                         XMode    :  Integer;
                         UseWC    :  Boolean;
                         KeyW     :  Str255;
                         CFilters :  FilterType);


    end;



  Function GetJob(AOWner :  TComponent;
                  Want   :  Str20;
              Var Found  :  Str20;
                  Mode   :  Integer)  :  Boolean;


    { ----------------------}

  type

    TJAnalList  =  Class(TGenList)

    Public
      DAMode    :  Integer;

      Function SetCheckKey  :  Str255; Override;

      Function StkMatchWCard(JobMiscR  :  JobMiscRec)  :  Char;

      Function SetFilter  :  Str255; Override;

      Function OutLine(Col  :  Byte)  :  Str255; Override;

    end;

    TJAnalFind  =  Object

    Public
      MULCtrlO    :  TJAnallist;
      PopUpList   :  TPopUpList;
      AdvanceFind :  Boolean;

      Destructor Destroy;

      Constructor Create(AOwner   :  TComponent;
                         Fnum,
                         SKeyPath :  Integer;
                         Key2F    :  Str255;
                         KLen     :  Integer;
                         XMode    :  Integer;
                         UseWC    :  Boolean;
                         KeyW     :  Str255;
                         CFilters :  FilterType);


    end;



  Function GetJobMisc(AOWner :  TComponent;
                      Want   :  Str20;
                  Var Found  :  Str20;
                      JAMode,
                      Mode   :  Integer)  :  Boolean;


  { ----------------------}

{$IFDEF JC}

  type

    TJEmpRList  =  Class(TGenList)

    Public
      DAMode    :  Integer;

      Function SetCheckKey  :  Str255; Override;

      Function StkMatchWCard(JobCtrlR  :  JobCtrlRec)  :  Char;

      Function SetFilter  :  Str255; Override;

      Function OutLine(Col  :  Byte)  :  Str255; Override;

    end;

    TJEmpRFind  =  Object

    Public
      MULCtrlO    :  TJEmpRlist;
      PopUpList   :  TPopUpList;
      AdvanceFind :  Boolean;

      Destructor Destroy;

      Constructor Create(AOwner   :  TComponent;
                         Fnum,
                         SKeyPath :  Integer;
                         Key2F    :  Str255;
                         KLen     :  Integer;
                         XMode    :  Integer;
                         UseWC    :  Boolean;
                         KeyW     :  Str255;
                         CFilters :  FilterType);


    end;



  Function GetEmpRate(AOWner :  TComponent;
                      Want   :  Str50;
                  Var Found  :  Str20;
                      GMode,
                      LMode  :  Integer)  :  Boolean;


  { ----------------------}

{$ENDIF}

  type

    TUserList  =  Class(TGenList)

      Function SetCheckKey  :  Str255; Override;

      Function SetFilter  :  Str255; Override;

      Function OutLine(Col  :  Byte)  :  Str255; Override;

    end;

    TUserFind  =  Object

      MULCtrlO    :  TUserlist;
      PopUpList   :  TPopUpList;
      AdvanceFind :  Boolean;

      Destructor Destroy;

      Constructor Create(AOwner   :  TComponent;
                         Fnum,
                         SKeyPath :  Integer;
                         Key2F    :  Str255;
                         KLen     :  Integer;
                         XMode    :  Integer;
                         UseWC    :  Boolean;
                         KeyW     :  Str255;
                         CFilters :  FilterType);


    end;



  Function GetUser(AOWner :  TComponent;
                  Want   :  Str20;
              Var Found  :  Str20;
                  Mode   :  Integer)  :  Boolean;



{$ENDIF}

{$IFDEF STK}

  { ----------------------}

  type

    TStockList  =  Class(TGenList)

      Function SetCheckKey  :  Str255; Override;

      Function StkMatchWCard(StockR  :  StockRec)  :  Char;

      Function SetFilter  :  Str255; Override;

      Function OutStkLine(Col  :  Byte)  :  Str255;

      {$IFDEF SOP}
        {$IFNDEF EDLL}
          {$IFNDEF OLE}
            {$IFNDEF RW}
             {$IFNDEF WCA}
             {$IFNDEF ENDV}
              {$IFNDEF XO}
              {$IFNDEF TRADEALTSB}
                Function OutAltLine(Col  :  Byte)  :  Str255;
              {$ENDIF}
              {$ENDIF}
              {$ENDIF}
             {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}

      Function OutLine(Col  :  Byte)  :  Str255; Override;

      Function SetColCaption  :  Str255; Override;


    end;

    TStockFind  =  Object

      MULCtrlO    :  TStocklist;
      PopUpList   :  TPopUpList;
      AdvanceFind :  Boolean;

      Destructor Destroy;

      Constructor Create(AOwner   :  TComponent;
                         Fnum,
                         SKeyPath :  Integer;
                         Key2F    :  Str255;
                         KLen     :  Integer;
                         XMode    :  Integer;
                         UseWC    :  Boolean;
                         KeyW,
                         KeyF     :  Str255;
                         CFilters :  FilterType);


    end;


  Function GetsdbStock(AOWner   :  TComponent;
                       Want     :  Str20;
                       SuppFilt :  Str10;
                   Var Found    :  Str20;
                   Var sdbStkL  :  LongInt;
                       Mode     :  Integer;
                       iIndexNo : Integer = -1)  :  Boolean;


{  Function GetStock(AOWner :  TComponent;
                    Want   :  Str20;
                Var Found  :  Str20;
                    Mode   :  Integer)  :  Boolean;}

  Function GetStock(AOWner :  TComponent;
                    Want   :  Str20;
                Var Found  :  Str20;
                    Mode   :  Integer;
                    iIndexNo : Integer = -1)  :  Boolean;

  {$IFNDEF OLE}
    {.$IFDEF SOP}

      type

        TMLFList  =  Class(TGenList)

        Public

          ThisStkCode :  Str20;

          Function SetCheckKey  :  Str255; Override;

          Function StkMatchWCard(MLocR :  MLocRec)  :  Char;

          Function SetFilter  :  Str255; Override;

          Function OutSLLine(Col  :  Byte)  :  Str255;

          Function OutLine(Col  :  Byte)  :  Str255; Override;

        end;


        TMLFFind  =  Object

          MULCtrlO    :  TMLFlist;
          PopUpList   :  TPopUpList;
          AdvanceFind :  Boolean;

          Destructor Destroy;

          Constructor Create(AOwner   :  TComponent;
                             Fnum,
                             SKeyPath :  Integer;
                             Key2F    :  Str255;
                             KLen     :  Integer;
                             XMode    :  Integer;
                             UseWC    :  Boolean;
                             KeyW     :  Str255;
                             SCode    :  Str20;
                             CFilters :  FilterType);


        end;


        Function GetMLoc(AOWner :  TComponent;
                     Want   :  Str10;
                 Var Found  :  Str10;
                     SCode  :  Str20;
                     Mode   :  Integer)  :  Boolean;


    {.$ENDIF}
  {$ENDIF}

{$ENDIF}

{$IFDEF EXDLL}
  Procedure Set_BackThreadMVisible(Param1 : Boolean);
{$ENDIF}

{$IFDEF EBAD}
  Procedure Set_BackThreadMVisible(Param1 : Boolean);
{$ENDIF}


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  EtMiscU,
  SBSPanel,
  BtrvU2,
  BtSupU1,
  ComnU2,

  {$IFNDEF OLE}
    {$IFDEF STK}
      SysU2,
    {$ENDIF}

    {$IFDEF SOPDLL}
      InvLst3U,
    {$ENDIF}

    {$IFDEF SOP}
      {$IFNDEF EDLL}
        {$IFNDEF RW}
        {$IFNDEF EBAD}
        InvLst3U,

        { IFNDEF RW}
          {$IFNDEF WCA}
          {$IFNDEF ENDV}
          {$IFNDEF XO}
            AltCLstU,
            SalTxl1U,
          {$ENDIF}
          {$ENDIF}
         {$ENDIF}
        {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}

    {$IFDEF JC}
      JobSup1U,
      VarJCstU,
    {$ENDIF}

  {$ENDIF}
  {$IFNDEF EDLL}
    {$IFNDEF EXDLL}
    {$IFNDEF OLE}
    {$IFNDEF EBAD}
    ExThrd2U,
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFNDEF EXDLL}
  DebugU,
  {$ENDIF}

  BtKeys1U;


{$IFDEF EDLL}
  Procedure Set_BackThreadMVisible(Param1 : Boolean);
  Begin
    { Dummy function used by form designer dll }
  End;
{$ENDIF}
{$IFDEF EXDLL}
  Procedure Set_BackThreadMVisible(Param1 : Boolean);
  Begin
    { Dummy function used by form designer dll }
  End;
{$ENDIF}
{$IFDEF OLE}
  Procedure Set_BackThreadMVisible(Param1 : Boolean);
  Begin
    { Dummy function used by OLE Server to get it to compile }
  End;
{$ENDIF}
{$IFDEF EBAD}
  Procedure Set_BackThreadMVisible(Param1 : Boolean);
  Begin
    { Dummy function used by form designer dll }
  End;
{$ENDIF}




{ ============ TCustList Methods ================= }



Function TCustList.SetCheckKey  :  Str255;


Var
  DumStr  :  Str255;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  Case Keypath of

    CustCodeK  :  DumStr:=Cust.CustCode;

    CustCompK  :  DumStr:=Cust.Company;

    CustCntyK  :  DumStr:=Cust.CustSupp + Cust.VATRegNo + Cust.CustCode; {NF : 19/9/00}

    CustTelK   :  DumStr:=Cust.Phone;

    CustAltK   :  DumStr:=Cust.CustCode2;

    ATCodeK    :  With Cust do
                    DumStr:=CustSupp+CustCode;

    ATCompK    :  With Cust do
                    DumStr:=CustSupp+Company;

    ATAltK     :  With Cust do
                    DumStr:=CustSupp+CustCode2;

    CustPCodeK :  DumStr:=Cust.PostCode;
    CustRCodeK :  DumStr:=Cust.RefNo;
    CustInvToK :  DumStr:=Cust.SOPInvCode;
    
    CustEmailK :  With Cust do
                    DumStr:=CustSupp+EmailAddr;

  end;

  SetCheckKey:=DumStr;
end;



{ ====== Function to Match Stock based on wild card ===== }

Function TCustList.StkMatchWCard(CustR   :  CustRec)  :  Char;

Var
  TmpBo,
  FOk    :  Boolean;
  TChr   :  Char;
  TMode  :  Byte;
  WildMatch
         :  Str255;

Begin

  TmpBO:=BOff;
  TMode:=0;

  Blank(WildMatch,Sizeof(WildMatch));

  FOk:=(Not UseWildCard);

  If (Not FOk) then
  With CustR do
  Begin

    TMode:=(1*Ord(KeyWildM[1]=#32))+(2*Ord(KeyWildM[1]='/'))+(3*Ord(KeyWildM[1]=WildChQ))+(4*Ord(KeyWildM[1]=WildCha));

    If (TMode>0) then
    Begin
      If (Length(KeyWildM)>1) then
        WildMatch:=Strip('L',[WildCha],Copy(KeyWildM,2,Pred(Length(KeyWildM))))
      else
        FOk:=BOn;


    end
    else
      WildMatch:=KeyWildM;

    If (WildMatch<>'') or (TMode=0) then
    Case TMode of

      0,1
         :  FOk:=(Match_Glob(Sizeof(CustCode),WildMatch,CustCode,TmpBo));
      2  :  FOk:=(Match_Glob(Sizeof(Company),WildMatch,Company,TmpBo));
      3  :  FOk:=(Match_Glob(Sizeof(CustCode2),WildMatch,CustCode2,TmpBo));
      4  :  FOk:=(Match_Glob(Sizeof(CustR),WildMatch,CustR,TmpBo));

      else  FOk:=BOff;


    end; {Case..}



  end; {With..}

  If (FOk) then
  With CustR do
  Begin
    If (AccStatus>=AccClose) and (Filter[1+Ord(UseWildCard),1]='1') then {* Exclude closed acounts *}
      TCHr:='1'
    else
      TChr:=CustR.CustSupp;
  end
  else
    TChr:=NdxWeight;

  StkMatchWCard:=TChr;

end;

Function TCustList.SetFilter  :  Str255;

Begin

  Case ScanFileNum of
    CustF  :  SetFilter:=StkMatchWCard(Cust);

  end; {Case..}

end;



{ ========== Generic Function to Return Formatted Display for List ======= }

Function TCustList.OutLine(Col  :  Byte)  :  Str255;

Begin
   With Cust do
     Case Col of
       0  :  OutLine:=CustCode;
       1  :  Case SCCount of
               0      :  OutLine:=Company;
               1      :  OutLine:=CustCode2;
               2..6   :  OutLine:=Addr[Pred(SCCount)];
               7      :  OutLine:=PostCode;

               8      :  Begin
                           Result:=Phone;

                           If (Result<>'') then
                             Result:=Result+' / ';

                           Result:=Result+Fax;

                           If (Result<>'') then
                             Result:=Result+' / ';

                           Result:=Result+Phone2;
                         end;

               9      :  OutLine:=Contact;
             end;
     end; {Case..}
end;


Function TCustList.SetColCaption  :  Str255;

Begin
  Case SCCount of
    0  :  Result:='Name';
    1  :  Result:='Alt Code';
    2..6
       :  Result:='Address';
    7  :  Result:='Post Code';
    8  :  Result:='Tel/Fax/Mbl';
    9  :  Result:='Contact Name';
  end; {Case..}
end;

{ ============ TCust Find Methods ================= }



Destructor TCustFind.Destroy;

Begin

  MULCtrlO.Destroy;

  If (PopUpList<>Nil) then
    PopUpList.Free;

end;

Constructor TCustFind.Create(AOwner   :  TComponent;
                             Fnum,
                             SKeyPath :  Integer;
                             Key2F    :  Str255;
                             LenSCode :  Integer;
                             XMode    :  Integer;
                             UseWC    :  Boolean;
                             KeyW     :  Str255;
                             CFilters :  FilterType;
                             WantConsumers
                                      : Boolean);

Begin

  PopUpList:=Nil;
  AdvanceFind:=BOff;

  MULCtrlO:=TCustList.Create(AOwner);

  Try
    With MULCtrlO do
    Begin
      Filter:=CFilters;

      UseWildCard:=UseWC;
      KeyWildM:=KeyW;

      //PR: 24/01/2013 Start list on appropriate consumer or cust/supp key. (Xmode = -1 means an exact match so search on short a/c code.)
      if WantConsumers and (XMode <> -1) and (XMode <> 99) then
        StartList(Fnum,SKeyPath,Key2F,'',FullSubTypeLongAcCodeKey(CONSUMER_CHAR, Key2F),LenSCode,BOn)
      else
        StartList(Fnum,SKeyPath,Key2F,'',FullCustCode(Key2F),LenSCode,BOn);

      AdvanceFind:=GetCode(XMode);

      //Ensure we haven't found a consumer if we're not allowing them - this shouldn't happen but can't hurt to check
      if AdvanceFind and not WantConsumers and (XMode = -1) then
        AdvanceFind := Cust.acSubType <> CONSUMER_CHAR;

    end;

    If (Not AdvanceFind) and (XMode<>-1) then
    Begin
      MULCtrlO.Destroy;

      PopUpList:=TACPopUpList.Create(AOwner);
      Try

        MULCtrlO:=TCustList.Create(PopUpList);

        With MULCtrlO do
        Begin
          UseWildCard:=UseWC;
          KeyWildM:=KeyW;

          HasScroll:=BOn;
          SCMax:=9;


        end;

        PopUpList.CreateOwnList(MULCtrlO,Fnum,SKeypath,Key2F,LenSCode,0,CFilters);


      except

        PopUpList.Free;
        PopUpList:=Nil;

      end;

    end; {IF Advance find ok..}

  Except

     MULCtrlO.Free;
     MULCtrlO:=Nil;
  end;

end; {Proc..}


{ ================ Function to Find an approximate match via list =========== }


Function GetCust(AOWner :  TComponent;
                 Want   :  Str20;
             Var Found  :  Str20;
                 IsCust :  Boolean;
                 Mode   :  Integer;
                 iIndexNo : Integer = -1;
                 HideConsumers
                          : Boolean = False)  :  Boolean;
{Function GetCust(AOWner :  TComponent;
                 Want   :  Str20;
             Var Found  :  Str20;
                 IsCust :  Boolean;
                 Mode   :  Integer)  :  Boolean;}

Var
  CustFind  :  ^TCustFind;
  LenSCode  :  Byte;

  PrevHState,
  NumFlg,
  UseWildCard,
  UseAltK
            :  Boolean;

  SKeyPath  :  Integer;

  KeyWildM  :  Str255;

  CustFilters
            :  FilterType;

  WantConsumers : Boolean; //PR: 20/09/2013 MRD 1.1.15/16

  function SetConsumerMode : TConsumerMode;
  begin
    Result := cmDontShow;
    if Syss.ssConsumersEnabled then
    begin
      if (Mode = 99) and not HideConsumers then
        Result := cmShowShortCode
      else
      if WantConsumers and not HideConsumers then
        Result := cmShowLongCode;
    end;
  end;

Begin
(*  Case Mode of
    0, 3  : if IsCust then
            begin
              if (Length(Want) > 0) and (Want[1] = CONSUMER_PREFIX) then
                ShowMessage('Try exact match first. If not match then Customer/Consumer List - default to Consumer tab')
              else
                ShowMessage('Try exact match first. If not match then Customer/Consumer List - default to Customer tab')
            end
            else
              ShowMessage('Supplier List');

    99    : ShowMessage('Customer/Consumer/Suppliers in same list');

    -1    : ShowMessage('Exact match - don''t show list');

  end; *)


  //PR: 03/10/2013 MRD 1.1.15/6 We want to look for an exact short code match before showing a list. Do it here before we check for consumers.
  if Mode <> -1 then
  begin
    Result := GetCust(AOwner, Want, Found, IsCust, -1, iIndexNo, HideConsumers);

    //Ensure we have a customer/consumer or a supplier as required unless looking for both (mode = 99)
    Result := Result and ((Mode = 99) or (IsCust xor (Cust.CustSupp = SUPPLIER_CHAR))) ;

    //if we've got an exact match then return, otherwise carry on with the rest of the routine.
    if Result then
      Exit;
  end;

  UseWildCard:=BOff;

  SKeyPath:=CustCodeK;

  Blank(CustFilters,Sizeof(CustFilters));

  LenSCode:=Length(Want);

  //PR: 20/09/2013 MRD 1.1.15/16 If the first character of the search string is the consumer prefix then we are looking for consumers. However,
  //                          if Mode = -1 then we're looking for an exact match on the short a/c code.
  WantConsumers := False;
  if (LenSCode > 0) and Syss.ssConsumersEnabled and (IsCust or (Mode = -1)) and not HideConsumers then
  begin
    if (Want[1] = CONSUMER_PREFIX) then
    begin  //If exact match needed then check for short consumer code but don't change Index or shorten code.
      if (Mode = -1) then
        WantConsumers := True
      else
      if (Mode <> 99) then
      begin
         WantConsumers := True;
         Delete(Want, 1, 1); //Remove underscore from string
         SKeyPath := CustLongACCodeK; //Change index to one using sub-type
      end;
    end;
  end;

  //EINum returns true if the code passed in ends in a number. If it doesn't, and numeric trader codes is turned on,
  //then we search on the trader name rather than code.
  If (Syss.TradCodeNum) then
    NumFlg:=EINum(Want)
  else
    NumFlg:=BOff;

  If (Mode<>-1) then
  Begin
    If (LenSCode>0) then
      UseWildCard:=((Want[1]=WildCha) and (Mode<>-1));


    If (UseWildCard) then
    Begin
      CustFilters[1,1]:=NdxWeight;
      KeyWildM:=Want;
      Blank(Want,Sizeof(Want));
    end;

    If (Mode<>99) then
    Begin
      CustFilters[1,0]:=TradeCode[IsCust];

      If (Mode=3) then
        CustFilters[1+Ord(UseWildCard),1]:='1'; {* Exclude Accounts on hold *}
    end;
  end;

  UseAltK:=((CustFilters[1,0]=TradeCode[BOff]) or (CustFilters[1,0]=TradeCode[BOn])) and (Mode<>-1);

  //PR: 20/09/2013 MRD 1.1.15/16 If we're going for consumers then set filter appropriately
  if UseAltK and WantConsumers then
    CustFilters[1, 0] := CONSUMER_CHAR;

  If (LenSCode>0) then
  Begin

    If (UseWildCard) then
      Want:=Copy(Want,2,Pred(LenScode));

    //PR: 20/09/2013 MRD 1.1.15/16 Change all indexes that need a prefix to use the SubType field rather than CustSupp
    If ((Want[1]=DescTrig) or ((Not NumFlg) and (Syss.TradCodeNum))) and (Mode<>-1) then
    Begin
      //Search on trader name 
      If (UseAltK) or WantConsumers then
        SKeyPath:={ATCompK} CustNameK
      else
        SKeyPath:=CustCompK;

      If (Not UseWildCard) and (Want[1]=DescTrig) then
        Want:=Copy(Want,2,Pred(LenScode));
    end
    else
    If (Want[1]=WildChQ) and (Mode<>-1) then
    Begin
      //Search on AltCode
      If (UseAltK) or WantConsumers then
        SKeyPath:={ATAltK} CustAltCodeK
      else
        SKeyPath:=CustAltK;

      If (Not UseWildCard) and (Want[1]=WildCHQ) then
        Want:=Copy(Want,2,Pred(LenScode));
    end
    else  //PR: 18/11/2013 MRD 1.1.15 Add postcode option
    if (Want[1] = PostCodeTrig) and (Mode <> -1) then
    begin
      //set index - doesn't include CustSupp or acSubType so UseAltK should be false
      SKeyPath := CustPCodeK;
      UseAltK := False;

      If (Not UseWildCard) and (Want[1]=PostCodeTrig) then
        Want:=Copy(Want,2,Pred(LenScode));
    end
    else
    If (UseAltK)  and (Mode<>-1) then
    begin
      //Search on a/c code
      if WantConsumers then
        SKeyPath := CustLongACCodeK
      else
        SKeyPath:={ATCodeK} CustACCodeK;
    end;


  end
  else
  If (UseAltK) then
  begin
    //Search on Subtype + a/c code
    if WantConsumers and (Mode <> -1) then
      SKeyPath := CustLongACCodeK
    else
      SKeyPath:={ATCodeK} CustACCodeK;
  end;


  If (UseAltK) then
    Want:=CustFilters[1,0]+Want;

  LenSCode:=Length(Want);

  {$IFDEF TRADE}
    if (iIndexNo = -1) or (iIndexNo = 0) then New(CustFind,Create(AOwner,CustF,SKeyPath,Want,LenSCode,Mode
    ,UseWildCard,KeyWildM,CustFilters, WantConsumers))
    else begin
      if (Mode = 0) and (iIndexNo in [1, 3, 4, 8, 9, 10]) then begin
        {remove 'C' or 'S' prefix from "Want"}
        Want := Copy(Want,2,255);
        LenSCode := Length(Want);
      end;{if}
      New(CustFind,Create(AOwner,CustF,iIndexNo,Want,LenSCode,Mode,UseWildCard,KeyWildM,CustFilters, WantConsumers));
    end;{if}
  {$ELSE}
    New(CustFind,Create(AOwner,CustF,SKeyPath,Want,LenSCode,Mode,UseWildCard,KeyWildM,CustFilters, WantConsumers));
  {$ENDIF}

  Try
    Result:=CustFind^.AdvanceFind;

    If (Not Result) and (Mode<>-1) then
    With CustFind^.PopUpList do
    Begin
      //PR: 02/12/2013 Added property on form to allow hiding of tab 
      HideConsumerTab := HideConsumers;

      //PR: 20/09/2013 MRD 1.1.15/16
      if WantConsumers then
        SetListType(CONSUMER_CHAR, Mode)
      else
        SetListType(TradeCode[IsCust], Mode);

      If (Mode<>99) then
        //PR: 20/09/2013 MRD 1.1.15/16
          Caption := TraderTypeNameFromSubType(ListPFix) + ' ' + Caption;

      ListCol1Lab.Caption:='Code';
      ListCol2Lab.Caption:='Name';

      {If (StartLookUp(LenSCode)) then}

      SetAllowHotKey(BOff,PrevHState);
      Set_BackThreadMVisible(BOn);


      //PR: 24/09/2013 Set ConsumerMode on list and assign ExtRecPtr so that ExtFilter function gets called.
      (OwnList as TCustList).ConsumerMode := SetConsumerMode;
      OwnList.ExtRecPtr := @Cust;

      ShowModal;

      Set_BackThreadMVisible(BOff);

      SetAllowHotKey(BOn,PrevHState);

      Result:=FFoundOk;

      If (Result) then
        Found:=Cust.CustCode;
    end
    else
      If (Result) then
        Found:=Cust.CustCode;

  finally

    Dispose(CustFind,Destroy);

  end;


end; {Func..}


{-----------------------}

{ ============ TNomList Methods ================= }

{ ====== Function to Match Stock based on wild card ===== }

Function TNomList.Check_NCCodes(NCode  :  LongInt;
                                AllowDr:  Boolean)   :   Boolean;

Var
  n        :  NomCtrlType;
  NCC      :  LongInt;

  FoundOk  :  Boolean;

Begin
  FoundOk:=BOff;

  For  n:=InVAT to FreightNC do
  With Syss do
  Begin
    NCC:=NomCtrlCodes[n];

    FoundOk:=((NCC=NCode)  and (((N<>Debtors) and (N<>Creditors)) or (Not AllowDr)));

    If (FoundOk) then
      Break;
  end;

  Check_NCCodes:=FoundOk;

end;


Function TNomList.StkMatchWCard(NomR   :  NominalRec)  :  Char;

Var
  TmpBo,
  FOk,
  WCMFail
         :  Boolean;
  TChr   :  Char;
  TMode  :  Byte;

  GenStr,
  WildMatch
         :  Str255;

Begin

  TmpBO:=BOff;
  WCMFail:=BOFF;

  TMode:=0;

  Blank(WildMatch,Sizeof(WildMatch));

  FOk:=(Not UseWildCard);

  If (Not FOk) then
  With NomR do
  Begin

    TMode:=(1*Ord(KeyWildM[1] in ['0'..'9']))+(2*Ord(KeyWildM[1] In ['A'..'z']))+(3*Ord(KeyWildM[1]=WildChQ))+(4*Ord(KeyWildM[1]=WildCha));

    If (TMode>2) then
    Begin
      If (Length(KeyWildM)>1) then
        WildMatch:=Copy(KeyWildM,2,Pred(Length(KeyWildM)))
      else
        FOk:=BOn;
    end
    else
      WildMatch:=KeyWildM;

    GenStr:=Form_Int(NomR.NomCode,0);

    If (WildMatch<>'') or (TMode<3) then
    Case TMode of

      0,1
         :  FOk:=(Match_Glob(Sizeof(GenStr),WildMatch,GenStr,TmpBo));
      2  :  FOk:=(Match_Glob(Sizeof(Desc),WildMatch,Desc,TmpBo));
      3  :  FOk:=(Match_Glob(Sizeof(AltCode),WildMatch,Altcode,TmpBo));
      4  :  FOk:=(Match_Glob(Sizeof(NomR),WildMatch,NomR,TmpBo));

      else  FOk:=BOff;


    end; {Case..}

    WCMFail:=Not FOK;

  end; {With..}

  If (FOk) then
    TChr:=NomR.NomType
  else
    TChr:=NdxWeight;

  If (Not WCMFail) then
  Begin
    Case DisplayMode of
       78,79
           :  With NomR do
              Begin
                If (Check_NCCodes(NomCode,(DisplayMode=79))) then
                  TChr:=NdxWeight
                else
                  TChr:=NomType;

              end;


       else  TChr:=NomR.NomType;

    end; {Case..}

  end;

  StkMatchWCard:=TChr;

end;


Function TNomList.SetCheckKey  :  Str255;


Var
  DumStr  :  Str255;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  Case Keypath of

    NomCodeK  :  DumStr:=FullNomKey(Nom.NomCode);

    NomDescK  :  DumStr:=Nom.Desc;

    NomAltK   :  DumStr:=Nom.AltCode;

  end;

  SetCheckKey:=DumStr;
end;




Function TNomList.SetFilter  :  Str255;

Begin

  Result:=StkMatchWCard(Nom);

end;



{ ========== Generic Function to Return Formatted Display for List ======= }

Function TNomList.OutLine(Col  :  Byte)  :  Str255;

Begin
   With Nom do
     Case Col of
       0  :  OutLine:=Form_Int(NomCode,0);
       1  :  OutLine:=Desc;
     end; {Case..}
end;




{ ============ TNom Find Methods ================= }



Destructor TNomFind.Destroy;

Begin

  MULCtrlO.Destroy;

  If (PopUpList<>Nil) then
    PopUpList.Free;

end;

Constructor TNomFind.Create(AOwner   :  TComponent;
                            Fnum,
                            SKeyPath :  Integer;
                            Key2F    :  Str255;
                            KLen     :  Integer;
                            NoUpCheck:  Boolean;
                            XMode    :  Integer;
                            UseWC    :  Boolean;
                            KeyW     :  Str255;
                            CFilters :  FilterType);

Begin

  PopUpList:=Nil;
  AdvanceFind:=BOff;

  MULCtrlO:=TNomList.Create(AOwner);

  Try
    With MULCtrlO do
    Begin
      Filter:=CFilters;

      UseWildCard:=UseWC;
      KeyWildM:=KeyW;

      If (XMode In [78,79]) then
        DisplayMode:=XMode;

      NoUpCaseCheck:=NoUpCheck;

      StartList(Fnum,SKeyPath,Key2F,'',Key2F,KLen,BOn);

      AdvanceFind:=GetCode(XMode);
    end;

    If (Not AdvanceFind) and (XMode<>-1) then
    Begin
      MULCtrlO.Destroy;

      PopUpList:=TPOPUpList.Create(AOwner);

      Try

        MULCtrlO:=TNomList.Create(PopUpList);


        PopUpList.CreateOwnList(MULCtrlO,Fnum,SKeypath,Key2F,KLen,0,CFilters);

        With MULCtrlO, ColAppear^[0] do
        Begin
          UseWildCard:=UseWC;
          KeyWildM:=KeyW;

          NoUpCaseCheck:=NoUpCheck;

          DispFormat:=SGFloat;
          NoDecPlaces:=0;

          If (XMode In [78,79]) then
            DisplayMode:=XMode;
        end;

      except

        PopUpList.Free;
        PopUpList:=Nil;

      end;

    end; {IF Advance find ok..}

  Except

     MULCtrlO.Free;
     MULCtrlO:=Nil;
  end;

end; {Proc..}


{ ================ Function to Find an approximate match via list =========== }


Function GetNom(AOWner :  TComponent;
                Want   :  Str20;
            Var Found  :  LongInt;
                Mode   :  Integer;
            Const SuppressInactive : Boolean = False)  :  Boolean;



Var
  RecFind   :  ^TNomFind;
  LenSCode  :  Byte;
  NoUpCheck :  Boolean;

  PrevHState,
  UseWildCard
            :  Boolean;

  SKeyPath  :  Integer;

  KeyWildM  :  Str255;

  RecFilters
            :  FilterType;
  KeyRef    :  Str255;

Begin
  UseWildCard:=BOff;

  SKeyPath:=NomCodeK;

  NoUPCheck:=BOff;
                 
  Blank(RecFilters,Sizeof(RecFilters));

  LenSCode:=Length(Want);

  Found:=IntStr(Want);

  If (Found<>0) then
  Begin
    KeyRef:=FullNomKey(Found);

    NoUpCheck:=BOn;

    If (Mode<>-1) then
      LenSCode:=Length(Strip('R',[#0],KeyRef));
  end
  else
  Begin
    UseWildCard:=((Want[1]=WildCha) and (Mode<>-1));

    If (UseWildCard) then
      Want:=Copy(Want,2,Pred(LenScode));

    If (Want[1]=WildChQ) and (Mode<>-1) then
    Begin

      SKeyPath:=NomAltK;

      If (Not UseWildCard) and (Want[1]=WildCHQ) then
        Want:=Copy(Want,2,Pred(LenScode));
    end
    else
      SKeyPath:=NomDescK;

    KeyRef:=Strip('B',[#32],Want);

    
  end;



  If (Mode<>-1) then
  Begin
    If (UseWildCard) then
    Begin
      RecFilters[1,1]:=NdxWeight;
      KeyWildM:=KeyRef;
      KeyRef:='';
    end;

    Case Mode of
      0  :  Begin                     { -- Include A & B types only -- }
              RecFilters[1+Ord(UseWildCard),1]:=NomHedCode;
              RecFilters[2+Ord(UseWildCard),1]:=CtrlNHCode;
              RecFilters[3+Ord(UseWildCard),1]:=CarryFlg;
            end;
      1  :  RecFilters[1,0]:=NomHedCode;  { -- Include only H types -- }

      5  :  Begin                     { -- Exclude Headings & Carry Fwd types only -- }
              RecFilters[1+Ord(UseWildCard),1]:=NomHedCode;
              RecFilters[2+Ord(UseWildCard),1]:=CarryFlg;
            end;

      77 :  RecFilters[1,0]:=BankNHCode;  { -- Include Bank Set (B/C) only -- }

      78,79
         :  Begin
              RecFilters[1,0]:=CtrlNHCode;
            end;

      99 :  ;                         { -- Include All -- }
    end; {Case..}
  end;

  LenSCode:=Length(KeyRef);

  New(RecFind,Create(AOwner,NomF,SKeyPath,KeyRef,LenSCode,NoUpCheck,Mode,UseWildCard,KeyWildM,RecFilters));

  Try
    Result:=RecFind^.AdvanceFind;

    If (Not Result) and (Mode<>-1) then
    With RecFind^.PopUpList do
    Begin
      ListPFix:='N';

      Caption:='General Ledger Code '+Caption;

      ListCol1Lab.Caption:='Code';
      ListCol1Lab.Alignment:=taRightJustify;

      ListCol2Lab.Caption:='Description';

      {If (StartLookUp(LenSCode)) then}

      SetAllowHotKey(BOff,PrevHState);
      Set_BackThreadMVisible(BOn);

      ShowModal;

      Set_BackThreadMVisible(BOff);

      SetAllowHotKey(BOn,PrevHState);

      Result:=FFoundOk;

      If (Result) then
        Found:=Nom.NomCode;
    end
    else
      If (Result) then
        Found:=Nom.NomCode;

  finally

    Dispose(RecFind,Destroy);

  end;


end; {Func..}



{-----------------------}


{$IFDEF PF_On}

  { ============ TCCList Methods ================= }



  Function TCCList.SetCheckKey  :  Str255;


  Var
    DumStr  :  Str255;

  Begin
    FillChar(DumStr,Sizeof(DumStr),0);

    With Password do
    With CostCtrRec do
      Case KeyPath of
        PWK       :  DumStr:=FullCCKey(RecPfix,SubType,PCostC);
        HelpNdxK  :  DumStr:=PartCCKey(RecPfix,SubType)+CCDesc;
      end; {Case..}

    SetCheckKey:=DumStr;
  end;


  Function TCCList.StkMatchWCard(PassWordR  :  PassWordRec)  :  Char;

  Var
    TmpBo,
    FOk    :  Boolean;
    TChr   :  Char;
    TMode  :  Byte;

    GenStr,
    WildMatch
           :  Str255;

  Begin

    TmpBO:=BOff;
    TMode:=0;

    Blank(WildMatch,Sizeof(WildMatch));

    FOk:=(Not UseWildCard);

    If (Not FOk) then
    With PassWordR.CostCtrRec do
    Begin
      TMode:=(1*Ord(KeyWildM[1]=#32))+(2*Ord(KeyWildM[1]=DescTrig))+(3*Ord(KeyWildM[1]=WildChQ))+(4*Ord(KeyWildM[1]=WildCha));

      {TMode:=(1*Ord(KeyWildM[1] in ['0'..'9']))+(2*Ord(KeyWildM[1] In ['A'..'z']))+(3*Ord(KeyWildM[1]=WildChQ))+(4*Ord(KeyWildM[1]=WildCha));}

      If (TMode>0) then
      Begin
        If (Length(KeyWildM)>1) then
          WildMatch:=Copy(KeyWildM,2,Pred(Length(KeyWildM)))
        else
          FOk:=BOn;
      end
      else
        WildMatch:=KeyWildM;

      If (WildMatch<>'') or (TMode=0) then
      Case TMode of

        0,1
           :  FOk:=(Match_Glob(Sizeof(PCostC),WildMatch,PCostC,TmpBo));
        2  :  FOk:=(Match_Glob(Sizeof(CCDesc),WildMatch,CCDesc,TmpBo));
        {3  :  FOk:=(Match_Glob(Sizeof(AltCode),WMatch,Altcode,TmpBo));}
        4  :  FOk:=(Match_Glob(Sizeof(PassWordR),WildMatch,PassWordR,TmpBo));

        else  FOk:=BOff;


      end; {Case..}



    end; {With..}

    If (FOk) then
      TChr:=#0
    else
      TChr:=NdxWeight;

    StkMatchWCard:=TChr;

  end;


  Function TCCList.SetFilter  :  Str255;

  Begin

    Result:=StkMatchWCard(PassWord);

  end;




  { ========== Generic Function to Return Formatted Display for List ======= }

  Function TCCList.OutLine(Col  :  Byte)  :  Str255;

  Begin
     With Password, CostCtrRec do
       Case Col of
         0  :  OutLine:=PCostC;
         1  :  OutLine:=CCDesc;
       end; {Case..}
  end;




  { ============ TNom Find Methods ================= }



  Destructor TCCFind.Destroy;

  Begin

    MULCtrlO.Destroy;

    If (PopUpList<>Nil) then
      PopUpList.Free;

  end;

  Constructor TCCFind.Create(AOwner   :  TComponent;
                              Fnum,
                              SKeyPath :  Integer;
                              Key2F    :  Str255;
                              KLen     :  Integer;
                              XMode    :  Integer;
                              UseWC    :  Boolean;
                              KeyW     :  Str255;
                              CFilters :  FilterType);

  Begin

    PopUpList:=Nil;
    AdvanceFind:=BOff;

    MULCtrlO:=TCCList.Create(AOwner);

    Try
      With MULCtrlO do
      Begin
        Filter:=CFilters;

        UseWildCard:=UseWC;
        KeyWildM:=KeyW;

        StartList(Fnum,SKeyPath,Key2F,'',Key2F,KLen,BOn);

        AdvanceFind:=GetCode(XMode);
      end;

      If (Not AdvanceFind) and (XMode<>-1) then
      Begin
        MULCtrlO.Destroy;

        PopUpList:=TPOPUpList.Create(AOwner);

        Try

          MULCtrlO:=TCCList.Create(PopUpList);

          PopUpList.CreateOwnList(MULCtrlO,Fnum,SKeypath,Key2F,KLen,0,CFilters);

          With MULCtrlO do
          Begin
            UseWildCard:=UseWC;
            KeyWildM:=KeyW;
          end;

        except

          PopUpList.Free;
          PopUpList:=Nil;

        end;

      end; {IF Advance find ok..}

    Except

       MULCtrlO.Free;
       MULCtrlO:=Nil;
    end;

  end; {Proc..}


  { ================ Function to Find an approximate match via list =========== }


  Function GetCCDep(AOWner :  TComponent;
                    Want   :  Str20;
                Var Found  :  Str20;
                    CCorDep:  Boolean;
                    Mode   :  Integer)  :  Boolean;


  Const
    CapTit     :  Array[BOff..Bon]  of Str15 = ('Department','Cost Centre');

  Var
    RecFind   :  ^TCCFind;
    LenSCode  :  Byte;

    PrevHState,
    UseWildCard
              :  Boolean;

    SKeyPath  :  Integer;

    KeyWildM  :  Str255;

    RecFilters
              :  FilterType;
    KeyRef    :  Str255;

  Begin

    SKeyPath:=PWK;

    Blank(RecFilters,Sizeof(RecFilters));

    LenSCode:=Length(Want);

    UseWildCard:=((Want[1]=WildCha) and (Mode<>-1));

    If (UseWildCard) then
      Want:=Copy(Want,2,Pred(LenScode));

    LenSCode:=Length(Want);

    If (LenSCode>0) and (Want[1]=DescTrig) and (Mode<>-1) then
    Begin

      SKeyPath:=HelpNdxK;

      KeyRef:=PartCCKey(CostCCode,CSubCode[CCorDep])+UpCaseStr(Strip('B',[#32],Copy(Want,2,Pred(LenScode))));
    end
    else
    Begin

      If (Mode<>-1) then
        KeyRef:=PartCCKey(CostCCode,CSubCode[CCorDep])+UpCaseStr(Strip('B',[#32],Want))
      else
        KeyRef:=FullCCKey(CostCCode,CSubCode[CCorDep],Want);
    end;


    If (Mode<>-1) then
    Begin
      If (UseWildCard) then
      Begin
        RecFilters[1,1]:=NdxWeight;
        KeyWildM:=Want;
        KeyRef:=PartCCKey(CostCCode,CSubCode[CCorDep]);
      end;
    end;

    LenSCode:=Length(KeyRef);

    New(RecFind,Create(AOwner,PwrdF,SKeyPath,KeyRef,LenSCode,Mode,UseWildCard,KeyWildM,RecFilters));

    Try
      Result:=RecFind^.AdvanceFind;

      If (Not Result) and (Mode<>-1) then
      With RecFind^.PopUpList do
      Begin
        ListPFix:='D';

        Caption:=CapTit[CCorDep]+' '+Caption;

        ListCol1Lab.Caption:='Code';
        ListCol2Lab.Caption:='Description';

        SetAllowHotKey(BOff,PrevHState);
        Set_BackThreadMVisible(BOn);

        ShowModal;

        Set_BackThreadMVisible(BOff);

        SetAllowHotKey(BOn,PrevHState);


        Result:=FFoundOk;

        If (Result) then
          Found:=PassWord.CostCtrRec.PCostC;
      end
      else
        If (Result) then
          Found:=PassWord.CostCtrRec.PCostC;

    finally

      Dispose(RecFind,Destroy);

    end;


  end; {Func..}

  {-----------------------}

  { ============ TJobList Methods ================= }


  Function TJobList.SetCheckKey  :  Str255;


  Var
    DumStr  :  Str255;

  Begin
    FillChar(DumStr,Sizeof(DumStr),0);

    With JobRec^ do
      Case Keypath of
        JobCodeK   :  DumStr:=JobCode;
        JobDescK   :  DumStr:=JobDesc;
        JobAltK    :  DumStr:=JobAltCode;
      end; {Case..}

    SetCheckKey:=DumStr;
  end;


  Function TJobList.StkMatchWCard(JobR  :  JobRecType)  :  Char;

  Var
    TmpBo,
    FOk    :  Boolean;
    TChr   :  Char;
    TMode  :  Byte;

    GenStr,
    WMatch
           :  Str255;

  Begin

    TmpBO:=BOff;
    TMode:=0;

    FOk:=(Not UseWildCard);

    If (Not FOk) then
    With JobR do
    Begin
      TMode:=(1*Ord(KeyWildM[1]=#32))+(2*Ord(KeyWildM[1]=DescTrig))+(3*Ord(KeyWildM[1]=WildChQ))+(4*Ord(KeyWildM[1]=WildCha));

      If (TMode>0) then
        WMatch:=Copy(KeyWildM,2,Pred(Length(KeyWildM)))
      else
        WMatch:=KeyWildM;

      Case TMode of

        0,1
           :  FOk:=(Match_Glob(Sizeof(JobCode),WMatch,JobCode,TmpBo));
        2  :  FOk:=(Match_Glob(Sizeof(JobDesc),WMatch,JobDesc,TmpBo));
        3  :  FOk:=(Match_Glob(Sizeof(JobAltCode),WMatch,JobAltcode,TmpBo));
        4  :  FOk:=(Match_Glob(Sizeof(JobR),WMatch,JobR,TmpBo));
        else  FOk:=BOff;


      end; {Case..}


    end; {With..}

    If (FOk) then
      TChr:=JobR.JobType
    else
      TChr:=NdxWeight;

    StkMatchWCard:=TChr;

  end;


  Function TJobList.SetFilter  :  Str255;

  Begin
    With JobRec^ do
    Begin
      If (JobStat=JobClosed) and (Filter[3,1]=NdxWeight) then {* Exclude closed Jobs *}
        Result:=NdxWeight
      else
        Result:=StkMatchWCard(JobRec^);
    end;
  end;




  { ========== Generic Function to Return Formatted Display for List ======= }

  Function TJobList.OutLine(Col  :  Byte)  :  Str255;

  Begin
     With JobRec^ do
       Case Col of
         0  :  Case Keypath of
                 JobAltK  :  OutLine:=JobAltCode;
                 else        OutLine:=JobCode;
               end;

         1  :  OutLine:=JobDesc;
       end; {Case..}
  end;




  { ============ TNom Find Methods ================= }



  Destructor TJobFind.Destroy;

  Begin

    MULCtrlO.Destroy;

    If (PopUpList<>Nil) then
      PopUpList.Free;

  end;

  Constructor TJobFind.Create(AOwner   :  TComponent;
                              Fnum,
                              SKeyPath :  Integer;
                              Key2F    :  Str255;
                              KLen     :  Integer;
                              XMode    :  Integer;
                              UseWC    :  Boolean;
                              KeyW     :  Str255;
                              CFilters :  FilterType);

  Begin

    PopUpList:=Nil;
    AdvanceFind:=BOff;

    MULCtrlO:=TJobList.Create(AOwner);

    Try
      With MULCtrlO do
      Begin
        Filter:=CFilters;

        UseWildCard:=UseWC;
        KeyWildM:=KeyW;

        StartList(Fnum,SKeyPath,Key2F,'',Key2F,KLen,BOn);

        AdvanceFind:=GetCode(XMode);
      end;

      If (Not AdvanceFind) and (XMode<>-1) then
      Begin
        MULCtrlO.Destroy;

        PopUpList:=TPOPUpList.Create(AOwner);

        Try

          MULCtrlO:=TJobList.Create(PopUpList);

          PopUpList.CreateOwnList(MULCtrlO,Fnum,SKeypath,Key2F,KLen,0,CFilters);

          With MULCtrlO do
          Begin
            UseWildCard:=UseWC;
            KeyWildM:=KeyW;
          end;

        except

          PopUpList.Free;
          PopUpList:=Nil;

        end;

      end; {IF Advance find ok..}

    Except

       MULCtrlO.Free;
       MULCtrlO:=Nil;
    end;

  end; {Proc..}


  { ================ Function to Find an approximate match via list =========== }


  Function GetJob(AOWner :  TComponent;
                  Want   :  Str20;
              Var Found  :  Str20;
                  Mode   :  Integer)  :  Boolean;



  Var
    RecFind   :  ^TJobFind;
    LenSCode  :  Byte;

    PrevHState,
    UseWildCard
              :  Boolean;

    SKeyPath  :  Integer;

    KeyWildM  :  Str255;

    RecFilters
              :  FilterType;
    KeyRef    :  Str255;

  Begin

    SKeyPath:=JobCodeK;

    Blank(RecFilters,Sizeof(RecFilters));

    LenSCode:=Length(Want);

    UseWildCard:=BOff;

    If (LenSCode>0) then
    Begin

      UseWildCard:=((Want[1]=WildCha) and (Mode<>-1));

      If (UseWildCard) then
        Want:=Copy(Want,2,Pred(LenScode));

      If ((Want[1]=WildChQ) or (Want[1]=DescTrig)) and (Mode<>-1) then
      Begin

        If (Want[1]=WildChQ) then
          SKeyPath:=JobAltK
        else
          SKeyPath:=JobDescK;

        If (Not UseWildCard) then
          Want:=Copy(Want,2,Pred(LenScode));
      end
    end;

    KeyRef:=Want;



    If (Mode<>-1) then
    Begin
      If (UseWildCard) then
      Begin
        RecFilters[1,1]:=NdxWeight;
        KeyWildM:=KeyRef;
        KeyRef:='';
      end
      else
        KeyRef:=Strip('B',[#32],KeyRef);

      Case Mode of
        0,3,4
           :  Begin

                { -- Exclude K types, Include J & Z types only -- }

                RecFilters[1+Ord(UseWildCard),1]:=JobGrpCode;

                RecFilters[3,1]:=NdxWeight;  { Exclude Closed Jobs }

              end;

        1  :  RecFilters[1,0]:=JobGrpCode;  { -- Include only K types -- }

        99 :  ;                         { -- Include All -- }
      end; {Case..}

    end;

    LenSCode:=Length(KeyRef);

    New(RecFind,Create(AOwner,JobF,SKeyPath,KeyRef,LenSCode,Mode,UseWildCard,KeyWildM,RecFilters));

    Try
      Result:=RecFind^.AdvanceFind;

      If (Not Result) and (Mode<>-1) then
      With RecFind^.PopUpList do
      Begin
        ListPFix:='J';

        Caption:='Job '+Caption;

        If (SKeyPath=JobAltK) then
          ListCol1Lab.Caption:='Alternative Code'
        else
          ListCol1Lab.Caption:='Code';

        ListCol2Lab.Caption:='Description';

        SetAllowHotKey(BOff,PrevHState);

        Set_BackThreadMVisible(BOn);

        ShowModal;

        Set_BackThreadMVisible(BOff);

        SetAllowHotKey(BOn,PrevHState);

        Result:=FFoundOk;

        If (Result) then
          Found:=JobRec^.JobCode;
      end
      else
        If (Result) then
          Found:=JobRec^.JobCode;

    finally

      Dispose(RecFind,Destroy);

    end;


  end; {Func..}




  {-----------------------}


  { ============ TJAnalList Methods ================= }


  Function TJAnalList.SetCheckKey  :  Str255;


  Var
    DumStr  :  Str255;

  Begin
    FillChar(DumStr,Sizeof(DumStr),0);

    With JobMisc^,JobAnalRec do
      Case KeyPath of
        JMK       :  DumStr:=FullJAKey(RecPfix,SubType,JAnalCode);
        JMSecK    :  DumStr:=PartCCKey(RecPfix,SubType)+JAnalName;
        JMTrdK    :  DumStr:=PartCCKey(RecPfix,SubType)+JMNDX3;
      end; {Case..}

    SetCheckKey:=DumStr;
  end;


  Function TJAnalList.StkMatchWCard(JobMiscR  :  JobMiscRec)  :  Char;

  Var
    TmpBo,
    FOk    :  Boolean;
    TChr   :  Char;
    TMode  :  Byte;

    GenStr,
    WMatch
           :  Str255;

  Begin

    TmpBO:=BOff;
    TMode:=0;

    FOk:=(Not UseWildCard);

    If (Not FOk) then
    With JobMiscR.JobAnalRec do
    Begin
      TMode:=(1*Ord(KeyWildM[1]=#32))+(2*Ord(KeyWildM[1]=DescTrig))+(3*Ord(KeyWildM[1]=WildChQ))+(4*Ord(KeyWildM[1]=WildCha));

      If (TMode>0) then
        WMatch:=Copy(KeyWildM,2,Pred(Length(KeyWildM)))
      else
        WMatch:=KeyWildM;

      Case TMode of

        0,1
           :  FOk:=(Match_Glob(Sizeof(JAnalCode),WMatch,JAnalCode,TmpBo));
        2  :  FOk:=(Match_Glob(Sizeof(JAnalName),WMatch,JAnalName,TmpBo));
        3  :  FOk:=(Match_Glob(Sizeof(JMNDX3),WMatch,JMNDX3,TmpBo));
        4  :  FOk:=(Match_Glob(Sizeof(JobMiscR.JobAnalRec),WMatch,JobMiscR.JobAnalRec,TmpBo));
        else  FOk:=BOff;


      end; {Case..}


    end; {With..}

    If (FOk) then
      TChr:=Chr(JobMiscR.JobAnalRec.JAType)
    else
      TChr:=NdxWeight;

    StkMatchWCard:=TChr;

  end;


  Function TJAnalList.SetFilter  :  Str255;

  Begin

    Result:=StkMatchWCard(JobMisc^);

    If  (Result<>NdxWeight) then
    With JobMisc^.JobAnalRec do
    Begin
      Case DAMode of
        5,6  :  If (JAType=JobXRev) and (AnalHed=(SysAnlsPRet-(DAmode-5))) then
                  Result:=Chr(JAType)
                else
                  Result:=NdxWeight;

        7    :  If (Result<>Chr(JobXRev)) or (AnalHed<>SysAnlsRcpt) then
                  Result:=NdxWeight;

        {$IFDEF JC}
          8    :  If (AnalHed=SysAnlsWIP) then
                    Result:=Chr(JAType)
                  else
                    Result:=NdxWeight;

          else    If (AnalHed=SysAnlsWIP) then {* Auto exclude WIP anal code *}
                    Result:=NdxWeight
                  else
                    Result:=Chr(JAType);
        {$ENDIF}

      end; {Case..}
    end;

  end;




  { ========== Generic Function to Return Formatted Display for List ======= }

  Function TJAnalList.OutLine(Col  :  Byte)  :  Str255;

  Begin
     With JobMisc^.JobAnalRec do
       Case Col of
         0  :  Case Keypath of
                 JMTrdK  :  OutLine:=JMNDX3;
                 else       OutLine:=JAnalCode;
               end;

         1  :  OutLine:=JAnalName;
       end; {Case..}
  end;




  { ============ TNom Find Methods ================= }



  Destructor TJAnalFind.Destroy;

  Begin

    MULCtrlO.Destroy;

    If (PopUpList<>Nil) then
      PopUpList.Free;

  end;

  Constructor TJAnalFind.Create(AOwner   :  TComponent;
                                Fnum,
                                SKeyPath :  Integer;
                                Key2F    :  Str255;
                                KLen     :  Integer;
                                XMode    :  Integer;
                                UseWC    :  Boolean;
                                KeyW     :  Str255;
                                CFilters :  FilterType);

  Begin

    PopUpList:=Nil;
    AdvanceFind:=BOff;

    MULCtrlO:=TJAnalList.Create(AOwner);

    Try
      With MULCtrlO do
      Begin
        Filter:=CFilters;
        DAMode:=XMode;
        UseWildCard:=UseWC;
        KeyWildM:=KeyW;

        StartList(Fnum,SKeyPath,Key2F,'',Key2F,KLen,BOn);

        AdvanceFind:=GetCode(XMode);
      end;

      If (Not AdvanceFind) and (XMode<>-1) then
      Begin
        MULCtrlO.Destroy;

        PopUpList:=TPOPUpList.Create(AOwner);

        Try

          MULCtrlO:=TJAnalList.Create(PopUpList);

          PopUpList.CreateOwnList(MULCtrlO,Fnum,SKeypath,Key2F,KLen,0,CFilters);

          With MULCtrlO do
          Begin
            DAMode:=XMode;
            UseWildCard:=UseWC;
            KeyWildM:=KeyW;
          end;

        except

          PopUpList.Free;
          PopUpList:=Nil;

        end;

      end; {IF Advance find ok..}

    Except

       MULCtrlO.Free;
       MULCtrlO:=Nil;
    end;

  end; {Proc..}


  { ================ Function to Find an approximate match via list =========== }


  Function GetJobMisc(AOWner :  TComponent;
                      Want   :  Str20;
                  Var Found  :  Str20;
                      JAMode,
                      Mode   :  Integer)  :  Boolean;



  Var
    RecFind   :  ^TJAnalFind;
    LenSCode  :  Byte;

    PrevHState,
    UseWildCard
              :  Boolean;

    SKeyPath  :  Integer;

    KeyWildM  :  Str255;

    RecFilters
              :  FilterType;
    KeyRef    :  Str255;

  Begin

    SKeyPath:=JMK;

    Blank(RecFilters,Sizeof(RecFilters));

    UseWildCard:=((Want[1]=WildCha) and (Mode<>-1));

    LenSCode:=Length(Want);

    If (UseWildCard) then
      Want:=Copy(Want,2,Pred(LenScode));

    LenSCode:=Length(Want);

    If (LenSCode>0) and ((Want[1]=WildChQ) or (Want[1]=DescTrig)) and (Mode<>-1) then
    Begin

      If (Want[1]=WildChQ) then
        SKeyPath:=JMTrdK
      else
        SKeyPath:=JMSecK;

      If (Not UseWildCard) then
        Want:=Copy(Want,2,Pred(LenScode));

      KeyRef:=PartCCKey(JARCode,JASubAry[JAMode])+UpCaseStr(Strip('B',[#32],Want));
    end
    else
    Begin
      If (Mode<>-1) then
        KeyRef:=PartCCKey(JARCode,JASubAry[JAMode])+UpCaseStr(Strip('B',[#32],Want))
      else
      Begin
       {$IFDEF JC}
        Case JAMode of
          3  :  KeyRef:=PartCCKey(JARCode,JASubAry[JAMode])+FullEmpKey(Want);
          else  KeyRef:=FullJAKey(JARCode,JASubAry[JAMode],Want);
        end; {case..}
       {$ELSE}
          KeyRef:=FullJAKey(JARCode,JASubAry[JAMode],Want);
       {$ENDIF}
      end;

    end;


    If (Mode<>-1) then
    Begin
      If (UseWildCard) then
      Begin
        RecFilters[1,1]:=NdxWeight;
        KeyWildM:=Want;
        KeyRef:=PartCCKey(JARCode,JASubAry[JAMode]);
      end
      else
        KeyRef:=Strip('B',[#32],KeyRef);


      Case JAMode of

        2  :  Case Mode of

                  1
                     :  RecFilters[1,0]:=Chr(JobXRev);  { -- 1. Include Revenue Types only -- }
                                                        { -- 2. Include Revenue type + Purch reten -- }
                                                        { -- 3. Include Revemue type + Sales Reten -- }

                  2  :  Begin
                          RecFilters[1,0]:=Chr(JobXMat);{ -- Include Materials Only -- }
                        end;

                  3  :  RecFilters[1+Ord(UseWildCard),1]:=Chr(JobXRev);  { -- Exclude Revenue Types -- }

                  4  :  Begin                       { -- include labour+o/ H by.. --}
                          RecFilters[1+Ord(UseWildCard),1]:=Chr(JobXRev);  { -- Exclude Revenue Types -- }
                          RecFilters[2+Ord(UseWildCard),1]:=Chr(JobXMat);  { -- Exclude Materials  -- }
                        end;

                  5..8
                     :  RecFilters[1,1]:=NdxWeight;  { -- Include Revenue Types only for retentions -- }
                                                 { -- 5,6. Include Retention type revenue -- }


              end; {Case..}


        99 :  ;                         { -- Include All -- }
      end; {Case..}

    end;

    LenSCode:=Length(KeyRef);

    New(RecFind,Create(AOwner,JMiscF,SKeyPath,KeyRef,LenSCode,Mode,UseWildCard,KeyWildM,RecFilters));

    Try
      Result:=RecFind^.AdvanceFind;

      If (Not Result) and (Mode<>-1) then
      With RecFind^.PopUpList do
      Begin
        ListPFix:='A';

        Caption:='Job Analysis '+Caption;

        If (SKeyPath=JMTrdK) then
          ListCol1Lab.Caption:='Alternative Code'
        else
          ListCol1Lab.Caption:='Code';

        ListCol2Lab.Caption:='Description';

        SetAllowHotKey(BOff,PrevHState);

        Set_BackThreadMVisible(BOn);

        ShowModal;

        Set_BackThreadMVisible(BOff);

        SetAllowHotKey(BOn,PrevHState);

        Result:=FFoundOk;

        If (Result) then
          Found:=JobMisc^.JobAnalRec.JAnalCode;
      end
      else
        If (Result) then
          Found:=JobMisc^.JobAnalRec.JAnalCode;

    finally

      Dispose(RecFind,Destroy);

    end;


  end; {Func..}




  {-----------------------}

  {$IFDEF JC}

    { ============ TEmpRList Methods ================= }


    Function TJEmpRList.SetCheckKey  :  Str255;


    Var
      DumStr  :  Str255;

    Begin
      FillChar(DumStr,Sizeof(DumStr),0);

      With JobCtrl^,EmplPay do
      Case KeyPath of
        JCK       :  DumStr:=FullJBKey(RecPfix,SubType,EmplCode);
        JCSecK    :  DumStr:=PartCCKey(RecPfix,SubType)+ECodeNDX;
      end; {Case..}

      SetCheckKey:=DumStr;
    end;


    Function TJEmpRList.StkMatchWCard(JobCtrlR  :  JobCtrlRec)  :  Char;

    Var
      TmpBo,
      FOk    :  Boolean;
      TChr   :  Char;
      TMode  :  Byte;

      GenStr,
      WMatch
             :  Str255;

    Begin

      TmpBO:=BOff;
      TMode:=0;

      FOk:=(Not UseWildCard);

      If (Not FOk) then
      With JobCtrlR.EmplPay do
      Begin
        TMode:=(1*Ord(KeyWildM[1]=#32))+(2*Ord(KeyWildM[1]=DescTrig))+(3*Ord(KeyWildM[1]=WildChQ))+(4*Ord(KeyWildM[1]=WildCha));

        If (TMode>0) then
          WMatch:=Copy(KeyWildM,2,Pred(Length(KeyWildM)))
        else
          WMatch:=KeyWildM;

        Case TMode of

          0,1
             :  FOk:=(Match_Glob(Sizeof(EStockCode),WMatch,EStockCode,TmpBo));
          2  :  FOk:=(Match_Glob(Sizeof(PayRDesc),WMatch,PayRDesc,TmpBo));
          3  :  FOk:=(Match_Glob(Sizeof(EAnalCode),WMatch,EAnalCode,TmpBo));
          4  :  FOk:=(Match_Glob(Sizeof(JobCtrlR.EmplPay),WMatch,JobCtrlR.EmplPay,TmpBo));
          else  FOk:=BOff;


        end; {Case..}


      end; {With..}

      If (FOk) then
        TChr:=#1
      else
        TChr:=NdxWeight;

      StkMatchWCard:=TChr;

    end;


    Function TJEmpRList.SetFilter  :  Str255;

    Begin

      Result:=StkMatchWCard(JobCtrl^);

      If (Result<>NdxWeight) then
      Begin
        Result:=JobCtrl^.EmplPay.EAnalCode;
      end;

    end;




    { ========== Generic Function to Return Formatted Display for List ======= }

    Function TJEmpRList.OutLine(Col  :  Byte)  :  Str255;

    Begin
       With JobCtrl^,EmplPay do
         Case Col of
           0  :  OutLine:=EStockCode;

           1  :  Begin
                   If (SubType=JBSubAry[4]) then {* Substitute alt desc *}
                     Result:=Get_StdPRDesc(EStockCode,ScanFileNum,Keypath,-1)
                   else
                     Result:=PayRDesc;
                 end;
         end; {Case..}
    end;




    { ============ TNom Find Methods ================= }



    Destructor TJEmpRFind.Destroy;

    Begin

      MULCtrlO.Destroy;

      If (PopUpList<>Nil) then
        PopUpList.Free;

    end;

    Constructor TJEmpRFind.Create(AOwner   :  TComponent;
                                  Fnum,
                                  SKeyPath :  Integer;
                                  Key2F    :  Str255;
                                  KLen     :  Integer;
                                  XMode    :  Integer;
                                  UseWC    :  Boolean;
                                  KeyW     :  Str255;
                                  CFilters :  FilterType);

    Begin

      PopUpList:=Nil;
      AdvanceFind:=BOff;

      MULCtrlO:=TJEmpRList.Create(AOwner);

      Try
        With MULCtrlO do
        Begin
          Filter:=CFilters;

          UseWildCard:=UseWC;
          KeyWildM:=KeyW;

          StartList(Fnum,SKeyPath,Key2F,'',Key2F,KLen,BOn);

          AdvanceFind:=GetCode(XMode);
        end;

        If (Not AdvanceFind) and (XMode<>-1) then
        Begin
          MULCtrlO.Destroy;

          PopUpList:=TPOPUpList.Create(AOwner);

          Try

            MULCtrlO:=TJEmpRList.Create(PopUpList);

            PopUpList.CreateOwnList(MULCtrlO,Fnum,SKeypath,Key2F,KLen,0,CFilters);

            With MULCtrlO do
            Begin
              DAMode:=XMode;
              UseWildCard:=UseWC;
              KeyWildM:=KeyW;
            end;

          except

            PopUpList.Free;
            PopUpList:=Nil;

          end;

        end; {IF Advance find ok..}

      Except

         MULCtrlO.Free;
         MULCtrlO:=Nil;
      end;

    end; {Proc..}


    { ================ Function to Find an approximate match via list =========== }


    Function GetEmpRate(AOWner :  TComponent;
                        Want   :  Str50;
                    Var Found  :  Str20;
                        GMode,
                        LMode  :  Integer)  :  Boolean;



    Var
      RecFind   :  ^TJEmpRFind;
      LenSCode  :  Byte;

      PrevHState,
      UseWildCard
                :  Boolean;

      SKeyPath  :  Integer;

      KeyWildM  :  Str255;

      RecFilters
                :  FilterType;
      KeyRef    :  Str255;

    Begin

      SKeyPath:=JCK;

      Blank(RecFilters,Sizeof(RecFilters));

      UseWildCard:=((Want[1]=WildCha) and (LMode<>-1));

      LenSCode:=Length(Want);

      If (UseWildCard) then
        Want:=Copy(Want,2,Pred(LenScode));

      LenSCode:=Length(Want);

      If (LenSCode>0) and ((Want[1]=WildChQ) or (Want[1]=DescTrig)) and (LMode<>-1) then
      Begin

        If (Want[1]<>WildChQ) then
          SKeyPath:=JCSecK;

        If (Not UseWildCard) then
          Want:=Copy(Want,2,Pred(LenScode));

        KeyRef:=PartCCKey(JBRCode,JBSubAry[GMode])+UpCaseStr(Strip('B',[#32],Copy(Want,2,Pred(LenScode))));
      end
      else
      Begin
        If (LMode<>-1) then
          KeyRef:=PartCCKey(JBRCode,JBSubAry[GMode])+UpCaseStr(Strip('B',[#32],Want))
        else
          KeyRef:=FullJBKey(JBRCode,JBSubAry[GMode],Want);

      end;


      If (LMode<>-1) then
      Begin
        If (UseWildCard) then
        Begin
          RecFilters[1,1]:=NdxWeight;
          KeyWildM:=Want;
          KeyRef:=PartCCKey(JBRCode,JBSubAry[GMode]);
        end
        else
          KeyRef:=Strip('B',[#32],KeyRef);



      end;

      LenSCode:=Length(KeyRef);

      New(RecFind,Create(AOwner,JCtrlF,SKeyPath,KeyRef,LenSCode,LMode,UseWildCard,KeyWildM,RecFilters));

      Try
        Result:=RecFind^.AdvanceFind;

        If (Not Result) and (LMode<>-1) then
        With RecFind^.PopUpList do
        Begin
          ListPFix:='E';

          Caption:='Employee Rates '+Caption;

          ListCol1Lab.Caption:='Code';

          ListCol2Lab.Caption:='Description';

          SetAllowHotKey(BOff,PrevHState);

          Set_BackThreadMVisible(BOn);

          ShowModal;

          Set_BackThreadMVisible(BOff);

          SetAllowHotKey(BOn,PrevHState);

          Result:=FFoundOk;

          If (Result) then
            Found:=JobCtrl^.EmplPay.EStockCode;
        end
        else
          If (Result) then
            Found:=JobCtrl^.EmplPay.EStockCode;

      finally

        Dispose(RecFind,Destroy);

      end;


    end; {Func..}




    {-----------------------}
{$ENDIF}


  { ============ TUserList Methods ================= }


  Function TUserList.SetCheckKey  :  Str255;


  Var
    DumStr  :  Str255;

  Begin
    FillChar(DumStr,Sizeof(DumStr),0);

    With PassWord.PassEntryRec do
    Case Keypath of
      PWK  :  DumStr:=FullPWordKey(PassUCode,C0,LogIn);
    end; {Case..}

    SetCheckKey:=DumStr;
  end;


  Function TUserList.SetFilter  :  Str255;

  Begin

    Result:=#0;

  end;




  { ========== Generic Function to Return Formatted Display for List ======= }

  Function TUserList.OutLine(Col  :  Byte)  :  Str255;

  Begin
     With PassWord.PassEntryRec  do
       Case Col of
         0  :  OutLine:=Login;
         1  :  OutLine:='Enterprise User';
       end; {Case..}
  end;




  { ============ TNom Find Methods ================= }



  Destructor TUserFind.Destroy;

  Begin

    MULCtrlO.Destroy;

    If (PopUpList<>Nil) then
      PopUpList.Free;

  end;

  Constructor TUserFind.Create(AOwner   :  TComponent;
                              Fnum,
                              SKeyPath :  Integer;
                              Key2F    :  Str255;
                              KLen     :  Integer;
                              XMode    :  Integer;
                              UseWC    :  Boolean;
                              KeyW     :  Str255;
                              CFilters :  FilterType);

  Begin

    PopUpList:=Nil;
    AdvanceFind:=BOff;

    MULCtrlO:=TUserList.Create(AOwner);

    Try
      With MULCtrlO do
      Begin
        Filter:=CFilters;

        UseWildCard:=UseWC;
        KeyWildM:=KeyW;

        StartList(Fnum,SKeyPath,Key2F,'',Key2F,KLen,BOn);

        AdvanceFind:=GetCode(XMode);
      end;

      If (Not AdvanceFind) and (XMode<>-1) then
      Begin
        MULCtrlO.Destroy;

        PopUpList:=TPOPUpList.Create(AOwner);

        Try

          MULCtrlO:=TUserList.Create(PopUpList);

          PopUpList.CreateOwnList(MULCtrlO,Fnum,SKeypath,Key2F,KLen,0,CFilters);

          With MULCtrlO do
          Begin
            UseWildCard:=UseWC;
            KeyWildM:=KeyW;
          end;

        except

          PopUpList.Free;
          PopUpList:=Nil;

        end;

      end; {IF Advance find ok..}

    Except

       MULCtrlO.Free;
       MULCtrlO:=Nil;
    end;

  end; {Proc..}


  { ================ Function to Find an approximate match via list =========== }


  Function GetUser(AOWner :  TComponent;
                   Want   :  Str20;
               Var Found  :  Str20;
                   Mode   :  Integer)  :  Boolean;



  Var
    RecFind   :  ^TUserFind;
    LenSCode  :  Byte;

    PrevHState,
    UseWildCard
              :  Boolean;

    SKeyPath  :  Integer;

    KeyWildM  :  Str255;

    RecFilters
              :  FilterType;
    KeyRef    :  Str255;

    TmpStat,
    TmpKPath  :  Integer;

    TmpRecAddr
              :  LongInt;

    TmpPWrd   :  PassWordRec;


  Begin

    SKeyPath:=PWK;

    Blank(RecFilters,Sizeof(RecFilters));

    LenSCode:=Length(Want);

    TmpPWrd:=PassWord;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(PWrdF,TmpKPath,F[PWrdF],TmpRecAddr,BOff,BOff);

    UseWildCard:=BOff;

    If (Mode<>-1) then
      KeyRef:=PartCCKey(PassUCode,C0)+UpCaseStr(Strip('B',[#32],Want))
    else
      KeyRef:=FullPWordKey(PassUCode,C0,Want);



    If (Mode<>-1) then
    Begin
      If (UseWildCard) then
      Begin
        RecFilters[1,1]:=NdxWeight;
        KeyWildM:=KeyRef;
        KeyRef:='';
      end
      else
        KeyRef:=Strip('B',[#32],KeyRef);


    end;

    LenSCode:=Length(KeyRef);

    New(RecFind,Create(AOwner,PWrdF,SKeyPath,KeyRef,LenSCode,Mode,UseWildCard,KeyWildM,RecFilters));

    Try
      Result:=RecFind^.AdvanceFind;

      If (Not Result) and (Mode<>-1) then
      With RecFind^.PopUpList do
      Begin
        ListPFix:='U';

        Caption:='User '+Caption;

        ListCol1Lab.Caption:='Name';

        ListCol2Lab.Caption:='Description';

        SetAllowHotKey(BOff,PrevHState);

        Set_BackThreadMVisible(BOn);

        ShowModal;

        Set_BackThreadMVisible(BOff);

        SetAllowHotKey(BOn,PrevHState);

        Result:=FFoundOk;

        If (Result) then
          Found:=LjVar(PassWord.PassEntryRec.Login,LogInKeyLen);
      end
      else
        If (Result) then
          Found:=LjVar(PassWord.PassEntryRec.Login,LogInKeyLen);

    finally

      Dispose(RecFind,Destroy);

      TmpStat:=Presrv_BTPos(PWrdF,TmpKPath,F[PWrdF],TmpRecAddr,BOn,BOff);

      PassWord:=TmpPWrd;

    end;


  end; {Func..}




  {-----------------------}

{$ENDIF}

{ ============ TStockList Methods ================= }

{$IFDEF STK}


  Function TStockList.SetCheckKey  :  Str255;


  Var
    DumStr  :  Str255;

  Begin
    FillChar(DumStr,Sizeof(DumStr),0);

    Case ScanFileNum of
      StockF  :
                 With Stock do
                   Case Keypath of
                     StkCodeK   :  DumStr:=StockCode;
                     StkDescK   :  DumStr:=Desc[1];
                     StkAltK    :  DumStr:=AltCode;
                     StkBarCK   :  DumStr:=Barcode;
                     {$IFDEF TRADE}
                       StkMinK : DumStr:=Supplier;
                     {$ENDIF}

                   end; {Case..}

    {$IFDEF SOP}

      MLocF : With MLocCtrl^,MLocLoc do
              Case KeyPath of
                MLK       :  If (DisplayMode=78) then
                             With sdbStkRec do
                               DumStr:=RecPfix+SubType+sdCode1
                             else
                               DumStr:=RecPfix+SubType+loCode;

                MLSecK    :  DumStr:=RecPfix+SubType+loName;
              end; {Case..}

    {$ENDIF}

    end; {Case..}
    SetCheckKey:=DumStr;
  end;


  Function TStockList.StkMatchWCard(StockR  :  StockRec)  :  Char;

  Var
    TmpBo,
    FOk    :  Boolean;
    TChr   :  Char;
    TMode  :  Byte;

    GenStr,
    WMatch
           :  Str255;

  Begin

    TmpBO:=BOff;
    TMode:=0;

    FOk:=(Not UseWildCard);

    If (Not FOk) then
    With StockR do
    Begin
      TMode:=(1*Ord(KeyWildM[1]=#32))+(2*Ord(KeyWildM[1]=DescTrig))+(3*Ord(KeyWildM[1]=WildChQ))+(4*Ord(KeyWildM[1]=BarCTrig))+
             (5*Ord(KeyWildM[1]=WildCha));

      If (TMode>0) then
        WMatch:=Copy(KeyWildM,2,Pred(Length(KeyWildM)))
      else
        WMatch:=KeyWildM;

      Case TMode of

        0,1
           :  FOk:=(Match_Glob(Sizeof(StockCode),WMatch,StockCode,TmpBo));
        2  :  FOk:=(Match_Glob(Sizeof(Desc),WMatch,Desc,TmpBo));
        3  :  FOk:=(Match_Glob(Sizeof(AltCode),WMatch,Altcode,TmpBo));
        4  :  FOk:=(Match_Glob(Sizeof(BarCode),WMatch,BarCode,TmpBo));
        5  :  FOk:=(Match_Glob(Sizeof(StockR),WMatch,StockR,TmpBo));
        else  FOk:=BOff;


      end; {Case..}


    end; {With..}

    If (FOk) then
      TChr:=StockR.StockType
    else
      TChr:=NdxWeight;

    StkMatchWCard:=TChr;

  end;


  Function TStockList.SetFilter  :  Str255;

  Var
    KeyChk  :  Str255;

  Begin
    Result:= '';

    FillChar(KeyChk,Sizeof(KeyChk),#0);

    Case ScanFileNum of
      StockF  :  Result:=StkMatchWCard(Stock);

      {$IFNDEF EDLL}
        {$IFNDEF OLE}
          {$IFNDEF RW}
            {$IFNDEF ENDV}
            {$IFNDEF XO}
            {$IFNDEF TRADEALTSB}
              {$IFDEF SOP}

                  MLocF  :  Begin
                              With MLocCtrl^.sdbStkRec do
                              Begin
                                {$IFNDEF TRADE}
                                   LinksdbStk(SdStkFolio,0);
                                {$ELSE}
                                   If (Stock.StockFolio<>sdStkFolio) then {Load up the stock record}
                                   Begin
                                     KeyChk:=FullNomKey(sdStkFolio);

                                     Status:=Find_Rec(B_GetEq,F[StockF],StockF,RecPtr[StockF]^,StkFolioK,KeyChk);

                                     If (Status<>0) or (Stock.StockFolio<>sdStkFolio) then
                                       FillChar(Stock,Sizeof(Stock),#0);

                                   end;
                                {$ENDIF}

                                If (UseWildCard) then
                                  Result:=StkMatchWCard(Stock)
                                else
                                  Result:=Stock.StockType;


                                If (KeyFilter<>'') and (Not CheckKey(KeyFilter,sdSuppCode,Length(KeyFilter),BOff)) then
                                  Result:=Filter[1,1];
                              end;

                            end;
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
            {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
    end; {Case..}

  end;


  { ========== Generic Function to Return Formatted Display for List ======= }

  Function TStockList.OutStkLine(Col  :  Byte)  :  Str255;

  Begin
     With Stock do
       Case Col of
         0  :  Case Keypath of
                 StkAltK  :  Result:=AltCode;
                 else        Result:=StockCode;
               end;

         1  :  Result:=Desc[1];

         2  :  Result:=FormatFloat(GenQtyMask,QtyInStock);

         {$IFNDEF OLE}
         3  :  Result:=FormatFloat(GenQtyMask,FreeStock(Stock));
         {$ENDIF}

         4  :  Result:=FormatFloat(GenQtyMask,QtyOnOrder);

       end; {Case..}
  end;

{$IFNDEF EDLL}
  {$IFNDEF OLE}
    {$IFNDEF RW}
      {$IFNDEF ENDV}
      {$IFNDEF XO}
      {$IFNDEF TRADEALTSB}
        {$IFDEF SOP}


         { ========== Generic Function to Return Formatted Display for List ======= }

          Function TStockList.OutAltLine(Col  :  Byte)  :  Str255;

          Begin
            With MLocCtrl^, SdbStkRec, Stock  do

            Case Col of
               0  :  Begin
                       Result:=sdCode1;

                       {$IFDEF TRADEXX}
                         If (Stock.StockFolio<>sdStkFolio) then {Load up the stock record}
                         Begin
                           If Not CheckRecExsists(Trim(FullNomKey(sdStkFolio)),StockF,StkFolioK) then
                             FillChar(Stock,Sizeof(Stock),#0);

                         end;
                       {$ENDIF}

                     end;

               1  :  Case SCCount of
                       0  :  Result:=dbFormatName(StockCode,Desc[1]);
                       1  :  Begin
                               Result:='';

                               {$IFNDEF TRADE}
                                 If (SdOverRO) then
                                   Result:=FormatCurFloat(GenUnitMask[BOff],sdROPrice,BOn,sdROCurrency);
                               {$ENDIF}

                               If (Result<>'') then
                                 Result:=Result+',';

                               Result:=Result+sdSuppCode;
                             end;
                       2  :  Result:=Desc[1];
                       3  :  Result:=sdDesc;
                       4  :  Result:=sdSuppCode;
                     end; {Case..}

               2  :  Result:=FormatFloat(GenQtyMask,QtyInStock);

               3  :  Result:=FormatFloat(GenQtyMask,FreeStock(Stock));

               4  :  Result:=FormatFloat(GenQtyMask,QtyOnOrder);

            end; {Case..}
          end;

        {$ENDIF}
      {$ENDIF}
      {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

  { ========== Generic Function to Return Formatted Display for List ======= }

  Function TStockList.OutLine(Col  :  Byte)  :  Str255;

  Begin
    Case ScanFileNum of
      StockF  :  Result:=OutStkLine(Col);

      {$IFNDEF EDLL}
        {$IFNDEF OLE}
          {$IFNDEF RW}
           {$IFNDEF ENDV}
            {$IFNDEF XO}
            {$IFNDEF TRADEALTSB}
              {$IFDEF SOP}
                MLocF :  Result:=OutAltLine(Col);
              {$ENDIF}
            {$ENDIF}
            {$ENDIF}
           {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    end; {Case..}
  end;


Function TStockList.SetColCaption  :  Str255;

Begin
  Case SCCount of
    0  :  Result:='Stock Item';
    1  :  Result:='RO Price,A/C Code';
    2  :  Result:='Stock Description';
    3  :  Result:='Alt Description';
    4  :  Result:='Alt Supplier';
  end; {Case..}
end;


  { ============ TNom Find Methods ================= }



  Destructor TStockFind.Destroy;

  Begin

    MULCtrlO.Destroy;

    If (PopUpList<>Nil) then
      PopUpList.Free;

  end;

  Constructor TStockFind.Create(AOwner   :  TComponent;
                                Fnum,
                                SKeyPath :  Integer;
                                Key2F    :  Str255;
                                KLen     :  Integer;
                                XMode    :  Integer;
                                UseWC    :  Boolean;
                                KeyW,
                                KeyF     :  Str255;
                                CFilters :  FilterType);

  Begin

    PopUpList:=Nil;
    AdvanceFind:=BOff;

    MULCtrlO:=TStockList.Create(AOwner);

    Try
      With MULCtrlO do
      Begin
        Filter:=CFilters;

        UseWildCard:=UseWC;
        KeyWildM:=KeyW;
        KeyFilter:=KeyF;

        StartList(Fnum,SKeyPath,Key2F,'',Key2F,KLen,BOn);

        AdvanceFind:=GetCode(XMode);
      end;

      If (Not AdvanceFind) and (XMode<>-1) then
      Begin
        MULCtrlO.Destroy;

        PopUpList:=TPOPUpList.Create(AOwner);

        Try

          MULCtrlO:=TStockList.Create(PopUpList);


          With MULCtrlO do
          Begin
            UseWildCard:=UseWC;
            KeyWildM:=KeyW;
            KeyFilter:=KeyF;

            HasScroll:=(Fnum=MLocF);

            If (HasScroll) then
              SCMax:=4;
          end;

          PopUpList.CreateOwnList(MULCtrlO,Fnum,SKeypath,Key2F,KLen,78,CFilters);

        except

          PopUpList.Free;
          PopUpList:=Nil;

        end;

      end {IF Advance find ok..}
      else
      Begin
        {$IFNDEF EDLL}
         {$IFNDEF OLE}
          {$IFNDEF RW}
           {$IFNDEF ENDV}
            {$IFNDEF XO}
            {$IFNDEF EBAD}
             {$IFDEF SOP}
               If (FNum=MLocF) then  {* On auto find, link to stock record... *}
                 With MLocCtrl^.sdbStkRec do
                   LinksdbStk(SdStkFolio,0);
             {$ENDIF}
            {$ENDIF}
           {$ENDIF}
           {$ENDIF}
          {$ENDIF}
         {$ENDIF}
        {$ENDIF}
      end;



    Except

       MULCtrlO.Free;
       MULCtrlO:=Nil;
    end;

  end; {Proc..}


  { ================ Function to Find an approximate match via list =========== }

  Function GetsdbStock(AOWner   :  TComponent;
                       Want     :  Str20;
                       SuppFilt :  Str10;
                   Var Found    :  Str20;
                   Var sdbStkL  :  LongInt;
                       Mode     :  Integer;
                       iIndexNo : Integer = -1)  :  Boolean;

  Var
    RecFind   :  ^TStockFind;
    LenSCode  :  Byte;

    WithSupF,
    UseAltdb,
    PrevHState,
    UseWildCard
              :  Boolean;

    SFnum,
    SKeyPath  :  Integer;

    KeyFilter,
    KeyWildM  :  Str255;

    RecFilters
              :  FilterType;
    KeyRef    :  Str255;

  Begin
    UseWildCard:=BOff;

    WithSupF:=BOff; UseAltdb:=BOff;

    SKeyPath:=StkCodeK;
    SFnum:=StockF;

    KeyFilter:='';

    Blank(RecFilters,Sizeof(RecFilters));

    LenSCode:=Length(Want);

    If (LenSCode>0) then
    Begin

      UseWildCard:=((Want[1]=WildCha) and (Mode<>-1));

      If (UseWildCard) then
        Want:=Copy(Want,2,Pred(LenScode));

      If ((Want[1]=WildChQ) or (Want[1]=DescTrig) or (Want[1]=BarCTrig)
           {$IFDEF SOP} or (Want[1]=sdbTrig) or (Want[1]=supTrig) {$ENDIF} ) and (Mode<>-1) then
      Begin

        If (Want[1]=WildChQ) then
          SKeyPath:=StkAltK
        else
          If (Want[1]=DescTrig) then
            SKeyPath:=StkDescK
          else
            If (Want[1]=BarCTrig) then
              SKeyPath:=StkBarCK
            {$IFDEF SOP}
            else
              If (Want[1]=sdbTrig) or (Want[1]=SupTrig) then
              Begin
                SKeyPath:=MLK;
                UseAltdb:=BOn;
                WithSupF:=(Want[1]=SupTrig);
              end;

            {$ELSE}

              ;

            {$ENDIF}


        If (Not UseWildCard) then
          Want:=Copy(Want,2,Pred(LenScode));
      end
    end;

    KeyRef:=UpCaseStr(Want);

    {$IFDEF TRADE}
      if iIndexNo = 10 then begin {alternative supplier code database}
        SKeyPath:=MLK;
        UseAltdb:=BOn;
        WithSupF:=(Want[1]=SupTrig);
      end;{if}
    {$ENDIF}


    If (Mode<>-1) then
    Begin
      If (UseWildCard) then
      Begin
        RecFilters[1,1]:=NdxWeight;
        KeyWildM:=KeyRef;
        KeyRef:='';
      end
      else
        KeyRef:=Strip('B',[#32],KeyRef);

      {$IFDEF SOP}

        If (UseAltdb) then
          KeyRef:=PartCCKey(NoteTCode,NoteCCode)+KeyRef;
      {$ENDIF}


      If (UseAltdb) then
        SFnum:=MLocF
      else
        SFnum:=StockF;

      Case Mode of
        0,3
           :  Begin                     { -- Exclude G types, Include P & D & M types only -- }
                                        { -- Mode 3 exclude delisted types in addition -- }
                RecFilters[1+Ord(UseWildCard),1]:=StkGrpCode;

                If (Mode=3) then
                  RecFilters[2+Ord(UseWildCard),1]:=StkDListCode;

                {$IFDEF SOP}
                  If (WithSupF) then
                    KeyFilter:=SuppFilt;
                {$ENDIF}

              end;

        1  :  RecFilters[1,0]:=StkGrpCode;  { -- Include only H types -- }

        2  :  RecFilters[1,0]:=StkBillCode;  { -- Include only M types -- }

        4  :  RecFilters[1+Ord(UseWildCard),1]:=StkDListCode; { -- Exclude de-listed -- }

        99 :  ;                         { -- Include All -- }
      end; {Case..}

    end;

    LenSCode:=Length(KeyRef);

    {$IFDEF TRADE}
      if (iIndexNo = -1) or (iIndexNo = 0) or (iIndexNo = 10) then New(RecFind,Create(AOwner,SFNum,SKeyPath,KeyRef
      ,LenSCode,Mode,UseWildCard,KeyWildM,KeyFilter, RecFilters))
      else begin
        New(RecFind,Create(AOwner,SFNum,iIndexNo,KeyRef,LenSCode,Mode,UseWildCard,KeyWildM
        ,KeyFilter, RecFilters));
      end;{if}
    {$ELSE}
      New(RecFind,Create(AOwner,SFNum,SKeyPath,KeyRef,LenSCode,Mode,UseWildCard,KeyWildM,KeyFilter, RecFilters));
    {$ENDIF}

    Try
      Result:=RecFind^.AdvanceFind;

      If (Not Result) and (Mode<>-1) then
      With RecFind^.PopUpList do
      Begin
        ListPFix:='K';

        Caption:='Stock '+Caption;

        If (SKeyPath=StkAltK) then
          ListCol1Lab.Caption:='Alternative Code'
        else
          ListCol1Lab.Caption:='Code';

        ListCol2Lab.Caption:='Description';

        SetAllowHotKey(BOff,PrevHState);

        Set_BackThreadMVisible(BOn);

        ShowModal;

        Set_BackThreadMVisible(BOff);

        SetAllowHotKey(BOn,PrevHState);

        Result:=FFoundOk;

        If (Result) then
        Begin
          Found:=Stock.StockCode;

          {$IFDEF SOP}
            With MLocCtrl^.sdbStkRec do
            If (SFnum=MLocF) and (sdStkFolio=Stock.StockFolio) and (UseAltdb) then
              SdbStkL:=SdFolio;
          {$ENDIF}
        end;

      end
      else
        If (Result) then
        Begin
          Found:=Stock.StockCode;

          {$IFDEF SOP}
            With MLocCtrl^.sdbStkRec do
            If (SFnum=MLocF) and (sdStkFolio=Stock.StockFolio) and (UseAltdb) then
              SdbStkL:=SdFolio;
          {$ENDIF}
        end;

    finally

      Dispose(RecFind,Destroy);

    end;


  end; {Func..}


{  Function GetStock(AOWner :  TComponent;
                    Want   :  Str20;
                Var Found  :  Str20;
                    Mode   :  Integer)  :  Boolean;}

  Function GetStock(AOWner :  TComponent;
                    Want   :  Str20;
                Var Found  :  Str20;
                    Mode   :  Integer;
                    iIndexNo : Integer = -1)  :  Boolean;
  Var
    sdbFolio  :  LongInt;

  Begin
    sdbFolio:=0;

    Result:=GetsdbStock(AOwner,Want,'',Found,sdbFolio,Mode, iIndexNo);

  end;

  {$IFNDEF OLE }
    {.$IFDEF SOP}

      { ============ TMLFList Methods ================= }



      Function TMLFList.SetCheckKey  :  Str255;


      Var
        DumStr  :  Str255;

      Begin
        FillChar(DumStr,Sizeof(DumStr),0);

        With MLocCtrl^,MLocLoc do
          Case KeyPath of
            MLK       :  DumStr:=FullCCKey(RecPfix,SubType,loCode);
            MLSecK    :  DumStr:=PartCCKey(RecPfix,SubType)+loName;
          end; {Case..}

        SetCheckKey:=DumStr;
      end;


      Function TMLFList.StkMatchWCard(MLocR :  MLocRec)  :  Char;

      Var
        TmpBo,
        FOk    :  Boolean;
        TChr   :  Char;
        TMode  :  Byte;

        GenStr,
        WildMatch
               :  Str255;

      Begin

        TmpBO:=BOff;
        TMode:=0;

        Blank(WildMatch,Sizeof(WildMatch));

        FOk:=(Not UseWildCard);

        If (Not FOk) then
        With MLocR.MLocLoc do
        Begin
          TMode:=(1*Ord(KeyWildM[1]=#32))+(2*Ord(KeyWildM[1]=DescTrig))+(3*Ord(KeyWildM[1]=WildChQ))+(4*Ord(KeyWildM[1]=WildCha));

          {TMode:=(1*Ord(KeyWildM[1] in ['0'..'9']))+(2*Ord(KeyWildM[1] In ['A'..'z']))+(3*Ord(KeyWildM[1]=WildChQ))+(4*Ord(KeyWildM[1]=WildCha));}

          If (TMode>0) then
          Begin
            If (Length(KeyWildM)>1) then
              WildMatch:=Copy(KeyWildM,2,Pred(Length(KeyWildM)))
            else
              FOk:=BOn;
          end
          else
            WildMatch:=KeyWildM;

          If (WildMatch<>'') or (TMode=0) then
          Case TMode of

            0,1
               :  FOk:=(Match_Glob(Sizeof(loCode),WildMatch,loCode,TmpBo));
            2  :  FOk:=(Match_Glob(Sizeof(loName),WildMatch,loName,TmpBo));
            {3  :  FOk:=(Match_Glob(Sizeof(AltCode),WMatch,Altcode,TmpBo));}
            4  :  FOk:=(Match_Glob(Sizeof(MLocR),WildMatch,MLocR,TmpBo));

            else  FOk:=BOff;


          end; {Case..}



        end; {With..}

        If (FOk) then
          TChr:=#0
        else
          TChr:=NdxWeight;

        StkMatchWCard:=TChr;

      end;


      Function TMLFList.SetFilter  :  Str255;

      Begin

        Result:=StkMatchWCard(MLocCtrl^);

      end;


      Function TMLFList.OutSLLine(Col  :  Byte)  :  Str255;

      Var
        L        :  Integer;
        TStkLoc  :  MStkLocType;
        Dnum     :  Double;
        SCode    :  Str20;

      Begin
        With MLocCtrl^, MLocLoc, TStkLoc do
        Begin

          Case Col of
             0  :  Result:=dbFormatName(loCode,loName);

             2  :  Begin
                     If (Is_FullStkCode(ThisStkCode)) then
                       SCode:=ThisStkCode
                     else
                       SCode:=Stock.StockCode;

                     If (Stock.StockCode<>SCode) then
                       Global_GetMainRec(StockF,SCode);

                     {$IFNDEF EDLL}
                     {$IFNDEF RW}
                     {$IFNDEF EBAD}
                     If LinkMLoc_Stock(loCode,SCode,TStkLoc) then;
                     {$ENDIF}
                     {$ENDIF}
                     {$ENDIF}

                     Dnum:=CaseQty(Stock,lsQtyInStock);

                     Result:=FormatFloat(GenQtyMask,Dnum);
                   end;

             3  :  Begin
                     {$IFNDEF EDLL}
                     {$IFNDEF RW}
                     {$IFNDEF EBAD}
                     Dnum:=CaseQty(Stock,FreeMLocStock(TStkLoc));
                     {$ENDIF}
                     {$ENDIF}
                     {$ENDIF}

                     Result:=FormatFloat(GenQtyMask,Dnum);
                   end;
             4  :  Begin
                     Dnum:=CaseQty(Stock,lsQtyOnOrder);

                     Result:=FormatFloat(GenQtyMask,Dnum);
                   end;


             else
                   Result:='';
           end; {Case..}


         end; {With..}
      end;



      { ========== Generic Function to Return Formatted Display for List ======= }

      Function TMLFList.OutLine(Col  :  Byte)  :  Str255;

      Begin
        Case DisplayMode of
          77  :  Result:=OutSLLine(Col);

          else   With MLocCtrl^.MLocLoc do
                 Case Col of
                   0  :  OutLine:=loCode;
                   1  :  OutLine:=loName;
                 end; {Case..}
        end; {Case..}
      end;




      { ============ TNom Find Methods ================= }



      Destructor TMLFFind.Destroy;

      Begin

        MULCtrlO.Destroy;

        If (PopUpList<>Nil) then
          PopUpList.Free;

      end;

      Constructor TMLFFind.Create(AOwner   :  TComponent;
                                  Fnum,
                                  SKeyPath :  Integer;
                                  Key2F    :  Str255;
                                  KLen     :  Integer;
                                  XMode    :  Integer;
                                  UseWC    :  Boolean;
                                  KeyW     :  Str255;
                                  SCode    :  Str20;
                                  CFilters :  FilterType);

      Begin

        PopUpList:=Nil;
        AdvanceFind:=BOff;

        MULCtrlO:=TMLFList.Create(AOwner);

        Try
          With MULCtrlO do
          Begin
            Filter:=CFilters;

            UseWildCard:=UseWC;
            KeyWildM:=KeyW;


            StartList(Fnum,SKeyPath,Key2F,'',Key2F,KLen,BOn);

            AdvanceFind:=GetCode(XMode);
          end;

          If (Not AdvanceFind) and (XMode<>-1) then
          Begin
            MULCtrlO.Destroy;

            PopUpList:=TPOPUpList.Create(AOwner);

            Try

              MULCtrlO:=TMLFList.Create(PopUpList);

              MULCtrlO.ThisStkCode:=SCode;

              PopUpList.CreateOwnList(MULCtrlO,Fnum,SKeypath,Key2F,KLen,XMode,CFilters);

              With MULCtrlO do
              Begin
                UseWildCard:=UseWC;
                KeyWildM:=KeyW;
              end;

            except

              PopUpList.Free;
              PopUpList:=Nil;

            end;

          end {IF Advance find ok..}
          else
          Begin



          end;

        Except

           MULCtrlO.Free;
           MULCtrlO:=Nil;
        end;

      end; {Proc..}


      { ================ Function to Find an approximate match via list =========== }


      Function GetMLoc(AOWner :  TComponent;
                       Want   :  Str10;
                   Var Found  :  Str10;
                       SCode  :  Str20;
                       Mode   :  Integer)  :  Boolean;



      Var
        RecFind   :  ^TMLFFind;
        LenSCode  :  Byte;

        PrevHState,
        UseWildCard
                  :  Boolean;

        SKeyPath  :  Integer;

        KeyWildM  :  Str255;

        RecFilters
                  :  FilterType;
        KeyRef    :  Str255;

      Begin

        SKeyPath:=MLK;

        Blank(RecFilters,Sizeof(RecFilters));

        LenSCode:=Length(Want);

        UseWildCard:=((Want[1]=WildCha) and (Mode<>-1));

        If (UseWildCard) then
          Want:=Copy(Want,2,Pred(LenScode));

        LenSCode:=Length(Want);

        If (LenSCode>0) and (Want[1]=DescTrig) and (Mode<>-1) then
        Begin

          SKeyPath:=MLSeck;

          KeyRef:=PartCCKey(CostCCode,CSubCode[BOn])+UpCaseStr(Strip('B',[#32],Copy(Want,2,Pred(LenScode))));
        end
        else
        Begin

          If (Mode<>-1) then
            KeyRef:=PartCCKey(CostCCode,CSubCode[BOn])+UpCaseStr(Strip('B',[#32],Want))
          else
            KeyRef:=FullCCKey(CostCCode,CSubCode[BOn],Want);
        end;


        If (Mode<>-1) then
        Begin
          If (UseWildCard) then
          Begin
            RecFilters[1,1]:=NdxWeight;
            KeyWildM:=Want;
            KeyRef:=PartCCKey(CostCCode,CSubCode[BOn]);
          end;
        end;

        LenSCode:=Length(KeyRef);

        New(RecFind,Create(AOwner,MLocF,SKeyPath,KeyRef,LenSCode,Mode,UseWildCard,KeyWildM
        ,SCode,RecFilters));

        Try
          Result:=RecFind^.AdvanceFind;

          If (Not Result) and (Mode<>-1) then
          With RecFind^.PopUpList do
          Begin
            ListPFix:='M';

            Caption:='Multi Location '+Caption;

            If (Mode<>77) then
            Begin
              ListCol1Lab.Caption:='Code';
              ListCol2Lab.Caption:='Name';
            end
            else
              ListCol1Lab.Caption:='Location';

            SetAllowHotKey(BOff,PrevHState);

            Set_BackThreadMVisible(BOn);

            ShowModal;

            Set_BackThreadMVisible(BOff);

            SetAllowHotKey(BOn,PrevHState);

            Result:=FFoundOk;

            If (Result) then
              Found:=MLocCtrl^.MLocLoc.loCode;
          end
          else
            If (Result) then
              Found:=MLocCtrl^.MLocLoc.loCode;

        finally

          Dispose(RecFind,Destroy);

        end;


      end; {Func..}

      {-----------------------}
    {.$ENDIF}
  {$ENDIF}
{$ENDIF}


end.

