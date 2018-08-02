unit Test;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses GlobVar, VarConst, BtrvU2, BtSupU1, Dialogs, FileCtrl, SysUtils,
     Forms, Windows;

Procedure Open400BtrFiles;

Procedure Create400Companies;

Procedure Open400BtrFilesMk2;

implementation

Uses CompList;

Procedure Open400BtrFiles;
Var
  Msg           : String;
  I, J, lStatus : Integer;
  KeyS          : Str255;
Begin { Open400BtrFiles }
  Msg := 'Start: ' + TimeToStr(Now) + #13;

  J := 0;
  For I := 1 To 400 Do Begin
    lStatus := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
    If (lStatus = 0) Then Begin
      { Get First Record }
      KeyS := '';
      lStatus := Find_Rec(B_GetFirst, F[SysF], SysF, RecPtr[SysF]^, 0, KeyS);

      Close_File(F[SysF]);
    End { If }
    Else
      Break;

    Inc(J);
  End; { For I }

  Msg := Msg + 'Finish: ' + TimeToStr(Now) + #13 + 'Recs Processed: ' + IntToStr(J);
  ShowMessage (Msg);
End; { Open400BtrFiles }

Procedure Create400Companies;
Var
  TStr : AnsiString;
  I    : SmallInt;
Begin { Create400Companies }
  For I := 1 To 400 Do Begin
    Form_CompanyList.Caption := IntToStr(I);
    Application.ProcessMessages;

    ForceDirectories ('g:\bigcomp\' + IntToStr(I));

    TStr := 'g:\bigcomp\' + IntToStr(I) + '\exchqss.dat';
    CopyFile ('e:\ent430d5\exchqss.dat', PChar(TStr), True);
  End; { For I }
End; { Create400Companies }

Procedure Open400BtrFilesMk2;
Var
  Msg           : String;
  I, J, lStatus : Integer;
  KeyS          : Str255;
Begin { Open400BtrFiles }
  Msg := 'Start: ' + TimeToStr(Now) + #13;

  J := 0;
  For I := 1 To 400 Do Begin
    //lStatus := Open_File(F[SysF], 'G:\bigcomp\' + IntToStr(I) + '\' + FileNames[SysF], 0);
    lStatus := Open_File(F[SysF], 't:\temp\mark\bigcomp\' + IntToStr(I) + '\' + FileNames[SysF], 0);
    If (lStatus = 0) Then Begin
      { Get First Record }
      KeyS := '';
      lStatus := Find_Rec(B_GetFirst, F[SysF], SysF, RecPtr[SysF]^, 0, KeyS);

      Close_File(F[SysF]);
    End { If }
    Else
      Break;

    Inc(J);
  End; { For I }

  Msg := Msg + 'Finish: ' + TimeToStr(Now) + #13 + 'Recs Processed: ' + IntToStr(J);
  ShowMessage (Msg);
End; { Open400BtrFiles }


end.
