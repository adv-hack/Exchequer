unit TGraphic;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TESLTransBmp = class(TGraphicControl)
  private
    { Private declarations }
    FBitmap     : TBitmap;
    FMask       : TBitmap;
    FMouseLabel : TLabel;
    FParent     : TImage;

    FOnClick  : TNotifyEvent;
  protected
    { Protected declarations }
    Procedure SetBitmap(Value : TBitmap);
    Procedure SetMask(Value : TBitmap);
  public
    { Public declarations }
    Constructor Create (AOwner : Tcomponent); OverRide;
    Destructor  Destroy; Override;

    Procedure Paint; Override;

    Procedure Click; Override;
  published
    { Published declarations }
    Property Bitmap: TBitmap Read FBitmap Write SetBitmap;
    Property Mask : TBitmap Read FMask Write SetMask;
    Property MouseLabel : TLabel Read FMouseLabel Write FMouseLabel;
    Property Parent : TImage Read FParent Write FParent;
    Property Visible;

    Property OnClick : TNotifyEvent Read FOnClick Write FOnClick;
    Property OnMouseMove;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SBS', [TESLTransBmp]);
end;


Constructor TESLTransBmp.Create (AOwner : Tcomponent);
Begin { Create }
  Inherited Create(AOwner);

  Height := 100;
  Width := 100;

  FBitmap := TBitmap.Create;
  FMask := TBitmap.Create;
End; { Create }

Destructor TESLTransBmp.Destroy;
Begin { Destroy }

  Inherited Destroy;
End; { Destroy }

Procedure TESLTransBmp.SetMask(Value : TBitmap);
Begin { SetMask }
  FMask.Assign(Value);
End; { SetMask }

Procedure TESLTransBmp.SetBitmap(Value : TBitmap);
Begin { SetMask }
  FBitmap.Assign(Value);

  Width := FBitmap.Width;
  Height := FBitmap.Height;
End; { SetMask }

Procedure TESLTransBmp.Paint;
Var
  TBmp            : TBitmap;
  Rect1, DrawRect : TRect;
Begin { Paint }
  If Assigned(FParent) And Assigned(FMask) And Assigned(FBitmap) Then Begin
    Rect1 := Rect (0, 0, FBitmap.Width, FBitmap.Height);

    TBmp := TBitmap.Create;
    Try
      TBmp.Height := FBitmap.Height;
      TBmp.Width := FBitmap.Width;

      DrawRect := Rect(Left, Top, Left + TBmp.Width, Top + TBmp.Height);

      { Copy background onto working canvas }
      TBmp.Canvas.CopyMode := cmSrcCopy;
      TBmp.Canvas.CopyRect (Rect1, FParent.Canvas, DrawRect);

      { Copy mask into working canvas }
      TBmp.Canvas.CopyMode := cmSrcAnd;
      TBmp.Canvas.CopyRect (Rect1, FMask.Canvas, Rect1);

      TBmp.Canvas.CopyMode := cmSrcPaint;
      TBmp.Canvas.CopyRect (Rect1, FBitmap.Canvas, Rect1);

      Canvas.CopyRect (Rect1,TBmp.Canvas,Rect1);
    Finally
      TBmp.Free;
    End;
  End; { If }
End; { Paint }

Procedure TESLTransBmp.Click;
Begin { Click }
  If Assigned(FOnClick) Then
    FOnClick(Self);
End; { Click }

end.


