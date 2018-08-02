unit TestF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtInitPath: TEdit;
    lstCcyVer: TComboBox;
    btnInit: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    edtSavePath: TEdit;
    btnTrans: TButton;
    GroupBox3: TGroupBox;
    btnClose: TButton;
    edtOurRef: TEdit;
    procedure btnInitClick(Sender: TObject);
    procedure btnTransClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses XMLFuncs;

procedure TForm1.btnInitClick(Sender: TObject);
Var
  InitInfo : xmlInitInfoType;
  Res      : SmallInt;
begin
  FillChar (InitInfo, SizeOf(InitInfo), 0);
  With InitInfo Do Begin
    xiDataPath  := edtInitPath.Text;
    xiCcyVer    := lstCcyVer.ItemIndex;
  End; { With }

  Res := xmlInitDLL (InitInfo);
end;

procedure TForm1.btnTransClick(Sender: TObject);
Var
  TransInfo : xmlTransInfoType;
  Res       : SmallInt;
begin
  FillChar (TransInfo, SizeOf(TransInfo), 0);
  With TransInfo Do Begin
    xtSaveDir := edtSavePath.Text;
    xtOurRef  := edtOurRef.Text;

  End; { With }

  Res := xmlTransXMLFile (TransInfo);
end;

procedure TForm1.btnCloseClick(Sender: TObject);
Var
  Res : SmallInt;
begin
  Res := xmlCloseDLL;
end;

end.
