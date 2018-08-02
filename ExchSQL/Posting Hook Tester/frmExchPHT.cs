using System;
using System.Windows.Forms;
using Enterprise01;
using Microsoft.Win32;
using System.Threading;
using Enterprise;
using EnterpriseBeta;
using System.Runtime.InteropServices;
using System.IO;
using System.Diagnostics;

namespace Posting_Hook_Tester
{
    public partial class frmExchPHT : Form
    {
        public frmExchPHT()
        {
            InitializeComponent();
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

        private void DataIntegityUI_FormClosed(object sender, FormClosedEventArgs e)
        {
            Application.Exit();
        }

        private void frmDataIntegrityNoUI_Load(object sender, EventArgs e)
        {
            this.Hide();
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

            // Set root Exchequer Path
            ExchequerPath = (string)Registry.GetValue("HKEY_CURRENT_USER\\SOFTWARE\\EXCHEQUER\\ENTERPRISE", "SystemDir", "");
            Thread.Sleep(100);

            ICOMCustomisation4 oCustom4 = (ICOMCustomisation4)enterpriseObject;

            string[] LogMessage;
            string HookMessage = "Exchequer Posting Hook Tester Results.\nThe following Posting Hook Point/s are enabled." + "\n";

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

            LogMessage = (HookMessage + "\n").Split('\n');

            HookMessage = HookMessage + "\n\n" + "Log file saved. " + ExchequerPath + "\\ExchPHTResults.txt";

            if (HookEnabled)
            {
                // Posting Disabled
                //PostingDisabled();

                // Read ENTCUSTM.INI file to string array
                string EntCustmIni = ExchequerPath + "\\entcustm.ini";
                string[] entCustm = File.ReadAllLines(EntCustmIni);

                // Write Log File
                string LogFile = ExchequerPath + "\\ExchPHTResults.txt";

                File.WriteAllLines(LogFile, LogMessage);
                File.AppendAllLines(LogFile, entCustm);

                MessageBox.Show(HookMessage);
            }
            else
                MessageBox.Show("The currently installed Plug-Ins will not affect enhanced SQL posting");

            Application.Exit();
        }

        // Removed for compatibility with older releases of Exchequer prior to 2017 R1 Patch 2
        //private void PostingDisabled()
        //{
        //    Int32 Long1 = 0;
        //    Int32 Long2 = 0;
        //    Int32 Long3 = 0;

        //    clsToolkit.EncodeOpCode(97, out Long1, out Long2, out Long3);

        //    IToolkit2 oToolkit2 = (IToolkit2)new Enterprise01.Toolkit();

        //    oToolkit2.Configuration.SetDebugMode(Long1, Long2, Long3);

        //    oToolkit2.Configuration.DataDirectory = ExchequerPath;

        //    int resToolkit = oToolkit2.OpenToolkit();

        //    if (resToolkit == 0)
        //    {
        //        for (int i = 1; i <= oToolkit2.Company.cmCount; i++)
        //        {
        //            CompanyCode = oToolkit2.Company.cmCompany[i].coCode;

        //            IHashFunctions oHashFunctions = (IHashFunctions)oToolkit2.Functions;

        //            clsIniFile ini = new clsIniFile();

        //            ini.IniFiles(ExchequerPath + "\\SQLConfig.ini");

        //            string CompStatus = CompanyCode.TrimEnd() + "=2";
        //            ini.WriteString("Posting", "SQLDaybookPosting-" + CompanyCode.TrimEnd(), oHashFunctions.HashText(CompStatus, ""));
        //        }
        //    }
        //}

        private string CompanyCode;
        private COMCustomisation enterpriseObject;
        private string ExchequerPath;
        private bool HookEnabled = false;
    }
}