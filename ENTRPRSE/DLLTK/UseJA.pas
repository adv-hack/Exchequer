unit UseJA;

interface

FUNCTION EX_SETJAINVOICEDFLAG(TRANSREF        : PCHAR;
                              LINENO          : LONGINT;
                              INVOICEREF      : PCHAR;
                              WIPTRANSFERRED  : WORDBOOL;
                              CHARGEOUT       : DOUBLE;
                              CHARGEOUTCURR   : LONGINT) : SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}


implementation

const

DllNAME = 'ENTDLL32.DLL';


FUNCTION EX_SETJAINVOICEDFLAG(TRANSREF        : PCHAR;
                              LINENO          : LONGINT;
                              INVOICEREF      : PCHAR;
                              WIPTRANSFERRED  : WORDBOOL;
                              CHARGEOUT       : DOUBLE;
                              CHARGEOUTCURR   : LONGINT) : SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}  EXTERNAL DLLNAME INDEX 176;


end.
