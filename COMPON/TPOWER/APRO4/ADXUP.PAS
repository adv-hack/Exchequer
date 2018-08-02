{*********************************************************}
{*                    ADXUP.PAS 4.03                     *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdXUp;

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
  TUploadDialog = class(TForm)
    Protocols: TRadioGroup;
    Panel1: TPanel;
    Label1: TLabel;
    FileMask: TEdit;
    OK: TButton;
    Cancel: TButton;
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  public
    function GetProtocol : TProtocolType;
    procedure SetProtocol(NewProt : TProtocolType);
    function GetMask : String;
    procedure SetMask(NewMask : String);

    property Protocol : TProtocolType
      read GetProtocol write SetProtocol;
    property Mask : String
      read GetMask write SetMask;

    { Public declarations }
  end;

var
  UploadDialog: TUploadDialog;

implementation

{$R *.DFM}

function TUploadDialog.GetProtocol : TProtocolType;
begin
  Result := TProtocolType(Protocols.ItemIndex+1);
end;

procedure TUploadDialog.SetProtocol(NewProt : TProtocolType);
begin
  Protocols.ItemIndex := Ord(NewProt)-1;
end;

function TUploadDialog.GetMask : String;
begin
  Result := FileMask.Text;
end;

procedure TUploadDialog.SetMask(NewMask : String);
begin
  FileMask.Text := NewMask;
end;

procedure TUploadDialog.OKClick(Sender: TObject);
begin
  ModalResult := idOK;
end;

procedure TUploadDialog.CancelClick(Sender: TObject);
begin
  ModalResult := idCancel;
end;

end.
