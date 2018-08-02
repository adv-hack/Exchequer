using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Security.Principal;

namespace CSH.Exchequer.Bespoke.UI.Buttons
{
    /// <summary>
    /// A User Account Control privilege elevation button
    /// </summary>
    public sealed class UacElevationButton : Button
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="UacElevationButton"/> class.
        /// </summary>
        public UacElevationButton()
        {
            this.Text = "Elevate Privilege";
            this.Click +=new EventHandler(UacElevationButton_Click);

            // The shield will only attach to the button if the
            // flat style is set to "System"

            this.FlatStyle = FlatStyle.System;
            AddShieldToButton(this);

            // If we’re already admin, then grey out the button
            this.Enabled = IsAdmin;
        }

        private static class NativeMethods
        {
            [DllImport("user32")]
            internal static extern UInt32 SendMessage
                (IntPtr hWnd, UInt32 msg, UInt32 wParam, UInt32 lParam);
        }

        private const int BCM_FIRST = 0x1600; //Normal button
        private const int BCM_SETSHIELD = (BCM_FIRST + 0x000C); //Elevated button

        /// <summary>
        /// Handles the Click event of the UacElevationButton control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        private void UacElevationButton_Click(object sender, EventArgs e)
        {
            RestartElevated();
        }

        /// <summary>
        /// Adds the shield to button.
        /// </summary>
        /// <param name="button">The button.</param>
        private void AddShieldToButton(Button button)
        {
            button.FlatStyle = FlatStyle.System;
            NativeMethods.SendMessage(button.Handle, BCM_SETSHIELD, 0, 0xFFFFFFFF);
        }

        /// <summary>
        /// Removes the shield from button.
        /// </summary>
        /// <param name="button">The button.</param>
        private  void RemoveShieldFromButton(Button button)
        {
            NativeMethods.SendMessage(button.Handle, BCM_FIRST, 0, 0xFFFFFFFF);
        }

        /// <summary>
        /// Restarts the elevated.
        /// </summary>
        private static void RestartElevated()
        {
            ProcessStartInfo startInfo = new ProcessStartInfo();
            startInfo.UseShellExecute = true;
            startInfo.WorkingDirectory = Environment.CurrentDirectory;
            startInfo.FileName = Application.ExecutablePath;
            startInfo.Verb = "RunAs";

            try
            {
                Process.Start(startInfo);
            }
            catch (System.ComponentModel.Win32Exception exception)
            {
                Debug.WriteLine("Error restarting application: " + exception.ToString());
                return;
            }

            Application.Exit();
        }

        /// <summary>
        /// Initializes the component.
        /// </summary>
        private void InitializeComponent()
        {
            this.SuspendLayout();
            this.ResumeLayout(false);
        }

        /// <summary>
        /// Gets a value indicating whether this instance is admin.
        /// </summary>
        /// <value>
        ///   <c>true</c> if this instance is admin; otherwise, <c>false</c>.
        /// </value>
        private bool IsAdmin
        {
            get
            {
                return new WindowsPrincipal(
                    WindowsIdentity.GetCurrent()).IsInRole(
                        WindowsBuiltInRole.Administrator);
            }
        }
    } 
}
