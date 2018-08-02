unit LabelU;

interface

Uses Classes, Dialogs, Forms, Graphics, IniFiles, SysUtils, Windows, TCustABS;

Function EntDoCustomText(Const WindowId : LongInt) : Boolean; Export;
Procedure EntGetCustomText(CustomText : TAbsCustomText); Export;

Procedure AddCustomText (Const WindowId, TextId                                   : LongInt;
                         Const Caption, FontName                                  : ShortString;
                         Const FontSize                                           : SmallInt;
                         Const FontBold, FontItalic, FontUnderline, FontStrikeOut : WordBool;
                         Const FontColorRed, FontColorGreen, FontColorBlue        : SmallInt); Export; StdCall;


implementation

Uses ChainU;

Type
  CustomTextInfoType = Record
    ctiWindowId   : LongInt;
    ctiTextId     : LongInt;

    ctiCaption    : ShortString;
    ctiFontName   : TFontName;
    ctiSize       : Integer;
    ctiStyle      : TFontStyles;

    ctiColorRed   : SmallInt;
    ctiColorBlue  : SmallInt;
    ctiColorGreen : SmallInt;
  End; { CustomTextInfoType }

Var
  lstWindows, lstCustomText : TStringList;

//----------------------------------------------------------------------------

// Interface function called by COM Label Customisation to add info into the internal
// label customisation database
Procedure AddCustomText (Const WindowId, TextId                                   : LongInt;
                         Const Caption, FontName                                  : ShortString;
                         Const FontSize                                           : SmallInt;
                         Const FontBold, FontItalic, FontUnderline, FontStrikeOut : WordBool;
                         Const FontColorRed, FontColorGreen, FontColorBlue        : SmallInt);
Var
  CustomTextInfo : ^CustomTextInfoType;
  TmpStr         : ShortString;
Begin { AddCustomText }
  If Assigned(lstWindows) And Assigned(lstCustomText) Then Begin
    // Add Entry into Windows list to identify the window as being customised
    TmpStr := Format ('%15.15d', [WindowId]);
    If (lstWindows.IndexOf (TmpStr) = -1) Then
      lstWindows.Add (TmpStr);

    // Add Entry into CustomText list containing the customisation details
    TmpStr := Format ('%15.15d/%15.15d', [WindowId, TextId]);
    If (lstCustomText.IndexOf (TmpStr) = -1) Then Begin
      // Add new CustomText entry into the list
      New (CustomTextInfo);
      With CustomTextInfo^ Do Begin
        ctiWindowId := WindowId;
        ctiTextId   := TextId;

        ctiCaption  := Caption;
        ctiFontName := FontName;
        ctiSize     := FontSize;
        ctiStyle    := [];
        If FontBold Then Include (ctiStyle, fsbold);
        If FontItalic Then Include (ctiStyle, fsItalic);
        If FontUnderline Then Include (ctiStyle, fsUnderline);
        If FontStrikeOut Then Include (ctiStyle, fsStrikeOut);

        ctiColorRed   := FontColorRed;
        ctiColorBlue  := FontColorGreen;
        ctiColorGreen := FontColorBlue;
      End; { With CustomTextInfo^ }
      lstCustomText.AddObject (TmpStr, TObject(CustomTextInfo));
    End; { If (lstCustomText.IndexOf (TmpStr) = -1) }
  End { If Assigned(lstWindows) ... }
End; { AddCustomText }

//----------------------------------------------------------------------------

{ Returns True if the specified window has customisation strings defined }
Function EntDoCustomText(Const WindowId : LongInt) : Boolean;
Begin
  If Assigned(lstWindows) And Assigned(lstCustomText) Then
    // Check local Window List DB for the Window Id
    Result := (lstWindows.IndexOf (Format ('%15.15d', [WindowId])) >= 0)
  Else
    // Local Text customisation not configured
    Result := False;

  If (Not Result) Then
    { Not Customised - pass on to next customisation DLL }
    Result := DLLChain.EntDoCustomText(WindowId);
End;

//----------------------------------------------------------------------------

{ Returns the custom text settings }
Procedure EntGetCustomText(CustomText : TAbsCustomText);
Var
  CustomTextInfo : ^CustomTextInfoType;
  lstIndex       : SmallInt;
  PassOn         : Boolean;
Begin { EntGetCustomText }
  PassOn := True;

  // Check the local CustomText List for customisation details
  If Assigned(lstWindows) And Assigned(lstCustomText) Then
    With CustomText Do Begin
      // Add Entry into CustomText list containing the customisation details
      LstIndex := lstCustomText.IndexOf (Format('%15.15d/%15.15d', [WindowId, TextId]));
      If (LstIndex >= 0) Then Begin
        // Got Local Customisation - extract customisation info
        CustomTextInfo := Pointer(lstCustomText.Objects[LstIndex]);

        With CustomTextInfo^ Do Begin
          // Copy details from Local DB into CustomText object
          Caption := ctiCaption;

          If (Trim(ctiFontName) <> '') Then Begin
            // Copy font details
            Name  := ctiFontName;
            Size  := ctiSize;
            Style := ctiStyle;

            If (ctiColorRed >= 0) And (ctiColorGreen >= 0) And (ctiColorBlue >= 0) Then
              // Reconstruct font color from RGB values
              Color := RGB (ctiColorRed, ctiColorGreen, ctiColorBlue);
          End; { If (Trim(ctiFontName) <> '') }
        End; { With CustomTextInfo^ }
      End; { If (LstIndex >= 0) }
    End; { With CustomText }

  If PassOn Then
    { Not customised by this DLL - pass onto next in chain }
    DLLChain.EntGetCustomText (CustomText);
End;  { EntGetCustomText }

//----------------------------------------------------------------------------

Procedure CheckINI;
Var
  SectionNames, SectionValues : TStringList;
  I, J                        : SmallInt;
Begin { CheckINI }
  If FileExists (ExtractFilePath(Application.ExeName) + 'LABELS.INI') Then
    Try
      SectionNames := TStringList.Create;
      SectionValues := TStringList.Create;
      try
        With TIniFile.Create (ExtractFilePath(Application.ExeName) + 'LABELS.INI') Do
          Try
            // Load in a list of all the sections
            ReadSections(SectionNames);

            // For each section load the custom text items
            If (SectionNames.Count > 0) Then
              For I := 0 To Pred(SectionNames.Count) Do Begin
                // Read the entire section
                ReadSectionValues (SectionNames[I], SectionValues);

                // Process the section and add it into the CustomText list
                If (SectionValues.Count > 0) Then
                  For J := 0 to Pred(SectionValues.Count) Do
                    AddCustomText (StrToInt(SectionNames[I]),
                                   StrToInt(SectionValues.Names[J]),
                                   SectionValues.Values[SectionValues.Names[J]],
                                   '', 0, False, False, False, False, -1, -1, -1);
              End; { For I }
          Finally
            Free;
          End;
      Finally
        SectionNames.Free;
        SectionValues.Free;
      End;
    Except
      On E : Exception Do
        MessageDlg ('The following error occurred importing LABELS.INI into the Label ' +
                    'Customisation subsystem:-'#13#13 + E.Message + #13#13'Please contact ' +
                    'your Technical Support', mtError, [mbOk], 0);
    End; { If FileExists (... }
End; { CheckINI }

//----------------------------------------------------------------------------

Initialization
  lstWindows    := TStringList.Create;
  lstCustomText := TStringList.Create;

  // Check Labels.Ini for any manually specified label customisation
  CheckINI;
Finalization
  // Shutdown the Window list
  lstWindows.Clear;
  FreeAndNIL(lstWindows);

  // Shutdown the CustomText list
  FreeAndNIL(lstCustomText);
end.
