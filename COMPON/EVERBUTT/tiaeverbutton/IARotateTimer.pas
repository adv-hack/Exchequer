unit IARotateTimer;

interface

uses
  Windows,Classes,Forms,Controls;

const
  cm_RotatedOn =cm_Base+105;

type
  TiaRotateTimer = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  public
    Dtime : integer;
    Handle1 : HWND;
  end;

implementation

{ Important: Methods and properties of objects in VCL can only be used in a
  method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TiaRotateTimer.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TiaRotateTimer }

procedure TiaRotateTimer.Execute;
begin
  repeat
    sleep(Dtime);
    sendmessage(Handle1,CM_ROTATEDON,0,0);
  until terminated;
   { Place thread code here }
end;

end.
