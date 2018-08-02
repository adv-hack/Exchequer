using System.Data;
using System.Data.SqlClient;
using System;

namespace Data_Integrity_Checker
{
    internal class clsTransactionLineJobCostingChecks
    {
        public void TransactionLineCheckAnalysisCodeExists(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52010" +
                                            ", IntegrityErrorCode = 'E_TLINT010'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + DTL.tlOurRef + ' Line: ' + CONVERT(VARCHAR, DTL.tlABSLineNo) + ') exist with Analysis Code ' + CONVERT(VARCHAR, DTL.tlAnalysisCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with invalid Analysis Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(DTL.PositionId,'') " +
                                            "FROM " + CompanyCode + ".DETAILS DTL " +
                                            "LEFT JOIN " + CompanyCode + ".evw_JobAnalysis JA ON DTL.tlAnalysisCode = JA.JobAnalysisCode " +
                                            "WHERE JA.JobAnalysisCode IS NULL " +
                                            "AND DTL.tlJobCode <> '' " +
                                            "AND DTL.tlAnalysisCode <> '' " +
                                            "AND (DTL.tlRunNo NOT IN (-42, -52, -62) " +
                                            "AND DTL.tlRunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineCheckJobNotContract(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52009" +
                                            ", IntegrityErrorCode = 'E_TLINT009'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + DTL.OurReference + ' Line: ' + CONVERT(VARCHAR, DTL.TransactionLineNo) + ') exist with Job set to Contract ' + CONVERT(VARCHAR, DTL.JobCode)" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with a Contract Job'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(DTL.LinePositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_TransactionLine DTL " +
                                            "JOIN " + CompanyCode + ".evw_Job J ON DTL.JobCode = J.JobCode " +
                                            "WHERE J.JobContractTypeCode = 'K' " +
                                            "AND DTL.LineGrossValue <> 0 " +
                                            "AND (DTL.RunNo NOT IN (-42, -52, -62) " +
                                            "AND DTL.RunNo <= 0)";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void TransactionLineJobExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -52008" +
                                            ", IntegrityErrorCode = 'E_TLINT008'" +
                                            ", Severity = 'High'" +
                                            ", IntegrityErrorMessage = 'Transaction Line(Ref: ' + DTL.OurReference + ' Line: ' + CONVERT(VARCHAR, DTL.TransactionLineNo) + ') exist with Job ' + CONVERT(VARCHAR, DTL.JobCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Transaction Line(s) exist with invalid Job'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'DETAILS'" +
                                            ", PositionId = ISNULL(DTL.LinePositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_TransactionLine DTL " +
                                            "LEFT JOIN " + CompanyCode + ".evw_Job J ON DTL.JobCode = J.JobCode " +
                                            "WHERE J.JobCode IS NULL " +
                                            "AND DTL.JobCode <> '' " +
                                            "AND DTL.LineGrossValue <> 0 " +
                                            "AND (DTL.RunNo NOT IN (-42, -52, -62) " +
                                            "AND DTL.RunNo <= 0)";
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