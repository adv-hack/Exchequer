unit Warning_SQLExecutionErrorFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Warning_BaseFrame, StdCtrls, DataConversionWarnings;

type
  TWarningSQLExecutionErrorFrame = class(TWarningBaseFrame)
    Label3: TLabel;
    Label2: TLabel;
    memErrorString: TMemo;
    memSQLCommand: TMemo;
  private
    { Private declarations }
    FWarning : TSQLExecutionErrorWarning;
  public
    { Public declarations }
    Constructor Create(AOwner : TComponent; Const Warning : TSQLExecutionErrorWarning);
  end;


implementation

{$R *.dfm}

//=========================================================================

Constructor TWarningSQLExecutionErrorFrame.Create(AOwner : TComponent; Const Warning : TSQLExecutionErrorWarning);
Var
  I : Integer;
Begin // Create
  Inherited Create (AOwner, Warning);

  FWarning := Warning;
  lblWarningDescription.Caption := 'SQL Error ' + IntToStr(Warning.SQLResult) + ' processing ' + FWarning.DataPacket.TaskDetails.dctPervasiveFilename;
  memSQLCommand.Text := Warning.SQLQuery;

  memErrorString.Clear;
  For I := 0 To (Warning.SQLErrors.Count - 1) Do
  Begin
    memErrorString.Lines.Add (Warning.SQLErrors[I]);
  End; // For I
End; // Create

end.
