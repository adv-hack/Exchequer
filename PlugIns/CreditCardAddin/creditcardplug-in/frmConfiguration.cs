using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using System.Xml;
using Enterprise04;
using Exchequer.Payments.Portal.COM.Client;
using Exchequer.Payments.Portal.COM.Client.PaymentServices;
using ExchequerPaymentGateway;

namespace PaymentGatewayAddin
  {
  public enum configStatus
    {
    csSuccess,
    csFailedToRead,
    csFailedToSave,
    csConfigEmpty
    }

  public enum historyActions
    {
    haSaveToCSV,
    haRestore
    }

  /// <summary>
  /// Configuration form for the Credit Card Gateway
  /// </summary>
  public partial class ConfigurationForm : Form
    {
    public SiteConfig config;
    private bool isSuperUser;

    private string plugh = string.Empty;

    public const string CURRENCY_NAME_COLUMN = "colExchCurrencyName";
    public const string CURRENCY_SYMBOL_COLUMN = "colExchCurrencySymbol";
    public const string CURRENCY_ISO_COLUMN = "colISOCurrency";

    public const string CONFIG_CC_COLUMN = "clCostCentre";
    public const string CONFIG_DEPT_COLUMN = "clDepartment";
    public const string CONFIG_SOURCE_COLUMN = "clSource";

    public const int DATA_HEADER_FIELDS = 14;
    public const int CUSTOM_DATA_HEADER_FIELDS = 7;
    public const int CUSTOM_DATA_LINE_FIELDS = 7;

    public IToolkit3 tToolkit = null;

    // Note: The Help button will be visible only if:
    //  1) helpFile has been set to a help filename (without a path)
    //  2) helpFile exists in the assembly directory
    //  3) HELP_CONTEXT_ID is not zero.
    private const int HELP_CONTEXT_CC_CONFIG = 9004;

    private string helpFile = "entrprse.chm";

    public enum sourceColumns : int
      {
      scPaymentProvider,
      scMerchantId,
      scSource,
      scGLCode,
      scCostCentre,
      scDepartment
      }

    private string currentCompanyCode;
    private int previouslySelectedCompany = -1;

    // ABSEXCH-15869. PKR. 28/11/2014. Validate GLCodes, Cost Centres and Departments
    private bool usingGLClasses = false;

    private bool usingCCDepts = false;

    private bool isInitialising = true;
    private bool isDirty = false;

    // This is assigned by the constructor - passed in by the PaymentGatewayPlugin.
    private GatewayCOMObject.GatewayCOMClass eppcc;

    private string csvFilename = string.Empty;
    private string csvPath = string.Empty;
    private Process csvApp = null;

    private string authTicket = string.Empty;

    private DataRestorer dataRestorer;
    private string userId;

    private string oldVal = string.Empty;

    public RestoreLog restoreLog;

    public DebugView dbgForm { get; set; }

    private bool canClose = false;

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Constructor
    /// </summary>
    /// <param name="aCurrentCompany"></param>
    public ConfigurationForm(IToolkit3 aToolkit, SiteConfig aConfig, string aCurrentCompany, GatewayCOMObject.GatewayCOMClass aPortal, string aUserID, bool aSuperUser = false)
      {
      InitializeComponent();

      tToolkit = aToolkit;
      config = aConfig;
      eppcc = aPortal;
      // PKR. 27/08/2015. ABSEXCH-16762.  MCM Company not being selected properly.
      currentCompanyCode = aCurrentCompany.Trim();

      lblVersion.Text = PaymentGateway.ExchequerVersion;

      userId = aUserID;

      isSuperUser = aSuperUser;

      SetConfiguration();

      editConfig.Text = PrintXML(config.configXML);

#if DEBUG
#else
      // This is used for debugging only, so in Release build, disconnect it from the parent
      tabConfig.Parent = null;
#endif

      if (!aSuperUser)
        {
        // Not logged in as System, so hide the Restore tab
        tabRestore.Parent = null;
        }
      else
        {
        // Logged in as System, so prepare the Restore tab
        // Set the start of the range to midnight last night.
        DateTime startDate = DateTime.Now;
        timeFrom.Format = DateTimePickerFormat.Custom;
        timeFrom.CustomFormat = "HH:mm";
        timeFrom.Value = new DateTime(startDate.Year, startDate.Month, startDate.Day, 0, 0, 0);
        timeFrom.ShowUpDown = true;
        dateFrom.Value = new DateTime(startDate.Year, startDate.Month, startDate.Day, 0, 0, 0);

        // Set the end of the range to midnight tonight.
        // PKR. 31/07/2015. ABSEXCH-16655. EndDate format was incorrect when run on last day of the month.
        DateTime endDate = DateTime.Now.AddDays(1);
        timeTo.Format = DateTimePickerFormat.Custom;
        timeTo.CustomFormat = "HH:mm";
        timeTo.Value = new DateTime(endDate.Year, endDate.Month, endDate.Day, 0, 0, 0);
        timeTo.ShowUpDown = true;
        dateTo.Value = new DateTime(endDate.Year, endDate.Month, endDate.Day, 0, 0, 0);

        // We don't want the user to be able to specify a date beyond midnight tonight
        dateTo.MaxDate = dateTo.Value;

        // Create the Data Restore object
        restoreLog = new RestoreLog();
        dataRestorer = new DataRestorer(tToolkit, config, userId, restoreLog);

        // PKR. 09/04/2015. ABSEXCH-16329. Indicate when the data restore is complete
        lblRestoreComplete.Visible = false;
        }

      // Help file.  Make the help button visible if we have assigned a help file and it exists.
      helpProvider.HelpNamespace = helpFile;
      Assembly assembly = Assembly.GetExecutingAssembly();
      string helpFilePath = Path.Combine(Path.GetDirectoryName(assembly.Location),
                              string.IsNullOrEmpty(helpProvider.HelpNamespace) ? string.Empty : helpProvider.HelpNamespace);
      btnRestoreHelp.Visible = (!string.IsNullOrEmpty(helpProvider.HelpNamespace)) &&
                               (File.Exists(helpFilePath)) &&
                               (HELP_CONTEXT_CC_CONFIG != 0);

      isInitialising = false;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Destructor
    /// </summary>
    ~ConfigurationForm()
      {
      // Release the DataRestorer object
      dataRestorer.Dispose();
      dataRestorer = null;

      if (csvApp != null)
        {
        if (!csvApp.HasExited)
          {
          csvApp.CloseMainWindow();
          }
        csvApp = null;
        }

      restoreLog = null;
      }

    //=============================================================================================
    public static String PrintXML(String XML)
      {
      String Result = "";

      MemoryStream mStream = new MemoryStream();
      XmlTextWriter writer = new XmlTextWriter(mStream, Encoding.Unicode);
      XmlDocument document = new XmlDocument();

      try
        {
        // Load the XmlDocument with the XML.
        document.LoadXml(XML);

        writer.Formatting = Formatting.Indented;

        // Write the XML into a formatting XmlTextWriter
        document.WriteContentTo(writer);
        writer.Flush();
        mStream.Flush();

        // Have to rewind the MemoryStream in order to read
        // its contents.
        mStream.Position = 0;

        // Read MemoryStream contents into a StreamReader.
        StreamReader sReader = new StreamReader(mStream);

        // Extract the text from the StreamReader.
        String FormattedXML = sReader.ReadToEnd();

        Result = FormattedXML;
        }
      catch (XmlException)
        {
        }

      mStream.Close();
      writer.Close();

      return Result;
      }

    //=============================================================================================
    /// <summary>
    /// Loads data from the configuration object into the fields on the form.
    /// </summary>
    public void SetConfiguration()
      {
      // Security code
      textSecurityCode.Text = config.securityCode;

      // Site ID and Password
      textSiteID.Text = config.siteIdentifier;
      textPassword.Text = config.password;

      // Load the combo box with companies, if there are any
      comboMCMCompany.Items.Clear();
      comboRestoreMCM.Items.Clear();

      int itemIndex;
      // PKR. 13/02/2015. ABSEXCH-16171. Populate lists with all MCM companies.
      // Populate the lists with all known MCM companies
      foreach (MCMCompany mcmCo in config.MCMCompanyList)
        {
        // ABSEXCH-15851. PKR. 25/11/2014.  Added company code to combo box entries.
        itemIndex = comboMCMCompany.Items.Add(new MCMComboBoxItem(mcmCo.name, mcmCo.code));
        // Add the data to the list on the Restore tab while we're at it.
        comboRestoreMCM.Items.Add(new MCMComboBoxItem(mcmCo.name, mcmCo.code));
        }

      // Set the default selected item in the combo box to the current company
      if (comboMCMCompany.Items.Count > 0)
        {
        if (!string.IsNullOrEmpty(currentCompanyCode))
          {
          for (int index = 0; index < comboMCMCompany.Items.Count; index++)
            {
            // ABSEXCH-15851. PKR. 25/11/2014.  Added company code to combo box entries.
            if ((comboMCMCompany.Items[index] as MCMComboBoxItem).companyCode == currentCompanyCode)
              {
              comboMCMCompany.SelectedIndex = index;
              comboRestoreMCM.SelectedIndex = index;
              break;
              }
            }
          }
        else
          {
          // PKR. 27/08/2015. ABSEXCH-16762. MCM Company not always being selected correctly.
          comboMCMCompany.SelectedIndex = 0;
          }
        }
      else
        {
        comboMCMCompany.SelectedIndex = -1;
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// returns the current configuration
    /// </summary>
    public SiteConfig GetConfiguration()
      {
      return config;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Event handler that fires when the form is loaded.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void ConfigurationForm_Load(object sender, EventArgs e)
      {
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Event handler that fires when the Save button is clicked.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void btnApply_Click(object sender, EventArgs e)
      {
      if (dataIsConsistent())
        {
        // Save the data in the form to the configuration object
        SaveCurrentDataToConfig();

        // Write the config to the file
        config.Save();

        // Disable this button as we don't need to use it again until further edits are made
        btnApply.Enabled = false;
        isDirty = false;
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Sets the "enabled" status of a cell in a DataGridView.  There is no native
    /// support for disabling a cell, hence the need for this method. The disabled state
    /// means that the cell is read-only and grayed out.
    /// </summary>
    /// <param name="dc">Cell to enable/disable</param>
    /// <param name="enabled">Whether the cell is enabled or disabled</param>
    private void enableCell(DataGridViewCell dc, bool enabled)
      {
      // Set the read-only state
      dc.ReadOnly = !enabled;
      if (enabled)
        {
        // Restore the cell style to the default value
        dc.Style.BackColor = dc.OwningColumn.DefaultCellStyle.BackColor;
        dc.Style.ForeColor = dc.OwningColumn.DefaultCellStyle.ForeColor;
        }
      else
        {
        // Grey out the cell
        dc.Style.BackColor = System.Drawing.SystemColors.Control;
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Prevents the user from selecting a cell in a disabled column.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void dgvConfiguration_CellStateChanged(object sender, DataGridViewCellStateChangedEventArgs e)
      {
      if (e.Cell == null || e.StateChanged != DataGridViewElementStates.Selected)
        {
        return;
        }

      // if Cell that changed state is to be selected you don't need to process
      // as event caused by 'unselectable' will select it again
      if (e.Cell.ColumnIndex > 1)
        {
        return;
        }

      // this condition is necessary if you want to reset your DataGridView
      if (!e.Cell.Selected)
        {
        return;
        }

      // Find the first available column that is enabled.
      int availCol = 0;
      while ((availCol < dgvConfiguration.ColumnCount) && (dgvConfiguration.Columns[availCol].ReadOnly))
        {
        availCol++;
        }

      // No selectable columns?
      if (availCol >= dgvConfiguration.ColumnCount)
        {
        return;
        }

      int col = e.Cell.ColumnIndex;
      if (dgvConfiguration.Columns[col].ReadOnly)
        {
        e.Cell.Selected = false;
        dgvConfiguration.Rows[e.Cell.RowIndex].Cells[availCol].Selected = true;
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Handles the event of the user selecting an item in the combo list
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void comboMCMCompany_SelectedIndexChanged(object sender, EventArgs e)
      {
      int index = comboMCMCompany.SelectedIndex;

      // Don't do anything if nothing has been selected.
      if (index >= 0)
        {
        // ABSEXCH-15851. PKR. 25/11/2014.  Added company code to combo box entries.
        MCMComboBoxItem selItem = comboMCMCompany.Items[index] as MCMComboBoxItem;

        // Check we have an object to work with
        if (selItem != null)
          {
          // ABSEXCH-15850. PKR. 25/11/2014. Toolkit errors when working with sub-companies.
          string datapath = "";

          // If the previous selection was different, and not -1, then save the current configuration
          if ((index != previouslySelectedCompany) && (previouslySelectedCompany != -1))
            {
            SaveCurrentDataToConfig();
            }

          // Look for the selected item in the configuration
          string selCompanyCode = selItem.companyCode;

          CompanyConfig selCompany = config.FindCompanyByCode(selCompanyCode);

          bool enabledInExchequer = false;
          MCMCompany selMCMCompany = null;

          if (selCompany != null)
            {
            // ABSEXCH-15850. PKR. 25/11/2014. Toolkit errors when working with sub-companies due to incorrect path.
            foreach (MCMCompany mcmCompany in config.MCMCompanyList)
              {
              if (mcmCompany.code.ToUpper().Trim() == selCompany.code.ToUpper().Trim())
                {
                datapath = mcmCompany.path; // This is used later
                selMCMCompany = mcmCompany;
                break;
                }
              }
            }

          if (selMCMCompany != null)
            {
            // If for some reason the SourceUDF field is out of range, we need to force it into range.
            spinSourceUDF.Enabled = true;
            if ((selCompany.sourceUDF <= spinSourceUDF.Maximum) && (selCompany.sourceUDF >= spinSourceUDF.Minimum))
              {
              spinSourceUDF.Value = selCompany.sourceUDF;
              }
            else
              {
              spinSourceUDF.Value = spinSourceUDF.Maximum;
              }

            previouslySelectedCompany = comboMCMCompany.SelectedIndex;

            if (tToolkit.Status == Enterprise04.TToolkitStatus.tkOpen)
              {
              tToolkit.CloseToolkit();
              }

            // ABSEXCH-15850. PKR. 25/11/2014. Toolkit errors when working with sub-companies, due to incorrect path.
            tToolkit.Configuration.DataDirectory = datapath;

            int tkRes = tToolkit.OpenToolkit();

            // ABSEXCH-15869. PKR. 28/11/2014. Validate GLCodes, Cost Centres and Departments
            //---------------------------------------------------------------------------------------
            // GL Codes
            usingGLClasses = (tToolkit.SystemSetup as Enterprise04.ISystemSetup5).ssEnforceGLClasses;

            //---------------------------------------------------------------------------------------
            // Cost Centres and Departments
            usingCCDepts = tToolkit.SystemSetup.ssUseCCDept;

            // Get GLCodes, Cost Centres and Departments.
            config.GetExchequerCompanySpecificData();

            // PKR. 04/03/2015. ABSEXCH-16213. Make the GLCode, CC and Department fields drop-down lists.
            // Populate the drop-down lists in the data grid
            clGLCode.Items.Clear();
            int itemIndex;
            foreach (GLCodeListItem glCode in config.GLCodes)
              {
              // Load the values into the combo box(es)
              itemIndex = clGLCode.Items.Add(glCode.ToString());
              }

            if (usingCCDepts)
              {
              clCostCentre.Items.Clear();
              foreach (CostCentreDeptListItem CC in config.CostCentres)
                {
                // Load the values into the combo box(es)
                clCostCentre.Items.Add(CC.ToString());
                }

              clDepartment.Items.Clear();
              foreach (CostCentreDeptListItem DP in config.Departments)
                {
                // Load the values into the combo box(es)
                clDepartment.Items.Add(DP.ToString());
                }
              }

            // Add the Source data
            dgvConfiguration.Rows.Clear();
            foreach (SourceConfig source in selCompany.sources)
              {
              int rowIndex = dgvConfiguration.Rows.Add();

              dgvConfiguration.Rows[rowIndex].Cells["clPaymentProvider"].Value = source.merchantAccount.PaymentProviderDescription;
              dgvConfiguration.Rows[rowIndex].Cells["clMerchantID"].Value = source.merchantAccount.MerchantAccountDescription;
              dgvConfiguration.Rows[rowIndex].Cells["clSource"].Value = source.name;

              // Locate the GL code in the combo box for this row
              DataGridViewComboBoxCell thisCombo = dgvConfiguration.Rows[rowIndex].Cells["clGLCode"] as DataGridViewComboBoxCell;

              string glComboVal;

              for (int cIndex = 0; cIndex < thisCombo.Items.Count; cIndex++)
                {
                glComboVal = thisCombo.Items[cIndex].ToString();
                if (glComboVal.StartsWith(source.glCode + " :"))
                  {
                  thisCombo.Value = glComboVal;
                  break;
                  }
                }

              if (usingCCDepts)
                {
                // Select the specified CC
                thisCombo = dgvConfiguration.Rows[rowIndex].Cells["clCostCentre"] as DataGridViewComboBoxCell;
                string ccComboVal;

                for (int cIndex = 0; cIndex < thisCombo.Items.Count; cIndex++)
                  {
                  ccComboVal = thisCombo.Items[cIndex].ToString();
                  if (ccComboVal.StartsWith(source.costCentre + " :"))
                    {
                    thisCombo.Value = ccComboVal;
                    break;
                    }
                  }

                // Select the specified Department
                thisCombo = dgvConfiguration.Rows[rowIndex].Cells["clDepartment"] as DataGridViewComboBoxCell;
                string dpComboVal;

                for (int cIndex = 0; cIndex < thisCombo.Items.Count; cIndex++)
                  {
                  dpComboVal = thisCombo.Items[cIndex].ToString();
                  if (dpComboVal.StartsWith(source.department + " :"))
                    {
                    thisCombo.Value = dpComboVal;
                    break;
                    }
                  }
                }

              enableCell(dgvConfiguration.Rows[rowIndex].Cells["clPaymentProvider"], false);
              enableCell(dgvConfiguration.Rows[rowIndex].Cells["clMerchantID"], false);

              // Add the hidden field values for reference, and to allow them to be saved
              dgvConfiguration.Rows[rowIndex].Cells["clMerchantAccountId"].Value = source.merchantAccount.MerchantAccountId;
              dgvConfiguration.Rows[rowIndex].Cells["clMerchantAccountCode"].Value = source.merchantAccount.MerchantAccountCode;
              dgvConfiguration.Rows[rowIndex].Cells["clPaymentProviderId"].Value = source.merchantAccount.PaymentProviderId;
              }

            // ABSEXCH-15860. PKR. 26/11/2014. Set availability of checkbox based on ciriteria.
            // Get Order Payments Enabled flag for the company from Exchequer.
            selMCMCompany.orderPaymentsIsEnabled = (tToolkit.SystemSetup as Enterprise04.ISystemSetup12).ssEnableOrderPayments;

            enabledInExchequer = selMCMCompany.orderPaymentsIsEnabled;

            // ABSEXCH-15860. PKR. 26/11/2014. Set availability of checkbox based on criteria.
            chkEnableCCFuncs.Enabled = (dgvConfiguration.RowCount > 0) &&
                                        (textPassword.Text != "") &&
                                        (enabledInExchequer);

            // ABSEXCH-15860. PKR. 27/11/2014. Uncheck the box if order payments is not enabled for this company.
            chkEnableCCFuncs.Checked = selCompany.enabled && chkEnableCCFuncs.Enabled;

            //.........................................................................................
            // 02/10/2014. PKR. Added Currency cross-reference table.
            // Make a list of ISO currencies
            ISO4217CurrencyList isoCurrencies = new ISO4217CurrencyList();

            //
            if (dgvCurrencies.ColumnCount < 3)
              {
              // Make a column for the grid that contains the currencies in combo boxes
              DataGridViewComboBoxColumn colISO = new DataGridViewComboBoxColumn();
              colISO.HeaderText = "ISO Currency";
              colISO.Name = CURRENCY_ISO_COLUMN;
              colISO.Width = 300;
              colISO.DisplayStyle = DataGridViewComboBoxDisplayStyle.ComboBox;

              foreach (ISO4217Currency currency in isoCurrencies.Currencies)
                {
                // Load the values into the combo box(es)
                colISO.Items.Add(currency.CountryName + " : " + currency.CurrencyName + " : " + currency.CurrencyCode);
                }

              // Add the column of combo boxes to the grid
              dgvCurrencies.Columns.Add(colISO);
              }

            int maxCurrencies = tToolkit.SystemSetup.ssMaxCurrency;

            // Now get the currencies from Exchequer
            string currName;
            string currSym;

            // Display the currency list
            dgvCurrencies.Rows.Clear();

            for (int currIndex = 0; currIndex < maxCurrencies; currIndex++)
              {
              currName = tToolkit.SystemSetup.ssCurrency[currIndex].scDesc;   // 11-char name

              // Add it to the table if it's not blank.
              // ABSEXCH-15859. PKR. 26/11/2014. Checking if the currency name received from Exchequer is non-null
              //  and then trimming whitespace from it, otherwise we can end up with blank rows in the currency table
              //  which raise an exception when an attempt is made to save them.
              if (!string.IsNullOrEmpty(currName))
                {
                currName = currName.Trim();
                if (!string.IsNullOrEmpty(currName))
                  {
                  currSym = tToolkit.SystemSetup.ssCurrency[currIndex].scSymbol;  // 3-char symbol (or actual symbol)
                  // A bit of jiggery-pokery to overcome Exchequer weirdness.  The £ symbol appears to be non-standard.
                  if (currSym == "œ")
                    currSym = "£";

                  int rowIndex = dgvCurrencies.Rows.Add();

                  dgvCurrencies.Rows[rowIndex].Cells[CURRENCY_NAME_COLUMN].Value = currName;
                  dgvCurrencies.Rows[rowIndex].Cells[CURRENCY_SYMBOL_COLUMN].Value = currSym;

                  // Look for it in the configuration to see if we've already defined it
                  // If we find it, we can select the correct entry in the combo box
                  foreach (CurrencyCodes currencyXref in selCompany.currencies)
                    {
                    if (currName == currencyXref.ExchequerName)
                      {
                      // Found it, so locate it in the combo box items
                      string isoCode = currencyXref.ISOCode;
                      string comboVal;
                      DataGridViewComboBoxCell thisCombo = dgvCurrencies.Rows[rowIndex].Cells[CURRENCY_ISO_COLUMN] as DataGridViewComboBoxCell;
                      if (!string.IsNullOrEmpty(isoCode))
                        {
                        for (int cIndex = 0; cIndex < thisCombo.Items.Count; cIndex++)
                          {
                          comboVal = thisCombo.Items[cIndex].ToString();
                          if (comboVal.EndsWith(isoCode))
                            {
                            // Found it
                            thisCombo.Value = comboVal;
                            break;
                            }
                          }
                        }
                      break;
                      }
                    }
                  }
                }
              }

            // Hide or Show the CC and Dept columns accordingly
            dgvConfiguration.Columns[CONFIG_CC_COLUMN].Visible = usingCCDepts;
            dgvConfiguration.Columns[CONFIG_DEPT_COLUMN].Visible = usingCCDepts;

            // PKR.19/02/2015. ABSEXCH-16192.  Removed call to CloseToolkit as it needs to be open
            // during the config editing process.  The toolkit is closed when the form closes.
            } // Not a null company
          } // if selItem not null
        else
          {
          // Selected item is null, so clear the checkbox and disable it
          chkEnableCCFuncs.Enabled = false;
          chkEnableCCFuncs.Checked = false;
          }
        } // A company has been selected
      else
        {
        // No company selected, so clear the checkbox and disable it
        chkEnableCCFuncs.Enabled = false;
        chkEnableCCFuncs.Checked = false;
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Saves the data in the form fields to the configuration object
    /// </summary>
    private void SaveCurrentDataToConfig()
      {
      // Save the current data to the configuration.  We only need to do this for the currently selected company.
      string currentCompanyCode = (comboMCMCompany.Items[previouslySelectedCompany] as MCMComboBoxItem).companyCode;

      CompanyConfig currentCompany = config.FindCompanyByCode(currentCompanyCode);

      // If we're displaying a security code, save it.
      if (!string.IsNullOrEmpty(textSecurityCode.Text))
        {
        config.securityCode = textSecurityCode.Text;
        }

      // If the user logged in under the System Password, it is possible that they also changed the Site ID and/or Password
      config.siteIdentifier = textSiteID.Text;
      config.password = textPassword.Text;

      // Get the data from the form fields
      // The Company name, Site ID and Password cannot be edited, so no need to update them.
      currentCompany.sourceUDF = Convert.ToInt32(spinSourceUDF.Value);
      currentCompany.enabled = chkEnableCCFuncs.Checked;

      // The PaymentProvider and MerchantID are not editable.  We have to find the right
      //  entry to update.
      foreach (SourceConfig source in currentCompany.sources)
        {
        foreach (DataGridViewRow gridRow in dgvConfiguration.Rows)
          {
          if ((gridRow.Cells["clPaymentProvider"].Value.ToString().Trim() == source.merchantAccount.PaymentProviderDescription) &&
              (gridRow.Cells["clMerchantID"].Value.ToString().Trim() == source.merchantAccount.MerchantAccountDescription))
            {
            source.merchantAccount.MerchantAccountId = Convert.ToInt64(gridRow.Cells["clMerchantAccountId"].Value);
            source.merchantAccount.MerchantAccountCode = gridRow.Cells["clMerchantAccountCode"].Value.ToString();
            source.merchantAccount.PaymentProviderId = Convert.ToInt64(gridRow.Cells["clPaymentProviderId"].Value);

            if (gridRow.Cells["clSource"].Value != null)
              {
              source.name = gridRow.Cells["clSource"].Value.ToString().Trim();
              }
            else
              source.name = "";

            // PKR. 04/03/2015. ABSEXCH-16213. Make the GLCode, CC and Department fields drop-down lists.
            if (gridRow.Cells["clGLCode"].Value != null)
              {
              string selGL = gridRow.Cells["clGLCode"].Value.ToString();
              int colonPOS = selGL.IndexOf(':');
              string selGLCode = selGL.Substring(0, colonPOS - 1);

              source.glCode = Convert.ToInt32(selGLCode);
              }
            else
              {
              source.glCode = 0;
              }

            //.....................................................................................
            if (dgvConfiguration.Columns["clCostCentre"].Visible)
              {
              if (gridRow.Cells["clCostCentre"].Value != null)
                {
                string selCC = gridRow.Cells["clCostCentre"].Value.ToString().Trim();
                int colonPos = selCC.IndexOf(':');
                string selCostCentre = selCC.Substring(0, colonPos - 1);

                source.costCentre = selCostCentre;
                }
              else
                {
                source.costCentre = "";
                }

              //.....................................................................................
              if (gridRow.Cells["clDepartment"].Value != null)
                {
                string selDP = gridRow.Cells["clDepartment"].Value.ToString().Trim();
                int colonPos = selDP.IndexOf(':');
                string selDepartment = selDP.Substring(0, colonPos - 1);

                source.department = selDepartment;
                }
              else
                {
                source.department = "";
                }
              }
            }
          }
        }

      // To avoid duplicate entries in the currency list, simply delete the list and rebuild it from the table
      currentCompany.currencies.Clear();

      // 03/10/2014. PKR. Add Currency list to configuration
      foreach (DataGridViewRow gridRow in dgvCurrencies.Rows)
        {
        if (!string.IsNullOrEmpty(gridRow.Cells[CURRENCY_NAME_COLUMN].Value.ToString()))
          {
          // Create a new currency object
          CurrencyCodes currCurrXref = new CurrencyCodes();

          // Fill in the Exchequer currency name
          currCurrXref.ExchequerName = gridRow.Cells[CURRENCY_NAME_COLUMN].Value.ToString();

          // Add the Exchequer currency symbol
          currCurrXref.ExchequerSymbol = gridRow.Cells[CURRENCY_SYMBOL_COLUMN].Value.ToString();

          // If we've specified an ISO currency symbol, then add that as well
          if (gridRow.Cells[CURRENCY_ISO_COLUMN].Value != null)
            {
            currCurrXref.ISOCode = gridRow.Cells[CURRENCY_ISO_COLUMN].Value.ToString();
            }
          else
            {
            // Entry in table is blank.
            currCurrXref.ISOCode = "";
            }

          // Add it to the configuration
          currentCompany.currencies.Add(currCurrXref);
          }
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Perform validation after editing a cell in the grid
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void dgvConfiguration_CellEndEdit(object sender, DataGridViewCellEventArgs e)
      {
      // If this was a user edit (i.e. not the table being initialised, then flag the data as having changed)
      /*
            if (!isInitialising)
              {
              dgvConfiguration.Rows[e.RowIndex].ErrorText = string.Empty;

              if (e.ColumnIndex > 2)
                {
                // This was a drop-down, so we have to handle them differently
                string newVal = dgvConfiguration.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString();
                if (newVal != oldVal)
                  {
                  isDirty = true;
                  btnApply.Enabled = true;
                  }
                }
              else
                {
                isDirty = true;
                btnApply.Enabled = true;
                }
              }
       */
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Handles the Show event of the form
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void ConfigurationForm_Shown(object sender, EventArgs e)
      {
      // NB. This will be called twice because we have to show it before setting its screen location
      // and then we have to hide it so that we can show it Modally.

      // If the SiteID or Password field are blank, or the user is logged in with the System Password
      //  then we can enable the Site ID and Password fields
      bool wantToEditCredentials = ((string.IsNullOrEmpty(config.siteIdentifier.Trim())) ||
                                    (string.IsNullOrEmpty(config.password.Trim())) ||
                                    (this.isSuperUser) ||
                                    (!this.config.isCredentialsVerified));

      textSecurityCode.Enabled = wantToEditCredentials;
      textSecurityCode.ReadOnly = !textSecurityCode.Enabled;
      textSecurityCode.TabStop = textSecurityCode.Enabled;

      btnGetCredentials.Enabled = textSecurityCode.Enabled;
      btnGetCredentials.TabStop = textSecurityCode.Enabled;

      textSiteID.Enabled = wantToEditCredentials && (string.IsNullOrEmpty(textSecurityCode.Text) && (!string.IsNullOrEmpty(textSiteID.Text)));
      textSiteID.ReadOnly = !textSiteID.Enabled;
      textSiteID.TabStop = textSiteID.Enabled;

      textPassword.Enabled = wantToEditCredentials && (string.IsNullOrEmpty(textSecurityCode.Text) && (!string.IsNullOrEmpty(textPassword.Text)));
      textPassword.ReadOnly = !textPassword.Enabled;
      textPassword.TabStop = textPassword.Enabled;

      // PKR. 27/08/2015. ABSEXCH-16762. Error updating merchant details.
      // Added test for at least one MCM company in the list.
      btnUpdateFromPP.Enabled = ((textSiteID.Text != string.Empty) &&
                                 (textPassword.Text != string.Empty) &&
                                 (comboMCMCompany.Items.Count > 0)
                                );
      }

    //---------------------------------------------------------------------------------------------
    private void btnOK_Click(object sender, EventArgs e)
      {
      btnApply_Click(sender, e);
      // Prevent closing with OK button if data is inconsistent.
      if (canClose)
        {
        Close();
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Handles a click on the Update button.  Attempts to retrieve config data from the Payment Portal.
    /// This has the side-effect of verifying the Payment Portal login credentials.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void btnUpdateFromPP_Click(object sender, EventArgs e)
      {
      // If the Payment Portal has been inactive for a while, it goes to sleep and can take some time
      // to connect.  So display the hourglass.
      Cursor.Current = Cursors.WaitCursor;

      if (comboMCMCompany.Items.Count > 0)
        {
        if (comboMCMCompany.SelectedIndex < 0)
          {
          comboMCMCompany.SelectedIndex = 0;
          }
        }
      else
        {
        // PKR. 27/08/2015. Error updating companies.
        // We should never get here because the Update button should be disabled if there are no MCM companies in the list.
        // Added for extra resilience.
        MessageBox.Show("System error.  No Companies found.");
        return;
        }

      int savedSelCompanyIndex = comboMCMCompany.SelectedIndex;

      // Ensure that the configuration data in the form is saved to the configuration object
      SaveCurrentDataToConfig();

      // Do we have some login credentials that appear to be of the right format?
      if ((SiteConfig.isValidSiteID(config.siteIdentifier)) && (SiteConfig.isValidPassword(config.password)))
        {
        // The credentials look valid (correct format at least)

        // Added under Graham Yorke's instruction to get it to connect to the Payment Portal.
        System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

        GatewayCOMObject.GatewayCOMClass.Credentials credentials = new GatewayCOMObject.GatewayCOMClass.Credentials();
        GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount[] companyMerchantAccsList = null;

        string errorMessage = string.Empty;

        // Send requests for Merchant ID details (one request per company)
        // PKR. 01/04/2015. ABSEXCH-16262. Reverse the loop so that we can delete entries without
        // the loop getting confused
        CompanyConfig company = null;
        for (int index = config.companies.Count - 1; index >= 0; index--)
          {
          company = config.companies[index];

          // Get an authTicket to allow us to update the config
          credentials.Company = company.code;
          credentials.SiteIdentifier = textSiteID.Text;
          credentials.Password = textPassword.Text;

          try
            {
            try
              {
              eppcc.Login(credentials, out authTicket);

              if (string.IsNullOrEmpty(authTicket))
                {
                MessageBox.Show("Could not log in to Exchequer Payments Portal");
                break;
                }
              else
                {
                // PKR. 02/01/2015. ABSEXCH-15982. Handle companies that are not set up in the Portal
                // Get the list of Merchant accounts for the current company

                // PKR. 06/02/2015. Change to interface.
                eppcc.GetCompanyMerchantAccounts(authTicket, company.code, out companyMerchantAccsList);

                Cursor.Current = Cursors.Default;

                if ((companyMerchantAccsList != null) && (companyMerchantAccsList.Length > 0))
                  {
                  // PKR. 06/02/2015.
                  string narrative = config.ApplyUpdates(company.code, companyMerchantAccsList);

                  // Update the display to reflect the changes.  Cunningly re-using the combo box changed event.
                  comboMCMCompany.SelectedIndex = savedSelCompanyIndex;
                  comboMCMCompany_SelectedIndexChanged(sender, e);

                  // We can now set the credentials as validated
                  config.isCredentialsVerified = true;

                  isDirty = true;
                  btnApply.Enabled = true;
                  }
                else
                  {
                  // Merchant Account list for this company is null or empty.
                  // PKR. 27/03/2015. ABSEXCH-16262. Companies deleted from the Payment Portal are not being deleted from the configuration.
                  config.companies.RemoveAt(index);
                  }
                }
              }
            finally
              {
              if (!string.IsNullOrEmpty(authTicket))
                {
                // No need to use TryLogout here as the Portal does not use the authTicket after the request.
                eppcc.Logout(authTicket);
                }
              }
            }
          catch (AggregateException aggEx)
            {
            Cursor.Current = Cursors.Default;
            String bigMessage = "The following errors occurred\r\n";

            for (int eIndex = 0; eIndex < aggEx.InnerExceptions.Count; eIndex++)
              {
              bigMessage += aggEx.InnerExceptions[eIndex].Message + "\r\n";
              }
            MessageBox.Show(bigMessage, "Error updating configuration");
            }
          catch (Exception ex)
            {
            Cursor.Current = Cursors.Default;
            if (ex != null)
              {
              if (!string.IsNullOrEmpty(ex.Message))
                {
                // If the message is The user details specified are not valid, it probably means that this company
                //  is not registered in the Portal, so don't report anything.
                if (!ex.Message.ToLower().Contains("the user details specified are not valid"))
                  {
                  var messageText = ex.Message;
                  messageText = messageText.Replace("One or more errors occurred. : ", string.Empty);
                  // Accumulate the error messages into one because it's really tedious clicking OK for every company
                  // that isn't set up for credit cards.
                  errorMessage += string.Format("No Merchant Account details received for company {0}\r\n{1}\r\n\r\n",
                                                credentials.Company, messageText);
                  }
                }
              }
            }
          }
        if (errorMessage != string.Empty)
          {
          MessageBox.Show(errorMessage, "Error retrieving Merchant Accounts");
          }
        }
      else
        {
        // Invalid credentials
        MessageBox.Show("Invalid Login Credentials");
        // Set config verified flag to false
        config.isCredentialsVerified = false;
        textSiteID.Enabled = true;
        textSiteID.ReadOnly = false;
        textPassword.Enabled = true;
        textPassword.ReadOnly = false;
        }
      Cursor.Current = Cursors.Default;
      }

    //---------------------------------------------------------------------------------------------
    private void spinSourceUDF_ValueChanged(object sender, EventArgs e)
      {
      if (!isInitialising)
        {
        isDirty = true;
        btnApply.Enabled = true;
        }
      }

    //---------------------------------------------------------------------------------------------
    private void chkEnableCCFuncs_CheckStateChanged(object sender, EventArgs e)
      {
      if (!isInitialising)
        {
        isDirty = true;
        btnApply.Enabled = true;
        }
      }

    //---------------------------------------------------------------------------------------------
    private void textSiteID_Leave(object sender, EventArgs e)
      {
      if (!btnCancel.Focused)
        {
        if (!SiteConfig.isValidSiteID(textSiteID.Text))
          {
          MessageBox.Show("Invalid Site ID");
          textSiteID.Focus();
          }
        else
          {
          if (!isInitialising)
            {
            isDirty = true;
            btnApply.Enabled = true;
            }
          }
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Handles focus/lose focus events on cells.  Used to make readonly cells non-selectable
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void dgvCurrencies_CellStateChanged(object sender, DataGridViewCellStateChangedEventArgs e)
      {
      // Null cell or no significant event?
      if (e.Cell == null || e.StateChanged != DataGridViewElementStates.Selected)
        {
        return;
        }

      // if Cell that changed state is to be selected you don't need to process
      // as event caused by 'unselectable' will select it again
      if (e.Cell.ColumnIndex > 1)
        {
        return;
        }

      // this condition is necessary if you want to reset your DataGridView
      if (!e.Cell.Selected)
        {
        return;
        }

      // Find the first available column that is enabled.
      int availCol = 0;
      while ((availCol < dgvCurrencies.ColumnCount) && (dgvCurrencies.Columns[availCol].ReadOnly))
        {
        availCol++;
        }

      // No selectable columns?
      if (availCol >= dgvCurrencies.ColumnCount)
        {
        return;
        }

      int col = e.Cell.ColumnIndex;
      if (dgvCurrencies.Columns[col].ReadOnly)
        {
        e.Cell.Selected = false;
        dgvCurrencies.Rows[e.Cell.RowIndex].Cells[availCol].Selected = true;
        }
      }

    //---------------------------------------------------------------------------------------------
    private void ConfigurationForm_FormClosing(object sender, FormClosingEventArgs e)
      {
      if (isDirty)
        {
        DialogResult dlgRes = MessageBox.Show("Configuration has changed. Save before closing?", "Confirm Cancel", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Question);
        switch (dlgRes)
          {
          case System.Windows.Forms.DialogResult.Yes:
            // Want to save, so save it
            btnApply_Click(sender, e);
            e.Cancel = false; // Allow the form to close
            break;

          case System.Windows.Forms.DialogResult.No:
            e.Cancel = false; // Allow the form to close
            break;

          case System.Windows.Forms.DialogResult.Cancel:
            e.Cancel = true; // Don't allow the form to close
            break;
          }
        }
      else
        {
        // Allow the form to close
        e.Cancel = false;
        }

      // If we're closing the form
      if (!e.Cancel)
        {
        // Close the toolkit if it's open.
        if (tToolkit.Status == Enterprise04.TToolkitStatus.tkOpen)
          {
          tToolkit.CloseToolkit();
          }

        // Reconnect the hidden pages to the tabControl so that they get destroyed.
        if (tabRestore.Parent == null)
          {
          tabRestore.Parent = tabControl1;
          }
        if (tabConfig.Parent == null)
          {
          tabConfig.Parent = tabControl1;
          }
        }
      }

    //---------------------------------------------------------------------------------------------
    private void dgvCurrencies_CellValueChanged(object sender, DataGridViewCellEventArgs e)
      {
      if (!isInitialising)
        {
        isDirty = true;
        btnApply.Enabled = true;
        }
      }

    private void textSiteID_TextChanged(object sender, EventArgs e)
      {
      if (!isInitialising)
        {
        isDirty = true;
        btnApply.Enabled = true;
        }
      }

    private void textPassword_TextChanged(object sender, EventArgs e)
      {
      if (!isInitialising)
        {
        isDirty = true;
        btnApply.Enabled = true;
        }
      }

    private void btnCancel_Click(object sender, EventArgs e)
      {
      }

    private void dgvCurrencies_CellEndEdit(object sender, DataGridViewCellEventArgs e)
      {
      if (!isInitialising)
        {
        isDirty = true;
        btnApply.Enabled = true;
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Checks the configuration data to ensure that is consistent.
    /// </summary>
    /// <returns></returns>
    private bool dataIsConsistent()
      {
      bool Result = true;
      int index = 0;
      // PKR. 02/03/2015. ABSEXCH-161216. If any one of GLCode, Cost Centre or Department are
      //  set in a line, then all of them must be set.
      string GL, CC, DP;

      int nRows = dgvConfiguration.RowCount;

      // PKR. 02/03/2015. ABSEXCH-16216. If any one of GLCode, Cost Centre or Department are
      //  set in a line, then all of them must be set.
      if ((nRows > 0) && (usingCCDepts))
        {
        foreach (DataGridViewRow gridRow in dgvConfiguration.Rows)
          {
          int numFieldsSet = 0;
          GL = (gridRow.Cells["clGLCode"].Value == null ? "" : gridRow.Cells["clGLCode"].Value.ToString().Trim());
          CC = (gridRow.Cells["clCostCentre"].Value == null ? "" : gridRow.Cells["clCostCentre"].Value.ToString().Trim());
          DP = (gridRow.Cells["clDepartment"].Value == null ? "" : gridRow.Cells["clDepartment"].Value.ToString().Trim());
          if (!string.IsNullOrEmpty(GL)) numFieldsSet++;
          if (!string.IsNullOrEmpty(CC)) numFieldsSet++;
          if (!string.IsNullOrEmpty(DP)) numFieldsSet++;
          if ((numFieldsSet != 3) && (numFieldsSet != 0))
            {
            Result = false;
            }
          }
        }

      if (!Result)
        {
        // One of the sources has an invalid combination of GL Code, Cost Centre and Department
        MessageBox.Show("Sources must have ALL or NONE of GL Code, Cost Centre and Department set.");
        dgvConfiguration.Focus();
        }
      else
        {
        // ABSEXCH-15858. PKR. 26/11/2014. Validation required to ensure that the same Source
        //  name is not used for more than one combination of Merchant ID and Payment Provider.
        // Passed that test.  Now scan for duplicates.
        // Obviously we only need to do this test if there is more than 1 row.
        if (nRows > 1)
          {
          bool duplicateSources = false;
          string[] sources = new string[dgvConfiguration.RowCount];

          // Build a list of Source names converted to upper case because they are not case-sensitive.
          foreach (DataGridViewRow gridRow in dgvConfiguration.Rows)
            {
            sources[index] = (gridRow.Cells["clSource"].Value == null ? "" : gridRow.Cells["clSource"].Value.ToString().Trim().ToUpper());
            index++;
            }

          // Now see if there are any duplicates in the list (including blanks)
          for (int key1 = 0; key1 < sources.Count() - 1; key1++)
            {
            for (int key2 = (key1 + 1); key2 < sources.Count(); key2++)
              {
              // Check duplicate source names (including blank)
              if (sources[key2] == sources[key1])
                {
                duplicateSources = true;
                Result = false;
                break; // Break out of the inner loop
                }
              }
            if (!Result)
              {
              break; // Break out of the outer loop
              }
            }

          if (duplicateSources)
            {
            MessageBox.Show("Source names (including blanks) may not be used more than once.");
            dgvConfiguration.Focus();
            }
          } // if at least two rows
        } // Passed first test

      canClose = Result;
      return Result;
      }

    //===============================================================================================
    // ABSEXCH-15851. PKR. 25/11/2014.  Add company code to the MCM Combo box items.
    /// <summary>
    /// Class to attach to the MCM Company combo box items.
    /// </summary>
    public class MCMComboBoxItem
      {
      public string companyName;
      public string companyCode;

      public MCMComboBoxItem(string coName, string coCode)
        {
        companyName = coName;
        companyCode = coCode;
        }

      /// <summary>
      /// Provides the Text for the combo box item
      /// </summary>
      /// <returns></returns>
      public override string ToString()
        {
        return string.Format("{0} : {1}", companyCode, companyName);
        }
      }

    /// <summary>
    /// Validates Cost Centres and Departments
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void dgvConfiguration_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
      {
      // PKR. 25/02/2015. ABSEXCH-16214.  Set CausesValidation property on the Cancel button to false.
      // This prevents this event from firing.  (Not a code change. This is just a record of the property change and JIRA)

      if (!isInitialising)
        {
        // ABSEXCH-15869. PKR. 01/12/2014.  Moved to here for improved validation.
        bool isValid = true;

        // Convert entered value to upper case for comparison purposes.
        string testVal = e.FormattedValue.ToString().ToUpper();

        //-------------------------------------------------------------------------------------------
        // Do some selected validation on the fields

        // Source field.
        if (e.ColumnIndex == Convert.ToInt32(sourceColumns.scSource))
          {
          if (testVal != null)
            {
            // ABSEXCH-15858. PKR. 28/11/2014. Validate Source Names
            // Must be unique, so see if it's already been used.
            if (dgvConfiguration.RowCount > 1)
              {
              foreach (DataGridViewRow gridRow in dgvConfiguration.Rows)
                {
                string compVal;
                if (gridRow.Cells[CONFIG_SOURCE_COLUMN].Value == null)
                  {
                  compVal = "";
                  }
                else
                  {
                  compVal = gridRow.Cells[CONFIG_SOURCE_COLUMN].Value.ToString().ToUpper();
                  }

                if ((compVal == testVal) &&
                    (gridRow.Index != e.RowIndex))
                  {
                  isValid = false;
                  }
                }
              }

            if (!isValid)
              {
              MessageBox.Show("Source Names must be unique");
              // If we cancel then we can't temporarily have 2 the same (eg blank) while changing them.
              //              e.Cancel = true;
              }
            }
          return;
          }

        // PKR. 04/03/2015. ABSEXCH-16213. Make the GLCode, CC and Department fields drop-down lists.
        // Values of GL Codes, Cost Centres and Departments selected from drop-down lists,
        // so no further validation required.
        }
      }

    /// <summary>
    /// Uses a security code to obtain Site credentials from the payments Portal
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void btnGetCredentials_Click(object sender, EventArgs e)
      {
      if (string.IsNullOrEmpty(textSecurityCode.Text.Trim()))
        {
        // No security code specified, so tell the user
        MessageBox.Show("Please enter your Security Code and try again");
        }
      else
        {
        // If the Payment Portal has been inactive for a while, it goes to sleep and can take some time
        // to connect.  So display the hourglass.
        Cursor.Current = Cursors.WaitCursor;

        // Added under Graham Yorke's instruction to get it to connect to the Payment Portal.
        System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

        string receivedSiteId = string.Empty;
        string receivedPassword = string.Empty;

        try
          {
          GatewayCOMObject.GatewayCOMClass.SecurityCode securityCodeResponse;
          eppcc.GetSecurityDetails(textSecurityCode.Text.Trim(), out securityCodeResponse);

          if (securityCodeResponse != null)
            {
            if (string.IsNullOrEmpty(securityCodeResponse.SiteIdentifier) || string.IsNullOrEmpty(securityCodeResponse.Password))
              {
              MessageBox.Show("Site Credentials not found. Did you enter the correct security code?");
              }
            else
              {
              textSiteID.Text = securityCodeResponse.SiteIdentifier;
              textPassword.Text = securityCodeResponse.Password;

              btnUpdateFromPP.Enabled = true;
              comboMCMCompany.Enabled = true;

              isDirty = true;
              btnApply.Enabled = true;
              }
            }
          else
            {
            MessageBox.Show("Site Credentials not found. Did you enter the correct security code?");
            }
          }
        catch (Exception ex)
          {
          MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
          }
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Handles a click on the Restore button.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void btnRestore_Click(object sender, EventArgs e)
      {
      // PKR. 09/04/2015. ABSEXCH-16329. Indicate when the data restore is complete
      lblRestoreComplete.Visible = false;
      try
        {
        // Start a new error log
        restoreLog.Open(config.GetInstallationDir());

        int Res = ProcessTransactionHistory(historyActions.haRestore);

        restoreLog.Close();

        // PKR. 09/04/2015. ABSEXCH-16329. Indicate when the data restore is complete
        if (Res == SUCCESS)
          {
          lblRestoreComplete.Visible = true;
          }
        }
      finally
        {
        if (tToolkit.Status == TToolkitStatus.tkOpen)
          {
          tToolkit.CloseToolkit();
          }

        // PKR. 22/09/2015. ABSEXCH-16655
        // If an error or warning was logged, display the restore log.
        if (restoreLog.LogContainsErrors)
          {
          btnViewLog_Click(sender, e);
          }
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Handles selection of a different tab.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
      {
      // Disable the Apply and OK buttons if the user has chosen the Restore flag.
      btnApply.Enabled = (tabControl1.SelectedTab != tabRestore) && (isDirty);
      btnOK.Enabled = (tabControl1.SelectedTab != tabRestore);
      }

    //=============================================================================================
    /// <summary>
    /// Handle a click on the Save to CSV button
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void btnSaveToCSV_Click(object sender, EventArgs e)
      {
      // PKR. 09/04/2015. ABSEXCH-16329. Indicate when the data restore is complete
      progressBar.Visible = false;
      lblRestoreComplete.Visible = false;

      // Start a new error log
      restoreLog.Open(tToolkit.Configuration.DataDirectory);

      ProcessTransactionHistory(historyActions.haSaveToCSV);

      restoreLog.Close();
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Returns the supplied string surrounded by quotation marks.
    /// </summary>
    /// <param name="aString"></param>
    /// <returns></returns>
    private string QuotedString(string aString)
      {
      return "\"" + aString + "\"";
      }

    //---------------------------------------------------------------------------------------------
    public const int SUCCESS = 0;

    public const int INVALID_DATE_RANGE = 1;
    public const int NO_TRANSACTIONS_FIT_CRITERIA = 2;
    public const int PORTAL_SERVICE_UNAVAILABLE = 3;
    public const int PORTAL_ERROR = 4;
    public const int INVALID_ACTION = 5;
    public const int DEFAULTS_NOT_SET = 6;

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Processes the credit card transaction history, applying the specified action
    /// </summary>
    /// <param name="action"></param>
    private int ProcessTransactionHistory(historyActions action)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      int Result = SUCCESS;

      List<string> csvData = null;
      string csvFilename = string.Empty;
      bool rangeIsValid = false;

      // Filter data
      MCMComboBoxItem company = comboRestoreMCM.SelectedItem as MCMComboBoxItem;

      int GLCodeFilterIndex = comboRestoreGLCode.SelectedIndex;
      int CCFilterIndex = comboRestoreCostCentre.SelectedIndex;
      int DeptFilterIndex = comboRestoreDepartment.SelectedIndex;

      if (action == historyActions.haRestore)
        {
        if ((comboRestoreGLCode.Text == string.Empty) && (action == historyActions.haRestore))
          {
          MessageBox.Show("Please specify a default GL Code");
          return DEFAULTS_NOT_SET;
          }

        if ((comboRestoreCostCentre.Visible) && (comboRestoreCostCentre.Text == string.Empty) && (action == historyActions.haRestore))
          {
          MessageBox.Show("Please specify a default Cost Centre");
          return DEFAULTS_NOT_SET;
          }

        if ((comboRestoreDepartment.Visible) && (comboRestoreDepartment.Text == string.Empty) && (action == historyActions.haRestore))
          {
          MessageBox.Show("Please specify a default Department");
          return DEFAULTS_NOT_SET;
          }

        // Extract the actual GL Code from the field
        string[] exploder = comboRestoreGLCode.Text.Split(' ');
        string GLCode = exploder[0];
        if (GLCode == string.Empty)
          {
          GLCode = "0";
          }
        dataRestorer.SetDefaults(Convert.ToInt32(GLCode), comboRestoreCostCentre.Text, comboRestoreDepartment.Text);
        dataRestorer.SetCompanyCode(company.companyCode);
        }

      int currentPage = 1;
      int rowsProcessed = 0;

      // Validate the range selection
      DateTime startDate = dateFrom.Value.Date + timeFrom.Value.TimeOfDay;
      DateTime endDate = dateTo.Value.Date + timeTo.Value.TimeOfDay;
      rangeIsValid = ValidateDateRange(startDate, endDate);

      string msg = string.Format("Restoring card transactions between {0} and {1}", startDate, endDate);
      restoreLog.Log(RestoreLog.severities.sevInfo, msg);

      // if range is valid
      if (rangeIsValid)
        {
        Cursor.Current = Cursors.WaitCursor;

        // Process the data

        // Added under Graham Yorke's instruction to get it to connect to the Payment Portal.
        System.Net.WebRequest.DefaultWebProxy.Credentials = System.Net.CredentialCache.DefaultNetworkCredentials;

        GatewayCOMObject.GatewayCOMClass.Credentials credentials = new GatewayCOMObject.GatewayCOMClass.Credentials();
        credentials.Company = company.companyCode;
        credentials.SiteIdentifier = textSiteID.Text;
        credentials.Password = textPassword.Text;

        // Create a transaction list to receive the data
        GatewayCOMObject.GatewayCOMClass.PagedTransactionResponse transList = null;

        bool haveDelayed = false;

        // Get the first block of data
        try
          {
          // Get an authTicket
          eppcc.Login(credentials, out authTicket);

          try
            {
            // PKR. 06/02/2015. Change to interface.
            eppcc.GetProcessedTransactionsByDateRange(authTicket, startDate, endDate, currentPage, out transList);

            // Get total number of pages
            int numberOfPages = transList.TotalPageCount;
            // Get total number of records
            int numberOfRows = transList.TotalRowCount;

            // Make sure we have something to process
            if (numberOfRows > 0)
              {
              // Show the progress bar.
              progressBar.Maximum = numberOfRows;
              progressBar.Value = 0;
              progressBar.Visible = true;

              // If the action is Save To CSV, we need to prepare data structures for it
              if (action == historyActions.haSaveToCSV)
                {
                // Create a list of strings to contain the CSV data
                csvData = new List<string>();

                // Generate filename with timestamp
                csvFilename = string.Format("CCData_{0:yyyyMMdd_HHmmss}.csv", DateTime.Now);

                // Emit a header for the CSV columns
                CSVEmitHeadings(ref csvData);
                }

              // While we have data to process
              while (currentPage <= numberOfPages)
                {
                // Process each line in the page
                foreach (GatewayTransactionView transItem in transList.Transactions)
                  {
                  // Process it
                  switch (action)
                    {
                    //...........................................................................
                    case historyActions.haSaveToCSV:
                      // Write record to CSV stringlist
                      CSVEmitDataRecord(ref csvData, credentials, transItem);

                      // Process the CustomData field (if it's not blank), which will be XML containing Transaction Line data
                      if (!string.IsNullOrEmpty(transItem.CustomData))
                        {
                        int cdataRowCount = ParseCustomDataToCSV(ref csvData, transItem.CustomData);
                        }
                      break;

                    //...........................................................................
                    case historyActions.haRestore:
                      // Send restore request to Exchequer
#if DEBUG
                      dbgForm.Log("Calling RestoreTransaction");
#endif
                      int Res = dataRestorer.RestoreTransaction(transItem, chkRestoreSORs.Checked);

                      // This delay after the first iteration of the loop seems to fix an unhandled
                      // exception in the emulator with FinancialMatching.dat
                      if (!haveDelayed)
                        {
                        Thread.Sleep(4000);
                        haveDelayed = true;
                        }

#if DEBUG
                      switch (Res)
                        {
                        case DataRestorer.SUCCESS:
                          dbgForm.Log("RestoreTransaction: Success");
                          restoreLog.Log(RestoreLog.severities.sevDebug, "RestoreTransaction: Success");
                          break;

                        case DataRestorer.WARNING_RECEIPT_ALREADY_EXISTS:
                          dbgForm.Log("RestoreTransaction: Receipt already exists");
                          restoreLog.Log(RestoreLog.severities.sevDebug, "RestoreTransaction: Receipt already exists");
                          break;

                        case DataRestorer.WARNING_TRANSACTION_REF_DOES_NOT_EXIST:
                          dbgForm.Log("RestoreTransaction: Transaction Reference doesn't exist");
                          restoreLog.Log(RestoreLog.severities.sevDebug, "RestoreTransaction: Transaction Reference doesn't exist");
                          break;

                        case DataRestorer.WARNING_TRANSACTION_DERIVES_FROM_DIFFERENT_ORDER:
                          dbgForm.Log("RestoreTransaction: Transaction derives from a different order");
                          restoreLog.Log(RestoreLog.severities.sevDebug, "RestoreTransaction: Transaction derives from a different order");
                          break;

                        case DataRestorer.ERROR_CURRENCY_MISMATCH:
                          dbgForm.Log("RestoreTransaction: Currency mismatch");
                          restoreLog.Log(RestoreLog.severities.sevDebug, "RestoreTransaction: Currency mismatch");
                          break;

                        case DataRestorer.ERROR_LINE_DETAIL_MISMATCH:
                          dbgForm.Log("RestoreTransaction: Line detail mismatch");
                          restoreLog.Log(RestoreLog.severities.sevDebug, "RestoreTransaction: Line detail mismatch");
                          break;

                        case DataRestorer.ERROR_PAYMENT_EXCEEDS_ORDER_VALUE:
                          dbgForm.Log("RestoreTransaction: Payment exceeds order value");
                          restoreLog.Log(RestoreLog.severities.sevDebug, "RestoreTransaction: Payment exceeds order value");
                          break;

                        case DataRestorer.ERROR_INVALID_ACCOUNT_CODE:
                          dbgForm.Log("RestoreTransaction: Invalid account code");
                          restoreLog.Log(RestoreLog.severities.sevDebug, "RestoreTransaction: Invalid account code");
                          break;

                        case DataRestorer.ERROR_ACCOUNT_CODE_MISMATCH:
                          dbgForm.Log("RestoreTransaction: Account code mismatch");
                          restoreLog.Log(RestoreLog.severities.sevDebug, "RestoreTransaction: Account code mismatch");
                          break;

                        case DataRestorer.ERROR_PAYMENT_IS_NOT_FOR_SPECIFIED_ORDER:
                          dbgForm.Log("RestoreTransaction: Payment is not for the specified order");
                          restoreLog.Log(RestoreLog.severities.sevDebug, "RestoreTransaction: Payment is not for the specified order");
                          break;

                        case DataRestorer.ERROR_TRANSACTION_LINE_NOT_FOUND:
                          dbgForm.Log("RestoreTransaction: Transaction line not found");
                          restoreLog.Log(RestoreLog.severities.sevDebug, "RestoreTransaction: Transaction line not found");
                          break;
                        }
#endif
                      break;
                    }

                  rowsProcessed++;
                  // Update progress bar
                  progressBar.PerformStep();
                  progressBar.Refresh();
                  Application.DoEvents();
                  } // foreach record

                // Get next block of data
                currentPage++;
                if (currentPage <= numberOfPages)
                  {
                  // PKR. 06/02/2015. Change to interface.
                  eppcc.GetProcessedTransactionsByDateRange(authTicket, startDate, endDate, currentPage, out transList);
                  }
                } // end while

              // Make sure the progress bar shows completion
              progressBar.Refresh();
              Application.DoEvents();

              if (rowsProcessed > 0)
                {
                //.................................................................................

                // If we're saving to CSV, save the data to the file
                if (action == historyActions.haSaveToCSV)
                  {
                  // Save the CSV file (save dialog)
                  saveCSVFileDialog.FileName = csvFilename;
                  DialogResult dlgRes = saveCSVFileDialog.ShowDialog();
                  if (dlgRes == System.Windows.Forms.DialogResult.OK)
                    {
                    // Get the chosen path
                    csvPath = saveCSVFileDialog.FileName;

                    // Save the data
                    File.WriteAllLines(csvPath, csvData.ToArray());

                    // Enable Display CSV button
                    btnViewCSV.Enabled = true;
                    }
                  }
                }
              else
                {
                MessageBox.Show("No card transactions that meet the selection criteria\r\nwere received from the Payment Portal");
                progressBar.Visible = false;
                Result = NO_TRANSACTIONS_FIT_CRITERIA;
                restoreLog.Log(0, "No transactions meet the selection criteria");
                }
              }
            else
              {
              MessageBox.Show("No card transactions within the specified time range\r\nwere received from the Payment Portal");
              Result = NO_TRANSACTIONS_FIT_CRITERIA;
              restoreLog.Log(0, "No transactions meet the selection criteria");
              }
            } // try
          catch (Exception ex)
            {
            var messageText = ex.Message;
            if (ex.InnerException != null)
              {
              if (!string.IsNullOrEmpty(ex.InnerException.Message))
                {
                messageText = string.Format("{0} : {1}", messageText, ex.InnerException.Message);
                }
              }
            messageText = messageText.Replace("One or more errors occurred. : ", string.Empty);
            MessageBox.Show(string.Format("An error was detected when attempting to retrieve a list of transactions...\r\n\r\n{0}", messageText), "Error Sending Request");
            Result = PORTAL_ERROR;
            restoreLog.Log(RestoreLog.severities.sevError, "An error occurred retrieving the transaction history");
            restoreLog.Log(RestoreLog.severities.sevError, messageText);
            }
          }
        finally
          {
          progressBar.Value = progressBar.Maximum;
          btnViewLog.Enabled = true;

          // Relinquish the authTicket
          eppcc.Logout(authTicket);
          }

        Cursor.Current = Cursors.Default;
        }
      else
        {
        // Not valid - display an error message
        MessageBox.Show("The specified date range is not valid.  Please correct it and try again.");
        Result = INVALID_DATE_RANGE;
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif

      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Returns true if the specified date range is valid
    /// </summary>
    /// <param name="startDate"></param>
    /// <param name="endDate"></param>
    /// <returns></returns>
    private bool ValidateDateRange(DateTime startDate, DateTime endDate)
      {
      bool Result = true;

      // Check that the end date is later than the start date
      if (DateTime.Compare(endDate, startDate) <= 0)
        {
        // End date is either earlier or the same as the start date
        Result = false;
        }

      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Applies the selection criteria to the CustomData XML to see whether this record is required
    /// </summary>
    /// <param name="p"></param>
    /// <returns></returns>
    private bool ApplyFilters(string customData, int GLCodeFilterIndex, int CCFilterIndex, int DeptFilterIndex)
      {
      bool Result = false;

      if ((GLCodeFilterIndex == 0) && (CCFilterIndex == 0) && (DeptFilterIndex == 0))
        {
        // We want ALL records, so no need to parse the XML
        Result = true;
        }
      else
        {
        // customData is in XML format so we need to parse it for the required criteria
        if (!string.IsNullOrEmpty(customData))
          {
          // We have something to parse
          XmlDocument xmlDoc = new XmlDocument();

          try
            {
            xmlDoc.LoadXml(customData);

            XmlNode PayDataNode = xmlDoc.DocumentElement;

            string glCode = string.Empty;
            string costCentre = string.Empty;
            string department = string.Empty;
            bool matchedGLCode = false;
            bool matchedCC = false;
            bool matchedDept = false;
            XmlNode node;

            // Extract the relevant attributes and see if there is a match.
            // A match occurs when any of the following criteria are met:
            // 1) The filter matches the attribute exactly
            // 2) The filter is set to ALL
            // 3) The attribute is blank (not used)

            // Get the 3-character code of the CC/Dept
            string filterCC = comboRestoreCostCentre.Text.Substring(0, 3);
            string filterDept = comboRestoreDepartment.Text.Substring(0, 3);

            // Get the GL code
            string filterGLCode = comboRestoreGLCode.Text;
            int hPos = filterGLCode.IndexOf(" -");
            if (hPos < 0)
              filterGLCode = string.Empty;
            else
              filterGLCode = filterGLCode.Substring(0, hPos);

            node = PayDataNode.Attributes["GLCode"];
            if (node != null) glCode = PayDataNode.Attributes["GLCode"].Value.ToString();
            matchedGLCode = ((filterGLCode == glCode) ||
                             (GLCodeFilterIndex == 0) ||
                             (string.IsNullOrEmpty(glCode)));

            node = PayDataNode.Attributes["CC"];
            if (node != null) costCentre = PayDataNode.Attributes["CC"].Value.ToString();
            matchedCC = ((filterCC.ToUpper() == costCentre.ToUpper()) ||
                         (CCFilterIndex == 0) ||
                         (string.IsNullOrEmpty(costCentre)));

            node = PayDataNode.Attributes["DP"];
            if (node != null) department = PayDataNode.Attributes["DP"].Value.ToString();
            matchedDept = ((filterDept.ToUpper() == department.ToUpper()) ||
                           (DeptFilterIndex == 0) ||
                           (string.IsNullOrEmpty(department)));

            // If we can match them all, we want this record.
            Result = ((matchedGLCode) && (matchedCC) && (matchedDept));
            }
          catch
            {
            // The XML is not valid.
            Result = false;
            }
          }
        else
          {
          // No custom data. Not sure this should happen, but we'll play safe and say we want it (for now)
          Result = true;
          }
        }

      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Writes a data record to the CSV data
    /// </summary>
    /// <param name="csvData">The CSV string list</param>
    /// <param name="csvLine"></param>
    /// <param name="credentials"></param>
    /// <param name="item">The transaction as received from the Payment Portal</param>
    private void CSVEmitDataRecord(ref List<string> csvData, GatewayCOMObject.GatewayCOMClass.Credentials credentials, GatewayTransactionView item)
      {
      StringBuilder csvLine = new StringBuilder();

      csvLine.Append(item.GatewayUserCompanyId.ToString());
      csvLine.Append(", " + item.GatewayTransactionTypeId.ToString());
      csvLine.Append(", " + item.GatewayTransactionId.ToString());
      csvLine.Append(", " + item.ExternalAccountReference);
      csvLine.Append(", " + item.GatewayTransactionCurrency);
      csvLine.Append(", " + item.GatewayVendorCardType);
      csvLine.Append(", " + QuotedString(item.GatewayVendorCardLast4Digits));
      csvLine.Append(", " + QuotedString(item.GatewayVendorCardExpiryDate));
      csvLine.Append(", " + item.GatewayVendorTxAuthNo);
      csvLine.Append(", " + item.GatewayVendorVPSTxId);
      string MerchantName = config.GetMerchantName(credentials.Company, item.GatewayUserCompanyMerchantAccountId);
      csvLine.Append(", " + MerchantName);
      csvLine.Append(", " + item.CreatedDateTime.ToString());
      csvLine.Append(", " + item.ExternalReceiptReference);
      csvLine.Append(", " + item.ExternalReference);

      // These data exist in the returned transactions, but we don't appear to need them.
      //                csvLine.Append(", " + item.TypeName);
      //                csvLine.Append(", " + item.ExternalReference);
      //                csvLine.Append(", " + item.CustomData);
      //                csvLine.Append(", " + item.Description);
      //                csvLine.Append(", " + QuotedString(item.GatewayStatusId.ToString()));
      //                csvLine.Append(", " + item.GatewayTransactionGrossAmount.ToString());
      //                csvLine.Append(", " + item.GatewayUserCompanyMerchantAccountId.ToString());
      //                csvLine.Append(", " + item.GatewayUserCompanyPaymentProviderId.ToString());
      //                csvLine.Append(", " + item.GatewayVendorAtsData);
      //                csvLine.Append(", " + QuotedString(item.GatewayVendorSecurityKey));
      //                csvLine.Append(", " + QuotedString(item.GatewayVendorTxCode));
      //                csvLine.Append(", " + item.IsError.ToString());
      //                csvLine.Append(", " + item.ServiceName);
      //                csvLine.Append(", " + item.ServiceResponse);
      //                csvLine.Append(", " + item.VendorTypeName);

      // Add blank fields for the columns used by the Custom Data
      int NumFields = CUSTOM_DATA_HEADER_FIELDS + CUSTOM_DATA_LINE_FIELDS;
      csvLine.Append(string.Concat(Enumerable.Repeat(", ", NumFields)));

      csvData.Add(csvLine.ToString());
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Adds the column headings row to the CSV data
    /// </summary>
    /// <param name="csvData"></param>
    /// <param name="csvLine"></param>
    private static void CSVEmitHeadings(ref List<string> csvData)
      {
      StringBuilder csvLine = new StringBuilder();

      csvLine.Append("Company Id");
      csvLine.Append(", Transaction Type");
      csvLine.Append(", Transaction Id");
      csvLine.Append(", External Account Reference");
      csvLine.Append(", Currency");
      csvLine.Append(", Card Type");
      csvLine.Append(", Card Last 4 Digits");
      csvLine.Append(", Card Expiry Date");
      csvLine.Append(", Tx Auth No");
      csvLine.Append(", Gateway Status Id");
      csvLine.Append(", Merchant Account Id");
      csvLine.Append(", Date/Time created");
      csvLine.Append(", External Receipt Reference");
      csvLine.Append(", External Reference");

      // Headings for Custom Data (transaction header)
      csvLine.Append(", Transaction Reference");
      csvLine.Append(", Period");
      csvLine.Append(", Year");
      csvLine.Append(", GL Code");
      csvLine.Append(", Cost Centre");
      csvLine.Append(", Department");
      csvLine.Append(", Payment Ref");

      // Headings for Custom Data (transaction line data)
      csvLine.Append(", ABS No.");
      csvLine.Append(", Stock");
      csvLine.Append(", Description");
      csvLine.Append(", Location");
      csvLine.Append(", VAT Code");
      csvLine.Append(", Goods");
      csvLine.Append(", VAT");

      csvData.Add(csvLine.ToString());
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Parses the CustomData field into CSV lines.
    /// </summary>
    /// <param name="csvData">Passed by ref to allow modification</param>
    /// <param name="customData">The input data containing XML</param>
    /// <returns></returns>
    private int ParseCustomDataToCSV(ref List<String> csvData, string customData)
      {
      int Result = 0;

      if (!string.IsNullOrEmpty(customData))
        {
        XmlDocument xmlDoc = new XmlDocument();

        StringBuilder csvLine = new StringBuilder();

        try
          {
          xmlDoc.LoadXml(customData);

          XmlNode PayDataNode = xmlDoc.DocumentElement;

          string transRef = string.Empty;
          string period = string.Empty;
          string year = string.Empty;
          string glCode = string.Empty;
          string costCentre = string.Empty;
          string department = string.Empty;
          string payRef = string.Empty;
          XmlNode node;

          // PKR. 05/01/2015. Check that the attributes exist before trying to access them.
          // There is no XmlNode.HasAttribute method, so this will have to do.
          node = PayDataNode.Attributes["TransRef"];
          if (node != null) transRef = PayDataNode.Attributes["TransRef"].Value.ToString();

          node = PayDataNode.Attributes["Period"];
          if (node != null) period = PayDataNode.Attributes["Period"].Value.ToString();

          node = PayDataNode.Attributes["Year"];
          if (node != null) year = PayDataNode.Attributes["Year"].Value.ToString();

          node = PayDataNode.Attributes["GLCode"];
          if (node != null) glCode = PayDataNode.Attributes["GLCode"].Value.ToString();

          node = PayDataNode.Attributes["CC"];
          if (node != null) costCentre = PayDataNode.Attributes["CC"].Value.ToString();

          node = PayDataNode.Attributes["DP"];
          if (node != null) department = PayDataNode.Attributes["DP"].Value.ToString();

          node = PayDataNode.Attributes["PayRef"];
          if (node != null) payRef = PayDataNode.Attributes["PayRef"].Value.ToString();

          // Emit a line to the CSV data
          // Add blank fields for the main header data
          csvLine.Append(" ");
          int NumFields = DATA_HEADER_FIELDS - 1;
          csvLine.Append(string.Concat(Enumerable.Repeat(", ", NumFields)));

          // Add the transaction header fields
          csvLine.Append(", " + transRef);
          csvLine.Append(", " + period);
          csvLine.Append(", " + year);
          csvLine.Append(", " + glCode);
          csvLine.Append(", " + costCentre);
          csvLine.Append(", " + department);
          csvLine.Append(", " + payRef);
          // Add blank fields for the transaction line data
          NumFields = CUSTOM_DATA_LINE_FIELDS;
          csvLine.Append(string.Concat(Enumerable.Repeat(", ", NumFields)));

          csvData.Add(csvLine.ToString());

          string absNo;
          string stk;
          string desc;
          string loc;
          string vatCode;
          string goods;
          string vat;

          // The transaction lines
          foreach (XmlNode lineNode in PayDataNode.ChildNodes)
            {
            csvLine.Clear();

            absNo = string.Empty;
            stk = string.Empty;
            desc = string.Empty;
            loc = string.Empty;
            vatCode = string.Empty;
            goods = string.Empty;
            vat = string.Empty;

            node = lineNode.Attributes["ABSNo"];
            if (node != null) absNo = lineNode.Attributes["ABSNo"].Value.ToString();

            node = lineNode.Attributes["Stk"];
            if (node != null) stk = lineNode.Attributes["Stk"].Value.ToString();

            node = lineNode.Attributes["Desc"];
            if (node != null) desc = lineNode.Attributes["Desc"].Value.ToString();

            node = lineNode.Attributes["Loc"];
            if (node != null) loc = lineNode.Attributes["Loc"].Value.ToString();

            node = lineNode.Attributes["VATCode"];
            if (node != null) vatCode = lineNode.Attributes["VATCode"].Value.ToString();

            node = lineNode.Attributes["Goods"];
            if (node != null) goods = lineNode.Attributes["Goods"].Value.ToString();

            node = lineNode.Attributes["VAT"];
            if (node != null) vat = lineNode.Attributes["VAT"].Value.ToString();

            // Emit the line to the CSV data
            // Add blank fields for the main header and the transaction header
            csvLine.Append(" ");
            NumFields = DATA_HEADER_FIELDS + CUSTOM_DATA_HEADER_FIELDS - 1;
            csvLine.Append(string.Concat(Enumerable.Repeat(", ", NumFields)));

            // Add the transaction line fields
            csvLine.Append(", " + absNo);
            csvLine.Append(", " + stk);
            csvLine.Append(", " + desc);
            csvLine.Append(", " + loc);
            csvLine.Append(", " + vatCode);
            csvLine.Append(", " + goods);
            csvLine.Append(", " + vat);

            csvData.Add(csvLine.ToString());
            }
          }
        catch (Exception ex)
          {
          // Temporary message
          MessageBox.Show("An error occurred processing the transaction data:\r\n" + ex.Message);

          // TODO: Log the error

          Result = 1; // anything non-zero
          }
        }
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Handle a click on the View CSV button.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void btnViewCSV_Click(object sender, EventArgs e)
      {
      progressBar.Visible = false;
      ViewCSVFile();
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Load the CSV file into the default application
    /// </summary>
    private void ViewCSVFile()
      {
      if (File.Exists(csvPath))
        {
        try
          {
          dbgForm.Log("Attempting to load " + csvPath);
          csvApp = Process.Start(csvPath);
          }
        catch (Exception ex)
          {
          string supp = string.Empty;
          if (csvApp == null)
            {
            supp = "\r\nNo application associated with CSV files.";
            }
          MessageBox.Show(string.Format("An error occurred loading the CSV file\r\n {0}.\r\n{1}{2}", csvPath, ex.Message, supp));
          }
        }
      else
        {
        MessageBox.Show("The CSV file does not exist");
        btnViewCSV.Enabled = false;
        }
      }

    /// <summary>
    /// Handles selection of a company from the combo box.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void comboRestoreMCM_SelectedIndexChanged(object sender, EventArgs e)
      {
      //      if (!isInitialising)
      //        {
      // PKR. 09/04/2015. ABSEXCH-16329. Indicate when the data restore is complete
      progressBar.Visible = false;
      lblRestoreComplete.Visible = false;

      int index = comboMCMCompany.SelectedIndex;

      // Don't do anything if nothing has been selected.
      if (index >= 0)
        {
        // ABSEXCH-15851. PKR. 25/11/2014.  Added company code to combo box entries.
        MCMComboBoxItem selItem = comboRestoreMCM.Items[index] as MCMComboBoxItem;

        // Check we have an object to work with
        if (selItem != null)
          {
          string datapath = "";

          // Get the item
          string selCompanyCode = selItem.companyCode;

          CompanyConfig selCompany = config.FindCompanyByCode(selCompanyCode);

          MCMCompany selMCMCompany = null;
          foreach (MCMCompany mcmCompany in config.MCMCompanyList)
            {
            if (mcmCompany.code == selCompany.code)
              {
              datapath = mcmCompany.path; // This is used later
              selMCMCompany = mcmCompany;
              break;
              }
            }

          if (tToolkit.Status == Enterprise04.TToolkitStatus.tkOpen)
            {
            tToolkit.CloseToolkit();
            }

          // ABSEXCH-15850. PKR. 25/11/2014. Toolkit errors when working with sub-companies, due to incorrect path.
          tToolkit.Configuration.DataDirectory = datapath;

          int tkRes = tToolkit.OpenToolkit();

          // ABSEXCH-15860. PKR. 26/11/2014. Set availability of checkbox based on criteria.
          // Get Order Payments Enabled flag for the company from Exchequer.
          selMCMCompany.orderPaymentsIsEnabled = (tToolkit.SystemSetup as Enterprise04.ISystemSetup12).ssEnableOrderPayments;

          // Cost Centres and Departments
          usingCCDepts = tToolkit.SystemSetup.ssUseCCDept;

          long Res;

          lblRestoreCC.Visible = usingCCDepts;
          lblRestoreDept.Visible = usingCCDepts;
          comboRestoreCostCentre.Visible = usingCCDepts;
          comboRestoreDepartment.Visible = usingCCDepts;
          if (!usingCCDepts)
            {
            // Not using Cost Centres or Departments, so make sure they are set to "ALL"
            // so that the records aren't filtered.
            comboRestoreCostCentre.Text = "ALL Cost Centres";
            comboRestoreDepartment.Text = "ALL Departments";
            }
          else
            {
            // Get the lists of Cost Centres and Departments from Exchequer
            // Cost Centres.  Reset the list
            comboRestoreCostCentre.Items.Clear();
            tToolkit.CostCentre.Index = Enterprise04.TCCDeptIndex.cdIdxCode;
            Res = tToolkit.CostCentre.GetFirst();
            while (Res == 0)
              {
              comboRestoreCostCentre.Items.Add(tToolkit.CostCentre.cdCode + " - " + tToolkit.CostCentre.cdName);
              Res = tToolkit.CostCentre.GetNext();
              }

            // Departments.  Reset the list
            comboRestoreDepartment.Items.Clear();
            tToolkit.Department.Index = Enterprise04.TCCDeptIndex.cdIdxCode;
            Res = tToolkit.Department.GetFirst();
            while (Res == 0)
              {
              comboRestoreDepartment.Items.Add(tToolkit.Department.cdCode + " - " + tToolkit.Department.cdName);
              Res = tToolkit.Department.GetNext();
              }
            }

          // Get the list of GL codes from Exchequer
          bool usingGLClasses = (tToolkit.SystemSetup as Enterprise04.ISystemSetup5).ssEnforceGLClasses;

          comboRestoreGLCode.Items.Clear();
          Enterprise04.IGeneralLedger2 oGL = (tToolkit.GeneralLedger as Enterprise04.IGeneralLedger2);

          oGL.Index = Enterprise04.TGeneralLedgerIndex.glIdxCode;
          Res = oGL.GetFirst();

          // PKR. 25/02/2015. ABSEXCH-16219.  Limit GLCodes to Balance Sheet and Profit & Loss.
          // If enforcing GL Classes, then Balance Sheet codes must be in the Bank Account class.
          while (Res == 0)
            {
            bool wantThisEntry = false;

            if (oGL.glType == TGeneralLedgerType.glTypeProfitLoss)
              {
              // It's a Profit & Loss code, so we want this one.
              wantThisEntry = true;
              }
            else
              {
              if (oGL.glType == TGeneralLedgerType.glTypeBalanceSheet)
                {
                // It's a Balance Sheet code, so we might want this one
                wantThisEntry = true;
                if (usingGLClasses)
                  {
                  // We're enforcing GL Classes, so make sure it's a Bank Account
                  if (oGL.glClass != TGeneralLedgerClass.glcBankAccount)
                    {
                    // It's not a bank account, so we don't want it.
                    wantThisEntry = false;
                    }
                  }
                }
              }

            if (wantThisEntry)
              {
              comboRestoreGLCode.Items.Add(tToolkit.GeneralLedger.glCode + " - " + tToolkit.GeneralLedger.glName);
              }
            Res = oGL.GetNext();  // tToolkit.GeneralLedger.GetNext();
            }

          // PKR. 19/02/2015. ABSEXCH-16192. Removed call to CloseToolkit as it must remain open while we're editing.
          // The toolkit is closed when the form closes.
          }
        }
      //        }
      }

    //---------------------------------------------------------------------------------------------
    private void btnViewLog_Click(object sender, EventArgs e)
      {
      // Display the log file
      string logFile = dataRestorer.GetRestoreLogFilename();

      if (File.Exists(logFile))
        {
        try
          {
          System.Diagnostics.Process.Start(logFile);
          }
        catch (Exception ex)
          {
          MessageBox.Show("An error occurred opening the log file.\r\n" + ex.Message);
          }
        }
      else
        {
        MessageBox.Show("No log file to view");
        btnViewLog.Enabled = false;
        }
      }

    //---------------------------------------------------------------------------------------------
    private void dgvConfiguration_CellValueChanged(object sender, DataGridViewCellEventArgs e)
      {
      if (!isInitialising)
        {
        isDirty = true;
        btnApply.Enabled = true;
        }
      }

    private void editConfig_KeyUp(object sender, KeyEventArgs e)
      {
      if (e.Control)
        {
        if (e.KeyCode == Keys.A)
          {
          editConfig.SelectAll();
          }
        }
      }

    private void btnSaveConfig_Click(object sender, EventArgs e)
      {
      //      TextLock textLocker = new TextLock(config.ExchDir);
      //      string password = ""; // Blank password forces use of default
      string configXML = editConfig.Text;
      //      textLocker.EncryptString(configXML, password);
      //      string encryptedConfiguration = textLocker.EncryptedString;
      Byte[] pepper = { 0x54, 0x53, 0x7D, 0x6E, 0x2D, 0x73, 0x35, 0x54, 0x2A, 0x6A, 0x52, 0x68, 0x35, 0x3C, 0x47, 0x61 };
      string newKey = System.Text.Encoding.Default.GetString(pepper);
      string encryptedConfiguration = Encryption2.Encrypt(configXML, newKey);

      XmlDocument xmlDoc = new XmlDocument();
      XmlNode rootNode = xmlDoc.CreateElement("CCGatewayCfg");
      xmlDoc.AppendChild(rootNode);

      XmlNode configNode = xmlDoc.CreateElement("Configuration");
      rootNode.AppendChild(configNode);
      configNode.InnerXml = encryptedConfiguration;

      // Save it
      xmlDoc.Save(config.ExchDir + config.filename);
      }

    /// <summary>
    /// For developers only
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void spinSourceUDF_KeyUp(object sender, KeyEventArgs e)
      {
#if DEBUG
      // This will show the decrypted XML config file and allow it to be edited and saved.
      // Set focus to the UDF Spin Edit box, hold Alt-Shift and type "plugh" when logged in as a superuser.
      string testPlugh = "PLUGH";
      if (isSuperUser)
        {
        if ((e.Alt) && (e.Shift))
          {
          string iChar = e.KeyData.ToString().Substring(0, 1);
          int cPos = testPlugh.IndexOf(iChar);
          if (plugh.Length == cPos)
            plugh += iChar;
          else
            plugh = string.Empty;

          if (plugh == testPlugh)
            {
            btnSaveConfig.Visible = true;
            plughLabel.Visible = true;
            tabConfig.Parent = tabControl1;
            }
          }
        }
#endif
      }

    /// <summary>
    /// Display help for the Data Restore function
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void btnHelp_Click(object sender, EventArgs e)
      {
      Help.ShowHelp(this, helpFile, HelpNavigator.TopicId, HELP_CONTEXT_CC_CONFIG.ToString());
      }

    /// <summary>
    /// Displays context-sensitive F1 help depending on the control that has focus.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="hlpevent"></param>
    private void ConfigurationForm_HelpRequested(object sender, HelpEventArgs hlpevent)
      {
      if (HELP_CONTEXT_CC_CONFIG != 0)
        {
        // Determine the current control and use its help context
        //        Control requestingControl = (Control)sender;

        //        string helpContext = requestingControl.Tag.ToString();
        string helpContext = HELP_CONTEXT_CC_CONFIG.ToString();
        Help.ShowHelp(this, helpFile, HelpNavigator.TopicId, helpContext);

        hlpevent.Handled = true;
        }
      }

    private void comboRestoreMCM_Click(object sender, EventArgs e)
      {
      comboRestoreMCM.DroppedDown = true;
      }

    private void comboRestoreGLCode_Click(object sender, EventArgs e)
      {
      comboRestoreGLCode.DroppedDown = true;
      }

    private void comboRestoreCostCentre_Click(object sender, EventArgs e)
      {
      comboRestoreCostCentre.DroppedDown = true;
      }

    private void comboRestoreDepartment_Click(object sender, EventArgs e)
      {
      comboRestoreDepartment.DroppedDown = true;
      }

    private void comboMCMCompany_Click(object sender, EventArgs e)
      {
      comboMCMCompany.DroppedDown = true;
      }

    //=============================================================================================
    }
  }