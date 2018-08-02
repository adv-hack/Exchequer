unit polltill;

interface

uses
  MPComms, Classes;

type
  TPollTillThread = class(TThread)
  private
    FMPComms : TMPComms;
    { Private declarations }
  public
    constructor Create(MPComms: TMPComms);
  protected
    procedure Execute; override;
  end;

implementation
uses

{ Important: Methods and properties of objects in VCL can only be used in a
  method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TPollTillThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TPollTillThread }

constructor TPollTillThread(MPComms : TMPComms);
begin
  FMPComms := MPComms;
end;

procedure TPollTillThread.Execute;
begin
  FreeOnTerminate := TRUE;
  while (FMPComms.lCommands.Count > 0) do begin
    FMPComms.ExecuteCommand(FMPComms.lCommands.Objects[0]);
    FMPComms.lCommands.Delete(0);
  end;{while}
  PollTill.Free;
end;

end.
