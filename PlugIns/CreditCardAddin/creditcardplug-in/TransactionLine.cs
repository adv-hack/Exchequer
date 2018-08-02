using System;
using System.Runtime.InteropServices;

namespace ExchequerPaymentGateway
  {
  [Guid("6EA13381-AAAB-47AD-AE3B-971059680A2A")]
  [InterfaceType(ComInterfaceType.InterfaceIsDual)]  // Was InterfaceIsDispatch
  [ComVisible(true)]
  public interface ITransactionLine
    {
    string Description { get; set; }

    string StockCode { get; set; } // PKR 17/09/21014 - used by the payment portal

    string VATCode { get; set; }   // PKR 17/09/21014 - used by the payment portal

    double Quantity { get; set; }

    double VATMultiplier { get; set; }

    double TotalNetValue { get; set; }

    double TotalVATValue { get; set; }

    double TotalGrossValue { get; set; }

    double UnitPrice { get; set; }

    double UnitDiscount { get; set; }

    double TotalDiscount { get; set; }
    }

  [Guid("47894B99-50BA-4DB3-8F28-772A7AAC970B")]
  [ClassInterface(ClassInterfaceType.None)]
  [ProgId("ExchequerPaymentGateway.TransactionLine")]
  [ComVisible(true)]
  public class TransactionLine : ITransactionLine
    {
    public string Description { get; set; }

    public string StockCode { get; set; } // PKR 17/09/21014 - used by the payment portal as ProductID

    public string VATCode { get; set; }   // PKR 17/09/21014 - used by the payment portal when displaying the shopping basket

    public double Quantity { get; set; }

    public double VATMultiplier { get; set; }

    public double TotalNetValue { get; set; }

    public double TotalVATValue { get; set; }

    public double TotalGrossValue { get; set; }

    public double UnitPrice { get; set; }

    public double UnitDiscount { get; set; }

    public double TotalDiscount { get; set; }
    }
  }