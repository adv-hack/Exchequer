unit RepGroups;

interface

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

uses
  SysUtils, Classes, Forms, Graphics, RPFiler, RPDefine, RPBase, RPCanvas,
  Dialogs, Types, RPrinter, RpDevice, RPFPrint, Windows;

type
  tsFontTypeList = (ftHdr, ftNormal, ftBNormal, ftSubTitle);
  tsTabTypeList = (ftCompanyColumns, ftUserColumns);

  TdmGroupsReport = class(TDataModule)
    ReportFiler1: TReportFiler;
    FilePrinter1: TFilePrinter;
    procedure ReportFiler1NewPage(Sender: TObject);
    procedure ReportFiler1Print(Sender: TObject);
    procedure ReportFiler1BeforePrint(Sender: TObject);
  private
    { Private declarations }
    FPrintJobInfo : TSBSPrintSetupInfo;
    FShowPaths : Boolean;
    FShowPwords : Boolean;
    FFromGroup : ShortString;
    FToGroup : ShortString;

    Procedure DoFont (Const FontType : tsFontTypeList);
    Procedure DoTabs (Const TabType : tsTabTypeList);

    Procedure SendText(ThisLine  :  String);
  public
    { Public declarations }
    Property FromGroup : ShortString Read FFromGroup Write FFromGroup;
    Property PrintJobInfo : TSBSPrintSetupInfo Read FPrintJobInfo Write FPrintJobInfo;
    Property ShowPaths : Boolean Read FShowPaths Write FShowPaths;
    Property ShowPwords : Boolean Read FShowPwords Write FShowPwords;
    Property ToGroup : ShortString Read FToGroup Write FToGroup;
  end;


// Prints the Groups Report to the specified destination
Procedure GenerateGroupsReport (Const ParentForm            : TForm;
                                Const PrintJobInfo          : TSBSPrintSetupInfo;
                                Const FromGroup, ToGroup    : ShortString;
                                Const ShowPaths, ShowPWords : Boolean);



implementation

{$R *.dfm}

Uses GlobVar, VarConst, BtrvU2, ETStrU, ETMiscU, ETDateU,
     BureauSecurity,   // SecurityManager Object
     Crypto,           // Encryption Routines
     Excep3U,          // GetSwapDir function
     GroupCompFile,    // Definition of GroupCmp.Dat (GroupCompXrefF) and utility functions
     GroupsFile,       // Definition of Groups.Dat (GroupF) and utility functions
     GroupUsersFile,   // Definition of GroupUsr.Dat (GroupUsersF) and utility functions
     PreviewF,         // Generic Print Preview Window
     PrintToF,         // Generic Select Printer dialog
     BTKeys1U, BTSupU1, RpMemo;

//-------------------------------------------------------------------------

// Prints the Groups Report to the specified destination
Procedure GenerateGroupsReport (Const ParentForm            : TForm;
                                Const PrintJobInfo          : TSBSPrintSetupInfo;
                                Const FromGroup, ToGroup    : ShortString;
                                Const ShowPaths, ShowPWords : Boolean);
Var
  dmGroupsReport : TdmGroupsReport;
Begin // GenerateGroupsReport
  dmGroupsReport := TdmGroupsReport.Create(ParentForm);
  Try
    RpDev.SetPrnSetup(PrintJobInfo);

    dmGroupsReport.PrintJobInfo := PrintJobInfo;
    dmGroupsReport.FromGroup := FromGroup;
    dmGroupsReport.ToGroup := ToGroup;
    dmGroupsReport.ShowPaths := ShowPaths;
    dmGroupsReport.ShowPwords := ShowPwords;

    // Print Report to temporary file and then to preview or to printer
    dmGroupsReport.ReportFiler1.FileName := GetUniqueName(IncludeTrailingBackslash(SetDrive) + GetSwapDir);
    dmGroupsReport.ReportFiler1.Execute;

    Try
      If PrintJobInfo.Preview Then
      Begin
        // Display Preview Window
        PreviewReport (ParentForm, dmGroupsReport.ReportFiler1.FileName, PrintJobInfo);
      End // If PrintJobInfo.Preview
      Else
      Begin
        // Printer
        dmGroupsReport.FilePrinter1.FileName := dmGroupsReport.ReportFiler1.FileName;
        dmGroupsReport.FilePrinter1.Execute;
      End;
    Finally
      // Remove the temporary file
      DeletePrintFile (dmGroupsReport.ReportFiler1.FileName);
    End; // Try..Finally
  Finally
    FreeAndNIL(dmGroupsReport);
  End; // Try..Finally
End; // GenerateGroupsReport

//=========================================================================

procedure TdmGroupsReport.ReportFiler1BeforePrint(Sender: TObject);
begin
  ReportFiler1.Orientation := RpDev.Orientation;

  ReportFiler1.MarginLeft   := 2 * ReportFiler1.LeftWaste;
  ReportFiler1.MarginRight  := 2 * ReportFiler1.RightWaste;
  ReportFiler1.MarginTop    := 2 * ReportFiler1.TopWaste;
  ReportFiler1.MarginBottom := 2 * ReportFiler1.BottomWaste;
end;

//------------------------------

procedure TdmGroupsReport.ReportFiler1NewPage(Sender: TObject);
begin
  With ReportFiler1 Do
  Begin
    Home;

    DoFont (ftNormal);
    PrintRight(ConCat('Printed :',DateToStr(Now),' - ',TimeToStr(Now)),PageWidth-MarginRight);
    CRLF;

    DoFont (ftHdr);
    PrintLeft('Bureau Groups Report', MarginLeft);
    DoFont (ftNormal);
    PrintRight (Concat('User : ',Trim(SecurityManager.smUserCode),'. Page : ',IntToStr(CurrentPage),' of ',Macro(midTotalPages)), PageWidth - MarginRight);
    CRLF;
    CRLF;

    // Draw line across report
    SetPen(clBlack,psSolid,-2,pmCopy);
    MoveTo(MarginLeft,YD2U(CursorYPos)-4.3);
    LineTo((PageWidth-1-MarginRight),YD2U(CursorYPos)-4.3);
    MoveTo(1,YD2U(CursorYPos));
  End; // With ReportFiler1
end;

//------------------------------

procedure TdmGroupsReport.ReportFiler1Print(Sender: TObject);
Var
  iStatus : SmallInt;
  sKey    : Str255;

  //------------------------------

  Procedure PrintCompanies;
  Var
    iStatus : SmallInt;
    sKey    : Str255;
  Begin // PrintCompanies
    With ReportFiler1 Do
    Begin
      // check for space
      If (ReportFiler1.LinesLeft < 5) Then ReportFiler1.NewPage;

      // Print sub-heading
      DoFont (ftBNormal);
      DoTabs (ftCompanyColumns);
      If FShowPaths Then
      Begin
        SendText (#9 + 'Company Code' + #9 + 'Company Name' + #9 + 'Path');
      End // If FShowPaths
      Else
      Begin
        SendText (#9 + 'Company Code' + #9 + 'Company Name');
      End; // Else
      DoFont (ftNormal);
      CRLF;

      // Draw line across report leaving an additional 10mm margin for the sub report
      SetPen(clBlack,psSolid,-1,pmCopy);
      MoveTo(MarginLeft+10,YD2U(CursorYPos)-4.3);
      LineTo((PageWidth-1-MarginRight-10),YD2U(CursorYPos)-4.3);
      MoveTo(1,YD2U(CursorYPos));

      sKey := FullGroupCodeKey(GroupFileRec.grGroupCode);
      iStatus := Find_Rec(B_GetGEq, F[GroupCompXRefF], GroupCompXRefF, RecPtr[GroupCompXRefF]^, GroupCompXRefGroupK, sKey);
      While (iStatus = 0) And (GroupCompFileRec^.gcGroupCode = GroupFileRec.grGroupCode) Do
      Begin
        // check for space
        If (ReportFiler1.LinesLeft < 3) Then ReportFiler1.NewPage;

        // Get Company record for Group-Company XRef record
        sKey := FullCompCodeKey (cmCompDet, GroupCompFileRec^.gcCompanyCode);
        iStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
        If (iStatus <> 0) Then
        Begin
          FillChar (Company^, SizeOf(Company^), #0);
        End; // If (iStatus <> 0)

        // Output Company Details to report
        If FShowPaths Then
        Begin
          SendText (#9 + Trim(GroupCompFileRec^.gcCompanyCode) + #9 +
                         Trim(Company^.CompDet.CompName) + #9 +
                         Trim(Company^.CompDet.CompPath));
        End // If FShowPaths
        Else
        Begin
          SendText (#9 + Trim(GroupCompFileRec^.gcCompanyCode) + #9 +
                         Trim(Company^.CompDet.CompName));
        End; // Else

        iStatus := Find_Rec(B_GetNext, F[GroupCompXRefF], GroupCompXRefF, RecPtr[GroupCompXRefF]^, GroupCompXRefGroupK, sKey);
      End; // While (iStatus = 0) And (...

      CRLF;
    End; // With ReportFiler1
  End; // PrintCompanies

  //------------------------------

  Procedure PrintUsers;
  Var
    iStatus : SmallInt;
    sKey    : Str255;
  Begin // PrintUsers
    With ReportFiler1 Do
    Begin
      // check for space
      If (ReportFiler1.LinesLeft < 5) Then ReportFiler1.NewPage;

      // Print sub-heading
      DoFont (ftBNormal);
      DoTabs (ftUserColumns);
      If FShowPwords Then
      Begin
        SendText (#9 + 'User Code' + #9 + 'User Name' + #9 + 'Password');
      End // If FShowPwords
      Else
      Begin
        SendText (#9 + 'User Code' + #9 + 'User Name');
      End; // Else
      DoFont (ftNormal);
      CRLF;

      // Draw line across report
      SetPen(clBlack,psSolid,-1,pmCopy);
      MoveTo(MarginLeft+10,YD2U(CursorYPos)-4.3);
      LineTo((PageWidth-1-MarginRight-10),YD2U(CursorYPos)-4.3);
      MoveTo(1,YD2U(CursorYPos));

      sKey := FullGroupCodeKey(GroupFileRec.grGroupCode);
      iStatus := Find_Rec(B_GetGEq, F[GroupUsersF], GroupUsersF, RecPtr[GroupUsersF]^, GroupUsersGroupCodeK, sKey);
      While (iStatus = 0) And (GroupUsersFileRec^.guGroupCode = GroupFileRec.grGroupCode) Do
      Begin
        // check for space
        If (ReportFiler1.LinesLeft < 3) Then ReportFiler1.NewPage;

        // Output User Details to report
        If FShowPwords Then
        Begin
          SendText (#9 + Trim(GroupUsersFileRec^.guUserCode) + #9 +
                         Trim(GroupUsersFileRec^.guUserName) + #9 +
                         DecodeKey (23130, GroupUsersFileRec^.guPassword));
        End // If FShowPwords
        Else
        Begin
          SendText (#9 + Trim(GroupUsersFileRec^.guUserCode) + #9 +
                         Trim(GroupUsersFileRec^.guUserName));
        End; // Else

        iStatus := Find_Rec(B_GetNext, F[GroupUsersF], GroupUsersF, RecPtr[GroupUsersF]^, GroupUsersGroupCodeK, sKey);
      End; // While (iStatus = 0) And (...

      CRLF;
    End; // With ReportFiler1
  End; // PrintUsers

  //------------------------------

begin
  // Run through the Groups, for each Group print the Companies and Users
  sKey := FFromGroup;
  iStatus := Find_Rec(B_GetGEq, F[GroupF], GroupF, RecPtr[GroupF]^, GroupCodeK, sKey);
  While (iStatus = 0) And
        ((Trim(FFromGroup) = '') Or (GroupFileRec.grGroupCode >= FFromGroup)) And
        ((Trim(FToGroup) = '') Or (GroupFileRec.grGroupCode <= FToGroup)) Do
  Begin
    // check for space
    If (ReportFiler1.LinesLeft < 7) Then ReportFiler1.NewPage;

    // Print Group Header
    DoFont (ftSubTitle);
    ReportFiler1.PrintLn (Trim(GroupFileRec.grGroupCode) + ' - ' + Trim(GroupFileRec.grGroupName));
    ReportFiler1.CRLF;

    PrintCompanies;
    PrintUsers;

    iStatus := Find_Rec(B_GetNext, F[GroupF], GroupF, RecPtr[GroupF]^, GroupCodeK, sKey);
  End; // While (iStatus = 0)

  // Draw line across report
  With ReportFiler1 Do
  Begin
    SetPen(clBlack,psSolid,-2,pmCopy);
    MoveTo(MarginLeft,YD2U(CursorYPos)-4.3);
    LineTo((PageWidth-1-MarginRight),YD2U(CursorYPos)-4.3);
    MoveTo(1,YD2U(CursorYPos));
  End; // With ReportFiler1
end;

//------------------------------

Procedure TdmGroupsReport.DoTabs (Const TabType : tsTabTypeList);
Begin // DoTabs
  With ReportFiler1 Do
  Begin
    ClearTabs;

    Case TabType Of
      ftCompanyColumns   : Begin
                             SetTab (MarginLeft + 10, pjLeft, 25,  4, 0, 0);
                             SetTab (NA,              pjLeft, 60,  4, 0, 0);
                             SetTab (NA,              pjLeft, 75,  4, 0, 0);
                           End;
      ftUserColumns      : Begin
                             SetTab (MarginLeft + 10, pjLeft, 45,  4, 0, 0);
                             SetTab (NA,              pjLeft, 80,  4, 0, 0);
                             SetTab (NA,              pjLeft, 35,  4, 0, 0);
                           End;
    End; // Case TabType
  End; // With ReportFiler1
End; // DoTabs

//------------------------------

Procedure TdmGroupsReport.DoFont (Const FontType : tsFontTypeList);
Begin
  With ReportFiler1 Do
  Begin
    FontName := 'Arial';
    FontColor := clBlack;
    Bold := False;
    Italic := False;
    UnderLine := False;

    SetPen (clBlack, psSolid, -1, pmCopy);
    SetBrush (clWhite, bsClear, Nil);

    Case FontType Of
      ftHdr       : Begin
                      FontSize := 10;
                      Bold := True;
                    End;
      ftNormal    : Begin
                      FontSize := 8;
                    End;
      ftBNormal   : Begin
                      FontSize := 8;
                      Bold := True;
                    End;
      ftSubTitle  : Begin
                      FontSize := 9;
                      Bold := True;
                    End;
    End; // Case FontType
  End; // With ReportFiler1
End;


Procedure TdmGroupsReport.SendText(ThisLine  :  String);

Var
  ThisPos,
  ThisPos2,
  ThisCol,
  ThisX,
  ThisY      :  Integer;

  ThisTab    :  PTab;

  ThisText,
  ProcessLn  :  String;

  TAbort     :  Boolean;

  // HM 17/01/02: Replacement function for TextRect2 that uses standard RAVE
  // commands to allow usage of RAVE PDF/HTML formats.
  Procedure ExtTextRect2 (      ftText    : ShortString;
                          Const ftJustify : TPrintJustify;
                          Const ftLeft,
                                ftTop,
                                ftWidth,
                                ftHeight  : Double;
                          Const VCenter   : Boolean = False);
  Var
    TempYPos            : Double;
    ThisRect            :  TRect;

    // String to Float conversion function which supports '-' signs on right
    // hand edge of number
    Procedure StrToDouble (    StrNum : Str30;
                           Var StrOK  : Boolean;
                           Var RNum   : Double;
                           Var NoDecs : Byte);
    Var
      Neg  : Boolean;
      Chk  : Integer;
    Begin { StrToDouble }
      StrOK  := FALSE;
      Rnum   := 0.00;
      NoDecs := 0;
      Neg    := False;

      // strip off any spaces
      StrNum := Trim(StrNum);

      // Remove any 000's commas as they cause problems too
      If (Length(StrNum) > 0) Then
        While (Pos(',', StrNum) > 0) Do
          Delete (StrNum, Pos(',', StrNum), 1);

      // Check for -ve sign
      If (Length(StrNum) > 0) Then
        If (StrNum[Length(StrNum)] = '-') Then Begin
          Neg := True;
          Delete (StrNum, Length(StrNum), 1);
        End; { If (StrNum[Length(StrNum)] = '-') }

      If (StrNum <> '') Then Begin
        If (Pos ('.', StrNum) > 0) Then Begin
          // Calculate number of decimal places in string
          NoDecs := Length(StrNum) - Pos ('.', StrNum);
        End; { If }

        // Convert string to float with error checking
        Val (StrNum, Rnum, Chk);
        StrOK := (Chk = 0);

        // Restore -ve sign to number
        If StrOK And Neg Then RNum := -RNum;
      End { If (StrNum <> '')  }
      Else
        StrOK:=True;
    End; { StrToDouble }

    // Squashes the text down so that it fits within the column without loss
    Procedure SquashText;
    Begin { SquashText }
      With ReportFiler1 Do Begin
        // Trim text based on justification before checking whether it will fit
        Case ftJustify Of
          pjLeft   : ftText := TrimRight(ftText);
          pjCenter : ftText := Trim(ftText);
          pjRight  : ftText := TrimLeft(ftText);
        End; { Case }

        // Check whether text will fit or not
        If (TextWidth(ftText) > ftWidth) Then Begin
          // Won't fit - determine whether text is text or number
//          StrToDouble (ftText, OK, RNum, NoDecs);
//          If OK Then Begin
//            // Number - check whether Integer or Floating Point
//            If (System.Pos ('.', ftText) > 0) Then Begin
//              // Floating Point - 1) Retry without commas, but with full number
//              //                  2) Incrementally reduce decimals
//              //                  3) Display #'s like MS Excel
//
//              // 1) Reformat without any thousands separators to see if that will fit
//              While (System.Pos (',', ftText) > 0) Do
//                System.Delete (ftText, System.Pos (',', ftText), 1);
//
//              If (TextWidth(ftText) > ftWidth) Then Begin
//                // 2) reduce the decs - retry at full decs just in case the formatting is different
//                { Generate a new formatting mask without commas }
//                BaseMask := GenRealMask;
//                While (System.Pos (',', BaseMask) > 0) Do System.Delete (BaseMask, System.Pos (',', BaseMask), 1);
//
//                For I := NoDecs DownTo 0 Do Begin
//                  { Generate a new mask with the correct decimals }
//                  FieldMask := FormatDecStrSD(I, BaseMask, BOff);
//
//                  { reformat field into what it should look like }
//                  ftText := FormatFloat (FieldMask, Round_Up(RNum, I));
//
//                  If (TextWidth(ftText) < ftWidth) Then Break;
//                End; { For I }
//              End; { If (TextWidth(ftText) > ftWidth) }
//            End; { If (Pos ('.', ftText) > 0) }
//
//            If (TextWidth(ftText) > ftWidth) Then
//              // No way to shorten string without misleading users so
//              // display ### like MS Excel to indicate the field can't fit
//              // NOTE: Integers just display ###'s if they don't fit
//              ftText := StringOfChar ('#', Trunc(ftWidth / TextWidth('#')));
//          End { If OK }
//          Else
            // Normal string - trim off characters until fits
            While (ftText <> '') And (TextWidth(ftText) > ftWidth) Do
              System.Delete (ftText, Length(ftText), 1);
        End; { If (TextWidth(ftText) > ftWidth) }
      End; { With RepFiler1 }
    End; { SquashText }

    //------------------------------

    Procedure RPJustXY(Var   TX, TY   : Integer;
                       Const ThisRect : TRect;
                       Const RPJust   : TPrintJustify);
    Begin
      With ThisRect do
      Begin
        TY:=Bottom;

        Case RPJust of

          pjCenter  :  TX:=Round((Right-Left)/2)+Left;

          pjRight  :  TX:=Right;

          else        TX:=Left;
        end; {Case..}
      end; {With..}
    end; {Proc..}

    //------------------------------

    function RPJust2DT (RPJust : TPrintJustify) : Byte;
    Begin
      Case RPJust of
        pjCenter  :  Result:=DT_Center;
        pjRight   :  Result:=DT_Right;
        else         Result:=DT_Left;
      end; {Case..}
    end;

    //------------------------------

  Begin { ExtTextRect2 }
    With ReportFiler1 Do Begin
      // 'Adjust' text to ensure that it will fit correctly within the column
      SquashText;

      // Check RDevRec to determine how to print the text - stick with old method for Preview,
      // Printer and Adobe, and use the new method for RAVE PDF/HTML only.
// HM 01/08/03 (EN552XL): Extended to use standard commands for export to Excel (Preview & File)
      If ((FPrintJobInfo.fePrintMethod = 2) And (FPrintJobInfo.feEmailAtType In [2, 3])) Or
          (FPrintJobInfo.fePrintMethod = 5) Then Begin
        // Sending Email with either RAVE PDF or RAVE HTML format attachments - use
        // standard RAVE commands to allow Renderer components to convert output
        TempYPos := YD2U(CursorYPos);

        With TMemoBuf.Create Do
          Try
            BaseReport := ReportFiler1;

            If (FPrintJobInfo.fePrintMethod = 5) and (ftJustify=pjRight) then
            Begin
              Justify := pjLeft;

              { Excel does not like right justification, or the minus at the end of the figure. Alter both factors
                 when outputting to excel }

              If (ftText[Length(ftText)]='-') then
                Text:='-'+Copy(ftText,1,Pred(Length(ftText)))
              else
                Text:=ftText;

              {$IFDEF EN560}
                Text:=Strip('A',[ThousandSeparator],Text);
              {$ENDIF}
            end
            else
              Begin
                Text := ftText;

                Justify := ftJustify;
              end;

            FontTop := ftTop;
            PrintStart := ftLeft;
            PrintEnd := ftLeft + ftWidth;

            PrintHeight (ftHeight, False);
          Finally
            Free;
          End;

        GotoXY (CursorXPos, TempYPos);
      End { If (RDevRec.fePrintMethod = 2) And (RDevRec.feEmailAtType In [2, 3]) }
      Else Begin
        // Standard routine for Preview/Printer/Adobe Acrobat support
        ThisRect := CreateRect(ftLeft, ftTop, ftLeft + ftWidth, ftTop + ftHeight);

        RPJustXY(ThisX,ThisY,ThisRect,ftJustify);

        TextRect2 (ThisRect,                        // Clipping Rectangle
                   XD2U(ThisX),                     // X Start Position
                   YD2U(ThisY),                     // Y Start Postion
                   RPJust2DT(ftJustify),            // Justification
                   ftText);                         // Text
      End; { Else }
    End; { With TheReport }
  End; { ExtTextRect2 }


Begin
  ThisText:='';

  With ReportFiler1 do
  Begin
    ThisCol:=0;
    ThisX:=0; ThisY:=0;

    TAbort:=BOff;

    ProcessLn:=ThisLine;

    ThisPos2:=Pos(#9,ProcessLn);

    While (ThisPos2<>0) and (Not TAbort) do
    Begin
      Inc(ThisCol);

      ThisPos:=ThisPos2;

      Delete(ProcessLn,ThisPos,1);

      ThisPos2:=Pos(#9,ProcessLn);

      If (ThisPos2=0) then
      Begin
        ThisPos2:=Succ(Length(ProcessLn));
        TAbort:=BOn;
      end;

      If (ThisPos2>ThisPos) then {* Only print if there is data there *}
      Begin
        ThisText:=Copy(ProcessLn,ThisPos,ThisPos2-ThisPos);

        ThisTab:=GetTab(ThisCol);

        If (Assigned(ThisTab)) then
        With ThisTab^ do
        Begin
          Tab(NA,NA,NA,NA,NA);
          {ThisRect:=CreateRect(TabStart(ThisCol),YD2U(CursorYPos)-YI2U(LineHeight),TabEnd(ThisCol),YD2U(CursorYPos));

          RPJustXY(ThisX,ThisY,ThisRect,Justify);

          TextRect2(ThisRect,XD2U(ThisX),YD2U(ThisY),RPJust2DT(Justify),ThisText);}

          ExtTextRect2 (ThisText,
                        Justify,
                        TabStart(ThisCol),                    // Left
                        YD2U(CursorYPos)-(LineHeight),        // Top
                        TabEnd(ThisCol)-TabStart(ThisCol),    // Width
                        LineHeight);                          // Height

        end;
      end;

    end; {While..}


    CRLF;
  end;

end; {Proc..}


end.
