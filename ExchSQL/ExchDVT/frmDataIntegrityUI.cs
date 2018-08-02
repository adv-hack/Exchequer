using System;
using System.Data;
using System.Windows.Forms;
using Enterprise01;
using Microsoft.Win32;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Linq;
using System.Threading;
using System.Reflection;
using EnterpriseBeta;
using System.Diagnostics;
using System.IO;
using System.Collections.Generic;
using ADODB;

namespace Data_Integrity_Checker
{
    public partial class frmDataIntegrityUI : Form
    {
        public frmDataIntegrityUI()
        {
            InitializeComponent();
        }

        public void GetCompanies()
        {
            lvCompanies.Items.Clear();

            Int32 Long1 = 0;
            Int32 Long2 = 0;
            Int32 Long3 = 0;

            clsToolkit.EncodeOpCode(97, out Long1, out Long2, out Long3);

            IToolkit2 oToolkit2 = (IToolkit2)new Enterprise01.Toolkit();

            for (int i = 1; i <= oToolkit2.Company.cmCount; i++)
            {
                ICompanyDetail2 oCompanyDetail = (ICompanyDetail2)oToolkit2.Company.cmCompany[i];
                ListViewItem lv = new ListViewItem("");
                lv.SubItems.Add(oCompanyDetail.coCode);
                lv.SubItems.Add(oCompanyDetail.coName.TrimEnd());
                lv.SubItems.Add(oCompanyDetail.coPath.Replace("\0", string.Empty).TrimEnd());
                lv.SubItems.Add("Pending");
                lvCompanies.Items.Add(lv);
            }

            oToolkit2.Configuration.SetDebugMode(Long1, Long2, Long3);

            // Check if Multi-Locations, CC/Depts, Stock and Committment Accounting are enabled for each company

            // Set Array sizes based on number of companies
            CommitmentAccounting = new bool[lvCompanies.Items.Count];
            StockModule = new bool[lvCompanies.Items.Count];
            JobCosting = new bool[lvCompanies.Items.Count];
            CCDept = new bool[lvCompanies.Items.Count];
            Locations = new bool[lvCompanies.Items.Count];

            foreach (ListViewItem lvItem in lvCompanies.Items)
            {
                oToolkit2.Configuration.DataDirectory = lvItem.SubItems[3].Text.ToString().TrimEnd();
                int resToolkit = oToolkit2.OpenToolkit();

                if (resToolkit == 0)
                {
                    if (oToolkit2.Enterprise.enModuleVersion == TEnterpriseModuleVersion.enModStandard)
                        StockModule[lvItem.Index] = false;
                    else
                        StockModule[lvItem.Index] = true;

                    ISystemSetup8 oSystemSetup = (ISystemSetup8)oToolkit2.SystemSetup;

                    if (oSystemSetup.ssReleaseCodes.rcCommitment == TReleaseCodeStatus.rcDisabled)
                        CommitmentAccounting[lvItem.Index] = false;
                    else
                        CommitmentAccounting[lvItem.Index] = true;

                    if (oSystemSetup.ssReleaseCodes.rcJobCosting == TReleaseCodeStatus.rcDisabled)
                        JobCosting[lvItem.Index] = false;
                    else
                        JobCosting[lvItem.Index] = true;

                    if (oToolkit2.Enterprise.enCurrencyVersion == 0)
                        MultiCurrency = false;
                    else
                        MultiCurrency = true;

                    if (oSystemSetup.ssUseCCDept == false)
                        CCDept[lvItem.Index] = false;
                    else
                        CCDept[lvItem.Index] = true;

                    if (oSystemSetup.ssUseLocations == false)
                        Locations[lvItem.Index] = false;
                    else
                        Locations[lvItem.Index] = true;

                    oSystemSetup = null;

                    // Check Current Posting Status
                    IHashFunctions oHashFunctions = (IHashFunctions)oToolkit2.Functions;

                    clsIniFile ini = new clsIniFile();

                    ini.IniFiles(ExchequerPath + "\\SQLConfig.ini");

                    // read current company status
                    string hash = ini.ReadString("Posting", "SQLDaybookPosting-" + lvItem.SubItems[1].Text.ToString().TrimEnd(), "0");

                    if (hash != "0")
                    {
                        if (hash == oHashFunctions.HashText(lvItem.SubItems[1].Text.ToString().TrimEnd() + "=1", ""))
                        {
                            lvItem.SubItems[4].Text = "Enabled";
                        }
                        else if (hash == oHashFunctions.HashText(lvItem.SubItems[1].Text.ToString().TrimEnd() + "=2", ""))
                        {
                            lvItem.SubItems[4].Text = "Disabled";
                        }
                    }
                }

                resToolkit = oToolkit2.CloseToolkit();
            }
        }

        private void btnCheckCompanies_Click(object sender, EventArgs e)
        {
            this.UseWaitCursor = true;
            btnCheckCompanies.Enabled = false;
            btnSelectAll.Enabled = false;
            btnSelectNone.Enabled = false;
            btnClose.Enabled = false;

            clsCoreChecks CoreChecks = new clsCoreChecks();
            clsTransactionHeaderChecks TransactionHeaderChecks = new clsTransactionHeaderChecks();
            clsTransactionLineChecks TransactionLineChecks = new clsTransactionLineChecks();
            clsTransactionLineJobCostingChecks TransactionLineJobCostingChecks = new clsTransactionLineJobCostingChecks();
            clsTransactionLineStockCheck TransactionLineStockChecks = new clsTransactionLineStockCheck();
            clsHistoryChecks HistoryChecks = new clsHistoryChecks();
            clsHistoryCalculations HistoryCalculations = new clsHistoryCalculations();

            //SS:01/03/2018:2018-R1:ABSEXCH-19796: When Running the ExchDVT.exe, SQL Admin Passwords are visible in dump file.
            ADODB.Connection conn = new ADODB.Connection();

            ADODB.Command cmd = new ADODB.Command();
            cmd.CommandText = "IF EXISTS (SELECT * FROM sys.tables WHERE name LIKE 'SQLDataValidation%') DROP TABLE common.SQLDataValidation; " +
                "CREATE TABLE common.SQLDataValidation(IntegrityErrorNo varchar(50), " +
                                                      "IntegrityErrorCode varchar(50), " +
                                                      "Severity varchar(50), " +
                                                      "IntegrityErrorMessage varchar(max), " +
                                                      "IntegritySummaryDescription varchar(max), " +
                                                      "SchemaName varchar(10), " +
                                                      "TableName varchar(100), " +
                                                      "PositionId int);";

            cmd.CommandTimeout = 10000;

            if (conn.State == 0)
                if (connPassword.Trim() == "")
                    conn.Open();
                else
                    conn.Open(ExchequerCommonSQLConnection, "", connPassword.Trim(),
                                                    (int)ConnectModeEnum.adModeUnknown);
            conn.CursorLocation = ADODB.CursorLocationEnum.adUseClient;

            try
            {
                Object recAff;
                cmd.ActiveConnection = conn;
                cmd.CommandType = ADODB.CommandTypeEnum.adCmdText;
                cmd.Execute(out recAff, Type.Missing, (int)ADODB.CommandTypeEnum.adCmdText);
                Console.WriteLine("Table Created Successfully...");

                if (conn.State == 1)
                    conn.Close();
            }
            catch
            {
                throw;
            }

            // Build List of Companies to check
            tsProgressBar.Value = 0;
            tsProgressBar.Maximum = (lvCompanies.CheckedItems.Count * 37) + 1;

            foreach (ListViewItem lvItem in lvCompanies.CheckedItems)
            {
                string Company = lvItem.SubItems[1].Text.ToString();
                tsCheckStatus.Text = "Checking " + Company;
                IncrementToolbar();
                StatusStrip.Refresh();

                // Run Core Checks
                // Check for inverted currencies if system either Euro or Multi-Currency
                if (MultiCurrency == true)
                {
                    CoreChecks.CheckInvertedCurrencies(ExchequerCommonSQLConnection, Company, connPassword);
                }
                IncrementToolbar();

                //SS:01/03/2018:2018-R1:ABSEXCH-19796: When Running the ExchDVT.exe, SQL Admin Passwords are visible in dump file.
                // Run Transaction Header Checks
                // Check for Transaction Headers with Zero Folio Number
                TransactionHeaderChecks.TransactionZeroFolioNum(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check if Transaction Header Trader Codes Exist
                TransactionHeaderChecks.TransactionTraderCodesExist(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check Control GL codes exist if they are set
                TransactionHeaderChecks.TransactionCheckControlGLCodesExistIfSet(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check Control GL Codes are not Headers
                TransactionHeaderChecks.TransactionCheckControlGLNotHeaders(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check Currency Codes exist
                TransactionHeaderChecks.TransactionCheckCurrencyCodeExists(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Run Transaction Line Checks
                // Check Transaction Header exists for non RUN transaction lines
                TransactionLineChecks.TransactionLineExistsWithNoTransactionHeader(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check if Transaction Lines exist with invalid GL Code
                TransactionLineChecks.TransactionLineExistWithInvalidGLCode(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check if Transaction Lines exist with Header GL Code
                TransactionLineChecks.TransactionLineExistWithHeaderGLCode(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check if Transction Lines exist with invalid Trader Code
                TransactionLineChecks.TransactionLineExistInvalidTraderCode(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check if Transaction Line Trader Code is same as Transaction Header Trader Code
                TransactionLineChecks.TransactionLineTraderCodeMatchesHeader(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check Transaction Line Currency Codes Exist
                TransactionLineChecks.TransactionLineCurrencyCodesExist(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check Transaction Line VAT Code Exists
                TransactionLineChecks.TransactionLineVATCodeExists(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check Transaction Line Inclusive VAT Code Exists
                TransactionLineChecks.TransactionLineInclusiveVATCodeExists(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check Transaction Line Period Matches Header Period
                TransactionLineChecks.TransactionLinePeriodMatchesHeaderPeriod(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check History Currency Codes Exist
                HistoryChecks.HistoryCheckCurrencyCodesExist(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check History General Ledger Codes Exist
                HistoryChecks.HistoryCheckGLCodesExist(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check if Cost Centres/Departments are used
                if (CCDept[lvItem.Index] == true)
                {
                    // Check Transaction Line Cost Centre Codes Exist
                    TransactionLineChecks.TransactionLineCostCentresExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check Transaction Line Department Codes Exist
                    TransactionLineChecks.TransactionLineDepartmentsExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check History Cost Centre Codes Exist
                    HistoryChecks.HistoryCheckCostCentreCodesExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check History Department Codes Exist
                    HistoryChecks.HistoryCheckDepartmentCodesExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();
                }

                // Check if Job Costing enabled
                if (JobCosting[lvItem.Index] == true)
                {
                    // Check Employee Codes on Header exist
                    TransactionHeaderChecks.TransactionCheckEmployeeCodesExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check Transaction Line Job Exists
                    TransactionLineJobCostingChecks.TransactionLineJobExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check Transaction Line Job check not Contract
                    TransactionLineJobCostingChecks.TransactionLineCheckJobNotContract(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check Transaction Line Analysis Code Exists
                    TransactionLineJobCostingChecks.TransactionLineCheckAnalysisCodeExists(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check Employee Currency History Codes Exist
                    HistoryChecks.HistoryCheckEmployeeCurrencyCodesExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check Employee History Codes Exist
                    HistoryChecks.HistoryCheckEmployeeCodesExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check Job Currency History Codes Exist
                    HistoryChecks.HistoryCheckJobCurrencyExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check Job History Codes Exist
                    HistoryChecks.HistoryCheckJobExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check Analysis Id History Codes Exist
                    HistoryChecks.HistoryCheckAnalysisIdExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();
                }
                else
                {
                    IncrementToolbar();
                    IncrementToolbar();
                    IncrementToolbar();
                    IncrementToolbar();
                    IncrementToolbar();
                    IncrementToolbar();
                    IncrementToolbar();
                    IncrementToolbar();
                    IncrementToolbar();
                }

                // Check if Stock enabled
                if (StockModule[lvItem.Index] == true)
                {
                    // Check Transaction Line Stock Code Exists
                    TransactionLineStockChecks.TransactionLineStockCodeExists(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check Transaction Line Stock Code not a Group
                    TransactionLineStockChecks.TransactionLineStockCodeNotGroup(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check Stock History Stock Codes Exists
                    HistoryChecks.HistoryCheckStockExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    // Check if Locations is enabled
                    if (Locations[lvItem.Index] == true)
                    {
                        // Check if Transaction Line Location Codes exist
                        TransactionLineStockChecks.TransactionLineLocationCodeDoesNotExist(ExchequerCommonSQLConnection, Company, connPassword);
                        IncrementToolbar();

                        // Check Stock History Location Codes Exists
                        HistoryChecks.HistoryCheckLocationExist(ExchequerCommonSQLConnection, Company, connPassword);
                        IncrementToolbar();

                        // Check Stock History Stock Location Codes Exists
                        HistoryChecks.HistoryCheckStockLocationExist(ExchequerCommonSQLConnection, Company, connPassword);
                        IncrementToolbar();
                    }
                    else
                    {
                        IncrementToolbar();
                        IncrementToolbar();
                        IncrementToolbar();
                    }
                }
                else
                {
                    IncrementToolbar();
                    IncrementToolbar();
                    IncrementToolbar();
                }

                // Check Profit and Loss Brought Forward
                HistoryCalculations.ProfitAndLossBroughtForward(ExchequerCommonSQLConnection, Company, CommitmentAccounting[lvItem.Index], connPassword);
                IncrementToolbar();
            }

            this.UseWaitCursor = false;
            btnCheckCompanies.Enabled = true;
            btnSelectAll.Enabled = true;
            btnSelectNone.Enabled = true;
            //btnEmailResults.Enabled = true;
            btnSaveResults.Enabled = true;
            btnClose.Enabled = true;
            tsCheckStatus.Text = "Checking Completed";

            tsProgressBar.Value = tsProgressBar.Maximum;
            Thread.Sleep(100);
            Application.DoEvents();

            // Display Summary Results in UI
            DisplayResults();
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void btnEmailResults_Click(object sender, EventArgs e)
        {
            frmExportEmail frmExport = new frmExportEmail();

            frmExport.Text = "Email Results";
            frmExport.ChangeButtonText("Email Results");
            frmExport.CompanyCode = "";
            frmExport.ShowDialog();
        }

        private void btnReturnToSummary_Click(object sender, EventArgs e)
        {
            lvDetailedResults.Visible = false;
            btnReturnToSummary.Visible = false;

            lvSummaryResults.Visible = true;
        }

        private void btnSaveResults_Click(object sender, EventArgs e)
        {
            frmExportEmail frmExport = new frmExportEmail();

            frmExport.Text = "Save Results";
            frmExport.ChangeButtonText("Save Results");

            frmExport.ExchequerPath = ExchequerPath;
            frmExport.VersionInfo = tssVersion.Text;
            frmExport.ExchequerCommonSQLConnection = ExchequerCommonSQLConnection;
            //SS:01/03/2018:2018-R1:ABSEXCH-19796: When Running the ExchDVT.exe, SQL Admin Passwords are visible in dump file.
            frmExport.ConnPassword = connPassword;
            frmExport.ShowDialog();
        }

        private void btnSelectAll_Click(object sender, EventArgs e)
        {
            for (int i = 0; i < lvCompanies.Items.Count; i++)
            {
                lvCompanies.Items[i].Checked = true;
            }
        }

        private void btnSelectNone_Click(object sender, EventArgs e)
        {
            for (int i = 0; i < lvCompanies.Items.Count; i++)
            {
                lvCompanies.Items[i].Checked = false;
            }
        }

        private void DataIntegityUI_FormClosed(object sender, FormClosedEventArgs e)
        {
            Application.Exit();
        }

        private void DisplayResults()
        {
            lvSummaryResults.Items.Clear();

            //SS:01/03/2018:2018-R1:ABSEXCH-19796: When Running the ExchDVT.exe, SQL Admin Passwords are visible in dump file.
            ADODB.Connection conn = new ADODB.Connection();
            ADODB.Command cmd = new ADODB.Command();
            cmd.CommandText = "SELECT [IntegrityErrorCode] " +
                                            ", [SummaryDescription] = CONVERT(VARCHAR(100), count(IntegrityErrorCode)) + ' ' + [IntegritySummaryDescription] " +
                                            ", [Severity] " +
                                            ", [SchemaName] " +
                                            ", [TableName] " +
                                            "FROM [common].[SQLDataValidation] " +
                                            "GROUP BY SchemaName, Severity, IntegrityErrorCode, IntegritySummaryDescription, TableName " +
                                            "ORDER BY SchemaName, Severity, IntegrityErrorCode";
            cmd.CommandTimeout = 10000;

            if (conn.State == 0)
                if (connPassword.Trim() == "")
                    conn.Open();
                else
                    conn.Open(ExchequerCommonSQLConnection, "", connPassword.Trim(),
                                                    (int)ADODB.ConnectModeEnum.adModeUnknown);
            conn.CursorLocation = ADODB.CursorLocationEnum.adUseClient;

            cmd.CommandType = ADODB.CommandTypeEnum.adCmdText;
            cmd.ActiveConnection = conn;
            ADODB.Recordset recordSet = null;
            object objRecAff;
            try
            {
                recordSet = (ADODB.Recordset)cmd.Execute(out objRecAff, Type.Missing, (int)ADODB.CommandTypeEnum.adCmdText);
            }
            catch
            {
                throw;
            }

            for (int i = 0; i < recordSet.RecordCount; i++)
            {
                ListViewItem lvItem = new ListViewItem(recordSet.Fields[0].Value);

                lvItem.SubItems.Add(recordSet.Fields[1].Value);
                lvItem.SubItems.Add(recordSet.Fields[2].Value);
                lvItem.SubItems.Add(recordSet.Fields[3].Value);
                lvItem.SubItems.Add(recordSet.Fields[4].Value);

                lvSummaryResults.Items.Add(lvItem);

                recordSet.MoveNext();
            }

            if (conn.State == 1)
                conn.Close();

            // Set INI file based on results of each company
            foreach (ListViewItem lvItem in lvCompanies.CheckedItems)
            {
                tsCheckStatus.Text = "Updating INI file: " + lvItem.SubItems[1].Text.TrimEnd();
                Thread.Sleep(1000);
                Application.DoEvents();

                //SS:01/03/2018:2018-R1:ABSEXCH-19796: When Running the ExchDVT.exe, SQL Admin Passwords are visible in dump file.
                conn = new ADODB.Connection();

                Command command = new ADODB.Command();
                command.CommandText = "SELECT RCount = COUNT(*) " +
                                                "FROM [common].[SQLDataValidation] " +
                                                "WHERE UPPER(Severity) = 'HIGH' " +
                                                "AND SchemaName = '" + lvItem.SubItems[1].Text.TrimEnd() + "'";

                command.CommandTimeout = 10000;

                if (conn.State == 0)
                    if (connPassword.Trim() == "")
                        conn.Open();
                    else
                        conn.Open(ExchequerCommonSQLConnection, "", connPassword.Trim(),
                                                        (int)ADODB.ConnectModeEnum.adModeUnknown);
                conn.CursorLocation = ADODB.CursorLocationEnum.adUseClient;

                command.ActiveConnection = conn;
                ADODB.Recordset rs = null;
                Object objAff;

                try
                {
                    rs = (ADODB.Recordset)command.Execute(out objAff, Type.Missing, (int)ADODB.CommandTypeEnum.adCmdText);
                }
                catch
                {
                    throw;
                }

                {
                    if (Convert.ToInt32(rs.Fields["RCount"].Value) == 0)
                    {
                        // Posting Enabled
                        tsCheckStatus.Text = "Posting Enabled: " + lvItem.SubItems[1].Text.TrimEnd();
                        Thread.Sleep(1000);
                        Application.DoEvents();
                        PostingEnabledDisabled(true, lvItem.SubItems[1].Text.TrimEnd());
                        lvItem.SubItems[4].Text = "Enabled";
                    }
                    else
                    {
                        // Posting Disabled
                        tsCheckStatus.Text = "Posting Disabled: " + lvItem.SubItems[1].Text.TrimEnd();
                        Thread.Sleep(1000);
                        Application.DoEvents();
                        PostingEnabledDisabled(false, lvItem.SubItems[1].Text.TrimEnd());
                        lvItem.SubItems[4].Text = "Disabled";
                    }
                }
                if (conn.State == 1)
                    conn.Close();
            }
            tsCheckStatus.Text = "Check Complete";
            Thread.Sleep(1000);
            Application.DoEvents();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            string ExVersion = "";

            // Set root Exchequer Path
            ExchequerPath = (string)Registry.GetValue("HKEY_CURRENT_USER\\SOFTWARE\\EXCHEQUER\\ENTERPRISE", "SystemDir", "");

            // Check Exchequer Toolkit Version
            if (FileVersionInfo.GetVersionInfo(Path.Combine(ExchequerPath, "enttoolk.dll")).FileMajorPart < 10)
            {
                MessageBox.Show("This utility can only be run on Exchequer 2017 R1 and above", "Exchequer SQL Data Validation Tool", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Application.Exit();
            }

            GetCompanies();

            // Get _Admin Connection String
            ConnectionStringBuilder oConn = new ConnectionStringBuilder(ExchequerPath, "wmie@iris!");
            string ex;
            bool validconnection = oConn.GetNewConnectionString(out ex);

            if (ex != "")
            {
                MessageBox.Show(ex);
            }

            if (validconnection)
            {
                SQLCommonConnectionString = oConn.DecryptedString;

                // Set shared SQL Connection String
                //RB 20/02/2018 2018-R1 ABSEXCH-19790: Check SQL Posting Compatibility: Unhandled exception is occurred when running check for Single Daybook posting.
                SetSQLCommonConnectionString(oConn);

                string assemblyVersion = Assembly.GetExecutingAssembly().GetName().Version.ToString();
                GetExchequerVersion(out ExVersion, oConn);

                tssVersion.Text = ExVersion + "  -  Integrity Checker Version: " + assemblyVersion;
            }
            else
            {
                MessageBox.Show("This utility can only be run on Exchequer SQL Edition installations", "Exchequer SQL Data Validation Tool", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Application.Exit();
            }
        }

        private void GetExchequerVersion(out string ExVersion, ConnectionStringBuilder connObj)
        {
            ExVersion = "";

            //SS:01/03/2018:2018-R1:ABSEXCH-19796: When Running the ExchDVT.exe, SQL Admin Passwords are visible in dump file.
            ADODB.Connection conn = new ADODB.Connection();
            ADODB.Command cmd = new ADODB.Command();

            if (conn.State == 0)
                if (connObj.DecryptedPassword.Trim() == "")
                    conn.Open();
                else
                    conn.Open(ExchequerCommonSQLConnection, "", connObj.DecryptedPassword.Trim(),
                                                    (int)ConnectModeEnum.adModeUnknown);
            conn.CursorLocation = ADODB.CursorLocationEnum.adUseClient;
            try
            {
                cmd.CommandType = ADODB.CommandTypeEnum.adCmdText;
                cmd.CommandText = "SELECT name, value FROM fn_listextendedproperty(default, default, default, default, default, default, default); ";
                cmd.ActiveConnection = conn;
                ADODB.Recordset recordSet = null;
                object objRecAff;
                recordSet = (ADODB.Recordset)cmd.Execute(out objRecAff, Type.Missing, (int)ADODB.CommandTypeEnum.adCmdText);

                if (recordSet.RecordCount > 0)
                    ExVersion = "Exchequer " + recordSet.Fields["value"].Value;

                if (conn.State == 1)
                    conn.Close();
            }
            catch
            {
                throw;
            }
        }

        private void IncrementToolbar()
        {
            tsProgressBar.Increment(1);
            Application.DoEvents();
            Thread.Sleep(100);
        }

        private void lvCompanies_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyData == (Keys.Alt | Keys.Control | Keys.O))
            {
                if (lvCompanies.SelectedItems.Count == 1)
                {
                    if (lvCompanies.SelectedItems[0].SubItems[4].Text == "Enabled")
                    {
                        tsCheckStatus.Text = "Posting Disabled: " + lvCompanies.SelectedItems[0].SubItems[1].Text.TrimEnd();
                        Thread.Sleep(200);
                        Application.DoEvents();
                        PostingEnabledDisabled(false, lvCompanies.SelectedItems[0].SubItems[1].Text.TrimEnd());
                        lvCompanies.SelectedItems[0].SubItems[4].Text = "Disabled";
                    }
                    else if (lvCompanies.SelectedItems[0].SubItems[4].Text == "Disabled")
                    {
                        tsCheckStatus.Text = "Posting Enabled: " + lvCompanies.SelectedItems[0].SubItems[1].Text.TrimEnd();
                        Thread.Sleep(200);
                        Application.DoEvents();
                        PostingEnabledDisabled(true, lvCompanies.SelectedItems[0].SubItems[1].Text.TrimEnd());
                        lvCompanies.SelectedItems[0].SubItems[4].Text = "Enabled";
                    }
                }
            }
        }

        private void lvSummaryResults_DoubleClick(object sender, EventArgs e)
        {
            lvDetailedResults.Items.Clear();

            //SS:01/03/2018:2018-R1:ABSEXCH-19796: When Running the ExchDVT.exe, SQL Admin Passwords are visible in dump file.
            ADODB.Connection conn = new ADODB.Connection();
            ADODB.Command cmd = new ADODB.Command();
            cmd.CommandText = "SELECT [IntegrityErrorMessage] " +
                                            ", [SchemaName] " +
                                            ", [TableName] " +
                                            ", [PositionID] " +
                                            "FROM [common].[SQLDataValidation] " +
                                            "WHERE IntegrityErrorCode = '" + lvSummaryResults.SelectedItems[0].Text + "' " +
                                            "AND SchemaName = '" + lvSummaryResults.SelectedItems[0].SubItems[3].Text + "' " +
                                            "ORDER BY PositionID";
            cmd.CommandTimeout = 10000;

            if (conn.State == 0)
                if (connPassword.Trim() == "")
                    conn.Open();
                else
                    conn.Open(ExchequerCommonSQLConnection, "", connPassword.Trim(),
                                                    (int)ADODB.ConnectModeEnum.adModeUnknown);
            conn.CursorLocation = ADODB.CursorLocationEnum.adUseClient;

            cmd.CommandType = ADODB.CommandTypeEnum.adCmdText;
            cmd.ActiveConnection = conn;
            ADODB.Recordset recordSet = null;
            object objRecAff;
            try
            {
                recordSet = (ADODB.Recordset)cmd.Execute(out objRecAff, Type.Missing, (int)ADODB.CommandTypeEnum.adCmdText);
            }
            catch
            {
                throw;
            }

            for (int i = 0; i < recordSet.RecordCount; i++)
            {
                ListViewItem lvItem = new ListViewItem(recordSet.Fields[0].Value);

                lvItem.SubItems.Add(recordSet.Fields[1].Value);
                lvItem.SubItems.Add(recordSet.Fields[2].Value);
                lvItem.SubItems.Add(recordSet.Fields[3].Value.ToString());

                lvDetailedResults.Items.Add(lvItem);

                recordSet.MoveNext();
            }

            if (conn.State == 1)
                conn.Close();

            lvDetailedResults.Visible = true;
            btnReturnToSummary.Visible = true;

            lvSummaryResults.Visible = false;
        }

        private void PostingEnabledDisabled(bool EnableDisable, string CompanyCode)
        {
            Int32 Long1 = 0;
            Int32 Long2 = 0;
            Int32 Long3 = 0;

            clsToolkit.EncodeOpCode(97, out Long1, out Long2, out Long3);

            IToolkit2 oToolkit2 = (IToolkit2)new Enterprise01.Toolkit();

            int resToolkit = oToolkit2.OpenToolkit();

            if (resToolkit == 0)
            {
                IHashFunctions oHashFunctions = (IHashFunctions)oToolkit2.Functions;

                clsIniFile ini = new clsIniFile();

                ini.IniFiles(ExchequerPath + "\\SQLConfig.ini");

                if (EnableDisable)
                {
                    // Posting Enabled String
                    string CompStatus = CompanyCode.TrimEnd() + "=1";
                    ini.WriteString("Posting", "SQLDaybookPosting-" + CompanyCode.TrimEnd(), oHashFunctions.HashText(CompStatus, ""));
                }
                else
                {
                    string CompStatus = CompanyCode.TrimEnd() + "=2";
                    ini.WriteString("Posting", "SQLDaybookPosting-" + CompanyCode.TrimEnd(), oHashFunctions.HashText(CompStatus, ""));
                }
            }

            resToolkit = oToolkit2.CloseToolkit();

            oToolkit2 = null;
        }

        //RB 20/02/2018 2018-R1 ABSEXCH-19790: Check SQL Posting Compatibility: Unhandled exception is occurred when running check for Single Daybook posting.
        private void SetSQLCommonConnectionString(ConnectionStringBuilder aConnStrBuilderObj)
        {
            // Rebuild Connection String
            string[] ConSplit = Regex.Split(SQLCommonConnectionString, ";");
            ExchequerCommonSQLConnection = "";
            foreach (string CSplit in ConSplit)
            {
                if (CSplit.StartsWith("Data Source"))
                {
                    ExchequerCommonSQLConnection = ExchequerCommonSQLConnection + "Data Source=" + CSplit.Substring(12, (CSplit.Length - 12)) + ";";
                }
                else if (CSplit.StartsWith("Initial Catalog"))
                {
                    ExchequerCommonSQLConnection = ExchequerCommonSQLConnection + "Initial Catalog= " + CSplit.Substring(16, (CSplit.Length - 16)) + ";";
                }
                else if (CSplit.StartsWith("User Id"))
                {
                    ExchequerCommonSQLConnection = ExchequerCommonSQLConnection + "User Id=" + CSplit.Substring(8, (CSplit.Length - 8)) + ";";
                }
                else if (CSplit.StartsWith("Password") && aConnStrBuilderObj.DecryptedPassword == "")
                {
                    ExchequerCommonSQLConnection = ExchequerCommonSQLConnection + "Password= " + CSplit.Substring(9, (CSplit.Length - 9)) + ";";
                }
            }
            ExchequerCommonSQLConnection = ExchequerCommonSQLConnection + "Provider=SQLOLEDB.1";

            if (aConnStrBuilderObj.DecryptedPassword != "")
                connPassword = aConnStrBuilderObj.DecryptedPassword;
        }

        private bool[] CCDept;
        private bool[] CommitmentAccounting;
        private String connPassword;
        private String ExchequerCommonSQLConnection;
        private string ExchequerPath;
        private bool[] JobCosting;
        private bool[] Locations;
        private bool MultiCurrency;
        private string SQLCommonConnectionString = "";
        private bool[] StockModule;
    }
}