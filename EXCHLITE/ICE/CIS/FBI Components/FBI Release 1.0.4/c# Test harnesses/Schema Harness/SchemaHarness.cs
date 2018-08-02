using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Data;
using System.Xml;
using System.IO;
using System.Runtime.InteropServices;



namespace Schema_Harness
{
    static class SchemaHarness
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new ct600Harness());
        }


    }
}