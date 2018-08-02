unit ConfigureDaybookTotalsFrameU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TConfigureDaybookTotalsFrame = class(TFrame)
    cbDocType: TCheckBox;
    cbTotal: TCheckBox;
    cbOS: TCheckBox;
    cbToday: TCheckBox;
    cbVAT: TCheckBox;
    procedure cbDocTypeClick(Sender: TObject);
    procedure cbTotalClick(Sender: TObject);
    procedure cbOSClick(Sender: TObject);
    procedure cbTodayClick(Sender: TObject);
    procedure cbVATClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CreateCheckboxes(WithCaption: string; IncludeVATCheckbox: Boolean);
    procedure CheckDocType;
    procedure CheckOptions;
    procedure CheckVAT;
  end;

implementation

{$R *.dfm}

{ TConfigureDaybookTotalsFrame }

procedure TConfigureDaybookTotalsFrame.CheckDocType;
begin
  if cbDocType.Checked and not cbTotal.Checked
                       and not cbOS.Checked
                       and not cbToday.Checked
                       and not cbVAT.Checked then
    cbTotal.Checked := true // make sure at least one option is selected
  else if not cbDocType.Checked then
  begin
    cbTotal.Checked := False;
    cbOS.Checked    := False;
    cbToday.Checked := False;
    cbVAT.Checked   := False;
  end;
end;

procedure TConfigureDaybookTotalsFrame.CheckOptions;
// if no option is required then the doc type is not required.
// if any option is required then the doc type is required.
// This procedure is called every time the user clicks any of the checkboxes
begin
  cbDocType.Checked := cbTotal.Checked or
                       cbOS.Checked or
                       cbToday.Checked;
  CheckDocType;
end;

procedure TConfigureDaybookTotalsFrame.CheckVAT;
begin
  if cbVAT.Checked then
  begin
    cbDocType.Checked := True;
    if not cbTotal.Checked and
       not cbOS.Checked and
       not cbToday.Checked then
      cbTotal.Checked := true; // make sure at least one value option is selected
  end;
end;

procedure TConfigureDaybookTotalsFrame.CreateCheckboxes(
  WithCaption: string; IncludeVATCheckbox: Boolean);
begin
  cbDocType.Caption := WithCaption;
  cbVat.Visible     := IncludeVATCheckbox;
end;

procedure TConfigureDaybookTotalsFrame.cbDocTypeClick(Sender: TObject);
begin
  CheckDocType;
end;

procedure TConfigureDaybookTotalsFrame.cbTotalClick(Sender: TObject);
begin
  CheckOptions;
end;

procedure TConfigureDaybookTotalsFrame.cbOSClick(Sender: TObject);
begin
  CheckOptions;
end;

procedure TConfigureDaybookTotalsFrame.cbTodayClick(Sender: TObject);
begin
  CheckOptions;
end;

procedure TConfigureDaybookTotalsFrame.cbVATClick(Sender: TObject);
begin
  CheckVAT;
end;

end.
