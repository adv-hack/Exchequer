using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using Enterprise04;
using EnterpriseBeta; // Do we need this?
using DotNetLibrariesC.Toolkit; // Toolkit backdoor

namespace ExchequerRCTGateway
  {
  [Guid("9031478F-155C-4C56-AEC3-159A3F71D802")]
  [InterfaceType(ComInterfaceType.InterfaceIsDual)]
  [ComVisible(true)]
  public interface IRCTGateway
    {
    /// <summary>
    /// Initialise the Gateway for batch processing of RCT transactions.
    /// </summary>
    /// <returns></returns>
    StatusCodes StartBatch(RCTCallBack aCallback, string MCMCompanyCode);

    /// <summary>
    /// Add a transaction to the batch
    /// </summary>
    /// <returns></returns>
    StatusCodes AddToBatch(string aOurRef);

    /// <summary>
    /// Pass the batch to Exchequer and start processing it
    /// </summary>
    /// <returns></returns>
    StatusCodes ProcessBatch();

    /// <summary>
    /// Get the current status of the batch
    /// </summary>
    /// <returns></returns>
    BatchStatuses GetBatchStatus();

    /// <summary>
    /// Returns the last error string.
    /// </summary>
    /// <returns></returns>
    string GetLastErrorString();

    /// <summary>
    /// This is provided so that Delphi can make sure the Gateway closes its COM Toolkit etc.
    /// </summary>
    void FreeResources();
    }

  [Guid("55BA2739-AC6B-4F9F-84E8-B5380378DFB0")]
  [ClassInterface(ClassInterfaceType.None)]
  [ProgId("ExchequerRCTGateway.RCTGateway")]
  [ComVisible(true)]
  public class RCTGateway : IRCTGateway, IDisposable
    {
    private BatchStatuses batchstatus;
    private StatusCodes status;
    private string errorString;
    private Enterprise04.IToolkit3 tToolkit;
    private MCMCompany selCompany = null;

    private List<string> rctBatch;

    // An instance pointer to the callback function, which will be assigned in StartBatch
    private RCTCallBack callback;
    private RCTLogger log;

    private List<MCMCompany> MCMCompanyList;

    /// <summary>
    /// Constructor
    /// </summary>
    public RCTGateway(RCTLogger aLogger=null)
      {
      MCMCompanyList = new List<MCMCompany>();
      log = aLogger;

      if (log == null)
        {
        log = dummyLogger;
        }

      batchstatus = BatchStatuses.NotReady;

      log("Created gateway");
      }

    //---------------------------------------------------------------------------------------------
    public StatusCodes StartBatch(RCTCallBack aCallback, string MCMCompanyCode)
      {
      // Set up the callback function
      callback = aCallback;

      status = StatusCodes.Success;

      // Create the toolkit if it's not already created
      if (tToolkit == null)
        {
        tToolkit = new Enterprise04.Toolkit() as IToolkit3;
        // Backdoor the toolkit
        int val1 = 0, val2 = 0, val3 = 0;
        ctkDebugLog.StartDebugLog(ref val1, ref val2, ref val3); // Backdoor the toolkit (renamed for obfuscation)
        tToolkit.Configuration.SetDebugMode(val1, val2, val3);
        }

      // Open the toolkit for the selected company
      Enterprise04.ICompanyManager coManager = tToolkit.Company;
      int nCos = coManager.cmCount;

      for (int index = 1; index <= nCos; index++)
        {
        MCMCompany aCompany = new MCMCompany();
        aCompany.name = coManager.cmCompany[index].coName.Trim();
        aCompany.code = coManager.cmCompany[index].coCode.Trim();
        aCompany.path = coManager.cmCompany[index].coPath.Trim();
        MCMCompanyList.Add(aCompany);

        if (MCMCompanyCode.ToUpper() == aCompany.code.ToUpper())
          {
          selCompany = aCompany;
          log("Found company " + aCompany.code);
          }
        }

      // Find the selected company and open the toolkit against it
      if (selCompany == null)
        {
        errorString = "Invalid company code : " + MCMCompanyCode;
        status = StatusCodes.DataError;
        }
      else
        {
        // Open the toolkit against the company
        if (tToolkit.Status == TToolkitStatus.tkOpen)
          {
          tToolkit.CloseToolkit();
          }
        tToolkit.Configuration.DataDirectory = selCompany.path;
        int Res = tToolkit.OpenToolkit();
        if (Res != 0)
          {
          errorString = "Couldn't open toolkit for company " + selCompany.code;
          status = StatusCodes.ToolkitError;
          }
        else
          {
          log("Toolkit opened successfully for company " + selCompany.code);
          status = StatusCodes.Success;
          }
        }

      if (status == StatusCodes.Success)
        {
        rctBatch.Clear();
        batchstatus = BatchStatuses.Initialised;

        log("Empty Batch ready");
        }

      return status;
      }

    //---------------------------------------------------------------------------------------------
    /// Release the resources owned by the add-in, because there's no way of calling
    /// the Dispose method from Delphi, and if left to its own devices, the Garbage Collector
    /// takes about 15 minutes to tidy up.
    /// </summary>
    public void FreeResources()
      {
      Dispose();
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Add a transaction to the batch
    /// </summary>
    /// <returns></returns>
    public StatusCodes AddToBatch(string aOurRef)
      {
      status = StatusCodes.Success;
      if (! string.IsNullOrEmpty(aOurRef))
        {
        log("Adding transaction " + aOurRef +" to batch");
        status = StatusCodes.NotYetImplemented;
        }

      return status;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Pass the batch to Exchequer and start processing it
    /// </summary>
    /// <returns></returns>
    public StatusCodes ProcessBatch()
      {
      log("Processing batch - NYI");

      // Check that there is at least one item in the batch
      if (rctBatch.Count > 0)
        {
        // Pass the batch to the Gateway

        }

      status = StatusCodes.NotYetImplemented;
      return status;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Get the current status of the batch
    /// </summary>
    /// <returns></returns>
    public BatchStatuses GetBatchStatus()
      {
      return batchstatus;
      }

    //---------------------------------------------------------------------------------------------
    public StatusCodes ClearBatch()
      {
      rctBatch.Clear();

      status = StatusCodes.Success;
      return status;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Returns the last error string.
    /// </summary>
    /// <returns></returns>
    public string GetLastErrorString()
      {
      string retval = errorString;
      errorString = string.Empty;
      return retval;
      }


    //=============================================================================================
    // Implementation of IDisposable
    //=============================================================================================

    // Flag: Has Dispose already been called?
    private bool disposed = false;

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
        if (tToolkit.Status == TToolkitStatus.tkOpen)
          {
          tToolkit.CloseToolkit();
          tToolkit = null;
          }
        }

      // Free any unmanaged objects here.
      //
      disposed = true;
      }


    /// <summary>
    /// Finalizer
    /// </summary>
    ~RCTGateway()
      {
      Dispose(false);
      }

    //--------------------------------------------------------------------
    /// <summary>
    /// Dummy Logger.  Used as a sink for log messages when no external logger specified.
    /// </summary>
    /// <param name="aMessage"></param>
    public void dummyLogger(string aMessage)
      {
      string msg = aMessage;
      }
    }


  // The Callback signature.
  // Return type and parameter list might change...
  public delegate void RCTCallBack();
#if DEBUG
  public delegate void RCTLogger(string aMessage);
#endif


  public enum BatchStatuses
    {
    Initialised = 0, //	The batch has been initialised and ready to accept payment information
    Ready = 1,       //	The batch contains at least one payment and may be submitted for processing
    InProgress = 2,  //	The batch is currently being processed by Batch Payments
    Complete = 3,    // Processing of the batch is complete and there were no errors
    Error = 4,       // Error	Processing of the batch is complete, but there were errors
    NotReady = 5     // A Payment Batch has not been initialised
    }

  public enum StatusCodes
    {
    Success = 0,
    GatewayNotInitialised = 1,
    BatchAlreadyInProgress = 2,
    DatabaseError = 3,
    DataError = 4,
    ToolkitError = 5,
    NotYetImplemented = 999
    }
  }
