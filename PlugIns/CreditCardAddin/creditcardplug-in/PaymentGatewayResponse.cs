using System;
using System.Runtime.InteropServices;

namespace ExchequerPaymentGateway
  {
  [Guid("C523B87C-F41E-4DD1-A2D0-B482C1424995")]
  [InterfaceType(ComInterfaceType.InterfaceIsDual)]
  [ComVisible(true)]
  public interface IPaymentGatewayResponse
    {
    string SalesOrderReference { get; set; }

    string DescendentTransactionReference { get; set; }

    string authTicket { get; set; }

    string gatewayTransactionGuid { get; set; }

    int GatewayStatusId { get; set; }

    string GatewayTransactionID { get; set; }

    string GatewayVendorTxCode { get; set; }

    string ServiceResponse { get; set; }

    bool IsError { get; set; }

    string GatewayVendorCardType { get; set; }

    string GatewayVendorCardLast4Digits { get; set; }

    string GatewayVendorCardExpiryDate { get; set; }

    string AuthorizationNumber { get; set; }

    string GUIDReference { get; set; }

    bool MultiplePayment { get; set; }

    double TransactionValue { get; set; }
    }

  [Guid("1304F2F5-1C2F-4916-BB90-232F9C43845E")]
  [ClassInterface(ClassInterfaceType.None)]
  [ProgId("ExchequerPaymentGateway.PaymentGatewayResponse")]
  [ComVisible(true)]
  public class PaymentGatewayResponse : IPaymentGatewayResponse
    {
    public string SalesOrderReference { get; set; }

    public string DescendentTransactionReference { get; set; }

    public string authTicket { get; set; }

    public string gatewayTransactionGuid { get; set; }

    public int GatewayStatusId { get; set; }

    public string GatewayTransactionID { get; set; }

    public string GatewayVendorTxCode { get; set; }

    public string ServiceResponse { get; set; }

    public bool IsError { get; set; }

    public string GatewayVendorCardType { get; set; }

    public string GatewayVendorCardLast4Digits { get; set; }

    public string GatewayVendorCardExpiryDate { get; set; }

    public string AuthorizationNumber { get; set; }

    public string GUIDReference { get; set; }

    public bool MultiplePayment { get; set; }

    public double TransactionValue { get; set; }
    }
  }