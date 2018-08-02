namespace PaymentGatewayAddin
  {
  partial class DebugView
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
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(DebugView));
      this.textDebug = new System.Windows.Forms.TextBox();
      this.panel1 = new System.Windows.Forms.Panel();
      this.chkTimestamp = new System.Windows.Forms.CheckBox();
      this.chkOnTop = new System.Windows.Forms.CheckBox();
      this.btnSave = new System.Windows.Forms.Button();
      this.btnClear = new System.Windows.Forms.Button();
      this.saveFileDialog = new System.Windows.Forms.SaveFileDialog();
      this.contextMenu = new System.Windows.Forms.ContextMenuStrip(this.components);
      this.selectAllToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.copyToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.saveToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.panel1.SuspendLayout();
      this.contextMenu.SuspendLayout();
      this.SuspendLayout();
      // 
      // textDebug
      // 
      this.textDebug.ContextMenuStrip = this.contextMenu;
      this.textDebug.Dock = System.Windows.Forms.DockStyle.Fill;
      this.textDebug.Font = new System.Drawing.Font("Lucida Console", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.textDebug.Location = new System.Drawing.Point(0, 44);
      this.textDebug.Multiline = true;
      this.textDebug.Name = "textDebug";
      this.textDebug.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
      this.textDebug.Size = new System.Drawing.Size(691, 456);
      this.textDebug.TabIndex = 0;
      // 
      // panel1
      // 
      this.panel1.Controls.Add(this.chkTimestamp);
      this.panel1.Controls.Add(this.chkOnTop);
      this.panel1.Controls.Add(this.btnSave);
      this.panel1.Controls.Add(this.btnClear);
      this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
      this.panel1.Location = new System.Drawing.Point(0, 0);
      this.panel1.Name = "panel1";
      this.panel1.Size = new System.Drawing.Size(691, 44);
      this.panel1.TabIndex = 1;
      // 
      // chkTimestamp
      // 
      this.chkTimestamp.AutoSize = true;
      this.chkTimestamp.Location = new System.Drawing.Point(504, 15);
      this.chkTimestamp.Name = "chkTimestamp";
      this.chkTimestamp.Size = new System.Drawing.Size(111, 17);
      this.chkTimestamp.TabIndex = 4;
      this.chkTimestamp.Text = "Include timestamp";
      this.chkTimestamp.UseVisualStyleBackColor = true;
      // 
      // chkOnTop
      // 
      this.chkOnTop.AutoSize = true;
      this.chkOnTop.Location = new System.Drawing.Point(621, 15);
      this.chkOnTop.Name = "chkOnTop";
      this.chkOnTop.Size = new System.Drawing.Size(58, 17);
      this.chkOnTop.TabIndex = 3;
      this.chkOnTop.Text = "On top";
      this.chkOnTop.UseVisualStyleBackColor = true;
      this.chkOnTop.CheckedChanged += new System.EventHandler(this.chkOnTop_CheckedChanged);
      // 
      // btnSave
      // 
      this.btnSave.Location = new System.Drawing.Point(271, 11);
      this.btnSave.Name = "btnSave";
      this.btnSave.Size = new System.Drawing.Size(75, 23);
      this.btnSave.TabIndex = 2;
      this.btnSave.Text = "Save";
      this.btnSave.UseVisualStyleBackColor = true;
      this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
      // 
      // btnClear
      // 
      this.btnClear.Location = new System.Drawing.Point(12, 11);
      this.btnClear.Name = "btnClear";
      this.btnClear.Size = new System.Drawing.Size(75, 23);
      this.btnClear.TabIndex = 1;
      this.btnClear.Text = "Clear";
      this.btnClear.UseVisualStyleBackColor = true;
      this.btnClear.Click += new System.EventHandler(this.btnClear_Click);
      // 
      // saveFileDialog
      // 
      this.saveFileDialog.DefaultExt = "txt";
      this.saveFileDialog.Filter = "Text files|*.txt|All files|*.*";
      // 
      // contextMenu
      // 
      this.contextMenu.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.selectAllToolStripMenuItem,
            this.copyToolStripMenuItem,
            this.saveToolStripMenuItem});
      this.contextMenu.Name = "contextMenu";
      this.contextMenu.Size = new System.Drawing.Size(165, 70);
      // 
      // selectAllToolStripMenuItem
      // 
      this.selectAllToolStripMenuItem.Name = "selectAllToolStripMenuItem";
      this.selectAllToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.A)));
      this.selectAllToolStripMenuItem.Size = new System.Drawing.Size(164, 22);
      this.selectAllToolStripMenuItem.Text = "Select All";
      this.selectAllToolStripMenuItem.Click += new System.EventHandler(this.selectAllToolStripMenuItem_Click);
      // 
      // copyToolStripMenuItem
      // 
      this.copyToolStripMenuItem.Name = "copyToolStripMenuItem";
      this.copyToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.C)));
      this.copyToolStripMenuItem.Size = new System.Drawing.Size(164, 22);
      this.copyToolStripMenuItem.Text = "Copy";
      this.copyToolStripMenuItem.Click += new System.EventHandler(this.copyToolStripMenuItem_Click);
      // 
      // saveToolStripMenuItem
      // 
      this.saveToolStripMenuItem.Name = "saveToolStripMenuItem";
      this.saveToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.S)));
      this.saveToolStripMenuItem.Size = new System.Drawing.Size(164, 22);
      this.saveToolStripMenuItem.Text = "Save";
      this.saveToolStripMenuItem.Click += new System.EventHandler(this.saveToolStripMenuItem_Click);
      // 
      // DebugView
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(691, 500);
      this.Controls.Add(this.textDebug);
      this.Controls.Add(this.panel1);
      this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
      this.Name = "DebugView";
      this.Text = "DebugView";
      this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.DebugView_FormClosing);
      this.Load += new System.EventHandler(this.DebugView_Load);
      this.panel1.ResumeLayout(false);
      this.panel1.PerformLayout();
      this.contextMenu.ResumeLayout(false);
      this.ResumeLayout(false);
      this.PerformLayout();

      }

    #endregion

    private System.Windows.Forms.TextBox textDebug;
    private System.Windows.Forms.Panel panel1;
    private System.Windows.Forms.Button btnClear;
    private System.Windows.Forms.Button btnSave;
    private System.Windows.Forms.SaveFileDialog saveFileDialog;
    private System.Windows.Forms.CheckBox chkOnTop;
    private System.Windows.Forms.CheckBox chkTimestamp;
    private System.Windows.Forms.ContextMenuStrip contextMenu;
    private System.Windows.Forms.ToolStripMenuItem selectAllToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem copyToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem saveToolStripMenuItem;

    }
  }