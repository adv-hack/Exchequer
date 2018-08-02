using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSH.Exchequer.Bespoke.Extensions.Numeric
{
    /// <summary>
    /// 
    /// </summary>
    public static class DoubleExtensions
    {
        /// <summary>
        /// Gets the precision.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        public static int GetPrecision(this double value)
        {
            var result = 0;
            var valueAsString = value.ToString();
            var index = valueAsString.IndexOf('.');

            if (index == -1)
            {
                result = 0;
            }
            else
            {
                result = valueAsString.Length - (index + 1);
            }

            return result;
        }
    }
}
