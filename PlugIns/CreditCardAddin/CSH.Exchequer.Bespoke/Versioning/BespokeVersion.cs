using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace CSH.Exchequer.Bespoke.Versioning
{
    /// <summary>
    /// Provides version and assembly information services and validation to the bespoke application
    /// </summary>
    public class BespokeVersion
    {
        const string COMPANY_NAME = "IRIS Enterprise Software";
        const string SUPPORT_INFO = "Contact your IRIS Exchequer helpline number";
        const string COPYRIGHT_C = "Copyright ©";
        const string COPYRIGHT_MESSAGE = COPYRIGHT_C + " " + COMPANY_NAME;
        const string PLEASE_CORRECT = "Please correct this value in AssemblyInfo.vb";

        private string _VersionNumber;
        private string _BespokeName;
        private Version _BespokeVersion;

        private bool IsVersionNumberOK()
        {
            //Check Version number in Assembly Information matches standard format used for bespoke
            return (_BespokeVersion.Major >= 5)
                && (_BespokeVersion.Major <= 15)
                && (_BespokeVersion.Minor >= 0)
                && (_BespokeVersion.Minor < 100)
                && (_BespokeVersion.Build > 0)
                && (_BespokeVersion.Build < 1000);
        }

        private bool IsCompanyOK()
        {
            //Check Company Name has been set correctly in Assembly Information
            return (AssemblyAttributes.Company.Substring(0, COMPANY_NAME.Length) == COMPANY_NAME);
        }

        private bool IsCopyrightOK(ref string CopyrightMessage)
        {
            //Check Copyright has been set correctly in Assembly Information
            CopyrightMessage = AssemblyAttributes.Copyright;
            return (CopyrightMessage.TrimEnd(' ',
                                             '1',
                                             '2',
                                             '3',
                                             '4',
                                             '5',
                                             '6',
                                             '7',
                                             '8',
                                             '9',
                                             '0') == COPYRIGHT_MESSAGE);
        }

        private void ValidateAssemblyInfo()
        {
            //initialise
            string CopyrightMessage = "";

            //Check Version Number
            Trace.Assert(IsVersionNumberOK(), "The AssemblyVersion (" + _VersionNumber + ") for this bespoke is not in the correct format.\r\n" + PLEASE_CORRECT);

            //Check Company Name
            Trace.Assert(IsCompanyOK(), "The AssemblyCompany (" + AssemblyAttributes.Company + ") for this bespoke is not set correctly.\r\nIt must be set to : " + COMPANY_NAME + "\r\n" + PLEASE_CORRECT);

            //Check Copyright
            Trace.Assert(IsCopyrightOK(ref CopyrightMessage), "The AssemblyCopyright (" + CopyrightMessage + ") for this bespoke is not set correctly.\r\nIt must be set to : " + COPYRIGHT_MESSAGE + "\r\n", PLEASE_CORRECT);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="BespokeVersion"/> class.
        /// </summary>
        public BespokeVersion()
        {
            //Initialise
            _BespokeVersion = AssemblyAttributes.Version;
            _BespokeName = AssemblyAttributes.Product;

            //Set Version Number (as string)
            _VersionNumber = "v" + _BespokeVersion.Major.ToString() + "." + _BespokeVersion.Minor.ToString().PadRight(2, Convert.ToChar("0")) + "." + _BespokeVersion.Build.ToString().PadLeft(3, Convert.ToChar("0"));

            //Validate Assembly Information
            ValidateAssemblyInfo();
        }

        /// <summary>
        /// Gets the about text.
        /// </summary>
        /// <returns></returns>
        public string GetAboutText()
        {
            //Returns the about text for the Bespoke

            //Initialise
            StringBuilder Message = new StringBuilder();

            //Build Message String
            Message.AppendLine(_BespokeName);
            Message.AppendLine("");
            Message.AppendLine("Version : " + _VersionNumber);
            Message.AppendLine("");
            Message.AppendLine("Author : " + AssemblyAttributes.Company);
            Message.AppendLine("Support : " + SUPPORT_INFO);
            Message.AppendLine("");
            Message.AppendLine(COPYRIGHT_MESSAGE);

            //Show Message
            return Message.ToString();
        }

        /// <summary>
        /// Gets the about strings.
        /// </summary>
        /// <returns></returns>
        public List<string> GetAboutStrings()
        {
            //Build up standard Exchequer about text for this bespoke

            List<string> AboutLines = new List<string>();
            string Separator = "";

            AboutLines.Add("Name : " + _BespokeName);
            AboutLines.Add("Version : " + _VersionNumber);
            AboutLines.Add("Author : " + AssemblyAttributes.Company);
            AboutLines.Add("Support : " + SUPPORT_INFO);
            AboutLines.Add(COPYRIGHT_MESSAGE);
            AboutLines.Add("");
            Separator = Separator.PadLeft(79, Convert.ToChar("-"));
            AboutLines.Add(Separator);
            AboutLines.Add("");

            return AboutLines;
        }

        /// <summary>
        /// Gets the version number.
        /// </summary>
        public string VersionNumber
        {
            //String Version of the bespoke version number
            get { return _VersionNumber; }
        }

        /// <summary>
        /// Gets the name of the bespoke.
        /// </summary>
        /// <value>
        /// The name of the bespoke.
        /// </value>
        public string BespokeName
        {
            //Name of the bespoke (from AssemblyProduct)
            get { return _BespokeName; }
        }
    }
}
