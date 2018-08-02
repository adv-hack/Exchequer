using System.Data;
using System.Data.SqlClient;
using System;

namespace Data_Integrity_Checker
{
    internal class clsHistoryChecks
    {
        public void HistoryCheckAnalysisIdExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo = -55003" +
                                            ", IntegrityErrorCode = 'E_JHINT003'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Job History records exists with Analysis History Id ' + CONVERT(VARCHAR, JH.AnalysisHistoryId) + ' that does NOT exist for this Job.'" +
                                            ", IntegritySummaryDescription = 'Job History Line(s) exist with invalid Analysis History Id'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'HISTORY'" +
                                            ", PositionId = ISNULL(JH.HistoryPositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_JobHistory JH " +
                                            "LEFT JOIN " + CompanyCode + ".evw_JobCategoryAnalysis JCA ON JH.JobCode = JCA.JobCode " +
                                            "WHERE JCA.JobCode IS NULL " +
                                            "AND JH.AnalysisHistoryId >= 1000";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void HistoryCheckCostCentreCodesExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -53003" +
                                            ", IntegrityErrorCode = 'E_NHINT003'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Nominal History records exists with Cost Centre Code ' + CONVERT(VARCHAR, NH.CostCentreCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Nominal History Line(s) exist with invalid Cost Centre'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'HISTORY'" +
                                            ", PositionId = ISNULL(NH.HistoryPositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_NominalHistory NH " +
                                            "LEFT JOIN " + CompanyCode + ".evw_CostCentre C ON NH.CostCentreCode = C.CostCentreCode " +
                                            "WHERE C.CostCentreCode IS NULL " +
                                            "AND NH.CostCentreCode IS NOT NULL";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void HistoryCheckCurrencyCodesExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -53001" +
                                            ", IntegrityErrorCode = 'E_NHINT001'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Nominal History records exists with Currency Code ' + CONVERT(VARCHAR, NH.CurrencyId) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Nominal History Line(s) exist with invalid Currency Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'HISTORY'" +
                                            ", PositionId = ISNULL(NH.HistoryPositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_NominalHistory NH " +
                                            "LEFT JOIN " + CompanyCode + ".CURRENCY C ON NH.CurrencyId = C.CurrencyCode " +
                                            "WHERE C.CurrencyCode IS NULL";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void HistoryCheckDepartmentCodesExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -53004" +
                                            ", IntegrityErrorCode = 'E_NHINT004'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Nominal History records exists with Department Code ' + CONVERT(VARCHAR, NH.DepartmentCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Nominal History Line(s) exist with invalid Department'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'HISTORY'" +
                                            ", PositionId = ISNULL(NH.HistoryPositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_NominalHistory NH " +
                                            "LEFT JOIN " + CompanyCode + ".evw_Department D ON NH.DepartmentCode = D.DepartmentCode " +
                                            "WHERE D.DepartmentCode IS NULL " +
                                            "AND NH.DepartmentCode IS NOT NULL";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void HistoryCheckEmployeeCodesExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -54002" +
                                            ", IntegrityErrorCode = 'E_EHINT002'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Employee History records exists with Employee Code ' + CONVERT(VARCHAR, EH.EmployeeCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Employee History Line(s) exist with invalid Employee Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'HISTORY'" +
                                            ", PositionId = ISNULL(EH.HistoryPositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_EmployeeHistory EH " +
                                            "LEFT JOIN " + CompanyCode + ".evw_Employee E ON EH.EmployeeCode = E.EmployeeCode " +
                                            "WHERE E.EmployeeCode IS NULL";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void HistoryCheckEmployeeCurrencyCodesExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -54001" +
                                            ", IntegrityErrorCode = 'E_EHINT001'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Employee History records exists with Currency Code ' + CONVERT(VARCHAR, EH.CurrencyId) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Employee History Line(s) exist with invalid Currency Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'HISTORY'" +
                                            ", PositionId = ISNULL(EH.HistoryPositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_EmployeeHistory EH " +
                                            "LEFT JOIN " + CompanyCode + ".CURRENCY C ON EH.CurrencyId = C.CurrencyCode " +
                                            "WHERE C.CurrencyCode IS NULL";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void HistoryCheckGLCodesExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -53002" +
                                            ", IntegrityErrorCode = 'E_NHINT002'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Nominal History records exists with GL Code ' + CONVERT(VARCHAR, NH.NominalCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Nominal History Line(s) exist with invalid GL Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'HISTORY'" +
                                            ", PositionId = ISNULL(NH.HistoryPositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_NominalHistory NH " +
                                            "LEFT JOIN " + CompanyCode + ".NOMINAL N ON NH.NominalCode = N.glCode " +
                                            "WHERE N.glCode IS NULL";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void HistoryCheckJobCurrencyExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -55001" +
                                            ", IntegrityErrorCode = 'E_JHINT001'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Job History records exists with Currency Code ' + CONVERT(VARCHAR, JH.CurrencyId) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Job History Line(s) exist with invalid Currency Code'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'HISTORY'" +
                                            ", PositionId = ISNULL(JH.HistoryPositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_JobHistory JH " +
                                            "LEFT JOIN " + CompanyCode + ".CURRENCY C ON JH.CurrencyId = C.CurrencyCode " +
                                            "WHERE C.CurrencyCode IS NULL";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void HistoryCheckJobExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo  = -55002" +
                                            ", IntegrityErrorCode = 'E_JHINT002'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Job History records exists with Job Code ' + CONVERT(VARCHAR, JH.JobCode) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Job History Line(s) exist with invalid Job Code '" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'HISTORY'" +
                                            ", PositionId = ISNULL(JH.HistoryPositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_JobHistory JH " +
                                            "LEFT JOIN " + CompanyCode + ".evw_Job J ON JH.JobCode = J.JobCode " +
                                            "WHERE J.JobCode IS NULL";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void HistoryCheckLocationExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo = -56002" +
                                            ", IntegrityErrorCode = 'E_STINT002'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Stock History records exists with Location ' + Loc.LocationCode + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Stock History Line(s) exist with invalid Location'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'HISTORY'" +
                                            ", PositionId = ISNULL(SH.HistoryPositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_StockHistory SH " +
                                            "CROSS APPLY(SELECT LocationCode = CASE " +
                                            "                                  WHEN LocationCode = '' THEN '<BLANK>' " +
                                            "                                  ELSE LocationCode " +
                                            "                                  END) Loc " +
                                            "LEFT JOIN " + CompanyCode + ".Location L ON SH.LocationCode = L.loCode " +
                                            "WHERE L.PositionId IS NULL " +
                                            "AND SH.LocationCode IS NOT NULL";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void HistoryCheckStockExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo = -56001" +
                                            ", IntegrityErrorCode = 'E_STINT001'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Stock History records exists with Stock Folio Number ' + CONVERT(VARCHAR, SH.StockFolioNumber) + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Stock History Line(s) exist with invalid Stock Folio Number'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'HISTORY'" +
                                            ", PositionId = ISNULL(SH.HistoryPositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_StockHistory SH " +
                                            "LEFT JOIN " + CompanyCode + ".evw_Stock S ON SH.StockFolioNumber = S.FolioNumber " +
                                            "AND (SH.HistoryClassificationCode = S.StockType COLLATE SQL_Latin1_General_CP1_CI_AS " +
                                            "OR   SH.HistoryClassificationId = ASCII(S.StockType) + 159) " +
                                            "WHERE S.StockId IS NULL";
            ExecuteQuery(ExchequerCommonSQLConnection, query, connPassword);
        }

        public void HistoryCheckStockLocationExist(string ExchequerCommonSQLConnection, string CompanyCode, string connPassword)
        {
            string query = "INSERT INTO common.SQLDataValidation " +
                                            "SELECT IntegrityErrorNo = -56003" +
                                            ", IntegrityErrorCode = 'E_STINT003'" +
                                            ", Severity = 'Low'" +
                                            ", IntegrityErrorMessage = 'Stock History records exists with Stock Folio / Location ' + CONVERT(VARCHAR, SH.StockFolioNumber) + ' / ' + Loc.LocationCode + ' that does NOT exist.'" +
                                            ", IntegritySummaryDescription = 'Stock History Line(s) exist with invalid Stock / Location combination'" +
                                            ", SchemaName = '" + CompanyCode + "'" +
                                            ", TableName = 'HISTORY'" +
                                            ", PositionId = ISNULL(SH.HistoryPositionId,'') " +
                                            "FROM " + CompanyCode + ".evw_StockHistory SH " +
                                            "CROSS APPLY  (SELECT LocationCode = CASE " +
                                            "                                    WHEN LocationCode = '' THEN '<BLANK>' " +
                                            "                                    ELSE LocationCode " +
                                            "                                    END) Loc " +
                                            "LEFT JOIN " + CompanyCode + ".Location SL ON SH.LocationCode = SL.LoCode " +
                                            "WHERE SL.PositionId IS NULL " +
                                            "AND SH.LocationCode IS NOT NULL";
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