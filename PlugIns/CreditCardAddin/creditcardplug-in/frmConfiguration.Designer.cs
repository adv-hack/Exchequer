namespace PaymentGatewayAddin
  {
  partial class ConfigurationForm
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
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ConfigurationForm));
      this.label1 = new System.Windows.Forms.Label();
      this.label2 = new System.Windows.Forms.Label();
      this.comboMCMCompany = new System.Windows.Forms.ComboBox();
      this.label3 = new System.Windows.Forms.Label();
      this.textPassword = new System.Windows.Forms.TextBox();
      this.label4 = new System.Windows.Forms.Label();
      this.spinSourceUDF = new System.Windows.Forms.NumericUpDown();
      this.chkEnableCCFuncs = new System.Windows.Forms.CheckBox();
      this.btnCancel = new System.Windows.Forms.Button();
      this.btnApply = new System.Windows.Forms.Button();
      this.dgvConfiguration = new System.Windows.Forms.DataGridView();
      this.clPaymentProvider = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.clMerchantID = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.clSource = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.clGLCode = new System.Windows.Forms.DataGridViewComboBoxColumn();
      this.clCostCentre = new System.Windows.Forms.DataGridViewComboBoxColumn();
      this.clDepartment = new System.Windows.Forms.DataGridViewComboBoxColumn();
      this.clMerchantAccountId = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.clMerchantAccountCode = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.clPaymentProviderId = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.btnOK = new System.Windows.Forms.Button();
      this.btnUpdateFromPP = new System.Windows.Forms.Button();
      this.textSiteID = new System.Windows.Forms.MaskedTextBox();
      this.tabControl1 = new System.Windows.Forms.TabControl();
      this.tabCCGConfig = new System.Windows.Forms.TabPage();
      this.btnGetCredentials = new System.Windows.Forms.Button();
      this.textSecurityCode = new System.Windows.Forms.TextBox();
      this.label12 = new System.Windows.Forms.Label();
      this.tabCurrencies = new System.Windows.Forms.TabPage();
      this.dgvCurrencies = new System.Windows.Forms.DataGridView();
      this.colExchCurrencyName = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.colExchCurrencySymbol = new System.Windows.Forms.DataGridViewTextBoxColumn();
      this.label5 = new System.Windows.Forms.Label();
      this.tabRestore = new System.Windows.Forms.TabPage();
      this.lblRestoreComplete = new System.Windows.Forms.Label();
      this.chkRestoreSORs = new System.Windows.Forms.CheckBox();
      this.btnViewCSV = new System.Windows.Forms.Button();
      this.progressBar = new System.Windows.Forms.ProgressBar();
      this.btnRestoreHelp = new System.Windows.Forms.Button();
      this.btnRestore = new System.Windows.Forms.Button();
      this.btnSaveToCSV = new System.Windows.Forms.Button();
      this.groupBox1 = new System.Windows.Forms.GroupBox();
      this.timeTo = new System.Windows.Forms.DateTimePicker();
      this.timeFrom = new System.Windows.Forms.DateTimePicker();
      this.dateTo = new System.Windows.Forms.DateTimePicker();
      this.label11 = new System.Windows.Forms.Label();
      this.label10 = new System.Windows.Forms.Label();
      this.dateFrom = new System.Windows.Forms.DateTimePicker();
      this.lblRestoreDept = new System.Windows.Forms.Label();
      this.comboRestoreDepartment = new System.Windows.Forms.ComboBox();
      this.comboRestoreCostCentre = new System.Windows.Forms.ComboBox();
      this.lblRestoreCC = new System.Windows.Forms.Label();
      this.comboRestoreGLCode = new System.Windows.Forms.ComboBox();
      this.label7 = new System.Windows.Forms.Label();
      this.comboRestoreMCM = new System.Windows.Forms.ComboBox();
      this.label6 = new System.Windows.Forms.Label();
      this.btnViewLog = new System.Windows.Forms.Button();
      this.tabConfig = new System.Windows.Forms.TabPage();
      this.plughLabel = new System.Windows.Forms.Label();
      this.btnSaveConfig = new System.Windows.Forms.Button();
      this.editConfig = new System.Windows.Forms.TextBox();
      this.saveCSVFileDialog = new System.Windows.Forms.SaveFileDialog();
      this.lblVersion = new System.Windows.Forms.Label();
      this.toolTip = new System.Windows.Forms.ToolTip(this.components);
      this.helpProvider = new System.Windows.Forms.HelpProvider();
      this.gLCodeListItemBindingSource = new System.Windows.Forms.BindingSource(this.components);
      ((System.ComponentModel.ISupportInitialize)(this.spinSourceUDF)).BeginInit();
      ((System.ComponentModel.ISupportInitialize)(this.dgvConfiguration)).BeginInit();
      this.tabControl1.SuspendLayout();
      this.tabCCGConfig.SuspendLayout();
      this.tabCurrencies.SuspendLayout();
      ((System.ComponentModel.ISupportInitialize)(this.dgvCurrencies)).BeginInit();
      this.tabRestore.SuspendLayout();
      this.groupBox1.SuspendLayout();
      this.tabConfig.SuspendLayout();
      ((System.ComponentModel.ISupportInitialize)(this.gLCodeListItemBindingSource)).BeginInit();
      this.SuspendLayout();
      // 
      // label1
      // 
      this.label1.AutoSize = true;
      this.label1.Location = new System.Drawing.Point(30, 61);
      this.label1.Name = "label1";
      this.label1.Size = new System.Drawing.Size(75, 14);
      this.label1.TabIndex = 3;
      this.label1.Text = "Site Identifier :";
      this.label1.TextAlign = System.Drawing.ContentAlignment.TopRight;
      // 
      // label2
      // 
      this.label2.AutoSize = true;
      this.label2.Location = new System.Drawing.Point(21, 113);
      this.label2.Name = "label2";
      this.label2.Size = new System.Drawing.Size(84, 14);
      this.label2.TabIndex = 2;
      this.label2.Text = "MCM Company :";
      this.label2.TextAlign = System.Drawing.ContentAlignment.TopRight;
      // 
      // comboMCMCompany
      // 
      this.comboMCMCompany.FormattingEnabled = true;
      this.comboMCMCompany.Location = new System.Drawing.Point(118, 110);
      this.comboMCMCompany.Name = "comboMCMCompany";
      this.comboMCMCompany.Size = new System.Drawing.Size(285, 22);
      this.comboMCMCompany.TabIndex = 3;
      this.comboMCMCompany.SelectedIndexChanged += new System.EventHandler(this.comboMCMCompany_SelectedIndexChanged);
      this.comboMCMCompany.Click += new System.EventHandler(this.comboMCMCompany_Click);
      // 
      // label3
      // 
      this.label3.AutoSize = true;
      this.label3.Location = new System.Drawing.Point(42, 87);
      this.label3.Name = "label3";
      this.label3.Size = new System.Drawing.Size(63, 14);
      this.label3.TabIndex = 6;
      this.label3.Text = "Password :";
      this.label3.TextAlign = System.Drawing.ContentAlignment.TopRight;
      // 
      // textPassword
      // 
      this.textPassword.Enabled = false;
      this.textPassword.Location = new System.Drawing.Point(118, 84);
      this.textPassword.MaxLength = 50;
      this.textPassword.Name = "textPassword";
      this.textPassword.PasswordChar = '*';
      this.textPassword.ReadOnly = true;
      this.textPassword.Size = new System.Drawing.Size(285, 20);
      this.textPassword.TabIndex = 2;
      this.textPassword.TabStop = false;
      this.textPassword.UseSystemPasswordChar = true;
      this.textPassword.TextChanged += new System.EventHandler(this.textPassword_TextChanged);
      // 
      // label4
      // 
      this.label4.AutoSize = true;
      this.label4.Location = new System.Drawing.Point(18, 328);
      this.label4.Name = "label4";
      this.label4.Size = new System.Drawing.Size(110, 14);
      this.label4.TabIndex = 7;
      this.label4.Text = "Source UDF (5 - 10) :";
      // 
      // spinSourceUDF
      // 
      this.spinSourceUDF.Enabled = false;
      this.spinSourceUDF.Location = new System.Drawing.Point(134, 326);
      this.spinSourceUDF.Maximum = new decimal(new int[] {
            10,
            0,
            0,
            0});
      this.spinSourceUDF.Minimum = new decimal(new int[] {
            5,
            0,
            0,
            0});
      this.spinSourceUDF.Name = "spinSourceUDF";
      this.spinSourceUDF.Size = new System.Drawing.Size(48, 20);
      this.spinSourceUDF.TabIndex = 8;
      this.spinSourceUDF.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
      this.toolTip.SetToolTip(this.spinSourceUDF, "Select the UDF which will specify the source of the transaction");
      this.spinSourceUDF.Value = new decimal(new int[] {
            10,
            0,
            0,
            0});
      this.spinSourceUDF.ValueChanged += new System.EventHandler(this.spinSourceUDF_ValueChanged);
      this.spinSourceUDF.KeyUp += new System.Windows.Forms.KeyEventHandler(this.spinSourceUDF_KeyUp);
      // 
      // chkEnableCCFuncs
      // 
      this.chkEnableCCFuncs.AutoSize = true;
      this.chkEnableCCFuncs.Enabled = false;
      this.chkEnableCCFuncs.Location = new System.Drawing.Point(21, 352);
      this.chkEnableCCFuncs.Name = "chkEnableCCFuncs";
      this.chkEnableCCFuncs.Size = new System.Drawing.Size(259, 18);
      this.chkEnableCCFuncs.TabIndex = 9;
      this.chkEnableCCFuncs.Text = "Enable credit card functionality for this Company";
      this.chkEnableCCFuncs.UseVisualStyleBackColor = true;
      this.chkEnableCCFuncs.CheckStateChanged += new System.EventHandler(this.chkEnableCCFuncs_CheckStateChanged);
      // 
      // btnCancel
      // 
      this.btnCancel.CausesValidation = false;
      this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
      this.btnCancel.Location = new System.Drawing.Point(532, 415);
      this.btnCancel.Name = "btnCancel";
      this.btnCancel.Size = new System.Drawing.Size(80, 21);
      this.btnCancel.TabIndex = 2;
      this.btnCancel.Text = "Cancel";
      this.toolTip.SetToolTip(this.btnCancel, "Close without saving");
      this.btnCancel.UseVisualStyleBackColor = true;
      this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
      // 
      // btnApply
      // 
      this.btnApply.Enabled = false;
      this.btnApply.Location = new System.Drawing.Point(360, 415);
      this.btnApply.Name = "btnApply";
      this.btnApply.Size = new System.Drawing.Size(80, 21);
      this.btnApply.TabIndex = 0;
      this.btnApply.Text = "Apply";
      this.toolTip.SetToolTip(this.btnApply, "Save changes");
      this.btnApply.UseVisualStyleBackColor = true;
      this.btnApply.Click += new System.EventHandler(this.btnApply_Click);
      // 
      // dgvConfiguration
      // 
      this.dgvConfiguration.AccessibleDescription = "Configuration Table";
      this.dgvConfiguration.AllowUserToAddRows = false;
      this.dgvConfiguration.AllowUserToDeleteRows = false;
      this.dgvConfiguration.AllowUserToResizeRows = false;
      this.dgvConfiguration.BackgroundColor = System.Drawing.SystemColors.Control;
      this.dgvConfiguration.ColumnHeadersHeight = 24;
      this.dgvConfiguration.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
      this.dgvConfiguration.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.clPaymentProvider,
            this.clMerchantID,
            this.clSource,
            this.clGLCode,
            this.clCostCentre,
            this.clDepartment,
            this.clMerchantAccountId,
            this.clMerchantAccountCode,
            this.clPaymentProviderId});
      this.dgvConfiguration.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter;
      this.dgvConfiguration.GridColor = System.Drawing.SystemColors.Control;
      this.dgvConfiguration.Location = new System.Drawing.Point(2, 138);
      this.dgvConfiguration.MultiSelect = false;
      this.dgvConfiguration.Name = "dgvConfiguration";
      this.dgvConfiguration.RowHeadersVisible = false;
      this.dgvConfiguration.ShowEditingIcon = false;
      this.dgvConfiguration.Size = new System.Drawing.Size(609, 174);
      this.dgvConfiguration.TabIndex = 6;
      this.dgvConfiguration.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvConfiguration_CellEndEdit);
      this.dgvConfiguration.CellStateChanged += new System.Windows.Forms.DataGridViewCellStateChangedEventHandler(this.dgvConfiguration_CellStateChanged);
      this.dgvConfiguration.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgvConfiguration_CellValidating);
      this.dgvConfiguration.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvConfiguration_CellValueChanged);
      // 
      // clPaymentProvider
      // 
      this.clPaymentProvider.HeaderText = "Payment Provider";
      this.clPaymentProvider.Name = "clPaymentProvider";
      this.clPaymentProvider.ReadOnly = true;
      // 
      // clMerchantID
      // 
      this.clMerchantID.HeaderText = "Merchant ID";
      this.clMerchantID.Name = "clMerchantID";
      this.clMerchantID.ReadOnly = true;
      // 
      // clSource
      // 
      this.clSource.HeaderText = "Source";
      this.clSource.MaxInputLength = 30;
      this.clSource.Name = "clSource";
      // 
      // clGLCode
      // 
      this.clGLCode.DropDownWidth = 200;
      this.clGLCode.HeaderText = "G/L Code";
      this.clGLCode.Name = "clGLCode";
      this.clGLCode.Resizable = System.Windows.Forms.DataGridViewTriState.True;
      this.clGLCode.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
      // 
      // clCostCentre
      // 
      this.clCostCentre.DropDownWidth = 150;
      this.clCostCentre.HeaderText = "Cost Centre";
      this.clCostCentre.Name = "clCostCentre";
      this.clCostCentre.Resizable = System.Windows.Forms.DataGridViewTriState.True;
      this.clCostCentre.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
      // 
      // clDepartment
      // 
      this.clDepartment.DropDownWidth = 150;
      this.clDepartment.HeaderText = "Department";
      this.clDepartment.Name = "clDepartment";
      this.clDepartment.Resizable = System.Windows.Forms.DataGridViewTriState.True;
      this.clDepartment.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
      // 
      // clMerchantAccountId
      // 
      this.clMerchantAccountId.HeaderText = "MerchantAccountId";
      this.clMerchantAccountId.Name = "clMerchantAccountId";
      this.clMerchantAccountId.Visible = false;
      // 
      // clMerchantAccountCode
      // 
      this.clMerchantAccountCode.HeaderText = "MerchantAccountCode";
      this.clMerchantAccountCode.Name = "clMerchantAccountCode";
      this.clMerchantAccountCode.Visible = false;
      // 
      // clPaymentProviderId
      // 
      this.clPaymentProviderId.HeaderText = "PaymentProviderId";
      this.clPaymentProviderId.Name = "clPaymentProviderId";
      this.clPaymentProviderId.Visible = false;
      // 
      // btnOK
      // 
      this.btnOK.Location = new System.Drawing.Point(446, 415);
      this.btnOK.Name = "btnOK";
      this.btnOK.Size = new System.Drawing.Size(80, 21);
      this.btnOK.TabIndex = 1;
      this.btnOK.Text = "OK";
      this.toolTip.SetToolTip(this.btnOK, "Save and close");
      this.btnOK.UseVisualStyleBackColor = true;
      this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
      // 
      // btnUpdateFromPP
      // 
      this.btnUpdateFromPP.Enabled = false;
      this.btnUpdateFromPP.Location = new System.Drawing.Point(409, 58);
      this.btnUpdateFromPP.Name = "btnUpdateFromPP";
      this.btnUpdateFromPP.Size = new System.Drawing.Size(90, 21);
      this.btnUpdateFromPP.TabIndex = 5;
      this.btnUpdateFromPP.Text = "Update";
      this.toolTip.SetToolTip(this.btnUpdateFromPP, "Obtain Merchant Account data from the Exchequer Payments Portal");
      this.btnUpdateFromPP.UseVisualStyleBackColor = true;
      this.btnUpdateFromPP.Click += new System.EventHandler(this.btnUpdateFromPP_Click);
      // 
      // textSiteID
      // 
      this.textSiteID.Enabled = false;
      this.textSiteID.Location = new System.Drawing.Point(118, 58);
      this.textSiteID.Mask = "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA";
      this.textSiteID.Name = "textSiteID";
      this.textSiteID.ReadOnly = true;
      this.textSiteID.Size = new System.Drawing.Size(285, 20);
      this.textSiteID.TabIndex = 1;
      this.textSiteID.TabStop = false;
      this.textSiteID.TextChanged += new System.EventHandler(this.textSiteID_TextChanged);
      this.textSiteID.Leave += new System.EventHandler(this.textSiteID_Leave);
      // 
      // tabControl1
      // 
      this.tabControl1.Controls.Add(this.tabCCGConfig);
      this.tabControl1.Controls.Add(this.tabCurrencies);
      this.tabControl1.Controls.Add(this.tabRestore);
      this.tabControl1.Controls.Add(this.tabConfig);
      this.tabControl1.Dock = System.Windows.Forms.DockStyle.Top;
      this.tabControl1.Location = new System.Drawing.Point(0, 0);
      this.tabControl1.Name = "tabControl1";
      this.tabControl1.SelectedIndex = 0;
      this.tabControl1.Size = new System.Drawing.Size(624, 409);
      this.tabControl1.TabIndex = 0;
      this.tabControl1.SelectedIndexChanged += new System.EventHandler(this.tabControl1_SelectedIndexChanged);
      // 
      // tabCCGConfig
      // 
      this.tabCCGConfig.Controls.Add(this.btnGetCredentials);
      this.tabCCGConfig.Controls.Add(this.textSecurityCode);
      this.tabCCGConfig.Controls.Add(this.label12);
      this.tabCCGConfig.Controls.Add(this.label1);
      this.tabCCGConfig.Controls.Add(this.textSiteID);
      this.tabCCGConfig.Controls.Add(this.label2);
      this.tabCCGConfig.Controls.Add(this.comboMCMCompany);
      this.tabCCGConfig.Controls.Add(this.label3);
      this.tabCCGConfig.Controls.Add(this.btnUpdateFromPP);
      this.tabCCGConfig.Controls.Add(this.textPassword);
      this.tabCCGConfig.Controls.Add(this.label4);
      this.tabCCGConfig.Controls.Add(this.dgvConfiguration);
      this.tabCCGConfig.Controls.Add(this.spinSourceUDF);
      this.tabCCGConfig.Controls.Add(this.chkEnableCCFuncs);
      this.tabCCGConfig.Location = new System.Drawing.Point(4, 23);
      this.tabCCGConfig.Name = "tabCCGConfig";
      this.tabCCGConfig.Padding = new System.Windows.Forms.Padding(3);
      this.tabCCGConfig.Size = new System.Drawing.Size(616, 382);
      this.tabCCGConfig.TabIndex = 0;
      this.tabCCGConfig.Text = "Configuration";
      this.tabCCGConfig.UseVisualStyleBackColor = true;
      // 
      // btnGetCredentials
      // 
      this.btnGetCredentials.Location = new System.Drawing.Point(409, 15);
      this.btnGetCredentials.Name = "btnGetCredentials";
      this.btnGetCredentials.Size = new System.Drawing.Size(90, 21);
      this.btnGetCredentials.TabIndex = 4;
      this.btnGetCredentials.Text = "Get credentials";
      this.toolTip.SetToolTip(this.btnGetCredentials, "Obtain Exchequer Payments Portal login credentials");
      this.btnGetCredentials.UseVisualStyleBackColor = true;
      this.btnGetCredentials.Click += new System.EventHandler(this.btnGetCredentials_Click);
      // 
      // textSecurityCode
      // 
      this.textSecurityCode.Enabled = false;
      this.textSecurityCode.Location = new System.Drawing.Point(118, 15);
      this.textSecurityCode.Name = "textSecurityCode";
      this.textSecurityCode.Size = new System.Drawing.Size(285, 20);
      this.textSecurityCode.TabIndex = 0;
      // 
      // label12
      // 
      this.label12.AutoSize = true;
      this.label12.Location = new System.Drawing.Point(24, 18);
      this.label12.Name = "label12";
      this.label12.Size = new System.Drawing.Size(81, 14);
      this.label12.TabIndex = 0;
      this.label12.Text = "Security Code :";
      this.label12.TextAlign = System.Drawing.ContentAlignment.TopRight;
      // 
      // tabCurrencies
      // 
      this.tabCurrencies.Controls.Add(this.dgvCurrencies);
      this.tabCurrencies.Controls.Add(this.label5);
      this.tabCurrencies.Location = new System.Drawing.Point(4, 23);
      this.tabCurrencies.Name = "tabCurrencies";
      this.tabCurrencies.Padding = new System.Windows.Forms.Padding(3);
      this.tabCurrencies.Size = new System.Drawing.Size(616, 382);
      this.tabCurrencies.TabIndex = 1;
      this.tabCurrencies.Text = "Currencies";
      this.tabCurrencies.UseVisualStyleBackColor = true;
      // 
      // dgvCurrencies
      // 
      this.dgvCurrencies.AllowUserToAddRows = false;
      this.dgvCurrencies.AllowUserToDeleteRows = false;
      this.dgvCurrencies.AllowUserToResizeRows = false;
      this.dgvCurrencies.BackgroundColor = System.Drawing.SystemColors.Control;
      this.dgvCurrencies.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
      this.dgvCurrencies.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.colExchCurrencyName,
            this.colExchCurrencySymbol});
      this.dgvCurrencies.Location = new System.Drawing.Point(22, 35);
      this.dgvCurrencies.MultiSelect = false;
      this.dgvCurrencies.Name = "dgvCurrencies";
      this.dgvCurrencies.RowHeadersVisible = false;
      this.dgvCurrencies.Size = new System.Drawing.Size(524, 301);
      this.dgvCurrencies.TabIndex = 1;
      this.dgvCurrencies.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvCurrencies_CellEndEdit);
      this.dgvCurrencies.CellStateChanged += new System.Windows.Forms.DataGridViewCellStateChangedEventHandler(this.dgvCurrencies_CellStateChanged);
      this.dgvCurrencies.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvCurrencies_CellValueChanged);
      // 
      // colExchCurrencyName
      // 
      this.colExchCurrencyName.HeaderText = "Currency Name";
      this.colExchCurrencyName.Name = "colExchCurrencyName";
      this.colExchCurrencyName.ReadOnly = true;
      this.colExchCurrencyName.Width = 120;
      // 
      // colExchCurrencySymbol
      // 
      this.colExchCurrencySymbol.HeaderText = "Symbol";
      this.colExchCurrencySymbol.Name = "colExchCurrencySymbol";
      this.colExchCurrencySymbol.ReadOnly = true;
      this.colExchCurrencySymbol.Width = 60;
      // 
      // label5
      // 
      this.label5.AutoSize = true;
      this.label5.Location = new System.Drawing.Point(19, 18);
      this.label5.Name = "label5";
      this.label5.Size = new System.Drawing.Size(107, 14);
      this.label5.TabIndex = 0;
      this.label5.Text = "Exchequer Currency";
      // 
      // tabRestore
      // 
      this.tabRestore.Controls.Add(this.lblRestoreComplete);
      this.tabRestore.Controls.Add(this.chkRestoreSORs);
      this.tabRestore.Controls.Add(this.btnViewCSV);
      this.tabRestore.Controls.Add(this.progressBar);
      this.tabRestore.Controls.Add(this.btnRestoreHelp);
      this.tabRestore.Controls.Add(this.btnRestore);
      this.tabRestore.Controls.Add(this.btnSaveToCSV);
      this.tabRestore.Controls.Add(this.groupBox1);
      this.tabRestore.Controls.Add(this.lblRestoreDept);
      this.tabRestore.Controls.Add(this.comboRestoreDepartment);
      this.tabRestore.Controls.Add(this.comboRestoreCostCentre);
      this.tabRestore.Controls.Add(this.lblRestoreCC);
      this.tabRestore.Controls.Add(this.comboRestoreGLCode);
      this.tabRestore.Controls.Add(this.label7);
      this.tabRestore.Controls.Add(this.comboRestoreMCM);
      this.tabRestore.Controls.Add(this.label6);
      this.tabRestore.Controls.Add(this.btnViewLog);
      this.tabRestore.Location = new System.Drawing.Point(4, 23);
      this.tabRestore.Name = "tabRestore";
      this.tabRestore.Padding = new System.Windows.Forms.Padding(3);
      this.tabRestore.Size = new System.Drawing.Size(616, 382);
      this.tabRestore.TabIndex = 2;
      this.tabRestore.Text = "Restore";
      this.tabRestore.UseVisualStyleBackColor = true;
      this.tabRestore.HelpRequested += new System.Windows.Forms.HelpEventHandler(this.ConfigurationForm_HelpRequested);
      // 
      // lblRestoreComplete
      // 
      this.lblRestoreComplete.AutoSize = true;
      this.lblRestoreComplete.Location = new System.Drawing.Point(256, 279);
      this.lblRestoreComplete.Name = "lblRestoreComplete";
      this.lblRestoreComplete.Size = new System.Drawing.Size(117, 14);
      this.lblRestoreComplete.TabIndex = 14;
      this.lblRestoreComplete.Text = "Data Restore Complete";
      this.lblRestoreComplete.Visible = false;
      // 
      // chkRestoreSORs
      // 
      this.chkRestoreSORs.AutoSize = true;
      this.chkRestoreSORs.Checked = true;
      this.chkRestoreSORs.CheckState = System.Windows.Forms.CheckState.Checked;
      this.chkRestoreSORs.Location = new System.Drawing.Point(300, 184);
      this.chkRestoreSORs.Name = "chkRestoreSORs";
      this.chkRestoreSORs.Size = new System.Drawing.Size(107, 18);
      this.chkRestoreSORs.TabIndex = 5;
      this.chkRestoreSORs.Text = "Recreate Orders";
      this.chkRestoreSORs.UseVisualStyleBackColor = true;
      // 
      // btnViewCSV
      // 
      this.btnViewCSV.Enabled = false;
      this.btnViewCSV.Location = new System.Drawing.Point(510, 208);
      this.btnViewCSV.Name = "btnViewCSV";
      this.btnViewCSV.Size = new System.Drawing.Size(80, 21);
      this.btnViewCSV.TabIndex = 9;
      this.btnViewCSV.Text = "View CSV";
      this.btnViewCSV.UseVisualStyleBackColor = true;
      this.btnViewCSV.Click += new System.EventHandler(this.btnViewCSV_Click);
      // 
      // progressBar
      // 
      this.progressBar.Location = new System.Drawing.Point(22, 247);
      this.progressBar.MarqueeAnimationSpeed = 50;
      this.progressBar.Name = "progressBar";
      this.progressBar.Size = new System.Drawing.Size(568, 20);
      this.progressBar.Step = 1;
      this.progressBar.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
      this.progressBar.TabIndex = 12;
      this.progressBar.Visible = false;
      // 
      // btnRestoreHelp
      // 
      this.btnRestoreHelp.Location = new System.Drawing.Point(510, 15);
      this.btnRestoreHelp.Name = "btnRestoreHelp";
      this.btnRestoreHelp.Size = new System.Drawing.Size(80, 21);
      this.btnRestoreHelp.TabIndex = 1;
      this.btnRestoreHelp.Text = "Help";
      this.btnRestoreHelp.UseVisualStyleBackColor = true;
      this.btnRestoreHelp.Visible = false;
      this.btnRestoreHelp.Click += new System.EventHandler(this.btnHelp_Click);
      // 
      // btnRestore
      // 
      this.btnRestore.Location = new System.Drawing.Point(424, 182);
      this.btnRestore.Name = "btnRestore";
      this.btnRestore.Size = new System.Drawing.Size(80, 21);
      this.btnRestore.TabIndex = 6;
      this.btnRestore.Text = "Restore";
      this.btnRestore.UseVisualStyleBackColor = true;
      this.btnRestore.Click += new System.EventHandler(this.btnRestore_Click);
      // 
      // btnSaveToCSV
      // 
      this.btnSaveToCSV.Location = new System.Drawing.Point(510, 182);
      this.btnSaveToCSV.Name = "btnSaveToCSV";
      this.btnSaveToCSV.Size = new System.Drawing.Size(80, 21);
      this.btnSaveToCSV.TabIndex = 7;
      this.btnSaveToCSV.Text = "Save to CSV";
      this.btnSaveToCSV.UseVisualStyleBackColor = true;
      this.btnSaveToCSV.Click += new System.EventHandler(this.btnSaveToCSV_Click);
      // 
      // groupBox1
      // 
      this.groupBox1.Controls.Add(this.timeTo);
      this.groupBox1.Controls.Add(this.timeFrom);
      this.groupBox1.Controls.Add(this.dateTo);
      this.groupBox1.Controls.Add(this.label11);
      this.groupBox1.Controls.Add(this.label10);
      this.groupBox1.Controls.Add(this.dateFrom);
      this.groupBox1.Location = new System.Drawing.Point(22, 152);
      this.groupBox1.Name = "groupBox1";
      this.groupBox1.Size = new System.Drawing.Size(272, 89);
      this.groupBox1.TabIndex = 4;
      this.groupBox1.TabStop = false;
      this.groupBox1.Text = "Restore period";
      // 
      // timeTo
      // 
      this.timeTo.Format = System.Windows.Forms.DateTimePickerFormat.Time;
      this.timeTo.Location = new System.Drawing.Point(177, 54);
      this.timeTo.Name = "timeTo";
      this.timeTo.Size = new System.Drawing.Size(74, 20);
      this.timeTo.TabIndex = 3;
      this.timeTo.Value = new System.DateTime(2014, 1, 1, 0, 0, 0, 0);
      // 
      // timeFrom
      // 
      this.timeFrom.Format = System.Windows.Forms.DateTimePickerFormat.Time;
      this.timeFrom.Location = new System.Drawing.Point(177, 28);
      this.timeFrom.Name = "timeFrom";
      this.timeFrom.Size = new System.Drawing.Size(74, 20);
      this.timeFrom.TabIndex = 1;
      this.timeFrom.Value = new System.DateTime(2014, 1, 1, 0, 0, 0, 0);
      // 
      // dateTo
      // 
      this.dateTo.Location = new System.Drawing.Point(45, 54);
      this.dateTo.Name = "dateTo";
      this.dateTo.Size = new System.Drawing.Size(126, 20);
      this.dateTo.TabIndex = 2;
      this.dateTo.Value = new System.DateTime(2014, 1, 1, 0, 0, 0, 0);
      // 
      // label11
      // 
      this.label11.AutoSize = true;
      this.label11.Location = new System.Drawing.Point(8, 59);
      this.label11.Name = "label11";
      this.label11.Size = new System.Drawing.Size(18, 14);
      this.label11.TabIndex = 2;
      this.label11.Text = "To";
      // 
      // label10
      // 
      this.label10.AutoSize = true;
      this.label10.Location = new System.Drawing.Point(8, 33);
      this.label10.Name = "label10";
      this.label10.Size = new System.Drawing.Size(31, 14);
      this.label10.TabIndex = 1;
      this.label10.Text = "From";
      // 
      // dateFrom
      // 
      this.dateFrom.Location = new System.Drawing.Point(45, 28);
      this.dateFrom.Name = "dateFrom";
      this.dateFrom.Size = new System.Drawing.Size(126, 20);
      this.dateFrom.TabIndex = 0;
      this.dateFrom.Value = new System.DateTime(2014, 1, 1, 0, 0, 0, 0);
      // 
      // lblRestoreDept
      // 
      this.lblRestoreDept.AutoSize = true;
      this.lblRestoreDept.Location = new System.Drawing.Point(19, 117);
      this.lblRestoreDept.Name = "lblRestoreDept";
      this.lblRestoreDept.Size = new System.Drawing.Size(99, 14);
      this.lblRestoreDept.TabIndex = 7;
      this.lblRestoreDept.Text = "Default Department";
      // 
      // comboRestoreDepartment
      // 
      this.comboRestoreDepartment.FormattingEnabled = true;
      this.comboRestoreDepartment.Location = new System.Drawing.Point(124, 114);
      this.comboRestoreDepartment.Name = "comboRestoreDepartment";
      this.helpProvider.SetShowHelp(this.comboRestoreDepartment, false);
      this.comboRestoreDepartment.Size = new System.Drawing.Size(221, 22);
      this.comboRestoreDepartment.TabIndex = 3;
      this.comboRestoreDepartment.Tag = "15";
      this.comboRestoreDepartment.Click += new System.EventHandler(this.comboRestoreDepartment_Click);
      this.comboRestoreDepartment.HelpRequested += new System.Windows.Forms.HelpEventHandler(this.ConfigurationForm_HelpRequested);
      // 
      // comboRestoreCostCentre
      // 
      this.comboRestoreCostCentre.FormattingEnabled = true;
      this.comboRestoreCostCentre.Location = new System.Drawing.Point(124, 86);
      this.comboRestoreCostCentre.Name = "comboRestoreCostCentre";
      this.helpProvider.SetShowHelp(this.comboRestoreCostCentre, false);
      this.comboRestoreCostCentre.Size = new System.Drawing.Size(221, 22);
      this.comboRestoreCostCentre.TabIndex = 2;
      this.comboRestoreCostCentre.Tag = "14";
      this.comboRestoreCostCentre.Click += new System.EventHandler(this.comboRestoreCostCentre_Click);
      this.comboRestoreCostCentre.HelpRequested += new System.Windows.Forms.HelpEventHandler(this.ConfigurationForm_HelpRequested);
      // 
      // lblRestoreCC
      // 
      this.lblRestoreCC.AutoSize = true;
      this.lblRestoreCC.Location = new System.Drawing.Point(19, 89);
      this.lblRestoreCC.Name = "lblRestoreCC";
      this.lblRestoreCC.Size = new System.Drawing.Size(101, 14);
      this.lblRestoreCC.TabIndex = 4;
      this.lblRestoreCC.Text = "Default Cost Centre";
      // 
      // comboRestoreGLCode
      // 
      this.comboRestoreGLCode.FormattingEnabled = true;
      this.comboRestoreGLCode.Location = new System.Drawing.Point(124, 58);
      this.comboRestoreGLCode.Name = "comboRestoreGLCode";
      this.helpProvider.SetShowHelp(this.comboRestoreGLCode, false);
      this.comboRestoreGLCode.Size = new System.Drawing.Size(221, 22);
      this.comboRestoreGLCode.TabIndex = 1;
      this.comboRestoreGLCode.Tag = "13";
      this.comboRestoreGLCode.Click += new System.EventHandler(this.comboRestoreGLCode_Click);
      this.comboRestoreGLCode.HelpRequested += new System.Windows.Forms.HelpEventHandler(this.ConfigurationForm_HelpRequested);
      // 
      // label7
      // 
      this.label7.AutoSize = true;
      this.label7.Location = new System.Drawing.Point(19, 61);
      this.label7.Name = "label7";
      this.label7.Size = new System.Drawing.Size(86, 14);
      this.label7.TabIndex = 2;
      this.label7.Text = "Default GL Code";
      // 
      // comboRestoreMCM
      // 
      this.comboRestoreMCM.FormattingEnabled = true;
      this.helpProvider.SetHelpString(this.comboRestoreMCM, "");
      this.comboRestoreMCM.Location = new System.Drawing.Point(124, 15);
      this.comboRestoreMCM.Name = "comboRestoreMCM";
      this.helpProvider.SetShowHelp(this.comboRestoreMCM, false);
      this.comboRestoreMCM.Size = new System.Drawing.Size(281, 22);
      this.comboRestoreMCM.TabIndex = 0;
      this.comboRestoreMCM.Tag = "12";
      this.comboRestoreMCM.SelectedIndexChanged += new System.EventHandler(this.comboRestoreMCM_SelectedIndexChanged);
      this.comboRestoreMCM.Click += new System.EventHandler(this.comboRestoreMCM_Click);
      this.comboRestoreMCM.HelpRequested += new System.Windows.Forms.HelpEventHandler(this.ConfigurationForm_HelpRequested);
      // 
      // label6
      // 
      this.label6.AutoSize = true;
      this.label6.Location = new System.Drawing.Point(19, 18);
      this.label6.Name = "label6";
      this.label6.Size = new System.Drawing.Size(52, 14);
      this.label6.TabIndex = 0;
      this.label6.Text = "Company";
      // 
      // btnViewLog
      // 
      this.btnViewLog.Enabled = false;
      this.btnViewLog.Location = new System.Drawing.Point(424, 208);
      this.btnViewLog.Name = "btnViewLog";
      this.btnViewLog.Size = new System.Drawing.Size(80, 21);
      this.btnViewLog.TabIndex = 8;
      this.btnViewLog.Text = "View Log";
      this.btnViewLog.UseVisualStyleBackColor = true;
      this.btnViewLog.Click += new System.EventHandler(this.btnViewLog_Click);
      // 
      // tabConfig
      // 
      this.tabConfig.Controls.Add(this.plughLabel);
      this.tabConfig.Controls.Add(this.btnSaveConfig);
      this.tabConfig.Controls.Add(this.editConfig);
      this.tabConfig.Location = new System.Drawing.Point(4, 23);
      this.tabConfig.Name = "tabConfig";
      this.tabConfig.Size = new System.Drawing.Size(616, 382);
      this.tabConfig.TabIndex = 3;
      this.tabConfig.Text = "Config";
      this.tabConfig.UseVisualStyleBackColor = true;
      // 
      // plughLabel
      // 
      this.plughLabel.AutoSize = true;
      this.plughLabel.Font = new System.Drawing.Font("Arial", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.plughLabel.ForeColor = System.Drawing.Color.Red;
      this.plughLabel.Location = new System.Drawing.Point(111, 357);
      this.plughLabel.Name = "plughLabel";
      this.plughLabel.Size = new System.Drawing.Size(488, 14);
      this.plughLabel.TabIndex = 12;
      this.plughLabel.Text = "WARNING. CLICKING Save WILL OVERWRITE YOUR CONFIG FILE WITH THE ABOVE XML DATA";
      this.plughLabel.Visible = false;
      // 
      // btnSaveConfig
      // 
      this.btnSaveConfig.Location = new System.Drawing.Point(8, 353);
      this.btnSaveConfig.Name = "btnSaveConfig";
      this.btnSaveConfig.Size = new System.Drawing.Size(90, 23);
      this.btnSaveConfig.TabIndex = 11;
      this.btnSaveConfig.Text = "Save";
      this.btnSaveConfig.UseVisualStyleBackColor = true;
      this.btnSaveConfig.Visible = false;
      this.btnSaveConfig.Click += new System.EventHandler(this.btnSaveConfig_Click);
      // 
      // editConfig
      // 
      this.editConfig.Dock = System.Windows.Forms.DockStyle.Top;
      this.editConfig.Font = new System.Drawing.Font("Lucida Console", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.editConfig.Location = new System.Drawing.Point(0, 0);
      this.editConfig.Multiline = true;
      this.editConfig.Name = "editConfig";
      this.editConfig.ScrollBars = System.Windows.Forms.ScrollBars.Both;
      this.editConfig.Size = new System.Drawing.Size(616, 347);
      this.editConfig.TabIndex = 0;
      this.editConfig.WordWrap = false;
      this.editConfig.KeyUp += new System.Windows.Forms.KeyEventHandler(this.editConfig_KeyUp);
      // 
      // lblVersion
      // 
      this.lblVersion.AutoSize = true;
      this.lblVersion.Location = new System.Drawing.Point(12, 408);
      this.lblVersion.Name = "lblVersion";
      this.lblVersion.Size = new System.Drawing.Size(46, 14);
      this.lblVersion.TabIndex = 20;
      this.lblVersion.Text = "v0.0.0.0";
      // 
      // gLCodeListItemBindingSource
      // 
      this.gLCodeListItemBindingSource.DataSource = typeof(PaymentGatewayAddin.GLCodeListItem);
      // 
      // ConfigurationForm
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 14F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(624, 441);
      this.Controls.Add(this.lblVersion);
      this.Controls.Add(this.tabControl1);
      this.Controls.Add(this.btnOK);
      this.Controls.Add(this.btnApply);
      this.Controls.Add(this.btnCancel);
      this.Font = new System.Drawing.Font("Arial", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
      this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
      this.Name = "ConfigurationForm";
      this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
      this.Tag = "100";
      this.Text = "Credit Card Gateway Configuration";
      this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.ConfigurationForm_FormClosing);
      this.Load += new System.EventHandler(this.ConfigurationForm_Load);
      this.Shown += new System.EventHandler(this.ConfigurationForm_Shown);
      this.HelpRequested += new System.Windows.Forms.HelpEventHandler(this.ConfigurationForm_HelpRequested);
      ((System.ComponentModel.ISupportInitialize)(this.spinSourceUDF)).EndInit();
      ((System.ComponentModel.ISupportInitialize)(this.dgvConfiguration)).EndInit();
      this.tabControl1.ResumeLayout(false);
      this.tabCCGConfig.ResumeLayout(false);
      this.tabCCGConfig.PerformLayout();
      this.tabCurrencies.ResumeLayout(false);
      this.tabCurrencies.PerformLayout();
      ((System.ComponentModel.ISupportInitialize)(this.dgvCurrencies)).EndInit();
      this.tabRestore.ResumeLayout(false);
      this.tabRestore.PerformLayout();
      this.groupBox1.ResumeLayout(false);
      this.groupBox1.PerformLayout();
      this.tabConfig.ResumeLayout(false);
      this.tabConfig.PerformLayout();
      ((System.ComponentModel.ISupportInitialize)(this.gLCodeListItemBindingSource)).EndInit();
      this.ResumeLayout(false);
      this.PerformLayout();

      }

    #endregion

    private System.Windows.Forms.Label label1;
    private System.Windows.Forms.Label label2;
    private System.Windows.Forms.ComboBox comboMCMCompany;
    private System.Windows.Forms.Label label3;
    private System.Windows.Forms.TextBox textPassword;
    private System.Windows.Forms.Label label4;
    private System.Windows.Forms.NumericUpDown spinSourceUDF;
    private System.Windows.Forms.CheckBox chkEnableCCFuncs;
    private System.Windows.Forms.Button btnCancel;
    private System.Windows.Forms.Button btnApply;
    private System.Windows.Forms.DataGridView dgvConfiguration;
    private System.Windows.Forms.Button btnOK;
    private System.Windows.Forms.Button btnUpdateFromPP;
    private System.Windows.Forms.MaskedTextBox textSiteID;
    private System.Windows.Forms.TabControl tabControl1;
    private System.Windows.Forms.TabPage tabCCGConfig;
    private System.Windows.Forms.TabPage tabCurrencies;
    private System.Windows.Forms.Label label5;
    private System.Windows.Forms.DataGridView dgvCurrencies;
    private System.Windows.Forms.DataGridViewTextBoxColumn colExchCurrencyName;
    private System.Windows.Forms.DataGridViewTextBoxColumn colExchCurrencySymbol;
    private System.Windows.Forms.TabPage tabRestore;
    private System.Windows.Forms.Label lblRestoreDept;
    private System.Windows.Forms.ComboBox comboRestoreDepartment;
    private System.Windows.Forms.ComboBox comboRestoreCostCentre;
    private System.Windows.Forms.Label lblRestoreCC;
    private System.Windows.Forms.ComboBox comboRestoreGLCode;
    private System.Windows.Forms.Label label7;
    private System.Windows.Forms.ComboBox comboRestoreMCM;
    private System.Windows.Forms.Label label6;
    private System.Windows.Forms.GroupBox groupBox1;
    private System.Windows.Forms.DateTimePicker dateTo;
    private System.Windows.Forms.Label label11;
    private System.Windows.Forms.Label label10;
    private System.Windows.Forms.DateTimePicker dateFrom;
    private System.Windows.Forms.DateTimePicker timeTo;
    private System.Windows.Forms.DateTimePicker timeFrom;
    private System.Windows.Forms.Button btnRestore;
    private System.Windows.Forms.Button btnSaveToCSV;
    private System.Windows.Forms.Button btnRestoreHelp;
    private System.Windows.Forms.ProgressBar progressBar;
    private System.Windows.Forms.Button btnGetCredentials;
    private System.Windows.Forms.TextBox textSecurityCode;
    private System.Windows.Forms.Label label12;
    private System.Windows.Forms.SaveFileDialog saveCSVFileDialog;
    private System.Windows.Forms.Button btnViewCSV;
    private System.Windows.Forms.Button btnViewLog;
    private System.Windows.Forms.Label lblVersion;
    private System.Windows.Forms.TabPage tabConfig;
    private System.Windows.Forms.TextBox editConfig;
    private System.Windows.Forms.BindingSource gLCodeListItemBindingSource;
    private System.Windows.Forms.ToolTip toolTip;
    private System.Windows.Forms.CheckBox chkRestoreSORs;
    private System.Windows.Forms.Button btnSaveConfig;
    private System.Windows.Forms.Label plughLabel;
    private System.Windows.Forms.DataGridViewTextBoxColumn clPaymentProvider;
    private System.Windows.Forms.DataGridViewTextBoxColumn clMerchantID;
    private System.Windows.Forms.DataGridViewTextBoxColumn clSource;
    private System.Windows.Forms.DataGridViewComboBoxColumn clGLCode;
    private System.Windows.Forms.DataGridViewComboBoxColumn clCostCentre;
    private System.Windows.Forms.DataGridViewComboBoxColumn clDepartment;
    private System.Windows.Forms.DataGridViewTextBoxColumn clMerchantAccountId;
    private System.Windows.Forms.DataGridViewTextBoxColumn clMerchantAccountCode;
    private System.Windows.Forms.DataGridViewTextBoxColumn clPaymentProviderId;
    private System.Windows.Forms.Label lblRestoreComplete;
    private System.Windows.Forms.HelpProvider helpProvider;
    }
  }