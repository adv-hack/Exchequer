unit MainF;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Menus,
  ImgList, ComCtrls, ToolWin, StdCtrls, Gauges, ExtCtrls, SBSPanel, Buttons, Inifiles,
  TEditVal, StdActns, ActnList, BtSupU1, ETDateU, SecureU, JPEG, BTSupU2,
  AdvToolBar, AdvGlowButton, AdvToolBarStylers;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    Menu_File: TMenuItem;
    mniExit: TMenuItem;
    Menu_Window: TMenuItem;
    mniCascade: TMenuItem;
    mniTileHorizontal: TMenuItem;
    mniIconArrange: TMenuItem;
    mniMinimizeAll: TMenuItem;
    Menu_Help: TMenuItem;
    Menu_Help_HideBkg: TMenuItem;
    Menu_Help_SepBar2: TMenuItem;
    Menu_Help_Contents: TMenuItem;
    Menu_Help_SepBar1: TMenuItem;
    Menu_Help_About: TMenuItem;
    imgImages: TImageList;
    mniCloseAll: TMenuItem;
    sbrMain: TStatusBar;
    ActionList1: TActionList;
    WindowArrange1: TWindowArrange;
    WindowCascade1: TWindowCascade;
    WindowClose1: TWindowClose;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    mniTileVertical: TMenuItem;
    SearchforHelpon1: TMenuItem;
    HowtoUseHelp1: TMenuItem;
    mniUtilities: TMenuItem;
    mniLookups: TMenuItem;
    mniTransactions: TMenuItem;
    mniDaybook: TMenuItem;
    actShowDaybook: TAction;
    actShowLookups: TAction;
    actExit: TAction;
    mniSetup: TMenuItem;
    ImportLogs1: TMenuItem;
    PostingLogs1: TMenuItem;
    WhatsThis1: TMenuItem;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    Bevel0: TAdvToolBarSeparator;
    btnDaybook: TAdvGlowButton;
    btnImportLogs: TAdvGlowButton;
    btnPostingLogs: TAdvGlowButton;
    DDn1Btn: TAdvGlowButton;
    AdvStyler: TAdvToolBarOfficeStyler;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    ToolButton2: TAdvGlowButton;
    btnExit: TAdvGlowButton;
    btnLookups: TAdvGlowButton;
    AdvToolBarContainer1: TAdvToolBarContainer;
    cbxCompanySelect: TSBSComboBox;
    imgCentreLeft: TImage;
    imgTopRight: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Menu_Help_ContentsClick(Sender: TObject);
    procedure Menu_Help_WhatClick(Sender: TObject);
    procedure Menu_Help_AboutClick(Sender: TObject);
    procedure Menu_Help_HideBkgClick(Sender: TObject);
    procedure Menu_HelpClick(Sender: TObject);
    procedure mniMinimizeAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Troubleshooting1Click(Sender: TObject);
    procedure SearchforHelpon1Click(Sender: TObject);
    procedure HowtoUseHelp1Click(Sender: TObject);
    procedure cbxCompanySelectChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actShowDaybookExecute(Sender: TObject);
    procedure actShowLookupsExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure mniSetupClick(Sender: TObject);
    procedure btnImportLogsClick(Sender: TObject);
    procedure btnPostingLogsClick(Sender: TObject);
    procedure WhatsThis1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    bBitmapExtracted, HideBkGnd, bFormClosing : Boolean;
    FClientInstance, FPrevClientProc : TFarProc;
    ONCMetrics, NCMetrics : PNonClientMetrics;
    OldHint, OldActive : TNotifyEvent;
    // PR 1/12/03: Added flag to control whether the scrollbar size gets reset - causes
    //              tray icon corruption under Windows XP - AOK on all other OS's
    // Copied from HM's code in EparentU
    SetXPScrollSize : Boolean;

    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMFormCloseMsg(var Message  :  TMessage); Message WM_FormCloseMsg;
    procedure WMKeyDown(var Message  :  TMessage); Message WM_KeyDown;
    procedure WMPaletteChanged(var Message  :  TMessage); Message WM_PaletteChanged;
    procedure WMQueryNewPalette(var Message  :  TMessage); Message WM_QueryNewPalette;

    procedure ClientWndProc(var Message: TMessage);
    procedure DrawBkGnd(var Message  :  TMessage);
    procedure Reset_NonClientInfo;
    procedure ResetPalette(var Message  : TMessage);
    procedure Set_NonClientInfo;
    procedure ShowHint(Sender: TObject);
    procedure UpdateMenuItems(Sender: TObject);
    procedure ApplicationActive(Sender  :  TObject);
    procedure EntDeactivate(Sender : TObject);
    procedure PopulateCompanyList;
    procedure CheckForActiveCompany(WantLogIn : Boolean);
    procedure FormShown;
    procedure LoadBackGround;
  protected
    function  ChildWindowExists(WindowClass : TClass) : boolean;
  public
  end;

var
  frmMain: TfrmMain;


function HasCodeExpired : boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}
{$R EBUSBACK.RES}
{$R EbusAxp.Res}

uses
  About, RpDevice, Globvar, varConst, BtrvU2, EtStrU, EtMiscU, BtKeys1U,
  HelpSupU, TkUtil, IntMU,

  // EBusiness
  StrUtil,
  EBusUtil,
  EBusBtrv,
  EBusLkup,
  EBusVar,
  AdmnUtil,
  UseDLLU,
  LkUpTrad,
  LkUpMain,
  DyBkMain,
  LogView,
  //HTMLView,
  ECBUtil,
  APIUtil,
  GFXUtil, EbusLic, ComObj, Sentimail_TLB, SQLUtils,
  PasswordComplexityConst, LoginF, 
  Brand,
  ADOConnect,
  VarRec2U;

var
  ExitSave : Pointer;
  ebLic : SmallInt;

//********************************************************
//**** New code added back from original E-Business module
//********************************************************

procedure StartLogIn;
var
  lGotPassWord: Boolean;
  lLoginFrm: TfrmLogin;
begin
  lGotPassWord:=BOff;
  lLoginFrm := TfrmLogin.Create(Application);
  try
    with lLoginFrm do
    begin
      eBussCompanyPath := SetDrive;
      LoginDialog := ldeBusiness;
      InitDefaults; //Init Defaults values
      Syss.TxlateCR := BOn;  //Force CR through.
      ShowModal;
      lGotPassword := ModalResult = mrOk;
      //Load user permissions into ThisUser object
      if (lGotPassword) and (LoggedInUserName <> 'SYSTEM') then
        ThisUser.UserName := LoggedInUserName;
    end; {with lLoginFrm do}
  finally
    FreeAndNil(lLoginFrm);
  end; 
  if not lGotPassword then {* Force abort..}
    Halt;
  FirstLogIn := False;
end;


//-----------------------------------------------------------------------

function TfrmMain.ChildWindowExists(WindowClass : TClass) : boolean;
var
  i : integer;
begin
  Result := false;
  for i := 0 to pred(MDIChildCount) do
    Result := Result or (MDIChildren[i] is WindowClass);
end;

//-----------------------------------------------------------------------

procedure TfrmMain.actShowDaybookExecute(Sender: TObject);
begin
  if not ChildWindowExists(TfrmDayBook) then
    with TfrmDayBook.Create(self) do
      Show;
end;

//-----------------------------------------------------------------------

procedure TfrmMain.actShowLookupsExecute(Sender: TObject);
begin
  if not ChildWindowExists(TfrmLookupMain) then
    with TfrmLookupMain.Create(self) do
      Show;
end;

//-----------------------------------------------------------------------

procedure TfrmMain.Button1Click(Sender: TObject);
begin
{  TEBusBtrieve.CreateFile('x:\ebus2\blanks\', true);
  TEBusBtrieveLookup.CreateFile('x:\ebus2\blanks\', true);}
end;

//-----------------------------------------------------------------------

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;


//-----------------------------------------------------------------------

procedure TfrmMain.cbxCompanySelectChange(Sender: TObject);
begin
  with cbxCompanySelect do
    if ItemIndex <> -1 then
    begin
      CurCompSettings.SelectCompany(Items[ItemIndex]
                                         {$IFDEF EBPWORDS}
                                         ,True
                                         {$ENDIF}
                                         );
      sbrMain.Panels[0].Text := 'Active company : ' + CurCompSettings.CompanyName;
      if Items[ItemIndex] <> CurCompSettings.CompanyCode then
        ItemIndex := Items.IndexOf(CurCompSettings.CompanyCode);
      actShowDaybook.Enabled := true;
      actShowLookups.Enabled := true;
      {$IFDEF EBPWORDS}
      ImportLogs1.Enabled := ThisUser.CanViewImpLogs;
      PostingLogs1.Enabled := ThisUser.CanViewPostLogs;
      btnImportLogs.Enabled := ThisUser.CanViewImpLogs;
      btnPostingLogs.Enabled := ThisUser.CanViewPostLogs;
      {$ENDIF}

    end;
end;

//-----------------------------------------------------------------------

procedure TfrmMain.PopulateCompanyList;
var
  Status,
  i : integer;
  ActiveCompany : string;
begin
  cbxCompanySelect.Clear;
  with TEBusBtrieveCompany.Create(true) do
    try
      OpenFile;
      Status := FindRecord(B_GetFirst);
      while Status = 0 do
      begin
        cbxCompanySelect.Items.Add(Trim(CompanyCode));
        Status := FindRecord(B_GetNext);
      end;
      CloseFile;
    finally
      Free;
    end;

{$IFNDEF EBPWORDS}
  // Update selected company in Toolbar combo box
  with TEBusBtrieveParams.Create(true) do
    try
      OpenFile;
      if FindRecord = 0 then
        ActiveCompany := Trim(ParamsSettings.EntDefaultCompany);
      CloseFile;
    finally
      Free;
    end;

  with cbxCompanySelect do
    for i := 0 to Items.Count -1 do
      if Items[i] = Trim(ActiveCompany) then
        ItemIndex := i;
{$ENDIF}
end;

//-----------------------------------------------------------------------

//********************************************************
//**** New code added back from original E-Business module
//********************************************************

procedure Ex_Abort;  far;
{ Generic procedure to close down all files }
begin
  ExitProc := ExitSave;
  Close_Files(TRUE);
 // oDLL.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i : integer;
begin
  //Initialise global AdoConnection
  if not Assigned(GlobalADOConnection) and SQLUtils.UsingSQL then
    InitialiseGlobalADOConnection(SetDrive);
  EventObject := nil;
  Caption := Application.Title;
  Application.OnActivate := ApplicationActive;
  Application.OnDeactivate := EntDeActivate;
  Application.OnMinimize   := EntDeActivate;
  Application.OnRestore    := ApplicationActive;


  If (IS_WINXPStyle) Then
    SetXPScrollSize := FindCmdLineSwitch('XPSCROLL', ['-', '/', '\'], True) Or
                       FindCmdLineSwitch('XPSCROLL:', ['-', '/', '\'], True)
  Else
    SetXPScrollSize := True;

  bBitmapExtracted := FALSE;

  bFormClosing := FALSE;
  HideBkGnd := NoXLogo;

  OldHint := Application.OnHint;
  Application.OnHint := ShowHint;
  Application.Hintpause := 1200;
  OldActive := Screen.OnActiveFormChange;
  Screen.OnActiveFormChange := UpdateMenuItems;

  { Set Tag to 1020, so window can be ID'd uniquely }
  { was 1010 in card system }
  SetWindowLong (Handle, GWL_USERDATA, 1020);

  FClientInstance := MakeObjectInstance(ClientWndProc);
  FPrevClientProc := Pointer(GetWindowLong(ClientHandle, GWL_WNDPROC));
  SetWindowLong(ClientHandle, GWL_WNDPROC, LongInt(FClientInstance));
  Set_NonClientInfo;
  {$IFDEF SENTEV}
  Try
    EventObject := CreateOLEObject('Sentimail.SentimailEvent') as ISentimailEvent;
  Except
  End;
  {$ENDIF}
  ThisUser := TUserAccess.Create;
  screen.cursor := crDefault;
  PopulateCompanyList;
  {.$IFNDEF EBPWORDS}

  //Need to allocate UserProfile memory
  New(UserProfile);
  FillChar(UserProfile^, SizeOf(UserProfile^), 0);

  //PR: 16/10/2017 Moved from initialization section of Ebus VarConst,
  //which was causing all sorts of problems.
  Open_System(PwrdF, PwrdF);
  Open_System(MlocF, MLocF);
  //PL 03/11/2017 2017-R2	ABSEXCH-19414 Forgotten Password Functionality not working in eBusiness
  Open_System(SysF, SysF);

  StartLogIn;
  CheckForActiveCompany(False);
  {.$ELSE}
//  CheckForActiveCompany(True);
  ImportLogs1.Enabled := ThisUser.CanViewImpLogs;
  PostingLogs1.Enabled := ThisUser.CanViewPostLogs;
  btnImportLogs.Enabled := ThisUser.CanViewImpLogs;
  btnPostingLogs.Enabled := ThisUser.CanViewPostLogs;
//  LoadBackGround;
    With Branding.BrandingFile('E8263') Do
    Begin
      ExtractImageCD (imgCentreLeft, 'back-centre-left');
      ExtractImageCD (imgTopRight, 'back-top-right');
    End; // With Branding.BrandingFile('E8263')

  {.$ENDIF}
  SetIntMessage;

end;

procedure TfrmMain.Menu_Help_ContentsClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;

procedure TfrmMain.Menu_Help_WhatClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,1000);
end;

procedure TfrmMain.Menu_Help_AboutClick(Sender: TObject);
begin
  with TfrmAbout.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmMain.WMFormCloseMsg(var Message  :  TMessage);
begin
  case Message.WParam of
    EBUS_FORM_SHOWN : FormShown;
  end;
end;

procedure TfrmMain.DrawBkGnd(var Message  :  TMessage);
Var
  MyDC       : hDC;
//  Ro, Co     : Word;
  OldPalette : HPalette;
  BackgroundRect: TRect;
//  X, Y,
  bgHeight, bgWidth, clTop, clRight, trLeft, trBottom: Integer;
//  BlitResult: Boolean;
Begin
  MyDC := TWMEraseBkGnd(Message).DC;

  OldPalette:=SelectPalette(MyDC,imgCentreLeft.Picture.BitMap.Palette,False);
  try
    RealizePalette(MyDC);

    (***
    { CJS 2012-09-07 ABSEXCH-12952 - Rebranding - Background bitmap handling }
    X := 0;
    Y := self.ClientHeight - StatusBar.Height - AdvToolbar.Height - 6 - Image1.Picture.Height;
    if (Y < 0) then
      Y := 0;

    BackgroundRect := Rect(0, 0, ClientWidth, Y);
    FillRect(MyDC, BackgroundRect, clWhite);

    BackgroundRect := Rect(Image1.Picture.Width, Y, ClientWidth, ClientHeight - StatusBar.Height - 6 - AdvToolbar.Height);
    FillRect(MyDC, BackgroundRect, clWhite);

    BlitResult := BitBlt(MyDC, 0, Y, Image1.Picture.Width, Image1.Picture.Height,
                         Image1.Picture.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);
    if not BlitResult then
      OutputDebugString('BitBlt failed');
    ***)

    //
    // To avoid flickering the background is painted in 6 blocks
    //
    //    +----------+--------+--------+
    //    |          |        |   TR   |
    //    |    B1    |        +--------+
    //    |          |        |        |
    //    +----------+        |        |
    //    |    CL    |   B3   |        |
    //    +----------+        |   B4   |
    //    |          |        |        |
    //    |    B2    |        |        |
    //    |          |        |        |
    //    +----------+--------+--------+
    //

    // Calculate the height of the area we are putting the background in
    bgHeight := self.ClientHeight - sbrMain.Height - AdvToolbar.Height - 6; // WTF does 6 come from?
    bgWidth := Self.ClientWidth; // - GetSystemMetrics(SM_CXVSCROLL) - 4;

    // Calculate the position of the Centre-Left bitmap (CL)
    clTop := (bgHeight - imgCentreLeft.Picture.Height) Div 2;
    clRight := imgCentreLeft.Picture.Width;

    // Calculate the position of the Top-Right bitmap (TR)
    trLeft := bgWidth - imgTopRight.Picture.Width;
    trBottom := imgTopRight.Picture.Height;

    // Paint in background B1 above Centre-Left bitmap
    BackgroundRect := Rect(0, 0, clRight, clTop);  // LTRB
    FillRect(MyDC, BackgroundRect, clRed);//clWhite);

    // Paint in background B2 below Centre-Left bitmap
    BackgroundRect := Rect(0, clTop + imgCentreLeft.Picture.Height, clRight, bgHeight);  // LTRB
    FillRect(MyDC, BackgroundRect, clWhite);

    // Paint in Centre-Left bitmap (CL)
    BitBlt(MyDC, 0, clTop, imgCentreLeft.Picture.Width, imgCentreLeft.Picture.Height,
           imgCentreLeft.Picture.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);

    If ((clRight + 1) < trLeft) Then
    Begin
      // Paint in central background column B3
      BackgroundRect := Rect(clRight, 0, trLeft, bgHeight);  // LTRB
      FillRect(MyDC, BackgroundRect, clWhite);
    End; // If ((clRight + 1) < trLeft)

    // Paint in Top-Right bitmap (TR)
    BitBlt(MyDC, trLeft, 0, imgTopRight.Picture.Width, imgTopRight.Picture.Height,
           imgTopRight.Picture.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);

    // Paint in background B4 below Top-Right bitmap
    BackgroundRect := Rect(trLeft, imgTopRight.Picture.Height, bgWidth, bgHeight);  // LTRB
    FillRect(MyDC, BackgroundRect, clWhite);
  finally
    SelectPalette(MyDC,OldPalette,true);
  end; {try..}
end;


procedure TfrmMain.ResetPalette(var Message  : TMessage);
var
  MyDC       : hDC;
  OldPalette : HPalette;
begin
  MyDC:=GetDC(Self.Handle);

  try
    OldPalette:=SelectPalette(MyDC,imgCentreLeft.Picture.BitMap.Palette,False);

    try
      Message.Result:=RealizePalette(MyDC);

    finally

      SelectPalette(MyDC,OldPalette,true);
    end;

  finally

    ReleaseDC(Self.Handle,MyDC);

  end;
end;


procedure TfrmMain.ClientWndProc(var Message: TMessage);
begin
  with Message do
  begin
    {ReDrawBk:=((Msg=WM_HSCROLL) or (Msg=WM_VSCROLL));}
    if (not HideBkGnd) {and (Not Syss.HideEXLogo)} then
      begin
        case Msg of
          WM_ERASEBKGND : begin
            DrawBkGnd(Message);
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

procedure TfrmMain.Set_NonClientInfo;
var
  MCCancel   :  Boolean;
  SBW,SBH    :  Integer;
begin
  If SetXPScrollSize Then
  Begin

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
end;

procedure TfrmMain.Reset_NonClientInfo;
begin
  if (Assigned(ONCMetrics))  And SetXPScrollSize then
  begin
    SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,ONCMETRICS,{SPif_SENDWININICHANGE}0);
    Dispose(ONCMetrics);
    ONCMetrics := nil;
    Dispose(NCMetrics);
    NCMetrics := nil;
  end;{if}
end;


procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  Application.OnHint := OldHint;
  Screen.OnActiveFormChange := OldActive;
  EventObject := nil;
  Reset_NonClientInfo;
end;

procedure TfrmMain.Menu_Help_HideBkgClick(Sender: TObject);
begin
  HideBkGnd := not HideBkGnd;
  InvalidateRect(0, nil, True);
end;

procedure TfrmMain.Menu_HelpClick(Sender: TObject);
begin
  Menu_Help_HideBkg.Checked := HideBkGnd;
end;

procedure TfrmMain.mniMinimizeAllClick(Sender: TObject);
var
  iChild: Integer;
begin  { Must be done backwards through the MDIChildren array }
  for iChild := MDIChildCount - 1 downto 0 do
    MDIChildren[iChild].WindowState := wsMinimized;
end;

procedure TfrmMain.ShowHint(Sender: TObject);
begin
  sbrMain.Panels[1].Text := Application.Hint;
end;

procedure TfrmMain.UpdateMenuItems(Sender: TObject);
begin
  mniCascade.Enabled := MDIChildCount > 0;
  mniTileHorizontal.Enabled := MDIChildCount > 0;
  mniTileVertical.Enabled := MDIChildCount > 0;
  mniIconArrange.Enabled := MDIChildCount > 0;
  mniMinimizeAll.Enabled := MDIChildCount > 0;
  mniSetup.Enabled := MDIChildCount = 0;
  cbxCompanySelect.Enabled := MDIChildCount = 0;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not bFormClosing then
  begin
    bFormClosing := TRUE;
    Application.ProcessMessages; {so it doesn't crash hideously !}
    Reset_NonClientInfo;
  end;
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

procedure TfrmMain.Troubleshooting1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,1001);
end;

procedure TfrmMain.SearchforHelpon1Click(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_PARTIALKEY, Longint(EmptyString));
end;

procedure TfrmMain.HowtoUseHelp1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

procedure TfrmMain.mniSetupClick(Sender: TObject);
var
  OldCount : integer;
begin
  OldCount := cbxCompanySelect.Items.Count;
  Ex_CloseData;
  ShowEBusSetup;
  Ex_InitDll;
  PopulateCompanyList;
//  if cbxCompanySelect.Items.Count = 1 then
    CheckForActiveCompany(OldCount = 0);
end;


function HasCodeExpired : boolean;
(*
var
  Rd,Rm,Ry : word;
  RelDateStr : longdate;
  SecDays : integer;
  RelDOW : byte;
  CurrTime : TimeTyp;
  bResult : boolean; *)
begin
(*  bResult := FALSE;
  if not FullyReleased then begin
    with Syss do begin
      JulCal(RelDate,Rd,Rm,Ry);
      RelDateStr:=StrDate(Ry,Rm,Rd);
      SecDays:=ABS(ETDateU.NoDays(Today,RelDateStr));
      RelDOW:=DayofWeek(Today);
      GetCurrTime(CurrTime);

      {* Avoid triggering outside office hours, or on a Fri-Mon *}
      If ((RelDateStr<Today) and (Not (RelDOW In [0,1,5,6])) and (CurrTime.HH>9) and (CurrTime.HH<17))
      or (SecDays>AbsMaxDays) or (RelDate=0) then Begin
        frmReleaseCode := TfrmReleaseCode.Create(application);
        try
          bResult := frmReleaseCode.ShowModal = mrCancel;
        finally
          frmReleaseCode.Release;
        end;{try}
      end;{if}
    end;{with}
    if not bResult then PutMultiSys(TRUE);
  end;{if}
  Result := bResult; *)
end;

procedure TfrmMain.ApplicationActive(Sender  :  TObject);
var
  Message  :  TMessage;
Begin
  FillChar(Message,Sizeof(Message),0);
  ResetPalette(Message);
  MDI_ForceParentBKGnd(BOn);

  Application.Title := 'Exchequer eBusiness Admin Module - ' + CurCompSettings.CompanyName;
  Caption := Application.Title;
end;

procedure TfrmMain.WMKeyDown(var Message: TMessage);
begin
  inherited;
end;

procedure TfrmMain.CheckForActiveCompany(WantLogIn : Boolean);
begin
  with cbxCompanySelect do
  begin
{     ebCompDir := GetMultiCompDir;
     if ItemIndex = -1 then
     begin
       ItemIndex := Items.IndexOf(CompanyCodeFromDir(ebCompDir));
       if ItemIndex = -1 then
       begin
         if Items.Count > 0 then
           ItemIndex := 0
         else
         begin
           Ex_CloseData;
           ShowEBusSetup;
           Ex_InitDll;
           PopulateCompanyList;
         end;
       end;
     end;}

     //PR: 07/02/2013 ABSEXCH-13988 Change to use CompanyPath from settings as SetDrive doesn't change when changing company
     //                             within eBusiness
     if CurCompSettings.CompanyPath <> '' then
       ebCompDir := CurCompSettings.CompanyPath
     else
       ebCompDir := SetDrive;
       
     if ItemIndex = -1 then
     begin
       ItemIndex := Items.IndexOf(Trim(CompanyCodeFromDir(ebCompDir)));
       if ItemIndex = -1 then
       begin
{         if Items.Count > 0 then
           ItemIndex := 0
         else}
         begin
           Ex_CloseData;
           MessageDlg('Company ' + CompanyCodeFromDir(ebCompDir) + ' is not available in the e-Business system.' + CRLF +
           'Contact your eBusiness administrator to add the company via the System Set-up Module'
           , mtWarning, [mbOK], 0);
           ShowEBusSetup;
           Ex_InitDll;
           PopulateCompanyList;
           ItemIndex := Items.IndexOf(Trim(CompanyCodeFromDir(ebCompDir)));
         end;
       end;
     end;

     if ItemIndex >= 0 then
     begin
       CurCompSettings.SelectCompany(Items[ItemIndex], WantLogIn);
       sbrMain.Panels[0].Text := 'Active company : ' + CurCompSettings.CompanyName;
       ebCompDir := GetCompanyDirFromCode(CurCompSettings.CompanyCode);
     end
     else
     begin
       if Items.Count = 0 then
         MessageDlg('No companies are available for selection.' + CRLF +
         'Contact your eBusiness administrator to add companies via the System Set-up Module'
         , mtWarning, [mbOK], 0)
       else
         MessageDlg('Company ' + CompanyCodeFromDir(ebCompDir) + ' is not available in the e-Business system.' + CRLF +
         'Contact your eBusiness administrator to add the company via the System Set-up Module'
         , mtWarning, [mbOK], 0);
//       Halt;
     end;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  PostMessage(Self.Handle, WM_FormCloseMsg, EBUS_FORM_SHOWN, 0);
end;

procedure TfrmMain.FormShown;
begin
{  PopulateCompanyList;
  if cbxCompanySelect.Items.Count = 0 then
    StartLogIn;
  CheckForActiveCompany;}
end;

procedure TfrmMain.btnImportLogsClick(Sender: TObject);
begin
  DisplayLogs(ebsImport);
end;

procedure TfrmMain.btnPostingLogsClick(Sender: TObject);
begin
  DisplayLogs(ebsPost);
end;




//-----------------------------------------------------------------------

procedure InitialiseEBusAdmin;
begin
  // For storage of form properties - used globally
//  StartLogin;

  //PR: 07/02/2013 ABSEXCH-13988 If we're running under MS-SQL then don't open misc file at this point -
  //               open it once we have the data path
  if not SQLUtils.UsingSQL then
    OpenMiscFile(true);
  OpenEBusFile(true);
end;

//-----------------------------------------------------------------------

procedure FinaliseEBusAdmin;
begin
  CloseEBusFile;
  CloseMiscFile;

  If CurCompSettings.PaperlessLoaded then  {* We have previosuly loaded the paperless module, so we need to unload it *}
  Begin
    CurCompSettings.PaperlessLoaded:=False;
    EX_ENDPRINTFORM;

  end;

  // DLL will be open
  Ex_CloseDLL;
end;

//-----------------------------------------------------------------------

procedure TfrmMain.WhatsThis1Click(Sender: TObject);
begin
  PostMessage(Self.Handle, WM_SysCommand, SC_CONTEXTHELP, 0);
end;

//-----------------------------------------------------------------------

procedure TfrmMain.EntDeactivate(Sender : TObject);
begin
  Application.Title := CurCompSettings.CompanyName + ' - Exchequer eBusiness Admin Module';
end;

//-----------------------------------------------------------------------

Procedure GetDirParam;

Var
  n  :  Integer;
  s  : string;
Begin
  ebSetDrive:='';

  For n:=0 to Pred(ParamCount) do
  Begin
    s := UpperCase(ParamStr(n));
    If s = ebEntDirSw then
      ebSetDrive:=IncludeTrailingBackslash(ParamStr(n+1))
    else
    If s = ebRemoteDirSw then
      ebCompDir:=IncludeTrailingBackslash(ParamStr(n+1))
  end;

  {$IFNDEF EBPWORDS}
  ebCompDir := ebSetDrive;
  {$ENDIF}
end;


procedure TfrmMain.LoadBackGround;
// Load background bitmap from ECB File
var
  EuroImage  : TBitMap;
  RectD      : TRect;
  sECBFile : string;
  iBitmapNo : byte;
begin
(*  try

    //sECBFile := GetECBFilename(waEnterprise, iBitmapNo, Self, SBSPanel1.Height + SpeedPanel.Height);
    sECBFile := GetECBFilename(waEbusAdmin, 1, Self, sbrMain.Height + AdvToolbar.Height);
    EuroImage := GetBitmapFromECB(sECBFile);
    //GetCentreOfBitmap(EuroImage, Self, SBSPanel1.Height + SpeedPanel.Height);
    GetCentreOfBitmap(EuroImage, Self, sbrMain.Height + AdvToolbar.Height);

    if (Assigned(EuroImage)) then
    begin
      with EuroImage do
      begin
        RectD:=Rect(0,0,Width,Height);
      end;{with}

      with BackgroundImage.Picture.Bitmap do
      begin
        Width:=RectD.Right;
        Height:=RectD.Bottom;

        DeleteObject(BackgroundImage.Picture.BitMap.Palette);
        BackgroundImage.Picture.BitMap.Palette:=CopyPalette(EuroImage.Palette);
        BackgroundImage.Picture.Bitmap.Canvas.CopyRect(RectD,EuroImage.Canvas,RectD);
      end;{with}

    end;{if}
  finally
      if (Assigned(EuroImage)) then
        EuroImage.Free;

  end;{try}*)
end;


procedure TfrmMain.FormResize(Sender: TObject);
begin
  if not Menu_Help_HideBkg.Checked then
  begin
    InvalidateRect(0, nil, False);
    Application.ProcessMessages;
  end;
end;

initialization
  ExitSave := ExitProc;
  ExitProc := @Ex_Abort;
  ebLic := GetEbusLicence;
  GetDirParam;
  if Trim(ebSetDrive) = '' then
  begin
    msgBox('Exchequer Ebusiness Admin Module ' + EbusAdminVersion + #10#10 +
           'This program can only be run from within the Exchequer Multi-Company Manager.', mtError, [mbOK], mbOK, 'Error');
    Application.Terminate;
  end;
  if  ebLic = eblLicenced then
    InitialiseEBusAdmin
  else
  begin
    if ebLic = eblNotLicenced then
      ShowEbusNotLicencedMessage
    else
      ShowEbusLicenceErrorMessage;

    Application.ShowMainForm := False;
    Application.Terminate;
  end;
//  if oDLL.Opened then AskForLogin;
//  oExchequer := TOExchequer.Create;



finalization
  FinaliseEBusAdmin
//  oExchequer.Free;

end.
