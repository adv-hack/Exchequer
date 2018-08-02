using System;
using System.Runtime.InteropServices;

namespace ExchequerPaymentGateway
  {
  /// <summary>
  /// Interface for default payment information
  /// </summary>
  [Guid("522B9B05-D665-4340-8818-70547275898A")]
  [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
  [ComVisible(true)]
  public interface IPaymentDefaultInformation
    {
    bool Result { get; set; }

    string DefaultPaymentProvider { get; set; }

    string DefaultMerchantID { get; set; }

    Int16 DefaultGLCode { get; set; }

    string DefaultCostCentre { get; set; } // PKR. Added 06/08/2014

    string DefaultDepartment { get; set; } // PKR. Added 06/08/2014
    }

  /// <summary>
  /// Class that implements the default payment information
  /// </summary>
  [Guid("8EA84189-D7BA-4D3A-91C1-FC8147385FCD")]
  [ClassInterface(ClassInterfaceType.None)]
  [ProgId("ExchequerPaymentGateway.PaymentDefaultInformation")]
  [ComVisible(true)]
  public class PaymentDefaultInformation : IPaymentDefaultInformation
    {
    public bool Result { get; set; }

    public string DefaultPaymentProvider { get; set; }

    public string DefaultMerchantID { get; set; }

    public Int16 DefaultGLCode { get; set; }

    public string DefaultCostCentre { get; set; } // PKR. Added 06/08/2014

    public string DefaultDepartment { get; set; } // PKR. Added 06/08/2014
    }
  }