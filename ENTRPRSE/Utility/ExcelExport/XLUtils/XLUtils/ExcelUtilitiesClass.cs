using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using Microsoft.Office.Interop.Excel;
using System.Globalization;

namespace Exchequer
{

    [Guid("3BB9C24D-6ACC-4FF9-9D89-480886FB5EF2")]
    public interface IExchequerExcelUtilities
    {
        string Version { get; }

        bool ExcelAPIAvailable { get; }

        // Connects to an existing or new instance of Excel
        bool ConnectToExcel();

        // Creates a new worksheet and sets the worksheet title
        void CreateWorksheet(string WorksheetTitle);
        
        // Called to add a column title into the worksheet
        void AddColumnTitle(string ColumnTitle, string MetaData);

        // Called to populate the current row cell in the worksheet
        void AddColumnData(string ColumnData, string MetaData);
        void AddColumnDataNumber(string Number, string NumberFormat, string MetaData);

        // Called to move to the next row
        void NewRow();

        // Shutdown the link to Excel
        void DisconnectFromExcel();
    }


    [Guid("62290D17-E73A-42DA-98FD-3A8107B878AD"), ClassInterface(ClassInterfaceType.None)]
    public class ExcelUtilities : IExchequerExcelUtilities
    {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool SetForegroundWindow(IntPtr hWnd);

        
        private Microsoft.Office.Interop.Excel.Application oExcelApp = null;
        private Microsoft.Office.Interop.Excel.Workbook oExcelWorkBook = null;
        private Microsoft.Office.Interop.Excel.Worksheet oExcelWorkSheet = null;

        private int iCurrentCellCol = 1;
        private int iCurrentCellRow = 1;
        private string sFirstCell = "";
        private string sLastCell = "";


        public string Version
        {
            get
            {
                return "11.0.001";
            }
        }


        // Tries to create an instance of the Excel API and returns True if successful
        public bool ExcelAPIAvailable
        {
            get
            {
                bool CheckResult;

                try
                {
                    Microsoft.Office.Interop.Excel.Application oExcelApp = new Microsoft.Office.Interop.Excel.Application();
                    CheckResult = true;
                }
                catch (Exception)
                {
                    CheckResult = false;
                }
                return CheckResult;
            }
        }


        // Connects to an existing or new instance of Excel
        public bool ConnectToExcel()
        {
            bool GotExcelRef = false;

            // Try to connect to an existing instance of Excel, if that fails then create a new instance 
            try
            {
                // Try to get a handle to an existing Excel instance - crashes and burns if it doesn't exist
                oExcelApp = (Microsoft.Office.Interop.Excel.Application)Marshal.GetActiveObject("Excel.Application");
                GotExcelRef = true;
            }
            catch (Exception)
            {
                GotExcelRef = false;
            }

            if (GotExcelRef == false)
            {
                // Failed to connect to an existing instance, so create a new one
                try
                {
                    oExcelApp = new Microsoft.Office.Interop.Excel.Application();
                    GotExcelRef = true;
                }
                catch (Exception)
                {
                    GotExcelRef = false;
                }
            }
            
            return GotExcelRef;
        }


        // Creates a new worksheet and sets the worksheet title
        public void CreateWorksheet (string WorksheetTitle)
        {
            // Check to see if there is already a Workbook open, if not we need to create one
            if (oExcelApp.ActiveWorkbook != null)
            {
                oExcelWorkBook = oExcelApp.ActiveWorkbook; 

                // Always create a new worksheet in an existing Workbook - don't want to overwrite anything the user may have added
                oExcelWorkSheet = oExcelWorkBook.Worksheets.Add();
            }
            else
            {
                oExcelWorkBook = oExcelApp.Workbooks.Add();

                // Use the default worksheet created for a new workbook
                oExcelWorkSheet = oExcelWorkBook.ActiveSheet;
            }
                       
            // Generate unique name
            oExcelWorkSheet.Name = GenerateUniqueName(WorksheetTitle);

            // Start writing in the top-left cell
            iCurrentCellCol = 1;
            iCurrentCellRow = 1;
            sFirstCell = oExcelWorkSheet.Cells[iCurrentCellRow, iCurrentCellCol].Address;
        }


        // Called to add a column title into the worksheet
        public void AddColumnTitle(string ColumnTitle, string MetaData)
        {
            //
            // Note: At this time there hasn't needed to be any column level formatting requiring analysis of the MetaData
            //

            Microsoft.Office.Interop.Excel.Range oCurrentCell = oExcelWorkSheet.Cells[iCurrentCellRow, iCurrentCellCol++];

            // Check the ColumnTitle is populated - empty columns come in as null strings and can cause crashes 
            if (ColumnTitle != null)
            {
                oCurrentCell.Value = ColumnTitle;
            }

            if ((MetaData != null) && (MetaData.Contains("<CURRENCYAMOUNT>") || 
                                       MetaData.Contains("<NONCURRENCYAMOUNT>") ||
                                       MetaData.Contains("<QUANTITY>") ||
                                       MetaData.Contains("<DATE>") ||
                                       MetaData.Contains("<ALIGNRIGHT>")))
            {
                oCurrentCell.HorizontalAlignment = Microsoft.Office.Interop.Excel.XlHAlign.xlHAlignRight;
            }
        }

        public void AddColumnDataNumber(string Number, string NumberFormat, string MetaData)
        {
            // Get a reference to the current cell and move the pointer to the next cell
            Microsoft.Office.Interop.Excel.Range oCurrentCell = oExcelWorkSheet.Cells[iCurrentCellRow, iCurrentCellCol++];

            // Check the ColumnData is populated - empty columns come in as null strings and can cause crashes
            if (Number != null)
            {
                oCurrentCell.Style = "Currency";
                oCurrentCell.NumberFormat = NumberFormat;
                oCurrentCell.Value = Number;
            }

            // Look at the MetaData to determine any special handling requirements
            ApplyCommonMetadata(oCurrentCell, MetaData);
        }

        // Called to populate the current row cell in the worksheet
        public void AddColumnData(string ColumnData, string MetaData)
        {
            // Get a reference to the current cell and move the pointer to the next cell
            Microsoft.Office.Interop.Excel.Range oCurrentCell = oExcelWorkSheet.Cells[iCurrentCellRow, iCurrentCellCol++];

            // Check the ColumnData is populated - empty columns come in as null strings and can cause crashes
            if (ColumnData != null)
            {
                // Look at the MetaData to determine any special handling requirements
                if ((MetaData != null) && (MetaData.Contains("<FORCETEXT>") || MetaData.Contains("<PERIOD>")))
                {
                    // Can't do everything like this as Excel doesn't recognize numerical fields as numbers, so things like SUM don't work
                    oCurrentCell.Formula = "=\"" + ColumnData + "\"";
                }
                
                else if ((MetaData != null) && MetaData.Contains("<DATE>"))
                {
                    // Check it is a valid date string - Exchequer can output dates as dd/mm/yyyy if they haven't been set yet
                    string sNumberChars = "0123456789";
                    if (sNumberChars.Contains(ColumnData.Substring(0, 1)))
                    {
                        // Force the date format to ShortDateFormat
                        oCurrentCell.NumberFormat = System.Globalization.DateTimeFormatInfo.CurrentInfo.ShortDatePattern;
                        //oCurrentCell.NumberFormatLocal = "dd-mm-yyyy";

                        // Exchequer supplies the date in US Format 
                        oCurrentCell.Value = ColumnData;
                    }
                }

                // Moved into Delphi in the TExportBtrieveListDataToExcel class as more information is available for formatting, e.g. Quantity Decimal Places 
                // and replaced by AddColumnDataNumber above
                //else if ((MetaData != null) && (MetaData.Contains("<CURRENCYAMOUNT>") || MetaData.Contains("<NONCURRENCYAMOUNT>")))
                //{
                //    // Separate Currency and Number elements, examples of incoming ColumnData:-
                //    //
                //    //   £12,006.86
                //    //   £240.00-
                //    //   NZD261.00
                //    //   €704.20

                //    // Run through the incoming string and split it into Currency Symbol, Number and Negative Y/N elements
                //    string CurrencySymbol = "";
                //    string NumberElement = "";
                //    bool Negative = false;

                //    string NumberCharacters = "0123456789";
                //    bool FoundNumber = false;
                //    foreach (char Letter in ColumnData)
                //    {
                //        // Once we have found a numerical character we will assume we are past the currency symbol
                //        if (!FoundNumber)
                //        {
                //            FoundNumber = NumberCharacters.Contains(Letter);
                //        }

                //        if (!FoundNumber)
                //        {
                //            CurrencySymbol += Letter;
                //        }
                //        else if (Letter == '-')
                //        {
                //            Negative = true;
                //        }
                //        else
                //        {
                //            NumberElement += Letter;
                //        }
                //    }
                //    //MessageBox.Show("CurrencySymbol=" + CurrencySymbol + Environment.NewLine +
                //    //                "NumberElement=" + NumberElement + Environment.NewLine +
                //    //                "Negative=" + Negative.ToString());

                //    // Excel requires the negative sign to be at the start of the number 
                //    if (Negative)
                //    {
                //        NumberElement = "-" + NumberElement;
                //    }

                //    oCurrentCell.Style = "Currency";
                //    oCurrentCell.NumberFormat = "\"" + CurrencySymbol + "\"#,##0.00";
                //    oCurrentCell.Value = NumberElement;
                //}
                else
                {
                    oCurrentCell.Value = ColumnData;
                }
            }

            // Look at the MetaData to determine any special handling requirements
            ApplyCommonMetadata(oCurrentCell, MetaData);
        }

        public void ApplyCommonMetadata (Microsoft.Office.Interop.Excel.Range TheCell, string MetaData)
        {
            // Look at the MetaData to determine any special handling requirements
            if ((MetaData != null) && MetaData.Contains("<ALIGNRIGHT>"))
            {
                TheCell.HorizontalAlignment = Microsoft.Office.Interop.Excel.XlHAlign.xlHAlignRight;
            }
            // MH 16/05/18 ABSEXCH-20519: Coded row emphasis as had to change the row export code to call the functions anyway
            if ((MetaData != null) && MetaData.Contains("<BOLD>"))
            {
                TheCell.Font.Bold = true;
            }
            if ((MetaData != null) && MetaData.Contains("<ITALIC>"))
            {
                TheCell.Font.Italic = true;
            }
            if ((MetaData != null) && MetaData.Contains("<UNDERLINE>"))
            {
                TheCell.Font.Underline = true;
            }
        }


        // Called to move to the next row
        public void NewRow()
        {
            // Record the address of the last cell (bottom-right) written to
            sLastCell = oExcelWorkSheet.Cells[iCurrentCellRow, iCurrentCellCol].Address;

            // Move to first column in next row
            iCurrentCellCol = 1;
            iCurrentCellRow++;
        }
        

        // Shutdown the link to Excel
        public void DisconnectFromExcel()
        {
            // Auto-Size the columnns so all the data is visible
            oExcelWorkSheet.Range[sFirstCell, sLastCell].EntireColumn.AutoFit();

            // Force Excel to be visible - if newly created it seems to be hidden
            oExcelApp.Visible = true;
            
            // Make Excel the foreground window 
            IntPtr IP = new IntPtr(oExcelApp.Hwnd);
            SetForegroundWindow(IP);

            // Shutdown all the Excel references
            oExcelWorkSheet = null;
            oExcelWorkBook = null;
            oExcelApp = null;
        }


        // Generate a unique name for the new worksheet based on the requested title, if a matching name
        // already exists then add a (2), (3), etc... until uniqueness is achieved
        private string GenerateUniqueName(string RequestedTitle)
        {
            // Filter out any banned characters from the requested worksheet title
            string BannedCharacters = @"\/*?:[]";     // Use the @ to allow the \ to be put in the string 
            string ModifiedTitle = "";
            for (int i = 0; i < RequestedTitle.Length; i++)
			{
                if (BannedCharacters.Contains(RequestedTitle[i]) == false)
                {
                    ModifiedTitle += RequestedTitle[i];
                }
			}


            // Check we have something left after filtering out the banned characters
            if (ModifiedTitle.Length == 0)
            {
                ModifiedTitle = "Exchequer Export";
            }
            // Worksheet names have a maximum length of 31 characters
            else if (ModifiedTitle.Length > 31)
            {
                ModifiedTitle = ModifiedTitle.Remove(31);
            }


            string SuggestedTitle = ModifiedTitle;
            string UniqueSuffix;
            int Count = 2;

            while (WorksheetTitleExists(SuggestedTitle))
            {
                // Worksheet names have a maximum length of 31 characters
                UniqueSuffix = '(' + Count++.ToString() + ')';
                if ((ModifiedTitle.Length + UniqueSuffix.Length) > 31)
                {
                    // Need to trim the requested title back to make space for the suffix
                    SuggestedTitle = ModifiedTitle.Substring(0, (31 - UniqueSuffix.Length)) + UniqueSuffix;
                }
                else
                {
                    SuggestedTitle = ModifiedTitle + UniqueSuffix;
                }               
            }

            return SuggestedTitle;
        }


        // Look in the Worksheets array to see if a worksheet already exists with the specified title
        private bool WorksheetTitleExists (string SearchTitle)
        {
            bool Found = false;

            foreach (Microsoft.Office.Interop.Excel.Worksheet oWorksheet in oExcelWorkBook.Worksheets)
            {
                if (SearchTitle.ToUpper()==oWorksheet.Name.ToUpper())
                {
                    Found = true;
                    break;
                }
            }

            return Found;
        }
        
    }
}
