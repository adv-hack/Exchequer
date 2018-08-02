unit Register;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses Classes, Dialogs, SysUtils, GlobVar, GlobType,
  XMLFileU, SBSList;

Function OpenFormDef (Const Filename   : String;
                      Var   HedRec     : fdHeaderRecType;
                      Var   StrRec     : fdFormStringsType;
                      Var   ListHandle : TSBSList) : Boolean; Export;

Procedure SaveFormDef (Const Filename   : String;
                       Const HedRec     : fdHeaderRecType;
                       Const StrRec     : fdFormStringsType;
                       Var   ListHandle : TSBSList); Export;

Function DeleteFormDef (Const DefName : Str255) : Boolean; Export;

Function ValidFormDef (Const FilePath : SplitFnameType;
                       Const WantMsg  : Boolean) : Boolean; Export;
Function GetFormCopies (Const Filename : String) : SmallInt; Export;

Function GetFormOrient (Const Filename : String) : fdOrientationType;

Function GetFormInfo (Const Filename : String) : FormInfoType; Export;

Function GetFormType (Const Filename : String) : Byte; Export;

implementation

Uses BtrvU2, BTSupU1, EtMiscU, VarConst, FormFile, RpDevice,
     Formutil, PrnCodes;

{ Following constants are used in the debugging files for open and close }
const
  RepClassStr  : Array [fdRepClassType] Of String[6] = ('Header', 'PagHed', 'PgBHed', 'Body  ', 'BdFoot', 'PgFoot', 'Column');
  FieldClassStr: Array [fdFieldClassType] Of String[6] =
                       ('Header', 'Text  ', 'Line  ', 'Bitmap',
                        'Table ', 'PageNo', 'Formla', 'Box   ',
                        'Dbfld ', 'FldCol', 'FrmCol', 'MaxSiz',
                        'Group ', 'String');

  SaveAsXML: Boolean = True;

var
  LoadAsXML: Boolean;

//-------------------------------------------------------------------------

{ Close the Form Definition File }
Procedure CloseFormDef;
Begin
  Status := Close_File (F[FormDetsF]);
End;

//-------------------------------------------------------------------------

{ Saves the form definition }
Procedure SaveFormDef (Const Filename   : String;
                       Const HedRec     : fdHeaderRecType;
                       Const StrRec     : fdFormStringsType;
                       Var   ListHandle : TSBSList);
Var
  OutF  : TextFile;
  KeyS  : Str255;
  I     : Integer;
  XMLFile: TXMLFile;
Begin
  if SaveAsXML then
    XMLFile := TXMLFile.Create
  Else
    XMLFile := NIL;

  CloseFormDef;

  If SystemInfo.DebugOpen Then Begin
    { Open debug file and print header }
    AssignFile (OutF, 'SaveForm.Txt');
    Rewrite    (OutF);
    Writeln    (OutF, 'Save: ' + FileName);
    Writeln    (OutF, 'Time: ' + TimeToStr(Now));
    Writeln    (OutF);
    Writeln    (OutF, 'Class   Order  Control Id  Group       FClass  Status');
    Writeln    (OutF, '------------------------------------------------------');
    Writeln    (OutF);
  End; { If }

  { Create form details file }
  FileNames[FormDetsF] := SplitFileName(FileName).PathName;

  if SaveAsXML then
    Status := 0
  else
  begin
    Status := Make_File(F[FormDetsF],FileNames[FormDetsF],FileSpecOfs[FormDetsF]^,FileSpecLen[FormDetsF]);
    Report_Berror (FormDetsF, Status);
  end;

  If (Status = 0) Then
  Begin
    { Open form details file }
    if SaveAsXML And Assigned(XMLFile) then
      XMLFile.StartNewFile(FileName, True)
    else
      FF_OpenFile (FormDetsF, False);
  End; { If }

  If (Status = 0) Then Begin
    { Save form details }
    FillChar (FormDetsRec^, SizeOf (FormDetsRec^), #0);
    FormDetsRec^.fdRepClass   := fdrHeader;
    FormDetsRec^.fdFieldOrder := 0;               { Creation Order of controls }
    FormDetsRec^.fdFieldClass := fdcHeader;
    FormDetsRec^.Header       := HedRec;
    FormDetsRec^.Header.fhMajVer := DesignerMajorVersion;
    FormDetsRec^.Header.fhMinVer := DesignerMinorVersion;

    if SaveAsXML then
      Status := XMLFile.AddRec(FormDetsRec^)
    else
      Status := Add_rec(F[FormDetsF], FormDetsF, RecPtr[FormDetsF]^, 0);

    Report_Berror (FormDetsF, Status);

    { Save String details }
    FillChar (FormDetsRec^, SizeOf (FormDetsRec^), #0);
    FormDetsRec^.fdRepClass   := fdrHeader;
    FormDetsRec^.fdFieldOrder := 1;               { Creation Order of controls }
    FormDetsRec^.fdFieldClass := fdcStrings;
    FormDetsRec^.FormStrings  := StrRec;

    if SaveAsXML then
      Status := XMLFile.AddRec(FormDetsRec^)
    else
      Status := Add_rec(F[FormDetsF], FormDetsF, RecPtr[FormDetsF]^, 0);

    Report_Berror (FormDetsF, Status);

    { Save form controls }
    If (ListHandle.Count > 0) Then
      For I := 0 To (ListHandle.Count - 1) Do Begin
        FormDetsRec^ := TFormDefListObjType(ListHandle.Items[I]).FormDef;

        if SaveAsXML then
          Status := XMLFile.AddRec(FormDetsRec^)
        else
          Status := Add_Rec(F[FormDetsF], FormDetsF, RecPtr[FormDetsF]^, 0);

        If SystemInfo.DebugOpen Then Begin
          { print detail to debug file }
          With FormDetsRec^ Do
            Writeln (OutF, RepClassStr[fdRepClass],        '  ',
                           Format('%5d',  [fdFieldOrder]), '  ',
                           Format('%10s', [fdControlId]),  '  ',
                           Format('%10s', [fdGroup]),      '  ',
                           FieldClassStr[fdFieldClass],    '  ',
                           Format('%3d',  [Status]));
        End; { If }

        Report_Berror (FormDetsF, Status);
      End; { For }
  End; { If }

  if SaveAsXML then
  begin
    XMLFile.CloseNewFile;
    XMLFile.Free;
  end
  else
    CloseFormDef;

  If SystemInfo.DebugOpen Then Begin
    { Close debug file }
    CloseFile (OutF);
  End; { If }
End;

//-------------------------------------------------------------------------

Function OpenFormDef (Const Filename   : String;
                      Var   HedRec     : fdHeaderRecType;
                      Var   StrRec     : fdFormStringsType;
                      Var   ListHandle : TSBSList) : Boolean;
Var
  DetailsRec : FormDefRecType;
  DetObj     : TFormDefListObjType;
  KeyS       : Str255;
  OutF       : TextFile;
  ColsList   : TSBSList;
  XMLFile    : TXMLFile;

  { Sort list into ascending fdFieldOrder order }
  Procedure SortList (Var TheList : TSBSList);
  Var
    Obj1, Obj2 : TFormDefListObjType;
    Changed    : Boolean;
    I          : Smallint;
  Begin
    Repeat
      Changed := False;

      If (TheList.Count > 0) Then
        For I := 0 To (TheList.Count - 2) Do Begin
          Obj1 := TFormDefListObjType(TheList.Items[I]);
          Obj2 := TFormDefListObjType(TheList.Items[I + 1]);

          If (Obj1.FormDef.fdFieldOrder > Obj2.FormDef.fdFieldOrder) Then Begin
            TheList.Items[I]     := Obj2;
            TheList.Items[I + 1] := Obj1;
            Changed := True;
          End; { If }
        End; { For }
    Until (Not Changed);
  End;

Begin
  CloseFormDef;

  LoadAsXML := TXMLFile.Version(FileName).IsValid;
  if LoadAsXML then
    XMLFile := TXMLFile.Create
  Else
    XMLFile := NIL;

  FillChar (HedRec, SizeOf (HedRec), #0);
  FillChar (StrRec, SizeOf (StrRec), #0);

  { Open details file }
  FileNames[FormDetsF] := Filename;

  if LoadAsXML And Assigned(XMLFile) then
    Status := XMLFile.OpenFile(FileName)
  else
    FF_OpenFile2 (FormDetsF);

  Result := (Status = 0);

  If SystemInfo.DebugOpen Then Begin
    { Open debug file and print header }
    AssignFile (OutF, 'OpenForm.Txt');
    Rewrite    (OutF);
    Writeln    (OutF, 'Open: ' + FileName);
    Writeln    (OutF, 'Time: ' + TimeToStr(Now));
    Writeln    (OutF);
    Writeln    (OutF, 'Class   Order  Control Id  Group       Field Class');
    Writeln    (OutF, '---------------------------------------------------');
    Writeln    (OutF);
  End; { If }

  If Result then Begin
    ColsList := TSBSList.CreateList('ColOpen');
    Try
      { Process details }
      ListHandle.Clear;
      KeyS := '';

      if LoadAsXML then
      begin
        FillChar(FormDetsRec^, SizeOf (FormDetsRec^), #0);
        XMLFile.ReadNode(FormDetsRec^);
      end
      else
        Status := Find_Rec (B_StepFirst, F[FormDetsF], FormDetsF, RecPtr[FormDetsF]^, Key_Dets_Class, KeyS);

      While (Status = 0) Do Begin
        If SystemInfo.DebugOpen Then Begin
          { print detail to debug file }
          With FormDetsRec^ Do
            Writeln (OutF, RepClassStr[fdRepClass],        '  ',
                           Format('%5d',  [fdFieldOrder]), '  ',
                           Format('%10s', [fdControlId]),  '  ',
                           Format('%10s', [fdGroup]),      '  ',
                           FieldClassStr[fdFieldClass]);
        End; { If }

        Case FormDetsRec^.fdFieldClass Of
          fdcHeader     : HedRec := FormDetsRec^.Header;
          fdcText,
          fdcLine,
          fdcBox,
          fdcBitmap,
          fdcTable,
          fdcPage,
          fdcDbField,
          fdcFormula,
          fdcGroup      : Begin
                            DetObj := TFormDefListObjType.Create;
                            DetObj.FormDef := FormDetsRec^;
                            ListHandle.Add (DetObj);
                          End;

          { Handle columns separately }
          fdcFieldCol,
          fdcFormulaCol : Begin
                            DetObj := TFormDefListObjType.Create;
                            DetObj.FormDef := FormDetsRec^;
                            ColsList.Add (DetObj);
                          End;

          fdcStrings    : StrRec := FormDetsRec^.FormStrings;
        End; { Case }

        if LoadAsXML then
        begin
          FillChar(FormDetsRec^, SizeOf (FormDetsRec^), #0);
          Status := XMLFile.NextNode;
          XMLFile.ReadNode(FormDetsRec^);
        end
        else
          Status := Find_Rec (B_StepNext, F[FormDetsF], FormDetsF, RecPtr[FormDetsF]^, Key_Dets_Class, KeyS);
      End; { While }

      if LoadAsXML then
        XMLFile.CloseFile
      else
        CloseFormDef;

      { Sort fields into order }
      SortList (ListHandle);

      { sort columns into order }
      SortList (ColsList);

      { add columns to fields list }
      While (ColsList.Count > 0) Do Begin
        { Get col from colslist }
        DetObj := TFormDefListObjType(ColsList.Items[0]);

        { Delete colslist entry }
        ColsList.Delete (0);

        { add to main fields list }
        ListHandle.Add (DetObj);
      End; { While }
    Finally
      ColsList.Free;
    End;
  End; { If }

  if LoadAsXML then
  begin
    XMLFile.Free;
  end;

  If SystemInfo.DebugOpen Then Begin
    { Close debug file }
    CloseFile (OutF);
  End; { If }
end;

//-------------------------------------------------------------------------

{ Delete form definition }
Function DeleteFormDef (Const DefName : Str255) : Boolean;
Begin
  If FileExists (DefName) Then
  Begin
    CloseFormDef;

    { Delete details file }
    Result := DeleteFile (DefName);
  End { If }
  Else
    Result := True; // Nothing to delete
end;

//-------------------------------------------------------------------------

Function ValidFormDef (Const FilePath : SplitFnameType;
                       Const WantMsg  : Boolean) : Boolean;
{ This validation method is called both when opening a file in the form
  designer, and when selecting a form definition (in SysFDef.pas). }
Var
  NewFileSpec      : FileSpec;
  ErrStr, FullName : String;
  ErrNo            : Byte;
  KeyS             : Str255;
  Ver              : Double;
  Ascii            : Array[1..4] Of Char;
begin
  CloseFormDef;

  ErrNo := 0;
  FullName := UpperCase(Trim(FilePath.Path + FilePath.Name + '.' + FilePath.Extension));

  LoadAsXML := TXMLFile.Version(Fullname).IsValid;
  if LoadAsXML then
  begin
    Result := True;
    Exit;
  end;
  if (FilePath.Extension = OldDefExtension) then
  begin
    { 26/04/99: Refresh file spec definition - just in case }
    FF_DefineFormDets;

    { Attempt to open the file }
    FileNames[FormDetsF] := FullName;
    Status := Open_File(F[FormDetsF], FileNames[FormDetsF], (-1*Ord(AccelMode)));

    If (Status <> 0) Then
      { Cannot open - probably not a btrieve file }
      ErrNo := 1
    Else Begin
      Status := GetFileSpec(F[FormDetsF], FormDetsF, NewFileSpec);

      If (Status = 0) Then Begin
        { got min number of records - check rec size }
        With NewFileSpec Do Begin
{ShowMessage ('RecLen(' + IntToStr(FormDetsFile^.RecLen) + '): ' + IntToStr(RecLen) + #13 +
             'PageSize(' + IntToStr(FormDetsFile^.PageSize) + '): ' + IntToStr(PageSize) + #13 +
             'NumIndex(' + IntToStr(FormDetsFile^.NumIndex) + '): ' + IntToStr(NumIndex) + #13 +
             'RecCount: ' + IntToStr(NotUsed));}
          If (RecLen   <> FormDetsFile^.RecLen) Or
             (PageSize <> FormDetsFile^.PageSize) Or
             (NumIndex <> FormDetsFile^.NumIndex) Or
             (NotUsed = 0) Then
            ErrNo := 3;
        End; { With }

        If (ErrNo = 0) Then Begin
          { Get first record and check the version number }
          KeyS := '';
          ErrNo := Find_Rec (B_StepFirst, F[FormDetsF], FormDetsF, RecPtr[FormDetsF]^, Key_Dets_Class, KeyS);
          If (ErrNo = 0) Then Begin
            If (FormDetsRec^.fdFieldClass = fdcHeader) Then Begin
// No point checking as only 1 version
//              With FormDetsRec^.Header Do
//                If (fhMajVer < MinDesMajVersion) Or (fhMajVer > MaxDesMajVersion) Or
//                   (fhMinVer < MinDesMinVersion) Or (fhMinVer > MaxDesMinVersion) Then
//                  ErrNo := 5; { Wrong version }
            End { If - need for correct compilation }
            Else
              ErrNo := 6; { Invalid header record }
          End { If }
          Else
            ErrNo := ErrNo + 100;
        End; { If }
      End { If }
      Else
        { no records - not a valid form def }
        ErrNo := 2;
    End;
  End
  Else If (FilePath.Extension = DefPCCExtension) Then
  Begin
      If (Not FileExists (FullName)) Or
         (Not FileExists (UpperCase(Trim(FilePath.Path + FilePath.Name + '.LST')))) Then
        ErrNo := 7;
  End
  Else
    { Wrong extension }
    ErrNo := 4;

  Result := (ErrNo = 0);
  If (Not Result) And WantMsg Then Begin
    {If Debug Then}
      ErrStr := '(' + IntToStr(ErrNo) + ') ';
    {Else
      ErrStr := '';}

    Case ErrNo Of
      1, 2     : ErrStr := ErrStr + '''' + FullName + ''' has caused Btrieve Error ' + IntToStr(Status);
      3, 6, 7  : ErrStr := ErrStr + '''' + FullName + ''' is not a valid Form Definition File';
      4        : ErrStr := ErrStr + '''' + FilePath.Extension + ''' is not a valid extension for a Form Definition File';
      5        : ErrStr := ErrStr + '''' + FullName + ''' is not valid for this version of the Exchequer Form Designer';
      { Btrieve Errors }
      100..199 : ErrStr := ErrStr + 'Cannot read ''' + FilePath.Extension + '''';
    End; { Case }

    MessageDlg (ErrStr, mtError, [mbOk], 0);
  End; { If }

  CloseFormDef;
end;


//-------------------------------------------------------------------------

Function GetFormHeader (Const Filename : String; Var FormHeader : FormDefRecType) : Boolean;
Var
  XMLFile  : TXMLFile;
  FormDets : FormDefRecType;
  sFilename : ShortString;
  iStatus  : SmallInt;
Begin // GetFormHeader
  FillChar (FormHeader, SizeOf(FormHeader), #0);
  Result := False;

  sFilename := SetDrive + FormsPath + Trim(FileName) + DefDotExtension;
  If FileExists(sFilename) Then
  Begin
    If TXMLFile.Version(sFileName).IsValid Then
    Begin
      XMLFile := TXMLFile.Create;
      Try
        iStatus := XMLFile.OpenFile(sFileName);
        If (iStatus = 0) Then
        Begin
          FormDets := FormHeader;
          XMLFile.ReadNode(FormDets);
          While (iStatus = 0) And (Not Result) Do
          Begin
            If (FormDets.fdFieldClass = fdcHeader) Then
            Begin
              FormHeader := FormDets;
              Result := True;
            End // If (FormDets.fdFieldClass = fdcHeader)
            Else
            Begin
              FormDets := FormHeader;
              iStatus := XMLFile.NextNode;
              XMLFile.ReadNode(FormDets);
            End; // Else
          End; // While (iStatus = 0) And (Not Result)
        End; // If (iStatus = 0)
      Finally
        XMLFile.Free;
      End; // Try..Finallytry
    End; // If TXMLFile.Version(FileName).IsValid
  End; // If FileExists(sFilename)
End; // GetFormHeader

//-------------------------------------------------------------------------

Function GetFormCopies (Const Filename : String) : SmallInt;
Var
  KeyS       : Str255;
Begin
  Result := 1;

  If GetFormHeader (Filename, FormDetsRec^) Then
    Result := FormDetsRec^.Header.fhCopies;
end;

//-------------------------------------------------------------------------

Function GetFormOrient (Const Filename : String) : fdOrientationType;
Begin
  Result := fdoPortrait;

  If GetFormHeader (Filename, FormDetsRec^) Then
    Result := FormDetsRec^.Header.fhOrientation;
End;

//-------------------------------------------------------------------------

Function GetFormInfo (Const Filename : String) : FormInfoType;
Var
  I          : SmallInt;
Begin
  FillChar (Result, SizeOf (Result), #0);

  { Open details file }
  FileNames[FormDetsF] := SetDrive + FormsPath + Trim(FileName) + DefDotExtension;
  If FileExists (FileNames[FormDetsF]) Then Begin
    If GetFormHeader (Filename, FormDetsRec^) Then
    Begin
      With Result Do Begin
        Copies     := FormDetsRec^.Header.fhCopies;
        Orient     := FormDetsRec^.Header.fhOrientation;

        PrinterNo  := -1;    { Default }

        If (RpDev.Printers.Count > 0) And (Trim(FormDetsRec^.Header.fhPrinter) <> '') Then
          For I:=0 to Pred(RpDev.Printers.Count) Do
            If (UpperCase(FormDetsRec^.Header.fhPrinter) = UpperCase(Copy(RpDev.Printers[I], 1, Length(FormDetsRec^.Header.fhPrinter)))) Then Begin
              PrinterNo := I;
              Break;
            End; { If }

        BinNo := FormDetsRec^.Header.fhBinNo;
        PaperNo := FormDetsRec^.Header.fhPaperNo;

        FormHeader := FormDetsRec^.Header;
      End; { With }
    End; // If GetFormHeader (Filename, FormDetsRec^)
  End { If }
  Else
    If FileExists (SetDrive + FormsPath + Trim(FileName) + '.' + DefPCCExtension) Then
      With Result Do Begin
        GetDefPCCInfo (FormHeader.fhPrinter, PrinterNo, BinNo, PaperNo);

        Copies     := 1;
        {PrinterNo  := 0;}
        Orient     := fdoPortrait;
        {BinNo      := 0;}
        {PaperNo    := 0;}

        FormHeader.fhFormType := ftForm;
        FormHeader.fhCopies   := Copies;
        FormHeader.fhBinNo    := BinNo;
        FormHeader.fhPaperNo  := PaperNo;
      End; { With }
end;

{ Returns a number indicating the form type: 0-Virtual, 1=EFD, 2=PCC }
Function GetFormType (Const Filename : String) : Byte;
Begin { GetFormType }
  Result := 0;  { Virtual - Doesn't Exists }

  { Open details file }
  If FileExists (SetDrive + FormsPath + Trim(FileName) + DefDotExtension) Then
    { EFD }
    Result := 1
  Else
    If FileExists (SetDrive + FormsPath + Trim(FileName) + '.' + DefPCCExtension) Then
      Result := 2;
End; { GetFormType }

End.
