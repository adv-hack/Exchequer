using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Enterprise;
using System.Diagnostics;
using CSH.Exchequer.Bespoke.Diagnostics;

namespace CSH.Exchequer.Bespoke.UI
{
    /// <summary>
    /// Provides static methods simplifiying the display of various types of MessageBox
    /// </summary>
    public class Notification
    {
        /// <summary>
        /// Gets the exchequer message box buttons.
        /// </summary>
        /// <param name="buttons">The buttons.</param>
        /// <returns></returns>
        private static int GetExchequerMessageBoxButtons(MessageBoxButtons buttons)
        {
            int result = 0;
            switch (buttons)
            {
                case MessageBoxButtons.OK:
                    result = (int)TEntMsgDlgButtons.embOK;
                    break;
                case MessageBoxButtons.OKCancel:
                    result = (int)(TEntMsgDlgButtons.embOK | TEntMsgDlgButtons.embCancel);
                    break;
                case MessageBoxButtons.YesNo:
                    result = (int)(TEntMsgDlgButtons.embYes | TEntMsgDlgButtons.embNo);
                    break;
                case MessageBoxButtons.YesNoCancel:
                    result = (int)(TEntMsgDlgButtons.embYes | TEntMsgDlgButtons.embNo | TEntMsgDlgButtons.embCancel);
                    break;
                case MessageBoxButtons.AbortRetryIgnore:
                    result = (int)(TEntMsgDlgButtons.embAbort | TEntMsgDlgButtons.embRetry | TEntMsgDlgButtons.embIgnore);
                    break;
            }

            return result;
        }

        /// <summary>
        /// Gets the type of the exchequer dialog.
        /// </summary>
        /// <param name="icon">The icon.</param>
        /// <returns></returns>
        private static TEntMsgDlgType GetExchequerDialogType(MessageBoxIcon icon)
        {
            TEntMsgDlgType result = TEntMsgDlgType.emtCustom;

            switch (icon)
            {
                case MessageBoxIcon.None:
                    result = TEntMsgDlgType.emtCustom;
                    break;
                case MessageBoxIcon.Information:
                    result = TEntMsgDlgType.emtInformation;
                    break;
                case MessageBoxIcon.Error:
                    result = TEntMsgDlgType.emtError;
                    break;
                case MessageBoxIcon.Warning:
                    result = TEntMsgDlgType.emtWarning;
                    break;
                case MessageBoxIcon.Question:
                    result = TEntMsgDlgType.emtConfirmation;
                    break;
            }

            return result;
        }

        /// <summary>
        /// Gets the dialog result.
        /// </summary>
        /// <param name="exchequerDialogResult">The exchequer dialog result.</param>
        /// <returns></returns>
        private static DialogResult GetDialogResult(TentMsgDlgReturn exchequerDialogResult)
        {
            DialogResult result = DialogResult.None;

            switch (exchequerDialogResult)
            {
                case TentMsgDlgReturn.emrAbort:
                    result = DialogResult.Abort;
                    break;
                case TentMsgDlgReturn.emrAll:
                    result = DialogResult.OK;
                    break;
                case TentMsgDlgReturn.emrCancel:
                    result = DialogResult.Cancel;
                    break;
                case TentMsgDlgReturn.emrIgnore:
                    result = DialogResult.Ignore;
                    break;
                case TentMsgDlgReturn.emrNo:
                    result = DialogResult.No;
                    break;
                case TentMsgDlgReturn.emrNone:
                    result = DialogResult.None;
                    break;
                case TentMsgDlgReturn.emrNoToAll:
                    result = DialogResult.No;
                    break;
                case TentMsgDlgReturn.emrOk:
                    result = DialogResult.OK;
                    break;
                case TentMsgDlgReturn.emrRetry:
                    result = DialogResult.Retry;
                    break;
                case TentMsgDlgReturn.emrYes:
                    result = DialogResult.Yes;
                    break;
                case TentMsgDlgReturn.emrYesToAll:
                    result = DialogResult.Yes;
                    break;
            }

            return result;
        }

        /// <summary>
        /// Shows the message box.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="caption">The caption.</param>
        /// <param name="icon">The icon.</param>
        /// <param name="buttons">The buttons.</param>
        /// <returns></returns>
        public static DialogResult ShowMessageBox(string message, string caption, MessageBoxIcon icon, MessageBoxButtons buttons = MessageBoxButtons.OK)
        {
            return MessageBox.Show(message, caption, buttons, icon, MessageBoxDefaultButton.Button1, 0, false);
        }

        /// <summary>
        /// Shows the message box.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="icon">The icon.</param>
        /// <param name="customisation">The customisation.</param>
        /// <param name="buttons">The buttons.</param>
        /// <returns></returns>
        public static DialogResult ShowMessageBox(string message, MessageBoxIcon icon, ICOMCustomisation customisation, MessageBoxButtons buttons = MessageBoxButtons.OK)
        {
            TEntMsgDlgType dialogType = GetExchequerDialogType(icon);
            TentMsgDlgReturn exchequerDialogResult = customisation.SysFunc.entMessageDlg(dialogType, message, GetExchequerMessageBoxButtons(buttons));
            DialogResult result = GetDialogResult(exchequerDialogResult);

            return result;
        }

        /// <summary>
        /// Shows the customisation error.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="errorNo">The error no.</param>
        /// <param name="COMCustomisation">The COM customisation.</param>
        public static void ShowCustomisationError(string message, int errorNo, COMCustomisation COMCustomisation)
        {
            if (errorNo != 0)
                COMCustomisation.SysFunc.entMessageDlg(TEntMsgDlgType.emtError, 
                                                      "Error : " + errorNo.ToString() + "\r\n\r\n" + message, 
                                                      (int)TEntMsgDlgButtons.embOK);
        }

        /// <summary>
        /// Shows the error and logs it.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="caption">The caption.</param>
        /// <param name="log">The log.</param>
        public static void ShowLogError(string message, string caption, ILog log)
        {
            if (log == null)
            {
                MessageBox.Show(message, caption, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            else
            {
                log.TraceEvent(TraceEventType.Error, 1, message);
            }
        }

    }
}
