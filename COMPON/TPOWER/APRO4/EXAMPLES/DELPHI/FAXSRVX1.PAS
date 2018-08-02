{*********************************************************}
{*                     FAXSRVX1.PAS                      *}
{*       Copyright (c) TurboPower Software 1997,98       *}
{*                 All rights reserved.                  *}
{*********************************************************}

unit FaxSrvx1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TfsFaxList = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    flFileName: TEdit;
    Label2: TLabel;
    flCover: TEdit;
    Label3: TLabel;
    flPhoneNumber: TEdit;
    flAction: TButton;
    flCancel: TButton;
    procedure flActionClick(Sender: TObject);
    procedure flCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    function GetFaxName : String;
    procedure SetFaxName(const NewName : String);
    function GetCoverName : String;
    procedure SetCoverName(const NewName : String);
    function GetPhoneNumber : String;
    procedure SetPhoneNumber(const NewNumber : String);

  public
    property FaxName : String
      read GetFaxName write SetFaxName;
    property CoverName : String
      read GetCoverName write SetCoverName;
    property PhoneNumber : String
      read GetPhoneNumber write SetPhoneNumber;

    { Public declarations }
  end;

var
  fsFaxList: TfsFaxList;

implementation

{$R *.DFM}

procedure TfsFaxList.flActionClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfsFaxList.flCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TfsFaxList.GetFaxName : String;
begin
  Result := flFileName.Text;
end;

procedure TfsFaxList.SetFaxName(const NewName : String);
begin
  flFileName.Text := NewName;
end;

function TfsFaxList.GetCoverName : String;
begin
  Result := flCover.Text;
end;

procedure TfsFaxList.SetCoverName(const NewName : String);
begin
  flCover.Text := NewName;
end;

function TfsFaxList.GetPhoneNumber : String;
begin
  Result := flPhoneNumber.Text;
end;

procedure TfsFaxList.SetPhoneNumber(const NewNumber : String);
begin
  flPhoneNumber.Text := NewNumber;
end;

procedure TfsFaxList.FormActivate(Sender: TObject);
begin
  flPhoneNumber.SetFocus;
end;

end.
