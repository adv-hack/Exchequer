unit TKPICKLIST;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, ExtCtrls, uMultiList, uComTKDataset, uDBMultiList
  , uBtrieveDataset, uExDatasets, uDBMColumns, ComCtrls, COMObj, StrUtil
  , Menus, uSettings, BTUtil, APIUtil, Enterprise01_TLB
  {$IFDEF PRE_571002_MULTILIST}
    ;
  {$ELSE}
    , EnterpriseBeta_TLB;
  {$ENDIF}

const
  glcANY_CLASS = -1;
  glccyANY_CURRENCY = -1;
  glccyCONSOLIDATED = 0;

  WM_DoIt = WM_User+$1;

  CLICK_OK = 1;
  CLICK_CANCEL = 2;

  NO_FILTER = 0;
  FILTER_ALTCODE = 1;
  FILTER_PARENTCODE = 2;
  FILTER_LINETYPE = 3;
  FILTER_NO_PARENTCODE = 4;

type
//  TIncludeGLTypes = Set of LongWord;

  TplType = (plSupplier, plGLCode, plCC, plDept, plCustomer, plProduct, plProductAndBOM, plBOM
  , plProductGroup, plLocation, plCustSalesAnalysis, plProductAndGroup, plProductInAGroup
  , plProductNoBOM, plProductOnly, plSupersededBy, plJob, plJobAnalysis, plProductDescOnly
  , plUser);

  TfrmTKPickList = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    ctkDataSet: TComTKDataset;
    panList: TPanel;
    mlList: TDBMultiList;
    pmMain: TPopupMenu;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    btnShowAll: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure GetFieldValue(Sender: TObject; ID: IDispatch; FieldName: String; var FieldValue: String);
    procedure SelectRecord(Sender: TObject; SelectType: TSelectType; Address: integer; ID: IDispatch);
//    procedure BuildIndex(Sender: TObject; ID: IDispatch; IndexNo : integer; var KeyStr : String);
    procedure btnOKClick(Sender: TObject);
//    procedure mlListSortColumn(Sender: TObject; ColIndex: Integer; SortAsc: Boolean);
    procedure FormShow(Sender: TObject);
    procedure mlListAfterInit(Sender: TObject);
    procedure mlListRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlListAfterLoad(Sender: TObject);
    procedure mlListBeforeLoad(Sender: TObject; var Allow: Boolean);
    procedure mlListScrollButtonKeyPress(Key: Char);
    procedure ctkDataSetFilterRecord(Sender: TObject; ID: IDispatch;
      var Include: Boolean);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnShowAllClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    bRestore : boolean;
//    IncludeGLTypes : TIncludeGLTypes;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
    procedure WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    function GetStockDescFromCode(sStockCode : string) : string;
    procedure WMDoIt(var Message : TMessage); message WM_DoIt;
  public
    oLToolkit : IToolkit;
    sParentCode : string[16];
    sFilter, sFind : string;
    plType : TplType;
    iCodeIndex, iDescIndex : integer;
    iFilterMode, iGLCurrency, iGLIncludeClass, iSearchCol : integer;
    bShowMessageIfEmpty, bAutoSelectIfOnlyOne, bRestrictList : boolean;
    IncludeGLTypes : Set of 1..100;
    sCaption : string;
    constructor CreateWith(Sender: TComponent; AToolkit : IToolkit);
  end;

var
  frmTKPickList: TfrmTKPickList;

implementation

{$R *.dfm}

uses
  FileUtil;

{$I TkPickListImplementation.inc}

end.
