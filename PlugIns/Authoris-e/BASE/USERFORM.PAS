unit UserForm;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmPaUserID = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    edtUserID: TEdit;
    edtPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblReason: TLabel;
    btnEar: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses
  {Comu,} KeyPress;

{$R *.DFM}

procedure TfrmPaUserID.FormActivate(Sender: TObject);
begin
 { if not IsLibrary then
    Form1.EntCustom1.IntF.SysFunc.entActivateClient(Self.Handle);}
end;

procedure TfrmPaUserID.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TfrmPaUserID.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl);
end;

end.
