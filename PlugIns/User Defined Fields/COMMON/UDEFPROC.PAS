unit UDefProc;

{ nfrewer440 09:40 03/09/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  CustABSU;

const

  PM_DISABLED = 0;
  PM_MANDATORY_LIST = 1;
  PM_OPTIONAL_LIST = 2;
  PM_VALIDATION_ONLY = 3;
  PM_MANDATORY_DATE = 4;
  PM_OPTIONAL_DATE = 5;

type
  TWinPos = Record
    wpLeft, wpTop, wpWidth, wpHeight : LongInt;
  End; { TWinPos }

{  TExecuteTXPlugIn = function(dtDocType : cuDocTypes; sHeadLine : string
  ; iFieldNo : integer; sField : string; var sFieldName : string; sDataPath : string
  ; var bResult : boolean; WinPos : TWinPos; UserFields : TAbsUserFields
  ; bReverseFlags : boolean; bValidate : boolean) : string; stdCall;}

TExecuteTXPlugIn = function(dtDocType : cuDocTypes; sHeadLine : string
; iFieldNo : integer; sField : string; var sFieldName : string; sDataPath, sUserName : string
; var bResult : boolean; WinPos : TWinPos; UserFields : TAbsUserFields
; bReverseFlags : boolean; bValidate : boolean) : string; stdcall;

TOpenFiles = function(asPath : ANSIString) : boolean; stdcall;

TCloseFiles = Procedure; stdcall;

implementation

end.
