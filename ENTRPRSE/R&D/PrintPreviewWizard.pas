unit PrintPreviewWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BasePrintPreview, ImgList, Menus, RPDefine, RPBase, RPCanvas,
  RPFPrint, RPreview, ComCtrls, ToolWin, StdCtrls, ExtCtrls, SBSPanel;

type
  TForm_PrintPreviewWizard = class(TForm_BasePrintPreview)
    pnlButtons: TPanel;
    btnContinue: TButton;
    btnCancel: TButton;
    procedure btnContinueClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    // Reference to the originating form. If this is set, messages will be sent
    // to this form on the Continue and Cancel events.
    FOwnerHandle: THandle;
    // Variable to store the original position of the Cancel button
    FCancelButtonLeft: Integer;
    procedure SetCanContinue(const Value: Boolean);
  public
    // The handle of the originating form -- any messages will be posted back
    // to this form.
    property OwnerHandle: THandle read FOwnerHandle write FOwnerHandle;
    property CanContinue: Boolean write SetCanContinue;
  end;

var
  Form_PrintPreviewWizard: TForm_PrintPreviewWizard;

implementation

{$R *.dfm}

uses BtSupU1;

// =============================================================================
// TForm_PrintPreviewWizard
// =============================================================================

procedure TForm_PrintPreviewWizard.FormCreate(Sender: TObject);
begin
  inherited;
  FCancelButtonLeft := btnCancel.Left;
end;

procedure TForm_PrintPreviewWizard.btnContinueClick(Sender: TObject);
begin
  // Post a message back to the originating form to let it know that the
  // current process can continue
  if (OwnerHandle <> 0) then
    PostMessage(OwnerHandle, WM_CONTINUEVATRETURN, 0, 0);
  Close;
end;

// -----------------------------------------------------------------------------

procedure TForm_PrintPreviewWizard.btnCancelClick(Sender: TObject);
begin
  // Post a message back to the originating form to let it know that the
  // current process should be cancelled
  if (OwnerHandle <> 0) then
    PostMessage(OwnerHandle, WM_CANCELVATRETURN, 0, 0);
  Close;
end;

procedure TForm_PrintPreviewWizard.SetCanContinue(const Value: Boolean);
begin
  if Value then
  begin
    btnCancel.Left := FCancelButtonLeft;
    btnCancel.Caption := '&Cancel';
    btnContinue.Visible := True;
  end
  else
  begin
    btnContinue.Visible := False;
    btnCancel.Left := btnContinue.Left;
    btnCancel.Caption := '&Close';
  end;
end;

end.
