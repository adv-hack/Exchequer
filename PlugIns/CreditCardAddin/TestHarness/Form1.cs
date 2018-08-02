using System;
using System.Windows.Forms;
using ExchequerPaymentGateway;
using PaymentGatewayAddin;
using Enterprise04;

namespace TestHarness
  {
  public partial class Form1 : Form
    {
    private string currentCompany;
    PaymentGateway gateway;

    private const string configFilename = "CCGatewayCfg.dat";

    public Form1()
      {
      InitializeComponent();

      gateway = new PaymentGateway();
      }

    private void btnCompanies_Click(object sender, EventArgs e)
      {
      }

    private void btnConfig_Click_1(object sender, EventArgs e)
      {
      gateway.DisplayConfigurationDialog(this.Handle.ToInt32(), currentCompany, "Fred", chkSuperUser.Checked);
      }

    private void Form1_Load(object sender, EventArgs e)
      {
//      currentCompany = "FIVE5 ";
      currentCompany = "ZZZZ01";
      }

    private void button1_Click(object sender, EventArgs e)
      {
      PaymentGateway gateway = new PaymentGateway();
      gateway.SetParentHandle((int)this.Handle);
      }
    }
  }