using System;
using System.Windows.Forms;
using DotNetLibrariesC.Toolkit;
using Enterprise04;
using EnterpriseBeta;

namespace OPTestTk
  {
  public partial class OPTkTestForm1 : Form
    {
    private Enterprise04.IToolkit3 tToolkit;

    public OPTkTestForm1()
      {
      InitializeComponent();
      }

    private void button1_Click(object sender, EventArgs e)
      {
      try
        {
        try
          {
          // Open the toolkit
          tToolkit = new Enterprise04.Toolkit() as IToolkit3;

          //        MessageBox.Show("Start your engines...");

//          ctkDebugLog.StartDebugLog(ref tToolkit);  // Backdoor the toolkit (obfuscated name)
          tToolkit.Configuration.DataDirectory = textExchDir.Text;
          int tkRes = tToolkit.OpenToolkit();

          ITransaction12 theTrans = (tToolkit.Transaction as ITransaction12);
          int Res = theTrans.GetEqual(theTrans.BuildOurRefIndex(textSOR.Text));


          IOrderPaymentTakePayment oPayment = theTrans.TakePayment();

          oPayment.oppGLCode = 2010;
          oPayment.oppCreditCardAction = TCreditCardAction.ccaPayment;

          oPayment.oppPaymentReference = textSOR.Text;

          oPayment.oppCreditCardDetails.ccdAuthorisationNo = "auth number";
          oPayment.oppCreditCardDetails.ccdCardExpiry = "0116";
          oPayment.oppCreditCardDetails.ccdCardNumber = "0006";
          oPayment.oppCreditCardDetails.ccdReferenceNo = "SomeTXCode";
          oPayment.oppCreditCardDetails.ccdCardType = "VISA";

          if (tToolkit.SystemSetup.ssUseCCDept)
            {
            oPayment.oppCostCentre = "AAA";
            oPayment.oppDepartment = "AAA";
            }

          oPayment.oppValue = 12.34;



          (oPayment as IBetaOP).SRCRef = textSRC.Text;
          (oPayment as IBetaOP).SRCTransDate = string.Format("{0:yyyyMMdd}", DateTime.Now);
          (oPayment as IBetaOP).SRCYear = 115;
          (oPayment as IBetaOP).SRCPeriod = 3;

          MessageBox.Show(string.Format("IBetaOP attributes:\r\nRef   : {0}\r\nYear  : {1}\r\nPeriod: {2}\r\nDate  : {3}",
                          (oPayment as IBetaOP).SRCRef, (oPayment as IBetaOP).SRCYear, (oPayment as IBetaOP).SRCPeriod, (oPayment as IBetaOP).SRCTransDate));

          // Don't really want to do this in here...
          //      Res = oPayment.Execute();

/*
          // Create the OP Refund against this transaction
          IOrderPaymentGiveRefund oRefund = theTrans.GiveRefund();

          oRefund.oprCreditCardAction = TCreditCardAction.ccaRefund;

          oRefund.oprCreditCardDetails.ccdAuthorisationNo = "auth number";
          oRefund.oprCreditCardDetails.ccdCardExpiry = "0116";
          oRefund.oprCreditCardDetails.ccdCardNumber = "0006";
          oRefund.oprCreditCardDetails.ccdCardType = "VISA";
          oRefund.oprCreditCardDetails.ccdReferenceNo = "Some Tx Code";

          (oRefund as IBetaOP).SRCRef = textSRC.Text;
          (oRefund as IBetaOP).SRCYear = 115;
          (oRefund as IBetaOP).SRCPeriod = 3;
          (oRefund as IBetaOP).SRCTransDate = string.Format("{0:yyyyMMdd}", DateTime.Now);

          MessageBox.Show(string.Format("IBetaOP attributes:\r\nRef   : {0}\r\nYear  : {1}\r\nPeriod: {2}\r\nDate  : {3}",
                          (oRefund as IBetaOP).SRCRef, (oRefund as IBetaOP).SRCYear, (oRefund as IBetaOP).SRCPeriod, (oRefund as IBetaOP).SRCTransDate));
 */
          }
        catch (Exception ex)
          {
          MessageBox.Show(string.Format("{0}\r\n\r\nStackTrace:\r\n{1}", ex.Message, ex.StackTrace), "Eeeeww! Nasty!");
          }
        }
      finally
        {
        // Close the toolkit
        tToolkit.CloseToolkit();
        }
      }
    }
  }