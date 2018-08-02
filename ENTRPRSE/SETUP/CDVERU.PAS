unit CDVerU;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses SysUtils;

function FindCDVer(    VerPath   : String;
                   Var VerString : String;
                   Var UCount    : SmallInt;
                   Var ClServer  : Boolean) : Boolean;

implementation


{ Gets the CD Version based on the ~Mc... files }
function FindCDVer(    VerPath   : String;
                   Var VerString : String;
                   Var UCount    : SmallInt;
                   Var ClServer  : Boolean) : Boolean;
var
  Ext : String;
  F   : TSearchRec;
begin { FindCDVer }
  Result    := False;

  VerString := '';
  UCount    := 0;
  ClServer  := False;

  { Get path of help file }
  If (VerPath[Length(VerPath)] <> '\' ) Then
    VerPath := VerPath + '\~*.u*'
  Else
    VerPath := VerPath + '~*.u*';

  If (FindFirst (VerPath, faAnyFile, F) = 0) Then Begin
    Result := True;

    F.Name := UpperCase(F.Name);

    If (Pos('PF', F.Name) > 0) Then
      VerString := VerString + 'Professional/'
    Else
      VerString := VerString + 'Global/';
    If (Pos('SOP', F.Name) > 0) Then VerString := VerString + 'SOP/';
    If (Pos('STK', F.Name) > 0) Then VerString := VerString + 'STK/';
    If (Pos('CS.', F.Name) > 0) Then Begin
      VerString := VerString + 'CS/';
      ClServer := True;
    End; { If }

    Ext := ExtractFileExt(F.Name);
    If (Length(Ext) > 2) Then Begin
      { Extract user count - delete '.U' part of extension }
      Delete (Ext, 1, 2);
      VerString := VerString + Ext;

      Try
        { Calculate user count }
        UCount := StrToInt(Ext);
      Except
        On E:Exception Do
          ;
      End;
    End; { If }

    If (Length(VerString) > 0) Then Begin
      { Take off any crud at the end }
      If (VerString[Length(VerString)] = '/') Then
        Delete (VerString, Length(VerString), 1);
    End; { If }
  End; { If }
  FindClose(F);
end; { FindCDVer }



end.
