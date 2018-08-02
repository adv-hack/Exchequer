program E365View;

uses
  Forms,
  ViewerF in 'ViewerF.pas' {frmOLEServerMapViewer},
  MemoryMap in '..\Common\MemoryMap.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer v7.0.2 Memory Map Viewer';
  Application.CreateForm(TfrmOLEServerMapViewer, frmOLEServerMapViewer);
  Application.Run;
end.
