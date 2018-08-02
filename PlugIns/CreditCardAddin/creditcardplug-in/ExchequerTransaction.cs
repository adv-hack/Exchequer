namespace ExchequerPaymentGateway
  {
  using System;
  using System.Collections.Generic;
  using System.Runtime.InteropServices;

  [Guid("A99DE27C-C762-4947-BFB3-7C1F41FDAAD4")]
  // This was InterfaceisDispatch, but that meant that data was readonly from Exchequer's end.
  [InterfaceType(ComInterfaceType.InterfaceIsDual)]
  [ComVisible(true)]
  public interface IExchequerTransaction
    {
    string ExchequerCompanyCode { get; set; }
    string SalesOrderReference { get; set; }
    string DescendentTransactionReference { get; set; }
    string ContactName { get; set; }
    string ContactPhone { get; set; }
    string ContactEmail { get; set; }
    string DeliveryAddress1 { get; set; }
    string DeliveryAddress2 { get; set; }
    string DeliveryAddress3_Town { get; set; }
    string DeliveryAddress4_County { get; set; }
    string DeliveryAddress_Country { get; set; }
    string DeliveryAddressPostCode { get; set; }
    string BillingAddress1 { get; set; }
    string BillingAddress2 { get; set; }
    string BillingAddress3_Town { get; set; }
    string BillingAddress4_County { get; set; }
    string BillingAddress_Country { get; set; }
    string BillingAddressPostCode { get; set; }

    ExchequerPaymentGateway.ExchequerTransaction.PaymentAction PaymentType { get; set; }
    bool FullAmount { get; set; }
    string CurrencySymbol { get; set; }
    int CurrencyCode { get; set; }
    double NetTotal { get; set; }
    double VATTotal { get; set; }
    double GrossTotal { get; set; }
    string PaymentReference { get; set; }
    string DefaultPaymentProvider { get; set; }
    string DefaultMerchantID { get; set; }
    // PKR. 28/07/2015. ABSEXCH-16683. Changes made to EPP regarding card authentication/authorisation
    string AuthenticationGUID { get; set; } // Required for payments against an authenticated card.

    void AddLine(TransactionLine line);

    [return: MarshalAs(UnmanagedType.SafeArray, SafeArraySubType = VarEnum.VT_DISPATCH, SafeArrayUserDefinedSubType = typeof(TransactionLine))]
    ITransactionLine[] GetLines();
    }

  /// <summary>
  /// Exchequer Transaction.  Used to get data from Exchequer to put in the Shopping Basket object.
  /// Seen by Delphi (from the type library) as IExchequerTransaction, which is mapped to ExchequerTransaction.
  /// </summary>
  [Guid("F87B9216-FCCD-4FC8-B0AB-77FA787D00AD")]
  [ClassInterface(ClassInterfaceType.None)]
  [ProgId("ExchequerPaymentGateway.ExchequerTransaction")]
  [ComVisible(true)]
  public class ExchequerTransaction : IExchequerTransaction
    {
    private IList<TransactionLine> lines = new List<TransactionLine>();

    [ComVisible(true)]
    public enum PaymentAction
      {
      Payment = 0,
      CardAuthentication = 1,
      PaymentAuthorisation = 2,
      Refund = 3
      }

    public string ExchequerCompanyCode { get; set; }
    public string SalesOrderReference { get; set; }
    public string DescendentTransactionReference { get; set; }
    public string ContactName { get; set; }
    public string ContactPhone { get; set; }
    public string ContactEmail { get; set; }
    public string DeliveryAddress1 { get; set; }
    public string DeliveryAddress2 { get; set; }
    public string DeliveryAddress3_Town { get; set; }
    public string DeliveryAddress4_County { get; set; }
    public string DeliveryAddress_Country { get; set; }
    public string DeliveryAddressPostCode { get; set; }
    public string BillingAddress1 { get; set; }
    public string BillingAddress2 { get; set; }
    public string BillingAddress3_Town { get; set; }
    public string BillingAddress4_County { get; set; }
    public string BillingAddress_Country { get; set; }
    public string BillingAddressPostCode { get; set; }

    public PaymentAction PaymentType { get; set; }
    public bool FullAmount { get; set; }
    public string CurrencySymbol { get; set; }
    public int CurrencyCode { get; set; }
    public double NetTotal { get; set; }
    public double VATTotal { get; set; }
    public double GrossTotal { get; set; }
    public string PaymentReference { get; set; }
    public string DefaultPaymentProvider { get; set; }
    public string DefaultMerchantID { get; set; }
    // PKR. 28/07/2015. ABSEXCH-16683. Changes made to EPP regarding card authentication/authorisation
    public string AuthenticationGUID { get; set; } // Required for payments against an authenticated card.

    /// <summary>
    /// Constructor
    /// </summary>
    public ExchequerTransaction()
      {
      }

    public void AddLine(TransactionLine line)
      {
      this.lines.Add(line);
      }

    public ITransactionLine[] GetLines()
      {
      ITransactionLine[] arrayofline = new ITransactionLine[this.lines.Count];
      for (int i = 0; i < this.lines.Count; i++)
        {
        arrayofline[i] = this.lines[i];
        }

      return arrayofline;
      }
    }
  }
