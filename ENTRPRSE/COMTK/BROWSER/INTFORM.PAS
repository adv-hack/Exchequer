unit intform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, ActiveX, Grids, ImgList, TreeObj, Menus, HelpGen,
  Variants;

Const
  DefaultMaxIndex = 100;
  DefaultMaxCharIndex = 0;

  NoParams  = 0;
  IntParam  = 1;
  CharParam = 2;

  InvGetFirst     = 16777217;
  InvGetPrevious  = 16777218;
  InvGetNext      = 16777219;
  InvGetLast      = 16777220;

  MaxLevel = 20;

  IID_NULL : TGUID = '{00000000-0000-0000-0000-000000000000}';


{Constants for handling array boundaries and other special cases:

IntArrayCount & IntArrays deal with standard fixed arrays with an
integer index.  Char indexed arrays are hard-coded in .GetMaxIndex.

SpecArrayCount, SpecialArrays & CountNames deal with variable size arrays - e.g.
thLine[].  What we do is interrogate the IDispatch for the count - held in CountNames

NACloneCount and NotAvailInClone deal with properties that are not available in some
circumstances - usually but not always cloned objects

IntFValidCount and IntFValidation deal with interfaces which might not have any data
- .ValidateInterface checks the shTest method for each interface - eg for IAccount
it will check acCode - if this is blank then the interface is assumed to have
no valid data so all fields are set to n/a without trying to get values

SpecHandCount and SpecialHandling deal with all other special cases - e.g for adType
we check that adStockCode is not blank - if it is then we assume that adType will
give us an exception so we don't try to get a value and just set it to n/a}

{NB: To add new lists into the browser:
  1 : Add the List Interface name into SpecialArrays. Update SpecArrayCount
  2 : Add the name of the count property into CountNames
  3 : Add the property name of the list into IntArrays. Update IntArrayCount

  eg Printers:
  1 : IPrinters
  2 : prCount
  3 : prPrinters}

  //Values of browseinfo which indicate that interface should not be treated as a clone or similar
  NotACloneSet = [0, {imGeneral}
                  29 {PrintJob.CustomData}
                 ];


  IntArrayCount  = 22;
  SpecArrayCount = 13;
  NACloneCount   = 10;

  ArrayMin = 0;
  ArrayMax = 1;


  IntArrays : Array[1..IntArrayCount] of String = ('ACTRADETERMS', 'BLCOMPONENT', 'CMCOMPANY',
                                                   'LINES','SSCOMPANYADDRESS','SSCURRENCY',
                                                   'SSDEBTCHASEDAYS','SSGLCTRLCODES',
                                                   'SSJOBCATEGORY','SSJOBCOSTINGGLCTRLCODES',
                                                   'SSTERMSOFTRADE','STDESC','THLINE',
                                                   'THLINETYPEANALYSIS','THTOTALS',
                                                   'TLUSEDSERIALBATCH',
                                                   'PRPRINTERS',
                                                   'STRINGS',
                                                   'PFFORMS',
                                                   'EAITEMS',
                                                   'AFFILES',
                                                   'JITRANSACTION');

   Boundaries : Array [1..IntArrayCount, ArrayMin..ArrayMax] of Integer =
                  (( 1,  2), //acTradeTerms
                   ( 1, -1), //blComponent
                   ( 1, -1), //cmCompany
                   ( 1,  5), //Lines
                   ( 1,  5), //ssCompanyAddress
                   ( 1, 90), //ssCurrency
                   ( 1,  3), //ssDebtChaseDays
                   ( 0, 16), //ssGLCtrlCodes
                   ( 0, 19), //ssJobCategory
                   ( 0,  5), //ssJobCostingGLCtrlCodes
                   ( 1,  2), //ssTermsOfTrade
                   ( 1,  6), //stDesc
                   ( 1, -1), //thLine
                   ( 0,  6), //thLineTypeAnalysis
                   ( 0,  11), //thTotals
                   ( 1, -1),//tlSerialBatch
                   ( 1, -1),//prPrinters
                   ( 1, -1),//Strings
                   ( 1, -1),//pfForms
                   ( 1, -1),//eaItems
                   ( 1, -1),//afFiles
                   ( 1, -1));//jiTransaction


  SpecialArrays : Array[1..SpecArrayCount] of WideString = ('ISTOCKBOMLIST',
                                                            'ICOMPANYMANAGER',
                                                            'ITRANSACTIONLINES',
                                                            'ITRANSACTIONLINESERIALBATCH3',
                                                            'IXMLTRANSACTIONLINES',
                                                            'IXMLSERIALBATCH',
                                                            'IPRINTERS',
                                                            'ISTRINGLISTREADONLY',
                                                            'IPRINTFORMLIST',
                                                            'IEMAILADDRESSARRAY',
                                                            'IEMAILATTACHMENTS',
                                                            'IJOBINVOICETRANSACTIONLIST',
                                                            'ITRANSACTIONLINEMULTIBIN');

  CountNames    : Array[1..SpecArrayCount] of WideString = ('BLCOMPONENTCOUNT',
                                                            'CMCOUNT',
                                                            'THLINECOUNT',
                                                            'TLCOUNT',
                                                            'THLINECOUNT',
                                                            'SBCOUNT',
                                                            'PRCOUNT',
                                                            'COUNT',
                                                            'PFCOUNT',
                                                            'EACOUNT',
                                                            'AFCOUNT',
                                                            'JITRANSACTIONCOUNT',
                                                            'TLCOUNT');

  NotAvailInClone : Array[1..NACloneCount] of WideString = ('INDEX', 'POSITION',
                                                            'KEYSTRING','ACNOTES',
                                                            'STLOCATIONLIST','STNOTES',
                                                            'JRNOTES', 'THNOTES', 'THMATCHING',
                                                            'PJCUSTOMDATA');

  shName = 0;
  shTest = 1;


  IntFValidCount = 8;

  IntfValidation : Array[1..IntfValidCount, shName..shTest] of WideString =
                (('ITRANSACTION','THOURREF'),
                 ('IACCOUNT','ACCODE'),
                 ('IGENERALLEDGER','GLCODE'),
                 ('IJOB','JRCODE'),
                 ('IJOBTYPE', 'JTCODE'),
                 ('IJOBANALYSIS','ANCODE'),
                 ('IEMPLOYEE','EMCODE'),
                 ('ISTOCK','STCODE'));

  SpecHandCount = 5;

  SpecialHandling : Array[1..SpecHandCount, shName..shTest] of WideString =
                (('ADTYPE','ADSTOCKCODE'),
                 ('ADQTYBREAKS','ADSTOCKCODE'),
                 ('QBTYPE','QBQUANTITYTO'),
                 ('STSERIALBATCH','STVALUATIONMETHOD'),
                 ('THPROCESS','THOURREF'));


  NAString = 'N/A';





type

  TfrmInterface = class(TForm)
    Panel1: TPanel;
    lvFuncs: TListView;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    Options1: TMenuItem;
    ShowOwnerGUIDs: TMenuItem;
    ShowOwnerAddresses: TMenuItem;
    StayOnTop: TMenuItem;
    N1: TMenuItem;
    File1: TMenuItem;
    Export1: TMenuItem;
    Close1: TMenuItem;                                  
    SaveDialog1: TSaveDialog;
    Refresh1: TMenuItem;
    Generatehelpfile1: TMenuItem;
    N2: TMenuItem;
    StatusBar1: TStatusBar;
    SaveDialog2: TSaveDialog;
    CancelHelp: TMenuItem;
    N3: TMenuItem;
    Debug1: TMenuItem;
    PopupMenu1: TPopupMenu;
    GetFirst1: TMenuItem;
    GetNext1: TMenuItem;
    GetLast1: TMenuItem;
    GetPrevious1: TMenuItem;
    Test1: TMenuItem;
    Find1: TMenuItem;
    IntFace: TMenuItem;
    GetFirst2: TMenuItem;
    GetPrevious2: TMenuItem;
    GetNext2: TMenuItem;
    GetLast2: TMenuItem;
    Find2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvFuncsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShowOwnerGUIDsClick(Sender: TObject);
    procedure ShowOwnerAddressesClick(Sender: TObject);
    procedure StayOnTopClick(Sender: TObject);
    procedure lvFuncsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Close1Click(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure Generatehelpfile1Click(Sender: TObject);
    procedure CancelHelpClick(Sender: TObject);
    procedure Debug1Click(Sender: TObject);
    procedure GetFirst1Click(Sender: TObject);
    procedure GetPrevious1Click(Sender: TObject);
    procedure GetNext1Click(Sender: TObject);
    procedure GetLast1Click(Sender: TObject);
    procedure Test1Click(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lvFuncsInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
  private
    { Private declarations }
    FDispatch : IDispatch;
    FBeforeUpdate,
    FAfterUpdate : TNotifyEvent;
    CurrentNodeName : string;
    Log, ArrayList : TStringList;
    TheTree : TInterfaceTreeObject;
    FShowParentGUID : Boolean;
    FShowParentAddress : Boolean;
    FTopItem : integer;
    FHelpGen : THelpGenerator;
    FGenerateHelp : Boolean;
    DispatchList : TStringList;
    ThisTypeString : string;
    ArrayID, ArrayP : longint;
    CurrentIName : string;
    SaveStateList : TList;
    FFunctionInterface : Pointer;
    FLastFunctionResult : String;
    FFunctionLog, FFunctionList  : TStringList;
    FTestMode : Boolean;
    FRecurse : Boolean;
    FCurrentIndex, FCurrentTreeIndex : longint;
    FirstTime : Boolean;
    FSearchKey : WideString;
    SpecialMaxIndex : integer;
    function ResultCode(i : HResult) : string;
    function GetIValue(ATypeInfo : ITypeInfo; id : integer; const Dispatch : IDispatch;
                        AParam : integer; CParam : WideString; ParamType : Byte;
                        iKind : TInvokeKind) : variant;
    function GetValueString(V : Variant; const UDType : string) : string;
    procedure AddToDisplayList(PropertyName, PropertyValue, ParentStr : string;
                                IndentLevel : integer; const ParentAddr : Pointer);
    procedure RecurseAdd(PropertyName, PropertyValue, ParentStr : string;
                                IndentLevel : integer; const ParentAddr : Pointer);
    procedure NonRecurseAdd(PropertyName, PropertyValue, ParentStr : string;
                                IndentLevel : integer; const ParentAddr : Pointer);
    function IntName(const I : IDispatch) : string;
    procedure ShowSubItems(WhichItem : TListItem);
    procedure HideSubItems(Index : integer);
    function GetMaxIndex(Name : string; FuncDesc : PFuncDesc;
                        var IsChar : Byte) : integer; virtual;
    function GetCharIndex(const AName : string; i : integer) : WideString; virtual;
    function GetMinIndex(Name : string; FuncDesc : PFuncDesc;
                        var IsChar : Byte) : word; virtual;
    procedure LogIt(const Msg : string);
    procedure RestoreState;
    function ParentGUIDCol : integer;
    function ParentAddressCol : integer;
    function GetParameterType(i : integer) : string;
    procedure AddToRtf(const PropertyName, RefName, TypeStr, ParentStr, Doc : string;
                       Params : TStringList; ik : TInvokeKind);
    function TypeString(V : Variant) : string;
    function VarTypeString(V : Variant) : string;
    procedure LoadTypeLibrary(Flib : ITypeLib);
    procedure LoadEnum(TypeInfo: ITypeInfo; TypeAttr: PTypeAttr);
    function GetUserDefType(TI : ITypeInfo; UD : HRefType) : string;
    function RemoveSquareBrackets(const s : string) : string;
    procedure SaveState;
    procedure RestoreStateList;
    function RootType : string;
    procedure ShowFunctionMenu(const p : Pointer; x, y : integer);
    procedure InvokeFunction(const Intf : Pointer; const ID : Widestring);
    procedure Delay(const i : longint);
    function GetSpecialMaxIndex(const ADispatch : IDispatch;
                                const AName : WideString) : integer; virtual;
    function AvailableInClone(const AName : WideString) : Boolean; virtual;
    function ValidateSpecial(const AName : WideString; const ADispatch : IDispatch;
                             IsClone : Boolean) : Boolean; virtual;
    function GetProperty(const ADispatch : IDispatch; const AName : WideString) : OLEVariant;
    function ValidateInterface(const ADispatch : IDispatch;
                               const AName : WideString) : Boolean; virtual;
    function PropertyTypeString(const FuncDesc : PFuncDesc;
                                const TypeInfo : ITypeInfo) : string;
    procedure ShowHelpMsg(const Msg : string);
  protected
    procedure SetDispatch(const ADispatch : IDispatch);
    procedure SetGUID(Value : Boolean);
    procedure SetAddress(Value : Boolean);

  public
    { Public declarations }
    Args : TVariantArgList;
    function ShowDetails(Level : integer; const ADispatch : IDispatch;
                         IsClone : Boolean) : string;
    procedure GenerateHelpfile(Sender : TObject);
    procedure Clear;
    procedure UpdateDetails(ShowForm : Boolean);
    procedure TestInterfaces(FuncList : TStringList);

    procedure SaveLog(const sFilename : string);
    property COMInterface : IDispatch read FDispatch write SetDispatch;
    property ShowParentGUID : Boolean read FShowParentGUID write SetGUID;
    property ShowParentAddress : Boolean read FShowParentAddress write SetAddress;
    property BeforeUpdate : TNotifyEvent read FBeforeUpdate write FBeforeUpdate;
    property AfterUpdate : TNotifyEvent read FAfterUpdate write FAfterUpdate;
    property GenerateHelp : Boolean read FGenerateHelp write FGenerateHelp;
    property LastFunctionResult : string read FLastFunctionResult;
    property FunctionLog : TStringList read FFunctionLog;
    property FunctionList : TStringList read FFunctionList
                                        write FFunctionList;
  end;

  TfrmToolkitInterface = Class(TfrmInterface)
    function GetMaxIndex(Name : string; FuncDesc : PFuncDesc;
                         var IsChar : Byte) : integer; override;
    function GetMinIndex(Name : string; FuncDesc : PFuncDesc;
                        var IsChar : Byte) : word; override;
    function GetCharIndex(const AName : string; i : integer) : WideString; override;
    function GetSpecialMaxIndex(const ADispatch : IDispatch;
                                const AName : WideString) : integer; override;
    function AvailableInClone(const AName : WideString) : Boolean; override;
    function ValidateSpecial(const AName : WideString; const ADispatch : IDispatch;
                                 IsClone : Boolean) : Boolean; override;

    function ValidateInterface(const ADispatch : IDispatch;
                               const AName : WideString) : Boolean; override;
  end;

  procedure SetBrowserHandle(AHandle : HWnd);

var
  Debug : Boolean;

implementation

{$R *.DFM}

uses
  ComObj, intfind, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF};

var
  OldHandle : HWnd;
  HandleSet : Boolean;




function TfrmInterface.ShowDetails(Level : integer; const ADispatch : IDispatch;
                                   IsClone : Boolean) : string;
//Main function - this iterates through all the functions of ADispatch adding
//all getproperty functions to the tree object.  If a property is IDispatch then
//ShowDetails is called recursively.
//All properties on the first level are displayed in the list view.
var
  SaveArrayID : longint;
  Res : Hresult;
  n1 : WideString;
  GU : TGUID;
  TypeAttr : PTypeAttr;
  FuncIndex: Integer;
  FuncDesc: PFuncDesc;
  AName, DocStr : WideString;
  TypeInfo : ITypeInfo;
  s, s1 : string;
  v : variant;
  i : integer;
  InterfaceName : string;
  InvalidParam : boolean;
  MaxIndex, MinIndex : word;
  SaveID : integer;
    Names: POleStrlist;
    id1 : PMemberIDList;
  ParentIdx : longint;
  sgu : string;
  ParentAddr : Pointer;
  IsChar : Byte;
  CharIdx : WideString;
  ParamType : byte;
  WordPos : longint;
  ParamNames : PBStrList;
  ParamIndex : integer;
  ParamList : TStringList;
  c : integer;
  FLib : ITypeLib;
  ResultString, ts : string;
  SaveIName : string;
  OldC : TCursor;
  pq : integer;
  LocalIsClone : Boolean;
  IB : IBrowseInfo;
begin
 if DispatchList.IndexOf(IntToStr(Integer(ADispatch))) > -1 then
  begin
  //already done this interface so we could be getting into an infinite loop
   Result := 'Possible infinite loop';
    EXIT;
  end
  else
    DispatchList.Add(IntToStr(Integer(ADispatch)));

  if Level > MaxLevel then
  begin
    Result := 'Level too deep';
    EXIT;
  end;

  //Added so that we can tell if interface is a clone
  if Supports(ADispatch, IID_IBrowseInfo, IB) then
    IsClone := not (IB.ibInterfaceMode in NotACloneSet);

  New(Names);
  New(Id1);
  New(ParamNames);
  Result := '';
  ParamList := TStringlist.Create;
  OldC := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  Try
    if Assigned(ADispatch) then
    begin
      Try
        //Get the type info for the dispatch interface
        Res := ADispatch.GetTypeInfo(0,0,TypeInfo);
        if Res <> 0 then
        begin
          Result := ('Unable to get interface information: ' + ResultCode(Res));
          EXIT;
        end;
        if TypeInfo = nil then
          Exit;

        Res := TypeInfo.GetTypeAttr(TypeAttr);

        if TypeAttr = nil then EXIT;

        //Set extra information string if required
        if FShowParentGUID then
          sgu := GUIDtoString(TypeAttr.GUID)
        else
          sgu := '';

{        if FShowParentAddress then}
          ParentAddr := Pointer(ADispatch); //need always for getfirst, etc.
{        else
          ParentAddr := nil;}

        //GetDocumentation gives us the name of the interface
        Res := TypeInfo.GetDocumentation(-1, @AName,
                 nil, nil, nil);
        Self.Caption := AName + ' - Interface browser';
        InterfaceName := AName;

        for i := 1 to SpecArrayCount do
        begin
          if UpperCase(AName) = SpecialArrays[i] then
            SpecialMaxIndex := GetSpecialMaxIndex(ADispatch, AName);
        end;

        if Debug then
          Logit(AName);

        if Level = 0 then
          TheTree.FRoot := InterfaceName;

        if FGenerateHelp then
          FHelpGen.PageHeader(InterfaceName);
        //We're interested in properties which are all implemented by
        //methods so type is tkind_dispatch (can also try kind_interface?)
        if TypeAttr.TypeKind in [TKIND_INTERFACE, TKIND_DISPATCH] then
        begin
          if Level = 0 then
          begin
            TypeInfo.GetContainingTypeLib(Flib, c);
            LoadTypeLibrary(FLib);
            {Flib := nil;}
          end;

          //Iterate through all available functions
          for FuncIndex := 0 to TypeAttr.cFuncs - 1 do
          begin
             ParamList.Clear;
             Application.ProcessMessages;
             //Get description of method
             TypeInfo.GetFuncDesc(FuncIndex, FuncDesc);
             Try
               //Get name of method
               TypeInfo.GetDocumentation(FuncDesc.memid, @AName,
                 @DocStr, nil, nil);
               Names[0] := POleStr(aName);
               //Get id of method to use in Invoke
               Res := TypeInfo.GetIDsOfNames(Names, 1, id1);
               //Only interested in reading properties at the moment +
               //avoid ancestor methods i.e. > 1600000000
               if (Res = 0) and (id1[0] < 1600000000) and
                   (FuncDesc.InvKind = INVOKE_PROPERTYGET)  then
               begin
                 if FuncDesc.elemdescFunc.tdesc.vt <> VT_PTR then
                   ResultString := GetUserDefType(TypeInfo,
                           FuncDesc.elemdescFunc.tdesc.hreftype)
                 else
                 if FuncDesc.elemdescFunc.tdesc.vt = VT_PTR then
                   ResultString := GetUserDefType(TypeInfo,
                           FuncDesc.elemdescFunc.tdesc.ptdesc.hreftype);
                 begin
                   if Assigned(TheTree) then
                     TheTree.CurrentDoc := DocStr;
                   if FuncDesc.cParams = 0 then //No parameters so easy
                   begin
                     if not ValidateInterface(ADispatch, InterfaceName) or
                        not ValidateSpecial(AName, ADispatch, IsClone) then
                     begin
                       v := NAString;
                     end
                     else
                       v := GetIValue(TypeInfo, id1[0], ADispatch, -1, '', NoParams, FuncDesc.InvKind);
                     if (VarType(v) = varOleStr) and (v = NAString) then
                     begin
                       s := PropertyTypeString(FuncDesc, TypeInfo);
                       ThisTypeString := s;
                     end
                     else
                       s := GetValueString(v, ResultString);
                   end
                   else
                   begin
                   // Load param names & types

                     Res := TypeInfo.GetNames(FuncDesc.memid, ParamNames, FuncDesc.cParams + 1, c);
                     for ParamIndex := 1 to c - 1 do
                     begin
                      ResultString := GetUserDefType(TypeInfo,
                        FuncDesc.lprgelemdescParam^[ParamIndex - 1].tdesc.hreftype);
                      if ResultString = '' then
                      begin
                        if FuncDesc.lprgelemdescParam^[ParamIndex - 1].tdesc.ptdesc <> nil then
                          ResultString := GetUserDefType(TypeInfo,
                                FuncDesc.lprgelemdescParam^[ParamIndex - 1].tdesc.ptdesc.hreftype)
                        else
                          ResultString := VarTypeString(FuncDesc.lprgelemdescParam^[ParamIndex - 1].tdesc.vt);
                      end;

                      if ParamNames[ParamIndex] <> nil then
                      begin
                        ParamList.Add(ParamNames^[ParamIndex]);
                        ParamList[ParamList.Count - 1] :=
                          ParamList[ParamList.Count - 1] + ' : ' + ResultString;
                      end;
                     end;

{                     TypeInfo.GetNames(FuncDesc.memid, ParamNames, FuncDesc.cParams + 1, c);
                     for ParamIndex := 1 to c - 1 do
                     begin
                       if ParamNames[ParamIndex] <> nil then
                         ParamList.Add(ParamNames^[ParamIndex]);
                     end;}
                     ResultString := '';
                     s := '*Parameters needed*';
                   end;
                   if (s = 'IDispatch') then
                   begin
                   //We have another interface so need to recurse
                     ParentAddr := Pointer(IDispatch(V));
                     SaveID := TheTree.CurrentParent;
                     s := IntName(IDispatch(V));
                     AddToDisplayList(AName, '[ ' + s + ' ]',
                       sgu, Level, ParentAddr);
                     SaveArrayID := ArrayID;
                     if s = '*Unassigned*' then
                     begin
                       if FuncDesc.elemdescFunc.tdesc.ptdesc <> nil then
                         s := GetUserDefType(TypeInfo,
                           FuncDesc.elemdescFunc.tdesc.ptdesc.hreftype);
                     end;
                     AddToRtf(AName,{IntName(IDispatch(V))}'I', s,
                       {TheTree.CurrentParentCaption(Level)}InterfaceName, DocStr,
                         ParamList, FuncDesc.InvKind);
                     SaveIName := CurrentIName;
                     CurrentIName := AName;
                     if (not FGenerateHelp) or (FGenerateHelp and
                                           (not FHelpGen.KnownInterface(s))) then
                     if FRecurse then
                     begin
                       LocalIsClone := (AName[Length(AName)] = 'I') or
                                       (UpperCase(RemoveSquareBrackets(AName)) = 'TLSERIALBATCH');
                       s := ShowDetails(Level + 1, IDispatch(V), LocalIsClone);
                     end;
                     CurrentIName := SaveIName;
                     ArrayID := SaveArrayID;
                     TheTree.CurrentParent := SaveID;
                   end
                   else
                  if (s = '*Parameters needed*') then
                   begin
                   //First need to find number and type of params
                   //Only integer & character (i.e. string) params at the moment
                     MaxIndex := GetMaxIndex(AName, FuncDesc, IsChar);
                     MinIndex := GetMinIndex(AName, FuncDesc, IsChar);
                     if (FuncDesc.cParams = 1) and (MaxIndex > 0) and
                        (IsChar in [2, 3, 8] ) then
                     begin
                       InvalidParam := False;
                       i := MinIndex;
                       while not InvalidParam  and (i < MaxIndex + 1) do
                       begin
                        if IsChar = 8 then
                        begin
                        //if we are in the base object then CharIdx will be '*Character parameter needed*'
                        //as we have no way of knowing the possible strings.
                        //In the descendent frmToolkitInterface we override GetCharIndex
                        //to return all possible parameters for the method in question
                          CharIdx := GetCharIndex(AName, i);
                          ParamType := CharParam;
                          s1 := QuotedStr(CharIdx);
                        end
                        else
                        begin
                          CharIdx := '';
                          ParamType := IntParam;
                          //See if we can get enumerated type of parametere
                          if ParamList.Count > 0 then
                          begin  
                            pq := Pos(':', ParamList[0]);
                            if pq > 0 then
                             s1 := FHelpGen.EnumName(Copy(ParamList[0], pq + 2, Length(ParamList[0])), i);
                          end
                          else
                            s1 := '';

                          if s1 = '' then
                            s1 := IntToStr(i)
                          else
                            s1 := ' ' + s1 + ' ';
                        end;
                        if not (CharIdx = '*Character parameter needed*') or
                              (FuncDesc.InvKind = INVOKE_PROPERTYPUT) then
                        begin
                          Try
                          if not ValidateInterface(ADispatch, InterfaceName) or
                             not ValidateSpecial(AName, ADispatch, IsClone) then
                           begin
                                v := NAString;
                           end
                           else
                             v := GetIValue(TypeInfo, id1[0], ADispatch, i, CharIdx, ParamType, FuncDesc.InvKind);
                           if (VarType(v) = varOleStr) and (v = NAString) then
                           begin
                             s := PropertyTypeString(FuncDesc, TypeInfo);
                             ThisTypeString := s;
                           end
                           else
                             s := GetValueString(v, ResultString);
                            if s = 'IDispatch' then //Recurse if IDispatch
                            begin
                              SaveID := TheTree.CurrentParent;
                              AddToDisplayList(AName  + '[' + s1 +
                                                   ']', '[ ' + IntName(IDispatch(V)) + ' ]',
                                   sgu, Level, ParentAddr);

                              SaveArrayID := ArrayID;
                              AddToRtf(AName,{IntName(IDispatch(V))}'I', IntName(IDispatch(V)),
                               {TheTree.CurrentParentCaption(Level)}InterfaceName,
                                  DocStr, ParamList, FuncDesc.InvKind);

                             SaveIName := CurrentIName;
                             CurrentIName := AName;
                             if (not FGenerateHelp) or (FGenerateHelp and
                                           (not FHelpGen.KnownInterface(IntName(IDispatch(V))))) then
                             if FRecurse then
                             begin
                                LocalIsClone := (AName[Length(AName)] = 'I') or
                                       (UpperCase(RemoveSquareBrackets(AName)) = 'TLSERIALBATCH');

                              s := ShowDetails(Level + 1, IDispatch(V),
                                 LocalIsClone);
                             end;
                              TheTree.CurrentParent := SaveID;
                              ArrayID := SaveArrayID;
                              CurrentIName :=SaveIName;
                            end
                            else
                            if Copy(s, 1, 5) = 'Error' then
                            begin
                            //If we have an error then we've probably reached the
                            //top of the range for parameters, unless i = 0
                            //in which case we may be trying to access an array
                            //that starts at 1
                             if i > 0 then
                              InvalidParam := True
                             else
                              if FuncDesc.InvKind = INVOKE_PROPERTYPUT then
                              begin
                               AddToDisplayList(AName, s, sgu {InterfaceName}, Level, ParentAddr);
                               if ResultString = '' then
                                 ResultString := '@' + TypeString(V);
                               AddToRtf(AName,AName, ResultString,
                                 {TheTree.CurrentParentCaption(Level)}InterfaceName,
                                  DocStr, ParamList, FuncDesc.InvKind);
                            end;
                            end
                            else
                            begin
                             AddToDisplayList(AName + '[' + s1 +
                                                   ']', s, sgu {InterfaceName}, Level, ParentAddr);
                             if ResultString = '' then
                               ResultString := '@' + TypeString(V);
                             AddToRtf(AName,AName, ResultString,
                               {TheTree.CurrentParentCaption(Level)}InterfaceName,
                                DocStr, ParamList, FuncDesc.InvKind);
                            end;
                          Except
                           InvalidParam := True;
                          End;
                        end;
                        inc(i);
                        Application.ProcessMessages;
                       end; //while
                     end
                     else
                     begin
                      if (FuncDesc.cParams > 1) and
                         (FuncDesc.InvKind = INVOKE_PROPERTYGET) then
                        s := '*Multiple parameters required*'//Can't deal with this yet
                      else
                      if not (IsChar in [2, 3, 8]) then
                      begin
                          {CharIdx := '*Character parameter needed*';}
                          s :=  '*' + GetParameterType(IsChar) + ' parameter needed*';
                      end
                      else
                      if MaxIndex = 0 then
                      begin
                        s := '[ Array - no members ]';
                        ThisTypeString := PropertyTypeString(FuncDesc, TypeInfo);
                      end
                      else
                        s := '*Character parameter needed*';//Unknown string parameter needed
                      AddToDisplayList(AName, s, sgu, Level, ParentAddr);
                      if ResultString = '' then
                           ResultString := {TypeString(V);}
                              PropertyTypeString(FuncDesc, TypeInfo);

                      AddToRtf(AName,AName,ResultString,
                      { TheTree.CurrentParentCaption(Level)}InterfaceName,
                       DocStr, ParamList, FuncDesc.InvKind);

                     end;
                   end
                   else
                   begin
                     AddToDisplayList(AName, s, sgu, Level, ParentAddr);
                      if ResultString = '' then
                           ResultString := TypeString(V);
                     AddToRtf(AName,AName, ResultString,
                      { TheTree.CurrentParentCaption(Level)}InterfaceName,
                       DocStr, ParamList, FuncDesc.InvKind);
                   end;
                 end;
               end
               else
               begin
                if Res <> 0 then
                  AddToDisplayList(AName, 'Unable to get Dispatch ID: Error ' + ResultCode(Res), '', Level, nil)
                else
                if (Res = 0) and (id1[0] < 1600000000) and
                   (FuncDesc.InvKind = INVOKE_FUNC) and (FGenerateHelp) then
                begin
                  if FuncDesc.cParams > 0 then
                  begin
                     Res := TypeInfo.GetNames(FuncDesc.memid, ParamNames, FuncDesc.cParams + 1, c);
                     for ParamIndex := 1 to c - 1 do
                     begin
                      ResultString := GetUserDefType(TypeInfo,
                        FuncDesc.lprgelemdescParam^[ParamIndex - 1].tdesc.hreftype);
                      if ResultString = '' then
                      begin
                        if FuncDesc.lprgelemdescParam^[ParamIndex - 1].tdesc.ptdesc <> nil then
                        begin
                          ResultString := GetUserDefType(TypeInfo,
                                FuncDesc.lprgelemdescParam^[ParamIndex - 1].tdesc.ptdesc.hreftype);
                          if FuncDesc.lprgelemdescParam^[ParamIndex - 1].tdesc.vt = VT_PTR then
                          begin
                            if ResultString = '' then
                            ResultString := VarTypeString(FuncDesc.lprgelemdescParam^[ParamIndex - 1].tdesc.ptdesc.vt);
                            if (ResultString <> '') and
                            ((ResultString[1] <> 'I') or (Copy(ResultString, 1, 7) = 'Integer'))then
                            ResultString := ResultString + ' v';  //mark as var parameter
                          end;
                        end;
                        if ResultString = '' then
                            ResultString := VarTypeString(FuncDesc.lprgelemdescParam^[ParamIndex - 1].tdesc.vt);
                      end;

                      if ParamNames[ParamIndex] <> nil then
                      begin
                        ParamList.Add(ParamNames^[ParamIndex]);
                        ParamList[ParamList.Count - 1] :=
                          ParamList[ParamList.Count - 1] + ' : ' + ResultString;
                      end;
                     end;
                  end;
                  Try
                    if AName = 'Clone' then
                      ResultString := AName;
                      if FuncDesc.elemdescFunc.tdesc.ptdesc <> nil then
                      ResultString := GetUserDefType(TypeInfo,
                              FuncDesc.elemdescFunc.tdesc.ptdesc.hreftype)
                      else
                    ResultString := GetUserDefType(TypeInfo,
                           FuncDesc.elemdescFunc.tdesc.hreftype);
                  Except
                    ResultString := '';
                  End;
                  if ResultString = '' then
                  begin
                        ResultString := VarTypeString(FuncDesc.elemdescFunc.tdesc.vt);
                  end;
                  ResultString := ' : ' + ResultString;
                  AddToRtf(AName, AName, 'Function' + ResultString, InterfaceName,
                   DocStr, ParamList, FuncDesc.InvKind);
                end
                else
                if (Res = 0) and (id1[0] < 1600000000) and
                   (FuncDesc.InvKind = INVOKE_PROPERTYPUT) then
                begin

                  ResultString := GetUserDefType(TypeInfo,
                    FuncDesc.lprgelemdescParam^[0].tdesc.hreftype);

                      if ResultString = '' then
                      begin
                        if FuncDesc.lprgelemdescParam^[0].tdesc.ptdesc <> nil then
                          ResultString := GetUserDefType(TypeInfo,
                                FuncDesc.lprgelemdescParam^[0].tdesc.ptdesc.hreftype)
                        else
                          ResultString := VarTypeString(FuncDesc.lprgelemdescParam^[0].tdesc.vt);
                      end;



                  AddToRtf(AName, AName, ResultString, InterfaceName, '', ParamList, FuncDesc.InvKind);
                end;

               end;

             Finally
               TypeInfo.ReleaseFuncDesc(FuncDesc);
             End;
          end; {for FuncIndex := 0 to TypeAttr.cFuncs - 1}
        end; {type attr = TKIND_DISPATCH}
        Self.Caption := InterfaceName + ' - Interface browser';
        Result := '[ ' + InterfaceName + ' ]';

      Except
       on E : Exception do
        ShowMessage(E.Message);
      End;
    end
    else
      Result := '*Unassigned*';
  Finally
     TypeInfo := nil;
{   ADispatch := nil;}
    Dispose(Names);
    Dispose(id1);
    Dispose(ParamNames);
    ParamList.Free;
    Screen.Cursor := OldC;
    IntFace.Caption := InterfaceName;
  End;
end;

function TfrmInterface.ResultCode(i : HResult) : string;
begin
  Case i and $FFFF of
    $0000 : Result := 'Success';
    $FFFF : Result := 'E_UNEXPECTED';
    $4001 : Result := 'E_NOTIMPL';
    $000E : Result := 'E_OUTOFMEMORY';
    $0057 : Result := 'E_INVALIDARG';
    $4002 : Result := 'E_NOINTERFACE';
    $4003 : Result := 'E_POINTER';
    $0006 : Result := 'E_HANDLE';
    $4004 : Result := 'E_ABORT';
    $4005 : Result := 'E_FAIL';
    $0005 : Result := 'E_ACCESSDENIED';
   else
     Result := 'Unknown error: ' + IntToStr(i and $FFFF);
  end;

  if Result[1] = 'U' then
  begin
    Case i of
       DISP_E_UNKNOWNINTERFACE   : Result := 'Unknown interface';
       DISP_E_MEMBERNOTFOUND     : Result := 'Member not found';
       DISP_E_PARAMNOTFOUND      : Result := 'Param not found';
       DISP_E_TYPEMISMATCH       : Result := 'Type mismatch';
       DISP_E_UNKNOWNNAME        : Result := 'Unknown name';
       DISP_E_NONAMEDARGS        : Result := 'No named arguments';
       DISP_E_BADVARTYPE         : Result := 'Bad variable type';
       DISP_E_EXCEPTION          : Result := 'Exception occurred';
       DISP_E_OVERFLOW           : Result := 'Out of present range';
       DISP_E_BADINDEX           : Result := 'Invalid index';
       DISP_E_UNKNOWNLCID        : Result := 'Unknown language';
       DISP_E_ARRAYISLOCKED      : Result := 'Memory is locked';
       DISP_E_BADPARAMCOUNT      : Result := 'Invalid number of parameters';
       DISP_E_PARAMNOTOPTIONAL   : Result := 'Parameter not optional';
       DISP_E_BADCALLEE          : Result := 'Invalid callee';
       DISP_E_NOTACOLLECTION     : Result := 'Does not support a collection';
    end; {case}
  end;


end;

function TfrmInterface.GetIValue(ATypeInfo : ITypeInfo;
                                  id : integer; const Dispatch : IDispatch;
                                   AParam : integer;
                                   CParam : WideString;
                                   ParamType : Byte;
                                   iKind : TInvokeKind) : Variant;
var
  Params : TDispParams;
  V : Variant;
  Flags : word;
  ArgError : integer;
  s : WideString;
  ExcepInfo : TExcepInfo;
  Res : HResult;
  P : PVariant;
  V1 : Variant;
begin
{  if iKind = INVOKE_PROPERTYPUT then
  begin
    Result.vt := VT_BSTR;
    Result.bstrVal := 'Set property method';
    Exit;
  end;}
  V1 := 'Exception';
  FillChar(Params, SizeOf(Params), #0);
  with Params do
  begin
    rgvarg:= nil;
    rgdispidNamedArgs:= nil;
    cArgs:= 0;
    cNamedArgs:= 0;
  end;
  if ParamType = IntParam then
  begin
    Args[0].vt := VT_I2;
    Args[0].iVal := AParam;
    Params.rgvarg := @Args;
    Params.cArgs := 1;
  end
  else
  if ParamType = CharParam then
  begin
    Args[0].vt := VT_BSTR;
    Args[0].bstrVal := PWideChar(CParam);
    Params.rgvarg := @Args;
    Params.cArgs := 1;
  end;

  ArgError := 0;
  P := @V;

  FillChar(ExcepInfo, SizeOf(ExcepInfo), #0);
  Flags := DISPATCH_PROPERTYGET;

  if Assigned(Dispatch) then
  begin
   Try
    {$IFDEF WantExe}
    Res := Dispatch.Invoke(ID, IID_NULL, LOCALE_USER_DEFAULT, Flags, Params, P, @ExcepInfo, @ArgError);
    {$ELSE}
    Res := ATypeInfo.Invoke(Pointer(Dispatch), ID, Flags, Params, P, @ExcepInfo,
                      @ArgError);
    {$ENDIF}
    if Res = 0 then
    begin
      Result := V;
    end
    else
    begin
      if ExcepInfo.bstrDescription <> '' then
        Result := 'Error: ' + ExcepInfo.bstrDescription
      else
        Result := 'Error: ' + ResultCode(Res);
    end;
   Except
    On E : Exception do
    begin
      Result := E.Message;
      if Result = '' then
        Result := V1;
    end;
   End;
  end;
end;

function TfrmInterface.GetValueString(V : Variant; const UDType : string) : string;
//Return a string value from a variant
var
  s : string;
begin
  s := '';
      if VarType(V) and $2000 = $2000 then Result := 'Array' else
      begin
        Case (VarType(V) and varTypeMask) of
            varEmpty,
            varNull      :  Result := '';
            varSmallint,
            varInteger   :  Result := IntToStr(V);
            varSingle,
            varDouble,
            varCurrency  :  Result := FloatToStrF(V, ffNumber, 15, 2);
            varDate      :  Result := DateToStr(V);
            varOleStr    :  Result := V;
            varDispatch  :  Result := 'IDispatch';
            varError     :  Result := 'Error';
            varBoolean   :  if V then
                              Result := 'True'
                            else
                              Result := 'False';
            varVariant   : Result := 'Variant';
            varUnknown   : Result := 'IUnknown';
            varByte      : Result := IntToStr(V);

            varStrArg    : Result := V;
            varString    : Result := V;
        end;{Case}
      end;

      if (UDType <> '') and (UDType[1] <> '@') and
         (Result <> 'IDispatch') and (Pos('Error', Result) <> 1) and
         (Result <> NAString) then
        s := FHelpGen.EnumName(UDType, V);

      if s <> '' then
        Result := s;

      if (UDType <> '') then
      begin
        if UDType[1] = '@' then
          ThisTypeString := Copy(UDType, 2, Length(UDType))
        else
          ThisTypeString := UDType;
      end
      else
        ThisTypeString := TypeString(V);
end;

function TfrmInterface.TypeString(V : Variant) : string;
//Return a string value from a variant
begin
      if VarType(V) and $2000 = $2000 then Result := 'Array' else
      begin
        Case (VarType(V) and varTypeMask) of
            varEmpty     :  Result := 'Empty';
            varNull      :  Result := 'Null';
            varSmallint  :  Result := 'Smallint';
            varInteger   :  Result := 'Integer';
            varSingle    :  Result := 'Single';
            varDouble    :  Result := 'Double';
            varCurrency  :  Result := 'Currency';
            varDate      :  Result := 'Date';
            varOleStr    :  Result := 'WideString';
            varDispatch  :  Result := 'IDispatch';
            varError     :  Result := 'Error';
            varBoolean   :  Result := 'WordBool';
            varVariant   :  Result := 'Variant';
            varUnknown   :  Result := 'Unknown';
            varByte      :  Result := 'Byte';
            varStrArg    :  Result := 'WideString';
            varString    :  Result := 'String';
        end;{Case}
      end;
end;

function TfrmInterface.VarTypeString(V : Variant) : string;
//Return a string value from a variant Type
begin
        Case (V) of
            varEmpty     :  Result := 'Empty';
            varNull      :  Result := 'Null';
            varSmallint  :  Result := 'Smallint';
            varInteger   :  Result := 'Integer';
            varSingle    :  Result := 'Single';
            varDouble    :  Result := 'Double';
            varCurrency  :  Result := 'Currency';
            varDate      :  Result := 'Date';
            varOleStr    :  Result := 'WideString';
            varDispatch  :  Result := 'IDispatch';
            varError     :  Result := 'Error';
            varBoolean   :  Result := 'WordBool';
            varVariant   :  Result := 'Variant';
            varUnknown   :  Result := 'Unknown';
            varByte      :  Result := 'Byte';
            varStrArg    :  Result := 'WideString';
            varString    :  Result := 'String';
        end;{Case}
end;



procedure TfrmInterface.FormCreate(Sender: TObject);
var
  i : integer;
begin
  Log := TStringList.Create;
  FFunctionLog := TStringList.Create;
  ArrayList := TStringList.Create;
  SaveStateList := TList.Create;
  TheTree := TInterfaceTreeObject.Create;
  FShowParentGUID := False;
  FShowParentAddress := False;
  FTopItem := -1;
  FHelpGen := THelpGenerator.Create;
  FHelpGen.ProgressForm := Self;
  DispatchList := TStringList.Create;
  CurrentIName := 'Root';
  StayOnTop.Checked := FormStyle = fsStayOnTop;
  FTestMode := False;
  FRecurse := False;
  FCurrentIndex := 0;
  FirstTime := True;
{$IFNDEF AllowHelp}
  GenerateHelpFile1.Visible := False;
  Debug1.Visible := False;
  Test1.Visible := False;
{$ENDIF}
end;

procedure TfrmInterface.FormDestroy(Sender: TObject);
begin
  if Assigned(Log) then
    Log.Free;
{$IFDEF AllowHelp}
 Try
  TheTree.WriteToFile('d:\tree.txt');
  ArrayList.SaveToFile('d:\array.txt');
 Except
 End;
{$ENDIF}
  ArrayList.Free;
  TheTree.Free;
  if HandleSet then
    Application.Handle := OldHandle;
  FDispatch := nil;
  if Assigned(FHelpGen) then
  begin
    FHelpGen.Free;
  end;
  DispatchList.Free;
  SaveStateList.Free;
  FFunctionLog.Free;

end;

function TfrmInterface.RemoveSquareBrackets(const s : string) : string;
var
  i : integer;
begin
  Result := s;
  i := Pos('[', Result);
  if i > 0 then
    Delete(Result, i, Length(Result));
end;

procedure TfrmInterface.AddToDisplayList(PropertyName, PropertyValue, ParentStr : string;
                                         IndentLevel : integer; const ParentAddr : Pointer);
var
  ThisId : longint;
  OutString : String;
  IsArray, NewArray : Boolean;
  ArrayString : string;
begin
(*  IsArray := False;
  NewArray := False;
  OutString := StringOfChar(' ', IndentLevel * 3);

  if Pos('[', PropertyName) > 0 then
  begin
    IsArray := True;
    TheTree.InArray := True;
    ArrayString := RemoveSquareBrackets(PropertyName);
    NewArray := ArrayList.IndexOf(CurrentIName + '.' + ArrayString) = -1;
    if NewArray then
    begin
      ArrayList.Add(CurrentIName + '.' + ArrayString);
      if Assigned(TheTree) then
      begin
        ArrayID := TheTree.AddItem(ArrayString, '[ Array ]', ParentStr, ThisTypeString, IndentLevel,
                                   ParentAddr);
{        OutString := OutString + ArrayString + ' - ' + '[ Array ]';}
        if ParentStr <> '' then
          OutString := OutString + ' - ' + ParentStr;
{        LogIt(OutString);}
      end;
    end;
  end
  else
  begin
    if TheTree.InArray then
    begin
      TheTree.InArray := False;
    end;
  end;




  if Assigned(TheTree) then
  begin
    if IsArray then
    ThisID := TheTree.AddParentedItem(PropertyName, PropertyValue, ParentStr, ThisTypeString, IndentLevel + 1,
                               ParentAddr, ArrayID)
    else
    ThisID := TheTree.AddItem(PropertyName, PropertyValue, ParentStr, ThisTypeString, IndentLevel,
                               ParentAddr);
    OutString := OutString + PropertyName + ' - ' + PropertyValue;
    if ParentStr <> '' then
      OutString := OutString + ' - ' + ParentStr;
    LogIt(OutString);
  end;

  if NewArray then
  begin
    PropertyName := ArrayString;
    PropertyValue := '[Array]';
    ThisID := ArrayID;
  end;


  if IndentLevel = 0 then {show on display}
  if not IsArray or NewArray then
  with lvFuncs.Items.Add do
  begin
    Caption := PropertyName;
    SubItems.Add(PropertyValue);

    if FShowParentGUID then
    begin
      if FShowParentAddress and (ParentAddressCol < ParentGUIDCol) then
        SubItems.Add('$' + IntToHex(longint(ParentAddr), 8));
      SubItems.Add(ParentStr);
      if FShowParentAddress and (ParentAddressCol > ParentGUIDCol) then
        SubItems.Add('$' + IntToHex(longint(ParentAddr), 8));
    end
    else
    if FShowParentAddress then
      SubItems.Add('$' + IntToHex(longint(ParentAddr), 8));

    if (Length(PropertyValue) > 1) and (PropertyValue[1] = '[') then
    begin
      if PropertyValue = '[ *Unassigned* ]' then
        ImageIndex := 2
      else
        ImageIndex := 0;
      Data := Pointer(ThisID);
    end
    else
    begin
      ImageIndex := -1;
      Data := Pointer({0}ThisID);
    end;
    Indent := IndentLevel;
  end;
  *)
  if FRecurse then
    RecurseAdd(PropertyName, PropertyValue, ParentStr, IndentLevel, ParentAddr)
  else
    NonRecurseAdd(PropertyName, PropertyValue, ParentStr, IndentLevel, ParentAddr);

end;

procedure TfrmInterface.RecurseAdd(PropertyName, PropertyValue, ParentStr : string;
                                         IndentLevel : integer; const ParentAddr : Pointer);
var
  ThisId : longint;
  OutString : String;
  IsArray, NewArray : Boolean;
  ArrayString : string;
begin
  IsArray := False;
  NewArray := False;
  ThisId := 0;
  OutString := StringOfChar(' ', IndentLevel * 3);

  if Pos('[', PropertyName) > 0 then
  begin
    IsArray := True;
    TheTree.InArray := True;
    ArrayString := RemoveSquareBrackets(PropertyName);
    NewArray := ArrayList.IndexOf(CurrentIName + '.' + ArrayString +
                                  '.' + IntToHex(Integer(ParentAddr), 8)) = -1;
    if NewArray then
    begin
      ArrayList.Add(CurrentIName + '.' + ArrayString + '.' + IntToHex(Integer(ParentAddr), 8));
      if Assigned(TheTree) then
      begin
        ArrayID := TheTree.AddItem(ArrayString, '[ Array ]', ParentStr, ThisTypeString, IndentLevel,
                                   ParentAddr);
{        OutString := OutString + ArrayString + ' - ' + '[ Array ]';}
        if ParentStr <> '' then
          OutString := OutString + ' - ' + ParentStr;
{        LogIt(OutString);}
      end;
    end;
  end
  else
  begin //This part is irrelevant now
    if TheTree.InArray then
    begin
      TheTree.InArray := False;
    end;
  end;




  if Assigned(TheTree) then
  begin
    if IsArray then
    ThisID := TheTree.AddParentedItem(PropertyName, PropertyValue, ParentStr, ThisTypeString, IndentLevel + 1,
                               ParentAddr, ArrayID)
    else
    ThisID := TheTree.AddItem(PropertyName, PropertyValue, ParentStr, ThisTypeString, IndentLevel,
                               ParentAddr);
    OutString := OutString + PropertyName + ' - ' + PropertyValue;
    if ParentStr <> '' then
      OutString := OutString + ' - ' + ParentStr;
    LogIt(OutString);
  end;

  if NewArray then
  begin
    PropertyName := ArrayString;
    PropertyValue := '[Array]';
    ThisID := ArrayID;
  end;


  if IndentLevel = 0 then {show on display}
  if not IsArray or NewArray then
  with lvFuncs.Items.Add do
  begin
    Caption := PropertyName;
    SubItems.Add(PropertyValue);

    if FShowParentGUID then
    begin
      if FShowParentAddress and (ParentAddressCol < ParentGUIDCol) then
        SubItems.Add('$' + IntToHex(longint(ParentAddr), 8));
      SubItems.Add(ParentStr);
      if FShowParentAddress and (ParentAddressCol > ParentGUIDCol) then
        SubItems.Add('$' + IntToHex(longint(ParentAddr), 8));
    end
    else
    if FShowParentAddress then
      SubItems.Add('$' + IntToHex(longint(ParentAddr), 8));

    if (Length(PropertyValue) > 1) and (PropertyValue[1] = '[') then
    begin
      if PropertyValue = '[ *Unassigned* ]' then
        ImageIndex := 2
      else
        ImageIndex := 0;
      Data := Pointer(ThisID);
    end
    else
    begin
      ImageIndex := -1;
      Data := Pointer({0}ThisID);
    end;
    Indent := IndentLevel;
  end;
end;

procedure TfrmInterface.NonRecurseAdd(PropertyName, PropertyValue, ParentStr : string;
                                         IndentLevel : integer; const ParentAddr : Pointer);
var
  ThisId : longint;
  OutString : String;
  IsArray, NewArray : Boolean;
  ArrayString : string;
begin
  ThisId := 0;
  IsArray := False;
  NewArray := False;
  OutString := StringOfChar(' ', IndentLevel * 3);

  if Pos('[', PropertyName) > 0 then
  begin
    IsArray := True;
    TheTree.InArray := True;
    ArrayString := RemoveSquareBrackets(PropertyName);
    NewArray := ArrayList.IndexOf(CurrentIName + '.' + ArrayString) = -1;
    if NewArray then
    begin
      ArrayList.Add(CurrentIName + '.' + ArrayString);
      if Assigned(TheTree) then
      begin
        ArrayID := TheTree.AddItem(ArrayString, '[ Array ]', ParentStr, ThisTypeString, IndentLevel,
                                   ParentAddr);
{        OutString := OutString + ArrayString + ' - ' + '[ Array ]';}
        if ParentStr <> '' then
          OutString := OutString + ' - ' + ParentStr;
{        LogIt(OutString);}
      end;
    end;
  end
  else
  begin
    if TheTree.InArray then
    begin
      TheTree.InArray := False;
    end;
  end;




  if Assigned(TheTree) then
  begin
    if IsArray then
    ThisID := TheTree.AddParentedItem(PropertyName, PropertyValue, ParentStr, ThisTypeString, IndentLevel + 1,
                               ParentAddr, ArrayID)
    else
    ThisID := TheTree.AddItem(PropertyName, PropertyValue, ParentStr, ThisTypeString, IndentLevel,
                               ParentAddr);
    OutString := OutString + PropertyName + ' - ' + PropertyValue;
    if ParentStr <> '' then
      OutString := OutString + ' - ' + ParentStr;
    LogIt(OutString);
  end;

  if NewArray then
  begin
    PropertyName := ArrayString;
    PropertyValue := '[Array]';
    ThisID := ArrayID;
  end;


{  if IndentLevel = 0 then {show on display}
  if not IsArray or NewArray then
  with lvFuncs.Items.Insert(FCurrentIndex) do
  begin
    Caption := PropertyName;
    SubItems.Add(PropertyValue);

    if FShowParentGUID then
    begin
      if FShowParentAddress and (ParentAddressCol < ParentGUIDCol) then
        SubItems.Add('$' + IntToHex(longint(ParentAddr), 8));
      SubItems.Add(ParentStr);
      if FShowParentAddress and (ParentAddressCol > ParentGUIDCol) then
        SubItems.Add('$' + IntToHex(longint(ParentAddr), 8));
    end
    else
    if FShowParentAddress then
      SubItems.Add('$' + IntToHex(longint(ParentAddr), 8));

    if (Length(PropertyValue) > 1) and (PropertyValue[1] = '[') then
    begin
      if PropertyValue = '[ *Unassigned* ]' then
        ImageIndex := 2
      else
        ImageIndex := 0;
      Data := Pointer(ThisID);
    end
    else
    begin
      ImageIndex := -1;
      Data := Pointer({0}ThisID);
    end;
    Indent := IndentLevel;
{    if IndentLevel > 0 then}
      inc(FCurrentIndex);
  end;
end;


function TfrmInterface.IntName(const I : IDispatch) : string;
var
  TypeInfo : ITypeInfo;
  AName : WideString;
  Res : integer;
begin
    if Assigned(I) then
    begin
      Try
        Res := I.GetTypeInfo(0,0,TypeInfo);
        if Res = 0 then
        Res := TypeInfo.GetDocumentation(-1, @AName,
                 nil, nil, nil);
        if Res = 0 then
          Result := AName
        else
          Result := '';
      Finally
        TypeInfo := nil;
      End;
    end
    else
      Result := '*Unassigned*';
end;


procedure TfrmInterface.ShowSubItems(WhichItem : TListItem);
var
  i : integer;
  d : longint;
  AddCount : integer;
  Lev : Word;
  GUIDFirst : Boolean;
  s : string;
begin
  if Assigned(TheTree) then
  begin
    if FShowParentGUID then
    begin
      if FShowParentAddress and (ParentAddressCol < ParentGUIDCol) then
        GUIDFirst := False
      else
        GUIDFirst := True;
    end
    else GUIDFirst := False;

    if not FRecurse and (Pos('Array', WhichItem.Caption) = 0) then
    begin
      s := WhichItem.Caption;
      FCurrentIndex := WhichItem.Index + 1;
      ShowDetails(WhichItem.Indent + 1, IDispatch(TheTree.ItemInterfaceAddress(WhichItem)),
                  (s[Length(s)] = 'I') or (UpperCase(RemoveSquareBrackets(s)) =
                   'TLSERIALBATCH'));
    end;

    AddCount := TheTree.ShowBranch(lvFuncs, WhichItem, GUIDFirst);
  end;
end;

procedure TfrmInterface.lvFuncsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  TheItem : TListItem;
  ParentType : string;
  Ro : Boolean;
  RoString : string;
  s : string;
begin
  Ro := False;
  with lvFuncs do
  if Button = mbRight then
  begin
    TheItem := GetItemAt(X,Y);
    if TheItem <> nil then
    begin
     if (TheItem.ImageIndex in [1, 0]) and
        (Pos('Array', TheItem.SubItems[0]) = 0)  then
       ShowFunctionMenu(TheTree.ItemInterfaceAddress(TheItem), X, Y);
    end;
  end
  else
  begin
    TheItem := GetItemAt(X,Y);
    if TheItem <> nil then
    begin
      ParentType := TheTree.ParentType(TheItem, RootType);
      if Assigned(FHelpGen) then
        Ro := FHelpGen.IsReadOnly(RemoveSquareBrackets(TheItem.Caption), ParentType);
      if Ro then
        RoString := ' (Read only)'
      else
        RoString := '';
        s := TheTree.ItemType(TheItem) + RoString;
        if Length(TheTree.ItemDoc(TheItem)) > 0 then
          s := s + ': ' +  TheTree.ItemDoc(TheItem);
        StatusBar1.SimpleText := s;
        StatusBar1.Hint := s;
      if htOnIcon in GetHitTestInfoAt(X,Y) then
      begin
        Case TheItem.ImageIndex of
          0  : begin
                 ShowSubItems(TheItem);
                 TheItem.ImageIndex := 1;
                 TheTree.AddState(TheItem.Data);
               end;
          1  : begin
                 HideSubItems(TheItem.Index);
                 TheItem.ImageIndex := 0;
                 TheTree.RemoveState(TheItem.Data);
               end;
        end; {case}
      end; {if }
    end;
  end; {with lvFuncs}

end;

procedure TfrmInterface.HideSubItems(Index : integer);
var
  i : integer;
  s : string;
begin
  i := Index + 1;
  with lvFuncs do
  begin
    while (i < Items.Count) and (Items[i].Indent > Items[Index].Indent) do
      if i >= 0 then
        Items.Delete(i);

    if not FRecurse then
    begin
      s := IntToStr(Integer(TheTree.ItemInterfaceAddress(Items[Index])));
      i := DispatchList.IndexOf(s);
      if i > -1 then
        DispatchList.Delete(i);
    end;

  end;
end;

function TfrmInterface.GetMaxIndex(Name : string; FuncDesc : PFuncDesc;
                                   var IsChar : Byte) : integer;
begin
  Result := 0;
  IsChar := FuncDesc.lprgelemdescParam[0].tdesc.vt;
  if IsChar = 8 then
  begin
    Result := DefaultMaxCharIndex;
  end
  else
  if IsChar in [2, 3] then
  begin
    Result := DefaultMaxIndex;
  end;
end;

function TfrmInterface.GetSpecialMaxIndex(const ADispatch : IDispatch;
                                          const AName : WideString) : integer;
begin
  Result := DefaultMaxIndex;
end;

function TfrmInterface.GetMinIndex(Name : string; FuncDesc : PFuncDesc;
                                    var IsChar : Byte) : word;
begin
  Result := 0;
end;

function TfrmInterface.AvailableInClone(const AName : WideString) : Boolean;
begin
  Result := True;
end;

function TfrmInterface.ValidateSpecial(const AName : WideString; const ADispatch : IDispatch;
                             IsClone : Boolean) : Boolean;
begin
  Result := True;
end;

function TfrmInterface.ValidateInterface(const ADispatch : IDispatch;
                                         const AName : WideString) : Boolean;
begin
  Result := True;
end;



procedure TfrmInterface.LogIt(const Msg : string);
begin
  Log.Add(Msg);
end;

procedure TfrmInterface.SetDispatch(const ADispatch : IDispatch);
begin
  FDispatch := ADispatch;
  if Assigned(TheTree) then
    TheTree.StateList.Clear;
end;

procedure TfrmInterface.SetGUID(Value : Boolean);
var
  i, j : integer;
begin
  if Value then
  begin
    if not FShowParentGUID then
    begin
      FShowParentGUID := True;
{      SetAddress(False);}
      with lvFuncs.Columns.Add do
      begin
        Caption := 'Owner GUID';
        Width := 250;
      end;
      ShowOwnerGUIDs.Checked := True;
    end;
  end
  else
  begin
    if FShowParentGUID then
    begin
      FShowParentGUID := False;
      i := ParentGUIDCol;
      if i <> -1 then
      begin
        lvFuncs.Columns.Delete(i);
        for j := 0 to lvFuncs.Items.Count - 1 do
          lvFuncs.Items.Item[j].SubItems.Delete(i -1);
      end;
      ShowOwnerGUIDs.Checked := False;
    end;
  end;
end;


procedure TfrmInterface.SetAddress(Value : Boolean);
var
  i, j : integer;
begin
  if Value then
  begin
    if not FShowParentAddress then
    begin
      FShowParentAddress := True;
{      SetGUID(False);}
      with lvFuncs.Columns.Add do
      begin
        Caption := 'Owner Address';
        Width := 100;
      end;
    ShowOwnerAddresses.Checked := True;
    end;
  end
  else
  begin
    i := ParentAddressCol;
    if i <> -1 then
    begin
      lvFuncs.Columns.Delete(i);
      for j := 0 to lvFuncs.Items.Count - 1 do
        lvFuncs.Items.Item[j].SubItems.Delete(i -1);
    end;
    FShowParentAddress := False;
    ShowOwnerAddresses.Checked := False;
  end;
end;

procedure TfrmInterface.Clear;
begin
  lvFuncs.Items.Clear;
  DispatchList.Clear;
  if Assigned(TheTree) then
    TheTree.Clear;
  if Assigned(ArrayList) then
    ArrayList.Clear;
  if Assigned(DispatchList) then
    DispatchList.Clear;
  Log.Clear;
end;


procedure TfrmInterface.ShowOwnerGUIDsClick(Sender: TObject);
begin
   with ShowOwnerGUIDs do
   begin
     Checked := not Checked;
     ShowParentGUID := Checked;
   end;
   UpdateDetails(True);
end;

procedure TfrmInterface.ShowOwnerAddressesClick(Sender: TObject);
begin
   with ShowOwnerAddresses do
   begin
     Checked := not Checked;
     ShowParentAddress := Checked;
   end;
   UpdateDetails(True);
end;

procedure TfrmInterface.UpdateDetails(ShowForm : Boolean);
var
  i : integer;
begin
  if Assigned(FBeforeUpdate) then
    FBeforeUpdate(Self);

  ArrayList.Clear;
  FFunctionInterface := nil;
  FLastFunctionResult := '';

  if Assigned(COMInterface) then
  begin
    IntFace.Visible := False;
    FFunctionInterface := Pointer(ComInterface);
    if Assigned(lvFuncs.TopItem) then
      FTopItem := lvFuncs.TopItem.Index; //save top item
    SaveState;

    Clear;
    ShowDetails(0, COMInterface, False);
    RestoreStateList;
    RestoreState; //Re-expand any expanded branches
{    lvFuncs.TopItem := lvFuncs.Items[FTopItem];}
    if FTopItem > -1 then
    begin //Set top item to original top item
      i := FTopItem + lvFuncs.VisibleRowCount - 1;
      if i > lvFuncs.Items.Count - 1 then
        i := lvFuncs.Items.Count - 1;
      lvFuncs.Items[{WhichItem.Index + AddCount}i].MakeVisible(False);
    end;

    if IntFace.Caption <> 'IToolkit' then
      IntFace.Visible := True;
    if ShowForm then
      if not Visible then Show;
  end;

  if Assigned(FAfterUpdate) then
    FAfterUpdate(Self);



end;

procedure TfrmInterface.StayOnTopClick(Sender: TObject);
var
  i : longint;
  LocalTopItem : longint;
begin
  LocalTopItem := -1;
//Changing the formstyle of the form seems to lose a lot of settings in
//the listview, so we need to refresh the listview.
//However, as the topitem is already lost by the time we refresh so
//we need to save and restore it here as well.
  if Assigned(lvFuncs.TopItem) then
   LocalTopItem := lvFuncs.TopItem.Index; //save top item
  with StayOnTop do
  begin
    Checked := not Checked;
    if Checked then
      Self.FormStyle := fsStayOnTop
    else
      Self.FormStyle := fsNormal;
  end;
  Refresh1Click(Self);

  if LocalTopItem > -1 then
  begin //Set top item to original top item
    i := LocalTopItem + lvFuncs.VisibleRowCount - 1;
    if i > lvFuncs.Items.Count - 1 then
      i := lvFuncs.Items.Count - 1;
    lvFuncs.Items[{WhichItem.Index + AddCount}i].MakeVisible(False);
  end;

end;



procedure TfrmInterface.lvFuncsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
      UpdateDetails(True)
  else
  if Key = VK_F1 then
    ShowHelpMsg(StatusBar1.SimpleText);
end;

procedure TfrmInterface.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmInterface.Export1Click(Sender: TObject);
var
  WasOnTop : Boolean;
begin
  WasOnTop :=  FormStyle = fsStayOnTop;
  if WasOnTop then
    FormStyle := fsNormal;
  if SaveDialog1.Execute then
    Log.SaveToFile(SaveDialog1.FileName);
  if WasOnTop then
  begin
    FormStyle := fsStayOnTop;
    Refresh1Click(Self);
  end;
end;

procedure TfrmInterface.Refresh1Click(Sender: TObject);
begin
  UpdateDetails(True);
end;

function TfrmInterface.GetCharIndex(const AName : string; i : integer) : WideString;
begin
  Result := '*Character parameter needed*';
end;


procedure TfrmInterface.RestoreState;
var
  i : integer;
  ThisItem : TListItem;

  function GetItem(D : integer) : TListItem;
  begin
    Result := lvFuncs.FindData(0, Pointer(D), True, False);
  end;

begin
  if Assigned(TheTree) then
  with TheTree do
  begin
   if StateList.Count > 0 then
    for i := 0 to StateList.Count -1 do
    begin
      ThisItem := GetItem(integer(TheTree.StateList.Items[i]));
      ShowSubItems(ThisItem);
      ThisItem.ImageIndex := 1;
{      lvFuncs.Items[integer(TheTree.StateList.Items[i])].ImageIndex := 1;}

    end;
  end;
end;

function TfrmInterface.ParentGUIDCol : integer;
var
  i : integer;
begin
  Result := -1;
  with lvFuncs do
  begin
    for i := Columns.Count - 1 downto 2 do
    begin
      if Column[i].Caption = 'Owner GUID' then
        Result := i;
    end;
  end;

end;

function TfrmInterface.ParentAddressCol : integer;
var
  i : integer;
begin
  Result := -1;
  with lvFuncs do
  begin
    for i := Columns.Count - 1 downto 2 do
    begin
      if Column[i].Caption = 'Owner Address' then
        Result := i;
    end;
  end;

end;

function TfrmInterface.GetParameterType(i : integer) : string;
begin
  Case i of
    VT_EMPTY          : Result := 'No';
    VT_NULL           : Result := 'Null';
    VT_I2             : Result := 'Integer';
    VT_I4             : Result := 'longint';
    VT_R4             : Result := '4 byte float';
    VT_R8             : Result := '4 byte float';
    VT_CY             : Result := 'Currency';
    VT_DATE           : Result := 'Date';
    VT_BSTR           : Result := 'String';
    VT_DISPATCH       : Result := 'IDispatch';
    VT_ERROR          : Result := 'Error';
    VT_BOOL           : Result := 'Boolean';
    VT_VARIANT        : Result := 'Variant';
    VT_UNKNOWN        : Result := 'Unknown';
    VT_DECIMAL        : Result := '16 byte fixed point';
    VT_I1             : Result := 'signed char';
    VT_UI1            : Result := 'unsigned char';
    VT_UI2            : Result := 'unsigned short';
    VT_UI4            : Result := 'unsigned short';
    VT_I8             : Result := 'signed 64-bit int';
    VT_UI8            : Result := 'unsigned 64-bit int';
    VT_INT            : Result := 'signed machine int';
    VT_UINT           : Result := 'unsigned machine int';
    VT_VOID           : Result := 'C style void';
    VT_HRESULT        : Result := 'Hresult';
    VT_PTR            : Result := 'Pointer type';
    VT_SAFEARRAY      : Result := 'Safe array';
    VT_CARRAY         : Result := 'C style array';
    VT_USERDEFINED    : Result := 'user defined type';
    VT_LPSTR          : Result := 'null terminated string';
    VT_LPWSTR         : Result := 'wide null terminated string';
    VT_FILETIME       : Result := 'FILETIME';
    VT_BLOB           : Result := 'Length prefixed bytes';
    VT_STREAM         : Result := 'Stream';
    VT_STORAGE        : Result := 'Storage';
    VT_STREAMED_OBJECT: Result := 'Streamed object';
    VT_STORED_OBJECT  : Result := 'Storage object';
    VT_BLOB_OBJECT    : Result := 'Blob object';
    VT_CF             : Result := 'Clipboard format';
    VT_CLSID          : Result := 'Class ID';
  end; {case}
end;



//----------------------------------------------------------------------------//
//  TTfrmToolkitInterface
//----------------------------------------------------------------------------//

function TfrmToolkitInterface.GetMaxIndex(Name : string; FuncDesc : PFuncDesc;
                                          var IsChar : Byte) : integer;
// This function is hard-coded to specify the range for an index-based property
var
  s : string;
  i : integer;
begin
  Result := inherited GetMaxIndex(Name, FuncDesc, IsChar);
  //In Com toolkit UserDefined types are usually enumerated so translate to
  //integer
  if IsChar = VT_USERDEFINED then
    IsChar := 3;
  s := UpperCase(Name);
  if IsChar in [3, 8] then
  begin
    if (s = 'THVATANALYSIS') or (s = 'SSVATRATES') or
          (s = 'THGOODSANALYSIS') then
      Result := 21
    else
     if s = 'SSGLCTRLCODES' then
        Result := 15
    else
      if s = 'SSDOCUMENTNUMBERS' then
        Result := 44
    else
      if (s = 'STSALESBANDS') or (s = 'SLSALESBANDS') then
        Result := 8
    else
      Result := 100;
  end;

  if Result = 100 then //can't allow that anymore
    for i := 1 to IntArrayCount do
    begin
{      ShowMessage(s + '  ' + IntToStr(i));}
      if s = IntArrays[i] then
        Result := Boundaries[i, ArrayMax];
    end;

{if this is a variable array eg cmCompany then we have set the SpecialMaxIndex
 variable already}

  if (Result = -1) then
    Result := SpecialMaxIndex;

end;

function TfrmToolkitInterface.GetSpecialMaxIndex(const ADispatch : IDispatch;
                                                 const AName : WideString) : integer;
var
  Res : integer;
  TypeInfo : ITypeInfo;
  Params : TDispParams;
  Flags : word;
  ArgError : integer;
  s : WideString;
  ExcepInfo : TExcepInfo;
  Res1 : HResult;
  P : PVariant;
  V : Variant;

  Names: POleStrlist;
  id1 : PMemberIDList;

  ID : WideString;
  i : integer;

begin
  Result := 0;
  if Assigned(ADispatch) then
  begin
    Result := 0;
    New(Names);
    New(Id1);
    TypeInfo := nil;

    Try

      for i := 1 to SpecArrayCount do
        if UpperCase(AName) = SpecialArrays[i] then
          ID := CountNames[i];



      Names[0] := POleStr(ID);

      Try
       Res := ADispatch.GetTypeInfo(0,0,TypeInfo);
      Except
       Res := -1;
      End;

      if (Res = 0) and Assigned(TypeInfo) then
      begin
        Res1 := TypeInfo.GetIDsOfNames(Names, 1, id1);

        if Res1 = 0 then
        begin
           v := GetIValue(TypeInfo, id1[0], ADispatch, -1, '', NoParams, INVOKE_PROPERTYGET);
           Result := V;
        end
        else
         FLastFunctionResult := ID + ' not available';

      end
      else
        FLastFunctionResult := 'Unable to get type info';
    Finally
      Dispose(Names);
      Dispose(id1);
      TypeInfo := nil;
      StatusBar1.SimpleText := 'Result : ' + FLastFunctionResult;

    End;
  end
  else
    FLastFunctionResult := 'Nil interface passed';

end;



function TfrmToolkitInterface.ValidateSpecial(const AName : WideString; const ADispatch : IDispatch;
                                                  IsClone : Boolean) : Boolean;
var
  v : variant;
  s : WideString;
  i : integer;
begin
  Result := True;


  if IsClone then
  begin
    if not AvailableInClone(AName) then
      Result := False;
  end;

  if Result = True then
  begin
    for i := 1 to SpecHandCount do
      if UpperCase(AName) = SpecialHandling[i, shName] then
      begin
        v := GetProperty(ADispatch, SpecialHandling[i, shTest]);

        Case i of
          1, 2 :
            if (VarType(v) = varOLEStr) and (v = '') then
               Result := False;
          3    :
            if (VarType(v) = varDouble) and (v = 0) then
               Result := False;
          4    :
            if (VarType(v) = varInteger) and not (Integer(v) in [5, 6]) then
               Result := False;
          5    :
            if (VarType(v) = varOLEStr) {and (Copy(v, 1, 3) <> 'SIN') }then
               Result := True;

        end; {case}
        Break;
      end;
  end;
end;

function TfrmToolkitInterface.ValidateInterface(const ADispatch : IDispatch;
                                                const AName : WideString) : Boolean;
var
  i : integer;
  v : variant;
begin
  Result := True;

  for i := 1 to IntFValidCount do
    if UpperCase(AName) = IntFValidation[i, shName] then
      begin
        v := GetProperty(ADispatch, IntFValidation[i, shTest]);

        Case i of
          1, 2, 4, 5, 6, 7, 8 :
            if (VarType(v) = varOLEStr) and (v = '') then
               Result := False;
{          3    :
            if (VarType(v) = varDouble) and (v = 0) then
               Result := False;  }
          3    :
            if (VarType(v) = varInteger) And (V = 0) then
               Result := False;

        end; {case}
        Break;
      end;

end;





function TfrmToolkitInterface.AvailableInClone(const AName : WideString) : Boolean;
var
  i : integer;
begin
  Result := True;
  for i := 1 to NACloneCount do
  begin
    if UpperCase(AName) = NotAvailInClone[i] then
      Result := False;
  end;

end;

function TfrmToolkitInterface.GetCharIndex(const AName : string; i : integer) : WideString;
Const
  DocNos : Array [1..44] Of String[3] =
           ('ACQ', 'ADC', 'ADJ', 'API', 'EPC', 'EPI', 'EPO', 'ESC', 'ESI', 'ESO',
            'FOL', 'JBF', 'JRN', 'NOM', {'PAY', }'PBT', 'PCR', 'PDN', 'PIN', 'PJC',
            'PJI', 'POR', 'PPI', 'PPY', 'PQU', 'PRF', 'PRN', 'RUN', 'SBT', 'SCR',
            'SDG', 'SDN', 'SIN', 'SJC', 'SJI', 'SKF', {'SOA',} 'SOR', 'SQU', 'SRC',
            'SRF', 'SRI', 'SRN', 'TSH', 'WIN', 'WOR');

  VatCodes  = 'SEZ123456789TXBCFGRWY';

  SalesBands = 'ABCDEFGH';

var
  s : string;

begin
 Try
  Result := Inherited GetCharIndex(AName, i);
  s := UpperCase(AName);
  if s = 'SSDOCUMENTNUMBERS' then
  begin
   if i > 0 then
    Result := DocNos[i];
  end
  else if (s = 'THVATANALYSIS') or (s = 'SSVATRATES') or
          (s = 'THGOODSANALYSIS') then
  begin
    if i > 0 then
      Result := VatCodes[i];
  end
  else if (s = 'STSALESBANDS') or (s = 'SLSALESBANDS') then
  begin
    if i > 0 then
      Result := SalesBands[i];
  end;
 Except
  on E: ERangeError do;
 End;

end;

function TfrmToolkitInterface.GetMinIndex(Name : string; FuncDesc : PFuncDesc;
                                    var IsChar : Byte) : word;
var
  i : integer;
  s : string;
begin
  s := UpperCase(Name);
  Result := 0;

  for i := 1 to IntArrayCount do
    if s = IntArrays[i] then
      Result := Boundaries[i, ArrayMin];

  for i := 7 to SpecArrayCount do
    if S = SpecialArrays[i] then
       Result := 1;
end;




//--------------------------------------------------------------------------//

procedure SetBrowserHandle(AHandle : HWnd);
//Called if the form is part of a dll so that it belongs to the calling app
begin
  OldHandle := Application.Handle;
  Application.Handle := AHandle;
  HandleSet := True;
end;


procedure TfrmInterface.Generatehelpfile1Click(Sender: TObject);
begin
  CancelHelp.Visible := True;
  FHelpGen.InitialiseRTF;
  GenerateHelpFile(Self);
  CancelHelp.Visible := False;
end;

procedure TfrmInterface.GenerateHelpfile(Sender : TObject);
begin
  if SaveDialog2.Execute then
  begin
    FGenerateHelp := True;
    UpdateDetails(True);
    FGenerateHelp := False;
    FHelpGen.SaveRTF(SaveDialog2.Filename);
  end;
end;

procedure TfrmInterface.AddToRtf(const PropertyName, RefName, TypeStr, ParentStr, doc : string;
                                 Params : TStringList; ik : TInvokeKind);
var
  RefString : string;
  Prefix : string;
  i : integer;
  IsFunction : Boolean;
begin
  IsFunction := (Pos('Function', TypeStr) = 1);
{  if FGenerateHelp then}
  begin
    if IsFunction  then
      Prefix := 'Method'
    else
      Prefix := 'Property';

    if FHelpGen.IsCommon(PropertyName) then
      RefString := Prefix + '_' + 'Common' + '_' + PropertyName
    else
      RefString := Prefix + '_' + ParentStr + '_' + PropertyName;
    FHelpGen.AddToTopicList(PropertyName, RefString, TypeStr, doc);
    if IsFunction then
      FHelpGen.AddToFunctionList(PropertyName, RefString, ParentStr)
    else
      FHelpGen.AddContentsMember(PropertyName, RefString, ParentStr, Byte(ik));
    if Params.Count > 0 then
    begin
      for i := 0 to Params.Count - 1 do
        FHelpGen.AddToParamList(RefString + ',' + Params[i]);
      if Not IsFunction then
        FHelpGen.AddToArrayList(PropertyName);
    end;
  end;

end;


procedure TfrmInterface.LoadTypeLibrary(Flib : ITypeLib);
var
  LibAttr: PTLibAttr;
  TypeInfo: ITypeInfo;
  TypeLibIndex: Integer;
  AName: WideString;
  ADocString: WideString;
  AHelpContext: LongInt;
  AHelpFile: WideString;
  TypeAttr: PTypeAttr;
  RootNode: TTreeNode;
  c : integer;
begin
      c := FLib.GetTypeInfoCount - 1;
      for TypeLibIndex := 0 to c do
      begin
        FLib.GetTypeInfo(TypeLibIndex, TypeInfo);
        OleCheck(TypeInfo.GetTypeAttr(TypeAttr));
        try
          case TypeAttr.typeKind of
            TKIND_ENUM:
              LoadEnum(TypeInfo, TypeAttr);

          end;
        finally
          TypeInfo.ReleaseTypeAttr(TypeAttr);
        end;
      end;

end;


procedure TfrmInterface.LoadEnum(TypeInfo: ITypeInfo; TypeAttr: PTypeAttr);
var
  TypeLibNode: TTreeNode;
  AName, EnumName: WideString;
  ADocString: WideString;
  AHelpContext: LongInt;
  ValuesNode: TTreeNode;
  ValueNode: TTreeNode;
  ValueIndex: Integer;
  VarDesc: PVarDesc;
begin
  TypeInfo.GetDocumentation(-1, @EnumName, @ADocString, @AHelpContext,
    nil);

  for ValueIndex := 0 to TypeAttr.cVars - 1 do
  begin
    TypeInfo.GetVarDesc(ValueIndex, VarDesc);
    try
      TypeInfo.GetDocumentation(VarDesc.memid, @AName, @ADocString,
        @AHelpContext, nil);
      FHelpGen.AddEnum(EnumName + ',' + AName + ',' + IntToHex(VarDesc^.lpvarValue^, 4) + 'h');
{      ValueNode := treeTI.Items.AddChild(ValuesNode, AName);
      if ADocString <> '' then
        treeTI.Items.AddChild(ValueNode, 'Help string: ' +
          ADocString);
      if AHelpContext <> 0 then
        treeTI.Items.AddChild(ValueNode, 'Help context: ' +
          IntToStr(AHelpContext));}
    finally
      TypeInfo.ReleaseVarDesc(VarDesc);
    end;
  end;
end;

function TfrmInterface.GetUserDefType(TI : ITypeInfo; UD : HRefType) : string;
var
  Info : ITypeInfo;
  AName : WideString;
begin
  Result := '';

  if UD > 50000000 then
  begin
    TI.GetRefTypeInfo(UD, Info);
    Try
      if Info <> nil then
      begin
        Info.GetDocumentation(-1, @AName, nil, nil, nil);
        Result := AName;
      end;
    Finally
      Info := nil;
    End;
  end;
end;




procedure TfrmInterface.CancelHelpClick(Sender: TObject);
begin
  FHelpGen.Cancel;
end;

procedure TfrmInterface.Debug1Click(Sender: TObject);
begin
  Debug1.Checked := not Debug1.Checked;
  Debug := Debug1.Checked;
end;

procedure TfrmInterface.SaveState;
var
  i : integer;
begin
  if Assigned(TheTree) then
  with TheTree do
  begin
    SaveStateList.Clear;
    for i := 0 to StateList.Count - 1 do
      SaveStateList.Add(StateList.Items[i]);
  end;
end;

procedure TfrmInterface.RestoreStateList;
var
  i : integer;
begin
  if Assigned(TheTree) then
  with TheTree do
  begin
    StateList.Clear;
    for i := 0 to SaveStateList.Count - 1 do
      StateList.Add(SaveStateList.Items[i]);
  end;
end;

function TfrmInterface.RootType : string;
var
  i : integer;
  s : string;
begin
  Result := '';
  i := Pos('-', Caption);
  if i > 0 then
    Result := Copy(Caption, 1, i - 2);
end;

procedure TfrmInterface.ShowFunctionMenu(const p : Pointer; x, y : integer);
var
  pt : TPoint;
begin
  FSearchKey := '';
  FFunctionInterface := p;
  pt := ClientToScreen(Point(X, Y));
  PopupMenu1.Popup(Pt.x, pt.y);
end;

procedure TfrmInterface.InvokeFunction(const Intf : Pointer; const ID : WideString);
var
  Res : integer;
  TypeInfo : ITypeInfo;
  Params : TDispParams;
  Flags : word;
  ArgError : integer;
  s : WideString;
  ExcepInfo : TExcepInfo;
  Res1 : HResult;
  P : PVariant;
  V : Variant;

  Dispatch : IDispatch;

  Names: POleStrlist;
  id1 : PMemberIDList;
begin
  if Assigned(IntF) then
  begin
    FLastFunctionResult := '';
    New(Names);
    New(Id1);
    TypeInfo := nil;

    Try

      Names[0] := POleStr(ID);

      Try
       Res := IDispatch(Intf).GetTypeInfo(0,0,TypeInfo);
      Except
       Res := -1;
      End;

      if (Res = 0) and Assigned(TypeInfo) then
      begin
        Res1 := TypeInfo.GetIDsOfNames(Names, 1, id1);

        if Res1 = 0 then
        begin

           Try
            FillChar(Params, SizeOf(Params), #0);
            with Params do
            begin
              rgvarg:= nil;
              rgdispidNamedArgs:= nil;
              cArgs:= 0;
              cNamedArgs:= 0;
            end;

            ArgError := 0;
            P := @V;

            FillChar(ExcepInfo, SizeOf(ExcepInfo), #0);
            Flags := DISPATCH_METHOD;

            if FSearchKey <> '' then
            begin
              Args[0].vt := VT_BSTR;
              Args[0].bstrVal := PWideChar(FSearchKey);
              Params.rgvarg := @Args;
              Params.cArgs := 1;
           end;

            {$IFDEF WantExe}
            Dispatch := IDispatch(Intf);
            Res := Dispatch.Invoke(Id1[0], IID_NULL, LOCALE_USER_DEFAULT, Flags, Params, P, @ExcepInfo, @ArgError);
            {$ELSE}
            Res1 := TypeInfo.Invoke(Intf, Id1[0], Flags, Params, P, @ExcepInfo,
                                @ArgError);
            {$ENDIF}

            if Res1 = 0 then
            begin
              if not FTestMode then
                UpdateDetails(False);
              FLastFunctionResult := GetValueString(V, '');
            end
            else
              FLastFunctionResult := ResultCode(Res1);
           Except
           End;

       end
       else
         FLastFunctionResult := ID + ' not available';

      end
      else
        FLastFunctionResult := 'Unable to get type info';
    Finally
      Dispose(Names);
      Dispose(id1);
      TypeInfo := nil;
      StatusBar1.SimpleText := 'Result : ' + FLastFunctionResult;

    End;
  end
  else
    FLastFunctionResult := 'Nil interface passed';

end;




procedure TfrmInterface.GetFirst1Click(Sender: TObject);
begin
  InvokeFunction(FFunctionInterface, 'GetFirst');
  FFunctionInterface := Pointer(FDispatch);
end;

procedure TfrmInterface.GetPrevious1Click(Sender: TObject);
begin
  InvokeFunction(FFunctionInterface, 'GetPrevious');
  FFunctionInterface := Pointer(FDispatch);
end;

procedure TfrmInterface.GetNext1Click(Sender: TObject);
begin
  InvokeFunction(FFunctionInterface, 'GetNext');
  FFunctionInterface := Pointer(FDispatch);
end;

procedure TfrmInterface.GetLast1Click(Sender: TObject);
begin
  InvokeFunction(FFunctionInterface, 'GetLast');
  FFunctionInterface := Pointer(FDispatch);
end;

procedure TfrmInterface.TestInterfaces(FuncList : TStringList);
var
  i, j : longint;
  ThisCommand : WideString;
begin
  if (Assigned(FuncList)) then
  begin
   if Assigned(TheTree) then
    with TheTree do
    begin
      for i := 1 to ItemCount do
      begin
        if Assigned(Items[i]) then
          if (Items[i]^.TypeStr[1] = 'I')  and (Items[i]^.TypeStr <> 'Integer') then
            for j := 0 to FuncList.Count - 1 do
            begin
              ThisCommand := FuncList[j];
              FFunctionLog.Add(IntToStr(i) + ' ' + Items[i]^.Caption + ': performing ' + ThisCommand);
              InvokeFunction(InterfaceAddress(i), ThisCommand);
              FFunctionLog.Add('Result: ' + FLastFunctionResult);
            end; {for j}
      end; {for i}
    end; {with thetree}
  end; {if assigned(funclist)}
end;



procedure TfrmInterface.Test1Click(Sender: TObject);
var
  T : TStringList;
begin
  Screen.cursor := crHourGlass;
  FTestMode := True;
  T := TStringList.Create;
  Try
    T.Add('GetFirst');
{    T.Add('GetNext');
    T.Add('GetLast');
    T.Add('GetPrevious');}
   Try
    TestInterfaces(T);
    ShowMessage('Test Finished');
   Except
   End;
  Finally
    FFunctionLog.SaveToFile('testlog.txt');
    T.Free;
    Screen.Cursor := crDefault;
    FTestMode := False;
  End;
end;

procedure TfrmInterface.Delay(const i : longint);
var
  j, k : longint;
begin
{  j := GetTickCount;
  while (GetTickCount) < j + i do
    Application.ProcessMessages;}
end;

procedure TfrmInterface.Find1Click(Sender: TObject);
begin
  frmIntFind := TfrmIntFind.Create(Self);
  with frmIntFind do
  begin
    Try
      cbOp.ItemIndex := 0;
      frmIntFind.Width := 362;
      frmIntFind.Height := 139;
      if Self.Left + Self.Width < Screen.Width then
       if Self.FormStyle = fsStayOnTop then
       begin
        frmIntFind.Left := Self.Left + Self.Width;
        frmIntFind.Top := (Screen.Height div 2) - (frmIntFind.Height div 2);
       end
       else
         frmIntFind.Position := poScreenCenter;
      ShowModal;
      if ModalResult = mrOK then
      begin
        FSearchKey := WideString(UpperCase(Edit1.Text));
        InvokeFunction(FFunctionInterface, WideString(cbOp.Items[cbOp.ItemIndex]));
      end;
    Finally
      Free;
      FFunctionInterface := Pointer(FDispatch);
    End;
  end;
end;

procedure TfrmInterface.FormActivate(Sender: TObject);
begin
  if FirstTime then
  begin
    Firsttime := False;
    FRecurse := True;
    UpdateDetails(True);
  end;

end;

function TfrmInterface.GetProperty(const ADispatch : IDispatch;
                                   const AName : WideString) : OLEVariant;
var
  Res : integer;
  TypeInfo : ITypeInfo;
  Params : TDispParams;
  Flags : word;
  ArgError : integer;
  s : WideString;
  ExcepInfo : TExcepInfo;
  Res1 : HResult;
  P : PVariant;
  V : Variant;

  Names: POleStrlist;
  id1 : PMemberIDList;

  ID : WideString;
  i : integer;

begin
  if Assigned(ADispatch) then
  begin
    Result := 0;
    New(Names);
    New(Id1);
    TypeInfo := nil;

    Try

      Names[0] := POleStr(AName);

      Try
       Res := ADispatch.GetTypeInfo(0,0,TypeInfo);
      Except
       Res := -1;
      End;

      if (Res = 0) and Assigned(TypeInfo) then
      begin
        Res1 := TypeInfo.GetIDsOfNames(Names, 1, id1);

        if Res1 = 0 then
        begin
           v := GetIValue(TypeInfo, id1[0], ADispatch, -1, '', NoParams, INVOKE_PROPERTYGET);
           Result := V;
        end
        else
         FLastFunctionResult := ID + ' not available';

      end
      else
        FLastFunctionResult := 'Unable to get type info';
    Finally
      Dispose(Names);
      Dispose(id1);
      TypeInfo := nil;
      StatusBar1.SimpleText := 'Result : ' + FLastFunctionResult;

    End;
  end
  else
    FLastFunctionResult := 'Nil interface passed';

end;

function TfrmInterface.PropertyTypeString(const FuncDesc : PFuncDesc;
                                          const TypeInfo : ITypeInfo) : string;
begin
   if FuncDesc.elemdescFunc.tdesc.vt <> VT_PTR then
     Result := GetUserDefType(TypeInfo,
             FuncDesc.elemdescFunc.tdesc.hreftype)
   else
   if FuncDesc.elemdescFunc.tdesc.vt = VT_PTR then
     Result := GetUserDefType(TypeInfo,
             FuncDesc.elemdescFunc.tdesc.ptdesc.hreftype);

end;

procedure TfrmInterface.ShowHelpMsg(const Msg : string);
begin
 {if FormStyle <> fsStayOnTop then
   ShowMessage(Msg);}
end;



procedure TfrmInterface.lvFuncsInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
begin
  if Assigned(Item) and Assigned(TheTree) then
    InfoTip := TheTree.ItemDoc(Item);
end;

procedure TfrmInterface.SaveLog(const sFilename: string);
begin
  Log.SaveToFile(sFilename);
end;

Initialization
  HandleSet := False;
  Debug := False;

end.
