namespace TestApp
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
      this.createGatewayBtn = new System.Windows.Forms.Button();
      this.dbgLog = new System.Windows.Forms.TextBox();
      this.statusBar = new System.Windows.Forms.StatusStrip();
      this.panel1 = new System.Windows.Forms.Panel();
      this.transListBox = new System.Windows.Forms.ListBox();
      this.btnRemove = new System.Windows.Forms.Button();
      this.btnSubmit = new System.Windows.Forms.Button();
      this.rctTransList = new System.Windows.Forms.ListBox();
      this.mcmCombo = new System.Windows.Forms.ComboBox();
      this.btnAddTrans = new System.Windows.Forms.Button();
      this.panel1.SuspendLayout();
      this.SuspendLayout();
      // 
      // createGatewayBtn
      // 
      this.createGatewayBtn.Location = new System.Drawing.Point(12, 12);
      this.createGatewayBtn.Name = "createGatewayBtn";
      this.createGatewayBtn.Size = new System.Drawing.Size(100, 23);
      this.createGatewayBtn.TabIndex = 0;
      this.createGatewayBtn.Text = "Create Gateway";
      this.createGatewayBtn.UseVisualStyleBackColor = true;
      this.createGatewayBtn.Click += new System.EventHandler(this.createGatewayBtn_Click);
      // 
      // dbgLog
      // 
      this.dbgLog.Dock = System.Windows.Forms.DockStyle.Fill;
      this.dbgLog.Font = new System.Drawing.Font("Consolas", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.dbgLog.Location = new System.Drawing.Point(0, 171);
      this.dbgLog.Multiline = true;
      this.dbgLog.Name = "dbgLog";
      this.dbgLog.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
      this.dbgLog.Size = new System.Drawing.Size(445, 250);
      this.dbgLog.TabIndex = 1;
      // 
      // statusBar
      // 
      this.statusBar.Location = new System.Drawing.Point(0, 421);
      this.statusBar.Name = "statusBar";
      this.statusBar.Size = new System.Drawing.Size(445, 22);
      this.statusBar.TabIndex = 2;
      // 
      // panel1
      // 
      this.panel1.Controls.Add(this.transListBox);
      this.panel1.Controls.Add(this.btnRemove);
      this.panel1.Controls.Add(this.btnSubmit);
      this.panel1.Controls.Add(this.rctTransList);
      this.panel1.Controls.Add(this.mcmCombo);
      this.panel1.Controls.Add(this.btnAddTrans);
      this.panel1.Controls.Add(this.createGatewayBtn);
      this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
      this.panel1.Location = new System.Drawing.Point(0, 0);
      this.panel1.Name = "panel1";
      this.panel1.Size = new System.Drawing.Size(445, 171);
      this.panel1.TabIndex = 3;
      // 
      // transListBox
      // 
      this.transListBox.FormattingEnabled = true;
      this.transListBox.Location = new System.Drawing.Point(12, 41);
      this.transListBox.Name = "transListBox";
      this.transListBox.ScrollAlwaysVisible = true;
      this.transListBox.Size = new System.Drawing.Size(123, 121);
      this.transListBox.Sorted = true;
      this.transListBox.TabIndex = 11;
      this.transListBox.SelectedIndexChanged += new System.EventHandler(this.transListBox_SelectedIndexChanged);
      // 
      // btnRemove
      // 
      this.btnRemove.Enabled = false;
      this.btnRemove.Location = new System.Drawing.Point(141, 70);
      this.btnRemove.Name = "btnRemove";
      this.btnRemove.Size = new System.Drawing.Size(81, 23);
      this.btnRemove.TabIndex = 10;
      this.btnRemove.Text = "<= Remove";
      this.btnRemove.UseVisualStyleBackColor = true;
      this.btnRemove.Click += new System.EventHandler(this.btnRemove_Click);
      // 
      // btnSubmit
      // 
      this.btnSubmit.Enabled = false;
      this.btnSubmit.Location = new System.Drawing.Point(357, 41);
      this.btnSubmit.Name = "btnSubmit";
      this.btnSubmit.Size = new System.Drawing.Size(75, 23);
      this.btnSubmit.TabIndex = 9;
      this.btnSubmit.Text = "Submit";
      this.btnSubmit.UseVisualStyleBackColor = true;
      this.btnSubmit.Click += new System.EventHandler(this.btnSubmit_Click);
      // 
      // rctTransList
      // 
      this.rctTransList.FormattingEnabled = true;
      this.rctTransList.Location = new System.Drawing.Point(228, 41);
      this.rctTransList.Name = "rctTransList";
      this.rctTransList.ScrollAlwaysVisible = true;
      this.rctTransList.Size = new System.Drawing.Size(123, 121);
      this.rctTransList.Sorted = true;
      this.rctTransList.TabIndex = 8;
      this.rctTransList.SelectedIndexChanged += new System.EventHandler(this.rctTransList_SelectedIndexChanged);
      // 
      // mcmCombo
      // 
      this.mcmCombo.FormattingEnabled = true;
      this.mcmCombo.Location = new System.Drawing.Point(118, 12);
      this.mcmCombo.Name = "mcmCombo";
      this.mcmCombo.Size = new System.Drawing.Size(233, 21);
      this.mcmCombo.TabIndex = 3;
      this.mcmCombo.SelectedIndexChanged += new System.EventHandler(this.mcmCombo_SelectedIndexChanged);
      // 
      // btnAddTrans
      // 
      this.btnAddTrans.Enabled = false;
      this.btnAddTrans.Location = new System.Drawing.Point(141, 41);
      this.btnAddTrans.Name = "btnAddTrans";
      this.btnAddTrans.Size = new System.Drawing.Size(81, 23);
      this.btnAddTrans.TabIndex = 2;
      this.btnAddTrans.Text = "Add Trans =>";
      this.btnAddTrans.UseVisualStyleBackColor = true;
      this.btnAddTrans.Click += new System.EventHandler(this.btnAddTrans_Click);
      // 
      // mainform
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(445, 443);
      this.Controls.Add(this.dbgLog);
      this.Controls.Add(this.statusBar);
      this.Controls.Add(this.panel1);
      this.Name = "mainform";
      this.Text = "RCT Gateway Test";
      this.panel1.ResumeLayout(false);
      this.ResumeLayout(false);
      this.PerformLayout();

      }

    #endregion

    private System.Windows.Forms.Button createGatewayBtn;
    private System.Windows.Forms.TextBox dbgLog;
    private System.Windows.Forms.StatusStrip statusBar;
    private System.Windows.Forms.Panel panel1;
    private System.Windows.Forms.Button btnAddTrans;
    private System.Windows.Forms.ComboBox mcmCombo;
    private System.Windows.Forms.ListBox rctTransList;
    private System.Windows.Forms.Button btnSubmit;
    private System.Windows.Forms.ListBox transListBox;
    private System.Windows.Forms.Button btnRemove;
    }
  }

