unit about;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;


type
  TfrmAbout = class(TForm)
    btnOK: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Bevel2: TBevel;
    Memo1: TMemo;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function EbusAdminVersion : string;

{var
  frmAbout: TfrmAbout;}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}
uses
  StrUtil, ExchequerRelease, EbusUtil;

function EbusAdminVersion : string;
begin
  Result := 'Version: ' + ExchequerModuleVersion(emEbusinessAdmin, BuildNo);
end;

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  Memo1.Lines.Add(EbusAdminVersion);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetCompanyNameString);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetExchequerTrademarkString);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetCopyRightMessage);
end;

end.
