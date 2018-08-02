using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSH.Exchequer.Bespoke.Licencing
{
    /// <summary>
    /// Generates authentication/authorisation code for accessing the functions in BespokeFuncs.dll
    /// </summary>
    internal static class StringUtilities
    {
        /// <summary>
        /// CalcDateTime is actually a function to return the password for accessing the functions in BespokeFuncs.Dll.
        /// </summary>
        /// <returns></returns>
        internal static string CalcDateTime()
        {
            Int32 iDay = 0;
            Int32 iD = 0;
            Int32 iB = 0;
            Int32 iA = 0;
            Int32 iE = 0;
            Int32 iC = 0;

            iDay = DateTime.Now.Day;
            iA = Convert.ToInt32(Math.Truncate(Math.Pow(iDay + 7, 3)));
            iB = iA - iDay;
            iC = Convert.ToInt32(Math.Truncate(Math.Sqrt(iB)));
            iD = Convert.ToInt32(Math.Truncate(Math.Pow(iC + 1, 3)));
            iE = Convert.ToInt32(Math.Truncate(Convert.ToDouble(iD)));

            return "1" + iE.ToString() + "0";
        }
    }
}
