unit RgnCalc;

interface

uses
  Classes,Windows,sysutils,graphics,Forms;

type
  TByteArray = array of Byte;
  PbyteArray =  ^TByteArray;
  Pcolor = ^Tcolor;

  RgnCalc1 = class(TThread)
  private
    { Private declarations }
    Bitmap : Tbitmap;
    ColorBack,ColorFore : Tcolor;
    OnBack,NoRgn : Boolean;
    Rgn1 : HRGN;
    procedure GetCopy;
    procedure IGetRegion;
    function DiffColors(C1,C2 : Tcolor): integer;
    function NearColor(x,y : integer): Tcolor;
  protected
    procedure Execute; override;
  public
    OwnerForm1 : Tform;
    Accuracy,Smooth : Integer;
  end;

implementation

uses
  RgnEdWindow;

procedure RgnCalc1.Execute;
  var
     i,j,x1,x2 : integer;
    Rgn2 : HRGN;

    PixelColor : Tcolor;
    X1on : Boolean;

begin
  { Place thread code here }
  x1:=0;x2:=0;
  Self.FreeOnTerminate:=true;
  Norgn:=true;
  Bitmap:=Tbitmap.Create;
  try
  Synchronize(GetCopy);
  except
  end;
  with Bitmap.Canvas do
    begin
      x1on:=false;
      Rgn1:=CreateRectRgn(0,0,0,0);
      for i:=0 to Bitmap.Height-1 do
        begin
          for j:=0 to Bitmap.Width-1 do
            begin
              PixelColor:=NearColor(j,i);
               if onBack then
                begin
                  if Accuracy<diffcolors(PixelColor,ColorBack) then
                  begin
                    if not x1on then
                    begin
                      x1on:=true;
                      x1:=j;x2:=j+1;
                    end else inc(x2);

                  end;
                  if (Accuracy>=diffcolors(PixelColor,ColorBack)) or (j=Bitmap.Width-1) then
                  begin
                    if x1on then
                    begin
                      x1on:=false;
                      Rgn2:=CreateRectRgn(x1,i,x2,i+1);
                      Combinergn(Rgn1,Rgn1,Rgn2,RGN_OR);
                      deleteobject(rgn2);
                      Norgn:=false;

                    end;
                  end;
                end else
                begin
                  if Accuracy>=diffcolors(PixelColor,ColorFore) then
                  begin
                     if not x1on then
                    begin
                      x1on:=true;
                      x1:=j;x2:=j+1;
                    end else inc(x2);
                  end;
                  if (Accuracy<diffcolors(PixelColor,ColorFore)) or (j=Bitmap.Width-1) then
                  begin
                    if x1on then
                    begin
                      x1on:=false;
                      Rgn2:=CreateRectRgn(x1,i,x2,i+1);
                      Combinergn(Rgn1,Rgn1,Rgn2,RGN_OR);
                      deleteobject(rgn2);
                      Norgn:=false;

                    end;
                  end;
                end;

            end;
        end;
    end;
  try
  Synchronize(IGetRegion);
  except
  end;
  Deleteobject(Rgn1);

  Bitmap.Free;
end;
function RgnCalc1.DiffColors(C1,C2 : Tcolor): integer;
var
 R1,G1,B1,R2,G2,B2,dr,dg,db : integer;

begin
  //
  r1:=colortoRGB(C1);G1:=r1;B1:=r1;
  r2:=colortoRGB(C2);G2:=r2;B2:=r2;
  r1:=(r1 shl 24) shr 24;
  G1:=(G1 shl 16) shr 24;
  B1:=(B1 shl 8) shr 24;
  r2:=(r2 shl 24) shr 24;
  G2:=(G2 shl 16) shr 24;
  B2:=(B2 shl 8) shr 24;
  dr:=abs(r1-r2);dg:=abs(g1-g2);db:=abs(b1-b2);
  result:=dr;
  if dg>dr then result:=dg;
  if db>dg then result:=db;
end;
function  RgnCalc1.NearColor(x,y : integer): Tcolor;
var
 i,j,R,G,B,R1,G1,B1,Count,count1 : integer;
begin
  //
  R:=0;G:=0;B:=0;Count:=0;Count1:=0;
  for i:=(x-smooth div 2) to (x-smooth div 2 + smooth) do
    for j:=(y-smooth div 2) to (y-smooth div 2 + smooth) do
      begin
        if (i>=0) and (i<=Bitmap.Width) and (j>=0) and (j<Bitmap.Height) then
          begin
            inc(Count);
            if onBack then
              begin
                if DiffColors(ColorBack,Bitmap.Canvas.Pixels[i,j])<=Accuracy then inc(count1);
              end else
              begin
                if DiffColors(ColorFore,Bitmap.Canvas.Pixels[i,j])<=Accuracy then inc(count1);
              end;

            R1:=ColorToRGB(Bitmap.Canvas.Pixels[i,j]);
            G1:=ColorToRGB(Bitmap.Canvas.Pixels[i,j]);
            B1:=ColorToRGB(Bitmap.Canvas.Pixels[i,j]);
            R1:=(r1 shl 24) shr 24;
            G1:=(G1 shl 16) shr 24;
            B1:=(B1 shl 8) shr 24;

            inc(R,R1);inc(G,G1);inc(B,B1);
          end;
      end;
  R:=R div Count;
  G:=G div Count;
  B:=B div Count;
  if Count1>=(1+Count div 2) then
    begin
      if onBack then  Result:=ColorBack
                else  Result:=ColorFore;
    end else
    begin
      Result:=RGB(R,G,B);
    end;      
end;
procedure RgnCalc1.GetCopy;
begin
  Bitmap.Assign(RGNBitmap);
  ColorBack:=(Ownerform1 as TRgnEditorForm).BackColor01.ButtonColor;
  ColorFore:=(Ownerform1 as TRgnEditorForm).ForeGroundColor01.ButtonColor;
  OnBack:=(Ownerform1 as TRgnEditorForm).RadioButton1.Checked;
end;
procedure RgnCalc1.IGetRegion;
begin
  repeat

  until not RGNLocked;
  RgnLocked:=true;
  deleteobject((Ownerform1 as TRgnEditorForm).Rgn);
  if not NORGN then
   begin
     (Ownerform1 as TRgnEditorForm).Rgn:=CreateRectRgn(0,0,0,0);
     CombineRgn((Ownerform1 as TRgnEditorForm).Rgn,Rgn1,Rgn1,RGN_COPY);
   end else
   begin
     if onBack then
     (Ownerform1 as TRgnEditorForm).Rgn:=
     CreateRectRgn(0,0,(Ownerform1 as TRgnEditorForm).PaintBox1.ClientWidth,
                       (Ownerform1 as TRgnEditorForm).PaintBox1.ClientHeight)
     else
     (Ownerform1 as TRgnEditorForm).Rgn:=CreateRectRgn(0,0,0,0);
   end;;
  RgnLocked:=false;
  (Ownerform1 as TRgnEditorForm).Repaint;
end;
end.
