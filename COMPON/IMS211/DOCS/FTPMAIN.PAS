unit ftpmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mssocket, msFTP, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ServerEdit: TEdit;
    UserNameEdit: TEdit;
    PasswordEdit: TEdit;
    FileNameEdit: TEdit;
    UploadButton: TButton;
    msFTPClient1: TmsFTPClient;
    procedure UploadButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.UploadButtonClick(Sender: TObject);
begin
  msFTPClient1.Host:=ServerEdit.Text;
  msFTPClient1.UserName:=UserNameEdit.Text;
  msFTPClient1.Password:=PasswordEdit.Text;
  msFTPClient1.Login;
  msFTPClient1.StoreFile(FileNameEdit.Text,ExtractFileName(FileNameEdit.Text));
  msFTPClient1.Logout;
end;

end.
