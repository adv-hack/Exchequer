unit Unit1;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure WMSYSCOMMAND (Var Msg : TMessage); Message WM_SYSCOMMAND;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Const
  SC_Menu1 = $F0; //WM_USER + 1;
  SC_Menu2 = $F1; //WM_USER + 2;

procedure TForm1.FormCreate(Sender: TObject);
Var
  SysMenu  : HMenu;
  MF_Check : Integer;
begin
  SysMenu := GetSystemMenu (Handle, False);

  AppendMenu(SysMenu, MF_SEPARATOR, 0, '');
  AppendMenu(SysMenu, MF_STRING, SC_Menu1, 'Menu1');
  AppendMenu(SysMenu, MF_STRING, SC_Menu2, 'Menu2');

  MF_Check := MF_UnChecked;

  ModifyMenu(SysMenu,SC_Menu1,MF_ByCommand+MF_String+MF_Check,SC_Menu1,'&Auto Minimize');
  ModifyMenu(SysMenu,SC_Menu2,MF_ByCommand+MF_String+MF_Check,SC_Menu2,'A&uto Maximize');
end;

Procedure TForm1.WMSYSCOMMAND (Var Msg : TMessage);
Begin { WMSYSCOMMAND }
  Case Msg.WParam Of
     SC_Menu1 : ShowMessage ('SC_Menu1');
     SC_Menu2 : ShowMessage ('SC_Menu2');
  Else
    Inherited;
  End; { Case }
End; { WMSYSCOMMAND }

end.
