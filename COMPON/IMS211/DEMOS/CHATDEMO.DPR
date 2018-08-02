program ChatDemo;

uses
  Forms,
  ChatMain in 'ChatMain.pas' {ChatForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TChatForm, ChatForm);
  Application.Run;
end.
