unit PrintPreview;

{ nfrewer440 12:19 22/02/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, RPBase
  , RPCanvas, RPFPrint, RPreview, Buttons, ExtCtrls, SBSPanel, TEditVal, ComCtrls, Menus
  , RPDefine, RpDevice, ToolWin, ImgList, {NeilProc,} APIUtil;

  Procedure DeletePrintFile(Const PrintFile : String);
  
const
  WM_InPrint = WM_USER + $103;

type
  TFrmPrintPreview = class(TForm)
    FilePreview1: TFilePreview;
    FilePrinter1: TFilePrinter;
    Panel_ScrollBox: TSBSPanel;
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
    Panel_ScrollBar: TSBSPanel;
    ScrollBar_Pages: TScrollBar;
    OpenDialog1: TOpenDialog;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    ToolButton15: TToolButton;
    spbtnPrevPage: TToolButton;
    spbtnNextPage: TToolButton;
    ToolButton2: TToolButton;
    spbtnPrint: TToolButton;
    ToolButton6: TToolButton;
    Panel_Pages: TPanel;
    sepProcess: TToolButton;
    btnProcess: TButton;
    ilTBar24Bit: TImageList;
    ilTBar24BitHot: TImageList;
    ilTBar24BitDis: TImageList;
    ilTBar16Col: TImageList;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
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
    procedure FormCreate(Sender: TObject);
    procedure ScrollBar_PagesChange(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Panel_PagesDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    ScPage      : LongInt;
    PrintStatus : Byte;
    PrintInfo   : PSBSPrintSetupInfo;
    bAlreadyClosed : boolean;
    Procedure EnableButts(PageNo : SmallInt);
    procedure InPrint(var Msg: TMessage); message WM_InPrint;
    procedure WindowClose;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
  public
    { Public declarations }
    NoCopies     : SmallInt;
    PageF, PageL : LongInt;
//    ProcessMode : TProcessMode;
    sLogFile : string;
    Procedure StartPreview;
    Procedure SetCaption (Const JobName : ShortString);
    Procedure SetPrintInfo(Value : TSBSPrintSetupInfo);
  end;

var
  FrmPrintPreview: TFrmPrintPreview;

implementation

{$R *.DFM}

Uses
  PrintPages, GfxUtil;


Const
  CM_AutoMin  =  $F0;
  CM_AutoMax  =  $F1;

procedure TFrmPrintPreview.FormCreate(Sender: TObject);
begin
  { Set Tag to 1010, so window can be ID'd uniquely }
  bAlreadyClosed := FALSE;
  SetWindowLong (Handle, GWL_USERDATA, 1010);

  if ColorMode(self.canvas) in [cm256Colors, cm16Colors, cmMonochrome] then
    begin
      {colour mode = 256 colours or less}

      {Set image lists for toolbar}
      ToolBar.Images := ilTBar16Col;
      ToolBar.HotImages := nil;
      ToolBar.DisabledImages := nil;

      {free unused image lists}
      FreeandNil(ilTBar24Bit);
      FreeandNil(ilTBar24BitHot);
      FreeandNil(ilTBar24BitDis);
    end
  else begin
    {colour mode > 256 colours}

    {Set image lists for toolbar}
    ToolBar.Images := ilTBar24Bit;
    ToolBar.HotImages := ilTBar24BitHot;
    ToolBar.DisabledImages := ilTBar24BitDis;

    {free unused image list}
    FreeandNil(ilTBar16Col);
  end;{if}


  New(PrintInfo);

  NoCopies := 1;
  PrintStatus := 0;
  Panel_Pages.Caption := '';
  PageF := 1;
  PageL := 1;

end;

procedure TFrmPrintPreview.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  WindowClose;
end;

Procedure TFrmPrintPreview.StartPreview;
Var
  Tmp : Integer;
Begin
{  case ProcessMode of
    pmFunction, pmBillSplit : btnProcess.Caption := '&Process';
    pmClearLog : btnProcess.Caption := '&Clear Log';
  end;{case}
  
//  btnProcess.Visible := ProcessMode in [pmFunction, pmClearLog{, pmBillSplit}];
  btnProcess.Visible := FALSE;

//  if ProcessMode = pmClearLog then btnProcess.Enabled
//  := oUsers.CurrentUserInfo.Details.usrSecurity[USEC_CLEAR_LOGS] = 1;

//  sepProcess.Visible := ProcessMode in [pmFunction, pmClearLog{, pmBillSplit}];
  sepProcess.Visible := FALSE;
  Toolbar.Transparent := not btnProcess.Visible;

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

procedure TFrmPrintPreview.FormKeyDown(Sender: TObject; var Key: Word;
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
  End; { With }
end;

procedure TFrmPrintPreview.Button_PrintClick(Sender: TObject);
Var
  PageSetupDlg : TPageSetupDlg;
  I : integer;
begin
  Screen.Cursor := crHourglass;
  PageSetupDlg := TPageSetupDlg.Create(Self);
  Try
    With PageSetupDlg Do Begin
      Copies := NoCopies;
      NoPages := FilePreview1.Pages;
      CurrPage := ScrollBar_Pages.Position;
    End; { With }

    Screen.Cursor := crDefault;

    If PageSetupDlg.Execute Then
      Begin
        Screen.Cursor := crHourglass;

        PageF := PageSetupDlg.FPage;
        PageL := PageSetupDlg.LPage;
        NoCopies := PageSetupDlg.Copies;

        If (NoCopies < 1) Then NoCopies := 1;
        If (NoCopies > 99) Then NoCopies := 99;
        For I := 1 To NoCopies Do FilePrinter1.ExecuteCustom(PageF, PageL, 1);
      End { If }
    Else Screen.Cursor := crHourglass;

  Finally
    PageSetupDlg.Free;
  End;
  Screen.Cursor := crDefault;
end;

procedure TFrmPrintPreview.InPrint(var Msg: TMessage);
var
  I       : SmallInt;
begin
  Screen.Cursor := crHourglass;

  with Msg do begin
    { Check the inprint flag }
    If (WParam = Ord(False)) Then
      Begin
        { Set inprint }

        Case PrintInfo^.fePrintMethod Of
          0 : Begin { Printer }
            { Print file }
            If (NoCopies < 1) Then NoCopies := 1;
            If (NoCopies > 99) Then NoCopies := 99;
            For I := 1 To NoCopies Do
              FilePrinter1.ExecuteCustom(PageF, PageL, 1);
          End; { Printer }
        End; { Case }
      End { If }
    Else MessageDlg ('Something else is already printing', mtInformation, [mbOk], 0);
  end;{with}

  PrintStatus := 0;
  Screen.Cursor := crDefault;
end;


{ Zoom in }
procedure TFrmPrintPreview.BitBtn_ZoomInClick(Sender: TObject);
begin
  FilePreview1.ZoomIn;
end;

{ Zoom Out }
procedure TFrmPrintPreview.BitBtn_ZoomOutClick(Sender: TObject);
begin
  FilePreview1.ZoomOut;
end;

{ Show Page }
procedure TFrmPrintPreview.BitBtn_ZoomPageClick(Sender: TObject);
begin
  FilePreview1.ZoomFactor := FilePreview1.ZoomPageFactor;
end;

{ Return to initial zoom size }
procedure TFrmPrintPreview.Popup_Preview_ZoomToNormalClick(
  Sender: TObject);
begin
  FilePreview1.ZoomFactor := 100;
end;

procedure TFrmPrintPreview.Popup_Preview_PrevPageClick(Sender: TObject);
Var
  NP : Integer;
begin
  NP := ScrollBar_Pages.Position - 1;
  If (NP >= ScrollBar_Pages.Min) And (NP <= ScrollBar_Pages.Max) Then Begin
    ScrollBar_PagesScroll(Sender, scPosition, NP);
    ScrollBar_Pages.Position := NP;
  End; { If }
End;

procedure TFrmPrintPreview.Popup_Preview_NextPageClick(Sender: TObject);
Var
  NP : Integer;
begin
  NP := ScrollBar_Pages.Position + 1;
  If (NP >= ScrollBar_Pages.Min) And (NP <= ScrollBar_Pages.Max) Then Begin
    ScrollBar_PagesScroll(Sender, scPosition, NP);
    ScrollBar_Pages.Position := NP;
  End; { If }
end;

Procedure TFrmPrintPreview.EnableButts(PageNo : SmallInt);
begin
  Popup_Preview_PrevPage.Enabled := (PageNo > ScrollBar_Pages.Min);
  Popup_Preview_NextPage.Enabled := (PageNo < ScrollBar_Pages.Max);
  spbtnPrevPage.Enabled := Popup_Preview_PrevPage.Enabled;
  spbtnNextPage.Enabled := Popup_Preview_NextPage.Enabled;
End;
    
procedure TFrmPrintPreview.Panel_ScrollBarResize(Sender: TObject);
begin
  ScrollBar_Pages.Height := Panel_ScrollBar.Height - 4;
end;

procedure TFrmPrintPreview.ScrollBar_PagesScroll(Sender: TObject;
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

procedure TFrmPrintPreview.Button_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPrintPreview.ScrollBar_PagesChange(Sender: TObject);
begin
  Panel_Pages.Caption := 'Page ' +
                          IntToStr(ScrollBar_Pages.Position) +
                          ' of ' +
                          IntToStr(ScrollBar_Pages.Max);
end;

procedure TFrmPrintPreview.FormDeactivate(Sender: TObject);
begin
  If (WindowState = wsMaximized) Then
    WindowState := wsNormal;
end;

procedure TFrmPrintPreview.Panel_PagesDblClick(Sender: TObject);
begin
  ShowMessage ('Report Printer ' + FilePrinter1.Version);
end;

procedure TFrmPrintPreview.SetCaption (Const JobName : ShortString);
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

Procedure TFrmPrintPreview.SetPrintInfo(Value : TSBSPrintSetupInfo);
Begin { SetPrintInfo }
  PrintInfo^ := Value;

  { Cannot print if faxing and not using the MAPI/Enterprise faxing }
  spbtnPrint.Visible :=  (Value.fePrintMethod <> 1) Or
                          ((Value.fePrintMethod = 1) And (Value.feFaxMethod In [0, 1]));
End; { SetPrintInfo }

procedure TFrmPrintPreview.FormDestroy(Sender: TObject);
begin
  WindowClose;
end;

procedure TFrmPrintPreview.WindowClose;
begin
  if not bAlreadyClosed then begin
    bAlreadyClosed := TRUE;
    Screen.Cursor := crHourglass;
    Try
      If FilePreview1.Printing Then
        FilePreview1.Finish;
    Except
      On Exception Do ;
    End;

    { Delete report file if necessary }
    DeletePrintFile(FilePreview1.FileName);

    { Deallocate form resources }
    Dispose(PrintInfo);
    Screen.Cursor := crDefault;
  end;{if}
end;


procedure TFrmPrintPreview.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 414;
    ptMinTrackSize.Y := 262;
  end;{with}
  Message.Result := 0;
  inherited;
end;


procedure DeletePrintFile(const PrintFile: String);
begin
  If FileExists(PrintFile) Then Begin
    Try
      DeleteFile(PrintFile);
    Except
      MessageDlg('Error:' + CHR(13) + CHR(13) + 'An error has occurred deleting the temporary file, '''
      + PrintFile + '''.', mtError, [mbOk], 0);
    End;{try}
  End; { If }
end;

end.





