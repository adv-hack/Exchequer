unit Rtfdemo;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, RPDefine, RPBase, RPSystem, RPMemo;

type
  TRTFDemoForm = class(TForm)
    ReportSystem1: TReportSystem;
    procedure ReportSystem1Print(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RTFDemoForm: TRTFDemoForm;

implementation

{$R *.DFM}

procedure TRTFDemoForm.ReportSystem1Print(Sender: TObject);

var
  MemoBuf: TMemoBuf;

begin
  MemoBuf := TMemoBuf.Create;
  With Sender as TBaseReport do try
    MemoBuf.PrintStart := SectionLeft;
    MemoBuf.PrintEnd := SectionRight;
    MemoBuf.RTFLoadFromFile('RPDEMO.RTF');
    PrintMemo(MemoBuf,0,false);
  finally
    MemoBuf.Free;
  end; { with }
end;

end.
