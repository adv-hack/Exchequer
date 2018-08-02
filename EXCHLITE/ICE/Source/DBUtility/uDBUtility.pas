unit uDBUtility;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, AdvMemo, AdvmSQLS;

type
  TfrmDbUtility = class(TForm)
    btnEncrypt: TButton;
    btnDecrypt: TButton;           
    btnLoad: TButton;
    odDbFile: TOpenDialog;
    sdDbFile: TSaveDialog;
    btnSave: TButton;
    mmScript: TMemo;
    procedure btnLoadClick(Sender: TObject);
    procedure btnEncryptClick(Sender: TObject);
    procedure btnDecryptClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDbUtility: TfrmDbUtility;

implementation
uses uCommon;

{$R *.dfm}

procedure TfrmDbUtility.btnLoadClick(Sender: TObject);
begin
  if odDbFile.Execute then
  begin
    mmScript.Clear;
    mmScript.Lines.LoadFromFile(odDbFile.FileName);
  end; {if odDbFile.Execute then}
end;

procedure TfrmDbUtility.btnEncryptClick(Sender: TObject);
var
  lAux, lAux2: String;
begin
  if mmScript.Lines.Count > 0 then
  begin
    {create temp file}
    lAux := _GetApplicationPath + _CreateGuidStr;
    lAux2 := _GetApplicationPath + _CreateGuidStr;
    mmScript.Lines.SaveToFile(lAux);
    mmScript.Clear;
    {try encryption}
    if _EncryptFile(lAux, lAux2) then
    begin
      if sdDbFile.Execute then
        CopyFile(pChar(lAux2), pChar(sdDbFile.filename), False)
    end
    else
      mmScript.Lines.Add('Error encrypting file...');
    _DelFile(lAux);
    _DelFile(lAux2);
  end; {if mmScript.Lines.Count > 0 then}
end;

procedure TfrmDbUtility.btnDecryptClick(Sender: TObject);
begin
  if odDbFile.Execute then
  begin
    {try decryption}
    if _DecryptFile(odDbFile.FileName) then
      mmScript.Lines.LoadFromFile(odDbFile.FileName)
    else
      mmScript.Lines.Add('Error decrypting file...');
  end; {if mmScript.Lines.Count > 0 then}
end;

procedure TfrmDbUtility.btnSaveClick(Sender: TObject);
begin
  if sdDbFile.Execute then
  begin
     mmScript.Lines.SaveToFile(sdDbFile.FileName);
  end;
end;

end.
