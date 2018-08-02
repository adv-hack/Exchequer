namespace Data_Integrity_Checker
{
    partial class frmDataIntegrityUI
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmDataIntegrityUI));
            this.StatusStrip = new System.Windows.Forms.StatusStrip();
            this.tsProgressBar = new System.Windows.Forms.ToolStripProgressBar();
            this.tsCheckStatus = new System.Windows.Forms.ToolStripStatusLabel();
            this.tssVersion = new System.Windows.Forms.ToolStripStatusLabel();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.btnClose = new System.Windows.Forms.Button();
            this.btnSelectAll = new System.Windows.Forms.Button();
            this.btnSelectNone = new System.Windows.Forms.Button();
            this.btnSaveResults = new System.Windows.Forms.Button();
            this.btnEmailResults = new System.Windows.Forms.Button();
            this.btnCheckCompanies = new System.Windows.Forms.Button();
            this.lvCompanies = new System.Windows.Forms.ListView();
            this.columnHeader4 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader1 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader2 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader3 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader9 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.btnReturnToSummary = new System.Windows.Forms.Button();
            this.lvSummaryResults = new System.Windows.Forms.ListView();
            this.lvResultCode = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.lvResultDescription = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.lvSeverity = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.lvResultCompany = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.lvResultTable = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.lvDetailedResults = new System.Windows.Forms.ListView();
            this.columnHeader6 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader7 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader8 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader5 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.StatusStrip.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.SuspendLayout();
            // 
            // StatusStrip
            // 
            this.StatusStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.tsProgressBar,
            this.tsCheckStatus,
            this.tssVersion});
            this.StatusStrip.Location = new System.Drawing.Point(0, 640);
            this.StatusStrip.Name = "StatusStrip";
            this.StatusStrip.Padding = new System.Windows.Forms.Padding(1, 0, 16, 0);
            this.StatusStrip.Size = new System.Drawing.Size(932, 27);
            this.StatusStrip.TabIndex = 1;
            this.StatusStrip.Text = "statusStrip1";
            // 
            // tsProgressBar
            // 
            this.tsProgressBar.Name = "tsProgressBar";
            this.tsProgressBar.Size = new System.Drawing.Size(233, 21);
            // 
            // tsCheckStatus
            // 
            this.tsCheckStatus.Font = new System.Drawing.Font("Open Sans", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tsCheckStatus.Name = "tsCheckStatus";
            this.tsCheckStatus.Size = new System.Drawing.Size(0, 22);
            // 
            // tssVersion
            // 
            this.tssVersion.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.tssVersion.Font = new System.Drawing.Font("Open Sans", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tssVersion.Name = "tssVersion";
            this.tssVersion.Size = new System.Drawing.Size(680, 22);
            this.tssVersion.Spring = true;
            this.tssVersion.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(0, 0);
            this.splitContainer1.Name = "splitContainer1";
            this.splitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.btnClose);
            this.splitContainer1.Panel1.Controls.Add(this.btnSelectAll);
            this.splitContainer1.Panel1.Controls.Add(this.btnSelectNone);
            this.splitContainer1.Panel1.Controls.Add(this.btnSaveResults);
            this.splitContainer1.Panel1.Controls.Add(this.btnEmailResults);
            this.splitContainer1.Panel1.Controls.Add(this.btnCheckCompanies);
            this.splitContainer1.Panel1.Controls.Add(this.lvCompanies);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.btnReturnToSummary);
            this.splitContainer1.Panel2.Controls.Add(this.lvSummaryResults);
            this.splitContainer1.Panel2.Controls.Add(this.lvDetailedResults);
            this.splitContainer1.Size = new System.Drawing.Size(932, 640);
            this.splitContainer1.SplitterDistance = 265;
            this.splitContainer1.TabIndex = 4;
            // 
            // btnClose
            // 
            this.btnClose.Location = new System.Drawing.Point(815, 42);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(105, 23);
            this.btnClose.TabIndex = 9;
            this.btnClose.Text = "Close";
            this.btnClose.UseVisualStyleBackColor = true;
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // btnSelectAll
            // 
            this.btnSelectAll.Location = new System.Drawing.Point(815, 197);
            this.btnSelectAll.Name = "btnSelectAll";
            this.btnSelectAll.Size = new System.Drawing.Size(105, 23);
            this.btnSelectAll.TabIndex = 8;
            this.btnSelectAll.Text = "Select All";
            this.btnSelectAll.UseVisualStyleBackColor = true;
            this.btnSelectAll.Click += new System.EventHandler(this.btnSelectAll_Click);
            // 
            // btnSelectNone
            // 
            this.btnSelectNone.Location = new System.Drawing.Point(815, 226);
            this.btnSelectNone.Name = "btnSelectNone";
            this.btnSelectNone.Size = new System.Drawing.Size(105, 23);
            this.btnSelectNone.TabIndex = 7;
            this.btnSelectNone.Text = "Select None";
            this.btnSelectNone.UseVisualStyleBackColor = true;
            this.btnSelectNone.Click += new System.EventHandler(this.btnSelectNone_Click);
            // 
            // btnSaveResults
            // 
            this.btnSaveResults.Enabled = false;
            this.btnSaveResults.Location = new System.Drawing.Point(815, 108);
            this.btnSaveResults.Name = "btnSaveResults";
            this.btnSaveResults.Size = new System.Drawing.Size(105, 23);
            this.btnSaveResults.TabIndex = 6;
            this.btnSaveResults.Text = "Save Results";
            this.btnSaveResults.UseVisualStyleBackColor = true;
            this.btnSaveResults.Click += new System.EventHandler(this.btnSaveResults_Click);
            // 
            // btnEmailResults
            // 
            this.btnEmailResults.Enabled = false;
            this.btnEmailResults.Location = new System.Drawing.Point(815, 137);
            this.btnEmailResults.Name = "btnEmailResults";
            this.btnEmailResults.Size = new System.Drawing.Size(105, 23);
            this.btnEmailResults.TabIndex = 5;
            this.btnEmailResults.Text = "Email Results";
            this.btnEmailResults.UseVisualStyleBackColor = true;
            this.btnEmailResults.Visible = false;
            this.btnEmailResults.Click += new System.EventHandler(this.btnEmailResults_Click);
            // 
            // btnCheckCompanies
            // 
            this.btnCheckCompanies.Location = new System.Drawing.Point(815, 13);
            this.btnCheckCompanies.Name = "btnCheckCompanies";
            this.btnCheckCompanies.Size = new System.Drawing.Size(105, 23);
            this.btnCheckCompanies.TabIndex = 4;
            this.btnCheckCompanies.Text = "Run Check";
            this.btnCheckCompanies.UseVisualStyleBackColor = true;
            this.btnCheckCompanies.Click += new System.EventHandler(this.btnCheckCompanies_Click);
            // 
            // lvCompanies
            // 
            this.lvCompanies.CheckBoxes = true;
            this.lvCompanies.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader4,
            this.columnHeader1,
            this.columnHeader2,
            this.columnHeader3,
            this.columnHeader9});
            this.lvCompanies.Dock = System.Windows.Forms.DockStyle.Left;
            this.lvCompanies.Font = new System.Drawing.Font("Open Sans", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lvCompanies.FullRowSelect = true;
            this.lvCompanies.Location = new System.Drawing.Point(0, 0);
            this.lvCompanies.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.lvCompanies.Name = "lvCompanies";
            this.lvCompanies.Size = new System.Drawing.Size(803, 265);
            this.lvCompanies.TabIndex = 3;
            this.lvCompanies.UseCompatibleStateImageBehavior = false;
            this.lvCompanies.View = System.Windows.Forms.View.Details;
            this.lvCompanies.KeyDown += new System.Windows.Forms.KeyEventHandler(this.lvCompanies_KeyDown);
            // 
            // columnHeader4
            // 
            this.columnHeader4.Text = "";
            this.columnHeader4.Width = 25;
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "Code";
            this.columnHeader1.Width = 100;
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "Company Name";
            this.columnHeader2.Width = 281;
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "Path";
            this.columnHeader3.Width = 281;
            // 
            // columnHeader9
            // 
            this.columnHeader9.Text = "Status";
            this.columnHeader9.Width = 83;
            // 
            // btnReturnToSummary
            // 
            this.btnReturnToSummary.Location = new System.Drawing.Point(399, 343);
            this.btnReturnToSummary.Name = "btnReturnToSummary";
            this.btnReturnToSummary.Size = new System.Drawing.Size(134, 23);
            this.btnReturnToSummary.TabIndex = 9;
            this.btnReturnToSummary.Text = "Return to Summary";
            this.btnReturnToSummary.UseVisualStyleBackColor = true;
            this.btnReturnToSummary.Visible = false;
            this.btnReturnToSummary.Click += new System.EventHandler(this.btnReturnToSummary_Click);
            // 
            // lvSummaryResults
            // 
            this.lvSummaryResults.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.lvResultCode,
            this.lvResultDescription,
            this.lvSeverity,
            this.lvResultCompany,
            this.lvResultTable});
            this.lvSummaryResults.Dock = System.Windows.Forms.DockStyle.Fill;
            this.lvSummaryResults.FullRowSelect = true;
            this.lvSummaryResults.Location = new System.Drawing.Point(0, 337);
            this.lvSummaryResults.MultiSelect = false;
            this.lvSummaryResults.Name = "lvSummaryResults";
            this.lvSummaryResults.Size = new System.Drawing.Size(932, 34);
            this.lvSummaryResults.TabIndex = 4;
            this.lvSummaryResults.UseCompatibleStateImageBehavior = false;
            this.lvSummaryResults.View = System.Windows.Forms.View.Details;
            this.lvSummaryResults.DoubleClick += new System.EventHandler(this.lvSummaryResults_DoubleClick);
            // 
            // lvResultCode
            // 
            this.lvResultCode.Text = "Result Code";
            this.lvResultCode.Width = 89;
            // 
            // lvResultDescription
            // 
            this.lvResultDescription.Text = "Result Description";
            this.lvResultDescription.Width = 582;
            // 
            // lvSeverity
            // 
            this.lvSeverity.Text = "Severity";
            // 
            // lvResultCompany
            // 
            this.lvResultCompany.Text = "Company";
            this.lvResultCompany.Width = 86;
            // 
            // lvResultTable
            // 
            this.lvResultTable.Text = "Table";
            this.lvResultTable.Width = 86;
            // 
            // lvDetailedResults
            // 
            this.lvDetailedResults.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader6,
            this.columnHeader7,
            this.columnHeader8,
            this.columnHeader5});
            this.lvDetailedResults.Dock = System.Windows.Forms.DockStyle.Top;
            this.lvDetailedResults.FullRowSelect = true;
            this.lvDetailedResults.Location = new System.Drawing.Point(0, 0);
            this.lvDetailedResults.MultiSelect = false;
            this.lvDetailedResults.Name = "lvDetailedResults";
            this.lvDetailedResults.Size = new System.Drawing.Size(932, 337);
            this.lvDetailedResults.TabIndex = 5;
            this.lvDetailedResults.UseCompatibleStateImageBehavior = false;
            this.lvDetailedResults.View = System.Windows.Forms.View.Details;
            this.lvDetailedResults.Visible = false;
            // 
            // columnHeader6
            // 
            this.columnHeader6.Text = "Result Description";
            this.columnHeader6.Width = 599;
            // 
            // columnHeader7
            // 
            this.columnHeader7.Text = "Company";
            this.columnHeader7.Width = 86;
            // 
            // columnHeader8
            // 
            this.columnHeader8.Text = "Table";
            this.columnHeader8.Width = 131;
            // 
            // columnHeader5
            // 
            this.columnHeader5.Text = "Position ID";
            this.columnHeader5.Width = 89;
            // 
            // frmDataIntegrityUI
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 17F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(932, 667);
            this.Controls.Add(this.splitContainer1);
            this.Controls.Add(this.StatusStrip);
            this.Font = new System.Drawing.Font("Open Sans", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmDataIntegrityUI";
            this.Text = "Exchequer SQL Data Validation Tool";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.DataIntegityUI_FormClosed);
            this.Load += new System.EventHandler(this.Form1_Load);
            this.StatusStrip.ResumeLayout(false);
            this.StatusStrip.PerformLayout();
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.StatusStrip StatusStrip;
        private System.Windows.Forms.ToolStripProgressBar tsProgressBar;
        private System.Windows.Forms.ToolStripStatusLabel tssVersion;
        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.Button btnEmailResults;
        private System.Windows.Forms.Button btnCheckCompanies;
        private System.Windows.Forms.ListView lvCompanies;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.ListView lvSummaryResults;
        private System.Windows.Forms.ColumnHeader lvResultCompany;
        private System.Windows.Forms.ColumnHeader lvResultCode;
        private System.Windows.Forms.ColumnHeader lvResultDescription;
        private System.Windows.Forms.ColumnHeader lvResultTable;
        private System.Windows.Forms.ColumnHeader columnHeader3;
        private System.Windows.Forms.ColumnHeader columnHeader4;
        private System.Windows.Forms.Button btnSaveResults;
        private System.Windows.Forms.Button btnSelectAll;
        private System.Windows.Forms.Button btnSelectNone;
        private System.Windows.Forms.Button btnReturnToSummary;
        private System.Windows.Forms.ListView lvDetailedResults;
        private System.Windows.Forms.ColumnHeader columnHeader6;
        private System.Windows.Forms.ColumnHeader columnHeader7;
        private System.Windows.Forms.ColumnHeader columnHeader8;
        private System.Windows.Forms.ColumnHeader columnHeader5;
        private System.Windows.Forms.ToolStripStatusLabel tsCheckStatus;
        private System.Windows.Forms.ColumnHeader lvSeverity;
        private System.Windows.Forms.Button btnClose;
        private System.Windows.Forms.ColumnHeader columnHeader9;
    }
}

