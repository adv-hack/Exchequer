using System;
using System.Data;
using System.Windows.Forms;
using Enterprise01;
using Microsoft.Win32;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.IO;
using System.Threading;
using System.Reflection;
using EnterpriseBeta;
using Enterprise;
using System.Diagnostics;
using ADODB;
using System.Runtime.InteropServices;

namespace Data_Integrity_Checker
{
    public partial class frmDataIntegrityNoUI : Form
    {
        public frmDataIntegrityNoUI()
        {
            InitializeComponent();
        }

        public void GetCompanies()
        {
            Int32 Long1 = 0;
            Int32 Long2 = 0;
            Int32 Long3 = 0;

            clsToolkit.EncodeOpCode(97, out Long1, out Long2, out Long3);

            IToolkit2 oToolkit2 = (IToolkit2)new Enterprise01.Toolkit();

            for (int i = 1; i <= oToolkit2.Company.cmCount; i++)
            {
                ICompanyDetail2 oCompanyDetail = (ICompanyDetail2)oToolkit2.Company.cmCompany[i];

                if (oCompanyDetail.coCode == CompanyCode)
                {
                    oToolkit2.Configuration.DataDirectory = oCompanyDetail.coPath;
                    CompanyPath = oCompanyDetail.coPath.TrimEnd();

                    // Create flag file to show posting check is running
                    fileString = Path.Combine(CompanyPath, "SQLPost.lck");

                    if (!File.Exists(fileString))
                    {
                        using (FileStream fs = File.Create(fileString))
                        {
                        }
                    }
                    else
                    {
                        MessageBox.Show("A Data Validation check is currently in progress.");
                        Application.Exit();
                    }

                    break;
                }
            }

            oToolkit2.Configuration.SetDebugMode(Long1, Long2, Long3);

            // Check if Multi-Locations, CC/Depts, Stock and Committment Accounting are enabled company
            int resToolkit = oToolkit2.OpenToolkit();

            if (resToolkit == 0)
            {
                if (oToolkit2.Enterprise.enModuleVersion == TEnterpriseModuleVersion.enModStandard)
                    StockModule = false;
                else
                    StockModule = true;

                ISystemSetup8 oSystemSetup = (ISystemSetup8)oToolkit2.SystemSetup;

                if (oSystemSetup.ssReleaseCodes.rcCommitment == TReleaseCodeStatus.rcDisabled)
                    CommitmentAccounting = false;
                else
                    CommitmentAccounting = true;

                if (oSystemSetup.ssReleaseCodes.rcJobCosting == TReleaseCodeStatus.rcDisabled)
                    JobCosting = false;
                else
                    JobCosting = true;

                if (oSystemSetup.ssUseCCDept == false)
                    CCDept = false;
                else
                    CCDept = true;

                if (oSystemSetup.ssUseLocations == false)
                    Locations = false;
                else
                    Locations = true;

                if (oToolkit2.Enterprise.enCurrencyVersion == 0)
                    MultiCurrency = false;
                else
                    MultiCurrency = true;

                oSystemSetup = null;
            }

            resToolkit = oToolkit2.CloseToolkit();
        }

        /// <summary>
        /// Application Exit Event
        /// </summary>
        /// <param name="sender">object sender</param>
        /// <param name="s">EventArgs e</param>
        private void Application_Exit(object sender, EventArgs s)
        {
            if (this.enterpriseObject != null)
            {
                this.enterpriseObject = null;
            }

            Application.ApplicationExit -= this.Application_Exit;
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            PostingEnabledDisabled(false, true);

            File.Delete(fileString);

            Application.Exit();
        }

        private void btnSaveResults_Click(object sender, EventArgs e)
        {
            frmExportEmail frmExport = new frmExportEmail();

            frmExport.Text = "Save Results";
            frmExport.ChangeButtonText("Save Results");

            frmExport.ExchequerPath = ExchequerPath;
            frmExport.VersionInfo = tssVersion.Text;
            frmExport.ExchequerCommonSQLConnection = ExchequerCommonSQLConnection;
            frmExport.ShowDialog();
        }

        private void CheckCompany()
        {
            this.UseWaitCursor = true;

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

            // Clear Old Results for Company
            cmd = new ADODB.Command();
            cmd.CommandText = "DELETE common.SQLDataValidation WHERE SchemaName = '" + CompanyCode + "'";
            cmd.CommandTimeout = 10000;

            if (conn.State == 0)
                if (connPassword.Trim() == "")
                    conn.Open();
                else
                    conn.Open(ExchequerCommonSQLConnection, "", connPassword.Trim(),
                                                    (int)ConnectModeEnum.adModeUnknown);

            try
            {
                cmd.ActiveConnection = conn;

                Object recAff;
                cmd.CommandType = ADODB.CommandTypeEnum.adCmdText;
                cmd.Execute(out recAff, Type.Missing, (int)ADODB.CommandTypeEnum.adCmdText);
                Console.WriteLine("Old Results Deleted Successfully...");

                if (conn.State == 1)
                    conn.Close();
            }
            catch
            {
                throw;
            }

            tsProgressBar.Value = 0;
            tsProgressBar.Maximum = 26;

            string Company = CompanyCode;

            IncrementToolbar();
            tsProgressBar.Refresh();

            lblStatus.Text = "Checking Currencies";

            // Run Core Checks
            // Check for inverted currencies if system either Euro or Multi-Currency
            if (MultiCurrency == true)
            {
                CoreChecks.CheckInvertedCurrencies(ExchequerCommonSQLConnection, Company, connPassword);
            }
            IncrementToolbar();

            lblStatus.Text = "Checking Transaction Headers";

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

            lblStatus.Text = "Checking Transaction Lines";

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

            //// Check History Currency Codes Exist
            //HistoryChecks.HistoryCheckCurrencyCodesExist(ExchequerCommonSQLConnection, Company);
            //IncrementToolbar();

            //// Check History General Ledger Codes Exist
            //HistoryChecks.HistoryCheckGLCodesExist(ExchequerCommonSQLConnection, Company);
            //IncrementToolbar();

            // Check if Cost Centres/Departments are used
            if (CCDept == true)
            {
                lblStatus.Text = "Checking Cost Centres and Departments";

                // Check Transaction Line Cost Centre Codes Exist
                TransactionLineChecks.TransactionLineCostCentresExist(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check Transaction Line Department Codes Exist
                TransactionLineChecks.TransactionLineDepartmentsExist(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                //// Check History Cost Centre Codes Exist
                //HistoryChecks.HistoryCheckCostCentreCodesExist(ExchequerCommonSQLConnection, Company);
                //IncrementToolbar();

                //// Check History Department Codes Exist
                //HistoryChecks.HistoryCheckDepartmentCodesExist(ExchequerCommonSQLConnection, Company);
                //IncrementToolbar();
            }
            else
            {
                IncrementToolbar();
                IncrementToolbar();
            }

            // Check if Job Costing enabled
            if (JobCosting == true)
            {
                lblStatus.Text = "Checking Job Costing";

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

                //// Check Employee Currency History Codes Exist
                //HistoryChecks.HistoryCheckEmployeeCurrencyCodesExist(ExchequerCommonSQLConnection, Company);
                //IncrementToolbar();

                //// Check Employee History Codes Exist
                //HistoryChecks.HistoryCheckEmployeeCodesExist(ExchequerCommonSQLConnection, Company);
                //IncrementToolbar();

                //// Check Job Currency History Codes Exist
                //HistoryChecks.HistoryCheckJobCurrencyExist(ExchequerCommonSQLConnection, Company);
                //IncrementToolbar();

                //// Check Job History Codes Exist
                //HistoryChecks.HistoryCheckJobExist(ExchequerCommonSQLConnection, Company);
                //IncrementToolbar();

                //// Check Analysis Id History Codes Exist
                //HistoryChecks.HistoryCheckAnalysisIdExist(ExchequerCommonSQLConnection, Company);
                //IncrementToolbar();
            }
            else
            {
                IncrementToolbar();
                IncrementToolbar();
                IncrementToolbar();
                IncrementToolbar();
            }

            // Check if Stock enabled
            if (StockModule == true)
            {
                lblStatus.Text = "Checking Stock Records";

                // Check Transaction Line Stock Code Exists
                TransactionLineStockChecks.TransactionLineStockCodeExists(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                // Check Transaction Line Stock Code not a Group
                TransactionLineStockChecks.TransactionLineStockCodeNotGroup(ExchequerCommonSQLConnection, Company, connPassword);
                IncrementToolbar();

                //// Check Stock History Stock Codes Exists
                //HistoryChecks.HistoryCheckStockExist(ExchequerCommonSQLConnection, Company);
                //IncrementToolbar();

                // Check if Locations is enabled
                if (Locations == true)
                {
                    lblStatus.Text = "Checking Locations";

                    // Check if Transaction Line Location Codes exist
                    TransactionLineStockChecks.TransactionLineLocationCodeDoesNotExist(ExchequerCommonSQLConnection, Company, connPassword);
                    IncrementToolbar();

                    //// Check Stock History Location Codes Exists
                    //HistoryChecks.HistoryCheckLocationExist(ExchequerCommonSQLConnection, Company);
                    //IncrementToolbar();

                    //// Check Stock History Stock Location Codes Exists
                    //HistoryChecks.HistoryCheckStockLocationExist(ExchequerCommonSQLConnection, Company);
                    //IncrementToolbar();
                }
                else
                {
                    IncrementToolbar();
                }
            }
            else
            {
                IncrementToolbar();
                IncrementToolbar();
                IncrementToolbar();
            }

            lblStatus.Text = "Checking Profit and Loss Brought Forward";

            // Check Profit and Loss Brought Forward
            HistoryCalculations.ProfitAndLossBroughtForward(ExchequerCommonSQLConnection, Company, CommitmentAccounting, connPassword);
            IncrementToolbar();

            this.UseWaitCursor = false;
            lblStatus.Text = "Checking Completed";

            tsProgressBar.Value = tsProgressBar.Maximum;
            Thread.Sleep(100);
            Application.DoEvents();

            // Display Summary Results in UI
            DisplayResults();
        }

        private void DataIntegityUI_FormClosed(object sender, FormClosedEventArgs e)
        {
            Application.Exit();
        }

        private void DisplayResults()
        {
            //SS:01/03/2018:2018-R1:ABSEXCH-19796: When Running the ExchDVT.exe, SQL Admin Passwords are visible in dump file.
            ADODB.Connection conn = new ADODB.Connection();
            ADODB.Command cmd = new ADODB.Command();
            cmd.CommandText = "SELECT RCount = COUNT(*) " +
                                            "FROM [common].[SQLDataValidation] " +
                                            "WHERE UPPER(Severity) = 'HIGH' " +
                                            "AND SchemaName = '" + CompanyCode + "'";
            cmd.CommandTimeout = 10000;

            if (conn.State == 0)
                if (connPassword.Trim() == "")
                    conn.Open();
                else
                    conn.Open(ExchequerCommonSQLConnection, "", connPassword.Trim(),
                                                    (int)ADODB.ConnectModeEnum.adModeUnknown);
            conn.CursorLocation = ADODB.CursorLocationEnum.adUseClient;

            DataTable dataTable = new DataTable();

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
                if (Convert.ToInt32(recordSet.Fields["RCount"].Value) == 0)
                {
                    // Posting Enabled
                    PostingEnabledDisabled(true, false);
                }
                else
                {
                    // Posting Disabled
                    PostingEnabledDisabled(false, false);
                }
            }

            File.Delete(fileString);

            Application.Exit();
        }

        private void frmDataIntegrityNoUI_Load(object sender, EventArgs e)
        {
            Application.ApplicationExit += this.Application_Exit;

            try
            {
                try
                {   // Try to connect to an existing COM Customisationwhich is
                    // Registered in the Windows Running Objects Table
                    this.enterpriseObject = Marshal.GetActiveObject("Enterprise.COMCustomisation") as COMCustomisation;
                }
                catch
                {
                    // This is a specifc exception. GetActiveObject will not return null, it will throw
                    // an Operation Unavailable exception
                    this.enterpriseObject = new Enterprise.COMCustomisation();
                }

                if (this.enterpriseObject == null)
                {
                    throw new NullReferenceException("Enterprise COM object could not be created");
                }
            }
            catch (Exception systemException)
            {
                MessageBox.Show("The application was terminated." + Environment.NewLine +
                                "Details: " + Environment.NewLine +
                                systemException.Message);
                Application.Exit();
            }

            string ExVersion = "";

            // Set root Exchequer Path
            ExchequerPath = (string)Registry.GetValue("HKEY_CURRENT_USER\\SOFTWARE\\EXCHEQUER\\ENTERPRISE", "SystemDir", "");

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

            // Check Exchequer Toolkit Version
            if (FileVersionInfo.GetVersionInfo(Path.Combine(ExchequerPath, "enttoolk.dll")).FileMajorPart < 10)
            {
                MessageBox.Show("This utility can only be run on Exchequer 2017 R1 and above", "Exchequer SQL Data Validation Tool", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Application.Exit();
            }
        }

        private void frmDataIntegrityNoUI_Shown(object sender, EventArgs e)
        {
            Application.DoEvents();
            Thread.Sleep(100);

            ICOMCustomisation4 oCustom4 = (ICOMCustomisation4)enterpriseObject;

            string HookMessage = "The Data Validation Tool cannot continue due to the following Hook Point/s being enabled." + "\n";

            if (oCustom4.HookPointEnabled(102000, 80))
            {
                HookMessage = HookMessage + "\n" + "   Hook Point: 2000, 80 (Convert Date To Period/Year)";
                HookEnabled = true;
            }

            if (oCustom4.HookPointEnabled(102000, 81))
            {
                HookMessage = HookMessage + "\n" + "   Hook Point: 2000, 81 (Convert Period/Year To Date)";
                HookEnabled = true;
            }

            if (oCustom4.HookPointEnabled(104000, 52))
            {
                HookMessage = HookMessage + "\n" + "   Hook Point: 4000, 52 (Posting - Set Cost Of Sales GL)";
                HookEnabled = true;
            }

            if (oCustom4.HookPointEnabled(104000, 57))
            {
                HookMessage = HookMessage + "\n" + "   Hook Point: 4000, 57 (Protect Transaction Line Date)";
                HookEnabled = true;
            }

            if (oCustom4.HookPointEnabled(104000, 88))
            {
                HookMessage = HookMessage + "\n" + "   Hook Point: 4000, 88 (Override CC/Dept on Posting Control Line)";
                HookEnabled = true;
            }

            if (oCustom4.HookPointEnabled(190001, 2))
            {
                HookMessage = HookMessage + "\n" + "   Hook Point: 90001, 2 (Override VAT / Tax Period during Transaction Posting)";
                HookEnabled = true;
            }

            if (HookEnabled)
            {
                // Posting Disabled
                PostingEnabledDisabled(false, false);

                MessageBox.Show(HookMessage);
                File.Delete(fileString);
                Application.Exit();
            }
            else
                CheckCompany();
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

        private void PostingEnabledDisabled(bool EnableDisable, bool Cancelled)
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
                    MessageBox.Show("SQL Posting Optimisations are enabled for this company", "Exchequer SQL Data Validation Tool", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    // if not cancelled show message or export file
                    if (!Cancelled)
                    {
                        string CompStatus = CompanyCode.TrimEnd() + "=2";
                        ini.WriteString("Posting", "SQLDaybookPosting-" + CompanyCode.TrimEnd(), oHashFunctions.HashText(CompStatus, ""));

                        if (!HookEnabled)
                        {
                            MessageBox.Show("Unfortunately due to High Severity items being found you will be unable to use the SQL Posting Optimisations." + "\n" + "Please send the results to your Exchequer support provider to allow the issues to be investigated.", "Exchequer SQL Data Validation Tool", MessageBoxButtons.OK, MessageBoxIcon.Warning);

                            frmExportEmail frmExport = new frmExportEmail();

                            frmExport.Text = "Save Results";
                            frmExport.ChangeButtonText("Save Results");

                            frmExport.ExchequerPath = ExchequerPath;
                            frmExport.VersionInfo = tssVersion.Text;
                            frmExport.ExchequerCommonSQLConnection = ExchequerCommonSQLConnection;
                            frmExport.CompanyCode = CompanyCode;
                            // ABSEXCH-20380 - NullReferenceException when saving results in DVT following database connection changes
                            frmExport.ConnPassword = connPassword;
                            frmExport.ShowDialog();
                        }
                    }
                    else
                    {
                        string CompStatus = CompanyCode.TrimEnd() + "=0";
                        ini.WriteString("Posting", "SQLDaybookPosting-" + CompanyCode.TrimEnd(), oHashFunctions.HashText(CompStatus, ""));
                    }
                }
            }
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

        private bool CCDept;
        private bool CommitmentAccounting;
        private string CompanyCode = Environment.GetCommandLineArgs()[1];
        private string CompanyPath;
        private string connPassword;
        private COMCustomisation enterpriseObject;
        private string ExchequerCommonSQLConnection;
        private string ExchequerPath;
        private string fileString;
        private bool HookEnabled = false;
        private bool JobCosting;
        private bool Locations;
        private bool MultiCurrency;
        private string SQLCommonConnectionString = "";
        private bool StockModule;
    }
}