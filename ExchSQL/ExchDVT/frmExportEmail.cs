using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Office.Interop.Excel;
using System.Xml;
using System.IO;
using System.Data.SqlClient;

namespace Data_Integrity_Checker
{
    public partial class frmExportEmail : Form
    {
        public frmExportEmail()
        {
            InitializeComponent();
        }

        public string CompanyCode { get; set; }
        public String ExchequerCommonSQLConnection { get; set; }
        //SS:01/03/2018:2018-R1:ABSEXCH-19796: When Running the ExchDVT.exe, SQL Admin Passwords are visible in dump file.
        public String ConnPassword { get; set; }
        public string ExchequerPath { get; set; }
        public string VersionInfo { get; set; }

        public void ChangeButtonText(string ButtonText)
        {
            btnSaveResults.Text = ButtonText;
        }

        private void btnSaveResults_Click(object sender, EventArgs e)
        {
            if (btnSaveResults.Text == "Save Results")
                ExportResults();
            else
                EmailResults();
        }

        private void EmailResults()
        {
        }

        private void ExportResults()
        {
            //SS:01/03/2018:2018-R1:ABSEXCH-19796: When Running the ExchDVT.exe, SQL Admin Passwords are visible in dump file.
            ADODB.Connection conn = new ADODB.Connection();
            ADODB.Command cmd = new ADODB.Command();

            if (CompanyCode == null)
            {
                cmd.CommandText = "SELECT [IntegrityErrorNo]" +
                                    ", [IntegrityErrorCode]" +
                                    ", [Severity]" +
                                    ", [IntegrityErrorMessage]" +
                                    ", [IntegritySummaryDescription]" +
                                    ", [SchemaName]" +
                                    ", [TableName]" +
                                    ", [PositionId]" +
                                    "FROM [common].[SQLDataValidation] ";
            }
            else
            {
                cmd.CommandText = "SELECT [IntegrityErrorNo]" +
                                    ", [IntegrityErrorCode]" +
                                    ", [Severity]" +
                                    ", [IntegrityErrorMessage]" +
                                    ", [IntegritySummaryDescription]" +
                                    ", [SchemaName]" +
                                    ", [TableName]" +
                                    ", [PositionId] " +
                                    "FROM [common].[SQLDataValidation] " +
                                    "WHERE SchemaName = '" + CompanyCode + "'";
            }

            cmd.CommandTimeout = 10000;

            if (conn.State == 0)
                if (ConnPassword.Trim() == "")
                    conn.Open();
                else
                    conn.Open(ExchequerCommonSQLConnection, "", ConnPassword.Trim(),
                                                    (int)ADODB.ConnectModeEnum.adModeUnknown);
            conn.CursorLocation = ADODB.CursorLocationEnum.adUseClient;

            System.Data.DataTable dataTable = new System.Data.DataTable { TableName = "resultSet" };

            try
            {

                cmd.CommandType = ADODB.CommandTypeEnum.adCmdText;
                cmd.ActiveConnection = conn;
                ADODB.Recordset recordSet = null;
                object objRecAff;
                recordSet = (ADODB.Recordset)cmd.Execute(out objRecAff, Type.Missing, (int)ADODB.CommandTypeEnum.adCmdText);

                System.Data.OleDb.OleDbDataAdapter adapter = new System.Data.OleDb.OleDbDataAdapter();
                adapter.Fill(dataTable, recordSet);

                if (conn.State == 1)
                    conn.Close();
            }
            catch
            {
                throw;
            }

            Type officeType = Type.GetTypeFromProgID("Excel.Application");
            if (officeType == null)
            {
                //no Excel installed
                SaveFileDialog.Filter = "XML File | *.xml";
                SaveFileDialog.InitialDirectory = ExchequerPath + "\\Logs";
                SaveFileDialog.DefaultExt = "XML";
                SaveFileDialog.OverwritePrompt = true;
                SaveFileDialog.FileName = "ExchSQLDataValidationResults";
                if (CompanyCode != null)
                    SaveFileDialog.FileName = SaveFileDialog.FileName + "-" + CompanyCode;
                SaveFileDialog.ShowDialog();
                this.UseWaitCursor = true;

                txtCompanyName.Enabled = false;
                txtContactName.Enabled = false;
                txtEmailAddress.Enabled = false;
                btnSaveResults.Enabled = false;
                System.Windows.Forms.Application.DoEvents();

                XmlTextWriter writer = new XmlTextWriter(@SaveFileDialog.FileName, null);
                writer.WriteStartDocument(true);
                writer.Formatting = Formatting.Indented;

                writer.WriteStartElement("SQLDataValidationResults");

                writer.WriteStartElement("CompanyName");
                writer.WriteString(txtCompanyName.Text);
                writer.WriteEndElement();

                writer.WriteStartElement("ContactName");
                writer.WriteString(txtContactName.Text);
                writer.WriteEndElement();

                writer.WriteStartElement("EmailAddress");
                writer.WriteString(txtEmailAddress.Text);
                writer.WriteEndElement();

                writer.WriteStartElement("VersionInfo");
                writer.WriteString(VersionInfo);
                writer.WriteEndElement();

                dataTable.WriteXml(writer);

                writer.WriteEndDocument();

                writer.Close();
            }
            else
            {
                //Excel installed
                SaveFileDialog.Filter = "Excel File | *.xlsx";
                SaveFileDialog.InitialDirectory = ExchequerPath + "\\Logs";
                SaveFileDialog.DefaultExt = "XLSX";
                SaveFileDialog.OverwritePrompt = true;
                SaveFileDialog.FileName = "ExchSQLDataValidationResults";
                if (CompanyCode != null)
                    SaveFileDialog.FileName = SaveFileDialog.FileName + "-" + CompanyCode;
                SaveFileDialog.ShowDialog();

                this.UseWaitCursor = true;

                txtCompanyName.Enabled = false;
                txtContactName.Enabled = false;
                txtEmailAddress.Enabled = false;
                btnSaveResults.Enabled = false;
                System.Windows.Forms.Application.DoEvents();

                clsExcelUtlity obj = new Data_Integrity_Checker.clsExcelUtlity();

                obj.WriteDataTableToExcel(dataTable, "ExchSQL Data Validation Results", SaveFileDialog.FileName, txtCompanyName.Text, txtContactName.Text, txtEmailAddress.Text, VersionInfo);
            }

            this.UseWaitCursor = false;
            dataTable = null;

            Close();
        }

        private void frmExportEmail_Load(object sender, EventArgs e)
        {
            btnSaveResults.Enabled = true;
            txtCompanyName.Enabled = true;
            txtContactName.Enabled = true;
            txtEmailAddress.Enabled = true;
        }

        private void txtEmailAddress_Validating(object sender, CancelEventArgs e)
        {
            clsEmailValidation EmailValidation = new clsEmailValidation();

            bool ValidEmail = EmailValidation.IsValidEmail(txtEmailAddress.Text);

            if (ValidEmail != true)
            {
                MessageBox.Show("Please enter a valid Email Address");
                txtEmailAddress.Focus();
            }
        }
    }
}