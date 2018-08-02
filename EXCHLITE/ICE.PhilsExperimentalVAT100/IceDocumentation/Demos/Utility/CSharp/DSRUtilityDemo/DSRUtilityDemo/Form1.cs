using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DSRUtility;
using System.IO;

namespace DSRUtilityDemo
{

    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        public string GetFile()
        {
            if (odFiles.ShowDialog() == DialogResult.OK)
            {                               
                return odFiles.FileName;              
                
            }
            else { return ""; }
        }

        private void btnCompress_Click(object sender, EventArgs e)
        {
            string lFile = GetFile();
            DSRUtil lUtil = new DSRUtil();
            bool lRes = false;

            if (lFile.Length > 0)
            {
                lRes = lUtil.Compress(lFile, "");
                if (lRes == true)
                {
                    MessageBox.Show("Success"); 
                }
                else { MessageBox.Show("Failure"); }
                lUtil = null;
            }
        }

        private void btnDeCompress_Click(object sender, EventArgs e)
        {
            string lFile = GetFile();
            DSRUtil lUtil = new DSRUtil();
            bool lRes = false;

            if (lFile.Length > 0)
            {
                lRes = lUtil.Decompress(lFile, "");
                if (lRes == true)
                {
                    MessageBox.Show("Success");
                }
                else { MessageBox.Show("Failure"); }
                lUtil = null;
            }

        }

        private void btnEncrypt_Click(object sender, EventArgs e)
        {
            string lFile = GetFile();
            DSRUtil lUtil = new DSRUtil();
            bool lRes = false;

            if (lFile.Length > 0)
            {
                lRes = lUtil.EnCrypt(lFile, "");
                if (lRes == true)
                {
                    MessageBox.Show("Success");
                }
                else { MessageBox.Show("Failure"); }
                lUtil = null;
            }

        }

        private void btnDecrypt_Click(object sender, EventArgs e)
        {
            string lFile = GetFile();
            DSRUtil lUtil = new DSRUtil();
            bool lRes = false;

            if (lFile.Length > 0)
            {
                lRes = lUtil.Decrypt(lFile, "");
                if (lRes == true)
                {
                    MessageBox.Show("Success");
                }
                else { MessageBox.Show("Failure"); }
                lUtil = null;
            }

        }

        private void btnGetXml_Click(object sender, EventArgs e)
        {
            string lFile = GetFile();
            DSRUtil lUtil = new DSRUtil();
            string lRes = "";

            if (lFile.Length > 0)
            {
                lRes = lUtil.GetXml(lFile);
                if (lRes.Length > 0)
                {
                    MessageBox.Show("Success");
                }
                else { MessageBox.Show("Failure"); }
                lUtil = null;
            }

        }

        private void btnCreateFile_Click(object sender, EventArgs e)
        {
            
            string pxml = @"<?xml version='1.0'?> <val:version xmlns:val='urn:www-iris-co-uk:version'><message guid='{04A2802D-10B3-4244-9467-DDC38A26D33E}' number='1' count='1' source='test@exc hequer.com' destination='test2@exchequer.com' flag='0' plugin='Sys' datatype='16' desc='' xsl='version.xsl' xsd='version.xsd' startperiod='0' startyear='0' endperiod='0' endyear='0'><vrdetails><vrmodule>2</vrmodule><vrcurrency>2</vrcurrency><vrproduct>1</vrproduct></vrdetails><vrmodules><vrinstalled>4</vrinstalled><vrinstalled>10</vrinstalled><vrinstalled>20</vrinstalled><vrinstalled>21</vrinstalled></vrmodules></message> </val:version>";

            
            string lresult = "";
            // constructor of this class fill some of the fields
            FileHeader hd = new FileHeader();
            DSRUtil lUtil = new DSRUtil();
            // result comes up separated by "," if more than one file returns

            lresult = lUtil.CreateDSRFiles(hd, "sample.xml", pxml);

            MessageBox.Show(lresult);
            
        }
    }


    internal class FileHeader : DSRFileHeader
    {
        #region DSRFileHeader Members

        public string fBatchId;
        public uint fCheckSum;
        public string fCompGuid;
        public string fEndChar;
        public string fExCode;
        public ushort fFlags;
        public sbyte fMode;
        public uint fOrder;
        public uint fSplit;
        public uint fSplitCheckSum;
        public uint fSplitTotal;
        public string fStartChar;
        public uint fTotal;
        public string fVersion;


        public FileHeader()
        {
            fStartChar = "|";
            fBatchId = "{61020536-110A-4993-BE22-BDDCD6EDF2DD}";
            fVersion = "0.0.0.0h";
            fExCode = "COMP01";
            fCompGuid = "{04C276B2-B6D3-4D8B-9384-61536DFD7FDC}";
            fFlags = 0;
            fMode = 0;
            fEndChar = "|";
            fCheckSum = 0;
            fOrder = 0;
            fSplit = 0;
            fSplitCheckSum = 0;
            fSplitTotal = 0;      
            fTotal = 0;      
        }

        public string BatchId
        {
            get { return fBatchId; }
            set { fBatchId = value;  }
        }

        public uint CheckSum
        {
            get { return fCheckSum; }
            set { fCheckSum = value; }
        }

        public string CompGuid
        {
            get { return fCompGuid; }
            set { fCompGuid = value; }
        }

        public string EndChar
        {
            get { return fEndChar; }
            set { fEndChar = value; }
        }

        public string ExCode
        {
            get { return fExCode; }
            set { fExCode = value; }
        }

        public ushort Flags
        {
            get { return fFlags; }
            set { fFlags = value; }
        }

        public sbyte Mode
        {
            get { return fMode; }
            set { fMode = value; }
        }

        public uint Order
        {
            get { return fOrder; }
            set { fOrder = value; }
        }

        public uint Split
        {
            get { return fSplit; }
            set { fSplit = value; }
        }

        public uint SplitCheckSum
        {
            get { return fSplitCheckSum; }
            set { fSplitCheckSum = value; }
        }

        public uint SplitTotal
        {
            get { return fSplitTotal; }
            set { fSplitTotal = value; }
        }

        public string StartChar
        {
            get { return fStartChar; }
            set { fStartChar = value; }
        }

        public uint Total
        {
            get { return fTotal; }
            set { fTotal = value; }
        }

        public string Version
        {
            get { return fVersion; }
            set { fVersion = value;  }
        }

        #endregion
    }

}