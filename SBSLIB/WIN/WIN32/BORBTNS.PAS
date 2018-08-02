{-------------------------------------------------------------------}
{ BORBTNS - BWCC Style CheckBoxes & Radio Buttons for Delphi v 1.01 }
{-------------------------------------------------------------------}
{ v. 1.00 April, 8 1995                                             }
{ v. 1.01  July, 6 1995  Controls refreshed when caption changes    }
{-------------------------------------------------------------------}
{ Copyright Enrico Lodolo                                           }
{ via F.Bolognese 27/3 - 440129 Bologna - Italy                     }
{ CIS 100275,1255 - Internet ldlc18k1@bo.nettuno.it                 }
{-------------------------------------------------------------------}

unit BorBtns;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Menus;

type
  TBorCheck = class(TCustomControl)
  private
    FDown:Boolean;
    FState:TCheckBoxState;

    FFocused:Boolean;

    FCheckColor:TColor;

    fHelpClick,
    FModified  :  Boolean;
    FAlign     :  TAlign;

    FTextId    : LongInt;
  protected
    constructor Create(AOwner: TComponent); override;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure WMHelp(var Message: TMessage); message WM_Help;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState;X, Y: Integer);
      override;
    procedure KeyDown(var Key:Word;Shift:TShiftSTate); override;
    procedure KeyUp(var Key:Word;Shift:TShiftSTate); override;
    procedure SetDown(Value:Boolean);
    procedure SetState(Value:TCheckBoxState);
    procedure SetChecked(Value:Boolean);
    function  GetChecked:Boolean;
    procedure SetCheckColor(Value:TColor);
    function  GetAlign: TAlign;
    procedure SetAlign(const Value:TAlign);
    function  GetCaption: TCaption;
    procedure SetCaption(const Value:TCaption);
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    Property Modified  :  Boolean  read fModified write fModified default False;

  published
    property Align : TAlign read GetAlign write SetAlign default alLeft;

    property Caption:TCaption read GetCaption write SetCaption;
    property CheckColor:TColor read FCheckColor write SetCheckColor
             default clBlack;

    property Color;

    property Checked:Boolean read GetChecked write SetChecked
             default False;
    property Down:Boolean read FDown write SetDown default False;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    Property ParentColor;

    property ParentFont;
    property PopupMenu;
    property ShowHint;
    property State:TCheckBoxState read FState write SetState
             default cbUnchecked;
    property TabOrder;
    property TabStop;
    Property TextId : LongInt Read FTextId Write FTextId;
    property Visible;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  // HM 01/03/01: Added TBorCheck descendant modified to paint properly when disabled,
  // unfortunately the Paint doesn't appear to be called if you re-enable it in the code
  // so you have to call the Refresh method.
  TBorCheckEx = class(TBorCheck)
  Protected
    procedure Paint; override;
  End;


type
  TBorRadio = class(TCustomControl)
  private
    FDown:Boolean;
    FChecked:Boolean;
    FFocused:Boolean;
    FAutoSet:Boolean;
    FCheckColor:TColor;
    FGroupIndex:Byte;

    FHelpClick,
    FModified  :  Boolean;
    FAlign     :  TAlign;

    FTextId    : LongInt;

    procedure TurnSiblingsOff;
  protected
    constructor Create(AOwner: TComponent); override;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure WMHelp(var Message: TMessage); message WM_Help;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState;X, Y: Integer);
      override;
    procedure KeyDown(var Key:Word;Shift:TShiftSTate); override;
    procedure KeyUp(var Key:Word;Shift:TShiftSTate); override;
    function  GetCaption: TCaption;
    procedure SetCaption(const Value:TCaption);
    procedure SetDown(Value:Boolean);
    procedure SetChecked(Value:Boolean);
    procedure SetAutoSet(Value:Boolean);
    procedure SetCheckColor(Value:TColor);

    function  GetAlign: TAlign;
    procedure SetAlign(const Value:TAlign);

    procedure DoEnter; override;
    procedure DoExit; override;
  public

    Property Modified  :  Boolean  read fModified write fModified default False;

  published

    property Align : TAlign read GetAlign write SetAlign default alLeft;

    property AutoSet :Boolean read FAutoSet write SetAutoSet
             default True;

    property Caption:TCaption read GetCaption write SetCaption;
    property CheckColor:TColor read FCheckColor write SetCheckColor
             default clBlack;
    property Checked:Boolean read FChecked write SetChecked
             default False;
    property Down:Boolean read FDown write SetDown default False;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property GroupIndex:Byte read FGroupIndex write FGroupIndex
      default 0;
    property ParentFont;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    Property TextId : LongInt Read FTextId Write FTextId;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

procedure Register;

implementation

{-------------------------------------------------------------------}
{                          Borland Style CheckBox                   }
{-------------------------------------------------------------------}

constructor TBorCheck.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  Width := 98;
  Height := 20;
  ParentColor:=False;
  Color:=clBtnFace;
  Align:=alLeft;
  FTextId := 0;
end;

procedure TBorCheck.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
    begin
      SetFocus;
      Checked:=Not Checked;
      Click;
      Result := 1;
    end else
      inherited;
end;


procedure TBorCheck.WMHelp(var Message: TMessage);

begin
  with Message do
  Begin
    fHelpClick:=True;

    inherited;
  end;
end;


const BW=12;

procedure TBorCheck.Paint;

var BL,BT,BR,BB:Integer;
    TX,TY,TW,TH:Integer;

    R,
    Rect2:TRect;

begin
     Canvas.Font:=Font;
     with Canvas do
       begin
         BT:=(Height div 2)-(BW div 2);
         BB:=BT+BW;

         If (Align=alLeft) then
           BL:=Width-BW-1
         else
           BL:=1;


         BR:=BW+BL;

         Brush.Color:=Color;
         if not FDown then
           begin
             Pen.Color:=clBtnFace;
             Rectangle(BL,BT,BR,BB);
             Pen.Color:=clBtnHighLight;
             MoveTo(BL,BB);
             LineTo(BL,BT);
             LineTo(BR,BT);
             Pen.Color:=clBtnShadow;
             LineTo(BR,BB);
             LineTo(BL,BB);
           end
         else
           begin
             Pen.Color:=clBlack;
             Pen.Width:=2;
             Rectangle(BL+1,BT+1,BR+1,BB+1);
             Pen.Width:=1;
           end;
         TY:=(Height div 2)+(Font.Height div 2)-1;
         TW:=TextWidth(Caption);
         TH:=TextHeight(Caption);

         If (BL=1) then
           TX:=BR+5
         else
           TX:=(BL-TW)-5;

         R:=Rect(TX,TY,TW+TX,TY+TH);

         DrawText(Handle,PChar(Caption),Length(Caption),R,DT_Left);

         case State of
           cbChecked:begin
                       Pen.Color:=FCheckColor;
                       Pen.Width:=1;
                       Dec(BT);Dec(BB);
                       MoveTo(BL+2,BT+BW div 2+1);
                       LineTo(BL+2,BB-1);
                       MoveTo(BL+3,BT+BW div 2);
                       LineTo(BL+3,BB-2);
                       MoveTo(BL+2,BB-1);
                       LineTo(BR-2,BT+3);
                       MoveTo(BL+3,BB-1);
                       LineTo(BR-1,BT+3);
                     end;
            cbGrayed:begin
                       if Down then
                         begin
                           Pen.Color:=clBtnFace;
                           Brush.Color:=clBtnFace;
                           Rectangle(BL+2,BT+2,BR-1,BB-1);
                         end;
                       Brush.Color:=clBtnShadow;
                       Rectangle(BL+2,BT+2,BR-1,BB-1);
                     end;
         end;
         Brush.Color:=clBtnFace;
         Rect2:=Bounds(TX-1,TY,TW+3,TH+1);
         FrameRect(Rect2);
         if FFocused then
           DrawFocusRect(Rect2);
       end;
end;

function TBorCheck.GetAlign:TAlign;


begin
  Result:=fAlign;

end;

procedure TBorCheck.SetAlign(const Value:TAlign);


begin
     if GetAlign<> Value then
     Begin
       fAlign:=Value;
       Invalidate;
     end;
end;

function TBorCheck.GetCaption:TCaption;

var
  Len:Integer;
  Buffer  :  PChar;

begin
  GetMem(Buffer, 256);

  Len := GetTextBuf(Buffer, 256);

  Result:=StrPas(Buffer);

  FreeMem(Buffer, 256);

     {Move(Result[0], Result[1], Len);
     Result[0] := Char(Len);}
end;

procedure TBorCheck.SetCaption(const Value:TCaption);

var Buffer: array[0..255] of Char;

begin
     if GetCaption <> Value then
       SetTextBuf(StrPCopy(Buffer,Value));
     Invalidate;
end;

procedure TBorCheck.SetDown(Value:Boolean);

begin
     if FDown<>Value then
       begin
         FDown:=Value;
         Paint;
       end;
end;

procedure TBorCheck.SetState(Value:TCheckBoxState);

begin
     if FState<>Value then
       begin
         FState:=Value;
         Paint;
         Click;
       end;
end;

function TBorCheck.GetChecked: Boolean;

begin
     Result:=State=cbChecked;
end;

procedure TBorCheck.SetChecked(Value:Boolean);

begin
     if Value then State := cbChecked
              else State := cbUnchecked;
end;

procedure TBorCheck.SetCheckColor(Value:TColor);

begin
     FCheckColor:=Value;
     Paint;
end;

procedure TBorCheck.DoEnter;

begin
     inherited DoEnter;
     FFocused:=True;
     Paint;
end;

procedure TBorCheck.DoExit;

begin
     inherited DoExit;
     FFocused:=False;
     Paint;
end;

procedure TBorCheck.MouseDown(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);

begin
  // MH 19/04/2013 v7.0.3 ABSEXCH-14238: Modified to stop it responding to right-clicks
  If (Button <> mbRight) Then
  Begin
     SetFocus;
     FFocused:=True;
     inherited MouseDown(Button, Shift, X, Y);
     MouseCapture:=True;
     Down:=True;
  End // If (Button <> mbRight)
  Else
    inherited MouseDown(Button, Shift, X, Y);
end;

procedure TBorCheck.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);

begin
  // MH 19/04/2013 v7.0.3 ABSEXCH-14238: Modified to stop it responding to right-clicks
  If (Button <> mbRight) Then
  Begin
     MouseCapture:=False;
     Down:=False;
     if (X>=0) and (X<=Width) and (Y>=0) and (Y<=Height) and (Not fHelpClick) then
     Begin
       Checked:=not Checked;
       Modified:=True;
     end;

     fHelpClick:=False;
  End; // If (Button <> mbRight)

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TBorCheck.MouseMove(Shift: TShiftState;X, Y: Integer);

begin
     if MouseCapture then
       Down:=(X>=0) and (X<=Width) and (Y>=0) and (Y<=Height);
     inherited MouseMove(Shift,X,Y);
end;

procedure TBorCheck.KeyDown(var Key:Word;Shift:TShiftSTate);

begin
     if Key=vk_Space then Down:=True;
     inherited KeyDown(Key,Shift);
end;

procedure TBorCheck.KeyUp(var Key:Word;Shift:TShiftSTate);

begin
     if Key=vk_Space then
       begin
         {Down:=False;
         Checked:=not Checked;
         Modified:=True;}

         {EL v5.50. 19/01/2003. Action of pressing space bar modifed to call MouseUp so any events dependig on a change of state still get called}

         MouseUp(mbLeft,[],1,1);
       end;
end;

{-------------------------------------------------------------------}
{                           Borland Radio Button                    }
{-------------------------------------------------------------------}

constructor TBorRadio.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  Width := 98;
  Height := 20;
  ParentColor:=False;
  Color:=clBtnFace;
  Align:=alLeft;
  AutoSet:=True;
  FTextId := 0;
end;

procedure TBorRadio.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
    begin
      SetFocus;
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TBorRadio.WMHelp(var Message: TMessage);

begin
  with Message do
  Begin
    fHelpClick:=True;

    inherited;
  end;
end;

procedure TBorRadio.Paint;

var BL,BT,BR,BB,BM:Integer;
    TX,TY,TW,TH:Integer;
    CX,CY:Integer;
    R,
    Rect2:TRect;

begin
     Canvas.Font:=Font;
     with Canvas do
       begin
         BM:=BW div 2;
         BT:=(Height div 2)-BM;
         BB:=BT+BW;

         If (Align=alLeft) then
           BL:=Width-BW-1
         else
           BL:=1;

         BR:=BW+BL;

         Brush.Color:=clBtnFace;
         if Down then
           begin
             Pen.Color:=clBlack;
             MoveTo(BL+BM,BT);
             LineTo(BL,BT+BM);
             LineTo(BL+BM,BB);
             LineTo(BR,BT+BM);
             LineTo(BL+BM,BT);
             MoveTo(BL+BM,BT+1);
             LineTo(BL+1,BT+BM);
             LineTo(BL+BM,BB-1);
             LineTo(BR-1,BT+BM);
             LineTo(BL+BM,BT+1);
           end
         else
           begin
             Pen.Color:=clBtnFace;
             Rectangle(BL,BT,BR,BB);
             if Checked then Pen.Color:=clBtnShadow
                        else Pen.Color:=clBtnHighLight;
             MoveTo(BL+BM,BT);
             LineTo(BL,BT+BM);
             LineTo(BL+BM,BB);
             if Checked then Pen.Color:=clBtnHighLight
                        else Pen.Color:=clBtnShadow;
             LineTo(BR,BT+BM);
             LineTo(BL+BM,BT);
           end;
         if Checked then
            begin
              Pen.Color:=CheckColor;
              CX:=BL+BM;CY:=BT+BM;
              MoveTo(CX-1,CY-1);
              LineTo(CX+2,CY-1);
              MoveTo(CX-2,CY);
              LineTo(CX+3,CY);
              MoveTo(CX-1,CY+1);
              LineTo(CX+2,CY+1);
              MoveTo(CX,CY-2);
              LineTo(CX,CY+3);
            end;
         TY:=(Height div 2)+(Font.Height div 2)-1;
         TW:=TextWidth(Caption);
         TH:=TextHeight(Caption);

         If (BL=1) then
           TX:=BR+5
         else
           TX:=(BL-TW)-5;

         R:=Rect(TX,TY,TW+TX,TY+TH);

         DrawText(Handle,PChar(Caption),Length(Caption),R,DT_Left);

         Brush.Color:=clBtnFace;
         Rect2:=Bounds(TX-1,TY,TW+3,TH+1);
         FrameRect(Rect2);
         if FFocused then
           DrawFocusRect(Rect2);
       end;
end;

function TBorRadio.GetCaption:TCaption;

var
  Len:Integer;
  Buffer  :  PChar;


begin
  GetMem(Buffer, 256);

  Len := GetTextBuf(Buffer, 256);

  Result:=StrPas(Buffer);

  FreeMem(Buffer, 256);

     {Move(Result[0], Result[1], Len);
     Result[0] := Char(Len);}
end;

procedure TBorRadio.SetCaption(const Value:TCaption);

var Buffer: array[0..255] of Char;

begin
     if GetCaption <> Value then
       SetTextBuf(StrPCopy(Buffer,Value));
     Invalidate;
end;

function TBorRadio.GetAlign:TAlign;


begin
  Result:=fAlign;

end;

procedure TBorRadio.SetAlign(const Value:TAlign);


begin
  if GetAlign<> Value then
  Begin
    fAlign:=Value;
    Invalidate;
  end;
end;

procedure TBorRadio.SetDown(Value:Boolean);

begin
     if FDown<>Value then
       begin
         FDown:=Value;
         Paint;
       end;
end;

procedure TBorRadio.TurnSiblingsOff;

var i:Integer;
    Sibling: TBorRadio;

begin
     if Parent <> nil then
       for i:=0 to Parent.ControlCount-1 do
         if Parent.Controls[i] is TBorRadio then
           begin
             Sibling:=TBorRadio(Parent.Controls[i]);
             if (Sibling<>Self) and
                (Sibling.GroupIndex=GroupIndex) then
                  Sibling.SetChecked(False);
           end;
end;

procedure TBorRadio.SetChecked(Value: Boolean);

begin
     if FChecked <> Value then
       begin
         TabStop:=Value;
         FChecked:=Value;
         Modified:=True;
         if Value then
           begin
             TurnSiblingsOff;
             Click;
           end;
         Paint;
       end;
end;

procedure TBorRadio.SetAutoSet(Value: Boolean);

Begin
  If (FAutoSet<>Value) then
    FAutoSet:=Value;


end;
procedure TBorRadio.SetCheckColor(Value:TColor);

begin
     FCheckColor:=Value;
     Paint;
end;

procedure TBorRadio.DoEnter;

begin
     inherited DoEnter;
     FFocused:=True;
     
     If (AutoSet) then
       Checked:=True;

     Paint;
end;

procedure TBorRadio.DoExit;

begin
     inherited DoExit;
     FFocused:=False;
     Paint;
end;

procedure TBorRadio.MouseDown(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);

begin
     SetFocus;
     FFocused:=True;
     inherited MouseDown(Button, Shift, X, Y);
     MouseCapture:=True;
     Down:=True;
end;

procedure TBorRadio.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);

begin
     MouseCapture:=False;
     Down:=False;
     if (X>=0) and (X<=Width) and (Y>=0) and (Y<=Height) and (Not fHelpClick)
       and not Checked then Checked:=True;

     fHelpClick:=False;

     inherited MouseUp(Button, Shift, X, Y);
end;

procedure TBorRadio.MouseMove(Shift: TShiftState;X, Y: Integer);

begin
     if MouseCapture then
       Down:=(X>=0) and (X<=Width) and (Y>=0) and (Y<=Height);
     inherited MouseMove(Shift,X,Y);
end;

procedure TBorRadio.KeyDown(var Key:Word;Shift:TShiftSTate);

begin
     if Key=vk_Space then Down:=True;
     inherited KeyDown(Key,Shift);
end;

procedure TBorRadio.KeyUp(var Key:Word;Shift:TShiftSTate);

begin
     if Key=vk_Space then
       begin
         Down:=False;
         if not Checked then Checked:=True;
       end;
end;

//-------------------------------------------

Procedure TBorCheckEx.Paint;
Const
  BW = 12;
Var
  BL, BT, BR, BB  : Integer;
  TX, TY, TW, TH  : Integer;
  R, Rect2        : TRect;
  oldColor        : TColor;
  oldBrushStyle   : TBrushStyle;

Begin { Paint }
  Canvas.Font:=Font;

  With Canvas Do Begin
    BT:=(Height div 2)-(BW div 2);
    BB:=BT+BW;

    If (Align=alLeft) then
      BL:=Width-BW-1
    else
      BL:=1;

    BR:=BW+BL;

    Brush.Color:=Color;
    if not FDown then begin
      Pen.Color:=clBtnFace;
      Rectangle(BL,BT,BR,BB);
      Pen.Color:=clBtnHighLight;
      MoveTo(BL,BB);
      LineTo(BL,BT);
      LineTo(BR,BT);
      Pen.Color:=clBtnShadow;
      LineTo(BR,BB);
      LineTo(BL,BB);
    end
    else begin
      Pen.Color:=clBlack;
      Pen.Width:=2;
      Rectangle(BL+1,BT+1,BR+1,BB+1);
      Pen.Width:=1;
    end;
    TY:=(Height div 2)+(Font.Height div 2)-1;
    TW:=TextWidth(Caption);
    TH:=TextHeight(Caption);

    If (BL=1) then
      TX:=BR+5
    else
      TX:=(BL-TW)-5;

    R:=Rect(TX,TY,TW+TX,TY+TH);

    // NOTE: This PAINT procedure is a copy of that in TBorCheck except for the
    // following text painting section
    if not Enabled then
    begin
      OldColor:=Canvas.Font.Color; //EL v5.60 12/02/2004: Preserve original color and style
      oldBrushStyle:=Brush.Style;

      OffsetRect(R, 1, 1);
      Canvas.Font.Color := clBtnHighlight;
      DrawText(Canvas.Handle, PChar(Caption), Length(Caption), R, DT_Left);

      OffsetRect(R, -1, -1);
      Brush.Style := bsClear;
      Canvas.Font.Color := clBtnShadow;
      DrawText(Canvas.Handle, PChar(Caption), Length(Caption), R, DT_Left);
      Brush.Style := oldBrushStyle;
      Canvas.Font.Color:=oldColor;
    end
    else
    // End of changes
    Begin

      DrawText(Handle,PChar(Caption),Length(Caption),R,DT_Left);

    end;

    Case State of
      cbChecked:begin
                  Pen.Color:=FCheckColor;
                  Pen.Width:=1;
                  Dec(BT);Dec(BB);
                  MoveTo(BL+2,BT+BW div 2+1);
                  LineTo(BL+2,BB-1);
                  MoveTo(BL+3,BT+BW div 2);
                  LineTo(BL+3,BB-2);
                  MoveTo(BL+2,BB-1);
                  LineTo(BR-2,BT+3);
                  MoveTo(BL+3,BB-1);
                  LineTo(BR-1,BT+3);
                end;
       cbGrayed:begin
                  if Down then
                    begin
                      Pen.Color:=clBtnFace;
                      Brush.Color:=clBtnFace;
                      Rectangle(BL+2,BT+2,BR-1,BB-1);
                    end;
                  Brush.Color:=clBtnShadow;
                  Rectangle(BL+2,BT+2,BR-1,BB-1);
                end;
    End; { Case State }

    Brush.Color:=clBtnFace;
    Rect2:=Bounds(TX-1,TY,TW+3,TH+1);
    FrameRect(Rect2);

    If FFocused then
      DrawFocusRect(Rect2);
  End; { With Canvas  }
End; { Paint }

//-------------------------------------------

procedure Register;

begin
     RegisterComponents('SBS',[TBorCheck,TBorRadio,TBorCheckEx]);
end;

end.
