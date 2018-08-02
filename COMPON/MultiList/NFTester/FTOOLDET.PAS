unit ftooldet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TToolDetails = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    btnBrowse: TButton;
    edtTitle: TEdit;
    edtPath: TEdit;
    OpenDialog1: TOpenDialog;
    Label3: TLabel;
    edtParams: TEdit;
    BtnBrowse2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure BtnBrowse2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OK : Boolean;
  end;

var
  ToolDetails: TToolDetails;

implementation

{$R *.DFM}

procedure TToolDetails.FormCreate(Sender: TObject);
begin
  OK := False;
end;

{ OK }
procedure TToolDetails.btnOkClick(Sender: TObject);
begin
  OK := (Trim(edtTitle.Text) <> '') And
        (Trim(edtPath.Text) <> '');

  If OK Then Close;
end;

{ Cancel }
procedure TToolDetails.btnCancelClick(Sender: TObject);
begin
  OK := False;
  Close;
end;

procedure TToolDetails.btnBrowseClick(Sender: TObject);
Var
  CurrPath : ShortString;
begin
  { Save current path }
  CurrPath := GetCurrentDir;

  Try
    OpenDialog1.FileName := ExtractFileName(Trim(edtPath.Text));
    OpenDialog1.InitialDir := ExtractFilePath(Trim(edtPath.Text));

    If OpenDialog1.Execute Then Begin
      { Have got a file }
      edtPath.Text := OpenDialog1.FileName;
    End; { If }
  Except
    On Exception Do ;
  End;

  { restore current path }
  SetCurrentDir(CurrPath);
end;

procedure TToolDetails.BtnBrowse2Click(Sender: TObject);
Var
  CurrPath : ShortString;
begin
  { Save current path }
  CurrPath := GetCurrentDir;

  Try
    OpenDialog1.FileName := ExtractFileName(Trim(edtParams.Text));
    OpenDialog1.InitialDir := ExtractFilePath(Trim(edtParams.Text));

    If OpenDialog1.Execute Then Begin
      { Have got a file }
      edtParams.Text := OpenDialog1.FileName;
    End; { If }
  Except
    On Exception Do ;
  End;

  { restore current path }
  SetCurrentDir(CurrPath);
end;

end.
