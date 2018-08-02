using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using System.Xml;
using Advanced.Encryption;
using Enterprise04;
using Exchequer.Payments.Portal.COM.Client;
using Microsoft.Win32;

/*
 * The configuration data is stored in a local XML file (in the Exchequer directory).
 * The file is called CCGatewayCfg.dat.  This is because Pervasive users tend to back up
 * any file with a file type of .dat.
 * The XML is encrypted and Base64 encoded for security.  It uses the same encryption
 * method (including the keys) as the SQL connection string XML file.
 */

namespace PaymentGatewayAddin
  {
  /// <summary>
  /// This is equivalent to the class in the GatewayCOMClass and could be replaced when
  /// we have the Payment Portal COM Object assembly
  /// </summary>

  //===============================================================================================
  // Classes for obtaining and holding Exchequer data

  public class MCMCompany
    {
    public string name;
    public string code;

    // ABSEXCH-15850. PKR. 25/11/2014. Added path so that the toolkit can be opened correctly for sub-companies
    public string path;

    // ABSEXCH-15860. PKR. 26/11/2014. Required for configuration dialog.
    public bool orderPaymentsIsEnabled;
    }

  // These will be used by the configuration screen in drop-down lists so that the user
  //  doesn't have to type them in.
  /// <summary>
  /// A GL Code item
  /// </summary>
  public class GLCodeListItem
    {
    public int GLCode;
    public string Description;

    public GLCodeListItem(int glCode, string glDesc)
      {
      GLCode = glCode;
      Description = glDesc;
      }

    public override string ToString()
      {
      return string.Format("{0} : {1}", GLCode, Description);
      }
    }

  /// <summary>
  /// A Cost Centre or Department item
  /// </summary>
  public class CostCentreDeptListItem
    {
    public string Code;
    public string Description;

    public CostCentreDeptListItem(string code, string desc)
      {
      Code = code;
      Description = desc;
      }

    public override string ToString()
      {
      // PKR. 26/08/2015. ABSEXCH-16789. Credit Card Config losing default CC / Dept codes is less than 3 characters.
      // Wasn't actually losing it - just not displaying it due to field padding.
      return string.Format("{0} : {1}", Code.Trim(), Description);
      }
    }

  //===============================================================================================
  // Components of the configuration that will be saved in the XML file
  //
  public class SourceConfig
    {
    public string name = string.Empty;
    public int glCode = 0;
    public string costCentre = string.Empty;
    public string department = string.Empty;
    public GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount merchantAccount;

    /// <summary>
    /// Constructor
    /// </summary>
    public SourceConfig()
      {
      merchantAccount = new GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount();
      }

    /// <summary>
    /// Destructor
    /// </summary>
    ~SourceConfig()
      {
      merchantAccount = null;
      }
    }

  //===============================================================================================
  public class CurrencyCodes
    {
    public string ExchequerName = string.Empty;
    public string ExchequerSymbol = string.Empty;
    public string ISOCode = string.Empty;
    }

  //===============================================================================================
  /// <summary>
  /// A configuration object for an MCM company
  /// </summary>
  public class CompanyConfig
    {
    public string name = string.Empty;
    public string code = string.Empty;
    public int sourceUDF;
    public bool enabled;
    public bool enabledInExchequer;
    public List<SourceConfig> sources;
    public List<CurrencyCodes> currencies;

    /// <summary>
    /// Constructor
    /// </summary>
    public CompanyConfig()
      {
      sources = new List<SourceConfig>();
      currencies = new List<CurrencyCodes>();
      }

    /// <summary>
    /// Destructor
    /// </summary>
    ~CompanyConfig()
      {
      // Empty the lists and set to null so they will be collected by the GC.
      sources.Clear();
      sources = null;
      currencies.Clear();
      currencies = null;
      }
    }

  //===============================================================================================
  /// <summary>
  /// Top level configuration object for the Credit Card add-in
  /// </summary>
  public class SiteConfig : IDisposable
    {
    public const int SITE_ID_LENGTH = 36;
    public const int PASSWORD_LENGTH = 50;

    private static Byte[] pepper = { 0x54, 0x53, 0x7D, 0x6E, 0x2D, 0x73, 0x35, 0x54, 0x2A, 0x6A, 0x52, 0x68, 0x35, 0x3C, 0x47, 0x61 };

    /// <summary>
    /// The Exchequer directory as reported by the COM Toolkit.
    /// </summary>
    public string ExchDir;

    public string filename;

    public string configXML { get; set; }

    public string securityCode = string.Empty;
    public string siteIdentifier = string.Empty;
    public string password = string.Empty;
    public bool isCredentialsVerified = false;
    public List<CompanyConfig> companies;
    public List<MCMCompany> MCMCompanyList;

    public List<GLCodeListItem> GLCodes;
    public List<CostCentreDeptListItem> CostCentres;
    public List<CostCentreDeptListItem> Departments;

    // Local reference to the toolkit.
    private IToolkit3 tToolkit = null;

    // PKR. TEMPORARY for debugging
    public DebugView dbgForm { get; set; }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Constructor
    /// </summary>
    public SiteConfig(IToolkit3 aToolkit)
      {
      tToolkit = aToolkit;

      companies = new List<CompanyConfig>();
      MCMCompanyList = new List<MCMCompany>();
      GLCodes = new List<GLCodeListItem>();
      CostCentres = new List<CostCentreDeptListItem>();
      Departments = new List<CostCentreDeptListItem>();

      siteIdentifier = string.Empty;
      password = string.Empty;

      ExchDir = string.Empty;
      }

    //=============================================================================================
    // Implementation of IDisposable
    //=============================================================================================

    private bool disposed = false;

    public void Dispose()
      {
      Dispose(true);
      GC.SuppressFinalize(this);
      }

    /// <summary>
    /// Dispose of resources
    /// This technique, allows us to close the Toolkit.
    /// If we try to do it in the destructor, the Toolkit might have already been disconnected from
    /// its RCW (Runtime Callable Wrapper), and will therefore be inaccessible.
    /// </summary>
    /// <param name="disposing"></param>
    protected virtual void Dispose(bool disposing)
      {
      if (disposed)
        {
        return;
        }

      if (disposing)
        {
        // Free all managed objects here.
        companies.Clear();
        companies = null;

        MCMCompanyList.Clear();
        MCMCompanyList = null;

        GLCodes.Clear();
        GLCodes = null;

        CostCentres.Clear();
        CostCentres = null;

        Departments.Clear();
        Departments = null;
        }

      // Free all unmanaged objects here.

      disposed = true;
      }

    /// <summary>
    /// Finalizer
    /// </summary>
    ~SiteConfig()
      {
      // This allows unmanaged resources to be handled
      Dispose(false);
      }

    //=============================================================================================

    /// <summary>
    /// Gets a list of MCM Companies via the COM Toolkit
    /// </summary>
    public void GetExchequerData()
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      try
        {
        // Get the Exchequer directory while we're here, because it's where the config file is stored.
        // PKR. 05/02/2015. ABSEXCH-16121. Config doesn't work if not running in the Exchequer installation directory
        // because the config file can't be found.
        // So get the installation directory from the Registry.
        ExchDir = GetInstallationDir();

        // Read the list of MCM companies.
        Enterprise04.ICompanyManager coManager = tToolkit.Company;
        int nCos = coManager.cmCount;
        this.companies.Clear();
        this.MCMCompanyList.Clear();

        int Res = 0;

        for (int index = 1; index <= nCos; index++)
          {
          MCMCompany aCompany = new MCMCompany();

          aCompany.name = coManager.cmCompany[index].coName;
          // Trim() added to remove trailing spaces for codes with fewer than 6 characters.
          aCompany.code = coManager.cmCompany[index].coCode.Trim();
          // ABSEXCH-15850. 25/11/2014. PKR. Added path so that the toolkit can be opened correctly for sub-companies
          aCompany.path = coManager.cmCompany[index].coPath;

          this.MCMCompanyList.Add(aCompany);

          // ABSEXCH-15860. PKR. Get Order Payments Enabled flag for the company from Exchequer.
          tToolkit.Configuration.DataDirectory = aCompany.path;
          Res = tToolkit.OpenToolkit();
          if (Res != 0)
            {
            MessageBox.Show("Configuration: Error opening COM toolkit for " + aCompany.code + " : " + tToolkit.LastErrorString);
            }
          else
            {
            aCompany.orderPaymentsIsEnabled = (tToolkit.SystemSetup as Enterprise04.ISystemSetup12).ssEnableOrderPayments;
            Res = tToolkit.CloseToolkit();
            if (Res != 0)
              {
              MessageBox.Show("Configuration: Error closing COM toolkit for " + aCompany.code + " : " + tToolkit.LastErrorString);
              }
            }
          }
        }
      catch (Exception ex)
        {
        MessageBox.Show("An error occurred obtaining company data from Exchequer:\r\n" + ex.Message);
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return;
      }

    //--------------------------------------------------------------------------------------------
    /// <summary>
    /// Gets the GL Codes, Cost Centres and Departments for the current company
    /// </summary>
    public void GetExchequerCompanySpecificData()
      {
#if DEBUG
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
#endif
      if (tToolkit.Status == TToolkitStatus.tkOpen)
        {
        bool usingGLClasses = (tToolkit.SystemSetup as Enterprise04.ISystemSetup5).ssEnforceGLClasses;
        // Cost Centres and Departments
        bool usingCCDepts = tToolkit.SystemSetup.ssUseCCDept;

        // Clear the GLCode list
        GLCodes.Clear();
        // Get the list of GLCodes for the current company.

        Enterprise04.IGeneralLedger2 oGL = (tToolkit.GeneralLedger as Enterprise04.IGeneralLedger2);

        oGL.Index = Enterprise04.TGeneralLedgerIndex.glIdxCode;
        long Res = oGL.GetFirst();

        // PKR. 25/02/2015. ABSEXCH-16219.  Limit GLCodes to Balance Sheet and Profit & Loss.
        // If enforcing GL Classes, then Balance Sheet codes must be in the Bank Account class.
        while (Res == 0)
          {
          bool wantThisEntry = false;

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

          if (wantThisEntry)
            {
            // Add the GLCode to the list
            GLCodeListItem newGLCode = new GLCodeListItem(tToolkit.GeneralLedger.glCode, tToolkit.GeneralLedger.glName);
            GLCodes.Add(newGLCode);
            }

          Res = oGL.GetNext();
          }

        oGL = null;

        if (usingCCDepts)
          {
          // Clear the Cost Centres list
          CostCentres.Clear();
          // Get the list of Cost Centres for the current company.

          tToolkit.CostCentre.Index = Enterprise04.TCCDeptIndex.cdIdxCode;
          Res = tToolkit.CostCentre.GetFirst();
          while (Res == 0)
            {
            CostCentreDeptListItem newCC = new CostCentreDeptListItem(tToolkit.CostCentre.cdCode, tToolkit.CostCentre.cdName);
            CostCentres.Add(newCC);

            Res = tToolkit.CostCentre.GetNext();
            }

          // Clear the Departments list
          Departments.Clear();
          // Get the list of Departments for the current company.
          // Departments.  Reset the list
          tToolkit.Department.Index = Enterprise04.TCCDeptIndex.cdIdxCode;
          Res = tToolkit.Department.GetFirst();
          while (Res == 0)
            {
            CostCentreDeptListItem newDept = new CostCentreDeptListItem(tToolkit.Department.cdCode, tToolkit.Department.cdName);
            Departments.Add(newDept);

            Res = tToolkit.Department.GetNext();
            }
          }
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Gets the Exchequer installation directory from the Registry.
    /// </summary>
    /// <returns></returns>
    public string GetInstallationDir()
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      string OLEServerPath = string.Empty;
      string OLEServerGuid = string.Empty;

      try
        {
        RegistryKey regKey = Registry.ClassesRoot;
        RegistryKey guidKey = regKey.OpenSubKey(@"Enterprise.OLEServer\Clsid", false);

        try
          {
          OLEServerGuid = guidKey.GetValue(null).ToString();

          if (!string.IsNullOrEmpty(OLEServerGuid))
            {
            // We have the GUID. Get the associated LocalServer32 value
            // This should be <path to Exchequer>\ENTEROLE.EXE
            RegistryKey pathKey = regKey.OpenSubKey(@"Clsid\" + OLEServerGuid + @"\LocalServer32", false);
            OLEServerPath = pathKey.GetValue(null).ToString();
            pathKey.Close();

            // Get the path only (ie the Exchequer directory)
            OLEServerPath = Path.GetDirectoryName(OLEServerPath);

            if (OLEServerPath != string.Empty)
              {
              // If no trailing backslash, add one.
              if (!OLEServerPath.EndsWith(@"\"))
                {
                OLEServerPath += Path.DirectorySeparatorChar;
                }
              }
            }
          }
        finally
          {
          guidKey.Close();
          regKey.Close();
          }
        }
      catch
        {
        // Sink the error and we'll simply return a null string.
        OLEServerPath = string.Empty;
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return OLEServerPath;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Loads the configuration from the file
    /// </summary>
    /// <returns></returns>
    public bool Load(string configFile)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      filename = configFile;

      // Get a list of companies in the MCM.  Companies in the configuration must be in this list
      GetExchequerData();

      string encryptedConfig = string.Empty;

      bool Result = true;

      try
        {
        if (!File.Exists(ExchDir + configFile))
          {
          // 23/03/2015. PKR. ABSEXCH-16171. Create empty configuration file.

          // Create an empty config object for each of the MCM companies
          foreach (MCMCompany mcmCo in MCMCompanyList)
            {
            // Create a CompanyConfig object for it
            CompanyConfig newCo = new CompanyConfig();
            // Add it to the list
            newCo.name = mcmCo.name;
            newCo.code = mcmCo.code;
            newCo.sourceUDF = 10;
            newCo.enabled = false;

            companies.Add(newCo);
            }

          // Save the skeleton config file
          Save();
          }
        else
          {
          string password = ""; // A blank password gets replaced by the standard one in the encryption/decryption routines.
          TextLock textLocker = new TextLock(ExchDir);

          encryptedConfig = textLocker.GetEncryptedStringFromFile(configFile, "Configuration");

          // The encryption routines have been replaced, so we need to determine whether this is an old
          // version or not.  If it is, decode using the old routine.
          if (string.IsNullOrEmpty(textLocker.ConfigVersion))
            {
            // Original encryption method
            textLocker.DecryptString(password, encryptedConfig);
            configXML = textLocker.DecryptedString;
            }
          else
            {
            // New encryption method
            string newKey = System.Text.Encoding.Default.GetString(pepper);
            configXML = Encryption2.Decrypt(encryptedConfig, newKey);
            }

          int convInt; // Used for safe integer conversion
          bool convBool; // Used for safe Boolean conversion
          bool convRes;

          // Do we have something which is potentially a configuration?
          if (!string.IsNullOrEmpty(configXML))
            {
            // We now have a decrypted XML string.
            // Traverse the XML string for configuration data.

            // PKR Temporary for debugging
            //            Clipboard.Clear();
            //            Clipboard.SetText(decryptedXML);

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(configXML);

            // Go to the root node
            XmlNodeList siteNodeList = xmlDoc.GetElementsByTagName("Site");
            if (siteNodeList != null)
              {
              XmlNode siteNode = siteNodeList.Item(0);
              this.isCredentialsVerified = Convert.ToBoolean(siteNode.Attributes["Verified"].Value);

              // Get the SiteID, Password and Companies list
              foreach (XmlNode aNode in siteNode)
                {
                switch (aNode.Name)
                  {
                  case "SecurityCode":
                    this.securityCode = aNode.InnerText;
                    break;

                  case "SiteID":
                    this.siteIdentifier = aNode.InnerText;
                    break;

                  case "Password":
                    this.password = aNode.InnerText;
                    break;

                  case "Companies":
                    XmlNode companiesNode = aNode;
                    foreach (XmlNode companyNode in companiesNode)
                      {
                      // In a <Company> node

                      // Check that this company is in the MCM
                      string thisCompanyCode = companyNode.Attributes["Code"].Value;

                      bool found = false;
                      foreach (MCMCompany knownCompany in this.MCMCompanyList)
                        {
                        // Compare trimmed, upper case version.
                        if (knownCompany.code.ToUpper().Trim() == thisCompanyCode.ToUpper().Trim())
                          {
                          found = true;
                          }
                        }

                      if (found)
                        {
                        // Create a new company configuration object
                        CompanyConfig aCompany = new CompanyConfig();

                        // Populate the company from the XML data
                        aCompany.name = companyNode.Attributes["Name"].Value;
                        aCompany.code = companyNode.Attributes["Code"].Value.ToString().Trim();

                        // Traverse the child nodes
                        foreach (XmlNode cNode in companyNode)
                          {
                          switch (cNode.Name)
                            {
                            case "SourceUDF":
                              convRes = Int32.TryParse(cNode.InnerText, out convInt);
                              if (convRes)
                                aCompany.sourceUDF = convInt;
                              else
                                aCompany.sourceUDF = 0;
                              break;

                            case "Enabled":
                              convRes = Boolean.TryParse(cNode.InnerText, out convBool);
                              if (convRes)
                                aCompany.enabled = Convert.ToBoolean(cNode.InnerText);
                              else
                                // Not a valid boolean value
                                aCompany.enabled = false; // Default to false
                              break;

                            case "Sources":
                              // We now have a list of zero or more sources
                              foreach (XmlNode sourceNode in cNode)
                                {
                                // Create a source
                                SourceConfig newSource = new SourceConfig();

                                newSource.name = sourceNode.Attributes["Name"].Value;

                                if (sourceNode.Attributes["MerchantID"] != null)
                                  {
                                  newSource.merchantAccount.MerchantAccountDescription = sourceNode.Attributes["MerchantID"].Value;
                                  }

                                if (sourceNode.Attributes["MerchantAccountCode"] != null)
                                  {
                                  newSource.merchantAccount.MerchantAccountCode = sourceNode.Attributes["MerchantAccountCode"].Value;
                                  }

                                if (sourceNode.Attributes["MerchantAccountId"] != null)
                                  {
                                  newSource.merchantAccount.MerchantAccountId = Convert.ToInt64(sourceNode.Attributes["MerchantAccountId"].Value);
                                  }

                                if (sourceNode.Attributes["PaymentProvider"] != null)
                                  {
                                  newSource.merchantAccount.PaymentProviderDescription = sourceNode.Attributes["PaymentProvider"].Value;
                                  }

                                if (sourceNode.Attributes["PaymentProviderId"] != null)
                                  {
                                  newSource.merchantAccount.PaymentProviderId = Convert.ToInt64(sourceNode.Attributes["PaymentProviderId"].Value);
                                  }

                                foreach (XmlNode scNode in sourceNode)
                                  {
                                  switch (scNode.Name)
                                    {
                                    case "GLCode":
                                      convRes = Int32.TryParse(scNode.InnerText, out convInt);
                                      if (convRes)
                                        newSource.glCode = convInt;
                                      else
                                        newSource.glCode = 0;
                                      break;

                                    case "CostCentre":
                                      newSource.costCentre = scNode.InnerText;
                                      break;

                                    case "Department":
                                      newSource.department = scNode.InnerText;
                                      break;
                                    }
                                  }
                                aCompany.sources.Add(newSource);
                                }
                              break;

                            case "Currencies":
                              foreach (XmlNode currencyNode in cNode)
                                {
                                // Create a currency configuration item
                                CurrencyCodes currencyXref = new CurrencyCodes();
                                currencyXref.ExchequerName = currencyNode.Attributes["Name"].Value;
                                currencyXref.ExchequerSymbol = currencyNode.Attributes["Symbol"].Value;
                                currencyXref.ISOCode = currencyNode.Attributes["ISO"].Value;

                                // Add it to the company configuration item
                                aCompany.currencies.Add(currencyXref);
                                }
                              break;
                            } // switch cNode.Name
                          } // for eachchild node in company node

                        this.companies.Add(aCompany);
                        } // if found in MCM companies list
                      } // for each company node
                    break;
                  }
                } // for each node in the config

              // If we have created an MCM company since the config file was created we need to make sure it's added
              foreach (MCMCompany exchMCMCompany in MCMCompanyList)
                {
                // See if there's an entry for it in the config
                bool found = false;
                foreach (CompanyConfig company in companies)
                  {
                  // Trimmed, upper-case for comparison.
                  if (company.code.ToUpper().Trim() == exchMCMCompany.code.ToUpper().Trim())
                    {
                    found = true;
                    }
                  }

                if (!found)
                  {
                  // Not found in the config, so we need to add one
                  // Create a new company configuration object
                  CompanyConfig aCompany = new CompanyConfig();

                  // Populate the company from the XML data
                  aCompany.name = exchMCMCompany.name;
                  aCompany.code = exchMCMCompany.code.ToUpper().Trim();

                  companies.Add(aCompany);
                  }
                }
              }

            if (string.IsNullOrEmpty(textLocker.ConfigVersion))
              {
              Save();
              }
            } // Config isn't empty
          else
            {
            // Empty string, so failed to read config.
            // This might be because we haven't created one yet.
            Result = false;
            }
          }
        }
      catch (Exception Ex)
        {
        MessageBox.Show("Error in config.Load : " + Ex.Message);
        // This might have failed because we haven't created a configuration yet.
        // Probably better to return a more useful failure reason.
        Result = false;
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
    /// Creates the part of the XML that will be encrypted
    /// </summary>
    /// <returns></returns>
    private string FormatAsXML()
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      string Result = "";

      try
        {
        XmlDocument xmlDoc = new XmlDocument();

        XmlNode siteNode = xmlDoc.CreateElement("Site");
        XmlAttribute verifiedAttribute = xmlDoc.CreateAttribute("Verified");
        verifiedAttribute.Value = isCredentialsVerified.ToString();
        siteNode.Attributes.Append(verifiedAttribute);

        // Site details
        // Site Identifier
        XmlNode siteSecurityNode = xmlDoc.CreateElement("SecurityCode");
        siteSecurityNode.InnerText = this.securityCode.Trim();
        siteNode.AppendChild(siteSecurityNode);

        // Site Identifier
        XmlNode siteIDNode = xmlDoc.CreateElement("SiteID");
        siteIDNode.InnerText = this.siteIdentifier.Trim();
        siteNode.AppendChild(siteIDNode);

        // Password
        XmlNode passwordNode = xmlDoc.CreateElement("Password");
        passwordNode.InnerText = this.password.Trim();
        siteNode.AppendChild(passwordNode);

        // The companies group of elements
        XmlNode companiesNode = xmlDoc.CreateElement("Companies");
        siteNode.AppendChild(companiesNode);

        // The actual companies
        foreach (CompanyConfig company in this.companies)
          {
          XmlNode companyNode = xmlDoc.CreateElement("Company");

          // Add its attributes
          XmlAttribute nameAttribute = xmlDoc.CreateAttribute("Name");
          nameAttribute.Value = company.name.Trim();
          companyNode.Attributes.Append(nameAttribute);

          XmlAttribute codeAttribute = xmlDoc.CreateAttribute("Code");
          codeAttribute.Value = company.code.Trim();
          companyNode.Attributes.Append(codeAttribute);

          // The Sources group of elements
          XmlElement sources = xmlDoc.CreateElement("Sources");
          companyNode.AppendChild(sources);

          // The actual sources
          foreach (SourceConfig source in company.sources)
            {
            XmlNode sourceNode = xmlDoc.CreateElement("Source");
            sources.AppendChild(sourceNode);

            // Add its attributes
            XmlAttribute nAttribute = xmlDoc.CreateAttribute("Name");
            nAttribute.Value = source.name.Trim();
            sourceNode.Attributes.Append(nAttribute);

            // Merchant ID details
            XmlAttribute mAttribute = xmlDoc.CreateAttribute("MerchantID");
            mAttribute.Value = source.merchantAccount.MerchantAccountDescription.Trim();
            sourceNode.Attributes.Append(mAttribute);

            XmlAttribute macAttribute = xmlDoc.CreateAttribute("MerchantAccountCode");
            macAttribute.Value = source.merchantAccount.MerchantAccountCode.Trim();
            sourceNode.Attributes.Append(macAttribute);

            XmlAttribute maiAttribute = xmlDoc.CreateAttribute("MerchantAccountId");
            maiAttribute.Value = source.merchantAccount.MerchantAccountId.ToString();
            sourceNode.Attributes.Append(maiAttribute);

            // Payment Provider details
            XmlAttribute ppAttribute = xmlDoc.CreateAttribute("PaymentProvider");
            ppAttribute.Value = source.merchantAccount.PaymentProviderDescription.Trim();
            sourceNode.Attributes.Append(ppAttribute);

            XmlAttribute ppiAttribute = xmlDoc.CreateAttribute("PaymentProviderId");
            ppiAttribute.Value = source.merchantAccount.PaymentProviderId.ToString();
            sourceNode.Attributes.Append(ppiAttribute);

            // Other child nodes
            XmlElement GLCode = xmlDoc.CreateElement("GLCode");
            GLCode.InnerText = source.glCode.ToString();
            sourceNode.AppendChild(GLCode);

            XmlElement CostCentre = xmlDoc.CreateElement("CostCentre");
            CostCentre.InnerText = source.costCentre.Trim();
            sourceNode.AppendChild(CostCentre);

            XmlElement Department = xmlDoc.CreateElement("Department");
            Department.InnerText = source.department.Trim();
            sourceNode.AppendChild(Department);
            }

          // Source UDF number
          XmlNode udfNumber = xmlDoc.CreateElement("SourceUDF");
          companyNode.AppendChild(udfNumber);
          udfNumber.InnerText = company.sourceUDF.ToString();

          // Credit Cards enabled for this company
          XmlNode isEnabled = xmlDoc.CreateElement("Enabled");
          companyNode.AppendChild(isEnabled);
          isEnabled.InnerText = company.enabled.ToString();

          // 03/10/2014.  PKR.  Add currency lookup table that converts from Exchequer to ISO4217.
          XmlNode currencyList = xmlDoc.CreateElement("Currencies");
          companyNode.AppendChild(currencyList);
          // Add each currency entry to the list
          foreach (CurrencyCodes currencyXref in company.currencies)
            {
            XmlNode currencyNode = xmlDoc.CreateElement("Currency");  // Create a node for the currency
            currencyList.AppendChild(currencyNode);                   // Add it to the list

            XmlAttribute nAttribute = xmlDoc.CreateAttribute("Name");
            nAttribute.Value = currencyXref.ExchequerName.Trim();
            currencyNode.Attributes.Append(nAttribute);

            XmlAttribute sAttribute = xmlDoc.CreateAttribute("Symbol");
            sAttribute.Value = currencyXref.ExchequerSymbol.Trim();
            currencyNode.Attributes.Append(sAttribute);

            XmlAttribute iAttribute = xmlDoc.CreateAttribute("ISO");
            iAttribute.Value = currencyXref.ISOCode.Trim();
            currencyNode.Attributes.Append(iAttribute);
            }

          companiesNode.AppendChild(companyNode);
          }

        xmlDoc.AppendChild(siteNode);

        Result = xmlDoc.OuterXml;
        }
      catch
        {
        // Sink the error
        }

      // Temporary for debugging
      //      Clipboard.Clear();
      //      Clipboard.SetText(xmlDoc.InnerXml);

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    public bool Save()
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      bool Result = false;

      // Format the data as XML
      configXML = FormatAsXML();
      configXML = configXML.Replace("\\", "");

      /*
            // Encrypt and encode the data
            TextLock textLocker = new TextLock(ExchDir);
            string password = ""; // Blank password forces use of default
            Result = textLocker.EncryptString(configXML, password);

            if (!Result)
              {
              }
            else
              {
              string encryptedConfiguration = textLocker.EncryptedString;
      */

      string newKey = System.Text.Encoding.Default.GetString(pepper);
      string encryptedConfiguration = Encryption2.Encrypt(configXML, newKey);

      // Save the data in the specified file

      // The encrypted data is wrapped in a simple XML wrapper
      // <CCGatewayCfg>
      //   <Configuration>
      //     <!-- The Base64 encoded, encrypted configuration goes in here -->
      //   </Configuration>
      // </CCGatewayCfg>

      XmlDocument xmlDoc = new XmlDocument();
      XmlNode rootNode = xmlDoc.CreateElement("CCGatewayCfg");
      xmlDoc.AppendChild(rootNode);

      XmlNode configNode = xmlDoc.CreateElement("Configuration");
      rootNode.AppendChild(configNode);
      configNode.InnerText = encryptedConfiguration;

      XmlAttribute versionAttribute = xmlDoc.CreateAttribute("Version");
      versionAttribute.Value = "2.0";
      configNode.Attributes.Append(versionAttribute);

      // Save it
      xmlDoc.Save(ExchDir + filename);

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    public CompanyConfig FindCompanyByName(string aCompanyName)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      CompanyConfig Result = null;

      foreach (CompanyConfig company in this.companies)
        {
        if (company.name == aCompanyName)
          {
          Result = company;
          }
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
    public CompanyConfig FindCompanyByCode(string aCompanyCode)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      CompanyConfig Result = null;
      foreach (CompanyConfig company in this.companies)
        {
        if (company.code.ToUpper().Trim() == aCompanyCode.ToUpper().Trim())
          {
          Result = company;
          break;
          }
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
    /// Given the name of a PaymentProvider, returns the PaymentProviderID
    /// </summary>
    /// <param name="aCompanyCode"></param>
    /// <param name="aPaymentProvider"></param>
    /// <returns></returns>
    public long GetPaymentProviderId(string aCompanyCode, string aPaymentProvider)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      long Result = 0;

      // Find the current company configuration
      foreach (CompanyConfig company in companies)
        {
        if (company.code.ToUpper().Trim() == aCompanyCode.ToUpper().Trim())
          {
          // Found it
          foreach (SourceConfig source in company.sources)
            {
            if (source.merchantAccount.PaymentProviderDescription.ToLower() == aPaymentProvider.ToLower())
              {
              // Found the payment provider
              Result = source.merchantAccount.PaymentProviderId;
              break;
              }
            }
          break;
          }
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
    /// Given the ID of a PaymentProvider, returns the Payment Provider name
    /// </summary>
    /// <param name="aCompanyCode"></param>
    /// <param name="aPaymentProviderId"></param>
    /// <returns></returns>
    public string GetPaymentProviderName(string aCompanyCode, long aPaymentProviderId)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      string Result = "";

      // Find the current company configuration
      foreach (CompanyConfig company in companies)
        {
        if (company.code.ToUpper().Trim() == aCompanyCode.ToUpper().Trim())
          {
          // Found it
          foreach (SourceConfig source in company.sources)
            {
            if (source.merchantAccount.PaymentProviderId == aPaymentProviderId)
              {
              // Found the payment provider
              Result = source.merchantAccount.PaymentProviderDescription;
              break;
              }
            }
          break;
          }
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
    /// Given a MerchantID, return the Merchant ID name
    /// </summary>
    /// <param name="aCompanyCode"></param>
    /// <param name="aPaymentProviderId"></param>
    /// <returns></returns>
    public string GetMerchantName(string aCompanyCode, long aMerchantId)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      string Result = "";

      // Find the current company configuration
      foreach (CompanyConfig company in companies)
        {
        if (company.code.ToUpper().Trim() == aCompanyCode.ToUpper().Trim())
          {
          // Found it
          foreach (SourceConfig source in company.sources)
            {
            if (source.merchantAccount.MerchantAccountId == aMerchantId)
              {
              // Found the payment provider
              Result = source.merchantAccount.MerchantAccountDescription;
              break;
              }
            }
          break;
          }
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
    public bool IsCCEnabledForCompany(string aCompanyCode)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      bool Result = false;

      // Find the current company configuration
      foreach (CompanyConfig company in companies)
        {
        if (company.code.ToUpper().Trim() == aCompanyCode.ToUpper().Trim())
          {
          Result = company.enabled;
          break;
          }
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
    /// Get the ISO currency from the lookup table
    /// </summary>
    /// <param name="aCompanyCode"></param>
    /// <param name="ExchequerCurrency"></param>
    /// <returns></returns>
    public string GetISOCurrency(string aCompanyCode, string ExchequerCurrency)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      string Result = string.Empty;

      foreach (CompanyConfig company in companies)
        {
        if (company.code.ToUpper().Trim() == aCompanyCode.ToUpper().Trim())
          {
          foreach (CurrencyCodes currency in company.currencies)
            {
            if (currency.ExchequerSymbol == ExchequerCurrency)
              {
              // Get the last 3 characters (or fewer) - the actual ISO code.
              Result = currency.ISOCode.Substring(currency.ISOCode.Length - Math.Min(3, currency.ISOCode.Length));
              break;
              }
            }
          if (Result != "")
            {
            break;
            }
          }
        }

      // PKR. 02/01/2015. ABSEXCH-15976. Last ditch attempt at conversion for common symbols if no translation table has been set up
      if (string.IsNullOrEmpty(Result))
        {
        if ((ExchequerCurrency == "£") || (ExchequerCurrency == "œ"))
          {
          Result = "GBP";
          }

        if (ExchequerCurrency == "$")
          {
          Result = "USD"; // Could be dangerous - symbol used by several countries
          }

        if (ExchequerCurrency == "€")
          {
          Result = "EUR";
          }

        if (ExchequerCurrency == "¥")
          {
          Result = "JPY";
          }
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
    /// Returns the Exchequer currency symbol from the ISO lookup table
    /// </summary>
    /// <param name="isoCurrencyCode"></param>
    /// <returns></returns>
    public string GetExchequerCurrencySymbol(string aCompanyCode, string isoCurrencyCode)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      string Result = string.Empty;

      foreach (CompanyConfig company in companies)
        {
        if (company.code.ToUpper().Trim() == aCompanyCode.ToUpper().Trim())
          {
          foreach (CurrencyCodes currency in company.currencies)
            {
            if (currency.ISOCode == isoCurrencyCode)
              {
              // Get the last 3 characters (or fewer) - the actual ISO code.
              Result = currency.ExchequerSymbol;
              break;
              }
            }

          if (Result != "")
            {
            break;
            }
          }
        }

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return Result;
      }

    //=============================================================================================
    /// <summary>
    /// Applies the Company merchant Account data received from the Portal to the local configuration.
    /// </summary>
    /// <param name="aCompanyCode"></param>
    /// <param name="companyMerchantAccsList"></param>
    public string ApplyUpdates(string aCompanyCode,
                             GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount[] companyMerchantAccsList)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      // PKR. 06/03/2015. Added return string for debug purposes.
      string narrative = string.Empty;

      SourceConfig currSource;

      // Ensure we have some data to work with
      if (companyMerchantAccsList != null)
        {
        if (companyMerchantAccsList.Length > 0)
          {
          // Find the current company configuration to update
          CompanyConfig currCo = null;
          foreach (CompanyConfig coConfig in companies)
            {
            if (coConfig.code == aCompanyCode)
              {
              // Found it
              currCo = coConfig;
              break;
              }
            }

          // We have some data for this company
          // If there is no company record for this company, create one.
          if (currCo == null)
            {
            currCo = new CompanyConfig();
            currCo.code = aCompanyCode;
            currCo.name = aCompanyCode;
            // Add it to the configuration
            companies.Add(currCo);
            }

          // Iterate the returned list of merchant accounts.  There could be deletions as well as additions
          //  so we need to keep the configuration in line with the data in the EPP.
          foreach (GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount merchantAccount in companyMerchantAccsList)
            {
            currSource = null;
            // Look for a match within the current company's list of sources
            foreach (SourceConfig srcConfig in currCo.sources)
              {
              // ABSEXCH-15902. PKR. 05/12/2014. Changed to use MerchantAccountCode instead of Description because Description can change.
              if ((srcConfig.merchantAccount.MerchantAccountCode.Trim().ToUpper() == merchantAccount.MerchantAccountCode.Trim().ToUpper()) &&
                  (srcConfig.merchantAccount.PaymentProviderDescription.Trim().ToUpper() == merchantAccount.PaymentProviderDescription.Trim().ToUpper()))
                {
                // Found it, so update it
                currSource = srcConfig;
                currSource.merchantAccount.MerchantAccountCode = merchantAccount.MerchantAccountCode;
                currSource.merchantAccount.MerchantAccountDescription = merchantAccount.MerchantAccountDescription;
                currSource.merchantAccount.MerchantAccountId = merchantAccount.MerchantAccountId;
                currSource.merchantAccount.PaymentProviderDescription = merchantAccount.PaymentProviderDescription;
                currSource.merchantAccount.PaymentProviderId = merchantAccount.PaymentProviderId;
                break;
                }
              } // end foreach source

            if (currSource == null)
              {
              // Didn't find it, so it must be a new one
              currSource = new SourceConfig();
              currSource.merchantAccount.MerchantAccountCode = merchantAccount.MerchantAccountCode;
              currSource.merchantAccount.MerchantAccountDescription = merchantAccount.MerchantAccountDescription;
              currSource.merchantAccount.MerchantAccountId = merchantAccount.MerchantAccountId;
              currSource.merchantAccount.PaymentProviderDescription = merchantAccount.PaymentProviderDescription;
              currSource.merchantAccount.PaymentProviderId = merchantAccount.PaymentProviderId;

              // Add it to the list
              currCo.sources.Add(currSource);
              }
            } // end foreach merchant account

          // We now need to remove any old sources from the list (i.e. those that are in the configuration,
          //  but don't match any returned by the Payment Portal)
          // Loop backwards so that it doesn't mess up the loop when we delete one

          // Check each source in the config, working from the end of the list to the beginning.
          for (int index = currCo.sources.Count - 1; index >= 0; index--)
            {
            bool matchedSource = false;

            SourceConfig srcConfig = currCo.sources[index];

            // See if we can match this source with one in the downloaded data
            foreach (GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount merchantAccount in companyMerchantAccsList)
              {
              // PKR. 16/03/2015. ABSEXCH-16262 Accounts not being deleted after deleting from the portal.
              // Changed from MerchantAccountId to MerchantAccountCode as this is the only unique value that
              //  is unlikely to change (although it can under some circumstances).
              // NOTE: MerchantAccountCode is simply an encrypted form of the MerchantAccountDescription, so if the user
              //  has their MerchantAccountDescription changed (e.g. after a company name change), then will the code change as well?
              //
              if (srcConfig.merchantAccount.MerchantAccountCode == merchantAccount.MerchantAccountCode)
                {
                // Found a match, so we need to keep this entry
                matchedSource = true;
                break;
                }
              }

            if (!matchedSource)
              {
              // Didn't find a match, so delete the entry from the config
              currCo.sources.RemoveAt(index);
              }
            }
          }
        }
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return narrative;
      }

    //=============================================================================================
    // Some Validation methods
    //=============================================================================================
    /// <summary>
    /// Carries out simple validation of the siteID field.
    /// </summary>
    /// <param name="siteID"></param>
    /// <returns></returns>
    public static bool isValidSiteID(string siteID)
      {
      bool Result = true;

      // Make sure it's the correct length
      if ((siteID.Length != SITE_ID_LENGTH) || (string.IsNullOrEmpty(siteID)))
        {
        Result = false;
        }
      else
        {
        // Make sure it's GUID-like
        // All characters must be hexadecimal or a hyphen. Not case-sensitive.
        if (!ContainsValidCharacters(siteID, "0123456789abcdefABCDEF-"))
          {
          Result = false;
          }
        else
          {
          // Ensure that the format is ########-####-####-####-############
          //                           123456789012345678901234567890123456
          if ((siteID[8] != '-') || (siteID[13] != '-') || (siteID[18] != '-') || (siteID[23] != '-'))
            {
            Result = false;
            }
          }
        }
      return Result;
      }

    /// <summary>
    /// Carry out simple validation on the password field.
    /// Checks length is not 0 or greater than the maximum
    /// </summary>
    /// <param name="password"></param>
    /// <returns></returns>
    public static bool isValidPassword(string password)
      {
      bool Result = true;
      if ((password.Length > SITE_ID_LENGTH) || (string.IsNullOrEmpty(password)))
        {
        Result = false;
        }
      return Result;
      }

    /// <summary>
    /// Test whether the characters of a string are within a set of permissible characters
    /// </summary>
    /// <param name="aTestString"></param>
    /// <param name="validChars"></param>
    /// <returns></returns>
    public static bool ContainsValidCharacters(string aTestString, string validChars)
      {
      foreach (char ch in aTestString)
        {
        if (!validChars.Contains(ch))
          {
          return false;
          }
        }
      return true;
      }

    //=============================================================================================
    /// <summary>
    /// Returns true if the specified company has credit card payments enabled.
    /// Returns false if not enabled, or if company not configured.
    /// </summary>
    /// <param name="aCompanyCode"></param>
    /// <returns></returns>
    public bool CreditCardsEnabledForCompany(string aCompanyCode)
      {
#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Entered " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      bool Result = false;

      // Find the company configuration
      foreach (CompanyConfig company in companies)
        {
        if (company.code.ToUpper().Trim() == aCompanyCode.ToUpper().Trim())
          {
          Result = company.enabled;
          }
        }

#if TDEBUG
      if (dbgForm != null)
        {
        dbgForm.Log("Leaving " + System.Reflection.MethodBase.GetCurrentMethod().Name);
        }
#endif
      return Result;
      }
    }
  }