program MultiListTest;

uses
  Forms,
  Main in 'Main.pas' {frmMultiList},
  MDIParent in 'MDIParent.pas' {frmMDIParent},
  DBMultiList in 'DBMultiList.pas' {frmDBMultiList},
  Blank in 'Blank.pas' {frmBlank};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMDIParent, frmMDIParent);
  Application.Run;
end.
