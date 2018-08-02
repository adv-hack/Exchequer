unit CustRolesFrame;

// PKR. October 2013.  - MRD 7.X Item 2.4 - Ledger Multi-Contacts
// Allows multiple contacts on an account.
// Allows Roles to be assigned to Contacts.

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, InspectorBar, ComCtrls, 

  VarConst,
  
  oContactRoleBtrieveFile,
  oAccountContactRoleBtrieveFile,
  oAccountContactBtrieveFile,
  
  ContactsManager,
  ContactsManagerSQL,
  ContactsManagerPerv,

  EntWindowSettings;

Const
  // Constant for the number of pixels to leave as a border when painting the details
  Margin = 4;
  // Number of pixels to leave between fields on a row, e.g. Name and Phone Number
  InterFieldGap = 20;
  // Number of pixels to leave between Role fields on a row
  InterRoleGap = 10;

  success = 0;

  addContactId = -1;

  CRLF = chr(13) + chr(10);
type
  //----------------------------------------------------------------------------
  TRolePositionDetail = Class(TObject)
  Private
    FRoleText : ShortString;
    FLeft : Integer;
    FWidth : Integer;
  Public
    Property RoleText : ShortString Read FRoleText;
    Property Left : Integer Read FLeft;
    Property Width : Integer Read FWidth Write FWidth;

    Constructor Create (Const RoleText : ShortString; Const Left, Width : Integer);
  End; // TRolePositionDetail

  //----------------------------------------------------------------------------
  // This class is ex-MH.  Might change later.
  // Class to hold row specific data, e.g. co-ordinates, to make things easier 
  //  for mouse clicks, etc...
  TListRowData = Class(TObject)
  Private
    FEmailRect : TRect;
  Public
    Property lrdEmailRect : TRect Read FEmailRect Write FEmailRect;
    Constructor Create;
  End; // TListRowData

  //----------------------------------------------------------------------------
  // This class is ex-MH.
  TRoleRowPositions = class(TObject)
  private
    // Reference to parent AccountContact needed to pickup the roles
    FAccountContact : TAccountContact;
    // Stores a list of the rows
    FRows : TList;

    // How to store the rows / positions
    //
    // for each item we need to store:-
    //
    //   Text description of role
    //   left
    //   width
    //
    function GetrrpRowCount : Integer;
    function GetRowText (Index : Integer) : ANSIString;
    function GetRowRoles(Index : Integer) : TList;

    // Adds a new row into the rows array
    procedure AddNewRow;
    // Adds a new role into the last row of the rows array
    procedure AddToRow(const RoleDetail : TRolePositionDetail);
  public
    // Returns the number of rows needed to display the fields
    property rrpRowCount : Integer read GetrrpRowCount;
    // Returns all the text required on a row for height calculation purposes
    property rrpRowText[index : Integer] : ANSIString read GetRowText;
    // Returns a list of Roles for the specified row
    property rrpRowRoles[index : Integer] : TList read GetRowRoles;

    constructor Create(const AccountContact : TAccountContact);
    destructor Destroy; override;

    // Runs through the Roles for the parent Account Contact and works out
    // how many rows would be needed to display them all and the position of each one
    procedure CalculateRowsForWidth(ClientCanvas : TCanvas;
                                    const ClientAreaWidth : Integer;
                                    aRolelabelSize : TSize);
  end; // TRoleRowPositions

  //----------------------------------------------------------------------------
  TframeCustRoles = class(TFrame)
    pnlRoleList: TPanel;
    lbContacts: TListBox;
    pnlRoles: TPanel;
    popupContactRole: TPopupMenu;
    puAssignRole: TMenuItem;
    puUnassignRole: TMenuItem;
    popupUnassignedRoles: TPopupMenu;
    popupAssignRole: TMenuItem;
    roleScroll: TScrollBox;
    uRolesCaption: TPanel;
    lblUnassignedRoles: TLabel;
    N1: TMenuItem;
    ContactPopupAdd: TMenuItem;
    ContactPopupEdit: TMenuItem;
    ContactPopupDelete: TMenuItem;
    puSendEmail: TMenuItem;
    procedure lbContactsMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure lbContactsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbContactsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlRoleListResize(Sender: TObject);
    procedure popupContactRolePopup(Sender: TObject);
    procedure lbContactsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AssignRoleClick(Sender: TObject);
    procedure UnassignRoleClick(Sender: TObject);
    procedure lbContactsClick(Sender: TObject);
    procedure lbContactsDblClick(Sender: TObject);
    procedure popupUnassignedRolesPopup(Sender: TObject);
    procedure popupAssignRoleClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure ContactPopupAddClick(Sender: TObject);
    procedure ContactPopupEditClick(Sender: TObject);
    procedure ContactPopupDeleteClick(Sender: TObject);
    procedure lbContactsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure puSendEmailClick(Sender: TObject);
  private
    { Private declarations }
    // PKR. 19/02/2014. ABSEXCH-15059. Respect password settings for Roles.
    fCanEditContacts : Boolean;

    oContactManager : TContactsManager;
    customerCode    : string;
	// MH 09/01/2014 v7.1 ABSEXCH-16008: Default the Country Code when adding a new role
    CustomerCountryCode : ShortString;
    custFormMode    : byte;
    FSettings       : IWindowSettings;
    roleBoxSize     : TSize;

    procedure DisplayAvailableRolesList; // Put the roles on display
    procedure DisplayContactList;        // Put the contacts on display
    procedure BuildPopupRoleMenus;
    function  ListBoxWidth : Integer;
  public
    { Public declarations }
    parentForm : TForm;

    constructor Create(AOwner : TComponent) ; override;
    Destructor  Destroy; override;

    procedure SetCustomerRecord(const aCustCode, aCountry : string);
    procedure SetCustFormMode(aMode : byte);
    procedure SetCanEditContacts(canEdit : Boolean);

    procedure DeleteCurrentContact;
    procedure EditCurrentContact;
    procedure ViewCurrentContact;
    // MH 09/01/2014 v7.1 ABSEXCH-16008: Default the Country Code when adding a new role
    procedure AddNewContact;

    procedure CalcRoleBoxSize;

    //PR: 14/02/2014 ABSEXCH-15038 Allow access to ContactsManager from CustR3U
    property ContactsManager : TContactsManager read oContactManager;
  end;

implementation

{$R *.dfm}
Uses
  APIUtil,
  SQLUtils, 
  // Needed for SetDrive
  GlobVar,
  ContactEditor,
  ConsumerUtils,
  StrUtil,
  CustR3U;

//==============================================================================
// TRolePositionDetail
//==============================================================================
Constructor TRolePositionDetail.Create (Const RoleText : ShortString; 
                                        Const Left, Width : Integer);
Begin // Create
  Inherited Create;

  FRoleText := RoleText;
  FLeft := Left;
  FWidth := Width;
End; // Create

//==============================================================================
// TListRowData
//==============================================================================
Constructor TListRowData.Create;
Begin // Create
  Inherited Create;

  // Initialise values
End; // Create

//==============================================================================
//TRoleRowPositions
//==============================================================================
Constructor TRoleRowPositions.Create (Const AccountContact : TAccountContact);
Begin // Create
  Inherited Create;
  FAccountContact := AccountContact;
  FRows := TList.Create;
End; // Create

//------------------------------------------------------------------------------
Destructor TRoleRowPositions.Destroy;
Begin // Destroy
  FAccountContact := NIL;
  Inherited Destroy;
End; // Destroy

//------------------------------------------------------------------------------
// Adds a new row into the rows array
procedure TRoleRowPositions.AddNewRow;
begin // AddNewRow
  FRows.Add(TList.Create);
end; // AddNewRow

//------------------------------------------------------------------------------
// Adds a new role into the last row of the rows array
procedure TRoleRowPositions.AddToRow (Const RoleDetail : TRolePositionDetail);
begin // AddToRow
  GetRowRoles(FRows.Count - 1).Add(RoleDetail);
end; // AddToRow

//------------------------------------------------------------------------------
function TRoleRowPositions.GetRowRoles (Index : Integer) : TList;
begin // GetRowRoles
  if (Index >=0) and (Index < FRows.Count) then
    Result := TList(FRows.Items[Index])
  else
    raise Exception.Create('TRoleRowPositions.GetRowRoles: Invalid Index (' + IntToStr(Index) + ')');
end; // GetRowRoles

//------------------------------------------------------------------------------
Function TRoleRowPositions.GetrrpRowCount : Integer;
Begin // GetrrpRowCount
  Result := FRows.Count;
End; // GetrrpRowCount

//------------------------------------------------------------------------------
Function TRoleRowPositions.GetRowText (Index : Integer) : ANSIString;
Var
  RowRoles : TList;
  iRowRole : Integer;
Begin // GetRowText
  // Get the list of roles for the row and run through them and return a consolidated string
  // containing all the text
  RowRoles := GetRowRoles (Index);
  For iRowRole := 0 To (RowRoles.Count - 1) Do
  Begin
    Result := Result + TRolePositionDetail(RowRoles.Items[iRowRole]).RoleText;
  End; // For I
End; // GetRowText


//==============================================================================


// TFrame doesn't have an OnCreate event, so this has been exposed instead.
constructor TframeCustRoles.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FSettings := GetWindowSettings(Self.ClassName + '_' + SubTypeFromTraderType(CustFormMode));
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  // Create the contacts manager
  // PKR. 22/01/2014. Use factory method.
  oContactManager := NewContactsManager;

  // PKR. 22/01/2014.  Removed calls to DisplayContactList and DisplayAvailableRoles
  //  list as there is no customer code set at this point.  They are called by
  //  SetCustomerRecord.
end;
  
//------------------------------------------------------------------------------
// TFrame doesn't have an OnCreate event, so this has been exposed instead.
destructor TframeCustRoles.Destroy;
begin
  // Free the contact manager so that its destructor is called.
  oContactManager.Free;
  
  inherited;
end;
  

//------------------------------------------------------------------------------
// Called to set the selected account within the Contact Manager.
// MH 09/01/2014 v7.1 ABSEXCH-16008: Default the Country Code when adding a new role
procedure TframeCustRoles.SetCustomerRecord(const aCustCode, aCountry : string);
begin
  customerCode := aCustCode;
  // MH 09/01/2014 v7.1 ABSEXCH-16008: Default the Country Code when adding a new role
  CustomerCountryCode := aCountry;

  oContactManager.SetCustomerRecord(customerCode);

  DisplayContactList;
  DisplayAvailableRolesList;

  if (lbContacts.Count > 0) then
  begin
    lbContacts.Selected[0] := true;
    (parentForm as TCustRec3).DelCP1Btn.Enabled := lbContacts.ItemIndex >= 0;
  end;
end;
  
//------------------------------------------------------------------------------
procedure TframeCustRoles.SetCustFormMode(aMode : byte);
begin
  custFormMode := aMode;

  // PKR. 20/11/2013.
  // We need to build the context menus here because they are different
  //  depending on whether it is a Customer or a Supplier.
  BuildPopupRoleMenus;
end;

//------------------------------------------------------------------------------
// PKR. 19/02/2014. ABSEXCH-15059. Respect Password settings for editing Roles/Contacts.
procedure TframeCustRoles.SetCanEditContacts(canEdit : Boolean);
begin
  fCanEditContacts := canEdit;
end;

//------------------------------------------------------------------------------
// Builds the Owner-draw Listbox that contains the Contacts
procedure TframeCustRoles.DisplayContactList;
var
  index : integer;
  oldIndex : integer;
begin
  CalcRoleBoxSize;
  oldIndex := lbContacts.ItemIndex;
  lbContacts.Clear;
  
  // For each contact in the contact manager
  for index := 0 to oContactManager.GetNumContacts-1 do
  begin
    lbContacts.Items.Add('Contact ' + IntToStr(index+1));
    lbContacts.Items.Objects[index] := TListRowData.Create;
  end;

  if (oldIndex >= 0) and (lbContacts.Count > oldIndex) then
  begin
    lbContacts.Selected[oldIndex] := true;
  end;
end;

//------------------------------------------------------------------------------
// Displays a list of available Roles as a set of TLabels.
procedure TframeCustRoles.DisplayAvailableRolesList;
var
  index     : integer;
  vIndex    : integer;
  roleRec   : ContactRoleRecType;
  numRoles  : integer;
  usedWidth : integer;
  roleLabel : TLabel;

  // PKR. 21/01/2014. Added to allow font properties to change
  labelVOffset : integer;
  uRolesPanelHeight : integer;
begin
  numRoles := oContactManager.GetNumRoles;

  roleScroll.Font  := lbContacts.Font;
  
  vIndex := 0;
  labelVOffset := lbContacts.Canvas.TextExtent('Height test').cy + 4;

  if numRoles > 0 then
  begin
    // Need to remove all Tlabels from the unassigned roles list.
    if roleScroll.ComponentCount > 0 then
    begin
      for index := roleScroll.ComponentCount-1 downto 0 do
      begin
        if roleScroll.Components[index] is TLabel then
        begin
          roleLabel := roleScroll.Components[index] as TLabel;
          roleLabel.Free;
        end; // is a TLabel
      end; // for each component
    end; // ComponentCount > 0

    usedWidth := Margin;

    for index := 0 to numRoles - 1 do
    begin
      roleRec := oContactManager.GetRole(index);

      // PKR. 04/11/2013.
      // Handle appropriate roles only - Customer or Supplier
      if ((roleRec.crRoleAppliesToCustomer) and (custFormMode = ConsumerUtils.CUSTOMER_TYPE)) or
         ((roleRec.crRoleAppliesToSupplier) and (custFormMode = ConsumerUtils.SUPPLIER_TYPE)) then
      begin
        // If this role is not assigned to a contact, then add it to the list
        //  of available roles.
        if (not oContactManager.RoleIsAssigned(roleRec.crRoleId)) then
        begin
          // Create a TLabel to represent the Unassigned Role
          roleLabel := TLabel.Create(roleScroll);

          rolelabel.Font := lbContacts.Font;

          // Set its Caption to the Role Description, adding a leading and trailing
          //  space to make it look better
          roleLabel.Caption := ' ' + Trim(roleRec.crRoleDescription) + ' ';

          // Give it a name
          roleLabel.Name := 'lblRole' + IntToStr(index);

          roleLabel.ParentFont := false;
          // Inverted colours
          // ABSEXCH-15106.  PKR. 03/03/2014. Colours were being picked up from
          // the wrong place.
          roleLabel.Font.Color := lbContacts.Color;
          roleLabel.Color      := lbContacts.Font.Color;

          roleLabel.AutoSize   := false;
          roleLabel.Width      := roleBoxSize.cx;
          roleLabel.Alignment  := taCenter;

          // Calculate its position
          if (usedWidth + Margin + roleBoxSize.cx) > roleScroll.ClientWidth then
          begin
            usedWidth := Margin;
            inc(vIndex);
          end;

          roleLabel.Top  := Margin + (vIndex * labelVOffset);
          roleLabel.Left := usedWidth + Margin;

          usedWidth := usedWidth + Margin + roleBoxSize.cx;

          // Give it a popup menu
          roleLabel.PopupMenu := popupUnassignedRoles;

          // Set it's Parent to add it to the form
          roleLabel.Parent := roleScroll;
        end; // Role not assigned
      end; // Role approriate for Supplier or Customer
    end;  // For each role
  end;  // NumRoles > 0

  uRolesPanelHeight := ((vIndex+1) * labelVOffset) + uRolesCaption.Height + 4;
  pnlRoles.Height := uRolesPanelHeight;
end;

//------------------------------------------------------------------------------
// Builds the popup menus for Assigning and Unassigning roles to contacts.
// Each menu has a submenu containing a list of roles.
procedure TframeCustRoles.BuildPopupRoleMenus;
var
  index   : integer;
  SubItem : TMenuItem;
  roleRec : ContactRoleRecType;
begin
  // PKR. Not entirely necessary, but avoids duplication in case this
  // method is called multiple times.
  popupContactRole.Items[0].Clear;
  popupContactRole.Items[1].Clear;

  for index := 0 to (oContactManager.GetNumRoles - 1) do
  begin
    // PKR. 04/11/2013.
    // Handle appropriate roles only - Customer or Supplier
    roleRec := oContactManager.GetRole(index);
    
    if ((roleRec.crRoleAppliesToCustomer) and (custFormMode = ConsumerUtils.CUSTOMER_TYPE)) or
       ((roleRec.crRoleAppliesToSupplier) and (custFormMode = ConsumerUtils.SUPPLIER_TYPE)) then
    begin      
      // Create an entry for the Assign Roles menu subitems
      SubItem:= TMenuItem.Create(popupContactRole);
      SubItem.Caption := roleRec.crRoleDescription;
      popupContactRole.Items[0].Add(SubItem);
      // Wire up the generic handler for this subitem
      SubItem.OnClick := AssignRoleClick;

      // Create an entry for the Unassign Roles menu subitems
      SubItem:= TMenuItem.Create(popupContactRole);
      SubItem.Caption := roleRec.crRoleDescription;
      popupContactRole.Items[1].Add(SubItem);
      // Wire up the generic handler for this subitem
      SubItem.OnClick := UnassignRoleClick;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Methods for the Owner-draw list box that is the Contacts list.
//------------------------------------------------------------------------------
procedure TframeCustRoles.lbContactsMeasureItem(Control    : TWinControl;
                                                Index      : Integer;
                                                var Height : Integer);
Var
  thisListBox   : TListBox;
  oContact      : TAccountContact;
  sOutText      : ANSIString;
  index2        : Integer;
  roleRowPos    : TRoleRowPositions;
begin
  // Need to calculate the required height - this will depend upon the width of
  //  the list and how many Roles have been assigned to the Contact.

  // Setup a local typecast reference to the ListBox in order to access the
  // properties such as Canvas that aren't published via TWinControl
  thisListBox := (Control As TListBox);

  oContact := oContactManager.GetContact(Index);
  if (oContact <> nil) then
  begin
    Height := 2 * Margin;

    // ROW 1 - Name + Phone Number ---------------------------------------------
    thisListBox.Canvas.Font.Style := thisListBox.Canvas.Font.Style + [fsBold];
    try
      sOutText := oContact.contactDetails.acoContactName +
                  oContact.contactDetails.acoContactPhoneNumber;
      Height   := Height + thisListBox.Canvas.TextExtent(sOutText).cy;
    finally
      thisListBox.Canvas.Font.Style := thisListBox.Canvas.Font.Style - [fsBold];
    end; // try..finally

    // ROW 2 - Job Title + Email Address ---------------------------------------
    sOutText := oContact.contactDetails.acoContactJobTitle +
                oContact.contactDetails.acoContactEmailAddress;
    Height   := Height + thisListBox.Canvas.TextExtent(sOutText).cy;

    // ROW 3+ - Assigned Roles -------------------------------------------------
    if Length(oContact.assignedRoles) > 0 then
    begin
      // Get a Role Row/Position object to determine how many rows for which we
      // need to allocate space.
      roleRowPos := TRoleRowPositions.Create(oContact);

      // PKR. 23/01/2014. Use the standard role box width.
      roleRowPos.CalculateRowsForWidth(thisListBox.Canvas, ListBoxWidth, roleBoxSize);

      if (roleRowPos.rrpRowCount > 0) then
      begin
        // Insert a short gap before painting the Role fields
        Height := Height + Margin;

        // Allocate height for the number of rows in the current font - use the full row text
        // to calculate the height to ensure no dangly bits get chopped off
        for index2 := 0 to (roleRowPos.rrpRowCount - 1) do
          // PKR. 23/01/2014. Use the standard role box height.
          Height := Height + roleBoxSize.cy + 1;
      end; // If (roleRowPos.rrpRowCount > 0)
    end;  // Has assigned roles

    // Dividing Line -----------------------------------------------------------
    Height := Height + 2;
  end;

  inherited;
end;


//------------------------------------------------------------------------------
procedure TframeCustRoles.lbContactsDrawItem(Control : TWinControl;
                                             Index   : Integer;
                                             Rect    : TRect;
                                             State   : TOwnerDrawState);
Var
  thisListBox     : TListBox;
  thisListRowData : TListRowData;
  oContact        : TAccountContact;
  sOutText        : ANSIString;
  OutRect         : TRect;
  FieldSize       : TSize;
  iLeftMargin, 
  iRightMargin, 
  iTotalWidth, 
  iRowTop, 
  iRowHeight, 
  iFieldLength, 
  iRoleRow, 
  iRole           : Integer;
  oRowRoleDetails : TRolePositionDetail;
  RowRoleList     : TList;
  OrigFontColor,
  OrigPenColor,
  OrigBrushColor  : TColor;
  roleRowPos      : TRoleRowPositions;
begin
  roleScroll.Font       := lbContacts.Font;

  // Setup a local typecast reference to the ListBox in order to access the
  // properties such as Canvas that aren't published via TWinControl
  thisListBox := (Control As TListBox);

  // Setup a local typecast referent to the row's ListRowData object
  thisListRowData := TListRowData(thisListBox.Items.Objects[Index]);

  // Setup a local typecast reference to the AccountContact object
  oContact := oContactManager.GetContact(Index);  //  oAccountContacts.AccountContacts[Index];

  // Paint the background area to clear the cell - the appropriate background
  //  colour is set automatically.
  (Control As TListBox).Canvas.FillRect(Rect);

  // ROW 1 - Name + Phone Number ---------------------------------------------
  iLeftMargin := Rect.Left + Margin;
  iRightMargin := Rect.Right - Margin;
  iTotalWidth := iRightMargin - iLeftMargin;

  // First row starts at top, subsequent rows share the top row of the Rect with the previous
  // row so we need to compensate in the first row
  iRowTop := Rect.Top + Margin;
  If (Index = 0) Then
    iRowTop := iRowTop - 1;

  // Display Contact Name in top-left in Bold
  ThisListBox.Canvas.Font.Style := ThisListBox.Canvas.Font.Style + [fsBold];
  Try
    // Measure the height of the first row - Name + Phone Number to determine position for 2nd row
    sOutText := oContact.contactDetails.acoContactName +
                oContact.contactDetails.acoContactPhoneNumber;
    iRowHeight := ThisListBox.Canvas.TextExtent(sOutText).cy;

    // Measure the length of the Contact Name so we can determine the split between Name and Phone,
    // limit the name to a max of 80% of the width to leave space for the Phone to be visible
    sOutText := oContact.contactDetails.acoContactName;


    iFieldLength := ThisListBox.Canvas.TextExtent(sOutText).cx;
    If (iFieldLength > (iTotalWidth * 0.7)) Then
      iFieldLength := Trunc(iTotalWidth * 0.7);

    OutRect := Classes.Rect(iLeftMargin,
                            iRowTop,
                            iLeftMargin + iFieldLength,
                            iRowTop + iRowHeight);
    DrawTextEx (ThisListBox.Canvas.Handle,  // handle of device context
                  PCHAR(sOutText),          // address of string to draw
                  Length(sOutText),         // length of string to draw
                  OutRect,                  // address of rectangle coordinates
                  DT_Left Or DT_MODIFYSTRING Or DT_END_ELLIPSIS,   // formatting options
                  NIL);	                    // address of structure for more options

  Finally
    ThisListBox.Canvas.Font.Style := ThisListBox.Canvas.Font.Style - [fsBold];
  End; // Try..Finally

  // Display Phone Number in top-right
  if Trim(oContact.contactDetails.acoContactPhoneNumber) <> '' then
  begin
    sOutText := 'P: ' + oContact.contactDetails.acoContactPhoneNumber;
    OutRect := Classes.Rect(iLeftMargin + iFieldLength + InterFieldGap, iRowTop, iRightMargin, iRowTop + iRowHeight);
    DrawTextEx (ThisListBox.Canvas.Handle,    // handle of device context
                PCHAR(sOutText),              // address of string to draw
                Length(sOutText),             // length of string to draw
                OutRect,                      // address of rectangle coordinates
                DT_Right Or DT_MODIFYSTRING Or DT_END_ELLIPSIS,   // formatting options
                NIL);	                        // address of structure for more options
  end;

  // ROW 2 - Job Title + Email Address ---------------------------------------

  // work out where this row starts and calculate the new height for this row
  iRowTop := iRowTop + iRowHeight;
  sOutText := oContact.contactDetails.acoContactJobTitle +
              oContact.contactDetails.acoContactEmailAddress;
  iRowHeight := ThisListBox.Canvas.TextExtent(sOutText).cy;

  // Display Job Title underneath Contact Name
  sOutText := oContact.contactDetails.acoContactJobTitle;

  iFieldLength := ThisListBox.Canvas.TextExtent(sOutText).cx;
  If (iFieldLength > (iTotalWidth * 0.7)) Then
    iFieldLength := Trunc(iTotalWidth * 0.7);

  OutRect := Classes.Rect(iLeftMargin, iRowTop, iLeftMargin + iFieldLength, iRowTop + iRowHeight);
  DrawTextEx (ThisListBox.Canvas.Handle,    // handle of device context
                PCHAR(sOutText),            // address of string to draw
                Length(sOutText),           // length of string to draw
                OutRect,                    // address of rectangle coordinates
                DT_Left Or DT_MODIFYSTRING Or DT_END_ELLIPSIS,   // formatting options
                NIL);	                      // address of structure for more options

  if Trim(oContact.contactDetails.acoContactEmailAddress) <> '' then
  begin
    // Display Email Address underneath Phone Number
    ThisListBox.Canvas.Font.Style := ThisListBox.Canvas.Font.Style + [fsUnderline];
    Try
      sOutText := 'E: ' + oContact.contactDetails.acoContactEmailAddress;
      FieldSize := ThisListBox.Canvas.TextExtent(sOutText);

      // Calculate the correct left bounds of the paint rectangle for the email address
      If ((iRightMargin - FieldSize.cx) > (iLeftMargin + iFieldLength + InterFieldGap)) Then
        // Email address is shorter than the maximum space so use the short rectangle
        OutRect := Classes.Rect(iRightMargin - FieldSize.cx, iRowTop, iRightMargin, iRowTop + iRowHeight)
      Else
        // Email address is longer than the maximum space so we need to limit it to the maximum space available
        OutRect := Classes.Rect(iLeftMargin + iFieldLength + InterFieldGap, iRowTop, iRightMargin, iRowTop + iRowHeight);

      // PKR. 03/02/2014. ABSEXCH-15004. Added DT_NOPREFIX flag to prevent the
      // listbox from removing "&" and underlining the next character.
      ThisListRowData.lrdEmailRect := OutRect;
      DrawTextEx (ThisListBox.Canvas.Handle,  // handle of device context
                      PCHAR(sOutText),        // address of string to draw
                      Length(sOutText),       // length of string to draw
                      OutRect,                // address of rectangle coordinates
                      DT_Right Or DT_NOPREFIX or DT_MODIFYSTRING Or DT_END_ELLIPSIS,   // formatting options
                      NIL);	                  // address of structure for more options
    Finally
      ThisListBox.Canvas.Font.Style := ThisListBox.Canvas.Font.Style - [fsUnderline];
    End; // Try..Finally
  end;

  // Roles Allocated to this AccountContact ----------------------------------
  // Get a Role Row/Position object to determine where each role field will be
  //  printed
  roleRowPos := TRoleRowPositions.Create(oContact);
  roleRowPos.CalculateRowsForWidth(ThisListBox.Canvas, ListBoxWidth, roleBoxSize);

  if (roleRowPos.rrpRowCount > 0) then
  begin
    // Insert a short gap before painting the Role fields
    iRowTop := iRowTop + Margin;

    // Invert colours for painting the Role labels
    OrigFontColor  := ThisListBox.Canvas.Font.Color;
    OrigBrushColor := ThisListBox.Canvas.Brush.Color;
    OrigPenColor   := ThisListBox.Canvas.Pen.Color;

    // ABSEXCH-15106.  PKR. 03/03/2014. Ensure that the colours of the selected
    // result in a visible combination.
    if (odSelected in State) then
    begin
      ThisListBox.Canvas.Font.Color  := clHighlight;
      ThisListBox.Canvas.Brush.Color := clHighlightText;
    end
    else
    begin
      ThisListBox.Canvas.Font.Color := ThisListBox.Canvas.Brush.Color;
      ThisListBox.Canvas.Brush.Color := ThisListBox.Font.Color;
    end;

    try
      // Run through the rows printing each Role
      for iRoleRow := 0 to (roleRowPos.rrpRowCount - 1) do
      begin
        // work out where this row starts
        iRowTop := iRowTop + iRowHeight;

        RowRoleList := roleRowPos.rrpRowRoles[iRoleRow];
        for iRole := 0 to (RowRoleList.Count - 1) do
        begin
          oRowRoleDetails := TRolePositionDetail(RowRoleList.Items[iRole]);

          // Surround the role text with spaces to make it look better
          sOutText := ' ' + oRowRoleDetails.RoleText + ' ';
          iRowHeight := roleBoxSize.cy + 1;   // Add 1 to create a small gap between rows

          // Draw a rectangle to the size of the largest role label
          OutRect := Classes.Rect(oRowRoleDetails.Left,
                                  iRowTop,
                                  oRowRoleDetails.Left + roleBoxSize.cx,
                                  iRowTop + iRowHeight);

          // PKR. 23/01/2014.  Added backgroud rectangle to ensure that each role
          //  label is the same size
          ThisListBox.Canvas.Pen.Color := ThisListBox.Canvas.Brush.Color;
          ThisListBox.Canvas.Rectangle(OutRect.Left, OutRect.Top, Outrect.Right, OutRect.Bottom-1);

          DrawTextEx (ThisListBox.Canvas.Handle,     // handle of device context
                          PCHAR(sOutText),           // address of string to draw
                          Length(sOutText),          // length of string to draw
                          OutRect,                   // address of rectangle coordinates
                          DT_CENTER or DT_MODIFYSTRING or DT_END_ELLIPSIS,   // formatting options
                          nil);	                     // address of structure for more options
        end; // For iRole
      end; // For iRoleRow
    finally
      ThisListBox.Canvas.Font.Color  := OrigFontColor;
      ThisListBox.Canvas.Brush.Color := OrigBrushColor;
      ThisListBox.Canvas.Pen.Color   := OrigpenColor;
    end; // Try..Finally
  end; // If (rrpRowCount > 0)

  // Dividing Line -----------------------------------------------------------
  iRowTop := iRowTop + iRowHeight + 1;

  ThisListBox.Canvas.Pen.Color := ThisListBox.Canvas.Font.Color;
  ThisListBox.Canvas.MoveTo (iLeftMargin, iRowTop);
  ThisListBox.Canvas.LineTo (iRightMargin, iRowTop);
end;

//------------------------------------------------------------------------------
procedure TframeCustRoles.lbContactsMouseUp(Sender : TObject;
                                            Button : TMouseButton;
                                            Shift  : TShiftState;
                                            X, Y   : Integer);
var
  ThisListRowData : TListRowData;
  oContact : TAccountContact;
  emailAddress : string;
begin
  if lbContacts.ItemIndex >= 0 then
  begin
    // Setup a local typecast referent to the row's ListRowData object
    ThisListRowData := TListRowData(lbContacts.Items.Objects[lbContacts.ItemIndex]);

    // Check whether the mouse click is within the rectangle where the email
    //  address is painted
    // PKR. 19/11/2013. Prevent right-click from invoking the email client.
    if (Button = mbLeft) then
    begin
      if (ThisListRowData.lrdEmailRect.Left <= X) and (X <= ThisListRowData.lrdEmailRect.Right) and
         (ThisListRowData.lrdEmailRect.Top <= Y) and (Y <= ThisListRowData.lrdEmailRect.Bottom) then
      begin
        // Setup a local typecast reference to the AccountContact object
        oContact := oContactManager.GetContact(lbContacts.ItemIndex);

        // PKR. 03/02/2014. ABSEXCH-15004.  Replace symbols in the email address
        //  with their "escaped" form (% followed by the hex ascii code. Eg. & => %26)

        // WARNING. At this point, having special characters in email addresses can
        //  hang Exchequer and Delphi when run using the Delphi debugger.
        emailAddress := oContact.contactDetails.acoContactEmailAddress;
        emailAddress := EscapeCharsForURL(emailAddress);
        RunFile('mailto:' + emailAddress, '');
      end; // If (ThisListRowData.lrdEmailRect.Left ...
    end;

    // Check whether the mouse click is within a role rectangle.
  end;
end;

//------------------------------------------------------------------------------
procedure TframeCustRoles.pnlRoleListResize(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  Try
    lbContacts.Style := lbStandard;
    lbContacts.Style := lbOwnerDrawVariable;
  Finally
    LockWindowUpdate(0);
  End; // Try..Finally
end;

//------------------------------------------------------------------------------
function TframeCustRoles.ListBoxWidth : Integer;
Begin // ListBoxWidth
  Result := lbContacts.ClientWidth;

  // Check to see if the vertical scroll-bar is visible - we have to always assume it will
  // be shown at some point and if we don't do this then the wrapping of roles to the next
  // line can get screwy.
  If (GetWindowlong(lbContacts.Handle, GWL_STYLE) and WS_VSCROLL) = 0 Then
    // No - subtract the width of the scrollbar
    Result := Result - GetSystemMetrics(SM_CXVSCROLL);
End; // ListBoxWidth

//------------------------------------------------------------------------------
// Runs through the Roles for the parent Account Contact and works out
// how many rows would be needed to display them all and the position of each one
procedure TRoleRowPositions.CalculateRowsForWidth(ClientCanvas : TCanvas;
                                                  Const ClientAreaWidth : Integer;
                                                  aRolelabelSize : TSize);
var
  PaintSize : TSize;
  sOutText : ShortString;
  iRole, iPaintLeft, iMaxPaintRight : Integer;
  FirstRowRole : Boolean;
begin // CalculateRowsForWidth
  // Start the painting at the left margin in the canvas' client area
  iPaintLeft := Margin;
  iMaxPaintRight := ClientAreaWidth - Margin;

  // Run through the Roles on the AccountContact working out where they can be painted
  if Length(FAccountContact.assignedRoles) > 0 then
  begin
    // Create the first row
    AddNewRow;
    FirstRowRole := True;

    // Make all labels the same size
    PaintSize := aRoleLabelSize;

    for iRole := Low(FAccountContact.assignedRoles) to High(FAccountContact.assignedRoles) do
    begin
      // Find out what area is needed using the current font
      // get the description of the role.
      sOutText := Trim(FAccountContact.assignedRoles[iRole].crRoleDescription);

//      PaintSize := ClientCanvas.TextExtent(' ' + sOutText + ' ');

      // Check to see if it will fit on the current row - if we don't have any fields
      // on the current row then first it to add to the current row
      if ((iPaintLeft + PaintSize.cx) >= iMaxPaintRight) and (not FirstRowRole) then
      begin
        // Doesn't fit in - create a new row
        AddNewRow;
        iPaintLeft := Margin;
      end; // If ((iPaintLeft + PaintSize.cx) >= iMaxPaintRight) And (Not FirstRowRole)

      // Add the Role to the current row
      AddToRow(TRolePositionDetail.Create (sOutText, iPaintLeft, PaintSize.cx));
      FirstRowRole := False;
      iPaintLeft := iPaintLeft + PaintSize.cx + InterRoleGap;
    end; // For iRole
  end; // If (FAccountContact.RoleCount > 0)
end; // CalculateRowsForWidth

//------------------------------------------------------------------------------
procedure TframeCustRoles.popupContactRolePopup(Sender: TObject);
var
  index : integer;
  oContact : TAccountContact;
  roleName         : string;
  contactRoleIndex : integer;
  enabledAssignItemsCount   : integer;
  enabledUnassignItemsCount : integer;
  theRole                   : ContactRoleRecType;
begin
  // PKR. 30/01/2014. ABSEXCH-14992. Popup doesn't appear if there are no contacts
  // but the menu "Add Contact", so it should pop up.
  if (lbContacts.ItemIndex >= 0) and
     (oContactManager.GetNumContacts > 0) then
  begin
    // PKR. 03/02/2014.  ABSEXCH-15007.  Enable menu items by default.
    puAssignRole.Enabled       := true;
    puUnassignRole.Enabled     := true;
    puSendEmail.Enabled        := true;
    ContactPopupAdd.Enabled    := true;
    ContactPopupEdit.Enabled   := true;
    ContactPopupDelete.Enabled := true;

    puAssignRole.Visible       := true;
    puUnassignRole.Visible     := true;
    puSendEmail.Visible        := true;
    ContactPopupAdd.Visible    := true;
    ContactPopupEdit.Visible   := true;
    ContactPopupDelete.Visible := true;

    enabledAssignItemsCount   := 0;
    enabledUnassignItemsCount := 0;

    // Get the selected Contact
    oContact := oContactManager.GetContact(lbContacts.ItemIndex);

    // PKR. 19/02/2014. ABSEXCH-15059. Respect Password control of editing Roles/Contacts.
    if not (fCanEditContacts) then
    begin
      puAssignRole.Visible       := false;
      puUnassignRole.Visible     := false;
      // Enable the Send Email option if this contact has an email address
      puSendEmail.Enabled := Trim(oContact.contactDetails.acoContactEmailAddress) <> '';
      ContactPopupAdd.Visible    := false;
      ContactPopupEdit.Visible   := false;
      ContactPopupDelete.Visible := false;

      if (not puSendEmail.Enabled) then
      begin
        abort;
      end;
    end
    else
    begin
      // Enable the Send Email option if this contact has an email address
      puSendEmail.Enabled := Trim(oContact.contactDetails.acoContactEmailAddress) <> '';

      if oContact <> nil then
      begin
        // Enable/disable the menu items as appropriate.
        if oContactManager.GetNumRoles > 0 then
        begin
          // We can use the captions from the menu items as they were created
          //  from the master list of roles.
          for index := 0 to puAssignRole.Count-1 do
          begin
            // Get the role name
            roleName := puAssignRole.Items[index].Caption;
            theRole := oContactManager.GetRoleByDescription(rolename);

            // Default to not assigned to this contact
            puAssignRole.Items[index].Visible := true;
            puUnassignRole.Items[index].Visible := false;

            // The Unassign Role menu should only allow roles assigned to this contact
            // PKR. 21/01/2014. We can now assign a role to multiple contacts, so the assign
            //  menu now contains all roles not assigned to this contact.
            if Length(oContact.assignedRoles) > 0 then
            begin
              for contactRoleIndex := Low(oContact.assignedRoles) to High(oContact.assignedRoles) do
              begin
                if oContact.assignedRoles[contactRoleIndex].crRoleDescription = roleName then
                begin
                  // Is assigned to this contact, so hide the Assign option
                  puAssignRole.Items[index].Visible   := false;
                  // Show the Unassign option
                  puUnassignRole.Items[index].Visible := true;

                  inc(enabledUnassignItemsCount);
                end;
              end;
            end;
          end;

          enabledAssignItemsCount := puAssignRole.Count - enabledUnassignItemsCount;
        end;
        // If the number of enabled submenu items is 0, then we can disable the
        //  parent menu item.
        puAssignRole.Visible   := enabledAssignItemsCount > 0;
        puUnassignRole.Visible := enabledUnassignItemsCount > 0;
      end;
    end;
  end
  else
  begin
    // No item selected, or no contacts, so limit the menu to Add

    // ABSEXCH-15104 . 03/03/2014. PKR.  If this user doesn't have edit contact
    // privileges, then there's nothing available in the menu, so no point in showing it.
    if (not fCanEditContacts) then
    begin
      // Abort the popup of this menu.
      abort;
    end;

    puAssignRole.Enabled       := false;
    puUnassignRole.Enabled     := false;
    puSendEmail.Enabled        := false;
    ContactPopupAdd.Enabled    := true;
    ContactPopupEdit.Enabled   := false;
    ContactPopupDelete.Enabled := false;
  end;
end;

//------------------------------------------------------------------------------
procedure TframeCustRoles.lbContactsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  ThisListRowData : TListRowData;
  Idx             : Integer;
begin
  // Check to see if we are over a valid row
  Idx := lbContacts.ItemAtPos(Point(X,Y), True);
  if (Idx >= 0) then
  begin
    // Setup a local typecast referent to the row's ListRowData object
    ThisListRowData := TListRowData(lbContacts.Items.Objects[Idx]);

    // Check whether the mouse click is within the rectangle where the email
    //  address is painted.

    // NB.  This doesn't always work when the list has scrolled.  So, in the 
    //  ListBox OnClick event, we repaint the list, which seems to help.
    if (ThisListRowData.lrdEmailRect.Left <= X) and (X <= ThisListRowData.lrdEmailRect.Right) and
       (ThisListRowData.lrdEmailRect.Top <= Y) and (Y <= ThisListRowData.lrdEmailRect.Bottom) then
      lbContacts.Cursor := crHandPoint
    else
      lbContacts.Cursor := crDefault;
  end // If (Idx >= 0)
  else
    lbContacts.Cursor := crDefault;
end;

//------------------------------------------------------------------------------
// Generic handler for all Assign role sub-menu items.
procedure TframeCustRoles.AssignRoleClick(Sender: TObject);
var
  theRole    : string;
  aRoleId    : integer;
  aContactId : integer;
  oContact   : TAccountContact;
  oRole      : ContactRoleRecType;
  iStatus    : integer;
begin
  // Assign the selected role to this contact
  // Get the Role

  theRole := (Sender as TMenuItem).Caption;
  oRole   := oContactManager.GetRoleByDescription(theRole);
  aRoleId := oRole.crRoleId;

  // Get the Contact
  oContact   := oContactManager.GetContact(lbContacts.ItemIndex);
  aContactId := oContact.contactDetails.acoContactId;

  // Assign the Role to the Contact
  oContactManager.AssignRoleToContact(aRoleId, aContactId);
  iStatus := oContactManager.SaveContactToDB(oContact, emEdit);
  if (iStatus <> Success) then
  begin
    MessageDlg('Could not save assigned roles.', mtInformation, [mbOk], 0);
  end;

  // Update the Contacts list
  DisplayContactList;

  DisplayAvailableRolesList;
end;

//------------------------------------------------------------------------------
// Generic handler for all Unassign role sub-menu items.
procedure TframeCustRoles.UnassignRoleClick(Sender: TObject);
var
  theRole    : string;
  aRoleId    : integer;
  aContactId : integer;
  oContact   : TAccountContact;
  oRole      : ContactRoleRecType;
  iStatus    : integer;
begin
  theRole := (Sender as TMenuItem).Caption;
  oRole   := oContactManager.GetRoleByDescription(theRole);
  aRoleId := oRole.crRoleId;

  // Remove the Role from this contact
  // Get the currently selected Contact.
  oContact   := oContactManager.GetContact(lbContacts.ItemIndex);
  aContactId := oContact.contactDetails.acoContactId;

  if oContact <> nil then
  begin
    // look for the selected Role in the Contact's assigned roles list.
    if length(oContact.AssignedRoles) > 0 then
    begin
      // Remove it from the general assigned roles list.
      oContactManager.UnassignRoleFromContact(aRoleId, aContactId);
      iStatus := oContactManager.SaveContactToDB(oContact, emEdit);
      if (iStatus <> 0) then
      begin
        MessageDlg('Could not update contact record - code ' + IntToStr(iStatus),
                   mtInformation, [mbOk], 0);
      end;

      // Now redraw the Contact list.
      DisplayContactList;

      // And the Roles list
      DisplayAvailableRolesList;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TframeCustRoles.lbContactsClick(Sender: TObject);
begin
  lbContacts.Repaint;
  (parentForm as TCustRec3).DelCP1Btn.Enabled := lbContacts.ItemIndex >= 0;
  (parentForm as TCustRec3).EditCP1Btn.Enabled := lbContacts.ItemIndex >= 0;
end;

//------------------------------------------------------------------------------
// Deletes the currently selected contact (if one is selected).
procedure TframeCustRoles.DeleteCurrentContact;
var
  oContact   : TAccountContact;
begin
  if (lbContacts.itemIndex >= 0) then
  begin
    // Get the current contact.
    oContact   := oContactManager.GetContact(lbContacts.ItemIndex);
      
    // Ask for confirmation
    if (MessageDlg('Are you sure you want to delete the record for ' + oContact.contactDetails.acoContactName + '?',
                   mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      // Delete the contact
      if oContactManager.DeleteContact(oContact.contactDetails.acoContactId) then
      begin
        // Update the list of contacts
        DisplayContactList;

        // Update the list of unassigned roles
        DisplayAvailableRolesList;
      end
      else
      begin
        MessageDlg('Failed to delete Contact ' +oContact.contactDetails.acoContactName + '.',
                   mtInformation, [mbOk], 0);
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Loads the currently selected Contact into the Contact Editor form.
procedure TframeCustRoles.EditCurrentContact;
var
  contactId : integer;
  mResult   : integer;  // modal result of the editor form/dialogs
  dbResult  : integer;  // Result from the database update process
  oContact  : TAccountContact;
  editorForm  : TContactEditorFrm;
begin
  // Ensure we have a currently selected contact
  if lbContacts.ItemIndex >= 0 then
  begin
    oContact  := oContactManager.GetContact(lbContacts.ItemIndex);
    contactId := oContact.contactDetails.acoContactId;

      // PKR. 14/01/2014. Reload selected record in case it has been modified.
    if oContactManager.ReloadContactFromDB(contactId) then
    //  PS - 02-11-2015 - ABSEXCH-17004 - Added conditon to check return value.  // Display detail if contact found
    begin
       // Lock the contact record
      if (oContactManager.LockContact(contactId)) then
      begin
        //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Changed to use CreateEx
        editorForm := TContactEditorFrm.CreateEx(self, emEdit, oContact,
                                               oContactManager, custFormMode);
        try
          editorForm.SetDisplayProperties(editorForm, lbContacts.Color, lbContacts.Font);
          mResult := editorForm.ShowModal;

          if mResult = mrOk then
          begin
            // Record has been updated, so save it and update the display
            dbResult := oContactManager.SaveContactToDB(oContact, emEdit);

            if (dbResult <> 0) then
            begin
              // Either the database update failed, or the record has been modified
              //  by another user, so display a message.
              MessageDlg('This record cannot be saved as it has been modified by another user.',
                         mtWarning,
                         [mbOk],
                         0);

              // Reload the contacts list
              oContactManager.RefreshContacts;
            end;

            // Update the display
            DisplayContactList;

            // We might have assigned Roles in the Contact editor, so update the
            //  available roles list.
            DisplayAvailableRolesList;
          end;
        finally
          oContactManager.UnlockContact(contactId);
          // PKR. 14/02/2014. ABSEXCH-15064.  Editor form not being freed after editing a contact
          editorForm.Free;
        end;
      end
      else
      begin
        // Lock failed
        MessageDlg('Could not lock record for ' + oContact.contactDetails.acoContactName + '.' + CRLF +
                    'It might be in use by another user.',
                     mtInformation, [mbOk], 0);
      end;
    end
    else
    begin
      if (oContactManager.GetNumContacts = 0) then
        MessageDlg('There are no contacts to edit', mtInformation, [mbOk], 0)
      else
        MessageDlg('Please select an entry to edit', mtInformation, [mbOk], 0)
    end;
  end;
end;

//------------------------------------------------------------------------------
// PKR> 19/02/2014. ABSEXCH-15059. Respect Password control of editong Roles/Contacts.
// Opens the editor in View mode.
procedure TframeCustRoles.ViewCurrentContact;
var
  editorForm  : TContactEditorFrm;
  oContact    : TAccountContact;
  contactId   : integer;
begin
  // Ensure we have a currently selected contact
  if lbContacts.ItemIndex >= 0 then
  begin
    oContact  := oContactManager.GetContact(lbContacts.ItemIndex);
    contactId := oContact.contactDetails.acoContactId;

    // PKR. 14/01/2014. Reload selected record in case it has been modified.
    if oContactManager.ReloadContactFromDB(contactId) then
    //  PS - 02-11-2015 - ABSEXCH-17004 - Added conditon to check return value.     // Display detail if contact found
    begin
    // Display the Contact Editor form
      //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Changed to use CreateEx
      editorForm := TContactEditorFrm.CreateEx(self, emView, oContact, oContactManager, custFormMode);

      editorForm.SetDisplayProperties(editorForm, lbContacts.Color, lbContacts.Font);
      editorForm.ShowModal;

      editorForm.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Creates a new Contact, displays the Contact Editor and updates the Contact list
procedure TframeCustRoles.AddNewContact;
var
  editorForm  : TContactEditorFrm;
  oContact    : TAccountContact;
  mResult     : integer;
  index       : integer;
  iStatus     : integer;
begin
  // Create a new, empty contact record
  oContact := TAccountContact.Create;

  // Display the Contact Editor form
  //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Changed to use CreateEx
  editorForm := TContactEditorFrm.CreateEx(self, emAdd, oContact, oContactManager,
                                           custFormMode);
  try
    editorForm.SetDisplayProperties(editorForm, lbContacts.Color, lbContacts.Font);
    // MH 09/01/2014 v7.1 ABSEXCH-16008: Default the Country Code when adding a new role
    editorForm.DefaultCountry := CustomerCountryCode;

    mResult := editorForm.ShowModal;

    if (mResult = mrOk) then
    begin
      // PKR. 06/11/2013.  Save moved here, (from the editor form), for consistency.
      iStatus := oContactManager.SaveContactToDB(oContact, emAdd);

      if (iStatus = success) then
      begin
        // Update the contact's ID
        oContact.contactDetails.acoContactId := oContactManager.LastAddedContactId;
        // Add the new record to the ContactsManager
        oContactManager.AddContact(oContact);
      end;

        // PKR. 19/02/2014. ABSEXCH-15087. Could not save assigned role after adding new contact.
        // Reload the record to ensure the DateModified field is correct.
      if oContactManager.ReloadContactFromDB(oContact.contactDetails.acoContactId) then
      //  PS - 02-11-2015 - ABSEXCH-17004 - Added conditon to check return value.
      begin
        DisplayContactList;

        // 23/10/2013. PKR. Unassigned Roles list was not being updated.
        // We might have assigned or unassigned Roles in the Contact editor, so update
        //  the available roles list.
        DisplayAvailableRolesList;
      end;

      if (iStatus = success) then
      begin
        // PKR. 07/11/2013.
        // Select the newly added role in the list
        index := oContactManager.IndexOf(oContact.contactDetails.acoContactId);
        lbContacts.Selected[index] := true;
      end;
    end;
  finally
    // Free the resources that we have allocated.
    editorForm.Free;
  end;

  oContact.Free;
end;

//------------------------------------------------------------------------------
// Loads the selected Contact into the editor in View mode.
procedure TframeCustRoles.lbContactsDblClick(Sender: TObject);
// PKR. 04/11/2013.  Changed to Edit mode on double-click. (previously view mode)
begin
  // PKR. 19/02/2014. ABSEXCH-15059. Respect Password settings for editing Roles/Contacts.
  if (fCanEditContacts) then
  begin
    // 04/11/2013. PKR. Edit the selected contact.
    EditCurrentContact;
  end
  else
  begin
    // Open the editor in View mode
    ViewCurrentContact;
  end;
end;

//------------------------------------------------------------------------------
// Sets the caption of the Unassigned Roles popup menu item to include the 
//  Contact name and Role description.
// Eg.  "Assign General Contact to John Smith"
procedure TframeCustRoles.popupUnassignedRolesPopup(Sender: TObject);
var
  theRole     : string;
  cIndex      : integer;
  theContact  : TAccountContact;
  SubItem     : TMenuItem;
begin
  // PKR. 19/02/2014. ABSEXCH-15059. Respect Password control of editing Roles/Contacts.
  if not (fCanEditContacts) then
  begin
    abort;
  end;

  // PKR. 21/01/2014.  Rewritten to allow roles to be assigned to multiple contacts.
  // The unassigned roles popup menu now shows a list of contacts to which a
  //  role may be assigned.
  if oContactManager.GetNumContacts = 0 then
  begin
    popupAssignRole.Caption := '** No contacts to which this role may be assigned **';
  end
  else
  begin
    popupUnassignedRoles.Items[0].Clear;

    theRole := Trim((popupUnassignedRoles.PopupComponent as TLabel).Caption);

    popupAssignRole.Caption := 'Assign ' + theRole + ' to ';

    // Build a list of contacts.
    for cIndex := 0 to oContactManager.GetNumContacts-1 do
    begin
      // See if this contact has already been assigned this role
      theContact := oContactManager.GetContact(cIndex);

      // We can create a menu item for this contact
      // Create an entry for the Assign Roles menu subitems
      SubItem := TMenuItem.Create(popupUnassignedRoles);
      SubItem.AutoHotkeys := maManual;
      SubItem.Caption := theContact.contactDetails.acoContactName;
      // Short cut to the Contact Id.
      SubItem.Tag := theContact.contactDetails.acoContactId;
      popupUnassignedRoles.Items[0].Add(SubItem);
      // Wire up the generic handler for this subitem
      SubItem.OnClick := popupAssignRoleClick;
    end; // contact loop
  end;
end;

//------------------------------------------------------------------------------
// Assigns the selected Role to the selected Contact as the result of a menu click.
procedure TframeCustRoles.popupAssignRoleClick(Sender: TObject);
var
  theRole    : string;
  oRoleId    : integer;
  oContactId : integer;
  oContact   : TAccountContact;
  iStatus    : integer;
begin
  // PKR. 21/01/2014.  Rewritten to allow roles to be assigned to multiple contacts.
  if popupUnassignedRoles.PopupComponent is TLabel then
  begin
    // Get and trim the label caption, which has the role name surrounded by spaces
    theRole := Trim((popupUnassignedRoles.PopupComponent as TLabel).Caption);

    // Assign this role to the selected contact.
    // Get the Role
    oRoleId := oContactManager.GetRoleByDescription(theRole).crRoleId;

    // Get the Contact Id from the menu item's Tag.
    oContactId := (Sender as TMenuItem).Tag;

    // Assign the Role to the Contact
    oContactManager.AssignRoleToContact(oRoleId, oContactId);

    // PKR. 27/01/2014.  Save the updated contact (previously done by AssignRoleToContact)
    oContact := oContactManager.GetContactById(oContactId);
    iStatus := oContactManager.SaveContactToDB(oContact, emEdit);
    if (iStatus <> Success) then
    begin
      MessageDlg('Could not save assigned roles.',
                   mtInformation, [mbOk], 0);
    end;

    // Update the Contacts list
    DisplayContactList;

    // And the available roles list
    DisplayAvailableRolesList;
  end;
end;

//------------------------------------------------------------------------------
// Handles resizing of the frame.  Updates the list of unassigned Roles to fit
// the available space.  The Contact list is resized elsewhere.
procedure TframeCustRoles.FrameResize(Sender: TObject);
begin
  CalcRoleBoxSize;
  DisplayContactList;
  DisplayAvailableRolesList;
end;

//------------------------------------------------------------------------------
procedure TframeCustRoles.ContactPopupAddClick(Sender: TObject);
begin
  AddNewContact;
end;

//------------------------------------------------------------------------------
procedure TframeCustRoles.ContactPopupEditClick(Sender: TObject);
begin
  EditCurrentContact;
end;

//------------------------------------------------------------------------------
procedure TframeCustRoles.ContactPopupDeleteClick(Sender: TObject);
begin
  DeleteCurrentContact;
end;

//------------------------------------------------------------------------------
procedure TframeCustRoles.lbContactsMouseDown(Sender: TObject;
                       Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  aPoint : TPoint;
  index  : integer;
begin
  // Make the right button select an item
  if Button = mbRight then
  begin
    aPoint.X := X;
    aPoint.Y := Y;
    index := lbContacts.ItemAtPos(aPoint, true);
    if index >= 0 then
      lbContacts.Selected[index] := true;
  end;
end;

//------------------------------------------------------------------------------
// PKR. 23/01/2014. Method to calculate the size of the longest Roles label
//  based on the font on the Contacts ListBox.
procedure TframeCustRoles.CalcRoleBoxSize;
var
  index : integer;
  roleSize : TSize;
  roleDesc : string;
  theRole  : ContactRoleRecType;
begin
  // Calculate the maximum size of the role labels so that they will all be
  //  displayed the same size.
  roleBoxSize.cx := 0;
  roleBoxSize.cy := 0;

//  PKR. This shows that the Canvas font isn't always the same as the component font.
//  ShowMessage(Format('lbContacts Font name: %s, size: %d' + chr(13)+chr(10) +
//                     'lbContacts Canvas Font name: %s, size: %d', [lbContacts.Font.Name,
//                                                                   lbContacts.Font.Size,
//                                                                   lbContacts.Canvas.Font.Name,
//                                                                   lbContacts.Canvas.Font.Size]));

  // PKR. 24/01/2014
  // This line of code overcomes some weirdness.
  // The Window Settings functions set the font of the component, but the font
  //  of its canvas doesn't seem to get updated straight away, so when we call
  //  TextExtent on the Canvas, we sometimes get the wrong result, so this forces
  //  the canvas to have the same font.
  lbContacts.Canvas.Font := lbContacts.Font;

  for index := 0 to oContactManager.GetNumRoles-1 do
  begin
    theRole := oContactManager.GetRole(index);

    roleDesc := theRole.crRoleDescription;
    roleSize := lbContacts.Canvas.TextExtent(' ' + roleDesc + ' ');
    if roleSize.cx > roleBoxSize.cx then
      roleBoxSize.cx := roleSize.cx;
    if roleSize.cy > roleBoxSize.cy then
      roleBoxSize.cy := roleSize.cy;
  end;
end;

//------------------------------------------------------------------------------
// PKR. 27/01/2014.  Send email to the current contact option from context menu.
procedure TframeCustRoles.puSendEmailClick(Sender: TObject);
var
  oContact : TAccountContact;
begin
  oContact := oContactManager.GetContact(lbContacts.ItemIndex);
  RunFile('mailto:' + oContact.contactDetails.acoContactEmailAddress, '');
end;

//------------------------------------------------------------------------------

end.

