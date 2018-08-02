unit UserFieldConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GlobVar, VirtualTrees, StrUtils, DB, SQLCallerU, SQLUtils,
  ImgList, VarConst, BTConst, StdCtrls, Menus, ExtCtrls;

  type
    //Declare common node class
    TNodeData = class
    protected
      fFieldIndex : longint;
      fCaption: string;
      fChBoxEnabled : boolean;
      fChBoxChecked : boolean;
      fImageIndex : Integer;
      fEditFlag : boolean;
      //RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
      //Flag to check whether the UDF contains PII data.
      fContainsPIIData: Boolean;
      //Flag to check whether UDF is PII Field. Depending on that we can set if we want to display the checkbox in UserFieldEdit.pas
      fPIIFieldVisible: Boolean;
    public
      constructor Create(fieldIndex : longint; caption: string; chBoxEnabled : boolean;
                         chBoxChecked : boolean; imageIndex : Integer; aContainsPIIData: Boolean;
                         aPIIFieldVisible: Boolean); overload;

      property FieldIndex : longint read fFieldIndex write fFieldIndex;
      property Caption : string read fCaption write fCaption;
      property ChBoxEnabled : boolean read fChBoxEnabled write fChBoxEnabled;
      property ChBoxChecked : boolean read fChBoxChecked write fChBoxChecked;
      property ImageIndex : integer read fImageIndex write fImageIndex;
      property EditFlag : boolean read fEditFlag write fEditFlag;
      //RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
      property ContainsPIIData: Boolean read fContainsPIIData write fContainsPIIData;
      property PIIFieldVisible: Boolean read fPIIFieldVisible write fPIIFieldVisible;
    end;

    //Declare new structure for node data
    rTreeNodeData = record
      NodeData: TNodeData;
  end;

type
  TFrm_UserFieldConfig = class(TForm)
    VSTree_UserFields: TVirtualStringTree;
    Btn_OK: TButton;
    Btn_Cancel: TButton;
    ImgList_Main: TImageList;
    PMenu_Main: TPopupMenu;
    MenItem_Collapse: TMenuItem;
    MenItem_Expand: TMenuItem;
    Image1: TImage;
    Btn_Edit: TButton;
    procedure FormCreate(Sender: TObject);
    procedure VSTree_UserFieldsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
                                       Column: TColumnIndex; TextType: TVSTTextType;
                                       var CellText: WideString);
    procedure VSTree_UserFieldsGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
                                             Kind: TVTImageKind; Column: TColumnIndex;
                                             var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VSTree_UserFieldsChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
                                        var NewState: TCheckState; var Allowed: Boolean);
    procedure VSTree_UserFieldsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTree_UserFieldsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
                                        var InitialStates: TVirtualNodeInitStates);
    procedure MenItem_ExpandClick(Sender: TObject);
    procedure MenItem_CollapseClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure VSTree_UserFieldsDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Btn_OKClick(Sender: TObject);
    procedure VSTree_UserFieldsKeyAction(Sender: TBaseVirtualTree;
      var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean);
    procedure Btn_EditClick(Sender: TObject);
  procedure DisplayError(operation : string; errorCode : integer);
    procedure VSTree_UserFieldsChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
  protected
    fShowDialog, fReadOnlyMode : boolean;
  private
    fCustomFieldDat : TFileVar;

    procedure PopulateDataTree();
    procedure EditField(node : PVirtualNode);
    procedure SaveEditedFields;
  public
    procedure SaveData(fieldData : TNodeData);
    property ShowDialog : boolean read fShowDialog write fShowDialog;
    property ReadOnlyMode : boolean read fReadOnlyMode write fReadOnlyMode;
  end;
implementation

Uses
  BtrvU2,
  BTKeys1U,
  BTSupU2,
  CustomFieldsVar,
  CustomFieldsIntf,
  UserFieldEdit,
  BTUtil,
  ADOConnect;

{$R *.dfm}

constructor TNodeData.Create(fieldIndex : longint; caption: string; chBoxEnabled : boolean;
                             chBoxChecked : boolean; imageIndex : Integer; aContainsPIIData: Boolean;
                             aPIIFieldVisible: Boolean);
begin
   fFieldIndex := fieldIndex;
   fCaption := caption;
   fChBoxEnabled := chBoxEnabled;
   fChBoxChecked := chBoxChecked;
   fImageIndex := imageIndex;
   fEditFlag := false;
   fContainsPIIData := aContainsPIIData;
   fPIIFieldVisible := aPIIFieldVisible and GDPROn;
end;

{ -------- Form Events -------- }

procedure TFrm_UserFieldConfig.FormCreate(Sender: TObject);
begin
  //Load Customfields.dat
  PopulateDataTree;

  showDialog := true;
end;

procedure TFrm_UserFieldConfig.FormActivate(Sender: TObject);
begin
  //Stop FormActivate from being called more than once.
  //RB 27/11/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
  //Adjusted width of form and position of buttons such that the PII column is visible.
  self.OnActivate := nil;

  self.ClientHeight := 322;
  self.ClientWidth := 502;
  self.Caption := 'User Defined Field Configuration';

  with VSTree_UserFields do
  begin
    Left := 6;
    Top := 6;
    Width := 398;
    Height := 292;
  end;

  with Btn_Ok do
  begin
    Left := 408;
    Top := 5;
    Width := 80;
    Height := 21;
  end;

  with Btn_Cancel do
  begin
    Left := 408;
    Top := 28;
    Width := 80;
    Height := 21;
  end;

  with Btn_Edit do
  begin
    Left := 408;
    Top := 82;
    Width := 80;
    Height := 21;
  end;

  with Image1 do
  begin
    Left := 6;
    Top := 301;
    Width := 127;
    Height := 18;
  end;
end;

procedure TFrm_UserFieldConfig.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   //Save any edited fields before exiting.
   SaveEditedFields;
   Action := caFree;
end;

{ -------- TreeView Events -------- }

//RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
//2nd column contains PII Field status information.
procedure TFrm_UserFieldConfig.VSTree_UserFieldsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  NodeD: ^rTreeNodeData;
begin
  NodeD := Sender.GetNodeData(Node);

  if NodeD.NodeData = nil then
    Text := ''
  else
  begin
    if Column = 0 then
      CellText := NodeD.NodeData.fCaption
    else if (Column = 1) then
    begin
      CellText := '';
      if NodeD.NodeData.fFieldIndex <> -1 then
      begin
        if NodeD.NodeData.fPIIFieldVisible then
        begin
          case NodeD.NodeData.fContainsPIIData of
            True: CellText := 'PII: YES';
            False: CellText := 'PII: NO';
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrm_UserFieldConfig.VSTree_UserFieldsGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeD : ^rTreeNodeData;
begin
  if Column = 1 then Exit;
  NodeD := Sender.GetNodeData(Node);
  //If the node is a category check its' expanded status and set the image accordingly
  //otherwise use whatever field # image is set
  if (NodeD.NodeData.fImageIndex in [0,1]) then
  begin
    if (vsExpanded in Node.States) then
      ImageIndex := 1
    else
      ImageIndex := 0;
  end
  else
    ImageIndex := NodeD.NodeData.fImageIndex;
end;
procedure TFrm_UserFieldConfig.VSTree_UserFieldsChecking(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
begin
  if (readOnlyMode) then
  begin
    Node.CheckState := Node.CheckState;
    Allowed := false;
  end;
  VSTree_UserFields.Refresh;
end;

procedure TFrm_UserFieldConfig.VSTree_UserFieldsChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NodeD: ^rTreeNodeData;
begin
  NodeD := Sender.GetNodeData(Node);
  NodeD.NodeData.fEditFlag := true;

  if (not ReadOnlyMode) then
  begin
    if (Node.CheckState = csCheckedNormal) then
       NodeD.NodeData.fChBoxChecked := true
    else
       NodeD.NodeData.fChBoxChecked := false;

    VSTree_UserFields.Refresh;
  end;
end;

procedure TFrm_UserFieldConfig.VSTree_UserFieldsInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  NodeD: ^rTreeNodeData;
begin
  NodeD := Sender.GetNodeData(Node);

  if (NodeD.NodeData <> nil) then
  begin
    //Check if checkboxes are supported by the field and check it if need be.
    if (NodeD.NodeData.fChBoxEnabled) then
    begin
      Node.CheckType:= ctCheckBox;

      if (NodeD.NodeData.fChBoxChecked) then
        Node.CheckState := csCheckedNormal
      else
        Node.CheckState := csUnCheckedNormal;
    end;
  end;
end;

procedure TFrm_UserFieldConfig.VSTree_UserFieldsDblClick(Sender: TObject);
var
  node : PVirtualNode;
begin
  //Check to see user hasnt clicked in empty space with no selected node.
  node := VSTree_UserFields.FocusedNode;

  if (node <> nil) and (not ReadOnlyMode) then
    EditField(node);
end;

procedure TFrm_UserFieldConfig.VSTree_UserFieldsKeyAction(
  Sender: TBaseVirtualTree; var CharCode: Word; var Shift: TShiftState;
  var DoDefault: Boolean);
var
  node : PVirtualNode;
begin
  //Check to see user hasnt clicked in empty space with no selected node.
  node := VSTree_UserFields.FocusedNode;

  //Character #13 = Enter/Numpad Enter
  if (node <> nil) and (charCode = 13) and (not ReadOnlyMode) then
    EditField(node);
end;

{ -------- PMenu Events -------- }

procedure TFrm_UserFieldConfig.MenItem_ExpandClick (Sender: TObject);
begin
  VSTree_UserFields.FullExpand(nil);
end;

procedure TFrm_UserFieldConfig.MenItem_CollapseClick(Sender: TObject);
begin
  VSTree_UserFields.FullCollapse(nil);
end;

{ -------- Button Events -------- }

procedure TFrm_UserFieldConfig.Btn_OKClick(Sender: TObject);
begin
  showDialog := false;
  Close;
end;

procedure TFrm_UserFieldConfig.Btn_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_UserFieldConfig.Btn_EditClick(Sender: TObject);
var
  node : PVirtualNode;
begin
  //Check to see user hasnt clicked in empty space with no selected node.
  node := VSTree_UserFields.FocusedNode;

  //Character #13 = Enter/Numpad Enter
  if (node <> nil) then
    EditField(node);
end;

//-------------------------------------------------------------------------

// MH 17/04/2012 v6.10 ABSEXCH-12748: Rewrote data access for maintainability and to implement module licensing correctly
procedure TFrm_UserFieldConfig.PopulateDataTree();
var
  result : integer;
  customField : TCustomFieldSettings;
  searchKeys : Str255;
  parentNode, oTransNode : PVirtualNode;

  // Fields added for SQL specific variant
  sqlCaller : TSQLCaller;
  fldFieldId : TIntegerField;
  fldSupportsEnablement : TBooleanField;
  fldEnabled : TBooleanField;
  fldCaption : TStringField;
  fldContainsPIIData: TBooleanField;
  fldDisplayPIIOption: TBooleanField;
  CompanyCode, ConnectionString, sqlQuery, lPassword : WideString;

  //------------------------------

  function AddCatagoryHeading (Const ParentNode : PVirtualNode; Const CatagoryDesc : ShortString) : PVirtualNode;
  var
    NodeD : ^rTreeNodeData;
  Begin // AddCatagoryHeading
    Result := VSTree_UserFields.AddChild(ParentNode);
    NodeD := VSTree_UserFields.GetNodeData(Result);
    NodeD.NodeData := TNodeData.Create(-1, CatagoryDesc, false, false, 0, false, false);
  End; // AddCatagoryHeading

  //------------------------------

  //RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
  Procedure AddRange (Const RangeParentNode : PVirtualNode;
                      Const RangeStart, RangeEnd : LongInt);
  Var
    customField : TCustomFieldSettings;
    newSubItemNode : PVirtualNode;
    NodeD : ^rTreeNodeData;
    I, iStatus : LongInt;
    sKey : Str255;
  Begin // AddRange
    If SQLUtils.UsingSQLAlternateFuncs Then
    Begin
      // Pull the required information out of the dataset
      For I := RangeStart To RangeEnd Do
      Begin
        If sqlCaller.Records.Locate('cfFieldID', I, []) Then
        Begin
          newSubItemNode := VSTree_UserFields.AddChild(RangeParentNode);
          NodeD := VSTree_UserFields.GetNodeData(newSubItemNode);
          NodeD.NodeData := TNodeData.Create(fldFieldId.Value, fldCaption.Value, fldSupportsEnablement.Value, fldEnabled.Value, (fldFieldId.Value Mod 1000) + 1, fldContainsPIIData.Value, fldDisplayPIIOption.Value);
        End; // If sqlCaller.Records.Locate('cfFieldID', I, [])
      End; // For I
    End // If SQLUtils.UsingSQLAlternateFuncs
    Else
    Begin
      // Pervasive Edition or fancy SQL turned off
      sKey := FullNomKey(RangeStart);
      iStatus := BTFindRecord(B_GetGEq, fCustomFieldDat, CustomField, SizeOf(CustomField), 0, sKey);
      While (iStatus = 0) And (CustomField.cfFieldID >= RangeStart) And (CustomField.cfFieldID <= RangeEnd) Do
      Begin
        newSubItemNode := VSTree_UserFields.AddChild(RangeParentNode);
        NodeD := VSTree_UserFields.GetNodeData(newSubItemNode);
        NodeD.NodeData := TNodeData.Create(CustomField.cfFieldID, CustomField.cfCaption, CustomField.cfSupportsEnablement, CustomField.cfEnabled, (CustomField.cfFieldID Mod 1000) + 1
                                                            , CustomField.cfContainsPIIData, CustomField.cfDisplayPIIOption);

        iStatus := BTFindRecord(B_GetNext,fCustomFieldDat, CustomField, SizeOf(CustomField), 0, sKey);
      End; // While (iStatus = 0) ...
    End; // Else
  End; // AddRange

  //------------------------------

  //RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
  Procedure AddCatagory(Const ParentNode : PVirtualNode;
                        Const CatagoryDesc : ShortString;
                        Const RangeStart, RangeEnd : LongInt;
                        Const SubRangeStart : LongInt = 0;
                        Const SubRangeEnd : LongInt = 0);
  var
    newCatagoryNode, newSubCatagoryNode : PVirtualNode;
    NodeD : ^rTreeNodeData;
  Begin // AddCatagory
    // Create the catagory header
    newCatagoryNode := VSTree_UserFields.AddChild(ParentNode);
    NodeD := VSTree_UserFields.GetNodeData(newCatagoryNode);
    NodeD.NodeData := TNodeData.Create(-1, CatagoryDesc, false, false, 0, false, false);

    // If defined create the sub-catagory and add the sub-range into it
    If (SubRangeStart <> 0) And (SubRangeEnd <> 0) Then
    Begin
      newSubCatagoryNode := VSTree_UserFields.AddChild(newCatagoryNode);
      NodeD := VSTree_UserFields.GetNodeData(newSubCatagoryNode);
      NodeD.NodeData := TNodeData.Create(-1, 'Data Entry Lines', false, false, 0, false, false);

      // Add the sub-range into the new sub-catagory
      AddRange (newSubCatagoryNode, SubRangeStart, SubRangeEnd);
    End; // If (SubRangeStart <> 0) And (SubRangeEnd <> 0)

    // Add the range into the main catagory
    AddRange (newCatagoryNode, RangeStart, RangeEnd);
  End; // AddCatagory

  //------------------------------

  Procedure LoadTreeStructure;
  Begin // LoadTreeStructure
    //RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
    // Accounts
    parentNode := AddCatagoryHeading (Nil, 'Accounts');
    //     Customers
    AddCatagory (parentNode, 'Customers', 1001, 1015, 0, 0);
    //     Suppliers
    AddCatagory (parentNode, 'Suppliers', 2001, 2015, 0, 0);

    // Financial
    parentNode := AddCatagoryHeading (Nil, 'Financial');
    //     Line Types
    AddCatagory (parentNode,  'Line Types', 3001, 3004);
    //     Sales Transactions
    oTransNode := AddCatagoryHeading (parentNode, 'Sales Transactions');
    //         Invoice Types (SIN, SCR, SJI, SJC, SRI, SRF)
    //             Data Entry Lines
    // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
    AddCatagory (oTransNode, 'Invoice Types (SIN, SCR, SJI, SJC, SRI, SRF)', 4001, 4012, 5001, 5010);
    //         Receipts (SRC)
    //             Data Entry Lines
    // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
    AddCatagory (oTransNode, 'Receipts (SRC)', 6001, 6012, 7001, 7010);
    //         Quotations (SQU)
    //             Data Entry Lines
    // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
    AddCatagory (oTransNode, 'Quotations (SQU)', 8001, 8012, 9001, 9010);
    {$IFDEF SOP}
      //         Order & Delivery Notes (SOR, SDN)
      //             Data Entry Lines
      // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
      AddCatagory (oTransNode, 'Order & Delivery Notes (SOR, SDN)', 10001, 10012, 11001, 11010);
    {$ENDIF} // SOP
    //     Purchase Transactions
    oTransNode := AddCatagoryHeading (parentNode, 'Purchase Transactions');
    //         Invoice Types (PIN, PCR, PJI, PJC, PPI, PRF)
    //             Data Entry Lines
    // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
    AddCatagory (oTransNode, 'Invoice Types (PIN, PCR, PJI, PJC, PPI, PRF)', 12001, 12012, 13001, 13010);
    //         Payments (PPY)
    //             Data Entry Lines
    // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
    AddCatagory (oTransNode, 'Payments (PPY)', 14001, 14012, 15001, 15010);
    //         Quotations (PQU)
    //             Data Entry Lines
    // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
    AddCatagory (oTransNode, 'Quotations (PQU)', 16001, 16012, 17001, 17010);
    {$IFDEF SOP}
      //         Order & Delivery Notes (POR, PDN)
      //             Data Entry Lines
      // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
      AddCatagory (oTransNode, 'Order & Delivery Notes (POR, PDN)', 18001, 18012, 19001, 19010);
    {$ENDIF} // SOP
    //     Nominal Journal (NOM)
    //         Data Entry Lines
    // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
    AddCatagory (parentNode, 'Nominal Journal (NOM)', 20001, 20012, 21001, 21010);

    {$IFDEF STK}
      // Stock Control
      parentNode := AddCatagoryHeading (Nil, 'Stock Control');
      //     Stock Record
      AddCatagory (parentNode, 'Stock Record', 22001, 22010);
      //     Stock Adjustment (ADJ)
      //         Data Entry Lines
      // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
      AddCatagory (parentNode, 'Stock Adjustment (ADJ)', 23001, 23012, 24001, 24010);

      If WOPOn Then
      Begin
        //     Works Order (WOR)
        //         Data Entry Lines
        // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
        AddCatagory (parentNode, 'Works Order (WOR)', 25001, 25012, 26001, 26010);
      End; // If WOPOn
    {$ENDIF} // STK

    // Check for Job Costing Licensing
    If JBCostOn Then
    Begin
      // Job Costing
      parentNode := AddCatagoryHeading (Nil, 'Job Costing');
      //     Job Record
      AddCatagory (parentNode, 'Job Record', 27001, 27010, 0, 0);
      //     Employee Record (Note: 1-4 only)
      AddCatagory (parentNode, 'Employee Record', 28001, 28004, 0, 0);
      //     Timesheet
      //         Data Entry Lines
      // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
      AddCatagory (parentNode, 'Timesheet (TSH)', 29001, 29012, 30001, 30010);

      // Check for Apps & Vals Licensing
      If JAPOn Then
      Begin
        //     Applications
        oTransNode := AddCatagoryHeading (parentNode, 'Applications');
        //         Purchase Applications (JPA)
        //             Data Entry Lines
        // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
        AddCatagory (oTransNode, 'Purchase Applications (JPA)', 41001, 41012, 42001, 42010);
        //         Sales Applications (JSA)
        //             Data Entry Lines
        // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
        AddCatagory (oTransNode, 'Sales Applications (JSA)', 43001, 43012, 44001, 44010);
        //     Terms
        oTransNode := AddCatagoryHeading (parentNode, 'Terms');
        //         Contract Terms (JCT)
        //             Data Entry Lines
        // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
        AddCatagory (oTransNode, 'Contract Terms (JCT)', 35001, 35012, 36001, 36010);
        //         Purchase Terms (JPT)
        //             Data Entry Lines
        // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
        AddCatagory (oTransNode, 'Purchase Terms (JPT)', 37001, 37012, 38001, 38010);
        //         Sales Terms (JST)
        //             Data Entry Lines
        // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
        AddCatagory (oTransNode, 'Sales Terms (JST)', 39001, 39012, 40001, 40010);
      End; // If JAPOn
    End; // If JBCostOn

    // Check for Returns Module Licensing
    If RetMOn Then
    Begin
      // Returns
      parentNode := AddCatagoryHeading (Nil, 'Returns');
      //     Sales Return (SRN)
      //         Data Entry Lines
      // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
      AddCatagory (parentNode, 'Sales Return (SRN)', 31001, 31012, 32001, 32010);
      //     Purchase Return (PRN)
      //         Data Entry Lines
      // PKR. 06/04/2016. ABSEXCH-17383. Extended UDF range to 12 for transaction headers.
      AddCatagory (parentNode, 'Purchase Return (PRN)', 33001, 33012, 34001, 34010);
    End; // If RetMOn

    // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom labelling for address fields
    parentNode := AddCatagoryHeading (Nil, 'General');
    AddCatagory (parentNode, 'Address', 45001, 45005);

    // PKR. 06/04/2016. Add custom labelling for Tax Regions
    AddCatagory(parentNode, 'Tax Regions', 46001, 46002);
  End; // LoadTreeStructure

  //------------------------------

begin
  { *Image Indexes: 0 Open folder, 1 Closed Folder, 2..11 Field #1-10* }
  result := BTOpenFile(fCustomFieldDat, SetDrive + 'Misc\Customfields.dat', 0, nil, Ownername^);

  if (result = 0) then
  begin
    VSTree_UserFields.NodeDataSize := SizeOf(rTreeNodeData);

    // Lock the Customer UDef 1 row to prevent multi-user editing
    searchKeys := FullNomKey(1001) + '!';
    result := BTFindRecord(B_GetEq + B_SingNWLock, fCustomFieldDat, customField, SizeOf(customField), 0, searchKeys);

    If (Result = 4) Then
    Begin
      // Customer UDef 1 missing
      Btn_Edit.Enabled := false;
      Btn_Ok.Enabled := false;

      Btn_Cancel.Caption := 'Close';
      ReadOnlyMode := true;

      MessageDlg('The information for Customer User Defined 1 could not be found', mtError, [mbOK], 0);
    End // If (Result = 4)
    Else if (result in [84..85]) then
    begin
      Btn_Edit.Enabled := false;
      Btn_Ok.Enabled := false;

      Btn_Cancel.Caption := 'Close';
      ReadOnlyMode := true;

      MessageDlg('The user fields are currently being edited by another user, you will not be able to change any fields until the user is finished.', mtWarning , [mbOK], 0);
      BTFindRecord(B_GetFirst,fCustomFieldDat,customField,SizeOf(customField),0,searchKeys);
    end
    else
      ReadOnlymode := false;

    //------------------------------

    If SQLUtils.UsingSQLAlternateFuncs Then
    Begin
      // Use a single SQL call to populate a dataset with all required rows in 1 round trip
      //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
      sqlCaller := TSQLCaller.Create(GlobalAdoConnection);
      Try
        // Get Company Admin Connection String - Read-Only doesn't have rights to run this
        CompanyCode := GetCompanyCode(SetDrive);
        //If (GetConnectionString(CompanyCode, False, ConnectionString) = 0) Then
        If (GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword) = 0) Then
        Begin
          sqlQuery := 'Select cfFieldID, cfSupportsEnablement, cfEnabled, cfCaption, cfContainsPIIData, cfDisplayPIIOption ' +
                      'From [COMPANY].CustomFields ' +
                      'Order By cfFieldId';

          sqlCaller.Select(sqlQuery, CompanyCode);
          Try
            If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0) Then
            Begin
              fldFieldId := sqlCaller.Records.FieldByName('cfFieldID') As TIntegerField;
              fldSupportsEnablement := sqlCaller.Records.FieldByName('cfSupportsEnablement') As TBooleanField;
              fldEnabled := sqlCaller.Records.FieldByName('cfEnabled') As TBooleanField;
              fldCaption := sqlCaller.Records.FieldByName('cfCaption') As TStringField;
              fldContainsPIIData := sqlCaller.Records.FieldByName('cfContainsPIIData') As TBooleanField;
              fldDisplayPIIOption := sqlCaller.Records.FieldByName('cfDisplayPIIOption') As TBooleanField;

              // Call full/summary report specific routines to process the returned datasets due to differences in columns returned and totalling
              sqlCaller.Records.DisableControls;
              Try
                LoadTreeStructure;
              Finally
                sqlCaller.Records.EnableControls;
              End; // Try..Finally
            End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
            Else If (sqlCaller.ErrorMsg <> '') Then
              ;//WriteSQLErrorMsg (sqlCaller.ErrorMsg);
          Finally
            sqlCaller.Close;
          End; // Try..Finally
        End; // If (GetConnectionString(CompanyCode, False, ConnectionString) = 0)
      Finally
        sqlCaller.Free;
      End; // Try..Finally
    End // If SQLUtils.UsingSQLAlternateFuncs
    Else
    Begin
      // Pervasive Edition or fancy SQL turned off
      LoadTreeStructure;
    End; // Else
  end//end if
  else
    DisplayError('There was an error opening the custom field settings' , result);
end;

procedure TFrm_UserFieldConfig.EditField(node : PVirtualNode);
var
  NodeD : ^rTreeNodeData;
  form : TFrm_FieldEdit;
begin
  NodeD := VSTree_UserFields.GetNodeData(node);

  //Check the node isnt a category node.
  if (NodeD.NodeData.fFieldIndex <> -1) then
  begin
    form := TFrm_FieldEdit.Create(self);
    form.PopulateUserFieldData(self, NodeD);
    form.ShowModal();

    //If Edited update the treeview data
    if (form.ModalResult = mrOK) then
    begin
      NodeD.NodeData.fChBoxChecked := form.UserFieldData.ChBoxChecked;
      NodeD.NodeData.fCaption := form.UserFieldData.Caption;
      NodeD.NodeData.fEditFlag := true;
      NodeD.NodeData.fContainsPIIData := form.UserFieldData.ContainsPIIData;
     
      if (form.UserFieldData.ChBoxChecked) then
        VSTree_UserFields.FocusedNode.CheckState := csCheckedNormal
      else
        VSTree_UserFields.FocusedNode.CheckState := csUnCheckedNormal;
     end;

     VSTree_UserFields.Refresh;
     form.Free;
  end;
end;

procedure TFrm_UserFieldConfig.SaveEditedFields;
var
  node, lastNode : PVirtualNode;
  NodeD : ^rTreeNodeData;
  saveFields : boolean;
  customField : TCustomFieldSettings;
  searchKeys : Str255;
  result : longint;
begin
  node := VSTree_UserFields.GetFirst;
  lastNode := node;

  //If showDialog is true then either the cancel button or the close button
  //has been clicked therefore show a dialog to warn the user that changes 
  //have been made(if they have) and offer to save them.
  if not (showDialog) then
    saveFields := true
  else
    saveFields := false;

  while (node <> nil) do
  begin
    nodeD := VSTree_UserFields.GetNodeData(node);

    if (nodeD.NodeData.fEditFlag) then
    begin
      if (showDialog) then
      begin
        if (Application.MessageBox('You have unsaved changes would you like to save them?', 'Warning', MB_YesNo + MB_DEFBUTTON1) = IDYes) then
        begin
           saveFields := true;
           showDialog := false;
        end
        else
          break;
      end;

      if (saveFields) then
         SaveData(nodeD.NodeData);
    end;
    node := VSTree_UserFields.GetNext(lastNode);
    lastNode := node;
  end;

  //Unlock file if it has been locked.
  if (not ReadOnlyMode) then
  begin
    searchKeys := FullNomKey(1001) + '!';
    result := BTFindRecord(B_GetEq, fCustomFieldDat, customField, SizeOf(customField), 0, searchKeys);
    if (result = 0) then
    begin
      result := BTFindRecord(B_UnLock,fCustomFieldDat,customField,SizeOf(customField),0,searchKeys);
      if (result <> 0) then
        DisplayError('There was an error unlocking the custom field file', result);
    end;
  end;

  BTCloseFile(fCustomFieldDat);

  //PR: 27/10/2011 v6.9 Releases the Custom Fields object so it will reload when next accessed.
  ClearCustomFields;
end;

procedure TFrm_UserFieldConfig.SaveData(fieldData : TNodeData);
var
  result : longint;
  indexKey : Str255;
  CustomFieldSettings : TCustomFieldSettings;
  focusedNode : PVirtualNode;
begin
  indexKey := BTFullNomKey(fieldData.fFieldIndex) + '!';

  //Attempt to find new record index.
  result := BTFindRecord(B_GetEq,fCustomFieldDat,CustomFieldSettings,SizeOf(CustomFieldSettings),0,indexKey);

  //Assign caption and enabled flags then perform an update if record is found.
  if (result = 0) then
  begin
    CustomFieldSettings.cfEnabled := fieldData.fChBoxChecked;
    CustomFieldSettings.cfCaption := fieldData.fCaption;
    CustomFieldSettings.cfContainsPIIData := fieldData.fContainsPIIData;

    result := BTUpdateRecord(fCustomFieldDat, CustomFieldSettings, SizeOf(CustomFieldSettings), 0, indexKey);

    if (result = 0) then
    begin
      //Necessary hack, when the text is changed to something longer than the selection
      //due to the length of the previous selection the text can be cut off so i
      //reselect the node.
      focusedNode :=  VSTree_UserFields.FocusedNode;
      VSTree_UserFields.FocusedNode := nil;
      VSTree_UserFields.FocusedNode := focusedNode;
    end
    else
      DisplayError('There was an error updating the custom field', result);
  end
  else
    DisplayError('Could not find custom field', result);
end;

procedure TFrm_UserFieldConfig.DisplayError(operation : string; errorCode : integer);
begin
  MessageDlg(Format('%s. Error code: %d',[operation, errorCode]), mtError , [mbOK], 0);
end;

procedure TFrm_UserFieldConfig.VSTree_UserFieldsChange(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NodeD: ^rTreeNodeData;
begin
  //GS 19/01/2012 ABSEXCH-12409: disable the edit button if a tree item with a folder icon is selected
  //if the user is allowed to edit UDFs..
  //- check if node is null, this event fires with a null node sometimes.. causes crash if not filtered
  if (Not ReadOnlyMode) and Assigned(Node) then
  begin
    //grab the node data
    NodeD := Sender.GetNodeData(Node);
    //if the node has an imageindex of 0 or 1 (closedfolder / openfolder icon)
    //then disable the edit button
    if NodeD.NodeData.fImageIndex in [0..1] then
    begin
      Btn_Edit.Enabled := False;
    end
    else
    begin
      Btn_Edit.Enabled := True;
    end;
  end;
end;

end.
