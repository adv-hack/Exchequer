using System;
using System.Collections.Generic;
using System.Threading;
using System.Windows.Forms;
using System.Xml;
using DotNetLibrariesC.Toolkit;
using Enterprise04;
using EnterpriseBeta;
using Exchequer.Payments.Portal.COM.Client.PaymentServices;
using ExchequerPaymentGateway;

namespace PaymentGatewayAddin
  {
  /// <summary>
  /// Basic transaction class used for disaster recovery
  /// </summary>
  public class DataRestorer : IDisposable
    {
    public const int XML_EXTRACT_SUCCESS = 0;
    public const int XML_EXTRACT_ERROR = 1;
    public const int XML_EXTRACT_NULL = 2;


    public const String ttPayment = "PAYMENT";
    // PKR. 04/03/2015. ABSEXCH-16223. Added missing transaction type. 
    //HV 15/02/2017 2017-R1  ABSEXCH-18219 - Worldpay transactions are not recreated when DB restore.
    // public const String ttPartPayment = "PARTPAYMENT";
    public const String ttRefund = "REFUND";
    public const String ttPaymentAuthorisation = "AUTHORISE";

    public const int SUCCESS = 0;
    public const int WARNING_RECEIPT_ALREADY_EXISTS = 1;
    public const int WARNING_TRANSACTION_REF_DOES_NOT_EXIST = 2;
    public const int WARNING_TRANSACTION_DERIVES_FROM_DIFFERENT_ORDER = 3;
    public const int WARNING_RECEIPT_CREATED_AGAINST_RECREATED_ORDER = 4;

    public const int ERROR_CURRENCY_MISMATCH = 11;
    public const int ERROR_LINE_DETAIL_MISMATCH = 12;
    public const int ERROR_PAYMENT_EXCEEDS_ORDER_VALUE = 13;
    public const int ERROR_INVALID_ACCOUNT_CODE = 14;
    public const int ERROR_ACCOUNT_CODE_MISMATCH = 15;
    public const int ERROR_PAYMENT_IS_NOT_FOR_SPECIFIED_ORDER = 16;
    public const int ERROR_TRANSACTION_LINE_NOT_FOUND = 17;

    private SiteConfig config;
    private string fCompanyCode;
    private MCMCompany currentCompany = null;
    private string userId;

    public bool IsError { get; set; }

    private string fLastErrorString;

    private RecoveryCustomDataTransaction customData;
    private RestoreLog errorLog;

    private int defaultGLCode;
    private string defaultCostCentre;
    private string defaultDepartment;

    // Local reference to the toolkit
    private IToolkit3 tToolkit = null;

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Constructor
    /// </summary>
    /// <param name="aToolkit">A COM Toolkit reference</param>
    /// <param name="aConfig">The add-in configuration</param>
    public DataRestorer(IToolkit3 aToolkit, SiteConfig aConfig, string aUserId, RestoreLog aErrLog)
      {
      tToolkit = aToolkit;

      if (aConfig == null)
        {
        SetLastErrorString("Data Recovery Error : Configuration not assigned.");
        }
      else
        {
        config = aConfig;
        }

      userId = aUserId;

      errorLog = aErrLog;

      customData = new RecoveryCustomDataTransaction();
      }

    //=============================================================================================
    // Implementation of IDisposable
    //=============================================================================================

    private bool disposed = false;

    // Public implementation of Dispose pattern callable by consumers.
    public void Dispose()
      {
      Dispose(true);
      GC.SuppressFinalize(this);
      }


    protected virtual void Dispose(bool disposing)
      {
      // This allows multiple calls
      if (disposed)
        {
        return;
        }

      if (disposing)
        {
        // Free all managed objects here.
        //
        customData.Dispose();
        customData = null;
        }

      // Free unmanaged objects here

      // This allows multiple calls
      disposed = true;
      }


    /// <summary>
    /// Finalizer
    /// </summary>
    ~DataRestorer()
      {
      Dispose(false);
      }

    //=============================================================================================

    public void SetDefaults(int aGLCode, string aCostCentre, string aDepartment)
      {
      defaultGLCode = aGLCode;
      defaultCostCentre = aCostCentre;
      defaultDepartment = aDepartment;
      }

    //---------------------------------------------------------------------------------------------
    public string GetRestoreLogFilename()
      {
      return errorLog.GetLogFilename();
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Sets the last error string
    /// </summary>
    /// <param name="aError"></param>
    public void SetLastErrorString(string aError)
      {
      fLastErrorString = aError;
      IsError = (!string.IsNullOrEmpty(aError));
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Returns the last error logged
    /// </summary>
    /// <returns></returns>
    public string LastErrorString()
      {
      string error = fLastErrorString;
      fLastErrorString = string.Empty;
      IsError = false;
      return error;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Configure for the specified company
    /// </summary>
    /// <param name="aCompanyCode"></param>
    public void SetCompanyCode(string aCompanyCode)
      {
      fCompanyCode = aCompanyCode.ToUpper();

      if ((config != null) && (config.MCMCompanyList != null))
        {
        foreach (MCMCompany mcmCompany in config.MCMCompanyList)
          {
          if (mcmCompany.code.ToUpper() == fCompanyCode)
            {
            currentCompany = mcmCompany;
            break;
            }
          }

        // If we have a company, open the toolkit and get various settings
        if (currentCompany != null)
          {
          ReopenToolkit(currentCompany);
          }
        }
      else
        {
        SetLastErrorString("SetCompanyCode : Configuration missing or invalid");
        }
      }

    //=============================================================================================
    /// <summary>
    /// Restore the transaction recovered from the Exchequer Payment Portal.
    /// </summary>
    /// <param name="aTransaction">The transaction details from the Payment Portal</param>
    /// <returns>Success/Error code</returns>
    /// <remarks>Abandon hope all ye who enter here</remarks>
    public int RestoreTransaction(GatewayTransactionView aTransaction, bool aWantRestoreSORs)
      // ABSEXCH-16255. Added aWantRestoreSORs flag.
      {
      #region debugstuff0
#if TDEBUG
      if (PaymentGateway.dbgForm != null)
        {
        PaymentGateway.dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      #endregion debugstuff0
      int Result = 0;

      long Res; // Return value when accessing the database via the COM Toolkit

      string theSOROurRef;

      ITransaction12 cloneSOR;

      #region debugStuff1
#if DEBUG
      // Show the content of the transaction we're trying to restore
      PaymentGateway.dbgForm.Log("\r\n==================================================================");
      PaymentGateway.dbgForm.Log("Restore transaction: ");

      PaymentGateway.dbgForm.Log(string.Format("  Created              : {0}", aTransaction.CreatedDateTime));
      PaymentGateway.dbgForm.Log(string.Format("  Description          : {0}", aTransaction.Description));
      PaymentGateway.dbgForm.Log(string.Format("  Account Ref          : {0}", aTransaction.ExternalAccountReference));
      PaymentGateway.dbgForm.Log(string.Format("  Receipt Ref          : {0}", aTransaction.ExternalReceiptReference));
      PaymentGateway.dbgForm.Log(string.Format("  Our Ref              : {0}", aTransaction.ExternalReference));
      PaymentGateway.dbgForm.Log(string.Format("  Status ID            : {0}", aTransaction.GatewayStatusId));
      PaymentGateway.dbgForm.Log(string.Format("  Currency             : {0}", aTransaction.GatewayTransactionCurrency));
      PaymentGateway.dbgForm.Log(string.Format("  Gross Amt            : {0}", aTransaction.GatewayTransactionGrossAmount));
      PaymentGateway.dbgForm.Log(string.Format("  Trans ID             : {0}", aTransaction.GatewayTransactionId));
      PaymentGateway.dbgForm.Log(string.Format("  Trans Type           : {0}", aTransaction.GatewayTransactionTypeId));
      PaymentGateway.dbgForm.Log(string.Format("  User Company         : {0}", aTransaction.GatewayUserCompanyId));
      PaymentGateway.dbgForm.Log(string.Format("  Merchant Account ID  : {0}", aTransaction.GatewayUserCompanyMerchantAccountId));
      PaymentGateway.dbgForm.Log(string.Format("  Payment Provider ID  : {0}", aTransaction.GatewayUserCompanyPaymentProviderId));
      PaymentGateway.dbgForm.Log(string.Format("  Vendor ATS data      : {0}", aTransaction.GatewayVendorAtsData));
      PaymentGateway.dbgForm.Log(string.Format("  Card expiry          : {0}", aTransaction.GatewayVendorCardExpiryDate));
      PaymentGateway.dbgForm.Log(string.Format("  Card 4 digits        : {0}", aTransaction.GatewayVendorCardLast4Digits));
      PaymentGateway.dbgForm.Log(string.Format("  Card type            : {0}", aTransaction.GatewayVendorCardType));
      PaymentGateway.dbgForm.Log(string.Format("  Security key         : {0}", aTransaction.GatewayVendorSecurityKey));
      PaymentGateway.dbgForm.Log(string.Format("  Tx Auth no.          : {0}", aTransaction.GatewayVendorTxAuthNo));
      PaymentGateway.dbgForm.Log(string.Format("  Tx code              : {0}", aTransaction.GatewayVendorTxCode));
      PaymentGateway.dbgForm.Log(string.Format("  VPS Tx ID            : {0}", aTransaction.GatewayVendorVPSTxId));
      PaymentGateway.dbgForm.Log(string.Format("  isError              : {0}", aTransaction.IsError));
      PaymentGateway.dbgForm.Log(string.Format("  Service name         : {0}", aTransaction.ServiceName));
      PaymentGateway.dbgForm.Log(string.Format("  Service response     : {0}", aTransaction.ServiceResponse));
      PaymentGateway.dbgForm.Log(string.Format("  Type name            : {0}", aTransaction.TypeName));
      PaymentGateway.dbgForm.Log(string.Format("  Vendor type name     : {0}", aTransaction.VendorTypeName));

      // Put it in the log as well, for convenience.
      errorLog.Log(RestoreLog.severities.sevDebug, "\r\n==================================================================");
      errorLog.Log(RestoreLog.severities.sevDebug, "Restore transaction: ");
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Created              : {0}", aTransaction.CreatedDateTime));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Description          : {0}", aTransaction.Description));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Account Ref          : {0}", aTransaction.ExternalAccountReference));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Receipt Ref          : {0}", aTransaction.ExternalReceiptReference));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Our Ref              : {0}", aTransaction.ExternalReference));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Status ID            : {0}", aTransaction.GatewayStatusId));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Currency             : {0}", aTransaction.GatewayTransactionCurrency));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Gross Amt            : {0}", aTransaction.GatewayTransactionGrossAmount));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Trans ID             : {0}", aTransaction.GatewayTransactionId));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Trans Type           : {0}", aTransaction.GatewayTransactionTypeId));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  User Company         : {0}", aTransaction.GatewayUserCompanyId));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Merchant Account ID  : {0}", aTransaction.GatewayUserCompanyMerchantAccountId));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Payment Provider ID  : {0}", aTransaction.GatewayUserCompanyPaymentProviderId));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Vendor ATS data      : {0}", aTransaction.GatewayVendorAtsData));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Card expiry          : {0}", aTransaction.GatewayVendorCardExpiryDate));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Card 4 digits        : {0}", aTransaction.GatewayVendorCardLast4Digits));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Card type            : {0}", aTransaction.GatewayVendorCardType));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Security key         : {0}", aTransaction.GatewayVendorSecurityKey));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Tx Auth no.          : {0}", aTransaction.GatewayVendorTxAuthNo));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Tx code              : {0}", aTransaction.GatewayVendorTxCode));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  VPS Tx ID            : {0}", aTransaction.GatewayVendorVPSTxId));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  isError              : {0}", aTransaction.IsError));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Service name         : {0}", aTransaction.ServiceName));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Service response     : {0}", aTransaction.ServiceResponse));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Type name            : {0}", aTransaction.TypeName));
      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Vendor type name     : {0}", aTransaction.VendorTypeName));
#endif
      #endregion debugStuff1

      // Message that will be output to the log.
      string logMsg = string.Empty;

      int customRes = XML_EXTRACT_SUCCESS;

      try
        {
        // The basic transaction header and line details are in XML format in the CustomData property
        customRes = customData.ExtractCustomData(aTransaction.CustomData);

        switch (customRes)
          {
          case XML_EXTRACT_SUCCESS:
              {
              #region debugStuff2
#if DEBUG
              // Extra logging added to debug the part payment issue in ABSEXCH-16255
              errorLog.Log(RestoreLog.severities.sevDebug, "CustomData extracted ok");
              errorLog.Log(RestoreLog.severities.sevDebug, "Start restore of " + aTransaction.ExternalReceiptReference);

              // Custom data...
              PaymentGateway.dbgForm.Log("  Custom data :");
              PaymentGateway.dbgForm.Log(string.Format("    TransRef={0}, Period={1}, Year={2}, GLCode={3}, CC={4}, DP={5}, PayRef={6}",
                                                       customData.TransRef, customData.Period, customData.Year, customData.GLCode, customData.CC, customData.DP, customData.PayRef));
              errorLog.Log(RestoreLog.severities.sevDebug, string.Format("    TransRef={0}, Period={1}, Year={2}, GLCode={3}, CC={4}, DP={5}, PayRef={6}",
                                                       customData.TransRef, customData.Period, customData.Year, customData.GLCode, customData.CC, customData.DP, customData.PayRef));

              foreach (RecoveryCustomDataLine line in customData.lines)
                {
                PaymentGateway.dbgForm.Log(string.Format("      ABSNo={0} Stk={1} Desc={2} Loc={3} VATCode={4} Goods={5} VAT={6}",
                                                       line.ABSNo, line.Stk, line.Description, line.Loc, line.VATCode, line.Goods, line.VAT));

                errorLog.Log(RestoreLog.severities.sevDebug, string.Format("ABSNo={0} Stk={1} Desc={2} Loc={3} VATCode={4} Goods={5} VAT={6}",
                                                    line.ABSNo, line.Stk, line.Description, line.Loc, line.VATCode, line.Goods, line.VAT));
                }
              PaymentGateway.dbgForm.Log("-------------------------------------------------------\r\n");

              errorLog.Log(RestoreLog.severities.sevDebug, "\r\nValidating data");
#endif
              #endregion debugstuff2

              // Validate the transaction data
              // P1, R1
              // Validate the supplied Account Code and check that Order Payments are turned on for the account.
              //  If it is invalid then log the payment details as an error and move onto the next payment.
              errorLog.Log(RestoreLog.severities.sevDebug, "  Account Code " + aTransaction.ExternalAccountReference);

              if (!string.IsNullOrEmpty(aTransaction.ExternalAccountReference))
                {
                if (!IsValidAccountCode(aTransaction.ExternalAccountReference))
                  {
                  // Account code is either invalid, or doesn't have OP enabled
                  logMsg = string.Format("{0} is against invalid account code {1}",
                           string.IsNullOrEmpty(aTransaction.ExternalReference) ? "" : aTransaction.ExternalReference,
                           string.IsNullOrEmpty(aTransaction.ExternalAccountReference) ? "" : aTransaction.ExternalAccountReference);
                  string moreDetail = LastErrorString();
                  if (!string.IsNullOrEmpty(moreDetail))
                    {
                    logMsg += "\r\n" + moreDetail;
                    }
                  errorLog.Log(RestoreLog.severities.sevWarning, logMsg);
                  Result = ERROR_INVALID_ACCOUNT_CODE;
                  #region debugstuff3
#if TDEBUG
                  if (PaymentGateway.dbgForm != null)
                    {
                    PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                    }
#endif
                  #endregion debugstuff3
                  return Result;
                  }
                #region debugstuff4
#if DEBUG
                errorLog.Log(RestoreLog.severities.sevDebug, "  Account Code OK");
                errorLog.Log(RestoreLog.severities.sevDebug, "  Looking for transaction " + aTransaction.ExternalReceiptReference);
#endif
                #endregion debugstuff4
                // P2, R2
                // Check whether the SRC OurRef already exists, if it does then we will assume the Date/Time
                //  range was incorrect and log the payment details as a warning and move onto the next payment.
                // PKR. 09/03/2015. ABSEXCH-16255. Corrected transaction reference to SRC (was SOR).
                if (ExchequerTransactionExists(aTransaction.ExternalReceiptReference))
                  {
                  // SRC exists, so log a warning
                  logMsg = string.Format("{0}. SRC {1} already exists.", aTransaction.ExternalReference, aTransaction.ExternalReceiptReference);
                  errorLog.Log(RestoreLog.severities.sevWarning, logMsg);
                  Result = WARNING_RECEIPT_ALREADY_EXISTS;
                  #region debugstuff5
#if TDEBUG
                  if (PaymentGateway.dbgForm != null)
                    {
                    PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                    }
#endif
                  #endregion
                  return Result;
                  }
                #region debugstuff6
#if DEBUG
                errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Transaction {0} not found - can recreate", aTransaction.ExternalReceiptReference));
#endif
                #endregion
                // P3, R3
                // Validate the supplied GL Code, if it doesn’t exist or isn’t a valid Order Payments GL Code
                //  or isn’t compatible with the supplier Transaction Currency then log a warning and use the
                //  Default GL Code entered by the user.
                if (!IsValidGLCode(customData.GLCode))
                  {
                  // PKR. 26/02/2015. ABSEXCH-16233. Part Payments not being recreated.
                  // This was partly due to an invalid GL Code, which caused this code to execute.
                  // Fixed parameter list in the errorLog call.
                  errorLog.Log(RestoreLog.severities.sevWarning, string.Format("{0}. Invalid GL Code: {1}. Using default: {2}",
                                                                 aTransaction.ExternalReference,
                                                                 customData.GLCode,
                                                                 defaultGLCode));
                  // We want to continue with the default
                  customData.GLCode = defaultGLCode;
                  }
                #region debugstuff7
#if DEBUG
                else
                  {
                  errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  GL Code {0} OK", customData.GLCode));
                  }
#endif
                #endregion debugstuff7
                if (tToolkit.SystemSetup.ssUseCCDept)
                  {
                  // P4, R4
                  // If Cost Centres are enabled then validate the supplied Cost Centre, if it doesn’t exist
                  //  or is inactive then log a warning and use the Default Cost Centre Code entered by the user.
                  if (!IsValidCostCentre(customData.CC))
                    {
                    // Not a valid cost-centre, so use the user-specified default
                    errorLog.Log(RestoreLog.severities.sevWarning, string.Format("{0}. Invalid Cost Centre: {1}. Using default: {2}",
                                                                   aTransaction.ExternalReference,
                                                                   customData.CC,
                                                                   defaultCostCentre));
                    customData.CC = defaultCostCentre;
                    }
                  #region debugValidateCC
#if DEBUG
                  else
                    {
                    errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Cost Centre {0} OK", customData.CC));
                    }
#endif
                  #endregion debugValidateCC
                  // P5, R5
                  // If Departments are enabled then validate the supplied Department, if it doesn’t exist
                  //  or is inactive then log a warning and use the Default Department Code entered by the user.
                  if (!IsValidDepartment(customData.DP))
                    {
                    // Not a valid department, so use the user-specified default
                    errorLog.Log(RestoreLog.severities.sevWarning, string.Format("{0}. Invalid Department: {1}. Using default: {2}",
                                                                   aTransaction.ExternalReference,
                                                                   customData.DP,
                                                                   defaultDepartment));
                    customData.DP = defaultDepartment;
                    }
                  #region debugValidateDept
#if DEBUG
                  else
                    {
                    errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Department {0} OK", customData.DP));
                    }
#endif
                  #endregion debugValidateDept
                  } // Using Cost Centres and Departments

                // P6, R6
                // Attempt to get the SOR.
                #region debugstuff11
#if DEBUG
                errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Looking for transaction {0}", aTransaction.ExternalReference));
#endif
                #endregion debugstuff11
                ITransaction theSOR;
                tToolkit.Transaction.Index = Enterprise04.TTransactionIndex.thIdxOurRef;
                string sKey = tToolkit.Transaction.BuildOurRefIndex(aTransaction.ExternalReference);
                Res = tToolkit.Transaction.GetEqual(sKey);
                if (Res != 0)
                  {
                  // The SOR doesn't exist.
                  // PKR. 11/02/2015. ABSEXCH-16104. Recreate zero-value SOR.
                  // PKR. 06/03/2015. Make this optional, based on a check-box on the form.
                  #region debugstuff12
#if DEBUG
                  errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Didn't find transaction {0}", aTransaction.ExternalReference));
#endif
                  #endregion debugstuff12

                  if (aWantRestoreSORs)
                    {
                    #region debugstuff13
#if DEBUG
                    errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Recreate Orders option selected"));
                    PaymentGateway.dbgForm.Log("P6/R6 Attempting to create transaction " + aTransaction.ExternalReference);
                    errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Attempting to create transaction {0}", aTransaction.ExternalReference));
#endif
                    #endregion debugstuff13
                    CreateSOR(aTransaction, customData);
                    }

                  #region debugstuff14
#if DEBUG
                  else
                    {
                    errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Recreate Orders option NOT selected"));
                    }
#endif
                  #endregion debugstuff14
                  int SRCRes = 0;
                  //HV 15/02/2017 2017-R1  ABSEXCH-18219 - Worldpay transactions are not recreated when DB restore.
                  switch (aTransaction.VendorTypeName.ToUpper())
                    {
                    case ttPayment:
                    // PKR. 04/03/2015. ABSEXCH-16223. Added missing transaction type.
                    //HV 15/02/2017 2017-R1  ABSEXCH-18219 - Worldpay transactions are not recreated when DB restore.
                    //case ttPartPayment:
                    // PKR. 14/09/2015. ABSEXCH-16846. Authenticated/Authorised payments not being recreated.
                    case ttPaymentAuthorisation:
                        {
                        #region debugstuff15
#if DEBUG
                        errorLog.Log(RestoreLog.severities.sevDebug, string.Format("P7 Attempting to create Non-OP payment SRC"));
                        PaymentGateway.dbgForm.Log("P7 Attempting to create Non-OP payment SRC");
#endif
                        #endregion debugstuff15
                        // P7
                        // If the SOR doesn’t exist then we will create a new non-Order-Payments SRC
                        //  against the Account for the supplied values.
                        SRCRes = CreateNonOPSRC(aTransaction, customData, true);

                        break;
                        }
                    case ttRefund:
                        {
                        #region debugstuff16
#if DEBUG
                        errorLog.Log(RestoreLog.severities.sevDebug, string.Format("R7 Attempting to create Non-OP refund SRC"));
                        PaymentGateway.dbgForm.Log("R7 Attempting to create Non-OP refund SRC");
#endif
                        #endregion debugstuff16
                        // R7
                        // Create a new Negative SRC against the account for the supplied refund value
                        SRCRes = CreateNonOPSRC(aTransaction, customData, false);

                        break;
                        }
                    } // end switch
                  // We can ignore the return value, SRCRes, as errors are logged within CreateNonOPSRC
                  }
                else
                  {
                  #region debugstuff17
#if DEBUG
                  errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Transaction {0} already exists", aTransaction.ExternalReference));
                  errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Validating Account Code {0} ", aTransaction.ExternalAccountReference));
#endif
                  #endregion debugstuff17
                  // P8, R8
                  // If the SOR DOES exist then check the SOR is for the specified Account Code and Currency,
                  //  if it doesn’t match then log the payment details as an error and move onto the next payment.
                  theSOR = tToolkit.Transaction;
                  theSOROurRef = theSOR.thOurRef;

                  // Check the SOR's Account Code
                  if (theSOR.thAcCode.ToUpper().Trim() != aTransaction.ExternalAccountReference.ToUpper().Trim())
                    {
                    // Account Codes don't match
                    // Log error and exit
                    errorLog.Log(RestoreLog.severities.sevError, string.Format("{0}. Account Codes {1} and {2} do not match.",
                                                                   aTransaction.ExternalReference,
                                                                   theSOR.thAcCode,
                                                                   aTransaction.ExternalAccountReference));
                    Result = ERROR_ACCOUNT_CODE_MISMATCH;
                    #region debugstuff18
#if TDEBUG
                    if (PaymentGateway.dbgForm != null)
                      {
                      PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                      }
#endif
                    #endregion debugstuff18
                    return Result;
                    }
                  else
                    {
                    #region debugstuff19
#if DEBUG
                    errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Account Code OK"));
                    errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Validating Currency {0}", aTransaction.GatewayTransactionCurrency));
#endif
                    #endregion debugstuff19
                    // Account code matches
                    // Check the currency

                    // We need to get the ISO currency code corresponding to the Exchequer currency.
                    // thCurrency is an integer index into the currency table.
                    int currencyIndex = tToolkit.Transaction.thCurrency;
                    // Use this index to get the Exchequer currency symbol.
                    string exchCurrSymbol = tToolkit.SystemSetup.ssCurrency[currencyIndex].scSymbol;
                    // Use the currency symbol to get the ISO code from our lookup table
                    string ISOCurrSymbol = config.GetISOCurrency(fCompanyCode, exchCurrSymbol);

                    if (ISOCurrSymbol.ToUpper().Trim() != aTransaction.GatewayTransactionCurrency.ToUpper().Trim())
                      {
                      // Currency doesn't match
                      errorLog.Log(RestoreLog.severities.sevError, string.Format("{0}. Currency mismatch : {1} and {2}",
                                                                     aTransaction.ExternalReference,
                                                                     ISOCurrSymbol,
                                                                     aTransaction.GatewayTransactionCurrency));
                      Result = ERROR_CURRENCY_MISMATCH;
                      #region debugstuff20
#if TDEBUG
                      if (PaymentGateway.dbgForm != null)
                        {
                        PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                        }
#endif
                      #endregion debugstuff20
                      return Result;
                      }
                    else
                      {
                      #region debugstuff21
#if DEBUG
                      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Currency OK"));
#endif
                      #endregion debugstuff21
                      // Currency code matches.
                      // Make a clone of the SOR for later use
                      cloneSOR = (theSOR.Clone() as ITransaction12);
                      //HV 15/02/2017 2017-R1  ABSEXCH-18219 - Worldpay transactions are not recreated when DB restore.
                      // Determine what type of transaction it is
                      switch (aTransaction.VendorTypeName.ToUpper())
                        {
                        //  #####                                             ##   
                        //  ##  ##                                            ##   
                        //  ##  ##   #####  ##  ##   ## ##    ####   ## ##   ####  
                        //  #####   ##  ##  ##  ##  ## # ##  ##  ##  ### ##   ##   
                        //  ##      ##  ##  ##  ##  ## # ##  ######  ##  ##   ##   
                        //  ##      ## ###  ##  ##  ## # ##  ##      ##  ##   ##   
                        //  ##       ## ##   #####  ##   ##   #####  ##  ##    ##  
                        //                      ##                                 
                        //                   ####          
                        //
                        #region Payment_PartPayment
                        case ttPayment:
                        // PKR. 04/03/2015. ABSEXCH-16223. Added missing transaction type.
                        //HV 15/02/2017 2017-R1  ABSEXCH-18219 - Worldpay transactions are not recreated when DB restore.
                        // case ttPartPayment:
                        // PKR. 14/09/2015. ABSEXCH-16846. Authenticated/Authorised payments not being recreated.
                        case ttPaymentAuthorisation:
                            {
                            #region debugstuff22
#if DEBUG
                            errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Transaction is Payment"));
#endif
                            #endregion debugstuff22
                            // PKR. 11/03/2015. ABSEXCH-16255. Part Payments are not being created when the SOR has also
                            //  been recreated due to the following tests failing.
                            // So we put a flag in a UDF on the recreated SOR to indicate that it has been recreated, and
                            // then we can skip the tests.

                            if (theSOR.thUserField1 != "RESTORED")
                              {
                              // The SOR exists and wasn't re-created  - i.e. it existed already.
                              #region debugstuff23
#if DEBUG
                              errorLog.Log(RestoreLog.severities.sevDebug, string.Format("SOR was not recreated (already exists)"));
                              errorLog.Log(RestoreLog.severities.sevDebug, string.Format("  Checking SOR lines"));
#endif
                              #endregion debugstuff23
                              // P9
                              // Check the SOR Lines correspond with supplied Stock Code, Location Code and VAT Code details.
                              // If they don’t match then log the payment details as an error and move onto the next payment.
                              foreach (RecoveryCustomDataLine line in customData.lines)
                                {
                                // Find the transaction line that has the same ABSno as the current line

                                // This doesn't work when the SOR has been recreated and we have multiple part-payments to restore.
                                // We can't force tlABSLineNo values when we recreate the SOR because they are read-only.
                                // This is why we added the RESTORED flag, to prevent this code from executing.

                                int lineIndex = -1;
                                for (int thLineIndex = 1; thLineIndex <= theSOR.thLines.thLineCount; thLineIndex++)
                                  {
                                  if (theSOR.thLines[thLineIndex].tlABSLineNo == line.ABSNo)
                                    {
                                    lineIndex = thLineIndex;
                                    break;
                                    }
                                  }

                                if (lineIndex != -1)
                                  {
                                  // PKR 20/08/2015. ABSEXCH-16655. Data restore no longer working.
                                  // tlInclusiveVATCode contained chr(0) so failing the comparison.
                                  string cVATcode = ((theSOR.thLines[lineIndex].tlVATCode == "\0") ? string.Empty : theSOR.thLines[lineIndex].tlVATCode.Trim()) + 
                                           ((theSOR.thLines[lineIndex].tlInclusiveVATCode == "\0") ? string.Empty : theSOR.thLines[lineIndex].tlInclusiveVATCode.Trim());
                                  string cStockCode = (theSOR.thLines[lineIndex].tlStockCode == null) ? string.Empty : theSOR.thLines[lineIndex].tlStockCode.Trim();
                                  string cLocation = (theSOR.thLines[lineIndex].tlLocation == null) ? string.Empty : theSOR.thLines[lineIndex].tlLocation.Trim();

                                  if ((line.Stk.Trim() != cStockCode) ||
                                      (line.Loc.Trim() != cLocation) ||
                                      (line.VATCode.Trim() != cVATcode))
                                    {
                                    // Mismatch on the line details
                                    string supplemental = string.Empty;
                                    if (line.Stk.Trim() != cStockCode) { supplemental += "\r\nStock code does not match."; }
                                    if (line.Loc.Trim() != cLocation) { supplemental += "\r\nLocation does not match."; }
                                    if (line.VATCode.Trim() != cVATcode) { supplemental += "\r\nVAT Code does not match.";  }
                                    #region debugstuff24
#if DEBUG
                                    if (line.Stk.Trim() != theSOR.thLines[lineIndex].tlStockCode.Trim())
                                      {
                                      supplemental += string.Format("\r\nStock code mis-match : [{0}] and [{1}]", line.Stk.Trim(), theSOR.thLines[lineIndex].tlStockCode.Trim());
                                      }
                                    if (line.Loc.Trim() != theSOR.thLines[lineIndex].tlLocation.Trim())
                                      {
                                      supplemental += string.Format("\r\nLocation mis-match : [{0}] and [{1}]", line.Loc, theSOR.thLines[lineIndex].tlLocation);
                                      }
                                    if (line.VATCode.Trim() != cVATcode)
                                      {
                                      supplemental += string.Format("\r\nVAT code mis-match : [{0}] and [{1}][{2}]", line.VATCode, theSOR.thLines[lineIndex].tlVATCode.Trim(), theSOR.thLines[lineIndex].tlInclusiveVATCode.Trim());
                                      }
#endif
                                    #endregion debugstuff24

                                    errorLog.Log(RestoreLog.severities.sevError, string.Format("{0}. Transaction line detail mismatch." + supplemental,
                                                                                    aTransaction.ExternalReference));

                                    Result = ERROR_LINE_DETAIL_MISMATCH;
                                    #region debugstuff25
#if TDEBUG
                                    if (PaymentGateway.dbgForm != null)
                                      {
                                      PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                                      }
#endif
                                    #endregion debugstuff25
                                    return Result;
                                    }

                                  // P10
                                  // Check the Payment Values are <= the SOR Line Values, if the Payment Values exceed the
                                  //  SOR Line values then log the payment details as an error and move onto the next payment.
                                  double srclineGross = Math.Round(line.Goods + line.VAT, 2);

                                  // PKR. 02/10/2015. ABSEXCH-16655. Wasn't taking quantity into account.
                                  double sorLineGross = Math.Round((theSOR.thLines[lineIndex].tlNetValue * theSOR.thLines[lineIndex].tlQty) + 
                                                                    theSOR.thLines[lineIndex].tlVATAmount, 2);

                                  if (srclineGross > sorLineGross)
                                    {
                                    // Payment exceeds values
                                    // Log error and exit
                                    string itemIdentifier = line.Stk;
                                    if (string.IsNullOrEmpty(itemIdentifier))
                                      {
                                      // Stock code not present - use description.
                                      itemIdentifier = line.Description;
                                      }
#if DEBUG
                                    PaymentGateway.dbgForm.Log(string.Format("{0} NOT re-created. Payment ({1}) exceeds order value ({2}) for item {3}",
                                                                                    aTransaction.ExternalReceiptReference,
                                                                                    srclineGross,
                                                                                    sorLineGross,
                                                                                    itemIdentifier));
#endif
                                    errorLog.Log(RestoreLog.severities.sevError, string.Format("{0} NOT re-created. Payment ({1}) exceeds order value ({2}) for item {3}",
                                                                                    aTransaction.ExternalReceiptReference,
                                                                                    srclineGross,
                                                                                    sorLineGross,
                                                                                    itemIdentifier));
                                    
                                    Result = ERROR_PAYMENT_EXCEEDS_ORDER_VALUE;
                                    #region tdebug26
#if TDEBUG
                                    if (PaymentGateway.dbgForm != null)
                                      {
                                      PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                                      }
#endif
                                    #endregion tdebug26
                                    return Result;
                                    }
                                  }
                                else
                                  {
                                  // Transaction line not found
                                  errorLog.Log(RestoreLog.severities.sevError, string.Format("{0}. Transaction line not found in sales order",
                                                                                  aTransaction.ExternalReference));

                                  Result = ERROR_TRANSACTION_LINE_NOT_FOUND;
                                  #region tdebug27
#if TDEBUG
                                  if (PaymentGateway.dbgForm != null)
                                    {
                                    PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                                    }
#endif
                                  #endregion tdebug27
                                  return Result;
                                  }
                                } // end foreach line in customData
                              }
                            else
                              {
                              #region debugstuff28
#if DEBUG
                              errorLog.Log(RestoreLog.severities.sevDebug, string.Format("SOR was recreated, so line tests were skipped."));
#endif
                              #endregion debugstuff28
                              }
                            #region debugstuff29
#if DEBUG
                            errorLog.Log(RestoreLog.severities.sevDebug, string.Format("CustomData TransRef = [{0}]", customData.TransRef));
#endif
                            #endregion debugstuff29
                            // P11
                            // If the TransRef is set in the Custom Data XML...
                            if (customData.TransRef != string.Empty)
                              {
                              // TransRef set
                              // P12
                              #region debugstuff30
#if DEBUG
                              errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Checking transaction [{0}] exists", customData.TransRef));
#endif
                              #endregion debugstuff30
                              // Check whether the SDN/SIN specified in the TransRef exists, if not then log a warning
                              //  and add an Order Payments Payment against the SOR using the supplied values.
                              if (!ExchequerTransactionExists(customData.TransRef))
                                {
                                // SDN/SIN doesn't exist
                                // log warning
                                errorLog.Log(RestoreLog.severities.sevWarning, string.Format("{0}. Transaction reference {1} does not exist",
                                                                                 aTransaction.ExternalReference,
                                                                                 customData.TransRef));
                                Result = WARNING_TRANSACTION_REF_DOES_NOT_EXIST;
                                #region debugstuff31
#if DEBUG
                                errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Doesn't exist - Creating SRC"));
#endif
                                #endregion debugstuff31
                                Res = CreateNonOPSRC(aTransaction, customData, true);
                                }
                              else
                                {
                                // SDN/SIN exists
                                // P13
                                // Check it is derived from the same SOR, if not then log a warning and add an
                                //  Order Payments Payment against the SOR using the supplied values.
                                #region debugstuff32
#if DEBUG
                                errorLog.Log(RestoreLog.severities.sevDebug, string.Format("{0} Exists - getting it via toolkit", customData.TransRef));
#endif
                                #endregion debugstuff32
                                // Get the transaction (SIN/SDN) specified in TransRef
                                ITransaction13 theSINorSDN;
                                tToolkit.Transaction.Index = Enterprise04.TTransactionIndex.thIdxOurRef;
                                sKey = tToolkit.Transaction.BuildOurRefIndex(customData.TransRef);
                                Res = tToolkit.Transaction.GetEqual(sKey);
                                if (Res == 0)
                                  {
                                  #region debugstuff33
#if DEBUG
                                  errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Got the transaction"));
#endif
                                  #endregion debugstuff33
                                  // Despite its name, this could actually be a SOR if the payment was made directly against the SOR.
                                  theSINorSDN = (tToolkit.Transaction as ITransaction13);

                                  string opOrderRef = theSINorSDN.thOrderPaymentOrderRef == null ? "" : theSINorSDN.thOrderPaymentOrderRef;
                                  string ourRef = theSINorSDN.thOurRef == null ? "" : theSINorSDN.thOurRef;

                                  if (
                                      (aTransaction.ExternalReference.ToUpper().Trim() != ourRef.ToUpper().Trim()) &&
                                      (aTransaction.ExternalReference.ToUpper().Trim() != opOrderRef.ToUpper().Trim())
                                    )

                                  //  if (aTransaction.ExternalReference.ToUpper().Trim() != theSINorSDN.thOrderPaymentOrderRef.ToUpper().Trim())
                                    {
                                    // Not derived from the same SOR
                                    // Log warning
                                    errorLog.Log(RestoreLog.severities.sevWarning, string.Format("{0}. Transaction {1} does not derive from the same order",
                                                                                     aTransaction.ExternalReference,
                                                                                     customData.TransRef));
                                    Result = WARNING_TRANSACTION_DERIVES_FROM_DIFFERENT_ORDER;

                                    Res = CreateOPSRC(aTransaction, customData, cloneSOR.thOurRef, true);
                                    }
                                  else
                                    {
                                    // It is derived from the same SOR
                                    // P14
                                    // Check the Payment Values are <= the SDN/SIN Line Values, if the Payment Values
                                    //  exceed the SDN/SIN Line values then log a warning and add an Order Payments
                                    //  Payment against the SOR using the supplied values.
                                    #region debugstuff34
#if DEBUG
                                    errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Checking transaction lines"));
#endif
                                    #endregion debugstuff34
                                    Result = 0;
                                    // PKR. 11/03/2015. ABSEXCH-16255. Part Payment SRCs are not being recreated if the SOR was recreated.
                                    // The SOR has zero value and unmatched tlABSLineNo values.
                                    // The RESTORED flag indicates that the SOR was recreated so we can skip the tests.
                                    if (theSINorSDN.thUserField1 != "RESTORED")
                                      {
                                      // It's an existing SOR/SDN - not a recreated one, so we can check the lines.
                                      foreach (RecoveryCustomDataLine line in customData.lines)
                                        {
                                        // Find the transaction line that has the same ABSno as the current line
                                        int lineIndex = -1;
                                        //   for (int thLineIndex = 0; thLineIndex < theSINorSDN.thLines.thLineCount; thLineIndex++)
                                        for (int thLineIndex = 1; thLineIndex <= theSINorSDN.thLines.thLineCount; thLineIndex++)
                                          {
                                          if (theSINorSDN.thLines[thLineIndex].tlABSLineNo == line.ABSNo)
                                            {
                                            lineIndex = thLineIndex;
                                            break;
                                            }
                                          }

                                        if (lineIndex != -1)
                                          {
                                          // Found the line
                                          if (Math.Round(line.Goods, 2) > Math.Round(theSINorSDN.thLines[lineIndex].tlNetValue * theSINorSDN.thLines[lineIndex].tlQty, 2))
                                            {
                                            // Payment exceeds values
                                            // Log error and exit
                                            errorLog.Log(RestoreLog.severities.sevError, string.Format("{0}. Payment exceeds invoice/delivery note value for {1}",
                                                                                              aTransaction.ExternalReference,
                                                                                              line.Stk));

                                            Result = ERROR_PAYMENT_EXCEEDS_ORDER_VALUE;
                                            #region debugstuff35
#if TDEBUG
                                            if (PaymentGateway.dbgForm != null)
                                              {
                                              PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                                              }
#endif
                                            #endregion debugstuff35
                                            return Result;
                                            }
                                          } // Line index not -1
                                        else
                                          {
                                          // Transaction line not found
                                          errorLog.Log(RestoreLog.severities.sevError, string.Format("{0}. Transaction line not found in invoice/delivery note",
                                                                                            aTransaction.ExternalReference));

                                          Result = ERROR_TRANSACTION_LINE_NOT_FOUND;
                                          #region debugstuff36
#if TDEBUG
                                          if (PaymentGateway.dbgForm != null)
                                            {
                                            PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                                            }
#endif
                                          #endregion debugstuff36
                                          return Result;
                                          } // Transaction line not found
                                        } // For each line in customData lines
                                      } // Not "RESTORED"
                                    else
                                      {
                                      // 17/03/2015. PKR. ABSEXCH-16255. Part payments not being restored correctly.
                                      // "RESTORED" flag set in UDF, so we can't create an OP SRC, nor can we check lines.
                                      Res = CreateNonOPSRC(aTransaction, customData, true);

                                      if (Res != 0)
                                        {
                                        // TODO: Check Parameters
                                        errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Failed to create Non-OP SRC {0}", customData.TransRef));
                                        }

                                      Result = WARNING_RECEIPT_CREATED_AGAINST_RECREATED_ORDER;
                                      #region debugstuff37
#if TDEBUG
                                      if (PaymentGateway.dbgForm != null)
                                        {
                                        PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                                        }
#endif
                                      #endregion debugstuff37
                                      return Result;
                                      }

                                    if (Result != 0)
                                      {
                                      // P14 continued
                                      #region debugstuff38
#if DEBUG
                                      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("P14 - Creating OP SRC {0} against {1}", customData.TransRef, cloneSOR.thOurRef));
#endif
                                      #endregion debugstuff38
                                      Res = CreateOPSRC(aTransaction, customData, cloneSOR.thOurRef, true);
                                      }
                                    else
                                      {
                                      // P15
                                      #region debugstuff39
#if DEBUG
                                      errorLog.Log(RestoreLog.severities.sevDebug, string.Format("P15 - Creating OP SRC {0} against {1}", 
                                                                                                   aTransaction.ExternalReceiptReference, 
                                                                                                   theSINorSDN.thOurRef));
#endif
                                      #endregion debugstuff39
                                      Res = CreateOPSRC(aTransaction, customData, theSINorSDN.thOurRef, true);
                                      }
                                    }
                                  }
                                }
                              }
                            else
                              {
                              // P16
                              // TransRef not set
                              #region debugstuff40
#if DEBUG
                              errorLog.Log(RestoreLog.severities.sevDebug, string.Format("P16 - TransRef not set - Creating OP SRC for {0}", cloneSOR.thOurRef));
#endif
                              #endregion debugstuff40
                              Res = CreateOPSRC(aTransaction, customData, cloneSOR.thOurRef, true);
                              }
                            break;
                            }
                        #endregion Payment_PartPayment

                        //.................................................................................................
                        //  #####             ###                      ##  
                        //  ##  ##           ##                        ##  
                        //  ##  ##   ####    ##    ##  ##  ## ##    #####  
                        //  #####   ##  ##  ####   ##  ##  ### ##  ##  ##  
                        //  ## ##   ######   ##    ##  ##  ##  ##  ##  ##  
                        //  ##  ##  ##       ##    ## ###  ##  ##  ## ###  
                        //  ##  ##   #####   ##     ## ##  ##  ##   ## ##  
                        //.................................................................................................
                        #region Refund
                        case ttRefund:
                            {
                            #region debugstuff41
#if DEBUG
                            errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Transaction is Refund"));
#endif
                            #endregion debugstuff41
                            // R9
                            // Check whether the Payment being refunded (TransRef in the Custom Data XML) exists
                            if (!ExchequerTransactionExists(customData.TransRef))
                              {
                              // R10
                              // If it doesn’t exist then add a new non-Order-Payments negative SRC against the
                              //  Account for the supplied refund value.
                              #region debugstuff42
#if DEBUG
                              errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Creating NON-OP SRC Refund"));
#endif
                              #endregion debugstuff42
                              Res = CreateNonOPSRC(aTransaction, customData, false);
                              }
                            else
                              {
                              // Payment being refunded exists
                              // R11, R12
                              // Check the Payment is for the SOR supplied in the refund details, if not then log
                              //  the refund details as an error and move onto the next payment.
                              if (aTransaction.ExternalReference != customData.TransRef) //   (tToolkit.Transaction as ITransaction13).thOrderPaymentOrderRef)
                                {
                                errorLog.Log(RestoreLog.severities.sevWarning, string.Format("Refund {0}. Order number mis-match ({1} / {2}).",
                                                                               aTransaction.ExternalReference,
                                                                               customData.TransRef,
                                                                               aTransaction.ExternalReference));
                                Result = ERROR_PAYMENT_IS_NOT_FOR_SPECIFIED_ORDER;
                                #region debugstuff43
#if TDEBUG
                                if (PaymentGateway.dbgForm != null)
                                  {
                                  PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                                  }
#endif
                                #endregion debugstuff43
                                return Result;
                                }
                              else
                                {
                                // Refund is for the supplied SOR
                                // R13
                                // Check the SOR Lines correspond with supplied Stock Code, Location Code and VAT Code details.

                                // PKR. 11/03/2015. ABSEXCH-16255. Part Refunds are not being created when the SOR has also
                                //  been recreated due to the following tests failing.
                                // So we put a flag in a UDF on the recreated SOR to indicate that it has been recreated, and
                                // then we can skip the tests.

                                if (theSOR.thUserField1 != "RESTORED")
                                  {
                                  #region debugstuff44
#if DEBUG
                                  errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Order not recreated, so checking lines"));
#endif
                                  #endregion debugstuff44
                                  foreach (RecoveryCustomDataLine line in customData.lines)
                                    {
                                    // Skip clutter lines
                                    if (line.ABSNo != 0)
                                      {

                                      // Find the transaction line that has the same ABSno as the current line
                                      int lineIndex = -1;
                                      //                                for (int thLineIndex = 0; thLineIndex < cloneSOR.thLines.thLineCount; thLineIndex++)
                                      for (int thLineIndex = 1; thLineIndex <= cloneSOR.thLines.thLineCount; thLineIndex++)
                                        {
                                        if ((cloneSOR.thLines[thLineIndex].tlABSLineNo == line.ABSNo) &&
                                            (line.ABSNo != 0))
                                          {
                                          lineIndex = thLineIndex;
                                          break;
                                          }
                                        }

                                      if (lineIndex != -1)
                                        {
                                        // PKR 20/08/2015. ABSEXCH-16655. Data restore no longer working.
                                        // tlInclusiveVATCode contained chr(0) so failing the comparison.
                                        string cStockCode = (cloneSOR.thLines[lineIndex].tlStockCode == null) ? string.Empty : cloneSOR.thLines[lineIndex].tlStockCode.Trim();
                                        string cLocation = (cloneSOR.thLines[lineIndex].tlLocation == null) ? string.Empty : cloneSOR.thLines[lineIndex].tlLocation.Trim();
                                        string cVATcode = (cloneSOR.thLines[lineIndex].tlVATCode == null) ? string.Empty : cloneSOR.thLines[lineIndex].tlVATCode.Trim() +
                                                ((cloneSOR.thLines[lineIndex].tlInclusiveVATCode == "\0") ? string.Empty : cloneSOR.thLines[lineIndex].tlInclusiveVATCode.Trim());

                                        if ((line.Stk.Trim() != cStockCode) ||
                                            (line.Loc.Trim() != cLocation) ||
                                            (line.VATCode.Trim() != cVATcode))
                                          {
                                          // Mismatch on the line details
                                          errorLog.Log(RestoreLog.severities.sevError, string.Format("{0}. Transaction line detail mismatch",
                                                                                          aTransaction.ExternalReference));
                                          Result = ERROR_LINE_DETAIL_MISMATCH;
                                          #region debugstuff45
#if TDEBUG
                                        if (PaymentGateway.dbgForm != null)
                                          {
                                          PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                                          }
#endif
                                          #endregion debugstuff45
                                          return Result;
                                          }

                                        // R14
                                        // Check the Refund Line Values are <= the Payment Line Values, if the Refund Line Values
                                        // exceed the Payment Line values then log the refund details as an error and move onto the next payment.
                                        double srclineGross = Math.Round(line.Goods + line.VAT, 2);
                                        double sorLineGross = Math.Round((cloneSOR.thLines[lineIndex].tlNetValue * cloneSOR.thLines[lineIndex].tlQty) + 
                                                                          cloneSOR.thLines[lineIndex].tlVATAmount, 2);

                                        if (srclineGross > sorLineGross)
                                          {
                                          // Payment exceeds values
                                          // Log error and exit
                                          string itemIdentifier = line.Stk;
                                          if (string.IsNullOrEmpty(itemIdentifier))
                                            {
                                            // Stock code not present - use description.
                                            itemIdentifier = line.Description;
                                            }

                                          errorLog.Log(RestoreLog.severities.sevError, string.Format("R14. {0}. Refund value ({1}) exceeds order value ({2}) for item {3}",
                                                                                            aTransaction.ExternalReference,
                                                                                            srclineGross,
                                                                                            sorLineGross,
                                                                                            itemIdentifier));

                                          Result = ERROR_PAYMENT_EXCEEDS_ORDER_VALUE;
                                          #region debugstuff46
#if TDEBUG
                                        if (PaymentGateway.dbgForm != null)
                                          {
                                          PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                                          }
#endif
                                          #endregion debugstuff46
                                          return Result;
                                          }
                                        } // lineIndex != -1
                                      else
                                        {
                                        // Transaction line not found
                                        errorLog.Log(RestoreLog.severities.sevError, string.Format("{0}. Transaction line not found in sales order",
                                                                                          aTransaction.ExternalReference));

                                        Result = ERROR_TRANSACTION_LINE_NOT_FOUND;
                                        #region debugstuff47
#if TDEBUG
                                      if (PaymentGateway.dbgForm != null)
                                        {
                                        PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                                        }
#endif
                                        #endregion debugstuff47
                                        return Result;
                                        }
                                      } // end foreach line
                                    }
                                  } // RESTORED flag not set
                                else
                                  {
                                  #region debugstuff48
#if DEBUG
                                  errorLog.Log(RestoreLog.severities.sevDebug, string.Format("Order was recreated, so creating Non-OP SRC"));
#endif
                                  #endregion debugstuff48
                                  // 17/03/2015. PKR. ABSEXCH-16255. Part refunds not being restored correctly.
                                  // RESTORED flag set in UDF, so we can't create an OP SRC.
                                  Res = CreateNonOPSRC(aTransaction, customData, false);
                                  Result = WARNING_RECEIPT_CREATED_AGAINST_RECREATED_ORDER;
                                  #region debugstuff49
#if TDEBUG
                                  if (PaymentGateway.dbgForm != null)
                                    {
                                    PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
                                    }
#endif
                                  #endregion debugstuff49
                                  return Result;
                                  }

                                // R15
                                // If the above validation passes then add an Order Payments Refund against the Payment SRC
                                //  using the supplied values.
                                // NB. The 3rd parameter is not always a field from the 2nd one as it is here.
                                #region debugstuff50
#if DEBUG
                                errorLog.Log(RestoreLog.severities.sevDebug, string.Format("R15 Creating OP SRC"));
#endif
                                #endregion debugstuff50

                                Res = CreateOPSRC(aTransaction, customData, customData.TransRef, false);
                                } // payment is for the supplied SOR
                              } // payment being refunded exists
                            break;
                            } // case ttRefund
                        #endregion Refund
                        } // switch transaction type
                      } // currency code matches
                    } // account code matches
                  } // order found
                } // Transaction ExternalAccountReference is not null
              else
                {
                string msg = string.Format("Transaction ExternalAccountReference is null");
                errorLog.Log(RestoreLog.severities.sevWarning, msg);
                #region debugstuff51
#if DEBUG
                PaymentGateway.dbgForm.Log(msg);
#endif
                #endregion debugstuff51
                }
              break;
              } // custom data extracted ok (XML_EXTRACT_SUCCESS

          case XML_EXTRACT_ERROR:
              {
              // Error parsing the XML
              string msg = string.Format("{0}. Error parsing CustomData XML", aTransaction.ExternalReference);
              errorLog.Log(RestoreLog.severities.sevWarning, msg);
              #region debugstuff52
#if DEBUG
              PaymentGateway.dbgForm.Log(msg);
#endif
              #endregion debugstuff52
              break;
              }

          case XML_EXTRACT_NULL:
              {
              // XML is null/empty
              string msg = string.Format("{0}. No CustomData XML found", aTransaction.ExternalReference);
              errorLog.Log(RestoreLog.severities.sevWarning, msg);
              #region debugstuff53
#if DEBUG
              PaymentGateway.dbgForm.Log(msg);
#endif
              #endregion debugstuff53
              break;
              }
          } // switch customRes
        } // try
      catch (Exception Ex)
        {
        string msg = string.Format("Error restoring receipt {0} against order {1}\r\n{2}", aTransaction.ExternalReceiptReference, aTransaction.ExternalReference, Ex.Message);
        errorLog.Log(RestoreLog.severities.sevError, msg);
        #region debugstuff54
#if DEBUG
        PaymentGateway.dbgForm.Log(msg);
#endif
        #endregion debugstuff54
        }
      #region debugstuff55
#if TDEBUG
      if (PaymentGateway.dbgForm != null)
        {
        PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      #endregion debugstuff55
      return Result;
      }

    //=============================================================================================
    // Methods for creating transactions in Exchequer
    // NB: Add parameters as required
    //=============================================================================================
    // PKR. 11/02/2015. ABSEXCH-16104. Create missing zero-value order header.
    /// <summary>
    /// Create a zero-value order to be updated by the user after the restore.
    /// </summary>
    /// <param name="customData"></param>
    private int CreateSOR(GatewayTransactionView aTransaction, RecoveryCustomDataTransaction customData)
      {
      int Res = 0;

      try
        {
#if DEBUG
#if TDEBUG
        if (PaymentGateway.dbgForm != null)
          {
          PaymentGateway.dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
          }
#endif
        PaymentGateway.dbgForm.Log(string.Format("## CreateSOR for {0}", aTransaction.ExternalAccountReference));
#endif

        bool oldOverwriteTransNosState = tToolkit.Configuration.OverwriteTransactionNumbers;

        // Allow us to specify the transaction OurRef
        tToolkit.Configuration.OverwriteTransactionNumbers = false;

        // Create the new transaction
        //PR: 17/03/2017 ABSEXCH-16884 v2017 R1 Change to ITransaction13 to access credit card reference fields
        ITransaction13 newSOR = (tToolkit.Transaction.Add(TDocTypes.dtSOR) as ITransaction13);

        if (newSOR != null)
          {
          newSOR.thAcCode = aTransaction.ExternalAccountReference;
          newSOR.thTransDate = string.Format("{0:yyyyMMdd}", aTransaction.CreatedDateTime);

          // Convert the ISO currency code to the Exchequer index
          newSOR.thCurrency = GetExchequerCurrencyIndex(aTransaction.GatewayTransactionCurrency);

          newSOR.thPeriod = customData.Period;
          newSOR.thYear = customData.Year;
          newSOR.thOurRef = aTransaction.ExternalReference;

          //PR: 17/03/2017 ABSEXCH-16884 v2017 R1 Add credit card references
          newSOR.thCreditCardType = customData.CreditCardType;
          newSOR.thCreditCardNumber = customData.CreditCardNumber;
          newSOR.thCreditCardExpiry = customData.CreditCardExpiry;
          newSOR.thCreditCardAuthorisationNo = customData.CreditCardAuthorisationNo;
          newSOR.thCreditCardReferenceNo = customData.CreditCardReferenceNo;



                    // PKR. 11/03/2015. ABSEXCH-16255. Part-payments not being recreated after the corresponding
                    //  SOR has been recreated, because the tlABSLineNo don't match, and the SOR values are zero.
                    // To overcome this, we put a flag in a UDF so we can skip the checks when we come to
                    // recover the SRCs.
                    newSOR.thUserField1 = "RESTORED";

          // Create the transaction line objects
          foreach (RecoveryCustomDataLine line in customData.lines)
            {
            ITransactionLine9 newLine = (newSOR.thLines.Add() as ITransactionLine9);

            newLine.tlGLCode = customData.GLCode;

            // Check Cost Centre and Departments are in use
            if (tToolkit.SystemSetup.ssUseCCDept)
              {
              // PKR.  01/09/2015.  ABSEXCH-16785. Pad the cost centre.
              newLine.tlCostCentre = tToolkit.CostCentre.BuildCodeIndex(customData.CC);

              // PKR.  01/09/2015.  ABSEXCH-16785. Pad the department.
              newLine.tlDepartment = tToolkit.Department.BuildCodeIndex(customData.DP);
              }

            // PKR. 06/03/2015. ABSEXCH-16254.  Stock code was going into description
            newLine.tlStockCode = line.Stk;

            // PKR. 06/03/2015. We now save the description if there is no stock code
            // It will be blank if we have a Stock Code, so we can safely save it anyway.
            newLine.tlDescr = line.Description;

            if (tToolkit.SystemSetup.ssUseLocations)
              {
              // PKR.  01/09/2015.  ABSEXCH-16785. Pad the location.
              newLine.tlLocation = tToolkit.Location.BuildCodeIndex(line.Loc);
              }

            newLine.tlVATCode = line.VATCode;

            newLine.tlNetValue = 0.0;
            newLine.tlVATAmount = 0.0;

            newLine.Save();
            // Zero value.  This will be updated by the user later.
            // The reason being that the transaction might be a part-payment, or some discount was applied.
            // There's no way we can know the original order value from the restore data.
            }

          // Save the transaction. Parameter=true forces header CalculateValues (will be zero in this case).
          Res = newSOR.Save(true);

          // Restore the setting in the toolkit
          tToolkit.Configuration.OverwriteTransactionNumbers = oldOverwriteTransNosState;

          if (Res == 0)
            {
            errorLog.Log(RestoreLog.severities.sevInfo, string.Format("Recreated order {0}.\r\nPlease review this order and update it as necessary", aTransaction.ExternalReference));
            }
          else
            {
            errorLog.Log(RestoreLog.severities.sevError, string.Format("Could not recreate order {0}. Error code {1}\r\n{2}", aTransaction.ExternalReference, Res, tToolkit.LastErrorString));
            }
          }
        }
      catch (Exception Ex)
        {
        errorLog.Log(RestoreLog.severities.sevWarning, string.Format("Failed to recreate order {0}\r\n{1}",
                                                       aTransaction.ExternalReference, Ex.Message));
        }
#if TDEBUG
      if (PaymentGateway.dbgForm != null)
        {
        PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      return Res;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Create a standard Exchequer Sales Receipt (SRC). If isPayment is false, creates a negative SRC (refund).
    /// </summary>
    /// <param name="aTransaction"></param>
    /// <param name="aCustomData"></param>
    /// <param name="isPayment">True if a payment, false if a refund</param>
    public int CreateNonOPSRC(GatewayTransactionView aTransaction,
                               RecoveryCustomDataTransaction aCustomData,
                               bool isPayment)
      {
      int Res = 0;

      try
        {
#if DEBUG
        PaymentGateway.dbgForm.Log(string.Format("## Creating SRC for {0}", aTransaction.ExternalAccountReference));
#if TDEBUG
        if (PaymentGateway.dbgForm != null)
          {
          PaymentGateway.dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
          }
#endif
#endif
        // Save the current value of this flag so we can restore it later (probably unnecessary)
        bool oldOverwriteTransNosState = tToolkit.Configuration.OverwriteTransactionNumbers;

        // Allow us to specify the transaction OurRef
        tToolkit.Configuration.OverwriteTransactionNumbers = false;

        ITransaction13 newSRC = (tToolkit.Transaction.Add(TDocTypes.dtSRC) as ITransaction13);

        newSRC.thAcCode = aTransaction.ExternalAccountReference;
        newSRC.thTransDate = string.Format("{0:yyyyMMdd}", aTransaction.CreatedDateTime);

        // Convert the ISO currency code to the Exchequer index
        newSRC.thCurrency = GetExchequerCurrencyIndex(aTransaction.GatewayTransactionCurrency);

        newSRC.thPeriod = customData.Period;
        newSRC.thYear = customData.Year;
        newSRC.thOurRef = aTransaction.ExternalReceiptReference;

        // PKR. 26/02/2015. ABSEXCH-16220.  Populate the credit card fields
        newSRC.thCreditCardAuthorisationNo = aTransaction.GatewayVendorTxAuthNo;
        newSRC.thCreditCardExpiry = aTransaction.GatewayVendorCardExpiryDate;
        newSRC.thCreditCardNumber = aTransaction.GatewayVendorCardLast4Digits;
        newSRC.thCreditCardReferenceNo = aTransaction.GatewayVendorTxCode;
        newSRC.thCreditCardType = aTransaction.GatewayVendorCardType;

        ITransactionLine9 newLine = (newSRC.thLines.Add() as ITransactionLine9);
        newLine.tlGLCode = customData.GLCode;

        // Check CC and Depts in use
        if (tToolkit.SystemSetup.ssUseCCDept)
          {
          newLine.tlCostCentre = tToolkit.CostCentre.BuildCodeIndex(customData.CC);
          newLine.tlDepartment = tToolkit.Department.BuildCodeIndex(customData.DP);
          }

        // Get the receipt total by summing the goods net values and VAT over all the lines.
        double receiptTotal = 0.0;
        foreach (RecoveryCustomDataLine line in customData.lines)
          {
          receiptTotal += (line.Goods + line.VAT);
          }
        // Round it to 2dp.
        newLine.tlNetValue = Math.Round(receiptTotal, 2);

        // If it's a refund, make the value negative
        if (!isPayment)
          {
          newLine.tlNetValue = -newLine.tlNetValue;
          newSRC.thNetValue = -newSRC.thNetValue;
          }
        // Save the transaction line
        try
          {
          newLine.Save();
          }
        catch (Exception ex)
          {
          errorLog.Log(RestoreLog.severities.sevError, string.Format("Could not save transaction line for SRC {0}.\r\n{1}\r\n{2}",
                       aTransaction.ExternalReceiptReference, ex.Message, tToolkit.LastErrorString));
          }

        // Save the transaction
        Res = newSRC.Save(true);

        if (Res == 0)
          {
          // Log that it was successful
          errorLog.Log(RestoreLog.severities.sevInfo, string.Format("Recreated transaction {0}", aTransaction.ExternalReceiptReference));
          }
        else
          {
          // Log the error
          errorLog.Log(RestoreLog.severities.sevError, string.Format("Could not recreate {0}. Error code {1} : {2}", 
                                             aTransaction.ExternalReceiptReference, Res, tToolkit.LastErrorString));
          }

        // Restore the setting in the toolkit
        tToolkit.Configuration.OverwriteTransactionNumbers = oldOverwriteTransNosState;
        }
      catch (Exception Ex)
        {
        errorLog.Log(RestoreLog.severities.sevWarning, string.Format("Failed to create {0}\r\n{1}",
                                                       aTransaction.ExternalReceiptReference,
                                                       Ex.Message));
        }
#if TDEBUG
      if (PaymentGateway.dbgForm != null)
        {
        PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      return Res;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Create an Order Payments SRC. If isPayment is false, creates a negative SRC (refund)
    /// </summary>
    /// <param name="aTransaction">The recovered transaction details</param>
    /// <param name="aCustomData">The unpacked payment/refund details</param>
    /// <param name="aBaseTransRef">The original transaction against which the payment/refund was made</param>
    /// <param name="isPayment">True if payment, false if refund</param>
    public int CreateOPSRC(GatewayTransactionView aTransaction,
                           RecoveryCustomDataTransaction aCustomData,
                           string aBaseTransRef,
                           bool isPayment)
      {
      int Res = 0;

#if DEBUG
#if TDEBUG
      if (PaymentGateway.dbgForm != null)
        {
        PaymentGateway.dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      if (isPayment)
        {
        PaymentGateway.dbgForm.Log(string.Format("## Creating Payment SRC for {0}", aTransaction.ExternalAccountReference));
        }
      else
        {
        PaymentGateway.dbgForm.Log(string.Format("## Creating Refund SRC for {0}", aTransaction.ExternalAccountReference));
        }
      PaymentGateway.dbgForm.Log(string.Format("  GL Code        : {0}", customData.GLCode));
      PaymentGateway.dbgForm.Log(string.Format("  Pay ref        : {0}", aBaseTransRef));
      PaymentGateway.dbgForm.Log(string.Format("  SRC Ref        : {0}", aTransaction.ExternalReceiptReference));
      PaymentGateway.dbgForm.Log(string.Format("  SRC Year       : {0}", customData.Year));
      PaymentGateway.dbgForm.Log(string.Format("  SRC Period     : {0}", customData.Period));
      PaymentGateway.dbgForm.Log(string.Format("  SRC Trans Date : {0}", string.Format("{0:yyyyMMdd}", aTransaction.CreatedDateTime)));
      PaymentGateway.dbgForm.Log(string.Format("  Cost Centre    : {0}", customData.CC));
      PaymentGateway.dbgForm.Log(string.Format("  Department     : {0}", customData.DP));
#endif

      try
        {
        (tToolkit.Configuration as IBetaConfig).UserID = userId;
#if DEBUG
        errorLog.Log(RestoreLog.severities.sevDebug, "CreateOPSRC : Set User ID : " + userId);
        errorLog.Log(RestoreLog.severities.sevDebug, "CreateOPSRC : Getting transaction : " + aTransaction.ExternalReference);
#endif
        // Get the transaction
        ITransaction13 theTrans = (tToolkit.Transaction as ITransaction13);
        Res = theTrans.GetEqual(theTrans.BuildOurRefIndex(aTransaction.ExternalReference));

        if (Res == 0)
          {
          // Found the transaction

#if DEBUG
          errorLog.Log(RestoreLog.severities.sevDebug, "CreateOPSRC : Got the transaction - calculating receipt total");
#endif

          // Get the receipt total by summing the goods net values and VAT over all the lines.
          double receiptTotal = 0.0;
          foreach (RecoveryCustomDataLine line in customData.lines)
            {
            receiptTotal += (line.Goods + line.VAT);
            }
          // Round it to 2dp.
          receiptTotal = Math.Round(receiptTotal, 2);

#if DEBUG
          errorLog.Log(RestoreLog.severities.sevDebug, "CreateOPSRC : Receipt total =  " + receiptTotal.ToString());
#endif

          // Determine whether it is a Payment or a Refund
          if (isPayment)
            {
            //.....................................................................................
            //  #####                                             ##   
            //  ##  ##                                            ##   
            //  ##  ##   #####  ##  ##   ## ##    ####   ## ##   ####  
            //  #####   ##  ##  ##  ##  ## # ##  ##  ##  ### ##   ##   
            //  ##      ##  ##  ##  ##  ## # ##  ######  ##  ##   ##   
            //  ##      ## ###  ##  ##  ## # ##  ##      ##  ##   ##   
            //  ##       ## ##   #####  ##   ##   #####  ##  ##    ##  
            //                      ##                                 
            //                   ####          
            //

            // Create the Order Payment
            IOrderPaymentTakePayment oPayment = theTrans.TakePayment();

            // Set to ccaNone because the payment has already been made.  We're just recreating the SRC.
            oPayment.oppCreditCardAction = TCreditCardAction.ccaNone;

            oPayment.oppGLCode = customData.GLCode;
            oPayment.oppPaymentReference = aTransaction.ExternalReference;

            // PKR. 26/02/2015. ABSEXCH-16220.  Populate the credit card fields
            oPayment.oppCreditCardDetails.ccdAuthorisationNo = aTransaction.GatewayVendorTxAuthNo;
            oPayment.oppCreditCardDetails.ccdCardExpiry = aTransaction.GatewayVendorCardExpiryDate;
            oPayment.oppCreditCardDetails.ccdCardNumber = aTransaction.GatewayVendorCardLast4Digits;
            oPayment.oppCreditCardDetails.ccdReferenceNo = aTransaction.GatewayVendorTxCode;
            oPayment.oppCreditCardDetails.ccdCardType = aTransaction.GatewayVendorCardType;

            if (tToolkit.SystemSetup.ssUseCCDept)
              {
              oPayment.oppCostCentre = tToolkit.CostCentre.BuildCodeIndex(customData.CC);
              oPayment.oppDepartment = tToolkit.Department.BuildCodeIndex(customData.DP);
              }

            oPayment.oppValue = receiptTotal;

            oPayment.oppContactName = "";

            (oPayment as IBetaOP).SRCRef = aTransaction.ExternalReceiptReference;
            (oPayment as IBetaOP).SRCYear = customData.Year;
            (oPayment as IBetaOP).SRCPeriod = customData.Period;
            (oPayment as IBetaOP).SRCTransDate = string.Format("{0:yyyyMMdd}", aTransaction.CreatedDateTime);

            Res = oPayment.Execute();

            oPayment = null;
            }
          else
            {
            //.....................................................................................
            //  #####             ###                      ##  
            //  ##  ##           ##                        ##  
            //  ##  ##   ####    ##    ##  ##  ## ##    #####  
            //  #####   ##  ##  ####   ##  ##  ### ##  ##  ##  
            //  ## ##   ######   ##    ##  ##  ##  ##  ##  ##  
            //  ##  ##  ##       ##    ## ###  ##  ##  ## ###  
            //  ##  ##   #####   ##     ## ##  ##  ##   ## ##  
#if DEBUG
            errorLog.Log(RestoreLog.severities.sevDebug, "CreateOPSRC : Creating Refund object");
#endif

            // Create the OP Refund against this transaction
            IOrderPaymentGiveRefund oRefund = theTrans.GiveRefund();

            if (oRefund == null)
              {
              errorLog.Log(RestoreLog.severities.sevDebug, "CreateOPSRC ERROR : GiveRefund returned null object");
              return -1;
              }
            else
              {
#if DEBUG
              errorLog.Log(RestoreLog.severities.sevDebug, "CreateOPSRC : Populating Refund object");
#endif
              // Set to ccaNone because the refund has already been made.  We're just recreating the SRC.
              // Otherwise it will be passed through to the Portal again.
              oRefund.oprCreditCardAction = TCreditCardAction.ccaNone;

              // PKR. 26/02/2015. ABSEXCH-16220.  Populate the credit card fields
              oRefund.oprCreditCardDetails.ccdAuthorisationNo = aTransaction.GatewayVendorTxAuthNo;
              oRefund.oprCreditCardDetails.ccdCardExpiry = aTransaction.GatewayVendorCardExpiryDate;
              oRefund.oprCreditCardDetails.ccdCardNumber = aTransaction.GatewayVendorCardLast4Digits;
              oRefund.oprCreditCardDetails.ccdReferenceNo = aTransaction.GatewayVendorTxCode;
              oRefund.oprCreditCardDetails.ccdCardType = aTransaction.GatewayVendorCardType;

              (oRefund as IBetaOP).SRCRef = aTransaction.ExternalReceiptReference;
              (oRefund as IBetaOP).SRCYear = customData.Year;
              (oRefund as IBetaOP).SRCPeriod = customData.Period;
              (oRefund as IBetaOP).SRCTransDate = string.Format("{0:yyyyMMdd}", aTransaction.CreatedDateTime);

              oRefund.oprRefundReason = string.Empty;

#if DEBUG
              errorLog.Log(RestoreLog.severities.sevDebug, "CreateOPSRC : Setting refund values...");
#endif

              // Find the payment that matches the TransRef so we can set its refund value.
              if (oRefund.oprPayments.oprpCount > 0)
                {
#if DEBUG
                errorLog.Log(RestoreLog.severities.sevDebug, "            : Looking for transaction...");
#endif
                for (int index = 1; index <= oRefund.oprPayments.oprpCount; index++)
                  {
                  IOrderPaymentRefundPayment refPmt = oRefund.oprPayments.oprpPayments[index];

                  // Is this the transaction we are looking for?
                  if ((refPmt.oprpPaymentTransactionI as ITransaction13).thOrderPaymentOrderRef == customData.TransRef)
                    {
#if DEBUG
                    errorLog.Log(RestoreLog.severities.sevDebug, "            : Found transaction");
                    errorLog.Log(RestoreLog.severities.sevDebug, "            : Scanning lines");
#endif
                    // This is the transaction we are looking for
                    // Process each line in the customData

                    foreach (RecoveryCustomDataLine line in customData.lines)
                      {
                      if (line.ABSNo != 0)
                        {
                        // Find the line in the payment record that matches it (if there are any).
                        if (refPmt.oprpPaymentDetails.oprpdCount > 0)
                          {
                          for (int lIndex = 1; lIndex <= refPmt.oprpPaymentDetails.oprpdCount; lIndex++)
                            {
                            if (line.ABSNo == refPmt.oprpPaymentDetails.oprpdPaymentDetails[lIndex].oprpdLineNo)
                              {
#if DEBUG
                              errorLog.Log(RestoreLog.severities.sevDebug, string.Format("            : Found line - Setting refund value to {0} + {1} = {2}", line.Goods, line.VAT, line.Goods + line.VAT));
#endif
                              // Found it.  Set the refund value.
                              refPmt.oprpPaymentDetails.oprpdPaymentDetails[lIndex].oprpdRefundValue = (line.Goods + line.VAT);
                              // Don't need to look any further, so quit the loop
                              break;
                              } // Line number matches
                            } // for each line in the payment details list
                          } // if there are any lines
                        else
                          {
                          errorLog.Log(RestoreLog.severities.sevWarning, string.Format("Refund {0}. No lines found in associated payment {1}", aTransaction.ExternalReference, customData.TransRef));
                          }
                        }
                      } // foreach line in the custom data
                    } // if the reference matches
                  } // for each payment
                } // if there are any payments
              else
                {
                errorLog.Log(RestoreLog.severities.sevWarning, string.Format("Refund {0}. No payments found against {0}", aTransaction.ExternalReference, aBaseTransRef));
                }

#if DEBUG
              errorLog.Log(RestoreLog.severities.sevDebug, "            : Calling IOrderPaymentGiveRefund.Execute...");
#endif
              //-----------------------------------------------------------------------------------
              // Execute the refund
              Res = oRefund.Execute();

              oRefund = null;
              //-----------------------------------------------------------------------------------
#if DEBUG
              errorLog.Log(RestoreLog.severities.sevDebug, string.Format("            : {0} returned from IOrderPaymentGiveRefund.Execute", Res));
#endif
              } // GiveRefund was successful
            } // it's a refund

          if (Res != 0)
            {
#if DEBUG
            PaymentGateway.dbgForm.Log(string.Format("Failed to execute Refund {0} - error code {1} - {2}",
                                         aTransaction.ExternalReceiptReference, Res, tToolkit.LastErrorString));
#endif
            errorLog.Log(RestoreLog.severities.sevError, string.Format("Failed to save transaction {0} - error code {1} : {2}", aTransaction.ExternalReceiptReference, Res, tToolkit.LastErrorString));
            }
          } // found the transaction
        } // try
      catch (Exception Ex)
        {
        errorLog.Log(RestoreLog.severities.sevWarning, string.Format("Failed to create {0}\r\n{1}",
                                                       aBaseTransRef,
                                                       Ex.Message));
        Res = -1; // We don't seem to have a value for this error
        }
#if TDEBUG
      if (PaymentGateway.dbgForm != null)
        {
        PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      return Res;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Get the Exchequer currency index from the ISO currency code.
    /// </summary>
    /// <param name="aISOCurrency"></param>
    /// <returns></returns>
    public short GetExchequerCurrencyIndex(string aISOCurrency)
      {
      short Result = 0;

      // Get the symbol from the ISO currency lookup table
      string ExchequerCurrencySymbol = config.GetExchequerCurrencySymbol(currentCompany.code, aISOCurrency);

      // Look up the symbol in the toolkit currency list
      for (short cIndex = 1; cIndex <= tToolkit.SystemSetup.ssMaxCurrency; cIndex++)
        {
        if (tToolkit.SystemSetup.ssCurrency[cIndex].scSymbol == ExchequerCurrencySymbol)
          {
          Result = cIndex;
          break;
          }
        }

      return Result;
      }

    //=============================================================================================
    // Validation methods
    //=============================================================================================
    /// <summary>
    /// Check if Order Payments is enabled for the specified account
    /// </summary>
    /// <param name="aAccountCode"></param>
    /// <returns></returns>
    public bool IsOrderPaymentsEnabled()
      {
      if (tToolkit != null)
        {
        return (((tToolkit.SystemSetup as Enterprise04.ISystemSetup12).ssEnableOrderPayments) &&
                (currentCompany.orderPaymentsIsEnabled));
        }
      else
        {
        SetLastErrorString("COM Toolkit is not assigned");
        return false;
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Check whether the current company is using Cost Centres and Departments
    /// </summary>
    /// <returns></returns>
    public bool IsUsingCostCentres()
      {
      if (tToolkit != null)
        {
        return tToolkit.SystemSetup.ssUseCCDept;
        }
      else
        {
        SetLastErrorString("COM Toolkit is not assigned");
        return false;
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Check whether the specified SOR exists in Exchequer
    /// </summary>
    /// <param name="OurRef"></param>
    /// <returns></returns>
    public bool ExchequerTransactionExists(string aOurRef)
      {
#if DEBUG
#if TDEBUG
      if (PaymentGateway.dbgForm != null)
        {
        PaymentGateway.dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      PaymentGateway.dbgForm.Log(string.Format("Checking existence of transaction {0}", aOurRef));
#endif

      bool Result = false;

      if (tToolkit != null)
        {
        long Res;

        tToolkit.Transaction.Index = Enterprise04.TTransactionIndex.thIdxOurRef;
        string sKey = tToolkit.Transaction.BuildOurRefIndex(aOurRef);
        Res = tToolkit.Transaction.GetEqual(sKey);
        Result = (Res == 0);
        }
      else
        {
        Result = false;
        SetLastErrorString("COM Toolkit error in ExchequerTransactionExists");
        }

#if DEBUG
      PaymentGateway.dbgForm.Log(string.Format("  Exists : {0}", Result));
#if TDEBUG
      if (PaymentGateway.dbgForm != null)
        {
        PaymentGateway.dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
#endif
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Checks whether an account code is valid and whether Order Payments is enabled for it.
    /// </summary>
    /// <param name="aAccountCode"></param>
    /// <returns></returns>
    public bool IsValidAccountCode(string aAccountCode)
      {
      bool Result = false;

      // PKR. 13/02/2015. Added test for null account code, which can happen during testing.
      // Retained here as a safety measure.
      if (aAccountCode != string.Empty)
        {
        if (tToolkit != null)
          {
          int Res = 0;

          try
            {
            tToolkit.Customer.Index = Enterprise04.TAccountIndex.acIdxCode;
            string sKey = tToolkit.Customer.BuildCodeIndex(aAccountCode);
            Res = tToolkit.Customer.GetEqual(sKey);
            // Is valid if Account found and allow order payments is set to true
            bool allowOP = false;
            if (Res == 0)
              {
              allowOP = ((tToolkit.Customer as IAccount10).acAllowOrderPayments);
              }

            Result = (Res == 0) && (allowOP);
            if (!allowOP)
              {
              SetLastErrorString(string.Format("Account {0} not configured to allow Order Payments", aAccountCode));
#if DEBUG
              PaymentGateway.dbgForm.Log(string.Format("Account {0} not configured to allow Order Payments", aAccountCode));
#endif
              }
            if (Res != 0)
              {
              SetLastErrorString(string.Format("Account {0} not found", aAccountCode));
#if DEBUG
              PaymentGateway.dbgForm.Log(string.Format("Account {0} not found", aAccountCode));
#endif
              }
            }
          catch (Exception Ex)
            {
            MessageBox.Show("Error calling toolkit : " + Ex.Message);
            }
          }
        else
          {
          Result = false;
          SetLastErrorString("COM Toolkit error validating account code");
          }
        }
      else
        {
#if DEBUG
        PaymentGateway.dbgForm.Log(string.Format("Null or empty account code : {0}", aAccountCode));
#endif
        Result = false;
        }

      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Reopens the toolkit for the specified company
    /// </summary>
    /// <param name="aCompany"></param>
    private void ReopenToolkit(MCMCompany aCompany)
      {
      if (tToolkit != null)
        {
        // If the datapath is different to the toolkit one, close the toolkit and re-open it.
        if (aCompany.path != tToolkit.Configuration.DataDirectory)
          {
          if (tToolkit.Status == Enterprise04.TToolkitStatus.tkOpen)
            {
            tToolkit.CloseToolkit();
            }
          tToolkit.Configuration.DataDirectory = aCompany.path;
          int tkRes = tToolkit.OpenToolkit();

          // Get user Id passed in from Exch.
          (tToolkit.Configuration as IBetaConfig2).UserID = userId;
          }
        }
      else
        {
        SetLastErrorString("COM Toolkit is not assigned");
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Check whether the specified GLCode is valid or not
    /// </summary>
    /// <param name="aGLCode"></param>
    /// <returns></returns>
    public bool IsValidGLCode(int aGLCode)
      {
      bool Result = false;

      if (tToolkit != null)
        {
        // First determine whether we're using GL Classes or not
        bool usingGLClasses = (tToolkit.SystemSetup as Enterprise04.ISystemSetup5).ssEnforceGLClasses;

        Enterprise04.IGeneralLedger2 oGL = (tToolkit.GeneralLedger as Enterprise04.IGeneralLedger2);
        long Res;
        try
          {
          oGL.Index = Enterprise04.TGeneralLedgerIndex.glIdxCode;
          Res = oGL.GetEqual(oGL.BuildCodeIndex(aGLCode));
          if (Res == 0)
            {
            // Found the GL code.  Validate it.
            if (oGL.glType == Enterprise04.TGeneralLedgerType.glTypeBalanceSheet)
              {
              Result = true; // Potentially valid

              if (usingGLClasses)
                {
                if (oGL.glClass != Enterprise04.TGeneralLedgerClass.glcBankAccount)
                  {
                  // Not a bank account, so not valid after all
                  Result = false;
                  SetLastErrorString(string.Format("GL Code {0} is not of class Bank Account", aGLCode));
                  }
                }
              }
            else
              {
              // Not a Balance Sheet type
              Result = false;
              SetLastErrorString(string.Format("GL Code {0} is not a Balance Sheet type.", aGLCode));
              }
            }
          }
        catch
          {
          Result = false;
          SetLastErrorString(string.Format("Could not validate GL Code {0}.", aGLCode));
          }

        oGL = null;
        }
      else
        {
        SetLastErrorString("Validate GL Code : COM Toolkit is not assigned");
        }

      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Checks whether the specified Cost Centre is valid or not
    /// </summary>
    /// <param name="aCostCentre"></param>
    /// <returns></returns>
    private bool IsValidCostCentre(string aCostCentre)
      {
      bool Result = false;

      if (tToolkit != null)
        {
        if (tToolkit.SystemSetup.ssUseCCDept)
          {
          tToolkit.CostCentre.Index = Enterprise04.TCCDeptIndex.cdIdxCode;
          string sKey = tToolkit.CostCentre.BuildCodeIndex(aCostCentre);
          int Res = tToolkit.CostCentre.GetEqual(sKey);

          // Check cdInactive...
          if (Res == 0)
            {
            Result = true; // Valid CC so far

            if (((tToolkit.CostCentre) as ICCDept2).cdInactive)
              {
              // Inactive, so not valid.
              Result = false;
              }
            }
          }
        else
          {
          // Not using Cost Centres, so just say it's valid.
          Result = true;
          }
        }
      else
        {
        SetLastErrorString("Validate Cost Centre : COM toolkit not assigned");
        Result = false;
        }
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Check whether the department is valid or not
    /// </summary>
    /// <param name="aDepartment"></param>
    /// <returns></returns>
    private bool IsValidDepartment(string aDepartment)
      {
      bool Result = false;

      if (tToolkit != null)
        {
        tToolkit.Department.Index = Enterprise04.TCCDeptIndex.cdIdxCode;
        string sKey = tToolkit.Department.BuildCodeIndex(aDepartment);
        int Res = tToolkit.Department.GetEqual(sKey);

        if (Res == 0)
          {
          Result = true;

          if (((tToolkit.Department) as ICCDept2).cdInactive)
            {
            // Inactive, so not valid.
            Result = false;
            }
          }
        }
      else
        {
        SetLastErrorString("Validate Department : COM toolkit not assigned");
        Result = false;
        }

      return Result;
      }
    }

  //=============================================================================================

  public class RecoveryCustomDataLine
    {
    public int ABSNo;
    public string Stk;
    public string Description; // Only used if no stock code
    public string Loc;
    public string VATCode;
    public double Goods;
    public double VAT;
    } // class RecoveryCustomDataLine

  //-----------------------------------------------------------------------------------------------
  public class RecoveryCustomDataTransaction : IDisposable
    {
    public string TransRef;
    public short Period;
    public short Year;
    public int GLCode;
    public string CC;
    public string DP;
    public string PayRef;

    //PR: 17/03/2017 ABSEXCH-16884 v2017 R1 Add credit card reference fields
    public string CreditCardType;
    public string CreditCardNumber;
    public string CreditCardExpiry;
    public string CreditCardAuthorisationNo;
    public string CreditCardReferenceNo;

    public List<RecoveryCustomDataLine> lines;

    /// <summary>
    /// Constructor
    /// </summary>
    public RecoveryCustomDataTransaction()
      {
      TransRef = string.Empty;
      Period = 0;
      Year = 0;
      GLCode = 0;
      CC = string.Empty;
      DP = string.Empty;
      PayRef = string.Empty;

      lines = new List<RecoveryCustomDataLine>();
      }

    //=============================================================================================
    // Implementation of IDisposable
    //=============================================================================================

    private bool disposed = false;

    public void Dispose()
      {
      Dispose(true);
      GC.SuppressFinalize(this);
      }


    protected virtual void Dispose(bool disposing)
      {
      // This allows multiple calls
      if (disposed)
        {
        return;
        }

      if (disposing)
        {
        // Free all managed objects here.
        lines.Clear();
        lines = null;
        }

      // Free all unmanaged objects here.
      // This allows multiple calls
      disposed = true;
      }

    /// <summary>
    /// Finalizer
    /// </summary>
    ~RecoveryCustomDataTransaction()
      {
      Dispose(false);
      }

    //=============================================================================================


    /// <summary>
    /// Extracts data from the CustomData string field.
    /// Note that if customData is a null or empty string, this function still returns success.
    /// </summary>
    /// <param name="aCustomData"></param>
    /// <returns>0 if no errors occurred</returns>
    public int ExtractCustomData(string aCustomData)
      {
      int Result = DataRestorer.XML_EXTRACT_SUCCESS;

      // Clear the fields of previous data
      TransRef = string.Empty;
      Period = 0;
      Year = 0;
      GLCode = 0;
      CC = string.Empty;
      DP = string.Empty;
      PayRef = string.Empty;

      //PR: 17/03/2017 ABSEXCH-16884 v2017 R1 Add credit card references
      CreditCardType = string.Empty;
      CreditCardNumber = string.Empty;
      CreditCardExpiry = string.Empty;
      CreditCardAuthorisationNo = string.Empty;
      CreditCardReferenceNo = string.Empty;


      lines.Clear();

#if DEBUG
      string currNode = string.Empty;
#endif

      // Extract the fields from the XML in aCustomData
      if (!string.IsNullOrEmpty(aCustomData))
        {
        XmlDocument xmlDoc = new XmlDocument();

        try
          {
          xmlDoc.LoadXml(aCustomData);

          XmlNode PayDataNode = xmlDoc.DocumentElement;
          XmlNode node;

#if DEBUG
          currNode = "header:TransRef";
#endif
          node = PayDataNode.Attributes["TransRef"];
          if (node != null) TransRef = PayDataNode.Attributes["TransRef"].Value.ToString();

#if DEBUG
          currNode = "header:Period";
#endif
          node = PayDataNode.Attributes["Period"];
          if (node != null) Period = Convert.ToInt16(PayDataNode.Attributes["Period"].Value);

#if DEBUG
          currNode = "header:Year";
#endif
          node = PayDataNode.Attributes["Year"];
          if (node != null) Year = Convert.ToInt16(PayDataNode.Attributes["Year"].Value);

#if DEBUG
          currNode = "header:GLCode";
#endif
          node = PayDataNode.Attributes["GLCode"];
          if (node != null) GLCode = Convert.ToInt32(PayDataNode.Attributes["GLCode"].Value);

#if DEBUG
          currNode = "header:CC";
#endif
          node = PayDataNode.Attributes["CC"];
          if (node != null) CC = PayDataNode.Attributes["CC"].Value;

#if DEBUG
          currNode = "header:DP";
#endif
          node = PayDataNode.Attributes["DP"];
          if (node != null) DP = PayDataNode.Attributes["DP"].Value;

//PR: 17/03/2017 ABSEXCH-16884 v2017 R1 Add credit card references
#if DEBUG
          currNode = "header:CreditCardType";
#endif
                    node = PayDataNode.Attributes["CreditCardType"];
          if (node != null) CreditCardType = PayDataNode.Attributes["CreditCardType"].Value;

#if DEBUG
          currNode = "header:CreditCardNumber";
#endif
          node = PayDataNode.Attributes["CreditCardNumber"];
          if (node != null) CreditCardNumber = PayDataNode.Attributes["CreditCardNumber"].Value;

#if DEBUG
          currNode = "header:CreditCardExpiry";
#endif
                    node = PayDataNode.Attributes["CreditCardExpiry"];
                    if (node != null) CreditCardExpiry = PayDataNode.Attributes["CreditCardExpiry"].Value;

#if DEBUG
          currNode = "header:CreditCardAuthorisationNo";
#endif
                    node = PayDataNode.Attributes["CreditCardAuthorisationNo"];
                    if (node != null) CreditCardAuthorisationNo = PayDataNode.Attributes["CreditCardAuthorisationNo"].Value;

#if DEBUG
          currNode = "header:CreditCardReferenceNo";
#endif
                    node = PayDataNode.Attributes["CreditCardReferenceNo"];
                    if (node != null) CreditCardReferenceNo = PayDataNode.Attributes["CreditCardReferenceNo"].Value;



#if DEBUG
          currNode = "header:PayRef";
#endif
                    node = PayDataNode.Attributes["PayRef"];
          if (node != null) PayRef = PayDataNode.Attributes["PayRef"].Value;



                    // Process the line data
                    foreach (XmlNode lineNode in PayDataNode.ChildNodes)
            {
            // Create a record for it
            RecoveryCustomDataLine newLine = new RecoveryCustomDataLine();

            // Extract the attributes from the XML tag
#if DEBUG
            currNode = "line:ABSNo";
#endif
            node = lineNode.Attributes["ABSNo"];
            if (node != null) newLine.ABSNo = Convert.ToInt32(lineNode.Attributes["ABSNo"].Value);

#if DEBUG
            currNode = "line:Stk";
#endif
            node = lineNode.Attributes["Stk"];
            if (node != null)
              {
              // PKR. 09/04/2015. ABSEXCH-16104. Use web encoded strings to allow special characters
              //  in stock codes and descriptions (including " < > & ')
              string decodeString = lineNode.Attributes["Stk"].Value;
              // PKR. 30/09/2015. ABSEXCH-16655. Data restore not working.
              // If no stock code is specified (description only), then this value will be null and
              // an exception will be raised.
              if (decodeString == null)
                {
                decodeString = string.Empty;
                }
              decodeString = XMLFuncs.WebDecode(decodeString);
              newLine.Stk = decodeString;
              }
            else
              {
              // No stock code, so look for a description
#if DEBUG
              currNode = "line:Desc";
#endif
              node = lineNode.Attributes["Desc"];
              if (node != null)
                {
                // PKR. 09/04/2015. ABSEXCH-16104. Use web encoded strings to allow special characters
                //  in stock codes and descriptions (including " < > & ')
                string decodeString = lineNode.Attributes["Desc"].Value;
                decodeString = XMLFuncs.WebDecode(decodeString);
                newLine.Description = decodeString;
                // PKR. 30/09/2015. ABSEXCH-16655. Data restore not working.
                // If no stock code is specified (description only), then this value will be null and
                // an exception will be raised.
                if (newLine.Stk == null)
                  {
                  newLine.Stk = string.Empty;
                  }
                }
              }

#if DEBUG
            currNode = "line:Loc";
#endif
            node = lineNode.Attributes["Loc"];
            if (node != null) newLine.Loc = lineNode.Attributes["Loc"].Value;

#if DEBUG
            currNode = "line:VATCode";
#endif
            node = lineNode.Attributes["VATCode"];
            if (node != null) newLine.VATCode = lineNode.Attributes["VATCode"].Value;

#if DEBUG
            currNode = "line:Goods";
#endif
            node = lineNode.Attributes["Goods"];
            if (node != null) newLine.Goods = Convert.ToDouble(lineNode.Attributes["Goods"].Value);

#if DEBUG
            currNode = "line:VAT";
#endif
            node = lineNode.Attributes["VAT"];
            if (node != null) newLine.VAT = Convert.ToDouble(lineNode.Attributes["VAT"].Value);

            // Add the line to the List
            lines.Add(newLine);
            }
          }
        catch (Exception ex)
          {
          // Temporary message for debugging only
#if DEBUG
          string msg = string.Format("An error occurred processing the customData XML\r\n{0}\r\nat node {1}", ex.Message, currNode);
#else
          string msg = string.Format("An error occurred processing the customData XML\r\n{0}", ex.Message);
#endif
          PaymentGateway.dbgForm.Log(msg);
          Result = DataRestorer.XML_EXTRACT_ERROR;
          }
        } // customData is not a null string
      else
        {
        Result = DataRestorer.XML_EXTRACT_NULL;
        }

      return Result;
      } // ExtractCustomData
    } // class RecoveryCustomDataTransaction
  }