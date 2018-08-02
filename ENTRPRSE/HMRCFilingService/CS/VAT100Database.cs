using System;
using System.IO;
using DotNetLibrariesC.Toolkit;
using Enterprise04;
using EnterpriseBeta;
using System.Diagnostics;
using System.Reflection;

namespace HMRCFilingService
  {
  /// <summary>
  /// Handles access to the VAT100 tables, via the COM Toolkit.
  /// </summary>
  public class VAT100Database
    {
    public Enterprise04.IToolkit3 tToolkit;

    private static VAT100Database instance;

    private static string lastErrorString = string.Empty;

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Constructor - called only by Instance method.
    /// </summary>
    private VAT100Database()
      {
      lastErrorString = string.Empty;
      try
        {
        // Create the toolkit
#if DEBUG
        Logger.Log("VAT100Database : Creating COM Toolkit...");

//        string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
//        FileVersionInfo myFileVersionInfo = FileVersionInfo.GetVersionInfo(Path.Combine(path, "EntToolk.exe"));
//        Logger.Log("Toolkit version = " + myFileVersionInfo.FileVersion);
#endif
        tToolkit = new Enterprise04.Toolkit() as IToolkit3;
        if (tToolkit != null)
          {
#if DEBUG
          Logger.Log("VAT100Database : Opening Toolkit backdoor...");
#endif
          ctkDebugLog.StartDebugLog(ref tToolkit); // Backdoor the toolkit (renamed for obfuscation)
#if DEBUG
          Logger.Log("VAT100Database : ...backdoor opened");
#endif
          }
        else
          {
          lastErrorString = "VAT100Database : Failed to create COM Toolkit";
          Logger.Log(lastErrorString);
          }
        }
      catch (Exception ex)
        {
        lastErrorString = "VAT100Database exception : Failed to create COM Toolkit : \r\n  " + ex.Message;
        Logger.Log(lastErrorString);
        }
      }

    //---------------------------------------------------------------------------------------------
    ~VAT100Database()
      {
      if (instance != null)
        {
        instance.tToolkit = null;
        instance = null;
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Returns the Singleton instance of a VAT100Database
    /// </summary>
    public static VAT100Database Instance
      {
      get
        {
        if (instance == null)
          {
          // Doesn't exist, so create one
          instance = new VAT100Database();
          }
        return instance;
        }
      }

    // CJS 2016-06-06 - ABSEXCH-17494 - VAT submission returning HMRC message to wrong company.
    /// <summary>
    /// Returns a new instance of VAT100Database, for use when the singleton is not safe because
    /// of the danger of conflict (see PollingService.Add in PollingService.cs)
    /// </summary>
    /// <returns>VAT100Database</returns>
    public static VAT100Database GetNewInstance()
    {
        return new VAT100Database();
    }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Returns the last error message from the database handler.
    /// </summary>
    /// <returns></returns>
    public static string GetLastErrorString()
      {
      string Result = lastErrorString;
      lastErrorString = string.Empty;
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Returns the Company Path for the specified company. Returns a blank string if no matching
    /// company can be found.
    /// </summary>
    /// <param name="ForCompanyCode"></param>
    /// <returns></returns>
    public string GetCompanyPath(string ForCompanyCode)
      {
      Enterprise04.ICompanyDetail CompanyDetail = null;
      string path = string.Empty;
      string UNCpath = string.Empty;

      // Cycle through all the companies
      int CompanyCount = tToolkit.Company.cmCount;
      for (int i = 1; i <= CompanyCount; i++)
        {
        try
          {
          // Point the Toolkit at the company path (getPendingVAT100Entry will
          // open and close the Toolkit using this path)
          CompanyDetail = tToolkit.Company.get_cmCompany(i);

          if (ForCompanyCode == CompanyDetail.coCode)
            {
            path = CompanyDetail.coPath;

            // PKR. 18/09/2015. Only need to do this if it's the company we're looking for.
            // PKR. 14/09/2015. ABSEXCH-16839. Toolkit must be closed before changing the DataDirectory.
            if (tToolkit.Status == TToolkitStatus.tkOpen)
              {
              tToolkit.CloseToolkit();
              }

            tToolkit.Configuration.DataDirectory = CompanyDetail.coPath;

            // PKR. 14/09/2015.ABSEXCH-16839. Toolkit must be closed before changing the DataDirectory.
            tToolkit.OpenToolkit();

            break;
            }
          }
        catch
          {
          Log.Add(string.Format("An error occurred getting company path for {0} :\r\n{1}", CompanyDetail.coCode, tToolkit.LastErrorString));
          lastErrorString = tToolkit.LastErrorString;
          }
        }
      path = path.Trim();
      if (path == "")
        {
        lastErrorString = "Failed to find company path for " + ForCompanyCode;
        }
      return path;
      }


    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Returns the most recent pending VAT entry (there should only be 1)
    /// Returns null if no pending submissions
    /// </summary>
    /// <returns></returns>
    public VAT100Record GetPendingVAT100Entry(string ForCompanyCode)
      {
      int Res;

      // Create the return record
      VAT100Record theEntry = null;

      // Switch to the data path for the selected company
      string path = GetCompanyPath(ForCompanyCode);
      if (path == "")
        {
        return null;
        }

      // If the toolkit is open, close it so we can change the directory
      if (tToolkit.Status == TToolkitStatus.tkOpen)
        {
        tToolkit.CloseToolkit();
        }
      // Change the directory
      tToolkit.Configuration.DataDirectory = path;
      // Reopen the toolkit
      Res = tToolkit.OpenToolkit();

      // Database record
      IVAT100 oVAT100 = (tToolkit as ICSNFToolkit).VAT100;

      try
        {
        try
          {
          Res = oVAT100.GetFirst();
          while (Res == 0)
            {
            // See if it's the required record (submitted or pending status)
            if ((oVAT100.vatStatus == 1) || (oVAT100.vatStatus == 2))
              {
              // Found the record, so create a return object
              theEntry = new VAT100Record();

              theEntry.correlationID = oVAT100.vatCorrelationId;
              theEntry.IRMark = oVAT100.vatIRMark;
              theEntry.dateSubmitted = oVAT100.vatDateSubmitted;
              theEntry.documentType = oVAT100.vatDocumentType;
              theEntry.VATPeriod = oVAT100.vatPeriod;
              theEntry.username = oVAT100.vatUserName;
              theEntry.status = oVAT100.vatStatus;
              theEntry.pollingInterval = oVAT100.vatPollingInterval;
              theEntry.VATDueOnOutputs = oVAT100.vatDueOnOutputs;
              theEntry.VATDueOnECAcquisitions = oVAT100.vatDueOnECAcquisitions;
              theEntry.VATTotal = oVAT100.vatTotal;
              theEntry.VATReclaimedOnInputs = oVAT100.vatReclaimedOnInputs;
              theEntry.VATNet = oVAT100.vatNet;
              theEntry.netSalesAndOutputs = oVAT100.vatNetSalesAndOutputs;
              theEntry.netPurchasesAndInputs = oVAT100.vatNetPurchasesAndInputs;
              theEntry.netECSupplies = oVAT100.vatNetECSupplies;
              theEntry.netECAcquisitions = oVAT100.vatNetECAcquisition;
              theEntry.hmrcNarrative = oVAT100.vatHMRCNarrative;
              theEntry.notifyEmail = oVAT100.vatNotifyEmail;
              theEntry.PollingURL = oVAT100.vatPollingURL;

              break;
              }
            Res = oVAT100.GetNext();
            }
          }
        catch (Exception ex)
          {
          lastErrorString = ex.Message;
          }
        }
      finally
        {
        tToolkit.CloseToolkit();
        }

      return theEntry;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Adds a VAT100 record to the database
    /// </summary>
    /// <param name="aVATRecord"></param>
    /// <returns></returns>
    public int AddVAT100Entry(VAT100Record aVATRecord, string ForCompanyCode)
      {
      IVAT100 oVAT100 = null;
      int Res = -1;
#if DEBUG
      Log.Add(string.Format("Adding record for [{0}] :", ForCompanyCode));
      Log.Add(string.Format(" Correlation ID : [{0}]", aVATRecord.correlationID));
      Log.Add(string.Format(" HMRC Narrative : [{0}]", aVATRecord.hmrcNarrative));
#endif
      string path = GetCompanyPath(ForCompanyCode);
      if (path == "")
        {
        return 12; // File not found
        }
      // PKR. 15/09/2015. ABSEXCH-16839. Close toolkit before changing path.
      if (tToolkit.Status == TToolkitStatus.tkOpen)
        {
        tToolkit.CloseToolkit();
        }
      tToolkit.Configuration.DataDirectory = path;
      Res = tToolkit.OpenToolkit();

      if (Res == 0)
        {
        try
          {
          try
            {
            oVAT100 = (tToolkit as ICSNFToolkit).VAT100.Add();

            oVAT100.vatCorrelationId = aVATRecord.correlationID;
            oVAT100.vatIRMark = aVATRecord.IRMark;
            oVAT100.vatDateSubmitted = aVATRecord.dateSubmitted;
            oVAT100.vatDocumentType = aVATRecord.documentType;
            oVAT100.vatPeriod = aVATRecord.VATPeriod;
            oVAT100.vatUserName = aVATRecord.username;
            oVAT100.vatStatus = aVATRecord.status;
            oVAT100.vatPollingInterval = aVATRecord.pollingInterval;
            oVAT100.vatDueOnOutputs = aVATRecord.VATDueOnOutputs;
            oVAT100.vatDueOnECAcquisitions = aVATRecord.VATDueOnECAcquisitions;
            oVAT100.vatTotal = aVATRecord.VATTotal;
            oVAT100.vatReclaimedOnInputs = aVATRecord.VATReclaimedOnInputs;
            oVAT100.vatNet = aVATRecord.VATNet;
            oVAT100.vatNetSalesAndOutputs = aVATRecord.netSalesAndOutputs;
            oVAT100.vatNetPurchasesAndInputs = aVATRecord.netPurchasesAndInputs;
            oVAT100.vatNetECSupplies = aVATRecord.netECSupplies;
            oVAT100.vatNetECAcquisition = aVATRecord.netECAcquisitions;
            oVAT100.vatNotifyEmail = aVATRecord.notifyEmail;
            oVAT100.vatPollingURL = aVATRecord.PollingURL;
            oVAT100.vatHMRCNarrative = aVATRecord.hmrcNarrative;

            Res = oVAT100.Save();

            if (Res != 0)
              {
              LogText("An error occurred adding a record to the VAT 100 database.\r\n" + tToolkit.LastErrorString);
              }
            }
          catch (Exception ex)
            {
            lastErrorString = ex.Message;
            LogText("AddVAT100Entry : " + ex.Message);
            }
          }
        finally
          {
          Res = tToolkit.CloseToolkit();
          }
        }
      else
        {
        LogText("Failed to open COM toolkit");
        lastErrorString = "AddVAT100Entry : Failed to open COM toolkit";
        }

      return Res;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Updates the record in the VAT100 table
    /// </summary>
    /// <param name="aVATRecord"></param>
    /// <returns></returns>
    public int UpdateVAT100Entry(VAT100Record aVATRecord, string ForCompanyCode)
      {
      IVAT100 oVAT100 = null;

      int Res = 0;

      LogText("Updating DB record for CorrelationID " + aVATRecord.correlationID);

      // Find the record, based on Correlation ID
      string path = GetCompanyPath(ForCompanyCode);
      if (path == "")
        {
        return 12; // File not found
        }
      // PKR. 15/09/2015. ABSEXCH-16839. Close toolkit before changing path.
      if (tToolkit.Status == TToolkitStatus.tkOpen)
        {
        tToolkit.CloseToolkit();
        }
      tToolkit.Configuration.DataDirectory = path;
      Res = tToolkit.OpenToolkit();

      if (Res == 0)
        {
        try
          {
          try
            {
            // Look for the entry to update
            oVAT100 = (tToolkit as ICSNFToolkit).VAT100;
            Res = oVAT100.GetFirst();
            while (Res == 0)
              {
              // See if it's the required record
              if (oVAT100.vatCorrelationId == aVATRecord.correlationID)
                {
                // Matched
                // Update the values
                IVAT100 uRec = oVAT100.Update();

                if (uRec != null)
                  {
                  uRec.vatIRMark = aVATRecord.IRMark;
                  uRec.vatDateSubmitted = aVATRecord.dateSubmitted;
                  uRec.vatDocumentType = aVATRecord.documentType;
                  uRec.vatPeriod = aVATRecord.VATPeriod;
                  uRec.vatUserName = aVATRecord.username;
                  uRec.vatStatus = aVATRecord.status;
                  uRec.vatPollingInterval = aVATRecord.pollingInterval;
                  uRec.vatDueOnOutputs = aVATRecord.VATDueOnOutputs;
                  uRec.vatDueOnECAcquisitions = aVATRecord.VATDueOnECAcquisitions;
                  uRec.vatTotal = aVATRecord.VATTotal;
                  uRec.vatReclaimedOnInputs = aVATRecord.VATReclaimedOnInputs;
                  uRec.vatNet = aVATRecord.VATNet;
                  uRec.vatNetSalesAndOutputs = aVATRecord.netSalesAndOutputs;
                  uRec.vatNetPurchasesAndInputs = aVATRecord.netPurchasesAndInputs;
                  uRec.vatNetECSupplies = aVATRecord.netECSupplies;
                  uRec.vatNetECAcquisition = aVATRecord.netECAcquisitions;
                  uRec.vatHMRCNarrative = aVATRecord.hmrcNarrative;
                  uRec.vatNotifyEmail = aVATRecord.notifyEmail;
                  uRec.vatPollingURL = aVATRecord.PollingURL;

                  Res = uRec.Save();

                  if (Res != 0)
                    {
                    LogText("Could not update VAT 100 database entry for Correlation ID " + aVATRecord.correlationID + 
                            ".\r\n" + tToolkit.LastErrorString);
                    }
                  }
                else
                  {
                  LogText("Failed to create Update object.");
                  // PKR. TODO: This needs updating to whatever value means that we couldn't get an Update object.
                  Res = -1;
                  lastErrorString = "Could not update VAT 100 database entry for Correlation ID " + aVATRecord.correlationID;
                  }
                // We found the record, so we don't need to look further
                break;
                } // if correct record

              Res = oVAT100.GetNext();
              } // while we have a record
            }
          catch (Exception ex)
            {
            lastErrorString = ex.Message;
            LogText("Could not update VAT 100 database entry for Correlation ID " + aVATRecord.correlationID + ".\r\n" + ex.Message);
            }
          }
        finally
          {
          Res = tToolkit.CloseToolkit();
          }
        }
      else
        {
        LogText("UpdateVAT100Entry : Failed to open COM toolkit");
        lastErrorString = "UpdateVAT100Entry : Failed to open COM toolkit";
        }

      return Res;
      }


    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Gets the VAT100 record for the specified VAT Period
    /// </summary>
    /// <param name="aCorrelationID"></param>
    /// <returns></returns>
    public IVAT100 GetRecordByVATPeriod(string aVATPeriod, string ForCompanyCode)
      {
      int Res;
      IVAT100 Result = null;

      string path = GetCompanyPath(ForCompanyCode);
      if (path == "")
        {
        return null;
        }
      // PKR. 15/09/2015. Close toolkit before changing path.
      if (tToolkit.Status == TToolkitStatus.tkOpen)
        {
        tToolkit.CloseToolkit();
        }
      tToolkit.Configuration.DataDirectory = path;
      tToolkit.OpenToolkit();
      IVAT100 oVAT100 = (tToolkit as ICSNFToolkit).VAT100;

      try
        {
        try
          {
          Res = oVAT100.GetFirst();
          while (Res == 0)
            {
            // See if it's the required record
            if (oVAT100.vatPeriod == aVATPeriod)
              {
              Result = oVAT100;
              break;
              }

            Res = oVAT100.GetNext();
            }
          }
        catch (Exception ex)
          {
          lastErrorString = ex.Message;
          Log.Add(lastErrorString);
          }
        }
      finally
        {
        tToolkit.CloseToolkit();
        }

      return Result;
      }

    //---------------------------------------------------------------------------------------------
    public void LogText(string message)
      {
      Log.Add(message);
      }

    }
  }