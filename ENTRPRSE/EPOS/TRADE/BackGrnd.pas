unit BackGrnd;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


/////////////////////////////////////////////////////////////////
// Note: This form also handles the messaging for the printing //
/////////////////////////////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , RunWarn, ExtCtrls, GlobType, jpeg;

type
  TFrmBackground = class(TForm)
    BackgroundImage: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    ONCMetrics, NCMetrics : PNonClientMetrics;
    FPrevClientProc, FClientInstance : TFarProc;
    bBitmapExtracted : Boolean;
    bitMain : TBitmap;
    procedure Reset_NonClientInfo;
    procedure Set_NonClientInfo;
    procedure PrintProgress(var Msg: TMessage); message WM_PrintProgress;
    procedure WMQueryNewPalette(var Message  :  TMessage); Message WM_QueryNewPalette;
    procedure WMPaletteChanged(var Message  :  TMessage); Message WM_PaletteChanged;
{    procedure WMKeyDown(var Message  :  TMessage);}
  public
    { Public declarations }
    procedure DrawBackGround(var Message  :  TMessage);
    procedure ResetPalette(var Message  : TMessage);
    procedure ClientWndProc(var Message: TMessage);
    procedure Refresh(Sender: TObject);
    procedure ApplicationActive(Sender  :  TObject);
  end;


var
  FrmBackground: TFrmBackground;

implementation
uses
  FileUtil, Login, APIUtil, EPOSCnst, EPOSProc, BTSupU2, GlobVar, BtrvU2, GfxUtil, ExchequerRelease;

{$R *.DFM}
{$R EXCHBACK.RES}

procedure TFrmBackground.FormShow(Sender: TObject);
begin
  WindowState := wsMaximized;
end;

procedure TFrmBackground.PrintProgress(var Msg: TMessage);
begin
  With Msg Do Begin
    { Mode passes in WParam }
    Case WParam Of
      { Check InPrint Flag }
      4 : SendMessage(LParam,WM_InPrint,Ord(False),0);
    End; { Case }
  End; { With }
end;


procedure TFrmBackground.FormCreate(Sender: TObject);
begin
  Application.OnActivate := ApplicationActive;

  bBitmapExtracted := FALSE;

  {create temporary bitmap}
  bitMain := TBitmap.Create;

  Caption := 'Exchequer Trade Counter - ' + ExchequerModuleVersion (emTradeCounter, sTCMVersionNumber);

  SetWindowLong (Handle, GWL_USERDATA, 1010);
  FClientInstance := MakeObjectInstance(ClientWndProc);
  FPrevClientProc := Pointer(GetWindowLong(ClientHandle, GWL_WNDPROC));
  SetWindowLong(ClientHandle, GWL_WNDPROC, LongInt(FClientInstance));

//  bRunningFromCentral := UpperCase(IncludeTrailingPathDelimiter(ExtractFilePath(Paramstr(0))))
//  = UpperCase(IncludeTrailingPathDelimiter(GetEnterpriseDirectory) + 'TRADE\');

//  Set_NonClientInfo;
end;

procedure TFrmBackground.DrawBackGround(var Message  :  TMessage);
var
  MyDC       : hDC;
  OldPalette : HPalette;
  ScrnTileRect, ARect, BRect : TRect;
  TmpJPEG : TJPEGImage;
{  bSwitchOffBack : boolean;}
  {iNoOfRecords,} iVert, iHoriz : integer;
{  ClubFile : TFileStream;}
{  sClubFileName : string;}
{  sKey : str255;
  iStatus : smallint;}
begin
{  bSwitchOffBack := FALSE;}
  if SysColorMode in ValidColorSet then begin
    if not bBitmapExtracted then begin

      {Get System Setup record
      sKey := 'S';
      iStatus := Find_Rec(B_GetGEq, F[EposF], EposF, RecPtr[EposF]^, 0, sKey);
      SetupRecord := EposRec.EposSetup;}

      {Load Background JPEG}
      TmpJPEG := TJPEGImage.Create;
      if LoadJPEGFromRes(sBackground, TmpJPEG) then begin

        BackgroundImage.Picture.Bitmap.Assign(TmpJPEG);

        {copy palette from loaded bitmap}
        DeleteObject(bitMain.Palette);
        bitMain.Palette := CopyPalette(BackgroundImage.Picture.Bitmap.Palette);

        {assigns the correct dimensions to the temporary bitmap (to fit the current screen)}
        bitMain.Width := ClientWidth;
        bitMain.Height := ClientHeight {- StatusBar.Height - Coolbar1.height};

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

      end;{if}
    end;{if}

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
    end;{if}
  end;{if}
end;

procedure TFrmBackground.ClientWndProc(var Message: TMessage);
begin
  with Message do
  begin
{    ReDrawBk:=((Msg=WM_HSCROLL) or (Msg=WM_VSCROLL));
    if (not HideBkGnd) and (Not TKSysRec.HideEXLogo) then
      begin}
        case Msg of
          WM_ERASEBKGND : begin
            DrawBackGround(Message);
            Result := 1;
          end;

{          WM_KEYDOWN : WMKeyDown(Message);}

          WM_VSCROLL, WM_HSCROLL : begin
{            InvalidateRect(ClientHandle, nil, True);}
             DrawBackGround(Message);
{            Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);}
          end;

          WM_QUERYNEWPALETTE : ResetPalette(Message);

          WM_PALETTECHANGED : begin
            if (WParam <> Self.Handle) then ResetPalette(Message);
{            else Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);}
          end;

        end;{case}
{      end
    else begin
      case Msg of
        WM_KEYDOWN : WMKeyDown(Message);
      else Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);
      end;{case}
{    end;{if}
  end;{with}
end;

procedure TFrmBackground.ResetPalette(var Message  : TMessage);
var
  MyDC       : hDC;
  OldPalette : HPalette;
begin
(*  if SysColorMode in ValidColorSet then begin
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
  end;*)
end;

procedure TFrmBackground.WMQueryNewPalette(var Message  :  TMessage);
begin
  {ResetPalette(Message);}
end;

procedure TFrmBackground.WMPaletteChanged(var Message  :  TMessage);
begin
{ if (Message.WParam <> Self.Handle) then ResetPalette(Message);}
end;


procedure TFrmBackground.Set_NonClientInfo;
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

procedure TFrmBackground.Reset_NonClientInfo;
begin
  if (Assigned(ONCMetrics)) then begin
    SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,ONCMETRICS,{SPif_SENDWININICHANGE}0);
    Dispose(ONCMetrics);
    ONCMetrics := nil;
    Dispose(NCMetrics);
    NCMetrics := nil;
  end;{if}
end;


procedure TFrmBackground.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveFormChange := nil;
//  Reset_NonClientInfo;
  bitMain.Free;
end;

procedure TFrmBackground.ApplicationActive(Sender  :  TObject);
Var
  DummyMessage  :  TMessage;
Begin
{  FillChar(DummyMessage,Sizeof(DummyMessage),0);
  ResetPalette(DummyMessage);
  MDI_ForceParentBKGnd(TRUE);}
end;

{procedure TFrmBackGrnd.WMKeyDown(var Message  :  TMessage);
begin
  Inherited;
end;}

procedure TFrmBackground.Refresh(Sender: TObject);
Var
  DummyMessage  :  TMessage;
Begin
{  FillChar(DummyMessage,Sizeof(DummyMessage),0);
  DummyMessage.Msg := WM_VSCROLL;
  FrmBackground.ClientWndProc(DummyMessage);}
end;

initialization
  bRunningFromCentral := UpperCase(IncludeTrailingPathDelimiter(ExtractFilePath(Paramstr(0))))
  = UpperCase(IncludeTrailingPathDelimiter(GetEnterpriseDirectory) + 'TRADE\');

//  if bRunningFromCentral then showmessage('x');
  if bRunningFromCentral then
  begin
    With TfrmRunWarning.Create(application) do begin
      ShowModal;
      Release;
    end;{with}
    halt;
  end;

end.


