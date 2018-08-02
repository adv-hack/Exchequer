unit MainF;

{ nfrewer440 16:26 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Menus, ImgList
  , ComCtrls, ToolWin, StdCtrls, Gauges, ExtCtrls, SBSPanel, Buttons, Inifiles, TEditVal, BtSupU1
  , Login, StdActns, ActnList, JPEG, BTSupU2, GlobType, LayList, TXRep, LicRec,
  AdvToolBar, AdvGlowButton, AdvToolBarStylers, Tilebmp, WallPaper;

type
  PHWND = ^HWND;

  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    Menu_File: TMenuItem;
    Menu_File_Exit: TMenuItem;
    Menu_Window: TMenuItem;
    Menu_Window_Cascade: TMenuItem;
    Menu_Window_Tile: TMenuItem;
    Menu_Window_ArrangeAll: TMenuItem;
    Menu_Window_MinimizeAll: TMenuItem;
    Menu_Help: TMenuItem;
    Menu_Help_HideBkg: TMenuItem;
    Menu_Help_SepBar2: TMenuItem;
    Menu_Help_Contents: TMenuItem;
    Menu_Help_About: TMenuItem;
    ToolbarImages: TImageList;
    CloseAll1: TMenuItem;
    ImageList1: TImageList;
    ActionList1: TActionList;
    WindowArrange1: TWindowArrange;
    WindowCascade1: TWindowCascade;
    WindowClose1: TWindowClose;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    TileVertically1: TMenuItem;
    SearchforHelpon1: TMenuItem;
    HowtoUseHelp1: TMenuItem;
    N10: TMenuItem;
    BackgroundImage: TImage;
    panStatus: TPanel;
    StatusPanel: TPanel;
    lStatusText: TLabel;
    Utilities1: TMenuItem;
    SystemSetup1: TMenuItem;
    Reports1: TMenuItem;
    EndOfDayReport1: TMenuItem;
    EditTillList1: TMenuItem;
    pmReports: TPopupMenu;
    EndOfDayReport2: TMenuItem;
    LayawayList1: TMenuItem;
    ransactionsPrintout1: TMenuItem;
    Printouttransactions1: TMenuItem;
    AdvStyler: TAdvToolBarOfficeStyler;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    tbReports: TAdvGlowButton;
    Btn_Layaway: TAdvGlowButton;
    Btn_TillList: TAdvGlowButton;
    tbSysSetup: TAdvGlowButton;
    Btn_Close: TAdvGlowButton;
    TileBackground: TTileBmp;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Menu_File_ExitClick(Sender: TObject);
    procedure Menu_Help_ContentsClick(Sender: TObject);
    procedure Menu_Help_WhatClick(Sender: TObject);
    procedure Menu_Help_HideBkgClick(Sender: TObject);
    procedure Menu_HelpClick(Sender: TObject);
    procedure Menu_Window_CascadeClick(Sender: TObject);
    procedure Menu_Window_TileClick(Sender: TObject);
    procedure Menu_Window_ArrangeAllClick(Sender: TObject);
    procedure Menu_Window_MinimizeAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SearchforHelpon1Click(Sender: TObject);
    procedure HowtoUseHelp1Click(Sender: TObject);
    procedure tbSysSetupClick(Sender: TObject);
    procedure EndOfDayReport1Click(Sender: TObject);
    procedure EditTillList1Click(Sender: TObject);
    procedure Menu_Help_AboutClick(Sender: TObject);
    procedure EndOfDayReport2Click(Sender: TObject);
    procedure tbEditTillListClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LayawayList1Click(Sender: TObject);
    procedure Printouttransactions1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    bBitmapExtracted, HideBkGnd, bFormClosing : Boolean;
    FClientInstance, FPrevClientProc : TFarProc;
    ONCMetrics, NCMetrics : PNonClientMetrics;
    OldHint, OldActive : TNotifyEvent;
    PrintHwnd     : HWnd;
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure ClientWndProc(var Message: TMessage);
    procedure DrawBkGnd(var Message  :  TMessage);
//    procedure Reset_NonClientInfo;
    procedure ResetPalette(var Message  : TMessage);
//    procedure Set_NonClientInfo;
    procedure ShowHint(Sender: TObject);
    procedure UpdateMenuItems(Sender: TObject);
    procedure WMFormCloseMsg(var Message  :  TMessage); Message WM_FormCloseMsg;
    procedure WMKeyDown(var Message  :  TMessage); Message WM_KeyDown;
    procedure WMPaletteChanged(var Message  :  TMessage); Message WM_PaletteChanged;
    procedure WMQueryNewPalette(var Message  :  TMessage); Message WM_QueryNewPalette;
    procedure ApplicationActive(Sender  :  TObject);
    procedure PrintProgress(var Msg: TMessage); message WM_PrintProgress;
  public

  end;

var
  frmMain: TfrmMain;
  function AskForLogin : boolean;

implementation

{$R *.DFM}
{$R EXCHBACK.RES}


uses
  RpDevice, Globvar, varConst, BtrvU2, EtStrU, EtMiscU, BtKeys1U, ExWrap1U
  , StrUtil, FileUtil, EPOSCnst, APIUtil, GfxUtil, UseDLLU, SSetup, EODRep
  , DLLInt, ChildWin, TillList, EposComn, EPOSProc, About, LicUtil;
  
var
  ExitSave : Pointer;

procedure Ex_Abort;  far;
{ Generic procedure to close down all files }
begin
  ExitProc := ExitSave;
  Close_Files(TRUE);
  Ex_CloseData;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  CDir : ShortString;
  bLocked, bTabs : boolean;
  iParam, iLockPos : integer;
begin
  sBackground := 'GREYBACK';
  For iParam := 1 to ParamCount do begin
    if UpperCase(Copy(Paramstr(iParam),1,12)) = '/BACKGROUND='
    then sBackground := Copy(Paramstr(iParam),13,255);
  end;{for}

  bRunningFromCentral := UpperCase(IncludeTrailingPathDelimiter(ExtractFilePath(Paramstr(0))))
  = UpperCase(IncludeTrailingPathDelimiter(GetEnterpriseDirectory) + 'TRADE\');

  if AskForLogin then
    begin
      Open_System (1, 15);
      OpenLayawayFiles(FALSE);

      {Initialise SBSFORM.DLL}
      With SystemInfo Do Begin
        ExVersionNo      := 11;
        MainForm         := frmMain;
        AppHandle        := Application;
        ExDataPath       := sCurrCompPath;
        ControllerHandle := Nil;
        DefaultFont      := Nil;
        DebugOpen        := False;
      End; { With }

      bTabs := TRUE;
      if (not sbsForm_Initialise(SystemInfo, bTabs)) then
        begin
          MsgBox('Failed to load the form designer DLL.',mtError,[mbOK],mbOK
          ,'Form Designer');
        end
      else begin

      end;{if}

      Caption := 'Exchequer Trade Counter Administrator';
      Application.OnActivate := ApplicationActive;
      bBitmapExtracted := FALSE;
      bFormClosing := FALSE;
      HideBkGnd := False;
      OldHint := Application.OnHint;
      Application.OnHint := ShowHint;
      Application.Hintpause := 1200;
      OldActive := Screen.OnActiveFormChange;
      Screen.OnActiveFormChange := UpdateMenuItems;
      { Set Tag to 1011, so window can be ID'd uniquely }
      SetWindowLong (Handle, GWL_USERDATA, 1210);

      FClientInstance := MakeObjectInstance(ClientWndProc);
      FPrevClientProc := Pointer(GetWindowLong(ClientHandle, GWL_WNDPROC));
      SetWindowLong(ClientHandle, GWL_WNDPROC, LongInt(FClientInstance));
//      Set_NonClientInfo;

      { Initialise the resource gauges }
      if (SetDrive = '') then GetDir(0,Cdir)
      else Cdir := SetDrive;

      {Get enterprise system setup record}
      bLocked := FALSE;
      GetMultiSys(FALSE, bLocked, Sysr);

      // NF: 27/04/2007 Removed as file is not SQL compatible
      {Get Trade counter system setup record}
{      if sBtrvFilename <> 'TRADEC00.DAT' then begin
        OpenEPOSBtrv(EposSysF);
        GetEPOSRec(EposSysF, FALSE, iLockPos);
        SetupRecord := EposSysRec.EposSetup;
      end;{if}

//      SystemSetup1.Enabled := {(sBtrvFilename <> 'TRADEC00.DAT') and} (AllowedTo(atSetupSystem)); // NF: 27/04/2007 Removed as file is not SQL compatible
      SystemSetup1.Enabled := not bRunningFromCentral;

      tbSysSetup.Enabled := SystemSetup1.Enabled;

      tbReports.Enabled := AllowedTo(atRunReports);
      Reports1.enabled := tbReports.Enabled;

      screen.cursor := crDefault;
    end
  else begin
    PostMessage(Self.Handle,WM_Close,0,0);
  end;{if}
end;


procedure TfrmMain.Menu_File_ExitClick(Sender: TObject);
begin
//  btn_Close.enabled := not btn_Close.enabled;
  Close;
end;

procedure TfrmMain.Menu_Help_ContentsClick(Sender: TObject);
const
  HELP_TAB = 15;
begin
//  Application.HelpCommand(HELP_Finder,0);
//  Application.HelpCommand(HELP_CONTENTS,0);
//  Application.HelpCommand(HELP_CONTEXT,0);
//  Application.HelpCommand(HELP_SETCONTENTS,0);
//  Application.HelpCommand(HELP_Finder,0);
  Application.HelpCommand(HELP_TAB, -3);
end;

procedure TfrmMain.Menu_Help_WhatClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,1000);
end;

procedure TfrmMain.WMFormCloseMsg(var Message  :  TMessage);
begin
end;

procedure TfrmMain.DrawBkGnd(var Message  :  TMessage);
var
  MyDC       : hDC;
  OldPalette : HPalette;
  bitMain : TBitmap;
  TmpJPEG : TJPEGImage;
  ScrnTileRect, ARect, BRect : TRect;
  iVert, iHoriz : integer;
begin
  if not HideBkGnd then begin
    if not bBitmapExtracted then begin

      {Load Background JPEG}
      TmpJPEG := TJPEGImage.Create;
      if LoadJPEGFromRes(sBackground, TmpJPEG) then begin

        BackgroundImage.Picture.Bitmap.Assign(TmpJPEG);
        TileBackground.BitMap.Assign(TmpJPEG);
        bBitmapExtracted := TRUE;
//        TileBackground.AdvImage.Assign(TmpJPEG);

        {create temporary bitmap}
(*        bitMain := TBitmap.Create;

        {copy palette from loaded bitmap}
        DeleteObject(bitMain.Palette);
        bitMain.Palette := CopyPalette(BackgroundImage.Picture.Bitmap.Palette);

        {assigns the correct dimensions to the temporary bitmap (to fit the current screen)}
        bitMain.Width := ClientWidth;
//        bitMain.Height := ClientHeight - StatusPanel{StatusBar}.Height - Coolbar1.height;
        bitMain.Height := ClientHeight - StatusPanel{StatusBar}.Height - AdvDockPanel.height;

        {tile / centre bitmap}
        if (bitMain.Width > BackgroundImage.Picture.Width) or (bitMain.Height > BackgroundImage.Picture.Height) then
          begin
            {tiles the whole bitmap from the top left corner}
            ARect := Rect(0, 0, BackgroundImage.Picture.Width, BackgroundImage.Picture.Height);
            For iHoriz := 0 to (bitMain.Width DIV BackgroundImage.Picture.Width) do begin
              For iVert := 0 to (bitMain.Height DIV BackgroundImage.Picture.Height) do begin
                ScrnTileRect := Rect(iHoriz * BackgroundImage.Picture.Width, iVert * BackgroundImage.Picture.Height
                , ((iHoriz + 1) * BackgroundImage.Picture.Width), (iVert + 1) * BackgroundImage.Picture.Height);
                bitMain.Canvas.CopyRect(ScrnTileRect,BackgroundImage.Picture.Bitmap.Canvas, ARect);
              end;{for}
            end;{for}
          end
        else begin
          {copys the correct chunk of the background bitmap into the centre of the temporary bitmap}
          ARect := Rect(0, 0, bitMain.Width, bitMain.Height);
          BRect := Rect((BackgroundImage.Picture.Width - ClientWidth) DIV 2, (BackgroundImage.Picture.Height - bitMain.Height) DIV 2
          , bitMain.Width + ((BackgroundImage.Picture.Width - ClientWidth) DIV 2)
          , bitMain.Height + ((BackgroundImage.Picture.Height - bitMain.Height) DIV 2));
          bitMain.Canvas.CopyRect(ARect,BackgroundImage.Picture.Bitmap.Canvas, BRect);
        end;{if}

        {assigns the temporary bitmap to the BackgroundImage for displaying}
        BackgroundImage.Picture.Bitmap.Assign(bitMain);

        bitMain.Free;*)
      end;{if}
    end;{if}

    // fixes wierd drawing bitmap problems
(*    BackgroundImage.Top := 0;
    BackgroundImage.Left := 0;

    if BackgroundImage.Width > 0 then begin
      MyDC := TWMEraseBkGnd(Message).DC;
      OldPalette := SelectPalette(MyDC,BackgroundImage.Picture.BitMap.Palette,False);
      try
        RealizePalette(MyDC);
        BitBlt(MyDC, 0, 0, BackgroundImage.Picture.Width, BackgroundImage.Picture.Height ,BackgroundImage.Picture.Bitmap.Canvas.Handle
        , 0, 0, SRCCOPY);
      finally
        SelectPalette(MyDC,OldPalette,true);
      end;{try}

      if not bBitmapExtracted then bBitmapExtracted := TRUE;
    end;{if}  *)
  end;{if}  
end;


procedure TfrmMain.ResetPalette(var Message  : TMessage);
var
  MyDC       : hDC;
  OldPalette : HPalette;
begin
  MyDC := GetDC(Self.Handle);
  try
    OldPalette := SelectPalette(MyDC,BackgroundImage.Picture.BitMap.Palette,False);
    try
      Message.Result := RealizePalette(MyDC);
    finally
      SelectPalette(MyDC,OldPalette,true);
    end;{try}
  finally
    ReleaseDC(Self.Handle,MyDC);
  end;{try}
end;


procedure TfrmMain.ClientWndProc(var Message: TMessage);
begin
  with Message do
  begin
    if (not HideBkGnd) then
      begin
        case Msg of
          WM_ERASEBKGND : begin
            DrawBkGnd(Message);

            if not bBitmapExtracted then begin
              Menu_Help_HideBkgClick(Menu_Help_HideBkg);
              Menu_Help_HideBkg.Enabled := FALSE;
            end;{if}

            Result := 1;
          end;

          WM_KEYDOWN : WMKeyDown(Message);

          WM_VSCROLL, WM_HSCROLL : begin
            InvalidateRect(ClientHandle, nil, True);
            Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);
          end;

          WM_QUERYNEWPALETTE : ResetPalette(Message);
          WM_PALETTECHANGED : if (WParam <> Self.Handle) then ResetPalette(Message);
        else Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);
        end;{case}
      end
    else begin
      case Msg of
        WM_KEYDOWN : WMKeyDown(Message);
      else Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);
      end;{case}
    end;{if}
  end;{with}
end;


procedure TfrmMain.WMQueryNewPalette(var Message  :  TMessage);
begin
  ResetPalette(Message);
end;

procedure TfrmMain.WMPaletteChanged(var Message  :  TMessage);
begin
  if (Message.WParam <> Self.Handle) then ResetPalette(Message);
end;
(*
procedure TfrmMain.Set_NonClientInfo;
var
  MCCancel   :  Boolean;
  SBW,SBH    :  Integer;
begin
  New(NCMetrics);
  New(ONCMetrics);
  FillChar(ONCMetrics^,Sizeof(ONCMetrics^),0);
  ONCMetrics^.cbSize := Sizeof(ONCMetrics^);
  if (SystemParametersInfo(SPI_GETNONCLIENTMETRICS,0,ONCMETRICS,0)) then
    begin
      with ONCMetrics^ do begin
        Move(iScrollWidth,SBW,Sizeof(SBW));
        Move(iScrollHeight,SBH,Sizeof(SBH));
      end;{with}

      if (SBW <> 16) or (SBH <> 16) then
        begin
          with NCMetrics^ do begin
            NCMetrics^ := ONCMetrics^;
            SBW := 16;
            SBH := 16;
            Move(SBW,iScrollWidth,Sizeof(SBW));
            Move(SBH,iScrollHeight,Sizeof(SBH));
            MCCancel := Not SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,NCMETRICS,{SPif_SENDWININICHANGE}0);
          end;{with}
        end
      else MCCancel := TRUE;
    end
  else MCCancel := TRUE;

  if (MCCancel) then begin
    Dispose(ONCMetrics);
    ONCMetrics := nil;
    Dispose(NCMetrics);
    NCMetrics := nil;
  end;{if}
end;

procedure TfrmMain.Reset_NonClientInfo;
begin
  if (Assigned(ONCMetrics)) then begin
    SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,ONCMETRICS,0);
    Dispose(ONCMetrics);
    ONCMetrics := nil;
    Dispose(NCMetrics);
    NCMetrics := nil;
  end;{if}
end;
*)

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  Application.OnHint := OldHint;
  Screen.OnActiveFormChange := OldActive;
//  Reset_NonClientInfo;
  NFClosePrevWindows;
  sbsForm_DeInitialise;
end;

procedure TfrmMain.Menu_Help_HideBkgClick(Sender: TObject);
var
  ARect : tRect;
begin
  HideBkGnd := not HideBkGnd;
  FormResize(self);

{  if HideBkGnd then
  begin
    BackgroundImage.Visible := FALSE;
//    Canvas.Refresh;
  end else
  begin
    BackgroundImage.Visible := TRUE;
//    BackgroundImage.Align := alClient
  end;{if}
//  BackgroundImage.Visible := not HideBkGnd;
  InvalidateRect(0, nil, True);
end;

procedure TfrmMain.Menu_HelpClick(Sender: TObject);
begin
  Menu_Help_HideBkg.Checked := HideBkGnd;
end;

procedure TfrmMain.WMKeyDown(var Message  :  TMessage);
begin
  Inherited;
end;

procedure TfrmMain.Menu_Window_CascadeClick(Sender: TObject);
begin
  Cascade;
end;

procedure TfrmMain.Menu_Window_TileClick(Sender: TObject);
begin
  Tile;
end;

procedure TfrmMain.Menu_Window_ArrangeAllClick(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TfrmMain.Menu_Window_MinimizeAllClick(Sender: TObject);
var
  iChild: Integer;
begin
  { Must be done backwards through the MDIChildren array }
  for iChild := MDIChildCount - 1 downto 0 do MDIChildren[iChild].WindowState := wsMinimized;
end;

procedure TfrmMain.ShowHint(Sender: TObject);
begin
{  StatusBar.Panels[1].Text := Application.Hint;}
  lStatusText.Caption := Application.Hint;
end;

procedure TfrmMain.UpdateMenuItems(Sender: TObject);
begin
  Menu_Window_Cascade.Enabled := MDIChildCount > 0;
  Menu_Window_Tile.Enabled := MDIChildCount > 0;
  TileVertically1.Enabled := MDIChildCount > 0;
  Menu_Window_ArrangeAll.Enabled := MDIChildCount > 0;
  Menu_Window_MinimizeAll.Enabled := MDIChildCount > 0;
end;


procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  iWindow : integer;
begin
  if not bFormClosing then begin
    bFormClosing := TRUE;

    {close all child windows}
    for iWindow := MDIChildCount - 1 downto 0
    do MDIChildren[iWindow].Close;

    Application.ProcessMessages; {so it doesn't crash hideously !}
//    Reset_NonClientInfo;
  end;{if}
end;


procedure TfrmMain.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 300;
    ptMinTrackSize.Y := 200;
  end;{with}
  Message.Result := 0;
  inherited;
end;

function AskForLogin : boolean;
begin
//  ShowMessage('');
  result := false;
  case GetModuleLicence(modTrade, GetTCMEnterpriseDirectory) of

    luLicenced : begin
      with TFrmLogin.Create(application) do begin
        try
          result := showmodal = mrOK;
        finally
          release;
        end;{try}
      end;{with}
    end;

    luNotLicenced : ShowNotLicencedMessage('Trade Counter');

    luError : ShowLicenceErrorMessage('Trade Counter');

  end;{case}
end;

procedure TfrmMain.SearchforHelpon1Click(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_PARTIALKEY, Longint(EmptyString));
end;

procedure TfrmMain.HowtoUseHelp1Click(Sender: TObject);
begin
//  Application.HelpCommand(HELP_HELPONHELP, 0);
  Application.HelpCommand(HELP_CONTEXT,32);
end;

procedure TfrmMain.ApplicationActive(Sender  :  TObject);
Var
  Message  :  TMessage;
Begin
  if not bFormClosing then begin
    FillChar(Message,Sizeof(Message),0);
    ResetPalette(Message);
    MDI_ForceParentBKGnd(BOn);
  end;{if}
end;

procedure TfrmMain.tbSysSetupClick(Sender: TObject);
begin
  with TFrmSetup.Create(Self) do begin
    try
      Showmodal;
    finally
      Release;
    end;{try}
  end;{with}
end;

procedure TfrmMain.EndOfDayReport1Click(Sender: TObject);
begin
  with TfrmEODReport.create(application) do begin
    try
      showmodal;
    finally
      release;
    end;{try}
  end;{with}
end;

procedure TfrmMain.PrintProgress(var Msg: TMessage);
begin
  With Msg Do Begin
    { Mode passes in WParam }
    Case WParam Of
      { Set HWnd }
      2 : PrintHwnd := LParam;

      { Set InPrint Flag }
      3 : InPrint := (LParam = 1);

      { Check InPrint Flag }
      4 : SendMessage(LParam,WM_InPrint,Ord(False),0);
    End; { Case }
  End; { With }
end;

procedure TfrmMain.EditTillList1Click(Sender: TObject);
begin
  with TFrmTillList.Create(self) do begin
    try
      ShowModal;
    finally
      Release;
    end;{try}
  end;{with}
end;

procedure TfrmMain.Menu_Help_AboutClick(Sender: TObject);
var
  FrmAbout : TFrmAbout;
begin
  FrmAbout := TFrmAbout.Create(Self);
  Try
    FrmAbout.ShowModal;
  Finally
    FrmAbout.Free;
  End;{try}
end;

procedure TfrmMain.EndOfDayReport2Click(Sender: TObject);
begin
  EndOfDayReport1Click(EndOfDayReport1);
end;

procedure TfrmMain.tbEditTillListClick(Sender: TObject);
begin
  EditTillList1Click(EditTillList1);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  If (Key = VK_F1) and (Not (ssAlt In Shift)) then Application.HelpCommand(HELP_Finder,0);
//  If (Key = VK_F1) and (Not (ssAlt In Shift)) then Application.HelpCommand(HELP_Finder,34);
  If (Key = VK_F1) and (Not (ssAlt In Shift)) then Application.HelpCommand(HELP_CONTEXT,34);
end;

procedure TfrmMain.LayawayList1Click(Sender: TObject);
var
  frmLayaways : TfrmLayaways;
begin
  // show layaway list
  frmLayaways := TfrmLayaways.Create(Self);
  with frmLayaways do begin
    try
      showmodal;
    finally
      release;
    end;{try}
  end;{with}
end;

procedure TfrmMain.Printouttransactions1Click(Sender: TObject);
begin
  with TfrmTXReport.create(application) do begin
    try
      showmodal;
    finally
      release;
    end;{try}
  end;{with}
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  iPos : integer;
begin
  For iPos := 0 to 99 do begin
    ShowMessage(IntToStr(iPos) + ' : ' + Char(iPos));
  end;{for}
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if HideBkGnd then
  begin
    TileBackground.Height := 0;
    TileBackground.Width := 0;
  end else
  begin
    TileBackground.Top := 0;
    TileBackground.Left := 0;
    TileBackground.Height := ClientHeight;
    TileBackground.Width := ClientWidth;
  end;{if}

  panStatus.Width := ClientWidth;
  panStatus.Height := 20;
  panStatus.Top := ClientHeight - panStatus.Height;
  panStatus.Left := 0;
end;

end.
