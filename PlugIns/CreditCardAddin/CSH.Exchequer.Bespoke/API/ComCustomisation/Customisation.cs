using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using Enterprise04;
using Enterprise;
using CSH.Exchequer.Bespoke.UI;
using CSH.Exchequer.Bespoke.Exceptions;

namespace CSH.Exchequer.Bespoke.API.ComCustomisation
{
    /// <summary>
    /// Helper wrapper for the COMCustomisation class
    /// </summary>
    public class Customisation
    {
        /// <summary>
        /// Friendly names for the Exchequer customisation event hooks
        /// </summary>
        public enum Hooks
        {
            /// <summary>
            /// 
            /// </summary>
            BeforeStoreTransaction = 1,
            /// <summary>
            /// 
            /// </summary>
            AfterStoreTransaction = 170,
            /// <summary>
            /// 
            /// </summary>
            BeforeStoreLine = 10,
            /// <summary>
            /// 
            /// </summary>
            AfterStoreLine = 14,
            /// <summary>
            /// 
            /// </summary>
            BeforeDeleteLine = 80,
            /// <summary>
            /// 
            /// </summary>
            AfterDeleteLine = 81,
            /// <summary>
            /// 
            /// </summary>
            BeforeStoreAccount = 2,
            /// <summary>
            /// 
            /// </summary>
            AfterStoreAccount = 3,
            /// <summary>
            /// 
            /// </summary>
            BeforeSaveStock = 2,
            /// <summary>
            /// 
            /// </summary>
            OpenInitialCompany = 10,
            /// <summary>
            /// 
            /// </summary>
            OpenCompany = 9,
            /// <summary>
            /// 
            /// </summary>
            CloseCompany = 8,
            /// <summary>
            /// 
            /// </summary>
            ValidateStock = 40,
            /// <summary>
            /// 
            /// </summary>
            EnterLineQtySetQty = 1,
            /// <summary>
            /// 
            /// </summary>
            ExitStockCode = 11,
            /// <summary>
            /// 
            /// </summary>
            SetStockCode = 15,
            /// <summary>
            /// 
            /// </summary>
            ValidateLineGeneral = 18,
            /// <summary>
            /// 
            /// </summary>
            ValidateLineNOM = 19,
            /// <summary>
            /// 
            /// </summary>
            ValidateLineADJorSRNorPRN = 20,
            /// <summary>
            /// 
            /// </summary>
            ValidateLineTelesales = 21,
            /// <summary>
            /// 
            /// </summary>
            ValidateLineBatch = 22,
            /// <summary>
            /// 
            /// </summary>
            ValidateLineTSH = 23,
            /// <summary>
            /// 
            /// </summary>
            ValidateLineGeneralPayment = 24,
            /// <summary>
            /// 
            /// </summary>
            LineDialogDisplayed = 8,
            /// <summary>
            /// 
            /// </summary>
            LineDialogClosed = 7,
            /// <summary>
            /// 
            /// </summary>
            ValidateTransaction = 82,
            /// <summary>
            /// 
            /// </summary>
            CopyTagFromXorToXdn = 107,
            /// <summary>
            /// 
            /// </summary>
            CopyTagFromXdnToXin = 108,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookMainCustomButton1 = 10,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookMainCustomButton2 = 20,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookQuotesCustomButton1 = 11,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookQuotesCustomButton2 = 21,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookAutoCustomButton1 = 12,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookAutoCustomButton2 = 22,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookHistoryCustomButton1 = 13,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookHistoryCustomButton2 = 23,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookOrdersCustomButton1 = 14,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookOrdersCustomButton2 = 24,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookOrderHistoryCustomButton1 = 15,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookOrderHistoryCustomButton2 = 25,
            /// <summary>
            /// 
            /// </summary>
            CustomerListCustomButton1 = 11,
            /// <summary>
            /// 
            /// </summary>
            CustomerListCustomButton2 = 12,
            /// <summary>
            /// 
            /// </summary>
            SupplierListCustomButton1 = 21,
            /// <summary>
            /// 
            /// </summary>
            SupplierListCustomButton2 = 22
        }

        /// <summary>
        /// Friendly names for the Exchequer customisation custom button labels
        /// </summary>
        public enum LabelButtons
        {
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookMainCustomButton1 = 10,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookMainCustomButton2 = 20,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookQuotesCustomButton1 = 11,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookQuotesCustomButton2 = 21,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookAutoCustomButton1 = 12,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookAutoCustomButton2 = 22,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookHistoryCustomButton1 = 13,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookHistoryCustomButton2 = 23,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookOrdersCustomButton1 = 14,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookOrdersCustomButton2 = 24,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookOrderHistoryCustomButton1 = 15,
            /// <summary>
            /// 
            /// </summary>
            SalesDaybookOrderHistoryCustomButton2 = 25,
            /// <summary>
            /// 
            /// </summary>
            CustomerListCustomButton1 = 1,
            /// <summary>
            /// 
            /// </summary>
            CustomerListCustomButton2 = 2,
            /// <summary>
            /// 
            /// </summary>
            SupplierListCustomButton1 = 3,
            /// <summary>
            /// 
            /// </summary>
            SupplierListCustomButton2 = 4
        }

        /// <summary>
        /// wiCompany
        /// </summary>
        public const int wiCompany = (int)(TWindowId.wiMisc + 2);

        /// <summary>
        /// Gets the instance.
        /// </summary>
        public COMCustomisation Instance { get; private set; }

        /// <summary>
        /// Gets the exchequer window.
        /// </summary>
        public WindowWrapper ExchequerWindow
        {
            get
            {
                IntPtr exchequerWindowPointer = new IntPtr(this.Instance.SysFunc.hWnd);
                return new WindowWrapper(exchequerWindowPointer);
            }
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Customisation"/> class.
        /// </summary>
        public Customisation()
        {
            try
            {
                // Try to connect to an already running instance of the IRIS Exchequer Customisation object 
                this.Instance = (COMCustomisation)Marshal.GetActiveObject("Enterprise.ComCustomisation");
            }
            catch (COMException)
            {
                try
                {
                    // Create a new instance of the IRIS Exchequer Customisation object 
                    this.Instance = new COMCustomisation();
                }
                catch(COMException ex)
                {
                    throw new BespokeLibraryException("Unable to retrieve an instance of the COM Customisation", ex);
                }

            }
        }

        /// <summary>
        /// Adds the about strings.
        /// </summary>
        /// <param name="aboutStrings">The about strings.</param>
        public void AddAboutStrings(List<string> aboutStrings)
        {
            foreach (string Line in aboutStrings)
            {
                this.Instance.AddAboutString(Line);
            }
        }

        /// <summary>
        /// Determines whether record is accessible.
        /// </summary>
        /// <param name="access">The access.</param>
        /// <returns>
        ///   <c>true</c> if [is record accessible] [the specified access]; otherwise, <c>false</c>.
        /// </returns>
        public bool IsRecordAccessible(TRecordAccessStatus access)
        {
            return (access == TRecordAccessStatus.arReadOnly) || (access == TRecordAccessStatus.arReadWrite);
        }
    }
}
