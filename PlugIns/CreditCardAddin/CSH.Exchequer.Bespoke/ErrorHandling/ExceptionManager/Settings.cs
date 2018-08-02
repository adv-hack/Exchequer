using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing.Imaging;
namespace CSH.Exchequer.Bespoke.ErrorHandling
{
    /// <summary>
    /// Provides standard exception handling services to your application
    /// </summary>
    public partial class ExceptionManager
    {
        /// <summary>
        /// Configuration settings for the <c>ExceptionManager</c>
        /// </summary>
        public static class Settings
        {
            /// <summary>
            /// Gets or sets the app product.
            /// </summary>
            /// <value>
            /// The app product.
            /// </value>
            public static string AppProduct { get; set; }
            /// <summary>
            /// Gets or sets the contact info.
            /// </summary>
            /// <value>
            /// The contact info.
            /// </value>
            public static string ContactInfo { get; set; }
            /// <summary>
            /// Gets or sets the email to.
            /// </summary>
            /// <value>
            /// The email to.
            /// </value>
            public static string EmailTo { get; set; }
            /// <summary>
            /// Gets or sets the email from.
            /// </summary>
            /// <value>
            /// The email from.
            /// </value>
            public static string EmailFrom { get; set; }
            /// <summary>
            /// Gets or sets a value indicating whether [debug mode].
            /// </summary>
            /// <value>
            ///   <c>true</c> if [debug mode]; otherwise, <c>false</c>.
            /// </value>
            public static bool DebugMode { get; set; }
            /// <summary>
            /// Gets or sets a value indicating whether [ignore debug errors].
            /// </summary>
            /// <value>
            ///   <c>true</c> if [ignore debug errors]; otherwise, <c>false</c>.
            /// </value>
            public static bool IgnoreDebugErrors { get; set; }
            /// <summary>
            /// Gets or sets a value indicating whether [display dialog].
            /// </summary>
            /// <value>
            ///   <c>true</c> if [display dialog]; otherwise, <c>false</c>.
            /// </value>
            public static bool DisplayDialog { get; set; }
            /// <summary>
            /// Gets or sets a value indicating whether [email screenshot].
            /// </summary>
            /// <value>
            ///   <c>true</c> if [email screenshot]; otherwise, <c>false</c>.
            /// </value>
            public static bool EmailScreenshot { get; set; }
            /// <summary>
            /// Gets or sets a value indicating whether [kill app on exception].
            /// </summary>
            /// <value>
            ///   <c>true</c> if [kill app on exception]; otherwise, <c>false</c>.
            /// </value>
            public static bool KillAppOnException { get; set; }
            /// <summary>
            /// Gets or sets a value indicating whether [log to file].
            /// </summary>
            /// <value>
            ///   <c>true</c> if [log to file]; otherwise, <c>false</c>.
            /// </value>
            public static bool LogToFile { get; set; }
            /// <summary>
            /// Gets or sets a value indicating whether [log to event log].
            /// </summary>
            /// <value>
            ///   <c>true</c> if [log to event log]; otherwise, <c>false</c>.
            /// </value>
            public static bool LogToEventLog { get; set; }
            /// <summary>
            /// Gets or sets a value indicating whether [send email].
            /// </summary>
            /// <value>
            ///   <c>true</c> if [send email]; otherwise, <c>false</c>.
            /// </value>
            public static bool SendEmail { get; set; }
            /// <summary>
            /// Gets or sets a value indicating whether [take screenshot].
            /// </summary>
            /// <value>
            ///   <c>true</c> if [take screenshot]; otherwise, <c>false</c>.
            /// </value>
            public static bool TakeScreenshot { get; set; }
            /// <summary>
            /// Gets or sets the screenshot image format.
            /// </summary>
            /// <value>
            /// The screenshot image format.
            /// </value>
            public static ImageFormat ScreenshotImageFormat { get; set; }

            static Settings()
            {
                AppProduct = "";
                ContactInfo = "";
                EmailTo = "";
                EmailFrom = "";
                DebugMode = false;
                ScreenshotImageFormat = System.Drawing.Imaging.ImageFormat.Png;
                SendEmail = true;
                TakeScreenshot = true;
                EmailScreenshot = true;
                LogToEventLog = false;
                LogToFile = true;
                DisplayDialog = true;
                IgnoreDebugErrors = true;
                KillAppOnException = true;
            }
        }
    }
}