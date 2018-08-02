unit IndeterminateProgressF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvProgressBar, StdCtrls;

type
  TIndeterminateProgressFrm = class(TForm)
    lblProcessing: TLabel;
    barProgress: TAdvProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    // Variable to prevent the user closing the form before the process has
    // finished
    FCanClose: Boolean;

    //SS:17/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
    FHideProgressBar: Boolean;
    procedure SetHideProgressBar(const Value: Boolean);
  public
    // Starts the progress bar and ensures that the form is visible
    procedure Start(Title: string = ''; ProgressCaption: string = '');
    // Stops the progress bar and closes the form
    procedure Stop;

    //SS:17/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
    property HideProgressBar : Boolean read FHideProgressBar write SetHideProgressBar;
  end;

implementation

{$R *.dfm}

// =============================================================================
// TIndeterminateProgressFrm
// =============================================================================

procedure TIndeterminateProgressFrm.FormCreate(Sender: TObject);
begin
  FCanClose := False;
  ClientHeight := 50;
  ClientWidth  := 320;
  FHideProgressBar := False;
end;

// -----------------------------------------------------------------------------

procedure TIndeterminateProgressFrm.Start(Title: string = ''; ProgressCaption: string = '');
begin
  // Adjust the position to be vertically centred (the default 'form center'
  // setting does not take the toolbar and status bar into account). We have
  // to do this here, because if we do it in FormCreate it gets ignored.
  Top := Trunc((Application.MainForm.ClientHeight - 64) / 2) - Height;
  if Title <> '' then
    self.Caption := Title;
  if ProgressCaption <> '' then
    lblProcessing.Caption := ProgressCaption;
  barProgress.Animated := True;
  Show;
end;

// -----------------------------------------------------------------------------

procedure TIndeterminateProgressFrm.Stop;
begin
  barProgress.Animated := False;
  FCanClose := True;
  PostMessage(self.Handle, WM_CLOSE, 0, 0);
end;

// -----------------------------------------------------------------------------

procedure TIndeterminateProgressFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := FCanClose;
  // If the FCanClose flag is not yet set, minmise the window instead (to
  // imitate standard child window behaviour)
  if not CanClose then
    WindowState := wsMinimized;
end;

// -----------------------------------------------------------------------------

procedure TIndeterminateProgressFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

// -----------------------------------------------------------------------------

//SS:17/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
procedure TIndeterminateProgressFrm.SetHideProgressBar(
  const Value: Boolean);
begin
  FHideProgressBar := Value;

  barProgress.Visible := not FHideProgressBar;
  if FHideProgressBar then
  begin
    ClientHeight := barProgress.Top;
  end else
  begin
    ClientHeight := barProgress.Top + barProgress.Height + 8;
  end;
end;

end.
