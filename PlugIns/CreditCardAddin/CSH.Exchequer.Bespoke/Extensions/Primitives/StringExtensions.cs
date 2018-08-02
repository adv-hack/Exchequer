using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace CSH.Exchequer.Bespoke.Extensions.Primitives
{
    /// <summary>
    /// Provides extension methods to the <c>System.String</c> class
    /// </summary>
    public static class StringExtensions
    {
        /// <summary>
        /// Converts a null string to an empty string
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        public static string NullToString(this string value)
        {
            if ((string.IsNullOrWhiteSpace(value)))
            {
                return string.Empty;
            }
            else
            {
                return value;
            }
        }

        /// <summary>
        /// Converts an 8 character exchequer date to a <c>System.DateTime</c>.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        public static System.DateTime Str8ToDate(this string value)
        {
            DateTime result;

            bool isDateValid = false;
            isDateValid = DateTime.TryParseExact(value,
                                                 "yyyyMMdd",
                                                 null,
                                                 System.Globalization.DateTimeStyles.None,
                                                 out result);
            if (!isDateValid)
                result = new DateTime(0);

            return result;
        }

        /// <summary>
        /// Replaces an instance of the specififed value in the string, but ignores case when finding the string to replace.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <param name="oldValue">The old value.</param>
        /// <param name="newValue">The new value.</param>
        /// <returns></returns>
        public static string ReplaceCaseInsensitive(this string value, string oldValue, string newValue)
        {

            string result = new string(value.ToCharArray());
            int i = -2;

            while ((i != -1))
            {
                i = result.LastIndexOf(oldValue, StringComparison.OrdinalIgnoreCase);
                if ((i != -1))
                {
                    result = result.Remove(i, oldValue.Length);
                    result = result.Insert(i, newValue);
                }
            }

            return result;
        }
    }
}
