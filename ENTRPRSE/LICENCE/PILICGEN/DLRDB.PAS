unit DlrDB;

interface

Uses Classes, DateUtils, Dialogs, Forms, IniFiles, SysUtils;

Type
  DealerRecType = Record
    dlrCode       : String[6];     // Enterprise Account Code
    dlrCompany    : String[45];    // Company Name
    dlrContact    : String[30];    // Contact Name
    dlrPhone      : String[30];    // Contact Phone Number
    dlrEmail      : String[100];   // Email Address for Licence Files
    dlrExpiry     : TDateTime;     // Licence Expiry Date
    dlrComments   : String[200];   // Any comments
  End; { DealerRecType }

  TEnumDealersProc = Procedure (Const DealerRec : DealerRecType) Of Object;


Procedure EnumDealers (EnumProc : TEnumDealersProc);
Function InitNewDealer : DealerRecType;
Function LoadDealer (Const DealerCode : ShortString) : DealerRecType;
Procedure SaveDealer (Const DealerDets  : DealerRecType; const Add : Boolean);
Function DealerExists (Const DealerCode : ShortString) : Boolean;
Procedure DeleteDealer (Const DealerCode : ShortString);

Function GetNextCode(Var IniF : TIniFile; Const SectName : ShortString) : SmallInt;

implementation

Uses PlugInDB;

//---------------------------------------------------------------------------

Function GetNextCode(Var IniF : TIniFile; Const SectName : ShortString) : SmallInt;
Var
  SectionList : TStringList;
  I           : SmallInt;
Begin { GetNextCode }
  Result := 0;

  With IniF Do Begin
    SectionList := TStringList.Create;
    Try
      // Load the list of Section Codes
      ReadSection (SectName, SectionList);

      // Find next available code number
      For I := 1 To 9999 Do
        If (SectionList.IndexOf(IntToStr(I)) = -1) Then Begin
          Result := I;
          Break;
        End; { If }
    Finally
      FreeAndNil(SectionList);
    End;
  End; { With IniF }
End; { GetNextCode }

//---------------------------------------------------------------------------

Procedure EnumDealers (EnumProc : TEnumDealersProc);
Var
  DealerList : TStringList;
  DlrCode    : String[10];
  I          : SmallInt;
Begin { EnumDealers }
  With TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT')) Do
    Try
      DealerList := TStringList.Create;
      Try
        // Load the list of Dealer Codes
        ReadSectionValues ('DEALERS', DealerList);

        If (DealerList.Count > 0) Then
          // Run through the dealer list reading the details and adding them into the ListView
          For I := 0 To Pred(DealerList.Count) Do Begin
            // Get Dealer Code
            DlrCode := DealerList.Values[DealerList.Names[I]];

            // Call Enum proc with full dealer record
            EnumProc (LoadDealer (DlrCode));
          End; { For I }
      Finally
        FreeAndNil(DealerList);
      End;
    Finally
      Free;
    End;
End; { EnumDealers }

//---------------------------------------------------------------------------

Function InitNewDealer : DealerRecType;
Begin { InitNewDealer }
  FillChar (Result, SizeOf (Result), #0);
  With Result Do Begin

    dlrExpiry := IncMonth (Now, 3);
  End; { With }
End; { InitNewDealer }

//---------------------------------------------------------------------------

Function LoadDealer (Const DealerCode : ShortString) : DealerRecType;
Begin { LoadDealer }
  FillChar (Result, SizeOf (Result), #0);

  With TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT')), Result Do
    Try
      // Enterprise Account Code
      dlrCode       := UpperCase(DealerCode);

      // Company Name
      dlrCompany    := ReadString (DlrCode, 'Name', '');

      // Contact Name
      dlrContact    := ReadString (DlrCode, 'Contact', '');

      // Contact Phone Number
      dlrPhone      := ReadString (DlrCode, 'Phone', '');

      // Email Address for Licence Files
      dlrEmail      := ReadString (DlrCode, 'Email', '');

      // Licence Expiry Date
      Try
        dlrExpiry := StrToDate (ReadString (DlrCode, 'LicenceExpiry', FormatDateTime('DD/MM/YYYY', Now - 1)));
      Except
        On E : Exception Do
          ShowMessage ('Dealer='+DlrCode+', Expiry='+ReadString (DlrCode, 'LicenceExpiry', '')+#13#13+E.Message);
      End;

      // Any comments
      dlrComments   := ReadString (DlrCode, 'Comments', '');
    Finally
      Free;
    End;
End; { LoadDealer }

//---------------------------------------------------------------------------

Procedure SaveDealer (Const DealerDets  : DealerRecType; Const Add : Boolean);
Var
   IniF : TIniFile;
Begin { SaveDealer }
  IniF := TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT'));
  Try
    With IniF, DealerDets Do Begin
      // Save Dealer Detail
      WriteString (dlrCode, 'Name', dlrCompany);
      WriteString (dlrCode, 'Contact', dlrContact);
      WriteString (DlrCode, 'Phone', dlrPhone);
      WriteString (DlrCode, 'Email', dlrEmail);
      WriteString (DlrCode, 'LicenceExpiry', FormatDateTime('DD/MM/YYYY', dlrExpiry));
      WriteString (DlrCode, 'Comments', dlrComments);

      If Add Then
        // Add Dealer code into Dealers List
        WriteString ('Dealers', IntToStr(GetNextCode(IniF, 'Dealers')), dlrCode);
    End; { With IniF, DealerDets }
  Finally
    IniF.UpdateFile;
    FreeAndNil(IniF);
  End;
End; { SaveDealer }

//---------------------------------------------------------------------------

Function DealerExists (Const DealerCode : ShortString) : Boolean;
Begin { DealerExists }
  With TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT')) Do
    Try
      Result := SectionExists (DealerCode);
    Finally
      Free;
    End;
End; { DealerExists }

//---------------------------------------------------------------------------

Procedure DeleteDealer (Const DealerCode : ShortString);
Var
  DealerList : TStringList;
  I          : SmallInt;
Begin { DeleteDealer }
  With TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT')) Do
    Try
      // Delete entry in Dealers List
      DealerList := TStringList.Create;
      Try
        // Load the list of Dealer Codes
        ReadSectionValues ('DEALERS', DealerList);

        If (DealerList.Count > 0) Then
          // Run through the dealer list reading the details and adding them into the ListView
          For I := 0 To Pred(DealerList.Count) Do
            // Get Dealer Code
            If (DealerList.Values[DealerList.Names[I]] = DealerCode) Then Begin
              DeleteKey ('Dealers', DealerList.Names[I]);
              Break;
            End; { If }

        // Delete Dealers Plug-Ins
        ReadSectionValues (DealerCode + '_PLUGINS', DealerList);
        If (DealerList.Count > 0) Then
          // Run through the dealer list reading the details and adding them into the ListView
          For I := 0 To Pred(DealerList.Count) Do
            // Delete Plug-In
            DeletePlugIn (DealerCode, DealerList.Values[DealerList.Names[I]]);
            //EraseSection(DealerList.Values[DealerList.Names[I]]);
    Finally
        FreeAndNil(DealerList);
      End;

      // Delete Dealer Plug-Ins List
      EraseSection (DealerCode + '_PLUGINS');

      // Delete Dealer Detail section
      EraseSection (DealerCode);
    Finally
      UpdateFile;
      Free;
    End;
End; { DeleteDealer }

//---------------------------------------------------------------------------

end.

