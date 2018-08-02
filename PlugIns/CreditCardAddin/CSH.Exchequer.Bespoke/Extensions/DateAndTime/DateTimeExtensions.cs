using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSH.Exchequer.Bespoke.Extensions.Dates
{
    /// <summary>
    /// Provides extension methods to the <c>System.DateTime</c> class
    /// </summary>
    public static class DateTimeExtensions
    {
        /// <summary>
        /// Converts the <c>System.DateTime</c> to Exchequer's 8 character string date format.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        public static string ToStr8(this System.DateTime value)
        {
            return value.ToString("yyyyMMdd");
        }
    }
}
