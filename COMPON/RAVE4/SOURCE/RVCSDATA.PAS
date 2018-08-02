{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVCsData;

interface

uses
  {$IFDEF Linux}
  QControls, QGraphics, QDialogs, QButtons, QStdCtrls, QForms,
  {$ELSE}
  Messages, Windows, Controls, Graphics, Dialogs,
  Buttons, StdCtrls, Forms,
  {$ENDIF}
  Classes, SysUtils, RVDefine, RVUtil, RVClass, RVCsStd, TypInfo,
  RVData, RPDefine, RPBase, RVProj, RVCsRpt, RVDataField;

type
  TRaveDataText = class(TRaveText)
  protected
    FDataField: TRaveFieldName;
    FDataView: TRaveBaseDataView;
    FLookupDataView: TRaveBaseDataView;
    FLookupField: TRaveFieldName;
    FLookupDisplay: TRaveFieldName;
    FLookupInvalid: string;
    procedure SetText(Value: string); override;
    function GetText: string; override;
    procedure SetDataField(Value: TRaveFieldName);
    procedure SetLookupDataView(Value: TRaveBaseDataView);
    procedure SetLookupField(Value: TRaveFieldName);
    procedure SetLookupDisplay(Value: TRaveFieldName);
    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Truncate default true;
    property DataField: TRaveFieldName read FDataField write SetDataField;
    property DataView: TRaveBaseDataView read FDataView write FDataView;
    property LookupDataView: TRaveBaseDataView read FLookupDataView
     write SetLookupDataView default nil;
    property LookupField: TRaveFieldName read FLookupField write SetLookupField;
    property LookupDisplay: TRaveFieldName read FLookupDisplay write SetLookupDisplay;
    property LookupInvalid: string read FLookupInvalid write FLookupInvalid;
  end; { TRaveDataText }

  TRaveDataMemo = class(TRaveMemo)
  protected
    FDataField: TRaveFieldName;
    FDataView: TRaveBaseDataView;

    function GetText: string; override;
    procedure SetDataField(Value: TRaveFieldName);
    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
  public
  published
    property ContainsRTF;
    property DataField: TRaveFieldName read FDataField write SetDataField;
    property DataView: TRaveBaseDataView read FDataView write FDataView;
  end; { TRaveDataMemo }

  TRaveDisplayType = (dtNumericFormat,dtDateTimeFormat);

  TRaveCalcFunction = (cfNone,cfTrunc,cfFrac,cfRound,cfNeg,cfAbs,cfSin,cfCos,cfArcTan,
   cfSqr,cfSqrt,cfInc,cfDec,cfRandom,cfRound1,cfRound2,cfRound3,cfRound4,cfRound5,
   cfSecsToTime,cfMinsToTime,cfHoursToTime,cfTimeToSecs,cfTimeToMins,cfTimeToHours,cfPercent);

  TRaveCalcOperator = (coAdd,coSub,coMul,coDiv,coMod,coExp,coGreater,coLesser,coAverage);

  TRaveCalcText = class(TRaveText)
  protected
    Count: integer;
    Total: extended;

    FController: TRaveComponent;
    FInitializer: TRaveComponent;
    FDataView: TRaveBaseDataView;
    FDataField: TRaveFieldName;
    FCalcType: TRaveCalcType;
    FRunningTotal: boolean;
    FDisplayFormat: string;
    FDisplayType: TRaveDisplayType;
    FCountBlanks: boolean;
    FCountNulls: boolean;
    FCountValue: string;

    procedure BeforeReport; override;
    procedure SetText(Value: string); override;
    function GetText: string; override;
    function GetValue: extended;
    procedure SetDataField(Value: TRaveFieldName);
    procedure SetController(Value: TRaveComponent);
    procedure SetInitializer(Value: TRaveComponent);
    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
    procedure CalcNewDataListen(Speaker: TRaveComponent;
                                Msg: TObject);
    procedure CalcInitDataListen(Speaker: TRaveComponent;
                                 Msg: TObject);
    procedure OverrideProperties(Filer: TRaveFiler); override;
    procedure ReadControllerBand(Reader: TRaveReader);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Print(Report: TBaseReport); override;

    property Value: extended read GetValue;
  published
    property CalcType: TRaveCalcType read FCalcType write FCalcType default ctSum;
    property Controller: TRaveComponent read FController write
     SetController default nil;
    property CountBlanks: boolean read FCountBlanks write FCountBlanks default true;
    property CountNulls: boolean read FCountNulls write FCountNulls default false;
    property CountValue: string read FCountValue write FCountValue;
    property DataView: TRaveBaseDataView read FDataView write FDataView default nil;
    property DataField: TRaveFieldName read FDataField write SetDataField;
    property DisplayFormat: string read FDisplayFormat write FDisplayFormat;
    property DisplayType: TRaveDisplayType read FDisplayType write FDisplayType
     default dtNumericFormat;
    property Initializer: TRaveComponent read FInitializer write
     SetInitializer default nil;
    property RunningTotal: boolean read FRunningTotal write FRunningTotal
     default false;
  end; { TRaveCalcText }

  TRaveCalcVariable = class(TRaveComponent)
  protected
    FDestParam: string;
    FDestPIVar: string;
    FDisplayFormat: string;
    FDisplayType: TRaveDisplayType;

    function GetValue: extended; virtual; abstract;
    function GetIsNull: boolean; virtual;
  public
    procedure Print(Report: TBaseReport); override;

    property Value: extended read GetValue;
    property IsNull: boolean read GetIsNull;
    property DestParam: string read FDestParam write FDestParam;
    property DestPIVar: string read FDestPIVar write FDestPIVar;
    property DisplayFormat: string read FDisplayFormat write FDisplayFormat;
    property DisplayType: TRaveDisplayType read FDisplayType write FDisplayType
     default dtNumericFormat;
  end; { TRaveCalcVariable }

  TRaveCalcOp = class(TRaveCalcVariable)
  protected
    FSrc1CalcVar: TRaveCalcVariable;
    FSrc1DataField: TRaveFieldName;
    FSrc1DataView: TRaveBaseDataView;
    FSrc1Value: extended;
    FSrc1Function: TRaveCalcFunction;
    FSrc2CalcVar: TRaveCalcVariable;
    FSrc2DataField: TRaveFieldName;
    FSrc2DataView: TRaveBaseDataView;
    FSrc2Value: extended;
    FSrc2Function: TRaveCalcFunction;
    FOperator: TRaveCalcOperator;
    FResultFunction: TRaveCalcFunction;

    function GetIsNull: boolean; override;
    function GetValue: extended; override;
    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DestParam;
    property DestPIVar;
    property DisplayFormat;
    property DisplayType;
    property Operator: TRaveCalcOperator read FOperator write FOperator
     default coAdd;
    property ResultFunction: TRaveCalcFunction read FResultFunction write
     FResultFunction default cfNone;
    property Src1CalcVar: TRaveCalcVariable read FSrc1CalcVar write FSrc1CalcVar default nil;
    property Src1DataField: TRaveFieldName read FSrc1DataField write FSrc1DataField;
    property Src1DataView: TRaveBaseDataView read FSrc1DataView write FSrc1DataView default nil;
    property Src1Value: extended read FSrc1Value write FSrc1Value;
    property Src1Function: TRaveCalcFunction read FSrc1Function
     write FSrc1Function default cfNone;
    property Src2CalcVar: TRaveCalcVariable read FSrc2CalcVar write FSrc2CalcVar default nil;
    property Src2DataField: TRaveFieldName read FSrc2DataField write FSrc2DataField;
    property Src2DataView: TRaveBaseDataView read FSrc2DataView write FSrc2DataView default nil;
    property Src2Value: extended read FSrc2Value write FSrc2Value;
    property Src2Function: TRaveCalcFunction read FSrc2Function
     write FSrc2Function default cfNone;
  end; { TRaveCalcOp }

  TRaveCalcTotal = class(TRaveCalcVariable)
  protected
    Count: integer;
    Total: extended;

    FCalcVar: TRaveCalcVariable;
    FDataView: TRaveBaseDataView;
    FDataField: TRaveFieldName;
    FController: TRaveComponent;
    FInitializer: TRaveComponent;
    FCalcType: TRaveCalcType;
    FCountBlanks: boolean;
    FCountNulls: boolean;
    FCountValue: string;
    FRunningTotal: boolean;

    procedure BeforeReport; override;
    procedure SetController(Value: TRaveComponent);
    procedure SetInitializer(Value: TRaveComponent);
    function GetValue: extended; override;
    procedure CalcNewDataListen(Speaker: TRaveComponent;
                                Msg: TObject);
    procedure CalcInitDataListen(Speaker: TRaveComponent;
                                 Msg: TObject);
    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Print(Report: TBaseReport); override;
  published
    property CalcType: TRaveCalcType read FCalcType write FCalcType default ctSum;
    property CalcVar: TRaveCalcVariable read FCalcVar write FCalcVar default nil;
    property Controller: TRaveComponent read FController write SetController default nil;
    property CountBlanks: boolean read FCountBlanks write FCountBlanks default true;
    property CountNulls: boolean read FCountNulls write FCountNulls default false;
    property CountValue: string read FCountValue write FCountValue;
    property DataView: TRaveBaseDataView read FDataView write FDataView default nil;
    property DataField: TRaveFieldName read FDataField write FDataField;
    property DestParam;
    property DestPIVar;
    property DisplayFormat;
    property DisplayType;
    property Initializer: TRaveComponent read FInitializer write SetInitializer default nil;
    property RunningTotal: boolean read FRunningTotal write FRunningTotal default false;
  end; { TRaveCalcTotal }

  TRaveCalcController = class(TRaveComponent)
  protected
    CalcNewDataListenList: TRaveMethodList;
    CalcInitDataListenList: TRaveMethodList;
    FInitCalcVar: TRaveCalcVariable;
    FInitDataField: TRaveFieldName;
    FInitValue: extended;

    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddListener(Conversation: string;
                          ListenMethod: TRaveListenEvent); override;
    procedure RemoveListener(Conversation: string;
                             ListenMethod: TRaveListenEvent); override;
    function Habla(Conversation: string): boolean; override;
    procedure Print(Report: TBaseReport); override;
  published
    property InitCalcVar: TRaveCalcVariable read FInitCalcVar write FInitCalcVar;
    property InitDataField: TRaveFieldName read FInitDataField write FInitDataField;
    property InitValue: extended read FInitValue write FInitValue;
  end; { TRaveCalcController }

  TRaveDataMirror = class(TPersistent)
  protected
    FDataValue: string;
    FSectionMirror: TRaveSection;
    FIsDefault: boolean;
  published
    property DataValue: string read FDataValue write FDataValue;
    property IsDefault: boolean read FIsDefault write FIsDefault default false;
    property SectionMirror: TRaveSection read FSectionMirror write FSectionMirror
     default nil;
  end; { TRaveDataMirror }

  TRaveDataMirrorSection = class(TRaveSection)
  protected
    Initialized: boolean;
    DirectReference: boolean;
    FDataField: TRaveFieldName;
    FDataView: TRaveBaseDataView;
    FDataMirrors: TRavePersistentList;
    FCompareCase: boolean;
    FSaveMirror: TRaveControl;

  { State saving variables }
    FSaveAnchor: TRaveAnchor;
    FSaveCompareCase: boolean;
    FSaveDataField: TRaveFieldName;
    FSaveDataMirrors: TRavePersistentList;
    FSaveDataView: TRaveBaseDataView;
    FSaveDisplayOn: TDisplayOn;
    FSaveTag: longint;

    procedure SetDataMirrors(Value: TRavePersistentList);
    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
    procedure InitData; override;
    procedure DoneData; override;
    procedure SaveDesigned; override;
    procedure RestoreDesigned; override;
    procedure RestoreAdjusted; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PrintAll(Report: TBaseReport); override;
  {$IFDEF DESIGNER}
    procedure Paint(Canvas: TCanvas); override;
  {$ENDIF}
  published
    property CompareCase: boolean read FCompareCase write FCompareCase default false;
    property DataField: TRaveFieldName read FDataField write FDataField;
    property DataView: TRaveBaseDataView read FDataView write FDataView;
    property DataMirrors: TRavePersistentList read FDataMirrors write SetDataMirrors;
  end; { TRaveDataMirrorSection }

  function CalcFunction(Value: extended;
                        Func: TRaveCalcFunction): extended;
  function CalcVariable(    Self: TRaveComponent;
                            CalcVar: TRaveCalcVariable;
                            DataView: TRaveBaseDataView;
                            DataField: TRaveFieldName;
                            Value: extended;
                            Func: TRaveCalcFunction;
                        var DoCount: boolean): extended;
  procedure RaveRegister;

implementation

{$IFDEF DESIGNER}
{$R *.RES}
{$ENDIF}

function CreateDataTextControl(AOwner: TComponent;
                               DataField: TRaveDataField): TRaveControl; far;

begin { CreateDataTextControl }
  Result := TRaveDataText.Create(AOwner);
  TRaveDataText(Result).DataView := TRaveBaseDataView(DataField.Parent);
  TRaveDataText(Result).DataField := DataField.FieldName;
end;  { CreateDataTextControl }

function CreateDataMemoControl(AOwner: TComponent;
                               DataField: TRaveDataField): TRaveControl; far;

begin { CreateDataTextControl }
  Result := TRaveDataMemo.Create(AOwner);
  TRaveDataMemo(Result).DataView := TRaveBaseDataView(DataField.Parent);
  TRaveDataMemo(Result).DataField := DataField.FieldName;
end;  { CreateDataTextControl }

procedure RaveRegister;

begin { RaveRegister }
{TransOff}
  CreateDataTextControlProc := CreateDataTextControl;
  CreateDataMemoControlProc := CreateDataMemoControl;
  RegisterRaveGroup('Report',Trans('Report'));
  RegisterRaveComponents('Report',[TRaveDataText,TRaveDataMemo,TRaveCalcText,
   TRaveDataMirrorSection,TRaveRegion,TRaveBand,TRaveDataBand,TRaveDataCycle,
   TRaveCalcOp,TRaveCalcTotal,TRaveCalcController]);
  RegisterRaveModuleClasses('RVCsData',[TRaveDataText,TRaveDataMemo,
   TRaveCalcText,TRaveDataMirrorSection,TRaveCalcOp,TRaveCalcTotal,
   TRaveCalcController]);
  RegisterRaveModuleClasses('RVCsRpt',[TRaveRegion,TRaveBand,TRaveDataBand,
   TRaveDataCycle]);

{$IFDEF DESIGNER}
  RegisterRaveProperties(TRaveDataText,
   {Beginner}     'DataField;DataView',
   {Intermediate} 'LookupDataView;LookupField;LookupDisplay',
   {Developer}    '',
   {Hidden}       'Text');

  RegisterRaveProperties(TRaveDataMemo,
   {Beginner}     'DataField;DataView',
   {Intermediate} 'ContainsRTF',
   {Developer}    '',
   {Hidden}       'Text');

  RegisterRaveProperties(TRaveCalcText,
   {Beginner}     'CalcType;Controller;DataView;DataField;DisplayFormat',
   {Intermediate} 'CountBlanks;CountValue;DisplayType;Initializer;RunningTotal',
   {Developer}    '',
   {Hidden}       'Text');

  RegisterRaveProperties(TRaveCalcVariable,
   {Beginner}     'DestParam;DisplayFormat',
   {Intermediate} 'DisplayType;DestPIVar',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveCalcOp,
   {Beginner}     'Operator;Src1CalcVar;Src1DataField;Src1DataView;Src1Value;' +
                  'Src2CalcVar;Src2DataField;Src2DataView;Src2Value;',
   {Intermediate} 'Src1Function;Src2Function',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveCalcTotal,
   {Beginner}     'CalcType;Controller;DataView;DataField;DisplayFormat',
   {Intermediate} 'CountBlanks;CountValue;Initializer;RunningTotal',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveCalcController,
   {Beginner}     'InitValue',
   {Intermediate} 'InitCalcVar;InitDataField',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveDataMirrorSection,
   {Beginner}     'DataField;DataView;DataMirrors',
   {Intermediate} 'CompareCase',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveRegion,
   {Beginner}     'Height;Left;Top;Width',
   {Intermediate} 'Columns;ColumnSpacing',
   {Developer}    '',
   {Hidden}       'DisplayOn;Mirror');

  RegisterRaveProperties(TRaveBand,
   {Beginner}     'BandStyle;ControllerBand;Height',
   {Intermediate} 'AllowSplit;GroupDataView;GroupKey',
   {Developer}    '',
   {Hidden}       'Anchor;DisplayOn;Mirror');

  RegisterRaveProperties(TRaveIterateBand,
   {Beginner}     '',
   {Intermediate} 'KeepBodyTogether;KeepRowTogether;OrphanRows;WidowRows',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveDataBand,
   {Beginner}     'DataView',
   {Intermediate} 'DetailKey;MasterDataView,MasterKey;SortKey',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveDataCycle,
   {Beginner}     'DataView',
   {Intermediate} 'DetailKey;MasterDataView,MasterKey;SortKey',
   {Developer}    '',
   {Hidden}       '');

  SetPropDesc(TRaveDataText,'Truncate',Trans('Determines whether the text is ' +
   'truncated or printed completely, regardless of the designed width. If a ' +
   'report variable such as Report.TotalPages is being printed, Truncate should ' +
   'be set to false to prevent the report variable token from being truncated.'));
  SetPropDesc(TRaveDataText,'DataField',Trans('Defines the data field to print. ' +
   'Using the Data Text Editor, any combination of data fields, report variables, ' +
   'project parameters or string constants (delimited by " or '' quotes) can be ' +
   'defined.'));
  SetPropDesc(TRaveDataText,'DataView',Trans('Defines the default dataview that ' +
   'will be used for the DataField property.'));
  SetPropDesc(TRaveDataText,'LookupDataView',Trans('Defines the default dataview that ' +
   'will be used for the LookupField and LookupDisplay properties.'));
  SetPropDesc(TRaveDataText,'LookupField',Trans('Defines the data field that will ' +
   'searched for a match of the current contents of the DataField property.'));
  SetPropDesc(TRaveDataText,'LookupDisplay',Trans('Defines the data field that will ' +
   'printed when a lookup match is found.  This can contain other data text items ' +
   'similar to the DataField property.'));
  SetPropDesc(TRaveDataText,'LookupInvalid',Trans('Defines the text that will be ' +
   'printed if a lookup match is not found.'));

  SetPropDesc(TRaveDataMemo,'ContainsRTF',Trans('Defines whether the memo text ' +
   'contains Rich Text Formatting (RTF) or not.'));
  SetPropDesc(TRaveDataMemo,'DataField',Trans('Defines the data field to print. ' +
   'Using the Data Text Editor, any combination of data fields, report variables, ' +
   'project parameters or string constants (delimited by " or '' quotes) can be ' +
   'defined.'));
  SetPropDesc(TRaveDataMemo,'DataView',Trans('Defines the default dataview that ' +
   'will be used for the DataField property.'));

  SetPropDesc(TRaveCalcText,'CalcType',Trans('Defines the type of summation ' +
   'calculation that will be performed.'));
  SetPropDesc(TRaveCalcText,'Controller',Trans('Defines the controller component ' +
   'that will execute the calculation when the controller is printed.  Normally ' +
   'the controller is tied to a particular dataview and will signal when new data ' +
   'is available.'));
  SetPropDesc(TRaveCalcText,'CountBlanks',Trans('Determines whether or not blank ' +
   '(zero) values are included in the ctCount and ctAverage calculation types.'));
  SetPropDesc(TRaveCalcText,'CountNulls',Trans('Determines whether or not null ' +
   '(empty) values are included in the ctCount and ctAverage calculation types.'));
  SetPropDesc(TRaveCalcText,'CountValue',Trans('Defines the field value ' +
   'that will cause a count to occur if there is a match for CalcType = ctCount.'));
  SetPropDesc(TRaveCalcText,'DataView',Trans('Defines the default dataview that ' +
   'will be used for the DataField property.'));
  SetPropDesc(TRaveCalcText,'DataField',Trans('Defines the data field or project ' +
   'parameter that will be used in the calculation.'));
  SetPropDesc(TRaveCalcText,'DisplayFormat',Trans('Defines the format codes ' +
   'that will be used to create a string representation of the calculated data.  See ' +
   'Appendix F in the Rave documentation for more details on formatting codes.'));
  SetPropDesc(TRaveCalcText,'DisplayType',Trans('Defines whether the contents ' +
   'represent numeric or date/time information.  The DisplayFormat property ' +
   'will be processed as either numeric or date/time format codes depending ' +
   'upon this setting.'));
  SetPropDesc(TRaveCalcText,'Initializer',Trans('Defines the initializer component ' +
   'that will initialize the calculation when the initializer is printed.  Initializers ' +
   'are useful for setting a calculation to a specific value or initializing it ' +
   'at key points in a report.'));
  SetPropDesc(TRaveCalcText,'RunningTotal',Trans('Determines whether the calculated ' +
   'value is reinitialized when it is printed.  If RunningTotal is true, the value ' +
   'will not be reinitialized and further calculations will be added to the existing ' +
   'value.'));

  SetPropDesc(TRaveCalcVariable,'DestParam',Trans('Defines the project parameter ' +
   'that the calculation will be written to when it is printed.  This value can ' +
   'be blank if the calculation is only going to be used as an intermediate result ' +
   'for other calculation components.'));
  SetPropDesc(TRaveCalcVariable,'DestPIVar',Trans('Defines the PIVar ' +
   'that the calculation will be written to when it is printed.  This value can ' +
   'be blank if the calculation is only going to be used as an intermediate result ' +
   'for other calculation components.'));
  SetPropDesc(TRaveCalcVariable,'DisplayFormat',Trans('Defines the format codes ' +
   'that will be used to create a string representation of the calculated data.  See ' +
   'Appendix F in the Rave documentation for more details on formatting codes.'));
  SetPropDesc(TRaveCalcVariable,'DisplayType',Trans('Defines whether the contents ' +
   'represent numeric or date/time information.  The DisplayFormat property ' +
   'will be processed as either numeric or date/time format codes depending ' +
   'upon this setting.'));

  SetPropDesc(TRaveCalcOp,'Operator',Trans('Defines the type of operation that will be ' +
   'performed on the two source values.  The result of this calculation can be ' +
   'placed in a project parameter using the DestParam property or used in other ' +
   'calculations as a CalcVar component.'));
  SetPropDesc(TRaveCalcOp,'ResultFunction',Trans('Defines the function that will be ' +
   'applied to the result of the calculation after the operation has been performed.'));
  SetPropDesc(TRaveCalcOp,'Src1CalcVar',Trans('Defines a calculation component to ' +
   'use as the first source value for the calculation operation.  If this property ' +
   'is defined, Src1DataField and Src1Value will be ignored.'));
  SetPropDesc(TRaveCalcOp,'Src1DataField',Trans('If Src1CalcVar is blank, defines ' +
   'a data field to use as the first source value for the calculation operation.  ' +
   'If this property is defined, Src1Value will be ignored.'));
  SetPropDesc(TRaveCalcOp,'Src1DataView',Trans('Defines the default dataview that ' +
   'will be used for the Src1DataField property.'));
  SetPropDesc(TRaveCalcOp,'Src1Value',Trans('If Src1CalcVar and Src1DataField are ' +
   'blank, defines a constant value that will be used as the first source value ' +
   'for the calculation operation.'));
  SetPropDesc(TRaveCalcOp,'Src1Function',Trans('Defines the function that will be ' +
   'performed on the first source value before the calculation operation.'));
  SetPropDesc(TRaveCalcOp,'Src2CalcVar',Trans('Defines a calculation component to ' +
   'use as the first source value for the calculation operation.  If this property ' +
   'is defined, Src2DataField and Src2Value will be ignored.'));
  SetPropDesc(TRaveCalcOp,'Src2DataField',Trans('If Src2CalcVar is blank, defines ' +
   'a data field to use as the first source value for the calculation operation.  ' +
   'If this property is defined, Src2Value will be ignored.'));
  SetPropDesc(TRaveCalcOp,'Src2DataView',Trans('Defines the default dataview that ' +
   'will be used for the Src2DataField property.'));
  SetPropDesc(TRaveCalcOp,'Src2Value',Trans('If Src2CalcVar and Src2DataField are ' +
   'blank, defines a constant value that will be used as the first source value ' +
   'for the calculation operation.'));
  SetPropDesc(TRaveCalcOp,'Src2Function',Trans('Defines the function that will be ' +
   'performed on the first source value before the calculation operation.'));

  SetPropDesc(TRaveCalcTotal,'CalcType',Trans('Defines the type of summation ' +
   'calculation that will be performed.'));
  SetPropDesc(TRaveCalcTotal,'CalcVar',Trans('Defines a calculation component to ' +
   'use in the calculation.  If this property is defined, DataField will be ignored.'));
  SetPropDesc(TRaveCalcTotal,'Controller',Trans('Defines the controller component ' +
   'that will execute the calculation when the controller is printed.  Normally ' +
   'the controller is tied to a particular dataview and will signal when new data ' +
   'is available.'));
  SetPropDesc(TRaveCalcTotal,'CountBlanks',Trans('Determines whether or not blank ' +
   '(zero) values are included in the ctCount and ctAverage calculation types.'));
  SetPropDesc(TRaveCalcTotal,'CountNulls',Trans('Determines whether or not null ' +
   '(empty) values are included in the ctCount and ctAverage calculation types.'));
  SetPropDesc(TRaveCalcTotal,'CountValue',Trans('Defines the field value ' +
   'that will cause a count to occur if there is a match for CalcType = ctCount.'));
  SetPropDesc(TRaveCalcTotal,'DataView',Trans('Defines the default dataview that ' +
   'will be used for the DataField property.'));
  SetPropDesc(TRaveCalcTotal,'DataField',Trans('If CalcVar is blank, defines the ' +
   'data field or project parameter that will be used in the calculation.'));
  SetPropDesc(TRaveCalcTotal,'Initializer',Trans('Defines the initializer component ' +
   'that will initialize the calculation when the initializer is printed.  Initializers ' +
   'are useful for setting a calculation to a specific value or initializing it ' +
   'at key points in a report.'));
  SetPropDesc(TRaveCalcTotal,'RunningTotal',Trans('Determines whether the calculated ' +
   'value is reinitialized when it is printed.  If RunningTotal is true, the value ' +
   'will not be reinitialized and further calculations will be added to the existing ' +
   'value.'));

  SetPropDesc(TRaveCalcController,'InitCalcVar',Trans('When this component is acting ' +
   'as an initializer, defines the calculation component that will be used as ' +
   'the initializing value.  If this property is defined, InitDataField and ' +
   'InitValue will be ignored.'));
  SetPropDesc(TRaveCalcController,'InitDataField',Trans('If InitCalcVar is blank, ' +
   'defines the data field or project parameter that will be used as the initializing ' +
   'value for any components that this is an initializer for.  If this property ' +
   'is defined, InitValue will be ignored.'));
  SetPropDesc(TRaveCalcController,'InitValue',Trans('If InitCalcVar and InitDataField ' +
   'are blank, defines a constant value that will be used as the initializing value ' +
   'for any components that this is an initializer for.'));

  SetPropDesc(TRaveDataMirrorSection,'CompareCase',Trans('Determines whether the ' +
   'field values defined in the DataMirrors property are compared with case ' +
   'sensitivity to the value of the data field defined by DataField.  If CompareCase ' +
   'is true, there must be an exact match (Apple <> apple).'));
  SetPropDesc(TRaveDataMirrorSection,'DataField',Trans('Defines the data field that ' +
   'will be compared against the field values defined in the DataMirrors property.  ' +
   'When a match is found, the DataMirrorSection will mirror the section ' +
   'component associated with the matching field value.'));
  SetPropDesc(TRaveDataMirrorSection,'DataView',Trans('Defines the default dataview that ' +
   'will be used for the DataField property.'));
  SetPropDesc(TRaveDataMirrorSection,'DataMirrors',Trans('Using the Data Mirror Editor, ' +
   'defines combinations of field values and section components.  These are used to ' +
   'determine which section will be mirrored when this component is printed.  A default ' +
   'data mirror can be defined that will be used if no other match is found.'));

  SetPropDesc(TRaveRegion,'Columns',Trans('Defines how many columns the region will ' +
   'print.  The width of each column is divided evenly across the width of the region ' +
   'and printing progresses from the left to the right column.'));
  SetPropDesc(TRaveRegion,'ColumnSpacing',Trans('Defines the width of a buffer ' +
   'between each column.  The spacing will not be applied before the first or ' +
   'after the last column.'));

  SetPropDesc(TRaveBand,'AllowSplit',Trans('Determines whether the band can be split ' +
   'across pages.  If AllowSplit is false, the entire band will move to the next page ' +
   'if there is not enough room on the current page.'));
  SetPropDesc(TRaveBand,'BandStyle',Trans('Using the Band Style Editor, defines the ' +
   'locations and occurrences where the band will print.  A band can be set to print ' +
   'multiple locations and occurrences.  The current band style setting is visible on ' +
   'right side of the band header in the page designer.'));
  SetPropDesc(TRaveBand,'ControllerBand',Trans('Defines the band that determines when ' +
   'this band prints.  In other words, this band will be act as a header or footer ' +
   'band for the ControllerBand depending upon the BandStyle property.  This relationship ' +
   'is shown visually in the page designer with a colored arrow that points towards the ' +
   'ControllerBand which contains a diamond shape of the same color.'));
  SetPropDesc(TRaveBand,'DesignerHide',Trans('Determines whether the band is shown ' +
   'in the page designer when it is not selected.  If DesignerHide is true, the band ' +
   'will be hidden when not selected to allow editing of a region with many large bands.'));
  SetPropDesc(TRaveBand,'FinishNewPage',Trans('Determines whether the region will ' +
   'continue on the next page after this band prints.  Useful for keeping report sections ' +
   'on separate pages from a footer band.'));
  SetPropDesc(TRaveBand,'GroupDataView',Trans('Defines the default dataview for the ' +
   'GroupKey property.'));
  SetPropDesc(TRaveBand,'GroupKey',Trans('Defines the data field(s) that make up the ' +
   'group key.  Bands defined as group headers or footers will print whenever the ' +
   'contents of the group key changes.  The group key can contain multiple fields ' +
   'which should be separated with + characters.'));
  SetPropDesc(TRaveBand,'Height',Trans('Defines the height of the band.  The designed ' +
   'height can change if there are components inside that are set to expand their ' +
   'parent such as the memo component.'));
  SetPropDesc(TRaveBand,'MinHeightLeft',Trans('Defines the minimum height that must ' +
   'remain in the region before this band will print.  If MinHeightLeft is greater ' +
   'than the remaining height in the region, the band will be printed on the next page.'));
  SetPropDesc(TRaveBand,'PositionMode',Trans('Defines the mode that will determine where ' +
   'this band prints vertically.  pmOffset and pmOverlay will print a band relative ' +
   'to the bottom of the previous band (the region cursor) while pmAbsolute will ' +
   'print the band relative to the top of the region.  pmOffset will advance the ' +
   'region cursor while pmOverlay and pmAbsolute will not.  See PositionValue.'));
  SetPropDesc(TRaveBand,'PositionValue',Trans('Defines a vertical offset that will ' +
   'applied to the band''s reference point (defined by PositionMode).  Positive values ' +
   'will move the band down the page while negative value will move it up the page.'));
  SetPropDesc(TRaveBand,'ReprintLocs',Trans('If this band is set to reprint on new pages ' +
   'or columns (print occurrence in BandStyle), the style of the band that causes the ' +
   'reprint must be in ReprintLocs for the band to actually reprint.  By default all ' +
   'locations will cause a reprint.'));
  SetPropDesc(TRaveBand,'StartNewPage',Trans('If this is not the first new band to print ' +
   'on this page, the region will print this band on the next page.  Useful for keeping ' +
   'report sections on separate pages from a header band.'));

  SetPropDesc(TRaveIterateBand,'Columns',Trans('Defines how many columns the band will ' +
   'print.  The width of each column is divided evenly across the width of the band and ' +
   'printing progresses from the left to the right column before progressing to the next row.'));
  SetPropDesc(TRaveIterateBand,'ColumnSpacing',Trans('Defines the width of a buffer ' +
   'between each column.  The spacing will not be applied before the first or ' +
   'after the last column.'));
  SetPropDesc(TRaveIterateBand,'KeepBodyTogether',Trans('Determines whether the ' +
   'body of the band (from body header to body footer) will be kept on a single page.  ' +
   'Unless already at the top of the current page, the region will print the body of ' +
   'this band on the next page if it cannot all fit on the current page.'));
  SetPropDesc(TRaveIterateBand,'KeepRowTogether',Trans('Determines whether the ' +
   'row of the band (from row header to row footer) will be kept on a single page.  ' +
   'Unless already at the top of the current page, the region will print the current ' +
   'row of this band on the next page if it cannot all fit on the current page.'));
  SetPropDesc(TRaveIterateBand,'MaxRows',Trans('Defines the maximum number of rows ' +
   'that this band will print.  Useful for limiting print runs when testing or ' +
   'printing only a set number of records.'));
  SetPropDesc(TRaveIterateBand,'InitToFirst',Trans('Determines whether the band ' +
   'will initialize the dataview to the first record or start printing from the ' +
   'current record.'));
  SetPropDesc(TRaveIterateBand,'OrphanRows',Trans('Defines the minimum number of rows ' +
   'that must be able to print on the current page before the whole body is moved ' +
   'to the next page.  A value of 0 will allow orphan rows.'));
  SetPropDesc(TRaveIterateBand,'WidowRows',Trans('Defines the minimum number of rows ' +
   'that must be able to print on the current page before the whole body is moved ' +
   'to the next page.  A value of 0 will allow orphan rows.'));

  SetPropDesc(TRaveDataBand,'DataView',Trans('Defines the dataview that this databand ' +
   'will print from.  The databand will cycle through the records of the dataview ' +
   'until the dataview reaches the last record or MaxRows is reached.'));
  SetPropDesc(TRaveDataBand,'DetailKey',Trans('Defines the field(s) that will ' +
   'be used to build the detail key.  The master and detail keys are used to filter ' +
   'the records in the current dataview so that only the records that match will be ' +
   'printed.  The default dataview for DetailKey is the DataView property.  There ' +
   'must be the same number of fields in the master and detail keys and multiple ' +
   'fields must be separated with the + character.'));
  SetPropDesc(TRaveDataBand,'MasterDataView',Trans('Defines the default dataview ' +
   'for the MasterKey property.'));
  SetPropDesc(TRaveDataBand,'MasterKey',Trans('Defines the field(s) that will ' +
   'be used to build the master key.  The master and detail keys are used to filter ' +
   'the records in the current dataview so that only the records that match will be ' +
   'printed.  There must be the same number of fields in the master and detail keys ' +
   'and multiple fields must be separated with the + character.'));
  SetPropDesc(TRaveDataBand,'SortKey',Trans('Defines the fields that will be used ' +
   'to sort the dataview fields.  The data connection must support sorting on the ' +
   'specified fields or no sorting will occur.'));

  SetPropDesc(TRaveDataCycle,'DataView',Trans('Defines the dataview that this datacycle ' +
   'will print from.  The datacycle will cycle through the records of the dataview ' +
   'until the dataview reaches the last record or MaxRows is reached.'));
  SetPropDesc(TRaveDataCycle,'DetailKey',Trans('Defines the field(s) that will ' +
   'be used to build the detail key.  The master and detail keys are used to filter ' +
   'the records in the current dataview so that only the records that match will be ' +
   'printed.  The default dataview for DetailKey is the DataView property.  There ' +
   'must be the same number of fields in the master and detail keys and multiple ' +
   'fields must be separated with the + character.'));
  SetPropDesc(TRaveDataCycle,'InitToFirst',Trans('Determines whether the datacycle ' +
   'will initialize the dataview to the first record or start printing from the ' +
   'current record.'));
  SetPropDesc(TRaveDataCycle,'MasterDataView',Trans('Defines the default dataview ' +
   'for the MasterKey property.'));
  SetPropDesc(TRaveDataCycle,'MasterKey',Trans('Defines the field(s) that will ' +
   'be used to build the master key.  The master and detail keys are used to filter ' +
   'the records in the current dataview so that only the records that match will be ' +
   'printed.  There must be the same number of fields in the master and detail keys ' +
   'and multiple fields must be separated with the + character.'));
  SetPropDesc(TRaveDataCycle,'MaxRows',Trans('Defines the maximum number of rows ' +
   'that this datacycle will print.  Useful for limiting print runs when testing or ' +
   'printing only a set number of records.'));
  SetPropDesc(TRaveDataCycle,'SortKey',Trans('Defines the fields that will be used ' +
   'to sort the dataview fields.  The data connection must support sorting on the ' +
   'specified fields or no sorting will occur.'));
{$ENDIF}
{TransOn}
end;  { RaveRegister }

function CalcFunction(Value: extended;
                      Func: TRaveCalcFunction): extended;

begin { CalcFunction }
  Result := Value;
  try
    Case Func of
      cfNone: begin end;
      cfTrunc: Result := Trunc(Result);
      cfFrac: Result := Frac(Result);
      cfRound: Result := Round(Result);
      cfNeg: Result := -Result;
      cfAbs: Result := Abs(Result);
      cfSin: Result := Sin(Result);
      cfCos: Result := Cos(Result);
      cfArcTan: Result := ArcTan(Result);
      cfSqr: Result := Sqr(Result);
      cfSqrt: Result := Sqrt(Result);
      cfInc: Result := Result + 1.0;
      cfDec: Result := Result - 1.0;
      cfRandom: Result := Result * Random;
      cfRound1: Result := Round(Result * 10.0) / 10.0;
      cfRound2: Result := Round(Result * 100.0) / 100.0;
      cfRound3: Result := Round(Result * 1000.0) / 1000.0;
      cfRound4: Result := Round(Result * 10000.0) / 10000.0;
      cfRound5: Result := Round(Result * 100000.0) / 100000.0;
      cfSecsToTime: Result := Result / 86400.0;
      cfMinsToTime: Result := Result / 1440.0;
      cfHoursToTime: Result := Result / 24.0;
      cfTimeToSecs: Result := Result * 86400.0;
      cfTimeToMins: Result := Result * 1440.0;
      cfTimeToHours: Result := Result * 24.0;
      cfPercent: Result := Result * 100.0;
    end; { case }
  except
  end; { tryx }
end;  { CalcFunction }

function CalcVariable(    Self: TRaveComponent;
                          CalcVar: TRaveCalcVariable;
                          DataView: TRaveBaseDataView;
                          DataField: TRaveFieldName;
                          Value: extended;
                          Func: TRaveCalcFunction;
                      var DoCount: boolean): extended;
var
  Field: TRaveDataField;
begin { CalcVariable }
  DoCount := true;
  If Assigned(CalcVar) and not CalcVar.IsNull then begin
    Result := CalcVar.Value;
  end else if DataField <> '' then begin
    If Assigned(DataView) then begin
      Field := DataView.FieldByName(DataField);
    end else begin
      Field := nil;
    end; { else }
    If Assigned(Field) then begin
      Result := Field.AsFloat;
      DoCount := not Field.IsNull;
    end else begin
      Result := StrToFloatDef(StripFloatStr(ProcessDataStr(Self,DataView,
       DataField)),0);
    end; { else }
  end else begin
    Result := Value;
  end; { else }
  Result := CalcFunction(Result,Func);
end;  { CalcVariable }

(*****************************************************************************}
( class TRaveDataText
(*****************************************************************************)

  constructor TRaveDataText.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    FTruncate := true;
  {$IFDEF DESIGNER}
    BracketText := true;
  {$ENDIF}
  end;  { Create }

  procedure TRaveDataText.Changing(OldItem: TRaveComponent;
                                   NewItem: TRaveComponent);

  begin { Changing }
    inherited Changing(OldItem,NewItem);
    If Assigned(DataView) and (DataView = OldItem) then begin
      DataView := NewItem as TRaveBaseDataView;
    end; { if }
    If Assigned(LookupDataView) and (LookupDataView = OldItem) then begin
      LookupDataView := NewItem as TRaveBaseDataView;
    end; { if }
  end;  { Changing }

  procedure TRaveDataText.SetText(Value: string);

  begin { SetText }
  end;  { SetText }

function TRaveDataText.GetText: string;
var
  Field: TRaveDataField;
begin { GetText }
  If TRaveProjectManager(Project).Printing then begin { Get from DataView }
    Result := ProcessDataStr(self,DataView,DataField);
    If Assigned(LookupDataView) and (LookupField <> '') and
     (LookupDisplay <> '') then begin
      If LookupDataView = DataView then begin
        Result := ProcessDataStr(self,DataView,LookupDisplay);
      end else begin
        Field := DataView.FieldByName(DataField);
        Result := PerformLookup(LookupDataView,Result,Field,LookupField,
         LookupDisplay,LookupInvalid);
      end; { else }
    end; { if }
  end else begin
    If DataField = '' then begin
      Result := Name;
    end else if Assigned(LookupDataView) and (LookupField <> '') and
     (LookupDisplay <> '') then begin
      Result := DataField + #187 + LookupDataView.Name + '.' +
       LookupDisplay;
    end else begin
      Result := DataField;
    end; { else }
  end; { else }
end;  { GetText }

procedure TRaveDataText.SetDataField(Value: TRaveFieldName);

begin { SetDataField }
  FDataField := Value;
  Invalidate;
end;  { SetDataField }

procedure TRaveDataText.SetLookupDataView(Value: TRaveBaseDataView);

begin { SetLookupDataView }
  FLookupDataView := Value;
  Invalidate;
end;  { SetLookupDataView }

procedure TRaveDataText.SetLookupField(Value: TRaveFieldName);

begin { SetLookupField }
  FLookupField := Value;
  Invalidate;
end;  { SetLookupField }

procedure TRaveDataText.SetLookupDisplay(Value: TRaveFieldName);

begin { SetLookupDisplay }
  FLookupDisplay := Value;
  Invalidate;
end;  { SetLookupDisplay }

(*****************************************************************************}
( class TRaveDataMemo
(*****************************************************************************)

procedure TRaveDataMemo.SetDataField(Value: TRaveFieldName);

begin { SetDataField }
{$IFDEF DESIGNER}
  If Assigned(LineList) then begin { Clear out memo lines }
    LineList.Free;
    LineList := nil;
  end; { if }
{$ENDIF}
  FDataField := Value;
  Invalidate;
end;  { SetDataField }

procedure TRaveDataMemo.Changing(OldItem: TRaveComponent;
                                 NewItem: TRaveComponent);

begin { Changing }
  inherited Changing(OldItem,NewItem);
  If Assigned(DataView) and (DataView = OldItem) then begin
    DataView := NewItem as TRaveBaseDataView;
  end; { if }
end;  { Changing }

function TRaveDataMemo.GetText: string;

begin { GetText }
  If TRaveProjectManager(Project).Printing then begin { Get from DataView }
    Result := ProcessDataStr(self,DataView,DataField);
  end else begin
    If DataField = '' then begin
      Result := '[' + Name + ']';
    end else begin
      Result := '[' + DataField + ']';
    end; { else }
  end; { else }
end;  { GetText }

(*****************************************************************************}
( CalcText and CalcTotal common functions
(*****************************************************************************)

function GetCalcValue(Total: extended;
                      Count: integer;
                      CalcType: TRaveCalcType): extended;

begin { GetCalcValue }
  Case CalcType of
    ctCount: Result := Count;
    ctSum: Result := Total;
    ctMin,ctMax: begin
      If Count = 0 then begin
        Result := 0.0;
      end else begin
        Result := Total;
      end; { else }
    end;
    ctAverage: begin
      If Count = 0 then begin
        Result := 0.0;
      end else begin
        Result := Total / Count;
      end; { else }
    end;
    else Result := 0.0;
  end; { case }
end;  { GetCalcValue }

procedure CalcNewData(var Total: extended;
                      var Count: integer;
                          CalcType: TRaveCalcType;
                          CountBlanks: boolean;
                          CountValue: string;
                          NewData: extended;
                          NewDataStr: string);

begin { CalcNewData }
  Case CalcType of
    ctCount: begin
      If ((CountBlanks or (NewData <> 0.0)) and (CountValue = '')) or
       (NewDataStr = CountValue) then begin
        Inc(Count);
      end; { if }
    end;
    ctSum: begin
      Total := Total + NewData;
    end;
    ctMin: begin
      If (Count = 0) or (NewData < Total) then begin
        Count := 1;
        Total := NewData;
      end; { if }
    end;
    ctMax: begin
      If (Count = 0) or (NewData > Total) then begin
        Count := 1;
        Total := NewData;
      end; { if }
    end;
    ctAverage: begin
      Total := Total + NewData;
      If CountBlanks or (NewData <> 0.0) then begin
        Inc(Count);
      end; { if }
    end;
  end; { case }
end;  { CalcNewData }

procedure CalcInitData(var Total: extended;
                       var Count: integer;
                           CalcType: TRaveCalcType;
                           InitData: extended);

begin { CalcInitData }
  Case CalcType of
    ctCount: begin
      Count := Trunc(InitData);
      Total := 0.0;
    end;
    ctSum: begin
      Count := 0;
      Total := InitData;
    end;
    ctMin,ctMax,ctAverage: begin
      Count := 0;
      Total := 0.0;
    end;
  end; { case }
end;  { CalcInitData }

(*****************************************************************************}
( class TRaveCalcText
(*****************************************************************************)

constructor TRaveCalcText.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
  FCalcType := ctSum;
  FCountBlanks := true;
{$IFDEF DESIGNER}
  BracketText := true;
{$ENDIF}
end;  { Create }

destructor TRaveCalcText.Destroy;

begin { Destroy }
  inherited Destroy;
end;  { Destroy }

procedure TRaveCalcText.Changing(OldItem: TRaveComponent;
                                 NewItem: TRaveComponent);

begin { Changing }
  inherited Changing(OldItem,NewItem);
  If Assigned(DataView) and (DataView = OldItem) then begin
    DataView := NewItem as TRaveBaseDataView;
  end; { if }
  If Assigned(Controller) and (Controller = OldItem) then begin
    Controller := NewItem;
  end; { if }
  If Assigned(Initializer) and (Initializer = OldItem) then begin
    Initializer := NewItem;
  end; { if }
end;  { Changing }

procedure TRaveCalcText.OverrideProperties(Filer: TRaveFiler);

begin { OverrideProperties }
{ ControllerBand was replaced with Controller in version 3.0E }
  Filer.OverrideProperty({Trans-}'ControllerBand',ReadControllerBand,nil);
end;  { OverrideProperties }

procedure TRaveCalcText.ReadControllerBand(Reader: TRaveReader);

var
  PropInfo: PPropInfo;

begin { ReadControllerBand }
{ Read old ControllerBand value into Controller property }
  PropInfo := GetPropInfo(ClassInfo,{Trans-}'Controller');
  Reader.ReadProperty(self,PropInfo);
end;  { ReadControllerBand }

procedure TRaveCalcText.SetText(Value: string);

begin { SetText }
end;  { SetText }

function TRaveCalcText.GetText: string;

begin { GetText }
  If TRaveProjectManager(Project).Printing then begin
    If (CalcType = ctAverage) and (Count = 0) then begin
      Result := Trans('undefined');
    end else begin
      If DisplayType = dtNumericFormat then begin
        Result := FormatFloat(DisplayFormat,Value);
      end else begin { dtDateTimeFormat }
        Result := FormatDateTime(DisplayFormat,Value);
      end; { else }
    end; { else }
  end else begin
  {TransOff}
    Case CalcType of
      ctCount: Result := 'Count(';
      ctSum: Result := 'Sum(';
      ctMin: Result := 'Min(';
      ctMax: Result := 'Max(';
      ctAverage: Result := 'Avg(';
    end; { else }
  {TransOn}
    If DataField = '' then begin
      Result := Result + Name + ')';
    end else begin
      Result := Result + DataField + ')';
    end; { else }
  end; { else }
end;  { GetText }

function TRaveCalcText.GetValue: extended;

begin { GetValue }
  Result := GetCalcValue(Total,Count,CalcType);
end;  { GetValue }

procedure TRaveCalcText.SetDataField(Value: TRaveFieldName);

begin { SetDataField }
  FDataField := Value;
  Invalidate;
end;  { SetDataField }

procedure TRaveCalcText.SetController(Value: TRaveComponent);

begin { SetController }
  If Value = FController then Exit;
  If Assigned(FController) then begin
    FController.RemoveListener({Trans-}'CalcNewData',CalcNewDataListen);
  end; { if }
  FController := Value;
  If Assigned(FController) then begin
    FController.AddListener({Trans-}'CalcNewData',CalcNewDataListen);
  end; { if }
end;  { SetController }

procedure TRaveCalcText.SetInitializer(Value: TRaveComponent);

begin { SetInitializer }
  If Value = FInitializer then Exit;
  If Assigned(FInitializer) then begin
    FInitializer.RemoveListener({Trans-}'CalcInitData',CalcInitDataListen);
  end; { if }
  FInitializer := Value;
  If Assigned(FInitializer) then begin
    FInitializer.AddListener({Trans-}'CalcInitData',CalcInitDataListen);
  end; { if }
end;  { SetInitializer }

procedure TRaveCalcText.BeforeReport;

begin { BeforeReport }
  CalcInitDataListen(self,nil);
  inherited BeforeReport;
end;  { BeforeReport }

procedure TRaveCalcText.CalcNewDataListen(Speaker: TRaveComponent; Msg: TObject);
var
  Value: extended;
  DoCount: boolean;
begin { CalcNewDataListen }
  Value := CalcVariable(Self,nil,DataView,DataField,0.0,cfNone,DoCount);
  If DoCount or not (CalcType in [ctCount,ctAverage]) then begin
    CalcNewData(Total,Count,CalcType,CountBlanks,CountValue,
     Value,ProcessDataStr(self,DataView,DataField));
  end; { if }
end;  { CalcNewDataListen }

procedure TRaveCalcText.CalcInitDataListen(Speaker: TRaveComponent;
                                           Msg: TObject);

var
  InitData: extended;

begin { CalcInitDataListen }
  If Assigned(Msg) then begin
    InitData := extended(pointer(Msg)^);
  end else begin
    InitData := 0.0;
  end; { else }
  CalcInitData(Total,Count,CalcType,InitData);
end;  { CalcInitDataListen }

procedure TRaveCalcText.Print(Report: TBaseReport);

begin { Print }
  if not AllowPrint then Exit;
  inherited Print(Report);
  If not RunningTotal then begin
    CalcInitDataListen(self,nil);
  end; { if }
end;  { Print }

(*****************************************************************************}
( class TRaveCalcVariable
(*****************************************************************************)

function TRaveCalcVariable.GetIsNull: boolean;

begin { GetIsNull }
  Result := false;
end;  { GetIsNull }

procedure TRaveCalcVariable.Print(Report: TBaseReport);

var
  S1: string;

begin { Print }
  If (DestParam <> '') or (DestPIVar <> '') then begin
    If DisplayType = dtNumericFormat then begin
      S1 := FormatFloat(DisplayFormat,Value);
    end else begin { dtDateTimeFormat }
      S1 := FormatDateTime(DisplayFormat,Value);
    end; { else }
    If DestParam <> '' then begin
      TRaveProjectManager(Project).SetParam(DestParam,S1);
    end; { if }
    If DestPIVar <> '' then begin
      Report.SetPIVar(DestPIVar,S1);
    end; { if }
  end; { if }
end;  { Print }

(*****************************************************************************}
( class TRaveCalcOp
(*****************************************************************************)

constructor TRaveCalcOp.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
end;  { Create }

destructor TRaveCalcOp.Destroy;

begin { Destroy }
  inherited Destroy;
end;  { Destroy }

function TRaveCalcOp.GetIsNull: boolean;

begin { GetIsNull }
  Result := (Assigned(Src1CalcVar) and Src1CalcVar.IsNull) or
   (Assigned(Src2CalcVar) and Src2CalcVar.IsNull);
end;  { GetIsNull }

function TRaveCalcOp.GetValue: extended;

var
  Val1: extended;
  Val2: extended;
  DoCount: boolean;

begin { GetValue }
  Val1 := CalcVariable(Self,Src1CalcVar,Src1DataView,Src1DataField,Src1Value,Src1Function,DoCount);
  Val2 := CalcVariable(Self,Src2CalcVar,Src2DataView,Src2DataField,Src2Value,Src2Function,DoCount);
  try
    Case Operator of
      coAdd: Result := Val1 + Val2;
      coSub: Result := Val1 - Val2;
      coMul: Result := Val1 * Val2;
      coDiv: begin
        If Val2 = 0.0 then begin
          Result := 0.0;
        end else begin
          Result := Val1 / Val2;
        end; { else }
      end;
      coMod: Result := Trunc(Val1) mod Trunc(Val2);
      coExp: Result := Exp(Val2 * Ln(Val1));
      coGreater: begin
        If Val1 > Val2 then begin
          Result := Val1;
        end else begin
          Result := Val2;
        end; { else }
      end;
      coLesser: begin
        If Val1 < Val2 then begin
          Result := Val1;
        end else begin
          Result := Val2;
        end; { else }
      end;
      coAverage: begin
        Result := (Val1 + Val2) / 2.0;
      end;
      else Result := 0.0;
    end; { case }
    Result := CalcFunction(Result,ResultFunction);
  except
    Result := 0.0;
  end; { tryx }
end;  { GetValue }

procedure TRaveCalcOp.Changing(OldItem: TRaveComponent;
                               NewItem: TRaveComponent);

begin { Changing }
  inherited Changing(OldItem,NewItem);
  If Assigned(Src1CalcVar) and (Src1CalcVar = OldItem) then begin
    Src1CalcVar := NewItem as TRaveCalcVariable;
  end; { if }
  If Assigned(Src1DataView) and (Src1DataView = OldItem) then begin
    Src1DataView := NewItem as TRaveBaseDataView;
  end; { if }
  If Assigned(Src2CalcVar) and (Src2CalcVar = OldItem) then begin
    Src2CalcVar := NewItem as TRaveCalcVariable;
  end; { if }
  If Assigned(Src2DataView) and (Src2DataView = OldItem) then begin
    Src2DataView := NewItem as TRaveBaseDataView;
  end; { if }
end;  { Changing }

(*****************************************************************************}
( class TRaveCalcTotal
(*****************************************************************************)

constructor TRaveCalcTotal.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
  FCalcType := ctSum;
  FCountBlanks := true;
end;  { Create }

destructor TRaveCalcTotal.Destroy;

begin { Destroy }
  inherited Destroy;
end;  { Destroy }

function TRaveCalcTotal.GetValue: extended;

begin { GetValue }
  Result := GetCalcValue(Total,Count,CalcType);
end;  { GetValue }

procedure TRaveCalcTotal.BeforeReport;

begin { BeforeReport }
  CalcInitDataListen(self,nil);
  inherited BeforeReport;
end;  { BeforeReport }

procedure TRaveCalcTotal.CalcNewDataListen(Speaker: TRaveComponent; Msg: TObject);
var
  Value: extended;
  DoCount: boolean;
begin { CalcNewDataListen }
  If not (Assigned(CalcVar) and CalcVar.IsNull) then begin
    Value := CalcVariable(Self,CalcVar,DataView,DataField,0.0,cfNone,DoCount);
    If DoCount or not (CalcType in [ctCount,ctAverage]) then begin
      CalcNewData(Total,Count,CalcType,CountBlanks,CountValue,
       Value,ProcessDataStr(Speaker,DataView,DataField));
    end; { if }
  end; { if }
end;  { CalcNewDataListen }

procedure TRaveCalcTotal.CalcInitDataListen(Speaker: TRaveComponent;
                                            Msg: TObject);

var
  InitData: extended;

begin { CalcInitDataListen }
  If Assigned(Msg) then begin
    InitData := extended(pointer(Msg)^);
  end else begin
    InitData := 0.0;
  end; { else }
  CalcInitData(Total,Count,CalcType,InitData);
end;  { CalcInitDataListen }

procedure TRaveCalcTotal.Changing(OldItem: TRaveComponent;
                                  NewItem: TRaveComponent);

begin { Changing }
  inherited Changing(OldItem,NewItem);
  If Assigned(CalcVar) and (CalcVar = OldItem) then begin
    CalcVar := NewItem as TRaveCalcVariable;
  end; { if }
  If Assigned(DataView) and (DataView = OldItem) then begin
    DataView := NewItem as TRaveBaseDataView;
  end; { if }
  If Assigned(Controller) and (Controller = OldItem) then begin
    Controller := NewItem;
  end; { if }
  If Assigned(Initializer) and (Initializer = OldItem) then begin
    Initializer := NewItem;
  end; { if }
end;  { Changing }

procedure TRaveCalcTotal.SetController(Value: TRaveComponent);

begin { SetController }
  If Value = FController then Exit;
  If Assigned(FController) then begin
    FController.RemoveListener({Trans-}'CalcNewData',CalcNewDataListen);
  end; { if }
  FController := Value;
  If Assigned(FController) then begin
    FController.AddListener({Trans-}'CalcNewData',CalcNewDataListen);
  end; { if }
end;  { SetController }

procedure TRaveCalcTotal.SetInitializer(Value: TRaveComponent);

begin { SetInitializer }
  If Value = FInitializer then Exit;
  If Assigned(FInitializer) then begin
    FInitializer.RemoveListener({Trans-}'CalcInitData',CalcInitDataListen);
  end; { if }
  FInitializer := Value;
  If Assigned(FInitializer) then begin
    FInitializer.AddListener({Trans-}'CalcInitData',CalcInitDataListen);
  end; { if }
end;  { SetInitializer }

procedure TRaveCalcTotal.Print(Report: TBaseReport);

begin { Print }
  inherited Print(Report);
  If not RunningTotal then begin { Reset totals }
    CalcInitDataListen(self,nil);
  end; { if }
end;  { Print }

(*****************************************************************************}
( class TRaveCalcController
(*****************************************************************************)

constructor TRaveCalcController.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
end;  { Create }

destructor TRaveCalcController.Destroy;

begin { Destroy }
  CalcNewDataListenList.Free;
  CalcInitDataListenList.Free;
  inherited Destroy;
end;  { Destroy }

procedure TRaveCalcController.AddListener(Conversation: string;
                                          ListenMethod: TRaveListenEvent);

begin { AddListener }
  inherited AddListener(Conversation,ListenMethod);
  If CompareText(Conversation,{Trans-}'CalcNewData') = 0 then begin
    If not Assigned(CalcNewDataListenList) then begin
      CalcNewDataListenList := TRaveMethodList.Create;
    end; { if }
    CalcNewDataListenList.AddMethod(TMethod(ListenMethod));
  end else if CompareText(Conversation,{Trans-}'CalcInitData') = 0 then begin
    If not Assigned(CalcInitDataListenList) then begin
      CalcInitDataListenList := TRaveMethodList.Create;
    end; { if }
    CalcInitDataListenList.AddMethod(TMethod(ListenMethod));
  end; { else }
end;  { AddListener }

procedure TRaveCalcController.RemoveListener(Conversation: string;
                                             ListenMethod: TRaveListenEvent);

begin { RemoveListener }
  inherited RemoveListener(Conversation,ListenMethod);
  If (CompareText(Conversation,{Trans-}'CalcNewData') = 0) and
   Assigned(CalcNewDataListenList) then begin
    CalcNewDataListenList.RemoveMethod(TMethod(ListenMethod));
  end else if (CompareText(Conversation,{Trans-}'CalcInitData') = 0) and
   Assigned(CalcInitDataListenList) then begin
    CalcInitDataListenList.RemoveMethod(TMethod(ListenMethod));
  end; { else }
end;  { RemoveListener }

function TRaveCalcController.Habla(Conversation: string): boolean;

begin { Habla }
  Result := (CompareText(Conversation,{Trans-}'CalcNewData') = 0) or
    (CompareText(Conversation,{Trans-}'CalcInitData') = 0);
end;  { Habla }

procedure TRaveCalcController.Changing(OldItem: TRaveComponent;
                                       NewItem: TRaveComponent);

begin { Changing }
  inherited Changing(OldItem,NewItem);
  If Assigned(InitCalcVar) and (InitCalcVar = OldItem) then begin
    InitCalcVar := NewItem as TRaveCalcVariable;
  end; { if }
  If Assigned(CalcNewDataListenList) and Assigned(OldItem) then begin
    If Assigned(NewItem) then begin
      CalcNewDataListenList.ReplaceObject(OldItem,NewItem);
    end else begin
      CalcNewDataListenList.RemoveObject(OldItem);
    end; { else }
  end; { if }
  If Assigned(CalcInitDataListenList) and Assigned(OldItem) then begin
    If Assigned(NewItem) then begin
      CalcInitDataListenList.ReplaceObject(OldItem,NewItem);
    end else begin
      CalcInitDataListenList.RemoveObject(OldItem);
    end; { else }
  end; { if }
end;  { Changing }

procedure TRaveCalcController.Print(Report: TBaseReport);
var
  Value: extended;
  DoCount: boolean;
begin { Print }
  Value := CalcVariable(Self,InitCalcVar,nil,InitDataField,InitValue,cfNone,DoCount);
  Speak(CalcInitDataListenList,@Value); { Notify controlled objects of initialize }
  Speak(CalcNewDataListenList,nil); { Notify controlled objects of new data }
end;  { Print }

(*****************************************************************************}
( class TRaveDataMirrorList
(*****************************************************************************)

type
  TRaveDataMirrorList = class(TRavePersistentList)
  public
    function CreateItem(ItemClass: string;
                        RootOwner: TComponent): TPersistent; override;
  end; { TRaveDataMirrorList }

function TRaveDataMirrorList.CreateItem(ItemClass: string;
                                        RootOwner: TComponent): TPersistent;

begin { CreateItem }
  Result := TRaveDataMirror.Create;
end;  { CreateItem }

(*****************************************************************************}
( class TRaveDataMirrorSection
(*****************************************************************************)

constructor TRaveDataMirrorSection.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
  FDataMirrors := TRaveDataMirrorList.Create;
end;  { Create }

destructor TRaveDataMirrorSection.Destroy;

begin { Destroy }
  If not DirectReference then begin
    ClearObjectList(FDataMirrors);
    FreeAndNil(FDataMirrors);
  end; { if }
  inherited Destroy;
end;  { Destroy }

procedure TRaveDataMirrorSection.SetDataMirrors(Value: TRavePersistentList);

var
  I1: integer;
  DM1: TRaveDataMirror;
  DM2: TRaveDataMirror;

begin { SetDataMirrors }
  If TRaveProjectManager(Project).Printing then begin
    FDataMirrors := Value;
    DirectReference := true;
  end else begin
    DirectReference := false;
    ClearObjectList(FDataMirrors);
    For I1 := 0 to Value.Count - 1 do begin
      DM1 := TRaveDataMirror(Value[I1]);
      DM2 := TRaveDataMirror.Create;
      DM2.DataValue := DM1.DataValue;
      DM2.SectionMirror := DM1.SectionMirror;
      DM2.IsDefault := DM1.IsDefault;
      FDataMirrors.Add(DM2);
    end; { for }
  end; { else }
end;  { SetDataMirrors }

procedure TRaveDataMirrorSection.InitData;
var
  I1: integer;
  DataText: string;
  CurrControl: TRaveControl;
  NewMirror: TRaveControl;
begin { InitData }
  If Initialized then Exit;
{ Setup Mirror before initializing rest of section }
  FSaveMirror := Mirror;
  CurrControl := self;
  Repeat
    NewMirror := nil;
    DataText := ProcessDataStr(self,DataView,DataField);
    For I1 := 0 to DataMirrors.Count - 1 do begin
      With TRaveDataMirror(DataMirrors[I1]) do begin
        If IsDefault and not Assigned(NewMirror) then begin
          NewMirror := SectionMirror; { Assign default value }
        end; { if }
        If (CompareCase and (CompareStr(DataText,DataValue) = 0)) or
         (not CompareCase and (CompareText(DataText,DataValue) = 0)) then begin
          NewMirror := SectionMirror;
          Break;
        end; { if }
      end; { with }
    end; { for }
    CurrControl.Mirror := NewMirror;
    If NewMirror is TRaveDataMirrorSection then begin
      CurrControl := NewMirror;
    end else begin
      CurrControl := nil;
    end; { else }
  until not Assigned(CurrControl);

  inherited InitData;
  Initialized := true;
end;  { InitData }

procedure TRaveDataMirrorSection.DoneData;

begin { DoneData }
  If not Initialized then Exit;
  inherited DoneData;
  If Mirror <> FSaveMirror then begin
  { Set mirrored item back to designed state.
    Typecast as TRaveDataMirrorSection to get access to protected method }
    If Assigned(Mirror) then begin
      TRaveDataMirrorSection(Mirror).RestoreDesigned;
    end; { if }
    Mirror := FSaveMirror;
  end; { if }
  Initialized := false;
end;  { DoneData }

procedure TRaveDataMirrorSection.SaveDesigned;

begin { SaveDesigned }
  inherited SaveDesigned;
  FSaveAnchor := Anchor;
  FSaveCompareCase := CompareCase;
  FSaveDataField := DataField;
  FSaveDataMirrors := DataMirrors;
  FSaveDataView := DataView;
  FSaveDisplayOn := DisplayOn;
  FSaveTag := Tag;
end;  { SaveDesigned }

procedure TRaveDataMirrorSection.RestoreDesigned;

begin { RestoreDesigned }
  Anchor := FSaveAnchor;
  CompareCase := FSaveCompareCase;
  DataField := FSaveDataField;
  FDataMirrors := FSaveDataMirrors;
  DataView := FSaveDataView;
  DisplayOn := FSaveDisplayOn;
  Tag := FSaveTag;
  inherited RestoreDesigned;
end;  { RestoreDesigned }

procedure TRaveDataMirrorSection.RestoreAdjusted;

begin { RestoreAdjusted }
  Anchor := FSaveAnchor;
  CompareCase := FSaveCompareCase;
  DataField := FSaveDataField;
  FDataMirrors := FSaveDataMirrors;
  DataView := FSaveDataView;
  DisplayOn := FSaveDisplayOn;
  Tag := FSaveTag;
  inherited RestoreAdjusted;
end;  { RestoreAdjusted }

procedure TRaveDataMirrorSection.Changing(OldItem: TRaveComponent;
                                          NewItem: TRaveComponent);

var
  I1: integer;
  DataMirror: TRaveDataMirror;

begin { Changing }
  inherited Changing(OldItem,NewItem);
  If Assigned(DataView) and (DataView = OldItem) then begin
    DataView := NewItem as TRaveBaseDataView;
  end; { if }
  If Assigned(FDataMirrors) then begin
    For I1 := 0 to FDataMirrors.Count - 1 do begin
      DataMirror := TRaveDataMirror(FDataMirrors[I1]);
      If Assigned(DataMirror.SectionMirror) and (DataMirror.SectionMirror =
       OldItem) then begin
        DataMirror.SectionMirror := NewItem as TRaveSection;
      end; { if }
    end; { for }
  end; { if }
end;  { Changing }

procedure TRaveDataMirrorSection.PrintAll(Report: TBaseReport);

begin { PrintAll }
  InitData;
  inherited PrintAll(Report);
  DoneData;
end;  { PrintAll }

{$IFDEF DESIGNER}
procedure TRaveDataMirrorSection.Paint(Canvas: TCanvas);

begin { Paint }
  With Canvas do begin
    Pen.Color := clFuchsia;
    Pen.Style := psDot;
    Pen.Mode := pmCopy;
    Pen.Width := 1;
    Brush.Color := clWhite;
    Brush.Style := bsClear;
    Rectangle(XI2D(PageLeft),YI2D(PageTop),XI2D(PageRight) + 1,YI2D(PageBottom) + 1);
  end; { with }
end;  { Paint }
{$ENDIF}

initialization
  RegisterProc('RVCL',RaveRegister);
end.