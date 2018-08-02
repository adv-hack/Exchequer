unit IdealOpt;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type

  TIdealOptsRec = Record
    UserID : String[8];
    CompanyCode : String[3];
  end;

  TfrmIdealOptions = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    edtUserID: TEdit;
    Label1: TLabel;
    edtCompCode: TEdit;
    Label2: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetIdealOptions(const Filename : string;
                             var TheRec : TIdealOptsRec) : Boolean;


implementation

{$R *.DFM}

uses
  IniFiles;

function ReadIdealOptsFile(const Filename : string) : TIdealOptsRec;
var
  TheIni : TIniFile;
begin
  TheIni := TIniFile.Create(Filename);
  with Result do
  begin
   Try
    UserID  := UpperCase(TheIni.ReadString('Ideal','UserID',''));
   Finally
    TheIni.Free;
   End;
  end;
end;

procedure WriteIdealOptsFile(const Filename : string; const TheRec : TIdealOptsRec);
var
  TheIni : TIniFile;
begin
  TheIni := TIniFile.Create(Filename);
  with TheRec do
  begin
   Try
    TheIni.WriteString('Ideal','UserID',UserID);
   Finally
    TheIni.Free;
   End;
  end;
end;

function GetIdealOptions(const Filename : string;
                           var TheRec : TIdealOptsRec) : Boolean;
var
  frmIdealOptions: TfrmIdealOptions;
begin
  Result := True;
  with TheRec do
  begin
    TheRec := ReadIdealOptsFile(Filename);
  end; {with TheRec}

end;

procedure TfrmIdealOptions.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  edtUserID.Text := UpperCase(edtUserID.Text); {all letters must be capitals}
end;

end.
