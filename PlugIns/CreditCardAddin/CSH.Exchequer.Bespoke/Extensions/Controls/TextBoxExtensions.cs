using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace CSH.Exchequer.Bespoke.Extensions.Controls
{
    /// <summary>
    /// Provides extension methods for the <c>System.Windows.Forms.TextBox</c> control
    /// </summary>
    public static class TextBoxExtensions
    {
        /// <summary>
        /// Sets the textbox value to decimal places.
        /// </summary>
        /// <param name="textBox">The text box.</param>
        /// <param name="decimals">The decimals.</param>
        public static void SetStringToDecimalPlaces(this TextBox textBox, int decimals)
        {
            //TODO Allow proper support for negative values.
            int PointPos = textBox.Text.IndexOf(".");
            //If PointPos = -1 Then Exit Sub
            
            int NoOfDigitsBeforePoint = textBox.MaxLength - decimals - 1;
            if (PointPos == -1)
            {
                if (decimals <= 0)
                {
                    //Don't add Decimal Point for integers
                    return;
                }
                else
                {
                    //Add Decimal point, and trailing zeros
                    textBox.Text = (textBox.Text + ".");
                    textBox.Text = textBox.Text.PadRight(textBox.Text.Length + decimals, '0');
                }
            }
            else
            {
                int TargetLength = PointPos + decimals + 1;
                if (TargetLength > textBox.Text.Length)
                {
                    //Add zeros to pad to the correct amount of DPs
                    //EditText = EditText.PadRight(EditText.Length - PointPos + NoOfDP, "0"(0))
                    textBox.Text = textBox.Text.PadRight(TargetLength, '0');
                }
                else
                {
                    //Trim off DPs
                    textBox.Text = textBox.Text.Substring(0, TargetLength);
                }
            }

            //Add Leading Zero
            if (PointPos == 0)
            {
                textBox.Text = "0" + textBox.Text;
            }

            //Trim to fit maxlength
            if (textBox.Text.Length > textBox.MaxLength)
            {
                textBox.Text = "0.".PadRight(decimals + 2, '0');
            }
        }

        /// <summary>
        /// Validates the textbox value as number.
        /// </summary>
        /// <param name="textBox">The text box.</param>
        /// <param name="decimals">The decimals.</param>
        /// <param name="rangeFrom">The range from.</param>
        /// <param name="rangeTo">The range to.</param>
        /// <returns></returns>
        public static bool ValidateEditAsNumber(this TextBox textBox, int decimals, decimal rangeFrom, decimal rangeTo)
        {
            bool result = true;
            if (textBox.ValidateEditAsNumber(decimals))
            {
                //Get Value
                decimal Value = default(decimal);
                if (decimals == 0)
                {
                    Value = Convert.ToInt64(textBox.Text);
                }
                else
                {
                    Value = Convert.ToDecimal(textBox.Text);
                }

                //Check Range
                if (!((Value >= rangeFrom) && (Value <= rangeTo)))
                {
                    //Out of Range - reset to Zero
                    if (decimals == 0)
                    {
                        textBox.Text = "0";
                    }
                    else
                    {
                        textBox.Text = "0.".PadRight(decimals + 2, '0');
                    }

                    result = false;
                }
            }
            else
            {
                result = false;
            }

            return result;
        }

        /// <summary>
        /// Validates the textbox value as a number.
        /// </summary>
        /// <param name="textBox">The text box.</param>
        /// <param name="decimals">The decimals.</param>
        /// <returns></returns>
        public static bool ValidateEditAsNumber(this TextBox textBox, int decimals)
        {
            //TODO Allow proper support for negative values.
            try
            {
                if (decimals == 0)
                {
                    textBox.Text = Convert.ToInt64(textBox.Text).ToString();
                }
                else
                {
                    Convert.ToDouble(textBox.Text);
                    textBox.SetStringToDecimalPlaces(decimals);
                }

                return true;

            }
            catch (FormatException)
            {
                if (decimals == 0)
                {
                    textBox.Text = "0";
                }
                else
                {
                    textBox.Text = "0.".PadRight(decimals + 2, '0');
                }

                return false;
            }
        }
    }
}
