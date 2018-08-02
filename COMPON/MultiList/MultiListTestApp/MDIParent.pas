unit MDIParent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ToolWin, ComCtrls, PromptPayDebt;

type
  TfrmMDIParent = class(TForm)
    ToolBar1: TToolBar;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure MLClick(Sender: TObject);
    procedure DBMLClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMDIParent: TfrmMDIParent;

implementation
uses
  DataDictFieldList, DBMultiList, Main;

{$R *.dfm}

procedure TfrmMDIParent.MLClick(Sender: TObject);
begin
  with TfrmMultiList.Create(Self) do
  begin
  end;
end;

procedure TfrmMDIParent.DBMLClick(Sender: TObject);
begin
  with TfrmDBMultiList.Create(Self) do
  begin
  end;
end;

procedure TfrmMDIParent.Button3Click(Sender: TObject);
begin
  with TfrmFieldList.Create(Self) do
  begin
  end;
end;

procedure TfrmMDIParent.Button4Click(Sender: TObject);
begin
  with TfrmDebt.Create(Self) do
  begin
  end;
end;

end.
