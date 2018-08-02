unit rwfuncs;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Graphics, GlobVar, RwOpenF;

Procedure CopyFont (TheFont : TFont; Var TheRec : ReportFontType; Const ToRec : Boolean);

Function Ok2DelRep (RepName  :  String)  :  Boolean;

Function GetReport (Const FindCode : String; Var FoundCode : String) : Boolean;

{Procedure Warn_ValErr(RVNo    :  Str10;
                      ValLine :  Str100);}

implementation

Uses
  Dialogs,
  VarConst,
  BtrvU2,
  BtSupu1,
  RpCommon,
  DebugLog,
  ElVar,
  FileUtil;

{ Copies informaiton between a TFont and a report font record }
Procedure CopyFont (TheFont : TFont; Var TheRec : ReportFontType; Const ToRec : Boolean);
Begin
  Try
    If ToRec Then
      With TheRec Do Begin
        fName  := TheFont.Name;
        fColor := TheFont.Color;
        fStyle := BYTE(TheFont.Style);
        fPitch := BYTE(TheFont.Pitch);
        fSize  := TheFont.Size;
      End { With }
    Else
      With TheRec Do Begin
        TheFont.Name   := fName;
        TheFont.Color  := fColor;
        TheFont.Style  := TFontStyles(fStyle);
        TheFont.Pitch  := TFontPitch(fPitch);
        TheFont.Size   := fSize;
      End; { With }
  Except
    ;
  End;
end;



{ Returns True of the report can be deleted }
Function Ok2DelRep (RepName  :  String)  :  Boolean;
Var
  KeyS  :  Str255;
Begin
  KeyS:=PartCCKey(ReportGenCode,RepHedTyp)+RepName;

  Result := Not CheckExsists(KeyS,RepGenF,RGK);
end;


Function GetReport (Const FindCode : String; Var FoundCode : String) : Boolean;
Const
  FNum    = RepGenF;
  KeyPath = RGNdxK;
Var
  KeyS : Str255;
  Res : Integer;
Begin
  LogIt(spReport, 'Start GetReport');
  Open_System ( 1, 15);
  Open_System (RepGenF, RepGenF);
  //PR 01/05/2007: Change to allow Dictnary.dat to be in MCM dir only
  Res:=Open_File(F[DictF],GetEnterpriseDirectory+FileNames[DictF],0);

  LogIt(spReport, 'After Open_System');

  Init_AllSys;
  LogIt(spReport, 'After Init_AllSys');

  KeyS   := FullRepKey (ReportGenCode, RepGroupCode, FindCode);

  Status := Find_Rec (B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
  LogIt(spReport, 'After Find_Rec');

  If StatusOk Then
    FoundCode := FullRepKey (ReportGenCode, RepGroupCode, RepGenRecs^.ReportHed.RepName);
  LogIt(spReport, 'End GetReport');

  Result := StatusOk;
End;

Function GetDict (Const FindCode : String; Var FoundCode : String) : Boolean;
Const
  FNum    = RepGenF;
  KeyPath = RGNdxK;
Var
  KeyS : Str255;
Begin
  KeyS   := FullRepKey (ReportGenCode, RepGroupCode, FindCode);

  Status := Find_Rec (B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

  If StatusOk Then
    FoundCode := FullRepKey (ReportGenCode, RepGroupCode, RepGenRecs^.ReportHed.RepName);

  Result := StatusOk;
End;

(*
Procedure Warn_ValErr(RVNo    :  Str10;
                      ValLine :  Str100);
Var
  Tch  :  Char;
Begin
  MessageDlg ('The Report Global Selection is incorrect.' + #10#13 +
              'Field '+RVNo+' is incorrect.', mtError, [mbOk], 0);
end;
*)


end.
