using System.Data;
using System.Data.SqlClient;
using System;

namespace Data_Integrity_Checker
{
    internal class clsHistoryCalculations
    {
        public void ProfitAndLossBroughtForward(string ExchequerCommonSQLConnection, string CompanyCode, bool Commitment, string connPassword)
        {
            string CommitmentEnabled = "0";

            if (Commitment == true)
                CommitmentEnabled = "1";

            ADODB.Connection conn = new ADODB.Connection();
            ADODB.Command cmd = new ADODB.Command();
            cmd.CommandText = "  DECLARE @MinYear INT" +
                                            "        , @MaxYear INT" +
                                            "        , @iv_IsCommitment INT = " + CommitmentEnabled +
                                            "        , @c_CTDPeriod INT = 255" +
                                            "        , @c_False BIT = 0" +

                                            "  IF OBJECT_ID('tempdb..#ProfitBF') IS NOT NULL" +
                                            "    DROP TABLE #ProfitBF" +

                                            "  DECLARE @ProfitBF    INT" +
                                            "        , @NominalType VARCHAR(1)" +
                                            "        , @HistoryCode VARBINARY(21)" +

                                            "  SELECT @ProfitBF = SS.NomCtrlProfitBF" +
                                            "       , @NominalType = N.NominalTypeCode" +
                                            "       , @HistoryCode = HC.HistoryCode" +
                                            "  FROM " + CompanyCode + ".EXCHQSS SS" +
                                            "  JOIN " + CompanyCode + ".evw_Nominal N ON SS.NomCtrlProfitBF = N.NominalCode" +
                                            "  CROSS APPLY(SELECT HistoryCode = [common].efn_CreateNominalHistoryCode(SS.NomCtrlProfitBF, NULL, NULL, NULL, @iv_IsCommitment)" +
                                            "              ) HC" +
                                            "  WHERE common.GetString(IDCode, 1) = 'SYS' " +

                                            // Gather qualifying data

                                            "  SELECT HistoryClassificationId = ASCII(@NominalType)" +
                                            "       , HistoryCode = @HistoryCode" +
                                            "       , NominalCode = @ProfitBF" +
                                            "       , HistoryYear = NH.HistoryYear - 1900" +
                                            "       , NH.CurrencyId" +
                                            "       , SalesAmount = SUM(NH.SalesAmount)" +
                                            "       , PurchaseAmount = SUM(NH.PurchaseAmount)" +

                                            "  INTO #ProfitBF" +
                                            "  FROM   " + CompanyCode + ".evw_NominalHistory NH(READUNCOMMITTED)" +
                                            "  JOIN   " + CompanyCode + ".evw_Nominal N ON NH.NominalCode = N.NominalCode" +
                                            "  WHERE NH.HistoryClassificationId = 65" +
                                            "  AND   NH.HistoryPeriod < 250" +
                                            "  AND   NH.CostCentreDepartmentFlag  IS NULL" +
                                            "  AND   NH.IsCommitment = @iv_IsCommitment" +

                                            "  GROUP BY NH.HistoryYear" +
                                            "         , NH.CurrencyId" +

                                            // Add in any direct bookings to the ProfitBF nominal

                                            "  MERGE #ProfitBF PBF" +
                                            "  USING(SELECT HistoryClassificationId = ASCII(@NominalType)" +
                                            "               , HistoryCode = @HistoryCode" +
                                            "               , NominalCode = @ProfitBF" +
                                            "               , HistoryYear = NH.HistoryYear - 1900" +
                                            "               , CurrencyId" +
                                            "               , SalesAmount = SUM(SalesAmount)" +
                                            "               , PurchaseAmount = SUM(PurchaseAmount)" +
                                            "          FROM   " + CompanyCode + ".evw_NominalHistory NH(READUNCOMMITTED)" +
                                            "          WHERE NH.HistoryClassificationId = 67" +
                                            "          AND   NH.HistoryCode = @HistoryCode" +
                                            "          AND   NH.HistoryPeriod < 250" +
                                            "          GROUP BY HistoryYear" +
                                            "                 , CurrencyId" +
                                            "        ) NewData ON NewData.HistoryCode = PBF.HistoryCode" +
                                            "                 AND NewData.HistoryYear = PBF.HistoryYear" +
                                            "                 AND NewData.CurrencyId = PBF.CurrencyId" +
                                            "  WHEN MATCHED THEN" +
                                            "       UPDATE" +
                                            "          SET SalesAmount = PBF.SalesAmount + NewData.SalesAmount" +
                                            "            , PurchaseAmount = PBF.PurchaseAmount + NewData.PurchaseAmount" +

                                            "  WHEN NOT MATCHED BY TARGET THEN" +
                                            "       INSERT(HistoryClassificationId, HistoryCode, NominalCode, HistoryYear, CurrencyId, SalesAmount, PurchaseAmount)" +
                                            "       VALUES(NewData.HistoryClassificationId, NewData.HistoryCode, NewData.NominalCode, NewData.HistoryYear, NewData.CurrencyId, NewData.SalesAmount, NewData.PurchaseAmount)" +
                                            "  ;" +

                                            "  SELECT @MinYear = MIN(HistoryYear), @MaxYear = MAX(HistoryYear)" +
                                            "  FROM   #ProfitBF" +

                                            // Fills any gaps in ProfitBF years" +

                                            "  INSERT INTO #ProfitBF" +
                                            "  SELECT P1.HistoryClassificationId, P1.HistoryCode, P1.NominalCode, EY.ExchequerYear, P1.CurrencyId, 0, 0" +
                                            "  FROM #ProfitBF P1" +
                                            "  OUTER APPLY(SELECT DISTINCT ExchequerYear" +
                                            "                FROM " + CompanyCode + ".evw_Period P" +
                                            "                WHERE P.ExchequerYear BETWEEN @MinYear AND @MaxYear" +
                                            "              ) EY" +
                                            "  WHERE P1.HistoryYear <= EY.ExchequerYear" +
                                            "  AND NOT EXISTS(SELECT TOP 1 1" +
                                            "                    FROM   #ProfitBF P2" +
                                            "                    WHERE P1.HistoryClassificationId = P2.HistoryClassificationId" +
                                            "                    AND   P1.HistoryCode = P2.HistoryCode" +
                                            "                    AND   P1.CurrencyId = P2.CurrencyId" +
                                            "                    AND   EY.ExchequerYear = P2.HistoryYear" +
                                            "                   )" +

                                            // Inital Result set removed //

                                            // The following finally checks that the ProfitBF hierarchy adds up

                                            " DECLARE @TopLevelNominalCode INT" +

                                            "  SELECT @TopLevelNominalCode = N.NominalCode" +
                                            "  FROM " + CompanyCode + ".evw_NominalAscendant NA" +
                                            "  JOIN " + CompanyCode + ".evw_Nominal N ON NA.AscendantNominalCode = N.NominalCode" +
                                            "  JOIN " + CompanyCode + ".evw_NominalHierarchy NHIER ON N.NominalCode = NHIER.NominalCode" +
                                            "  WHERE NHIER.NominalLevel = 0" +
                                            "  AND NA.NominalCode = @ProfitBF" +

                                            "  IF OBJECT_ID('tempdb..#PBFHierarchyChildren') IS NOT NULL" +
                                            "    DROP TABLE #PBFHierarchyChildren" +

                                            // Put the children of the Profit BF hierarchy into a temp.table" +

                                            "  SELECT NominalCode = N.NominalCode" +
                                            "       , HC.HistoryCode" +
                                            "  INTO   #PBFHierarchyChildren" +
                                            "  FROM   " + CompanyCode + ".evw_NominalDescendant ND" +
                                            "  JOIN   " + CompanyCode + ".evw_Nominal            N ON ND.DescendantNominalCode = N.NominalCode" +
                                            "  CROSS APPLY(SELECT HistoryCode = [common].efn_CreateNominalHistoryCode(N.NominalCode, NULL, NULL, NULL, @iv_IsCommitment)" +
                                            "              ) HC" +
                                            "  WHERE  ND.NominalCode = @TopLevelNominalCode" +
                                            "  AND    CONVERT(BIT, ISNULL((SELECT TOP 1 1 " +
                                            "           FROM " + CompanyCode + ".NOMINAL C " +
                                            "           WHERE  N.NominalCode = C.glParent), 0)) = @c_False" +

                                            "  IF OBJECT_ID('tempdb..#PBFRawData') IS NOT NULL" +
                                            "    DROP TABLE #PBFRawData" +

                                            "  SELECT PBFHC.NominalCode, H.HistoryPeriodKey, H.ExchequerYear, HistoryPeriod, CurrencyId, SalesAmount, PurchaseAmount" +
                                            "  INTO #PBFRawData" +
                                            "  FROM   #PBFHierarchyChildren PBFHC" +
                                            "  JOIN   " + CompanyCode + ".evw_NominalHistory H(READUNCOMMITTED) ON PBFHC.HistoryCode = H.HistoryCode" +
                                            "                                                               AND H.HistoryPeriod < 250" +
                                            "  WHERE   PBFHC.NominalCode <> @ProfitBF" +
                                            "  AND(H.SalesAmount <> 0 OR H.PurchaseAmount <> 0)" +
                                            "  UNION" +
                                            "  SELECT NominalCode" +
                                            "       , HistoryPeriodKey = ((HistoryYear + 1900) * 1000) + 249" +
                                            "       , HistoryYear" +
                                            "       , HistoryPeriod = 249" +
                                            "       , CurrencyId" +
                                            "       , SalesAmount" +
                                            "       , PurchaseAmount" +
                                            "  FROM #ProfitBF" +
                                            "  ORDER BY NominalCode DESC" +

                                            "  IF OBJECT_ID('tempdb..#PBFH') IS NOT NULL" +
                                            "    DROP TABLE #PBFH" +

                                            "  SELECT NA.NominalCode, AscendantNominalCode" +
                                            "  INTO #PBFH" +
                                            "  FROM " + CompanyCode + ".evw_NominalAscendant NA" +
                                            "  JOIN #PBFHierarchyChildren PBFHC ON NA.NominalCode = PBFHC.NominalCode" +

                                            "  IF OBJECT_ID('tempdb..#PBFHierarchyData') IS NOT NULL" +
                                            "    DROP TABLE #PBFHierarchyData" +

                                            "  SELECT HistoryClassificationId = CONVERT(INT, NULL)" +
                                            "       , NominalCode = P1.AscendantNominalCode" +
                                            "       , HistoryCode = CONVERT(VARBINARY(21), NULL)" +
                                            "       , PBF.ExchequerYear" +
                                            "       , HistoryPeriodKey" +
                                            "       , CurrencyId" +
                                            "       , SalesAmount" +
                                            "       , PurchaseAmount" +
                                            "  INTO   #PBFHierarchyData" +
                                            "  FROM   #PBFRawData PBF" +
                                            "  JOIN   #PBFH P1 ON PBF.NominalCode = P1.NominalCode" +

                                            "  UPDATE PBF" +
                                            "     SET HistoryCode = [common].efn_CreateNominalHistoryCode(PBF.NominalCode, NULL, NULL, NULL, @iv_IsCommitment)" +
                                            "       , HistoryClassificationId = ASCII(N.NominalTypeCode)" +
                                            "    FROM #PBFHierarchyData PBF" +
                                            "    JOIN " + CompanyCode + ".evw_Nominal N ON PBF.NominalCode = N.NominalCode" +

                                            "    	INSERT INTO common.SQLDataValidation " +
                                            "       SELECT IntegrityErrorNo = -59000" +
                                            "            , IntegrityErrorCode = 'E_HPLBF001'" +
                                            "            , Severity = 'High'" +
                                            "            , IntegrityErrorMessage = 'GL Code: ' + convert(varchar(100), PBFData.NominalCode) + ' Period: ' + convert(varchar(3), PBFData.HistoryPeriod) + ' Year: '" +
                                            "                                    + convert(varchar(4), (convert(int, PBFData.ExchequerYear) + 1900)) + ' Sales Difference: '" +
                                            "                                    + convert(varchar(100), ISNULL(convert(int, H.hiSales - PBFData.SalesAmount), 0)) + ' Purchase Difference: ' +" +
                                            "                                    +convert(varchar(100), ISNULL(convert(int, H.hiPurchases - PBFData.PurchaseAmount), 0))" +
                                            "            , IntegritySummaryDescription = 'Errors found in Profit and Loss Brought Forward'" +
                                            "            , SchemaName = '" + CompanyCode + "'" +
                                            "            , TableName = 'HISTORY'" +
                                            "            , PositionId = 0" +
                                            "    FROM (" +
                                            "    SELECT NominalCode, HistoryClassificationId, HistoryCode, ExchequerYear, HistoryPeriod = @c_CTDPeriod, CurrencyId, SalesAmount, PurchaseAmount" +
                                            "    FROM ( SELECT DISTINCT NominalCode, HistoryClassificationId, HistoryCode, ExchequerYear, CurrencyId" +
                                            "             FROM   #PBFHierarchyData" +
                                            "           ) PBF" +
                                            "    CROSS APPLY ( SELECT SalesAmount = SUM(SalesAmount)" +
                                            "                       , PurchaseAmount = SUM(PurchaseAmount)" +
                                            "                  FROM #PBFHierarchyData PBFFin" +
                                            "                  WHERE PBF.HistoryCode = PBFFin.HistoryCode" +
                                            "                  AND   PBF.CurrencyId = PBFFin.CurrencyId" +
                                            "                  AND (((PBF.ExchequerYear + 1900) * 1000) + 255) >= PBFFin.HistoryPeriodKey" +
                                            "                ) Fin" +
                                            "         ) PBFData" +
                                            "    LEFT JOIN " + CompanyCode + ".HISTORY H ON H.hiCode = PBFData.HistoryCode" +
                                            "                  AND H.HiExCLass = PBFData.HistoryClassificationId" +
                                            "                  AND H.hiCurrency = PBFData.CurrencyId" +
                                            "                  AND H.hiYear = PBFData.ExchequerYear" +
                                            "                  AND H.hiPeriod = PBFData.HistoryPeriod" +
                                            "    WHERE /*H.PositionId  IS NULL    OR*/   ROUND(H.hiSales, 2) <> ROUND(PBFData.SalesAmount, 2)" +
                                            "    OR    ROUND(H.hiPurchases, 2) <> ROUND(PBFData.PurchaseAmount, 2)";
            cmd.CommandTimeout = 10000;

            if (conn.State == 0)
                if (connPassword.Trim() == "")
                    conn.Open();
                else
                    conn.Open(ExchequerCommonSQLConnection, "", connPassword.Trim(),
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