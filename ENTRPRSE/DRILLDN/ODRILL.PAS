unit oDrill;

{$ALIGN 1}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, Windows, StdVcl, SysUtils,
  Forms, Messages,
  Enterprise_TLB;           // Drill-Down COM Object Type Library

type
  TDrillDown = class(TAutoObject, IConnectionPointContainer, IDrillDown)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: IDrillDownEvents;
  protected
    { Protected declarations }
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    function DrillDown(const DrillStr: WideString): TDrillDownResult; safecall;
    procedure DisplayAbout(const AddInVer: WideString); safecall;
  public
    procedure Initialize; override;
    Destructor Destroy; override;

    Function  GetCellInfo (Const CellRef : ShortString; Var CellValue, CellFormula : ShortString) : Boolean;
    Procedure SetWindowFocus (Const WindowHandle : THandle);
    Procedure UpdateCellFormula (Const NewFormula : ShortString);
  end;

implementation

uses ComServ,
     ProcFunc,      // Drill-Down Object
     FuncParser,    // Function Parser Object
     FuncList,      // FunctionList object
     DrillLog,      // DrillDownLog object
     History,       // History of Changes
     ExchequerRelease,
     DDAboutF;      // Drill-Down About Form

//=============================================================================

procedure TDrillDown.Initialize;
begin
  inherited Initialize;
  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect)
  else FConnectionPoint := nil;
end;

//-----------------------------------

Destructor TDrillDown.Destroy;
begin
  PostMessage (Application.MainForm.Handle, WM_CLOSE, 0, 0);

  Inherited;
end;

//-----------------------------------------------------------------------------

// Dunno what this does - something to do with the Events so don't change it
procedure TDrillDown.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IDrillDownEvents;
end;

//-----------------------------------------------------------------------------

// Called from the Excel Add-In to execute the Drill-Down process
//
// DrillStr    The contents of the cell that the user double-clicked on.
//
function TDrillDown.DrillDown(const DrillStr: WideString): TDrillDownResult;
Var
  oFunctionParser  : TFunctionParser;
  oProcessFunction : TProcessFunction;
  OK               : Boolean;
begin { DrillDown }
  // Return No-Action as default return value
  Result := ddNoAction;

  // Clear any previous logging details and start a new drill-down report
  DrillDownLog.ClearLog;
  DrillDownLog.AddString ('DrillDown Request for "' + DrillStr + '"');
  DrillDownLog.AddString ('Requested at ' + FormatDateTime ('HH:MM.ss', Now));
  DrillDownLog.BlankLine;

  // Create a Function-Parser object to break down the string from Excel
  oFunctionParser := TFunctionParser.Create;
  Try
    // Perform basic parsing on formula to identify function and parameters
    // HM 04/08/03: Convert formula to uppercase to avoid case sensitivity issues
    OK := oFunctionParser.ParseFormula (UpperCase(DrillStr));

    // Check Result to see if its a valid function we are interested in
    If OK Then Begin
      // Create a Drill-Down object to complete the wotsit
      oProcessFunction := TProcessFunction.Create(Self, oFunctionParser);
      Try
        Case oProcessFunction.ProcessFormula Of
          frNoAction      : Result := ddNoAction;

          frDrillOK       : Result := ddDrillDownExecuted;

          frUpdateFormula : Result := ddUpdateCellFormula;

          frException     : Result := ddNoAction;
        End; { Case oProcessFunction.ProcessFormula }
      Finally
        FreeAndNIL(oProcessFunction);
      End;
    End; { If OK }
  Finally
    FreeAndNIL(oFunctionParser);
  End;
end; { DrillDown }

//-----------------------------------------------------------------------------------------

// Generates the OnResolveCellReference event so that the Excel Add-In can process the
// Cell Reference and return its value
//
// CellRef      The reference to the cell - "$B$6"
// CellValue    The returned value of the cell
// CellFormula  The returned formula (if any) from the cell
//
Function TDrillDown.GetCellInfo (Const CellRef : ShortString; Var CellValue, CellFormula : ShortString) : Boolean;
Var
  CellVal  : WideString;
  CellFmla : WideString;
  OK       : WordBool;
Begin { GetCellInfo }
  CellVal := CellValue;
  CellVal := CellFormula;
  OK      := False;
  FEvents.OnResolveCellReference(CellRef, CellVal, CellFmla, OK);
  If OK Then Begin
    CellValue := CellVal;
    CellFormula := CellFmla;
  End; { If OK }
  Result := OK;
End; { GetCellInfo }

//-----------------------------------------------------------------------------------------

Procedure TDrillDown.UpdateCellFormula (Const NewFormula : ShortString);
Begin { UpdateCellFormula }
  FEvents.OnChangeCellFormula(NewFormula);
End; { UpdateCellFormula }

//-----------------------------------------------------------------------------------------

Procedure TDrillDown.SetWindowFocus (Const WindowHandle : THandle);
Begin { SetWindowFocus }
  FEvents.OnSetWindowFocus(WindowHandle);
End; { SetWindowFocus }

//-------------------------------------------------------------------------

procedure TDrillDown.DisplayAbout(const AddInVer: WideString);
begin
  With TfrmAbout.Create (Application.MainForm) Do
    Try
      lblExcelAddInVer.Caption := ExchequerModuleVersion (emExcelDrillDownAddIn, AddInVer);
      lblCOMServerVer.Caption := DrillDownVer;

      ShowModal;
    Finally
      Free;
    End;
end;

//=============================================================================

initialization
  TAutoObjectFactory.Create(ComServer, TDrillDown, Class_DrillDown,
    ciSingleInstance, tmApartment);
end.
