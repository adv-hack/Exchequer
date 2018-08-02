unit MainF;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, NeilProc
  , Menus, ImgList, ComCtrls, ToolWin, StdCtrls, Gauges, ExtCtrls, SBSPanel, Buttons
  , Inifiles, TEditVal, BtSupU1, CardList, Startup, SysSetup, EOD, CardProc
  , DLLProc, ExchLink, About, ETDateU, AutoEOD, ClubU, Club2Exp, RunRange, FuncBook
  , ProcFunc, PLUList, HeldCard, DatRange, StdActns, APIUtil, ActnList, Progress
  , ProgTill, DebugInf, Utils, SecureU, JPEG, BTSupU2, PrntList, BillSplt, OoMisc
  , AdStatLt, ChkPrntr, SecSup2U, EOY;

type
  PHWND = ^HWND;

  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    Menu_File: TMenuItem;
    Menu_File_Exit: TMenuItem;
    Menu_Records: TMenuItem;
    Menu_Window: TMenuItem;
    Menu_Window_Cascade: TMenuItem;
    Menu_Window_Tile: TMenuItem;
    Menu_Window_ArrangeAll: TMenuItem;
    Menu_Window_MinimizeAll: TMenuItem;
    Menu_Help: TMenuItem;
    Menu_Help_HideBkg: TMenuItem;
    Menu_Help_SepBar2: TMenuItem;
    Menu_Help_Contents: TMenuItem;
    Menu_Help_What: TMenuItem;
    Menu_Help_SepBar1: TMenuItem;
    Menu_Help_About: TMenuItem;
    Menu_Records_Cards: TMenuItem;
    Menu_Reports: TMenuItem;
    Menu_Tools: TMenuItem;
    Menu_Tools_Options: TMenuItem;
    Menu_Tools_SepBar1: TMenuItem;
    Menu_Records_Groups: TMenuItem;
    Menu_Procedures: TMenuItem;
    AutomaticEndOfDay1: TMenuItem;
    EndOfDay1: TMenuItem;
    N1: TMenuItem;
    FunctionBooking1: TMenuItem;
    ProgramTills1: TMenuItem;
    Full1: TMenuItem;
    CardDetailsonly1: TMenuItem;
    CardBalancesOnly1: TMenuItem;
    CardReports1: TMenuItem;
    CardList1: TMenuItem;
    CardTurnover1: TMenuItem;
    CardsOnHold1: TMenuItem;
    PostingReport1: TMenuItem;
    DetailedPostingReport1: TMenuItem;
    BadTillCardList1: TMenuItem;
    PostingReports1: TMenuItem;
    Menu_Utils: TMenuItem;
    SuspendAllCards1: TMenuItem;
    UnsuspendAllCards1: TMenuItem;
    Menu_Reports_SepBar1: TMenuItem;
    Menu_Utils_SysSetup: TMenuItem;
    Menu_Utils_ResetBadTill: TMenuItem;
    CheckTillComms1: TMenuItem;
    ToolbarImages: TImageList;
    Debug1: TMenuItem;
    CommsDebug1: TMenuItem;
    CommandList1: TMenuItem;
    Import1: TMenuItem;
    ExporttoClubSystem1: TMenuItem;
    N3: TMenuItem;
    pmReports: TPopupMenu;
    CardList2: TMenuItem;
    BadTillCardList2: TMenuItem;
    EndofDayErrorLog1: TMenuItem;
    EndofDayErrorLog2: TMenuItem;
    EndOfDayPosting1: TMenuItem;
    CardsOnHold2: TMenuItem;
    AllEndofDayReports1: TMenuItem;
    AllEndofDayReports2: TMenuItem;
    FunctionBooking2: TMenuItem;
    N2: TMenuItem;
    CloseAll1: TMenuItem;
    TechSupportLog1: TMenuItem;
    TechSupportLog2: TMenuItem;
    N5: TMenuItem;
    ResetTechSupportLog1: TMenuItem;
    EndofDayPosting2: TMenuItem;
    CardTurnover2: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    LedgerHistory1: TMenuItem;
    LedgerHistory2: TMenuItem;
    ImageList1: TImageList;
    ActionList1: TActionList;
    WindowArrange1: TWindowArrange;
    WindowCascade1: TWindowCascade;
    WindowClose1: TWindowClose;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    TileVertically1: TMenuItem;
    AllTills1: TMenuItem;
    AllTills2: TMenuItem;
    AllTills3: TMenuItem;
    SelectedTills1: TMenuItem;
    SelectedTills2: TMenuItem;
    SelectedTills3: TMenuItem;
    DebugInfo1: TMenuItem;
    N6: TMenuItem;
    Utilities1: TMenuItem;
    N9: TMenuItem;
    Troubleshooting1: TMenuItem;
    SearchforHelpon1: TMenuItem;
    HowtoUseHelp1: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    PLUSales1: TMenuItem;
    TillReports1: TMenuItem;
    PLUSales2: TMenuItem;
    TillGroupSales1: TMenuItem;
    TillGroupSales2: TMenuItem;
    HourlySales1: TMenuItem;
    HourlySales2: TMenuItem;
    ClerkSales1: TMenuItem;
    ClerkSales2: TMenuItem;
    TransactionTotals1: TMenuItem;
    TransactionTotals2: TMenuItem;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    tbCardList: TToolButton;
    tbPLUList: TToolButton;
    ToolButton6: TToolButton;
    tbEOD: TToolButton;
    tbAEOD: TToolButton;
    ToolButton15: TToolButton;
    tbFunctionBook: TToolButton;
    ToolButton2: TToolButton;
    tbReports: TToolButton;
    ToolButton13: TToolButton;
    tbCheckComms: TToolButton;
    tbSysSetup: TToolButton;
    ToolButton10: TToolButton;
    tbMarkCards: TToolButton;
    ToolButton8: TToolButton;
    tbExit: TToolButton;
    TheImage: TImage;
    CommslogViewer1: TMenuItem;
    DumpFile1: TMenuItem;
    TillSaledat1: TMenuItem;
    bytsMainK1: TMenuItem;
    by1: TMenuItem;
    CheckAllAccountBalances1: TMenuItem;
    Panel1: TPanel;
    StatusPanel: TPanel;
    lStatusText: TLabel;
    ApdStatusLight1: TApdStatusLight;
    lCommsStatus: TLabel;
    Label1: TLabel;
    Bevel1: TBevel;
    N12: TMenuItem;
    FunctionBooking3: TMenuItem;
    N13: TMenuItem;
    BatchJobs1: TMenuItem;
    N4: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    AllowCreditonallcards1: TMenuItem;
    DisallowCreditonallcards1: TMenuItem;
    OpenTables1: TMenuItem;
    OpenTables2: TMenuItem;
    N16: TMenuItem;
    AllTillReports1: TMenuItem;
    N17: TMenuItem;
    AllTillReports2: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    CustFbyCustCodeK1: TMenuItem;
    CustFbyCustCodeK2: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    ConverttoSplitDiscount1: TMenuItem;
    ConvertfromSplitDiscount1: TMenuItem;
    EndofYear1: TMenuItem;
    PLUDat1: TMenuItem;
    bysiTypeK1: TMenuItem;
    bysiGroupK1: TMenuItem;
    bysiNameK2: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Menu_File_ExitClick(Sender: TObject);
    procedure Menu_Help_ContentsClick(Sender: TObject);
    procedure Menu_Help_WhatClick(Sender: TObject);
    procedure Menu_Help_AboutClick(Sender: TObject);
    procedure Menu_Help_HideBkgClick(Sender: TObject);
    procedure Menu_Window_CascadeClick(Sender: TObject);
    procedure Menu_Window_TileClick(Sender: TObject);
    procedure Menu_Window_ArrangeAllClick(Sender: TObject);
    procedure Menu_Window_MinimizeAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DisplayCardList(Sender: TObject);
    procedure Menu_Tools_OptionsClick(Sender: TObject);
    procedure AutomaticEndOfDay1Click(Sender: TObject);
    procedure Menu_Utils_SysSetupClick(Sender: TObject);
    procedure CommandList1Click(Sender: TObject);
    procedure CommsDebug1Click(Sender: TObject);
    procedure CheckTillComms1Click(Sender: TObject);
    procedure EndOfDay1Click(Sender: TObject);
    procedure ImportfromClubSystems1Click(Sender: TObject);
    procedure ExporttoClubSystem1Click(Sender: TObject);
    procedure CardList1Click(Sender: TObject);
    procedure BadTillCardList1Click(Sender: TObject);
    procedure EndofDayErrorLog1Click(Sender: TObject);
    procedure CardsOnHold2Click(Sender: TObject);
    procedure tbFunctionBookClick(Sender: TObject);
    procedure FunctionBooking2Click(Sender: TObject);
    procedure Menu_Records_GroupsClick(Sender: TObject);
    procedure TechSupportLog1Click(Sender: TObject);
    procedure ResetTechSupportLog1Click(Sender: TObject);
    procedure CardTurnover1Click(Sender: TObject);
    procedure LedgerHistory1Click(Sender: TObject);
    procedure ReprogSelectedTills(Sender: TObject);
    procedure ProgramAllTills(Sender: TObject);
    procedure Menu_Utils_ResetBadTillClick(Sender: TObject);
    procedure SuspendAllCards1Click(Sender: TObject);
    procedure DebugInfo1Click(Sender: TObject);
    procedure Utilities1Click(Sender: TObject);
    procedure Troubleshooting1Click(Sender: TObject);
    procedure SearchforHelpon1Click(Sender: TObject);
    procedure HowtoUseHelp1Click(Sender: TObject);
    procedure RunNoRangeReport(Sender: TObject);
    procedure CommslogViewer1Click(Sender: TObject);
    procedure tillsaledump(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure CheckAllAccountBalances1Click(Sender: TObject);
    procedure AllowCreditonallcards1Click(Sender: TObject);
    procedure DisallowCreditonallcards1Click(Sender: TObject);
    procedure OpenTables2Click(Sender: TObject);
    procedure CustFbyCustCodeK1Click(Sender: TObject);
    procedure ConvertBalances(Sender: TObject);
    procedure EndofYear1Click(Sender: TObject);
    procedure DumpSaleItem(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    FrmSystemSetup: TFrmSystemSetup;
    {bBitmapExtracted,} InAutoEOD, HideBkGnd, bFormClosing, InCardList   : Boolean;
    FClientInstance, FPrevClientProc : TFarProc;
    ONCMetrics, NCMetrics : PNonClientMetrics;
    OldHint, OldActive : TNotifyEvent;
    FrmPLUList : TFrmPLUList;
    FrmDebugInfo : TFrmDebugInfo;
{    BackgroundImage : TImage;}
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
//    procedure ClientWndProc(var Message: TMessage);
//    procedure DrawBkGnd(var Message  :  TMessage);
//    procedure Reset_NonClientInfo;
//    procedure ResetPalette(var Message  : TMessage);
//    procedure Set_NonClientInfo;
    procedure ShowHint(Sender: TObject);
    procedure UpdateMenuItems(Sender: TObject);
    procedure WMFormCloseMsg(var Message  :  TMessage); Message WM_FormCloseMsg;
    procedure WMKeyDown(var Message  :  TMessage); Message WM_KeyDown;
//    procedure WMPaletteChanged(var Message  :  TMessage); Message WM_PaletteChanged;
//    procedure WMQueryNewPalette(var Message  :  TMessage); Message WM_QueryNewPalette;
    procedure UpdateToolsMenu(Sender: TObject);
    procedure ApplicationActive(Sender  :  TObject);
    Procedure DoClubImport;
    procedure SizeImage(AnImage : TImage);
    procedure ImportFromClub;
  public
    FrmCardList2: TFrmCardList2;
    FrmFunctionList : TFrmFunctionList;
    FrmBillSplit: TFrmBillSplit;
    Procedure CheckComms(bAutoCont : boolean; Sender: TObject);
    procedure DisableControls;
  end;

var
  frmMain: TfrmMain;
  FrmStartUp : TFrmStartUp;
{  hMainWin : Hwnd;}
  procedure AskForLogin;
  function HasCodeExpired : boolean;

implementation

{$R *.DFM}
{$R CARDBACK.RES}


uses
  RpDevice, Globvar, varConst, BtrvU2, EtStrU, EtMiscU, BtKeys1U, ToolOpt, OpenTab,
  Comms, Reports, Expiry, HelpSupU, LogView, ExWrap1U, StrUtil, FileUtil, GfxUtil,
  CARDL3;

var
  ExitSave : Pointer;

procedure Ex_Abort;  far;
{ Generic procedure to close down all files }
begin
  ExitProc := ExitSave;
  Close_Files(TRUE);
  oDLL.Destroy;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  TmpJPEG : TJPEGImage;
  CDir : ShortString;
begin

  LoginMode := lmDebug;

{  BackgroundImage := TImage.Create(nil);}
  if ColorMode(self.canvas) in [cm256Colors, cm16Colors, cmMonochrome] then begin
    Menu_Help_HideBkg.Checked := TRUE;
    Menu_Help_HideBkgClick(nil);
    Menu_Help_HideBkg.Enabled := FALSE;
  end;{if}

  if not Menu_Help_HideBkg.Checked then begin
    SizeImage(TheImage);
    TmpJPEG := TJPEGImage.Create;
    LoadJPEGFromRes('CARDBACK', TmpJPEG);
    TheImage.Picture.Bitmap.Assign(TmpJPEG);
    TheImage.Center := TRUE;
    TmpJPEG.Free;
  end;{if}

  if igBaudRate = 19200 then lCommsStatus.Caption := '19200 / Offline'
  else lCommsStatus.Caption := '9600 / Offline';

//  l19200.Visible := (igBaudRate = 19200);
  Caption := 'Exchequer Loyalty ' + WincardVersion + ' - ' + Syss.UserName;
  Application.OnActivate := ApplicationActive;

//  bBitmapExtracted := FALSE;
  SetCommsWorking(bgCommsWorking);

  DisableControls;

  bFormClosing := FALSE;

  HideBkGnd := False;
  InCardList  := False;
  InAutoEOD  := False;
  OldHint := Application.OnHint;
  Application.OnHint := ShowHint;
  Application.Hintpause := 1200;
  OldActive := Screen.OnActiveFormChange;
  Screen.OnActiveFormChange := UpdateMenuItems;
  { Set Tag to 1010, so window can be ID'd uniquely }
  SetWindowLong (Handle, GWL_USERDATA, 1010);

{  if FileExists('CARDBACK.BMP') then Image1.Picture.LoadFromFile('CARDBACK.BMP');}
//  FClientInstance := MakeObjectInstance(ClientWndProc);
//  FPrevClientProc := Pointer(GetWindowLong(ClientHandle, GWL_WNDPROC));
//  SetWindowLong(ClientHandle, GWL_WNDPROC, LongInt(FClientInstance));
//  Set_NonClientInfo;

  { Initialise the resource gauges }
  if (SetDrive = '') then GetDir(0,Cdir)
  else Cdir := SetDrive;

  { Do user configurable tools menu }
  AddUserTools(Menu_Tools);
  screen.cursor := crDefault;
{  ApdStatusLight1.Visible := FrmComms.MPComms.Enabled;
  FrmComms.ApdSLController1.Monitoring := FrmComms.MPComms.Enabled;}
  PostMessage(FrmMain.Handle,WM_FormCloseMsg,131,0);
end;



procedure TfrmMain.Menu_File_ExitClick(Sender: TObject);
begin
  Close;
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

procedure TfrmMain.WMFormCloseMsg(var Message  :  TMessage);
var
  bNewState : boolean;
  iComp : integer;
begin
  case Message.WParam of
    1 : FrmStartUp := nil;
    2 : FrmCardList2 := nil;
    3 : FrmSystemSetup := nil;
    4 : FrmFunctionList := nil;
    5 : FrmPLUList := nil;
    6 : FrmDebugInfo := nil;
    121 : begin
      bNewState := Message.LParam > 0;

      if bNewState then
        begin
          {re-open window}
          case Message.LParam of
            2 : FrmCardList2 := TFrmCardList2.Create(self);
            4 : FrmFunctionList := TFrmFunctionList.Create(self);
            5 : FrmPLUList := TFrmPLUList.Create(self);
          end;{case}
        end
      else begin
        {Close All Open Windows}
        if FrmCardList2 <> nil then FrmCardList2.Close;
        if FrmFunctionList <> nil then FrmFunctionList.Close;
        if FrmPLUList <> nil then FrmPLUList.Close;
      end;

      {grey out all menu items and toolbar buttons}
      For iComp := 0 to (ComponentCount - 1) do begin
        if (Components[iComp] is TMenuItem) then TMenuItem(Components[iComp]).Enabled := bNewState;
        if (Components[iComp] is TToolButton) then TToolButton(Components[iComp]).Enabled := bNewState;
      end;{for}

      if bNewState then DisableControls;
    end;
    131 : ImportFromClub;
  end;{case}
end;
(*
procedure TfrmMain.DrawBkGnd(var Message  :  TMessage);
const
  MAX_NO_OF_IMPORTS_BEFORE_ASKING = 3;
var
  MyDC       : hDC;
  OldPalette : HPalette;
  bitMain : TBitmap;
  TmpJPEG : TJPEGImage;
  ScrnTileRect, ARect, BRect : TRect;
  bSwitchOffBack : boolean;
  iNoOfRecords, iVert, iHoriz : integer;
  ClubFile : TFileStream;
  sClubFileName : string;
begin
  bSwitchOffBack := FALSE;
  if not bBitmapExtracted then begin

    {Load Background JPEG}
    TmpJPEG := TJPEGImage.Create;
    LoadJPEGFromRes('CARDBACK', TmpJPEG);
    BackgroundImage.Picture.Bitmap.Assign(TmpJPEG);

    {create temporary bitmap}
    bitMain := TBitmap.Create;

    {copy palette from loaded bitmap}
    DeleteObject(bitMain.Palette);
    bitMain.Palette := CopyPalette(BackgroundImage.Picture.Bitmap.Palette);

    {assigns the correct dimensions to the temporary bitmap (to fit the current screen)}
    bitMain.Width := ClientWidth;
    bitMain.Height := ClientHeight - StatusPanel{StatusBar}.Height - Coolbar1.height;

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

    Application.ProcessMessages;{fixes first draw of bitmap problem}
    bitMain.Free;
  end;{if}

  MyDC := TWMEraseBkGnd(Message).DC;
  OldPalette := SelectPalette(MyDC,BackgroundImage.Picture.BitMap.Palette,False);
  try
    RealizePalette(MyDC);
    BitBlt(MyDC, 0, 0, BackgroundImage.Picture.Width, BackgroundImage.Picture.Height ,BackgroundImage.Picture.Bitmap.Canvas.Handle
    , 0, 0, SRCCOPY);
  finally
    SelectPalette(MyDC,OldPalette,true);
  end;{try}

  if bSwitchOffBack then begin
    Menu_Help_HideBkgClick(nil);
    Menu_Help_HideBkg.Enabled := FALSE;
  end;{if}

  if not bBitmapExtracted then begin
    bBitmapExtracted := TRUE;

    {Club Import}
    sClubFileName := IncludeTrailingBackslash(Syss.MergePath) + 'CSCHANGE.DAT';
    if FileExists(sClubFileName) then begin
      ClubFile := TFileStream.Create(sClubFileName, fmOpenRead or fmShareDenyNone);
      iNoOfRecords := Round(ClubFile.Size / 256);
      ClubFile.Free;
      if (iNoOfRecords < (MAX_NO_OF_IMPORTS_BEFORE_ASKING + 1))
      or (MsgBox('There are more than ' + IntToStr(MAX_NO_OF_IMPORTS_BEFORE_ASKING)
      + ' Records waiting to be imported from Club Systems.' + #13
      + 'Is is advised that you do not perform this operation whilst your tills are being used.' + #13 + #13
      + 'Do you wish to perform this import now ?',mtConfirmation,[mbYes,mbNo],mbYes
      ,'Club Systems Import') = mrYes)
      then DoClubImport;
    end;{if}
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
    SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,ONCMETRICS,{SPif_SENDWININICHANGE}0);
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
{  BackgroundImage.Free;}
end;

procedure TfrmMain.Menu_Help_HideBkgClick(Sender: TObject);
begin
//  Menu_Help_HideBkg.Checked := not Menu_Help_HideBkg.Checked;
  TheImage.Visible := not Menu_Help_HideBkg.Checked;
  InvalidateRect(0, nil, True);

//  TheImage.Visible := not Menu_Help_HideBkg.Checked;
//  InvalidateRect(0, nil, True);

//  HideBkGnd := not HideBkGnd;
//  InvalidateRect(0, nil, True);
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


procedure TfrmMain.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FrmComms.ApdSLController1.Monitoring := FALSE;
  if not bFormClosing then begin
    bFormClosing := TRUE;
    if FrmCardList2 <> nil then FrmCardList2.Close;
    if FrmFunctionList <> nil then FrmFunctionList.Close;
    if FrmPLUList <> nil then FrmPLUList.Close;

    {Sleuth}
    if FrmComms <> nil then begin
      FrmComms.Release;
      FrmComms := nil;
    end;{if}

    Application.ProcessMessages; {so it doesn't crash hideously !}
//    Reset_NonClientInfo;
  end;{if}

  {if Syss.UpWrite then Write_ClubFile(3);}

  if Not Syss.UsingCardToolkit then Write_ClubFile(3);
end;

procedure TfrmMain.DisplayCardList(Sender: TObject);
begin
  if FrmCardList2 = nil then FrmCardList2 := TFrmCardList2.Create(self);
end;

procedure TfrmMain.Menu_Tools_OptionsClick(Sender: TObject);
var
  ToolsOptions : TToolsOptions;
begin
  ToolsOptions := TToolsOptions.Create(Self);
  ToolsOptions.OnUpdateTools := UpdateToolsMenu;
end;

procedure TfrmMain.UpdateToolsMenu(Sender: TObject);
begin
  { add on current tools }
  AddUserTools(Menu_Tools);
end;

procedure TfrmMain.AutomaticEndOfDay1Click(Sender: TObject);
var
  FrmAutoEOD: TFrmAutoEOD;
begin
  Hide;
  try
    FrmAutoEOD := TFrmAutoEOD.Create(Self);
    FrmAutoEOD.ShowModal;
  finally
    FrmAutoEOD.Release;
  end;{try}
  Show;
end;

procedure TfrmMain.Menu_Utils_SysSetupClick(Sender: TObject);
begin
  if FrmSystemSetup = nil then FrmSystemSetup := TFrmSystemSetup.Create(self);
  FrmSystemSetup.ShowModal;
  DisableControls;
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

procedure TfrmMain.CommandList1Click(Sender: TObject);
begin
  FrmComms.MpComms.ShowCommandList;
end;

procedure TfrmMain.CommsDebug1Click(Sender: TObject);
begin
  FrmComms.MPComms.ShowCommsDebug;
end;


procedure TfrmMain.CheckComms(bAutoCont : boolean; Sender: TObject);
begin
  if Live then begin
    {check till comms}
    try
      FrmStartUp := TFrmStartUp.Create(self);
      FrmStartUp.ShowModal;
    finally
      FrmStartUp.Release
    end;{try}
  end;{if}
{  FrmComms.MPComms.Enabled := bgCommsWorking;}
{  if bgCommsWorking then StatusBar.Panels[0].Text := 'Live'
  else StatusBar.Panels[0].Text := 'Offline'}

  if igBaudRate = 19200 then lCommsStatus.Caption := '19200 / '
  else lCommsStatus.Caption := '9600 / ';

  if bgCommsWorking then lCommsStatus.Caption := lCommsStatus.Caption  + 'Live'
  else lCommsStatus.Caption := lCommsStatus.Caption  + 'Offline';

end;

procedure AskForLogin;
begin
  {Set Globals}
  setlength(agBalances,Syss.NoTills + 1);

  if not HasCodeExpired then
    begin
      FrmComms := TFrmComms.Create(Application);
      with FrmStartUp do begin
        if Live then begin
          {check till comms}
          FrmStartUp := TFrmStartUp.Create(application);
          try
            if LoginMode in [lmDebug, lmUser] then ShowModal
            else CheckForTills;
          finally
            FrmStartUp.Release;
            FrmStartUp := nil;
          end;{try}
        end;{if}
      end;{with}
    end
  else Halt;
end;

procedure TfrmMain.CheckTillComms1Click(Sender: TObject);
begin
  CheckComms(FALSE, Sender);
  DisableControls;
end;

procedure TfrmMain.EndOfDay1Click(Sender: TObject);
var
  iRunNo : Integer;
begin
  if MsgBox('Please confirm that you wish to end the day for ' + POutDate(Today)
  ,mtConfirmation,[mbYes,mbNo],mbNo,'End of Day') = mrYes then EndOfDay(iRunNo, FALSE, nil);
end;

procedure TfrmMain.ImportfromClubSystems1Click(Sender: TObject);
begin
  if MsgBox('Are you sure you want to run the import procedure now ?',mtConfirmation
  ,[mbYes,mbNo],mbNo,'Import') = mrYes then begin
    case TWinControl(Sender).Tag of
      1: begin {Import}
        If (Live) or (SBSIn) then
          begin
            {$IFDEF CS}
              Process_ClubFile(7)
            {$ELSE}
              Process_ClubFile(3)
            {$ENDIF}
          end
        else {Warn_Beep};
      end;{if}

      2 : begin {With Balances}
        If Live and SBSIn Then
          Begin
            If SBSIn then Process_ClubFile(4)
            Else Process_ClubFile(2);
          End { If }
        Else {Warn_Beep};
      end;

      3: begin {With Full Name}
        If SBSIn then Process_ClubFile(7);
      end;
    end;{case}
  end;{if}
end;

procedure TfrmMain.ExporttoClubSystem1Click(Sender: TObject);
begin
  if MsgBox('Are you sure you want to mark all your cards for export ?',mtConfirmation
  ,[mbYes,mbNo],mbNo,'Export') = mrYes then MarkCards;
end;

procedure TfrmMain.CardList1Click(Sender: TObject);
begin
  with TFrmPrintCardList.Create(Application) do begin
    try
      if ShowModal = mrOK then begin
        ModReports.PrintCardList(TReportOrder(Ord(rbCardName.Checked)));
      end;{if}
    finally
      Release;
    end;{try}
  end;{with}
end;

procedure TfrmMain.BadTillCardList1Click(Sender: TObject);
begin
  ModReports.PrintDuffTillLog(FALSE);
end;

procedure TfrmMain.EndofDayErrorLog1Click(Sender: TObject);
begin
  ModReports.PrintEODError;
end;

procedure TfrmMain.CardsOnHold2Click(Sender: TObject);
var
  FrmHeldCardsList: TFrmHeldCardsList;
begin
  FrmHeldCardsList := TFrmHeldCardsList.Create(Application);
  try
    FrmHeldCardsList.ShowModal;
  finally
    FrmHeldCardsList.Release;
  end;{try}
end;

procedure TfrmMain.tbFunctionBookClick(Sender: TObject);
begin
  if FrmFunctionList = nil then FrmFunctionList := TFrmFunctionList.Create(self);
end;

procedure TfrmMain.FunctionBooking2Click(Sender: TObject);
var
  FrmProcessFunction : TFrmProcessFunction;
begin
  FrmProcessFunction := TFrmProcessFunction.Create(Self);
  Try
    with FrmProcessFunction do begin
      FuncFormMode := fmPrint;
      ShowModal;
    end;{with}
  Finally
    FrmProcessFunction.Release;
  End;
end;

procedure TfrmMain.Menu_Records_GroupsClick(Sender: TObject);
begin
  if FrmPLUList = nil then FrmPLUList := TFrmPLUList.Create(self);
end;

procedure TfrmMain.TechSupportLog1Click(Sender: TObject);
begin
  ModReports.PrintTechSuppLog;
end;

procedure TfrmMain.ResetTechSupportLog1Click(Sender: TObject);
begin
  if MsgBox('Are you sure you want to reset the Tech. Support Log ?',mtConfirmation,[mbYes,mbNo],mbNo
  ,'Reset Log') = mrYes then DeleteFile(sTechSupportLogFile);
end;

procedure TfrmMain.CardTurnover1Click(Sender: TObject);
var
  FrmDateRange : TFrmDateRange;
begin
  FrmDateRange := TFrmDateRange.Create(fmCardTurnover);
  try
    with FrmDateRange do begin
      sStartDate := DateToStr8(Now - 364);
      sEndDate := DateToStr8(Now);
      ShowModal;
    end;{with}
  finally
    FrmDateRange.Release;
  end;{try}
end;

procedure TfrmMain.LedgerHistory1Click(Sender: TObject);
var
  FrmDateRange : TFrmDateRange;
begin
  FrmDateRange := TFrmDateRange.Create(fmLedgerHistory);
  try
    with FrmDateRange do begin
      sStartDate := DateToStr8(Now - 364);
      sEndDate := DateToStr8(Now);
      ShowModal;
    end;{with}
  finally
    FrmDateRange.Release;
  end;{try}
end;

procedure TfrmMain.DisableControls;
begin
  tbEOD.Enabled := bgCommsWorking and (LoginMode <> lmOperator);
  EndOfDay1.Enabled := bgCommsWorking and (LoginMode <> lmOperator);

  tbAEOD.Enabled := bgCommsWorking and ((LoginMode <> lmOperator) or ((LoginMode = lmOperator) and Syss.OpoDoAutoEOD));
  AutomaticEndOfDay1.Enabled := bgCommsWorking and ((LoginMode <> lmOperator) or ((LoginMode = lmOperator) and Syss.OpoDoAutoEOD));

  ProgramTills1.Enabled := bgCommsWorking and (LoginMode <> lmOperator);
  Menu_Utils_SysSetup.Enabled := LoginMode <> lmOperator;
  tbSysSetup.Enabled := LoginMode <> lmOperator;

  tbMarkCards.Enabled := (LoginMode <> lmOperator);
  ExporttoClubSystem1.Enabled := (LoginMode <> lmOperator);

  CheckTillComms1.Enabled := Live;
  Debug1.Visible := LoginMode in [lmDebug, lmUser];
  TechSupportLog1.Visible := LoginMode in [lmDebug, lmUser];
  TechSupportLog2.Visible := LoginMode in [lmDebug, lmUser];
  ResetTechSupportLog1.Visible := LoginMode in [lmDebug, lmUser];
  Menu_Utils_ResetBadTill.Visible := LoginMode in [lmDebug, lmUser, lmMaster];

  SuspendAllCards1.Enabled := bgCommsWorking and (LoginMode in [lmDebug, lmUser]);
  UnsuspendAllCards1.Enabled := bgCommsWorking and (LoginMode in [lmDebug, lmUser]);
{  CheckAllAccountBalances1.Enabled := bgCommsWorking;}
  Import1.Enabled := LoginMode in [lmDebug, lmUser];

  CustFbyCustCodeK1.Enabled := LoginMode = lmDebug;
  CustFbyCustCodeK2.Enabled := LoginMode = lmDebug;

  ConverttoSplitDiscount1.Enabled := LoginMode = lmDebug;
  ConvertfromSplitDiscount1.Enabled := LoginMode = lmDebug;
  EndOfYear1.Enabled := LoginMode = lmDebug;

  {grey out Till Sales reports}
  TillReports1.Enabled := Syss.EODTillReps;
  PLUSales1.Visible := Syss.EODTillReps;
  TillGroupSales1.Visible := Syss.EODTillReps;
  HourlySales1.Visible := Syss.EODTillReps;
  ClerkSales1.Visible := Syss.EODTillReps;
  TransactionTotals2.Visible := Syss.EODTillReps;

  OpenTables1.Enabled := bgCommsWorking;
  OpenTables2.Enabled := bgCommsWorking;
end;

procedure TfrmMain.ReprogSelectedTills(Sender: TObject);
var
  iMode : byte;
  WizReprogTills : TWizReprogTills;
begin
  iMode := TWinControl(Sender).Tag;
  try
    WizReprogTills := TWizReprogTills.Create(Self);
    with WizReprogTills do begin
      bDoDetails := iMode in [1,2];
      bDoBalances := iMode in [1,3];
      if ShowModal = mrOK then ReprogramTills(bDoDetails, bDoBalances, aiTillsToSendTo, iProgTillNo);
    end;{with}
  finally
    WizReprogTills.Release;
  end;{try}
end;

procedure TfrmMain.ProgramAllTills(Sender: TObject);
var
  aiTillsToSendTo : array of byte;
  iMode, iPos : byte;
begin
  if MsgBox('Are you sure you want to reprogram all your tills ?',mtconfirmation
  , [mbYes,mbNo],mbNo,'Reprogram Tills ?') = mrYes then begin
    setlength(aiTillsToSendTo, Syss.NoTills);
    For iPos := low(aiTillsToSendTo) to low(aiTillsToSendTo) do aiTillsToSendTo[iPos] := iPos + 1;
    iMode := TWinControl(Sender).Tag;
    ReprogramTills((iMode in [1,2]), (iMode in [1,3]), aiTillsToSendTo, 0);
  end;{if}
end;

procedure TfrmMain.Menu_Utils_ResetBadTillClick(Sender: TObject);
begin
  if MsgBox('Are you sure you want to reset the Bad Till Log ?',mtConfirmation,[mbYes,mbNo],mbNo
  ,'Reset Log') = mrYes then DeleteFile(sDuffTillLogFile);
end;

procedure TfrmMain.SuspendAllCards1Click(Sender: TObject);
var
  sOperation : string;
begin
  case TWinControl(Sender).Tag of
    0 : sOperation := ' clear holds on all cards ?';
    5 : sOperation := ' suspend all cards ?';
  end;{case}
  if MsgBox('Are you sure you want to' + sOperation,mtConfirmation,[mbYes,mbNo],mbNo
  ,'Suspend Cards') = mrYes then SuspendCards(TWinControl(Sender).Tag);
end;

procedure TfrmMain.DebugInfo1Click(Sender: TObject);
begin
  if FrmDebugInfo = nil then FrmDebugInfo := TFrmDebugInfo.Create(self);
end;

procedure TfrmMain.Utilities1Click(Sender: TObject);
var
  FrmUtilities : TFrmUtilities;
begin
  try
    FrmUtilities := TFrmUtilities.Create(application);
    FrmUtilities.ShowModal;
  finally
    FrmUtilities.Release;
  end;{try}
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

function HasCodeExpired : boolean;
var
  Rd,Rm,Ry : word;
  RelDateStr : longdate;
  SecDays : integer;
  RelDOW : byte;
  CurrTime : TimeTyp;
  bResult : boolean;
begin
  bResult := FALSE;
  if not FullyReleased then begin
    with Syss do begin
      JulCal(RelDate,Rd,Rm,Ry);
      if Ry < 200 then Ry := Ry + 1900;
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
  Result := bResult;
end;

procedure TfrmMain.RunNoRangeReport(Sender: TObject);
var
  FrmRunNoRange: TFrmRunNoRange;
begin
  FrmRunNoRange := TFrmRunNoRange.Create(Application);
  try
    with FrmRunNoRange do begin
      case TWinControl(Sender).Tag of
        1 : RangeFormMode := fmPosting;
        2 : RangeFormMode := fmPostingDetail;
        3 : RangeFormMode := fmGroupSales;
        4 : RangeFormMode := fmEODReports;
        5 : RangeFormMode := fmPLUSales;
        6 : RangeFormMode := fmNewTillGroupSales;
        7 : RangeFormMode := fmHourlySales;
        8 : RangeFormMode := fmClerkSales;
        9 : RangeFormMode := fmTXTotalisers;
        10 : RangeFormMode := fmAllTillReports;
      end;{case}
      ShowModal;
    end;{with}
  finally
    FrmRunNoRange.Release;
  end;{try}
end;

procedure TfrmMain.ApplicationActive(Sender  :  TObject);
Var
  Message  :  TMessage;
Begin
  if not bFormClosing then begin
    FillChar(Message,Sizeof(Message),0);
//    ResetPalette(Message);
    MDI_ForceParentBKGnd(BOn);
  end;{if}
end;

procedure TfrmMain.CommslogViewer1Click(Sender: TObject);
begin
  with TfrmCommslogViewer.Create(application) do begin
    try
      ShowModal;
    finally
      Release;
    end;{try}
  end;{with}
end;

procedure TfrmMain.tillsaledump(Sender: TObject);
var
  ExLocal : TdExLocal;
  TheKey : Str255;
  iStatus : integer;
  sLine : string;
  cLastType : char;
begin
  screen.cursor := crHourglass;

  cLastType := 'X';

  ExLocal.Create;
  With ExLocal Do Begin

    DeleteFile('TillSale.Txt');

    { Build key }
    FillChar(TheKey,SizeOf(TheKey),#0);

    { Get first record }
    iStatus := Find_Rec(B_GetFirst, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, TWinControl(Sender).Tag, TheKey);
    LGetRecAddr(TillSalesF);

    While (iStatus = 0) do begin


      with LTillSales do begin

        if cLastType <> tsType then begin
          case tsType of
            'C' : begin {clerk sales}
              AddLineToFile(' ', 'TillSale.Txt');
              AddLineToFile('Type ClerkNo RunNo   DataType TillNo Qty     Amount    Descript', 'TillSale.Txt');
              AddLineToFile('---------------------------------------------------------------', 'TillSale.Txt');
            end;

            'P' : begin {PLU sales}
              AddLineToFile(' ', 'TillSale.Txt');
              AddLineToFile('Type GroupNo PLUNo   RunNo   TillNo Qty     Amount    Description     ', 'TillSale.Txt');
              AddLineToFile('----------------------------------------------------------------------', 'TillSale.Txt');
            end;

            'H' : begin {clerk sales}
              AddLineToFile(' ', 'TillSale.Txt');
              AddLineToFile('Type HourNo  RunNo   TillNo Qty     Amount    ', 'TillSale.Txt');
              AddLineToFile('----------------------------------------------', 'TillSale.Txt');
            end;

            'T' : begin {clerk sales}
              AddLineToFile(' ', 'TillSale.Txt');
              AddLineToFile('Type TillNo RunNo   TransNo Qty     Amount    ', 'TillSale.Txt');
              AddLineToFile('----------------------------------------------', 'TillSale.Txt');
            end;
          end;{case}
        end;{if}

        sLine := PadString(psRight,tsType,' ',5) {+ PadString(psRight,tsIndex1,' ',20)};
        case tsType of
          'C' : begin {clerk sales}
            with tsClerk do begin
              sLine := sLine + PadString(psRight,IntToStr(tcClerkNo),' ',8)
              + PadString(psRight,IntToStr(tcRunNo),' ',8)
              + PadString(psRight,IntToStr(tcDataType),' ',9)
              + PadString(psRight,IntToStr(tcTillNo),' ',7)
              + PadString(psRight,MoneyToStr(tcQty),' ',8)
              + PadString(psRight,MoneyToStr(tcAmount),' ',10)
              + PadString(psRight,tcDescription,' ',8)
{              + PadString(psRight,tcSpare,' ',9)
              + PadString(psRight,tcIndex2,' ',20)}
            end;{with}
          end;

          'P' : begin {PLU Sales}
            with tsPLU do begin
{              sLine := sLine + tsIndex1;}
              sLine := sLine + PadString(psRight,IntToStr(tpGroupNo),' ',8)
              + PadString(psRight,IntToStr(tpPLUNo),' ',8)
              + PadString(psRight,IntToStr(tpRunNo),' ',8)
              + PadString(psRight,IntToStr(tpTillNo),' ',7)
              + PadString(psRight,MoneyToStr(tpQty),' ',8)
              + PadString(psRight,MoneyToStr(tpAmount),' ',10)
              + PadString(psRight,tpDescription,' ',16)
{              + PadString(psRight,tpIndex2),' ',20)}
            end;{with}
          end;

          'H' : begin {Hourly Sales}
            with tsHourly do begin
              sLine := sLine + PadString(psRight,IntToStr(thHourNo),' ',8)
              + PadString(psRight,IntToStr(thRunNo),' ',8)
              + PadString(psRight,IntToStr(thTillNo),' ',7)
              + PadString(psRight,MoneyToStr(thQty),' ',8)
              + PadString(psRight,MoneyToStr(thAmount),' ',10)
{              thSpare : array[1..19] of byte;
              thIndex2 : String20;}
            end;{with}
          end;

          'T' : begin {transaction data}
            with tsTrans do begin
              sLine := sLine + PadString(psRight,IntToStr(ttTillNo),' ',7)
              + PadString(psRight,IntToStr(ttRunNo),' ',8)
              + PadString(psRight,IntToStr(ttTransNo),' ',8)
              + PadString(psRight,MoneyToStr(ttQty),' ',8)
              + PadString(psRight,MoneyToStr(ttAmount),' ',10)
{              ttSpare : array[1..18] of byte;
              ttIndex2 : String20;}
            end;{with}
          end;
        end;
        cLastType := tsType
      end;

      AddLineToFile(sLine, 'TillSale.Txt');

      {next record}
      iStatus := Find_Rec (B_GetNext, F[TillSalesF], TillSalesF, LRecPtr[TillSalesF]^, TWinControl(Sender).Tag, TheKey);
      LGetRecAddr(TillSalesF);
    end;{while}
    Destroy;
  end;{with}
  screen.cursor := crDefault;
  showmessage('File Dump (TillSale.Txt) completed.');
end;

Procedure TfrmMain.DoClubImport;
begin
  {$IFDEF Cu_On}
    If (Live) or (SBSIn) then begin
      {$IFDEF CS}
        Refresh;
        Set_CSRead;
        If (Syss.UpRead) then Process_ClubFile(3);
        Process_ClubPayFile(3);   {* Check for any payment files *}
      {$ELSE}
        Process_ClubFile(3);  {* Change 4 to a 3 Auto Get Card Details *}
      {$ENDIF}
    end;
  {$ENDIF}
end;


procedure TfrmMain.Import1Click(Sender: TObject);
begin
  DoClubImport;
end;

procedure TfrmMain.CheckAllAccountBalances1Click(Sender: TObject);
var
  ExLocal : TdExLocal;
  iStatus : smallint;
  KeyS : str255;
  FrmProgress : TFrmProgress;
  bLock : boolean;
begin
  if MsgBox('Are you sure you want to Check all the account balances ?',mtConfirmation,[mbYes,mbNo],mbNo
  ,'Check Balances') = mrYes then begin
    if bgCommsWorking then
      begin
        TechSuppLog('Check all accounts run');
        screen.cursor := crHourglass;
        SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);
        ExLocal.Create;

        try
          FrmProgress := TFrmProgress.Create(application);
          with FrmProgress do begin
            Caption := 'Checking All Account Balances...';
            Show;
            ProgressBar1.Position := 0;
            ProgressBar1.Max := Used_Recs(F[CustF], CustF);
            FrmProgress.lStatus.Caption := 'Processing Card';
            Refresh;
          end;{with}
          { Get first record }
          Blank(KeyS,SizeOf(KeyS));
          iStatus := Find_Rec (B_GetGEq, F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK,KeyS);
          ExLocal.LGetRecAddr(CustF);

          With ExLocal, LCust, LInv Do Begin
            While (iStatus = 0) do begin
              FrmProgress.lName.Caption := CardFullName(LCust, True, True);
              FrmProgress.lName.Refresh;

              if LockRecord(CustF, CustCodeK, ExLocal, TRUE) then begin
                CurrBalance := 0;
                CPaid := 0;
                CSpent := 0;

                KeyS := ExLocal.LCust.CustCode;
                iStatus := Find_Rec(B_GetGEq,F[InvF],InvF,LRecPtr[InvF]^,InvCustK,KeyS);
                while (iStatus = 0) and (Copy(KeyS,1,6) = ExLocal.LCust.CustCode) do begin
                  CalcCustBals(LCust, LInv);

                  ChangeFlag := 3;
                  KeyS := ExLocal.LCust.CustCode;
                  iStatus := Find_Rec(B_GetNext,F[InvF],InvF,LRecPtr[InvF]^,InvCustK,KeyS);
                end;{while}
                CPaid := CPaid;
                CSpent := CSpent;
                CurrBalance := CurrBalance;
                iStatus := Put_Rec(F[CustF],CustF,LRecPtr[CustF]^,CustCodeK); {save cust record}

                LockRecord(CustF, CustCodeK, ExLocal, FALSE); {unlock cust record}
                Report_BError(CustF, iStatus);

                {set the Club2000 export flag}
                bLock := TRUE;
                GetMultiSys(TRUE, bLock);
                Syss.UpWrite := TRUE;
                PutMultiSys(TRUE);

  {              SendMessage(TForm(Owner).Handle,WM_CustGetRec,1,0); {refresh screen}
              end;{if}

              { Get next record }
              iStatus := Find_Rec (B_GetNext{B_GetGretr}, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
              LGetRecAddr(CustF);
              FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Position + 1;
            end;{while}
          end;{with}
        finally
          FrmProgress.Release;
        end;{try}
        SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);

        ExLocal.Destroy; {destroy local record instance}
        screen.cursor := crDefault;
      end
    else TillCommsError;
  end;{if}
end;

procedure TfrmMain.AllowCreditonallcards1Click(Sender: TObject);
begin
  if MsgBox('Are you sure you want to set the Unlimited Credit flag on all cards ?',mtConfirmation
  ,[mbYes,mbNo],mbNo,'Suspend Cards') = mrYes then SetCreditOnCards(TRUE);
end;

procedure TfrmMain.DisallowCreditonallcards1Click(Sender: TObject);
begin
  if MsgBox('Are you sure you want to reset the Unlimited Credit flag on all cards ?',mtConfirmation
  ,[mbYes,mbNo],mbNo,'Suspend Cards') = mrYes then SetCreditOnCards(FALSE);

end;

procedure TfrmMain.OpenTables2Click(Sender: TObject);
begin
  with TfrmOpenTablesRep.create(application) do begin
    try
      if showmodal = mrOK then begin
        {run report}
        with ModReports do begin
          SetRunNumbers(iStart, iEnd);
          PrintOpenTables(cbHideZeros.checked);
        end;{with}
      end;{if}
    finally
      release;
    end;{try}
  end;{with}
end;

procedure TfrmMain.SizeImage(AnImage: TImage);
begin
  AnImage.Top := 0;
  AnImage.Left := 0;
  AnImage.Width := ClientWidth;
  AnImage.Height := ClientHeight - StatusPanel.Height - 4;
end;

procedure TfrmMain.CustFbyCustCodeK1Click(Sender: TObject);
begin
  ModReports.PrintCardFbyCustCodeK;
end;

procedure TfrmMain.ConvertBalances(Sender: TObject);
begin
  ConvertCardBalances(TWinControl(Sender).Tag);
end;

procedure TfrmMain.ImportFromClub;
const
  MAX_NO_OF_IMPORTS_BEFORE_ASKING = 3;
var
  sClubFileName : string;
  ClubFile : TFileStream;
  iNoOfRecords : integer;
begin{ImportFromClub}
  {Club Import}
  sClubFileName := IncludeTrailingBackslash(Syss.MergePath) + 'CSCHANGE.DAT';
  if FileExists(sClubFileName) then begin
    ClubFile := TFileStream.Create(sClubFileName, fmOpenRead or fmShareDenyNone);
    iNoOfRecords := Round(ClubFile.Size / 256);
    ClubFile.Free;
    if (iNoOfRecords < (MAX_NO_OF_IMPORTS_BEFORE_ASKING + 1))
    or (MsgBox('There are more than ' + IntToStr(MAX_NO_OF_IMPORTS_BEFORE_ASKING)
    + ' Records waiting to be imported from Club Systems.' + #13
    + 'Is is advised that you do not perform this operation whilst your tills are being used.' + #13 + #13
    + 'Do you wish to perform this import now ?',mtConfirmation,[mbYes,mbNo],mbYes
    ,'Club Systems Import') = mrYes)
    then DoClubImport;
  end;{if}
end;{ImportFromClub}

procedure TfrmMain.EndofYear1Click(Sender: TObject);
begin
  with TfrmEOY.create(application) do begin
    try
      showmodal;
    finally
      release;
    end;{try}
  end;{with}
end;

procedure TfrmMain.DumpSaleItem(Sender: TObject);
const
  sExportFile = 'SaleItem.Txt';
var
  ExLocal : TdExLocal;
  TheKey : Str255;
  iStatus : integer;
  sLine : string;
begin
  screen.cursor := crHourglass;

  ExLocal.Create;
  With ExLocal Do Begin

    DeleteFile(sExportFile);

    { Build key }
    FillChar(TheKey,SizeOf(TheKey),#0);

    { Get first record }
    iStatus := Find_Rec(B_GetFirst, F[ItemF], ItemF, LRecPtr[ItemF]^, TWinControl(Sender).Tag, TheKey);
    LGetRecAddr(ItemF);

    AddLineToFile('Type Number Group Name                          Override Discount Price', sExportFile);
    AddLineToFile('-----------------------------------------------------------------------', sExportFile);

    While (iStatus = 0) do begin
      with LItemRec do begin
        sLine := PadString(psRight,siType,' ',5)
        + PadString(psRight,IntToStr(siNumber),' ',7)
        + PadString(psRight,IntToStr(siGroup),' ',6)
        + PadString(psRight,siName,' ',30)
        + PadString(psRight,GetYNFromBool(siOverride),' ',9)
        + PadString(psRight,MoneyToStr(siDiscount),' ',9)
        + PadString(psRight,MoneyToStr(siPrice),' ',6);
        AddLineToFile(sLine, sExportFile);
      end;{with}

      {next record}
      iStatus := Find_Rec (B_GetNext, F[ItemF], ItemF, LRecPtr[ItemF]^, TWinControl(Sender).Tag, TheKey);
      LGetRecAddr(ItemF);
    end;{while}
    Destroy;
  end;{with}
  screen.cursor := crDefault;
  showmessage('File Dump (' + sExportFile + ') completed.');
end;

procedure TfrmMain.ToolButton1Click(Sender: TObject);
var
  FrmCardList3 : TFrmCardList3;
begin
  FrmCardList3 := TFrmCardList3.Create(self);
end;

Initialization
  sEXEDir := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
  if IsAppAlreadyRunning('WindowsCardSystem') then
    begin
      oDLL.Opened := FALSE;
    end
  else begin
    ExitSave := ExitProc;
    ExitProc := @Ex_Abort;
    if CheckPrintersOK then
      begin
        if oDLL.Opened then AskForLogin;
      end
    else Halt;
    oEnterprise := TOEnterprise.Create;
  end;{if}

finalization
  oEnterprise.Free;

end.
