using System;
using System.Collections.Generic;
using System.Runtime;
using System.Threading;

// For Debugger
using System.Reflection;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Diagnostics;
using Exchequer.Payments.Portal.COM.Client;
using Exchequer.Payments.Portal.COM.Client.PaymentServices;
using PaymentGatewayAddin;
using Enterprise04;

namespace ExchequerPaymentGateway
  {
  [Guid("A4F422CF-2B78-4946-A10A-8BDC0094AF5B")]
  [InterfaceType(ComInterfaceType.InterfaceIsDual)]
  [ComVisible(true)]
  public interface IPaymentGatewayPlugin
    {
    Boolean SetCurrentCompanyCode(string aCompanyCode);

    short GetDefaultGlCode(string SalesOrderReference, string TransactionReference,
                           string UDF5, string UDF6, string UDF7,
                           string UDF8, string UDF9, string UDF10);

    PaymentGatewayResponse ProcessPayment(ExchequerTransaction TransactionDetails, long aProvider, long aMerchant);

    PaymentGatewayResponse ProcessRefund(ExchequerTransaction TransactionDetails, string RefundReason);

    DialogResult DisplayConfigurationDialog(int hWnd, string aCompany, string aUserId, bool aIsSuperUser);

    Boolean GetPaymentDefaults(out int GLCode,
                               out long Provider,
                               out long MerchantID,
                               out string CostCentre,
                               out string Department,
                               string UDF5, string UDF6, string UDF7,
                               string UDF8, string UDF9, string UDF10);

    Boolean GetPaymentDefaultsEx(out int GLCode,
                                 out long Provider,
                                 out long MerchantID,
                                 out string CostCentre,
                                 out string Department,
                                 out string ProviderDescription,
                                 string UDF5, string UDF6, string UDF7,
                                 string UDF8, string UDF9, string UDF10);

    Boolean IsCCEnabledForCompany(string aCompanyCode);

    Boolean SetParentHandle(int hWnd);

    PaymentGatewayResponse GetTransactionStatus(string aTransVendorTx);

    // PKR. 21/07/2015. ABSEXCH-16683. Portal has changed to provide correct functionality.
    // Obsolete
    //    int GetTokenStatus(string aOurRef);

    Boolean GetProcessedTransactionsByDateRange(DateTime startDate,
                                                DateTime endDate,
                                                int pageNumber,
                                                out GatewayCOMObject.GatewayCOMClass.PagedTransactionResponse response);

    int UpdateTransactionContent(string gatewayTransactionGuid,
                                 string receiptReference,
                                 string customData);

    // PKR. 05/01/2015. New method to get the Portal status
    Boolean GetServiceStatus();

    void CancelTransaction(string aTransactionGUID);

    void FreeResources();
    }

  //===============================================================================================
  [Guid("FBA4004E-D3D9-4AD2-803A-BB5E8BBA4237")]
  [ClassInterface(ClassInterfaceType.None)]
  [ProgId("ExchequerPaymentGateway.PaymentGatewayPlugin")]
  [ComVisible(true)]
  public class PaymentGateway : IPaymentGatewayPlugin, IDisposable
    {
    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    public static string ExchequerVersion
      {
      get 
        {
        Assembly assembly = Assembly.GetExecutingAssembly();
        FileVersionInfo fvi = FileVersionInfo.GetVersionInfo(assembly.Location);
        int buildNum = fvi.FilePrivatePart;

        FileVersionInfo COMClientVersionInfo = FileVersionInfo.GetVersionInfo(@"Exchequer.Payments.Portal.COM.Client.dll");
        if (COMClientVersionInfo != null)
          {
          return string.Format("Version: Exchequer 2015 R1 Build {0}\r\nPayments Portal Client version {1}", buildNum, COMClientVersionInfo.FileVersion);
          }
        else
          {
          return string.Format("Version: Exchequer 2015 R1 Build {0}", buildNum);
          }
        }
      }

    public const int TRANS_STATUS_NOT_SET = -1;
    public const int TRANS_STATUS_PENDING = 0;
    public const int TRANS_STATUS_SUCCESS = 1;
    public const int TRANS_STATUS_NOT_AUTHORISED = 2;
    public const int TRANS_STATUS_ABORT = 3;
    public const int TRANS_STATUS_REJECTED = 4;
    public const int TRANS_STATUS_AUTHENTICATED = 5;
    public const int TRANS_STATUS_REGISTERED = 6;
    public const int TRANS_STATUS_ERROR = 7;

    [StructLayout(LayoutKind.Sequential)]
    private struct RECT
      {
      public int Left;
      public int Top;
      public int Right;
      public int Bottom;
      }

    private string userID;

    public string gatewayTransactionGuid = string.Empty; // Receives the transaction ID
    public string authTicket = string.Empty;             // Receives the authorisation code

    public static DebugView dbgForm;

    //---------------------------------------------------------------------------------------------
    // The one and only portal, which will be passed in to all other objects that need it
    private GatewayCOMObject.GatewayCOMClass eppcc;

    // The one and only configuration, which will be passed in to all other objects that need it
    private SiteConfig config;
    // This is populated from the Payments Portal if it is null.
    GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount[] companyMerchantAccsList = null;

    // The one and only COM Toolkit
    private ToolkitWrapper tkw;
    //---------------------------------------------------------------------------------------------

    private const string configFilename = "CCGatewayCfg.dat";
    private string currentCompanyCode = string.Empty;

    /// <summary>
    /// The handle of the parent window.  This allows any displayed dialogs to have a parent window.
    /// </summary>
    private IntPtr ParentWindowHandle;

    public int errorCode;

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Constructor
    /// </summary>
    public PaymentGateway()
      {
      // PKR. TEMPORARY for debugging
#if DEBUG
      // Create a debug view form
      if (dbgForm == null)
        {
        dbgForm = new DebugView();
        }
      dbgForm.Show();
#if TDEBUG
      dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
#endif
#endif
      errorCode = 0;

      // Create a GatewayCOMClass object
      eppcc = new GatewayCOMObject.GatewayCOMClass();

      // Create a toolkit wrapper
      tkw = new ToolkitWrapper();

      // Create a configuration
      config = new SiteConfig(tkw.tToolkit);

#if DEBUG
      // Pass the debug form to the config so that it can update it
      config.dbgForm = dbgForm;
#endif

      config.Load(configFilename);

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      }

    // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
    //
    // NOTE: Dispose is not called automatically by .NET, and it's not possible to call it from
    //       Delphi across the COM boundary.  The execution of the Finalizer is non-deterministic
    //       so it takes a long time for the GC to clean up.
    // So the IDisposable model is useless when called from Delphi, but works fine when used
    // in C#, so the interface remains here in case we migrate Exchequer to C#.
    // In the meantime, the FreeResources method is called from Exchequer.  This sets the disposed
    // flag so that it can't be called more than once. The disposed flag is also checked to prevent
    // execution of the public methods after FreeResources has been called.
    //
    //=============================================================================================
    // Implementation of IDisposable
    //=============================================================================================

    // Flag: Has Dispose already been called?
    // Made public so that Exchequer can query it
    public bool disposed = false;

    // Public implementation of Dispose pattern callable by consumers.
    public void Dispose()
      {
      Dispose(true);
      GC.SuppressFinalize(this);
      }


    // Protected implementation of Dispose pattern.
    protected virtual void Dispose(bool disposing)
      {
      // Prevent re-entry
      if (disposed)
        {
        return;
        }

      if (disposing)
        {
        // Free managed objects here.

        // ABSEXCH-16215. Release allocated resource.
        // The configuration
        if (config != null)
          {
          config.Dispose();
          config = null;
          }

        // The payments portal COM client
        if (eppcc != null)
          {
          eppcc.Dispose();
          eppcc = null;
          }

        // The toolkit wrapper.
        if (tkw != null)
          {
          tkw.Dispose();
          tkw = null;
          }

#if DEBUG
        // (Tell the GC to) get rid of the Debug view form.
        if (dbgForm != null)
          {
          dbgForm.Dispose();
          dbgForm = null;
          }
#endif
        }

      // Free any unmanaged objects here.
      //
      disposed = true;
      }


    /// <summary>
    /// Finalizer
    /// </summary>
    ~PaymentGateway()
      {
      Dispose(false);
      }


    /// <summary>
    /// Release the resources owned by the add-in, because there's no way of calling
    /// the Dispose method from Delphi, and if left to its own devices, the Garbage Collector
    /// takes about 15 minutes to tidy up.
    /// </summary>
    public void FreeResources()
      {
      Dispose();
      }

    //=============================================================================================
    /// <summary>
    /// Sets the current company code.  Returns false if this company is not configured to use credit cards
    /// </summary>
    /// <param name="aCompanyCode"></param>
    /// <returns></returns>
    public Boolean SetCurrentCompanyCode(string aCompanyCode)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }

      bool result = true;

      currentCompanyCode = aCompanyCode;
      result = config.CreditCardsEnabledForCompany(aCompanyCode);

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Gets the default data for the specified source.
    /// </summary>
    /// <param name="SalesOrderReference"></param>
    /// <param name="DescendentTransactionReference"></param>
    /// <param name="UDF5"></param>
    /// <param name="UDF6"></param>
    /// <param name="UDF7"></param>
    /// <param name="UDF8"></param>
    /// <param name="UDF9"></param>
    /// <param name="UDF10"></param>
    /// <returns></returns>
    public short GetDefaultGlCode(string SalesOrderReference, string DescendentTransactionReference,
                                  string UDF5, string UDF6, string UDF7,
                                  string UDF8, string UDF9, string UDF10)
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      short result;
      long Provider;
      long MerchantID;
      string CostCentre;
      string Department;
      int GLCode;

      // This method gets default data including GLCode, so use it.
      GetPaymentDefaults(out GLCode, out Provider, out MerchantID, out CostCentre, out Department,
                         UDF5, UDF6, UDF7, UDF8, UDF9, UDF10);

      result = Convert.ToInt16(GLCode);

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return result;
      }

    //=============================================================================================
    /// <summary>
    /// Sends a payment request to the Payment Portal.
    /// May be a standard payment request, a request for authorisation, or a request for payment
    /// using an existing authorisation.
    /// </summary>
    /// <param name="TransactionDetails"></param>
    /// <returns>Returns the response from the Payment Portal</returns>
    public PaymentGatewayResponse ProcessPayment(ExchequerTransaction TransactionDetails, long aProvider, long aMerchant)
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }

#if DEBUG
      if (dbgForm != null)
        {
#if TDEBUG
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
#endif
        dbgForm.Log("<<<<=============== PAYMENT ===============>>>>");
        }
#endif

      // PKR. 09/02/2015. Login to get an authTicket.
      if (authTicket == string.Empty)
        {
        Login();
        }
#if DEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("authTicket               : " + authTicket);
        }
#endif

      PaymentGatewayResponse result = new PaymentGatewayResponse();

      // Added under Graham Yorke's instruction to get it to connect to the Payment Portal.
      System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

      ShoppingBasket shoppingBasket = new ShoppingBasket();
      shoppingBasket.Items = new List<ShoppingBasketItem>();

      string ourRef = string.Empty;

      // Get the ISO-4217 Currency code that corresponds to the Exchequer currency symbol
      string currencyCode = config.GetISOCurrency(currentCompanyCode, TransactionDetails.CurrencySymbol);

      // PKR. 02/01/2015. ABSEXCH-15976. Catch instances when the currency table hasn't been set up.
      if (string.IsNullOrEmpty(currencyCode))
        {
        // No valid currency code was found
        MessageBox.Show(string.Format("Currency {0} not recognised as a valid ISO currency.\r\nPlease set up currency symbols on the configuration screen.", TransactionDetails.CurrencySymbol), "Invalid currency code");
        result.IsError = true;
        }
      else
        {
        // PKR. 05/01/2015. Now that Authorise Only requires a shopping basket (due to WorldPay)
        // common code has been factored out to here.

        // PKR. 02/01/2015.
        // For Authorisations, we now need to fill a shopping basket to satisfy WorldPay,
        //  so this is now common to all transaction requests
#if DEBUG
        if (dbgForm != null)
          {
          switch (TransactionDetails.PaymentType)
            {
            case ExchequerTransaction.PaymentAction.CardAuthentication:
                {
                dbgForm.Log("Payment type : Card Authentication");
                break;
                }
            case ExchequerTransaction.PaymentAction.Payment:
                {
                dbgForm.Log("Payment type : Payment");
                break;
                }
            case ExchequerTransaction.PaymentAction.PaymentAuthorisation:
                {
                dbgForm.Log("Payment type : Payment Authorisation");
                break;
                }
            case ExchequerTransaction.PaymentAction.Refund:
                {
                dbgForm.Log("Payment type : Refund");
                break;
                }
            }
          }
#endif

        shoppingBasket.RelatedTransactionGuid = string.Empty;
        shoppingBasket.CurrencyCode = currencyCode;
        shoppingBasket.PaymentProviderId = aProvider;
        shoppingBasket.MerchantAccountId = aMerchant;

        switch (TransactionDetails.PaymentType)
          {
          #region Payments
          // PKR. 22/07/2015. ABSEXCH-16683. EPP behaviour changed.
          //.......................................................................................
          case ExchequerTransaction.PaymentAction.Payment:                    // Normal Payment
            shoppingBasket.TransType = TransactionTypes.Payment;
            FillShoppingBasketHeader(TransactionDetails, ref shoppingBasket);

            FillShoppingBasket(TransactionDetails, ref shoppingBasket, true);
            break;

          //.......................................................................................
          case ExchequerTransaction.PaymentAction.PaymentAuthorisation:       // Payment against an Authentication
            shoppingBasket.TransType = TransactionTypes.Authorise;
            // This is required so that the EPP knows which Card Authentication transaction to work against.
            shoppingBasket.RelatedTransactionGuid = TransactionDetails.AuthenticationGUID;

#if DEBUG
            if (dbgForm != null)
              {
              dbgForm.Log("Payment Authorisation : GUID = " + shoppingBasket.RelatedTransactionGuid);
              }
#endif

            FillShoppingBasketHeader(TransactionDetails, ref shoppingBasket);
            // No need to populate the shopping basket items list

            // Temporarily added to see if it fixes a bug... (it didn't!)
            FillShoppingBasket(TransactionDetails, ref shoppingBasket, true);
            break;

          //.......................................................................................
          // PKR. 21/07/2015. ABSEXCH-16683.  EPP functionality changes.
          // Authorise Only has now been replaced by Card Authentication, and is handled as a transaction
          // Token-based actions are now obsolete. (hurrah!)
          case ExchequerTransaction.PaymentAction.CardAuthentication:
            shoppingBasket.TransType = TransactionTypes.Authenticate;

            FillShoppingBasketHeader(TransactionDetails, ref shoppingBasket);
            FillShoppingBasket(TransactionDetails, ref shoppingBasket, true);
            break;
          } // End switch (TransactionDetails.PaymentType)

        try
          {
          gatewayTransactionGuid = string.Empty;

          if (shoppingBasket.RefundReason == null)
            shoppingBasket.RefundReason = string.Empty;

#if DEBUG
          if (dbgForm != null)
            {
            dbgForm.Log("ShoppingBasket....");

            if (shoppingBasket == null)
              {
              dbgForm.Log("shoppingBasket is null!");
              }

            if (shoppingBasket.BillingAddressCountry == null)
              {
              dbgForm.Log("BillingAddressCountry is null!");
              }

            dbgForm.Log("BillingAddressCountry    : " + shoppingBasket.BillingAddressCountry);
            dbgForm.Log("BillingAddressCounty     : " + shoppingBasket.BillingAddressCounty);
            dbgForm.Log("BillingAddressLine1      : " + shoppingBasket.BillingAddressLine1);
            dbgForm.Log("BillingAddressLine2      : " + shoppingBasket.BillingAddressLine2);
            dbgForm.Log("BillingAddressPostcode   : " + shoppingBasket.BillingAddressPostcode);
            dbgForm.Log("BillingAddressTown       : " + shoppingBasket.BillingAddressTown);
            dbgForm.Log("ContactEmailAddress      : " + shoppingBasket.ContactEmailAddress);
            dbgForm.Log("ContactName              : " + shoppingBasket.ContactName);
            dbgForm.Log("ContactTelephone         : " + shoppingBasket.ContactTelephone);
            dbgForm.Log("CurrencyCode             : " + shoppingBasket.CurrencyCode);
            dbgForm.Log("CustomData               : " + shoppingBasket.CustomData);
            dbgForm.Log("DeliveryAddressCountry   : " + shoppingBasket.DeliveryAddressCountry);
            dbgForm.Log("DeliveryAddressCounty    : " + shoppingBasket.DeliveryAddressCounty);
            dbgForm.Log("DeliveryAddressLine1     : " + shoppingBasket.DeliveryAddressLine1);
            dbgForm.Log("DeliveryAddressLine2     : " + shoppingBasket.DeliveryAddressLine2);
            dbgForm.Log("DeliveryAddressPostcode  : " + shoppingBasket.DeliveryAddressPostcode);
            dbgForm.Log("DeliveryAddressTown      : " + shoppingBasket.DeliveryAddressTown);
            dbgForm.Log("ExternalAccountReference : " + shoppingBasket.ExternalAccountReference);
            dbgForm.Log("ExternalReceiptReference : " + shoppingBasket.ExternalReceiptReference);
            dbgForm.Log("MerchantAccountId        : " + shoppingBasket.MerchantAccountId.ToString());
            dbgForm.Log("PaymentProviderId        : " + shoppingBasket.PaymentProviderId.ToString());

            dbgForm.Log("RefundReason             : " + shoppingBasket.RefundReason);
            dbgForm.Log("RelatedTransactionGuid   : " + shoppingBasket.RelatedTransactionGuid);
            dbgForm.Log("SecurityKey              : " + shoppingBasket.SecurityKey);
            dbgForm.Log("TotalGrossCost           : " + shoppingBasket.TotalGrossCost.ToString());
            dbgForm.Log("TotalNetCost             : " + shoppingBasket.TotalNetCost.ToString());
            dbgForm.Log("TotalVATCost             : " + shoppingBasket.TotalVATCost.ToString());
            dbgForm.Log("TransactionGuid          : " + shoppingBasket.TransactionGuid);
            dbgForm.Log("TransType                : " + shoppingBasket.TransType.ToString());
            dbgForm.Log("YourReference            : " + shoppingBasket.YourReference);

            dbgForm.Log("Items : " + shoppingBasket.Items.Count.ToString());
            }
#endif

          // Register the payment
          // PKR. 06/02/2015. ABSEXCH-16153. Change to interface.
          eppcc.RegisterTransaction(authTicket, shoppingBasket, out gatewayTransactionGuid);
          // No longer retrieve the authTicket from the result.
          result.gatewayTransactionGuid = gatewayTransactionGuid;

#if DEBUG
          if (dbgForm != null)
            {
            dbgForm.Log("Transaction GUID from EPP = " + gatewayTransactionGuid);
            }
#endif
          result.IsError = false;
          }
        catch (AggregateException aggEx)
          {
          result.IsError = true;

          string bigMessage = "The following errors occurred calling Register Transaction\r\n";

          for (int index = 0; index < aggEx.InnerExceptions.Count; index++)
            {
            bigMessage += UnwindException(aggEx.InnerExceptions[index]) + "\r\n";
            }
#if DEBUG
          if (dbgForm != null)
            {
            dbgForm.Log("***AGG EX ***" + bigMessage);
            }
#endif

          throw new Exception(bigMessage);
          }
        catch (Exception Ex)
          {
          // PKR. 27/04/2015. ABSEXCH-16303. 
          // By the time the Exception reaches us, it can have a lot of wrappers, 
          // so we need to unwind all the wrappers to find the real message.
          string finalMessage = UnwindException(Ex);
#if DEBUG
          if (dbgForm != null)
            {
            dbgForm.Log("***UNWOUND***" + finalMessage);
            }
#endif
          throw new Exception(finalMessage);
          }

          #endregion Payments
        } // Currency is valid

      // Release to the GC.
      shoppingBasket = null;

      if (!result.IsError)
        {
        // Extract the results
        result.GatewayTransactionID = gatewayTransactionGuid;
        result.AuthorizationNumber = authTicket;
        result.ServiceResponse = "";
        }

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return result;
      }

    //=============================================================================================
    /// <summary>
    /// Sends a Refund Request to the Payment Portal.
    /// </summary>
    /// <param name="TransactionDetails"></param>
    /// <param name="RefundReason"></param>
    /// <returns></returns>
    public PaymentGatewayResponse ProcessRefund(ExchequerTransaction TransactionDetails, string RefundReason)
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }

#if DEBUG
      if (!disposed)
        {
#if TDEBUG
        if (dbgForm != null)
          {
          dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
          }
#endif
        if (dbgForm != null)
          {
          dbgForm.Log("<<<<=============== REFUND ===============>>>>");
          }
        }
#endif

      // PKR. 10/02/2015. Login to get an authTicket.
      Login();

      PaymentGatewayResponse result = new PaymentGatewayResponse();

      // Added under Graham Yorke's instruction to get it to connect to the Payment Portal.
      // This gets around the requirement to have this in the host app's app.config (which Delphi doesn't have)
      //   <system.net>
      //    <defaultProxy useDefaultCredentials="true"/>
      //  </system.net>
      System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

      ShoppingBasket shoppingBasket = new ShoppingBasket();
      // PKR. 29/07/2015. ABSEXCH-16703. Unable to process Credit Card Refunds.
      shoppingBasket.Items = new List<ShoppingBasketItem>();

      FillShoppingBasketHeader(TransactionDetails, ref shoppingBasket);

      if (FillShoppingBasket(TransactionDetails, ref shoppingBasket, false))
        {
        // Get the ISO-4217 Currency code that corresponds to the Exchequer currency symbol
        string currencyCode = config.GetISOCurrency(currentCompanyCode, TransactionDetails.CurrencySymbol);

        if (string.IsNullOrEmpty(currencyCode))
          {
          // No valid currency code was found
          MessageBox.Show(string.Format("Currency {0} not recognised as a valid ISO currency.\r\nPlease set up currency symbols on the configuration screen.", TransactionDetails.CurrencySymbol), "Invalid currency code");
          result.IsError = true;
          }
        else
          {
          shoppingBasket.CurrencyCode = currencyCode;

          shoppingBasket.TransType = TransactionTypes.Refund;
          // Refunds don't use a token, so clear the flag.
          // PKR. 21/07/2015. ABSEXCH-16683. Portal has changed to provide correct functionality.
          // Tokens are now obsolete.
          //          shoppingBasket.UseToken = false;

          shoppingBasket.RelatedTransactionGuid = (string.IsNullOrEmpty(TransactionDetails.DescendentTransactionReference) ? "" : TransactionDetails.DescendentTransactionReference);

          shoppingBasket.RefundReason = ((string.IsNullOrEmpty(RefundReason)) ? "" : RefundReason);

          try
            {
            gatewayTransactionGuid = string.Empty;

            // PKR. 06/02/2015. ABSEXCH-16153. Change to interface
            eppcc.RegisterTransaction(authTicket, shoppingBasket, out gatewayTransactionGuid);

            // Extract the results
            result.gatewayTransactionGuid = gatewayTransactionGuid;
            result.IsError = false;
            }
          // The Payment Portal puts a list of exceptions in AggregateException rather than Exception.
          catch (AggregateException aggEx)
            {
            result.IsError = true;

            String bigMessage = "The following errors occurred\r\n";

            for (int index = 0; index < aggEx.InnerExceptions.Count; index++)
              {
              bigMessage += UnwindException(aggEx.InnerExceptions[index]) + "\r\n";
              }
            MessageBox.Show(bigMessage, "Error registering transaction");
            }

          catch (Exception Ex)
            {
            // PKR. 27/04/2015. ABSEXCH-16303. 
            // By the time the Exception reaches us, it can have a lot of wrappers, 
            // so we need to unwind all the wrappers to find the real message.
            string finalMessage = UnwindException(Ex);
            throw new Exception(finalMessage);
            }
          }
        }
      else
        {
        result.IsError = true;
        throw new Exception("Process Refund : System error : Failed to create Shopping Basket");
        }

      // Release to the GC
      shoppingBasket = null;

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return result;
      }

    /// <summary>
    /// Unwinds Exceptions that are embedded in Exceptions to get the final error message
    /// </summary>
    /// <param name="Ex"></param>
    /// <returns></returns>
    private static string UnwindException(Exception Ex)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      string finalMessage = string.Empty;
      // PKR. 27/04/2015. ABSEXCH-16303. 
      // By the time the Exception reaches us, it can have a lot of wrappers, 
      // so we need to unwind all the wrappers to find the real message.
      Exception subEx = Ex;
      while (subEx.InnerException != null)
        {
        subEx = subEx.InnerException;
        }

      finalMessage = subEx.Message;
      if (string.IsNullOrEmpty(finalMessage))
        {
        finalMessage = "An unknown error occurred in the Payments Portal";
        }

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return finalMessage;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Create a new, empty shoppinig basket.
    /// </summary>
    /// <returns></returns>
    private void InitialiseShoppingBasket(ref ShoppingBasket oShoppingBasket)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      if (oShoppingBasket == null)
        {
#if DEBUG
        dbgForm.Log("InitialiseShoppingBasket : Shopping Basket is null");
#endif
        oShoppingBasket = new ShoppingBasket();
        }
      oShoppingBasket.BillingAddressCountry = string.Empty;
      oShoppingBasket.BillingAddressCounty = string.Empty;
      oShoppingBasket.BillingAddressLine1 = string.Empty;
      oShoppingBasket.BillingAddressLine2 = string.Empty;
      oShoppingBasket.BillingAddressPostcode = string.Empty;
      oShoppingBasket.BillingAddressTown = string.Empty;
      oShoppingBasket.ContactEmailAddress = string.Empty;
      oShoppingBasket.ContactName = string.Empty;
      oShoppingBasket.ContactTelephone = string.Empty;
      oShoppingBasket.CurrencyCode = string.Empty;
      oShoppingBasket.CustomData = string.Empty;
      oShoppingBasket.DeliveryAddressCountry = string.Empty;
      oShoppingBasket.DeliveryAddressCounty = string.Empty;
      oShoppingBasket.DeliveryAddressLine1 = string.Empty;
      oShoppingBasket.DeliveryAddressLine2 = string.Empty;
      oShoppingBasket.DeliveryAddressPostcode = string.Empty;
      oShoppingBasket.DeliveryAddressTown = string.Empty;
      oShoppingBasket.ExternalAccountReference = string.Empty;
      oShoppingBasket.ExternalReceiptReference = string.Empty;
      oShoppingBasket.MerchantAccountId = 0;
      oShoppingBasket.PaymentProviderId = 0;
      oShoppingBasket.RefundReason = string.Empty;
      oShoppingBasket.RelatedTransactionGuid = string.Empty;
      oShoppingBasket.SecurityKey = string.Empty;
      // PKR. 21/07/2015. ABSEXCH-16683. Portal has changed to provide correct functionality.
      // Tokens are now obsolete
      //      shoppingBasket.Token = string.Empty;
      oShoppingBasket.TotalGrossCost = 0.0M;
      oShoppingBasket.TotalNetCost = 0.0M;
      oShoppingBasket.TotalVATCost = 0.0M;
      oShoppingBasket.TransactionGuid = string.Empty;
      oShoppingBasket.YourReference = string.Empty;

      // Ensure that the list is created, even if it isn't populated, because the Portal complains otherwiase.
      oShoppingBasket.Items = new List<ShoppingBasketItem>();

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return;
      }

    //=============================================================================================
    /// <summary>
    /// Fills the shopping basket with transaction details
    /// </summary>
    /// <param name="TransactionDetails"></param>
    /// <param name="shoppingBasket"></param>
    private Boolean FillShoppingBasket(ExchequerTransaction TransactionDetails, ref ShoppingBasket shoppingBasket, bool isPayment)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      bool result = true;

      if (shoppingBasket != null)
        {
        decimal totalNet = 0.0M;
        decimal totalVAT = 0.0M;

        ExchequerPaymentGateway.ITransactionLine[] transLines = TransactionDetails.GetLines();

        int itemCount = 0;
        foreach (ExchequerPaymentGateway.ITransactionLine line in transLines)
          {
          // Don't need to populate Items if it's a refund.
          if (isPayment)
            {
            // Create a new Shopping Basket item
            ShoppingBasketItem item = new ShoppingBasketItem();

            // Copy the details from the transaction line to the shopping basket item
            item.ProductId = string.IsNullOrEmpty(line.StockCode) ? "" : line.StockCode;
            item.Description = string.IsNullOrEmpty(line.Description) ? "" : line.Description;
            item.Quantity = Convert.ToInt32(line.Quantity);              //  !!!!!! This will change to double in later Payment Portal assemblies.
            item.VatMultiplier = Math.Round(Convert.ToDecimal(line.VATMultiplier), 4);
            item.VatCode = string.IsNullOrEmpty(line.VATCode) ? "" : line.VATCode.Substring(0, 1);

            // PKR. 05/11/2014.  Added rounding to 2 decimal places, which was causing the Payment to fail (specifically the VAT amount).
            // In future, this might need changing to the number of decimal places set in Exchequer.
            item.LineNetPrice = Math.Round(Convert.ToDecimal(line.TotalNetValue), 2);
            item.LineVatPrice = Math.Round(Convert.ToDecimal(line.TotalVATValue), 2);

            item.UnitNetPrice = Convert.ToDecimal(line.UnitPrice);

            // Drop the item in the basket
            shoppingBasket.Items.Add(item);
            itemCount++;
            }

          // Need to get the totals whether it's a Payment or a Refund
          totalNet += Math.Round(Convert.ToDecimal(line.TotalNetValue), 2);
          totalVAT += Math.Round(Convert.ToDecimal(line.TotalVATValue), 2);
          }
        shoppingBasket.TotalNetCost = totalNet;
        shoppingBasket.TotalVATCost = totalVAT;
        shoppingBasket.TotalGrossCost = totalNet + totalVAT;
        }
      else
        {
        // The shopping basket is null, so fail.
        result = false;
        }

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    ///
    /// </summary>
    /// <param name="TransactionDetails"></param>
    /// <param name="shoppingBasket"></param>
    private bool FillShoppingBasketHeader(ExchequerTransaction TransactionDetails, ref ShoppingBasket shoppingBasket)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      bool result = false;

      if (shoppingBasket != null)
        {
        // Header fields
        shoppingBasket.YourReference = string.IsNullOrEmpty(TransactionDetails.SalesOrderReference) ? "" : TransactionDetails.SalesOrderReference;

        shoppingBasket.ContactName = string.IsNullOrEmpty(TransactionDetails.ContactName) ? "" : TransactionDetails.ContactName;
        shoppingBasket.ContactTelephone = string.IsNullOrEmpty(TransactionDetails.ContactPhone) ? "" : TransactionDetails.ContactPhone;
        shoppingBasket.ContactEmailAddress = string.IsNullOrEmpty(TransactionDetails.ContactEmail) ? "" : TransactionDetails.ContactEmail;

        shoppingBasket.BillingAddressLine1 = string.IsNullOrEmpty(TransactionDetails.BillingAddress1) ? "" : TransactionDetails.BillingAddress1;
        shoppingBasket.BillingAddressLine2 = string.IsNullOrEmpty(TransactionDetails.BillingAddress2) ? "" : TransactionDetails.BillingAddress2;
        shoppingBasket.BillingAddressTown = string.IsNullOrEmpty(TransactionDetails.BillingAddress3_Town) ? "" : TransactionDetails.BillingAddress3_Town;
        shoppingBasket.BillingAddressCounty = string.IsNullOrEmpty(TransactionDetails.BillingAddress4_County) ? "" : TransactionDetails.BillingAddress4_County;
        shoppingBasket.BillingAddressCountry = string.IsNullOrEmpty(TransactionDetails.BillingAddress_Country) ? "" : TransactionDetails.BillingAddress_Country;
        shoppingBasket.BillingAddressPostcode = string.IsNullOrEmpty(TransactionDetails.BillingAddressPostCode) ? "" : TransactionDetails.BillingAddressPostCode;

        // If the Delivery Address fields are empty, use the Billing Address fields
        if (string.IsNullOrEmpty(TransactionDetails.DeliveryAddress1))
          {
          shoppingBasket.DeliveryAddressLine1 = TransactionDetails.BillingAddress1;
          shoppingBasket.DeliveryAddressLine2 = TransactionDetails.BillingAddress2;
          shoppingBasket.DeliveryAddressTown = TransactionDetails.BillingAddress3_Town;
          shoppingBasket.DeliveryAddressCounty = TransactionDetails.BillingAddress4_County;
          shoppingBasket.DeliveryAddressCountry = TransactionDetails.BillingAddress_Country;
          shoppingBasket.DeliveryAddressPostcode = TransactionDetails.BillingAddressPostCode;
          }
        else
          {
          shoppingBasket.DeliveryAddressLine1 = string.IsNullOrEmpty(TransactionDetails.DeliveryAddress1) ? "" : TransactionDetails.DeliveryAddress1;
          shoppingBasket.DeliveryAddressLine2 = string.IsNullOrEmpty(TransactionDetails.DeliveryAddress2) ? "" : TransactionDetails.DeliveryAddress2;
          shoppingBasket.DeliveryAddressTown = string.IsNullOrEmpty(TransactionDetails.DeliveryAddress3_Town) ? "" : TransactionDetails.DeliveryAddress3_Town;
          shoppingBasket.DeliveryAddressCounty = string.IsNullOrEmpty(TransactionDetails.DeliveryAddress4_County) ? "" : TransactionDetails.DeliveryAddress4_County;
          shoppingBasket.DeliveryAddressCountry = string.IsNullOrEmpty(TransactionDetails.DeliveryAddress_Country) ? "" : TransactionDetails.DeliveryAddress_Country;
          shoppingBasket.DeliveryAddressPostcode = string.IsNullOrEmpty(TransactionDetails.DeliveryAddressPostCode) ? "" : TransactionDetails.DeliveryAddressPostCode;
          }

        // These are used for the forthcoming Data Recovery feature and will be used elsewhere.
        shoppingBasket.CustomData = ""; // Will be populated later
        shoppingBasket.ExternalAccountReference = TransactionDetails.ExchequerCompanyCode;
        shoppingBasket.ExternalReceiptReference = "";  // Not used here

        // PKR. 30/1/2015. ABSEXCH-16101. Removed code that sets the Sagepay test Address line and postcode.
        result = true;
        }

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return result;
      }

    //=============================================================================================
    /// <summary>
    /// Displays the Credit Card Add-in Configuration Form
    /// </summary>
    /// <returns></returns>
    public DialogResult DisplayConfigurationDialog(int hWnd, string aCompany, string aUserId, bool aIsSuperUser = false)
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      userID = aUserId;

      // Create a configuration form
      ConfigurationForm configForm = new ConfigurationForm(tkw.tToolkit, config, aCompany, eppcc, userID, aIsSuperUser);
      configForm.StartPosition = FormStartPosition.Manual;
      configForm.dbgForm = dbgForm;

      // Get the parent handle.
      IntPtr hWin = new IntPtr(hWnd);

      Cursor.Current = Cursors.Default;

      // PKR. 02/12/2014.
      // If the parent handle is not null, then calculate the position of the form
      //  so that it is centred on the parent.
      if ((hWin != null) && (hWnd != 0))
        {
        RECT exchRect = new RECT();
        GetWindowRect(hWin, out exchRect);

        int cfgFormWidth = configForm.Size.Width;
        int cfgFormHeight = configForm.Size.Height;

        int exchWidth = exchRect.Right - exchRect.Left;
        int exchHeight = exchRect.Bottom - exchRect.Top;

        int destLeft = exchRect.Left + (exchWidth - cfgFormWidth) / 2;
        int destTop = exchRect.Top + (exchHeight - cfgFormHeight) / 2;

        configForm.Location = new System.Drawing.Point(destLeft, destTop);
        }

      // Display the configuration form modally
      DialogResult Result = configForm.ShowDialog();

      // Reload the configuration to make sure it reflects the current config file.
      // If the user clicked Update, but then cancelled, the config object in memory won't necessarily match the saved file.
      // PKR. 02/04/2015. ABSEXCH-16303. (?)
      config.Load(configFilename);

      // Finished with the form, so dispose of it.
      configForm.dbgForm = null;
      configForm.Dispose();
      configForm = null;

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Get Payment Defaults based on the UDF field containing the source of the SOR
    /// </summary>
    /// <param name="GLCode"></param>
    /// <param name="Provider"></param>
    /// <param name="MerchantID"></param>
    /// <param name="UDF5"></param>
    /// <param name="UDF6"></param>
    /// <param name="UDF7"></param>
    /// <param name="UDF8"></param>
    /// <param name="UDF9"></param>
    /// <param name="UDF10"></param>
    /// <returns></returns>
    public bool GetPaymentDefaults(out int GLCode,
                                   out long ProviderID,
                                   out long MerchantAccID,
                                   out string CostCentre,
                                   out string Department,
                                   string UDF5, string UDF6, string UDF7,
                                   string UDF8, string UDF9, string UDF10)
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      bool result = false;

      int lGLCode = 0;
      long lProviderID = 0;
      long lMerchantAccID = 0;
      string lCostCentre = "";
      string lDepartment = "";
      string lProviderDescription = "";

      result = GetPaymentDefaultsEx(out lGLCode, out lProviderID, out lMerchantAccID, out lCostCentre,
                                    out lDepartment, out lProviderDescription,
                                    UDF5, UDF6, UDF7, UDF8, UDF9, UDF10);

      GLCode = lGLCode;
      ProviderID = lProviderID;
      MerchantAccID = lMerchantAccID;
      CostCentre = lCostCentre;
      Department = lDepartment;

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Get Payment Defaults with additional Provider Description
    /// </summary>
    /// <param name="GLCode"></param>
    /// <param name="ProviderID"></param>
    /// <param name="MerchantAccID"></param>
    /// <param name="CostCentre"></param>
    /// <param name="Department"></param>
    /// <param name="ProviderDescription"></param>
    /// <param name="UDF5"></param>
    /// <param name="UDF6"></param>
    /// <param name="UDF7"></param>
    /// <param name="UDF8"></param>
    /// <param name="UDF9"></param>
    /// <param name="UDF10"></param>
    /// <returns></returns>
    public Boolean GetPaymentDefaultsEx(out int GLCode,
                                        out long ProviderID,
                                        out long MerchantAccID,
                                        out string CostCentre,
                                        out string Department,
                                        out string ProviderDescription,
                                        string UDF5, string UDF6, string UDF7,
                                        string UDF8, string UDF9, string UDF10)
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      bool result = false;

      string MerchantAccountCode;
      string PaymentProviderDescription;

      // Default values in case we don't find the source we're looking for
      GLCode = 0;
      MerchantAccID = 0;
      ProviderID = 0;
      CostCentre = string.Empty;
      Department = string.Empty;
      ProviderDescription = string.Empty;

      Cursor.Current = Cursors.WaitCursor;

#if DEBUG
      dbgForm.Log("GPDEx: Looking for " + currentCompanyCode);
#endif

      // Find the configured UDF field for the current company
      CompanyConfig thisCompany = null;
      foreach (CompanyConfig company in config.companies)
        {
        if (company.code.ToUpper().Trim() == currentCompanyCode.ToUpper().Trim())
          {
          thisCompany = company;
          break;
          }
        }

      string UDFSourceName = string.Empty;

      if (thisCompany != null)
        {
        // Found the company

        // ABSEXCH-16003. PKR. 08/01/2015. MerchantAccountIds can change without notice.
        // Instead of relying on potentially out-of-date config data, we need to get the
        // Merchant Account data from the Portal.
        System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

        // If we don't have an auth ticket, log in to get one.
        if (string.IsNullOrEmpty(authTicket))
          {
          Login();
          }

        try
          {
#if DEBUG
          dbgForm.Log("Calling GetCompanyMerchantAccounts for " + thisCompany.code);
#endif
          // Populate the Company Merchants Accounts list from the EPP during first run only.
          // This saves having to repeatedly contact the EPP for data that very rarely changes.
          if (companyMerchantAccsList == null)
            {
            eppcc.GetCompanyMerchantAccounts(authTicket, thisCompany.code, out companyMerchantAccsList);
            }

          // Get the configured UDF
          int indexUDF = thisCompany.sourceUDF;
          // now get the value from the passed-in UDF
          switch (indexUDF)
            {
            // ABSEXCH-16170. PKR. 17/02/2015. Added Trim to ensure no whitespace in empty fields.
            // Set ToUpper to make case-insensitive comparison.
            case 5: UDFSourceName = string.IsNullOrEmpty(UDF5) ? UDF5 : UDF5.Trim().ToUpper(); break;
            case 6: UDFSourceName = string.IsNullOrEmpty(UDF6) ? UDF6 : UDF6.Trim().ToUpper(); break;
            case 7: UDFSourceName = string.IsNullOrEmpty(UDF7) ? UDF7 : UDF7.Trim().ToUpper(); break;
            case 8: UDFSourceName = string.IsNullOrEmpty(UDF8) ? UDF8 : UDF8.Trim().ToUpper(); break;
            case 9: UDFSourceName = string.IsNullOrEmpty(UDF9) ? UDF9 : UDF9.Trim().ToUpper(); break;
            case 10: UDFSourceName = string.IsNullOrEmpty(UDF10) ? UDF10 : UDF10.Trim().ToUpper(); break;
            } // switch indexUDF

          SourceConfig thisSource = null;

#if DEBUG
          dbgForm.Log("Looking for source " + UDFSourceName);
#endif

          // Now look through the sources to get the default data from the configuration
          foreach (SourceConfig source in thisCompany.sources)
            {
            // Make upper case and trim wihitespace for reliable, case-insensitive comparison.
            string thisSourceName = source.name.Trim().ToUpper();

            // ABSEXCH-15954. PKR. 02/01/2015. Check for null source name
            // ABSEXCH-16170. PKR. 17/02/2015. Added Trim to ensure no whitespace in empty fields.
            if (
                ((string.IsNullOrEmpty(thisSourceName)) && (string.IsNullOrEmpty(UDFSourceName))) ||
                (thisSourceName == UDFSourceName)
               )
              {
              // Found the source
#if DEBUG
              dbgForm.Log("Found the source");
#endif
              thisSource = source;

              // Found the source, so get the details
              // Get the Exchequer-specific details from the configuration data
              GLCode = Convert.ToInt16(thisSource.glCode);
              CostCentre = (string.IsNullOrEmpty(thisSource.costCentre) ? "" : thisSource.costCentre);
              Department = (string.IsNullOrEmpty(thisSource.department) ? "" : thisSource.department);

              // Get the portal-specific details from Portal data.

#if DEBUG
              if (dbgForm != null)
                {
                dbgForm.Log("Looking for MerchantAccountId etc");
                }
#endif
              // ABSEXCH-16003. PKR. 08/01/2015. MerchantAccountIds can change without notice.
              // Key on the MerchantAccountCode (which never changes)
              MerchantAccountCode = thisSource.merchantAccount.MerchantAccountCode.Trim().ToUpper();
              PaymentProviderDescription = thisSource.merchantAccount.PaymentProviderDescription.Trim().ToUpper();

              // Use it to look up the MerchantAccountId and PaymentProviderId from the returned data
              foreach (GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount coMerchAcc in companyMerchantAccsList)
                {
                if ((coMerchAcc.MerchantAccountCode.Trim().ToUpper() == MerchantAccountCode) &&
                    (coMerchAcc.PaymentProviderDescription.Trim().ToUpper() == PaymentProviderDescription))
                  {
#if DEBUG
                  if (dbgForm != null)
                    {
                    dbgForm.Log("Found the MerchantAccount data");
                    }
#endif
                  // Found it, so pick up the associated details
                  MerchantAccID = coMerchAcc.MerchantAccountId;
                  ProviderID = coMerchAcc.PaymentProviderId;
                  ProviderDescription = coMerchAcc.PaymentProviderDescription;
                  break;
                  }
                } // foreach merchant account

              result = true;

              break;
              }
            } // for each source
          }
        catch (Exception ex)
          {
          // If this happens, it could be that the transaction has been cancelled,
          // so the AuthTicket has been logged out.
          // Exchequer needs to know this, so it can get a new AuthTicket.

          var messageText = ex.Message;
          if (ex.InnerException != null)
            {
            if (!string.IsNullOrEmpty(ex.InnerException.Message))
              {
              messageText = string.Format("{0} : {1}", messageText, ex.InnerException.Message);
              }
            }
          result = true;
          }
        } // company is not null
      else
        {
#if DEBUG
        dbgForm.Log("Didn't find company " + currentCompanyCode);
#endif
        }
      Cursor.Current = Cursors.Default;

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Returns true if credit cards are enabled for the specified company
    /// </summary>
    /// <param name="aCompanyCode"></param>
    /// <returns></returns>
    public Boolean IsCCEnabledForCompany(string aCompanyCode)
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      Boolean Result = config.IsCCEnabledForCompany(aCompanyCode);

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    //    public PaymentGatewayResponse GetTransactionStatus(string aTransAuthTicket, string aTransVendorTx)
    public PaymentGatewayResponse GetTransactionStatus(string aTransactionGUID)
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      PaymentGatewayResponse response = new PaymentGatewayResponse();

      GatewayTransactionView transactionStatus;

      try
        {
        response.GatewayStatusId = -1;

        System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

        if (authTicket == string.Empty)
          {
          Login();
          }

        eppcc.CheckTransactionStatus(authTicket, aTransactionGUID, out transactionStatus);

#if DEBUG
        if (!disposed)
          {
          dbgForm.Log("\r\n ================ ");
          dbgForm.Log("==   RESPONSE   ==");
          dbgForm.Log(" ================ ");

          if (transactionStatus.IsError)
            {
            dbgForm.Log("Transaction Status           = Error");
            }
          else
            {
            dbgForm.Log("Transaction Status           = OK");
            }

          dbgForm.Log("ServiceResponse              = " + transactionStatus.ServiceResponse);
          //        dbgForm.Log("GatewayVendorCardType        = " + transactionStatus.GatewayVendorCardType);
          //        dbgForm.Log("GatewayVendorCardLast4Digits = " + transactionStatus.GatewayVendorCardLast4Digits);
          //        dbgForm.Log("GatewayVendorCardExpiryDate  = " + transactionStatus.GatewayVendorCardExpiryDate);
          dbgForm.Log("GatewayStatusId              = " + transactionStatus.GatewayStatusId);
          dbgForm.Log("GatewayVendorTxAuthNo        = " + transactionStatus.GatewayVendorTxAuthNo);
          dbgForm.Log("GatewayVendorTxCode          = " + transactionStatus.GatewayVendorTxCode);
          //        dbgForm.Log("GatewayVendorSecurityKey     = " + transactionStatus.GatewayVendorSecurityKey);
          //        dbgForm.Log("==================");
          }
#endif

        // Copy the fields that will be used by Exchequer
        response.IsError = transactionStatus.IsError;
        response.ServiceResponse = transactionStatus.ServiceResponse;
        response.GatewayVendorCardType = transactionStatus.GatewayVendorCardType;
        response.GatewayVendorCardLast4Digits = transactionStatus.GatewayVendorCardLast4Digits;
        response.GatewayVendorCardExpiryDate = transactionStatus.GatewayVendorCardExpiryDate;
        response.GatewayStatusId = transactionStatus.GatewayStatusId;
        response.GatewayVendorTxCode = transactionStatus.GatewayVendorTxCode;
        response.AuthorizationNumber = transactionStatus.GatewayVendorTxAuthNo;
        response.TransactionValue = Convert.ToDouble(transactionStatus.GatewayTransactionGrossAmount);

        // PKR. 09/02/2015. ABSEXCH-16153. New security model.
        // If the status is a terminating status (i.e. not pending), then log out the authTicket.
        if (response.GatewayStatusId != TRANS_STATUS_PENDING)
          {
          Logout();
          }
        }
      catch (Exception ex)
        {
        var messageText = ex.Message;
        if (ex.InnerException != null)
          {
          if (!string.IsNullOrEmpty(ex.InnerException.Message))
            {
            messageText = string.Format("{0} : {1}", messageText, ex.InnerException.Message);
            }
          }

        response.IsError = true;
        }

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return response;
      }

    //---------------------------------------------------------------------------------------------
    /*
        /// <summary>
        /// Request the Portal for the status of an Authorise Only request.
        /// </summary>
        /// <param name="aOurRef"></param>
        /// <returns>True if authorised</returns>
        public int GetTokenStatus(string aOurRef)
          {
          // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
          if (disposed)
            {
            throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
            }
    #if TDEBUG
          if (dbgForm != null)
            {
            dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
            }
    #endif

          int tokenStatus = -1;

          System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

          try
            {
            if (authTicket == string.Empty)
              {
              Login();
              }

            // PKR. 06/02/2015. ABSEXCH-16153. Change to interface.
            eppcc.CheckTokenStatus(authTicket, aOurRef, out tokenStatus);

            // If it's a terminating status, then log out the authTicket.
            if (tokenStatus != TRANS_STATUS_PENDING)
              {
              Logout();
              }

    #if DEBUG
            string msg = String.Format("tokenStatus {0}", tokenStatus);
            switch (tokenStatus)
              {
              case TRANS_STATUS_PENDING        : msg += " - Pending"; break;
              case TRANS_STATUS_SUCCESS        : msg += " - OK"; break;
              case TRANS_STATUS_NOT_AUTHORISED : msg += " - Not Authorised"; break;
              case TRANS_STATUS_ABORT          : msg += " - Aborted"; break;
              case TRANS_STATUS_REJECTED       : msg += " - Rejected"; break;
              case TRANS_STATUS_AUTHENTICATED  : msg += " - Authenticated"; break;
              case TRANS_STATUS_REGISTERED     : msg += " - Registered"; break;
              case TRANS_STATUS_ERROR          : msg += " - Error"; break;
              default: msg += " - Unexpected value"; break;
              }

            if (!disposed)
              dbgForm.Log(msg);
    #endif
            }
          catch (Exception ex)
            {
            var messageText = ex.Message;
            if (ex.InnerException != null)
              {
              if (!string.IsNullOrEmpty(ex.InnerException.Message))
                {
                messageText = string.Format("{0} : {1}", messageText, ex.InnerException.Message);
                }
              }
            messageText = messageText.Replace("One or more errors occurred. : ", string.Empty);
            //        MessageBox.Show(string.Format("An error was detected when attempting to retrieve token status.\r\n\r\n{0}", messageText), "Error Sending Request");
            }

    #if TDEBUG
          if (dbgForm != null)
            {
            dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
            }
    #endif
          return tokenStatus;
          }
    */

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Gets the Payment Portal status
    /// </summary>
    /// <returns></returns>
    public Boolean GetServiceStatus()
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      bool Result = false;

      // Added under Graham Yorke's instruction to get it to connect to the Payment Portal.
      System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

      try
        {
        // PKR. 06/02/2015. ABSEXCH-16153. Change to interface.
        eppcc.GetServiceStatus(out Result);
        }
      catch (AggregateException aggEx)
        {
        String bigMessage = "The following errors occurred calling Register Transaction\r\n";

        for (int index = 0; index < aggEx.InnerExceptions.Count; index++)
          {
          bigMessage += aggEx.InnerExceptions[index].Message + "\r\n";
          }
        MessageBox.Show(bigMessage, "Error calling GetServiceStatus");
        }
      catch (Exception Ex)
        {
        var messageText = Ex.Message;
        if (!string.IsNullOrEmpty(Ex.InnerException.Message))
          {
          messageText = string.Format("{0} : {1}\r\n\r\n", messageText, Ex.InnerException.Message);
          }
        messageText = messageText.Replace("One or more errors occurred. : ", string.Empty);
        MessageBox.Show(string.Format("An error occurred calling GetServiceStatus...\r\n\r\n{0}", messageText), "Error Sending Request");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Gets processed transactions from the Payment Portal
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="startDate"></param>
    /// <param name="endDate"></param>
    /// <param name="pageNumber"></param>
    /// <param name="response"></param>
    /// <returns></returns>
    public Boolean GetProcessedTransactionsByDateRange(DateTime startDate,
                                                       DateTime endDate,
                                                       int pageNumber,
                                                       out GatewayCOMObject.GatewayCOMClass.PagedTransactionResponse response)
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      Boolean Result = false;
      response = null;

      // Added under Graham Yorke's instruction to get it to connect to the Payment Portal.
      System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

      try
        {
        // Call the Payment Portal to get the data
        // PKR. 06/02/2015. ABSEXCH-16153. Change to interface.
        eppcc.GetProcessedTransactionsByDateRange(authTicket, startDate, endDate, pageNumber, out response);

        if (response != null)
          {
          // Set Result to true if there is at least one row of data.
          // TotalRowCount is the number of rows available within the specified time range.
          Result = (response.TotalRowCount > 0);
          }
        }
      catch (AggregateException aggEx)
        {
        String bigMessage = "The following errors occurred requesting transaction history\r\n";

        for (int index = 0; index < aggEx.InnerExceptions.Count; index++)
          {
          bigMessage += aggEx.InnerExceptions[index].Message + "\r\n";
          }
        MessageBox.Show(bigMessage, "Error getting transaction history");
        }
      catch (Exception Ex)
        {
        var messageText = Ex.Message;
        if (!string.IsNullOrEmpty(Ex.InnerException.Message))
          {
          messageText = string.Format("{0} : {1}\r\n\r\n", messageText, Ex.InnerException.Message);
          }
        messageText = messageText.Replace("One or more errors occurred. : ", string.Empty);
        MessageBox.Show(string.Format("An error occurred requesting transaction history...\r\n\r\n{0}", messageText), "Error getting transaction history");
        }

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Updates the transaction on the Payment Portal with the supplied customData
    /// </summary>
    /// <param name="gatewayTransactionGuid"></param>
    /// <param name="receiptReference"></param>
    /// <param name="customData"></param>
    /// <returns>0 if successful, 1 if error</returns>
    public int UpdateTransactionContent(string gatewayTransactionGuid,
                                         string receiptReference,
                                         string customData)
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      int Result = 0;

      // Added under Graham Yorke's instruction to get it to connect to the Payment Portal.
      System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

      try
        {
        try
          {
          // Get an authTicket so we can apply the update.
          // Note that after getting a terminating transaction status, we log out the original authTicket
          // because if the transaction was not successful, we won't be calling this method.
          // So, we simply log in again and get a new authTicket.
          Login();

          // Send the update to the Portal
          // PKR. 06/02/2015. ABSEXCH-16153. Change to interface.
          eppcc.UpdateTransactionContent(authTicket, gatewayTransactionGuid, receiptReference, customData);

          // PKR. 15/01/2015. According to Graham Yorke, if no exception is raised by UpdateTransactionContent
          //  then the Portal has successfully received and applied the update, so we need no return value.
          }
        finally
          {
          Logout();
          }
        }
      catch (AggregateException aggEx)
        {
        String bigMessage = "The following errors occurred updating transaction content\r\n";

        for (int index = 0; index < aggEx.InnerExceptions.Count; index++)
          {
          bigMessage += aggEx.InnerExceptions[index].Message + "\r\n";
          }
        MessageBox.Show(bigMessage, "Error updating transaction content");
        Result = 1;
        }
      catch (Exception Ex)
        {
        var messageText = Ex.Message;
        if (!string.IsNullOrEmpty(Ex.InnerException.Message))
          {
          messageText = string.Format("{0} : {1}\r\n\r\n", messageText, Ex.InnerException.Message);
          }
        messageText = messageText.Replace("One or more errors occurred. : ", string.Empty);
        MessageBox.Show(string.Format("An error occurred updating transaction content...\r\n\r\n{0}", messageText), "Error updating transaction content");
        Result = 1;
        }

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return Result;
      }

    // PKR. 30/1/2015. ABSEXCH-16077.
    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Allows a transaction to be cancelled in the Portal
    /// </summary>
    /// <param name="aTransactionGUID"></param>
    public void CancelTransaction(string aTransactionGUID)
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

      try
        {
        // PKR. 06/02/2015. ABSEXCH-16153. Change to interface.
        eppcc.CancelTransaction(authTicket, aTransactionGUID);
        }
      catch (AggregateException aggEx)
        {
        string bigMessage = "The following errors occurred requesting transaction history\r\n";

        for (int index = 0; index < aggEx.InnerExceptions.Count; index++)
          {
          bigMessage += aggEx.InnerExceptions[index].Message + "\r\n";
          }
        MessageBox.Show(bigMessage, "Error getting transaction history");
        }
      catch (Exception Ex)
        {
        var messageText = Ex.Message;
        if (!string.IsNullOrEmpty(Ex.InnerException.Message))
          {
          messageText = string.Format("{0} : {1}\r\n\r\n", messageText, Ex.InnerException.Message);
          }
        messageText = messageText.Replace("One or more errors occurred. : ", string.Empty);
        MessageBox.Show(string.Format("An error occurred requesting transaction history...\r\n\r\n{0}", messageText), "Error getting transaction history");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Log in to the Portal to get an authTicket.
    /// </summary>
    /// <returns></returns>
    public void Login()
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      authTicket = string.Empty;

      System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

      GatewayCOMObject.GatewayCOMClass.Credentials credentials = new GatewayCOMObject.GatewayCOMClass.Credentials();
      credentials.Company = currentCompanyCode;
      credentials.Password = config.password;
      credentials.SiteIdentifier = config.siteIdentifier;

      try
        {
        try
          {
          eppcc.Login(credentials, out authTicket);
          }
        catch (Exception ex)
          {
#if DEBUG
          if (dbgForm != null)
            {
            dbgForm.Log("Error logging in to EPP : " + ex.Message);
            }
#endif
          throw;
          }
        }
      finally
        {
        credentials = null;
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Logs out the current authTicket.
    /// </summary>
    public bool Logout()
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      bool Result = false;

      if (authTicket != string.Empty)
        {
        try
          {
          System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

          // CJS 2015-08-07 - ABSEXCH-16466 - Payment Portal error after completing process
          // Added retry, using new TryLogout method on the COM Client

          // Set up the 'retry' parameters
          int maxRetries = 10;
          int retryInterval = 1000;
          int retryCount = 0;

          bool done = false;
          bool loggedOut = false;
          while (!done)
            {
            loggedOut = eppcc.TryLogout(authTicket);
            if (!loggedOut)
              {
              if (retryCount < maxRetries)
                {
                Thread.Sleep(retryInterval);
                retryCount++;
                }
              else
                {
                // Give up and hope for the best...
                done = true;
                }
              }
            else
              {
              // PKR. 19/08/2015. This bit was missing, so it never quit the loop if TryLogout succeeded.
              // Logged out so quit
              done = true;
              }
            }
#if DEBUG
          dbgForm.Log(string.Format("Logout Retries : {0}", retryCount));
#endif
          authTicket = string.Empty;
          Result = true;
          }
        catch
          {
          // Sink the exception.  The authTicket will naturally expire after 15 minutes if it still exists.
          }
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Allows the handle of the parent window to be passed in
    /// </summary>
    /// <param name="hWnd"></param>
    public Boolean SetParentHandle(int hWnd)
      {
      // PKR. 29/04/2015. ABSEXCH-16215. Free resources so that Toolkit doesn't stay in memory
      if (disposed)
        {
        throw new Exception("Cannot use Credit Card Add-in after calling FreeResources");
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      ParentWindowHandle = (IntPtr)hWnd;

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return true;
      }

    }
  }