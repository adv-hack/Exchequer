{**********************************************************}
{*                     SENDFAX1.PAS                       *}
{*   Copyright (c) TurboPower Software Company 1996-98    *}
{*                  All rights reserved                   *}
{**********************************************************}

unit Sendfax1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TsfFaxList = class(TForm)
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
  sfFaxList: TsfFaxList;

implementation

{$R *.DFM}

procedure TsfFaxList.flActionClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TsfFaxList.flCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TsfFaxList.GetFaxName : String;
begin
  Result := flFileName.Text;
end;

procedure TsfFaxList.SetFaxName(const NewName : String);
begin
  flFileName.Text := NewName;
end;

function TsfFaxList.GetCoverName : String;
begin
  Result := flCover.Text;
end;

procedure TsfFaxList.SetCoverName(const NewName : String);
begin
  flCover.Text := NewName;
end;

function TsfFaxList.GetPhoneNumber : String;
begin
  Result := flPhoneNumber.Text;
end;

procedure TsfFaxList.SetPhoneNumber(const NewNumber : String);
begin
  flPhoneNumber.Text := NewNumber;
end;

procedure TsfFaxList.FormActivate(Sender: TObject);
begin
  flPhoneNumber.SetFocus;
end;

end.
