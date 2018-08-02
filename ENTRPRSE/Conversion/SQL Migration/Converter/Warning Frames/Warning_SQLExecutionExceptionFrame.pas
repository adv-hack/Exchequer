unit Warning_SQLExecutionExceptionFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Warning_BaseFrame, StdCtrls, DataConversionWarnings;

type
  TWarningSQLExecutionExceptionFrame = class(TWarningBaseFrame)
    Label2: TLabel;
    memExceptionMessage: TMemo;
    Label3: TLabel;
    memSQLCommand: TMemo;
  private
    { Private declarations }
    FWarning : TSQLExecutionExceptionWarning;
  public
    { Public declarations }
    Constructor Create(AOwner : TComponent; Const Warning : TSQLExecutionExceptionWarning);
  end;

implementation

{$R *.dfm}

//=========================================================================

Constructor TWarningSQLExecutionExceptionFrame.Create(AOwner : TComponent; Const Warning : TSQLExecutionExceptionWarning);
Begin // Create
  Inherited Create (AOwner, Warning);

  FWarning := Warning;
  lblWarningDescription.Caption := 'SQL Execution Exception processing ' + FWarning.DataPacket.TaskDetails.dctPervasiveFilename;
  memSQLCommand.Text := Warning.SQLQuery;
  memExceptionMessage.Text := Warning.ExceptionMessage;
End; // Create

end.
