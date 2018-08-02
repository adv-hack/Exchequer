using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Exchequer.Payments.Portal.COM.Client;
using Exchequer.Payments.Portal.COM.Client.PaymentServices;
using Exchequer.Payments.Services.Security;

namespace PaymentGatewayAddin
  {
  public class CompanyMerchantAccount
    {
    public long PaymentProviderId { get; set; }
    public string PaymentProviderDescription { get; set; }
    public long MerchantAccountId { get; set; }
    public string MerchantAccountCode { get; set; }
    public string MerchantAccountDescription { get; set; }
    }
  
  
  class StubGatewayClass
    {
    public void RegisterTransaction(GatewayCOMObject.GatewayCOMClass.Credentials credentials,
                                    ShoppingBasket shoppingBasket,
                                    out string authTicket,
                                    out string gatewayTransactionGuid)
      {
      // Display Form to allow editing of response
      StubGatewayForm stubForm = new StubGatewayForm();
      stubForm.tabControl.SelectedIndex = 0;

      stubForm.textSiteId.Text = credentials.SiteIdentifier;
      stubForm.textCompany.Text = credentials.Company;
      stubForm.textPassword.Text = credentials.Password;

      stubForm.textAuthTicket.Text = ""; // Need to populate this with something - probably random
      authTicket = stubForm.textAuthTicket.Text;

      stubForm.textTransGUID.Text = Guid.NewGuid().ToString();
      gatewayTransactionGuid = stubForm.textTransGUID.Text;

      // Display the contents of the shopping basket
      // Header
      stubForm.textContactName.Text = shoppingBasket.ContactName;
      stubForm.textEmail.Text = shoppingBasket.ContactEmailAddress;
      stubForm.textPhone.Text = shoppingBasket.ContactTelephone;
      stubForm.textCurrencyCode.Text = shoppingBasket.CurrencyCode;
      stubForm.textBAddr1.Text = shoppingBasket.BillingAddressLine1;
      stubForm.textBAddr2.Text = shoppingBasket.BillingAddressLine2;
      stubForm.textBTown.Text = shoppingBasket.BillingAddressTown;
      stubForm.textBCounty.Text = shoppingBasket.BillingAddressCounty;
      stubForm.textBPostcode.Text = shoppingBasket.BillingAddressPostcode;
      stubForm.textBCountry.Text = shoppingBasket.BillingAddressCountry;
      stubForm.textDAddr1.Text = shoppingBasket.DeliveryAddressLine1;
      stubForm.textDAddr2.Text = shoppingBasket.DeliveryAddressLine2;
      stubForm.textDTown.Text = shoppingBasket.DeliveryAddressTown;
      stubForm.textDCounty.Text = shoppingBasket.DeliveryAddressCounty;
      stubForm.textDPostcode.Text = shoppingBasket.DeliveryAddressPostcode;
      stubForm.textDCountry.Text = shoppingBasket.DeliveryAddressCountry;
      stubForm.textMerchantAccount.Text = shoppingBasket.MerchantAccountId.ToString();
      stubForm.textPaymentProvider.Text = shoppingBasket.PaymentProviderId.ToString();

      // Items
      foreach (ShoppingBasketItem sbItem in shoppingBasket.Items)
        {
        ListViewItem item1 = new ListViewItem(sbItem.ProductId);
        item1.SubItems.Add(sbItem.Quantity.ToString());
        item1.SubItems.Add(sbItem.UnitNetPrice.ToString());
        item1.SubItems.Add(sbItem.LineNetPrice.ToString());
        item1.SubItems.Add(sbItem.LineVatPrice.ToString());
        item1.SubItems.Add(sbItem.VatCode);
        item1.SubItems.Add(sbItem.VatMultiplier.ToString());
        }
      }

    //---------------------------------------------------------------------------------------------
    public void CheckTransactionStatus(string authTicket,
                                string vendorTxCode,
                                out GatewayTransactionView paymentTransaction)
      {
      // Display Form to allow editing of response
      StubGatewayForm stubForm = new StubGatewayForm();
      stubForm.tabControl.SelectedIndex = 2;

      paymentTransaction = new GatewayTransactionView();

      paymentTransaction.CreatedDateTime = DateTime.Now;
      paymentTransaction.Description = "";
      paymentTransaction.GatewayStatusId = 0;
      paymentTransaction.GatewayTransactionCurrency = "GBP";
      paymentTransaction.GatewayTransactionGrossAmount = 0.00M;
      paymentTransaction.GatewayTransactionId = 0;
      paymentTransaction.GatewayTransactionTypeId = 0;
      paymentTransaction.GatewayUserCompanyId = 0;
      paymentTransaction.GatewayUserCompanyMerchantAccountId = 0;
      paymentTransaction.GatewayUserCompanyPaymentProviderId = 0;
      paymentTransaction.GatewayVendorAtsData = "";
      paymentTransaction.GatewayVendorCardExpiryDate = "";
      paymentTransaction.GatewayVendorCardLast4Digits = "";
      paymentTransaction.GatewayVendorCardType = "";
      paymentTransaction.GatewayVendorSecurityKey = "";
      paymentTransaction.GatewayVendorTxAuthNo = "";
      paymentTransaction.GatewayVendorTxCode = "";
      paymentTransaction.GatewayVendorVPSTxId = "";
      paymentTransaction.IsError = false;
      paymentTransaction.ServiceName = "";
      paymentTransaction.ServiceResponse = "";
      paymentTransaction.TypeName = "";
      paymentTransaction.VendorTypeName = "";
      }

    //---------------------------------------------------------------------------------------------
    public void RegisterTransactionCardToken(GatewayCOMObject.GatewayCOMClass.Credentials credentials,
                                      string ourRef,
                                      string currencyCode,
                                      long paymentProviderId,
                                      long merchantAccountId)
      {
      // Display Form to allow setting of response
      StubGatewayForm stubForm = new StubGatewayForm();
      stubForm.tabControl.SelectedIndex = 0;

      }

    //---------------------------------------------------------------------------------------------
    public void UpdateTransactionContent(GatewayCOMObject.GatewayCOMClass.Credentials credentials,
                                  string gatewayTransactionGuid,
                                  string receiptReference,
                                  string customData)
      {
      }

    //---------------------------------------------------------------------------------------------
    public void GetCompanyMerchantAccounts(GatewayCOMObject.GatewayCOMClass.Credentials credentials,
                                    out GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount[] companyMerchantAccountsList)
      {
      // Display form to allow data to be edited

      companyMerchantAccountsList = null;

      List<GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount> list = new List<GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount>();

      string authTicket = "";

      if (authTicket != null)
        {
/*
        foreach (var account in results)
          {
          list.Add(new CompanyMerchantAccount
            {
            PaymentProviderId = account.PaymentProviderId,
            PaymentProviderDescription = account.PaymentProviderDescription,
            MerchantAccountId = account.MerchantAccountId,
            MerchantAccountCode = account.MerchantAccountCode,
            MerchantAccountDescription = account.MerchantAccountDescription
            });
          }
*/
        companyMerchantAccountsList = new GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount[list.Count];
        companyMerchantAccountsList = list.ToArray<GatewayCOMObject.GatewayCOMClass.CompanyMerchantAccount>();
        }
      }


    //---------------------------------------------------------------------------------------------
    public void GetProcessedTransactionsByDateRange(GatewayCOMObject.GatewayCOMClass.Credentials credentials,
                                             DateTime startDate,
                                             DateTime endDate,
                                             int pageNumber,
                                             out Exchequer.Payments.Portal.COM.Client.GatewayCOMObject.GatewayCOMClass.PagedTransactionResponse response)
      {
      response = new GatewayCOMObject.GatewayCOMClass.PagedTransactionResponse();

      MessageBox.Show("Stub of GetProcessedTransactionsByDateRange not yet implemented");
      }
    }
  }
