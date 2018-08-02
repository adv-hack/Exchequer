unit ReportO;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,GlobVar,VarConst,BtrvU2,BTSupU3,ExBtTh1U,
  RPBase, RpFiler, RpDefine, RpDevice, RpMemo;


type


  TGenReport  =  Object(TThreadQueue)
                       RepFiler1   :  TReportFiler;

                       Procedure RAfterPrint(Sender  :  TObject);

                       Procedure RBeforePrint(Sender  :  TObject);

                       Procedure RNewPage(Sender  :  TObject);

                       Procedure RPrint(Sender  :  TObject);

                       Procedure RPrintFooter(Sender  :  TObject);

                       Procedure RPrintHeader(Sender  :  TObject);

                       Function RPrintPage(Sender  :  TObject;
                                      var PageNum  :  Integer)  :  Boolean;


                       Procedure RepAfterPrint(Sender  :  TObject); Virtual;

                       Procedure RepBeforePrint(Sender  :  TObject); Virtual;

                       Procedure RepNewPage(Sender  :  TObject); Virtual;

                       Procedure RepPrint(Sender  :  TObject); Virtual;

                       Procedure RepPrintFooter(Sender  :  TObject); Virtual;

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                       Function RepPrintPage(Sender  :  TObject;
                                        var PageNum  :  Integer)  :  Boolean; Virtual;

                     private


                       TestLoop   :  Integer;

                       LBitMap  :  TBitMap;

                       Procedure DelSwpFile;


                     public
                       RNoPageLine,
                       RUseForms  :  Boolean;
                       {RCopies    :  SmallInt;}
                       RFont      :  TFont;
                       ROrient    :  TOrientation;
                       {RForm      :  Str10;}

                       RDevRec    :  TSBSPrintSetupInfo;

                       ReportMode:  Byte;

                       RepLen,
                       RepLenCnst,
                       B_Start,
                       B_Next    :  SmallInt;

                       RFnum,
                       RKeyPath  :  Integer;


                       {RPrinterNo :  SmallInt;
                       RToPrinter :  Boolean;}

                       RCount,
                       ICount    :  LongInt;

                       ThTitle,
                       PageTitle,
                       RepTitle,
                       RepTitle2,
                       KeyS,
                       RepKey    :  Str255;

                       RepAbort,
                       NoDeviceP :  Boolean;

                       ReportParam,
                       RepORecPtr,
                       RepObjPtr :  Pointer;


                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       procedure DefFont (Const FSize     : Integer;
                                          Const FontStyle  : TfontStyles);  Virtual;

                       Procedure DefLine(Const PWidth,
                                               LStart,
                                               LWidth,
                                               AHeight  :  Double);

                       Procedure SendText(ThisLine  :  String);

                       Procedure SendLine(ThisLine  :  String);

                       Function GetReportInput  :  Boolean; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       function RPJust2DT(RPJust  :  TPrintJustify)  :  Byte;

                       Procedure RPJustXY(Var TX,TY       :  Integer;
                                        Const ThisRect  :  TRect;
                                        Const RPJust    :  TPrintJustify);

                       Procedure PrintHedTit; Virtual;

                       Procedure PrintStdPage; Virtual;

                       Procedure PrintReportLine; Virtual;

                       function MatchProc(B_Func  :  SmallInt;
                                          BKey    :  Str255)  :  SmallInt; Virtual;

                       Procedure PrintEndPage; Virtual;

                       function ChkRepAbort  :  Boolean;

                       Function PO2RO(PR  :  TOrientation)  :  TOrientation;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start  :  Boolean; Virtual;

                       Function InitRep1  :  Boolean; Virtual;

                   end; {Class..}



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  ETDateU,
  ETStrU,
  ETMiscU,
  BTSFrmU1,
  BTKeys1U,
  BTSupU1,
  TEditVal,

  {$IFDEF FRM}
    {PrintFrm,}  { Causes DicLinkU }
  {$ENDIF}

  ExWrap1U;




{ ========== TGenReport methods =========== }

Constructor TGenReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);


  fTQNo:=2;
  fCanAbort:=BOn;
  fPrintJob:=BOn;

  fOwnMT:=BOff; {* This must be set if MTExLocal is created/destroyed by thread *}

  MTExLocal:=nil;

  RFnum:=0;
  RKeypath:=0;
  RepLen:=0;
  RepLenCnst:=0;
  ICount:=0;
  RCount:=0;
  ReportMode:=0;
  TestLoop:=0;
  RepAbort:=BOff;
  NoDeviceP:=BOff;

  {RPrinterNo:=-1;
  RToPrinter:=BOff;}
  RUseForms:=BOff;

  FillChar(RDevRec,Sizeof(RDevRec),0);

  With RDevRec do
  Begin
    DevIdx:=-1;
    Preview:=BOn;
    NoCopies:=1;
  end;

  RNoPageLine:=BOff;

  B_Start:=B_GetGEq;
  B_Next:=B_GetNext;

  ThTitle:='';
  RepTitle2:='';
  RepTitle:='';
  PageTitle:='';

  RepKey:='';
  KeyS:='';

  ReportParam:=nil;
  RepORecPtr:=nil;
  RepObjPtr:=nil;

  RepFiler1:=TReportFiler.Create(Application.MainForm);

  {RCopies:=1;}

  RFont:=TFont.Create;

{$IFNDEF SENT}
  try
    RFont.Assign(Application.MainForm.Font);
  except
    RFont.Free;
    RFont:=nil;
  end;
{$ENDIF}

  ROrient:=PoPortrait;

  LBitMap:=TBitMap.Create; {*Disabled, as caused printing to printer to make machine VERY slow }

  try
    LBitMap.Handle:=LoadBitMap(HInstance,'ENTLOG_1');
  except
    LBitMap.Free;
    LBitMap:=nil;
  end;

end;


Destructor TGenReport.Destroy;

Begin
  If (Assigned(RepFiler1)) then
    RepFiler1.Free;

  If (Assigned(RFont)) then
    RFont.Free;

  If (Assigned(LBitMap)) then
    LBitMap.Free;

  Inherited Destroy;
end;


Procedure TGenReport.PrintHedTit;

Var
  ShowSize  :  Byte;

Begin

  With RepFiler1 do
  Begin

    ShowSize:=(2*Ord(CurrentPage=1))+(1*Ord(CurrentPage>1));

    DefFont (ShowSize,[fsBold]);
    PrintLeft(Trim(Syss.UserName), MarginLeft);

    DefFont (0,[]);

    PrintRight(ConCat('Printed :',DateToStr(Now),' - ',TimeToStr(Now)),PageWidth-MarginRight);

    CRLF;

  end;
end;


Procedure TGenReport.PrintStdPage;

Begin
  With RepFiler1 do
  Begin
    DefFont ((1*Ord(CurrentPage=1))-(1*Ord(CurrentPage>1)),[fsBold]);
    PrintLeft (PageTitle, MarginLeft);
    DefFont (0,[]);
    PrintRight (Concat('User : ',Trim(EntryRec^.Login),'. Page : ',IntToStr(CurrentPage)), PageWidth - MarginRight);
    CRLF;

    If (RepTitle2<>'') then
    Begin
      DefFont (0,[fsBold]);
      PrintLeft (Trim(RepTitle2), MarginLeft); CRLF;
    end;

    CRLF;

  end; {with..}
end; {Proc..}



procedure TGenReport.DefFont (Const FSize     : Integer;
                              Const FontStyle : TFontStyles);

begin
  With RepFiler1 do
  Begin
    FontName  := RFont.Name;
    FontSize  := RFont.Size+FSize;
    FontColor := RFont.Color;

    Bold := (fsBold In FontStyle);

    UnderLine :=(fsUnderLine In FontStyle);
    Italic:=(fsItalic In FontStyle);

  end; { with.. }
end;


Procedure TGenReport.DefLine(Const PWidth,
                                   LStart,
                                   LWidth,
                                   AHeight  :  Double);

Begin
  With RepFiler1 do
  Begin
    SetPen(clBlack,psSolid,Round(PWidth),pmCopy);

    MoveTo(LStart,YD2U(CursorYPos)-(4.3+AHeight));
    LineTo(LWidth,YD2U(CursorYPos)-(4.3+AHeight));
    MoveTo(1,YD2U(CursorYPos));
  end;
end;


Procedure TGenReport.RepAfterPrint(Sender  :  TObject);
Begin


end;


Procedure TGenReport.RepBeforePrint(Sender  :  TObject);
Begin

  If (RUseForms) then
  Begin
    InPrint:=BOff; {* Force in print off otherwise, batch will not work *}

    {$IFDEF FRM}

      {pfInitNewBatch(BOff);} {RW32}

    {$ENDIF}

    InPrint:=BOn;
  end
  else
    Begin
      RepFiler1.Title:=Application.Title+'. '+RepTitle;
      {RepFiler1.FileName:=GetTempFName('!REP');}

      { HM 09/05/00: Applied mods for fax/emailing }
      If (RDevRec.fePrintMethod = 1) Or ((RDevRec.fePrintMethod = 2) And (RDevRec.feEmailAtType = 0)) Then
        { Fax or Email with RPPro attachments }
        RepFiler1.FileName := GetTempFNameExt('!REP', '.EDF')
      Else
        { Printing or Email with PDF Attachments }
        RepFiler1.FileName := GetTempFNameExt('!REP', '.SWP');
    end;

end;


Procedure TGenReport.RepNewPage(Sender  :  TObject);
Begin


end;


Function TGenReport.RepPrintPage(Sender  :  TObject;
                            var PageNum  :  Integer)  :  Boolean;

Begin
  Result:=True;
end;

Procedure TGenReport.RepPrintFooter(Sender  :  TObject);
Begin


end;




Procedure TGenReport.RepPrint(Sender  :  TObject);

Var
  TmpStat      :  Integer;
  TmpRecAddr   :  LongInt;


Begin

  ShowStatus(2,'Processing Report.');

  With MTExLocal^,RepFiler1 do
  Begin
    
    Case RepLen of

      256  :  RepLen:=0;

      257  :  RepLen:=RepLenCnst;    {* Force a replen const thru for checking *}

      else    RepLen:=Length(RepKey);

    end; {Case..}

    KeyS:=RepKey;

    If (RepObjPtr=NIL) then
      LStatus:=LFind_Rec(B_Start,RFnum,RKeypath,KeyS)
    else
      Status:=MatchProc(B_Start,KeyS);

    If (Assigned(ThreadRec)) then
      RepAbort:=ThreadRec^.THAbort;

    While (LStatusOk) and (CheckKey(RepKey,KeyS,RepLen,BOn)) and (Not RepAbort) do
    Begin

      TmpStat:=LPresrv_BTPos(RFnum,RKeypath,LocalF^[RFnum],TmpRecAddr,BOff,BOff);

      If (IncludeRecord) then
      Begin


        If (LinesLeft<5) then
          NewPage;

        PrintReportLine;

        Inc(ICount);

      end; {If Ok..}

      Inc(RCount);

      If (Assigned(ThreadRec)) then
        UpDateProgress(RCount);

      TmpStat:=LPresrv_BTPos(RFnum,RKeypath,LocalF^[RFnum],TmpRecAddr,BOn,BOff);


      If (RepObjPtr=NIL) then
        LStatus:=LFind_Rec(B_Next,RFnum,RKeypath,KeyS)
      else
        LStatus:=MatchProc(B_Next,KeyS);

      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;
    end; {While..}

    If (LinesLeft<5) then
      NewPage;

    PrintEndPage;


  end; {With..}


end;




Procedure TGenReport.RAfterPrint(Sender  :  TObject);
Begin
  RepAfterPrint(Sender);

end;


Procedure TGenReport.RBeforePrint(Sender  :  TObject);
Begin
  RepBeforePrint(Sender);

end;


Procedure TGenReport.RNewPage(Sender  :  TObject);
Begin
  RepNewPage(Sender);

end;


Function TGenReport.RPrintPage(Sender  :  TObject;
                          var PageNum  :  Integer)  :  Boolean;

Begin
  Result:=RepPrintPage(Sender,PageNum);
end;

Procedure TGenReport.RPrintFooter(Sender  :  TObject);
Begin
  RepPrintFooter(Sender);

end;


Procedure TGenReport.RPrintHeader(Sender  :  TObject);
Begin
  RepPrintHeader(Sender);
end;



function TGenReport.RPJust2DT(RPJust  :  TPrintJustify)  :  Byte;

Begin
  Case RPJust of

    pjCenter  :  Result:=DT_Center;
    pjRight   :  Result:=DT_Right;
    else         Result:=DT_Left;

  end; {Case..}

end;


Procedure TGenReport.RPJustXY(Var TX,TY       :  Integer;
                            Const ThisRect    :  TRect;
                            Const RPJust      :  TPrintJustify);

Var
  FontHeight  : Integer;

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



Procedure TGenReport.SendText(ThisLine  :  String);

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
    Var
      sStr                : ANSIString;
      FieldMask, BaseMask : Str255;
      Rect                : TRect;
      PaintFlags          : Word;
      RNum                : Double;
      NoDecs, I           : Byte;
    Begin { SquashText }
      With RepFiler1 Do Begin
        // Trim text based on justification before checking whether it will fit
        //PR 2/6/03- blank string in header was crashing preview.
        if Trim(ftText) <> '' then
        Case ftJustify Of
          pjLeft   : ftText := TrimRight(ftText);
          pjCenter : ftText := Trim(ftText);
          pjRight  : ftText := TrimLeft(ftText);
        End; { Case }

        // Check whether text will fit or not
        If (TextWidth(ftText) > ftWidth) Then Begin
          // Won't fit - determine whether text is text or number
          StrToDouble (ftText, OK, RNum, NoDecs);
          If OK Then Begin
            // Number - check whether Integer or Floating Point
            If (System.Pos ('.', ftText) > 0) Then Begin
              // Floating Point - 1) Retry without commas, but with full number
              //                  2) Incrementally reduce decimals
              //                  3) Display #'s like MS Excel

              // 1) Reformat without any thousands separators to see if that will fit
              While (System.Pos (',', ftText) > 0) Do
                System.Delete (ftText, System.Pos (',', ftText), 1);

              If (TextWidth(ftText) > ftWidth) Then Begin
                // 2) reduce the decs - retry at full decs just in case the formatting is different
                { Generate a new formatting mask without commas }
                BaseMask := GenRealMask;
                While (System.Pos (',', BaseMask) > 0) Do System.Delete (BaseMask, System.Pos (',', BaseMask), 1);

                For I := NoDecs DownTo 0 Do Begin
                  { Generate a new mask with the correct decimals }
                  FieldMask := FormatDecStrSD(I, BaseMask, BOff);

                  { reformat field into what it should look like }
                  ftText := FormatFloat (FieldMask, Round_Up(RNum, I));

                  If (TextWidth(ftText) < ftWidth) Then Break;
                End; { For I }
              End; { If (TextWidth(ftText) > ftWidth) }
            End; { If (Pos ('.', ftText) > 0) }

            If (TextWidth(ftText) > ftWidth) Then
              // No way to shorten string without misleading users so
              // display ### like MS Excel to indicate the field can't fit
              // NOTE: Integers just display ###'s if they don't fit
              ftText := StringOfChar ('#', Trunc(ftWidth / TextWidth('#')));
          End { If OK }
          Else
            // Normal string - trim off characters until fits
            While (ftText <> '') And (TextWidth(ftText) > ftWidth) Do
              System.Delete (ftText, Length(ftText), 1);
        End; { If (TextWidth(ftText) > ftWidth) }
      End; { With RepFiler1 }
    End; { SquashText }

  Begin { ExtTextRect2 }
    With RepFiler1 Do Begin
      // 'Adjust' text to ensure that it will fit correctly within the column
      SquashText;

      // Check RDevRec to determine how to print the text - stick with old method for Preview,
      // Printer and Adobe, and use the new method for RAVE PDF/HTML only.
      {$IFDEF SENT}
      If (RDevRec.fePrintMethod in [2, 5, 7]) And (RDevRec.feEmailAtType In [2, 3, 4]) Then Begin
      {$ELSE}
      If (RDevRec.fePrintMethod = 2) And (RDevRec.feEmailAtType In [2, 3]) Then Begin
      {$ENDIF}
        // Sending Email with either RAVE PDF or RAVE HTML format attachments - use
        // standard RAVE commands to allow Renderer components to convert output
        TempYPos := YD2U(CursorYPos);

        With TMemoBuf.Create Do
          Try
            BaseReport := RepFiler1;

            Text := ftText;

            Justify := ftJustify;

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
  With RepFiler1 do
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


      If (ThisPos2 > ThisPos) Then Begin
        ThisText:=Copy(ProcessLn,ThisPos,ThisPos2-ThisPos);

        ThisTab:=GetTab(ThisCol);

        If (Assigned(ThisTab)) then
        With ThisTab^ do
        Begin
          Tab(NA,NA,NA,NA,NA);
          (*  HM 17/01/02: Modified to support new RAVE PDF/HTML formats
          ThisRect:=CreateRect(TabStart(ThisCol),YD2U(CursorYPos)-{YI2U}(LineHeight),TabEnd(ThisCol),YD2U(CursorYPos));

          RPJustXY(ThisX,ThisY,ThisRect,Justify);

          TextRect2(ThisRect,XD2U(ThisX),YD2U(ThisY),RPJust2DT(Justify),ThisText);
          *)

          ExtTextRect2 (ThisText,
                        Justify,
                        TabStart(ThisCol),                    // Left
                        YD2U(CursorYPos)-(LineHeight),        // Top
                        TabEnd(ThisCol)-TabStart(ThisCol),    // Width
                        LineHeight);                          // Height
        end;
      End; { If }
    end; {While..}


    {PrintLn(ThisLine);}
  end;

end; {Proc..}


Procedure TGenReport.SendLine(ThisLine  :  String);

Begin

  SendText(ThisLine); RepFiler1.CRLF;

end;


Procedure TGenReport.PrintEndPage;


Begin
  With RepFiler1 do
  Begin
    {$B-}
    If (Assigned(ThreadRec)) and (ThreadRec^.ThAbort) then
    Begin
    {$B+}
      DefFont(0,[fsItalic,fsBold]);
      PrintCenter('Aborted by user...',PageWidth/2); CrLF;
      DefFont(0,[]);
    end;


    If (ICount>0) then
    Begin
      (*
      SetPen(clBlack,psSolid,-2,pmCopy);

      MoveTo(1,YD2U(CursorYPos)-4);
      LineTo((PageWidth-1-MarginRight),YD2U(CursorYPos)-4);
      MoveTo(1,YD2U(CursorYPos));*)

      { Modified because line was being drawn in the wrong place }
      SetPen(clBlack,psSolid,-2,pmCopy);
      MoveTo(MarginLeft-1,YD2U(CursorYPos) - {YI2U}(LineHeight));
      LineTo((PageWidth+1-MarginRight),YD2U(CursorYPos) - {YI2U}(LineHeight));
      MoveTo(MarginLeft-1,YD2U(CursorYPos));
    end;

    PrintLeft('Total Records : ' + IntToStr(ICount),MarginLeft);

    {$IFNDEF SENT}
    PrintBitMapRect(PageWidth-MarginRight-10,YD2U(CursorYPos)-2,PageWidth-MarginRight,YD2U(CursorYPos)+5.3,LBitMap);
    {$ENDIF}

  end;
end;


Function TGenReport.PO2RO(PR  :  TOrientation)  :  TOrientation;

Begin
  (*
  Case PR of
    {$IFDEF RW}
      Printers.PoPortrait  :  Result:=RpDefine.PoPortrait;
      Printers.PoLandscape :  Result:=RpDefine.PoLandScape;
    {$ELSE}
      Printers.PoPortrait  :  Result:=RpBase.PoPortrait;
      Printers.PoLandscape :  Result:=RpBase.PoLandScape;
    {$ENDIF}
  end; {Case..}
  *)
  Result := PR;
end;


Procedure TGenReport.RPrint(Sender  :  TObject);



Begin

  RepPrint(Sender);

end;



Procedure TGenReport.Process;
Var
  Ok2Cont  :  Boolean;
  MaxCount :  LongInt;

Begin

  Inherited Process;

  (*
  ShowStatus(0,RepTitle);

  With MTExLocal^ do
    MaxCount:=Used_RecsCId(LocalF^[RFnum],RFnum,ExCLientId);

  InitProgress(MaxCount+Round(MaxCount/10));


  With RepFiler1 do
    Execute;
  *)
end;


Function TGenReport.InitRep1  :  Boolean;

Begin
  Result:=BOn;

  try
    With RepFiler1 do
    Begin
      StreamMode:=smFile;
      Units:=unMM;

      FileName:=SetDrive+'Rep99.Swp';  {* EX32, replace with new valid file *}

      PrinterIndex:=RDevRec.DevIdx;
      Orientation:=PO2RO(ROrient);

      { HM 12/05/00: Added checks as Fax Driver has 0 margins }
      If (LeftWaste = 0) And (RightWaste = 0) And (TopWaste = 0) And (BottomWaste = 0) Then Begin
        MarginLeft   := 8;
        MarginRight  := 8;
        MarginTop    := 8;
        MarginBottom := 8;
      End { If }
      Else Begin
        MarginLeft:=LeftWaste+1;
        MarginRight:=1+RightWaste;
        MarginTop:=1+TopWaste;
        MarginBottom:=1+BottomWaste;
      End; { Else }

      OnAfterPrint:=RAfterPrint;
      OnBeforePrint:=RBeforePrint;
      OnNewPage:=RNewPage;
      RepFiler1.OnPrint:=RPrint;
      OnPrintFooter:=RPrintFooter;
      OnPrintHeader:=RPrintHeader;

    end; {With..}
  except
    RepFiler1.Free;
    RepFiler1:=nil;
    Result:=BOff;
  end; {try..}

end;

{ Sets the Tab positions for fields }
Procedure TGenReport.RepSetTabs;
Begin
  { Fill out in descendents }
end;

{ prints the column titles }
Procedure TGenReport.RepPrintPageHeader;
Begin
  { Fill out in descendents }
end; {Proc..}


{ prints the complete header }
Procedure TGenReport.RepPrintHeader(Sender  :  TObject);
Begin { RepPrintHeader }
  With RepFiler1 Do Begin
    If (CurrentPage=1) Then
      RepSetTabs;

    PrintHedTit;

    PrintStdPage;

    RepPrintPageHeader;

    If (Not RNoPageLine) Then Begin
      SetPen(clBlack,psSolid,-2,pmCopy);

      MoveTo(1,YD2U(CursorYPos)-4.3);
      LineTo((PageWidth-1-MarginRight),YD2U(CursorYPos)-4.3);
      MoveTo(1,YD2U(CursorYPos));
    End; { If }
  End; { With }
end; { RepPrintHeader }


function TGenReport.MatchProc(B_Func  :  SmallInt;
                              BKey    :  Str255)  :  SmallInt;

Begin
  Result:=4;

end;

function TGenReport.IncludeRecord  :  Boolean;

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      0,1  :  Result:=LCust.CustSupp=TradeCode[(ReportMode=0)];

      9,10 :  Result:=(LCust.EECMember);

      else    Result:=BOn;
    end; {case..}

  end; {With..}
end;



Procedure TGenReport.PrintReportLine;


Begin
  With MTExLocal^do
  Begin
    DefFont (0,[]);

    Case ReportMode of
      0,1  :  With LCust do
                SendLine (#9 + Trim(CustCode) +
                          #9 + Trim(Company) +
                          #9 + Trim(Contact) +
                          #9 + Trim(Phone)+
                          #9 + Trim(Fax)+
                          #9 + Trim(RefNo)+
                          #9 + FormatFloat(GenRealMask,CreditLimit));

      4    :  With LNom do
                SendLine (ConCat(#9,Form_Int(NomCode,0),#9,Trim(Desc),#9,NomType));

      9,10
           :  With LCust do
                SendLine (ConCat(#9,Trim(VATRegNo),#9,YesNoBo(EECMember),#9,Trim(CustCode),#9,Trim(Company)));

    end; {Case..}
  end; {With..}
end;




Function TGenReport.GetReportInput  :  Boolean;

Begin


  Case ReportMode of

    0,1  :  Begin
              RepTitle:=TradeType[(ReportMode=0)]+' List';
              THTitle:=RepTitle;

              RFnum:=CustF;
            end;

    4    :  Begin
              RepTitle:='General Ledger Code List';
              ThTitle:='G/L Code List';

              RFnum:=NomF;
              RKeypath:=NomDescK;

              RFont.Size:=10;
            end;


    9,10
         :  Begin
              RepTitle:=TradeType[(ReportMode=9)]+' VAT Registration No. List';

              ThTitle:=TradeType[(ReportMode=9)]+' VAT Reg List';

              RFnum:=CustF;
              RKeyPath:=CustCntyK;

              RepKey:=TradeCode[(ReportMode=9)];

              RepLen:=0;

              RFont.Size:=10;
            end;

  end; {Case..}

  PageTitle:=RepTitle;

  Result:=BOn;
end;


Function TGenReport.Start  :  Boolean;

Var
  mbRet  :  Word;

Begin
  Result:=GetReportInput;

  If (Result) then
  Begin

    {$IFDEF FRM}
      (*
      If (Not NoDeviceP) then
      Begin
        { RW32
        If (RUseForms) then
          Result:=pfSelectFormPrinter(RPrinterNo,RToPrinter,BOn,RForm,RFont,ROrient,RCopies)
        else
         Result:=pfSelectPrinter(RPrinterNo,RToPrinter,RFont,ROrient,RCopies);
        }
      end;
      RFont.Assign(Application.MainForm.Font);
      RPrinterNo:=-1;
      RToPrinter:=BOn;
      *)
    {$ELSE}
      (*
      RFont.Assign(Application.MainForm.Font);
      RPrinterNo:=-1;
      RToPrinter:=BOff;
      *)
    {$ENDIF}


    If (Not Assigned(RepExLocal)) and (Result) then { Open up files here }
      Result:=Create_ReportFiles;

    If (Result) then
      MTExLocal:=RepExLocal;

    If (Result) then
      InitRep1;

  end;
end;


function TGenReport.ChkRepAbort  :  Boolean;


Begin
  If (Assigned(ThreadRec)) then
    RepAbort:=ThreadRec^.THAbort;

  Result:=Not RepAbort;
end;


Procedure TGenReport.DelSwpFile;

Var
    DelF    :  File of Byte;

Begin
  {$I-}

   AssignFile(DelF,RepFiler1.FileName);

   Erase(DelF);

   MTExLocal^.LReport_IOError(IOResult,RepFiler1.FileName);

 {$I+}



end;

Procedure TGenReport.Finish;
Var
  PParam   :  ^TPrintParam;
Begin
  New(PParam);

  FillChar(PParam^,Sizeof(PParam^),0);

  ShowStatus(2,'Printing Report.');

  With PParam^ Do Begin
    PDevRec:=RDevRec;

    FileName:=RepFiler1.FileName;
    RepCaption:=RepTitle;

    PBatch:=RUseForms;

{$IFNDEF SENT}
    {$IFDEF THREDZ}
      With MTExLocal^ Do Begin
        If (Assigned(LThPrintJob)) and (Not ThreadRec^.ThAbortPrint) then Begin {* Call back to Synchronise method *}
          ThreadRec^.THAbort:=BOn; {* Force abort, as control now handed over to DLL *}
          LThPrintJob(nil,LongInt(@PParam^),0);
        End { If }
        Else
          If (ThreadRec^.ThAbortPrint) Then Begin
            RepFiler1.Abort;
            DelSwpFile;
          End; { If }
      End; { With }

      If (Assigned(ThreadRec)) then
        UpdateProgress(ThreadRec^.PTotal);
    {$ENDIF}
{$ENDIF}
  end; {With..}

  InPrint:=BOff;

  Inherited Finish;
end;






end.
