program MemoText;

uses
  Forms,
  MDIFrame in 'MDIFrame.pas' {FrameForm},
  MDIEdit in 'MDIEdit.pas' {EditForm},
  SpellUtil in '..\..\..\ENTRPRSE\FUNCS\SpellUtil.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'MemoText';
  Application.CreateForm(TFrameForm, FrameForm);
  Application.Run;
end.
