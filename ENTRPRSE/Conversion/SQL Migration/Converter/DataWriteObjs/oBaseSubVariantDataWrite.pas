Unit oBaseSubVariantDataWrite;

Interface

Uses ADODB, oDataPacket;

Type
  // Base type for
  TDataWrite_BaseSubVariant = Class(TObject)
  Protected
    FADOQuery : TADOQuery;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Virtual;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Virtual; Abstract;
  End; // TDataWrite_BaseSubVariant

Implementation

//=========================================================================

Constructor TDataWrite_BaseSubVariant.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(Nil);
End; // Create

//------------------------------

Destructor TDataWrite_BaseSubVariant.Destroy;
Begin // Destroy
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TDataWrite_BaseSubVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  // Link the private ADOQuery instance to the shared ADO Connection 
  FADOQuery.Connection := ADOConnection;
End; // Prepare

//=========================================================================

End.

