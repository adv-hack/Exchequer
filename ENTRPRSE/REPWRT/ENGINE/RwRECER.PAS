unit RwRECER;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, TEditVal, ExtCtrls;

type
  TFormRecurseErr = class(TForm)
    ListVw_Controls: TListView;
    Panel1: TPanel;
    Label81: Label8;
    Panel2: TPanel;
    btnOK: TButton;
    Label82: Label8;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  end;

var
  FormRecurseErr: TFormRecurseErr;

implementation

{$R *.DFM}

Procedure TFormRecurseErr.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ do Begin
    ptMinTrackSize.X:=435;
    ptMinTrackSize.Y:=175;

    ptMaxTrackSize.X:=435;
    ptMaxTrackSize.Y:=560;
  end;

  Message.Result:=0;

  Inherited;
end;


procedure TFormRecurseErr.btnOKClick(Sender: TObject);
begin
  Close;
end;

end.
