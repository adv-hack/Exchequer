unit ExportProgressF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WindowExport, StdCtrls, AdvProgressBar, ExportListIntf, ExtCtrls,
  rtflabel;

type
  TfrmExportProgress = class(TForm)
    lblProgressInfo: TLabel;
    lblProgressRows: TLabel;
    tmCloseAfterException: TTimer;
    Image1: TImage;
    Shape1: TShape;
    RTFLabel1: TRTFLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmCloseAfterExceptionTimer(Sender: TObject);
  private
    { Private declarations }
    FRunning : Boolean;
    FExportedRowCount : Integer;
    FExportComponent : TWindowExport;
    FCommandID : Integer;
    Procedure SetExportComponent (Value : TWindowExport);

    procedure UpdateListExportProgress(var Message: TMessage); message WM_ListExportProgress;
  public
    { Public declarations }
    Property CommandID : Integer Read FCommandID Write FCommandID;
    Property ExportComponent : TWindowExport Read FExportComponent Write SetExportComponent;
  end;

// Display the progress window (that doesn't show progress) and execute the list export
Procedure ExecuteListExport (ExportComponent : TWindowExport; Const CommandID : Integer);

implementation

Uses
    {$IFDEF MADEXCEPT}
      MadExcept,
    {$ENDIF MADEXCEPT}
    GlobVar;

{$R *.dfm}

//=========================================================================

// Display the progress window (that doesn't show progress) and execute the list export
Procedure ExecuteListExport (ExportComponent : TWindowExport; Const CommandID : Integer);
var
  frmExportProgress: TfrmExportProgress;
  wForm : TForm;
Begin // ExecuteListExport
  // Grey out the Exchequer window to give a disabled effect whilst the export is in progress
  wForm := TForm.Create(Application.MainForm);
  Try
    // Use the alpha-blend functionality to put a semi-transparent grey affect across the top of the Exchequer window
    wForm.Position := poDesigned;
    wForm.AlphaBlend := true;
    wForm.AlphaBlendValue := 64;
    wForm.Color := clBlack;
    wForm.BorderStyle := bsNone;
    wForm.Enabled := false;
    SetWindowLong(Application.MainForm.Handle, GWL_HWNDPARENT, Application.MainForm.Handle);
    SetWindowPos(Application.MainForm.handle, Application.MainForm.handle, 0,0,0,0, SWP_NOSIZE or SWP_NOMOVE);
    wForm.Visible := true;
    // Need to set the bounds here, otherwise setting Visible to True screws up the position when the
    // mainform goes across monitor boundaries in a multi-monitor setup
    wForm.BoundsRect := Application.MainForm.BoundsRect;

    // Now display the actual progress window across the top 
    frmExportProgress := TfrmExportProgress.Create(Application.MainForm);
    Try
      frmExportProgress.ExportComponent := ExportComponent;
      frmExportProgress.CommandID := CommandID;

      frmExportProgress.ShowModal;

    Finally
      frmExportProgress.Free;
    End; // Try..Finally
  Finally
    wForm.Free;
  End; // Try..Finally
End; // ExecuteListExport

//=========================================================================

procedure TfrmExportProgress.FormCreate(Sender: TObject);
begin
  FRunning := False;
  FExportedRowCount := 0;
end;

//-------------------------------------------------------------------------

procedure TfrmExportProgress.FormActivate(Sender: TObject);
Var
  sTime, ETime : TDateTime;
begin
  If (Not FRunning) And Assigned(FExportComponent) Then
  Begin
    FRunning := True;
    Try
      Try
        FExportComponent.ExecuteCommand(FCommandID, Self.Handle);
      Except
        {$IFDEF MADEXCEPT}
          // Log the exception to file and shutdown the application modal progress dialog

          // After trying numerous combinations this is what I have come up with for the error handling, handling the
          // Exception allows us to re-raise it AFTER enabling the Timer to close the Application Modal progress window.
          // The resulting exception is then handled by MadExcept and saved to BugReport.txt for later reference by support
          // a couple of seconds after the user closes the MadExcept Bug dialog the progress window is closed
          On E:Exception Do
          Begin
            tmCloseAfterException.Enabled := True;
            Raise;
          End; // On E:Exception
        {$ELSE}
          // Report the exception on screen and shutdown the application modal progress dialog
          On E:Exception Do
          Begin
            MessageDlg ('An error occurred exporting data to Microsoft Excel, please contact your technical support' +
                        #13#13 +
                        E.Message, mtError, [mbOK], 0);
            Close;
          End; // On E:Exception
        {$ENDIF MADEXCEPT}
      End;
    Finally
      PostMessage (Self.Handle, WM_Close, 0, 0);
    End; // Try..finally
  End; // If (Not FRunning) And Assigned(FExportComponent)
end;

//-------------------------------------------------------------------------

Procedure TfrmExportProgress.SetExportComponent (Value : TWindowExport);
Begin // SetExportComponent
  FExportComponent := Value;
  lblProgressInfo.Caption := 'Exporting ' + Value.OnGetExportDescription + ' to Microsoft Excel, please wait...';
  lblProgressRows.Caption := '';
End; // SetExportComponent

//-------------------------------------------------------------------------

Procedure TfrmExportProgress.UpdateListExportProgress(var Message: TMessage);
Begin // UpdateListExportProgress
  FExportedRowCount := FExportedRowCount + 1;
  If (FExportedRowCount Mod 5) = 0 Then
    lblProgressRows.Caption := Format ('%0.0n rows exported', [FExportedRowCount * 1.0]);
End; // UpdateListExportProgress

//-------------------------------------------------------------------------

procedure TfrmExportProgress.tmCloseAfterExceptionTimer(Sender: TObject);
begin
  Close;
end;

//=========================================================================


end.
