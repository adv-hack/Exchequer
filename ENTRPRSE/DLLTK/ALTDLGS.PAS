unit Altdlgs;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$S-,W-,R-}
{$C PRELOAD}

interface

{$IFDEF WIN32}
uses Windows, SysUtils, CommDlg, Messages, Classes, Graphics, Controls,
  Buttons, StdCtrls, ExtCtrls, Forms;
{$ELSE}
uses WinTypes, SysUtils, CommDlg, Messages, Classes, Graphics, Controls,
  Buttons, StdCtrls, ExtCtrls, Forms;
{$ENDIF}

type
  AlTMsgDlgType = (mtWarning, mtError, mtInformation, mtConfirmation, mtCustom);
  AlTMsgDlgBtn = (mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore,
    mbAll, mbHelp);
  AlTMsgDlgButtons = set of AlTMsgDlgBtn;

const
  mbYesNoCancel = [mbYes, mbNo, mbCancel];
  mbOKCancel = [mbOK, mbCancel];
  mbAbortRetryIgnore = [mbAbort, mbRetry, mbIgnore];


function AltMessageDlg(const Msg: string; AType: AlTMsgDlgType;
  AButtons: AlTMsgDlgButtons; HelpCtx: Longint): Word;
function AltMessageDlgPos(const Msg: string; AType: AlTMsgDlgType;
  AButtons: AlTMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Word;

procedure AltShowMessage(const Msg: string);
procedure AltShowMessagePos(const Msg: string; X, Y: Integer);

function AltCreateMessageDialog(const Msg: string; AType: AlTMsgDlgType;
  AButtons: AlTMsgDlgButtons): TForm;


implementation


{$IFDEF WIN32}
uses {Printers, }Consts, Dlgs;
{$ELSE}
uses WinProcs, Printers, Consts, Dlgs;
{$ENDIF}

{$R SBSLIB.RES}

const
  MsgDlgMinWidth = 150;
  MsgDlgMinHeight = 55;
  MsgDlgButtonStyle: TButtonStyle = bsAutoDetect;
  MsgDlgGlyphs: Boolean = True;
  MsgDlgBtnSize: TPoint = (X: 74; Y: 40);

{$IFNDEF WIN32}
  WndProcSegAtom: TAtom = 0;
{$ENDIF}
  WndProcOfsAtom: TAtom = 0;
  Captions: array[AlTMsgDlgType] of Word = (SMsgdlgWarning, SMsgdlgError,
    SMsgdlgInformation, SMsgdlgConfirm, 0);
  ResIDs: array[AlTMsgDlgType] of PChar = ('EXCLAMBIG','HANDSTOP' , 'INFOBIG',
    'QMARKBIG', nil);

  BtnKinds: array[AlTMsgDlgBtn] of TBitBtnKind = (bkYes, bkNo, bkOK, bkCancel,
    bkAbort, bkRetry, bkIgnore, bkAll, bkHelp);
  BtnCaptions: array[AlTMsgDlgBtn] of Word = (SMsgdlgYes, SMsgdlgNo, SMsgdlgOK,
    SMsgdlgCancel, SMsgDlgAbort, SMsgDlgRetry, SMsgDlgIgnore,
    SMsgDlgAll, SMsgdlgHelp);
  BtnNames: array[AlTMsgDlgBtn] of PChar = ('YES', 'NO', 'OK', 'CANCEL',
    'ABORT', 'RETRY', 'IGNORE', 'ALL', 'HELP');

  BtnIDs: array[AlTMsgDlgBtn] of PChar = ('TICKS','STOPS' , 'TICKS', 'CROSSES',
    'CROSSES','TICKS',Nil,Nil,Nil);


function AltCreateMessageDialog(const Msg: string; AType: AlTMsgDlgType;
  AButtons: AlTMsgDlgButtons): TForm;
const
  mgGlyphTop = 10;
  mgGlyphLeft = 10;
  mgTextLeft = 10;
  mgTextTop = 10;
  mgTextRight = 10;
  mgButtonLR = 15;
  mgButtonTop = 10;
  mgButtonBottom = 8;
  ButtonSpacing = 8;
var
  MsgLabel: TLabel;
  Glyph: TImage;
  FIcon: TBitMap;
  Buttons: array[AlTMsgDlgBtn] of TBitBtn;
  Btn: AlTMsgDlgBtn;
  ButtonCount: Integer;
  ButtonSize: TPoint;
  InfoSize: TPoint;
  TextRect: TRect;
  C: array[0..255] of Char;
  ButtonX: Integer;
  ButtonTop: Integer;

  function Max(v1, v2: Integer): Integer;
  begin
    if v2 > v1 then Result := v2
    else Result := v1;
  end;

begin
  Result := TForm.CreateNew(Application);
  with Result do
  begin
    PixelsPerInch := 96;
    BorderStyle := bsDialog;
    BorderIcons := [biSystemMenu];
    Ctl3D := True;
    Font.Name := 'MS Sans Serif';
    Font.Height := -11;
    Font.Style := [fsBold];

    TextRect := Rect(0, 0, Screen.Width div 2, 0);
    DrawText(Canvas.Handle, StrPCopy(C, Msg), -1, TextRect, DT_CALCRECT or
      DT_WORDBREAK);

    { create the text }
    MsgLabel := TLabel.Create(Result);
    MsgLabel.Name := 'Message';
    MsgLabel.Parent := Result;
    MsgLabel.WordWrap := True;
    MsgLabel.Caption := Msg;
    MsgLabel.BoundsRect := TextRect;

    if ResIDs[AType] <> nil then
    begin
      Glyph := TImage.Create(Result);
      Glyph.Name := 'Image';
      Glyph.Parent := Result;

      FIcon := TBitMap.Create;
      try
        FIcon.Handle := LoadBitMap(HInstance, ResIDs[AType]);
        Glyph.Picture.Graphic:= FIcon;
        Glyph.BoundsRect := Bounds(mgGlyphLeft, 0, FIcon.Width, FIcon.Height);
      finally
        FIcon.Free;
      end;
    end
    else Glyph := nil;

    { sum up the size of the infomational items }
    InfoSize.X := (TextRect.Right - TextRect.Left) + mgTextLeft + mgTextRight;

    if Glyph <> nil then
      Inc(InfoSize.X, Glyph.Picture.Graphic.Width + mgGlyphLeft);

    if Glyph <> nil
      then InfoSize.Y := Max(Glyph.Picture.Graphic.Height + mgGlyphTop,
        (TextRect.Bottom - TextRect.Top) + mgTextTop)
    else InfoSize.Y := (TextRect.Bottom - TextRect.Top) + mgTextTop;

    { create the buttons }
    ButtonCount := 0;
    for Btn := Low(AlTMsgDlgBtn) to High(AlTMsgDlgBtn) do
    begin
      if Btn in AButtons then
      begin
        Inc(ButtonCount);
        Buttons[Btn] := TBitBtn.Create(Result);
        with Buttons[Btn] do
        begin
          Parent := Result;
          SetBounds(0, 0, MsgDlgBtnSize.X, MsgDlgBtnSize.Y);
          Kind := BtnKinds[Btn];
          if not MsgDlgGlyphs then
          begin
            Glyph := nil;
            Margin := -1;
          end
          else Margin := 2;
          Spacing := -1;
          Caption := LoadStr(BtnCaptions[Btn]);
          Name := StrPas(BtnNames[Btn]);
          Style := MsgDlgButtonStyle;

          If (Btn In [mbYes,mbOk,mbNo,mbCancel,mbAbort]) then
          Begin
            Glyph.Handle:=LoadBitMap(HInstance,BtnIds[Btn]);
            NumGlyphs:=4;
          end;
        end;
      end
      else Buttons[Btn] := nil;

    end;
    { If both a No and a Cancel button exist, then turn off the Cancel style
      of the NO button }
    if (mbNo in AButtons) and (mbCancel in AButtons) then
      Buttons[mbNo].Cancel := False;

    { if only an OK button exists, mark it as Cancel also }
    if (mbOK in AButtons) and not (mbCancel in AButtons) then
      Buttons[mbOK].Cancel := True;


    ButtonSize.X := (ButtonCount * MsgDlgBtnSize.X) +
      (ButtonSpacing * (ButtonCount - 1)) + (mgButtonLR * 2);
    ButtonSize.Y := MsgDlgBtnSize.Y + mgButtonTop + mgButtonBottom;

    ClientWidth := Max(MsgDlgMinWidth, Max(InfoSize.X, ButtonSize.X));
    ClientHeight := Max(MsgDlgMinHeight, InfoSize.Y + ButtonSize.Y);

    { layout the text and glyph }
    if (Glyph <> nil) and (Glyph.Height > (TextRect.Bottom - TextRect.Top)) then
    begin
      Glyph.Top := mgGlyphTop;
      MsgLabel.Top := Glyph.Top + (Glyph.Picture.Graphic.Height div 2) -
        ((TextRect.Bottom - TextRect.Top) div 2);
      ButtonTop := Glyph.Top + Glyph.Height;
    end
    else
    begin
      MsgLabel.Top := mgTextTop;
      if Glyph <> nil then Glyph.Top := MsgLabel.Top +
        (((TextRect.Bottom - TextRect.Top) div 2) - (Glyph.Height div 2));
      ButtonTop := MsgLabel.Top + MsgLabel.Height;
    end;

    if Glyph <> nil then
      MsgLabel.Left := Glyph.Left + Glyph.Width + mgTextLeft
    else
      MsgLabel.Left := mgTextLeft;

    { layout the buttons }
    ButtonX := (Result.ClientWidth div 2) - (ButtonSize.X div 2) + mgButtonLR;
    for Btn := Low(AlTMsgDlgBtn) to High(AlTMsgDlgBtn) do
      if Buttons[Btn] <> nil then
      begin
        Buttons[Btn].Left := ButtonX;
        Buttons[Btn].Top := mgButtonTop + ButtonTop;
        Inc(ButtonX, Buttons[Btn].Width + ButtonSpacing);
      end;

    { set the caption }
    if Captions[AType] > 0 then Caption := LoadStr(Captions[AType])
    else Caption := ExtractFileName(ParamStr(0));
  end;

  Result.Left := (Screen.Width div 2) - (Result.Width div 2);
  Result.Top := (Screen.Height div 2) - (Result.Height div 2);
end;

function AltMessageDlg(const Msg: string; AType: AlTMsgDlgType;
  AButtons: AlTMsgDlgButtons; HelpCtx: Longint): Word;
begin
  Result := AltMessageDlgPos(Msg, AType, AButtons, HelpCtx, -1, -1);
end;

function AltMessageDlgPos(const Msg: string; AType: AlTMsgDlgType;
  AButtons: AlTMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Word;
var
  W: TForm;
begin
  Result := 0;
  W := AltCreateMessageDialog(Msg, AType, AButtons);
  try
    W.HelpContext := HelpCtx;
    if X > -1 then W.Left := X;
    if Y > -1 then W.Top := Y;
    W.ScaleBy(Screen.PixelsPerInch, 96);
    Result := W.ShowModal;
  finally
    W.Free;
  end;
end;

procedure AltShowMessagePos(const Msg: string; X, Y: Integer);
begin
  AltMessageDlgPos(Msg, mtCustom, [mbOK], 0, X, Y);
end;

procedure AltShowMessage(const Msg: string);
begin
  AltShowMessagePos(Msg, -1, -1);
end;

end.

