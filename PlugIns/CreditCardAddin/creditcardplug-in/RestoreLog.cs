using System;
using System.IO;
using System.Windows.Forms;

namespace PaymentGatewayAddin
  {
  public class RestoreLog
    {
    public enum severities : int { sevInfo = 0, sevWarning = 1, sevError = 2, sevDebug = 3 };

    public string[] severityStrings = new string[4];

    private StreamWriter sw;
    private string filename;

    public string GetLogFilename()
      {
      return filename;
      }

    public int lineCount { get; set; }

    // PKR. 22/09/2015. ABSEXCH-16655. Error reported: Invalid account code
    public bool LogContainsErrors;

    //---------------------------------------------------------------------------------------------
    public RestoreLog()
      {
      lineCount = 0;
      severityStrings[0] = "Information";
      severityStrings[1] = "Warning";
      severityStrings[2] = "Error";
      severityStrings[3] = "DEBUG";
      }

    ~RestoreLog()
      {
      severityStrings = null;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Open a new logfile
    /// </summary>
    /// <param name="aPath"></param>
    public void Open(string aPath)
      {
      filename = aPath + @"LOGS\CreditCardRecoveryLog_" + string.Format("CCData_{0:yyyyMMdd_HHmmss}.log", DateTime.Now);
      if (!File.Exists(filename))
        {
        // Create a file to write to.
        sw = File.CreateText(filename);
        sw.Write("Credit Card Transaction Data Restore\r\n");
        sw.Write(string.Format("Started at {0}\r\n", DateTime.Now.ToString()));
        sw.Write("----------------------------------------------------------------------\r\n");
        sw.Flush();

        // PKR. 22/09/2015. ABSEXCH-16655. Error reported: Invalid account code
        LogContainsErrors = false;
        }
      else
        {
        MessageBox.Show("Couldn't open streamWriter : " + aPath);
        sw = null;
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Log a message to the log file
    /// </summary>
    /// <param name="aSeverity"></param>
    /// <param name="aMessage"></param>
    public void Log(severities aSeverity, string aMessage)
      {
      DateTime timeNow = DateTime.Now;
      string logMsg = string.Empty;

      if (aSeverity == severities.sevDebug)
        {
        logMsg = string.Format("{0,12} : {1}\r\n", severityStrings[(int)aSeverity], aMessage);
        }
      else
        {
        logMsg = string.Format("{0} : {1,12} : {2}\r\n", timeNow.ToString(), severityStrings[(int)aSeverity], aMessage);

        // PKR. 22/09/2015. ABSEXCH-16655. Error reported: Invalid account code
        // Set a flag if an error or warning was logged.
        if ((aSeverity == severities.sevWarning) || (aSeverity == severities.sevError))
          {
          LogContainsErrors = true;
          }
        }
      try
        {
        sw.Write(logMsg);
        lineCount++;
        sw.Flush();
        }
      catch (Exception Ex)
        {
        MessageBox.Show("Log error : " + Ex.Message);
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Close the log file streamwriter
    /// </summary>
    public void Close()
      {
      sw.Close();

      // If the file is empty, there's no point in keeping it
      if (lineCount == 0)
        {
        File.Delete(filename);
        }
      }
    }
  }

