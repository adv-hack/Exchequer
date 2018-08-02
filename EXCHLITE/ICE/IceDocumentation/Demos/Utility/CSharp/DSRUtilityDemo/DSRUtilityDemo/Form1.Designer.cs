namespace DSRUtilityDemo
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
            this.btnCompress = new System.Windows.Forms.Button();
            this.btnDeCompress = new System.Windows.Forms.Button();
            this.btnEncrypt = new System.Windows.Forms.Button();
            this.btnDecrypt = new System.Windows.Forms.Button();
            this.btnGetXml = new System.Windows.Forms.Button();
            this.odFiles = new System.Windows.Forms.OpenFileDialog();
            this.btnCreateFile = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnCompress
            // 
            this.btnCompress.Location = new System.Drawing.Point(12, 36);
            this.btnCompress.Name = "btnCompress";
            this.btnCompress.Size = new System.Drawing.Size(75, 23);
            this.btnCompress.TabIndex = 0;
            this.btnCompress.Text = "Compress";
            this.btnCompress.UseVisualStyleBackColor = true;
            this.btnCompress.Click += new System.EventHandler(this.btnCompress_Click);
            // 
            // btnDeCompress
            // 
            this.btnDeCompress.Location = new System.Drawing.Point(93, 36);
            this.btnDeCompress.Name = "btnDeCompress";
            this.btnDeCompress.Size = new System.Drawing.Size(75, 23);
            this.btnDeCompress.TabIndex = 1;
            this.btnDeCompress.Text = "Decompress";
            this.btnDeCompress.UseVisualStyleBackColor = true;
            this.btnDeCompress.Click += new System.EventHandler(this.btnDeCompress_Click);
            // 
            // btnEncrypt
            // 
            this.btnEncrypt.Location = new System.Drawing.Point(174, 36);
            this.btnEncrypt.Name = "btnEncrypt";
            this.btnEncrypt.Size = new System.Drawing.Size(75, 23);
            this.btnEncrypt.TabIndex = 2;
            this.btnEncrypt.Text = "Encrypt";
            this.btnEncrypt.UseVisualStyleBackColor = true;
            this.btnEncrypt.Click += new System.EventHandler(this.btnEncrypt_Click);
            // 
            // btnDecrypt
            // 
            this.btnDecrypt.Location = new System.Drawing.Point(255, 36);
            this.btnDecrypt.Name = "btnDecrypt";
            this.btnDecrypt.Size = new System.Drawing.Size(75, 23);
            this.btnDecrypt.TabIndex = 3;
            this.btnDecrypt.Text = "Decrypt";
            this.btnDecrypt.UseVisualStyleBackColor = true;
            this.btnDecrypt.Click += new System.EventHandler(this.btnDecrypt_Click);
            // 
            // btnGetXml
            // 
            this.btnGetXml.Location = new System.Drawing.Point(336, 36);
            this.btnGetXml.Name = "btnGetXml";
            this.btnGetXml.Size = new System.Drawing.Size(75, 23);
            this.btnGetXml.TabIndex = 4;
            this.btnGetXml.Text = "Get Xml";
            this.btnGetXml.UseVisualStyleBackColor = true;
            this.btnGetXml.Click += new System.EventHandler(this.btnGetXml_Click);
            // 
            // odFiles
            // 
            this.odFiles.RestoreDirectory = true;
            // 
            // btnCreateFile
            // 
            this.btnCreateFile.Location = new System.Drawing.Point(12, 70);
            this.btnCreateFile.Name = "btnCreateFile";
            this.btnCreateFile.Size = new System.Drawing.Size(75, 23);
            this.btnCreateFile.TabIndex = 5;
            this.btnCreateFile.Text = "Create File";
            this.btnCreateFile.UseVisualStyleBackColor = true;
            this.btnCreateFile.Click += new System.EventHandler(this.btnCreateFile_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(423, 105);
            this.Controls.Add(this.btnCreateFile);
            this.Controls.Add(this.btnGetXml);
            this.Controls.Add(this.btnDecrypt);
            this.Controls.Add(this.btnEncrypt);
            this.Controls.Add(this.btnDeCompress);
            this.Controls.Add(this.btnCompress);
            this.Name = "Form1";
            this.Text = "DSR Utility Demo";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnCompress;
        private System.Windows.Forms.Button btnDeCompress;
        private System.Windows.Forms.Button btnEncrypt;
        private System.Windows.Forms.Button btnDecrypt;
        private System.Windows.Forms.Button btnGetXml;
        private System.Windows.Forms.OpenFileDialog odFiles;
        private System.Windows.Forms.Button btnCreateFile;
    }
}

