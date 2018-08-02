/*****************************************************************************************/
/* ***************************************************************************************
 * ExceptionDialogue.cs
 * ***************************************************************************************/
/*****************************************************************************************/
//'--
//'--
//'-- Jeff Atwood
//'-- http://www.codinghorror.com
//'--



using System;
using System.Drawing;
using System.Windows.Forms;
using CSH.Exchequer.Bespoke.Resources;

namespace CSH.Exchequer.Bespoke.ErrorHandling
{
    /// <summary>
    /// Generic user error dialog
    /// UI adapted from
    /// Alan Cooper's "About Face: The Essentials of User Interface Design"
    /// Chapter VII, "The End of Errors", pages 423-440
    ///</summary>
    internal class ExceptionDialog : System.Windows.Forms.Form
    {
        #region " Windows Form Designer generated code "

        public ExceptionDialog()
            : base()
        {
            Load += UserErrorDialog_Load;

            //This call is required by the Windows Form Designer.
            InitializeComponent();

            //Add any initialization after the InitializeComponent() call
            ResourceReader reader = new ResourceReader();
            Icon = new System.Drawing.Icon(reader.Read(ResourceName.IRISBallIcon));
        }

        //Form overrides dispose to clean up the component list.
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if ((components != null))
                {
                    components.Dispose();
                }
            }
            base.Dispose(disposing);
        }

        //Required by the Windows Form Designer

        private System.ComponentModel.IContainer components = null;
        //NOTE: The following procedure is required by the Windows Form Designer
        //It can be modified using the Windows Form Designer.
        //Do not modify it using the code editor.
        private System.Windows.Forms.Button withEventsField_btn1;

        internal System.Windows.Forms.Button btn1
        {
            get { return withEventsField_btn1; }
            set
            {
                if (withEventsField_btn1 != null)
                {
                    withEventsField_btn1.Click -= btn1_Click;
                }
                withEventsField_btn1 = value;
                if (withEventsField_btn1 != null)
                {
                    withEventsField_btn1.Click += btn1_Click;
                }
            }
        }

        private System.Windows.Forms.Button withEventsField_btn2;

        internal System.Windows.Forms.Button btn2
        {
            get { return withEventsField_btn2; }
            set
            {
                if (withEventsField_btn2 != null)
                {
                    withEventsField_btn2.Click -= btn2_Click;
                }
                withEventsField_btn2 = value;
                if (withEventsField_btn2 != null)
                {
                    withEventsField_btn2.Click += btn2_Click;
                }
            }
        }

        private System.Windows.Forms.Button withEventsField_btn3;

        internal System.Windows.Forms.Button btn3
        {
            get { return withEventsField_btn3; }
            set
            {
                if (withEventsField_btn3 != null)
                {
                    withEventsField_btn3.Click -= btn3_Click;
                }
                withEventsField_btn3 = value;
                if (withEventsField_btn3 != null)
                {
                    withEventsField_btn3.Click += btn3_Click;
                }
            }
        }

        internal System.Windows.Forms.PictureBox PictureBox1;
        internal System.Windows.Forms.Label lblErrorHeading;
        internal System.Windows.Forms.Label lblScopeHeading;
        internal System.Windows.Forms.Label lblActionHeading;
        internal System.Windows.Forms.Label lblMoreHeading;
        internal System.Windows.Forms.TextBox txtMore;
        private System.Windows.Forms.Button withEventsField_btnMore;

        internal System.Windows.Forms.Button btnMore
        {
            get { return withEventsField_btnMore; }
            set
            {
                if (withEventsField_btnMore != null)
                {
                    withEventsField_btnMore.Click -= btnMore_Click;
                }
                withEventsField_btnMore = value;
                if (withEventsField_btnMore != null)
                {
                    withEventsField_btnMore.Click += btnMore_Click;
                }
            }
        }

        private System.Windows.Forms.RichTextBox withEventsField_ErrorBox;

        internal System.Windows.Forms.RichTextBox ErrorBox
        {
            get { return withEventsField_ErrorBox; }
            set
            {
                if (withEventsField_ErrorBox != null)
                {
                    withEventsField_ErrorBox.LinkClicked -= ErrorBox_LinkClicked;
                }
                withEventsField_ErrorBox = value;
                if (withEventsField_ErrorBox != null)
                {
                    withEventsField_ErrorBox.LinkClicked += ErrorBox_LinkClicked;
                }
            }
        }

        private System.Windows.Forms.RichTextBox withEventsField_ScopeBox;

        internal System.Windows.Forms.RichTextBox ScopeBox
        {
            get { return withEventsField_ScopeBox; }
            set
            {
                if (withEventsField_ScopeBox != null)
                {
                    withEventsField_ScopeBox.LinkClicked -= ScopeBox_LinkClicked;
                }
                withEventsField_ScopeBox = value;
                if (withEventsField_ScopeBox != null)
                {
                    withEventsField_ScopeBox.LinkClicked += ScopeBox_LinkClicked;
                }
            }
        }

        private System.Windows.Forms.RichTextBox withEventsField_ActionBox;

        internal System.Windows.Forms.RichTextBox ActionBox
        {
            get { return withEventsField_ActionBox; }
            set
            {
                if (withEventsField_ActionBox != null)
                {
                    withEventsField_ActionBox.LinkClicked -= ActionBox_LinkClicked;
                }
                withEventsField_ActionBox = value;
                if (withEventsField_ActionBox != null)
                {
                    withEventsField_ActionBox.LinkClicked += ActionBox_LinkClicked;
                }
            }
        }

        [System.Diagnostics.DebuggerStepThrough()]
        private void InitializeComponent()
        {
            this.PictureBox1 = new System.Windows.Forms.PictureBox();
            this.lblErrorHeading = new System.Windows.Forms.Label();
            this.ErrorBox = new System.Windows.Forms.RichTextBox();
            this.lblScopeHeading = new System.Windows.Forms.Label();
            this.ScopeBox = new System.Windows.Forms.RichTextBox();
            this.lblActionHeading = new System.Windows.Forms.Label();
            this.ActionBox = new System.Windows.Forms.RichTextBox();
            this.lblMoreHeading = new System.Windows.Forms.Label();
            this.btn1 = new System.Windows.Forms.Button();
            this.btn2 = new System.Windows.Forms.Button();
            this.btn3 = new System.Windows.Forms.Button();
            this.txtMore = new System.Windows.Forms.TextBox();
            this.btnMore = new System.Windows.Forms.Button();
            this.SuspendLayout();
            //
            //PictureBox1
            //
            this.PictureBox1.Location = new System.Drawing.Point(8, 8);
            this.PictureBox1.Name = "PictureBox1";
            this.PictureBox1.Size = new System.Drawing.Size(32, 32);
            this.PictureBox1.TabIndex = 0;
            this.PictureBox1.TabStop = false;
            //
            //lblErrorHeading
            //
            this.lblErrorHeading.AutoSize = true;
            this.lblErrorHeading.Font = new System.Drawing.Font("Tahoma", 8f, System.Drawing.FontStyle.Bold);
            this.lblErrorHeading.Location = new System.Drawing.Point(48, 4);
            this.lblErrorHeading.Name = "lblErrorHeading";
            this.lblErrorHeading.Size = new System.Drawing.Size(91, 16);
            this.lblErrorHeading.TabIndex = 0;
            this.lblErrorHeading.Text = "What happened";
            //
            //ErrorBox
            //
            this.ErrorBox.Anchor = (System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) | System.Windows.Forms.AnchorStyles.Right);
            this.ErrorBox.BackColor = System.Drawing.SystemColors.Control;
            this.ErrorBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.ErrorBox.CausesValidation = false;
            this.ErrorBox.Location = new System.Drawing.Point(48, 24);
            this.ErrorBox.Name = "ErrorBox";
            this.ErrorBox.ReadOnly = true;
            this.ErrorBox.ScrollBars = System.Windows.Forms.RichTextBoxScrollBars.Vertical;
            this.ErrorBox.Size = new System.Drawing.Size(416, 64);
            this.ErrorBox.TabIndex = 1;
            this.ErrorBox.Text = "(error message)";
            //
            //lblScopeHeading
            //
            this.lblScopeHeading.AutoSize = true;
            this.lblScopeHeading.Font = new System.Drawing.Font("Tahoma", 8f, System.Drawing.FontStyle.Bold);
            this.lblScopeHeading.Location = new System.Drawing.Point(8, 92);
            this.lblScopeHeading.Name = "lblScopeHeading";
            this.lblScopeHeading.Size = new System.Drawing.Size(134, 16);
            this.lblScopeHeading.TabIndex = 2;
            this.lblScopeHeading.Text = "How this will affect you";
            //
            //ScopeBox
            //
            this.ScopeBox.Anchor = (System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) | System.Windows.Forms.AnchorStyles.Right);
            this.ScopeBox.BackColor = System.Drawing.SystemColors.Control;
            this.ScopeBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.ScopeBox.CausesValidation = false;
            this.ScopeBox.Location = new System.Drawing.Point(24, 112);
            this.ScopeBox.Name = "ScopeBox";
            this.ScopeBox.ReadOnly = true;
            this.ScopeBox.ScrollBars = System.Windows.Forms.RichTextBoxScrollBars.Vertical;
            this.ScopeBox.Size = new System.Drawing.Size(440, 64);
            this.ScopeBox.TabIndex = 3;
            this.ScopeBox.Text = "(scope)";
            //
            //lblActionHeading
            //
            this.lblActionHeading.AutoSize = true;
            this.lblActionHeading.Font = new System.Drawing.Font("Tahoma", 8f, System.Drawing.FontStyle.Bold);
            this.lblActionHeading.Location = new System.Drawing.Point(8, 180);
            this.lblActionHeading.Name = "lblActionHeading";
            this.lblActionHeading.Size = new System.Drawing.Size(143, 16);
            this.lblActionHeading.TabIndex = 4;
            this.lblActionHeading.Text = "What you can do about it";
            //
            //ActionBox
            //
            this.ActionBox.Anchor = (System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) | System.Windows.Forms.AnchorStyles.Right);
            this.ActionBox.BackColor = System.Drawing.SystemColors.Control;
            this.ActionBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.ActionBox.CausesValidation = false;
            this.ActionBox.Location = new System.Drawing.Point(24, 200);
            this.ActionBox.Name = "ActionBox";
            this.ActionBox.ReadOnly = true;
            this.ActionBox.ScrollBars = System.Windows.Forms.RichTextBoxScrollBars.Vertical;
            this.ActionBox.Size = new System.Drawing.Size(440, 92);
            this.ActionBox.TabIndex = 5;
            this.ActionBox.Text = "(action)";
            //
            //lblMoreHeading
            //
            this.lblMoreHeading.AutoSize = true;
            this.lblMoreHeading.Font = new System.Drawing.Font("Tahoma", 8f, System.Drawing.FontStyle.Bold);
            this.lblMoreHeading.Location = new System.Drawing.Point(8, 300);
            this.lblMoreHeading.Name = "lblMoreHeading";
            this.lblMoreHeading.TabIndex = 6;
            this.lblMoreHeading.Text = "More information";
            //
            //btn1
            //
            this.btn1.Anchor = (System.Windows.Forms.AnchorStyles)(System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right);
            this.btn1.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btn1.Location = new System.Drawing.Point(220, 544);
            this.btn1.Name = "btn1";
            this.btn1.TabIndex = 9;
            this.btn1.Text = "Button1";
            //
            //btn2
            //
            this.btn2.Anchor = (System.Windows.Forms.AnchorStyles)(System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right);
            this.btn2.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btn2.Location = new System.Drawing.Point(304, 544);
            this.btn2.Name = "btn2";
            this.btn2.TabIndex = 10;
            this.btn2.Text = "Button2";
            //
            //btn3
            //
            this.btn3.Anchor = (System.Windows.Forms.AnchorStyles)(System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right);
            this.btn3.Location = new System.Drawing.Point(388, 544);
            this.btn3.Name = "btn3";
            this.btn3.TabIndex = 11;
            this.btn3.Text = "Button3";
            //
            //txtMore
            //
            this.txtMore.Anchor = (System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) | System.Windows.Forms.AnchorStyles.Left) | System.Windows.Forms.AnchorStyles.Right);
            this.txtMore.CausesValidation = false;
            this.txtMore.Font = new System.Drawing.Font("Lucida Console", 8.25f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, Convert.ToByte(0));
            this.txtMore.Location = new System.Drawing.Point(8, 324);
            this.txtMore.Multiline = true;
            this.txtMore.Name = "txtMore";
            this.txtMore.ReadOnly = true;
            this.txtMore.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtMore.Size = new System.Drawing.Size(456, 212);
            this.txtMore.TabIndex = 8;
            this.txtMore.Text = "(detailed information, such as exception details)";
            //
            //btnMore
            //
            this.btnMore.Location = new System.Drawing.Point(112, 296);
            this.btnMore.Name = "btnMore";
            this.btnMore.Size = new System.Drawing.Size(28, 24);
            this.btnMore.TabIndex = 7;
            this.btnMore.Text = ">>";
            //
            //ExceptionDialog
            //
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(472, 573);
            this.Controls.Add(this.btnMore);
            this.Controls.Add(this.txtMore);
            this.Controls.Add(this.btn3);
            this.Controls.Add(this.btn2);
            this.Controls.Add(this.btn1);
            this.Controls.Add(this.lblMoreHeading);
            this.Controls.Add(this.lblActionHeading);
            this.Controls.Add(this.lblScopeHeading);
            this.Controls.Add(this.lblErrorHeading);
            this.Controls.Add(this.ActionBox);
            this.Controls.Add(this.ScopeBox);
            this.Controls.Add(this.ErrorBox);
            this.Controls.Add(this.PictureBox1);
            this.MinimizeBox = false;
            this.Name = "ExceptionDialog";
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Show;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "(app) has encountered a problem";
            this.TopMost = true;
            this.ResumeLayout(false);
        }

        #endregion " Windows Form Designer generated code "

        const int _intSpacing = 10;

        /// <summary>
        /// security-safe process.start wrapper
        /// </summary>
        /// <param name="strUrl">The STR URL.</param>
        private void LaunchLink(string strUrl)
        {
            try
            {
                System.Diagnostics.Process.Start(strUrl);
            }
            catch (System.Security.SecurityException)
            {
                //-- do nothing; we can't launch without full trust.
            }
        }

        /// <summary>
        /// Sizes the box.
        /// </summary>
        /// <param name="ctl">The control</param>
        private void SizeBox(System.Windows.Forms.RichTextBox ctl)
        {
            Graphics g = null;
            try
            {
                //-- note that the height is taken as MAXIMUM, so size the label for maximum desired height!
                g = Graphics.FromHwnd(ctl.Handle);
                SizeF objSizeF = g.MeasureString(ctl.Text, ctl.Font, new SizeF(ctl.Width, ctl.Height));
                //g.Dispose();
                ctl.Height = Convert.ToInt32(objSizeF.Height) + 5;
            }
            catch (System.Security.SecurityException)
            {
                //-- do nothing; we can't set control sizes without full trust
            }
            finally
            {
                if ((g != null))
                    g.Dispose();
            }
        }

        /// <summary>
        /// Determines the dialog result.
        /// </summary>
        /// <param name="strButtonText">The STR button text.</param>
        /// <returns></returns>
        private System.Windows.Forms.DialogResult DetermineDialogResult(string strButtonText)
        {
            DialogResult returnVal = DialogResult.None;

            //-- strip any accelerator keys we might have
            strButtonText = strButtonText.Replace("&", "");
            switch (strButtonText.ToLower())
            {
                case "abort":
                    return System.Windows.Forms.DialogResult.Abort;
                case "cancel":
                    return System.Windows.Forms.DialogResult.Cancel;
                case "ignore":
                    return System.Windows.Forms.DialogResult.Ignore;
                case "no":
                    return System.Windows.Forms.DialogResult.No;
                case "none":
                    return System.Windows.Forms.DialogResult.None;
                case "ok":
                    return System.Windows.Forms.DialogResult.OK;
                case "retry":
                    return System.Windows.Forms.DialogResult.Retry;
                case "yes":
                    return System.Windows.Forms.DialogResult.Yes;

            }
            return returnVal;
        }

        private void btn1_Click(System.Object sender, System.EventArgs e)
        {
            this.Close();
            this.DialogResult = DetermineDialogResult(btn1.Text);
        }

        private void btn2_Click(System.Object sender, System.EventArgs e)
        {
            this.Close();
            this.DialogResult = DetermineDialogResult(btn2.Text);
        }

        private void btn3_Click(System.Object sender, System.EventArgs e)
        {
            this.Close();
            this.DialogResult = DetermineDialogResult(btn3.Text);
        }

        /// <summary>
        /// Handles the Load event of the UserErrorDialog control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        private void UserErrorDialog_Load(System.Object sender, System.EventArgs e)
        {
            //-- make sure our window is on top
            this.TopMost = true;
            this.TopMost = false;

            //-- More >> has to be expanded
            this.txtMore.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.txtMore.Visible = false;

            //-- size the labels' height to accommodate the amount of text in them
            SizeBox(ScopeBox);
            SizeBox(ActionBox);
            SizeBox(ErrorBox);

            //-- now shift everything up
            lblScopeHeading.Top = ErrorBox.Top + ErrorBox.Height + _intSpacing;
            ScopeBox.Top = lblScopeHeading.Top + lblScopeHeading.Height + _intSpacing;

            lblActionHeading.Top = ScopeBox.Top + ScopeBox.Height + _intSpacing;
            ActionBox.Top = lblActionHeading.Top + lblActionHeading.Height + _intSpacing;

            lblMoreHeading.Top = ActionBox.Top + ActionBox.Height + _intSpacing;
            btnMore.Top = lblMoreHeading.Top - 3;

            this.Height = btnMore.Top + btnMore.Height + _intSpacing + 45;

            this.CenterToScreen();
        }

        /// <summary>
        /// Handles the Click event of the btnMore control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        private void btnMore_Click(System.Object sender, System.EventArgs e)
        {
            if (btnMore.Text == ">>")
            {
                this.Height = this.Height + 300;
                var _with1 = txtMore;
                _with1.Location = new System.Drawing.Point(lblMoreHeading.Left, lblMoreHeading.Top + lblMoreHeading.Height + _intSpacing);
                _with1.Height = this.ClientSize.Height - txtMore.Top - 45;
                _with1.Width = this.ClientSize.Width - 2 * _intSpacing;
                _with1.Anchor = System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right;
                _with1.Visible = true;
                btn3.Focus();
                btnMore.Text = "<<";
            }
            else
            {
                this.SuspendLayout();
                btnMore.Text = ">>";
                this.Height = btnMore.Top + btnMore.Height + _intSpacing + 45;
                txtMore.Visible = false;
                txtMore.Anchor = System.Windows.Forms.AnchorStyles.None;
                this.ResumeLayout();
            }
        }

        /// <summary>
        /// Handles the LinkClicked event of the ErrorBox control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.Forms.LinkClickedEventArgs"/> instance containing the event data.</param>
        private void ErrorBox_LinkClicked(System.Object sender, System.Windows.Forms.LinkClickedEventArgs e)
        {
            LaunchLink(e.LinkText);
        }

        /// <summary>
        /// Handles the LinkClicked event of the ScopeBox control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.Forms.LinkClickedEventArgs"/> instance containing the event data.</param>
        private void ScopeBox_LinkClicked(System.Object sender, System.Windows.Forms.LinkClickedEventArgs e)
        {
            LaunchLink(e.LinkText);
        }

        /// <summary>
        /// Handles the LinkClicked event of the ActionBox control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.Forms.LinkClickedEventArgs"/> instance containing the event data.</param>
        private void ActionBox_LinkClicked(System.Object sender, System.Windows.Forms.LinkClickedEventArgs e)
        {
            LaunchLink(e.LinkText);
        }
    }
}