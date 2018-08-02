unit SelDataO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FuncList, StdCtrls, TEditVal, Menus, ExtCtrls, SBSPanel,
  GlobVar,       // Exchequer Global Const, Type & Var
  VarConst,      // Enterprise Global Const, Type & Var
  VarRec2U,      // Additional Enterprise Global Const, Type & Var
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

end.
