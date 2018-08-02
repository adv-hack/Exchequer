unit SecWarn2;

interface

Uses LicRec;

Var
  IAOSecOverride : Boolean = False;

{ Display the Single-CD Security Warning Wizard }
Function SCD_SecWarnWizard (Const CompDir, EntDir : ShortString;
                            Const Mode            : Byte;
                            Var   TempLicR        : EntLicenceRecType;
                            Var   SetRelCode      : Byte) : LongInt;

Function MCM_SECWIZARD (Const CompDir, EntDir : ShortString; Const Mode : Byte; Const Repl : Boolean) : LongInt; StdCall; Export;

implementation

{ Display the Single-CD Security Warning Wizard }
Function SCD_SecWarnWizard (Const CompDir, EntDir : ShortString;
                            Const Mode            : Byte;
                            Var   TempLicR        : EntLicenceRecType;
                            Var   SetRelCode      : Byte) : LongInt;
Begin // SCD_SecWarnWizard
  Result := 0; // Dummy unit to prevent loads units being included in Conv600MSSQL
End; // SCD_SecWarnWizard

Function MCM_SECWIZARD (Const CompDir, EntDir : ShortString; Const Mode : Byte; Const Repl : Boolean) : LongInt;
Begin // MCM_SECWIZARD
  Result := 0; // Dummy unit to prevent loads units being included in Conv600MSSQL
End; // MCM_SECWIZARD

end.
