Unit OPVATPaySingleton;

Interface

Uses SysUtils, oOPVATPayBtrieveFile;

// Singleton for OPVATPay.Dat Btrieve File Object
Function OPVATPayFile : TOrderPaymentsVATPayDetailsBtrieveFile;

// Shutdown routine to reset the singleton called during Change Company and Shutdown
Procedure OPVATPaySingleton_ShutdownCompany;

Implementation

Uses GlobVar;

Var
  lOPVATPayFile : TOrderPaymentsVATPayDetailsBtrieveFile;

//=========================================================================

Function OPVATPayFile : TOrderPaymentsVATPayDetailsBtrieveFile;
Begin // OPVATPayFile
  If (Not Assigned(lOPVATPayFile)) Then
  Begin
    lOPVATPayFile := TOrderPaymentsVATPayDetailsBtrieveFile.Create;
    lOPVATPayFile.OpenFile (SetDrive + OrderPaymentsVATPayDetailsFilePath);
    lOPVATPayFile.Index := vpIdxReceiptRef;
  End; // If (Not Assigned(lOPVATPayFile))

  Result := lOPVATPayFile;
End; // OPVATPayFile

//-------------------------------------------------------------------------

Procedure OPVATPaySingleton_ShutdownCompany;
Begin // OPVATPaySingleton_ShutdownCompany
  If Assigned(lOPVATPayFile) Then
    FreeAndNIL(lOPVATPayFile);
End; // OPVATPaySingleton_ShutdownCompany

//=========================================================================

Initialization
  lOPVATPayFile := NIL;
Finalization
  OPVATPaySingleton_ShutdownCompany;
End.
