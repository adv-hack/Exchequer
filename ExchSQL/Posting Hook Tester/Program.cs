using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Posting_Hook_Tester
{
    internal static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        private static void Main(string[] args)
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Process[] pname = Process.GetProcessesByName("ENTER1");

            if (pname.Length == 0)
            {
                MessageBox.Show("Please run Exchequer before running this utility.");
                Application.Exit();
            }
            else
                Application.Run(new frmExchPHT());
        }
    }
}