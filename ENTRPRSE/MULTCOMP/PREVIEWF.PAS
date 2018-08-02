unit PreviewF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RPBase, RPCanvas, RPFPrint, RPreview, Buttons, ExtCtrls,
  SBSPanel, TEditVal, ComCtrls, Menus, RPDefine, RpDevice, ToolWin, ImgList,
  AdvToolBar, AdvGlowButton, AdvToolBarStylers;

type
  TForm_PrintPreview = class(TForm)
    FilePreview1: TFilePreview;
    FilePrinter1: TFilePrinter;
    Panel_ScrollBox: TPanel;
    ScrollBox_Preview: TScrollBox;
    Popup_Preview: TPopupMenu;
    Popup_Preview_SepBar1: TMenuItem;
    Popup_Preview_Print: TMenuItem;
    Popup_Preview_ZoomIn: TMenuItem;
    Popup_Preview_ZoomOut: TMenuItem;
    Popup_Preview_ZoomToPage: TMenuItem;
    Popup_Preview_ZoomToNormal: TMenuItem;
    Popup_Preview_SepBar2: TMenuItem;
    Popup_Preview_PrevPage: TMenuItem;
    Popup_Preview_NextPage: TMenuItem;
    Panel_ScrollBar: TPanel;
    ScrollBar_Pages: TScrollBar;
    OpenDialog1: TOpenDialog;
    N1: TMenuItem;
    popSavePosition: TMenuItem;
    popRestoreDefaults: TMenuItem;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    AdvToolBarStyler: TAdvToolBarOfficeStyler;
    SpeedButton2: TAdvGlowButton;
    SpeedButton3: TAdvGlowButton;
    SpeedButton1: TAdvGlowButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    spbtnPrevPage: TAdvGlowButton;
    spbtnNextPage: TAdvGlowButton;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    spbtnPrint: TAdvGlowButton;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    Button_Close: TAdvGlowButton;
    AdvToolBarSeparator4: TAdvToolBarSeparator;
    Panel_Pages: TPanel;
    procedure FormActivate(Sender: TObject);
    procedure Button_PrintClick(Sender: TObject);
    procedure BitBtn_ZoomInClick(Sender: TObject);
    procedure BitBtn_ZoomOutClick(Sender: TObject);
    procedure BitBtn_ZoomPageClick(Sender: TObject);
    procedure Popup_Preview_ZoomToNormalClick(Sender: TObject);
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
    procedure Panel_PagesDblClick(Sender: TObject);
    procedure popRestoreDefaultsClick(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    DoneRestore : Boolean;
    ScPage      : LongInt;
    PrintStatus : Byte;
    SysMenuH    : HWnd;
    PrintInfo   : PSBSPrintSetupInfo;
    HaveClosed  : Boolean;
    Procedure EnableButts(PageNo : SmallInt);
    Procedure MaxSize;

    // Controls the loading/saving of the colours and positions
    //
    // Mode   0=Load Details, 1=Save Details, 2=Delete Details
    procedure SetColoursUndPositions (Const Mode : Byte);
  public
    { Public declarations }
    NoCopies     : SmallInt;
    PageF, PageL : LongInt;
    Procedure StartPreview;
    Procedure SetCaption (Const JobName : ShortString);
    Procedure SetPrintInfo(Value : TSBSPrintSetupInfo);
  end;

var
  Form_PrintPreview: TForm_PrintPreview;

// Display Print Preview window
Procedure PreviewReport (Const ParentForm : TForm; Const RepFile : ShortString; Const SBSSetupInfo : TSBSPrintSetupInfo);

Procedure DeletePrintFile (Const PrintFile : String); StdCall;

implementation

{$R *.DFM}

Uses PageDlg,
     uSettings,       // Colour/Position editing and saving routines
     GfxUtil;

//-------------------------------------------------------------------------

// Display Print Preview window
Procedure PreviewReport (Const ParentForm : TForm; Const RepFile : ShortString; Const SBSSetupInfo : TSBSPrintSetupInfo);
Var
  Form_PrintPreview : TForm_PrintPreview;
Begin // PreviewReport
  Form_PrintPreview := TForm_PrintPreview.Create (ParentForm);
  Try
    Form_PrintPreview.SetPrintInfo(SBSSetupInfo);

    Form_PrintPreview.FilePreview1.FileName := RepFile;
    Form_PrintPreview.FilePreview1.PrinterIndex := SBSSetupInfo.DevIdx;
    Form_PrintPreview.FilePrinter1.FileName := RepFile;
    Form_PrintPreview.FilePrinter1.PrinterIndex := SBSSetupInfo.DevIdx;

    Form_PrintPreview.ShowModal;
  Finally
    FreeAndNIL(Form_PrintPreview);
  End
End; // PreviewReport

//-------------------------------------------------------------------------

Procedure DeletePrintFile (Const PrintFile : String);
Begin
  If FileExists (PrintFile) Then Begin
    Try
      DeleteFile (PrintFile);
    Except
      MessageDlg ('Error:' +
                  #13#10#13#10 +
                  'An error has occured deleting the temporary file, ''' +
                  PrintFile +
                  '''.',
                  mtError,
                  [mbOk],
                  0);
    End;
  End; { If }
End;

//-------------------------------------------------------------------------

Procedure TForm_PrintPreview.MaxSize;
Begin
  (*
  Top    := 1;
  Left   := 1;
  Width  := Application.MainForm.ClientWidth - 2 - GetSystemMetrics (SM_CXVSCROLL);
  Height := Application.MainForm.ClientHeight - Application.MainForm.Tag - 2 - GetSystemMetrics (SM_CYHSCROLL);
  WindowState := wsNormal;
  *)
  WindowState := wsMaximized;
End;

procedure TForm_PrintPreview.FormCreate(Sender: TObject);
begin
  { Set Tag to 1010, so window can be ID'd uniquely }
  SetWindowLong (Handle, GWL_USERDATA, 1010);

  if ColorMode(self.canvas) in [cm256Colors, cm16Colors, cmMonochrome] then
  begin
    {colour mode = 256 colours or less}

    {Set image lists for toolbar}
//    ToolBar.Images := ilTBar16Col;
//    ToolBar.HotImages := nil;
//    ToolBar.DisabledImages := nil;

    {free unused image lists}
//    FreeandNil(ilTBar24Bit);
//    FreeandNil(ilTBar24BitHot);
//    FreeandNil(ilTBar24BitDis);
  end
  else begin
    {colour mode > 256 colours}

    {Set image lists for toolbar}
//    ToolBar.Images := ilTBar24Bit;
//    ToolBar.HotImages := ilTBar24BitHot;
//    ToolBar.DisabledImages := ilTBar24BitDis;

    {free unused image list}
//    FreeandNil(ilTBar16Col);
  end;{if}

  New(PrintInfo);

  NoCopies := 1;
  PrintStatus := 0;
  Panel_Pages.Caption := '';
  PageF := 1;
  PageL := 1;

  HaveClosed := False;

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  SetColoursUndPositions (0);
end;

procedure TForm_PrintPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Save colours/positions/sizes/etc...
  SetColoursUndPositions (1);

  If (Not HaveClosed) Then Begin
    HaveClosed := True;

    { Finish Preview }
    Try
      If FilePreview1.Printing Then
        FilePreview1.Finish;
    Except
      On Exception Do ;
    End;

    { Delete report file if necessary }
    DeletePrintFile (FilePreview1.FileName);

    { Deallocate form resources }
    Action := caFree;

    Dispose(PrintInfo);
  End; { If }
end;

procedure TForm_PrintPreview.FormActivate(Sender: TObject);
begin
  Refresh;
  LockWindowUpdate(Handle);
  StartPreview;
  LockWindowUpdate(0);
End;

Procedure TForm_PrintPreview.StartPreview;
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

procedure TForm_PrintPreview.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
  Incr, NewPos : SmallInt;
  NP           : Integer;
begin
  With ScrollBox_Preview Do Begin
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

    { HM: Added processing of shortcuts for close button - Delphi5 doesn't seem to do it correctly }
    If ((Shift = []) And (Key = 27)) Or
       ((Shift = [ssAlt]) And ((Key = Ord('C')) Or (Key = Ord('c')))) Then Begin
      { Escape or Alt-C }
      Button_CloseClick(Self);
    End; { If }
  End; { With }
end;

procedure TForm_PrintPreview.Button_PrintClick(Sender: TObject);
Var
  I : SmallInt;
begin
  With TPageSetupDlg.Create(Self) Do
    Try
      Copies := NoCopies;
      NoPages := FilePreview1.Pages;
      CurrPage := ScrollBar_Pages.Position;

      If Execute Then Begin
        PageF := FPage;
        PageL := LPage;
        NoCopies := Copies;

        If (NoCopies < 1) Then NoCopies := 1;
        If (NoCopies > 99) Then NoCopies := 99;
        For I := 1 To NoCopies Do
          FilePrinter1.ExecuteCustom(PageF, PageL, 1);
      End; { If }
    Finally
      Free;
    End;
end;

{ Zoom in }
procedure TForm_PrintPreview.BitBtn_ZoomInClick(Sender: TObject);
begin
  FilePreview1.ZoomIn;
end;

{ Zoom Out }
procedure TForm_PrintPreview.BitBtn_ZoomOutClick(Sender: TObject);
begin
  FilePreview1.ZoomOut;
end;

{ Show Page }
procedure TForm_PrintPreview.BitBtn_ZoomPageClick(Sender: TObject);
begin
  FilePreview1.ZoomFactor := FilePreview1.ZoomPageFactor;
end;

{ Return to initial zoom size }
procedure TForm_PrintPreview.Popup_Preview_ZoomToNormalClick(
  Sender: TObject);
begin
  FilePreview1.ZoomFactor := 100;
end;

procedure TForm_PrintPreview.Popup_Preview_PrevPageClick(Sender: TObject);
Var
  NP : Integer;
begin
  NP := ScrollBar_Pages.Position - 1;
  If (NP >= ScrollBar_Pages.Min) And (NP <= ScrollBar_Pages.Max) Then Begin
    ScrollBar_PagesScroll(Sender, scPosition, NP);
    ScrollBar_Pages.Position := NP;
  End; { If }
End;

procedure TForm_PrintPreview.Popup_Preview_NextPageClick(Sender: TObject);
Var
  NP : Integer;
begin
  (*
  If (ScrollBar_Pages.Position < ScrollBar_Pages.Max) Then Begin
    { Print Page }
    FilePreview1.NextPage;

    Refresh;
    Application.ProcessMessages;
  End; { If }

  ScrollBar_Pages.Position := FilePreview1.CurrentPage;
  EnableButts(ScrollBar_Pages.Position);
  *)
  NP := ScrollBar_Pages.Position + 1;
  If (NP >= ScrollBar_Pages.Min) And (NP <= ScrollBar_Pages.Max) Then Begin
    ScrollBar_PagesScroll(Sender, scPosition, NP);
    ScrollBar_Pages.Position := NP;
  End; { If }
end;

Procedure TForm_PrintPreview.EnableButts(PageNo : SmallInt);
begin
  Popup_Preview_PrevPage.Enabled := (PageNo > ScrollBar_Pages.Min);
  Popup_Preview_NextPage.Enabled := (PageNo < ScrollBar_Pages.Max);
  spbtnPrevPage.Enabled := Popup_Preview_PrevPage.Enabled;
  spbtnNextPage.Enabled := Popup_Preview_NextPage.Enabled;
End;
    
procedure TForm_PrintPreview.Panel_ScrollBarResize(Sender: TObject);
begin
  ScrollBar_Pages.Height := Panel_ScrollBar.Height - 4;
end;

procedure TForm_PrintPreview.ScrollBar_PagesScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  If (ScrollCode <> scTrack) And (ScPage <> ScrollPos) Then Begin
    { Update display - disable scrollbar as it stops a bug which   }
    { causes it to automatically scroll whenever the mouse is over }
    { the button which was clicked                                 }
    {ScrollBar_Pages.Enabled := False;}
    ScPage := ScrollPos;
    FilePreview1.PrintPage(ScrollPos);
    {Refresh;}
    EnableButts(ScrollPos);
    {ScrollBar_Pages.Enabled := True;}
  End; { If }
end;

procedure TForm_PrintPreview.Button_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_PrintPreview.FormResize(Sender: TObject);
begin
  (* HM 23/03/00: Fixed min/max problems caused by WindowState bug
  {
  Button_Close.Left := Panel_Toolbar.ClientWidth - Button_Close.Width - BitBtn_ZoomIn.Left;
  }
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
  *)
end;

procedure TForm_PrintPreview.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := (PrintStatus = 0);

  If (Not CanClose) Then
    MessageDlg ('The Preview window cannot be closed while printing is in progress', mtInformation, [mbOk], 0)
  Else
    If (FormStyle = fsMDIChild) And (WindowState = wsMaximized) Then
      WindowState := wsMinimized;
end;

procedure TForm_PrintPreview.ScrollBar_PagesChange(Sender: TObject);
begin
  Panel_Pages.Caption := 'Page ' +
                          IntToStr(ScrollBar_Pages.Position) +
                          ' of ' +
                          IntToStr(ScrollBar_Pages.Max);
end;

procedure TForm_PrintPreview.FormDeactivate(Sender: TObject);
begin
  If (WindowState = wsMaximized) Then
    WindowState := wsNormal;
end;

procedure TForm_PrintPreview.Panel_PagesDblClick(Sender: TObject);
begin
  ShowMessage ('Report Printer ' + FilePrinter1.Version);
end;

procedure TForm_PrintPreview.SetCaption (Const JobName : ShortString);
Var
  JobType : String[10];
Begin { SetCaption }
  JobType := 'Print';

  If Assigned(PrintInfo) Then Begin
    Case PrintInfo^.fePrintMethod Of
      1 : JobType := 'Fax';
      2 : JobType := 'Email';
    End; { Case }
  End; { If }

  Self.Caption := JobType + ' Preview - ' + Trim(JobName);
End; { SetCaption }

Procedure TForm_PrintPreview.SetPrintInfo(Value : TSBSPrintSetupInfo);
Begin { SetPrintInfo }
  PrintInfo^ := Value;

  { Cannot print if faxing and not using the MAPI/Enterprise faxing }
  spbtnPrint.Visible :=  (Value.fePrintMethod <> 1) Or
                          ((Value.fePrintMethod = 1) And (Value.feFaxMethod In [0, 1]));
End; { SetPrintInfo }

//-------------------------------------------------------------------------

// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
procedure TForm_PrintPreview.SetColoursUndPositions (Const Mode : Byte);
Var
  WantAutoSave : Boolean;
Begin // SetColoursUndPositions
  Case Mode Of
    0 : Begin
          oSettings.LoadForm (Self, WantAutoSave);
          popSavePosition.Checked := WantAutoSave;
        End;
    1 : If (Not DoneRestore) Then
        Begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm (Self, popSavePosition.Checked);
        End; // If (Not DoneRestore)
    2 : Begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults (Self.Name);
          popSavePosition.Checked := False;
        End;
  Else
    Raise Exception.Create ('TForm_PrintPreview.SetColoursUndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  End; // Case Mode
End; // SetColoursUndPositions

//-------------------------------------------------------------------------

procedure TForm_PrintPreview.popRestoreDefaultsClick(Sender: TObject);
begin
  SetColoursUndPositions (2);
end;

//-------------------------------------------------------------------------

procedure TForm_PrintPreview.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  OriginalPos, ScrollPos: Integer;
begin
  LockWindowUpdate(self.Handle);
  try
    OriginalPos := ScrollBox_Preview.VertScrollBar.Position;
    ScrollBox_Preview.VertScrollBar.Position := ScrollBox_Preview.VertScrollBar.Position + ScrollBox_Preview.VertScrollBar.Increment;
    if (ScrollBox_Preview.VertScrollBar.Position = OriginalPos) and
       (ScrollBar_Pages.Position < FilePreview1.Pages) then
    begin
      ScrollPos := ScrollBar_Pages.Position + 1;
      ScPage := ScrollPos;
      ScrollBar_Pages.Position := ScrollPos;
      FilePreview1.PrintPage(ScrollPos);
      ScrollBox_Preview.VertScrollBar.Position := 0;
      EnableButts(ScrollPos);
    end;
    Handled := True;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TForm_PrintPreview.FormMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  OriginalPos, ScrollPos: Integer;
begin
  LockWindowUpdate(self.Handle);
  try
    OriginalPos := ScrollBox_Preview.VertScrollBar.Position;
    ScrollBox_Preview.VertScrollBar.Position := ScrollBox_Preview.VertScrollBar.Position - ScrollBox_Preview.VertScrollBar.Increment;
    if (ScrollBox_Preview.VertScrollBar.Position = OriginalPos) and
       (ScrollBar_Pages.Position > 1) then
    begin
      ScrollPos := ScrollBar_Pages.Position - 1;
      ScPage := ScrollPos;
      ScrollBar_Pages.Position := ScrollPos;
      FilePreview1.PrintPage(ScrollPos);
      // Setting the scroll bar to a high number will force it to display the
      // bottom of the page (there is no obvious way to calculate the correct
      // scroll bar position).
      ScrollBox_Preview.VertScrollBar.Position := 32768;
      EnableButts(ScrollPos);
    end;
    Handled := True;
  finally
    LockWindowUpdate(0);
  end;

end;

end.





