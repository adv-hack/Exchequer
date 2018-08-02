unit FaxDirs;

{ nfrewer440 10:20 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, APIUtil;

type
  TfrmFaxSubDirs = class(TForm)
    edtNormalDir: Text8Pt;
    edtFailedDir: Text8Pt;
    edtArchivedDir: Text8Pt;
    edtOffPeakDir: Text8Pt;
    edtUrgentDir: Text8Pt;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    btnClose: TButton;
    Button1: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFaxSubDirs: TfrmFaxSubDirs;

implementation

{$R *.DFM}

procedure TfrmFaxSubDirs.btnCloseClick(Sender: TObject);
var
  slDirs : TStringList;
  bExit : boolean;
begin
  bExit := TRUE;
  slDirs := TStringList.Create;
  slDirs.Sorted := TRUE;
  slDirs.Duplicates := dupError;
  try
    slDirs.Add(UpperCase(edtNormalDir.Text));
    slDirs.Add(UpperCase(edtUrgentDir.Text));
    slDirs.Add(UpperCase(edtOffPeakDir.Text));
    slDirs.Add(UpperCase(edtArchivedDir.Text));
    slDirs.Add(UpperCase(edtFailedDir.Text));
  except
    on EStringListError do begin
      MsgBox('You have 2 or more directories with the same name.',mtError,[mbOK],mbOK,'Naming Error');
      bExit := FALSE;
    end;{on}
  end;{try}
  slDirs.Free;
  if bExit then ModalResult := mrOk;
end;

end.
