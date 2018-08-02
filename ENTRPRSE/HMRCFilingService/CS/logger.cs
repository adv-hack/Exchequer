using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Reflection;

namespace HMRCFilingService
  {
  static class Logger
    {
    static string thisPath;
    public static void Log(string someText, bool append=true)
      {
      thisPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
      using (StreamWriter sw = new StreamWriter(Path.Combine(thisPath, "HMRCServiceLog.txt"), append))
        {
        sw.WriteLine(DateTime.UtcNow.ToShortDateString() + " " + DateTime.Now.ToLongTimeString() + ": " + someText);
        }
      }
    }
  }
