unit PrevPCC;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RPBase, RPCanvas, RPFPrint, RPreview, Buttons, ExtCtrls,
  SBSPanel, TEditVal, ComCtrls, Menus, GlobType, RPDefine, PrintPCC,
  RPrinter, RpDevice, PCCToEFP, ImgList, ToolWin, AbBase, AbBrowse,
  AbZBrows;

type
  TForm_PrevPCC = class(TForm)
    Panel_ScrollBox: TSBSPanel;
    Popup_Preview: TPopupMenu;
    Popup_Preview_Print: TMenuItem;
    Popup_Preview_SepBar2: TMenuItem;
    Popup_Preview_PrevPage: TMenuItem;
    Popup_Preview_NextPage: TMenuItem;
    Panel_ScrollBar: TSBSPanel;
    ScrollBar_Pages: TScrollBar;
    ToPrinter1: TMenuItem;
    ToFile1: TMenuItem;
    Memo1: TMemo;
    FontDialog1: TFontDialog;
    SaveDialog1: TSaveDialog;
    ReportPrinter1: TReportPrinter;
    FilePrinter1: TFilePrinter;
    CoolBar1: TCoolBar;
    ToolBar: TToolBar;
    ToolButton4: TToolButton;
    spbtnPrevPage: TToolButton;
    spbtnNextPage: TToolButton;
    ToolButton5: TToolButton;
    BitBtn_Print: TToolButton;
    ToolButton2: TToolButton;
    Button_Close: TToolButton;
    ToolButton1: TToolButton;
    Panel2: TPanel;
    Panel_Pages: TPanel;
    SpeedButton2: TToolButton;
    SpeedButton3: TToolButton;
    ilTBar24BitDisaaa: TImageList;
    ilTBar24Bitaaa: TImageList;
    ilTBar24BitHotaaa: TImageList;
    procedure BitBtn_PrintClick(Sender: TObject);
    procedure Popup_Preview_PrevPageClick(Sender: TObject);
    procedure Popup_Preview_NextPageClick(Sender: TObject);
    procedure Panel_ScrollBarResize(Sender: TObject);
    procedure ScrollBar_PagesScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure Button_CloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ScrollBar_PagesChange(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure BitBtn_MemoFontClick(Sender: TObject);
    procedure ReportPrinter1Print(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Panel_PagesDblClick(Sender: TObject);
  private
    { Private declarations }
    PrnF        : TFileStream;
    PageList    : TList;
    PrevName    : ShortString;
    RepFName    : ShortString; { Name Of Temporary file }
    ScPage      : LongInt;
    PrintStatus : Byte;
    SysMenuH    : HWnd;
    ToPrinter   : Boolean;
    PEFxs       : PEFxsREC;
    PrintInfo   : PSBSPrintSetupInfo;
    PreviewMode : Byte;      { 1 - Form Designer Modal, 2 - Exchequer mdi child }
    procedure CreatePrnFile (Const TempName : ShortString);
    Procedure EnableButts(PageNo : SmallInt);
    procedure InPrint(var Msg: TMessage); message WM_InPrint;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    procedure UpdateSysMenu;
    procedure SetSysMenu;
    Procedure MaxSize;
    procedure PrintPage (PrnPageNo : LongInt);
  public
    { Public declarations }
    NoCopies     : SmallInt;
    PageF, PageL : LongInt;
    RepHeader    : ShortString;     { Page setup characters to be printed at start of each rep }
    JobInfo      : TJobInfo;
    Procedure SetPrintInfo(Value : TSBSPrintSetupInfo);
    Procedure StartPreview(FName     : ShortString;
                           Copies    : SmallInt;
                           FPageList : TList;
                           FX        : PEFxsREC);
    Procedure DoMenu;
  end;


implementation

{$R *.DFM}

Uses FormUtil,
     FormFile,
     PrntForm,
     SBSFuncs,
     GlobVar,
     VarConst,
     PageDlg,
     BtSupU1,
     PrnCodes,
     PrntPrev,
     GFXUtil;


Const
  CM_AutoMin  =  $F0;
  CM_AutoMax  =  $F1;



Procedure TForm_PrevPCC.WMSysCommand(Var Message  :  TMessage);

Var
  Locked,
  TBo  :  Boolean;

Begin
  With Message do
    Case WParam of
      CM_AutoMin,
      CM_AutoMax    :  Begin
                         Locked:=Bon;

                         TBo:=(WParam=CM_AutoMax);

                         GetMultiSys(BOn,Locked,SysR);

                         Syss.AMMPreview[TBo]:=Not Syss.AMMPreview[TBo];

                         If (Syss.AMMPreview[Not TBo]) and (Syss.AMMPreview[TBo]) then
                           Syss.AMMPreview[Not TBo]:=BOff;

                         PutMultiSys(SysR,BOn);

                         UpdateSysMenu;

                       end;
    end; {Case..}

  Inherited;
end;

Procedure TForm_PrevPCC.MaxSize;
Begin
  WindowState := wsMaximized;
End;

procedure TForm_PrevPCC.UpdateSysMenu;

Var
  MF_Check  :  Integer;

Begin
  If (SystemInfo.ControllerHandle = Nil) Then Begin
    If (Syss.AMMPreview[BOff]) then
      MF_Check:=MF_Checked
    else
      MF_Check:=0;

    ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_String+MF_Check,CM_AutoMin,'&Auto Minimize');
  End { If }
  Else
    ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_Disabled+MF_GRAYED,CM_AutoMin,'&Auto Minimize');

  If (Syss.AMMPreview[BOn]) And (Not Syss.AMMPreview[BOff]) then
    MF_Check:=MF_Checked
  else
    MF_Check:=0;

  ModifyMenu(SysMenuH,CM_AutoMax,MF_ByCommand+MF_String+MF_Check,CM_AutoMax,'A&uto Maximize');
end;

procedure TForm_PrevPCC.SetSysMenu;

Begin
  SysMenuH:=GetSystemMenu(Handle,BOff);

  AppendMenu(SysMenuH,MF_SEPARATOR,0,'');

  AppendMenu(SysMenuH,MF_String,CM_AutoMin,'');

  AppendMenu(SysMenuH,MF_String,CM_AutoMax,'');

  UpdateSysMenu;
end;

{ function called after changing form to MDI child, as that screws everything up }
Procedure TForm_PrevPCC.DoMenu;
begin
  SetSysMenu;

  FormResize (Application);

  If Syss.AMMPreview[BOn] Then MaxSize;
end;

procedure TForm_PrevPCC.FormCreate(Sender: TObject);
Var
  TmpFont : TFont;
  I       : SmallInt;
begin
  { Set Tag to 1010, so window can be ID'd uniquely }
  SetWindowLong (Handle, GWL_USERDATA, 1010);

  New(PrintInfo);

  PageList := TList.Create;

  PrnF := Nil;
  NoCopies := 1;
  PrintStatus := 0;
  Panel_Pages.Caption := '';
  PageF := 1;
  PageL := 1;

  SetSysMenu;

  If (Syss.AMMPreview[BOff]) Then Begin
    If (SystemInfo.ControllerHandle = Nil) Then WindowState := wsMinimized
  End { If }
  Else
    { Set to maximised only if running from Form Designer }
    If (Syss.AMMPreview[BOn]) {And (SystemInfo.ControllerHandle <> Nil)} Then
      WindowState := wsMaximized;

  TmpFont := Memo1.Font;
  GetPreviewFont (TmpFont);
end;

procedure TForm_PrevPCC.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  { Free form handle from list in dll }
  FreeFormHandle (Handle);

  { Free page info }
  While (PageList.Count > 0) Do Begin
    TPageRef(PageList[0]).Free;
    PageList.Delete(0);
  End; { While }
  PageList.Free;

  PrnF.Free;

  { Save Font info to the .INI file }
  WritePreviewFont(Memo1.Font);

  { Delete report file if necessary }
  DeletePrintFile (PrevName);

  Dispose(PrintInfo);

  { Deallocate form resources }
  Action := caFree;
end;

Procedure TForm_PrevPCC.StartPreview(FName     : ShortString;
                                     Copies    : SmallInt;
                                     FPageList : TList;
                                     FX        : PEFxsREC);
Var
  Tmp : Integer;
Begin
  { Open print file as a stream }
  NoCopies := Copies;
  PrevName := FName;
  PrnF := TFileStream.Create(PrevName, (fmOpenRead Or fmShareDenyNone));

  { Copy printter codes }
  PEFxs := FX;
  FillChar(PEFxs.OnOff,Sizeof(PEFxs.OnOff),0);

  { Move page info to local list}
  While (FPageList.Count > 0) Do Begin
    PageList.Add (FPageList[0]);
    FPageList.Delete(0);
  End; { While }

  { Set scroll shadow page }
  ScPage := -1;

  { Setup scrollbars }
  Tmp := Round(PageList.Count * 0.1);
  If (Tmp < 1) Then Tmp := 1;
  ScrollBar_Pages.LargeChange := Tmp;
  ScrollBar_Pages.SetParams (1, 1, PageList.Count);
  ScrollBar_Pages.Enabled := (PageList.Count > 1);
  Panel_ScrollBar.Visible := (PageList.Count > 1);
  EnableButts(ScrollBar_Pages.Position);

  { Print first page }
  PrintPage (ScrollBar_Pages.Position);
end;

procedure TForm_PrevPCC.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
  Incr, NewPos : SmallInt;
  NP           : Integer;
begin
  With Memo1 Do Begin
    If (ssCtrl In Shift) And (Not (ssAlt In Shift)) Then Begin
      Case Key Of
        VK_PRIOR : Popup_Preview_PrevPageClick(Sender);
        VK_NEXT  : Popup_Preview_NextPageClick(Sender);
        VK_HOME  : Begin
                     NP := ScrollBar_Pages.Min;
                     ScrollBar_PagesScroll(Sender, scPosition, NP);
                     ScrollBar_Pages.Position := NP;
                   End;
        VK_END   : Begin
                     NP := ScrollBar_Pages.Max;
                     ScrollBar_PagesScroll(Sender, scPosition, NP);
                     ScrollBar_Pages.Position := NP;
                   End;
      End; { Case }
    End; { If }

    (*
    If (ssAlt In Shift) Then Begin
      If (Key = VK_HOME) Then
        VertScrollBar.Position := 0;

      If (Key = VK_END) Then
        VertScrollBar.Position := VertScrollBar.Range;

      If (Key In [VK_PRIOR, VK_Up, VK_Down, VK_NEXT]) Then Begin
        If (Key In [VK_PRIOR, VK_NEXT]) Then
          { Calc Distance to move - 10% }
          Incr := Height
        Else
          Incr := Round(Height * 0.25);

        { Reverse sign if moving up }
        If (Key In [VK_PRIOR, VK_Up]) Then Incr := -Incr;

        { Check its ok }
        NewPos := VertScrollBar.Position + Incr;
        If (NewPos < 0) Then NewPos := 0;
        If (NewPos > VertScrollBar.Range) Then NewPos := VertScrollBar.Range;

        { move the scrollbar}
        VertScrollBar.Position := NewPos;
      End; { If }

      If (Key In [VK_Left, VK_Right]) Then Begin
        Incr := Round(Width * 0.25);

        { Reverse sign if moving up }
        If (Key In [VK_Left]) Then Incr := -Incr;

        { Check its ok }
        NewPos := HorzScrollBar.Position + Incr;
        If (NewPos < 0) Then NewPos := 0;
        If (NewPos > HorzScrollBar.Range) Then NewPos := HorzScrollBar.Range;

        { move the scrollbar}
        HorzScrollBar.Position := NewPos;
      End; { If }
    End; { If }
    *)
  End; { With }
end;

procedure TForm_PrevPCC.BitBtn_PrintClick(Sender: TObject);
Var
  PageSetupDlg : TPageSetupDlg;
begin
  ToPrinter := (Sender = BitBtn_Print);

  If (PrintInfo^.fePrintMethod = 0) Or (Not ToPrinter) Then Begin
    PageSetupDlg := TPageSetupDlg.Create(Self);
    Try
      With PageSetupDlg Do Begin
        If ToPrinter Then
          Copies := NoCopies
        Else
          HideCopies;
        NoPages := PageList.Count;
        CurrPage := ScrollBar_Pages.Position;
      End; { With PageSetupDlg }

      If PageSetupDlg.Execute Then Begin
        PageF := PageSetupDlg.FPage;
        PageL := PageSetupDlg.LPage;
        NoCopies := PageSetupDlg.Copies;

        PrintStatus := 1; { Checking for print }

        { Send message to check inprint flag }
        SendMessage (SystemInfo.MainForm.Handle, WM_PrintProgress, 4, Handle);
      End; { If }
    Finally
      PageSetupDlg.Free;
    End;
  End { If }
  Else Begin
    { Faxing/Email }
    PrintStatus := 1; { Checking for print }

    { Send message to check inprint flag }
    SendMessage (SystemInfo.MainForm.Handle, WM_PrintProgress, 4, Handle);
  End; { Else }
end;

procedure TForm_PrevPCC.InPrint(var Msg: TMessage);
Var
  BaseDir  : ShortString;
  FVar, I  : SmallInt;
  Abort    : Boolean;
begin
  With Msg, PrintInfo^ Do
    { Check the inprint flag }
    If (WParam = Ord(False)) Then Begin
      { Set inprint }
      SendMessage (SystemInfo.MainForm.Handle, WM_PrintProgress, 3, 1);

      If (fePrintMethod = 0) Or (Not ToPrinter) Then Begin
        { Get filename for temp file }
        Abort := False;
        If ToPrinter Then Begin
          { Generate Unique Filename for report file }
          FVar := 0;
          GetTempFilePath (BaseDir);
          Repeat
            RepFName := BaseDir + '!REP' + IntToStr(FVar) + '.SWP';
            Inc (FVar);
          Until (Not FileExists (RepFName)) Or (FVar > 9999);
          If (FVar > 9999) Then Begin
            MessageDlg('Cannot Find Unique Filename',mtError,[mbOk],0);
            Abort := True;
          End; { If }
        End { If }
        Else Begin
          { Printing To File - convert into destination file }
          SaveDialog1.InitialDir := SetDrive;
          Abort := Not SaveDialog1.Execute;

          If (Not Abort) Then
            RepFName := SaveDialog1.FileName;
        End; { Else }

        If (Not Abort) Then Begin
          { Print selected pages to Temp File converting control codes }
          CreatePrnFile (RepFName);

          If ToPrinter Then Begin
            If (NoCopies < 1) Then NoCopies := 1;
            If (NoCopies > 99) Then NoCopies := 99;

            ReportPrinter1.Title := PrintInfo^.feJobtitle;

            { Print file to current printer }
            For I := 1 To NoCopies Do
              ReportPrinter1.Execute;

            { Delete temporary file }
            DeletePrintFile(RepFName);
          End; { If }
        End; { If }
      End { If }
      Else Begin
        { Faxing/Email }

        { Print PCC Text to RPPro intermediate file and use }
        { normal EFD form functions to handle the rest }
        RepFName := ConvertPCCToEFP (PrevName, JobInfo, PageList, False, PrintInfo^.feJobtitle);

        If (fePrintMethod = 1) Then Begin
          { Fax via MAPI or Exchequer }
          Case feFaxMethod Of
            { via Exchequer }
            0 : SendEntFax (PrintInfo^, FilePrinter1, RepFName, True);
            { via MAPI }
            1 : SendMAPIFax (PrintInfo^, RepFName);
            { Third-Party Fax Software }
            2 : SendEntFax (PrintInfo^, FilePrinter1, RepFName, False);
          Else
            MessageDlg ('Unknown Fax Method (' + IntToStr(feFaxMethod) + ') - Fax not sent',
                        mtError, [mbOk], 0);
          End; { Case }
        End { If }
        Else Begin
          { Email via MAPI/Exchequer }
          SendEmailFile (PrintInfo^, FilePrinter1, RepFName);
        End; { Else }

        { Delete EFP file }
        DeletePrintFile (RepFName);
      End; { Else }

      { reset inprint }
      SendMessage (SystemInfo.MainForm.Handle, WM_PrintProgress, 3, 0);
    End { If }
    Else
      MessageDlg ('Something else is already printing',
                  mtInformation, [mbOk], 0);

  PrintStatus := 0;
end;


procedure TForm_PrevPCC.Popup_Preview_PrevPageClick(Sender: TObject);
Var
  NP : Integer;
begin
  NP := ScrollBar_Pages.Position - 1;
  If (NP >= ScrollBar_Pages.Min) And (NP <= ScrollBar_Pages.Max) Then Begin
    ScrollBar_PagesScroll(Sender, scPosition, NP);
    ScrollBar_Pages.Position := NP;
  End; { If }
End;

procedure TForm_PrevPCC.Popup_Preview_NextPageClick(Sender: TObject);
Var
  NP : Integer;
begin
  NP := ScrollBar_Pages.Position + 1;
  If (NP >= ScrollBar_Pages.Min) And (NP <= ScrollBar_Pages.Max) Then Begin
    ScrollBar_PagesScroll(Sender, scPosition, NP);
    ScrollBar_Pages.Position := NP;
  End; { If }
end;

Procedure TForm_PrevPCC.EnableButts(PageNo : SmallInt);
begin
  Popup_Preview_PrevPage.Enabled := (PageNo > ScrollBar_Pages.Min);
  Popup_Preview_NextPage.Enabled := (PageNo < ScrollBar_Pages.Max);
  spbtnPrevPage.Enabled := Popup_Preview_PrevPage.Enabled;
  spbtnNextPage.Enabled := Popup_Preview_NextPage.Enabled;
End;

procedure TForm_PrevPCC.Panel_ScrollBarResize(Sender: TObject);
begin
  ScrollBar_Pages.Height := Panel_ScrollBar.Height - 4;
end;

procedure TForm_PrevPCC.ScrollBar_PagesScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  If (ScrollCode <> scTrack) And (ScPage <> ScrollPos) Then Begin
    { Update display - disable scrollbar as it stops a bug which   }
    { causes it to automatically scroll whenever the mouse is over }
    { the button which was clicked                                 }
    {ScrollBar_Pages.Enabled := False;}
    ScPage := ScrollPos;
    PrintPage(ScrollPos);
    {Refresh;}
    EnableButts(ScrollPos);
    {ScrollBar_Pages.Enabled := True;}
  End; { If }
end;

procedure TForm_PrevPCC.Button_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_PrevPCC.FormResize(Sender: TObject);
Var
  MF_Check  :  Integer;
begin
  If (WindowState = wsMaximized) Then Begin
    { disable the menu options }
    ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_DISABLED+MF_GRAYED,CM_AutoMin,'&Auto Minimize');
    ModifyMenu(SysMenuH,CM_AutoMax,MF_ByCommand+MF_DISABLED+MF_GRAYED,CM_AutoMax,'A&uto Maximize');
  End { IF }
  Else Begin
    If (SystemInfo.ControllerHandle = Nil) Then Begin
      { re-enable them }
      If (Syss.AMMPreview[BOff]) then
        MF_Check:=MF_Checked
      else
        MF_Check:=0;
      ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_ENABLED+MF_Check,CM_AutoMin,'&Auto Minimize');
    End; { If }

    If (Syss.AMMPreview[BOn]) then
      MF_Check:=MF_Checked
    else
      MF_Check:=0;
    ModifyMenu(SysMenuH,CM_AutoMax,MF_ByCommand+MF_ENABLED+MF_Check,CM_AutoMax,'A&uto Maximize');
  End; { Else }
end;

procedure TForm_PrevPCC.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := (PrintStatus = 0);

  If (Not CanClose) Then
    MessageDlg ('The Preview window cannot be closed while printing is in progress', mtInformation, [mbOk], 0)
  Else
    If (FormStyle = fsMDIChild) And (WindowState = wsMaximized) Then
      WindowState := wsMinimized;
end;

procedure TForm_PrevPCC.ScrollBar_PagesChange(Sender: TObject);
begin
  Panel_Pages.Caption := 'Page ' +
                          IntToStr(ScrollBar_Pages.Position) +
                          ' of ' +
                          IntToStr(ScrollBar_Pages.Max);
end;

procedure TForm_PrevPCC.FormDeactivate(Sender: TObject);
begin
  If (WindowState = wsMaximized) Then
    WindowState := wsNormal;
end;

{ Display the Font dialog for the memo to allow the font to be changed }
procedure TForm_PrevPCC.BitBtn_MemoFontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(Memo1.Font);
  If FontDialog1.Execute Then
    Memo1.Font.Assign(FontDialog1.Font);
end;

procedure TForm_PrevPCC.PrintPage (PrnPageNo : LongInt);
Var
  PageRef    : TPageRef;
  FPos, LPos : LongInt;
  Cont       : Boolean;
  Ch         : Char;
  Line       : ShortString;
Begin
  { Calculate 1st char of page }
  PageRef := PageList[Pred(PrnPageNo)];
  FPos := PageRef.Position;

  { Calculate last char of page }
  If (PrnPageNo < PageList.Count) Then Begin
    PageRef := PageList[PrnPageNo];
    LPos := Pred(PageRef.Position);
  End { If }
  Else
    LPos := PrnF.Size;

  { Clear memo }
  Memo1.Clear;

  { Move to page start }
  PrnF.Position := FPos;

  { Read page character by character }
  Line := '';
  Cont := True;
  While (PrnF.Read (Ch, 1) = 1) And (FPos < LPos) And Cont Do Begin
    Inc (FPos);

    If (Ord(Ch) = 12) Then Begin
      Cont := False;
    End { If }
    Else
      If (Ord(Ch) = 13) Then Begin
        Memo1.Lines.Add(Line);
        Line := '';
      End { If }
      Else
        If (Ord(Ch) >= 32) Then Begin
          Line := Line + Ch;
        End; { If }
  End; { While }
End;


{ Print selected pages to Temp File converting control codes }
procedure TForm_PrevPCC.CreatePrnFile (Const TempName : ShortString);
Var
  PageRef       : TPageRef;
  FPos, LPos, I : LongInt;
  OutF          : TFileStream;
  OutStr        : ShortString;
Begin
  { Check page range is valid }
  If (PageF > 0) And (PageF <= PageList.Count) And
     (PageL >= PageF) And (PageL <= PageList.Count) Then Begin
    { Calculate 1st char of page }
    PageRef := PageList[Pred(PageF)];
    FPos := PageRef.Position;

    { Calculate last char of page }
    If (PageL = PageList.Count) Then
      { Printing last page }
      LPos := PrnF.Size
    Else Begin
      { not printing last page }
      PageRef := PageList[PageL];
      LPos := Pred(PageRef.PrevPBreak);
    End; { Else }

    { Create Temporary Stream }
    OutF := TFileStream.Create(TempName, (fmCreate Or fmOpenWrite Or fmShareExclusive));
    Try
      { Move to page start }
      PrnF.Position := FPos;

      { Write orinter setup chars }
      OutF.Write (RepHeader[1], Length(RepHeader));

      { Read section to print character by character }
      For I := FPos To LPos Do
        If (PrnF.Read (Ch, 1) = 1) Then Begin
          If (Ch In [#10, #13]) Then
            OutF.Write (Ch, 1)
          Else
            If (Ch In [^A..^Z]) Then Begin
              { Control Code - Replace with printer control code }
              With PEFxs do Begin
                OnOff[Ord(Ch)]:=Not OnOff[Ord(Ch)];

                OutStr := Codes[Ord(Ch),OnOff[Ord(Ch)]];

                { Write to stream }
                OutF.Write (OutStr[1], Length(OutStr));
              end; {With..}
            End { If }
            Else
              OutF.Write (Ch, 1);
        End { If }
        Else
          Break;

      OutF.Free;
    Except
      On Ex:Exception Do Begin
        MessageDlg ('The following error occured printing the report:' + #10#13#10#13 +
                    '''' + Ex.Message + '''', mtError, [mbOk], 0);
        OutF.Free;
        DeletePrintFile (TempName);
      End; { On }
    End;
  End { IF }
  Else
    MessageDlg ('An Invalid Page Range was specified', mtError, [mbOk], 0);
End;


procedure TForm_PrevPCC.ReportPrinter1Print(Sender: TObject);
Var
  TempF   : TextFile;
  LineStr : ShortString;
begin
  AssignFile (TempF, RepFName);
  Reset (TempF);

  While Not EOF(TempF) Do Begin
    ReadLn (TempF, LineStr);

    ReportPrinter1.PrintData(LineStr+#13#10);
  End; { While }

  CloseFile (TempF);
end;

Procedure TForm_PrevPCC.SetPrintInfo(Value : TSBSPrintSetupInfo);
Begin { SetPrintInfo }
  PrintInfo^ := Value;

  { Cannot print if faxing and not using the MAPI/Exchequer faxing }
  BitBtn_Print.Visible :=  (Value.fePrintMethod <> 1) Or
                          ((Value.fePrintMethod = 1) And (Value.feFaxMethod In [0, 1]));
End; { SetPrintInfo }

procedure TForm_PrevPCC.FormActivate(Sender: TObject);
begin
  {If (PreviewMode = 1) Then Begin
    Refresh;
    LockWindowUpdate(Handle);
    StartPreview;
    LockWindowUpdate(0);
  End; { If }
end;

procedure TForm_PrevPCC.Panel_PagesDblClick(Sender: TObject);
Var
  ZipInfo : ShortString;
begin
  // NF: Added 26/07/02

  // HM 14/03/02: Added Abbrevia version as well
  Try
    With TAbZipBrowser.Create (Self) Do
      Try
        ZipInfo := #13 + 'PK-Zip Library ' + Version;
      Finally
        Free;
      End;
  Except
    ZipInfo := '';
  End;

  ShowMessage ('Report Printer ' + FilePrinter1.Version + ZipInfo);
end;

end.
