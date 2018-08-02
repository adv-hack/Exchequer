unit BTSupU1;

{ nfrewer440 10:20 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$IFNDEF VER130}
  {$ALIGN 1}  { Variable Alignment Disabled }
{$ENDIF}


interface
uses
  messages;
Const
  WM_FormCloseMsg  =  WM_User + $2;
  WM_FormStateMsg  =  WM_User + $5;

implementation

end.

