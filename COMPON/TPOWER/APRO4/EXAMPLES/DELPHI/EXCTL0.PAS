{*********************************************************}
{*                      ExCtl0.PAS                       *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*  Demonstrates how to monitor a fax printer driver.    *}
{*********************************************************}

unit ExCtl0;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AdFaxCtl, StdCtrls, OoMisc;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    FaxConvController1: TApdFaxDriverInterface;
    Button1: TButton;
    Button2: TButton;
    procedure FaxConvController1DocStart(Sender: TObject);
    procedure FaxConvController1DocEnd(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
{$IFDEF Win32}
  Registry;
{$ELSE}
  IniFiles;
{$ENDIF}

{$R *.DFM}

procedure TForm1.FaxConvController1DocStart(Sender: TObject);
  {Event OnDocStart}
begin
  Memo1.Lines.Add('About to print:'+FaxConvController1.DocName);
end;

procedure TForm1.FaxConvController1DocEnd(Sender: TObject);
  {Event OnDocEnd}
begin
  Memo1.Lines.Add('Done printing:'+FaxConvController1.DocName);
end;

procedure TForm1.Button1Click(Sender: TObject);
{$IFDEF Win32}
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey,True); // Key is declared in OOMisc.pas     
    Reg.WriteString(ApdIniKey,ParamStr(0));                           
  finally
    Reg.Free;
  end;
{$ELSE}
var
   IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(ApdIniFileName);                          
  try
    { Key is declared in OOMisc.pas }
    IniFile.WriteString(ApdIniSection,ApdIniKey,ParamStr(0));          
  finally
    IniFile.Free;
  end;
{$ENDIF}
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  {$IFNDEF Win32}
  if (GetWinFlags and $4000) <> 0 then
    ShowMessage('Warning! You cannot use a 16-bit application to monitor an NT printer driver.');
  {$ENDIF}
end;

procedure TForm1.Button2Click(Sender: TObject);
  {End program}
begin
  Close;
end;

end.
