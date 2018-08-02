unit SQLQueries;

interface

const

  // Signs for DocTypes
  //PR: 18/10/2010: Added SRF (5) to negative set & removed PRF (20) ABSEXCH-9926
//  SQL_NEGATIVE_SET   = 'IN (0, 3, 16, 17, 19, 20, 21)';
  SQL_NEGATIVE_SET   = 'IN (0, 3, 5, 16, 17, 19, 21)';
  SQL_POSITIVE_SET   = 'NOT ' + SQL_NEGATIVE_SET;

  //Query for inserting item records into Temp Bank Rec File
  //Parameters = CompanyCode, Temp Table Name, CompanyCode
  SQL_INSERT_FIELDS = 'INSERT INTO [%s].[%s] ([btdDocType],[btdYear],[btdPeriod],[btdAcCode],[btdDesc],' +
                      '[btdAmount],[btdStatus],[btdDate],[btdLineKey],[btdPayInRef] ,[btdOurRef] ,[btdFullPayInRef] ,[image_0]) ' +
                      'SELECT SUBSTRING(tlOurRef, 1, 3),tlYear,tlPeriod,tlAcCode, ' +
                      'REPLACE(tlDescription, '''''''', ''''),Round(tlNetValue, 2),' +
                      'tlRecStatus,tlLineDate,0x08 + ' +
                      'CONVERT(VARBINARY(4), REVERSE(CONVERT(VARBINARY(4), tlFolioNum))) + ' +
                      'CONVERT(VARBINARY(4), REVERSE(CONVERT(VARBINARY(4), PositionID))),'  +
                      'SUBSTRING(tlStockCode,1, 1) + SUBSTRING(tlStockCode,8,14),' +
                      'tlOurRef,0x00,Cast(tlDocType as VARBINARY(1)) + ' +
                      'CONVERT(VARBINARY(4), REVERSE(CONVERT(VARBINARY(4), tlRunNo))) + '+
                      'CONVERT(VARBINARY(4), REVERSE(CONVERT(VARBINARY(4), tlFolioNum))) + ' +
                      '0x00000000 + 0x00000000 + 0x00000000 + ' +
                      'CONVERT(VARBINARY(4), REVERSE(CONVERT(VARBINARY(4), PositionID))) + 0x00000000 + ' +
                      'CONVERT(VARBINARY(4), REVERSE(CONVERT(VARBINARY(4), PositionID))) + '+
                      '0x08 + Cast(tlReconciliationDate as VarBinary(8)) ' +
                      'FROM [%s].[Details] WHERE tlGLCode = %d AND SUBSTRING(tlOurRef, 9, 1) <> ''A'' AND tlRunNo <> 0';

  {SS 27/04/2016 2016-R2 
   ABSEXCH-15137 : Bank Rec wizard PPI Issue in SQL version showing both invoice and payment line amounts as negatives.
   Update reconcile amount for the PPI and SRI.}
  SQL_UPDATE_NETVALUE = 'Update REC  set REC.btdAmount =   Case '+
                        'when (Details.tlPaymentCode = ''N'') and  (Details.tlDocType = 21) then Round(Details.tlNetValue, 2) *-1 '+
                        'when (Details.tlPaymentCode = ''Y'') and  (Details.tlDocType = 21) then Round(Details.tlNetValue, 2)  '+
                        'when (Details.tlPaymentCode = ''N'') and  (Details.tlDocType = 6)  then Round(Details.tlNetValue, 2) *-1 '+
                        'ELSE REC.btdAmount end '+
                        'from  [%s].[%s] REC   inner Join [%s].[DETAILS] Details on ' +
                        '0x08 + CONVERT(VARBINARY(4),REVERSE(CONVERT(VARBINARY(4), Details.tlFolioNum))) ' +
                        '+ CONVERT(VARBINARY(4),REVERSE(CONVERT(VARBINARY(4), Details.PositionID))) = REC.btdLineKey '+
                        'Where Details.tlDocType IN (6,21) and Details.tlGLCode = %d ' ;



  //Add for Currency <> 0
  //Paremeter = Currency
  SQL_CURRENCY =      ' AND tlCurrency = %d';

  //Add for uncleared only
  SQL_UNCLEARED_ONLY = ' AND tlRecStatus = 0';

  //Add for use reconciliation date
  //Parameter = ReconciliationDate as yyyymmdd
  SQL_USE_RECONCILE_DATE
                     = ' AND tlRecStatus = 1 AND tlReconciliationDate = ''%s''';

  //Query to update values with the correct sign
  //Parameters = CompanyCode, Temp Table Name,
  SQL_UPDATE_AMOUNTS ='UPDATE [%s].[%s] SET btdAmount = Round(btdAmount * -1, 2) WHERE SUBSTRING(image_0, 1, 1) ' + SQL_NEGATIVE_SET;

  SQL_UPDATE_STORED_STATUSES
                     = 'UPDATE [COMPANY].[%s] ' +
                       'SET btdStatus = brLineStatus ' +
                       'FROM [COMPANY].[MLocStk] ' +
                       'WHERE RecPfix = ''K'' AND SubType = ''2'' AND ' +
                       'CAST(SUBSTRING(varCode2, 6, 10) as VarChar(10)) = ''%s'' AND brFolioLink = %d ' +
                       'AND SUBSTRING(btdLineKey, 2, 8) = SUBSTRING(varCode2, 20, 8)';

  //Query for inserting Group records into Temp Bank Rec File - grouped on PayInRef
  //PR: 14/10/2011 Added extra parameter to allow date to be included or not as required by GroupBy v6.9 ABSEXCH-10076

  //Parameters = CompanyCode, Temp Table Name, [either 'btdDate' or '', depending on groupby], CompanyCode, TempTableName

  //PR: 21/01/2010 Added CAST(AVG(btdStatus) AS INTEGER) to put status into group record
  //PR: 29/01/2015 ABSEXCH-14650 Amended to use the earliest year and period in a group
  SQL_GROUP_QUERY    = 'INSERT INTO [%s].[%s] ([btdDocType],[btdYear],[btdPeriod],[btdAcCode]' +
                      ',[btdDesc],[btdAmount],[btdStatus],[btdDate],[btdLineKey],[btdPayInRef],[btdOurRef]' +
		      ',[btdFullPayInRef],[image_0]) ' +
                      'SELECT ''RUN'',MIN(btdYear),MIN(btdPeriod),'''','''',Round(SUM(btdAmount), 2),CAST(AVG(btdStatus) AS INTEGER),%s,0,btdPayInRef,' +
                      '''RUN'',0x00,0x00 + 0x00000000 + 0x00000000 + ' +
                      'CONVERT(VARBINARY(4), REVERSE(CONVERT(VARBINARY(4), Count(*)))) +' +
                      '0x00000000000000000000000000000000 ' +
                      'FROM [%s].[%s] ' +
                      'WHERE btdDocType <> ''RUN'' AND SUBSTRING(btdPayInRef, 2, 1) <> 0x00 ' +
                      'AND SUBSTRING(btdPayInRef, 2, 1) <> 0x20 ';


  //Query for inserting Group records into Temp Bank Rec File - one for each Itemised record with a blank PayInRef
  //Parameters = CompanyCode, Temp Table Name, CompanyCode, TempTableName
  SQL_GROUP_QUERY_2  = 'INSERT INTO [%s].[%s] ([btdDocType],[btdYear],[btdPeriod],[btdAcCode]' +
                      ',[btdDesc],[btdAmount],[btdStatus],[btdDate],[btdLineKey],[btdPayInRef],[btdOurRef]' +
		      ',[btdFullPayInRef],[image_0]) ' +
                      'SELECT ''RUN'',btdYear,btdPeriod,'''','''',Round(btdAmount, 2),btdStatus,btdDate,0,btdPayInRef,' +
                      '''RUN'',btdLineKey,0x00 + 0x00000000 + 0x00000000 + 0x01000000 +  ' +
                      'CASE btdStatus ' +
                      'WHEN 1 THEN 0x01000000 ' +
                      'ELSE 0x00000000 ' +
                      'END + ' +
                      '0x000000000000000000000000 ' +
                      'FROM [%s].[%s] ' +
                      'WHERE btdDocType <> ''RUN'' AND ' +
                      '(SUBSTRING(btdPayInRef, 2, 1) = 0x00 OR SUBSTRING(btdPayInRef, 2, 1) = 0x20)';

  //Query for updating Group records with the count of cleared items for the group
  //Parameters = TempTableName, TempTableName
  //PR: Added Date field to temporary table to ensure distinctness where Itemised records have then
  //same pay-in ref but different dates, so shouldn't be grouped together

  SQL_GROUP_QUERY_3  = 'DECLARE @RecTemp TABLE ' +
                       '(tmpPayInRef VarBinary(23) NOT NULL PRIMARY KEY, tmpCount Int, ' +
                       'tmpDate VarChar(8) COLLATE SQL_Latin1_General_CP437_BIN) ' +
                       'INSERT @RecTemp (tmpPayInRef, tmpCount, tmpDate) ' +
                       'SELECT btdPayInRef + CAST(btdDate as VarBinary(8)),Count(*), btdDate ' +
                       'FROM [COMPANY].[%s] ' +
                       'WHERE btdDocType <> ''RUN'' AND SUBSTRING(btdPayInRef, 2, 1) <> 0x00 ' +
                       'AND SUBSTRING(btdPayInRef, 2, 1) <> 0x20 AND btdStatus = 1 ' +
                       'GROUP BY btdPayInRef, btdDate ' +
                       'UPDATE [COMPANY].[%s] ' +
                       'SET image_0 = CAST(SUBSTRING(image_0, 1, 13) AS VARBINARY(13)) + ' +
                                     'CONVERT(VARBINARY(4), REVERSE(CONVERT(VARBINARY(4), tmpCount))) + ' +
                                     '0x00000000000000000000000000000000 ' +
                       'FROM @RecTemp ' +
                       'WHERE btdDocType = ''RUN'' AND btdPayInRef = SUBSTRING(tmpPayInRef, 1, 15)' +
                       ' AND btdDate = tmpDate';

  //PR: 17/10/2011 Added No Date variant
  SQL_GROUP_QUERY_3_NODATE
                     = 'DECLARE @RecTemp TABLE ' +
                       '(tmpPayInRef VarBinary(23) NOT NULL PRIMARY KEY, tmpCount Int)  ' +
                       'INSERT @RecTemp (tmpPayInRef, tmpCount) ' +
                       'SELECT btdPayInRef,Count(*) ' +
                       'FROM [COMPANY].[%s] ' +
                       'WHERE btdDocType <> ''RUN'' AND SUBSTRING(btdPayInRef, 2, 1) <> 0x00 ' +
                       'AND SUBSTRING(btdPayInRef, 2, 1) <> 0x20 AND btdStatus = 1 ' +
                       'GROUP BY btdPayInRef ' +
                       'UPDATE [COMPANY].[%s] ' +
                       'SET image_0 = CAST(SUBSTRING(image_0, 1, 13) AS VARBINARY(13)) + ' +
                                     'CONVERT(VARBINARY(4), REVERSE(CONVERT(VARBINARY(4), tmpCount))) + ' +
                                     '0x00000000000000000000000000000000 ' +
                       'FROM @RecTemp ' +
                       'WHERE btdDocType = ''RUN'' AND btdPayInRef = SUBSTRING(tmpPayInRef, 1, 15)';

  //Set btdStatus to cleared for group records where btdNoOfItems = btdNumberCleared
  //Parameters = TempTableName
  SQL_GROUP_QUERY_4  = 'UPDATE [COMPANY].[%s] ' +
                       'SET btdStatus = 1 ' +
                       'WHERE btdDocType = ''RUN'' AND ' +
                       'SUBSTRING(image_0, 10, 4) = SUBSTRING(image_0, 14, 4)';

  //Query for updating Group records with the count of matched items for the group
  //Parameters = TempTableName, TempTableName
  //PR: Added Date field to temporary table to ensure distinctness where Itemised records have then
  //same pay-in ref but different dates, so shouldn't be grouped together
  SQL_GROUP_QUERY_5  = 'DECLARE @RecTemp TABLE ' +
                       '(tmpPayInRef VarBinary(23) NOT NULL PRIMARY KEY, tmpCount Int, ' +
                       'tmpDate VarChar(8) COLLATE SQL_Latin1_General_CP437_BIN) ' +
                       'INSERT @RecTemp (tmpPayInRef, tmpCount, tmpDate) ' +
                       'SELECT btdPayInRef + CAST(btdDate as VarBinary(8)),Count(*), btdDate ' +
                       'FROM [COMPANY].[%s] ' +
                       'WHERE btdDocType <> ''RUN'' AND SUBSTRING(btdPayInRef, 2, 1) <> 0x00 ' +
                       'AND SUBSTRING(btdPayInRef, 2, 1) <> 0x20 AND btdStatus = 8 ' +
                       'GROUP BY btdPayInRef, btdDate ' +
                       'UPDATE [COMPANY].[%s] ' +
                       'SET image_0 = CAST(SUBSTRING(image_0, 1, 17) AS VARBINARY(17)) + ' +
                                     'CONVERT(VARBINARY(4), REVERSE(CONVERT(VARBINARY(4), tmpCount))) + ' +
                                     '0x00000000000000000000000000000000 ' +
                       'FROM @RecTemp ' +
                       'WHERE btdDocType = ''RUN'' AND btdPayInRef = SUBSTRING(tmpPayInRef, 1, 15)' +
                       ' AND btdDate = tmpDate';


  //PR: 17/10/2011 Added No Date variant
  SQL_GROUP_QUERY_5_NODATE
                     = 'DECLARE @RecTemp TABLE ' +
                       '(tmpPayInRef VarBinary(23) NOT NULL PRIMARY KEY, tmpCount Int) ' +
                       'INSERT @RecTemp (tmpPayInRef, tmpCount) ' +
                       'SELECT btdPayInRef,Count(*) ' +
                       'FROM [COMPANY].[%s] ' +
                       'WHERE btdDocType <> ''RUN'' AND SUBSTRING(btdPayInRef, 2, 1) <> 0x00 ' +
                       'AND SUBSTRING(btdPayInRef, 2, 1) <> 0x20 AND btdStatus = 8 ' +
                       'GROUP BY btdPayInRef ' +
                       'UPDATE [COMPANY].[%s] ' +
                       'SET image_0 = CAST(SUBSTRING(image_0, 1, 17) AS VARBINARY(17)) + ' +
                                     'CONVERT(VARBINARY(4), REVERSE(CONVERT(VARBINARY(4), tmpCount))) + ' +
                                     '0x00000000000000000000000000000000 ' +
                       'FROM @RecTemp ' +
                       'WHERE btdDocType = ''RUN'' AND btdPayInRef = SUBSTRING(tmpPayInRef, 1, 15)';

  //Set btdStatus to Matched for group records where btdNoOfItems = btdNumberMatched
  //Parameters = TempTableName
  SQL_GROUP_QUERY_6  = 'UPDATE [COMPANY].[%s] ' +
                       'SET btdStatus = 8 ' +
                       'WHERE btdDocType = ''RUN'' AND ' +
                       'SUBSTRING(image_0, 10, 4) = SUBSTRING(image_0, 18, 4)';


  SQL_GROUP_CLAUSE_DATE = ' GROUP BY btdPayInRef, btdDate';

  SQL_GROUP_CLAUSE_NODATE = ' GROUP BY btdPayInRef';


  //Updates the line keys for Group Records with more than one item
  //Parameters = CompanyCode, TempTableName
  SQL_UPDATE_GROUP_LINEKEYS
                     = 'UPDATE [%s].[%s] ' +
                       'SET btdLineKey = 0x0800000000 + Cast(PositionID as VarBinary(4)) ' +
                       'WHERE btdDocType = ''RUN''';

  //Updates the line keys for Group Records with one item only
  //Parameters = CompanyCode, TempTableName
  SQL_UPDATE_GROUP_LINEKEYS2
                     = 'UPDATE [%s].[%s] ' +
                       'SET image_0 = SUBSTRING(image_0, 1, 21) + CONVERT(VARBINARY(4), REVERSE(CONVERT(VARBINARY(4), PositionID))) ' +
                       'WHERE btdDocType = ''RUN'' AND (SUBSTRING(btdPayInRef, 2, 1) = 0x00 OR SUBSTRING(btdPayInRef, 2, 1) = 0x20)';

  //Query for inserting Reconciled Line records into MLocStk
  //Parameters = CompanyCode, VarCode1, VarCode2, VarCode3, BankRecHeaderFolio, CompanyCode, TempTableName , FolioNum
  //PR: 22/01/2010 Added check for duplicate line
  SQL_INSERT_RECONCILED_LINES
                     = 'INSERT INTO [%s].[MLOCSTK] ([RecPfix],[SubType],[varCode1],[varCode2],[varCode3]' +
                       ',[BrPayRef],[BrLineDate],[BrMatchRef],[BrValue],[BrLineNo],[BrStatLine],[BrCustCode],[BrPeriod]' +
                       ',[BrYear],[BrFolioLink],[BrLineStatus]) ' +
                       'SELECT ''K'',''2'',%s,%s,%s, ' +
                       'SUBSTRING(btdPayInRef, 1, 11), ' +
                       'SUBSTRING(image_0, 35, 8),btdOurRef,Round(btdAmount, 2),' +
                       'Cast(SUBSTRING(image_0, 22, 4) as Integer),Cast(SUBSTRING(image_0, 26, 4) as Integer)' +
                       ',btdAcCode,btdPeriod,btdYear,%d,btdStatus ' +
                       'FROM [%s].[%s] ' +
                       'WHERE btdSTATUS > 0 ' +
                       'AND NOT EXISTS (SELECT VarCode1 ' +
                       'FROM [COMPANY].[MLOCSTK] WHERE RecPFix = ''K'' AND SubType = ''2'' ' +
                       'AND brFolioLink = %d ' +
                       'AND BrLineNo = Cast(SUBSTRING(image_0, 22, 4) as Integer))';

  //Used to get the number of records in the Temp Table
  //Parameters = TempTableName
  SQL_COUNT_QUERY    = 'SELECT COUNT(PositionID) AS RecCount FROM [COMPANY].[%s]';

  //Used to update statuses in Temp Table from Reconcile Line Records in MLocStk
  //Parameters = CompanyCode, TempTableName, CompanyCode, UserID, GLCode, ReconcileFolio - May not need to use
  SQL_UPDATE_STATUSES
                     = 'UPDATE [%s].[%s] ' +
                       'SET btdStatus = brStatus ' +
                       'FROM [%s].[MLocStk] ' +
                       'WHERE RecPfix = ''K'' AND SubType = ''2'' AND ' +
                       'CAST(SUBSTRING(varCode2, 6, 10) as VarChar(10)) = ''%s'' AND brNomCode = %d AND brFolioLink = %d ' +
                       'AND btdLineKey = SUBSTRING(varCode2, 19, 8)';

  //Used to update Tags in Temp Table from Reconcile Line Records in MLocStk
  //Parameters = TempTableName, iTag, UserID, ReconcileFolio
  SQL_UPDATE_TAGS    = 'UPDATE [COMPANY].[%s] ' +
                       'SET btdStatus = %d ' +
                       'FROM [COMPANY].[MLocStk] ' +
                       'WHERE RecPfix = ''K'' AND SubType = ''2'' AND ' +
                       'brStatID = ''TAG'' AND ' +
                       'CAST(SUBSTRING(varCode2, 6, 10) as VarChar(10)) = ''%s'' AND brFolioLink = %d ' +
                       'AND btdLineKey = brPayRef';


  //Used to delete Group records from the temporary file before processing
  //Parameters = CompanyCode, TempTableName
  SQL_DELETE_GROUP_RECS
                     = 'DELETE FROM [%s].[%s] WHERE btdDocType = ''RUN''';

  //Used to delete unwanted records from the temporary file before processing
  //Parameters = CompanyCode, TempTableName, CompanyCode, CompanyCode, TempTableName,
  SQL_DELETE_UNUSED_RECS
                     = 'DELETE [%s].[%s] ' +
                       'FROM [%s].[Details] d ' +
                       'INNER JOIN [%s].[%s] ON ' +
                       'SUBSTRING(image_0, 33, 1) + SUBSTRING(image_0, 32, 1) + ' +
                       'SUBSTRING(image_0, 31, 1) + SUBSTRING(image_0, 30, 1) = d.PositionID ' +
                       'WHERE btdStatus = tlRecStatus ' +
                       'AND CAST(SUBSTRING(image_0,35, 8) as VARCHAR) = tlReconciliationDate';

  //Used to update records in MLocStk after processing
  //Parameters = CompanyCode, GLCode (as VarBin), UserID, bnkHeader.brIntRef
  SQL_UPDATE_RECONCILED_LINES
                     = 'UPDATE [%s].[MLocStk] ' +
                       'SET brLineStatus = 32 ' +
                       'WHERE RecPFix = ''K'' AND SUBTYPE = ''2'' ' +
//                       'AND CAST(SUBSTRING(varCode2, 2, 4) AS VARBINARY(4)) = %s ' +
                       'AND brNomCode = %d ' +
                       'AND CAST(SUBSTRING(varCode2, 6, 10) AS VARCHAR(10)) = ''%s'' ' +
                       'AND brFolioLink = %d';
  //Deletes Group Records from MLocStk
  //Paramters CompanyCode, GLCode as VarBin, UserID, Reconcilition Folio
  SQL_DELETE_RECONCILED_GROUP_RECS
                     = 'DELETE FROM [%s].[MLocStk] ' +
                       'WHERE RecPFix = ''K'' AND SUBTYPE = ''2'' ' +
//                       'AND CAST(SUBSTRING(varCode2, 2, 4) AS VARBINARY(4)) = %s ' +
                       'AND brNomCode = %d ' +
                       'AND CAST(SUBSTRING(varCode2, 6, 10) AS VARCHAR(10)) = ''%s'' ' +
                       'AND brFolioLink = %d ' +
                       'AND brMatchRef = ''RUN''';

  //Sum of reconciled values in Temp Table
  //Parameters TempTableName
  SQL_SUM_RECONCILED_QUERY
                     = 'SELECT SUM(btdAmount) AS RecAmount FROM [COMPANY].[%s] ' +
                       'WHERE btdStatus in (1, 8) AND btdDocType <> ''RUN''';

  //Sum of reconciled values in Temp Table
  //Parameters TempTableName
  SQL_SUM_RECONCILED_MLOC
                     = 'SELECT SUM(brValue) AS RecAmount FROM [COMPANY].[MLocStk] ' +
                        'WHERE RecPfix = ''K'' AND SubType = ''2'' AND ' +
                        'BrNomCode = %d AND ' + 
                        'brMatchRef <> ''RUN'' AND brMatchRef <> ''TAG'' AND ' +
                       'CAST(SUBSTRING(varCode2, 6, 10) as VarChar(10)) = ''%s'' ' +
                       'AND brFolioLink = %d AND brLineStatus in (1, 8)';


  //Sum of Reconciled Details records
  SQL_OPEN_BALANCE   = 'SELECT SUM(Round(tlNetValue, 2)) AS OpenBalance FROM [COMPANY].[Details] ' +
                       'WHERE tlGLCode = %d AND tlRecStatus = 1 AND tlDocType ';

  // CS 2011-08-17 ABSEXCH-11231 - Opening Balance on Bank Rec
  // SQL Query to calculate Consolidated opening balance.
  // Parameters: G/L Code, 'tlDailyRate'/'tlCompanyRate', 'tlDailyRate'/'tlCompanyRate'
  {$IFDEF MC_On}
  SQL_CONSOLIDATED_OPEN_BALANCE =
                      'SELECT SUM(' +
                      '	CASE tlTriInvert ' +
                      '		WHEN 0 THEN ROUND(tlNetValue / %s, 2) ' +
                      '		WHEN 1 THEN ROUND(tlNetValue * %s, 2) ' +
                      '	END ' +
                      ') AS OpenBalance ' +
                      'FROM [COMPANY].[Details] ' +
                      'WHERE tlGLCode = %d AND tlRecStatus = 1 AND tlDocType ';
  {$ENDIF}

  //Converts currency values in TempTable to Base
  //Parameters TempTableName, 'tlDailyRate'/'tlCompanyRate','tlDailyRate'/'tlCompanyRate'
  SQL_CONVERT_TO_BASE
                     = 'UPDATE [COMPANY].[%s] ' +
                       'SET btdAmount =  ' +
                       'CASE tlTriInvert ' +
                       '    WHEN 0 THEN ROUND(btdAmount / %s, 2) ' +
                       '    WHEN 1 THEN ROUND(btdAmount * %s, 2) ' +
                       'END ' +
                       'FROM [COMPANY].[Details] d ' +
                       'WHERE SUBSTRING(image_0, 33, 1) + SUBSTRING(image_0, 32, 1) + ' +
                       '      SUBSTRING(image_0, 31, 1) + SUBSTRING(image_0, 30, 1) = d.PositionID';

  //Updates Matched Status & Statement Line No in Temp Table when auto-reconciling
  //Parameters = TempTableName, Bank Statement Folio No
  SQL_MATCH_ITEMS    = 'UPDATE [COMPANY].[%s] ' +
                       'SET btdStatus = 8, ' +
                       '    image_0 = CAST(SUBSTRING(image_0, 1, 25) AS VARBINARY(25)) + ' +
                       '              CAST(EbLineNo AS VARBINARY(4)) + ' +
                       '              CAST(SUBSTRING(image_0, 30, 17) AS VARBINARY(17)) ' +
                       'FROM [COMPANY].[MLocStk] ' +
                       'WHERE (CAST(SUBSTRING(btdPayInRef, 2, LEN(EbLineRef)) AS VARCHAR(5)) = EbLineRef ' +
                       'OR SUBSTRING(btdDesc, 1, LEN(EbLineRef)) = EbLineRef) ' +
                       'AND btdStatus = 0 AND btdDocType <> ''RUN'' ' +
                       'AND Round(EbLineValue, 2) = Round(btdAmount, 2) ' +
                       'AND EbLineIntRef = %d ' +
                       'AND RecPFix = ''K'' AND SubType = ''5''';

  //Query for inserting Matched Line records into MLocStk
  //Parameters = CompanyCode, VarCode1, VarCode2, VarCode3, BankRecHeaderFolio, CompanyCode, TempTableName
  SQL_INSERT_MATCHED_LINES
                     = 'INSERT INTO [COMPANY].[MLOCSTK] ([RecPfix],[SubType],[varCode1],[varCode2],[varCode3]' +
                       ',[BrPayRef],[BrLineDate],[BrMatchRef],[BrValue],[BrLineNo],[BrStatLine],[BrCustCode],[BrPeriod]' +
                       ',[BrYear],[BrNomCode],[BrFolioLink],[BrLineStatus]) ' +
                       'SELECT ''K'',''2'',%s,%s,%s,btdPayInRef,SUBSTRING(image_0, 34, 9),btdOurRef,Round(btdAmount, 2),' +
                       'Cast(SUBSTRING(image_0, 22, 4) as Integer),Cast(SUBSTRING(image_0, 26, 4) as Integer)' +
                       ',btdAcCode,btdPeriod,btdYear,%d,%d,btdStatus ' +
                       'FROM [COMPANY].[%s] ' +
                       'WHERE btdSTATUS = 8';

  //Query for deleting records from MLocStk when deleting a reconcile
  SQL_MLOC_DELETE = 'DELETE FROM [%s].[MLocStk] WHERE RecPfix = ''K'' AND SubType = ''2'' AND ' +
                   'SUBSTRING(varCode1, 1, 19) = %s';


  S_QUOTE = '' + #39;

  I_TIMEOUT = 300;


implementation

end.
