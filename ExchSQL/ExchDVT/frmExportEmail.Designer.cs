namespace Data_Integrity_Checker
{
    partial class frmExportEmail
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
            this.SaveFileDialog = new System.Windows.Forms.SaveFileDialog();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.txtCompanyName = new System.Windows.Forms.TextBox();
            this.txtContactName = new System.Windows.Forms.TextBox();
            this.btnSaveResults = new System.Windows.Forms.Button();
            this.txtEmailAddress = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // SaveFileDialog
            // 
            this.SaveFileDialog.FileName = "ExchSQLDataValidationResults";
            this.SaveFileDialog.Title = "Select Location to Save results";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(15, 17);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(98, 17);
            this.label1.TabIndex = 0;
            this.label1.Text = "Company Name";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(25, 47);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(88, 17);
            this.label2.TabIndex = 1;
            this.label2.Text = "Contact Name";
            // 
            // txtCompanyName
            // 
            this.txtCompanyName.Location = new System.Drawing.Point(119, 14);
            this.txtCompanyName.MaxLength = 100;
            this.txtCompanyName.Name = "txtCompanyName";
            this.txtCompanyName.Size = new System.Drawing.Size(434, 24);
            this.txtCompanyName.TabIndex = 2;
            // 
            // txtContactName
            // 
            this.txtContactName.Location = new System.Drawing.Point(119, 44);
            this.txtContactName.MaxLength = 100;
            this.txtContactName.Name = "txtContactName";
            this.txtContactName.Size = new System.Drawing.Size(434, 24);
            this.txtContactName.TabIndex = 3;
            // 
            // btnSaveResults
            // 
            this.btnSaveResults.Location = new System.Drawing.Point(216, 104);
            this.btnSaveResults.Name = "btnSaveResults";
            this.btnSaveResults.Size = new System.Drawing.Size(139, 25);
            this.btnSaveResults.TabIndex = 5;
            this.btnSaveResults.Text = "Export Results";
            this.btnSaveResults.UseVisualStyleBackColor = true;
            this.btnSaveResults.Click += new System.EventHandler(this.btnSaveResults_Click);
            // 
            // txtEmailAddress
            // 
            this.txtEmailAddress.Location = new System.Drawing.Point(119, 74);
            this.txtEmailAddress.MaxLength = 100;
            this.txtEmailAddress.Name = "txtEmailAddress";
            this.txtEmailAddress.Size = new System.Drawing.Size(434, 24);
            this.txtEmailAddress.TabIndex = 4;
            this.txtEmailAddress.Validating += new System.ComponentModel.CancelEventHandler(this.txtEmailAddress_Validating);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(25, 77);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(88, 17);
            this.label3.TabIndex = 5;
            this.label3.Text = "Email Address";
            // 
            // frmExportEmail
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 17F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(571, 143);
            this.Controls.Add(this.txtEmailAddress);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.btnSaveResults);
            this.Controls.Add(this.txtContactName);
            this.Controls.Add(this.txtCompanyName);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Font = new System.Drawing.Font("Open Sans", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmExportEmail";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Export/Email Results";
            this.Load += new System.EventHandler(this.frmExportEmail_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.SaveFileDialog SaveFileDialog;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtCompanyName;
        private System.Windows.Forms.TextBox txtContactName;
        private System.Windows.Forms.Button btnSaveResults;
        private System.Windows.Forms.TextBox txtEmailAddress;
        private System.Windows.Forms.Label label3;
    }
}