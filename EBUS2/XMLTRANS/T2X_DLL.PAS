unit t2x_dll;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

function WriteXmlTransactionFile(P : Pointer;
                                 PL : Pointer;
                                 PSize, PLSize : longint;
                                 A : Pointer;
                                 AL : Pointer;
                                 ASize, ALSize : longint;
                                 N : Pointer;
                                 NSize : longInt) : Integer; stdcall;


implementation

function WriteXmlTransactionFile(P : Pointer;
                                 PL : Pointer;
                                 PSize, PLSize : longint;
                                 A : Pointer;
                                 AL : Pointer;
                                 ASize, ALSize : longint;
                                 N : Pointer;
                                 NSize : longInt) : Integer; stdcall; external 'TXML.DLL';


end.
