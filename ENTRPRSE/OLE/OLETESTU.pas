unit oletestu;

{ markd6 12:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OLEAuto, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    TitleLbl: TLabel;
    Label1: TLabel;
    OLELbl: TLabel;
    ErrLbl: TLabel;
    OdbcLbl: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    EntOLE : Variant;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses Registry;

Const
  PervName = 'PERVASIVE SOFTWARE ODBC-32';

{ Check to see if Pervasive Software ODBC-32 is Installed }
Function GotPervyDriver : Boolean;
Var
  RegObj  : TRegistry;
Begin
  Result := False;

  { Create registry access object }
  RegObj := TRegistry.Create;
  Try
    RegObj.RootKey := HKEY_LOCAL_MACHINE;

    If RegObj.OpenKey('Software\ODBC\ODBCINST.INI\ODBC Drivers', False) Then Begin
      { See If Pervasive value is there }
      Result := RegObj.ValueExists(PervName);
    End; { If }
  Finally
    RegObj.CloseKey;
    RegObj.Free;
  End;
End;


procedure TForm1.FormCreate(Sender: TObject);
begin
  { Force Screen to paint properly }
  Refresh;

  Try
    { Load OLE Server }
    EntOLE := CreateOleObject('Enterprise.OLEServer');

    { Display version }
    OleLbl.Caption := 'Server Version: ' + EntOLE.Version;
  Except
    On Ex:Exception Do Begin
      OleLbl.Caption := 'The following error occured attempting to load the OLE Server:';
      ErrLbl.Caption := '"'+ Ex.Message + '"';

    End;
  End;

  If GotPervyDriver Then
    OdbcLbl.Caption := 'Driver Found'
  Else
    OdbcLbl.Caption := 'Driver Not Found';
end;

end.



