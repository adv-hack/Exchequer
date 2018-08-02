{*********************************************************}
{*                   PATCH401.PAS 4.01                   *}
{*      Copyright (c) TurboPower Software 1998-2001      *}
{*                 All rights reserved.                  *}
{*********************************************************}
{* this program patches the 16-bit printer driver so it  *}
{* can use the 32-bit GDI (for non-Latin char sets)      *}
{*********************************************************}
unit Patch401;
  {- Main form for Patch4.0 app. }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
const
  NEPointerOffset = $3C;
var
  F            : File;
  Signature    : array[0..1] of char;
  NEOffset     : Longint;
  NEHeader     : record
    Signature  : array[0..1] of char;   { 'NE' = 16-bit Windows program }
    OtherStuff : array[2..$3D] of byte; { Information we don't care about in this context }
    ExpVerLow  : Byte;                  { Expected Windows version (low byte) }
    ExpVerHigh : Byte;                  { Expected Windows version (high byte)}
  end;
begin
  if OpenDialog1.Execute then begin
    AssignFile(F,OpenDialog1.FileName);
    Reset(F,1);
    try
      BlockRead(F,Signature,sizeof(Signature));
      if Signature <> 'MZ' then
        raise Exception.CreateFmt('%s does not appear to be an executable file',[OpenDialog1.FileName]);
      try
        Seek(F,NEPointerOffset);
      except
        raise Exception.CreateFmt('%s does not appear to be a 16-bit Windows executable',[OpenDialog1.FileName]);
      end;
      BlockRead(F,NEOffset,sizeof(NEOffset));
      try
        Seek(F,NEOffset);
      except
        raise Exception.CreateFmt('%s does not appear to be a 16-bit Windows executable',[OpenDialog1.FileName]);
      end;
      BlockRead(F,NEHeader,sizeof(NEHEader));
      if NEHeader.Signature <> 'NE' then
        raise Exception.CreateFmt('%s does not appear to be a 16-bit Windows executable',[OpenDialog1.FileName]);
      if NEHeader.ExpVerHigh >= 4 then
        ShowMessage(OpenDialog1.FileName+' is already patched for use with Windows95')
      else begin
        NEHeader.ExpVerHigh := 4;
        NEHeader.ExpVerLow := 0;
        Seek(F,NEOffset);
        BlockWrite(F,NEHEader,sizeof(NEHeader));
        ShowMessage(OpenDialog1.FileName+' patched.');
      end;
    finally
      CloseFile(F);
    end;
  end;
end;

end.
