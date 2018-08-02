namespace IRIS.ExchequerSQL.ClrExtensions
{
    using System;
    using Microsoft.SqlServer.Server;
    using System.Data.SqlTypes;
    using System.Text;

    public class SQLCLRFunctions
    {
        //PR: 24/08/2015 ABSEXCH-13479 Chenged to pad CostCentre/Department codes correctly in returned History Code

        /// <summary>
        /// Pads a string to 3 hex characters with char 20 (space). 
        /// </summary>
        /// <param name="ccDeptCode">Cost Centre or Department string in hex</param>
        /// <remarks></remarks>
        private static string PadCCDeptString(string ccDeptCode)
        {
           const string padding = "202020";

           return ccDeptCode + padding.Substring(ccDeptCode.Length);
        }
        /// <summary>
        /// Gets the exact value for the HISTORY.hiCodeComputed field for the provided parameters. 
        /// Primarily used by Trial Balance reports
        /// </summary>
        /// <param name="nominalCode">Nominal code</param>
        /// <param name="costCentre">Cost Centre (3 characters)</param>
        /// <param name="department">Department (3 characters)</param>
        /// <param name="committed">Comitted values. True or False</param>
        /// <returns>Returns a byte array which can directly populate a SQL varbinary(20)</returns>
        /// <remarks></remarks>
        [SqlFunction(DataAccess = DataAccessKind.None, IsDeterministic = true, Name = "ifn_Report_GetHiCodeComputedValue")]
        public static Byte[] GetHiCodeComputedValue(int nominalCode, string costCentre, string department, bool committed)
        {
            // Define a few constants which may help compiler
            const string costCentreTag = "43";
            const string departmentTag = "44";
            const string byteSeperator = "-";
            const string hexSeperator = "02";
            const string padding = "2020202020202020202020202020202020202020";
            const string committedTag = "434D54020221";

            // PR 24/08/2015 Trim CC/Dept so that Length check ignores empty string padded with spaces
            costCentre = costCentre.Trim();
            department = department.Trim();

            // Ok. Off we go
            StringBuilder rawHex = new StringBuilder(0, 40);
            if (committed)
                rawHex.Append(committedTag);

            // Add 'C' or 'D' into hexstring depending upon whether Cost Centre or Department
            // If both then search on the Cost Centre record
            if ((costCentre.Length > 0) & (department.Length > 0))
            {
                rawHex.Append(costCentreTag);
            }
            else if (costCentre.Length > 0)
            {
                rawHex.Append(costCentreTag);
            }
            else if (department.Length > 0)
            {
                rawHex.Append(departmentTag);
            }

            // Add nominal code
            rawHex.Append(BitConverter.ToString(BitConverter.GetBytes(nominalCode)).Replace(byteSeperator, string.Empty));

            // Now add hex equivalent of cost centre and/or department
            if ((costCentre.Length > 0) & (department.Length > 0))
            {
                rawHex.Append(
                    PadCCDeptString(BitConverter.ToString(new ASCIIEncoding().GetBytes(costCentre)).Replace(byteSeperator, string.Empty))
                    + hexSeperator
                    + PadCCDeptString(BitConverter.ToString(new ASCIIEncoding().GetBytes(department)).Replace(byteSeperator, string.Empty)));
            }
            else if (costCentre.Length > 0)
            {
                rawHex.Append(PadCCDeptString(BitConverter.ToString(new ASCIIEncoding().GetBytes(costCentre)).Replace(byteSeperator, string.Empty)));
            }
            else if (department.Length > 0)
            {
                rawHex.Append(PadCCDeptString(BitConverter.ToString(new ASCIIEncoding().GetBytes(department)).Replace(byteSeperator, string.Empty)));
            }

            // Pad it out to 40 characters with trailing spaces
            rawHex.Append(padding.Substring(0, 40 - rawHex.Length));

            // Return the value
            return FieldConverter.ConvertStringToBytes(rawHex.ToString());
        }
    }
}
