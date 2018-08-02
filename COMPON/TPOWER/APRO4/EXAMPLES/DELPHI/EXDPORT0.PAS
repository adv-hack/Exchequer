{***********************************************************}
{*                    EXDPORT0.PAS                         *}
{*      Copyright (c) TurboPower Software 1996-98          *}
{*                 All rights reserved.                    *}
{***********************************************************}

{**********************Description**************************}
{*Demonstrates how to dynamically create a TApdComPort and *}
{*   set the trigger events programmatically.              *}
{***********************************************************}

unit ExDPort0;
  {show dynamic creation of a port with data trigger}

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdPort;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    MyCP : TApdComPort;
    {note: trigger handlers must be method of a form}
    procedure MyTriggerAvail(CP : TObject; Count : Word);
    procedure MyTriggerData(CP : TObject; TriggerHandle : Word);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  {add a data trigger for "OK"}
  MyCP.AddDataTrigger('OK', False);
  MyCP.Output := 'ATZ'#13;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {dynamically create the com port}
  MyCP := TApdComPort.Create(Self);
  {set the com port properties}
  MyCP.ComNumber := 1;
  {attach a trigger avail handler to the new com port}
  MyCP.OnTriggerAvail := MyTriggerAvail;
  {attach a trigger data handler to the new com port}
  MyCP.OnTriggerData := MyTriggerData;
end;

procedure TForm1.MyTriggerAvail(CP : TObject; Count : Word);
var
  I : Word;
begin
  {retrieve all Count characters, even though we don't need them}
  For I := 1 to Count do
    MyCP.GetChar;
end;
procedure TForm1.MyTriggerData(CP : TObject; TriggerHandle : Word);
  {note: trigger handler must be method of a form}
begin
  ShowMessage('Got a data trigger');
  MyCP.RemoveAllTriggers;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  MyCP.Free;
end;

end.
