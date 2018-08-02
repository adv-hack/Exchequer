namespace Data_Integrity_Checker
{
    partial class frmDataIntegrityNoUI
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmDataIntegrityNoUI));
            this.tsProgressBar = new System.Windows.Forms.ProgressBar();
            this.lblStatus = new System.Windows.Forms.Label();
            this.tssVersion = new System.Windows.Forms.Label();
            this.btnCancel = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // tsProgressBar
            // 
            this.tsProgressBar.Location = new System.Drawing.Point(12, 43);
            this.tsProgressBar.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.tsProgressBar.Name = "tsProgressBar";
            this.tsProgressBar.Size = new System.Drawing.Size(418, 21);
            this.tsProgressBar.TabIndex = 3;
            // 
            // lblStatus
            // 
            this.lblStatus.Location = new System.Drawing.Point(12, 9);
            this.lblStatus.Name = "lblStatus";
            this.lblStatus.Size = new System.Drawing.Size(418, 30);
            this.lblStatus.TabIndex = 4;
            this.lblStatus.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // tssVersion
            // 
            this.tssVersion.ImageAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.tssVersion.Location = new System.Drawing.Point(12, 100);
            this.tssVersion.Name = "tssVersion";
            this.tssVersion.Size = new System.Drawing.Size(418, 21);
            this.tssVersion.TabIndex = 5;
            this.tssVersion.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // btnCancel
            // 
            this.btnCancel.Location = new System.Drawing.Point(176, 71);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(86, 26);
            this.btnCancel.TabIndex = 6;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // frmDataIntegrityNoUI
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 17F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(442, 131);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.tssVersion);
            this.Controls.Add(this.lblStatus);
            this.Controls.Add(this.tsProgressBar);
            this.Font = new System.Drawing.Font("Open Sans", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.Name = "frmDataIntegrityNoUI";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Exchequer SQL Data Validation Tool";
            this.Load += new System.EventHandler(this.frmDataIntegrityNoUI_Load);
            this.Shown += new System.EventHandler(this.frmDataIntegrityNoUI_Shown);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ProgressBar tsProgressBar;
        private System.Windows.Forms.Label lblStatus;
        private System.Windows.Forms.Label tssVersion;
        private System.Windows.Forms.Button btnCancel;
    }
}