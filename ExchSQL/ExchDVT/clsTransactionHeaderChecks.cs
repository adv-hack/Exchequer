using System.Data;
using System.Data.SqlClient;
using System;

namespace Data_Integrity_Checker
{
    internal class clsTransactionHeaderChecks
    {
        public void TransactionCheckControlGLCodesExistIfSet(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo   = -51003" +
                                            ", IntegrityErrorCode = 'E_THINT003'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction(' + D.thOurRef + ') exist with Control GL Code ' + CONVERT(VARCHAR, D.thControlGL) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction(s) exist with invalid Control GL Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DOCUMENT' " +
                                            ", PositionId = ISNULL(D.PositionId,'') " +
                                            "FROM " + CompanyCode + ".DOCUMENT D " +
                                            "LEFT JOIN " + CompanyCode + ".NOMINAL N ON D.thControlGL = N.glCode " +
                                            "WHERE N.glCode IS NULL " +
                                            "AND D.thControlGL <> 0 " +
                                            "AND (D.thRunNo NOT IN (-42, -52, -62) " +
                                            "AND D.thRunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionCheckControlGLNotHeaders(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo   = -51004" +
                                            ", IntegrityErrorCode = 'E_THINT004'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction(' + D.thOurRef + ') exist with H(eader) Control GL Code ' + CONVERT(VARCHAR, thControlGL)" +
                                            ", IntegritySummaryDescription = 'Transaction(s) exist with H(eader) Control GL Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DOCUMENT' " +
                                            ", PositionId = ISNULL(D.PositionId,'') " +
                                            "FROM " + CompanyCode + ".DOCUMENT D " +
                                            "JOIN " + CompanyCode + ".NOMINAL N ON D.thControlGL = N.glCode " +
                                            "WHERE N.glType = 'H' " +
                                            "AND (D.thRunNo NOT IN (-42, -52, -62) " +
                                            "AND D.thRunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionCheckCurrencyCodeExists(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -51005" +
                                            ", IntegrityErrorCode = 'E_THINT005'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Transaction(' + D.thOurRef + ') exist with Currency Code ' + CONVERT(VARCHAR, D.thCurrency) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction(s) exist with invalid Currency Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DOCUMENT'" +
                                            ", PositionId = ISNULL(D.PositionId,'') " +
                                            "FROM " + CompanyCode + ".DOCUMENT D " +
                                            "LEFT JOIN " + CompanyCode + ".CURRENCY C ON D.thCurrency = C.CurrencyCode " +
                                            "WHERE C.CurrencyCode IS NULL " +
                                            "AND (D.thRunNo NOT IN (-42, -52, -62) " +
                                            "AND D.thRunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionCheckEmployeeCodesExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -51006" +
                                            ", IntegrityErrorCode = 'E_THINT006'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction(' + TH.thOurRef + ') exist with Employee Code ' + TH.thBatchLinkTrans + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction(s) exist with invalid Employee Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DOCUMENT'" +
                                            ", PositionId = ISNULL(TH.PositionId,'') " +
                                            "FROM " + CompanyCode + ".DOCUMENT TH " +
                                            "LEFT JOIN " + CompanyCode + ".evw_Employee E ON TH.thBatchLinkTrans = E.EmployeeCode " +
                                            "WHERE E.EmployeeCode IS NULL AND TH.thDocType = 41 " +
                                            "AND TH.thBatchLinkTrans <> ''";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionTraderCodesExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo   = -51002" +
                                            ", IntegrityErrorCode = 'E_THINT002'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction(' + D.thOurRef + ') exists with Trader Code ' + D.thAcCode + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction(s) exist with invalid Trader Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DOCUMENT' " +
                                            ", PositionId = ISNULL(D.PositionId,'') " +
                                            "FROM " + CompanyCode + ".DOCUMENT D " +
                                            "LEFT JOIN " + CompanyCode + ".CUSTSUPP CS ON D.thAcCode = CS.acCode " +
                                            "WHERE CS.acCode IS NULL " +
                                            "AND D.thAcCode <> '' " +
                                            "AND (D.thRunNo NOT IN (-42, -52, -62) " +
                                            "AND D.thRunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionZeroFolioNum(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo   = -51001" +
                                            ", IntegrityErrorCode = 'E_THINT001'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = ' < zero > Transaction Header exists.'" +
                                            ", IntegritySummaryDescription = 'Transaction(s) exist with FolioNumber 0'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DOCUMENT' " +
                                            ", PositionId = ISNULL(PositionId,'') " +
                                            "FROM " + CompanyCode + ".DOCUMENT " +
                                            "WHERE thFolioNum = 0";
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