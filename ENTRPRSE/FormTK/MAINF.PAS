unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GlobType;

type
  TfrmFormToolkit = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure PrintProgress(var Msg: TMessage); message WM_PrintProgress;
  public
    { Public declarations }
    InPrint : Boolean;
  end;

var
  frmFormToolkit: TfrmFormToolkit;

implementation

{$R *.dfm}

//----------------------------------------

procedure TfrmFormToolkit.FormCreate(Sender: TObject);
begin
  InPrint := False;
end;

//----------------------------------------

procedure TfrmFormToolkit.PrintProgress(var Msg: TMessage);
begin
  With Msg Do
    { Mode passed in WParam }
    Case WParam Of
      { Set Progress percentage within threads bar graph}
      1 : ;

      { Set HWnd }
      2 : ; //PrintHwnd := LParam;

      { Set InPrint Flag }
      3 : ; //InPrint := (LParam = 1);

      { Check InPrint Flag }
      4 : SendMessage(LParam,WM_InPrint,Ord(InPrint),0);

      { Clear Progress }
      10 : ;

      { Set Progress percentage }
      11 : ;

      // HM 09/10/00: Change Notification for Form Definition Sets
      90 : ;
    End; { Case WParam }

end;

end.
