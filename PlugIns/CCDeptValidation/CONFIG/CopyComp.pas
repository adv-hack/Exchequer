unit CopyComp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CCDeptU;

type
  TfrmCopy = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cmbSource: TComboBox;
    cmbDestination: TComboBox;
    btnClose: TButton;
    btnCopy: TButton;
    procedure btnCopyClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure cmbSourceChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    bCopied : boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses
  BTFile, Main;

{$R *.DFM}

procedure TfrmCopy.btnCopyClick(Sender: TObject);
var
  pFrom, pTo : pChar;
begin
  if MessageDlg('Are you sure you want to copy the configuration ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin

    pFrom := StrAlloc(101);
    pTo := StrAlloc(101);

    StrPCopy(pFrom,IncludeTrailingBackslash(Trim(TCompanyInfo(cmbSource.Items.Objects[cmbSource.ItemIndex]).Path)) + CCDEPT_DAT);
    StrPCopy(pTo, IncludeTrailingBackslash(Trim(TCompanyInfo(cmbDestination.Items.Objects[cmbDestination.ItemIndex]).Path)) + CCDEPT_DAT);

    CopyFile(pFrom, pTo, FALSE);

    StrDispose(pFrom);
    StrDispose(pTo);

//    CopyFile(PChar(IncludeTrailingBackslash(TCompanyInfo(cmbSource.Items.Objects[cmbSource.ItemIndex]).Path) + CCDEPTINI)
//    , PChar(IncludeTrailingBackslash(TCompanyInfo(cmbDestination.Items.Objects[cmbDestination.ItemIndex]).Path) + CCDEPTINI), FALSE);
    bCopied := TRUE;
    MessageDlg('Configuration Copied',mtInformation,[mbOK],0);
  end;{if}
end;

procedure TfrmCopy.btnCloseClick(Sender: TObject);
begin
  if bCopied then ModalResult := mrOK
  else Close;
end;

procedure TfrmCopy.cmbSourceChange(Sender: TObject);
begin
  btnCopy.Enabled := cmbSource.ItemIndex <> cmbDestination.ItemIndex;
end;

procedure TfrmCopy.FormCreate(Sender: TObject);
begin
  bCopied := FALSE;
end;

end.
