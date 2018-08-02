using System.Data;
using System.Data.SqlClient;
using System;

namespace Data_Integrity_Checker
{
    internal class clsCoreChecks
    {
        public void CheckInvertedCurrencies(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                        "SELECT IntegrityErrorNo = -59010 " +
                                        ", IntegrityErrorCode = 'E_CURR001' " +
                                        ", Severity = 'High' " +
                                        ", IntegrityErrorMessage = 'Currency ' + CONVERT(VARCHAR, CurrencyCode) + ' is inverted.' " +
                                        ", IntegritySummaryDescription = 'Inverted Currencies found.' " +
                                        ", SchemaName = '" + CompanyCode + "' " +
                                        ", TableName = 'CURRENCY' " +
                                        ", PositionId = '' " +
                                        "FROM " + CompanyCode + ".evw_Currency " +
                                        "WHERE TriInverted = 1 ";
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