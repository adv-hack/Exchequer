{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPTable;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Controls, TypInfo, Graphics,
  Dialogs, Forms, RPDefine, RPBase, RPFiler, RPShell, RPSect, RPMemo;

{$I RPVER.PAS}

{ Code based table printing class }
{

type
  TTableRow = class
  public
    DefaultMargin: double;

    procedure AddColumn(Justify: TPrintJustify;
                        Width: double;
                        Lines: TBoxLines);
  end;

This class is used to contain a group of columns.  Most of the
functionality of the current TTablePrinter will be moved to this
class.  This will allow easier code based table printer as compared
with SetTab/PrintTab and will also allow much more efficient RTF &
HTML export.

Each column will have the following properties:
  property Width: double;
  property ShadeColor: TColor;
  property ShadePercent: byte;
  property Margin: double;
  property Margin100: double;
  property OverflowMethod: TOverflowMethod;
  property OverflowReplace: TFormatString;
  property OverflowAppend: TFormatString;
  property MinFontSize: byte;
  property Font: TFont;
  property UseParentFont: boolean;
  property Pen: TPen;
  property UseParentPen: boolean;
  property Justify: TPrintJustify;
  property JustifyVert: TPrintJustifyVert;
  property BoxLines: TBoxLines;

  property Heading: TFormatString;
  property HeadingJustify
  property Totals: boolean;
  property SplitRow: boolean;
  property DisplayFormat: TFormatString;

// Maybe these properties
  property OutputType: TOutputType;
  property TableItem: TTableItem;
  property MemoBuf: TMemoBuf;
  property SubTotal: double;
  property PageTotal: double;
  property GrandTotal: double;
  property AsInteger: integer;
  property AsFloat: double;

  property Defined: TDefinedSet; { This set will contain which items have
   been defined differently than the default value for the table row. }

type
  TSectionType = (stReportHeader,stPageHeader,stBodyHeader,stGroupHeader,
   stGroupFooter,stBodyFooter,stPageFooter,stReportFooter,stNone);

const
  SectionName: array[TSectionType] of string[13] = ('Report Header','Page Header',
   'Body Header','Group Header','Group Footer','Body Footer','Page Footer',
   'Report Footer','None');

type
  TTableItem = class;
  TTableColumn = class;
  TTableSection = class;
  TTablePrinter = class;

  TOverflowMethod = (omTruncateWord,omTruncateChar,omReplace,omWrap,omShrink,omUser);
  TOutputType = (otText,otHeadings,otPageTotals,otSubTotals,otGrandTotals);

  TFormatEvent = procedure(    Sender: TObject;
                           var Text: string) of object;
  TIntegerEvent = function(Sender: TObject): integer of object;

  TTableColumnEvent = procedure(TableColumn: TTableColumn) of object;

  TTableColumnHeightEvent = procedure(    TableColumn: TTableColumn;
                                      var Height: double;
                                      var MinHeight: double) of object;

  TTableSectionEvent = procedure(TableSection: TTableSection) of object;

  TTablePrinterEvent = procedure(    TablePrinter: TTablePrinter;
                                 var Valid: boolean) of object;

{ Relationship of Groups, Rows and Columns                                     }
{                                                                              }
{ - A group is composed of a row and a detail body                             }
{ - A subgroup can contain several of its own subgroups                        }
{ - A row contains columns                                                     }
{ - Columns contain data                                                       }

  TRowHeader = record
    Height: double; { Height of this row }
    MinHeight: double; { Minimum printable height for this row }
    Columns: word; { How many columns are in this row }
    Level: word; { Level of this row }
  end; { TRowHeader }

  TColHeader = record
    DataSize: longint; { Length of data that follows }
    FontSize: double; { Size of font for line }
    Height: double; { Height of data in the column }
    MinHeight: double; { Minimum printable height for this column }
    StartLine: smallint; { Line to start printing from }
    Lines: word; { Lines of data }
  end; { TColHeader }

  TColText = record
    Justify: TPrintJustify;
    Height: double; { Height of line }
    Len: longint; { Length of text that follows }
  end; { TColText }

{*************************************************************************}
{                            class TTableItem                             }
{*************************************************************************}

  TTableItem = class(TRPBaseComponent)
  protected
    FParent: TTablePrinter; { Parent TTablePrinter object }
    SaveColStream: TStream;
    SaveColHeader: TColHeader;
    SaveHeight: double;

  { Attributes about this column }
    FWidth: double; { Width of column in inches }
    FShadeColor: TColor; { Color of column to shade in, use util proc to init }
    FShadePercent: byte; { Percent of FShadeColor to use }
    FMargin: double; { Width of margin in inches }
    FOverflowMethod: TOverflowMethod; { Method to use when text is too long }
    FOverflowAppend: TFormatString; { String to append when truncating }
    FOverflowReplace: TFormatString; { String to replace with when omReplace }
    FMinFontSize: byte; { Minimum point size for omShrink }
    FJustify: TPrintJustify; { Horizontal justification }
    FJustifyVert: TPrintJustifyVert; { Vertical justification }
    FBoxLines: TBoxLines;
    FFont: TFont;
    FPen: TPen;
    FUseParentFont: boolean;
    FUseParentPen: boolean;
    FDescription: TComponentName; { Descriptive name of TableItem }

    procedure ReadState(Reader: TReader); override;
    procedure SetParent(Value: TTablePrinter); virtual; abstract;
    procedure Loaded; override;
    procedure ParentFontChanged;

    procedure SetDescription(Value: TComponentName);
    procedure SetFont(Value: TFont);
    procedure SetPen(Value: TPen);
    procedure SetWidth(Value: double);
    function GetWidth: double;
    procedure SetShadePercent(Value: byte);
    procedure SetMargin(Value: double);
    function GetMargin: double;
    procedure SetMargin100(Value: double);
    function GetMargin100: double;
    procedure SetOverflowMethod(Value: TOverflowMethod);
    function GetOverflowMethod: TOverflowMethod;
    function GetReportPrinter: TBaseReport;
    function IsFontStored: boolean;
    function IsPenStored: boolean;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PrintBox;
    function HasParent: boolean; override;

    property TablePrinter: TTablePrinter read FParent;
    property ReportPrinter: TBaseReport read GetReportPrinter;

  published
    property Description: TComponentName read FDescription write SetDescription;
    property Width: double read GetWidth write SetWidth;
    property ShadeColor: TColor read FShadeColor write FShadeColor default clBlack;
    property ShadePercent: byte read FShadePercent write SetShadePercent default 0;
    property Margin: double read GetMargin write SetMargin;
    property Margin100: double read GetMargin100 write SetMargin100;
    property OverflowMethod: TOverflowMethod read GetOverflowMethod
     write SetOverflowMethod default omTruncateChar;
    property OverflowReplace: TFormatString read FOverflowReplace
     write FOverflowReplace;
    property OverflowAppend: TFormatString read FOverflowAppend
     write FOverflowAppend;
    property MinFontSize: byte read FMinFontSize write FMinFontSize default 6;
    property Font: TFont read FFont write SetFont stored IsFontStored;
    property UseParentFont: boolean read FUseParentFont write FUseParentFont
     default true;
    property Pen: TPen read FPen write SetPen stored IsPenStored;
    property UseParentPen: boolean read FUseParentPen write FUseParentPen
     default true;
    property Justify: TPrintJustify read FJustify write FJustify default pjLeft;
    property JustifyVert: TPrintJustifyVert read FJustifyVert write FJustifyVert
     default pjTop;
    property BoxLines: TBoxLines read FBoxLines write FBoxLines default blAll;
  end; { TTableItem }

{*************************************************************************}
{                            class TTableColumn                           }
{*************************************************************************}

  TTableColumn = class(TTableItem)
  protected
    IsDefault: boolean;

    FIndex: word; { Column number 0 for default column and 1-n for user's }
    FOutputType: TOutputType;
    FTableItem: TTableItem;

  { Attributes about this column }
    FHeading: TFormatString;
    FMemoBuf: TMemoBuf;
    FSubTotal: double;
    FPageTotal: double;
    FGrandTotal: double;
    FTotals: boolean;
    FSection: TReportSection;
    FSplitRow: boolean;
    FDisplayFormat: TFormatString;

  { Event Methods }
    FOnHeaderBefore: TTableColumnEvent;
    FOnHeaderSetup: TTableColumnEvent;
    FOnHeaderHeight: TTableColumnHeightEvent;
    FOnHeaderPrint: TTableColumnHeightEvent;
    FOnHeaderAfter: TTableColumnEvent;

    FOnRowBefore: TTableColumnEvent;
    FOnRowSetup: TTableColumnEvent;
    FOnRowHeight: TTableColumnHeightEvent;
    FOnRowPrint: TTableColumnHeightEvent;
    FOnRowAfter: TTableColumnEvent;

    FOnFooterBefore: TTableColumnEvent;
    FOnFooterSetup: TTableColumnEvent;
    FOnFooterHeight: TTableColumnHeightEvent;
    FOnFooterPrint: TTableColumnHeightEvent;
    FOnFooterAfter: TTableColumnEvent;

    FOnAddTotal: TTableColumnEvent;
    FOnInitPage: TTableColumnEvent;
    FOnInitMaster: TTableColumnEvent;
    FOnOverflow: TTableColumnEvent;

    procedure HeaderBeforeEvent; virtual;
    procedure HeaderSetupEvent; virtual;
    procedure HeaderHeightEvent(var Height: double;
                                var MinHeight: double); virtual;
    procedure HeaderPrintEvent(var Height: double;
                               var MinHeight: double); virtual;
    procedure HeaderAfterEvent; virtual;
    procedure RowBeforeEvent; virtual;
    procedure RowSetupEvent; virtual;
    procedure RowHeightEvent(var Height: double;
                             var MinHeight: double); virtual;
    procedure RowPrintEvent(var Height: double;
                            var MinHeight: double); virtual;
    procedure RowAfterEvent; virtual;
    procedure FooterBeforeEvent; virtual;
    procedure FooterSetupEvent; virtual;
    procedure FooterHeightEvent(var Height: double;
                                var MinHeight: double); virtual;
    procedure FooterPrintEvent(var Height: double;
                               var MinHeight: double); virtual;
    procedure FooterAfterEvent; virtual;
    procedure AddTotalEvent; virtual;
    procedure InitPageEvent; virtual;
    procedure InitMasterEvent; virtual;
    procedure OverflowEvent; virtual;

    procedure SetParent(Value: TTablePrinter); override;
    function GetAsInteger: integer;
    procedure SetAsInteger(Value: integer);
    function GetAsFloat: double;
    procedure SetAsFloat(Value: double);

    procedure FillMemoBuf; virtual;
    procedure GetRow(    ColStream: TStream;
                     var ColHeader: TColHeader);
    procedure PrintRow(    ColStream: TStream;
                       var ColHeader: TColHeader;
                           Height: double);
    procedure AddTotal;
    procedure InitPage;
    procedure InitMaster;
    procedure AddLine(    ColStream: TStream;
                      var ColHeader: TColHeader;
                          S1: string;
                          ThisJustify: TPrintJustify);
    procedure ProcessOverflow(    ColStream: TStream;
                              var ColHeader: TColHeader;
                                  AvailWidth: double);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; virtual;
    procedure PrintDefault;

    property OutputType: TOutputType read FOutputType write FOutputType;
    property TableItem: TTableItem read FTableItem write FTableItem;
    property MemoBuf: TMemoBuf read FMemoBuf;
    property SubTotal: double read FSubTotal write FSubTotal;
    property PageTotal: double read FPageTotal write FPageTotal;
    property GrandTotal: double read FGrandTotal write FGrandTotal;
    property AsInteger: integer read GetAsInteger write SetAsInteger;
    property AsFloat: double read GetAsFloat write SetAsFloat;
  published
    property Heading: TFormatString read FHeading write FHeading;
    property Totals: boolean read FTotals write FTotals default false;
    property SplitRow: boolean read FSplitRow write FSplitRow default true;
    property DisplayFormat: TFormatString read FDisplayFormat write FDisplayFormat;

  { Event handlers }
    property OnHeaderBefore: TTableColumnEvent read FOnHeaderBefore
     write FOnHeaderBefore;
    property OnHeaderSetup: TTableColumnEvent read FOnHeaderSetup
     write FOnHeaderSetup;
    property OnHeaderHeight: TTableColumnHeightEvent read FOnHeaderHeight
     write FOnHeaderHeight;
    property OnHeaderPrint: TTableColumnHeightEvent read FOnHeaderPrint
     write FOnHeaderPrint;
    property OnHeaderAfter: TTableColumnEvent read FOnHeaderAfter
     write FOnHeaderAfter;

    property OnRowBefore: TTableColumnEvent read FOnRowBefore
     write FOnRowBefore;
    property OnRowSetup: TTableColumnEvent read FOnRowSetup
     write FOnRowSetup;
    property OnRowHeight: TTableColumnHeightEvent read FOnRowHeight
     write FOnRowHeight;
    property OnRowPrint: TTableColumnHeightEvent read FOnRowPrint
     write FOnRowPrint;
    property OnRowAfter: TTableColumnEvent read FOnRowAfter
     write FOnRowAfter;

    property OnFooterBefore: TTableColumnEvent read FOnFooterBefore
     write FOnFooterBefore;
    property OnFooterSetup: TTableColumnEvent read FOnFooterSetup
     write FOnFooterSetup;
    property OnFooterHeight: TTableColumnHeightEvent read FOnFooterHeight
     write FOnFooterHeight;
    property OnFooterPrint: TTableColumnHeightEvent read FOnFooterPrint
     write FOnFooterPrint;
    property OnFooterAfter: TTableColumnEvent read FOnFooterAfter
     write FOnFooterAfter;

    property OnAddTotal: TTableColumnEvent read FOnAddTotal write FOnAddTotal;
    property OnInitPage: TTableColumnEvent read FOnInitPage write FOnInitPage;
    property OnInitMaster: TTableColumnEvent read FOnInitMaster write FOnInitMaster;
    property OnOverflow: TTableColumnEvent read FOnOverflow write FOnOverflow;
  end; { TTableColumn }

{*************************************************************************}
{                            class TTableSection                          }
{*************************************************************************}
  TTableSection = class(TTableItem)
  protected
    FSectionType: TSectionType;
    FSection: TReportSection;
    FText: TFormatString;
    FOutputType: TOutputType;

  { Event handlers }
    FOnBefore: TTableSectionEvent;
    FOnSetup: TTableSectionEvent;
    FOnPrint: TTableSectionEvent;
    FOnAfter: TTableSectionEvent;

    procedure BeforeEvent; virtual;
    procedure SetupEvent; virtual;
    procedure PrintEvent; virtual;
    procedure AfterEvent; virtual;

    procedure SetParent(Value: TTablePrinter); override;
    procedure SetSectionType(Value: TSectionType);
    procedure SetSection(Value: TReportSection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Print;
    procedure PrintDefault;

  published
    property SectionType: TSectionType read FSectionType write SetSectionType;
    property Section: TReportSection read FSection write SetSection;
    property Text: TFormatString read FText write FText;
    property OutputType: TOutputType read FOutputType write FOutputType
     default otText;

    property OnBefore: TTableSectionEvent read FOnBefore write FOnBefore;
    property OnSetup: TTableSectionEvent read FOnSetup write FOnSetup;
    property OnPrint: TTableSectionEvent read FOnPrint write FOnPrint;
    property OnAfter: TTableSectionEvent read FOnAfter write FOnAfter;
  end; { TTableSection }

{*************************************************************************}
{                            class TTablePrinter                          }
{*************************************************************************}
  TTablePrinter = class(TBaseShell)
  protected
    FTableColumns: TList;
    DoHeadings: boolean;
    IsDefault: boolean;
    DefaultProc: byte;

    FDetailTablePrinter: TBaseShell;
    FMasterTablePrinter: TTablePrinter;
    FStartOffset: double;
    FStartPos: double;
    FFont: TFont;
    FPen: TPen;
    FTableSection: array[stReportHeader..stReportFooter] of TTableSection;
    FReprintHeader: boolean;

    FOnInitTable: TTablePrinterEvent;
    FOnInitMaster: TTablePrinterEvent;
    FOnValidateRow: TTablePrinterEvent;
    FOnGetNextRow: TTablePrinterEvent;

    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure SetDetailTablePrinter(Value: TBaseShell);
    procedure InitTableEvent(var Valid: boolean); virtual;
    procedure InitMasterEvent(var Valid: boolean); virtual;
    procedure ValidateRowEvent(var Valid: boolean); virtual;
    procedure GetNextRowEvent(var Valid: boolean); virtual;

    procedure GetChildren(Proc: TGetChildProc{$IFDEF LEVEL3};Root: TComponent{$ENDIF}); override;

    function GetTableColumns: integer;
    function GetTableColumn(Index: integer): TTableColumn;
    function GetTableSection(Index: TSectionType): TTableSection;
    procedure SetFont(Value: TFont);
    procedure SetPen(Value: TPen);
    procedure SetName(const Value: TComponentName); override;
    procedure BeginPage(Sender: TObject);
    procedure EndPage(Sender: TObject);
    procedure ReprintHeaders(PrintingHeader: boolean);
    procedure PrintSection(TableSection: TTableSection);
    procedure InitMaster(var Valid: boolean;
                             Master: TTablePrinter); virtual;
    procedure InitTable(var Valid: boolean); virtual;
    procedure ValidateRow(var Valid: boolean); virtual;
    procedure GetNextRow(var Valid: boolean); virtual;

    procedure PrintRow(ColStream: TStream;
                       RowHeader: TRowHeader;
                       RowOutputType: TOutputType;
                       RowTableItem: TTableItem);
    procedure ReadRow(    ColStream: TStream;
                      var RowHeader: TRowHeader;
                          RowOutputType: TOutputType;
                          RowTableItem: TTableItem);
    procedure ReadBody(ColStream: TStream;
                       OnLevel: word);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AssignParent(TableItem: TTableItem);
    function CreateColumn(Description: TComponentName): TTableColumn; virtual;
    function CreateSection(Description: TComponentName;
                           SectionType: TSectionType): TTableSection; virtual;

    procedure Execute(Report: TBaseReport); override;
    procedure Default(var Valid: boolean);

    property TableColumnList: TList read FTableColumns;
    property TableColumns: integer read GetTableColumns;
    property TableColumn[Index: integer]: TTableColumn read GetTableColumn;
    property TableSection[Index: TSectionType]: TTableSection read GetTableSection;
    property MasterTablePrinter: TTablePrinter read FMasterTablePrinter
     write FMasterTablePrinter;

  published
    property DetailTablePrinter: TBaseShell read FDetailTablePrinter
     write SetDetailTablePrinter;

    property StartPos: double read FStartPos write FStartPos;
    property Font: TFont read FFont write SetFont;
    property Pen: TPen read FPen write SetPen;
    property ReprintHeader: boolean read FReprintHeader write FReprintHeader
     default true;

    property OnInitTable: TTablePrinterEvent read FOnInitTable
     write FOnInitTable;
    property OnInitMaster: TTablePrinterEvent read FOnInitMaster
     write FOnInitMaster;
    property OnValidateRow: TTablePrinterEvent read FOnValidateRow
     write FOnValidateRow;
    property OnGetNextRow: TTablePrinterEvent read FOnGetNextRow
     write FOnGetNextRow;
  end; { TTablePrinter }

  function DescToName(Desc: TComponentName): TComponentName;

implementation

  function DescToName(Desc: TComponentName): TComponentName;

  var
    I1: integer;

  begin { DescToName }
    Result := Desc;
    I1 := 0;
    While I1 < Length(Result) do begin
      Inc(I1);
      If not (Result[I1] in ['0'..'9','A'..'Z','a'..'z','_']) then begin
        Delete(Result,I1,1);
        Dec(I1);
      end; { if }
    end; { if }
  end;  { DescToName }

{$I RPTABITM.PAS}
{$I RPTABSEC.PAS}
{$I RPTABCOL.PAS}

{*************************************************************************}
{                            class TTablePrinter                          }
{*************************************************************************}

  constructor TTablePrinter.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);

    DoHeadings := false;

    FStartOffset := 0.0;
    FTableColumns := TList.Create;
    FFont := TFont.Create;
    FPen := TPen.Create;
    FReprintHeader := true;
    FStartPos := 0.0;
  end;  { Create }

  destructor TTablePrinter.Destroy;

  var
    TableColumn: TTableColumn;
    SectionType: TSectionType;

  begin { Destroy }
  { Delete any TableColumn components }
    While TableColumnList.Count > 0 do begin
      TableColumn := TableColumnList.Last;
      TableColumnList.Remove(TableColumn);
      TableColumn.Free;
    end; { while }
    TableColumnList.Free;

    For SectionType := stReportHeader to stReportFooter do begin
      If FTableSection[SectionType] <> nil then begin
        FTableSection[SectionType].Free;
      end; { if }
    end; { for }

    FPen.Free;
    FFont.Free;

    inherited Destroy;
  end;  { Destroy }

  procedure TTablePrinter.Notification(AComponent: TComponent;
                                         Operation: TOperation);

  begin { Notification }
    inherited Notification(AComponent,Operation);
    If (Operation = opRemove) and (AComponent = FDetailTablePrinter) then begin
      FDetailTablePrinter := nil;
    end; { if }
  end;  { Notification }

  procedure TTablePrinter.SetDetailTablePrinter(Value: TBaseShell);

  begin { SetDetailTablePrinter }
    FDetailTablePrinter := Value;
    If Assigned(Value) then begin
      Value.FreeNotification(self);
    end; { if }
  end;  { SetDetailTablePrinter }

  procedure TTablePrinter.GetChildren(Proc: TGetChildProc
   {$IFDEF LEVEL3};Root: TComponent{$ENDIF});

  var
    I1: integer;
    TableColumn: TTableColumn;
    SectionType: TSectionType;

  begin { GetChildren }
    For I1 := 0 to TableColumnList.Count - 1 do begin
      TableColumn := TableColumnList[I1];
      Proc(TableColumn);
    end; { for }

    For SectionType := stReportHeader to stReportFooter do begin
      If FTableSection[SectionType] <> nil then begin
        Proc(FTableSection[SectionType]);
      end; { if }
    end; { for }
  end;  { GetChildren }

  procedure TTablePrinter.InitTableEvent(var Valid: boolean);

  begin { InitTableEvent }
    If Assigned(FOnInitTable) then begin
      FOnInitTable(self,Valid)
    end; { if }
  end;  { InitTableEvent }

  procedure TTablePrinter.InitMasterEvent(var Valid: boolean);

  begin { InitMasterEvent }
    If Assigned(FOnInitMaster) then begin
      FOnInitMaster(self,Valid)
    end; { if }
  end;  { InitMasterEvent }

  procedure TTablePrinter.ValidateRowEvent(var Valid: boolean);

  begin { ValidateRowEvent }
    If Assigned(FOnValidateRow) then begin
      FOnValidateRow(self,Valid)
    end; { if }
  end;  { ValidateRowEvent }

  procedure TTablePrinter.GetNextRowEvent(var Valid: boolean);

  begin { GetNextRowEvent }
    If Assigned(FOnGetNextRow) then begin
      FOnGetNextRow(self,Valid)
    end; { if }
  end;  { GetNextRowEvent }

  procedure TTablePrinter.AssignParent(TableItem: TTableItem);

  begin { AssignParent }
    TableItem.SetParent(self);
  end;  { AssignParent }

  procedure TTablePrinter.SetFont(Value: TFont);

  var
    I1: integer;
    TableColumn: TTableColumn;
    SectionType: TSectionType;

  begin { SetFont }
    FFont.Assign(Value);

  { Notify all children that font has changed }
    For I1 := 0 to TableColumnList.Count - 1 do begin
      TableColumn := TableColumnList[I1];
      TableColumn.ParentFontChanged;
    end; { for }

    For SectionType := stReportHeader to stReportFooter do begin
      If FTableSection[SectionType] <> nil then begin
        FTableSection[SectionType].ParentFontChanged;
      end; { if }
    end; { for }
  end;  { SetFont }

  procedure TTablePrinter.SetPen(Value: TPen);

  begin { SetPen }
    FPen.Assign(Value);
  end;  { SetPen }

  function TTablePrinter.CreateColumn(Description: TComponentName): TTableColumn;

  begin { CreateColumn }
    Result := TTableColumn.Create(Owner);
    Result.FDescription := Description;
    Result.Name := Name + DescToName(Description);
    AssignParent(Result);
  end;  { CreateColumn }

  function TTablePrinter.CreateSection(Description: TComponentName;
                                       SectionType: TSectionType): TTableSection;

  begin { CreateSection }
    Result := TTableSection.Create(Owner);
    Result.FDescription := Description;
    Result.Name := Name + DescToName(Description);
    AssignParent(Result);
    Result.SectionType := SectionType;
  end;  { CreateSection }

  procedure TTablePrinter.SetName(const Value: TComponentName);

  var
    I1: integer;
    SectionType: TSectionType;
    OldLen: integer;
    OldName: TComponentName;
    ItemName: TComponentName;

  begin
    OldName := Name;
    inherited SetName(Value);

    If (csDesigning in ComponentState) and (Name <> OldName) then begin
      OldLen := Length(OldName);
      For I1 := 1 to TableColumns do begin
        ItemName := TableColumn[I1].Name;
        If Copy(ItemName,1,OldLen) = OldName then begin
          TableColumn[I1].Name := Name + Copy(ItemName,OldLen + 1,
           Length(ItemName) - OldLen);
        end; { if }
      end; { for }

      For SectionType := stReportHeader to stReportFooter do begin
        If TableSection[SectionType] <> nil then begin
          ItemName := TableSection[SectionType].Name;
          If Copy(ItemName,1,OldLen) = OldName then begin
            TableSection[SectionType].Name := Name + Copy(ItemName,OldLen + 1,
             Length(ItemName) - OldLen);
          end; { if }
        end; { if }
      end; { for }
    end; { if }
  end;  { SetName }

  function TTablePrinter.GetTableColumns: integer;

  begin { GetTableColumns }
    Result := TableColumnList.Count;
  end;  { GetTableColumns }

  function TTablePrinter.GetTableColumn(Index: integer): TTableColumn;

  begin { GetTableColumn }
    Result := TableColumnList[Index - 1];
  end;  { GetTableColumn }

  function TTablePrinter.GetTableSection(Index: TSectionType): TTableSection;

  begin { GetTableSection }
    If Index = stNone then begin
      Result := nil;
    end else begin
      Result := FTableSection[Index];
    end; { else }
  end;  { GetTableSection }

{ Output methods }

  procedure TTablePrinter.ReprintHeaders(PrintingHeader: boolean);

  begin { ReprintHeaders }
  { Process through headers and reprint }
    If Assigned(FMasterTablePrinter) then begin
      MasterTablePrinter.ReprintHeaders(false);
    end; { if }

    If ReprintHeader and not PrintingHeader then begin { Print any otHeadings headers }
      If (TableSection[stReportHeader] <> nil) and
       (TableSection[stReportHeader].OutputType = otHeadings) then begin
        TableSection[stReportHeader].Print;
      end; { if }
      If (TableSection[stBodyHeader] <> nil) and
       (TableSection[stBodyHeader].OutputType = otHeadings) then begin
        TableSection[stBodyHeader].Print;
      end; { if }
      If (TableSection[stGroupHeader] <> nil) and
       (TableSection[stGroupHeader].OutputType = otHeadings) then begin
        TableSection[stGroupHeader].Print;
      end; { if }
    end; { if }
  end;  { ReprintHeaders }

  procedure TTablePrinter.PrintSection(TableSection: TTableSection);

  var
    ColStream: TMemoryStream;
    RowHeader: TRowHeader;

  begin { PrintSection }
    ColStream := TMemoryStream.Create;
    try
      ColStream.SetSize(65536);
      ReadRow(ColStream,RowHeader,TableSection.OutputType,TableSection);
      TableSection.Section.SetupSection(ReportPrinter);
      If TableSection.SectionType = stPageFooter then begin
        ReportPrinter.SectionBottom := 999.0; { Don't create page break }
      end; { if }
      PrintRow(ColStream,RowHeader,TableSection.OutputType,TableSection)
    finally
      ColStream.Free;
    end; { tryf }
  end;  { PrintSection }

  procedure TTablePrinter.PrintRow(ColStream: TStream;
                                   RowHeader: TRowHeader;
                                   RowOutputType: TOutputType;
                                   RowTableItem: TTableItem);

  var
    Col: integer;
    X1: double;
    Y1,Y2: double;
    Height: double;
    ColHeaderPos: longint;
    ColHeader: TColHeader;
    MaxLeft: double;
    LastMaxLeft: double;
    MinLeft: double;

  begin { PrintRow }
    With ReportPrinter do begin

    { Process through the columns }
      Repeat
        ColStream.Position := 0;
        MaxLeft := 999999.0;
        Height := SectionBottom - SectionTop;
        If Height < RowHeader.MinHeight then begin { Goto next page }
          NewPage;
          ReprintHeaders(RowOutputType = otHeadings);
          Height := SectionBottom - SectionTop;
        end; { if }
        If Height > RowHeader.Height then begin
          Height := RowHeader.Height + 0.001;
        end; { if }
        X1 := StartPos;
        Y1 := LineTop;
        Y2 := Y1 + Height;
        LastMaxLeft := MaxLeft;
        MaxLeft := 0.0;
        MinLeft := 0.0;
        For Col := 1 to RowHeader.Columns do begin
        { Set up section }
          SectionLeft := X1;
          SectionRight := X1 + TableColumn[Col].Width;
          SectionTop := Y1;
          SectionBottom := Y2;

        { Read in column header }
          ColHeaderPos := ColStream.Position;
          ColStream.ReadBuffer(ColHeader,SizeOf(ColHeader));

        { Print this column }
          If not (RowOutputType in [otPageTotals..otGrandTotals]) or
           TableColumn[Col].Totals then begin
            TableColumn[Col].OutputType := RowOutputType;
            If Assigned(RowTableItem) then begin
              RowTableItem.Width := TableColumn[Col].Width;
              TableColumn[Col].TableItem := RowTableItem;
            end else begin
              TableColumn[Col].TableItem := TableColumn[Col];
            end; { else }
            TableColumn[Col].PrintRow(ColStream,ColHeader,Height);
            If ColHeader.Height > MaxLeft then begin
              MaxLeft := ColHeader.Height;
            end; { if }
            If ColHeader.MinHeight > MinLeft then begin
              MinLeft := ColHeader.MinHeight;
            end; { if }
          end; { if }

        { Write out modified column header }
          ColStream.Position := ColHeaderPos;
          ColStream.WriteBuffer(ColHeader,SizeOf(ColHeader));
          ColStream.Position := ColStream.Position + ColHeader.DataSize;

          X1 := X1 + TableColumn[Col].Width;
        end; { for }
        If LastMaxLeft = MaxLeft then Break; { Making no progress }
        RowHeader.Height := MaxLeft;
        RowHeader.MinHeight := MinLeft;
        SectionTop := Y2; { Position the cursor for next row }
        SectionBottom := PageHeight - MarginBottom;
        LineTop := SectionTop;
      until RowHeader.Height = 0.0;
    end; { with }
  end;  { PrintRow }

  procedure TTablePrinter.ReadRow(    ColStream: TStream;
                                  var RowHeader: TRowHeader;
                                      RowOutputType: TOutputType;
                                      RowTableItem: TTableItem);

  var
    Col: word;
    ColHeader: TColHeader;
    ColHeaderPos: longint;
    SavePos: longint;

  begin { ReadRow }
  { Init RowHeader }
    ColStream.Position := 0;
    With RowHeader do begin
      Height := 0.0;
      MinHeight := 0.0;
      Columns := 0;
    end; { with }

  { Read each column }
    For Col := 1 to TableColumns do begin
      With TableColumn[Col] do begin
      { Init ColHeader }
        With ColHeader do begin
          DataSize := 0;
          FontSize := 0;
          Height := 0.0;
          StartLine := 1;
          Lines := 0;
        end; { with }

      { Reserve space for ColHeader }
        ColHeaderPos := ColStream.Position;
        ColStream.WriteBuffer(ColHeader,SizeOf(ColHeader));

      { Get and Save Column Data }
        OutputType := RowOutputType;
        If Assigned(RowTableItem) then begin
          RowTableItem.Width := TableColumn[Col].Width;
          TableItem := RowTableItem;
        end else begin
          TableItem := TableColumn[Col];
        end; { else }
        GetRow(ColStream,ColHeader);

      { Write updated Column Header }
        SavePos := ColStream.Position;
        ColStream.Position := ColHeaderPos;
        ColStream.WriteBuffer(ColHeader,SizeOf(ColHeader));
        ColStream.Position := SavePos;

      { Add Column Info to RowHeader }
        With RowHeader do begin
          If ColHeader.Height > Height then begin
            Height := ColHeader.Height;
          end; { if }
          If ColHeader.MinHeight > MinHeight then begin
            MinHeight := ColHeader.MinHeight;
          end; { if }
          Inc(Columns);
        end; { with }
      end; { with }
    end; { for }
  end;  { ReadRow }

  procedure TTablePrinter.ReadBody(ColStream: TStream;
                                   OnLevel: word);

  var
    Valid: boolean;
    DetailValid: boolean;
    RowHeader: TRowHeader;
    TP: TTablePrinter;

  begin { ReadBody }
  { Print the Body Header }
    If TableSection[stBodyHeader] <> nil then begin
      TableSection[stBodyHeader].Print;
    end; { if }
    try
    { Initialize the Table }
      Valid := Assigned(FOnInitTable) or Assigned(FOnValidateRow) or
       Assigned(FOnGetNextRow);
      InitTable(Valid);

      While Valid do begin
      { Validate current Row }
        ValidateRow(Valid);
        If Valid then begin
        { Print Group Header }
          If TableSection[stGroupHeader] <> nil then begin
            TableSection[stGroupHeader].Print;
          end; { if }

        { Read and print Row }
          ReadRow(ColStream,RowHeader,otText,nil);
          With ReportPrinter do begin
            SectionTop := LineTop;
            SectionBottom := PageHeight - MarginBottom;
          end; { with }
          PrintRow(ColStream,RowHeader,otText,nil);

        { Call Detail TablePrinter }
          If Assigned(FDetailTablePrinter) then begin
            DetailValid := true;
            TP := FDetailTablePrinter as TTablePrinter;
            TP.ReportPrinter := ReportPrinter;
            TP.InitMaster(DetailValid,self);
            If DetailValid then begin
              TP.ReadBody(ColStream,OnLevel + 1);
            end; { if }
          end; { if }

        { Print Group Footer }
          If TableSection[stGroupFooter] <> nil then begin
            TableSection[stGroupFooter].Print;
          end; { if }
        end; { if }
        GetNextRow(Valid);
      end; { while }
    finally
    { Print the Body Footer }
      If TableSection[stBodyFooter] <> nil then begin
        TableSection[stBodyFooter].Print;
      end; { if }
    end; { tryf }
  end;  { ReadBody }

  procedure TTablePrinter.BeginPage(Sender: TObject);

  var
    Col: integer;

  begin { BeginPage }
    If TableSection[stPageHeader] <> nil then begin
      ReportPrinter.PushPos;
      TableSection[stPageHeader].Print;
      ReportPrinter.PopPos;
    end; { if }
    For Col := 1 to TableColumns do begin
      TableColumn[Col].InitPage;
    end; { for }
  end;  { BeginPage }

  procedure TTablePrinter.EndPage(Sender: TObject);

  begin { EndPage }
    If TableSection[stPageFooter] <> nil then begin
      ReportPrinter.PushPos;
      TableSection[stPageFooter].Print;
      ReportPrinter.PopPos;
    end; { if }
  end;  { EndPage }

  procedure TTablePrinter.InitTable(var Valid: boolean);

  begin { InitTable }
    DefaultProc := 1;
    If not IsDefault then begin
      InitTableEvent(Valid);
    end; { if }
  end;  { InitTable }

  procedure TTablePrinter.InitMaster(var Valid: boolean;
                                         Master: TTablePrinter);

  var
    Col: integer;

  begin { InitMaster }
    DefaultProc := 2;
    If Assigned(Master) then begin
      MasterTablePrinter := Master;
    end; { if }
    If not IsDefault then begin
      InitMasterEvent(Valid);
    end; { if }
    For Col := 1 to TableColumns do begin
      TableColumn[Col].InitMaster;
    end; { for }
  end;  { InitMaster }

  procedure TTablePrinter.ValidateRow(var Valid: boolean);

  begin { ValidateRow }
    DefaultProc := 3;
    If not IsDefault then begin
      ValidateRowEvent(Valid);
    end; { if }
  end;  { ValidateRow }

  procedure TTablePrinter.GetNextRow(var Valid: boolean);

  begin { GetNextRow }
    DefaultProc := 4;
    If not IsDefault then begin
      GetNextRowEvent(Valid);
    end; { if }
  end;  { GetNextRow }

  procedure TTablePrinter.Execute(Report: TBaseReport);

  var
    ColStream: TMemoryStream;
    TablePrinter: TTablePrinter;
    Col: integer;

  begin { Execute }
  { Init Report Items }
    If InitEngine(Report) then begin
      TablePrinter := self;
      While Assigned(TablePrinter) do begin
        With TablePrinter do begin
          For Col := 1 to TableColumns do begin
            TableColumn[Col].Init;
          end; { for }
        end; { with }
        TablePrinter := TablePrinter.DetailTablePrinter as TTablePrinter;
      end; { while }

      With ReportPrinter do begin
        Canvas.Font := Font;
        AdjustLine;
        SectionTop := LineTop;
        Home;
      end; { with }
      ReportPrinter.AddReportEvent(reBeginPage,BeginPage);
      ReportPrinter.AddReportEvent(reEndPage,EndPage);
      try
      { Print Report Header }
        If TableSection[stReportHeader] <> nil then begin
          TableSection[stReportHeader].Print;
        end; { if }

      { Print First Page Header }
        If TableSection[stPageHeader] <> nil then begin
          TableSection[stPageHeader].Print;
        end; { if }

      { Init the first group }
        ColStream := TMemoryStream.Create;
        try
          ColStream.SetSize(65536);
          ReadBody(ColStream,1);
        finally
          ColStream.Free;
        end; { tryf }

      { Print Last Page Footer }
        If TableSection[stPageFooter] <> nil then begin
          TableSection[stPageFooter].Print;
        end; { if }

      { Print Report Footer }
        If TableSection[stReportFooter] <> nil then begin
          TableSection[stReportFooter].Print;
        end; { if }
      finally
      { Finish Report Items }
        ReportPrinter.RemoveReportEvent(reBeginPage,BeginPage);
        ReportPrinter.RemoveReportEvent(reEndPage,EndPage);
        ReportPrinter := nil;
      end; { tryf }
    end; { if }
  end;  { Execute }

  procedure TTablePrinter.Default(var Valid: boolean);

  begin { Default }
    If DefaultProc > 0 then begin
      IsDefault := true;
      Case DefaultProc of
        1: InitTable(Valid);
        2: InitMaster(Valid,nil);
        3: ValidateRow(Valid);
        4: GetNextRow(Valid);
      end; { case }
      DefaultProc := 0;
      IsDefault := false;
    end; { if }
  end;  { Default }

end.