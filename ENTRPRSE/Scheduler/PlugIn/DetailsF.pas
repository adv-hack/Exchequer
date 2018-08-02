unit DetailsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, EnterToTab;

const
  OutFilename = 'c:\PlugTest.ini';

type
  TfrmDetails = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    pnlNext: TPanel;
    pnlPrev: TPanel;
    EnterToTab1: TEnterToTab;
    Label2: TLabel;
    procedure pnlNextEnter(Sender: TObject);
    procedure pnlPrevEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NextControl, PrevControl : HWND;
    procedure Save;
  end;

  function ShowDetailsWindow(Wnd : HWND) : TfrmDetails;

var
  OutputFile : string;



implementation

{$R *.dfm}
function ShowDetailsWindow(Wnd : HWND) : TfrmDetails;
begin
  Result := TfrmDetails.CreateParented(Wnd);
  Result.Top := 2;
  Result.Left := 2;
  Result.Edit1.Text := OutputFile;
  Result.Visible := True;
  Result.ActiveControl := Result.Edit1;
end;

procedure TfrmDetails.Save;
begin
  OutputFile := Edit1.Text;
end;

{pnlNext and pnlPrev are 1 pixel * 1 pixel panels at the start and end of the tab order. When we tab
to one of them, then we need to re-direct the focus to the appropriate control on the host form}
procedure TfrmDetails.pnlNextEnter(Sender: TObject);
begin
  if NextControl <> 0 then
    Windows.SetFocus(NextControl);
end;

procedure TfrmDetails.pnlPrevEnter(Sender: TObject);
begin
  if PrevControl <> 0 then
    Windows.SetFocus(PrevControl);
end;

end.
