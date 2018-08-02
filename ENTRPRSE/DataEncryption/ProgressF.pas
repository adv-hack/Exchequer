unit ProgressF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvProgressBar, StdCtrls;

type
  TfrmEncryptProgress = class(TForm)
    lblProcessing: TLabel;
    barProgress: TAdvProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    // Variable to prevent the user closing the form before the process has
    // finished
    FCanClose: Boolean;
  public
    // Starts the progress bar and ensures that the form is visible
    procedure Start(Title: string = ''; ProgressCaption: string = '');
    //Procedure to show the progress form on startup as a splash screen
    procedure StartNonModal(Title: string = ''; ProgressCaption: string = '');
    // Stops the progress bar and closes the form
    procedure Stop;
  end;

var
  frmEncryptProgress : TfrmEncryptProgress;

implementation

{$R *.dfm}

// =============================================================================
// TIndeterminateProgressFrm
// =============================================================================

procedure TfrmEncryptProgress.FormCreate(Sender: TObject);
begin
  FCanClose := False;
end;

// -----------------------------------------------------------------------------

procedure TfrmEncryptProgress.Start(Title: string = ''; ProgressCaption: string = '');
begin
  if Title <> '' then
    self.Caption := Title;
  if ProgressCaption <> '' then
    lblProcessing.Caption := ProgressCaption;
  barProgress.Animated := True;
  ShowModal;
end;

// -----------------------------------------------------------------------------

procedure TfrmEncryptProgress.Stop;
begin
  barProgress.Animated := False;
  FCanClose := True;
  PostMessage(self.Handle, WM_CLOSE, 0, 0);
end;

// -----------------------------------------------------------------------------

procedure TfrmEncryptProgress.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := FCanClose;
end;

// -----------------------------------------------------------------------------

//Procedure to show the progress form on startup as a splash screen
procedure TfrmEncryptProgress.StartNonModal(Title, ProgressCaption: string);
begin
  if Title <> '' then
    self.Caption := Title;
  if ProgressCaption <> '' then
    lblProcessing.Caption := ProgressCaption;
  barProgress.Animated := True;
  Show;
  Application.ProcessMessages;
end;

end.
