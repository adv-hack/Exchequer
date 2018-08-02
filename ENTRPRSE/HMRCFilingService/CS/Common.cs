using System;
using System.IO;
using System.Text;

// Common declarations, shared with all other units
namespace HMRCFilingService
  {
  public class DocumentRecord
    {
    public string docClass;
    public string function;
    public string companyCode;
    public string companyPath;
    public VAT100Record theDocument;
    public ServiceStatus status;
    }

  public enum HMRCDocTypes
    {
    hmrcVAT100 = 0
    }

  public enum HMRCSubmissionTypes
    {
    hmrcLiveSubmission = 0,
    hmrcDevSubmission = 1,
    }

  public enum SubmissionStatus
    {
    ssSubmitted = 1,
    ssPending = 2,
    ssError = 3,
    ssAccepted = 4
    }

  public enum ServiceStatus
    {
    ssIdle = 0,
    ssPolling = 1,
    ssProcessing = 2,
    }

  public sealed class Log
    {
    public static string Path = "";
    public static void Add(string message)
      {
//#if DEBUG
      Add(Path, message);
//#endif
      }

    public static void Add(string companyPath, string message)
      {
//#if DEBUG
      string filespec = @companyPath + @"\LOGS\VAT100Log.txt";
      DateTime timenow = DateTime.Now;
      // AppendAllText creates/opens a file, writes the specified string to the file, 
      // and then closes the file.
      try
        {
        System.IO.File.AppendAllText(@filespec,
                                     string.Format("{0} : {1}\r\n", timenow, message));
        }
      catch
        {
        // We're in debug mode, it was just a log message ... ignore errors.
        }
//#endif
      }
    }

  // CJS 2015-09-24 - ABSEXCH-16922 - HMRC Filing VAT Submissions xml folder
  // Added this class to set the paths correctly and output the supplied XML
  public sealed class XMLWrite
    {
        public static void ToSentFolder(string companyPath, string filename, string xmlText)
        {
            string filespec = string.Format(@"{0}\AUDIT\VAT100\RawFiles\Sent\{1}", companyPath, Path.GetFileName(filename));
            try
            {
                System.IO.File.WriteAllText(filespec, xmlText);
            }
            catch (Exception Ex)
            {
                Log.Add(string.Format("Error saving XML file to Sent folder {0}: {1}", filespec, Ex.Message));
            }
        }
        public static void ToReceivedFolder(string companyPath, string filename, string xmlText)
        {
            string filespec = string.Format(@"{0}\AUDIT\VAT100\RawFiles\Received\{1}", companyPath, Path.GetFileName(filename));
            try
            {
                System.IO.File.WriteAllText(filespec, xmlText);
            }
            catch (Exception Ex)
            {
                Log.Add(string.Format("Error saving XML file to Received folder {0}: {1}", filespec, Ex.Message));
            }
        }
    }
  //SS:04/06/2018:2018-R1:ABSEXCH-20538:VAT 100 Submissions failing due to HMRC gateway changes
  // This class is used to encode XmlSerializer into string with UTF8
  public sealed class Utf8StringWriter : StringWriter
  {
      //public override Encoding Encoding => Encoding.UTF8;
      public override Encoding Encoding { get { return Encoding.UTF8; } }
  }
}

