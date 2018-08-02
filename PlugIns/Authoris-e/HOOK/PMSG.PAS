unit pmsg;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, sbs_Int,
  StdCtrls, ExtCtrls;

type
  TPMsgForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
    InPrint : Boolean;
    PrintHwnd : HWnd;

    procedure PrintProgress(var Msg: TMessage); message WM_PrintProgress;
  public
    { Public declarations }
  end;

var
  PMsgForm: TPMsgForm;

implementation

{$R *.DFM}
{uses
  ComU;}

procedure TPMsgForm.PrintProgress(var Msg: TMessage);
Const
  YN  :  Array[False..True] of Char = ('N','Y');
Begin
  With Msg Do Begin
    { Mode passes in WParam }
    Case WParam Of
      0  : ; { ? }
      1  : ; { Set Progress percentage within threads bar graph}

      { Set HWnd }
      2  :  begin
              PrintHwnd := LParam;
            end;

      { Set InPrint Flag }
      3  :  begin
              InPrint := (LParam = 1);
            end;
      { Check InPrint Flag }
      4  :  begin
              SendMessage(LParam,WM_InPrint,Ord(InPrint),0);
            end;

      10 : ; { Clear Progress }
      11 : ; { Set Progress percentage }
    End; { Case }
  End; { With }
End;


procedure TPMsgForm.FormCreate(Sender: TObject);
begin
  InPrint := False;
  PrintHwnd := 0;

end;

procedure TPMsgForm.FormActivate(Sender: TObject);
begin
{$IFNDEF ERM}
{  if not IsLibrary then
    Form1.EntCustom1.IntF.SysFunc.entActivateClient(Self.Handle);}
{$ENDIF}
end;

procedure TPMsgForm.FormHide(Sender: TObject);
begin
{$IFNDEF ERM}
{  if not IsLibrary then
    Form1.EntCustom1.IntF.SysFunc.entActivateClient(Self.Handle);}
{$ENDIF}
end;

end.
