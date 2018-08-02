unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Sentimail_TLB, ComObj, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Timer1: TTimer;
    Button2: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    oEvent : ISentimailEvent;
    bMainCo : Boolean;
    procedure StoreTrans(const sDataPath, sOurRef : string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
const
  Paths : Array[False..True] of String[25] = ('c:\Ent67SQL\', 'c:\Ent67SQL\');
  OurRefs : Array[False..True] of String[9] = ('SOR000852', 'SOR000850');

procedure TForm1.Button1Click(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  oEvent := CreateOLEObject('Sentimail.SentimailEvent') as ISentimailEvent
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  oEvent := nil;
end;

procedure TForm1.StoreTrans(const sDataPath, sOurRef: string);
var
  Res : Integer;
begin
  if Assigned(oEvent) then
  begin
    oEvent.seWindowID := 102000;
    oEvent.seHandlerID := 170;
    oEvent.seDataType := edtTransaction;
    oEvent.seDataPath := sDataPath;
    oEvent.seKey := sOurRef;
    Res := oEvent.Save;
    Label1.Caption := sOurRef;
    Label1.Refresh;
    Application.ProcessMessages;
  end
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  StoreTrans(Paths[bMainco], OurRefs[bMainCo]);
  bMainCo := not bMainCo;
  Timer1.Enabled := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

end.
