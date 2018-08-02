unit TestMain;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AxCtrls, PlugTest_TLB, StdVcl, ExScheduler_TLB, DetailsF, Enterprise01_TLB;

type
  TScheduleTest = class(TAutoObject, IConnectionPointContainer, IScheduleTest, IScheduledTask)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: IScheduledTaskEvents;
    FName : string;
    FDataPath : string;
    FDetailsForm : TfrmDetails;
    oToolkit : IToolkit;
  public
    procedure Initialize; override;
  protected
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    procedure ThisEventConnect(const Sink: IUnknown;  Connecting: Boolean);
    function Test: WideString; safecall;
    { Protected declarations }
    function Get_stType: WideString; safecall;
    function Get_stName: WideString; safecall;
    procedure Set_stName(const Value: WideString); safecall;
    procedure ShowDetails(DisplayWindow: Integer); safecall;
    procedure FreeDetails; safecall;
    procedure Run; safecall;
    procedure Load; safecall;
    procedure Save; safecall;
    function Get_stFirstControl: Integer; safecall;
    function Get_stNextControl: Integer; safecall;
    procedure Set_stNextControl(Value: Integer); safecall;
    function Get_stPrevControl: Integer; safecall;
    procedure Set_stPrevControl(Value: Integer); safecall;
    function Get_stLastControl: Integer; safecall;
    function Get_stDataPath: WideString; safecall;
    procedure Set_stDataPath(const Value: WideString); safecall;
  end;

implementation

uses ComServ, Classes, SysUtils, Windows, Silencer;



procedure TScheduleTest.EventSinkChanged(const EventSink: IInterface);
begin
  FEvents := EventSink as IScheduledTaskEvents;
end;

procedure TScheduleTest.FreeDetails;
begin
  FreeAndNil(FDetailsForm);
end;

function TScheduleTest.Get_stDataPath: WideString;
begin
  Result := FDataPath;
end;

//We need to supply the first and last controls in our tab order to the host so it can set focus correctly
function TScheduleTest.Get_stFirstControl: Integer;
begin
  if Assigned(FDetailsForm) then
    Result := FDetailsForm.Edit1.Handle;
end;

function TScheduleTest.Get_stLastControl: Integer;
begin
  if Assigned(FDetailsForm) then
    Result := FDetailsForm.Edit2.Handle;
end;

function TScheduleTest.Get_stName: WideString;
begin
  Result := FName;
end;

function TScheduleTest.Get_stNextControl: Integer;
begin
  if Assigned(FDetailsForm) then
    Result := FDetailsForm.NextControl;
end;

function TScheduleTest.Get_stPrevControl: Integer;
begin
  if Assigned(FDetailsForm) then
    Result := FDetailsForm.PrevControl;
end;

function TScheduleTest.Get_stType: WideString;
//This is the text that will be displayed in the 'Type' column in the scheduler list
begin
  Result := 'Schedule Test';
end;


procedure TScheduleTest.Initialize;
begin
  inherited Initialize;
  FConnectionPoints := TConnectionPoints.Create(Self);
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      IScheduledTaskEvents, ckSingle, ThisEventConnect)
end;

procedure TScheduleTest.Load;
//This procedure will load the data for the task. The 'Name' property will already have been set
//before this is called.
var
  F : TextFile;
  s : string;
begin
  Try
    AssignFile(F, 'c:\' + FName + '.ini');
    Reset(F);
    ReadLn(F, OutputFile);
    CloseFile(F);
  Except
  End;
end;

procedure TScheduleTest.Run;
//The main functionality of the plugin.
var
  Res : integer;
  F : TextFile;
  OutString : string;
  //Variables to calculate percentage done to show on progress bar
  CustTotal, CustSoFar : Double;
  CustPercent : Integer;
begin
//Although we're running in a thread there's no need to call CoInitialize
  oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
  if Assigned(oToolkit) then
  Try

    //Data directory is in FDataPath - set by host before calling Run procedure
    oToolkit.Configuration.DataDirectory := FDataPath;
    Res := oToolkit.OpenToolkit;
    if Res = 0 then
    with oToolkit do
    begin

      //Find total customers in database
      CustTotal := 0;
      Res := Customer.GetFirst;
      while Res = 0 do
      begin
        CustTotal := CustTotal + 1;

        Res := Customer.GetNext;
      end;

      //Open output file
      AssignFile(F, OutputFile);
      Rewrite(F);
      Try
        //
        CustSoFar := 0;
        Res := Customer.GetFirst;

        //Iterate through all customers and output name and code to file
        while Res = 0 do
        begin
          OutString := Customer.acCode + ',' + Customer.acCompany;

          //Calculate percentage done
          CustSoFar := CustSoFar + 1;
          CustPercent := Trunc((CustSoFar / CustTotal) * 100);

          //Show progress
          if Assigned(FEvents) then
            FEvents.OnProgress(OutString, CustPercent);

          //Ouput line
          WriteLn(F, OutString);
          SleepEx(100, True);

          Res := Customer.GetNext;
        end;
      Finally
        CloseFile(F);
      End;

    end
    else
      raise Exception.Create('Unable to open COM Toolkit'#10'Error: ' +
                             oToolkit.LastErrorString );
  Finally
    oToolkit := nil;
  End
  else
    raise Exception.Create('Unable to create COM Toolkit');
end;

procedure TScheduleTest.Save;
//Save the data for this task
var
  F : TextFile;
begin
  FDetailsForm.Save;
  AssignFile(F, 'c:\' + FName + '.ini');
  Rewrite(F);
  WriteLn(F, OutputFile);
  CloseFile(F);
end;


procedure TScheduleTest.Set_stDataPath(const Value: WideString);
//The Exchequer company data path from where the task is being loaded.
begin
  FDataPath := Value;
end;

procedure TScheduleTest.Set_stName(const Value: WideString);
//The name of the task as set in the Scheduler
begin
  FName := Value;
end;

procedure TScheduleTest.Set_stNextControl(Value: Integer);
//This is provided by the Scheduler and is the handle of the next control in the tab order.
//When we enter the (hidden) last control on the form then we need to set focus to this control
begin
  if Assigned(FDetailsForm) then
    FDetailsForm.NextControl := Value;
end;

procedure TScheduleTest.Set_stPrevControl(Value: Integer);
//This is provided by the Scheduler and is the handle of the previous control in the tab order
//When we enter the (hidden) first control on the form then we need to set focus to this control
begin
  if Assigned(FDetailsForm) then
    FDetailsForm.PrevControl := Value;
end;

procedure TScheduleTest.ShowDetails(DisplayWindow: Integer);
//Create and display a configuration form in the supplied window
begin
  FDetailsForm := ShowDetailsWindow(HWND(DisplayWindow));
end;

procedure TScheduleTest.ThisEventConnect(const Sink: IUnknown;
  Connecting: Boolean);
var
  LEventSink : IUnknown;
begin
  if Connecting then
  begin
    OleCheck(Sink.QueryInterface(IScheduledTaskEvents, LEventSink));
    EventSink := LEventSink;
    EventSinkChanged(TMyDispatchSilencer.Create(Sink, IScheduledTaskEvents));
  end
  else
  begin
    EventSink := nil;
    EventSinkChanged(nil);
  end;
end;

function TScheduleTest.Test: WideString;
begin
  Result := 'Test Result';
end;

initialization
  TAutoObjectFactory.Create(ComServer, TScheduleTest, Class_ScheduleTest,
    ciSingleInstance, tmApartment);
end.
