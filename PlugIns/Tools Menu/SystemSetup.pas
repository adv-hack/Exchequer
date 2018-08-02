unit SystemSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ToolBTFiles, BTConst, BTUtil, StrUtil;

type
  TfrmSystemSetup = class(TForm)
    edPassword: TEdit;
    lPassword: TLabel;
    Bevel1: TBevel;
    cbUsePassword: TCheckBox;
    btnCancel: TButton;
    btnOK: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbUsePasswordClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSystemSetup: TfrmSystemSetup;

implementation

{$R *.dfm}

procedure TfrmSystemSetup.FormShow(Sender: TObject);
var
  BTRec : TBTRec;
  LToolRec : TToolRec;
begin
  // Get System Setup Record
  BTRec.KeyS := RT_SystemSetup + BuildA10Index('');
  BTRec.Status := BTFindRecord(BT_GetEqual, FileVar[ToolF], LToolRec, BufferSize[ToolF]
  , ssIdx, BTRec.KeyS);
  case BTRec.Status of
    0 : begin
      cbUsePassword.checked := LToolRec.SysSetup.ssUsePassword;
      edPassword.Text := UnScramble(LToolRec.SysSetup.ssPassword);
//      cbUsePasswordClick(cbUsePassword);
    end;
    4,9 : begin
      // System Setup Record Has not been added yet
    end;
  end;{case}
  cbUsePasswordClick(cbUsePassword);
end;

procedure TfrmSystemSetup.btnOKClick(Sender: TObject);
var
  BTRec : TBTRec;
  LToolRec : TToolRec;
begin
  // Get System Setup Record
  BTRec.KeyS := RT_SystemSetup + BuildA10Index('');
  BTRec.Status := BTFindRecord(BT_GetEqual, FileVar[ToolF], LToolRec, BufferSize[ToolF]
  , ssIdx, BTRec.KeyS);
  case BTRec.Status of
    0 : begin
      // udpdate System Setup Record
      LToolRec.SysSetup.ssUsePassword := cbUsePassword.checked;
      LToolRec.SysSetup.ssPassword := Scramble(Uppercase(edPassword.Text));
      SetSystemSetupIndexes(LToolRec);
      BTRec.Status := BTUpdateRecord(FileVar[ToolF], LToolRec, BufferSize[ToolF], ssIdx, BTRec.KeyS);
      BTShowError(BTRec.Status, 'BTUpdateRecord', asAppDir + aFileNames[ToolF]);
    end;
    4,9 : begin
      // System Setup Record Has not been added yet
      FillChar(LToolRec, SizeOf(LToolRec),#0);
      LToolRec.RecordType := RT_SystemSetup;
      LToolRec.SysSetup.ssUsePassword := cbUsePassword.checked;
      LToolRec.SysSetup.ssPassword := Scramble(Uppercase(edPassword.Text));
      SetSystemSetupIndexes(LToolRec);
      BTRec.Status := BTAddRecord(FileVar[ToolF], LToolRec, BufferSize[ToolF], ssIdx);
      BTShowError(BTRec.Status, 'BTAddRecord', asAppDir + aFileNames[ToolF]);
    end;
  end;{case}
  if (BTRec.Status = 0) then Close;
end;

procedure TfrmSystemSetup.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSystemSetup.cbUsePasswordClick(Sender: TObject);
begin
  edPassword.Enabled := cbUsePassword.Checked;
  lPassword.Enabled := edPassword.Enabled;
end;

end.
