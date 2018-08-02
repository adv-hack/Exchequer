unit IssueU;

{ markd6 10:35 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, dialogs, SysUtils;

//----------------

Type
  SignatureType = String[5];

Const
  IssueSig   : SignatureType = #255#254#253#254#255;

  CurrentVer : SmallInt = 1;

  UtilsFName = 'Utils32.Dll';

//----------------

{ Writes the Issue Number details to the specified file }
Procedure WriteIssueNo (Const IssueFile : ShortString;
                        Const IssueNo   : SmallInt);

{ Reads the Issue Number from the specified file }
Function ReadIssueNo (Const IssueFile : ShortString) : SmallInt;

//--------------------------------------------------

implementation

//--------------------------------------------------

{ Writes the Issue Number details to the specified file }
Procedure WriteIssueNo (Const IssueFile : ShortString;
                        Const IssueNo   : SmallInt);
Var
  Len : SmallInt;
Begin { WriteIssueNo }
  { Check file exists before continuing }
  If FileExists(IssueFile) Then Begin
    { Add Version Info to end of DLL }
    With TFileStream.Create (IssueFile, fmOpenReadWrite Or fmShareExclusive) Do
      Try
        { Move to end }
        Position := Size;
        Len := -Size;

        { Write Signature }
        Write (IssueSig[1], Length(IssueSig));

        { Write Version No }
        Write (CurrentVer, SizeOf(CurrentVer));

        { Write Issue Number }
        Write (IssueNo, SizeOf(IssueNo));

        { Write Length }
        Len := Len + Size + SizeOf(Len);
        Write (Len, SizeOf(Len));
      Finally
        Free;
      End;
  End { If FileExists... }
  Else
    ShowMessage ('Invalid Issue File: ' + QuotedStr(IssueFile));
End; { WriteIssueNo }

//--------------------------------------------------

{ Reads the Issue Number from the specified file }
Function ReadIssueNo (Const IssueFile : ShortString) : SmallInt;
Var
  Sig             : SignatureType;
  Issue, Len, Ver : SmallInt;
Begin { ReadIssueNo }
  Result := -1;

  { Check file exists before continuing }
  If FileExists(IssueFile) Then Begin
    { Add Version Info to end of DLL }
    With TFileStream.Create (IssueFile, fmOpenRead) Do
      Try
        { Move to end }
        Position := Size - 2;

        { Read Data Length }
        Read (Len, SizeOf(Len));

        { Move to start of data section }
        Position := Size - Len;

        { Read and validate the signature }
        SetLength(Sig, 5);
        Read (Sig[1], Length(Sig));
        If (Sig = IssueSig) Then Begin
          { Read Version No }
          Read (Ver, SizeOf(Ver));
          If (Ver = CurrentVer) Then Begin
            { Read and Return Issue Number }
            Read (Issue, SizeOf(Issue));
            Result := Issue;
          End { If (Ver = CurrentVer) }
          Else
            Raise Exception.Create ('Unknown Issue Signature');
        End { If (Sig = IssueSig) }
        Else
          Raise Exception.Create ('Invalid Issue Signature');
      Finally
        Free;
      End;
  End { If FileExists... }
  Else
    Raise Exception.Create ('Invalid Issue File: ' + QuotedStr(IssueFile));
End; { ReadIssueNo }


end.
