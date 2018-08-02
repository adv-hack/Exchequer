//
//
//  DUMMY MODULE FOR REPORT WRITER
//
//
unit PrintFrm;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses {ShareMem, }Classes, Graphics, Forms, GlobVar, Dialogs, BTSupU3,
     VarConst, RpDevice, RpDefine;


{Const
  pfProcessErr = True;}


Function pfPrintFormSta (Var   PrnInfo    : TSBSPrintSetupInfo;
                         Const DefMode    : Integer;
                         Const FormName   : ShortString;
                         Const MFN, MKP   : Integer;
                         Const MKeyRef    : Str255;
                         Const TFN, TKP   : Integer;
                         Const TKeyRef    : Str255;
                         Const Descr      : ShortString;
                         Const WinTitle   : ShortString;
                         Const AddBatchInfo
                                          : StaCtrlRec;
                         Const ProcessErr : Boolean) : Boolean;

{Function pfPrintForm (Var   PrnInfo   : TSBSPrintSetupInfo;
                      Const DefMode    : Integer;
                      Const FormName   : ShortString;
                      Const MFN, MKP   : Integer;
                      Const MKeyRef    : Str255;
                      Const TFN, TKP   : Integer;
                      Const TKeyRef    : Str255;
                      Const Descr      : ShortString;
                      Const WinTitle   : ShortString;
                      Const ProcessErr : Boolean) : Boolean;}

Function pfInitNewBatch (Const ProcessErr : Boolean;
                         Const IgnoreInP  : Boolean) : Boolean;

Function pfAddBatchForm (Var   PrnInfo    : TSBSPrintSetupInfo;
                         Const DefMode    : Integer;
                         Const FormName   : ShortString;
                         Const MFN, MKP   : Integer;
                         Const MKeyRef    : Str255;
                         Const TFN, TKP   : Integer;
                         Const TKeyRef    : Str255;
                         Const Descr      : ShortString;
                         Const AddBatchInfo
                                          : StaCtrlRec;
                         Const ProcessErr : Boolean) : Boolean;

Function pfPrintBatch (Const WinTitle   : ShortString;
                       Const Copies     : Integer;
                       Const ProcessErr : Boolean;
                       Const JobTitle   : ShortString) : Boolean;


Function pfSelectFormPrinter (Var PrnInfo   : TSBSPrintSetupInfo;
                                  ChangeFrm : Boolean;
                              Var FormName  : Str10;
                              Var PFont     : TFont;
                              Var POrient   : TOrientation) : Boolean;

Function pfSelectPrinter (Var PrnInfo   : TSBSPrintSetupInfo;
                          Var PFont     : TFont;
                          Var POrient   : TOrientation) : Boolean;

Function pf_Check4Printers  :  Boolean;

Procedure pfSet_DefaultPrinter(ThisSet  :  Tcomponent;
                               DefName  :  Str255);


Function pfFind_DefaultPrinter(DefName  :  Str255)  :  Integer;

Function pfGetMultiFrmDefs(PageNo  :  Integer)  :  FormDefsRecType;

Function pfGetMultiFrmDesc(PageNo  :  Integer)  :  Str255;

procedure pfListPrinters(AList : TStrings);

 Procedure pfSet_NDPDefaultPrinter(ThisSet  :  TComponent;
                                  DefName  :  Str255;
                                  pfsMode  :  Byte);



Var
  Local_PrnInfo  :  ^TSBSPrintSetupInfo;



Implementation

Uses BTSupU1, SysUtils;


Function pfSelectFormPrinter (Var PrnInfo   : TSBSPrintSetupInfo;
                                  ChangeFrm : Boolean;
                              Var FormName  : Str10;
                              Var PFont     : TFont;
                              Var POrient   : TOrientation) : Boolean;
Begin
End;


Function pfSelectPrinter (Var PrnInfo   : TSBSPrintSetupInfo;
                          Var PFont     : TFont;
                          Var POrient   : TOrientation) : Boolean;
Begin
End;

Function pfPrintFormSta (Var   PrnInfo    : TSBSPrintSetupInfo;
                         Const DefMode    : Integer;
                         Const FormName   : ShortString;
                         Const MFN, MKP   : Integer;
                         Const MKeyRef    : Str255;
                         Const TFN, TKP   : Integer;
                         Const TKeyRef    : Str255;
                         Const Descr      : ShortString;
                         Const WinTitle   : ShortString;
                         Const AddBatchInfo
                                          : StaCtrlRec;
                         Const ProcessErr : Boolean) : Boolean;
Begin
End;

Function pfPrintForm (Var   PrnInfo    : TSBSPrintSetupInfo;
                      Const DefMode    : Integer;
                      Const FormName   : ShortString;
                      Const MFN, MKP   : Integer;
                      Const MKeyRef    : Str255;
                      Const TFN, TKP   : Integer;
                      Const TKeyRef    : Str255;
                      Const Descr      : ShortString;
                      Const WinTitle   : ShortString;
                      Const ProcessErr : Boolean) : Boolean;
Begin
End;

Function pfInitNewBatch (Const ProcessErr : Boolean;
                         Const IgnoreInP  : Boolean) : Boolean;
Begin
End;

Function pfAddBatchForm (Var   PrnInfo    : TSBSPrintSetupInfo;
                         Const DefMode    : Integer;
                         Const FormName   : ShortString;
                         Const MFN, MKP   : Integer;
                         Const MKeyRef    : Str255;
                         Const TFN, TKP   : Integer;
                         Const TKeyRef    : Str255;
                         Const Descr      : ShortString;
                         Const AddBatchInfo
                                          : StaCtrlRec;
                         Const ProcessErr : Boolean) : Boolean;
Begin
End;


{ Prints The Current Batch }
Function pfPrintBatch (Const WinTitle   : ShortString;
                       Const Copies     : Integer;
                       Const ProcessErr : Boolean;
                       Const JobTitle   : ShortString) : Boolean;
Begin
End;



Function pfFind_DefaultPrinter(DefName  :  Str255)  :  Integer;
Var
  n         :  Integer;
  FoundOk   :  Boolean;
Begin
  FoundOk:=BOff;

  For n:=0 to Pred(RpDev.Printers.Count) do
  Begin
    FoundOk:=(CheckKey(DefName,RpDev.Printers[n],Length(DefName),BOff)) and (DefName<>'');

    If (FoundOk) then
      Break;
  end;

  If (FoundOk) then
    Result:=n
  else
    If (RpDev.Printers.Count>0) then
      Result:=RpDev.DeviceIndex
    else
      Result:=-1;
end;

procedure pfListPrinters(AList : TStrings);
Var
  n         :  Integer;
begin
  AList.Clear;
  For n:=0 to Pred(RpDev.Printers.Count) do
    AList.Add(Trim(RpDev.Printers[n]));
end;


Function pf_Check4Printers  :  Boolean;
Begin
end;

{Procedure pfSet_DefaultPrinter(ThisSet  :  TSBSComboBox;
                               DefName  :  Str255);
Begin
end;}


 Function pfGetMultiFrmDefs(PageNo  :  Integer)  :  FormDefsRecType;
 Begin
 end;


 Function pfGetMultiFrmDesc(PageNo  :  Integer)  :  Str255;
 Begin
 end;

 Procedure pfSet_NDPDefaultPrinter(ThisSet  :  TComponent;
                                  DefName  :  Str255;
                                  pfsMode  :  Byte);

Const
  NoDefaultStr  = 'Use Windows Default';
  EntDefaultStr = 'Use Exchequer Default';

Var
  n  :  Integer;

Begin
(*
  ThisSet.Items.Assign(RpDev.Printers);

  For n:=0 to Pred(ThisSet.Items.Count) do
    ThisSet.Items[n]:=StripOnP(ThisSet.Items[n]);

  ThisSet.ItemsL.Assign(RpDev.Printers);

  If (pfsMode In [1,2]) then {Insert a no default printer in as first item}
  Begin
    ThisSet.Items.Insert(0,NoDefaultStr);
    ThisSet.ItemsL.Insert(0,NoDefaultStr);
  end;

  If (pfsMode In [2]) then {Insert a no default printer in as first item}
  Begin
    ThisSet.Items.Insert(0,EntDefaultStr);
    ThisSet.ItemsL.Insert(0,EntDefaultStr);
  end;



  {$IFDEF FRM}
    Case pfsMode of
      1,2
         :  ThisSet.ItemIndex:=pfFind_ComboPrinter(ThisSet,DefName);

      else  ThisSet.ItemIndex:=pfFind_DefaultPrinter(DefName);
    end; {Case..}

    If (ThisSet.ItemIndex>=0) then
      ThisSet.Text:=ThisSet.Items[ThisSet.ItemIndex];
  {$ELSE}
    ThisSet.ItemIndex:=RpDev.DeviceIndex;
  {$ENDIF}
*)
end;

Procedure pfSet_DefaultPrinter(ThisSet  :  Tcomponent;
                               DefName  :  Str255);

begin
end;



Initialization
  New(Local_PrnInfo);
  FillChar(Local_PrnInfo^,Sizeof(Local_PrnInfo^),0);
Finalization
  Dispose(Local_PrnInfo);
end.
