unit PlugInDB;

interface

Uses Classes, DateUtils, Dialogs, Forms, IniFiles, SysUtils;

Type
  PlugInRecType = Record
    piCode        : String[16];    // Plug-In ID Code
    piName        : String[100];    // Plug-in Description
    piExpiry      : TDateTime;     // Licence Expiry Date
  End; { PlugInRecType }

  TEnumDealerPlugInsProc = Procedure (Const PlugInRec : PlugInRecType) Of Object;


Procedure EnumDealerPlugIns (Const DealerCode : ShortString; EnumProc : TEnumDealerPlugInsProc);
Function InitNewPlugIn : PlugInRecType;
Function LoadPlugIn (Const PlugInCode : ShortString) : PlugInRecType;
Procedure SavePlugIn (Const DealerCode : ShortString; Const PlugInDets : PlugInRecType; Const Add : Boolean);
Function PlugInExists (Const PlugInCode : ShortString) : Boolean;
Procedure DeletePlugIn (Const DealerCode, PlugInCode : ShortString);
Function PlugInNumberUnique (Const PlugInCode : ShortString) : Boolean;

implementation

Uses DlrDB;

//---------------------------------------------------------------------------

Procedure EnumDealerPlugIns (Const DealerCode : ShortString; EnumProc : TEnumDealerPlugInsProc);
Var
  PlugInList : TStringList;
  PlugInCode : String[16];
  I          : SmallInt;
Begin { EnumDealerPlugIns }
  With TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT')) Do
    Try
      PlugInList := TStringList.Create;
      Try
        // Load the list of Dealer Codes
        ReadSectionValues (DealerCode + '_PLUGINS', PlugInList);

        If (PlugInList.Count > 0) Then
          // Run through the dealer list reading the details and adding them into the ListView
          For I := 0 To Pred(PlugInList.Count) Do Begin
            // Get Dealer Code
            PlugInCode := PlugInList.Values[PlugInList.Names[I]];

            // Call Enum proc with full dealer record
            EnumProc (LoadPlugIn (PlugInCode));
          End; { For I }
      Finally
        FreeAndNil(PlugInList);
      End;
    Finally
      Free;
    End;
End; { EnumDealerPlugIns }

//---------------------------------------------------------------------------

Function LoadPlugIn (Const PlugInCode : ShortString) : PlugInRecType;
Begin { LoadPlugIn }
  FillChar (Result, SizeOf (Result), #0);

  With TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT')), Result Do
    Try
      // Plug-In ID Code
      piCode       := UpperCase(PlugInCode);

      // Plug-in Description
      piName       := ReadString (PlugInCode, 'Name', '');

      // Licence Expiry Date
      Try
        piExpiry := StrToDate (ReadString (PlugInCode, 'PlugInExpiry', FormatDateTime('DD/MM/YYYY', Now - 1)));
      Except
        On E : Exception Do
          ShowMessage ('PlugIn='+PlugInCode+', Expiry='+ReadString (PlugInCode, 'PlugInExpiry', '')+#13#13+E.Message);
      End;
    Finally
      Free;
    End;
End; { LoadPlugIn }

//---------------------------------------------------------------------------

Function InitNewPlugIn : PlugInRecType;
Begin { InitNewPlugIn }
  FillChar (Result, SizeOf (Result), #0);
  With Result Do Begin

    piExpiry := IncYear (Now, 1);
  End; { With }
End; { InitNewPlugIn }

//---------------------------------------------------------------------------

Procedure SavePlugIn (Const DealerCode : ShortString; Const PlugInDets : PlugInRecType; Const Add : Boolean);
Var
   IniF : TIniFile;
Begin { SavePlugIn }
  IniF := TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT'));
  Try
    With IniF, PlugInDets Do Begin
      // Save Plug-In Details
      WriteString (piCode, 'Name', piName);
      WriteString (piCode, 'PlugInExpiry', FormatDateTime('DD/MM/YYYY', piExpiry));

      If Add Then Begin
        // Add Plug-In Code into Plug-Ins List
        WriteString ('PlugIns', IntToStr(GetNextCode(IniF, 'PlugIns')), piCode);

        // Add Plug-In into the Dealers list of Plug-Ins
        WriteString (DealerCode + '_PLUGINS', IntToStr(GetNextCode(IniF, DealerCode + '_PLUGINS')), piCode);
      End; { If Add }
    End; { With IniF, DealerDets }
  Finally
    IniF.UpdateFile;
    FreeAndNil(IniF);
  End;
End; { SavePlugIn }

//---------------------------------------------------------------------------

Function PlugInExists (Const PlugInCode : ShortString) : Boolean;
Begin { PlugInExists }
  With TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT')) Do
    Try
      Result := SectionExists (PlugInCode);
    Finally
      Free;
    End;
End; { PlugInExists }

//---------------------------------------------------------------------------

Procedure DeletePlugIn (Const DealerCode, PlugInCode : ShortString);
Var
  PlugInList : TStringList;
  IniF       : TIniFile;
  I          : SmallInt;
Begin { DeletePlugIn }
  IniF := TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT'));
  Try
    With IniF Do Begin
      // Delete Plug-In Details
      EraseSection (PlugInCode);

      PlugInList := TStringList.Create;
      Try
        // Remove Plug-In from the Dealers list of Plug-Ins
        ReadSectionValues (DealerCode + '_PLUGINS', PlugInList);
        If (PlugInList.Count > 0) Then
          // Run through the dealer list reading the details and adding them into the ListView
          For I := 0 To Pred(PlugInList.Count) Do
            // Get Dealer Code
            If (PlugInList.Values[PlugInList.Names[I]] = PlugInCode) Then Begin
              DeleteKey (DealerCode + '_PLUGINS', PlugInList.Names[I]);
              Break;
            End; { If }

        // Erase Plug-In Code from Plug-Ins List
        ReadSectionValues ('PLUGINS', PlugInList);
        If (PlugInList.Count > 0) Then
          // Run through the dealer list reading the details and adding them into the ListView
          For I := 0 To Pred(PlugInList.Count) Do
            // Get Dealer Code
            If (PlugInList.Values[PlugInList.Names[I]] = PlugInCode) Then Begin
              DeleteKey ('PLUGINS', PlugInList.Names[I]);
              Break;
            End; { If }
      Finally
        FreeAndNil(PlugInList);
      End;
    End; { With IniF }
  Finally
    IniF.UpdateFile;
    FreeAndNil(IniF);
  End;
End; { DeletePlugIn }

//---------------------------------------------------------------------------

Function PlugInNumberUnique (Const PlugInCode : ShortString) : Boolean;
Var
  PlugInList   : TStringList;
  I            : SmallInt;
Begin { PlugInNumberUnique }
  Result := True;

  With TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT')) Do
    Try
      PlugInList := TStringList.Create;
      Try
        // Load the list of Dealer Codes
        ReadSectionValues ('PlugIns', PlugInList);

        If (PlugInList.Count > 0) Then
          // Run through the dealer list reading the details and adding them into the ListView
          For I := 0 To Pred(PlugInList.Count) Do
            // Compare numerical section against the Plug-In in the list
            If (Copy (PlugInCode, 11, 6) = Copy (PlugInList.Values[PlugInList.Names[I]], 11, 6)) Then Begin
              // Error - match found
              Result := False;
              Break;
            End; { If }
      Finally
        FreeAndNil(PlugInList);
      End;
    Finally
      Free;
    End;
End; { PlugInNumberUnique }

//---------------------------------------------------------------------------

end.
