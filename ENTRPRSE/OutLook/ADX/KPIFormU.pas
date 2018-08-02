unit KPIFormU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Outlook2000, adxolFormsManager, StdCtrls, KPIHostControlU, ExtCtrls,
  ComCtrls, Menus, AdvGlowButton,
  Enterprise01_TLB, CTKUtil;

type
  TKPIForm = class(TadxOlForm)
    ProgressPnl: TPanel;
    DebugPnl: TPanel;
    ShutDownBtn: TButton;
    ResetBtn: TButton;
    LogPnl: TPanel;
    Log: TListBox;
    LogBtn: TButton;
    IRISPnl: TPanel;
    PopupMenu: TPopupMenu;
    AddColumnMenuItem: TMenuItem;
    RemoveColumnMenuItem: TMenuItem;
    N1: TMenuItem;
    Cancel1: TMenuItem;
    N2: TMenuItem;
    BordersMenuItem: TMenuItem;
    AddPluginsLbl: TLabel;
    LeftImg: TImage;
    RightImg: TImage;
    VersionLbl: TLabel;
    ConfigurePopupMenu: TPopupMenu;
    miConfigureBanner: TMenuItem;
    UserPnl: TPanel;
    ULeftImg: TImage;
    UBackImg: TImage;
    URightImg: TImage;
    procedure adxOlFormCreate(Sender: TObject);
    procedure adxOlFormDestroy(Sender: TObject);
    procedure ShutDownBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure LogBtnClick(Sender: TObject);
    procedure WMResize(var Msg: TWMSize); message WM_SIZE;
    procedure PopupMenuPopup(Sender: TObject);
    procedure AddColumnMenuItemClick(Sender: TObject);
    procedure RemoveColumnMenuItemClick(Sender: TObject);
    procedure BordersMenuItemClick(Sender: TObject);
    procedure AddPluginsLblClick(Sender: TObject);
    procedure adxOlFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure miConfigureBannerClick(Sender: TObject);
    procedure VersionLblDblClick(Sender: TObject); // v.005 BJH
  private
    { Private declarations }
    FHost: TKPIHostControl;
    FInitialised: Boolean;
    FLicensed: Boolean;

    {Custom banner settings from KPI.INI}
    FShowCustomBanner: boolean;
    FIRISBannerOnTop:  boolean;
    FAllowOverlap:     boolean;
    FShowRightImage:   boolean;
    FReplicateLeft:    boolean;
    FReplicateLeftIntoCenter: boolean;
    FReplicateLeftIntoRight:  boolean;
    FReplicateRightmostPixels: integer;

    procedure DoCustomBanner;
    { Adds the supplied message to the log file. Only used for debugging. }
    procedure OnLog(Msg: string);

    { This method is assigned to the KPI Manager's OnReset property, and is
      called whenever the KPI Manager is reset.

      If no plug-ins are installed, it displays a message for the user.

      NOTE: At the moment, this does not work -- the message is never
            visible. }
    procedure OnReset(Sender: TObject);

    { The IRIS banner at the top of the page actually consists of three
      images -- the IRIS image on the left, the 'flower' image on the right,
      and a 'fill-in' image in-between. The FillBanner method tiles the fill-in
      image from a clipped portion of the other images, to create a seamless
      banner. }
    procedure FillBanner(SourceImg: TImage; DestImg: TImage; WidthToCopy: integer);
    procedure ResizeIRISBanner;
    procedure ResizeUserBanner;

  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

{NOTE: The adxOlForm1 variable is intended for the exclusive use
       by the TadxOlFormsCollectionItem Designer.
       NEVER use this variable for other purposes.}
var
  KPIForm : TKPIForm;

implementation

{$R *.DFM}

uses
  ActiveX,
  KPISelectPluginsDlgU,
  KPIAvailablePluginsU,
  KPIManagerU,
  EntLicence,
  History,
  BannerConfigForm,
  KPIIniFileClass;

// =============================================================================
// TKPIForm
// =============================================================================
procedure TKPIForm.AddColumnMenuItemClick(Sender: TObject);
begin
  KPIManager.IncrementAreas(self);
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.adxOlFormCreate(Sender: TObject);
begin
  VersionLbl.Caption := 'Outlook Dynamic Dashboard, ' + KPIVer;
  FLicensed := (EnterpriseLicence.elModules[modOutlookDD] > mrNone);
  FInitialised := False;
  if FLicensed then
  begin
    FHost := TKPIHostControl.Create(self);
    FHost.Parent := self;
    FHost.BorderStyle := bsSingle;
    FHost.HostType := htWebPage;
    FHost.Visible := True;
    FHost.PopupMenu := PopupMenu;
    KPIManager.OnLog := OnLog;
    KPIManager.OnReset := OnReset;
  end
  else
  begin
    ProgressPnl.Font.Color := clRed;
    ProgressPnl.Caption := 'Licence expired';
    AddPluginsLbl.Visible := False;
  end;

  DoCustomBanner;

{$IFNDEF KPI_DEBUG}
  DebugPnl.Visible := False;
{$ENDIF}
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.adxOlFormDestroy(Sender: TObject);
begin
  if FLicensed then
  begin
    FHost.Free;
    FHost := nil;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.BordersMenuItemClick(Sender: TObject);
begin
  with (Sender as TMenuItem) do
    KPIManager.ShowBorders(Checked);
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.LogBtnClick(Sender: TObject);
begin
  LogPnl.Visible := not LogPnl.Visible;
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.OnLog(Msg: string);
begin
  Log.Items.Add(Msg);
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.OnReset(Sender: TObject);
begin
  ProgressPnl.Visible := False;
  if FLicensed and not FInitialised then
  begin
    FInitialised := True;
    if KPIManager.ActivePlugins.Count = 0 then
    begin
      ProgressPnl.Caption := 'Click the Add Controls button to add controls to this page';
      ProgressPnl.BringToFront;
      ProgressPnl.Visible := True;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.PopupMenuPopup(Sender: TObject);
begin
  AddColumnMenuItem.Enabled    := KPIManager.ActiveAreas.Count < 3;
  RemoveColumnMenuItem.Enabled := KPIManager.ActiveAreas.Count > 1;
  BordersMenuItem.Checked      := KPIManager.LayoutManager.ShowBorders;
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.RemoveColumnMenuItemClick(Sender: TObject);
begin
  KPIManager.DecrementAreas(self);
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.ResetBtnClick(Sender: TObject);
begin
  if FLicensed then
    KPIManager.Reset;
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.ShutDownBtnClick(Sender: TObject);
begin
  if FLicensed then
    ShutDownKPIManager;
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.ResizeIRISBanner;
var
  Margin: Integer;
  XPos: Integer;
begin
  if Assigned(AddPluginsLbl) then begin
    XPos := (ClientWidth div 2) - (AddPluginsLbl.Width div 2); // ORIGINAL LINE
    AddPluginsLbl.Left := XPos;

    Margin := GetSystemMetrics(SM_CXVSCROLL);
    RightImg.Left := ClientWidth - (RightImg.Width + Margin); // RightImg.Align := alRight !
    RightImg.Visible := true; // otherwise next line doesn't make RH image visible again when window wide after being narrow
    RightImg.Visible := (RightImg.Left > LeftImg.Width);

    XPos := (ClientWidth div 2) - (VersionLbl.Width div 2);
    VersionLbl.Left := XPos;
//    FillBanner(LeftImg, BackImg, 70);
  end;

//  if Assigned(BackImg) and Assigned(LeftImg) then
//  begin
//    BackImg.Width := ClientWidth - (LeftImg.Width + RightImg.Width);
//  end; // BackImg.Align := alClient !
end;

procedure TKPIForm.ResizeUserBanner;
begin
  if not FShowCustomBanner then EXIT;

  if FReplicateLeft and FReplicateLeftIntoCenter then FillBanner(ULeftImg, UBackImg, FReplicateRightmostPixels);
  if FReplicateLeft and FReplicateLeftIntoRight  then FillBanner(ULeftImg, URightImg, FReplicateRightmostPixels);

  if FShowRightImage then begin
    URightImg.Visible := true; // otherwise next line doesn't make RH image visible again when window widened after being narrow
    URightImg.Visible := (URightImg.Left > ULeftImg.Width) or FAllowOverlap;
  end;
end;

procedure TKPIForm.DoCustomBanner;
  procedure ReadIniFile;
  begin                                                                                        
    with TKPIIniFile.Create do begin
      try
        FShowCustomBanner         := ShowCustomBanner;
        FIRISBannerOnTop          := IRISBannerOnTop;
        FAllowOverlap             := AllowOverlap;
        FReplicateLeft            := ReplicateLeft;
        FReplicateLeftIntoCenter  := ReplicateLeftIntoCenter;
        FReplicateLeftIntoRight   := ReplicateLeftIntoRight;
        FReplicateRightmostPixels := ReplicateRightmostPixels;

        UserPnl.Color         := BackgroundColor;

        ULeftImg.Stretch     := ImageStretch[1];
        ULeftImg.AutoSize    := ImageAutoSize[1];
        ULeftImg.Transparent := ImageTransparent[1];
        ULeftImg.Center      := ImageCenter[1];

        UBackImg.Stretch     := ImageStretch[2];
        UBackImg.AutoSize    := ImageAutoSize[2];
        UBackImg.Transparent := ImageTransparent[2];
        UBackImg.Center      := ImageCenter[2];

        URightImg.Stretch     := ImageStretch[3];
        URightImg.AutoSize    := ImageAutoSize[3];
        URightImg.Transparent := ImageTransparent[3];
        URightImg.Center      := ImageCenter[3];

        if ShowImage[1] then ULeftImg.Picture.LoadFromFile(ImageFileName[1]);
        if ShowImage[2] then UBackImg.Picture.LoadFromFile(ImageFileName[2]);
        if ShowImage[3] then URightImg.Picture.LoadFromFile(ImageFileName[3]);

        FShowRightImage := ShowImage[3];

        ResizeUserBanner;
      finally
        Free;
      end;
    end;
  end;
begin
  ULeftImg.Picture.Graphic := nil; // force refresh after configuration window closed
  UBackImg.Picture.Graphic := nil;
  URightImg.Picture.Graphic := nil;
  ULeftImg.Invalidate; UBackImg.Invalidate; URightImg.Invalidate;

  ReadIniFile;

  UserPnl.Visible := FShowCustomBanner;
  if not FShowCustomBanner then EXIT;

  if not FIRISBannerOnTop then begin
    IRISPnl.Align := alNone;
    UserPnl.Align := alNone;
    IRISPnl.Top   := 100;
    UserPnl.Top   := 100;
    UserPnl.Align := alTop;
    IRISPnl.Align := alTop;
  end
  else
  begin
    IRISPnl.Align := alNone;
    UserPnl.Align := alNone;
    IRISPnl.Top   := 100;
    UserPnl.Top   := 100;
    IRISPnl.Align := alTop;
    UserPnl.Align := alTop;
  end;
end;

procedure TKPIForm.WMResize(var Msg: TWMSize);
begin
  inherited;
  ResizeIRISBanner;
  ResizeUserBanner;
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.AddPluginsLblClick(Sender: TObject);
var
  Dlg: TKPISelectPluginsDlg;
  i: Integer;
begin
  Dlg := TKPISelectPluginsDlg.Create(nil);
  try
    Dlg.ShowModal;
    if (Dlg.ModalResult = mrOk) then
    begin
      for i := 0 to Dlg.SelectedPlugins.Count - 1 do
        KPIManager.InstallPlugin(TKPIPluginInfo(Dlg.SelectedPlugins[i]));
      KPIManager.SaveConfiguration;
      if KPIManager.ActivePlugins.Count > 0 then
        ProgressPnl.Visible := False;
      KPIManager.RedrawLayout;
    end;
  finally
    Dlg.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPIForm.FillBanner(SourceImg: TImage; DestImg: TImage; WidthToCopy: integer);
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

{procedure TKPIForm.FillBanner;
var
  DestX, SrcX: Integer;
  WidthToCopy: Integer;
  Dest, Source: TRect;
begin
  WidthToCopy := 10;

  Source.Top := 0;
  Source.Left := LeftImg.Width - WidthToCopy - 1; // which column of pixels to be copied, in this case the rightmost WidthToCopy pixels.
  Source.Bottom := LeftImg.Height;
  Source.Right := WidthToCopy - 1;

//  with Source do
//    ShowMessage(format('SOURCE: Top:%d, Left:%d, Bottom:%d, Right:%d', [Top, Left, Bottom, Right]));

  Dest.Top := 0;
  Dest.Bottom := BackImg.Height;

  BackImg.Canvas.CopyMode := cmSrcCopy;
  Dest.Left := 0;
  while Dest.Left < BackImg.Width do begin
    Dest.Right := Dest.Left + WidthToCopy - 1;
//    with Dest do
//      ShowMessage(format('DEST: Top:%d, Left:%d, Bottom:%d, Right:%d', [Top, Left, Bottom, Right]));
    BackImg.Canvas.CopyRect(Dest, LeftImg.Canvas, Source);
    Dest.Left := Dest.Left + WidthToCopy - 1;
  end;
end;}

// -----------------------------------------------------------------------------

procedure TKPIForm.adxOlFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F5) and FLicensed then
    KPIManager.Reset;
end;

procedure TKPIForm.miConfigureBannerClick(Sender: TObject);
begin
  with TfrmConfigureBanner.Create(nil) do begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
  DoCustomBanner;
end;

procedure TKPIForm.VersionLblDblClick(Sender: TObject); // v.005 BJH
var
  KPIHostPath: array[0..MAX_PATH] of char;
  Toolkit: IToolkit;
  EntDir: string;
begin
  if pos(KPIVer, VersionLbl.Caption) = 1 then                    // v.008
    VersionLbl.Caption := 'Outlook Dynamic Dashboard, ' + KPIVer // v.008
  else begin
    GetModuleFileName(hInstance, KPIHostPath, SizeOf(KPIHostPath));
    Toolkit := CreateToolkitWithBackdoor;
    EntDir  := Toolkit.Configuration.EnterpriseDirectory;
    Toolkit := nil;
    VersionLbl.Caption := KPIVer + ', ' + KPIHostPath + ', ' + EntDir;
  end;
  VersionLbl.Left    := (IRISPnl.Width - VersionLbl.Width) div 2;
end;

// -----------------------------------------------------------------------------

// =============================================================================

initialization
  RegisterClass(TPersistentClass(TKPIForm));

// -----------------------------------------------------------------------------

finalization

// -----------------------------------------------------------------------------

end.
