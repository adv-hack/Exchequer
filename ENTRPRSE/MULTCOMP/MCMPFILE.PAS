{ Contains definitions of the Multi-Company Btrieve Files }


{ Function to return position of field within a record }
Function BKeyPos (Const OfsField, OfsRec : Pointer) : Word;
Var
  OfR, OfF : LongInt;
Begin { BKeyPos }
  OfR := LongInt(OfsRec);
  OfF := LongInt(OfsField);

  If (OfF > OfR) Then
    BKeyPos := (OfF - OfR) + 1
  Else
    BKeyPos := 1;
End;  { BKeyPos }


{ setup Company file }
Procedure DefineCompany;
Const
  Idx = CompF;
Begin
  FileSpecLen[Idx]:=Sizeof(CompFile);
  Fillchar(CompFile,FileSpecLen[Idx],0);

  With CompFile do Begin
    RecLen:=Sizeof(Company^);
    PageSize:=DefPageSize3;  //2k
    NumIndex:=CompNofKeys;

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    { Index 0 - RecPFix + Company Code  (CompCodeK) }
    KeyBuff[1].KeyPos:=BKeyPos(@Company^.RecPFix, @Company^);
    KeyBuff[1].KeyLen:=1;
    KeyBuff[1].KeyFlags:=ModSeg;
    KeyBuff[2].KeyPos:=BKeyPos(@Company^.CompDet.CompCode, @Company^) + 1;
    KeyBuff[2].KeyLen:=CompCodeLen;
    KeyBuff[2].KeyFlags:=Modfy+AltColSeq;

    { Index 1 - RecPFix + Company Path  (CompPathK) }
    KeyBuff[3].KeyPos:=BKeyPos(@Company^.RecPFix, @Company^);
    KeyBuff[3].KeyLen:=1;
    KeyBuff[3].KeyFlags:=ModSeg;
    KeyBuff[4].KeyPos:=BKeyPos(@Company^.CompDet.CompPath, @Company^) + 1;
    KeyBuff[4].KeyLen:=CompPathLen;
    KeyBuff[4].KeyFlags:=Modfy+AltColSeq;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  end; {With..}

  FileRecLen[Idx]:=Sizeof(Company^);

  Fillchar(Company^,FileRecLen[Idx],0);

  RecPtr[Idx]:=@Company^;

  FileSpecOfs[Idx]:=@CompFile;

  FileNames[Idx]:=MultCompNam;
end; {..}

{$IFNDEF COMTK}
{$IFNDEF OLE}
Procedure LoadCompanyOpt;
Var
  KeyS : Str255;
begin
  { Load Company Options Record }
  KeyS := cmSetup + CmSetupCode;
  Status := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^,CompCodeK,KeyS);
  If Not StatusOK Then Begin
    FillChar (Company^, SizeOf (Company^), #0);

    With Company^, CompOpt Do Begin
      RecPFix := cmSetup;
      OptCode := CmSetupCode;
    End; { With }

    Status := Add_Rec(F[CompF],CompF,RecPtr[CompF]^,CompCodeK);
  End;

  SyssCompany^ := Company^;
end; { LoadCompanyOpt }

{$IFNDEF HKSEC}
{$IFNDEF BUREAUDLL}
Function LoadnLockCompanyOpt : Boolean;
Var
  KeyS     : Str255;
  Locked   : Boolean;
Begin { LoadnLockCompanyOpt }
  KeyS := cmSetup + CmSetupCode;
  Result := GetMultiRec(B_GetEq, B_MultLock, KeyS, CompCodeK, CompF, True, Locked);
  SyssCompany^ := Company^;
End; { LoadnLockCompanyOpt }

Procedure PutCompanyOpt (Const Unlock : Boolean);
Var
  RecPos  : LongInt;
  LStatus : SmallInt;
Begin { PutCompanyOpt }
  // Update record
  LStatus:=Put_Rec(F[CompF],CompF,SyssCompany^,CompCodeK);

  If Unlock Then Begin
    // unlock it
    GetPos(F[CompF],CompF,RecPos);
    UnlockMultiSing(F[CompF],CompF,RecPos);
  End; { If }
End; { PutCompanyOpt }
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
