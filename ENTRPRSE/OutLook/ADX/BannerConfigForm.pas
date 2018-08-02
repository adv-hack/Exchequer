unit BannerConfigForm;

{******************************************************************************}
{* The following change has been made to the TMS Components to draw a box     *}
{* around a flat TColumnComboBox:-                                            *}
{* In AdvCombo.pas, procedure TAdvCustomCombo.DrawControlBorder(DC: HDC);

    if FFlat and (FFlatLineColor <> clNone) then
    begin
      OldPen := SelectObject(DC,CreatePen( PS_SOLID,1,ColorToRGB(FFlatLineColor)));
      MovetoEx(DC,ARect.Left - 2,Height - 1,nil);
      LineTo(DC,ARect.Right - 18 ,Height - 1);
      LineTo(DC,ARect.Right - 18, 0);            // ***BJH***
      LineTo(DC, 0, 0);                          // ***BJH***
      LineTo(DC, 0, Height - 1);                 // ***BJH***
      DeleteObject(SelectObject(DC,OldPen));
    end;


{* The project must be compiled with TMSDISABLEOLE defined.
{* There appears to be a problem with the OLE subsystem not unloading which in
{* turn prevents the Outlook process from terminating even though the UI closes.
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvMenus,
  AdvMenuStylers, GradientLabel, AdvGlowButton, AdvSpin, htmlbtns, Mask,
  AdvOfficePager, AdvPanel, AdvOfficePagerStylers, AdvCombo, ColCombo,
  rtflabel, ComObj, ActiveX, KPICommon, Buttons, jpeg, psvDialogs, AdvEdit,
  AdvSelectors, ImgList, Menus;

type
  TfrmConfigureBanner = class(TForm)
    advPanel: TAdvPanel;
    ofConfig: TAdvOfficePager;
    ofpCustSupp: TAdvOfficePage;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    btnSave: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    gbSettings: TGroupBox;
    cbIRISOnTop: TCheckBox;
    cbAllowOverlap: TCheckBox;
    BannerPnl: TAdvPanel;
    IRISPnl: TPanel;
    LeftImg: TImage;
    BackImg: TImage;
    RightImg: TImage;
    AddPluginsLbl: TLabel;
    VersionLbl: TLabel;
    UserPnl: TPanel;
    ULeftImg: TImage;
    UBackImg: TImage;
    URightImg: TImage;
    gbImages: TGroupBox;
    Label1: TLabel;
    edtImage1: TAdvEdit;
    btnImage1: TAdvGlowButton;
    Label2: TLabel;
    edtImage2: TAdvEdit;
    btnImage2: TAdvGlowButton;
    Label3: TLabel;
    edtImage3: TAdvEdit;
    btnImage3: TAdvGlowButton;
    psvOpenDialog: TpsvOpenDialog;
    lblLeftChevron: TLabel;
    lblRightChevron: TLabel;
    cbStretch1: TCheckBox;
    cbStretch2: TCheckBox;
    cbStretch3: TCheckBox;
    cbAutoSize1: TCheckBox;
    cbAutoSize2: TCheckBox;
    cbAutoSize3: TCheckBox;
    csBackgroundColour: TAdvColorSelector;
    Label6: TLabel;
    cbTransparent1: TCheckBox;
    cbTransparent2: TCheckBox;
    cbTransparent3: TCheckBox;
    cbCenter1: TCheckBox;
    cbCenter2: TCheckBox;
    cbCenter3: TCheckBox;
    ImageList: TImageList;
    btnClearImage1: TAdvGlowButton;
    btnClearImage2: TAdvGlowButton;
    btnClearImage3: TAdvGlowButton;
    btnReloadImage1: TAdvGlowButton;
    btnReloadImage2: TAdvGlowButton;
    btnReloadImage3: TAdvGlowButton;
    PopupMenu: TPopupMenu;
    miStretch: TMenuItem;
    miAutoSize: TMenuItem;
    miTransparent: TMenuItem;
    miCenter: TMenuItem;
    Label4: TLabel;
    cbReplicate: TCheckBox;
    edtReplicateRightmostPixels: TAdvEdit;
    lblPixels: TLabel;
    Label5: TLabel;
    cbReplicateCenter: TCheckBox;
    cbReplicateRight: TCheckBox;
    Bevel1: TBevel;
    Label7: TLabel;
    procedure csBackgroundColourSelect(Sender: TObject; Index: Integer; Item: TAdvSelectorItem);
    procedure BannerPnlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BannerPnlMouseLeave(Sender: TObject);
    procedure BannerPnlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure BannerPnlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnClearImageClick(Sender: TObject);
    procedure btnImageClick(Sender: TObject);
    procedure btnReloadImageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveClick(Sender: TObject);
    procedure cbAllowOverlapClick(Sender: TObject);
    procedure cbAutoSizeClick(Sender: TObject);
    procedure cbCenterClick(Sender: TObject);
    procedure cbStretchClick(Sender: TObject);
    procedure cbTransparentClick(Sender: TObject);
    procedure cbIRISOnTopClick(Sender: TObject);
    procedure cbReplicateCenterClick(Sender: TObject);
    procedure cbReplicateClick(Sender: TObject);
    procedure cbReplicateRightClick(Sender: TObject);
    procedure edtImageChange(Sender: TObject);
    procedure edtReplicateRightmostPixelsExit(Sender: TObject);
    procedure edtReplicateRightmostPixelsKeyPress(Sender: TObject; var Key: Char);
    procedure MaxBtnClick(Sender: TObject);
    procedure miAutoSizeClick(Sender: TObject);
    procedure miCenterClick(Sender: TObject);
    procedure miStretchClick(Sender: TObject);
    procedure miTransparentClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure UBackImgContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure UBackImgDblClick(Sender: TObject);
    procedure ULeftImgContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure ULeftImgDblClick(Sender: TObject);
    procedure URightImgContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure URightImgDblClick(Sender: TObject);
  private
    FDragging:  boolean;
    FIsDirty:   boolean;
    FMaximized: boolean;
    FLefBtnDwn: boolean;
    FStartup:   boolean;
    procedure ChangeBackgroundColour;
    procedure IsDirty;
    procedure LoadSettings;
    procedure MakeRounded(Control: TWinControl);
    procedure SetHost(Value: HWND);
    procedure SaveSettings;
    procedure FillBanner(SourceImg, DestImg: TImage; WidthToCopy: integer);
    procedure FillUserBanner;
    procedure EnableDisableEtc;
  public
    destructor destroy; override;
    procedure Startup;
  published
  end;

implementation

uses CommCtrl, KPIIniFileClass, History;

{$R *.dfm}

destructor TfrmConfigureBanner.destroy;
begin
  inherited destroy;
end;

procedure TfrmConfigureBanner.csBackgroundColourSelect(Sender: TObject; Index: Integer; Item: TAdvSelectorItem);
begin
  ChangeBackgroundColour;
  IsDirty;
end;

procedure TfrmConfigureBanner.BannerPnlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FLefBtnDwn := true;
end;

procedure TfrmConfigureBanner.BannerPnlMouseLeave(Sender: TObject);
begin
  if not FDragging then screen.Cursor := crDefault;
end;

procedure TfrmConfigureBanner.FillBanner(SourceImg: TImage; DestImg: TImage; WidthToCopy: integer);
var
  Dest, Source: TRect;
begin
  DestImg.Picture.Graphic := nil; // was picture

  application.ProcessMessages;

  Source.Top := 0;
  Source.Left := SourceImg.Width - WidthToCopy;
  Source.Bottom := SourceImg.Height;
  Source.Right := WidthToCopy;

//  with Source do
//    ShowMessage(format('SOURCE: Top:%d, Left:%d, Bottom:%d, Right:%d', [Top, Left, Bottom, Right]));

  Dest.Top := 0;
  Dest.Bottom := DestImg.Height;

  DestImg.Canvas.CopyMode := cmSrcCopy;
  Dest.Left := 0;
  while Dest.Left < DestImg.Width  do begin
    Dest.Right := Dest.Left + WidthToCopy;
//    with Dest do
//      ShowMessage(format('DEST: Top:%d, Left:%d, Bottom:%d, Right:%d', [Top, Left, Bottom, Right]));
    DestImg.Canvas.CopyRect(Dest, SourceImg.Canvas, Source);
    Dest.Left := Dest.Left + WidthToCopy;
  end;
end;

procedure TfrmConfigureBanner.FillUserBanner;
begin
  if cbReplicate.Checked then begin
    if cbReplicateCenter.Checked then
      FillBanner(ULeftImg, UBackImg, edtReplicateRightmostPixels.IntValue);
    if cbReplicateRight.Checked then
      FillBanner(ULeftImg, URightImg, edtReplicateRightmostPixels.IntValue);
  end;
  BackImg.Invalidate;
  RightImg.Invalidate;
end;

procedure TfrmConfigureBanner.BannerPnlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  procedure WMResize;
  var
    XPos: Integer;
  begin
    XPos := (BannerPnl.Width div 2) - (AddPluginsLbl.Width div 2);
    AddPluginsLbl.Left := XPos;

    RightImg.Visible := true;  // otherwise next line doesn't make image RH visible again when dragging to the right
    RightImg.Visible := (RightImg.Left > LeftImg.Width);

    URightImg.Visible := true; // otherwise next line doesn't make image RH visible again when dragging to the right
    URightImg.Visible := (URightImg.Left > ULeftImg.Width) or cbAllowOverlap.Checked;

    XPos := (BannerPnl.Width div 2) - (VersionLbl.Width div 2);
    VersionLbl.Left := XPos;

    FillBanner(LeftImg, BackImg, 70); // this is dictated by the current IRIS bitmaps and might not be compulsory with future logos/bitmaps
    FillUserBanner;
  end;
begin
  FDragging := FLefBtnDwn; // and mouse moving

  if Y > IRISPnl.Height + UserPnl.Height then // the cursor's in the drag strip below the UserPnl
    screen.Cursor := crHandPoint
  else
  if not FDragging then // don't change the cursor while dragging, even if the mouse pointer strays out of the drag strip
    screen.Cursor := crDefault;

  if FDragging then begin
    BannerPnl.Width := x;
    WMResize;
  end;
end;

procedure TfrmConfigureBanner.BannerPnlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FLefBtnDwn := false;
  FDragging  := false;
end;

procedure TfrmConfigureBanner.btnClearImageClick(Sender: TObject);
var
  TargetEditBox: TAdvEdit;
  TargetImage: TImage;
begin
  TargetEditBox := TAdvEdit(TComponent(Sender).Tag);
  TargetImage   := TImage(TargetEditBox.Tag);
  TargetImage.Picture.Graphic := nil;
  IsDirty;
end;

procedure TfrmConfigureBanner.btnImageClick(Sender: TObject);
var
  TargetEditBox: TAdvEdit;
  TargetImage: TImage;
begin
  TargetEditBox := TAdvEdit(TComponent(Sender).Tag);
  TargetImage   := TImage(TargetEditBox.Tag);
  if psvOpenDialog.Execute then begin
    TargetEditBox.Text := psvOpenDialog.FileName;
    TargetImage.Picture.LoadFromFile(psvOpenDialog.FileName);
    IsDirty;
    FillUserBanner;
  end;
end;

procedure TfrmConfigureBanner.btnReloadImageClick(Sender: TObject);
var
  TargetEditBox: TAdvEdit;
  TargetImage: TImage;
begin
  TargetEditBox := TAdvEdit(TComponent(Sender).Tag);
  TargetImage   := TImage(TargetEditBox.Tag);
  TargetImage.Picture.Graphic := nil; // whatever happens next we don't want the current image displayed
  if FileExists(TargetEditBox.Text) then
    TargetImage.Picture.LoadFromFile(TargetEditBox.Text);
  IsDirty;
  FillUserBanner;
end;

procedure TfrmConfigureBanner.FormCreate(Sender: TObject);
  procedure SetupObjectPointers;
  begin
    cbStretch1.Tag     := integer(ULeftImg);
    cbAutoSize1.Tag    := integer(ULeftImg);
    cbTransparent1.Tag := integer(ULeftImg);
    cbCenter1.Tag      := integer(ULeftImg);
    edtImage1.Tag      := integer(ULeftImg);

    cbStretch2.Tag     := integer(UBackImg);
    cbAutoSize2.Tag    := integer(UBackImg);
    cbTransparent2.Tag := integer(UBackImg);
    cbCenter2.Tag      := integer(UBackImg);
    edtImage2.Tag      := integer(UBackImg);

    cbStretch3.Tag     := integer(URightImg);
    cbAutoSize3.Tag    := integer(URightImg);
    cbTransparent3.Tag := integer(URightImg);
    cbCenter3.Tag      := integer(URightImg);
    edtImage3.Tag      := integer(URightImg);

    btnImage1.Tag      := integer(edtImage1);
    btnImage2.Tag      := integer(edtImage2);
    btnImage3.Tag      := integer(edtImage3);

    btnClearImage1.Tag := integer(edtImage1);
    btnClearImage2.Tag := integer(edtImage2);
    btnClearImage3.Tag := integer(edtImage3);

    btnReloadImage1.Tag := integer(edtImage1);
    btnReloadImage2.Tag := integer(edtImage2);
    btnReloadImage3.Tag := integer(edtImage3);
  end;

  procedure DefaultImageSettings;
    procedure SetImage(AnImage: TImage);
    begin
      AnImage.Stretch     := false;
      AnImage.AutoSize    := false;
      AnImage.Transparent := false;
      AnImage.Center      := false;
    end;
  begin
    SetImage(ULeftImg); SetImage(UBackImg); SetImage(URightImg);
  end;
begin
  VersionLbl.Caption := 'Outlook Dynamic Dashboard, ' + KPIVer;
  VersionLbl.Left    := (BannerPnl.Width div 2) - (VersionLbl.Width div 2);
  // Centre - can't use poScreenCentre because of Host property not working
  Self.Top := (Screen.Height - - Self.Height) Div 2;
  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);

  SetupObjectPointers;
  DefaultImageSettings;

  ULeftImg.Tag  := ULeftImg.Width;  // remember the default width
  URightImg.Tag := URightImg.Width;

  btnCancel.Caption := '&Close';
  edtReplicateRightmostPixels.IntValue := 1;
  csBackgroundColour.Tools.Delete(csBackgroundColour.Tools.Count - 1);

  Startup;
end;

Procedure TfrmConfigureBanner.SetHost (Value : HWND);
Var
  lpRect: TRect;
Begin // SetHost
  If (Value <> 0) Then
  Begin
    // Get the host window position and centre the login dialog over it
    If GetWindowRect(Value, lpRect) Then
    Begin
      // Top = Top of Host + (0.5 * Host Height) - (0.5 * Self Height)
      Self.Top := lpRect.Top + ((lpRect.Bottom - lpRect.Top - Self.Height) Div 2);

      // Left = Left of Host + (0.5 * Host Width) - (0.5 * Self Width)
      Self.Left := lpRect.Left + ((lpRect.Right - lpRect.Left - Self.Width) Div 2);

      // Make sure it is still fully on the screen
      If (Self.Top < 0) Then Self.Top := 0;
      If ((Self.Top + Self.Height) > Screen.Height) Then Self.Top := Screen.Height - Self.Height;
      If (Self.Left < 0) Then Self.Left := 0;
      If ((Self.Left + Self.Width) > Screen.Width) Then Self.Left := Screen.Width - Self.Width;
    End; // If GetWindowRect(Value, lpRect)
  End; // If (Value <> 0)
End; // SetHost

procedure TfrmConfigureBanner.Startup;
begin
  FStartup := true;
  LoadSettings;
  FillUserBanner;
  EnableDisableEtc;
  FStartup := false;
end;

procedure TfrmConfigureBanner.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmConfigureBanner.FormActivate(Sender: TObject);
begin
  ofpCustSupp.SetFocus;
  FillUserBanner; // do this now because UBackImg.Align = alClient and therefore only now is UBackImg.Width <> 0;
end;

procedure TfrmConfigureBanner.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmConfigureBanner.MakeRounded(Control: TWinControl);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Control do
  begin
    R := ClientRect;
    rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20);
    Perform(EM_GETRECT, 0, lParam(@r));
    InflateRect(r, -5, -5);
    Perform(EM_SETRECTNP, 0, lParam(@r));
    SetWindowRgn(Handle, rgn, True);
    Invalidate;
  end;
end;

procedure TfrmConfigureBanner.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfrmConfigureBanner.btnSaveClick(Sender: TObject);
begin
  SaveSettings;
  btnSave.Enabled   := false;
  btnCancel.Caption := '&Close';
end;

procedure TfrmConfigureBanner.cbAllowOverlapClick(Sender: TObject);
begin
  IsDirty;
end;

procedure TfrmConfigureBanner.cbAutoSizeClick(Sender: TObject);
var
  TargetImage: TImage;
begin
  TargetImage := TImage(TComponent(Sender).Tag);
  TargetImage.AutoSize := TCheckBox(Sender).Checked;
  TargetImage.Width    := TargetImage.Tag; // reset to the default width
  IsDirty;
end;

procedure TfrmConfigureBanner.cbCenterClick(Sender: TObject);
var
  TargetImage: TImage;
begin
  TargetImage := TImage(TComponent(Sender).Tag);
  TargetImage.Center := TCheckBox(Sender).Checked;
  IsDirty;
end;

procedure TfrmConfigureBanner.cbStretchClick(Sender: TObject);
var
  TargetImage: TImage;
begin
  TargetImage := TImage(TComponent(Sender).Tag);
  TargetImage.Stretch := TCheckBox(Sender).Checked;
  IsDirty;
end;

procedure TfrmConfigureBanner.cbTransparentClick(Sender: TObject);
var
  TargetImage: TImage;
begin
  TargetImage := TImage(TComponent(Sender).Tag);
  TargetImage.Transparent := TCheckBox(Sender).Checked;
  IsDirty;
end;

procedure TfrmConfigureBanner.ChangeBackgroundColour;
begin
   UserPnl.Color := csBackgroundColour.SelectedColor;
end;

procedure TfrmConfigureBanner.cbIRISOnTopClick(Sender: TObject);
begin
  IRISPnl.Align := alNone;
  UserPnl.Align := alNone;
  IRISPnl.Top   := 100;
  UserPnl.Top   := 100;
  if cbIRISOnTop.Checked then begin
    IRISPnl.Align := alTop;
    UserPnl.Align := alTop;
  end
  else begin
    UserPnl.Align := alTop;
    IRISPnl.Align := alTop;
  end;
  IsDirty;
end;

procedure TfrmConfigureBanner.cbReplicateCenterClick(Sender: TObject);
begin
  if not FStartup then begin
    UBackImg.Picture.Graphic := nil; // was picture
    UBackImg.Invalidate;
    if cbReplicateCenter.Checked then begin
      cbReplicate.Checked := true;
      FillUserBanner;
    end;
    IsDirty;
  end;
end;

procedure TfrmConfigureBanner.cbReplicateClick(Sender: TObject);
begin
  if not FStartup then begin
    if cbReplicateCenter.Checked then begin
      UBackImg.Picture.Graphic := nil; // was picture
      UBackImg.Invalidate;
    end;

    if cbReplicateRight.Checked then begin
      URightImg.Picture.Graphic := nil; // was picture
      URightImg.Invalidate;
    end;
    FillUserBanner;
    IsDirty;
  end;
end;

procedure TfrmConfigureBanner.cbReplicateRightClick(Sender: TObject);
begin
  if not FStartup then begin
    URightImg.Picture.Graphic := nil; // was picture
    URightImg.Invalidate;
    if cbReplicateRight.Checked then begin
      cbReplicate.Checked := true;
      FillUserBanner;
    end;
    IsDirty;
  end;
end;

procedure TfrmConfigureBanner.edtImageChange(Sender: TObject);
begin
  if FileExists(TAdvEdit(Sender).Text) then IsDirty;
end;

procedure TfrmConfigureBanner.edtReplicateRightmostPixelsExit(Sender: TObject);
begin
  FillUserBanner;
end;

procedure TfrmConfigureBanner.edtReplicateRightmostPixelsKeyPress(Sender: TObject; var Key: Char);
begin
  IsDirty;
end;

procedure TfrmConfigureBanner.LoadSettings;
begin
  with TKPIIniFile.Create do begin
    try
      cbIRISOnTop.Checked              := IRISBannerOnTop;
      cbAllowOverlap.Checked           := AllowOverlap;
      csBackgroundColour.SelectedColor := BackgroundColor;
      UserPnl.Color                    := BackgroundColor;

      edtImage1.Text         := ImageFileName[1];
      cbStretch1.Checked     := ImageStretch[1];
      cbAutoSize1.Checked    := ImageAutoSize[1];
      cbTransparent1.Checked := ImageTransparent[1];
      cbCenter1.Checked      := ImageCenter[1];
      if ShowImage[1] then
        btnReloadImageClick(btnReloadImage1);

      edtImage2.Text         := ImageFileName[2];
      cbStretch2.Checked     := ImageStretch[2];
      cbAutoSize2.Checked    := ImageAutoSize[2];
      cbTransparent2.Checked := ImageTransparent[2];
      cbCenter2.Checked      := ImageCenter[2];
      if ShowImage[2] then
        btnReloadImageClick(btnReloadImage2);

      edtImage3.Text         := ImageFileName[3];
      cbStretch3.Checked     := ImageStretch[3];
      cbAutoSize3.Checked    := ImageAutoSize[3];
      cbTransparent3.Checked := ImageTransparent[3];
      cbCenter3.Checked      := ImageCenter[3];
      if ShowImage[3] then
        btnReloadImageClick(btnReloadImage3);

      cbReplicate.Checked            := ReplicateLeft;
      cbReplicateCenter.Checked      := ReplicateLeftIntoCenter;
      cbReplicateRight.Checked       := ReplicateLeftIntoRight;
      edtReplicateRightmostPixels.IntValue := ReplicateRightmostPixels;
    finally
      Free;
    end;
  end;
end;

procedure TfrmConfigureBanner.SaveSettings;
begin
  with TKPIIniFile.Create do begin
    try
      ShowCustomBanner := (ULeftImg.Picture.Graphic <> nil) or (UBackImg.Picture.Graphic <> nil) or (URightImg.Picture.Graphic <> nil);
      IRISBannerOnTop  := cbIRISOnTop.Checked;
      AllowOverlap     := cbAllowOverlap.Checked;
      BackgroundColor  := csBackgroundColour.SelectedColor;

      ShowImage[1]        := (ULeftImg.Picture.Graphic <> nil);
      ImageFileName[1]    := edtImage1.Text;
      ImageStretch[1]     := cbStretch1.Checked;
      ImageAutoSize[1]    := cbAutoSize1.Checked;
      ImageTransparent[1] := cbTransparent1.Checked;
      ImageCenter[1]      := cbCenter1.Checked;

      ShowImage[2]        := (UBackImg.Picture.Graphic <> nil) and not (cbReplicate.Checked and cbReplicateCenter.Checked);
      ImageFileName[2]    := edtImage2.Text;
      ImageStretch[2]     := cbStretch2.Checked;
      ImageAutoSize[2]    := cbAutoSize2.Checked;
      ImageTransparent[2] := cbTransparent2.Checked;
      ImageCenter[2]      := cbCenter2.Checked;

      ShowImage[3]        := (URightImg.Picture.Graphic <> nil) and not (cbReplicate.Checked and cbReplicateRight.Checked);
      ImageFileName[3]    := edtImage3.Text;
      ImageStretch[3]     := cbStretch3.Checked;
      ImageAutoSize[3]    := cbAutoSize3.Checked;
      ImageTransparent[3] := cbTransparent3.Checked;
      ImageCenter[3]      := cbCenter3.Checked;

      ReplicateLeft            := cbReplicate.Checked;
      ReplicateLeftIntoCenter  := cbReplicateCenter.Checked;
      ReplicateLeftIntoRight   := cbReplicateRight.Checked;
      ReplicateRightmostPixels := edtReplicateRightmostPixels.IntValue;

      UpdateFile;
    finally
      Free;
    end;
  end;
end;

procedure TfrmConfigureBanner.MaxBtnClick(Sender: TObject);
begin
  FMaximized := not FMaximized;

  if FMaximized then begin
    ShowWindow(self.Handle, SW_SHOWMAXIMIZED);
  end
  else begin
    ShowWindow(self.Handle, SW_RESTORE);
  end;
end;

procedure TfrmConfigureBanner.miAutoSizeClick(Sender: TObject);
begin
  case PopupMenu.Tag of
    1: cbAutoSize1.Checked := miAutoSize.Checked;
    2: cbAutoSize2.Checked := miAutoSize.Checked;
    3: cbAutoSize3.Checked := miAutoSize.Checked;
  end;
end;

procedure TfrmConfigureBanner.miCenterClick(Sender: TObject);
begin
  case PopupMenu.Tag of
    1: cbCenter1.Checked := miCenter.Checked;
    2: cbCenter2.Checked := miCenter.Checked;
    3: cbCenter3.Checked := miCenter.Checked;
  end;
end;

procedure TfrmConfigureBanner.miStretchClick(Sender: TObject);
begin
  case PopupMenu.Tag of
    1: cbStretch1.Checked := miStretch.Checked;
    2: cbStretch2.Checked := miStretch.Checked;
    3: cbStretch3.Checked := miStretch.Checked;
  end;
end;

procedure TfrmConfigureBanner.miTransparentClick(Sender: TObject);
begin
  case PopupMenu.Tag of
    1: cbTransparent1.Checked := miTransparent.Checked;
    2: cbTransparent2.Checked := miTransparent.Checked;
    3: cbTransparent3.Checked := miTransparent.Checked;
  end;
end;

procedure TfrmConfigureBanner.PopupMenuPopup(Sender: TObject);
begin
  case PopupMenu.Tag of
    1: begin
         miStretch.Checked     := cbStretch1.Checked;
         miAutoSize.Checked    := cbAutoSize1.Checked;
         miTransparent.Checked := cbTransparent1.Checked;
         miCenter.Checked      := cbCenter1.Checked;
       end;
    2: begin
         miStretch.Checked     := cbStretch2.Checked;
         miAutoSize.Checked    := cbAutoSize2.Checked;
         miTransparent.Checked := cbTransparent2.Checked;
         miCenter.Checked      := cbCenter2.Checked;
       end;
    3: begin
         miStretch.Checked     := cbStretch3.Checked;
         miAutoSize.Checked    := cbAutoSize3.Checked;
         miTransparent.Checked := cbTransparent3.Checked;
         miCenter.Checked      := cbCenter3.Checked;
       end;
  end;
end;

procedure TfrmConfigureBanner.UBackImgContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  PopupMenu.Tag := 2;
end;

procedure TfrmConfigureBanner.UBackImgDblClick(Sender: TObject);
begin
  if psvOpenDialog.Execute then begin
    edtImage2.Text := psvOpenDialog.FileName;
    UBackImg.Picture.LoadFromFile(psvOpenDialog.FileName);
  end;
end;

procedure TfrmConfigureBanner.ULeftImgContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  PopupMenu.Tag := 1;
end;

procedure TfrmConfigureBanner.ULeftImgDblClick(Sender: TObject);
begin
  if psvOpenDialog.Execute then begin
    edtImage1.Text := psvOpenDialog.FileName;
    ULeftImg.Picture.LoadFromFile(psvOpenDialog.FileName);
  end;
end;

procedure TfrmConfigureBanner.URightImgContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  PopupMenu.Tag := 3;
end;

procedure TfrmConfigureBanner.URightImgDblClick(Sender: TObject);
begin
  if psvOpenDialog.Execute then begin
    edtImage3.Text := psvOpenDialog.FileName;
    URightImg.Picture.LoadFromFile(psvOpenDialog.FileName);
  end;
end;

procedure TfrmConfigureBanner.EnableDisableEtc;
  function SuitableImage: boolean;
  begin;
    result := (ULeftImg.Picture.Graphic <> nil) and (LowerCase(ExtractFileExt(edtImage1.Text)) = '.bmp') and not cbStretch1.Checked;
  end;
begin
  cbReplicate.Enabled                 := SuitableImage;
  cbReplicateCenter.Enabled           := SuitableImage;
  cbReplicateRight.Enabled            := SuitableImage;
  edtReplicateRightmostPixels.Enabled := SuitableImage;
  if not SuitableImage then cbReplicate.Checked := false; // not the same as cbReplicate.Checked := SuitableImage as this would set replication on
end;

procedure TfrmConfigureBanner.IsDirty;
begin
  if not FStartup then begin
    FIsDirty := true;
    btnSave.Enabled := true;
    btnCancel.Caption := '&Cancel';
    EnableDisableEtc;
  end;
end;

initialization

finalization

end.
