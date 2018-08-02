using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
namespace CSH.Exchequer.Bespoke.ErrorHandling
{
    /// <summary>
    /// Provides standard exception handling services to your application
    /// </summary>
    public partial class ExceptionManager
    {
        /// <summary>
        /// Native P\Invoke methods that are used by the <c>ExceptionManager</c> class
        /// </summary>
        private static class NativeMethods
        {
            //--
            //-- Windows API calls necessary to support screen capture
            //--
            [DllImport("gdi32", EntryPoint = "BitBlt", CharSet = CharSet.Ansi, SetLastError = true, ExactSpelling = true)]
            internal static extern int BitBlt(int hDestDC, int x, int y, int nWidth, int nHeight, int hSrcDC, int xSrc, int ySrc, int dwRop);

            [DllImport("user32", EntryPoint = "GetDC", CharSet = CharSet.Ansi, SetLastError = true, ExactSpelling = true)]
            internal static extern int GetDC(int hwnd);

            [DllImport("user32", EntryPoint = "ReleaseDC", CharSet = CharSet.Ansi, SetLastError = true, ExactSpelling = true)]
            internal static extern int ReleaseDC(int hwnd, int hdc);
        }
    }
}
