unit StkHook;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, EntCustom, Enterprise_TLB;

type
  TForm1 = class(TForm)
    EntCustom1: TEntCustom;
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure EntCustom1Connect(CustomConfig: ICOMCustomConfig);
    procedure EntCustom1Hook(EnterpriseSystem: ICOMCustomisation);
    procedure EntCustom1Close;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  EntCustom1.Connect;
end;

procedure TForm1.EntCustom1Connect(CustomConfig: ICOMCustomConfig);
begin
  With CustomConfig Do Begin
    { Trans Line - Set Stock Code }
    SetHandlerStatus (wiTransLine, 15, esEnabled);
  End; { With CustomConfig }
end;

procedure TForm1.EntCustom1Hook(EnterpriseSystem: ICOMCustomisation);
begin
  Try
    With EnterpriseSystem Do Begin
      ListBox1.Items.Add (Format('%10.10d  %3.3d', [WindowId, HandlerId]));

      If (WindowId = wiTransLine) And (HandlerId = 15) Then Begin
        { TL - Exit Stock Code - Before Validation }
        Transaction.thLines.thCurrentLine.tlStockCode := 'BLUE';
      End; { If }
    End; { With EnterpriseSystem }
  Except
    On Ex:Exception Do
      MessageDlg ('The following error occured processing a hook:-' + #13#13 + Ex.Message, mtError, [mbOk], 0);
  End;
end;

procedure TForm1.EntCustom1Close;
begin
  Application.Terminate;
end;

end.
