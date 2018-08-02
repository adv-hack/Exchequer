unit entPrevw;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, Controls, Graphics, Menus, Forms, StdCtrls,
  ComServ, StdVCL, AXCtrls, entPrevX_TLB, RavePrev, ExtCtrls;

type
  TentPreviewX = class(TActiveXControl, IentPreviewX)
  private
    { Private declarations }
    FDelphiControl: TRavePreview;
    FEvents: IentPreviewXEvents;
    procedure PageChangedEvent(Sender: TObject);
    procedure PreviewActivatedEvent(Sender: TObject);
    procedure PreviewStoppedEvent(Sender: TObject);
  protected
    { Protected declarations }
    procedure DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage); override;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    procedure InitializeControl; override;
    function DrawTextBiDiModeFlagsReadingOnly: Integer; safecall;
    function Get_Active: WordBool; safecall;
    function Get_AlignDisabled: WordBool; safecall;
    function Get_CurrentPage: Integer; safecall;
    function Get_Cursor: Smallint; safecall;
    function Get_DoubleBuffered: WordBool; safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_Filename: WideString; safecall;
    function Get_HelpKeyword: WideString; safecall;
    function Get_HelpType: TxHelpType; safecall;
    function Get_Pages: Integer; safecall;
    function Get_Visible: WordBool; safecall;
    function Get_VisibleDockClientCount: Integer; safecall;
    function Get_Zoom: Double; safecall;
    function Get_ZoomInc: Integer; safecall;
    function Get_ZoomPage: Double; safecall;
    function Get_ZoomPageWidth: Double; safecall;
    function IsRightToLeft: WordBool; safecall;
    function UseRightToLeftReading: WordBool; safecall;
    function UseRightToLeftScrollBar: WordBool; safecall;
    procedure AboutBox; safecall;
    procedure FirstPage; safecall;
    procedure InitiateAction; safecall;
    procedure LastPage; safecall;
    procedure NextPage; safecall;
    procedure PreviousPage; safecall;
    procedure Set_Active(Value: WordBool); safecall;
    procedure Set_CurrentPage(Value: Integer); safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    procedure Set_Filename(const Value: WideString); safecall;
    procedure Set_HelpKeyword(const Value: WideString); safecall;
    procedure Set_HelpType(Value: TxHelpType); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    procedure Set_Zoom(Value: Double); safecall;
    procedure Set_ZoomInc(Value: Integer); safecall;
    procedure Set_ZoomPage(Value: Double); safecall;
    procedure Set_ZoomPageWidth(Value: Double); safecall;
    procedure SetSubComponent(IsSubComponent: WordBool); safecall;
    procedure ZoomIn; safecall;
    procedure ZoomOut; safecall;
  end;

implementation

uses ComObj, About1;

{ TentPreviewX }

procedure TentPreviewX.DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage);
begin
  {TODO: Define property pages here.  Property pages are defined by calling
    DefinePropertyPage with the class id of the page.  For example,
      DefinePropertyPage(Class_entPreviewXPage); }
end;

procedure TentPreviewX.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IentPreviewXEvents;
end;

procedure TentPreviewX.InitializeControl;
begin
  FDelphiControl := Control as TRavePreview;
  FDelphiControl.OnPageChanged := PageChangedEvent;
  FDelphiControl.OnPreviewActivated := PreviewActivatedEvent;
  FDelphiControl.OnPreviewStopped := PreviewStoppedEvent;
end;

function TentPreviewX.DrawTextBiDiModeFlagsReadingOnly: Integer;
begin
  Result := FDelphiControl.DrawTextBiDiModeFlagsReadingOnly;
end;

function TentPreviewX.Get_Active: WordBool;
begin
  Result := FDelphiControl.Active;
end;

function TentPreviewX.Get_AlignDisabled: WordBool;
begin
  Result := FDelphiControl.AlignDisabled;
end;

function TentPreviewX.Get_CurrentPage: Integer;
begin
  Result := FDelphiControl.CurrentPage;
end;

function TentPreviewX.Get_Cursor: Smallint;
begin
  Result := Smallint(FDelphiControl.Cursor);
end;

function TentPreviewX.Get_DoubleBuffered: WordBool;
begin
  Result := FDelphiControl.DoubleBuffered;
end;

function TentPreviewX.Get_Enabled: WordBool;
begin
  Result := FDelphiControl.Enabled;
end;

function TentPreviewX.Get_Filename: WideString;
begin
  Result := WideString(FDelphiControl.Filename);
end;

function TentPreviewX.Get_HelpKeyword: WideString;
begin
  Result := WideString(FDelphiControl.HelpKeyword);
end;

function TentPreviewX.Get_HelpType: TxHelpType;
begin
  Result := Ord(FDelphiControl.HelpType);
end;

function TentPreviewX.Get_Pages: Integer;
begin
  Result := FDelphiControl.Pages;
end;

function TentPreviewX.Get_Visible: WordBool;
begin
  Result := FDelphiControl.Visible;
end;

function TentPreviewX.Get_VisibleDockClientCount: Integer;
begin
  Result := FDelphiControl.VisibleDockClientCount;
end;

function TentPreviewX.Get_Zoom: Double;
begin
  Result := FDelphiControl.Zoom;
end;

function TentPreviewX.Get_ZoomInc: Integer;
begin
  Result := FDelphiControl.ZoomInc;
end;

function TentPreviewX.Get_ZoomPage: Double;
begin
  Result := FDelphiControl.ZoomPage;
end;

function TentPreviewX.Get_ZoomPageWidth: Double;
begin
  Result := FDelphiControl.ZoomPageWidth;
end;

function TentPreviewX.IsRightToLeft: WordBool;
begin
  Result := FDelphiControl.IsRightToLeft;
end;

function TentPreviewX.UseRightToLeftReading: WordBool;
begin
  Result := FDelphiControl.UseRightToLeftReading;
end;

function TentPreviewX.UseRightToLeftScrollBar: WordBool;
begin
  Result := FDelphiControl.UseRightToLeftScrollBar;
end;

procedure TentPreviewX.AboutBox;
begin
  ShowentPreviewXAbout;
end;

procedure TentPreviewX.FirstPage;
begin
  FDelphiControl.FirstPage;
end;

procedure TentPreviewX.InitiateAction;
begin
  FDelphiControl.InitiateAction;
end;

procedure TentPreviewX.LastPage;
begin
  FDelphiControl.LastPage;
end;

procedure TentPreviewX.NextPage;
begin
  FDelphiControl.NextPage;
end;

procedure TentPreviewX.PageChangedEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnPageChanged;
end;

procedure TentPreviewX.PreviewActivatedEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnPreviewActivated;
end;

procedure TentPreviewX.PreviewStoppedEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnPreviewStopped;
end;

procedure TentPreviewX.PreviousPage;
begin
  FDelphiControl.PreviousPage;
end;

procedure TentPreviewX.Set_Active(Value: WordBool);
begin
  FDelphiControl.Active := Value;
end;

procedure TentPreviewX.Set_CurrentPage(Value: Integer);
begin
  FDelphiControl.CurrentPage := Value;
end;

procedure TentPreviewX.Set_Cursor(Value: Smallint);
begin
  FDelphiControl.Cursor := TCursor(Value);
end;

procedure TentPreviewX.Set_DoubleBuffered(Value: WordBool);
begin
  FDelphiControl.DoubleBuffered := Value;
end;

procedure TentPreviewX.Set_Enabled(Value: WordBool);
begin
  FDelphiControl.Enabled := Value;
end;

procedure TentPreviewX.Set_Filename(const Value: WideString);
begin
  FDelphiControl.Filename := ShortString(Value);
end;

procedure TentPreviewX.Set_HelpKeyword(const Value: WideString);
begin
  FDelphiControl.HelpKeyword := String(Value);
end;

procedure TentPreviewX.Set_HelpType(Value: TxHelpType);
begin
  FDelphiControl.HelpType := THelpType(Value);
end;

procedure TentPreviewX.Set_Visible(Value: WordBool);
begin
  FDelphiControl.Visible := Value;
end;

procedure TentPreviewX.Set_Zoom(Value: Double);
begin
  FDelphiControl.Zoom := Value;
end;

procedure TentPreviewX.Set_ZoomInc(Value: Integer);
begin
  FDelphiControl.ZoomInc := Value;
end;

procedure TentPreviewX.Set_ZoomPage(Value: Double);
begin
  FDelphiControl.ZoomPage := Value;
end;

procedure TentPreviewX.Set_ZoomPageWidth(Value: Double);
begin
  FDelphiControl.ZoomPageWidth := Value;
end;

procedure TentPreviewX.SetSubComponent(IsSubComponent: WordBool);
begin
  FDelphiControl.SetSubComponent(IsSubComponent);
end;

procedure TentPreviewX.ZoomIn;
begin
  FDelphiControl.ZoomIn;
end;

procedure TentPreviewX.ZoomOut;
begin
  FDelphiControl.ZoomOut;
end;

initialization
  TActiveXControlFactory.Create(
    ComServer,
    TentPreviewX,
    TRavePreview,
    Class_entPreviewX,
    1,
    '',
    OLEMISC_SIMPLEFRAME or OLEMISC_ACTSLIKELABEL,
    tmApartment);
end.
