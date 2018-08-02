{-----------------------------------------------------------------------------
 Unit Name: uFrmBase
 Author:    vmoura
 Purpose:  base form for dashboard

-----------------------------------------------------------------------------}
Unit uFrmBase;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvToolBar, AdvToolBarStylers, APIUtil, uconsts;

const
  cCAPTIONBARHEIGHT = 28;
  WM_DASHCLOSEFORM = WM_USER + 500;


Type
  TfrmBase = Class(TForm)
    AdvPg: TAdvToolBarPager;
    Procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  Private
    fBarStyler: TAdvToolBarOfficeStyler;
    fCaptionBarHeight: Integer;
    Function FindAdvStyler: TAdvToolBarOfficeStyler;
    Procedure WMGetMinMaxInfo(Var Msg: TMessage); Message WM_GETMINMAXINFO;
    procedure WMMESSAGECLOSE(var msg: TMessage); message WM_DASHCLOSEFORM;

    function IsVista: Boolean;
  protected
    Procedure CreateParams(Var Params: TCreateParams); Override;
  Public
    Procedure AfterConstruction; Override;
  published
    property CaptionBarHeight: Integer read fCaptionBarHeight write fCaptionBarHeight;
  End;

Var
  frmBase: TfrmBase;

Implementation

{$R *.dfm}

{ TfrmBase }

{-----------------------------------------------------------------------------
  Procedure: AfterConstruction
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmBase.AfterConstruction;
Begin
  Inherited;

  fCaptionBarHeight := 0;

  fBarStyler := Nil;

{$IFDEF USECAPTION}
  if not IsVista then
  begin
    fCaptionBarHeight := cCAPTIONBARHEIGHT;
    AdvPg.Caption.Caption := Self.Caption;
    AdvPg.CaptionButtons := [];
    If biMinimize In Self.BorderIcons Then
      AdvPg.CaptionButtons := [cbminimize];

    If biSystemMenu In Self.BorderIcons Then
      AdvPg.CaptionButtons := AdvPg.CaptionButtons + [cbClose];

    If biMaximize In Self.BorderIcons Then
      AdvPg.CaptionButtons := AdvPg.CaptionButtons + [cbMaximize];

    AdvPg.ToolBarStyler := FindAdvStyler;

    If AdvPg.ToolBarStyler = Nil Then
    Begin
      fBarStyler := TAdvToolBarOfficeStyler.Create(Nil);
      fBarStyler.Style := bsOffice2007Luna;
      AdvPg.ToolBarStyler := fBarStyler;
    End;

    AdvPg.Height := fCaptionBarHeight;

    Height := Self.Height + AdvPg.Height;
  end
  else
  begin
    fCaptionBarHeight := 0;
    AdvPg.Visible := False;
    BorderWidth := 0;
  end;
{$ELSE}
  fCaptionBarHeight := 0;
  AdvPg.Visible := False;
  BorderWidth := 0;
{$ENDIF}

  HelpFile := cHELPFILE;
End;

{-----------------------------------------------------------------------------
  Procedure: CreateParams
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmBase.CreateParams(Var Params: TCreateParams);
Begin
  Inherited CreateParams(Params);
{$IFDEF USECAPTION}
  if not IsVista then
    Params.Style := Params.Style And Not WS_CAPTION Or WS_POPUP;
{$ENDIF}
End;

{-----------------------------------------------------------------------------
  Procedure: FindAdvStyler
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmBase.FindAdvStyler: TAdvToolBarOfficeStyler;
Var
  lCont: Integer;
Begin
  Result := Nil;
  For lCont := 0 To componentcount - 1 Do
    If Components[lCont] Is TAdvToolBarOfficeStyler Then
    Begin
      Result := TAdvToolBarOfficeStyler(Components[lCont]);
      Break;
    End;
End;

{-----------------------------------------------------------------------------
  Procedure: WMGetMinMaxInfo
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmBase.WMGetMinMaxInfo(Var Msg: TMessage);
Var
  info: ^TMinMaxInfo;
  rc: TRect;
Begin
{$IFDEF USECAPTION}
  if not IsVista then
  begin
    SystemParametersInfo(SPI_GETWORKAREA, 0, @rc, 0);
    info := pointer(Msg.LParam);
    info^.ptMaxPosition.X := rc.Left;
    info^.ptMaxPosition.Y := rc.Top;
    info^.ptMaxSize.x := GetSystemMetrics(SM_CXMAXIMIZED);
    info^.ptMaxSize.y := GetSystemMetrics(SM_CYMAXIMIZED);
  end;
{$ENDIF}
End;

{-----------------------------------------------------------------------------
  Procedure: WMMESSAGECLOSE
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmBase.WMMESSAGECLOSE(var msg: TMessage);
begin
  if Msg.Msg = WM_DASHCLOSEFORM then
    Close;
end;

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmBase.FormDestroy(Sender: TObject);
Begin
{$IFDEF USECAPTION}
  if not IsVista then
    If Assigned(fBarStyler) Then
      FreeAndNil(fBarStyler);
{$ENDIF}
End;

{-----------------------------------------------------------------------------
  Procedure: IsVista
  Author:    vmoura
-----------------------------------------------------------------------------}
function TfrmBase.IsVista: Boolean;
begin
  Result := GetWindowsVersion = wvVista;
end;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmBase.FormCreate(Sender: TObject);
begin
  inherited;
  // 
end;

End.

