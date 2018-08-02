unit DllFunc;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

interface

Uses Dialogs, FileCtrl, Forms, IniFiles, SysUtils, Windows;

Type
  TCompanyType = Record
    CompCode   : String [6];      { Company Code  }
    CompName   : String [45];     { Company Name  }
    CompPath   : String [100];    { Company Path - Short DOS 8.3 Format }

    CompSpare  : Array [1..100] Of Char;
  End; { TCompanyType }

  TCompanyTypePtr = ^TCompanyType;

  //------------------------------

  TCompanyType2 = Record
    CompCode    : String [6];      { Company Code  }
    CompName    : String [45];     { Company Name  }
    CompPath    : String [100];    { Company Path - Short DOS 8.3 Format }
    CompConnect : String [255];    { Connection Info - for future use }

    CompSpare   : Array [1..100] Of Char;
  End; // TCompanyType2

  TCompanyType2Ptr = ^TCompanyType2;

  //------------------------------


Function EX_GETCOMPANY(    COMPDIR    : PCHAR;
                           PARRAY     : POINTER;
                       VAR PARRAYSIZE : LONGINT) : SMALLINT;
                       STDCALL EXPORT;

 
Function EX_GETCOMPANY2(    COMPDIR    : PCHAR;
                            PARRAY     : POINTER;
                        VAR PARRAYSIZE : LONGINT) : SMALLINT;
                        STDCALL EXPORT;


implementation

Uses GlobVar, VarConst, BtrvU2,
{$IFDEF EXSQL}
  SQLUtils,
{$ENDIF}
  BtKeys1U{, FormUtil};

Const
  {$I FilePath.Inc}


{ 32765 - Array Pointer is dud }
{ 32766 - Btrieve Not Running }
{ 32767 - Invalid Company Path }
Function LoadCompanyList(Const Mode       : Byte;
                               COMPDIR    : PCHAR;
                               PARRAY     : POINTER;
                         VAR   PARRAYSIZE : LONGINT) : SMALLINT;
Const
  FNum    = CompF;
  KeyPath : Integer = CompCodeK;
  RecSizes : Array[1..2] Of SmallInt = (SizeOf(TCompanyType), SizeOf(TCompanyType2));
Var
  IniF               : TIniFile;
  KeyS               : Str255;
  ArrayLen, ArrayPos : SmallInt;
  PCompany           : TCompanyTypePtr;
  PCompany2          : TCompanyType2Ptr;
  ConStr: WideString;  //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords

  Function DirOK (Const ChkDir : ShortString) : Boolean;
  Begin { DirOK }
{$IFDEF EXSQL}
    Result := SQLUtils.ValidSystem(ChkDir);
{$ELSE}
    Result := DirectoryExists (ChkDir) And
              FileExists (ChkDir + 'COMPANY.DAT') And
              FileExists (ChkDir + Path1 + CustName) And
              FileExists (ChkDir + Path2 + DocName);
{$ENDIF}
  End; { DirOK }

Begin { LoadCompanyList }
  Result := 0;

  { Initialise passed array }
  FillChar(PArray^, PArraySize, #0);

  SetDrive := StrPas(CompDir);
  If (Length(SetDrive) > 3) Then Begin
    If (SetDrive[Length(SetDrive)] <> '\') Then Begin
      SetDrive := SetDrive + '\';
    End; { If }

    // HM 25/08/04: Changed to use Delphi function to remove dependancy on FormDes code
    //SetDrive := PathToShort (SetDrive);
    SetDrive := ExtractShortPathName(SetDrive);
  End { If }
  Else Begin
    { Invalid Company Path }
    Result := 32767;
  End; { Else }

  If (Result = 0) Then Begin
    { Check for ENTWREPL.INI configuration file }
    If FileExists (SetDrive + 'ENTWREPL.INI') Then Begin
      IniF := TIniFile.Create (SetDrive + 'ENTWREPL.INI');
      Try
        KeyS := IniF.ReadString ('UpdateEngine', 'NetworkDir', '');
        If (Length(KeyS) > 3) Then Begin
          If (KeyS[Length(KeyS)] <> '\') Then Begin
            KeyS := KeyS + '\';
          End; { If }

          { Check the path is valid }
          If DirOK (KeyS) Then Begin
            { Convert to short date format }
            // HM 25/08/04: Changed to use Delphi function to remove dependancy on FormDes code
            //SetDrive := PathToShort (KeyS);
            SetDrive := ExtractShortPathName(KeyS);
          End; { If }
        End; { If }
      Finally
        IniF.Destroy;
      End;
    End; { If }

    { Check SetDrive for a valid company directory }
    If Not DirOK (SetDrive) Then Begin
      { Invalid Company Path }
      Result := 32767;
    End; { If }
  End; { If }

  ArrayLen := 0;
  If (Result = 0) Then Begin
    { Check Pointer Parameter }
    If Assigned(PArray) And
       //((PArraySize Mod Sizeof(TCompanyType)) = 0) And
       ((PArraySize Mod RecSizes[Mode]) = 0) And
       (PArraySize > 1) Then Begin
      //ArrayLen := (PArraySize Div Sizeof(TCompanyType));
      ArrayLen := (PArraySize Div RecSizes[Mode]);
    End { If }
    Else Begin
      { Array Pointer is dud }
      Result := 32765;
    End; { Else }
  End; { If }

  If (Result = 0) Then Begin
    { Start Btrieve and open database }
    If Check4BtrvOk Then Begin
      { Open company database }
      Result := Open_File(F[CompF], SetDrive + FileNames[CompF], 0);
      If (Result = 0) Then Begin
        ArrayPos := 1;

        KeyS := cmCompDet + #0;
        Result := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
        While (Result = 0) And (Company^.RecPFix = cmCompDet) And (ArrayPos <= ArrayLen) Do Begin
          { Copy Company Details Into Array }
          If (Mode = 1) Then
          Begin
            // Ex_GetCompany
            PCompany := TCompanyTypePtr(LongInt(PArray) + (Pred(ArrayPos) * RecSizes[Mode]));
            PCompany^.CompCode := Company^.CompDet.CompCode;
            PCompany^.CompName := Company^.CompDet.CompName;
            PCompany^.CompPath := Company^.CompDet.CompPath;
          End // If (Mode = 1)
          Else If (Mode = 2) Then
          Begin
            PCompany2 := TCompanyType2Ptr(LongInt(PArray) + (Pred(ArrayPos) * RecSizes[Mode]));
            PCompany2^.CompCode := Company^.CompDet.CompCode;
            PCompany2^.CompName := Company^.CompDet.CompName;
            PCompany2^.CompPath := Company^.CompDet.CompPath;
{$IFDEF EXSQL}
            // PCompany2^.CompConnect := SQLUtils.GetConnectionString(PCompany2^.CompCode, True, nil);

            if SQLUtils.GetConnectionString(PCompany2^.CompCode, True, ConStr, nil) = 0 then
              PCompany2^.CompConnect := ConStr;
{$ENDIF}
          End; // If (Mode = 2)
          Inc (ArrayPos);

          Result := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
        End; { While }

        PArraySize := Pred (ArrayPos);

        { Close file }
        Close_File(F[CompF]);
      End; { If }
    End { If }
    Else Begin
      { Btrieve Not Running }
      Result := 32766;
    End; { Else }
  End; { If }
End; { LoadCompanyList }

//-------------------------------------------------------------------------

Function EX_GETCOMPANY(    COMPDIR    : PCHAR;
                           PARRAY     : POINTER;
                       VAR PARRAYSIZE : LONGINT) : SMALLINT;
Begin // EX_GETCOMPANY
  Result := LoadCompanyList (1, CompDir, PArray, PArraySize);
End; // EX_GETCOMPANY

//------------------------------

Function EX_GETCOMPANY2(    COMPDIR    : PCHAR;
                           PARRAY     : POINTER;
                       VAR PARRAYSIZE : LONGINT) : SMALLINT;
Begin // EX_GETCOMPANY
  Result := LoadCompanyList (2, CompDir, PArray, PArraySize);
End; // EX_GETCOMPANY

//-------------------------------------------------------------------------


end.
