using System;
using System.Diagnostics;
using System.Drawing;
using System.Threading;
using System.Windows.Forms;
using CSH.Exchequer.Bespoke.Network.Email;

namespace CSH.Exchequer.Bespoke.ErrorHandling
{
    /// <summary>
    /// Provides standard exception handling services to your application
    /// </summary>
    public partial class ExceptionManager
    {
        /// <summary>
        /// Provides standard exception handling for exceptions you expect your application to throw
        /// It's like a MessageBox, but specific to handled exceptions, and supports email notifications
        /// </summary>
        public class Handled
        {
            private static bool _blnHaveException = false;
            private static bool _blnEmailError = true;
            private static string _strEmailBody;
            private static string _strExceptionType;

            private const string _strDefaultMore = "No further information is available. If the problem persists, contact (contact).";
            /// <summary>
            /// Gets or sets a value indicating whether to email the error.
            /// </summary>
            /// <value>
            ///   <c>true</c> if [email error]; otherwise, <c>false</c>.
            /// </value>
            public static bool IsErrorToBeEmailed
            {
                get { return _blnEmailError; }
                set { _blnEmailError = value; }
            }

            /// <summary>
            /// Friendly names for the default button selection on the handled exception form
            /// </summary>
            public enum UserErrorDefaultButton
            {
                /// <summary>
                /// Default
                /// </summary>
                Default = 0,
                /// <summary>
                /// Button1
                /// </summary>
                Button1 = 1,
                /// <summary>
                /// Button2
                /// </summary>
                Button2 = 2,
                /// <summary>
                /// Button3
                /// </summary>
                Button3 = 3
            }

            /// <summary>
            /// replace generic constants in strings with specific values
            /// </summary>
            /// <param name="output">output.</param>
            /// <returns></returns>
            private static string ReplaceStringVals(string output)
            {
                string strTemp = null;
                if (output == null)
                {
                    strTemp = "";
                }
                else
                {
                    strTemp = output;
                }
                strTemp = strTemp.Replace("(app)", Settings.AppProduct);
                strTemp = strTemp.Replace("(contact)", Settings.ContactInfo);
                return strTemp;
            }

            /// <summary>
            /// make sure "More" text is populated with something useful
            /// </summary>
            /// <param name="moreDetails">more details.</param>
            /// <returns></returns>
            private static string GetDefaultMore(string moreDetails)
            {
                if (string.IsNullOrEmpty(moreDetails))
                {
                    System.Text.StringBuilder objStringBuilder = new System.Text.StringBuilder();
                    objStringBuilder.Append(_strDefaultMore);
                    objStringBuilder.Append(Environment.NewLine);
                    objStringBuilder.Append(Environment.NewLine);
                    objStringBuilder.Append("Basic technical information follows: " + Environment.NewLine);
                    objStringBuilder.Append("---" + Environment.NewLine);
                    objStringBuilder.Append(Unhandled.SysInfoToString(true));
                    return objStringBuilder.ToString();
                }
                else
                {
                    return moreDetails;
                }
            }

            /// <summary>
            /// converts exception to a formatted "more" string
            /// </summary>
            /// <param name="exception">The obj exception.</param>
            /// <returns></returns>
            private static string ExceptionToMore(System.Exception exception)
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                if (_blnEmailError)
                {
                    sb.Append("Information about this problem was automatically mailed to ");
                    sb.Append(Settings.EmailTo);
                    sb.Append(Environment.NewLine + Environment.NewLine);
                }
                sb.Append("Detailed technical information follows: " + Environment.NewLine);
                sb.Append("---" + Environment.NewLine);
                string x = Unhandled.ExceptionToString(exception);
                sb.Append(x);
                return sb.ToString();
            }

            /// <summary>
            /// perform our string replacements for (app) and (contact), etc etc
            /// also make sure More has default values if it is blank.
            /// </summary>
            /// <param name="whatHappened">what happened.</param>
            /// <param name="howUserAffected">how user affected.</param>
            /// <param name="whatUserCanDo">what user can do.</param>
            /// <param name="moreDetails">more details.</param>
            private static void ProcessStrings(ref string whatHappened, ref string howUserAffected, ref string whatUserCanDo, ref string moreDetails)
            {
                whatHappened = ReplaceStringVals(whatHappened);
                howUserAffected = ReplaceStringVals(howUserAffected);
                whatUserCanDo = ReplaceStringVals(whatUserCanDo);
                moreDetails = ReplaceStringVals(GetDefaultMore(moreDetails));
            }


            /// <summary>
            /// Shows the simplest possible error dialog.
            /// </summary>
            /// <param name="whatHappened">The what happened.</param>
            /// <param name="howUserAffected">The how user affected.</param>
            /// <param name="whatUserCanDo">The what user can do.</param>
            /// <param name="owner">The owner.</param>
            /// <returns></returns>
            public static DialogResult ShowDialog(string whatHappened, string howUserAffected, string whatUserCanDo, IWin32Window owner = null)
            {
                _blnHaveException = false;
                return ShowDialogInternal(whatHappened, howUserAffected, whatUserCanDo, "", MessageBoxButtons.OK, MessageBoxIcon.Warning, UserErrorDefaultButton.Default, owner);
            }


            /// <summary>
            /// Shows the advanced error dialog with Exception object.
            /// </summary>
            /// <param name="whatHappened">The what happened.</param>
            /// <param name="howUserAffected">The how user affected.</param>
            /// <param name="whatUserCanDo">The what user can do.</param>
            /// <param name="exception">The exception.</param>
            /// <param name="owner">The owner.</param>
            /// <param name="buttons">The buttons.</param>
            /// <param name="icon">The icon.</param>
            /// <param name="defaultButton">The default button.</param>
            /// <returns></returns>
            public static DialogResult ShowDialog(string whatHappened, string howUserAffected, string whatUserCanDo, System.Exception exception, IWin32Window owner = null, MessageBoxButtons buttons = MessageBoxButtons.OK, MessageBoxIcon icon = MessageBoxIcon.Warning, UserErrorDefaultButton defaultButton = UserErrorDefaultButton.Default)
            {
                _blnHaveException = true;
                _strExceptionType = exception.GetType().FullName;
                return ShowDialogInternal(whatHappened, howUserAffected, whatUserCanDo, ExceptionToMore(exception), buttons, icon, defaultButton, owner);
            }


            /// <summary>
            /// Shows the advanced error dialog with More string.
            /// leave "more" string blank to get the default
            /// </summary>
            /// <param name="whatHappened">The what happened.</param>
            /// <param name="howUserAffected">The how user affected.</param>
            /// <param name="whatUserCanDo">The what user can do.</param>
            /// <param name="moreDetails">The more details.</param>
            /// <param name="owner">The owner.</param>
            /// <param name="buttons">The buttons.</param>
            /// <param name="icon">The icon.</param>
            /// <param name="defaultButton">The default button.</param>
            /// <returns></returns>
            public static DialogResult ShowDialog(string whatHappened, string howUserAffected, string whatUserCanDo, string moreDetails, IWin32Window owner = null, MessageBoxButtons buttons = MessageBoxButtons.OK, MessageBoxIcon icon = MessageBoxIcon.Warning, UserErrorDefaultButton defaultButton = UserErrorDefaultButton.Default)
            {
                _blnHaveException = false;
                return ShowDialogInternal(whatHappened, howUserAffected, whatUserCanDo, moreDetails, buttons, icon, defaultButton, owner);
            }


            /// <summary>
            /// Shows the dialog internal.
            /// </summary>
            /// <param name="whatHappened">The what happened.</param>
            /// <param name="howUserAffected">The how user affected.</param>
            /// <param name="whatUserCanDo">The what user can do.</param>
            /// <param name="moreDetails">The more details.</param>
            /// <param name="buttons">The buttons.</param>
            /// <param name="icon">The icon.</param>
            /// <param name="defaultButton">The default button.</param>
            /// <param name="owner">The owner.</param>
            /// <returns></returns>
            private static DialogResult ShowDialogInternal(string whatHappened, string howUserAffected, string whatUserCanDo, string moreDetails, MessageBoxButtons buttons, MessageBoxIcon icon, UserErrorDefaultButton defaultButton, IWin32Window owner)
            {
                DialogResult result;
                //-- set default values, etc
                ProcessStrings(ref whatHappened, ref howUserAffected, ref whatUserCanDo, ref moreDetails);

                using (ExceptionDialog objForm = new ExceptionDialog())
                {
                    objForm.Text = ReplaceStringVals(objForm.Text);
                    objForm.ErrorBox.Text = whatHappened;
                    objForm.ScopeBox.Text = howUserAffected;
                    objForm.ActionBox.Text = whatUserCanDo;
                    objForm.txtMore.Text = moreDetails;

                    //-- determine what button text, visibility, and defaults are
                    switch (buttons)
                    {
                        case MessageBoxButtons.AbortRetryIgnore:
                            objForm.btn1.Text = "&Abort";
                            objForm.btn2.Text = "&Retry";
                            objForm.btn3.Text = "&Ignore";
                            objForm.AcceptButton = objForm.btn2;
                            objForm.CancelButton = objForm.btn3;
                            break;
                        case MessageBoxButtons.OK:
                            objForm.btn3.Text = "OK";
                            objForm.btn2.Visible = false;
                            objForm.btn1.Visible = false;
                            objForm.AcceptButton = objForm.btn3;
                            break;
                        case MessageBoxButtons.OKCancel:
                            objForm.btn3.Text = "Cancel";
                            objForm.btn2.Text = "OK";
                            objForm.btn1.Visible = false;
                            objForm.AcceptButton = objForm.btn2;
                            objForm.CancelButton = objForm.btn3;
                            break;
                        case MessageBoxButtons.RetryCancel:
                            objForm.btn3.Text = "Cancel";
                            objForm.btn2.Text = "&Retry";
                            objForm.btn1.Visible = false;
                            objForm.AcceptButton = objForm.btn2;
                            objForm.CancelButton = objForm.btn3;
                            break;
                        case MessageBoxButtons.YesNo:
                            objForm.btn3.Text = "&No";
                            objForm.btn2.Text = "&Yes";
                            objForm.btn1.Visible = false;
                            break;
                        case MessageBoxButtons.YesNoCancel:
                            objForm.btn3.Text = "Cancel";
                            objForm.btn2.Text = "&No";
                            objForm.btn1.Text = "&Yes";
                            objForm.CancelButton = objForm.btn3;
                            break;
                    }

                    //'-- set the proper dialog icon
                    MessageBoxIcon PictureBox1 = icon;
                    if (PictureBox1 == MessageBoxIcon.Hand)
                    {
                        objForm.PictureBox1.Image = SystemIcons.Error.ToBitmap();
                    }
                    else if (PictureBox1 == MessageBoxIcon.Hand)
                    {
                        objForm.PictureBox1.Image = SystemIcons.Error.ToBitmap();
                    }
                    else if (PictureBox1 == MessageBoxIcon.Exclamation)
                    {
                        objForm.PictureBox1.Image = SystemIcons.Exclamation.ToBitmap();
                    }
                    else if (PictureBox1 == MessageBoxIcon.Asterisk)
                    {
                        objForm.PictureBox1.Image = SystemIcons.Information.ToBitmap();
                    }
                    else if (PictureBox1 == MessageBoxIcon.Question)
                    {
                        objForm.PictureBox1.Image = SystemIcons.Question.ToBitmap();
                    }
                    else
                    {
                        objForm.PictureBox1.Image = SystemIcons.Error.ToBitmap();
                    }

                    //-- override the default button
                    switch (defaultButton)
                    {
                        case UserErrorDefaultButton.Button1:
                            objForm.AcceptButton = objForm.btn1;
                            objForm.btn1.TabIndex = 0;
                            break;
                        case UserErrorDefaultButton.Button2:
                            objForm.AcceptButton = objForm.btn2;
                            objForm.btn2.TabIndex = 0;
                            break;
                        case UserErrorDefaultButton.Button3:
                            objForm.AcceptButton = objForm.btn3;
                            objForm.btn3.TabIndex = 0;
                            break;
                    }

                    if (_blnEmailError)
                    {
                        SendNotificationEmail(whatHappened, howUserAffected, whatUserCanDo, moreDetails);
                    }

                    //-- show the user our error dialog
                    if (owner == null)
                    {
                        result = objForm.ShowDialog();
                    }
                    else
                    {
                        result = objForm.ShowDialog(owner);
                    }

                    return result;
                }
            }

            /// <summary>
            /// this is the code that executes in the spawned thread
            /// </summary>
            private static void ThreadHandler()
            {
                EmailClient smtp = new EmailClient();
                EmailMessage mail = new EmailMessage();

                mail.To = Settings.EmailTo;
                mail.From = Settings.EmailFrom;

                if (_blnHaveException)
                {
                    mail.Subject = "Handled Exception notification - " + _strExceptionType;
                }
                else
                {
                    mail.Subject = "HandledExceptionManager notification";
                }
                mail.Body = _strEmailBody;
                //-- try to send email, but we don't care if it succeeds (for now)
                try
                {
                    smtp.SendMail(mail);
                }
                catch (Exception e)
                {
                    Debug.WriteLine("** SMTP email failed to send!");
                    Debug.WriteLine("** " + e.Message);
                }
            }

            /// <summary>
            /// Send notification about this error via e-mail
            /// </summary>
            /// <param name="whatHappened">what happened.</param>
            /// <param name="howUserAffected">how user affected.</param>
            /// <param name="whatUserCanDo">what user can do.</param>
            /// <param name="moreDetails">more details.</param>
            private static void SendNotificationEmail(string whatHappened, string howUserAffected, string whatUserCanDo, string moreDetails)
            {
                //-- ignore debug exceptions (eg, development testing)?
                if (ExceptionManager.Settings.IgnoreDebugErrors)
                {
                    if (Settings.DebugMode)
                        return;
                }

                System.Text.StringBuilder objStringBuilder = new System.Text.StringBuilder();

                objStringBuilder.Append("What happened:");
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(whatHappened);
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append("How this will affect the user:");
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(howUserAffected);
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append("What the user can do about it:");
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(whatUserCanDo);
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append("More information:");
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(moreDetails);
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(Environment.NewLine);
                SendEmail(objStringBuilder.ToString());
            }

            /// <summary>
            /// Sends the email.
            /// </summary>
            /// <param name="mailBody">The email body.</param>
            private static void SendEmail(string mailBody)
            {
                _strEmailBody = mailBody;
                //-- spawn off the email send attempt as a thread for improved throughput
                Thread objThread = new Thread(new ThreadStart(ThreadHandler));
                objThread.Name = "HandledExceptionEmail";
                objThread.Start();
            }
        }
    }
}