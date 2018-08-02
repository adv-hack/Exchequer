using System;

namespace HMRCFilingService
  {
  public class VAT100Record
    {
    public string correlationID;
    public string IRMark;
    public string dateSubmitted;
    public string documentType;
    public string VATPeriod;
    public string username;
    public short status;
    public int pollingInterval;
    public double VATDueOnOutputs;
    public double VATDueOnECAcquisitions;
    public double VATTotal;
    public double VATReclaimedOnInputs;
    public double VATNet;
    public double netSalesAndOutputs;
    public double netPurchasesAndInputs;
    public double netECSupplies;
    public double netECAcquisitions;
    public string hmrcNarrative;
    public string notifyEmail;
    public string PollingURL;
    public DateTime dateCreated;
    public DateTime dateModified;
    public int positionId;

    /// <summary>
    /// Constructor
    /// </summary>
    public VAT100Record()
      {
      correlationID = string.Empty;
      IRMark = string.Empty;
      dateSubmitted = string.Empty;
      documentType = string.Empty;
      VATPeriod = string.Empty;
      username = string.Empty;
      status = 0;
      pollingInterval = 0;
      VATDueOnOutputs = 0.0;
      VATDueOnECAcquisitions = 0.0;
      VATTotal = 0.0;
      VATReclaimedOnInputs = 0.0;
      VATNet = 0.0;
      netSalesAndOutputs = 0.0;
      netPurchasesAndInputs = 0.0;
      netECSupplies = 0.0;
      netECAcquisitions = 0.0;

      // PKR. 16/09/2015. ABSEXCH-16865. Remove spurious 'a' character from record
      // (Was originally there for debugging)
      // It's a non-null field, so use space instead.
      hmrcNarrative = " ";

      notifyEmail = string.Empty;
      PollingURL = string.Empty;
      dateCreated = DateTime.Now;
      dateModified = dateCreated;
      positionId = 0;
      }
    }
  }