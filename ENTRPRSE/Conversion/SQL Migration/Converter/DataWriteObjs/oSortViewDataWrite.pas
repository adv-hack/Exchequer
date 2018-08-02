Unit oSortViewDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TSortViewDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    svrViewIdParam, svrUserIdParam, svrListTypeParam, svrDescrParam, svsEnabled01Param, 
    svsFieldId01Param, svsAscending01Param, svsSpare01Param, svsEnabled02Param, 
    svsFieldId02Param, svsAscending02Param, svsSpare02Param, svsEnabled03Param, 
    svsFieldId03Param, svsAscending03Param, svsSpare03Param, svsEnabled04Param, 
    svsFieldId04Param, svsAscending04Param, svsSpare04Param, svfEnabled01Param, 
    svfFieldId01Param, svfComparison01Param, svfValue01Param, svfSpare01Param, 
    svfEnabled02Param, svfFieldId02Param, svfComparison02Param, svfValue02Param, 
    svfSpare02Param, svfEnabled03Param, svfFieldId03Param, svfComparison03Param, 
    svfValue03Param, svfSpare03Param, svfEnabled04Param, svfFieldId04Param, 
    svfComparison04Param, svfValue04Param, svfSpare04Param, svfEnabled05Param, 
    svfFieldId05Param, svfComparison05Param, svfValue05Param, svfSpare05Param, 
    svfEnabled06Param, svfFieldId06Param, svfComparison06Param, svfValue06Param, 
    svfSpare06Param, svfEnabled07Param, svfFieldId07Param, svfComparison07Param, 
    svfValue07Param, svfSpare07Param, svfEnabled08Param, svfFieldId08Param, 
    svfComparison08Param, svfValue08Param, svfSpare08Param : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TSortViewDataWrite

Implementation

Uses Graphics, Variants, SQLConvertUtils, VarSortV;

//=========================================================================

Constructor TSortViewDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TSortViewDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TSortViewDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].SORTVIEW (' + 
                                               'svrViewId, ' + 
                                               'svrUserId, ' + 
                                               'svrListType, ' + 
                                               'svrDescr, ' + 
                                               'svsEnabled01, ' + 
                                               'svsFieldId01, ' +
                                               'svsAscending01, ' +
                                               'svsSpare01, ' + 
                                               'svsEnabled02, ' + 
                                               'svsFieldId02, ' + 
                                               'svsAscending02, ' + 
                                               'svsSpare02, ' + 
                                               'svsEnabled03, ' + 
                                               'svsFieldId03, ' + 
                                               'svsAscending03, ' + 
                                               'svsSpare03, ' + 
                                               'svsEnabled04, ' + 
                                               'svsFieldId04, ' + 
                                               'svsAscending04, ' + 
                                               'svsSpare04, ' + 
                                               'svfEnabled01, ' + 
                                               'svfFieldId01, ' + 
                                               'svfComparison01, ' + 
                                               'svfValue01, ' + 
                                               'svfSpare01, ' + 
                                               'svfEnabled02, ' + 
                                               'svfFieldId02, ' + 
                                               'svfComparison02, ' + 
                                               'svfValue02, ' + 
                                               'svfSpare02, ' + 
                                               'svfEnabled03, ' + 
                                               'svfFieldId03, ' + 
                                               'svfComparison03, ' + 
                                               'svfValue03, ' + 
                                               'svfSpare03, ' + 
                                               'svfEnabled04, ' + 
                                               'svfFieldId04, ' + 
                                               'svfComparison04, ' + 
                                               'svfValue04, ' + 
                                               'svfSpare04, ' + 
                                               'svfEnabled05, ' + 
                                               'svfFieldId05, ' + 
                                               'svfComparison05, ' + 
                                               'svfValue05, ' + 
                                               'svfSpare05, ' + 
                                               'svfEnabled06, ' + 
                                               'svfFieldId06, ' + 
                                               'svfComparison06, ' + 
                                               'svfValue06, ' + 
                                               'svfSpare06, ' +
                                               'svfEnabled07, ' + 
                                               'svfFieldId07, ' + 
                                               'svfComparison07, ' + 
                                               'svfValue07, ' + 
                                               'svfSpare07, ' + 
                                               'svfEnabled08, ' + 
                                               'svfFieldId08, ' + 
                                               'svfComparison08, ' + 
                                               'svfValue08, ' + 
                                               'svfSpare08' + 
                                               ') ' + 
              'VALUES (' + 
                       ':svrViewId, ' + 
                       ':svrUserId, ' + 
                       ':svrListType, ' + 
                       ':svrDescr, ' + 
                       ':svsEnabled01, ' + 
                       ':svsFieldId01, ' + 
                       ':svsAscending01, ' + 
                       ':svsSpare01, ' + 
                       ':svsEnabled02, ' + 
                       ':svsFieldId02, ' + 
                       ':svsAscending02, ' + 
                       ':svsSpare02, ' + 
                       ':svsEnabled03, ' + 
                       ':svsFieldId03, ' + 
                       ':svsAscending03, ' + 
                       ':svsSpare03, ' + 
                       ':svsEnabled04, ' + 
                       ':svsFieldId04, ' + 
                       ':svsAscending04, ' + 
                       ':svsSpare04, ' + 
                       ':svfEnabled01, ' + 
                       ':svfFieldId01, ' + 
                       ':svfComparison01, ' + 
                       ':svfValue01, ' + 
                       ':svfSpare01, ' + 
                       ':svfEnabled02, ' + 
                       ':svfFieldId02, ' + 
                       ':svfComparison02, ' + 
                       ':svfValue02, ' + 
                       ':svfSpare02, ' + 
                       ':svfEnabled03, ' + 
                       ':svfFieldId03, ' +
                       ':svfComparison03, ' + 
                       ':svfValue03, ' + 
                       ':svfSpare03, ' + 
                       ':svfEnabled04, ' + 
                       ':svfFieldId04, ' + 
                       ':svfComparison04, ' + 
                       ':svfValue04, ' + 
                       ':svfSpare04, ' + 
                       ':svfEnabled05, ' + 
                       ':svfFieldId05, ' + 
                       ':svfComparison05, ' + 
                       ':svfValue05, ' + 
                       ':svfSpare05, ' + 
                       ':svfEnabled06, ' + 
                       ':svfFieldId06, ' + 
                       ':svfComparison06, ' + 
                       ':svfValue06, ' + 
                       ':svfSpare06, ' + 
                       ':svfEnabled07, ' + 
                       ':svfFieldId07, ' + 
                       ':svfComparison07, ' + 
                       ':svfValue07, ' + 
                       ':svfSpare07, ' + 
                       ':svfEnabled08, ' + 
                       ':svfFieldId08, ' + 
                       ':svfComparison08, ' + 
                       ':svfValue08, ' + 
                       ':svfSpare08' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    svrViewIdParam := FindParam('svrViewId');
    svrUserIdParam := FindParam('svrUserId');
    svrListTypeParam := FindParam('svrListType');
    svrDescrParam := FindParam('svrDescr');
    svsEnabled01Param := FindParam('svsEnabled01');
    svsFieldId01Param := FindParam('svsFieldId01');
    svsAscending01Param := FindParam('svsAscending01');
    svsSpare01Param := FindParam('svsSpare01');
    svsEnabled02Param := FindParam('svsEnabled02');
    svsFieldId02Param := FindParam('svsFieldId02');
    svsAscending02Param := FindParam('svsAscending02');
    svsSpare02Param := FindParam('svsSpare02');
    svsEnabled03Param := FindParam('svsEnabled03');
    svsFieldId03Param := FindParam('svsFieldId03');
    svsAscending03Param := FindParam('svsAscending03');
    svsSpare03Param := FindParam('svsSpare03');
    svsEnabled04Param := FindParam('svsEnabled04');
    svsFieldId04Param := FindParam('svsFieldId04');
    svsAscending04Param := FindParam('svsAscending04');
    svsSpare04Param := FindParam('svsSpare04');
    svfEnabled01Param := FindParam('svfEnabled01');
    svfFieldId01Param := FindParam('svfFieldId01');
    svfComparison01Param := FindParam('svfComparison01');
    svfValue01Param := FindParam('svfValue01');
    svfSpare01Param := FindParam('svfSpare01');
    svfEnabled02Param := FindParam('svfEnabled02');
    svfFieldId02Param := FindParam('svfFieldId02');
    svfComparison02Param := FindParam('svfComparison02');
    svfValue02Param := FindParam('svfValue02');
    svfSpare02Param := FindParam('svfSpare02');
    svfEnabled03Param := FindParam('svfEnabled03');
    svfFieldId03Param := FindParam('svfFieldId03');
    svfComparison03Param := FindParam('svfComparison03');
    svfValue03Param := FindParam('svfValue03');
    svfSpare03Param := FindParam('svfSpare03');
    svfEnabled04Param := FindParam('svfEnabled04');
    svfFieldId04Param := FindParam('svfFieldId04');
    svfComparison04Param := FindParam('svfComparison04');
    svfValue04Param := FindParam('svfValue04');
    svfSpare04Param := FindParam('svfSpare04');
    svfEnabled05Param := FindParam('svfEnabled05');
    svfFieldId05Param := FindParam('svfFieldId05');
    svfComparison05Param := FindParam('svfComparison05');
    svfValue05Param := FindParam('svfValue05');
    svfSpare05Param := FindParam('svfSpare05');
    svfEnabled06Param := FindParam('svfEnabled06');
    svfFieldId06Param := FindParam('svfFieldId06');
    svfComparison06Param := FindParam('svfComparison06');
    svfValue06Param := FindParam('svfValue06');
    svfSpare06Param := FindParam('svfSpare06');
    svfEnabled07Param := FindParam('svfEnabled07');
    svfFieldId07Param := FindParam('svfFieldId07');
    svfComparison07Param := FindParam('svfComparison07');
    svfValue07Param := FindParam('svfValue07');
    svfSpare07Param := FindParam('svfSpare07');
    svfEnabled08Param := FindParam('svfEnabled08');
    svfFieldId08Param := FindParam('svfFieldId08');
    svfComparison08Param := FindParam('svfComparison08');
    svfValue08Param := FindParam('svfValue08');
    svfSpare08Param := FindParam('svfSpare08');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TSortViewDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^SortViewRecType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    svrViewIdParam.Value := svrViewId;                                                                             // SQL=int, Delphi=LongInt
    svrUserIdParam.Value := svrUserId;                                                                             // SQL=varchar, Delphi=String[30]
    svrListTypeParam.Value := svrListType;                                                                         // SQL=int, Delphi=TSortViewListType
    svrDescrParam.Value := svrDescr;                                                                               // SQL=varchar, Delphi=String[100]
    svsEnabled01Param.Value := svrSorts[1].svsEnabled;                                                             // SQL=bit, Delphi=Boolean
    svsFieldId01Param.Value := svrSorts[1].svsFieldId;                                                             // SQL=int, Delphi=LongInt
    svsAscending01Param.Value := svrSorts[1].svsAscending;                                                         // SQL=bit, Delphi=Boolean
    svsSpare01Param.Value := CreateVariantArray (@svrSorts[1].svsSpare, SizeOf(svrSorts[1].svsSpare));// SQL=varbinary, Delphi=Array [1..50] Of Byte
    svsEnabled02Param.Value := svrSorts[2].svsEnabled;                                                             // SQL=bit, Delphi=Boolean
    svsFieldId02Param.Value := svrSorts[2].svsFieldId;                                                             // SQL=int, Delphi=LongInt
    svsAscending02Param.Value := svrSorts[2].svsAscending;                                                         // SQL=bit, Delphi=Boolean
    svsSpare02Param.Value := CreateVariantArray (@svrSorts[2].svsSpare, SizeOf(svrSorts[2].svsSpare));// SQL=varbinary, Delphi=Array [1..50] Of Byte
    svsEnabled03Param.Value := svrSorts[3].svsEnabled;                                                             // SQL=bit, Delphi=Boolean
    svsFieldId03Param.Value := svrSorts[3].svsFieldId;                                                             // SQL=int, Delphi=LongInt
    svsAscending03Param.Value := svrSorts[3].svsAscending;                                                         // SQL=bit, Delphi=Boolean
    svsSpare03Param.Value := CreateVariantArray (@svrSorts[3].svsSpare, SizeOf(svrSorts[3].svsSpare));// SQL=varbinary, Delphi=Array [1..50] Of Byte
    svsEnabled04Param.Value := svrSorts[4].svsEnabled;                                                             // SQL=bit, Delphi=Boolean
    svsFieldId04Param.Value := svrSorts[4].svsFieldId;                                                             // SQL=int, Delphi=LongInt
    svsAscending04Param.Value := svrSorts[4].svsAscending;                                                         // SQL=bit, Delphi=Boolean
    svsSpare04Param.Value := CreateVariantArray (@svrSorts[4].svsSpare, SizeOf(svrSorts[4].svsSpare));// SQL=varbinary, Delphi=Array [1..50] Of Byte
    svfEnabled01Param.Value := svrFilters[1].svfEnabled;                                                           // SQL=bit, Delphi=Boolean
    svfFieldId01Param.Value := svrFilters[1].svfFieldId;                                                           // SQL=int, Delphi=LongInt
    svfComparison01Param.Value := svrFilters[1].svfComparison;                                                     // SQL=int, Delphi=TSortViewFilterComparisonType
    svfValue01Param.Value := svrFilters[1].svfValue;                                                               // SQL=varchar, Delphi=String[100]
    svfSpare01Param.Value := CreateVariantArray (@svrFilters[1].svfSpare, SizeOf(svrFilters[1].svfSpare));// SQL=varbinary, Delphi=Array [1..100] Of Byte
    svfEnabled02Param.Value := svrFilters[2].svfEnabled;                                                           // SQL=bit, Delphi=Boolean
    svfFieldId02Param.Value := svrFilters[2].svfFieldId;                                                           // SQL=int, Delphi=LongInt
    svfComparison02Param.Value := svrFilters[2].svfComparison;                                                     // SQL=int, Delphi=TSortViewFilterComparisonType
    svfValue02Param.Value := svrFilters[2].svfValue;                                                               // SQL=varchar, Delphi=String[100]
    svfSpare02Param.Value := CreateVariantArray (@svrFilters[2].svfSpare, SizeOf(svrFilters[2].svfSpare));// SQL=varbinary, Delphi=Array [1..100] Of Byte
    svfEnabled03Param.Value := svrFilters[3].svfEnabled;                                                           // SQL=bit, Delphi=Boolean
    svfFieldId03Param.Value := svrFilters[3].svfFieldId;                                                           // SQL=int, Delphi=LongInt
    svfComparison03Param.Value := svrFilters[3].svfComparison;                                                     // SQL=int, Delphi=TSortViewFilterComparisonType
    svfValue03Param.Value := svrFilters[3].svfValue;                                                               // SQL=varchar, Delphi=String[100]
    svfSpare03Param.Value := CreateVariantArray (@svrFilters[3].svfSpare, SizeOf(svrFilters[3].svfSpare));// SQL=varbinary, Delphi=Array [1..100] Of Byte
    svfEnabled04Param.Value := svrFilters[4].svfEnabled;                                                           // SQL=bit, Delphi=Boolean
    svfFieldId04Param.Value := svrFilters[4].svfFieldId;                                                           // SQL=int, Delphi=LongInt
    svfComparison04Param.Value := svrFilters[4].svfComparison;                                                     // SQL=int, Delphi=TSortViewFilterComparisonType
    svfValue04Param.Value := svrFilters[4].svfValue;                                                               // SQL=varchar, Delphi=String[100]
    svfSpare04Param.Value := CreateVariantArray (@svrFilters[4].svfSpare, SizeOf(svrFilters[4].svfSpare));// SQL=varbinary, Delphi=Array [1..100] Of Byte
    svfEnabled05Param.Value := svrFilters[5].svfEnabled;                                                           // SQL=bit, Delphi=Boolean
    svfFieldId05Param.Value := svrFilters[5].svfFieldId;                                                           // SQL=int, Delphi=LongInt
    svfComparison05Param.Value := svrFilters[5].svfComparison;                                                     // SQL=int, Delphi=TSortViewFilterComparisonType
    svfValue05Param.Value := svrFilters[5].svfValue;                                                               // SQL=varchar, Delphi=String[100]
    svfSpare05Param.Value := CreateVariantArray (@svrFilters[5].svfSpare, SizeOf(svrFilters[5].svfSpare));// SQL=varbinary, Delphi=Array [1..100] Of Byte
    svfEnabled06Param.Value := svrFilters[6].svfEnabled;                                                           // SQL=bit, Delphi=Boolean
    svfFieldId06Param.Value := svrFilters[6].svfFieldId;                                                           // SQL=int, Delphi=LongInt
    svfComparison06Param.Value := svrFilters[6].svfComparison;                                                     // SQL=int, Delphi=TSortViewFilterComparisonType
    svfValue06Param.Value := svrFilters[6].svfValue;                                                               // SQL=varchar, Delphi=String[100]
    svfSpare06Param.Value := CreateVariantArray (@svrFilters[6].svfSpare, SizeOf(svrFilters[6].svfSpare));// SQL=varbinary, Delphi=Array [1..100] Of Byte
    svfEnabled07Param.Value := svrFilters[7].svfEnabled;                                                           // SQL=bit, Delphi=Boolean
    svfFieldId07Param.Value := svrFilters[7].svfFieldId;                                                           // SQL=int, Delphi=LongInt
    svfComparison07Param.Value := svrFilters[7].svfComparison;                                                     // SQL=int, Delphi=TSortViewFilterComparisonType
    svfValue07Param.Value := svrFilters[7].svfValue;                                                               // SQL=varchar, Delphi=String[100]
    svfSpare07Param.Value := CreateVariantArray (@svrFilters[7].svfSpare, SizeOf(svrFilters[7].svfSpare));// SQL=varbinary, Delphi=Array [1..100] Of Byte
    svfEnabled08Param.Value := svrFilters[8].svfEnabled;                                                           // SQL=bit, Delphi=Boolean
    svfFieldId08Param.Value := svrFilters[8].svfFieldId;                                                           // SQL=int, Delphi=LongInt
    svfComparison08Param.Value := svrFilters[8].svfComparison;                                                     // SQL=int, Delphi=TSortViewFilterComparisonType
    svfValue08Param.Value := svrFilters[8].svfValue;                                                               // SQL=varchar, Delphi=String[100]
    svfSpare08Param.Value := CreateVariantArray (@svrFilters[8].svfSpare, SizeOf(svrFilters[8].svfSpare));// SQL=varbinary, Delphi=Array [1..100] Of Byte
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

