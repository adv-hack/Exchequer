namespace HMRCStatusChecker
  {
  partial class Help
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
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Help));
      this.textHelp = new System.Windows.Forms.TextBox();
      this.button1 = new System.Windows.Forms.Button();
      this.SuspendLayout();
      // 
      // textHelp
      // 
      this.textHelp.Dock = System.Windows.Forms.DockStyle.Top;
      this.textHelp.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.textHelp.Location = new System.Drawing.Point(0, 0);
      this.textHelp.Multiline = true;
      this.textHelp.Name = "textHelp";
      this.textHelp.Size = new System.Drawing.Size(311, 221);
      this.textHelp.TabIndex = 0;
      this.textHelp.TabStop = false;
      this.textHelp.Text = resources.GetString("textHelp.Text");
      // 
      // button1
      // 
      this.button1.DialogResult = System.Windows.Forms.DialogResult.OK;
      this.button1.Location = new System.Drawing.Point(224, 227);
      this.button1.Name = "button1";
      this.button1.Size = new System.Drawing.Size(75, 23);
      this.button1.TabIndex = 1;
      this.button1.Text = "Ok";
      this.button1.UseVisualStyleBackColor = true;
      this.button1.Click += new System.EventHandler(this.button1_Click);
      // 
      // Help
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(311, 261);
      this.Controls.Add(this.button1);
      this.Controls.Add(this.textHelp);
      this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
      this.Name = "Help";
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
      this.Text = "Help";
      this.ResumeLayout(false);
      this.PerformLayout();

      }

    #endregion

    private System.Windows.Forms.TextBox textHelp;
    private System.Windows.Forms.Button button1;
    }
  }