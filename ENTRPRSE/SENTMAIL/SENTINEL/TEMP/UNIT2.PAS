unit UMain;

interface

uses
  Windows, Messages, Classes, SysUtils, Graphics, Controls, Forms,
Dialogs,
  ExtCtrls, Menus;

type
  TfrmMain = class(TForm)
    mnuMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    imgTile: TImage;
    mnuOptions: TMenuItem;
    mnuBitmap: TMenuItem;
    mnuGradient: TMenuItem;
    procedure mnuExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuBitmapClick(Sender: TObject);
    procedure mnuGradientClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
    MDIDefProc:pointer;
    MDIInstance:TFarProc;
    procedure MDIWndProc(var prmMsg:TMessage);
    procedure CreateWnd;override;
    procedure ShowBitmap(prmDC:hDC);
    procedure ShowGradient(prmDC:hDC;prmRed,prmGreen,prmBlue:byte);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  glbImgWidth:integer;
  glbImgHeight:integer;

implementation

{$R *.DFM}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
 glbImgHeight:=imgTile.Picture.Height;
 glbImgWidth:=imgTile.Picture.Width;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
 FormPaint(Sender);
end;

procedure TfrmMain.MDIWndProc(var prmMsg:TMessage);
begin
 with prmMsg do
  begin
   if Msg=WM_ERASEBKGND then
    begin
     if mnuBitmap.Checked then
      ShowBitmap(wParam)
     else
      ShowGradient(wParam,255,0,0);
     Result:=1;
    end
   else
    Result:=CallWindowProc(MDIDefProc,ClientHandle,Msg,wParam,lParam);
  end;
end;

procedure TfrmMain.CreateWnd;
begin
 inherited CreateWnd;
 MDIInstance:=MakeObjectInstance(MDIWndProc); { create wrapper }
 MDIDefProc:=pointer(SetWindowLong(ClientHandle,GWL_WNDPROC,
     longint(MDIInstance)) );
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose:
Boolean);
begin
 { restore default window proc }
 SetWindowLong(ClientHandle,GWL_WNDPROC,longint(MDIDefProc));
 { dispose of instance }
 FreeObjectInstance(MDIInstance);
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
 close;
end;

procedure TfrmMain.mnuBitmapClick(Sender: TObject);
 var
  wrkDC:hDC;
begin
 wrkDC:=GetDC(ClientHandle);
 ShowBitmap(wrkDC);
 ReleaseDC(ClientHandle,wrkDC);
 mnuBitmap.Checked:=true;
 mnuGradient.Checked:=false;
end;

procedure TfrmMain.mnuGradientClick(Sender: TObject);
 var
  wrkDC:hDC;
begin
 wrkDC:=GetDC(ClientHandle);
 ShowGradient(wrkDC,0,0,255);
 ReleaseDC(ClientHandle,wrkDC);
 mnuGradient.Checked:=true;
 mnuBitMap.Checked:=false;
end;

procedure TfrmMain.ShowBitmap(prmDC:hDC);
 var
  wrkSource:TRect;
  wrkTarget:TRect;
  wrkX:integer;
  wrkY:integer;
begin
 {tile bitmap }
 if FormStyle=fsNormal then
  begin
   wrkY:=0;
   while wrkY < ClientHeight do    { go from top to bottom.. }
    begin
     wrkX:=0;
     while wrkX < ClientWidth do   { ..and left to right. }
      begin
       Canvas.Draw(wrkX,wrkY,imgTile.Picture.Bitmap);
       Inc(wrkX,glbImgWidth);
      end;
     Inc(wrkY,glbImgHeight);
    end;
  end
 else if FormStyle=fsMDIForm then
  begin
   Windows.GetClientRect(ClientHandle,wrkTarget);
   wrkY:=0;
   while wrkY < wrkTarget.Bottom do
    begin
     wrkX:=0;
     while wrkX < wrkTarget.Right do
      begin
       BitBlt(longint(prmDC),wrkX,wrkY,imgTile.Width,imgTile.Height,
                imgTile.Canvas.Handle,0,0,SRCCOPY);
       Inc(wrkX,glbImgWidth);
      end;
     Inc(wrkY,glbImgHeight);
    end;
  end;
end;

procedure TfrmMain.ShowGradient(prmDC:hDC;prmRed,prmGreen,prmBlue:byte);
 var
  wrkBrushNew:hBrush;
  wrkBrushOld:hBrush;
  wrkColor:TColor;
  wrkCount:integer;
  wrkDelta:integer;
  wrkRect:TRect;
  wrkSize:integer;
  wrkY:integer;
begin
 { gradient routine }
 wrkDelta:=255 div (1+ClientHeight); { number of shades desired }
 if wrkDelta=0 then wrkDelta:=1;     { yes, usually 1 }
 wrkSize:=ClientHeight div 240;      { size of blended bars }
 if wrkSize=0 then wrkSize:=1;
 for wrkY:=0 to 1+(ClientHeight div wrkSize) do
  begin
   wrkColor:=RGB(prmRed,prmGreen,prmBlue);
   wrkRect:=Rect(0,wrkY*wrkSize,ClientWidth,(wrkY+1)*wrkSize);
   if FormStyle=fsNormal then
    begin
     Canvas.Brush.Color:=wrkColor;
     Canvas.FillRect(wrkRect);
    end
   else if FormStyle=fsMDIForm then
    begin
     wrkBrushNew:=CreateSolidBrush(wrkColor);
     wrkBrushOld:=SelectObject(prmDC,wrkBrushNew);
     FillRect(prmDC,wrkRect,wrkBrushNew);
     SelectObject(prmDC,wrkBrushOld);
     DeleteObject(wrkBrushNew);
    end;
   if prmRed >wrkDelta then Dec(prmRed,wrkDelta);
   if prmGreen > wrkDelta then Dec(prmGreen,wrkDelta);
   if prmBlue  > wrkDelta then Dec(prmBlue,wrkDelta);
  end;
end;

procedure TfrmMain.FormPaint(Sender: TObject);
begin
 if FormStyle=fsNormal then
  if mnuBitMap.Checked then
   mnuBitMapClick(Sender)
  else
   mnuGradientClick(Sender);
end;

end.

