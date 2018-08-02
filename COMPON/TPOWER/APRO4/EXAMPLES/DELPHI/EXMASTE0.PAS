{*********************************************************}
{*                    EXMASTE0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*This example - along with the ExSlave DLL -            *}
{*   demonstrates how to create a custom dispatcher for  *}
{*   using an already open communications handle with    *}
{*   Async Professional.                                 *}
{*********************************************************} 

unit ExMaste0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    btnOpen: TButton;
    btnSlave: TButton;
    procedure btnOpenClick(Sender: TObject);
    procedure btnSlaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ComPortOpen : Boolean;
    ComHandle : THandle;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  if ComPortOpen then begin
    btnOpen.Caption := 'Open COM1';
    btnSlave.Enabled := False;
    CloseHandle(ComHandle);
    ComPortOpen := False;
  end else begin
    {Open handle to COM1}
    ComHandle := CreateFile('\\.\COM1',
                         GENERIC_READ or GENERIC_WRITE, {access attributes}
                         0,                             {no sharing}
                         nil,                           {no security}
                         OPEN_EXISTING,                 {creation action}
                         FILE_ATTRIBUTE_NORMAL or
                         FILE_FLAG_OVERLAPPED,          {attributes}
                         0);                            {no template}
    if ComHandle <> INVALID_HANDLE_VALUE then begin
      ComPortOpen := True;
      btnOpen.Caption := 'Close COM1';
      btnSlave.Enabled := True;
    end;
  end;
end;

procedure ShowTerminal(PortHandle : THandle); external 'ExSlave.dll';

procedure TForm1.btnSlaveClick(Sender: TObject);
begin
  {Call ExSlave.dll, passing the open handle to COM1}
  ShowTerminal(ComHandle);
end;

end.
