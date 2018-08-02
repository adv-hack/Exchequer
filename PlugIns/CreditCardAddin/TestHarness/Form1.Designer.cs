namespace TestHarness
  {
  partial class Form1
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
      this.btnCompanies = new System.Windows.Forms.Button();
      this.btnConfig = new System.Windows.Forms.Button();
      this.memoOutput = new System.Windows.Forms.TextBox();
      this.btnCreateGateway = new System.Windows.Forms.Button();
      this.label1 = new System.Windows.Forms.Label();
      this.exchDirLbl = new System.Windows.Forms.Label();
      this.chkSuperUser = new System.Windows.Forms.CheckBox();
      this.btnGetDefaults = new System.Windows.Forms.Button();
      this.panel1 = new System.Windows.Forms.Panel();
      this.panel1.SuspendLayout();
      this.SuspendLayout();
      // 
      // btnCompanies
      // 
      this.btnCompanies.Enabled = false;
      this.btnCompanies.Location = new System.Drawing.Point(4, 3);
      this.btnCompanies.Name = "btnCompanies";
      this.btnCompanies.Size = new System.Drawing.Size(90, 23);
      this.btnCompanies.TabIndex = 0;
      this.btnCompanies.Text = "Companies";
      this.btnCompanies.UseVisualStyleBackColor = true;
      this.btnCompanies.Click += new System.EventHandler(this.btnCompanies_Click);
      // 
      // btnConfig
      // 
      this.btnConfig.Location = new System.Drawing.Point(100, 3);
      this.btnConfig.Name = "btnConfig";
      this.btnConfig.Size = new System.Drawing.Size(90, 23);
      this.btnConfig.TabIndex = 1;
      this.btnConfig.Text = "Configuration";
      this.btnConfig.UseVisualStyleBackColor = true;
      this.btnConfig.Click += new System.EventHandler(this.btnConfig_Click_1);
      // 
      // memoOutput
      // 
      this.memoOutput.Dock = System.Windows.Forms.DockStyle.Fill;
      this.memoOutput.Location = new System.Drawing.Point(0, 0);
      this.memoOutput.Multiline = true;
      this.memoOutput.Name = "memoOutput";
      this.memoOutput.ScrollBars = System.Windows.Forms.ScrollBars.Both;
      this.memoOutput.Size = new System.Drawing.Size(456, 331);
      this.memoOutput.TabIndex = 2;
      // 
      // btnCreateGateway
      // 
      this.btnCreateGateway.Location = new System.Drawing.Point(354, 3);
      this.btnCreateGateway.Name = "btnCreateGateway";
      this.btnCreateGateway.Size = new System.Drawing.Size(99, 23);
      this.btnCreateGateway.TabIndex = 3;
      this.btnCreateGateway.Text = "Create Gateway";
      this.btnCreateGateway.UseVisualStyleBackColor = true;
      this.btnCreateGateway.Click += new System.EventHandler(this.button1_Click);
      // 
      // label1
      // 
      this.label1.AutoSize = true;
      this.label1.Location = new System.Drawing.Point(12, 309);
      this.label1.Name = "label1";
      this.label1.Size = new System.Drawing.Size(77, 13);
      this.label1.TabIndex = 4;
      this.label1.Text = "Exchequer Dir.";
      this.label1.Visible = false;
      // 
      // exchDirLbl
      // 
      this.exchDirLbl.Location = new System.Drawing.Point(95, 309);
      this.exchDirLbl.Name = "exchDirLbl";
      this.exchDirLbl.Size = new System.Drawing.Size(266, 13);
      this.exchDirLbl.TabIndex = 5;
      this.exchDirLbl.Text = "label2";
      this.exchDirLbl.Visible = false;
      // 
      // chkSuperUser
      // 
      this.chkSuperUser.AutoSize = true;
      this.chkSuperUser.Checked = true;
      this.chkSuperUser.CheckState = System.Windows.Forms.CheckState.Checked;
      this.chkSuperUser.Location = new System.Drawing.Point(196, 7);
      this.chkSuperUser.Name = "chkSuperUser";
      this.chkSuperUser.Size = new System.Drawing.Size(77, 17);
      this.chkSuperUser.TabIndex = 6;
      this.chkSuperUser.Text = "Super-user";
      this.chkSuperUser.UseVisualStyleBackColor = true;
      // 
      // btnGetDefaults
      // 
      this.btnGetDefaults.Location = new System.Drawing.Point(369, 304);
      this.btnGetDefaults.Name = "btnGetDefaults";
      this.btnGetDefaults.Size = new System.Drawing.Size(75, 23);
      this.btnGetDefaults.TabIndex = 7;
      this.btnGetDefaults.Text = "Get defaults";
      this.btnGetDefaults.UseVisualStyleBackColor = true;
      this.btnGetDefaults.Visible = false;
      // 
      // panel1
      // 
      this.panel1.Controls.Add(this.btnCompanies);
      this.panel1.Controls.Add(this.btnConfig);
      this.panel1.Controls.Add(this.chkSuperUser);
      this.panel1.Controls.Add(this.btnCreateGateway);
      this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
      this.panel1.Location = new System.Drawing.Point(0, 0);
      this.panel1.Name = "panel1";
      this.panel1.Size = new System.Drawing.Size(456, 34);
      this.panel1.TabIndex = 8;
      // 
      // Form1
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(456, 331);
      this.Controls.Add(this.panel1);
      this.Controls.Add(this.memoOutput);
      this.Controls.Add(this.btnGetDefaults);
      this.Controls.Add(this.exchDirLbl);
      this.Controls.Add(this.label1);
      this.Name = "Form1";
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
      this.Text = "Config Launcher";
      this.Load += new System.EventHandler(this.Form1_Load);
      this.panel1.ResumeLayout(false);
      this.panel1.PerformLayout();
      this.ResumeLayout(false);
      this.PerformLayout();

      }

    #endregion

    private System.Windows.Forms.Button btnCompanies;
    private System.Windows.Forms.Button btnConfig;
    private System.Windows.Forms.TextBox memoOutput;
    private System.Windows.Forms.Button btnCreateGateway;
    private System.Windows.Forms.Label label1;
    private System.Windows.Forms.Label exchDirLbl;
    private System.Windows.Forms.CheckBox chkSuperUser;
    private System.Windows.Forms.Button btnGetDefaults;
    private System.Windows.Forms.Panel panel1;
    }
  }

