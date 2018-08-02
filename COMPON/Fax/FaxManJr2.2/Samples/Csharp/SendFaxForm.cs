using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Windows.Forms;

namespace JrNetTest
{
	/// <summary>
	/// Summary description for SendFaxForm.
	/// </summary>
	public class SendFaxForm : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.TextBox tbFaxBanner;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox tbName;
		private System.Windows.Forms.TextBox tbCompany;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.TextBox tbSenderPhone;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.TextBox tbSenderCompany;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.TextBox tbSenderName;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.TextBox tbSenderFax;
		private System.Windows.Forms.Label label7;
		private System.Windows.Forms.TextBox tbDate;
		private System.Windows.Forms.Label label8;
		private System.Windows.Forms.Label label9;
		private System.Windows.Forms.Label label10;
		private System.Windows.Forms.Label label11;
		private System.Windows.Forms.Button btnCancel;
		private System.Windows.Forms.Button btnSend;
		private System.Windows.Forms.TextBox tbFaxNumber;
		private System.Windows.Forms.CheckBox cbCoverpage;
		private System.Windows.Forms.ListBox lbFaxFiles;
		private System.Windows.Forms.Button btnAdd;
		private System.Windows.Forms.Button btnRemove;
		private System.Windows.Forms.TextBox tbComments;
		private System.Windows.Forms.Button btnSave;
		private System.Windows.Forms.Label lbImportingFiles;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public SendFaxForm(DataTech.FaxManJr.Fax fax)
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			_fax = fax;
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
			this.panel1 = new System.Windows.Forms.Panel();
			this.tbFaxBanner = new System.Windows.Forms.TextBox();
			this.label2 = new System.Windows.Forms.Label();
			this.tbName = new System.Windows.Forms.TextBox();
			this.tbCompany = new System.Windows.Forms.TextBox();
			this.label3 = new System.Windows.Forms.Label();
			this.tbFaxNumber = new System.Windows.Forms.TextBox();
			this.label4 = new System.Windows.Forms.Label();
			this.cbCoverpage = new System.Windows.Forms.CheckBox();
			this.tbSenderPhone = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			this.tbSenderCompany = new System.Windows.Forms.TextBox();
			this.label5 = new System.Windows.Forms.Label();
			this.tbSenderName = new System.Windows.Forms.TextBox();
			this.label6 = new System.Windows.Forms.Label();
			this.tbSenderFax = new System.Windows.Forms.TextBox();
			this.label7 = new System.Windows.Forms.Label();
			this.tbDate = new System.Windows.Forms.TextBox();
			this.label8 = new System.Windows.Forms.Label();
			this.label9 = new System.Windows.Forms.Label();
			this.label10 = new System.Windows.Forms.Label();
			this.lbFaxFiles = new System.Windows.Forms.ListBox();
			this.btnAdd = new System.Windows.Forms.Button();
			this.btnRemove = new System.Windows.Forms.Button();
			this.label11 = new System.Windows.Forms.Label();
			this.tbComments = new System.Windows.Forms.TextBox();
			this.btnCancel = new System.Windows.Forms.Button();
			this.btnSend = new System.Windows.Forms.Button();
			this.btnSave = new System.Windows.Forms.Button();
			this.lbImportingFiles = new System.Windows.Forms.Label();
			this.SuspendLayout();
			// 
			// panel1
			// 
			this.panel1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.panel1.BackColor = System.Drawing.SystemColors.ActiveCaptionText;
			this.panel1.Location = new System.Drawing.Point(48, 28);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(512, 4);
			this.panel1.TabIndex = 0;
			// 
			// tbFaxBanner
			// 
			this.tbFaxBanner.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tbFaxBanner.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.tbFaxBanner.Location = new System.Drawing.Point(48, 4);
			this.tbFaxBanner.Name = "tbFaxBanner";
			this.tbFaxBanner.Size = new System.Drawing.Size(512, 20);
			this.tbFaxBanner.TabIndex = 0;
			this.tbFaxBanner.Text = "From: %s  To: %r | %t %d |  Page %c  of %p";
			this.tbFaxBanner.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
			// 
			// label2
			// 
			this.label2.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label2.Location = new System.Drawing.Point(48, 72);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(176, 24);
			this.label2.TabIndex = 3;
			this.label2.Text = "To:";
			this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// tbName
			// 
			this.tbName.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tbName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.tbName.Location = new System.Drawing.Point(240, 72);
			this.tbName.Name = "tbName";
			this.tbName.Size = new System.Drawing.Size(320, 20);
			this.tbName.TabIndex = 2;
			this.tbName.Text = "";
			// 
			// tbCompany
			// 
			this.tbCompany.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tbCompany.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.tbCompany.Location = new System.Drawing.Point(240, 96);
			this.tbCompany.Name = "tbCompany";
			this.tbCompany.Size = new System.Drawing.Size(320, 20);
			this.tbCompany.TabIndex = 3;
			this.tbCompany.Text = "";
			// 
			// label3
			// 
			this.label3.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label3.Location = new System.Drawing.Point(48, 96);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(176, 24);
			this.label3.TabIndex = 5;
			this.label3.Text = "Company:";
			this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// tbFaxNumber
			// 
			this.tbFaxNumber.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tbFaxNumber.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.tbFaxNumber.Location = new System.Drawing.Point(240, 120);
			this.tbFaxNumber.Name = "tbFaxNumber";
			this.tbFaxNumber.Size = new System.Drawing.Size(320, 20);
			this.tbFaxNumber.TabIndex = 4;
			this.tbFaxNumber.Text = "";
			// 
			// label4
			// 
			this.label4.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label4.Location = new System.Drawing.Point(48, 120);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(176, 24);
			this.label4.TabIndex = 7;
			this.label4.Text = "Fax:";
			this.label4.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// cbCoverpage
			// 
			this.cbCoverpage.CheckAlign = System.Drawing.ContentAlignment.BottomRight;
			this.cbCoverpage.Checked = true;
			this.cbCoverpage.CheckState = System.Windows.Forms.CheckState.Checked;
			this.cbCoverpage.Font = new System.Drawing.Font("Arial", 15.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cbCoverpage.Location = new System.Drawing.Point(40, 40);
			this.cbCoverpage.Name = "cbCoverpage";
			this.cbCoverpage.Size = new System.Drawing.Size(272, 24);
			this.cbCoverpage.TabIndex = 1;
			this.cbCoverpage.Text = "Facsimile Cover Sheet";
			// 
			// tbSenderPhone
			// 
			this.tbSenderPhone.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tbSenderPhone.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.tbSenderPhone.Location = new System.Drawing.Point(240, 208);
			this.tbSenderPhone.Name = "tbSenderPhone";
			this.tbSenderPhone.Size = new System.Drawing.Size(320, 20);
			this.tbSenderPhone.TabIndex = 7;
			this.tbSenderPhone.Text = "";
			// 
			// label1
			// 
			this.label1.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label1.Location = new System.Drawing.Point(48, 208);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(176, 24);
			this.label1.TabIndex = 14;
			this.label1.Text = "Phone:";
			this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// tbSenderCompany
			// 
			this.tbSenderCompany.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tbSenderCompany.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.tbSenderCompany.Location = new System.Drawing.Point(240, 184);
			this.tbSenderCompany.Name = "tbSenderCompany";
			this.tbSenderCompany.Size = new System.Drawing.Size(320, 20);
			this.tbSenderCompany.TabIndex = 6;
			this.tbSenderCompany.Text = "";
			// 
			// label5
			// 
			this.label5.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label5.Location = new System.Drawing.Point(48, 184);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(176, 24);
			this.label5.TabIndex = 12;
			this.label5.Text = "Company:";
			this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// tbSenderName
			// 
			this.tbSenderName.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tbSenderName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.tbSenderName.Location = new System.Drawing.Point(240, 160);
			this.tbSenderName.Name = "tbSenderName";
			this.tbSenderName.Size = new System.Drawing.Size(320, 20);
			this.tbSenderName.TabIndex = 5;
			this.tbSenderName.Text = "";
			// 
			// label6
			// 
			this.label6.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label6.Location = new System.Drawing.Point(48, 160);
			this.label6.Name = "label6";
			this.label6.Size = new System.Drawing.Size(176, 24);
			this.label6.TabIndex = 10;
			this.label6.Text = "From:";
			this.label6.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// tbSenderFax
			// 
			this.tbSenderFax.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tbSenderFax.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.tbSenderFax.Location = new System.Drawing.Point(240, 232);
			this.tbSenderFax.Name = "tbSenderFax";
			this.tbSenderFax.Size = new System.Drawing.Size(320, 20);
			this.tbSenderFax.TabIndex = 8;
			this.tbSenderFax.Text = "";
			// 
			// label7
			// 
			this.label7.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label7.Location = new System.Drawing.Point(48, 232);
			this.label7.Name = "label7";
			this.label7.Size = new System.Drawing.Size(176, 24);
			this.label7.TabIndex = 16;
			this.label7.Text = "Fax:";
			this.label7.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// tbDate
			// 
			this.tbDate.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tbDate.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.tbDate.Location = new System.Drawing.Point(240, 272);
			this.tbDate.Name = "tbDate";
			this.tbDate.ReadOnly = true;
			this.tbDate.Size = new System.Drawing.Size(320, 20);
			this.tbDate.TabIndex = 9;
			this.tbDate.Text = "";
			// 
			// label8
			// 
			this.label8.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label8.Location = new System.Drawing.Point(48, 272);
			this.label8.Name = "label8";
			this.label8.Size = new System.Drawing.Size(176, 24);
			this.label8.TabIndex = 18;
			this.label8.Text = "Date:";
			this.label8.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// label9
			// 
			this.label9.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label9.Location = new System.Drawing.Point(40, 312);
			this.label9.Name = "label9";
			this.label9.Size = new System.Drawing.Size(176, 16);
			this.label9.TabIndex = 20;
			this.label9.Text = "Pages including this";
			this.label9.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// label10
			// 
			this.label10.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label10.Location = new System.Drawing.Point(40, 328);
			this.label10.Name = "label10";
			this.label10.Size = new System.Drawing.Size(176, 16);
			this.label10.TabIndex = 21;
			this.label10.Text = "cover page:";
			this.label10.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// lbFaxFiles
			// 
			this.lbFaxFiles.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.lbFaxFiles.Location = new System.Drawing.Point(240, 312);
			this.lbFaxFiles.Name = "lbFaxFiles";
			this.lbFaxFiles.Size = new System.Drawing.Size(256, 56);
			this.lbFaxFiles.TabIndex = 11;
			// 
			// btnAdd
			// 
			this.btnAdd.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.btnAdd.Location = new System.Drawing.Point(496, 312);
			this.btnAdd.Name = "btnAdd";
			this.btnAdd.Size = new System.Drawing.Size(64, 24);
			this.btnAdd.TabIndex = 10;
			this.btnAdd.Text = "&Add";
			this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
			// 
			// btnRemove
			// 
			this.btnRemove.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.btnRemove.Location = new System.Drawing.Point(496, 344);
			this.btnRemove.Name = "btnRemove";
			this.btnRemove.Size = new System.Drawing.Size(64, 24);
			this.btnRemove.TabIndex = 12;
			this.btnRemove.Text = "&Remove";
			this.btnRemove.Click += new System.EventHandler(this.btnRemove_Click);
			// 
			// label11
			// 
			this.label11.Font = new System.Drawing.Font("Arial", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label11.Location = new System.Drawing.Point(40, 372);
			this.label11.Name = "label11";
			this.label11.Size = new System.Drawing.Size(176, 24);
			this.label11.TabIndex = 25;
			this.label11.Text = "Comments";
			this.label11.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// tbComments
			// 
			this.tbComments.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tbComments.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.tbComments.Location = new System.Drawing.Point(40, 400);
			this.tbComments.Multiline = true;
			this.tbComments.Name = "tbComments";
			this.tbComments.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
			this.tbComments.Size = new System.Drawing.Size(520, 76);
			this.tbComments.TabIndex = 13;
			this.tbComments.Text = "";
			// 
			// btnCancel
			// 
			this.btnCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.btnCancel.Location = new System.Drawing.Point(48, 484);
			this.btnCancel.Name = "btnCancel";
			this.btnCancel.Size = new System.Drawing.Size(128, 24);
			this.btnCancel.TabIndex = 14;
			this.btnCancel.Text = "&Cancel";
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// btnSend
			// 
			this.btnSend.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.btnSend.DialogResult = System.Windows.Forms.DialogResult.OK;
			this.btnSend.Location = new System.Drawing.Point(424, 484);
			this.btnSend.Name = "btnSend";
			this.btnSend.Size = new System.Drawing.Size(128, 24);
			this.btnSend.TabIndex = 16;
			this.btnSend.Text = "&Send";
			this.btnSend.Click += new System.EventHandler(this.btnSend_Click);
			// 
			// btnSave
			// 
			this.btnSave.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.btnSave.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.btnSave.Location = new System.Drawing.Point(236, 484);
			this.btnSave.Name = "btnSave";
			this.btnSave.Size = new System.Drawing.Size(128, 24);
			this.btnSave.TabIndex = 15;
			this.btnSave.Text = "Sa&ve";
			this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
			// 
			// lbImportingFiles
			// 
			this.lbImportingFiles.Location = new System.Drawing.Point(248, 376);
			this.lbImportingFiles.Name = "lbImportingFiles";
			this.lbImportingFiles.Size = new System.Drawing.Size(216, 16);
			this.lbImportingFiles.TabIndex = 30;
			this.lbImportingFiles.Text = "Importing Files....";
			this.lbImportingFiles.Visible = false;
			// 
			// SendFaxForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.AutoScroll = true;
			this.ClientSize = new System.Drawing.Size(600, 514);
			this.Controls.Add(this.lbImportingFiles);
			this.Controls.Add(this.btnSave);
			this.Controls.Add(this.btnSend);
			this.Controls.Add(this.btnCancel);
			this.Controls.Add(this.tbComments);
			this.Controls.Add(this.tbDate);
			this.Controls.Add(this.tbSenderFax);
			this.Controls.Add(this.tbSenderPhone);
			this.Controls.Add(this.tbSenderCompany);
			this.Controls.Add(this.tbSenderName);
			this.Controls.Add(this.cbCoverpage);
			this.Controls.Add(this.tbFaxNumber);
			this.Controls.Add(this.tbCompany);
			this.Controls.Add(this.tbName);
			this.Controls.Add(this.tbFaxBanner);
			this.Controls.Add(this.label11);
			this.Controls.Add(this.btnRemove);
			this.Controls.Add(this.btnAdd);
			this.Controls.Add(this.lbFaxFiles);
			this.Controls.Add(this.label10);
			this.Controls.Add(this.label9);
			this.Controls.Add(this.label8);
			this.Controls.Add(this.label7);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.label5);
			this.Controls.Add(this.label6);
			this.Controls.Add(this.label4);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.panel1);
			this.Name = "SendFaxForm";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Faxman Jr.NET Test Application - Send Fax Form";
			this.Load += new System.EventHandler(this.SendFaxForm_Load);
			this.ResumeLayout(false);

		}
		#endregion

		public DataTech.FaxManJr.Fax _fax;

		private void SendFaxForm_Load(object sender, System.EventArgs e)
		{
			if (_fax.Banner.Length > 1)
				tbFaxBanner.Text = _fax.Banner;
			cbCoverpage.Checked = (_fax.Coverpage.Length > 1);
			tbName.Text = _fax.Name;
			tbCompany.Text = _fax.Company;
			tbFaxNumber.Text = _fax.FaxNumber;
			tbSenderName.Text = _fax.SenderName;
			tbSenderCompany.Text = _fax.SenderCompany;
			tbSenderPhone.Text = _fax.SenderPhone;
			tbSenderFax.Text = _fax.SenderFax;
			tbDate.Text = DateTime.Now.ToShortDateString();
			tbComments.Text = _fax.Comments;
			lbFaxFiles.DisplayMember = "Text";
			
			foreach (Object ff in _fax.FaxFiles)
			{
				ListViewItem li = new ListViewItem();
				String ffile = ff.ToString();
				li.Tag = ffile;
				li.Text = ffile.Length > 40 ? string.Format("...{0}", ffile.Substring(ffile.Length - 40)) : ffile;
				lbFaxFiles.Items.Add(li);
			}

		}

		private void btnSend_Click(object sender, System.EventArgs e)
		{
			SaveSendFaxInformationToFaxObject();
			// Button returns DialogResult.OK
		}

		private void btnSave_Click(object sender, System.EventArgs e)
		{
			SaveSendFaxInformationToFaxObject();
			// Button returns DialogResult.Cancel
		}

		private void btnCancel_Click(object sender, System.EventArgs e)
		{
			this.Close();
			// Button returns DialogResult.Cancel
		}

		private void btnAdd_Click(object sender, System.EventArgs e)
		{
			System.Windows.Forms.OpenFileDialog open = new System.Windows.Forms.OpenFileDialog();
			open.Filter = "Faxable Files *.fmf;*.fmp;*.pdf|*.fmf;*.fmp;*.pdf|Monochrome Image Files *.tif;*.pcx;*.dcx;*.bmp|*.tif;*.tiff;*.pcx;*.dcx;*.bmp|Plain Text Files *.txt;|*.txt;";
			open.InitialDirectory = Application.UserAppDataPath;
			if (DialogResult.OK == open.ShowDialog())
			{
				string file = open.FileName;

				// import file if needed
				if ( !(file.EndsWith(".fmf") || file.EndsWith(".fmp")) )
				{
					try
					{
						lbImportingFiles.Visible = true;
						lbImportingFiles.Refresh();
						Cursor = Cursors.WaitCursor;
						string importedfile = String.Format("{0}{1}.fmf", 
							Application.UserAppDataPath, 
							file.Substring(file.LastIndexOf("\\"), file.Length - file.LastIndexOf("\\")));
						if (! (System.IO.File.Exists(importedfile)) )
						{
							DataTech.FaxManJr.Faxing faxing = new DataTech.FaxManJr.Faxing();
							faxing.ImportFiles(file, importedfile);
						}
						ListViewItem li = new ListViewItem();
						li.Tag = importedfile;
						li.Text = importedfile.Length > 40 ? string.Format("..{0}", importedfile.Substring(importedfile.Length - 40)) : importedfile;
						lbFaxFiles.Items.Add(li);
					}
					finally
					{
						Cursor = Cursors.Default;
						lbImportingFiles.Visible = false;
					}
				}
				else
				{
					ListViewItem li = new ListViewItem();
					li.Tag = open.FileName;
					li.Text = open.FileName.Length > 40 ? string.Format("..{0}", open.FileName.Substring(open.FileName.Length - 40)) : open.FileName;
					lbFaxFiles.Items.Add(li);
				}
			}
		}

		private void btnRemove_Click(object sender, System.EventArgs e)
		{
			lbFaxFiles.Items.Remove(lbFaxFiles.SelectedItem);
		}

		private void SaveSendFaxInformationToFaxObject()
		{
			if (tbFaxBanner.Text.Length  > 0) _fax.Banner = tbFaxBanner.Text;
			if (cbCoverpage.Checked) _fax.Coverpage = "cover2.pg";
			else _fax.Coverpage = "";
			if (tbName.Text.Length  > 0) _fax.Name = tbName.Text;
			if (tbCompany.Text.Length  > 0) _fax.Company = tbCompany.Text;
			if (tbFaxNumber.Text.Length  > 0) _fax.FaxNumber = tbFaxNumber.Text;
			if (tbSenderName.Text.Length  > 0) _fax.SenderName = tbSenderName.Text;
			if (tbSenderCompany.Text.Length  > 0) _fax.SenderCompany = tbSenderCompany.Text;
			if (tbSenderPhone.Text.Length  > 0) _fax.SenderPhone = tbSenderPhone.Text;
			if (tbSenderFax.Text.Length  > 0) _fax.SenderFax = tbSenderFax.Text;
			if (tbComments.Text.Length  > 0) _fax.Comments = tbComments.Text;
			
			_fax.FaxFiles.Clear();
			foreach (ListViewItem li in lbFaxFiles.Items)
				_fax.FaxFiles.Add(li.Tag.ToString());
		}

	}
}
