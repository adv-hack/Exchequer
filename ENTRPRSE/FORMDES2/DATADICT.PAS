unit datadict;

interface

Uses Classes, Dialogs, SysUtils, WinTypes, BtrvU2, BTSupU1, GlobVar,
     StdCtrls, GlobType, VarConst, VarFPosU, VarRPosU, TEditVal,
     VarRec2U, Forms;

{$ALIGN 1}

{$I VarRecRp.Pas}

Var
  DictRec  : ^DataDictRec;
  DictFile : ^DataDict_FileDef;

Procedure DefineDataDict;
{Procedure LoadFileCombo (Var Combo_File : TSBSComboBox);}
Procedure LoadFileCombo (Items : TStrings);
Function GetFileComboFileNo (Const ItIdx : SmallInt) : SmallInt;
Function GetFileComboIndex (Const FNo : SmallInt) : SmallInt;
Function CheckXRef (Const ShortCode : String10;
                    Var   DataRec   : DataDictRec) : Boolean;
Function GetDDField (Const ShortCode : String10;
                     Var   DataRec   : DataDictRec) : Boolean;
Procedure LoadFieldList(Var   TheList  : TListBox;
                        Const FileNo   : Byte;
                        Const DispType : Byte);
Function GetFileDescr (Const FNo : SmallInt) : ShortString; Export;

{ Loads the specified list with fields with the specified prefix }
Procedure LoadDDList (Var   TheList     : TListBox;
                      Const FieldPrefix : ShortString);

Procedure PrintDDReport; Export;

Implementation

Uses ETStrU, ETMiscU, FormUtil, EntLicence;

Var
  IsLITE : Boolean;

{$I VarCnst3.Pas}

Function GetFileDescr (Const FNo : SmallInt) : ShortString;
Begin
  Result := '';

  Case FNo Of
    1 : Result := 'Customer';
    2 : Result := 'Supplier';
    3 : Result := 'Document Header';
    4 : Result := 'Document Detail';
    5 : Result := 'Nominal';
    6 : Result := 'Stock';
    7 : Result := 'Cost Centre';
    8 : Result := 'Department';
    9 : Result := 'Serial/Batch';
  End; { Case }
End;

Procedure LoadFileCombo (Items : TStrings);
Begin
  Items.Clear;

  Items.Add ('Customers');
  Items.Add ('Suppliers');
  Items.Add ('Document Headers');
  Items.Add ('Document Details');
  Items.Add ('Nominal');
  Items.Add ('Stock');
  Items.Add ('Cost Centre');
  Items.Add ('Department');
  Items.Add ('Serial/Batch');
End;

Function GetFileComboFileNo (Const ItIdx : SmallInt) : SmallInt;
Begin
  Result := ItIdx + 1;
End;

Function GetFileComboIndex (Const FNo : SmallInt) : SmallInt;
Begin
  Result := FNo - 1;
  If (Result < 0) Then Result := 0;
End;


Function GetDDField (Const ShortCode : String10;
                     Var   DataRec   : DataDictRec) : Boolean;
Const
  FNum    = DictF;
  KeyPath = DIK;
Var
  KeyS : Str255;
begin
  { Build index for variable record }
  KeyS := 'DV' + LJVAR(ShortCode,8);

  Status := Find_Rec (B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  If (Status = 0) Then
    DataRec := DictRec^
  Else
    FillChar (DataRec, SizeOf (DataRec), #0);

  Result := (Status = 0);
end;

{ Returns True and the record if a specified data dictionary item exists }
Function CheckXRef (Const ShortCode : String10;
                    Var   DataRec   : DataDictRec) : Boolean;
Const
  FNum    = DictF;
  KeyPath = DIK;
Var
  FlagBase : Array [1..2] Of LongInt;
  KeyS     : Str255;
begin
  Result := False;
  FillChar (DataRec, SizeOf (DataRec), #0);

  { Get dictionary record }
  If GetDDField (ShortCode, DataRec) Then Begin
    { Check versioning }
    With DataRec, DataVarRec Do Begin
      FlagBase[1] := Round(Power(2,Pred(SystemInfo.ExVersionNo)));
      If ExVerIsMultiCcy Then
        FlagBase[1] := Round(Power(2,Pred(22)))
      Else
        FlagBase[1] := Round(Power(2,Pred(21)));

      Result := ((AvailVer And FlagBase[1]) = FlagBase[1]) Or
                ((AvailVer And FlagBase[2]) = FlagBase[2]);
    End; { With }
  End; { If }

  (*
  { Get record }
  FillChar (KeyS, SizeOf (KeyS), #0);
  KeyS := 'DX'#1#1 + ShortCode;
  KeyS[3] := Chr(SystemInfo.ExVersionNo);
  KeyS[4] := Chr(FileNo);
  Status := Find_Rec (B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  Result := (Status = 0);
  If (Not Result) Then Begin
    FillChar (KeyS, SizeOf (KeyS), #0);
    KeyS := 'DX'#1#1 + ShortCode;
    If ExVerIsMultiCcy Then
      KeyS[3] := Chr(22)
    Else
      KeyS[3] := Chr(21);
    KeyS[4] := Chr(FileNo);
    Status := Find_Rec (B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
    Result := (Status = 0);
  End; { If }

  If Result Then
    Result := GetDDField (ShortCode, DataRec);
  *)
end;

Procedure LoadFieldList(Var   TheList  : TListBox;
                        Const FileNo   : Byte;
                        Const DispType : Byte);
Const
  FNum    = DictF;
  KeyPath = DIK;
Var
  DataRec             : DataDictRec;
  FormDesVersionNo, I : Integer;
  KeyS                : Str255;
  OutF                : TextFile;
  {VarMap              : Array [1..40] Of SmallInt;}
begin
  { Generate for exchequer version in first pass }
  FormDesVersionNo := SystemInfo.ExVersionNo;
  TheList.Clear;
  For I := 1 To 2 Do Begin
    { build index }
    FillChar (KeyS, SizeOf (KeyS), #0);
    KeyS := 'DX'#1#1;
    KeyS[3] := Chr(FormDesVersionNo);
    KeyS[4] := Chr(FileNo);

    { Get record }
    Status := Find_Rec (B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
    Report_Berror (Fnum, Status);

    With DictRec^ Do Begin
      While (Status = 0) And
            (SubType = 'X') And
            (DataXRefRec.VarExVers = FormDesVersionNo) And
            (DataXRefRec.VarFileNo = FileNo) Do Begin
        If GetDDField (DataXRefRec.VarName, DataRec) Then
          Case DispType Of
            1 : TheList.Items.Add (DataRec.DataVarRec.VarName + #9 + DataRec.DataVarRec.VarDesc);
            2 : AddObjectToList (TheList,
                                 Nil,
                                 1,
                                 DataRec.DataVarRec.VarName,
                                 DataRec.DataVarRec.VarDesc,
                                 'DBF[' + Trim(DataRec.DataVarRec.VarName) + ']',
                                 0,
                                 [Field],
                                 Nil);
          End { Case }
        Else
          TheList.Items.Add (DataXRefRec.VarName + ': Failed');

        { Get next }
        Status := Find_Rec (B_GetGretr, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
        Report_Berror (Fnum, Status);
      End; { While }

      If (TheList.ItemIndex = -1) And (TheList.Items.Count > 0) Then
        TheList.ItemIndex := 0;
    End; { With }

    { Generate from form designer version in 2nd pass }
    If ExVerIsMultiCcy Then
      FormDesVersionNo := 22
    Else
      FormDesVersionNo := 21;
  End; { For }

  (*
  AssignFile (OutF, 'c:\Dict.Txt');
  Rewrite    (OutF);

  { build index }
  FillChar (KeyS, SizeOf (KeyS), #0);

  { Get record }
  Status := Find_Rec (B_GetFirst, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  Report_Berror (Fnum, Status);

  WriteLn (OutF, 'Name,Description,Type,Len,Decs,FormDes');

  {For I := Low(VarMap) To High(VarMap) Do
    VarMap[I] := 0;}

  While StatusOk Do Begin
    With DictRec^ Do
      If (RecPFix = 'D') Then Begin
        Case SubType Of
          'V' : With DataVarRec Do Begin
                  Write (OutF, Trim(VarName), ',',
                               Trim(VarDesc), ',');

                  Case VarType Of
                    1  : Write (OutF, 'String');
                    2  : Write (OutF, 'Real');
                    3  : Write (OutF, 'Double');
                    4  : Write (OutF, 'Date');
                    5  : Write (OutF, 'Char');
                    6  : Write (OutF, 'Longint');
                    7  : Write (OutF, 'Integer');
                    8  : Write (OutF, 'Byte');
                    9  : Write (OutF, 'Currency');
                    10 : Write (OutF, 'Period');
                    11 : Write (OutF, 'Yes/No');
                    12 : Write (OutF, 'Time');
                  Else
                    Write (OutF, IntToStr(VarType));
                  End; { Case }
                  Write (OutF, ',', IntToStr(VarLen), ',', IntToStr(VarNoDec), ',');

                  If ((AvailVer And 1048576) = 1048576) Or
                     ((AvailVer And 2097152) = 2097152) Then
                    Write (OutF, 'Form Designer');

                  Writeln (OutF);
                End; { With }

          'X' : With DataXRefRec Do
                  WriteLn (OutF, SubType + '  ' + IntToStr(VarExVers) + '  '  +IntToStr(VarFileNo) + '  '  + DataXRefRec.VarName);

          {'X' : With DataXRefRec Do
                  Inc (VarMap[VarExVers]);}
        Else
          WriteLn (OutF, 'Unknown SubType: ', SubType);
        End; { Case }
      End; { If }

    { Get next }
    Status := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  End; { While }

  {For I := Low(VarMap) To High(VarMap) Do
    Writeln (OutF, I, '    ', VarMap[I]);}

  CloseFile (OutF);

  *)
End;


{ Loads the specified list with fields with the specified prefix }
Procedure LoadDDList (Var   TheList     : TListBox;
                      Const FieldPrefix : ShortString);
Const
  FNum    = DictF;
  KeyPath = DIK;
Var
  MMFlagBase          : Array [1..NoMMGrps] Of LongInt;
  DataRec             : DataDictRec;
  FormDesVersionNo, I : Integer;
  KeyS, KeyChk        : Str255;
  WantIt              : Boolean;
Begin { LoadDDList }
  KeyS := 'DV' + FieldPrefix;
  KeyChk := KeyS;

  { Calculate base values for MM Flags }
  For I := 1 To NoMMGrps Do Begin
    MMFlagBase[I] := Round(Power(2,Pred(I)));
  End; { For }

  { Generate from form designer version in 2nd pass }
  If ExVerIsMultiCcy Then
    FormDesVersionNo := 22
  Else
    FormDesVersionNo := 21;

  { Get first record for key}
  Status := Find_Rec (B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

  While StatusOk and CheckKey(KeyChk, KeyS, Length(KeyChk), BOn) Do Begin
    With DictRec^, DataVarRec Do Begin
      { Check Security }
      WantIt := (((AvailVer And MMFlagBase[SystemInfo.ExVersionNo]) = MMFlagBase[SystemInfo.ExVersionNo]) Or
                ((AvailVer And MMFlagBase[FormDesVersionNo]) = MMFlagBase[FormDesVersionNo])) And
                ((AvailVer And MMFlagBase[23]) = 0);

      // MH 21/03/06: Added suppression of fields for LITE
      If WantIt And IsLITE Then
      Begin
        // 24 = Not LITE
        WantIt := (AvailVer And MMFlagBase[24]) = 0;
      End; // If WantIt And IsLITE

      If WantIt Then Begin
        { Add to list }
        TheList.Items.Add (VarName + #9 + Trim(VarDesc));
      End; { If }
    End; { With }

    Status := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  End; { While }
End; { LoadDDList }


Procedure PrintDDReport;
Const
  FNum    = DictF;
  KeyPath = DIK;
Var
  dlgSave  : TSaveDialog;
  OutF     : TextFile;
  KeyS     : Str255;
Begin { PrintDDReport }
  dlgSave := TSaveDialog.Create(Application.MainForm);
  Try
    With dlgSave Do Begin
      DefaultExt := 'TXT';
      FileName := 'DICT.TXT';
      Filter := 'Text Files (*.TXT)|*.TXT|All Files (*.*)|*.*';
      FilterIndex := 1;
      InitialDir := SystemInfo.ExDataPath;
      Options := [ofHideReadOnly,ofOverwritePrompt,ofPathMustExist];
      Title := 'Save Report As';
    End; { With dlgSave }

    If dlgSave.Execute Then Begin
      AssignFile (OutF, dlgSave.FileName);
      Rewrite    (OutF);

      { build index }
      FillChar (KeyS, SizeOf (KeyS), #0);

      { Get record }
      Status := Find_Rec (B_GetFirst, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
      Report_Berror (Fnum, Status);

      WriteLn (OutF, 'Name,Description,Type,Len,Decs,FormDes');

      While StatusOk Do Begin
        With DictRec^ Do Begin
          If (RecPFix = 'D') And (SubType = 'V') Then Begin
            { Field Record }
            With DataVarRec Do Begin
              Write (OutF, Trim(VarName), ',', Trim(VarDesc), ',');
              Case VarType Of
                1  : Write (OutF, 'String');
                2  : Write (OutF, 'Real');
                3  : Write (OutF, 'Double');
                4  : Write (OutF, 'Date');
                5  : Write (OutF, 'Char');
                6  : Write (OutF, 'Longint');
                7  : Write (OutF, 'Integer');
                8  : Write (OutF, 'Byte');
                9  : Write (OutF, 'Currency');
                10 : Write (OutF, 'Period');
                11 : Write (OutF, 'Yes/No');
                12 : Write (OutF, 'Time');
              Else
                Write (OutF, IntToStr(VarType));
              End; { Case }
              Write (OutF, ',', IntToStr(VarLen), ',', IntToStr(VarNoDec), ',');

              If ((AvailVer And 1048576) = 1048576) Or
                 ((AvailVer And 2097152) = 2097152) Then
                Write (OutF, 'Form Designer');

              Writeln (OutF);
            End; { With }
          End { If }
          Else Begin
            If (RecPFix = 'D') And (SubType = 'X') Then Begin
              { X-Ref record }
              With DataXRefRec Do Begin
                //WriteLn (OutF, SubType + '  ' + IntToStr(VarExVers) + '  '  +IntToStr(VarFileNo) + '  '  + DataXRefRec.VarName);
              End; { With }
            End { If }
            Else Begin
              If (RecPFix = 'N') And (SubType = 'A') Then Begin
                { X-Ref record }
                With DNotesRec Do Begin
                  //WriteLn (OutF, 'Notes: ', NoteNo, ' ', NType);
                End; { With }
              End { If }
              Else Begin
                { Dimebar }
                WriteLn (OutF, 'Unknown Record: ', RecPFix, SubType);
              End; { Else }
            End; { Else }
          End; { Else }

          { Get next }
          Status := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
        End; { With }
      End; { While }

      CloseFile (OutF);
    End; { If }
  Finally
    dlgSave.Destroy;
  End;
End; { PrintDDReport }

Initialization
  GetMem (DictRec, SizeOf (DictRec^));
  GetMem (DictFile, SizeOf (DictFile^));

  DefineDataDict;
  Define_PVar;

  IsLITE := (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]);
Finalization
  FreeMem (DictRec, SizeOf (DictRec^));
  FreeMem (DictFile, SizeOf (DictFile^));
end.
