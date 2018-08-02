namespace HMRCStatusChecker
  {
  partial class mainform
    {
    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    /// Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
      {
      if (disposing && (components != null))
        {
        components.Dispose();
        }
      base.Dispose(disposing);
      }

    #region Windows Form Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
      {
      this.components = new System.ComponentModel.Container();
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(mainform));
      this.label1 = new System.Windows.Forms.Label();
      this.comboTargetURL = new System.Windows.Forms.ComboBox();
      this.label2 = new System.Windows.Forms.Label();
      this.comboSubmissionType = new System.Windows.Forms.ComboBox();
      this.label3 = new System.Windows.Forms.Label();
      this.editCorrelationID = new System.Windows.Forms.TextBox();
      this.groupBox1 = new System.Windows.Forms.GroupBox();
      this.comboVATRegNo = new System.Windows.Forms.ComboBox();
      this.editPassword = new System.Windows.Forms.TextBox();
      this.comboUserID = new System.Windows.Forms.ComboBox();
      this.label6 = new System.Windows.Forms.Label();
      this.label5 = new System.Windows.Forms.Label();
      this.label4 = new System.Windows.Forms.Label();
      this.btnPoll = new System.Windows.Forms.Button();
      this.btnDelete = new System.Windows.Forms.Button();
      this.textNarrative = new System.Windows.Forms.TextBox();
      this.btnHelp = new System.Windows.Forms.Button();
      this.pollTimer = new System.Windows.Forms.Timer(this.components);
      this.groupBox1.SuspendLayout();
      this.SuspendLayout();
      // 
      // label1
      // 
      this.label1.AutoSize = true;
      this.label1.Location = new System.Drawing.Point(12, 20);
      this.label1.Name = "label1";
      this.label1.Size = new System.Drawing.Size(63, 13);
      this.label1.TabIndex = 0;
      this.label1.Text = "Target URL";
      // 
      // comboTargetURL
      // 
      this.comboTargetURL.FormattingEnabled = true;
      this.comboTargetURL.Items.AddRange(new object[] {
            "https://secure.dev.gateway.gov.uk/poll"});
      this.comboTargetURL.Location = new System.Drawing.Point(109, 17);
      this.comboTargetURL.Name = "comboTargetURL";
      this.comboTargetURL.Size = new System.Drawing.Size(375, 21);
      this.comboTargetURL.TabIndex = 1;
      this.comboTargetURL.TabStop = false;
      this.comboTargetURL.Text = "https://secure.dev.gateway.gov.uk/poll";
      // 
      // label2
      // 
      this.label2.AutoSize = true;
      this.label2.Location = new System.Drawing.Point(12, 47);
      this.label2.Name = "label2";
      this.label2.Size = new System.Drawing.Size(83, 13);
      this.label2.TabIndex = 2;
      this.label2.Text = "Submission type";
      // 
      // comboSubmissionType
      // 
      this.comboSubmissionType.FormattingEnabled = true;
      this.comboSubmissionType.Items.AddRange(new object[] {
            "VAT 100"});
      this.comboSubmissionType.Location = new System.Drawing.Point(109, 44);
      this.comboSubmissionType.Name = "comboSubmissionType";
      this.comboSubmissionType.Size = new System.Drawing.Size(174, 21);
      this.comboSubmissionType.TabIndex = 3;
      this.comboSubmissionType.TabStop = false;
      this.comboSubmissionType.Text = "VAT 100";
      // 
      // label3
      // 
      this.label3.AutoSize = true;
      this.label3.Location = new System.Drawing.Point(12, 94);
      this.label3.Name = "label3";
      this.label3.Size = new System.Drawing.Size(71, 13);
      this.label3.TabIndex = 4;
      this.label3.Text = "Correlation ID";
      // 
      // editCorrelationID
      // 
      this.editCorrelationID.Location = new System.Drawing.Point(109, 91);
      this.editCorrelationID.Name = "editCorrelationID";
      this.editCorrelationID.Size = new System.Drawing.Size(216, 20);
      this.editCorrelationID.TabIndex = 5;
      // 
      // groupBox1
      // 
      this.groupBox1.Controls.Add(this.comboVATRegNo);
      this.groupBox1.Controls.Add(this.editPassword);
      this.groupBox1.Controls.Add(this.comboUserID);
      this.groupBox1.Controls.Add(this.label6);
      this.groupBox1.Controls.Add(this.label5);
      this.groupBox1.Controls.Add(this.label4);
      this.groupBox1.Location = new System.Drawing.Point(343, 44);
      this.groupBox1.Name = "groupBox1";
      this.groupBox1.Size = new System.Drawing.Size(245, 104);
      this.groupBox1.TabIndex = 6;
      this.groupBox1.TabStop = false;
      this.groupBox1.Text = "Credentials";
      // 
      // comboVATRegNo
      // 
      this.comboVATRegNo.Enabled = false;
      this.comboVATRegNo.FormattingEnabled = true;
      this.comboVATRegNo.Items.AddRange(new object[] {
            "999900001",
            "999900002",
            "999900003",
            "999900004",
            "999900005",
            "999900006"});
      this.comboVATRegNo.Location = new System.Drawing.Point(98, 73);
      this.comboVATRegNo.Name = "comboVATRegNo";
      this.comboVATRegNo.Size = new System.Drawing.Size(141, 21);
      this.comboVATRegNo.TabIndex = 5;
      this.comboVATRegNo.Text = "999900001";
      // 
      // editPassword
      // 
      this.editPassword.Location = new System.Drawing.Point(98, 47);
      this.editPassword.Name = "editPassword";
      this.editPassword.Size = new System.Drawing.Size(141, 20);
      this.editPassword.TabIndex = 4;
      this.editPassword.Text = "testing1";
      // 
      // comboUserID
      // 
      this.comboUserID.FormattingEnabled = true;
      this.comboUserID.Items.AddRange(new object[] {
            "VATDEC249a01",
            "VATDEC249a02",
            "VATDEC249a03",
            "VATDEC249a04",
            "VATDEC249a05",
            "VATDEC249a06"});
      this.comboUserID.Location = new System.Drawing.Point(98, 20);
      this.comboUserID.Name = "comboUserID";
      this.comboUserID.Size = new System.Drawing.Size(141, 21);
      this.comboUserID.TabIndex = 3;
      this.comboUserID.Text = "VATDEC249a01";
      this.comboUserID.SelectedIndexChanged += new System.EventHandler(this.comboUserID_SelectedIndexChanged);
      // 
      // label6
      // 
      this.label6.AutoSize = true;
      this.label6.Location = new System.Drawing.Point(11, 76);
      this.label6.Name = "label6";
      this.label6.Size = new System.Drawing.Size(71, 13);
      this.label6.TabIndex = 2;
      this.label6.Text = "VAT Reg No.";
      // 
      // label5
      // 
      this.label5.AutoSize = true;
      this.label5.Location = new System.Drawing.Point(11, 50);
      this.label5.Name = "label5";
      this.label5.Size = new System.Drawing.Size(53, 13);
      this.label5.TabIndex = 1;
      this.label5.Text = "Password";
      // 
      // label4
      // 
      this.label4.AutoSize = true;
      this.label4.Location = new System.Drawing.Point(11, 23);
      this.label4.Name = "label4";
      this.label4.Size = new System.Drawing.Size(43, 13);
      this.label4.TabIndex = 0;
      this.label4.Text = "User ID";
      // 
      // btnPoll
      // 
      this.btnPoll.Location = new System.Drawing.Point(109, 125);
      this.btnPoll.Name = "btnPoll";
      this.btnPoll.Size = new System.Drawing.Size(75, 23);
      this.btnPoll.TabIndex = 7;
      this.btnPoll.Text = "Status";
      this.btnPoll.UseVisualStyleBackColor = true;
      this.btnPoll.Click += new System.EventHandler(this.btnPoll_Click);
      // 
      // btnDelete
      // 
      this.btnDelete.Location = new System.Drawing.Point(250, 125);
      this.btnDelete.Name = "btnDelete";
      this.btnDelete.Size = new System.Drawing.Size(75, 23);
      this.btnDelete.TabIndex = 8;
      this.btnDelete.Text = "Delete";
      this.btnDelete.UseVisualStyleBackColor = true;
      this.btnDelete.Click += new System.EventHandler(this.btnDelete_Click);
      // 
      // textNarrative
      // 
      this.textNarrative.Font = new System.Drawing.Font("Consolas", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.textNarrative.Location = new System.Drawing.Point(15, 154);
      this.textNarrative.Multiline = true;
      this.textNarrative.Name = "textNarrative";
      this.textNarrative.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
      this.textNarrative.Size = new System.Drawing.Size(573, 275);
      this.textNarrative.TabIndex = 9;
      // 
      // btnHelp
      // 
      this.btnHelp.Image = ((System.Drawing.Image)(resources.GetObject("btnHelp.Image")));
      this.btnHelp.Location = new System.Drawing.Point(560, 15);
      this.btnHelp.Name = "btnHelp";
      this.btnHelp.Size = new System.Drawing.Size(28, 23);
      this.btnHelp.TabIndex = 10;
      this.btnHelp.UseVisualStyleBackColor = true;
      this.btnHelp.Click += new System.EventHandler(this.btnHelp_Click);
      // 
      // pollTimer
      // 
      this.pollTimer.Interval = 5000;
      this.pollTimer.Tick += new System.EventHandler(this.pollTimer_Tick);
      // 
      // mainform
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(600, 441);
      this.Controls.Add(this.btnHelp);
      this.Controls.Add(this.textNarrative);
      this.Controls.Add(this.btnDelete);
      this.Controls.Add(this.btnPoll);
      this.Controls.Add(this.groupBox1);
      this.Controls.Add(this.editCorrelationID);
      this.Controls.Add(this.label3);
      this.Controls.Add(this.comboSubmissionType);
      this.Controls.Add(this.label2);
      this.Controls.Add(this.comboTargetURL);
      this.Controls.Add(this.label1);
      this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
      this.Name = "mainform";
      this.Text = "HMRC Status Checker";
      this.groupBox1.ResumeLayout(false);
      this.groupBox1.PerformLayout();
      this.ResumeLayout(false);
      this.PerformLayout();

      }

    #endregion

    private System.Windows.Forms.Label label1;
    private System.Windows.Forms.ComboBox comboTargetURL;
    private System.Windows.Forms.Label label2;
    private System.Windows.Forms.ComboBox comboSubmissionType;
    private System.Windows.Forms.Label label3;
    private System.Windows.Forms.TextBox editCorrelationID;
    private System.Windows.Forms.GroupBox groupBox1;
    private System.Windows.Forms.Label label6;
    private System.Windows.Forms.Label label5;
    private System.Windows.Forms.Label label4;
    private System.Windows.Forms.TextBox editPassword;
    private System.Windows.Forms.ComboBox comboUserID;
    private System.Windows.Forms.ComboBox comboVATRegNo;
    private System.Windows.Forms.Button btnPoll;
    private System.Windows.Forms.Button btnDelete;
    private System.Windows.Forms.TextBox textNarrative;
    private System.Windows.Forms.Button btnHelp;
    private System.Windows.Forms.Timer pollTimer;
    }
  }

