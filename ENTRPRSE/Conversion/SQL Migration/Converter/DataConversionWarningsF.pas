unit DataConversionWarningsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseF, EnterToTab, StdCtrls, ExtCtrls, Warning_BaseFrame;

type
  TfrmDataConversionWarnings = class(TfrmCommonBase)
    btnOK: TButton;
    Label2: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    scrlWarnings: TScrollBox;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FWarningFrames : Array of TWarningBaseFrame;
    MinSizeX : Integer;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses DataConversionWarnings, Warning_UnknownVariantFrame, Warning_SQLExecutionErrorFrame,
     Warning_SQLExecutionExceptionFrame, StrUtils;

//=========================================================================

procedure TfrmDataConversionWarnings.FormCreate(Sender: TObject);
Var
  oBaseWarning : TBaseDataConversionWarning;
  I, NextTop : Integer;
begin
  inherited;

  MinSizeX := Width;  

  lblBanner.Caption := IntToStr(ConversionWarnings.TotalWarningsLogged) + ' Data Conversion Warning' + IfThen(ConversionWarnings.TotalWarningsLogged > 1, 's', '');

  // Check if any warnings were ignored to save memory after passing the MaxWarnings limit
  If (ConversionWarnings.TotalWarningsLogged > MaxWarnings) Then
  Begin
    MessageDlg (IntToStr(ConversionWarnings.TotalWarningsLogged) + ' warnings were generated during the conversion, the first ' +
                IntToStr(ConversionWarnings.Count) + ' warnings are shown below, details for the remainder can be found in the log files',
                mtInformation, [mbOK], 0);
  End; // If (ConversionWarnings.TotalWarningsLogged > MaxWarnings)

  // Dynamically resize the array to store the frame references
  SetLength (FWarningFrames, ConversionWarnings.Count);

  // Run through the list and add them as frames into the scroll-box
  NextTop := 1;
  For I := 0 To (ConversionWarnings.Count - 1) Do
  Begin
    oBaseWarning := ConversionWarnings.Warnings[I];
    If (oBaseWarning Is TSQLUnknownVariantWarning) Then
    Begin
      // Unknown Variant
      FWarningFrames[I] := TTWarningUnknownVariantFrame.Create(Self, TSQLUnknownVariantWarning(oBaseWarning));
    End // If (oBaseWarning Is TSQLUnknownVariantWarning)
    Else If (oBaseWarning Is TSQLExecutionExceptionWarning) Then
    Begin
      // SQL Exception
      FWarningFrames[I] := TWarningSQLExecutionExceptionFrame.Create(Self, TSQLExecutionExceptionWarning(oBaseWarning));
    End // If (oBaseWarning Is TSQLExecutionExceptionWarning)
    Else If (oBaseWarning Is TSQLExecutionErrorWarning) Then
    Begin
      // SQL Execution Error
      FWarningFrames[I] := TWarningSQLExecutionErrorFrame.Create(Self, TSQLExecutionErrorWarning(oBaseWarning));
    End // If (oBaseWarning Is TSQLExecutionErrorWarning)
    Else
      MessageDlg('Unknown warning type: ' + oBaseWarning.ClassName, mtError, [mbOK], 0);

    If Assigned(FWarningFrames[I]) Then
    Begin
      // Have to modify the component name as subsequent components of the same class will have the same name
      FWarningFrames[I].Name := FWarningFrames[I].Name + IntToStr(I);

      // Position the frame within the form
      FWarningFrames[I].Parent := scrlWarnings;
      FWarningFrames[I].Top := NextTop;
      FWarningFrames[I].Left := 1;

      // Update position for next frame
      NextTop := NextTop + FWarningFrames[I].Height;
    End; // If Assigned(FWarningFrames[I])
  End; // For I
end;

//-------------------------------------------------------------------------

Procedure TfrmDataConversionWarnings.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X:=MinSizeX;
    ptMinTrackSize.Y:=150;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
end;

//-------------------------------------------------------------------------

procedure TfrmDataConversionWarnings.FormResize(Sender: TObject);
begin
  inherited;

  btnCancel.Top := ClientHeight - scrlWarnings.Left - btnCancel.Height;
  btnCancel.Left := (ClientWidth Div 2) + scrlWarnings.Left;
  btnOK.Top := btnCancel.Top;
  btnOK.Left := btnCancel.Left - (2 * scrlWarnings.Left) - btnOK.Width;

  // Use left setting as common border measurement
  scrlWarnings.Width := ClientWidth - (2 * scrlWarnings.Left);
  scrlWarnings.Height := btnCancel.Top - scrlWarnings.Top - scrlWarnings.Left;
end;

//-------------------------------------------------------------------------


end.
