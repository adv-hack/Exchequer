unit DevReg;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, FileCtrl, Forms, IniFiles, SysUtils, Windows,
     GlobVar, VarConst, VarCnst3;

Type
  { Developer Data Types }
  DeveloperInfoType = Record
    diSysId       : LongInt;                { Developers System Id }
    diDevName     : String[30];             { Developers Company Name }

    diSpare       : Array[1..100] Of Char;  { For Future Use }
    diLastChar    : Char;                   { For Word Alignment Testing }
  End; { DeveloperInfoType }

  DeveloperDataType = Record
    ddIdx1        : String[20];
    ddIdx2        : String[35];
    ddIdx3        : String[20];

    ddData        : Array [1..654] Of Byte;
    ddLastChar    : Char;
  End; { DeveloperDataType }




Function EX_GETDEVELOPERINFO (PDevInfo     : Pointer;
                              PDevInfoSize : SmallInt;
                              SystemDir    : PChar) : SmallInt;
                              StdCall; Export;

implementation


//  1000    Unknown Error
//  1001    Unknown Exception
//  1002    System directory invalid
//  1003    EntCustm.Ini not found in SystemDir
Function EX_GETDEVELOPERINFO (PDevInfo     : Pointer;
                              PDevInfoSize : SmallInt;
                              SystemDir    : PChar) : SmallInt;
Var
  DevInfo : ^DeveloperInfoType;
  IniF    : TIniFile;
  StrList : TStrings;
  BitList : TBits;
  SysDir  : String;
  Idx, I  : LongInt;
Begin { Ex_GetDeveloperInfo }
  Result := 1000; { Unknown Error }

  Try
    { Dereference pointer to local variable }
    DevInfo := PDevInfo;

    { Copy system directory into local string and check format }
    SysDir := IncludeTrailingBackslash(SystemDir);

    { Check system directory exists }
    If DirectoryExists (SysDir) Then Begin
      { Check for EntCustm.Ini }
      If FileExists (SysDir + 'ENTCUSTM.INI') Then Begin
        IniF := TIniFile.Create(SysDir + 'ENTCUSTM.INI');

        Try
          Idx := IniF.ReadInteger ('DevData', UpperCase(DevInfo.diDevName), -1);

          If (Idx = -1) Then Begin
            { Entry not found - create new entry }
            StrList := TStringList.Create;
            Try
              BitList := TBits.Create;
              Try
                { Max 1024 Developers - Should cover it OK :-) }
                BitList.Size := 1024;
                BitList[0] := True;

                { Read existing developer names into StringList }
                IniF.ReadSection ('DevData', StrList);

                If (StrList.Count > 0) Then
                  { Mark off any pre-allocated numbers in BitList array }
                  For I := 0 To Pred(StrList.Count) Do Begin
                    { Read developer SysId }
                    Idx := IniF.ReadInteger ('DevData', StrList.Strings[I], -1);

                    If (Idx > -1) Then
                      { Mark as used in BitList array }
                      BitList[Idx] := True;
                  End; { For I }

                { Allocate next available slot }
                DevInfo.diSysId := BitList.OpenBit;
                BitList[DevInfo.diSysId] := True;

                { Add entry into entCustm.Ini file }
                IniF.WriteInteger ('DevData', UpperCase(DevInfo.diDevName), DevInfo.diSysId);

                Result := 0;
              Finally
                BitList.Destroy;
              End;
            Finally
              StrList.Destroy;
            End;
          End { If (Idx < -1) }
          Else Begin
            { Got Id - return in DevInfo }
            DevInfo.diSysId := Idx;
            Result := 0;
          End; { Else }
        Finally
          IniF.Destroy;
        End;
      End { If FileExists (SysDir + 'ENTCUSTM.INI') }
      Else
        { EntCustm.Ini not found in SystemDir }
        Result := 1003;
    End { If DirectoryExists (SystemDir) }
    Else
      { System directory invalid }
      Result := 1002;
  Except
    On Exception Do
      Result := 1001; { Unknown Exception }
  End;
End; { Ex_GetDeveloperInfo }


end.

