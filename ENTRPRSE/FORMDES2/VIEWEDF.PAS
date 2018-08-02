unit ViewEDF;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }
{$REALCOMPATIBILITY ON}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bkgroup, RPDefine, RPBase, RPCanvas, RPFPrint, StdCtrls, TEditVal, Menus,
  RPDevice, RPreview, Buttons, ExtCtrls, SBSPanel, ComCtrls, ImgList,
  ToolWin, AbBase, AbBrowse, AbZBrows, AbUnZper, AbUtils, AdvGlowButton,
  AdvToolBar, AdvToolBarStylers;

type
  TForm1 = class(TForm)
    FilePrinter1: TFilePrinter;
    Notebook1: TNotebook;
    SBSBackGroup1: TSBSBackGroup;
    lblPrintFile: Label8;
    lblPrinter: Label8;
    Panel_ScrollBox: TSBSPanel;
    ScrollBox_Preview: TScrollBox;
    Panel_ScrollBar: TSBSPanel;
    ScrollBar_Pages: TScrollBar;
    FilePreview1: TFilePreview;
    Popup_Preview: TPopupMenu;
    Popup_Preview_ZoomIn: TMenuItem;
    Popup_Preview_ZoomOut: TMenuItem;
    Popup_Preview_ZoomToPage: TMenuItem;
    Popup_Preview_ZoomToNormal: TMenuItem;
    Popup_Preview_SepBar1: TMenuItem;
    Popup_Preview_PrevPage: TMenuItem;
    Popup_Preview_NextPage: TMenuItem;
    Popup_Preview_SepBar2: TMenuItem;
    Popup_Preview_Print: TMenuItem;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    menu_File: TMenuItem;
    Menu_File_Print: TMenuItem;
    Menu_File_SepBar: TMenuItem;
    Menu_File_Exit: TMenuItem;
    Menu_View: TMenuItem;
    Menu_Help: TMenuItem;
    Menu_Help_About1: TMenuItem;
    Menu_View_PrevPage: TMenuItem;
    Menu_View_NextPage: TMenuItem;
    Menu_View_SepBar1: TMenuItem;
    Menu_View_ZoomIn: TMenuItem;
    Menu_View_ZoomOut: TMenuItem;
    Menu_View_ZoomPage: TMenuItem;
    ZoomtoNormal1: TMenuItem;
    N1: TMenuItem;
    Menu_Help_Contents: TMenuItem;
    AbUnZipper1: TAbUnZipper;
    AdvToolBarStyler: TAdvToolBarOfficeStyler;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    btnZoomOut: TAdvGlowButton;
    btnFullPage: TAdvGlowButton;
    btnZoomIn: TAdvGlowButton;
    btnPrevPage: TAdvGlowButton;
    btnNextPage: TAdvGlowButton;
    btnPrint: TAdvGlowButton;
    btnHelp: TAdvGlowButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Menu_View_ZoomInClick(Sender: TObject);
    procedure Menu_View_ZoomOutClick(Sender: TObject);
    procedure Menu_View_ZoomPageClick(Sender: TObject);
    procedure Menu_View_PrevPageClick(Sender: TObject);
    procedure Menu_View_NextPageClick(Sender: TObject);
    procedure ScrollBar_PagesScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure Panel_ScrollBarResize(Sender: TObject);
    procedure Panel_PagesDblClick(Sender: TObject);
    procedure Menu_File_PrintClick(Sender: TObject);
    procedure ScrollBar_PagesChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Menu_File_ExitClick(Sender: TObject);
    procedure Menu_Help_About1Click(Sender: TObject);
    procedure Menu_View_ZoomToNormalClick(Sender: TObject);
    procedure AppOnHint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Menu_Help_ContentsClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    FormMode : Byte;
    ScPage   : LongInt;
    SysMenuH : HWnd;
    DelFile  : ShortString;

    Procedure EnableButts(PageNo : SmallInt);
    Procedure StartPreview;
    procedure UnzipEDZ (Var InFile : ShortString);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  GfxUtil, StrUtil;

{$R *.DFM}

Const
  CM_AboutApp  =  $F0;

procedure TForm1.FormCreate(Sender: TObject);
Var
  InFile : ShortString;
  I : Byte;
begin
  Caption := Application.Title;

  Application.OnHint := AppOnHint;
  Application.HelpFile := ExtractFilePath(Application.Exename) + 'EDFREADR.CHM';

  FormMode := 0;
  Delfile := '';

  If (ParamCount > 0) Then Begin
    // HM 12/06/00: Modified filename extraction as Internet Mail was creating files with
    //              embedded spaces. This was seen as multiple parameters.
    //InFile := UpperCase(ParamStr(1));

    InFile := UpperCase(Trim(CmdLine));

    // Trim off application name
    I := Pos('.EXE', InFile);
    If (I > 0) Then Delete (InFile, 1, I + 4);

    // trim off anything after filename
    InFile := Trim (InFile);
    I := Pos('.EDF', InFile);
    If (I = 0) Then I := Pos('.EDZ', InFile);
    If (I > 0) Then Delete (InFile, I + 4, Length(InFile));

    If FileExists(InFile) Then Begin
      FormMode := 2;
      If (ParamCount > 1) Then Begin
        If (UpperCase(ParamStr(2)) = '/P') Or (UpperCase(ParamStr(2)) = '/PRINT') Then
          FormMode := 1;
      End; { If }
    End { If }
    Else Begin
      // File Not Found
      MessageDlg ('The Document File could not be found, the command line was:-' + #13#13 +
                  '''' + CmdLine + '''', mtError, [mbOk], 0);
    End; { Else }
  End; { If }

  If (Pos('.EDZ', InFile) > 0) Then Begin
    // Extract .EDF from .EDZ archive
    UnzipEDZ (InFile);

    // Ensure that .EDF which WE created gets deleted
    DelFile := InFile;
  End; { If }


  FilePrinter1.FileName := InFile;

  Case FormMode Of
    0 : Begin { Abort/Abandon/Terminate }
          PostMessage (Self.Handle, WM_CLOSE, 0, 0);
        End;
    1 : Begin { Print }
          { Setup dialog }
          NoteBook1.ActivePage := 'Print';
          ClientHeight := 67;
          ClientWidth := 348;

          AdvDockPanel.Visible := False;

          If (MainMenu1.Items.Count > 0) Then
            For I := 0 To Pred(MainMenu1.Items.Count) Do Begin
              MainMenu1.Items[I].Enabled := False;
            End; { For }

          { automatically print file }
          lblPrintFile.Caption := lblPrintFile.Caption + UpperCase(InFile);
          lblPrinter.Caption := lblPrinter.Caption + RPDev.Printers[RpDev.DeviceIndex];
        End;
    2 : Begin { Preview }
          { Setup dialog }
          FilePreview1.FileName := InFile;

          {ClientHeight := 400;
          ClientWidth := 600;}
          Height := Trunc(Screen.Height * 0.9);
          Width := Trunc(Screen.Width * 0.75);
          NoteBook1.ActivePage := 'Preview';
        End;
  End; { Case }
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Refresh;

  If (FormMode = 1) Then Begin
    FilePrinter1.Execute;

    { Auto Close }
    PostMessage (Self.Handle, WM_CLOSE, 0, 0);
  End { If }
  Else Begin
    If (FormMode = 2) Then Begin
      { Preview }
      LockWindowUpdate(Handle);
      StartPreview;
      LockWindowUpdate(0);
    End; { If }
  End; { Else }
end;

Procedure TForm1.StartPreview;
Var
  Tmp : Integer;
Begin
  ScPage := -1;
  FilePreview1.Start;

  Tmp := Round(FilePreview1.Pages * 0.1);
  If (Tmp < 1) Then Tmp := 1;
  ScrollBar_Pages.LargeChange := Tmp;
  ScrollBar_Pages.SetParams (1, 1, FilePreview1.Pages);
  ScrollBar_Pages.Enabled := (FilePreview1.Pages > 1);
  Panel_ScrollBar.Visible := (FilePreview1.Pages > 1);
  EnableButts(ScrollBar_Pages.Position);
end;

Procedure TForm1.EnableButts(PageNo : SmallInt);
begin
  Popup_Preview_PrevPage.Enabled := (PageNo > ScrollBar_Pages.Min);
  Popup_Preview_NextPage.Enabled := (PageNo < ScrollBar_Pages.Max);

  btnPrevPage.Enabled := Popup_Preview_PrevPage.Enabled;
  btnNextPage.Enabled := Popup_Preview_NextPage.Enabled;

  Menu_View_PrevPage.Enabled := Popup_Preview_PrevPage.Enabled;
  Menu_View_NextPage.Enabled := Popup_Preview_NextPage.Enabled;
End;

procedure TForm1.Menu_View_ZoomInClick(Sender: TObject);
begin
  FilePreview1.ZoomIn;
end;

procedure TForm1.Menu_View_ZoomOutClick(Sender: TObject);
begin
  FilePreview1.ZoomOut;
end;

procedure TForm1.Menu_View_ZoomPageClick(Sender: TObject);
begin
  FilePreview1.ZoomFactor := FilePreview1.ZoomPageFactor;
end;

procedure TForm1.Menu_View_PrevPageClick(Sender: TObject);
Var
  NP : Integer;
begin
  NP := ScrollBar_Pages.Position - 1;
  If (NP >= ScrollBar_Pages.Min) And (NP <= ScrollBar_Pages.Max) Then Begin
    ScrollBar_PagesScroll(Sender, scPosition, NP);
    ScrollBar_Pages.Position := NP;
  End; { If }
end;

procedure TForm1.Menu_View_NextPageClick(Sender: TObject);
Var
  NP : Integer;
begin
  NP := ScrollBar_Pages.Position + 1;
  If (NP >= ScrollBar_Pages.Min) And (NP <= ScrollBar_Pages.Max) Then Begin
    ScrollBar_PagesScroll(Sender, scPosition, NP);
    ScrollBar_Pages.Position := NP;
  End; { If }
end;

procedure TForm1.ScrollBar_PagesScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  If (ScrollCode <> scTrack) And (ScPage <> ScrollPos) Then Begin
    { Update display - disable scrollbar as it stops a bug which   }
    { causes it to automatically scroll whenever the mouse is over }
    { the button which was clicked                                 }
    ScPage := ScrollPos;
    FilePreview1.PrintPage(ScrollPos);
    EnableButts(ScrollPos);
  End; { If }
end;

procedure TForm1.Panel_ScrollBarResize(Sender: TObject);
begin
  ScrollBar_Pages.Height := Panel_ScrollBar.Height - 2;
end;

procedure TForm1.Panel_PagesDblClick(Sender: TObject);
begin
  ShowMessage ('Report Printer ' + FilePrinter1.Version);
end;

procedure TForm1.Menu_File_PrintClick(Sender: TObject);
begin
  If FilePrinter1.ShowPrinterSetupDialog Then Begin
    FilePrinter1.IgnoreFileSettings := True;
    FilePrinter1.Execute;
  End; { If RpDevice.PrinterSetupDialog }
end;

procedure TForm1.ScrollBar_PagesChange(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Page ' +
                               IntToStr(ScrollBar_Pages.Position) +
                               ' of ' +
                               IntToStr(ScrollBar_Pages.Max);
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
  Incr, NewPos : SmallInt;
  NP           : Integer;
begin
  With ScrollBox_Preview Do Begin
    If (Shift = []) Then Begin
      // Just keys only
      Case Key Of
        VK_PRIOR : Menu_View_PrevPageClick(Sender);
        VK_NEXT  : Menu_View_NextPageClick(Sender);
      End; { Case }
    End; { If }

    If (ssCtrl In Shift) And (Not (ssAlt In Shift)) Then Begin
      Case Key Of
        VK_PRIOR : Menu_View_PrevPageClick(Sender);
        VK_NEXT  : Menu_View_NextPageClick(Sender);
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
  End; { With }
end;

procedure TForm1.Menu_File_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Menu_Help_About1Click(Sender: TObject);
Var
  sAbout : ANSIString;
begin
  { CJS - 2013-07-08 - ABSEXCH-14438 - update branding and copyright }
  sAbout := 'Exchequer EDF/EDZ Reader Build 017' + #13#13 +
            'Printer Engine: ' + FilePrinter1.Version + #13#13 +
            GetCopyrightMessage;
            // HM 02/01/03: Changed to use standarx functions
            //'Copyright 1986-2002 Exchequer Software Ltd.';

  Application.MessageBox (PCHAR(sAbout),
                          'About Exchequer EDF/EDZ Reader',
                          MB_OK Or MB_ICONINFORMATION);
end;

procedure TForm1.Menu_View_ZoomToNormalClick(Sender: TObject);
begin
  FilePreview1.ZoomFactor := 115;
end;

procedure TForm1.AppOnHint(Sender: TObject);
Begin { AppOnHint }
  StatusBar1.Panels[1].Text := '   ' + GetLongHint(Application.Hint);
End; { AppOnHint }

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.OnHint := Nil;

  // End the preview so temporary file can be deleted if required
  FilePreview1.Finish;

  // Delete any listed temporary file
  If (Trim (DelFile) <> '') And FileExists(DelFile) Then
    Try
      DeleteFile (DelFile);
    Except
      On Exception Do ;
    End;
end;

procedure TForm1.Menu_Help_ContentsClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;

procedure TForm1.btnHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_Context,666);
end;

procedure TForm1.UnzipEDZ (Var InFile : ShortString);
Var
  TmpPath   : AnsiString;
  I         : SmallInt;
  Res1      : LongInt;
Begin { UnzipEDZ }
  With AbUnZipper1 Do Begin
    // HM 05/11/01: Added as Abbrevia 3.0 crashes when unzipping EDZ's
    //              as it can't determine the compression method to use
    ForceType := True;
    ArchiveType := atZip;


    FileName := InFile;

    If (Count > 0) Then
      For I := 0 To Pred(Count) Do
        If (UpperCase(ExtractFileExt (Items[I].FileName)) = '.EDF') Then Begin
          // Get windows temp directory
          TmpPath := StringOfChar (' ', 255);
          Res1 := GetTempPath(Length(TmpPath), PChar(TmpPath));
          SetLength (TmpPath, Res1);

          // Extract EFD from .EDZ file to windows\temp directory
          BaseDirectory := TmpPath;

          ExtractAt (I, '');

          InFile := IncludeTrailingBackslash(TmpPath) + Items[I].FileName;
        End; { If }
  End; { With AbUnZipper1 }
End; { UnzipEDZ }

Initialization
  Application.HelpFile := ChangeFileExt(Application.ExeName, '.HLP');
end.

