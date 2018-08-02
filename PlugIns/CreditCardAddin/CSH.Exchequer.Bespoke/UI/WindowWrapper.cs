using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace CSH.Exchequer.Bespoke.UI
{
    /// <summary>
    /// Provides a wrapper around a window handle that can be used to represent the owner of a dialog or form.
    /// </summary>
    public class WindowWrapper : IWin32Window
    {
        private IntPtr hwnd;
        /// <summary>
        /// Initializes a new instance of the <see cref="WindowWrapper"/> class.
        /// </summary>
        /// <param name="handle">The handle.</param>
        public WindowWrapper(IntPtr handle)
        {
            this.hwnd = handle;
        }

        /// <summary>
        /// Gets the handle to the window represented by the implementer.
        /// </summary>
        /// <returns>A handle to the window represented by the implementer.</returns>
        public IntPtr Handle
        {
            get { return this.hwnd; }
        }
    }
}
