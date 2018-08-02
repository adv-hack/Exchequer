unit CustomFieldsIntf;

interface
{
  TCustomFields is an object which allows read-only access to the new Custom
  Fields data. Calling the CustomFields method returns a singleton which can be
  treated as an 2-dimensional array of ICustomField interfaces indexed by
  Category (constants listed below) and Index (number of User Field). Eg

      lblUDF5.Caption := CustomFields[cfCustomer, 5].cfCaption;

  The object loads the data automatically when first accessed. To refresh the
  data, for example when changing companies or when storing changes via system
  setup, call the ClearCustomFields procedure.

  When used within Enter1, the data path will be taken automatically from
  SetDrive. If you are using the object in any other application, you will need
  to set the data path explicitly by calling SetCustomFieldsPath.
}

uses
  CustomFieldsVar, BtrvU2, BTUtil, BTConst, ExtCtrls, TEditVal, Controls,
  Graphics, SysUtils, StdCtrls, SQLUtils, VarConst, SQLCallerU
  {$IF DEFINED(ENTER1) or DEFINED(DRILL) or DEFINED(RW)}, GlobVar{$IFEND};

const
  // PKR. 05/04/2016. ABSEXCH-17383. Add 2 UDFs for transaction headers to support eRCT.
  //Accounts
  cfCustomer     = 1; // 15 fields
  cfSupplier     = 2; // 15 fields

  //Line types
  cfLinetypes    = 3; // 4 fields

  //Sales trans + lines
  cfSINHeader    = 4;
  cfSINLine      = 5;
  cfSRCHeader    = 6;
  cfSRCLine      = 7;
  cfSQUHeader    = 8;
  cfSQULine      = 9;
  cfSORHeader    = 10;
  cfSORLine      = 11;

  //Purchase trans + lines
  cfPINHeader    = 12;
  cfPINLine      = 13;
  cfPRCHeader = 14;
  cfPPYHeader = 14;
  cfPRCLine = 15;
  cfPPYLine = 15;
  
  cfPQUHeader    = 16;
  cfPQULine      = 17;
  cfPORHeader    = 18;
  cfPORLine      = 19;

  //Nominals
  cfNOMHeader    = 20;
  cfNOMLine      = 21;

  //Stock
  cfStock        = 22;
  cfADJHeader    = 23;
  cfADJLine      = 24;
  cfWORHeader    = 25;
  cfWORLine      = 26;

  //Job Costing
  cfJob          = 27;
  cfEmployee     = 28;
  cfTSHHeader    = 29;
  cfTSHLine      = 30;

  //Returns  added 23/11/2011
  cfSRNHeader    = 31;
  cfSRNLine      = 32;
  cfPRNHeader    = 33;
  cfPRNLine      = 34;

  //PR: 24/02/2012 Apps and Vals v6.10 ABSEXCH-12128
  cfJCTHeader    = 35;
  cfJCTLine      = 36;
  cfJPTHeader    = 37;
  cfJPTLine      = 38;
  cfJSTHeader    = 39;
  cfJSTLine      = 40;
  cfJPAHeader    = 41;
  cfJPALine      = 42;
  cfJSAHeader    = 43;
  cfJSALine      = 44;

  // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom fields for Addresses
  cfAddressLabels = 45; // 5 fields
  // PKR. 05/04/2016. Additional 2 fields for Tax Region.
  cfTaxRegion     = 46; // 2 fields
  //============================================================================
  // NOTE. If any new Custom Fields/Categories are added you must extend the
  // appropiate sets below.
  //============================================================================

  //PR: 23/11/2011 added Cat4Set for categories with only 4 udfs (LineTypes & Employees)
  Cat4Set      = [cfLineTypes, cfEmployee];

  // These categories have 15 fields
  CatTraderSet = [cfCustomer, cfSupplier];

  // PKR. 05/04/2016. ABSEXCH-17383 - Add 2 UDFs to Transaction Headers for eRCT support
  //                  ABSEXCH-15814 - Stop Pervasive crashing when new custom fields added.
  // Create some sets that define categories with common sizes

  // These categories have 12 fields
  CatHeaderSet = [cfSINHeader, cfSRCHeader, cfSQUHeader, cfSORHeader, cfPINHeader,
                  cfPRCHeader, cfPPYHeader, cfPQUHeader, cfPORHeader, cfNOMHeader,
                  cfADJHeader, cfWORHeader, cfTSHHeader, cfSRNHeader, cfPRNHeader,
                  cfJCTHeader, cfJPTHeader, cfJSTHeader, cfJPAHeader, cfJSAHeader]; // Have 12 entries

  // These categories have 10 fields
  CatLineSet   = [cfSINLine, cfSRCLine, cfSQULine, cfSORLine, cfPINLine, cfPRCLine,
                  cfPPYLine, cfPQULine, cfPORLine, cfNOMLine, cfStock, cfADJLine,
                  cfWORLine, cfJob, cfEmployee, cfTSHLine, cfSRNLine, cfPRNLine,
                  cfJCTLine, cfJPTLine, cfJSTLine, cfJPALine, cfJSALine]; // Have 10 entries

  // Both of the Header and Line sets combined.  The default captions are all 'User Def n'
  //  so can be treated together when setting their captions.
  CatUdfSet    = CatHeaderSet + CatLineSet;

  // This category has 5 fields
  CatAddressSet = [cfAddressLabels];
  
  // This category has 2 fields
  CatTaxRegionSet = [cfTaxRegion];

//const
  // PKR. 05/04/2016. ABSEXCH-15814 - Stop Pervasive crashing when new custom fields added.
  // This constant is unused as the array is now dynamic.
//  NO_OF_CUSTOM_FIELDS = 455;  //There are only 294 fields but to make indexing easier we allow 10 fields for
                              // each category but only access 1..4 of Line Types.
                              //PR: 23/11/2011 Added returns so increased fields to 340
                              //PR: 20/03/2012 Increased fields to 440 to accommodate Apps & Vals ABSEXCH-12128
                              // MH 10/11/2014 OrdPay: Added 10 new fields for rebadged Credit Card fields
                              // MH 17/12/2014 v7.1 ABSEXCH-15855: Added 5 new custom fields for Addresses


type
  ICustomField = Interface
  ['{1286A93F-36AB-466B-B9A7-0874ACC3D2DE}']
    function Get_cfEnabled : Boolean;
    property cfEnabled : Boolean read Get_cfEnabled;

    function Get_cfSupportsEnablement : Boolean;
    property cfSupportsEnablement : Boolean read Get_cfSupportsEnablement;

    function Get_cfCaption : string;
    property cfCaption : string read Get_cfCaption;

    function Get_cfDescription : string;
    property cfDescription : string read Get_cfDescription;

    function Get_cfCategory : Integer;
    property cfCategory : Integer read Get_cfCategory;

    //RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
    function Get_cfDisplayPIIOption: Boolean;
    property cfDisplayPIIOption: Boolean read Get_cfDisplayPIIOption;
    function Get_cfContainsPIIData: Boolean;
    property cfContainsPIIData: Boolean read Get_cfContainsPIIData;

    function Get_cfIndex : Integer;
    property cfIndex : Integer read Get_cfIndex;
  end;


  TCustomField = Class(TInterfacedObject, ICustomField)
  private
    FDataRec : TCustomFieldSettings;
  public
    function Get_cfEnabled : Boolean;
    property cfEnabled : Boolean read Get_cfEnabled;

    function Get_cfSupportsEnablement : Boolean;
    property cfSupportsEnablement : Boolean read Get_cfSupportsEnablement;

    function Get_cfCaption : string;
    property cfCaption : string read Get_cfCaption;

    function Get_cfDescription : string;
    property cfDescription : string read Get_cfDescription;

    function Get_cfCategory : Integer;
    property cfCategory : Integer read Get_cfCategory;

    //RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
    function Get_cfDisplayPIIOption: Boolean;
    property cfDisplayPIIOption: Boolean read Get_cfDisplayPIIOption;
    function Get_cfContainsPIIData: Boolean;
    property cfContainsPIIData: Boolean read Get_cfContainsPIIData;

    function Get_cfIndex : Integer;
    property cfIndex : Integer read Get_cfIndex;

    procedure SetDataRec(const ADataRec : TCustomFieldSettings);
  end;

  TCustomFields = Class
  protected
    FDataPath : string;
    function GetField(Category, Index : Integer) : TCustomFieldSettings; virtual; abstract;
    procedure LoadFields; virtual; abstract;
    procedure Initialise; virtual; abstract;
    procedure Finalise; virtual; abstract;
    function ValidIndex(Category, Index : Integer) : Boolean;
    function MakeFieldIndex(Category, Index : Integer) : Integer; virtual; abstract;
  public
    constructor Create(const ADataPath : string);
    destructor Destroy; override;
    function Get_Field(Category, Index : Integer) : ICustomField;
    function GetNewFieldIndex(searchKey : string; fieldIndex : longint) : longint;
    function GetFieldEnabled(oldRecord : string; fieldIndex : longint) : boolean;
  property Field[Category, Index : Integer] : ICustomField read Get_Field; default;
  end;

  TPervasiveCustomFields = Class(TCustomFields)
  private
//    FDataRecs : Array[1..NO_OF_CUSTOM_FIELDS] of TCustomFieldSettings;
    // PKR. 05/04/2016. ABSEXCH-15814. Class crashes after adding new field.
    // Made array dynamic so that we don't have to manually adjust the size when new fields are added
    fDataRecs : array of TCustomFieldSettings;
  protected
    function MakeFieldIndex(Category, Index : Integer) : Integer; override;
    function GetField(Category, Index : Integer) : TCustomFieldSettings; override;
    procedure LoadFields; override;
    procedure Initialise; override;
    procedure Finalise; override;
  end;

  TSQLCustomFields = Class(TCustomFields)
  private
    FCaller : TSQLCaller;
    procedure CopyFields(var DataRec : TCustomFieldSettings);
  protected
    function MakeFieldIndex(Category, Index : Integer) : Integer; override;
    function GetField(Category, Index : Integer) : TCustomFieldSettings; override;
    procedure LoadFields; override;
    procedure Initialise; override;
    procedure Finalise; override;
  end;


  function CustomFields : TCustomFields;
  procedure ClearCustomFields;


  {$IFNDEF ENTER1}
  //PL 12/01/2017 2017-R1 ABSEXCH-17461 : Cannot perform this operation on a closed dataset error for hosted customers when using OLE drilldown.
  function GetCustomFieldsPath : String;
  procedure SetCustomFieldsPath(const ADataPath : string);
  {$ENDIF}

  // Function to arrange a set of edits and labels to cover up any gaps caused by invisible udfs.
  procedure ArrangeUDFs(const Captions : Array of TLabel; const Edits : Array of TCustomEdit);

  //Function to return the number of udfs in an array which are visible.
  function NumberOfVisibleUDFs(const Edits : Array of TCustomEdit) : Integer;

  //procedure to adjust the height of the parent control of the UDEFs
  //so that multiple hidden fields do not leave blank spaces.

  //Parameters:
  //VisibleFieldCount     - the number of UDFs that have their visibility property set to true
  //RowCount              - the number of UDFs that make up a row on the user interface
  //                        (typically UDFs are positioned on the UI as 1(c)olumn x 10(r)ow, 2c x 5r, 5c x 2r)
  //ParentContainer       - the control that contains the UDF controls (such as a TForm or TSBSExtendedForm)
  //RowHEightOverRide      - over-ride the default height value; adjust the target control by this many pixels for each row that is hidden
  // UDF_Count            - the total number of UDFs
  procedure ResizeUDFParentContainer(VisibleFieldCount: Integer; RowLength: Integer; ParentContainer: TObject; RowHeightOverRide: Integer = 0; UDF_Count: Integer = 10);

  //procedure to enable Udf TEdits and set the captions on their associated labels; if Arrange is not false then it will also call ArrangeUDFs
  procedure EnableUDFs(const Captions : Array of TLabel; const Edits : Array of TCustomEdit; ACategory : Integer; Arrange : Boolean = True);

  //Procedure to return correct Custom Field category from a DocType - Enter 1 only
  {$IF DEFINED(ENTER1) or DEFINED(DRILL) or DEFINED(SCHEDULER) or DEFINED(SOPDLL)}
  function DocTypeToCFCategory(AType : DocTypes; IsLine : Boolean = False) : Integer;
  {$IFEND}

  //procedure to set a group of captions - used where user fields can't be hidden.
  procedure SetUDFCaptions(const Captions : Array of TLabel; ACategory : Integer);

  //HV 23/11/2017 2018-R1 ABSEXCH-19405: procedure to set a Highlighting PII Fields flag for GDPR
  procedure SetGDPREnabled(AControl: Array of TCustomEdit; ACategory: Integer);


implementation

uses SBSPanel, Forms, ADOConnect, DB;

var
  CustomFieldsObj : TCustomFields;
  CustomFieldsDataPath : string;
//Procedure to return correct Custom Field category from a DocType - Enter 1 only
{$IF DEFINED(ENTER1) or DEFINED(DRILL) or DEFINED(SCHEDULER) or DEFINED(SOPDLL)}
function DocTypeToCFCategory(AType : DocTypes; IsLine : Boolean = False) : Integer;
begin
  Result := 0;
  Case AType of
    SIN,
    SRI,
    SCR,
    SRF,
    SJI,
    SJC   :  Result := cfSINHeader;
    SRC   :  Result := cfSRCHeader;
    SQU   :  Result := cfSQUHeader;
    SOR,
    SDN   :  Result := cfSORHeader;
    PIN,
    PPI,
    PCR,
    PRF,
    PJI,
    PJC   :  Result := cfPINHeader;
    PPY   :  Result := cfPRCHeader;
    PQU   :  Result := cfPQUHeader;
    POR,
    PDN   :  Result := cfPORHeader;
    NMT   :  Result := cfNOMHeader;
    ADJ   :  Result := cfADJHeader;
    WOR   :  Result := cfWORHeader;
    TSH   :  Result := cfTSHHeader;
    SRN   :  Result := cfSRNHeader;
    PRN   :  Result := cfPRNHeader;

    //PR: 25/01/2018 ABSEXCH-19688 Apps/Terms were missed out
    JCT   :  Result := cfJCTHeader;
    JPT   :  Result := cfJPTHeader;
    JST   :  Result := cfJSTHeader;
    JPA   :  Result := cfJPAHeader;
    JSA   :  Result := cfJSAHeader;
  end;

  //Constants for transaction lines are always one more than the constant for
  //the equivalenT header.
  if IsLine then
    Result := Result + 1;
end;
{$IFEND}

//procedure to set a group of captions - used where user fields can't be hidden.
procedure SetUDFCaptions(const Captions : Array of TLabel; ACategory : Integer);
var
  i : integer;
begin
  for i := Low(Captions) to High(Captions) do
    Captions[i].Caption := Trim(CustomFields[ACategory, i + 1].cfCaption);
end;

//HV 23/11/2017 2018-R1 ABSEXCH-19405: procedure to set a Highlighting PII Fields flag for GDPR
procedure SetGDPREnabled(AControl: Array of TCustomEdit; ACategory: Integer);
var
  lSp: TShape;
  i: Integer;
  lPanel: TPanel;
begin
  if IsGDPROn then
  begin
    for i := Low(AControl) to High(AControl) do
    begin
      if (AControl[i].Visible) and (CustomFields[ACategory, i + 1].cfContainsPIIData) then
      begin
        with AControl[i] do
        begin
          Width := Width - 8;
          //HV 28/11/2017 ABSEXCH-19520: Highlight PII fields >UDF for transaction lines are not highlighted.
          lPanel := TPanel.Create(AControl[i]);
          lPanel.Parent := Parent;
          lPanel.Name := 'Shape'+ AControl[i].Name;
          lPanel.Left := Left + Width + 1;
          lPanel.Height := Height - 1;
          lPanel.Top := Top + 1;
          lPanel.Width := 7;
          lPanel.Visible := Visible;
          lPanel.BevelOuter := bvNone;
          lPanel.BorderStyle := bsNone;
          lPanel.Caption := '';

          lSp := TShape.Create(lPanel);
          lSp.Parent := lPanel;
          lSp.Align := alClient;
          if GDPRColor <> 0 then
            lSp.Brush.Color := GDPRColor
          else
            lSp.Brush.Color := GDPRDefaultColor;
          lSp.Brush.Style := bsSolid;
          lSp.Pen.Style := psClear;
          lPanel.BringToFront;
          if AControl[i] is Text8Pt then
            Text8Pt(AControl[i]).GDPREnabled := True;
          if AControl[i] is TEditDate then
            TEditDate(AControl[i]).GDPREnabled := True;
        end;
      end;
    end;
  end;
end;

//procedure to enable Udf TEdits and set the captions on their associated labels; if Arrange is not false then it will also call ArrangeUDFs
procedure EnableUDFs(const Captions : Array of TLabel; const Edits : Array of TCustomEdit; ACategory : Integer; Arrange : Boolean = True);
var
  i : integer;
  HighestVisible : TCustomEdit;
begin
  Assert(High(Edits) = High(Captions), 'Number of edits must equal number of captions.');
  HighestVisible := nil;
  //Run through edits setting visiblity and captions.
  for i := Low(Edits) to High(Edits) do
  begin
    //Open array parameters are zero-based, so convert to one-based CustomFields index.
    if CustomFields[ACategory, i + 1].cfSupportsEnablement then
      Edits[i].Visible := CustomFields[ACategory, i + 1].cfEnabled
    else
      Edits[i].Visible := True;

    Captions[i].Visible := Edits[i].Visible;

    if Edits[i].Visible then
    begin
      //Set caption on associated label
      Captions[i].Caption := Trim(CustomFields[ACategory, i + 1].cfCaption);

      //If we're using a weirdo drop-down thingy, then we need to keep track of the last
      //visible edit so we can set it as FocusLast
      if not Assigned(HighestVisible) or (Edits[i].TabOrder > HighestVisible.TabOrder) then
        HighestVisible := Edits[i];
    end;
  end; //for i

  if Arrange then
    ArrangeUDFs(Captions, Edits);
    
  //HV 23/11/2017 2018-R1 ABSEXCH-19405: procedure to set a Highlighting PII Fields flag for GDPR
  if GDPROn then
    SetGDPREnabled(Edits, ACategory);

  //Assign FocusLast if necessary.
  if Assigned(HighestVisible) and (HighestVisible.Parent is TSBSExtendedForm) then
    with HighestVisible.Parent as TSBSExtendedForm do
      FocusLast := HighestVisible;
end;


procedure ArrangeUDFs(const Captions : Array of TLabel; const Edits : Array of TCustomEdit);
var
  i, j : Integer;
begin
  if NumberOfVisibleUDFs(Edits) > 0 then
  begin
    i := 0;
    while i <= High(Edits) do
    begin
      if not Edits[i].Visible then
        for j := High(Edits) downto i + 1 do
        begin
          if j > Low(Edits) then
          begin
           //Move position of edit
           Edits[j].Top := Edits[j-1].Top;
           Edits[j].Left := Edits[j-1].Left;

           //PR: 11/11/2011 In some circumstances, (allocation wizard for one), one column of
           //Udfs has their labels right-aligned and the other has theirs left-aligned.
           //If we're moving between the two columns then we need to adjust accordingly.
           if Captions[j].Alignment <> Captions[j-1].Alignment then
           begin
             Captions[j].AutoSize := Captions[j-1].Autosize;
             Captions[j].Width := Captions[j-1].Width;
             Captions[j].Alignment := Captions[j-1].Alignment;
           end;

           //Move position of label
           Captions[j].Top := Captions[j-1].Top;
           Captions[j].Left := Captions[j-1].Left;

          end;
        end;
      inc(i);
    end;
  end;
end;

function NumberOfVisibleUDFs(const Edits : Array of TCustomEdit) : Integer;
var
  i : Integer;
begin
  Result := 0;
  for i := Low(Edits) to High(Edits) do
    if Edits[i].Visible then inc(Result);
end;

//procedure to adjust the height of the parent control of the UDEFs
//so that multiple hidden fields do not leave blank spaces.

//Parameters:
//VisibleFieldCount     - the number of UDFs that have their visibility property set to true
//RowLength             - the number of UDFs that make up a row on the user interface
//                        (typically UDFs are positioned on the UI as 1(c)olumn x 10(r)ow, 2c x 5r, 5c x 2r)
//ParentContainer       - the control that contains the UDF controls (such as a TForm or TSBSExtendedForm)
// UDF_Count            - the total number of UDFs
procedure ResizeUDFParentContainer(VisibleFieldCount: Integer; RowLength: Integer; ParentContainer: TObject; RowHeightOverRide: Integer = 0; UDF_Count: Integer = 10);
const
  //this is the pre-set height offset;                                                        -
  //for every row of UDEFs that are hidden; the container control will have it's height reduced by this amount
  ROW_HEIGHT = 23;
var
  //stores the number of hidden UDFs
  HiddenFieldCount: Integer;
  //stores the number of hidden rows of UDFs
  HiddenRowCount: Integer;
  //this holds the sum amount that the container control needs to be adjusted by
  ContainerHeightOffset: Integer;
  ExtendedFormObj: TSBSExtendedForm;
begin
  //firstly, determine if we need to resize the container control;
  //if no DUFs are being hidden, we don't need to adjust the height
  if VisibleFieldCount <= (UDF_COUNT - RowLength) then
  begin
    //next, we need to determine how many rows of UDFs are hidden, so..

    //determine how many UD fields are hidden by subtracting the # of visible fields from the total # of fields
    HiddenFieldCount := UDF_COUNT - VisibleFieldCount;
    //now that we know how many individual UDFs are hidden, we can determine how many rows are hidden
    //by dividing the result by the length of a row
    HiddenRowCount := HiddenFieldCount div RowLength;
    //with the hidden row count, we can now calculate how much hight we need to subtract from the parent container
    //to remove the blank space that any hidden UDF rows will leave behind

    if RowHeightOverRide < 1 then
    begin
      ContainerHeightOffset := ROW_HEIGHT * HiddenRowCount;
    end
    else
    begin
      ContainerHeightOffset := RowHeightOverRide * HiddenRowCount;
    end;
    //finally, apply the height offset to the parent containers height property
    //currently this supports parent container property types of:
    //TSBSExtendedForm
    //TForm
    if ParentContainer Is TSBSExtendedForm then
    begin
      ExtendedFormObj := TSBSExtendedForm(ParentContainer);
      if VisibleFieldCount > 0 then
      begin
        ExtendedFormObj.ExpandedHeight := ExtendedFormObj.ExpandedHeight - ContainerHeightOffset;
      end
      else
      begin
        //GS 16/04/2012 ABSEXCH-12808: logic error when resizing the udf parent container when all fields are hidden;
        //it hides the whole drop-down form; but there could be fields other than UDfs on the form..
        ExtendedFormObj.ExpandedHeight := ExtendedFormObj.ExpandedHeight - ContainerHeightOffset;
        //ExtendedFormObj.ExpandedWidth := ExtendedFormObj.OrigWidth;
        //ExtendedFormObj.ExpandedHeight := ExtendedFormObj.OrigHeight;
      end;
    end
    else if ParentContainer Is TSBSPanel then
    begin
      TSBSPanel(ParentContainer).Height := TSBSPanel(ParentContainer).Height - ContainerHeightOffset;
    end
    else if ParentContainer Is TForm then
    begin
      TForm(ParentContainer).Height := TForm(ParentContainer).Height - ContainerHeightOffset;
    end
    else if ParentContainer Is TControl then
    begin
      TControl(ParentContainer).Top := TControl(ParentContainer).Top - ContainerHeightOffset;
    end;
  end;
end;


  { TCustomField }

function TCustomField.Get_cfCaption: string;
begin
  Result := FDataRec.cfCaption;
end;

function TCustomField.Get_cfCategory: Integer;
begin
  Result := FDataRec.cfFieldID div 1000;
end;

function TCustomField.Get_cfDescription: string;
begin
  Result := FDataRec.cfDescription;
end;

//RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
function TCustomField.Get_cfDisplayPIIOption: Boolean;
begin
  Result := FDataRec.cfDisplayPIIOption;
end;

//RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
function TCustomField.Get_cfContainsPIIData: Boolean;
begin
  Result := FDataRec.cfContainsPIIData;
end;

function TCustomField.Get_cfEnabled: Boolean;
begin
  {$IFDEF LTE}
  Result := False;
  {$ELSE}
  // MH 10/11/2011: Modified to return TRUE if the field does not support enablement - i.e. it can't be turned off
  Result := (Not FDataRec.cfSupportsEnablement) Or FDataRec.cfEnabled;
  {$ENDIF}
end;

function TCustomField.Get_cfIndex: Integer;
begin
  {$IFDEF LTE}
  Result := False;
  {$ELSE}
  Result := FDataRec.cfFieldID mod 1000;
  {$ENDIF}
end;

function TCustomField.Get_cfSupportsEnablement: Boolean;
begin
  Result := FDataRec.cfSupportsEnablement;
end;

procedure TCustomField.SetDataRec(const ADataRec: TCustomFieldSettings);
begin
  FDataRec := ADataRec;
end;

{ TCustomFields }

constructor TCustomFields.Create(const ADataPath: string);
begin
  inherited Create;
  FDataPath := ADataPath;
  Initialise;
  LoadFields;
end;

destructor TCustomFields.Destroy;
begin
  Finalise;
  inherited;
end;

function TCustomFields.Get_Field(Category, Index: Integer): ICustomField;
var
  oCustomField : TCustomField;
begin
  if ValidIndex(Category, Index) then
  begin
    oCustomField := TCustomField.Create;
    oCustomField.SetDataRec(GetField(Category, Index));
    Result := oCustomField;
  end
  else
    raise ERangeError.Create('Category or Index out of range');
end;

function TCustomFields.GetNewFieldIndex(searchKey : string; fieldIndex : longint) : longint;
var
  newIndex : longint;
begin
  newIndex := -1;

  //Search for index in new table using the searchKey and index.
  if(searchKey = 'VAT') then
  begin
    case fieldIndex of
      1 : newIndex := 1001;
      2 : newIndex := 1002;
      3 : newIndex := 4001;
      4 : newIndex := 4002;
      5 : newIndex := 22001;
      6 : newIndex := 22002;
      7 : newIndex := 3001;
      8 : newIndex := 3002;
      9 : newIndex := 3003;
      10 : newIndex := 3004;
      11 : newIndex := 1003;
      12 : newIndex := 1004;
      13 : newIndex := 4003;
      14 : newIndex := 4004;
      15 : newIndex := 22003;
      16 : newIndex := 22004;
      17 : newIndex := 5001;
      18 : newIndex := 5002;
      19 : newIndex := 5003;
      20 : newIndex := 5004;
      21 : newIndex := 27001;
      22 : newIndex := 27002;
    end;
  end
  else if (searchKey = 'Custom') then
  begin
    case fieldIndex of
      1 : newIndex := 27003;
      2 : newIndex := 27004;
      3 : newIndex := 6001;
      4 : newIndex := 6002;
      5 : newIndex := 6003;
      6 : newIndex := 6004;
      7 : newIndex := 7001;
      8 : newIndex := 7002;
      9 : newIndex := 7003;
      10 : newIndex := 7004;
      11 : newIndex := 10001;
      12 : newIndex := 10002;
      13 : newIndex := 10003;
      14 : newIndex := 10004;
      15 : newIndex := 11001;
      16 : newIndex := 11002;
      17 : newIndex := 11003;
      18 : newIndex := 11004;
      19 : newIndex := 12001;
      20 : newIndex := 12002;
      21 : newIndex := 12003;
      22 : newIndex := 12004;
      23 : newindex := 13001;
      24 : newindex := 13002;
      25 : newindex := 13003;
      26 : newindex := 13004;
      27 : newindex := 14001;
      28 : newindex := 14002;
      29 : newindex := 14003;
      30 : newindex := 14004;
      31 : newindex := 15001;
      32 : newindex := 15002;
      33 : newindex := 15003;
      34 : newindex := 15004;
      35 : newindex := 18001;
      36 : newindex := 18002;
      37 : newindex := 18003;
      38 : newindex := 18004;
      39 : newindex := 19001;
      40 : newindex := 19002;
      41 : newindex := 19003;
      42 : newindex := 19004;
      43 : newindex := 20001;
      44 : newindex := 20002;
      45 : newindex := 20003;
      46 : newindex := 20004;
      47 : newindex := 21001;
      48 : newindex := 21002;
      49 : newindex := 21003;
      50 : newindex := 21004;
      51 : newindex := 2001;
      52 : newindex := 2002;
      53 : newindex := 2003;
      54 : newindex := 2004;
      end;
  end
  else if (searchKey = 'Custom2') then
  begin
    case fieldIndex of
      1 : newIndex := 23001;
      2 : newIndex := 23002;
      3 : newIndex := 23003;
      4 : newIndex := 23004;
      5 : newIndex := 24001;
      6 : newIndex := 24002;
      7 : newIndex := 24003;
      8 : newIndex := 24004;
      9 : newIndex := 25001;
      10 : newIndex := 25002;
      11 : newIndex := 25003;
      12 : newIndex := 25004;
      13 : newIndex := 26001;
      14 : newIndex := 26002;
      15 : newIndex := 26003;
      16 : newIndex := 26004;
      17 : newIndex := 29001;
      18 : newIndex := 29002;
      19 : newIndex := 29003;
      20 : newIndex := 29004;
      21 : newIndex := 30001;
      22 : newIndex := 30002;
      23 : newindex := 30003;
      24 : newindex := 30004;
      25 : newindex := 8001;
      26 : newindex := 8002;
      27 : newindex := 8003;
      28 : newindex := 8004;
      29 : newindex := 9001;
      30 : newindex := 9002;
      31 : newindex := 9003;
      32 : newindex := 9004;
      33 : newindex := 16001;
      34 : newindex := 16002;
      35 : newindex := 16003;
      36 : newindex := 16004;
      37 : newindex := 17001;
      38 : newindex := 17002;
      39 : newindex := 17003;
      40 : newindex := 17004;
      41 : newindex := 28001;
      42 : newindex := 28002;
      43 : newindex := 28003;
      44 : newindex := 28004;
      end;
  end;

  //Return new index
  result := newIndex;
end;

function TCustomFields.GetFieldEnabled(oldRecord : string; fieldIndex : longint) : boolean;
begin
  Result := false;

  //Search for index in new table using the searchKey and index.
  if(oldRecord = 'HideLType') then
  begin
    case fieldIndex of
      0 : Result := Not CustomFields[cfSINHeader, 1].cfEnabled;
      1 : Result := Not CustomFields[cfLinetypes, 1].cfEnabled;
      2 : Result := Not CustomFields[cfLinetypes, 2].cfEnabled;
      3 : Result := Not CustomFields[cfLinetypes, 3].cfEnabled;
      4 : Result := Not CustomFields[cfLinetypes, 4].cfEnabled;
      5 : Result := Not CustomFields[cfSINHeader, 2].cfEnabled;
      6 : Result := Not CustomFields[cfSINHeader, 3].cfEnabled;
    end;
  end
  else if (oldRecord = 'HideUDF') then
  begin
    case fieldIndex of
      7 : Result := Not CustomFields[cfSINHeader, 4].cfEnabled;
      8 : Result := Not CustomFields[cfSINLine, 1].cfEnabled;
      9 : Result := Not CustomFields[cfSINLine, 2].cfEnabled;
      10 : Result := Not CustomFields[cfSINLine, 3].cfEnabled;
      11 : Result := Not CustomFields[cfSINLine, 4].cfEnabled;
      end;
  end
  else if (oldRecord = 'Custom') then
  begin
    case fieldIndex of
      3: Result := CustomFields[cfSRCHeader, 1].cfEnabled;
      4: Result := CustomFields[cfSRCHeader, 2].cfEnabled;
      5: Result := CustomFields[cfSRCHeader, 3].cfEnabled;
      6: Result := CustomFields[cfSRCHeader, 4].cfEnabled;
      7: Result := CustomFields[cfSRCLine, 1].cfEnabled;
      8: Result := CustomFields[cfSRCLine, 2].cfEnabled;
      9: Result := CustomFields[cfSRCLine, 3].cfEnabled;
      10: Result := CustomFields[cfSRCLine, 4].cfEnabled;
      11: Result := CustomFields[cfSORHeader, 1].cfEnabled;
      12: Result := CustomFields[cfSORHeader, 2].cfEnabled;
      13: Result := CustomFields[cfSORHeader, 3].cfEnabled;
      14: Result := CustomFields[cfSORHeader, 4].cfEnabled;
      15: Result := CustomFields[cfSORLine, 1].cfEnabled;
      16: Result := CustomFields[cfSORLine, 2].cfEnabled;
      17: Result := CustomFields[cfSORLine, 3].cfEnabled;
      18: Result := CustomFields[cfSORLine, 4].cfEnabled;
      19: Result := CustomFields[cfPINHeader, 1].cfEnabled;
      20: Result := CustomFields[cfPINHeader, 2].cfEnabled;
      21: Result := CustomFields[cfPINHeader, 3].cfEnabled;
      22: Result := CustomFields[cfPINHeader, 4].cfEnabled;
      23: Result := CustomFields[cfPINLine, 1].cfEnabled;
      24: Result := CustomFields[cfPINLine, 2].cfEnabled;
      25: Result := CustomFields[cfPINLine, 3].cfEnabled;
      26: Result := CustomFields[cfPINLine, 4].cfEnabled;
      27: Result := CustomFields[cfPPYHeader, 1].cfEnabled;
      28: Result := CustomFields[cfPPYHeader, 2].cfEnabled;
      29: Result := CustomFields[cfPPYHeader , 3].cfEnabled;
      30: Result := CustomFields[cfPPYHeader, 4].cfEnabled;
      31: Result := CustomFields[cfPPYLine, 1].cfEnabled;
      32: Result := CustomFields[cfPPYLine, 2].cfEnabled;
      33: Result := CustomFields[cfPPYLine, 3].cfEnabled;
      34: Result := CustomFields[cfPPYLine, 4].cfEnabled;
      35: Result := CustomFields[cfPORHeader, 1].cfEnabled;
      36: Result := CustomFields[cfPORHeader, 2].cfEnabled;
      37: Result := CustomFields[cfPORHeader, 3].cfEnabled;
      38: Result := CustomFields[cfPORHeader, 4].cfEnabled;
      39: Result := CustomFields[cfPORLine, 1].cfEnabled;
      40: Result := CustomFields[cfPORLine, 2].cfEnabled;
      41: Result := CustomFields[cfPORLine, 3].cfEnabled;
      42: Result := CustomFields[cfPORLine, 4].cfEnabled;
      43: Result := CustomFields[cfNOMHeader, 1].cfEnabled;
      44: Result := CustomFields[cfNOMHeader, 2].cfEnabled;
      45: Result := CustomFields[cfNOMHeader, 3].cfEnabled;
      46: Result := CustomFields[cfNOMHeader, 4].cfEnabled;
      47: Result := CustomFields[cfNOMLine, 1].cfEnabled;
      48: Result := CustomFields[cfNOMLine, 2].cfEnabled;
      49: Result := CustomFields[cfNOMLine, 3].cfEnabled;
      50: Result := CustomFields[cfNOMLine, 4].cfEnabled;
    end;
  end
  else if (oldRecord = 'Custom2') then
  begin
    case fieldIndex of
      1: Result := CustomFields[cfADJHeader, 1].cfEnabled;
      2: Result := CustomFields[cfADJHeader, 2].cfEnabled;
      3: Result := CustomFields[cfADJHeader, 3].cfEnabled;
      4: Result := CustomFields[cfADJHeader, 4].cfEnabled;
      5: Result := CustomFields[cfADJLine, 1].cfEnabled;
      6: Result := CustomFields[cfADJLine, 2].cfEnabled;
      7: Result := CustomFields[cfADJLine, 3].cfEnabled;
      8: Result := CustomFields[cfADJLine, 4].cfEnabled;
      9: Result := CustomFields[cfWORHeader, 1].cfEnabled;
      10: Result := CustomFields[cfWORHeader, 2].cfEnabled;
      11: Result := CustomFields[cfWORHeader, 3].cfEnabled;
      12: Result := CustomFields[cfWORHeader, 4].cfEnabled;
      13: Result := CustomFields[cfWORLine, 1].cfEnabled;
      14: Result := CustomFields[cfWORLine, 2].cfEnabled;
      15: Result := CustomFields[cfWORLine, 3].cfEnabled;
      16: Result := CustomFields[cfWORLine, 4].cfEnabled;
      17: Result := CustomFields[cfTSHHeader, 1].cfEnabled;
      18: Result := CustomFields[cfTSHHeader, 2].cfEnabled;
      19: Result := CustomFields[cfTSHHeader, 3].cfEnabled;
      20: Result := CustomFields[cfTSHHeader, 4].cfEnabled;
      21: Result := CustomFields[cfTSHLine, 1].cfEnabled;
      22: Result := CustomFields[cfTSHLine, 2].cfEnabled;
      23: Result := CustomFields[cfTSHLine, 3].cfEnabled;
      24: Result := CustomFields[cfTSHLine, 4].cfEnabled;
      25: Result := CustomFields[cfSQUHeader, 1].cfEnabled;
      26: Result := CustomFields[cfSQUHeader, 2].cfEnabled;
      27: Result := CustomFields[cfSQUHeader, 3].cfEnabled;
      28: Result := CustomFields[cfSQUHeader, 4].cfEnabled;
      29: Result := CustomFields[cfSQULine , 1].cfEnabled;
      30: Result := CustomFields[cfSQULine, 2].cfEnabled;
      31: Result := CustomFields[cfSQULine, 3].cfEnabled;
      32: Result := CustomFields[cfSQULine, 4].cfEnabled;
      33: Result := CustomFields[cfPQUHeader, 1].cfEnabled;
      34: Result := CustomFields[cfPQUHeader, 2].cfEnabled;
      35: Result := CustomFields[cfPQUHeader, 3].cfEnabled;
      36: Result := CustomFields[cfPQUHeader, 4].cfEnabled;
      37: Result := CustomFields[cfPQULine, 1].cfEnabled;
      38: Result := CustomFields[cfPQULine, 2].cfEnabled;
      39: Result := CustomFields[cfPQULine, 3].cfEnabled;
      40: Result := CustomFields[cfPQULine, 4].cfEnabled;
    end;
  end;
end;


function TCustomFields.ValidIndex(Category, Index: Integer): Boolean;
begin
  // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom fields for Addresses
  // PKR. 05/04/2016. ABSEXCH-15814, ABSEXCH-17383.  Validation updated for new UDFs.
  Result := Category in [cfCustomer..cfTaxRegion];

  if Result then
  begin
    // MH 10/11/2014 Order Payments: Extended Customer/Supplier to 15 fields
    If (Category in [cfCustomer, cfSupplier]) Then
      Result := Index in [1..15]
    //PR: 23/11/2011 added Cat4Set for categories with only 4 udfs (LineTypes & Employees)
    Else if Category in Cat4Set then
      Result := Index in [1..4]
    // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom fields for Addresses
    Else If (Category = cfAddressLabels) Then
      Result := Index in [1..5]
    // PKR. 05/04/2016. ABSEXCH-17383. New UDFs for RCT support.
    else if (Category in CatHeaderSet) then
      Result := Index in [1..12]
    else if (Category in CatLineSet) then
      Result := Index in [1..10]
    else if (Category in CatTaxRegionSet) then
      Result := Index in [1..2];
  end;
end;

{ TPervasiveCustomFields }

procedure TPervasiveCustomFields.Finalise;
begin

end;

function TPervasiveCustomFields.GetField(Category,
  Index: Integer): TCustomFieldSettings;
var
  arrayIndex : integer;
begin
  arrayIndex := MakeFieldIndex(Category, Index);
  if (arrayIndex >= 0) then
    Result := FDataRecs[arrayIndex]
  else
    // PKR: 05/04/2016. Blank result if not found
    FillChar(Result, SizeOf(Result), 0);
end;

procedure TPervasiveCustomFields.Initialise;
begin
  //PR: 28/03/2012 ABSEXCH-12723 Initialise array.
  FillChar(FDataRecs, SizeOf(FDataRecs), 0);
end;


procedure TPervasiveCustomFields.LoadFields;
var
  FV : TFileVar;
  Res : Integer;
  CustomFieldRec : TCustomFieldSettings;
  KeyS : TStr255;
  i : integer;
begin
  Res := BTOpenFile(FV, FDataPath + CustomFieldSettingsFileName, 0);
  if Res = 0 then
  Try
    //PR: 02/11/2012 ABSEXCH-13642 Initialise KeyS to empty string to avoid range check error in BtFindRecord.
    KeyS := '';

    SetLength(FDataRecs, 1);
    i := 1;
    Res := BTFindRecord(B_GetFirst, FV, CustomFieldRec, SizeOf(CustomFieldRec), 0, KeyS);

    while Res = 0 do
    begin
      // PKR. 05/04/2016. ABSEXCH-15814. PervasiveCustomFields class crashes after adding new field.
      // Made the FDataRecs array dynamic which starts from 0, so we need to offset by 1
      // to keep all the code consistent.  Element[0] will remain unused.

      // Make space for this entry.
      SetLength(FDataRecs, i+1);

      FDataRecs[i] := CustomFieldRec;

      inc(i);
      Res := BTFindRecord(B_GetNext, FV, CustomFieldRec, SizeOf(CustomFieldRec), 0, KeyS);
    end; //while res = 0
  Finally
    BTCloseFile(FV);
  End
  else
    raise Exception.CreateFmt('Unable to open file %s. Btrieve error: %d', [FDataPath + CustomFieldSettingsFileName, Res]);
end;


function TPervasiveCustomFields.MakeFieldIndex(Category, Index: Integer): Integer;
Var
  I, FieldId : Integer;
begin
  //Create index into the fields array from Category and Index
  //Result := (Pred(Category) * 10) + Index;

  // MH 04/12/2014 ABSEXCH-15824: Modified code to look for the FieldID instead of using the unsafe
  //                              assumption that there are 10 fields per catagory
  FieldId := 1000 * Category + Index;
  Result := -1;
  // PKR. Ignore [0] element of the dynamic array to keep it consistent with the fixed array we used before.
  For I := Low(FDataRecs)+1 To High(FDataRecs) Do
  Begin
    If (FDataRecs[I].cfFieldID = FieldId) Then
    Begin
      Result := I;
      Break;
    End; // If (FDataRecs[I].cfFieldID = FieldId)
  End; // For I
end;

//==============================================================================
{ TSQLCustomFields }

//Copy field values from dataset into TCustomFieldSettings record.
procedure TSQLCustomFields.CopyFields(var DataRec: TCustomFieldSettings);
begin
  DataRec.cfFieldID     := FCaller.Records.FieldByName('cfFieldID').AsInteger;
  DataRec.cfSupportsEnablement
                        := FCaller.Records.FieldByName('cfSupportsEnablement').AsBoolean;
  DataRec.cfEnabled     := FCaller.Records.FieldByName('cfEnabled').AsBoolean;
  DataRec.cfCaption     := FCaller.Records.FieldByName('cfCaption').AsString;
  DataRec.cfDescription := FCaller.Records.FieldByName('cfDescription').AsString;
  //RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
  DataRec.cfDisplayPIIOption := FCaller.Records.FieldByName('cfDisplayPIIOption').AsBoolean;
  DataRec.cfContainsPIIData := FCaller.Records.FieldByName('cfContainsPIIData').AsBoolean;
end;

procedure TSQLCustomFields.Finalise;
begin
  FCaller.Close;
  FCaller.Free;
end;

function TSQLCustomFields.GetField(Category, Index: Integer): TCustomFieldSettings;
begin
  //RB 14/06/2017 2017-R2 ABSEXCH-18914: SQL connection fixes from Delphi end.
  try
    //In case if the Dataset is not active after reconnection
    if not FCaller.Records.Active then
      FCaller.Records.Open;

    if FCaller.Records.Locate('cfFieldID', MakeFieldIndex(Category, Index), []) then
      CopyFields(Result)
    else //PR: 28/03/2012 ABSEXCH-12723 Blank result if not found
      FillChar(Result, SizeOf(Result), 0);
  except
    on E: Exception do
    begin
      if E.Message = CONNECTION_FAILURE then
      begin
        if ResetConnection(FCaller.GetDrivePath) then
          GetField(Category, Index);
      end;
    end;
  end;
end;

procedure TSQLCustomFields.Initialise;
var
  sConnection : AnsiString;
begin
  //Create SQL Caller and set connection string
  //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
  FCaller := TSQLCaller.Create(GlobalADOConnection);
end;


procedure TSQLCustomFields.LoadFields;
begin
  FCaller.Select('Select * from [COMPANY].[CustomFields]', GetCompanyCode(FDataPath));
end;

function TSQLCustomFields.MakeFieldIndex(Category,
  Index: Integer): Integer;
begin
  //Create cfFieldId value from Category and Index
  Result := 1000 * Category + Index;
end;

//===============================================================//

function CustomFields : TCustomFields;
begin
//For Enter1 we can use SetDrive to get the data path. For any other application it should be set explicitly by calling SetCustomFieldsPath before
//using the CustomFields object - this will store the path in CustomFieldsDataPath

  if not Assigned(CustomFieldsObj) then
  // MH 07/05/2015 v7.0.14 ABSEXCH-15637: Added begin/end to correct the bahaviour for Non-Enter1/RW builds
  Begin
{$IF DEFINED(ENTER1) OR DEFINED(RW)}
    if SQLUtils.UsingSQL then
      CustomFieldsObj := TSQLCustomFields.Create(SetDrive)
    else
      CustomFieldsObj := TPervasiveCustomFields.Create(SetDrive);
{$ELSE}
    if Trim(CustomFieldsDataPath) = '' then
      raise Exception.Create('Custom Fields Data Path not set');

    if SQLUtils.UsingSQL then
      CustomFieldsObj := TSQLCustomFields.Create(CustomFieldsDataPath)
    else
      CustomFieldsObj := TPervasiveCustomFields.Create(CustomFieldsDataPath);
{$IFEND}
  End; // if not Assigned(CustomFieldsObj)

  Result := CustomFieldsObj;
end;

procedure ClearCustomFields;
begin
//To be called when changing company, or when system setup has updated custom fields.
  if Assigned(CustomFieldsObj) then
    FreeAndNil(CustomFieldsObj);
end;

{$IFNDEF ENTER1}
procedure SetCustomFieldsPath(const ADataPath : string);
begin
  CustomFieldsDataPath := ADataPath;
end;


function GetCustomFieldsPath : String;
begin
  Result := CustomFieldsDataPath;
end;
{$ENDIF}



Initialization
  CustomFieldsObj := nil;


end.
