unit TJobHandlerClass;

interface

uses
  TPosterClass;

type
  {PR: 24/06/2013 ABSEXCH-14317 TJobHandler is a class for linking together the TImportJob objects which all have the same JobNo. To
                                begin with, it is used to keep track of whether any of the jobs in a multi-file job have import
                                errors so that the status can be shown in the scheduler window. In future, if resources permit,
                                I hope to extend it to make multi-file jobs work in a more coherent manner.}

  TJobHandler = Class
  private
    FImportError : Boolean; // True if we any of the files have encountered errors
    FPoster      : TPoster; // Reference to Poster object for posting messages
    FJobNo       : Integer;

    function GetImportError : Boolean;
    procedure SetImportError(const Value: Boolean);

    function GetPoster : TPoster;
    procedure SetPoster(const Value : TPoster);

    function GetJobNo : Integer;
  public
    constructor Create(const AJobNo : Integer);
    destructor Destroy; override;

    property ImportError : Boolean read GetImportError write SetImportError;
    property Poster : TPoster read GetPoster write SetPoster;
    property JobNo : Integer read GetJobNo;
  end;


implementation

uses
  TJobQueueClass; //needed for access to message constants


{ TJobHandler }

constructor TJobHandler.Create(const AJobNo : Integer);
begin
  inherited Create;
  FImportError := False;
  FJobNo := AJobNo;
end;

destructor TJobHandler.Destroy;
begin
//The object should only be destroyed once all the files for the
//job have been processed; at this point we can send the error status
//to the scheduler window.
  if FImportError then
    FPoster.PostMsg(WM_IMPORTJOB_FAILED, FJobNo, 0)
  else
    FPoster.PostMsg(WM_IMPORTJOB_FINISHED, FJobNo, 0);

  inherited;
end;

function TJobHandler.GetImportError: Boolean;
begin
  Result := FImportError;
end;

function TJobHandler.GetJobNo: Integer;
begin
  Result := FJobNo;
end;

function TJobHandler.GetPoster: TPoster;
begin
  Result := FPoster;
end;

procedure TJobHandler.SetImportError(const Value: Boolean);
begin
  //As we want to preserve any error status, only allow value to be set to true
  if Value and not FImportError then
    FImportError := True;
end;

procedure TJobHandler.SetPoster(const Value: TPoster);
begin
  FPoster := Value;
end;

end.
