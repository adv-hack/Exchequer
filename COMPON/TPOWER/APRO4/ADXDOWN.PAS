{*********************************************************}
{*                   ADXDOWN.PAS 4.03                    *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdXDown;

interface

uses
  SysUtils,
  WinTypes,
  WinProcs,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  AdProtcl;

type
  TDownloadDialog = class(TForm)
    Panel1: TPanel;
    DestDirLabel: TLabel;
    Directory: TEdit;
    FileNameLabel: TLabel;
    FileName: TEdit;
    Protocols: TRadioGroup;
    OK: TButton;
    Cancel: TButton;
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ProtocolsClick(Sender: TObject);
  public
    function GetDestDirectory : String;
    procedure SetDestDirectory(NewDir : String);
    function GetReceiveName : String;
    procedure SetReceiveName(NewName : String);
    function GetProtocol : TProtocolType;
    procedure SetProtocol(NewProt : TProtocolType);

    property DestDirectory : String
      read GetDestDirectory write SetDestDirectory;
    property ReceiveName : String
      read GetReceiveName write SetReceiveName;
    property Protocol : TProtocolType
      read GetProtocol write SetProtocol;
  end;

var
  DownloadDialog: TDownloadDialog;

implementation

{$R *.DFM}

function TDownloadDialog.GetDestDirectory : String;
begin
  Result := Directory.Text;
end;

procedure TDownloadDialog.SetDestDirectory(NewDir : String);
begin
  Directory.Text := NewDir;
end;

function TDownloadDialog.GetReceiveName : String;
begin
  Result := FileName.Text;
end;

procedure TDownloadDialog.SetReceiveName(NewName : String);
begin
  FileName.Text := NewName;
end;

function TDownloadDialog.GetProtocol : TProtocolType;
begin
  Result := TProtocolType(Protocols.ItemIndex+1);
end;

procedure TDownloadDialog.SetProtocol(NewProt : TProtocolType);
begin
  Protocols.ItemIndex := Ord(NewProt)-1;
end;

procedure TDownloadDialog.OKClick(Sender: TObject);
begin
  ModalResult := idOK;
end;

procedure TDownloadDialog.CancelClick(Sender: TObject);
begin
  ModalResult := idCancel;
end;

procedure TDownloadDialog.ProtocolsClick(Sender: TObject);
begin
  case Protocols.ItemIndex of
    0..3, 8 :
      begin
        FileNameLabel.Enabled := True;
        FileName.Enabled := True;
      end;
    else begin
      FileName.Text := '';;
      FileNameLabel.Enabled := False;
      FileName.Enabled := False;
    end;
  end;
end;

end.
