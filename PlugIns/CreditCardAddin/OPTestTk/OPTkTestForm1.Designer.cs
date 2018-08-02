namespace OPTestTk
  {
  partial class OPTkTestForm1
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
      this.button1 = new System.Windows.Forms.Button();
      this.textSOR = new System.Windows.Forms.TextBox();
      this.label1 = new System.Windows.Forms.Label();
      this.label2 = new System.Windows.Forms.Label();
      this.textSRC = new System.Windows.Forms.TextBox();
      this.label3 = new System.Windows.Forms.Label();
      this.textExchDir = new System.Windows.Forms.TextBox();
      this.SuspendLayout();
      // 
      // button1
      // 
      this.button1.Location = new System.Drawing.Point(82, 133);
      this.button1.Name = "button1";
      this.button1.Size = new System.Drawing.Size(75, 23);
      this.button1.TabIndex = 0;
      this.button1.Text = "Go";
      this.button1.UseVisualStyleBackColor = true;
      this.button1.Click += new System.EventHandler(this.button1_Click);
      // 
      // textSOR
      // 
      this.textSOR.Location = new System.Drawing.Point(82, 55);
      this.textSOR.Name = "textSOR";
      this.textSOR.Size = new System.Drawing.Size(109, 20);
      this.textSOR.TabIndex = 1;
      this.textSOR.Text = "SOR000853";
      // 
      // label1
      // 
      this.label1.AutoSize = true;
      this.label1.Location = new System.Drawing.Point(26, 58);
      this.label1.Name = "label1";
      this.label1.Size = new System.Drawing.Size(30, 13);
      this.label1.TabIndex = 2;
      this.label1.Text = "SOR";
      // 
      // label2
      // 
      this.label2.AutoSize = true;
      this.label2.Location = new System.Drawing.Point(26, 85);
      this.label2.Name = "label2";
      this.label2.Size = new System.Drawing.Size(29, 13);
      this.label2.TabIndex = 3;
      this.label2.Text = "SRC";
      // 
      // textSRC
      // 
      this.textSRC.Location = new System.Drawing.Point(82, 81);
      this.textSRC.Name = "textSRC";
      this.textSRC.Size = new System.Drawing.Size(109, 20);
      this.textSRC.TabIndex = 4;
      this.textSRC.Text = "SRC000625";
      // 
      // label3
      // 
      this.label3.AutoSize = true;
      this.label3.Location = new System.Drawing.Point(19, 23);
      this.label3.Name = "label3";
      this.label3.Size = new System.Drawing.Size(44, 13);
      this.label3.TabIndex = 5;
      this.label3.Text = "ExchDir";
      // 
      // textExchDir
      // 
      this.textExchDir.Location = new System.Drawing.Point(82, 20);
      this.textExchDir.Name = "textExchDir";
      this.textExchDir.Size = new System.Drawing.Size(253, 20);
      this.textExchDir.TabIndex = 6;
      this.textExchDir.Text = "C:\\Exchequer\\Exch2015";
      // 
      // Form1
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(347, 193);
      this.Controls.Add(this.textExchDir);
      this.Controls.Add(this.label3);
      this.Controls.Add(this.textSRC);
      this.Controls.Add(this.label2);
      this.Controls.Add(this.label1);
      this.Controls.Add(this.textSOR);
      this.Controls.Add(this.button1);
      this.Name = "Form1";
      this.Text = "Form1";
      this.ResumeLayout(false);
      this.PerformLayout();

      }

    #endregion

    private System.Windows.Forms.Button button1;
    private System.Windows.Forms.TextBox textSOR;
    private System.Windows.Forms.Label label1;
    private System.Windows.Forms.Label label2;
    private System.Windows.Forms.TextBox textSRC;
    private System.Windows.Forms.Label label3;
    private System.Windows.Forms.TextBox textExchDir;
    }
  }

