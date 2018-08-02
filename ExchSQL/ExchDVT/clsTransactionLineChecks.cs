using System.Data;
using System.Data.SqlClient;
using System;

namespace Data_Integrity_Checker
{
    internal class clsTransactionLineChecks
    {
        public void TransactionLineCostCentresExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52006" +
                                            ", IntegrityErrorCode = 'E_TLINT006'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + DTL.OurReference + ' Line: ' + CONVERT(VARCHAR, DTL.TransactionLineNo) + ') exist with Cost Centre ' + CONVERT(VARCHAR, DTL.CostCentreCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with invalid Cost Centre'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(DTL.LinePositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_TransactionLine DTL " +
                                            "LEFT JOIN " + CompanyCode + ".evw_CostCentre C ON DTL.CostCentreCode = C.CostCentreCode " +
                                            "LEFT JOIN " + CompanyCode + ".DOCUMENT DOC ON DTL.LineFolioNumber = thFolioNum " +
                                            "WHERE C.CostCentreCode IS NULL " +
                                            "AND DTL.LineGrossValue <> 0 " +
                                            "AND DTL.StockCode <> '' " +
                                            "AND DTL.LineFolioNumber <> 0 " +
                                            "AND (DOC.thRunNo NOT IN (-42, -52, -62) " +
                                            "AND DOC.thRunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineCurrencyCodesExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52005" +
                                            ", IntegrityErrorCode = 'E_TLINT005'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + DTL.tlOurRef + ' Line: ' + CONVERT(VARCHAR, DTL.tlABSLineNo) + ') exist with Currency Code ' + CONVERT(VARCHAR, DTL.tlCurrency) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with invalid Currency Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(DTL.PositionId,'') " +
                                            "FROM " + CompanyCode + ".DETAILS DTL " +
                                            "LEFT JOIN " + CompanyCode + ".CURRENCY C ON DTL.tlCurrency = C.CurrencyCode " +
                                            "WHERE C.CurrencyCode IS NULL " +
                                            "AND (DTL.tlRunNo NOT IN (-42, -52, -62) " +
                                            "AND DTL.tlRunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineDepartmentsExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52007" +
                                            ", IntegrityErrorCode = 'E_TLINT007'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + DTL.OurReference + ' Line: ' + CONVERT(VARCHAR, DTL.TransactionLineNo) + ') exist with Department ' + CONVERT(VARCHAR, DTL.DepartmentCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with invalid Department'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(DTL.LinePositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_TransactionLine DTL " +
                                            "LEFT JOIN " + CompanyCode + ".evw_Department D ON DTL.DepartmentCode = D.DepartmentCode " +
                                            "LEFT JOIN " + CompanyCode + ".DOCUMENT DOC ON DTL.LineFolioNumber = thFolioNum " +
                                            "WHERE D.DepartmentCode IS NULL " +
                                            "AND DTL.LineGrossValue <> 0 " +
                                            "AND DTL.StockCode <> '' " +
                                            "AND DTL.LineFolioNumber <> 0 " +
                                            "AND (DOC.thRunNo NOT IN (-42, -52, -62) " +
                                            "AND DOC.thRunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineExistInvalidTraderCode(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52003" +
                                            ", IntegrityErrorCode = 'E_TLINT003'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + TL.OurReference + ' Line: ' + CONVERT(VARCHAR, TL.TransactionLineNo) + ') exist with Trader Code ' + TL.TraderCode + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with invalid Trader Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(TL.LinePositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_TransactionLine TL " +
                                            "LEFT JOIN " + CompanyCode + ".CUSTSUPP CS ON TL.TraderCode = CS.acCode COLLATE SQL_Latin1_General_CP1_CI_AS " +
                                            "WHERE CS.acCode IS NULL " +
                                            "AND TL.TraderCode <> ''  " +
                                            "AND (TL.RunNo NOT IN (-5, -42, -52, -62) " +
                                            "AND TL.RunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineExistsWithNoTransactionHeader(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52000" +
                                            ", IntegrityErrorCode = 'E_TLINT000'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + DTL.tlOurRef + ' Line: ' + CONVERT(VARCHAR, DTL.tlABSLineNo) + ') exists with a Transaction Header that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with no Transaction Header'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS' " +
                                            ", PositionId = ISNULL(DTL.PositionId,'') " +
                                            "FROM " + CompanyCode + ".DETAILS DTL " +
                                            "LEFT JOIN " + CompanyCode + ".DOCUMENT D ON D.thFolioNum = DTL.tlFolioNum " +
                                            "WHERE D.thFolioNum IS NULL " +
                                            "AND DTL.tlOurRef NOT LIKE '%A' " +
                                            "AND DTL.tlFolioNum <> 0 " +
                                            "AND DTL.tlDocType NOT IN (46,47,48,49,50)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineExistWithHeaderGLCode(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52002" +
                                            ", IntegrityErrorCode = 'E_TLINT002'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + DTL.tlOurRef + ' Line: ' + CONVERT(VARCHAR, DTL.tlABSLineNo) + ') exist with H(eader) GL Code ' + CONVERT(VARCHAR, DTL.tlGLCode)" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with H(eader) GL Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(DTL.PositionId,'') " +
                                            "FROM " + CompanyCode + ".DETAILS DTL " +
                                            "JOIN " + CompanyCode + ".NOMINAL N ON DTL.tlGLCode = N.glCode " +
                                            "WHERE N.glType = 'H'";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineExistWithInvalidGLCode(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52001" +
                                            ", IntegrityErrorCode = 'E_TLINT001'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + DTL.tlOurRef + ' Line: ' + CONVERT(VARCHAR, DTL.tlABSLineNo) + ') exist with GL Code ' + CONVERT(VARCHAR, DTL.tlGLCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with invalid GL Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(DTL.PositionId,'') " +
                                            "FROM " + CompanyCode + ".DETAILS DTL " +
                                            "LEFT JOIN " + CompanyCode + ".NOMINAL N ON DTL.tlGLCode = N.glCode " +
                                            "WHERE N.glCode IS NULL " +
                                            "AND DTL.tlGLCode > 0";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineInclusiveVATCodeExists(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52015" +
                                            ", IntegrityErrorCode = 'E_TLINT015'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + TL.OurReference COLLATE SQL_Latin1_General_CP1_CI_AS + ' Line: ' + CONVERT(VARCHAR, TL.TransactionLineNo) + ') exist with Inclusive VAT Code ' + CONVERT(VARCHAR, TL.InclusiveVATCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with invalid Inclusive VAT Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(TL.LinePositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_TransactionLine TL " +
                                            "LEFT JOIN " + CompanyCode + ".evw_VATRate V ON TL.InclusiveVATCode = V.VATRateCode COLLATE SQL_Latin1_General_CP1_CI_AS " +
                                            "WHERE V.VATRateCode IS NULL " +
                                            "AND TL.InclusiveVATCode NOT IN('', 'A', 'D')";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLinePeriodMatchesHeaderPeriod(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52016" +
                                            ", IntegrityErrorCode = 'E_TLINT016'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + TL.OurReference COLLATE SQL_Latin1_General_CP1_CI_AS + ' Line: ' + CONVERT(VARCHAR, TL.TransactionLineNo) + ') exist with Period ' + LinePeriodKey + ' that is different from Transaction Header ' + HeaderPeriodKey" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with Period different from Transaction Header Period'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(TL.LinePositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_TransactionLine TL " +
                                            "JOIN " + CompanyCode + ".evw_TransactionHeader TH ON TL.LineFolioNumber = TH.HeaderFolioNumber " +
                                            "CROSS APPLY(SELECT LinePeriodKey = STUFF(CONVERT(VARCHAR, TL.TransactionPeriodKey), 5, 0, ' - ') " +
                                            "    , HeaderPeriodKey = STUFF(CONVERT(VARCHAR, TH.TransactionPeriodKey), 5, 0, ' - ') " +
                                            "    ) PK " +
                                            "WHERE TL.TransactionPeriodKey <> TH.TransactionPeriodKey " +
                                            "AND TH.RunNo NOT IN(-1, -2, -42, -52, -62) AND TH.RunNo <= 0 " +
                                            "AND TL.TransactionTypeId NOT IN(46, 47, 48, 49, 50, 10, 25) " +
                                            "AND TL.LineFolioNumber <> 0 " +
                                            "AND TL.LineGrossValue <> 0";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineTraderCodeMatchesHeader(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52004" +
                                            ", IntegrityErrorCode = 'E_TLINT004'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + TL.OurReference + ' Line: ' + CONVERT(VARCHAR, TL.TransactionLineNo) + ') exist with Trader Code ' + TL.TraderCode + ' that is different from Transaction Header ' + TH.TraderCode COLLATE SQL_Latin1_General_CP1_CI_AS" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with Trader Code different from Header Trader Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(TL.LinePositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_TransactionLine TL " +
                                            "LEFT JOIN " + CompanyCode + ".evw_TransactionHeader TH ON TL.LineFolioNumber = TH.HeaderFolioNumber " +
                                            "WHERE TH.TraderCode <> TL.TraderCode COLLATE SQL_Latin1_General_CP1_CI_AS " +
                                            "AND TL.LineFolioNumber <> 0 " +
                                            "AND TL.TransactionTypeId NOT IN (46, 47, 48, 49, 50, 10, 25, 30) " +
                                            "AND (TH.RunNo NOT IN (-42, -52, -62) " +
                                            "AND TH.RunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineVATCodeExists(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52014" +
                                            ", IntegrityErrorCode = 'E_TLINT014'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + TL.OurReference COLLATE SQL_Latin1_General_CP1_CI_AS + ' Line: ' + CONVERT(VARCHAR, TL.TransactionLineNo) + ') exist with VAT Code ' + CONVERT(VARCHAR, TL.VATCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with invalid VAT Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(TL.LinePositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_TransactionLine TL " +
                                            "LEFT JOIN " + CompanyCode + ".evw_VATRate V ON TL.VATCode = V.VATRateCode COLLATE SQL_Latin1_General_CP1_CI_AS " +
                                            "WHERE V.VATRateCode IS NULL " +
                                            "AND TL.VATCode NOT IN('', 'A', 'D', 'M', 'I')";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        //SS:01/03/2018:2018-R1:ABSEXCH-19796: When Running the ExchDVT.exe, SQL Admin Passwords are visible in dump file.
        //Generic routine
        private void ExecuteQuery(string connStr, string query, string connPassword)
        {
            ADODB.Connection conn = new ADODB.Connection();
            ADODB.Command cmd = new ADODB.Command();
            cmd.CommandText = query;

            cmd.CommandTimeout = 10000;

            if (conn.State == 0)
                if (connPassword.Trim() == "")
                    conn.Open();
                else
                    conn.Open(connStr, "", connPassword.Trim(),
                                                    (int)ADODB.ConnectModeEnum.adModeUnknown);
            conn.CursorLocation = ADODB.CursorLocationEnum.adUseClient;

            try
            {
                Object recAff;
                cmd.ActiveConnection = conn;
                cmd.CommandType = ADODB.CommandTypeEnum.adCmdText;
                cmd.Execute(out recAff, Type.Missing, (int)ADODB.CommandTypeEnum.adCmdText);

                if (conn.State == 1)
                    conn.Close();
            }
            catch
            {
                throw;
            }
        }
    }
}