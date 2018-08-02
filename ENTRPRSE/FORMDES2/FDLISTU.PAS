unit FDlistu;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }



interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ExtCtrls,Forms,
  Globvar,VarConst,SBSComp,RwSupLiU;



type

  TDictList  =  Class(TRWGenList)

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;




  TDictFind  =  Object

    MULCtrlO    :  TDictList;
    PopUpList   :  TRWPopUpList;
    AdvanceFind :  Boolean;

    Destructor Destroy;
    Constructor Create(AOwner   :  TComponent;
                       Fnum,
                       SKeyPath :  Integer;
                       Key2F    :  Str255;
                       LenSCode :  Integer;
                       XMode    :  Integer;
                       UseWC    :  Boolean;
                       KeyW     :  Str255;
                       CFilters :  FilterType);


  end;

(*
  TRepList  =  Class(TRWGenList)

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;




  TRepFind  =  Object

    MULCtrlO    :  TRepList;
    PopUpList   :  TRWPopUpList;
    AdvanceFind :  Boolean;

    Destructor Destroy;
    Constructor Create(AOwner   :  TComponent;
                       Fnum,
                       SKeyPath :  Integer;
                       Key2F    :  Str255;
                       LenSCode :  Integer;
                       XMode    :  Integer;
                       UseWC    :  Boolean;
                       KeyW     :  Str255;
                       CFilters :  FilterType);


  end;
*)


Function GetDict(    AOWner              : TComponent;
                     Want                : Str20;
                 Var Found               : Str20;
                     Mode, ExVNo, FileNo : SmallInt) : Boolean;

(*
Function GetRep(    AOWner  : TComponent;
                    Want    : Str20;
                Var Found   : Str20;
                    Mode    : SmallInt) : Boolean;
*)

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  EtMiscU,
  SBSPanel,
  BtSupU1,
  BtKeys1U,
  DataDict,
  RpCommon;


{ ============ TDictList Methods ================= }
Function TDictList.SetCheckKey  :  Str255;
Var
  DumStr  :  Str255;
Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With DictRec^, DataXRefRec Do
    Case Keypath of
      DIK        : DumStr:=RecPFix + SubType + VarKey;
      {DISecK     : DumStr:=RecPFix + SubType + VarDesc;}
    End; { Case }

  SetCheckKey:=DumStr;
end;


Function TDictList.SetFilter  :  Str255;
Begin
  Result := '1';

  { need to try and get a X-reference record for this variable record }
  { return blank if not a valid field }
end;


{ ========== Generic Function to Return Formatted Display for List ======= }
Function TDictList.OutLine(Col  :  Byte)  :  Str255;
Const
  FNum    = DictF;
  KeyPath = DIK;
Var
  KeyS                : Str255;
  TmpStat, TmpRecAddr : LongInt;
  KP                  : Integer;
Begin
  Result := '';

  With DictRec^, DataVarRec do
    Case Col of
      0  : Result := VarName;
      1  : Result := VarDesc;
    End; { Case }
end;




{ ============ TCust Find Methods ================= }



Destructor TDictFind.Destroy;

Begin

  MULCtrlO.Destroy;

  If (PopUpList<>Nil) then
    PopUpList.Free;

end;

Constructor TDictFind.Create(AOwner   :  TComponent;
                             Fnum,
                             SKeyPath :  Integer;
                             Key2F    :  Str255;
                             LenSCode :  Integer;
                             XMode    :  Integer;
                             UseWC    :  Boolean;
                             KeyW     :  Str255;
                             CFilters :  FilterType);

Begin

  PopUpList:=Nil;
  AdvanceFind:=BOff;

  MULCtrlO:=TDictList.Create(AOwner);

  Try
    With MULCtrlO do Begin
      Filter:=CFilters;

      UseWildCard:=UseWC;
      KeyWildM:=KeyW;

      StartList(Fnum,SKeyPath,Key2F,'',Key2F,LenSCode,BOn);

      AdvanceFind:=GetCode(XMode);
    end;

    If (Not AdvanceFind) and (XMode<>-1) then
    Begin
      MULCtrlO.Destroy;

      PopUpList:=TRWPOPUpList.Create(AOwner);

      Try

        MULCtrlO:=TDictList.Create(PopUpList);

        With MULCtrlO do
        Begin
          UseWildCard:=UseWC;
          KeyWildM:=KeyW;
        end;

        PopUpList.CreateOwnList(MULCtrlO,Fnum,SKeypath,Key2F,LenSCode,CFilters);


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
Function GetDict(    AOWner              : TComponent;
                     Want                : Str20;
                 Var Found               : Str20;
                     Mode, ExVNo, FileNo : SmallInt) : Boolean;
Var
  PrevHState, UseWildCard : Boolean;
  DictFind    : ^TDictFind;
  LenSCode    : Byte;
  SKeyPath    : Integer;
  KeyWildM    : Str255;
  DictFilters : FilterType;
Begin
  UseWildCard:=BOff;

  SKeyPath:=DIK;

  Blank(DictFilters,Sizeof(DictFilters));
  DictFilters[1,0]:='1';           { Only want group headers }

  { Update for recpfix & subtype }
  {If (Mode<>-1) then
    Want := PartCCKey(DataDicCode,DataDicXRef) + Chr(ExVNo) + Chr(FileNo) + Want
  Else}
    Want := PartCCKey(DataDicCode,DataDicVar) + Want;
  LenSCode:=Length(Strip('R',[#0,#32],Want));

  New(DictFind,Create(AOwner,DictF,SKeyPath,Want,LenSCode,Mode,UseWildCard,KeyWildM,DictFilters));

  Try
    Result:=DictFind^.AdvanceFind;

    If (Not Result) and (Mode<>-1) then
      With DictFind^.PopUpList do Begin
        ListPFix:='D';

        {
        If (Mode<>99) then
          Caption:=TradeType[Bon]+' '+Caption;
        }

        ListCol1Lab.Caption:='Code';
        ListCol2Lab.Caption:='Description';

        {If (StartLookUp(LenSCode)) then}

        SetAllowHotKey(BOff,PrevHState);

          ShowModal;

        SetAllowHotKey(BOn,PrevHState);

        Result:=FFoundOk;

        If (Result) then
          Found:=DictRec.DataVarRec.VarName;
      End { With }
    Else
      If Result then
        {If (Mode<>-1) then
          Found:=DictRec.DataXRefRec.VarName
        Else}
          Found:=DictRec.DataVarRec.VarName
  finally
    Dispose(DictFind,Destroy);
  end;
end; {Func..}

(***
{ ============ TDictList Methods ================= }
Function TRepList.SetCheckKey  :  Str255;
Var
  DumStr  :  Str255;
Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With RepGenRecs^, ReportHed Do
    Case Keypath of
      RGK        : DumStr:=RecPFix + SubType + ReportKey;
      RGNdxK     : DumStr:=RecPFix + SubType + RepName;
    End; { Case }

  SetCheckKey:=DumStr;
end;


Function TRepList.SetFilter  :  Str255;
Begin
  With RepGenRecs^ Do
    If (RecPFix = ReportGenCode) And (SubType = RepHedTyp) Then
      Result := ReportHed.RepType
    Else
      Result := '?';
end;


{ ========== Generic Function to Return Formatted Display for List ======= }
Function TRepList.OutLine(Col  :  Byte)  :  Str255;
Begin
  Result := '';

  With RepGenRecs^, ReportHed do
    Case Col of
      0  : Result := RepName;
      1  : Result := RepDesc;
    end; {Case..}
end;




{ ============ TCust Find Methods ================= }



Destructor TRepFind.Destroy;

Begin

  MULCtrlO.Destroy;

  If (PopUpList<>Nil) then
    PopUpList.Free;

end;

Constructor TRepFind.Create(AOwner   :  TComponent;
                             Fnum,
                             SKeyPath :  Integer;
                             Key2F    :  Str255;
                             LenSCode :  Integer;
                             XMode    :  Integer;
                             UseWC    :  Boolean;
                             KeyW     :  Str255;
                             CFilters :  FilterType);

Begin

  PopUpList:=Nil;
  AdvanceFind:=BOff;

  MULCtrlO:=TRepList.Create(AOwner);

  Try
    With MULCtrlO do Begin
      Filter:=CFilters;

      UseWildCard:=UseWC;
      KeyWildM:=KeyW;

      StartList(Fnum,SKeyPath,Key2F,'',Key2F,LenSCode,BOn);

      AdvanceFind:=GetCode(XMode);
    end;

    If (Not AdvanceFind) and (XMode<>-1) then
    Begin
      MULCtrlO.Destroy;

      PopUpList:=TRWPOPUpList.Create(AOwner);

      Try

        MULCtrlO:=TRepList.Create(PopUpList);

        With MULCtrlO do
        Begin
          UseWildCard:=UseWC;
          KeyWildM:=KeyW;
        end;

        PopUpList.CreateOwnList(MULCtrlO,Fnum,SKeypath,Key2F,LenSCode,CFilters);


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
Function GetRep(    AOWner   : TComponent;
                    Want     : Str20;
                Var Found    : Str20;
                    Mode     : SmallInt) : Boolean;
Var
  PrevHState, UseWildCard : Boolean;
  RepFind     : ^TRepFind;
  LenSCode    : Byte;
  SKeyPath    : Integer;
  KeyWildM    : Str255;
  RepFilters  : FilterType;
Begin
  UseWildCard:=BOff;

  SKeyPath:=RGNdxK;

  Blank(RepFilters,Sizeof(RepFilters));
  RepFilters[1,0]:=RepHedTyp;           { Only want group headers }


  { Update for recpfix & subtype }
  {If (Mode<>-1) then
    Want := PartCCKey(DataDicCode,DataDicXRef) + Chr(ExVNo) + Chr(FileNo) + Want
  Else
    Want := PartCCKey(DataDicCode,DataDicVar) + Want;}
  Want := PartCCKey(ReportGenCode,RepGroupCode) + Want;
  LenSCode:=Length(Strip('R',[#0,#32],Want));

  New(RepFind,Create(AOwner,RepGenF,SKeyPath,Want,LenSCode,Mode,UseWildCard,KeyWildM,RepFilters));

  Try
    Result:=RepFind^.AdvanceFind;

    If (Not Result) and (Mode<>-1) then
      With RepFind^.PopUpList do Begin
        ListPFix:='D';

        {
        If (Mode<>99) then
          Caption:=TradeType[Bon]+' '+Caption;
        }

        ListCol1Lab.Caption:='Code';
        ListCol2Lab.Caption:='Description';

        {If (StartLookUp(LenSCode)) then}

        SetAllowHotKey(BOff,PrevHState);

          ShowModal;

        SetAllowHotKey(BOn,PrevHState);

        Result:=FFoundOk;

        If (Result) then
          Found:=RepGenRecs^.ReportHed.RepName;
      End { With }
    Else
      If Result then
        Found:=RepGenRecs^.ReportHed.RepName;
  finally
    Dispose(RepFind,Destroy);
  end;
end; {Func..}
****)

end.
