unit RgnEdWindow;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolWin, ComCtrls, ExtCtrls, StdCtrls, IAeverButton, ExtDlgs,Math,RgnCalc;
const
  cm_DtChanged = cm_Base+101;

type
  TIAResultRGN = procedure(Value : HRGN) of object;
  TIANoresultRgn = procedure of object;

  TRgnEditorForm = class(TForm)
    PicturePanel1: TPanel;
    InterfacePanel: TPanel;
    PaintBox1: TPaintBox;
    IAeverButton1: TIAeverButton;
    OpenPictureDialog1: TOpenPictureDialog;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    BackColor01: TIAeverButton;
    ForeGroundColor01: TIAeverButton;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    IAeverButton2: TIAeverButton;
    LoadBitmap: TIAeverButton;
    LetShowRgn: TIAeverButton;
    Bevel1: TBevel;
    Panel1: TPanel;
    UpDesignPanel: TPanel;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    TrackBar2: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LoadBitmapClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BackColor01Click(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ForeGroundColor01Click(Sender: TObject);
    procedure LetShowRgnClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure IAeverButton1Click(Sender: TObject);
    procedure IAeverButton2Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure CMDTChanged(Var Messsage : Tmessage); message cm_DtChanged;
    procedure TrackBar2Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    SelectBack,SelectFore : Boolean;
    ShowRgn,REcalck : Boolean;

//    Deltat,BeginT : Integer;
    Deltat,BeginT : Cardinal;

    Processison : Boolean;
    accuracy1,smooth1 : integer;

    RgnCalc01 : RgnCalc1;
    CreatedFlows : Integer;
    FResultRGN : TIAResultRGN;
    FNoresultRgn : TIANoResultRgn;
    FillRgnBitmap : Tbitmap;

    procedure RgnTerm(sender : Tobject);
    { Private declarations }
  public
    { Public declarations }
    Rgn,ShowRgn1 : HRGN;



    property ResultRGN : TIAResultRGN read FResultRGN write FResultRGN;
    property NoResultRGN : TIANoResultRGN read FNoResultRGN write FNoResultRGN;
  end;

var
  RgnEditorForm: TRgnEditorForm;
  RGNBitmap : Tbitmap;
  BitmapLoaded,rgnlocked : Boolean;


implementation

{$R *.DFM}

procedure TRgnEditorForm.FormCreate(Sender: TObject);
begin
//
  RgnBitmap:=Tbitmap.Create;
  BitmapLoaded:=False;
  Selectback:=False;
  ShowRgn:=True;
  Rgn:=CreateRectRgn(0,0,0,0);
  ShowRgn1:=CreateRectRgn(0,0,0,0);
  RgnLocked:=false;
  Recalck:=true;
  CreatedFlows:=0;
end;

procedure TRgnEditorForm.FormDestroy(Sender: TObject);
begin
  Rgnbitmap.Free;
  FillRgnBitmap.Free;
  Deleteobject(rgn);
  Deleteobject(Showrgn1);

end;

procedure TRgnEditorForm.LoadBitmapClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    begin
      RgnBitmap.loadfromfile(OpenpictureDialog1.filename);
      BitmapLoaded:=True;
      ScrollBar1.Position:=0;
      ScrollBar1.Max:=Max(100,(RgnBitmap.Height-PaintBox1.ClientHeight));
      if RgnBitmap.Height>PaintBox1.ClientHeight then ScrollBar1.Visible:=True else  ScrollBar1.Visible:=False;
      ScrollBar2.Position:=0;
      ScrollBar2.Max:=Max(100,(RgnBitmap.Width-PaintBox1.ClientWidth));
      if RgnBitmap.Width>PaintBox1.ClientWidth then ScrollBar2.Visible:=True else  ScrollBar2.Visible:=False;
      recalck:=true;
      repaint;
    end;
end;

procedure TRgnEditorForm.FormPaint(Sender: TObject);
  var

    dx,dy : integer;
begin
  inherited;
  //
  Paintbox1.Canvas.brush.Color:=Paintbox1.Color;
  PaintBox1.Canvas.FillRect(Paintbox1.clientrect);
  dx:=0;dy:=0;
  if BitmapLoaded then
    begin
      if ScrollBar1.Visible then dy:=-ScrollBar1.Position;
      if ScrollBar2.Visible then dx:=-ScrollBar2.Position;
      PaintBox1.Canvas.Draw(dx,dy,RgnBitmap);

    end;
  //Далее идёт создание региона...
  if Recalck and BitmapLoaded and Showrgn then
    begin

      Rgncalc01:=RgnCalc1.Create(True);
      RgnCalc01.OnTerminate:=RgnTerm;
      RgnCalc01.OwnerForm1:=Self;
      RGNCalc01.Accuracy:=self.accuracy1;
      RgnCalc01.Smooth:=self.smooth1;
      RgnCalc01.Resume;
      inc(CreatedFlows);
      Panel1.visible:=true;
      Recalck:=false;
    end;
      if Showrgn and (Rgn<>0) and (not RGNlocked) then
        begin
          RgnLocked:=true;
          FillRgnBitmap.Free;
          FillRgnBitmap:=Tbitmap.Create;
          FillRgnBitmap.Width:=RgnBitmap.Width;
          FillRgnBitmap.Height:=RgnBitmap.Height;
          FillRgnBitmap.PixelFormat:=RgnBitmap.PixelFormat;
          FillRgnBitmap.Canvas.Brush.Color:=clBlack;
          FillRgnBitmap.Canvas.Brush.Style:=bsSolid;
          FillRgnBitmap.Canvas.FillRect(rect(0,0,FillRgnBitmap.Width,FillRgnBitmap.Height));
          FillRgnBitmap.Canvas.Brush.Color:=clWhite;
          FillRgnBitmap.Canvas.Brush.Style:=bsDiagCross;

          combinergn(showrgn1,rgn,0,rgn_copy);
          fillRgn(FillRgnBitmap.canvas.handle,showRgn1,FillRgnBitmap.canvas.Brush.handle);
          PaintBox1.Canvas.copymode:=cmSrcInvert;	
          PaintBox1.Canvas.Draw(dx,dy,FillRgnBitmap);
          PaintBox1.Canvas.copymode:=cmSrcCopy;



          RgnLocked:=false;
        end;

end;

procedure TRgnEditorForm.FormResize(Sender: TObject);
  var
    P1,M1,P2,M2 : integer;
begin
//
      p1:=ScrollBar1.Position;
      M1:=ScrollBar1.Max;
      p2:=ScrollBar2.Position;
      M2:=ScrollBar2.Max;
      ScrollBar1.Max:=Max(100,(RgnBitmap.Height-PaintBox1.ClientHeight));
      ScrollBar2.Max:=Max(100,(RgnBitmap.Width-PaintBox1.ClientWidth));
      if RgnBitmap.Height>PaintBox1.ClientHeight
        then
          begin
            if not ScrollBar1.Visible then ScrollBar1.Position:=0
                                      else ScrollBar1.Position:=p1+(ScrollBar1.Max-M1) div 2;
            ScrollBar1.Visible:=True;
          end
        else  ScrollBar1.Visible:=False;
      if RgnBitmap.Width>PaintBox1.ClientWidth
        then
          begin
            if not ScrollBar2.Visible then ScrollBar2.Position:=0
                                      else ScrollBar2.Position:=p2+(ScrollBar2.Max-M2) div 2;
            ScrollBar2.Visible:=True;
          end
        else  ScrollBar2.Visible:=False;
end;

procedure TRgnEditorForm.BackColor01Click(Sender: TObject);
begin
//
  SelectBack:=True;
  PaintBox1.Cursor:=crHandPoint;

end;

procedure TRgnEditorForm.PaintBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Rx,Ry,dx,dy : integer;


begin
  if PaintBox1.Cursor=crHandPoint then
    begin
      if BitmapLoaded then
        begin
          dx:=0;dy:=0;
          if ScrollBar1.Visible then dy:=ScrollBar1.Position;
          if ScrollBar2.Visible then dx:=ScrollBar2.Position;

          Rx:=x+dx;Ry:=y+dy;
          if (Rx<RgnBitmap.Width) and (Ry<RgnBitmap.Height) then
            begin
              if SelectBack then BackColor01.ButtonColor:=RgnBitmap.Canvas.Pixels[Rx,Ry];
              if SelectFore then ForeGroundColor01.ButtonColor:=RgnBitmap.Canvas.Pixels[Rx,Ry];
            end;
        end;
        PaintBox1.Cursor:=crDefault;
        SelectBack:=False;
        SelectFore:=False;
        recalck:=true;
        repaint;
    end;

end;

procedure TRgnEditorForm.PaintBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
  var
  Rx,Ry,dx,dy : integer;
begin
  if PaintBox1.Cursor=crHandPoint then
    begin
      if BitmapLoaded then
        begin
          dx:=0;dy:=0;
          if ScrollBar1.Visible then dy:=ScrollBar1.Position;
          if ScrollBar2.Visible then dx:=ScrollBar2.Position;

          Rx:=x+dx;Ry:=y+dy;
          if (Rx<RgnBitmap.Width) and (Ry<RgnBitmap.Height) then
            begin
              if SelectBack then
              begin
              BackColor01.ButtonColor:=RgnBitmap.Canvas.Pixels[Rx,Ry];
              BackColor01.Font.Color:=$00FFFFFF xor RgnBitmap.Canvas.Pixels[Rx,Ry];
              end;
              if SelectFore then
              begin
              ForeGroundColor01.ButtonColor:=RgnBitmap.Canvas.Pixels[Rx,Ry];
              ForegroundColor01.Font.Color:=$00FFFFFF xor RgnBitmap.Canvas.Pixels[Rx,Ry];
              end;
            end;

        end;
      end;

end;

procedure TRgnEditorForm.ForeGroundColor01Click(Sender: TObject);
begin
//
  SelectFore:=True;
  PaintBox1.Cursor:=crHandPoint;
end;

procedure TRgnEditorForm.LetShowRgnClick(Sender: TObject);
begin
  if ShowRgn
    then
      begin
        LetShowRgn.ButtonColor:=$00EAA8D2;
        LetShowRgn.Font.Color:=$00BC83AC;
        LetShowRgn.Caption:='NO real time';
      end
    else
      begin
        LetShowRgn.ButtonColor:=$00EAA8D2;
        LetShowRgn.Font.Color:=$002747FC;
        LetShowRgn.Caption:='RealTime';
      end;
  SHowRgn:=not ShowRgn;
  repaint;
end;

procedure TRgnEditorForm.RgnTerm(sender : Tobject);
begin

  dec(CreatedFlows);

  if CreatedFlows=0 then  Panel1.visible:=false;
end;

procedure TRgnEditorForm.RadioButton1Click(Sender: TObject);
begin
//
  recalck:=true;
  repaint;
end;

procedure TRgnEditorForm.IAeverButton1Click(Sender: TObject);
begin
  if Assigned(FresultRGN) and BitmapLoaded then
    begin
      Rgncalc01:=RgnCalc1.Create(True);
      RgnCalc01.OnTerminate:=RgnTerm;
      RgnCalc01.OwnerForm1:=Self;
      RGNCalc01.Accuracy:=self.accuracy1;
      RgnCalc01.Smooth:=self.smooth1;
      RgnCalc01.Resume;
      inc(CreatedFlows);
      Panel1.visible:=true;
      repeat
        application.ProcessMessages;
      until CreatedFlows=0;
      ResultRgn(Rgn);
    end;
  self.Close;
end;

procedure TRgnEditorForm.IAeverButton2Click(Sender: TObject);
begin
  self.NoResultRGN;
  self.Close;
end;

procedure TRgnEditorForm.TrackBar1Change(Sender: TObject);
begin
  //
  Label1.Caption:=inttostr(TrackBar1.Position);
  if Label2.Visible then deltat:=gettickcount();
  Begint:=deltat;
  if not processison then
  SendMessage(self.handle,cm_dtChanged,0,0);
end;

procedure TRgnEditorForm.CMDTChanged(Var Messsage : Tmessage);
begin
  //

  processison:=true;
//  if abs(int64(GetTickCount)-int64(Begint))>1000
  if abs(GetTickCount - Begint) > 1000
  then
  begin
  accuracy1:=Trackbar1.position;
  recalck:=true;
  repaint;
  processison:=false;
  end
  else
  begin
  Application.ProcessMessages;
  PostMessage(self.handle,cm_dtChanged,0,0);
  end;
  
end;
procedure TRgnEditorForm.TrackBar2Change(Sender: TObject);
begin
  //
  Label4.Caption:=inttostr(TrackBar2.Position);
  if Label3.Visible then deltat:=gettickcount();
  Begint:=deltat;
  if not processison then
  SendMessage(self.handle,cm_dtChanged,0,0);
end;

procedure TRgnEditorForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  self.NoResultRGN;
end;

end.
