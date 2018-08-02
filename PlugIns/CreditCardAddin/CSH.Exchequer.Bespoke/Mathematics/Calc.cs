using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.CompilerServices;
using System.IO;

namespace CSH.Exchequer.Bespoke.Mathematics
{
    /// <summary>
    /// Provides mathematical functions useful when dealing with numeric values coming from Exchequer
    /// </summary>
    public class Calc
    {
        /// <summary>
        /// The mode of rounding to use
        /// </summary>
        public enum RoundMode
        {
            /// <summary>
            /// RoundUp
            /// </summary>
            RoundUp,
            /// <summary>
            /// RoundDown
            /// </summary>
            RoundDown,
            /// <summary>
            /// RoundUpOrDown
            /// </summary>
            RoundUpOrDown
        }

        /// <summary>
        /// A method for dividing one number by the other that avoids division by zero exceptions
        /// </summary>
        /// <param name="value1">The value1.</param>
        /// <param name="value2">The value2.</param>
        /// <returns></returns>
        public static decimal SafeDiv(decimal value1, decimal value2)
        {
            if (value2 == 0)
            {
                return 0;
            }
            else
            {
                return value1 / value2;
            }
        }

        /// <summary>
        /// Rounds the specified value.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <param name="RoundMode">The round mode.</param>
        /// <param name="decimals">The decimals.</param>
        /// <returns></returns>
        public static decimal Round(decimal value, Calc.RoundMode RoundMode, int decimals)
        {
            return Round(value, RoundMode, decimals, System.MidpointRounding.AwayFromZero);
        }

        /// <summary>
        /// Rounds the specified value.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <param name="RoundMode">The round mode.</param>
        /// <param name="decimals">The decimals.</param>
        /// <param name="MidPointRounding">The mid point rounding.</param>
        /// <returns></returns>
        public static decimal Round(decimal value, Calc.RoundMode RoundMode, int decimals, System.MidpointRounding MidPointRounding)
        {
            switch (RoundMode)
            {
                case RoundMode.RoundUp:
                    decimal OriginalDecimal = default(decimal);
                    if (decimals == 0)
                    {
                        OriginalDecimal = value;
                        value = Math.Truncate(value);
                        if (OriginalDecimal != value)
                            value = value + 1;
                    }
                    else
                    {
                        decimal MultiplyPower = Convert.ToDecimal(Math.Pow(10, decimals));
                        value = value * MultiplyPower;
                        OriginalDecimal = value;
                        value = Math.Truncate(value);
                        if (OriginalDecimal != value)
                            value = value + 1;
                        value = SafeDiv(value, MultiplyPower);
                    }

                    return value;
                case RoundMode.RoundDown:
                    if (decimals == 0)
                    {
                        value = Math.Truncate(value);
                    }
                    else
                    {
                        decimal MultiplyPower = Convert.ToDecimal(Math.Pow(10, decimals));
                        value = value * MultiplyPower;
                        value = Math.Truncate(value);
                        value = SafeDiv(value, MultiplyPower);
                    }

                    return value;
                case RoundMode.RoundUpOrDown:
                    return Math.Round(value, decimals, MidPointRounding);
            }

            //Should never happen
            return 0;

        }

        /// <summary>
        /// Determines whether the specified value is a whole number.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns>
        ///   <c>true</c> if the specified value is a whole number; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsWholeNumber(decimal value)
        {
            if (decimal.Truncate(value) == value)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}