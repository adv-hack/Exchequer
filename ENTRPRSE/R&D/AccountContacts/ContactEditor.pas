unit ContactEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, TEditVal,
  ContactsManager, CheckLst, EnterToTab;

type
  TContactEditorFrm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    pnlOwnAddress: TPanel;
    lblAddress1: TLabel;
    lblPostCode: TLabel;
    chkHasOwnAddress: TCheckBox;
    btnCancel: TButton;
    btnOk: TButton;
    Label6: TLabel;
    rolesList: TCheckListBox;
    EnterToTab1: TEnterToTab;
    lstCountry: TSBSComboBox;
    lblCountry: TLabel;
    lblAddress2: TLabel;
    lblAddress3: TLabel;
    lblAddress4: TLabel;
    lblAddress5: TLabel;
    edtContactName: Text8Pt;
    edtContactJobTitle: Text8Pt;
    edtContactTelephone: Text8Pt;
    edtContactFax: Text8Pt;
    edtContactEmail: Text8Pt;
    edtContactAddr1: Text8Pt;
    edtContactAddr2: Text8Pt;
    edtContactAddr3: Text8Pt;
    edtContactAddr4: Text8Pt;
    edtContactAddr5: Text8Pt;
    edtContactPostCode: Text8Pt;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure chkHasOwnAddressClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rolesListDblClick(Sender: TObject);
  private
    { Private declarations }
    oContact          : TAccountContact;
    fEditMode         : TEditModes;
    fContactManager   : TContactsManager;
    // MH 09/01/2014 v7.1 ABSEXCH-16008: Default the Country Code when adding a new role
    FDefaultCountry   : ShortString;
  public
    { Public declarations }
    // MH 09/01/2014 v7.1 ABSEXCH-16008: Default the Country Code when adding a new role
    Property DefaultCountry : ShortString Read FDefaultCountry Write FDefaultCountry;
    //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Changed to CreateEx so as not to hide ancester constructor
    constructor CreateEx(AOwner: TComponent;
                       const aEditMode : TEditModes;
                       var aContact    : TAccountContact;
                       oContactManager : TContactsManager;
                       aCustFormMode   : integer);
    procedure SetDisplayProperties(aContainer : TWinControl; aBGColour : TColor; aFont : TFont);
  end;

implementation

uses
  oContactRoleBtrieveFile,
  ConsumerUtils,
  // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  CountryCodeUtils, CountryCodes,
  // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom labelling for address fields
  CustomFieldsIntf;

{$R *.dfm}

//------------------------------------------------------------------------------
// PKR. 06/11/2013. Added customer from mode so that we know whether this is
//  being used with a Customer list or a Supplier list, which is required for
//  filtering the available roles.
//PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Changed to CreateEx so as not to hide ancester constructor
constructor TContactEditorFrm.CreateEx(AOwner: TComponent;
                                     const aEditMode : TEditModes;
                                     var aContact    : TAccountContact;
                                     oContactManager : TContactsManager;
                                     aCustFormMode   : integer);
const
  checkYOffset = 20;
var
  index        : integer;
  index2       : integer;
  oRole        : ContactRoleRecType;
  nRoles       : integer;
begin
  inherited Create(AOwner);  // Ensure the underlying form class is created

  fEditMode := aEditMode;
  // Create a reference to the input contact record
  oContact  := aContact;

  fContactManager := oContactManager;
  Name := 'RoleEditForm';

  // MH 09/01/2014 v7.1 ABSEXCH-16008: Default the Country Code when adding a new role
  FDefaultCountry := '';

  // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  LoadCountryCodes (lstCountry);
  lstCountry.MaxListWidth := lstCountry.Width;
  lstCountry.Items.Assign(lstCountry.ItemsL);

  // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom labelling for address fields
  SetUDFCaptions([lblAddress1, lblAddress2, lblAddress3, lblAddress4, lblAddress5], cfAddressLabels);

  // Populate the list of available roles for this Contact
  rolesList.Clear;

  // First add any Roles that are already assigned to this Contact
  if Length(oContact.assignedRoles) > 0 then
  begin
    for index := Low(oContact.assignedRoles) to High(oContact.assignedRoles) do
    begin
      // Add the Role to the list
      index2 := rolesList.Items.Add(oContact.assignedRoles[index].crRoleDescription);
      // Check it, because it is assigned.
      rolesList.Checked[index2] := true;
    end;
  end;

  // Now add any remaining available roles
  nRoles := fContactManager.GetNumRoles;
  for index := 0 to nRoles-1 do
  begin
    oRole := fContactManager.GetRole(index);

    // Ensure that it's not already in the list.
    if rolesList.Items.IndexOf(oRole.crRoleDescription) < 0 then
    begin
      // Make sure that it applies to the current contact type (cust/supp)
      if ((oRole.crRoleAppliesToCustomer) and (aCustFormMode = ConsumerUtils.CUSTOMER_TYPE)) or
         ((oRole.crRoleAppliesToSupplier) and (aCustFormMode = ConsumerUtils.SUPPLIER_TYPE)) then
      begin
        // Applies to this contact type

        // PKR. 22/01/2014. Can now assign roles to multiple contacts, so the
        //  filter has been removed.
        rolesList.Items.Add(oRole.crRoleDescription);
        // Don't check this one as it is only an available Role - not assigned
      end;
    end;
  end;

  // Fill in the contact fields if we're in Edit or View Mode.  leave blank otherwise.
  case fEditMode of
    emEdit,
    emView:
      begin
        edtContactName.Text      := oContact.contactDetails.acoContactName;
        edtContactJobTitle.Text  := oContact.contactDetails.acoContactJobTitle;
        edtContactTelephone.Text := oContact.contactDetails.acoContactPhoneNumber;
        edtContactFax.Text       := oContact.contactDetails.acoContactFaxNumber;
        edtContactEmail.Text     := oContact.contactDetails.acoContactEmailAddress;
        edtContactAddr1.Text     := oContact.contactDetails.acoContactAddress[1];
        edtContactAddr2.Text     := oContact.contactDetails.acoContactAddress[2];
        edtContactAddr3.Text     := oContact.contactDetails.acoContactAddress[3];
        edtContactAddr4.Text     := oContact.contactDetails.acoContactAddress[4];
        edtContactAddr5.Text     := oContact.contactDetails.acoContactAddress[5];
        edtContactPostCode.Text  := oContact.contactDetails.acoContactPostCode;
        // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
        lstCountry.ItemIndex     := ISO3166CountryCodes.IndexOf(ifCountry2, oContact.contactDetails.acoContactCountry);
        // If any of the address fields are populated, then enable the address fields
        chkHasOwnAddress.Checked := (edtContactAddr1.Text <> '') or
                                    (edtContactAddr2.Text <> '') or
                                    (edtContactAddr3.Text <> '') or
                                    (edtContactAddr4.Text <> '') or
                                    (edtContactAddr5.Text <> '') or
                                    (edtContactPostCode.Text <> '') Or
                                    // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
                                    (lstCountry.ItemIndex <> -1);

        if fEditMode = emEdit then
          Caption := 'Edit Roles - ' + oContact.contactDetails.acoContactName
        else
          Caption := 'View Roles - ' + oContact.contactDetails.acoContactName;
                                  
        edtContactName.Readonly      := (aEditMode = emView);
        edtContactJobTitle.Readonly  := (aEditMode = emView);
        edtContactTelephone.Readonly := (aEditMode = emView);
        edtContactFax.Readonly       := (aEditMode = emView);
        edtContactEmail.Readonly     := (aEditMode = emView);
        edtContactAddr1.Readonly     := (aEditMode = emView);
        edtContactAddr2.Readonly     := (aEditMode = emView);
        edtContactAddr3.Readonly     := (aEditMode = emView);
        edtContactAddr4.Readonly     := (aEditMode = emView);
        edtContactAddr5.Readonly     := (aEditMode = emView);
        edtContactPostCode.Readonly  := (aEditMode = emView);
        // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
        lstCountry.Readonly          := (aEditMode = emView);
        // PKR. 19/02/2014. ABSEXCH-15059. Respect Password control of editing Roles/Contacts
        // View mode has been reinstated so that a non-privileged user can view, but not edit, a contact's details.
        rolesList.Enabled            := (aEditMode <> emView);
      end;
    emAdd:
      begin
        Caption := 'New Roles Contact';

        edtContactName.Text      := '';
        edtContactJobTitle.Text  := '';
        edtContactTelephone.Text := '';
        edtContactFax.Text       := '';
        edtContactEmail.Text     := '';
        edtContactAddr1.Text     := '';
        edtContactAddr2.Text     := '';
        edtContactAddr3.Text     := '';
        edtContactAddr4.Text     := '';
        edtContactAddr5.Text     := '';
        edtContactPostCode.Text  := '';
        // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
        lstCountry.ItemIndex     := -1;
        // If any of the address fields are populated, then enable the address fields
        chkHasOwnAddress.Checked := (edtContactAddr1.Text <> '') or
                                    (edtContactAddr2.Text <> '') or
                                    (edtContactAddr3.Text <> '') or
                                    (edtContactAddr4.Text <> '') or
                                    (edtContactAddr5.Text <> '') or
                                    (edtContactPostCode.Text <> '');
      end;
    end;
  // Enable the OK button if in Edit or Add mode.
  btnOk.Enabled := (fEditMode <> emView);
end;

//------------------------------

procedure TContactEditorFrm.FormCreate(Sender: TObject);
begin
  // DO NOT USE - Use overriden Constructor above
end;

//------------------------------------------------------------------------------
// Handle a click on the cancel button
procedure TContactEditorFrm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

//------------------------------------------------------------------------------
// Handle a click on the OK button.
procedure TContactEditorFrm.btnOkClick(Sender: TObject);
var
  index     : integer;
  index2    : integer;
  rolename  : string;
  theRole   : ContactRoleRecType;
  valResult : TContactValidationCodes;
begin
  // Copy the data to the record
  // PKR.07/02/2014.  Moved assignment of Account Code to here.
  oContact.contactDetails.acoAccountCode         := fContactmanager.GetAccountID;

  oContact.contactDetails.acoContactName         := edtContactName.Text;
  oContact.contactDetails.acoContactJobTitle     := edtContactJobTitle.Text;
  oContact.contactDetails.acoContactPhoneNumber  := edtContactTelephone.Text;
  oContact.contactDetails.acoContactFaxNumber    := edtContactFax.Text;
  oContact.contactDetails.acoContactEmailAddress := edtContactEmail.Text;
  oContact.contactDetails.acoContactHasOwnAddress := chkHasOwnAddress.Checked;
  oContact.contactDetails.acoContactAddress[1]   := edtContactAddr1.Text;
  oContact.contactDetails.acoContactAddress[2]   := edtContactAddr2.Text;
  oContact.contactDetails.acoContactAddress[3]   := edtContactAddr3.Text;
  oContact.contactDetails.acoContactAddress[4]   := edtContactAddr4.Text;
  oContact.contactDetails.acoContactAddress[5]   := edtContactAddr5.Text;
  oContact.contactDetails.acoContactPostCode     := edtContactPostCode.Text;
  // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  If (lstCountry.ItemIndex >= 0) Then
    oContact.contactDetails.acoContactCountry    := ISO3166CountryCodes.ccCountryDetails[lstCountry.ItemIndex].cdCountryCode2
  Else
    oContact.contactDetails.acoContactCountry    := '  ';

  // Update the contact's assigned roles
  SetLength(oContact.assignedRoles, 0);
  for index := 0 to rolesList.Items.Count -1 do
  begin
    rolename := rolesList.Items[index];

    // Get the Id of the Role
    theRole := fContactManager.GetRoleByDescription(roleName);

    // This record isn't in the ContactsManager, so we have to add the
    //  assigned roles locally.
    if rolesList.Checked[index] then
    begin
      // Assign the Role to this contact
      SetLength(oContact.assignedRoles, Length(oContact.assignedRoles)+1);
      index2 := High(oContact.assignedRoles);
      oContact.assignedRoles[index2].crRoleId := theRole.crRoleId;
      oContact.assignedRoles[index2].crRoleDescription := theRole.crRoleDescription;
      oContact.assignedRoles[index2].crRoleAppliesToCustomer := theRole.crRoleAppliesToCustomer;
      oContact.assignedRoles[index2].crRoleAppliesToSupplier := theRole.crRoleAppliesToSupplier;
    end;
  end;

  // Validate the record
  valResult := fContactmanager.ValidateContact(oContact, fEditMode);

  case valResult of
    cvOK:
      begin
        // Successfully validated
        ModalResult := mrOk;
      end;

    cvMissingName:
      begin
        ShowMessage('Contact Name must not be blank');
        edtContactName.SetFocus;
      end;

    cvNameNotUnique:
      begin
        ShowMessage('A contact with that name already exists.');
        edtContactName.SetFocus;
      end;

    cvInvalidEmailAddress:
      begin
        ShowMessage('Invalid email address');
        edtContactEmail.SetFocus;
      end;

    cvAccountNotFound:
      begin
        ShowMessage('Account not found');
        edtContactEmail.SetFocus;
      end;

    cvIncorrectAccountCode:
      begin
        ShowMessage('Incorrect account code');
        edtContactEmail.SetFocus;
      end;

    cvInvalidAccountType:
      begin
        ShowMessage('Invalid account type');
        edtContactEmail.SetFocus;
      end;

    cvIncorrectRoleForAccountType:
      begin
        ShowMessage('Invalid role for account type');
        edtContactEmail.SetFocus;
      end;

    cvInvalidCountry:
      begin
        ShowMessage('The Country must be specified');
        lstCountry.SetFocus;
      end;
  end;
end;


//------------------------------------------------------------------------------
// If the user checks the Own Address box, then enable the address fields.
procedure TContactEditorFrm.chkHasOwnAddressClick(Sender: TObject);
begin
  // Enable/disable the fields.
  pnlOwnAddress.Enabled      := chkHasOwnAddress.Checked;
  edtContactAddr1.Enabled    := chkHasOwnAddress.Checked;
  edtContactAddr2.Enabled    := chkHasOwnAddress.Checked;
  edtContactAddr3.Enabled    := chkHasOwnAddress.Checked;
  edtContactAddr4.Enabled    := chkHasOwnAddress.Checked;
  edtContactAddr5.Enabled    := chkHasOwnAddress.Checked;
  edtContactPostCode.Enabled := chkHasOwnAddress.Checked;

  // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  lstCountry.Enabled         := chkHasOwnAddress.Checked;
  // MH 09/01/2014 v7.1 ABSEXCH-16008: Default the Country Code when adding a new role
  If (lstCountry.ItemIndex = -1) And (FDefaultCountry <> '') Then
    lstCountry.ItemIndex := ISO3166CountryCodes.IndexOf(ifCountry2, FDefaultCountry);

  // Enable/disable the labels.
  lblAddress1.Enabled        := chkHasOwnAddress.Checked;
  lblAddress2.Enabled        := chkHasOwnAddress.Checked;
  lblAddress3.Enabled        := chkHasOwnAddress.Checked;
  lblAddress4.Enabled        := chkHasOwnAddress.Checked;
  lblAddress5.Enabled        := chkHasOwnAddress.Checked;
  lblPostCode.Enabled        := chkHasOwnAddress.Checked;
  lblCountry.Enabled         := chkHasOwnAddress.Checked;
end;

//------------------------------------------------------------------------------
// PKR. 23/01/2014.
// Sets the background colour and font of fields on the form
procedure TContactEditorFrm.SetDisplayProperties(aContainer : TWinControl; aBGColour : TColor; aFont : TFont);
var
  index : integer;
begin
  // Loop through all the components on this form
  if aContainer.ControlCount > 0 then
  begin
    for index := 0 to aContainer.ComponentCount-1 do
    begin
      if not (aContainer.Components[index] is TLabel) then
      begin
        // NB. If other component types are added, this will have to be extended.
        if aContainer.Components[index] is TEdit then
        begin
          (aContainer.Components[index] as TEdit).Color := aBGColour;
          (aContainer.Components[index] as TEdit).Font  := aFont;
        end
        Else if aContainer.Components[index] is TCheckListBox then
        begin
          (aContainer.Components[index] as TCheckListBox).Color := aBGColour;
          (aContainer.Components[index] as TCheckListBox).Font  := aFont;
        end
        Else if aContainer.Components[index] is TSBSComboBox then
        begin
          (aContainer.Components[index] as TSBSComboBox).Color := aBGColour;
          (aContainer.Components[index] as TSBSComboBox).Font  := aFont;
        end;
      end;
    end;
  end;
end;

// PKR. 04/11/2015. ABSEXCH-15094. Selection of Role is not consistent with the
// rest of Exchequer.
// Double-click on the role title now toggles the check-box.
procedure TContactEditorFrm.rolesListDblClick(Sender: TObject);
var
  index : integer;
begin
  // Double-clicked an item in the list, so we want to toggle its checked state.
  index := rolesList.ItemIndex;
  rolesList.Checked[index] := not rolesList.Checked[index];
end;

end.
