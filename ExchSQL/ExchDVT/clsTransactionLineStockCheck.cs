using System.Data;
using System.Data.SqlClient;
using System;

namespace Data_Integrity_Checker
{
    internal class clsTransactionLineStockCheck
    {
        public void TransactionLineLocationCodeDoesNotExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52013" +
                                            ", IntegrityErrorCode = 'E_TLINT013'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line (Ref: ' + DTL.tlOurRef + ' Line: ' + CONVERT(VARCHAR, DTL.tlABSLineNo) + ') exist with Location ' + CONVERT(VARCHAR, DTL.tlLocation) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with invalid Location Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(DTL.PositionId,'') " +
                                            "FROM " + CompanyCode + ".DETAILS DTL " +
                                            "LEFT JOIN " + CompanyCode + ".Location L ON DTL.tlLocation = L.LoCode " +
                                            "WHERE L.LoCode IS NULL " +
                                            "AND DTL.tlDocType NOT IN (1, 16, 30, 41, 46, 47, 48, 49, 50) " +
                                            "AND DTL.tlLocation <> '' " +
                                            "AND DTL.tlStockCodeTrans1 <> '' " +
                                            "AND (DTL.tlRunNo NOT IN (-42, -52, -62) " +
                                            "AND DTL.tlRunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineStockCodeExists(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52011" +
                                            ", IntegrityErrorCode = 'E_TLINT011'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + TL.OurReference + ' Line: ' + CONVERT(VARCHAR, TL.TransactionLineNo) + ') exist with Stock ' + CONVERT(VARCHAR, TL.StockCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with invalid Stock code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(TL.LinePositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_TransactionLine TL " +
                                            "LEFT JOIN " + CompanyCode + ".STOCK S ON TL.StockCode = S.stCode " +
                                            "WHERE S.PositionId IS NULL " +
                                            "AND TL.StockCode <> '' " +
                                            "AND TL.DisplayLineNo <> 2147483647 " +
                                            "AND (TL.RunNo NOT IN (-42, -52, -62) " +
                                            "AND TL.RunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineStockCodeNotGroup(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52012" +
                                            ", IntegrityErrorCode = 'E_TLINT012'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + TL.OurReference + ' Line: ' + CONVERT(VARCHAR, TL.TransactionLineNo) + ') exist with G(roup) Stock ' + CONVERT(VARCHAR, TL.StockCode)" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with G(roup) Stock Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(TL.LinePositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_TransactionLine TL " +
                                            "JOIN " + CompanyCode + ".evw_Stock S ON TL.StockCode = S.StockCode " +
                                            "WHERE S.StockType = 'G' " +
                                            "AND (TL.RunNo NOT IN (-42, -52, -62) " +
                                            "AND TL.RunNo <= 0)";
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