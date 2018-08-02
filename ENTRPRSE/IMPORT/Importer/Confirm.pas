unit Confirm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, EntLicence;

type
  TfrmConfirm = class(TForm)
    btnChange: TButton;
    btnLogin: TButton;
    Label1: TLabel;
    lblJobCompany: TLabel;
    lblCompany: TLabel;
    Label2: TLabel;
    lblOptions: TLabel;
    Image1: TImage;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
{* Property Fields *}
    FLoginCompany: string;
    FJobCompany: string;
    FOptionsCaption: string;
    FJobFile: string;
{* Procedural Methods *}
    procedure GetIcon;
{* Getters and Setters *}
    procedure SetLoginCompany(const Value: string);
    procedure SetVersionAndCopyright;
    procedure SetJobCompany(const Value: string);
    procedure SetOptionsCaption(const Value: string);
    procedure SetJobFile(const Value: string);
  public
    property JobFile: string read FJobFile write SetJobFile;
    property JobCompany: string read FJobCompany write SetJobCompany;
    property LoginCompany: string read FLoginCompany write SetLoginCompany;
    property OptionsCaption: string read FOptionsCaption write SetOptionsCaption;
  end;

implementation

uses ShellAPI, StrUtil, GlobalConsts;

{$R *.dfm}

{ TfrmConfirm }

{* Procedural Methods *}

procedure TfrmConfirm.GetIcon;
// get the standard mtConfirmation icon that MessageDlg would display.
var
  TmpIcon: TICON;
  i, j: integer;
  SysDir: array[0..MAX_PATH] of char;
begin
  tmpIcon := TIcon.Create;
  try
    GetSystemDirectory(SysDir, MAX_PATH);
    tmpIcon.Handle := ExtractIcon(hInstance, pchar(IncludeTrailingPathDelimiter(SysDir) + 'User32.dll'), 2);
    tmpIcon.Transparent := true;

    If TmpIcon.handle > 1 then begin
      image1.picture.Bitmap.Width  := TmpIcon.Width;
      image1.Picture.Bitmap.Height := TmpIcon.Height;
      for i := 0 to 31 do
        for j := 0 to 31 do
         image1.Picture.Bitmap.Canvas.pixels[i,j] := clBtnFace; // otherwise BG is white
      image1.Picture.Bitmap.Canvas.Draw(0, 0, TmpIcon);
    end;

  finally
    TmpIcon.Free;
  end;
end;

{* Event Procedures *}

procedure TfrmConfirm.FormShow(Sender: TObject);
begin
  if EnterpriseLicence.IsLITE then
    caption := 'IRIS Accounts Office Importer - [' + ExtractFileName(JobFile) + ']'
  else
    caption := 'Exchequer Importer - [' + ExtractFileName(JobFile) + ']';
  lblJobCompany.Caption := FJobCompany;
  lblCompany.Caption    := FLoginCompany;
end;

procedure TfrmConfirm.FormCreate(Sender: TObject);
begin
  GetIcon;
  SetVersionAndCopyright;
end;


{* Getters and Setters *}

procedure TfrmConfirm.SetLoginCompany(const Value: string);
begin
  FLoginCompany := Value;
end;

procedure TfrmConfirm.SetVersionAndCopyright;
begin
//  lblVersion.caption   := APPVERSION;
//  lblCopyright.Caption := GetCopyrightMessage;
end;

procedure TfrmConfirm.SetJobCompany(const Value: string);
begin
  FJobCompany := Value;
end;

procedure TfrmConfirm.SetOptionsCaption(const Value: string);
begin
  lblOptions.Caption := Value;
end;

procedure TfrmConfirm.SetJobFile(const Value: string);
begin
  FJobFile := Value;
end;

end.
