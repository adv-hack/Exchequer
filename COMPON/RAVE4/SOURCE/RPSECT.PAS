{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPSect;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, RPDefine, RPBase;

type
  TDistMethod = (dmPage,dmMargin,dmSpecial);
  THeightMethod = (hmUnits,hmLines);

{*************************************************************************}
{                            class TReportSection                         }
{*************************************************************************}

  TReportSection = class(TPersistent)
  protected
    FLeft: double;
    FRight: double;
    FTop: double;
    FBottom: double;
    FMinHeight: double;

    FLeftMethod: TDistMethod;
    FRightMethod: TDistMethod;
    FTopMethod: TDistMethod;
    FBottomMethod: TDistMethod;
    FHeightMethod: THeightMethod;

    FEnabled: boolean;
    FTabIndex: integer;
    FFontIndex: integer;
    FNoNewPage: boolean;

    procedure AssignTo(Dest: TPersistent); override;
    procedure SetLeft(Value: double);
    procedure SetRight(Value: double);
    procedure SetTop(Value: double);
    procedure SetBottom(Value: double);
    procedure SetMinHeight(Value: double);
    procedure SetLeftMethod(Value: TDistMethod);
    procedure SetRightMethod(Value: TDistMethod);
    procedure SetTopMethod(Value: TDistMethod);
    procedure SetBottomMethod(Value: TDistMethod);
    procedure SetTabIndex(Value: integer);
    procedure SetFontIndex(Value: integer);
    procedure SetSections(BaseReport: TBaseReport);
  public
    function SetupSection(BaseReport: TBaseReport): boolean;
    constructor Create;
    destructor Destroy; override;

    property NoNewPage: boolean read FNoNewPage write FNoNewPage;
  published
    property Left: double read FLeft write SetLeft;
    property Right: double read FRight write SetRight;
    property Top: double read FTop write SetTop;
    property Bottom: double read FBottom write SetBottom;
    property MinHeight: double read FMinHeight write SetMinHeight;

    property LeftMethod: TDistMethod read FLeftMethod write SetLeftMethod
     default dmMargin;
    property RightMethod: TDistMethod read FRightMethod write SetRightMethod
     default dmMargin;
    property TopMethod: TDistMethod read FTopMethod write SetTopMethod
     default dmSpecial;
    property BottomMethod: TDistMethod read FBottomMethod write SetBottomMethod
     default dmMargin;
    property HeightMethod: THeightMethod read FHeightMethod write FHeightMethod
     default hmLines;

    property Enabled: boolean read FEnabled write FEnabled default true;
    property TabIndex: integer read FTabIndex write SetTabIndex default 0;
    property FontIndex: integer read FFontIndex write SetFontIndex default 0;
  end; { TReportSection }

implementation

  constructor TReportSection.Create;

  begin { Create }
    inherited Create;

    FLeft := 0.0;
    FRight := 0.0;
    FTop := 0.0;
    FBottom := 0.0;
    FMinHeight := 0.0;

    FLeftMethod := dmMargin;
    FRightMethod := dmMargin;
    FTopMethod := dmSpecial;
    FBottomMethod := dmMargin;
    FHeightMethod := hmLines;

    FEnabled := true;
    FTabIndex := 0;
    FFontIndex := 0;
    FNoNewPage := false;
  end;  { Create }

  destructor TReportSection.Destroy;

  begin { Destroy }
    inherited Destroy;
  end;  { Destroy }

  procedure TReportSection.AssignTo(Dest: TPersistent);

  begin { AssignTo }
    If Dest is TReportSection then begin
      With Dest as TReportSection do begin
        FLeft := self.FLeft;
        FRight := self.FRight;
        FTop := self.FTop;
        FBottom := self.FBottom;
        FMinHeight := self.FMinHeight;

        FLeftMethod := self.FLeftMethod;
        FRightMethod := self.FRightMethod;
        FTopMethod := self.FTopMethod;
        FBottomMethod := self.FBottomMethod;
        FHeightMethod := self.FHeightMethod;

        FEnabled := self.FEnabled;
        FTabIndex := self.FTabIndex;
        FFontIndex := self.FFontIndex;
        FNoNewPage := self.FNoNewPage;
      end; { with }
    end; { if }
  end;  { AssignTo }

  procedure TReportSection.SetLeft(Value: double);

  begin { SetLeft }
    FLeft := Value;
    If (FLeftMethod = dmPage) and (FLeft < 0.0) then begin
      FLeft := 0.0;
    end; { if }
  end;  { SetLeft }

  procedure TReportSection.SetRight(Value: double);

  begin { SetRight }
    FRight := Value;
    If (FRightMethod in [dmPage,dmSpecial]) and (FRight < 0.0) then begin
      FRight := 0.0;
    end; { if }
  end;  { SetRight }

  procedure TReportSection.SetTop(Value: double);

  begin { SetTop }
    FTop := Value;
    If (FTopMethod = dmPage) and (FTop < 0.0) then begin
      FTop := 0.0;
    end; { if }
  end;  { SetTop }

  procedure TReportSection.SetBottom(Value: double);

  begin { SetBottom }
    FBottom := Value;
    If (FBottomMethod in [dmPage,dmSpecial]) and (FBottom < 0.0) then begin
      FBottom := 0.0;
    end; { if }
  end;  { SetBottom }

  procedure TReportSection.SetMinHeight(Value: double);

  begin { SetMinHeight }
    FMinHeight := Value;
    If FMinHeight < 0.0 then begin
      FMinHeight := 0.0;
    end; { if }
  end;  { SetMinHeight }

  procedure TReportSection.SetLeftMethod(Value: TDistMethod);

  begin { SetLeftMethod }
    If Value <> dmSpecial then begin
      FLeftMethod := Value;
      Left := FLeft;
    end; { if }
  end;  { SetLeftMethod }

  procedure TReportSection.SetRightMethod(Value: TDistMethod);

  begin { SetRightMethod }
    FRightMethod := Value;
    Right := FRight;
  end;  { SetRightMethod }

  procedure TReportSection.SetTopMethod(Value: TDistMethod);

  begin { SetTopMethod }
    FTopMethod := Value;
    Top := FTop;
  end;  { SetTopMethod }

  procedure TReportSection.SetBottomMethod(Value: TDistMethod);

  begin { SetBottomMethod }
    FBottomMethod := Value;
    Bottom := FBottom;
  end;  { SetBottomMethod }

  procedure TReportSection.SetTabIndex(Value: integer);

  begin { SetTabIndex }
    If (Value >= 0) and (Value <= MAXSAVETABS) then begin
      FTabIndex := Value;
    end; { if }
  end;  { SetTabIndex }

  procedure TReportSection.SetFontIndex(Value: integer);

  begin { SetFontIndex }
    If (Value >= 0) and (Value <= MAXSAVEFONT) then begin
      FFontIndex := Value;
    end; { if }
  end;  { SetFontIndex }

  procedure TReportSection.SetSections(BaseReport: TBaseReport);

  begin { SetSections }
    With BaseReport do begin
      Case LeftMethod of
        dmPage: begin
          SectionLeft := Left;
        end;
        dmMargin,dmSpecial: begin
          SectionLeft := MarginLeft + Left;
        end;
      end; { case }

      Case RightMethod of
        dmPage: begin
          SectionRight := PageWidth - Right;
        end;
        dmMargin: begin
          SectionRight := PageWidth - (MarginRight + Right);
        end;
        dmSpecial: begin { Set to distance from SectionLeft }
          SectionRight := SectionLeft + Right;
        end;
      end; { case }

      Case TopMethod of
        dmPage: begin
          SectionTop := Top;
        end;
        dmMargin: begin
          SectionTop := MarginTop + Top;
        end;
        dmSpecial: begin { Set to top of current line }
          SectionTop := LineTop + Top;
        end;
      end; { case }

      Case BottomMethod of
        dmPage: begin
          SectionBottom := PageHeight - Bottom;
        end;
        dmMargin: begin
          SectionBottom := PageHeight - (MarginBottom + Bottom);
        end;
        dmSpecial: begin
          SectionBottom := SectionTop + Bottom;
        end;
      end; { case }
    end; { with }
  end;  { SetSections }

  function TReportSection.SetupSection(BaseReport: TBaseReport): boolean;

  var
    DoNewPage: boolean;

  begin { SetupSection }
    Result := false;
    If not Enabled then Exit;

  { Set the report to the settings of this section }
    With BaseReport do begin
      If FontIndex > 0 then begin
        RestoreFont(FontIndex);
      end; { if }
      If TabIndex > 0 then begin
        RestoreTabs(TabIndex);
      end; { if }
      AdjustLine;
      SetSections(BaseReport);
      Home;
      If (MinHeight > 0.0) and not NoNewPage then begin
        DoNewPage := false;
        Case HeightMethod of
          hmUnits: begin
            DoNewPage := ((SectionBottom - SectionTop) < MinHeight);
          end;
          hmLines: begin
            DoNewPage := (LinesLeft < MinHeight);
          end;
        end; { case }
        If DoNewPage then begin
          Result := true;
          NewPage;
          SetSections(BaseReport);
          Home;
        end; { if }
      end; { if }
    end; { with }
  end;  { SetupSection }

end.
