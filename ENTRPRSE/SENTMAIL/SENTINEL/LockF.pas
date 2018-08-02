unit LockF;
{$ALIGN 1}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TForm1 = class(TForm)
    Button1: TButton;
    spRecNo: TSpinEdit;
    Label1: TLabel;
    chkStop: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  ElVar, ElObjs;

var
  SysRec : TSysRec;

procedure UpdateRec(RecNo : Integer);
var
  i : integer;
  CanRun : Boolean;
  Res : SmallInt;
begin
  with SysRec do
  begin
    UserID := 'ZZZZZZZZZZ';
    ElertName := 'System';
    i := RecNo;
    OutputType := TOutputLineType(i + Ord(Pred(eolSysEmail)));
    Repeat
      Res := GetEqual('', True);
      if Res = 0 then
      begin
        Line2 := FormatDateTime('hh:nn:ss:zzz', Now);
        Res := Save;

        if Res = 78 then
          Cancel;  //Unlocks record
      end;
    until Res <> 78;

  end;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  while not chkStop.Checked do
  begin
    Application.ProcessMessages;
    UpdateRec(Trunc(spRecNo.Value));
    Application.ProcessMessages;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SysRec := TSysRec.Create(ExtractFilePath(Application.exeName));
  SysRec.OpenFile;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SysRec.CloseFile;
  SysRec.Free;
end;

end.
