using System;
using System.Collections.Generic;
using System.Text;
using CASPolicy_CS;
using System.IO;


namespace GrantPolicy
  {
  public class grantpolicy
    {
    static void Main(string[] args)
      {
      // log events for net policy
      if (File.Exists("GP.log"))
        {
        try
          {
          File.Delete("GP.log");
          }
        catch { }
        }

      StreamWriter sw = new StreamWriter("GP.log", true);

      string lDrive = "";

      // check number of parameters given
      if (args.Length.Equals(1))
        {
        lDrive = args.GetValue(0).ToString();
        // load the drive letter that will be used to give the permission
        lDrive = Directory.GetDirectoryRoot(lDrive);

        // if drive exists (ex. x:\)
        if (Directory.Exists(lDrive))
          {
          // add star (all directories will be granted)
          lDrive = lDrive + "*";
          try
            {
            //SecurityFunctions.AddUrlSecurityGroup(@"\Iris_Code_Apps", @"\" + lDrive + "\"", "FullTrust");                    

            // add security policy
            int lresult = SecurityFunctions.AddUrlSecurityGroup(@"\Iris_Code_Apps", @lDrive, "FullTrust");

            // add result to the log file
            sw.WriteLine(DateTime.Now + "|Result: " + lresult.ToString() + "|Path: " + lDrive);
            }
          catch (Exception er)
            {
            sw.WriteLine(DateTime.Now + "|Error: " + er.Message + "|Path: " + lDrive);
            }
          } // if (Directory.Exists(lDrive))
        else
          {
          sw.WriteLine(DateTime.Now + "|Error: Drive does not exist |Path: " + lDrive);
          }

        } // if (args.Length.Equals(1))             
      else
        {
        sw.WriteLine(DateTime.Now + "|Error: Drive should be a single letter |Path: " + lDrive);
        }

      sw.Flush();
      sw.Close();
      }
    }
  }


