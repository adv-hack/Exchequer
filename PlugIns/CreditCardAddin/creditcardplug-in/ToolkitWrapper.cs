using System;
using DotNetLibrariesC.Toolkit;
using Enterprise04;

namespace PaymentGatewayAddin
  {
  /// <summary>
  /// A wrapper around the Out-of-process Toolkit object.  Implements IDisposable
  /// to allow resources to be released.
  /// </summary>
  public class ToolkitWrapper : IDisposable
    {
    public Enterprise04.IToolkit3 tToolkit;

    /// <summary>
    /// Constructor.  Private for singleton instance
    /// </summary>
    public ToolkitWrapper()
      {
      tToolkit = new Enterprise04.Toolkit() as IToolkit3;
      int val1 = 0, val2 = 0, val3 = 0;
      ctkDebugLog.StartDebugLog(ref val1, ref val2, ref val3); // Backdoor the toolkit (renamed for obfuscation)
      tToolkit.Configuration.SetDebugMode(val1, val2, val3);
      tkDisposed = false;
      }

    //=============================================================================================
    // Implementation of IDisposable
    //=============================================================================================

    private bool tkDisposed = false;

    public void Dispose()
      {
      Dispose(true);
      GC.SuppressFinalize(this);
      }


    protected virtual void Dispose(bool disposing)
      {
      // This allows multiple calls
      if (tkDisposed)
        {
        return;
        }

      if (disposing)
        {
        // Free all managed objects here.
        int tkRCount = System.Runtime.InteropServices.Marshal.ReleaseComObject(tToolkit);
        Console.WriteLine(string.Format("toolkit reference count is {0}", tkRCount));
        while (tkRCount > 0)
          {
          tkRCount = System.Runtime.InteropServices.Marshal.ReleaseComObject(tToolkit);
          }
        tToolkit = null;
        }

      // Free all unmanaged objects here.
      // This allows multiple calls
      tkDisposed = true;
      }

    /// <summary>
    /// Finalizer
    /// </summary>
    ~ToolkitWrapper()
      {
      Dispose(false);
      }

    //=============================================================================================
    }
  }