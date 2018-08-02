unit SelDataO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FuncList, StdCtrls, TEditVal, Menus, ExtCtrls, SBSPanel,
  GlobVar,       // Exchequer Global Const, Type & Var
  VarConst,      // Exchequer Global Const, Type & Var
  VarRec2U,      // Additional Exchequer Global Const, Type & Var
  SBSComp,       // Btrieve List Routines
  SupListU,      // Btrieve List Classes (TGenList)
  SBSComp2,      // Routines for Loading/Saving Window Colours/Co-Ordinates
  BTSupU3;       // Misc Global Record Structures  (TReturnCtrlRec)

type
  TSDCustList  =  Class(TGenList)
    Function SetCheckKey  :  Str255; Override;

    Function StkMatchWCard(CustR   :  CustRec)  :  Char;

    Function SetFilter  :  Str255; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Function SetColCaption  :  Str255; Override;

    Function GetCustBal(Const CCode : Str10; Const BalPr, BalYr : Byte) : Double;
  End; { TSDCustList }

  //------------------------------

  TSDGLList  =  Class(TGenList)
    Function SetCheckKey  :  Str255; Override;

    Function StkMatchWCard(NomR   :  NominalRec)  :  Char;

    Function SetFilter  :  Str255; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;
  End; { TSDGLList }

  //------------------------------

  TSDStkList  =  Class(TGenList)
    Function SetCheckKey  :  Str255; Override;

    Function StkMatchWCard(StockR : StockRec): Char;

    Function SetFilter  :  Str255; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;
  End; { TSDStkList }

  //------------------------------

  TSDCCDpList  =  Class(TGenList)
    Function SetCheckKey  :  Str255; Override;

    Function StkMatchWCard (PassWordR : PassWordRec) : Char;

    Function SetFilter  :  Str255; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;
  End; { TSDCCDpList }

  //------------------------------

  TSDLocList  =  Class(TGenList)
    Function SetCheckKey  :  Str255; Override;

    Function StkMatchWCard (MLocR :  MLocRec) : Char;

    Function SetFilter  :  Str255; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;
  End; { TSDLocList }

  //------------------------------

  TSDJobList = Class(TGenList)
    function SetCheckKey: Str255; override;
    function StkMatchWCard(JobR: JobRecType): Char;
    function SetFilter: Str255; override;
    function OutLine(Col: Byte): Str255; override;
  End; { TSDJobList }

  //------------------------------

  TSDEmployeeList = Class(TGenList)
    function SetCheckKey: Str255; override;
    function StkMatchWCard(JobMiscR: JobMiscRec): Char;
    function SetFilter: Str255; override;
    function OutLine(Col: Byte): Str255; override;
  End; { TSDemployeeList }

  //------------------------------

  TSDAnalysisList = Class(TGenList)
    function SetCheckKey: Str255; override;
    function StkMatchWCard(JobMiscR: JobMiscRec): Char;
    function SetFilter: Str255; override;
    function OutLine(Col: Byte): Str255; override;
  End; { TSDemployeeList }

  //------------------------------

  TSDJobTypeList = Class(TGenList)
    function SetCheckKey: Str255; override;
    function StkMatchWCard(JobMiscR: JobMiscRec): Char;
    function SetFilter: Str255; override;
    function OutLine(Col: Byte): Str255; override;
  End; { TSDemployeeList }

  //------------------------------

implementation

Uses ETStrU,
     ETMiscU,
     BTSupU1,
     BTKeys1U,
     PWarnU;

//=========================================================================

Function TSDCustList.SetCheckKey  :  Str255;
Var
  DumStr  :  Str255;
Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  Case Keypath of
    CustCodeK  :  DumStr := Cust.CustCode;
    CustCompK  :  DumStr := Cust.Company;
    CustCntyK  :  DumStr := Cust.CustSupp + Cust.VATRegNo + Cust.CustCode; {NF : 19/9/00}
    CustTelK   :  DumStr := Cust.Phone;
    CustAltK   :  DumStr := Cust.CustCode2;
    ATCodeK    :  DumStr := Cust.CustSupp+Cust.CustCode;
    ATCompK    :  DumStr := Cust.CustSupp+Cust.Company;
    ATAltK     :  DumStr := Cust.CustSupp+Cust.CustCode2;
    CustPCodeK :  DumStr := Cust.PostCode;
    CustRCodeK :  DumStr := Cust.RefNo;
    CustInvToK :  DumStr := Cust.SOPInvCode;
    CustEmailK :  DumStr := Cust.CustSupp+Cust.EmailAddr;
  end;

  SetCheckKey:=DumStr;
end;

//-------------------------------------------------------------------------

// Function to Match Stock based on wild card
Function TSDCustList.StkMatchWCard (CustR : CustRec) : Char;
Var
  TmpBo,
  FOk       : Boolean;
  TChr      : Char;
  TMode     : Byte;
  WildMatch : Str255;
Begin { StkMatchWCard }
  TmpBO:=BOff;

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

  StkMatchWCard := TChr;
End; { StkMatchWCard }

//-------------------------------------------------------------------------

Function TSDCustList.SetFilter : Str255;
Begin { SetFilter }
  Result := StkMatchWCard(Cust);
End; { SetFilter }

//-------------------------------------------------------------------------

// Generic Function to Return Formatted Display for List
Function TSDCustList.OutLine (Col : Byte)  :  Str255;
Var
  Dnum  :  Double;
Begin { OutLine }
  With Cust do
    Case Col of
      0  : OutLine:=CustCode;
      1  : OutLine:=Company;
      2  : Begin
             {$B-}
             If (Not IsACust(CustSupp)) Or PChkAllowed_In(404) Then
               Dnum := GetCustBal(CustCode, Syss.CPr, Syss.CYr)
             Else
               Dnum := 0.0;

             OutLine:=FormatFloat(GenRealMask,Dnum);
           End;
    End; { Case Col }
End; { OutLine }

//-------------------------------------------------------------------------

Function TSDCustList.SetColCaption : Str255;
Begin { SetColCaption }
  Case SCCount of
    0  :  Result:='Name';
    1  :  Result:='Alt Code';
    2..6
       :  Result:='Address';
    7  :  Result:='Post Code';
    8  :  Result:='Tel/Fax/Mbl';
    9  :  Result:='Contact Name';
  end; {Case..}
End; { SetColCaption }

//-------------------------------------------------------------------------

Function TSDCustList.GetCustBal (Const CCode : Str10; Const BalPr, BalYr : Byte) : Double;
Var
  Sales, Purch, Cleared : Double;
Begin { GetCustBal }
  Result:=Profit_to_Date(CustHistCde,CCode,0,BalYr,BalPr,Purch,Sales,Cleared,BOn);
End; { GetCustBal }

//=========================================================================

function TSDGLList.OutLine(Col: Byte): Str255;
begin
  Case Col of
    0  : OutLine := Form_Int(Nom.NomCode,0);
    1  : OutLine := Nom.Desc;
    2  : OutLine := Nom.AltCode;
  End; { Case Col }
end;

//-------------------------------------------------------------------------

function TSDGLList.SetCheckKey: Str255;
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

//-------------------------------------------------------------------------

function TSDGLList.SetFilter: Str255;
begin
  Result:=StkMatchWCard(Nom);
end;

//-------------------------------------------------------------------------

function TSDGLList.StkMatchWCard (NomR: NominalRec) : Char;
Var
  TmpBo, FOk{, WCMFail} : Boolean;
  TChr                  : Char;
  TMode                 : Byte;
  GenStr, WildMatch     : Str255;
Begin
  TmpBO:=BOff;
  //WCMFail:=BOFF;

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
      End { If (TMode>2) }
      Else
        WildMatch:=KeyWildM;

      GenStr:=Form_Int(NomR.NomCode,0);

      If (WildMatch<>'') or (TMode<3) then
        Case TMode of
          0, 1 : FOk := Match_Glob (Sizeof(GenStr),  WildMatch, GenStr, TmpBo);
          2    : FOk := Match_Glob (Sizeof(Desc),    WildMatch, Desc,   TmpBo);
          3    : FOk := Match_Glob (Sizeof(AltCode), WildMatch, Altcode,TmpBo);
          4    : FOk := Match_Glob (Sizeof(NomR),    WildMatch, NomR,   TmpBo);
        else
          FOk:=BOff;
        end; {Case..}

      //WCMFail:=Not FOK;
    end; {With..}

  If (FOk) then
    TChr:=NomR.NomType
  else
    TChr:=NdxWeight;

  StkMatchWCard:=TChr;
end;

//=========================================================================

function TSDStkList.OutLine(Col: Byte): Str255;
begin
  With Stock do
    Case Col of
      0  :  Case Keypath of
              StkAltK  :  Result:=AltCode;
              else        Result:=StockCode;
            end;

      1  :  Result:=Desc[1];

      2  :  Result:=AltCode;
    End; {Case..}
end;

//-------------------------------------------------------------------------

function TSDStkList.SetCheckKey: Str255;
Var
  DumStr  :  Str255;
Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  Case Keypath Of
    StkCodeK : DumStr := Stock.StockCode;
    StkDescK : DumStr := Stock.Desc[1];
    StkAltK  : DumStr := Stock.AltCode;
    StkBarCK : DumStr := Stock.Barcode;
  End; { Case Keypath }

  SetCheckKey:=DumStr;
end;

//-------------------------------------------------------------------------

function TSDStkList.SetFilter: Str255;
begin
  Result := StkMatchWCard(Stock);
end;

//-------------------------------------------------------------------------

function TSDStkList.StkMatchWCard(StockR: StockRec): Char;
Var
  TmpBo,
  FOk    : Boolean;
  TChr   : Char;
  TMode  : Byte;
  WMatch : Str255;
Begin
  TmpBO:=BOff;

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

//=========================================================================

function TSDCCDpList.OutLine (Col : Byte) : Str255;
begin
  With Password, CostCtrRec do
    Case Col of
      0  : OutLine := PCostC;
      1  : OutLine := CCDesc;
    Else
      Result := '';
    End; { Case Col }
end;

//-------------------------------------------------------------------------

function TSDCCDpList.SetCheckKey: Str255;
Var
  DumStr  :  Str255;
Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With Password, CostCtrRec do
    Case KeyPath of
      PWK       : DumStr := FullCCKey (RecPfix, SubType, PCostC);
      HelpNdxK  : DumStr := PartCCKey (RecPfix, SubType) + CCDesc;
    End; { Case KeyPath }

  SetCheckKey:=DumStr;
end;

//-------------------------------------------------------------------------

function TSDCCDpList.SetFilter: Str255;
begin
  Result:=StkMatchWCard (PassWord);
end;

//-------------------------------------------------------------------------

function TSDCCDpList.StkMatchWCard (PassWordR : PassWordRec) : Char;
Var
  TmpBo, FOk : Boolean;
  TChr       : Char;
  TMode      : Byte;
  WildMatch  : Str255;
Begin
  TmpBO:=BOff;

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

//=========================================================================

function TSDLocList.OutLine(Col: Byte): Str255;
begin
  With MLocCtrl^.MLocLoc do
    Case Col of
      0  : OutLine := loCode;
      1  : OutLine := loName;
      2  : Begin
             Result := Trim (loAddr[1]);

             If (Result <> '') And (Trim (loAddr[2]) <> '') Then
               Result := Result + ', ' + Trim (loAddr[2]);
           End;
    Else
      Result := '';
    End; { Case Col }
end;

//-------------------------------------------------------------------------

function TSDLocList.SetCheckKey: Str255;
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

//-------------------------------------------------------------------------

function TSDLocList.SetFilter: Str255;
begin
  Result:=StkMatchWCard(MLocCtrl^);
end;

//-------------------------------------------------------------------------

function TSDLocList.StkMatchWCard(MLocR :  MLocRec): Char;
Var
  TmpBo, FOk  : Boolean;
  TChr        : Char;
  TMode       : Byte;
  WildMatch   : Str255;
Begin
  TmpBO:=BOff;

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
          //WildMatch:=Copy(KeyWildM,4,Pred(Length(KeyWildM)))
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

//=========================================================================

{ TSDJobList }

function TSDJobList.OutLine(Col: Byte): Str255;
begin
  case Col of
    0: Result := JobRec.JobCode;
    1: Result := JobRec.JobDesc;
  else
    Result := '';
  end;
end;

//-------------------------------------------------------------------------

function TSDJobList.SetCheckKey: Str255;
begin
  FillChar(Result, Sizeof(Result), 0);
  case Keypath of
    JobCodeK  : Result := JobRec.JobCode;
    JobDescK  : Result := JobRec.JobDesc;
    JobAltK   : Result := JobRec.JobAltCode;
  end;
end;

//-------------------------------------------------------------------------

function TSDJobList.SetFilter: Str255;
begin
  Result := StkMatchWCard(JobRec^);
end;

//-------------------------------------------------------------------------

function TSDJobList.StkMatchWCard(JobR: JobRecType): Char;
var
  TmpBo, FOk : Boolean;
  TChr       : Char;
  TMode      : Byte;
  WildMatch  : Str255;
begin
  TmpBO := BOff;

  Blank(WildMatch, Sizeof(WildMatch));

  FOk := (not UseWildCard);

  if (not FOk) then
    with JobR do
    begin
      TMode := (1 * Ord(KeyWildM[1] = #32)) +
               (2 * Ord(KeyWildM[1] = '/')) +
               (3 * Ord(KeyWildM[1] = WildChQ)) +
               (4 * Ord(KeyWildM[1] = WildCha));

      If (TMode > 0) then
      Begin
        If (Length(KeyWildM)>1) then
          WildMatch := Strip('L',
                             [WildCha],
                             Copy(KeyWildM, 2, Pred(Length(KeyWildM))))
        else
          FOk := BOn;
      end
      else
        WildMatch := KeyWildM;

      if (WildMatch <> '') or (TMode < 3) then
        case TMode of
          0, 1 : FOk := Match_Glob(Sizeof(JobCode),    WildMatch, JobCode,    TmpBo);
          2    : FOk := Match_Glob(Sizeof(JobDesc),    WildMatch, JobDesc ,   TmpBo);
          3    : FOk := Match_Glob(Sizeof(JobAltCode), WildMatch, JobAltCode, TmpBo);
          4    : FOk := Match_Glob(Sizeof(JobR),       WildMatch, JobR,       TmpBo);
        else
          FOk:=BOff;
        end; {Case..}

    end; {With..}

  if (FOk) then
    TChr := 'J'
  else
    TChr := NdxWeight;

  Result := TChr;
end;

//=========================================================================

{ TSDEmployeeList }

function TSDEmployeeList.OutLine(Col: Byte): Str255;
begin
  case Col of
    0: Result := JobMisc.EmplRec.EmpCode;
    1: Result := JobMisc.EmplRec.EmpName;
    2: Result := JobMisc.EmplRec.Supplier;
  else
    Result := '';
  end;
end;

function TSDEmployeeList.SetCheckKey: Str255;
begin
  FillChar(Result, Sizeof(Result), 0);
  case Keypath of
    JMK    : Result := JARCode + JAECode + FullEmpCode(JobMisc.EmplRec.EmpCode);
    JMSecK : Result := JARCode + JAECode + JobMisc.EmplRec.Surname;
  end;
end;

function TSDEmployeeList.SetFilter: Str255;
begin
  Result := StkMatchWCard(JobMisc^);
end;

function TSDEmployeeList.StkMatchWCard(JobMiscR: JobMiscRec): Char;
var
  TmpBo, FOk : Boolean;
  TChr       : Char;
  TMode      : Byte;
  WildMatch  : Str255;
begin
  TmpBO := BOff;

  Blank(WildMatch, Sizeof(WildMatch));

  FOk := (not UseWildCard);

  if (not FOk) then
    with JobMiscR do
    begin
      if (RecPfix = 'J') and
         (SubType = 'E') then
      begin
        TMode := (1 * Ord(KeyWildM[1] = #32)) +
                 (2 * Ord(KeyWildM[1] = '/')) +
                 (3 * Ord(KeyWildM[1] = WildChQ)) +
                 (4 * Ord(KeyWildM[1] = WildCha));

        If (TMode > 0) then
        Begin
          if (Length(KeyWildM)>1) then
          begin
            WildMatch := Strip('L',
                               [WildCha],
                               Copy(KeyWildM, 2, Pred(Length(KeyWildM))));
            if (Copy(WildMatch, 1, 2) = JARCode + JAECode) then
              WildMatch := Copy(WildMatch, 3, Length(WildMatch));
          end
          else
            FOk := BOn;
        end
        else
          WildMatch := KeyWildM;

        if (WildMatch <> '') or (TMode < 3) then
          case TMode of
            0, 1 : FOk := Match_Glob(Sizeof(EmplRec.EmpCode), WildMatch, EmplRec.EmpCode ,    TmpBo);
            2    : FOk := Match_Glob(Sizeof(EmplRec.Surname), WildMatch, EmplRec.Surname,   TmpBo);
  {          3    : FOk := Match_Glob(Sizeof(JobAltCode), WildMatch, JobAltCode, TmpBo); }
            4    : FOk := Match_Glob(Sizeof(EmplRec),         WildMatch, EmplRec, TmpBo);
          else
            FOk := BOff;
          end; {Case..}
      end { if (RecPfix = 'J'... }
      else
        FOk := BOff;

    end; {With..}

  if (FOk) then
    TChr := 'E'
  else
    TChr := NdxWeight;

  Result := TChr;
end;

{ TSDAnalysisList }

function TSDAnalysisList.OutLine(Col: Byte): Str255;
begin
  case Col of
    0: Result := JobMisc.JobAnalRec.JAnalCode;
    1: Result := JobMisc.JobAnalRec.JAnalName;
  else
    Result := '';
  end;
end;

function TSDAnalysisList.SetCheckKey: Str255;
begin
  FillChar(Result, Sizeof(Result), 0);
  case Keypath of
    JMK    : Result := FullJAKey(JARCode, JAACode, JobMisc.JobAnalRec.JAnalCode);
    JMSecK : Result := PartCCKey(JARCode, JAACode) + JobMisc.JobAnalRec.JANameCode;
  end;
end;

function TSDAnalysisList.SetFilter: Str255;
begin
  Result := StkMatchWCard(JobMisc^);
end;

function TSDAnalysisList.StkMatchWCard(JobMiscR: JobMiscRec): Char;
var
  TmpBo, FOk : Boolean;
  TChr       : Char;
  TMode      : Byte;
  WildMatch  : Str255;
begin
  TmpBO := BOff;

  Blank(WildMatch, Sizeof(WildMatch));

  FOk := (not UseWildCard);

  if (not FOk) then
    with JobMiscR do
    begin
      if (RecPfix = 'J') and
         (SubType = 'A') then
      begin
        TMode := (1 * Ord(KeyWildM[1] = #32)) +
                 (2 * Ord(KeyWildM[1] = '/')) +
                 (3 * Ord(KeyWildM[1] = WildChQ)) +
                 (4 * Ord(KeyWildM[1] = WildCha));

        If (TMode > 0) then
        Begin
          If (Length(KeyWildM)>1) then
          begin
            WildMatch := Strip('L',
                               [WildCha],
                               Copy(KeyWildM, 2, Pred(Length(KeyWildM))));
            if (Copy(WildMatch, 1, 2) = JARCode + JAACode) then
              WildMatch := Copy(WildMatch, 3, Length(WildMatch));
          end
          else
            FOk := BOn;
        end
        else
          WildMatch := KeyWildM;

        if (WildMatch <> '') or (TMode < 3) then
          case TMode of
            0, 1 : FOk := Match_Glob(Sizeof(JobAnalRec.JAnalCode), WildMatch, JobAnalRec.JAnalCode, TmpBo);
            2    : FOk := Match_Glob(Sizeof(JobAnalRec.JAnalName), WildMatch, JobAnalRec.JAnalName, TmpBo);
  {          3    : FOk := Match_Glob(Sizeof(JobAltCode), WildMatch, JobAltCode, TmpBo); }
            4    : FOk := Match_Glob(Sizeof(JobAnalRec),           WildMatch, JobAnalRec, TmpBo);
          else
            FOk:=BOff;
          end; {Case..}
      end { if (RefPFix = 'J'... }
      else
        FOk := BOff;

    end; {With..}

  if (FOk) then
    TChr := 'A'
  else
    TChr := NdxWeight;

  Result := TChr;
end;

{ TSDJobTypeList }

function TSDJobTypeList.OutLine(Col: Byte): Str255;
begin
  case Col of
    0: Result := JobMisc.JobTypeRec.JobType;
    1: Result := JobMisc.JobTypeRec.JTypeName;
  else
    Result := '';
  end;
end;

function TSDJobTypeList.SetCheckKey: Str255;
begin
  FillChar(Result, Sizeof(Result), 0);
  case Keypath of
    JMK    : Result := FullJAKey(JARCode, JATCode, JobMisc.JobTypeRec.JobType);
    JMSecK : Result := PartCCKey(JARCode, JATCode) + JobMisc.JobTypeRec.JTNameCode;
  end;
end;

function TSDJobTypeList.SetFilter: Str255;
begin
  Result := StkMatchWCard(JobMisc^);
end;

function TSDJobTypeList.StkMatchWCard(JobMiscR: JobMiscRec): Char;
var
  TmpBo, FOk : Boolean;
  TChr       : Char;
  TMode      : Byte;
  WildMatch  : Str255;
begin
  TmpBO := BOff;

  Blank(WildMatch, Sizeof(WildMatch));

  FOk := (not UseWildCard);

  if (not FOk) then
    with JobMiscR do
    begin
      if (RecPfix = 'J') and
         (SubType = 'T') then
      begin
        TMode := (1 * Ord(KeyWildM[1] = #32)) +
                 (2 * Ord(KeyWildM[1] = '/')) +
                 (3 * Ord(KeyWildM[1] = WildChQ)) +
                 (4 * Ord(KeyWildM[1] = WildCha));

        If (TMode > 0) then
        Begin
          If (Length(KeyWildM)>1) then
          begin
            WildMatch := Strip('L',
                               [WildCha],
                               Copy(KeyWildM, 2, Pred(Length(KeyWildM))));
            if (Copy(WildMatch, 1, 2) = JARCode + JATCode) then
              WildMatch := Copy(WildMatch, 3, Length(WildMatch));
          end
          else
            FOk := BOn;
        end
        else
          WildMatch := KeyWildM;

        if (WildMatch <> '') or (TMode < 3) then
          case TMode of
            0, 1 : FOk := Match_Glob(Sizeof(JobTypeRec.JobType), WildMatch, JobTypeRec.JobType, TmpBo);
            2    : FOk := Match_Glob(Sizeof(JobTypeRec.JTypeName), WildMatch, JobTypeRec.JTypeName, TmpBo);
  {          3    : FOk := Match_Glob(Sizeof(JobAltCode), WildMatch, JobAltCode, TmpBo); }
            4    : FOk := Match_Glob(Sizeof(JobTypeRec),           WildMatch, JobTypeRec, TmpBo);
          else
            FOk:=BOff;
          end; {Case..}
      end { if (RefPFix = 'J'... }
      else
        FOk := BOff;

    end; {With..}

  if (FOk) then
    TChr := 'J'
  else
    TChr := NdxWeight;

  Result := TChr;
end;

end.
