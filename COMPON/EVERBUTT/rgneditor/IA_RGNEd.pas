unit IA_RGNEd;

interface
  uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolWin, ComCtrls, ExtCtrls, StdCtrls, IAeverButton, ExtDlgs,Math,dsgnintf,
  RgnEdWindow;

  type
  TIARGNEditor = class(TPropertyEditor)
  public

    Dialog : TRgnEditorForm;
    Rgn : HRGN;
    Closedison : Boolean;

    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;

    procedure GetRGN1(Value : HRGN);
    procedure Norgn;
  end;


procedure Register;

implementation

function TIARGNEditor.GetAttributes: TPropertyAttributes;
begin
  Result:=[paDialog];
end;
function TIARGNEditor.GetValue: string;
begin
  Result:='String Value';
end;


procedure TIARGNEditor.Edit;
begin
  Closedison:=false;
  Dialog:=TRgnEditorForm.Create(Application);
  Dialog.ResultRGN:=GetRgn1;
  Dialog.NoResultRGN:=NoRgn;
  Dialog.Show;
  repeat
    application.ProcessMessages;
  until Closedison or (not assigned(Dialog));
  try
  if assigned(Dialog) then Dialog.free;
  except
  end;
end;
procedure TIARGNEditor.Norgn;
begin
  Closedison:=true;
end;
procedure TIARGNEditor.GetRGN1(Value : HRGN);
  var
    S1 : string;
    RD1 : PRGNDATA;
    BufSize,i : Integer;
    p1,p2 : Pbyte;


begin
  deleteobject(RGN);
  RGN:=CreateRectRgn(0,0,0,0);

  Combinergn(RGN,Value,0,RGN_COPY);
  deleteobject(value);
  BufSize:=getregionData(rgn,0,Nil);
  Getmem(pointer(RD1),BufSize+sizeof(Rd1^));
  getregionData(RGN,BufSize,RD1);
  setlength(s1,2*BufSize);
  p1:=pByte(Rd1);
  p2:=pbyte(S1);

  for i:=1 to bufsize do
    begin
      if p1^>127 then
        begin
          p2^:=p1^;p2:=pbyte(integer(p2)+1);
          p2^:=p1^;p2:=pbyte(integer(p2)+1);
        end else
        begin
          p2^:=33;p2:=pbyte(integer(p2)+1);
          p2^:=p1^+128;p2:=pbyte(integer(p2)+1);
        end;
      p1:=pbyte(integer(p1)+1);
     end;
  deleteobject(rgn);
  freemem(pointer(RD1),BufSize+sizeof(Rd1^));
  SetStrValue(S1);
  Closedison:=true;

end;

procedure Register;
begin
  RegisterPropertyEditor(Typeinfo(TIAStringRGNData),TIAEVERButton,'StringButtonRegion',TIARGNEditor);
end;


end.
