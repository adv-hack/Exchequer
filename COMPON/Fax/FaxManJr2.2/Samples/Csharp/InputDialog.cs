using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace JrNetTest
{
	/// <summary>
	/// Summary description for InputDialog.
	/// </summary>
	public class InputDialog : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label lbInput;
		private System.Windows.Forms.TextBox tbInput;
		private System.Windows.Forms.Button btnSend;
		private System.Windows.Forms.Button btnCancel;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public InputDialog(String title, String prompt, String currentInput)
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			_inputTitle = title;
			_inputPrompt = prompt;
			_inputText = currentInput;
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.lbInput = new System.Windows.Forms.Label();
			this.tbInput = new System.Windows.Forms.TextBox();
			this.btnSend = new System.Windows.Forms.Button();
			this.btnCancel = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// lbInput
			// 
			this.lbInput.Location = new System.Drawing.Point(9, 12);
			this.lbInput.Name = "lbInput";
			this.lbInput.Size = new System.Drawing.Size(332, 44);
			this.lbInput.TabIndex = 0;
			this.lbInput.Text = "lbInput";
			this.lbInput.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// tbInput
			// 
			this.tbInput.Location = new System.Drawing.Point(9, 64);
			this.tbInput.Name = "tbInput";
			this.tbInput.Size = new System.Drawing.Size(332, 20);
			this.tbInput.TabIndex = 1;
			this.tbInput.Text = "tbInput";
			// 
			// btnSend
			// 
			this.btnSend.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.btnSend.DialogResult = System.Windows.Forms.DialogResult.OK;
			this.btnSend.Location = new System.Drawing.Point(193, 96);
			this.btnSend.Name = "btnSend";
			this.btnSend.Size = new System.Drawing.Size(128, 24);
			this.btnSend.TabIndex = 18;
			this.btnSend.Text = "O&K";
			this.btnSend.Click += new System.EventHandler(this.btnSend_Click);
			// 
			// btnCancel
			// 
			this.btnCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.btnCancel.Location = new System.Drawing.Point(29, 96);
			this.btnCancel.Name = "btnCancel";
			this.btnCancel.Size = new System.Drawing.Size(128, 24);
			this.btnCancel.TabIndex = 17;
			this.btnCancel.Text = "&Cancel";
			// 
			// InputDialog
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(350, 134);
			this.Controls.Add(this.btnSend);
			this.Controls.Add(this.btnCancel);
			this.Controls.Add(this.tbInput);
			this.Controls.Add(this.lbInput);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.Name = "InputDialog";
			this.Text = "InputDialog";
			this.Load += new System.EventHandler(this.InputDialog_Load);
			this.ResumeLayout(false);

		}
		#endregion

		private String _inputTitle;
		private String _inputPrompt;
		private String _inputText;

		private void InputDialog_Load(object sender, System.EventArgs e)
		{
			this.Text = _inputTitle;
			lbInput.Text = _inputPrompt;
			tbInput.Text = _inputText;
		}

		private void btnSend_Click(object sender, System.EventArgs e)
		{
			_inputText = tbInput.Text;
		}

		public string InputText
		{
			get
			{
				return(_inputText);
			}
		}
	}
}
