unit TestF;

interface
//Test program for KonnectIT backdoor to toolkit.
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  COMObj, Enterprise01_TLB, StdCtrls;

type
  TfrmCustList = class(TForm)
    btnOpen: TButton;
    Label1: TLabel;
    lblVersion: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOpenClick(Sender: TObject);
  private
    { Private declarations }
    oToolkit : IToolkit;
  public
    { Public declarations }
  end;

var
  frmCustList: TfrmCustList;

implementation

{$R *.DFM}

Procedure Konnect_CTKDebugMode (Var I1, I2, I3 : LongInt); StdCall; External 'ExchKonnect.dll';

procedure TfrmCustList.FormCreate(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  // Create COM Toolkit object
  oToolkit := CreateOLEObject ('Enterprise01.Toolkit') as IToolkit;

  if Assigned(oToolkit) then
    lblVersion.Caption := oToolkit.Version
  else
    btnOpen.Enabled := False;
end;

//-----------------------------------------------------------------------

procedure TfrmCustList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If Assigned(oToolkit) Then Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }
end;

procedure TfrmCustList.btnOpenClick(Sender: TObject);
var
  i1, i2, i3 : longint;
  Res : integer;
begin
  i1 := 1955;
  i2 := 364759;
  i3 := -612498;

  Konnect_CTKDebugMode(i1, i2, i3);

  oToolkit.Configuration.SetDebugMode(i1, i2, i3);

  Res := oToolkit.OpenToolkit;

  if Res = 0 then
    ShowMessage('Toolkit opened successfully')
  else
    ShowMessage('Unable to open toolkit: ' + IntToStr(Res) + #10#10 + QuotedStr(oToolkit.LastErrorString));

end;

end.
