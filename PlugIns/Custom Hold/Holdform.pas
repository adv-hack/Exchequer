unit Holdform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom;

const
  sSQU = 1;
  sSOR = 2;
  sSDN = 4;
  sSIN = 8;
  sSCR = 16;
  sSRF = 32;
  sSJI = 64;
  sSRI = 128;
  sSJC = 256;

  SettingsFile = 'CH.DAT';
  PasswordKey = 17513;

type
  TSettingsRec = Record
    Bools  : longint;
    PWord  : string[12];
  end;

  TfrmHoldAdmin = class(TForm)
    GroupBox1: TGroupBox;
    edtSQU: TCheckBox;
    chkSOR: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox2: TCheckBox;
    SBSButton1: TSBSButton;
    SBSButton2: TSBSButton;
    SBSButton3: TSBSButton;
    procedure SBSButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FormToRec;
    procedure RecToForm;
  end;

  procedure ReadSettingsFile;
  procedure WriteSettingsFile;
  procedure ShowSettingsForm;
  function CheckPassword(const s : string) : Boolean;

var
  frmHoldAdmin: TfrmHoldAdmin;
  Settings : TSettingsRec;

implementation

uses
  Crypto, Pass2, Shared;
{$R *.dfm}

function CheckPassword(const s : string) : Boolean;
var
  s1 : string;
begin
  s1 := DecodeKey(PasswordKey, Settings.PWord);
  Result := s = s1;
end;


procedure ReadSettingsFile;
var
  F : File;
begin
  AssignFile(F, ExtractFilePath(Application.ExeName) + SettingsFile);
  Reset(F, 1);
  BlockRead(F, Settings, SizeOf(Settings));
end;

procedure WriteSettingsFile;
var
  F : File;
begin
  AssignFile(F, ExtractFilePath(Application.ExeName) + SettingsFile);
  Reset(F, 1);
  BlockWrite(F, Settings, SizeOf(Settings));
end;

procedure TfrmHoldAdmin.FormToRec;
var
  i : integer;
begin
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TCheckBox then
      with Components[i] as TCheckBox do
      begin
        if Checked then
          Settings.Bools := Settings.Bools or Tag
        else
          Settings.Bools := Settings.Bools and not Tag;
      end;
end;

procedure TfrmHoldAdmin.RecToForm;
var
  i : integer;
begin
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TCheckBox then
      with Components[i] as TCheckBox do
        Checked := Tag and Settings.Bools = Tag;
end;


procedure ShowSettingsForm;
begin
  with TfrmHoldAdmin.Create(nil) do
  Try
    ReadSettingsFile;
    RecToForm;
    ShowModal;
    if ModalResult = mrOK then
    begin
      FormToRec;
      WriteSettingsFile;
    end;
  Finally
    Free;
  End;
end;



procedure TfrmHoldAdmin.SBSButton3Click(Sender: TObject);
begin
  with TfrmPassWord.Create(nil) do
  Try
    ShowModal;
    if ModalResult = mrOK then
    begin
      Settings.PWord := EncodeKey(PasswordKey, Trim(edtPass.Text));
      WriteSettingsFile;
    end;
  Finally
    Free;
  End;
end;

procedure TfrmHoldAdmin.FormCreate(Sender: TObject);
begin
  Caption := 'Custom Hold Plug-in  Administration build ' + sVersionNo;
end;

Initialization
  FillChar(Settings, SizeOf(Settings), 0);

end.
