using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Runtime.InteropServices;

namespace CSH.Exchequer.Bespoke.Extensions.IO
{
    /// <summary>
    /// 
    /// </summary>
    public static class DirectoryInfoExtensions
    {
        /// <summary>
        /// 
        /// </summary>
        private static class NativeMethods
        {
            /// <summary>
            /// Gets the short name of the path.
            /// </summary>
            /// <param name="path">The path.</param>
            /// <param name="result">The result.</param>
            /// <param name="resultLength">Length of the result.</param>
            /// <returns></returns>
            [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
            public static extern int GetShortPathName(
                   [MarshalAs(UnmanagedType.LPTStr)]
                   string path,
                   [MarshalAs(UnmanagedType.LPTStr)]
                   StringBuilder result,
                   int resultLength);
        }


        /// <summary>
        /// Gets the short 8.3 style path.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        public static string GetShortName(this DirectoryInfo value)
        {
            StringBuilder result = new StringBuilder(255);
            NativeMethods.GetShortPathName(value.FullName, result, result.Capacity);
            return result.ToString();
        }

        /// <summary>
        /// Determines whether [is unc drive] [the specified info].
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns>
        ///   <c>true</c> if [is unc drive] [the specified info]; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsUncDrive(this DirectoryInfo value)
        {
            Uri uri = null;
            if (!Uri.TryCreate(value.FullName, UriKind.Absolute, out uri))
            {
                return false;
            }
            return uri.IsUnc;
        }

    }
}
