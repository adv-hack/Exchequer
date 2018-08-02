unit bkgroup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TSBSBackGroup = class(TGraphicControl)
  private
    { Private declarations }
    FCaption : String;
    FTextId  : LongInt;
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure SetCaption(Value : String);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    Property Anchors;
    Property Caption : String read FCaption write SetCaption;
    Property Color;
    Property Font;
    Property TextId : LongInt Read FTextId Write FTextId;

    property OnClick;
    property OnDblClick;
  end;

{procedure Register;}

implementation

{procedure Register;
begin
  RegisterComponents('SbsForm', [TSBSBackGroup]);
end;}

constructor TSBSBackGroup.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  FTextId := 0;
end;

destructor TSBSBackGroup.Destroy;
begin
  Inherited Destroy;
end;

procedure TSBSBackGroup.SetCaption(Value : String);
begin
  FCaption := Value;
  Invalidate;
end;

procedure TSBSBackGroup.Paint;
var
  H       : Integer;
  R       : TRect;
  TheText : ANSIString;
begin
  With Canvas Do Begin
    { Clear Background }
    Brush.Color := Color;
    FillRect (ClientRect);

    Font := Self.Font;
    H := TextHeight('0');
    R := Rect(0, H div 2 - 1, Width, Height);

    Inc(R.Left);
    Inc(R.Top);
    Brush.Color := clBtnHighlight;
    FrameRect(R);
    OffsetRect(R, -1, -1);
    Brush.Color := clBtnShadow;

    FrameRect(R);

    If (Trim(Caption) <> '') then begin
      R := Rect(8, 0, 0, H);

      TheText := ' ' + Trim(Caption) + ' ';

      DrawText(Handle, PChar(TheText), Length(TheText), R, DT_LEFT or DT_SINGLELINE or
        DT_CALCRECT);
      Brush.Color := Color;
      DrawText(Handle, PChar(TheText), Length(TheText), R, DT_LEFT or DT_SINGLELINE);
    end;
  end;
end;

end.
