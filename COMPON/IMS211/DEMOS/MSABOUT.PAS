unit msabout;

interface

uses
  WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TAboutDlg = class(TForm)
    ProgramName: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    ProductVersion: TLabel;
    Label4: TLabel;
    OKButton: TButton;
    Image1: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutDlg: TAboutDlg;

implementation

uses msDef;

{$R *.DFM}

procedure TAboutDlg.FormCreate(Sender: TObject);
begin
  ProductVersion.Caption:=msVersion;
end;

end.
