using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using ExchequerRCTGateway;
using System.Runtime.InteropServices;
using Enterprise04;
using EnterpriseBeta; // Do we need this?
using DotNetLibrariesC.Toolkit; // Toolkit backdoor

namespace TestApp
  {
  public partial class mainform : Form
    {
    public Enterprise04.IToolkit3 tToolkit;


    RCTGateway gateway;
    public mainform()
      {
      InitializeComponent();

      if (tToolkit == null)
        {
        tToolkit = new Enterprise04.Toolkit() as IToolkit3;
        // Backdoor the toolkit
        int val1 = 0, val2 = 0, val3 = 0;
        ctkDebugLog.StartDebugLog(ref val1, ref val2, ref val3); // Backdoor the toolkit (renamed for obfuscation)
        tToolkit.Configuration.SetDebugMode(val1, val2, val3);
        }

      Enterprise04.ICompanyManager coManager = tToolkit.Company;
      int nCos = coManager.cmCount;

      for (int index = 1; index <= nCos; index++)
        {
        mcmCombo.Items.Add(new MCMComboBoxItem(coManager.cmCompany[index].coName, coManager.cmCompany[index].coCode.Trim(), coManager.cmCompany[index].coPath));
        }
//      if (mcmCombo.Items.Count > 0)
//        {
//        mcmCombo.SelectedIndex = 0;
//        }
      }

    // Callback function
    public void myCallBack()
      {
      }

    public void myLogger(string aMessage)
      {
      string msg = aMessage;

      dbgLog.AppendText(msg + "\r\n");
      }


    private void createGatewayBtn_Click(object sender, EventArgs e)
      {
      gateway = new RCTGateway(myLogger);
      }

    private void btnAddTrans_Click(object sender, EventArgs e)
      {
      // Add a transaction to the batch
      int selIndex = transListBox.SelectedIndex;
      if (selIndex >=0)
        {
        string ourRef = transListBox.SelectedItem.ToString();

        rctTransList.Items.Add(ourRef);
        transListBox.Items.RemoveAt(selIndex);
        }

      if (transListBox.Items.Count == 0)
        {
        btnAddTrans.Enabled = false;
        }
      
      btnSubmit.Enabled = rctTransList.Items.Count > 0;
      }

    private void mcmCombo_SelectedIndexChanged(object sender, EventArgs e)
      {
      Cursor.Current = Cursors.WaitCursor;
      if (mcmCombo.SelectedIndex >= 0)
        {
        // Get the outstanding purchase orders from Exchequer
        transListBox.Items.Clear();

        long Res;
        if (tToolkit.Status != TToolkitStatus.tkOpen)
          {
          int index = mcmCombo.SelectedIndex;
          MCMComboBoxItem selItem = mcmCombo.Items[index] as MCMComboBoxItem;
          tToolkit.Configuration.DataDirectory = selItem.companyPath;
          Res = tToolkit.OpenToolkit();
          gateway.StartBatch(myCallBack, selItem.companyCode);
          }
        tToolkit.Transaction.Index = Enterprise04.TTransactionIndex.thIdxOurRef;
        string sKey = tToolkit.Transaction.BuildOurRefIndex("POR");
        Res = tToolkit.Transaction.GetGreaterThanOrEqual(sKey);
        while (Res == 0)
          {
          if (tToolkit.Transaction.thOurRef.StartsWith("POR"))
            {
            transListBox.Items.Add(tToolkit.Transaction.thOurRef);
            }

          Res = tToolkit.Transaction.GetNext();
          }
        tToolkit.CloseToolkit();

        btnAddTrans.Enabled = true;
        }
      Cursor.Current = Cursors.Default;
      }

    private void transListBox_SelectedIndexChanged(object sender, EventArgs e)
      {
      btnAddTrans.Enabled = true;
      }

    private void btnRemove_Click(object sender, EventArgs e)
      {
      // Add a transaction to the batch
      int selIndex = rctTransList.SelectedIndex;
      if (selIndex >= 0)
        {
        string ourRef = rctTransList.SelectedItem.ToString();

        transListBox.Items.Add(ourRef);
        rctTransList.Items.RemoveAt(selIndex);
        }

      if (rctTransList.Items.Count == 0)
        {
        btnRemove.Enabled = false;
        }
      btnSubmit.Enabled = rctTransList.Items.Count > 0;
      }

    private void rctTransList_SelectedIndexChanged(object sender, EventArgs e)
      {
      if (rctTransList.SelectedIndex >= 0)
        {
        btnRemove.Enabled = true;
        }
      }

    private void btnSubmit_Click(object sender, EventArgs e)
      {
      dbgLog.AppendText("Submit not yet implemented\r\n");
      }
    }

  public class MCMComboBoxItem
    {
    public string companyName;
    public string companyCode;
    public string companyPath;

    public MCMComboBoxItem(string coName, string coCode, string coPath)
      {
      companyName = coName;
      companyCode = coCode;
      companyPath = coPath;
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

  }
