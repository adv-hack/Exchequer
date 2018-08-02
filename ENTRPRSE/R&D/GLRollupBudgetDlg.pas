// CJS 2016-04-19 - ABSEXCH-17431 - additional UI mods for SQL GL Budget changes
unit GLRollupBudgetDlg;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VarConst, GlobVar, ExtCtrls, SQLCallerU,
  IndeterminateProgressF, GLRollupBudgetModule;

type
  TRollupBudgetDlg = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    chkCostCentre: TRadioButton;
    chkDepartment: TRadioButton;
    chkCombined: TRadioButton;
    chkGLOnly: TRadioButton;
    lblRollupBudgets: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    // Progress bar form
    FRollupBudget: TRollupBudgetModule;

    // Modify the radio-button captions based on the current system settings
    // for the G/L Budget Roll-up options
    procedure UpdateCaptions;
  public
    constructor CreateForGLOnly(AOwner: TComponent);
  end;

implementation

{$R *.dfm}

uses GenWarnU, SQLUtils, ADOConnect, ExThrd2U, SQLRep_Config;

// =============================================================================
// TRollupBudgetDlg
// =============================================================================

constructor TRollupBudgetDlg.CreateForGLOnly(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Visible := False;
end;

// -----------------------------------------------------------------------------

procedure TRollupBudgetDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

// -----------------------------------------------------------------------------

procedure TRollupBudgetDlg.FormCreate(Sender: TObject);
begin
  ClientHeight := 207;
  ClientWidth  := 260;
  UpdateCaptions;
end;

// -----------------------------------------------------------------------------

procedure TRollupBudgetDlg.btnOkClick(Sender: TObject);
var
  RollupBasis: string;
  Title: string;
begin
  // Set the Summarisation Level
  if chkCostCentre.Checked then
    RollupBasis := 'C'
  else if chkDepartment.Checked then
    RollupBasis := 'D'
  else if chkCombined.Checked then
    RollupBasis := 'C+D'
  else
    RollupBasis := 'G';

  // Disable the controls
  chkCostCentre.Enabled := False;
  chkDepartment.Enabled := False;
  chkCombined.Enabled   := False;
  chkGLOnly.Enabled := False;
  btnOk.Enabled := False;
  btnCancel.Enabled := False;

  // Run the actual routine
  RollupBudgets(RollupBasis);

  // Close this dialog
  PostMessage(self.Handle, WM_Close, 0, 0);
end;

// -----------------------------------------------------------------------------

procedure TRollupBudgetDlg.btnCancelClick(Sender: TObject);
begin
  PostMessage(self.Handle, WM_Close, 0, 0);
end;

// -----------------------------------------------------------------------------

procedure TRollupBudgetDlg.UpdateCaptions;
var
  RollupOption: Integer;
begin
  RollupOption := Ord(Syss.PostCCNom) + Ord(Syss.PostCCDCombo);
  case RollupOption of
    1:  begin
          chkCostCentre.Caption := 'Cost Centre';
          chkDepartment.Caption := 'Department';
          // chkCombined.Caption   := 'Cost Centre / Department';
        end;
    2:  begin
          chkCostCentre.Caption := 'Cost Centre / Department';
          chkDepartment.Caption := 'Department / Cost Centre';
          // chkCombined.Caption   := 'Combined';
        end;
    else
    begin
      // This dialog will not be displayed for option 0
    end;
  end;
end;

// -----------------------------------------------------------------------------

end.
