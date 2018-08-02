namespace TestDecoder
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
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
      this.editXML = new System.Windows.Forms.TextBox();
      this.btnDeserialise = new System.Windows.Forms.Button();
      this.editNarrative = new System.Windows.Forms.TextBox();
      this.panel1 = new System.Windows.Forms.Panel();
      this.button1 = new System.Windows.Forms.Button();
      this.btnShares = new System.Windows.Forms.Button();
      this.btnMapping = new System.Windows.Forms.Button();
      this.panel1.SuspendLayout();
      this.SuspendLayout();
      // 
      // editXML
      // 
      this.editXML.Dock = System.Windows.Forms.DockStyle.Top;
      this.editXML.Font = new System.Drawing.Font("Consolas", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.editXML.Location = new System.Drawing.Point(0, 0);
      this.editXML.Multiline = true;
      this.editXML.Name = "editXML";
      this.editXML.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
      this.editXML.Size = new System.Drawing.Size(837, 312);
      this.editXML.TabIndex = 0;
      this.editXML.TabStop = false;
      this.editXML.Text = resources.GetString("editXML.Text");
      // 
      // btnDeserialise
      // 
      this.btnDeserialise.Location = new System.Drawing.Point(12, 13);
      this.btnDeserialise.Name = "btnDeserialise";
      this.btnDeserialise.Size = new System.Drawing.Size(75, 23);
      this.btnDeserialise.TabIndex = 1;
      this.btnDeserialise.Text = "Deserialise";
      this.btnDeserialise.UseVisualStyleBackColor = true;
      this.btnDeserialise.Click += new System.EventHandler(this.btnDeserialise_Click);
      // 
      // editNarrative
      // 
      this.editNarrative.Dock = System.Windows.Forms.DockStyle.Fill;
      this.editNarrative.Font = new System.Drawing.Font("Consolas", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.editNarrative.Location = new System.Drawing.Point(0, 363);
      this.editNarrative.Multiline = true;
      this.editNarrative.Name = "editNarrative";
      this.editNarrative.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
      this.editNarrative.Size = new System.Drawing.Size(837, 255);
      this.editNarrative.TabIndex = 2;
      // 
      // panel1
      // 
      this.panel1.Controls.Add(this.btnMapping);
      this.panel1.Controls.Add(this.button1);
      this.panel1.Controls.Add(this.btnShares);
      this.panel1.Controls.Add(this.btnDeserialise);
      this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
      this.panel1.Location = new System.Drawing.Point(0, 312);
      this.panel1.Name = "panel1";
      this.panel1.Size = new System.Drawing.Size(837, 51);
      this.panel1.TabIndex = 3;
      // 
      // button1
      // 
      this.button1.Location = new System.Drawing.Point(251, 13);
      this.button1.Name = "button1";
      this.button1.Size = new System.Drawing.Size(75, 23);
      this.button1.TabIndex = 3;
      this.button1.Text = "Drives";
      this.button1.UseVisualStyleBackColor = true;
      this.button1.Click += new System.EventHandler(this.button1_Click);
      // 
      // btnShares
      // 
      this.btnShares.Location = new System.Drawing.Point(170, 13);
      this.btnShares.Name = "btnShares";
      this.btnShares.Size = new System.Drawing.Size(75, 23);
      this.btnShares.TabIndex = 2;
      this.btnShares.Text = "Shares";
      this.btnShares.UseVisualStyleBackColor = true;
      this.btnShares.Click += new System.EventHandler(this.btnShares_Click);
      // 
      // btnMapping
      // 
      this.btnMapping.Location = new System.Drawing.Point(348, 13);
      this.btnMapping.Name = "btnMapping";
      this.btnMapping.Size = new System.Drawing.Size(75, 23);
      this.btnMapping.TabIndex = 4;
      this.btnMapping.Text = "Mapping";
      this.btnMapping.UseVisualStyleBackColor = true;
      this.btnMapping.Click += new System.EventHandler(this.btnMapping_Click);
      // 
      // Form1
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(837, 618);
      this.Controls.Add(this.editNarrative);
      this.Controls.Add(this.panel1);
      this.Controls.Add(this.editXML);
      this.Name = "Form1";
      this.Text = "Form1";
      this.panel1.ResumeLayout(false);
      this.ResumeLayout(false);
      this.PerformLayout();

      }

    #endregion

    private System.Windows.Forms.TextBox editXML;
    private System.Windows.Forms.Button btnDeserialise;
    private System.Windows.Forms.TextBox editNarrative;
    private System.Windows.Forms.Panel panel1;
    private System.Windows.Forms.Button btnShares;
    private System.Windows.Forms.Button button1;
    private System.Windows.Forms.Button btnMapping;
    }
  }

