unit TestFormTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise04_TLB, StdCtrls, TestConst;

type
  TfrmTestTemplate = class(TForm)
    lblProgress: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  protected
    oToolkit : IToolkit;
    FDataPath : string;
    FTestName : string;
    FMessageHandle : THandle;
    FirstTime : Boolean;
    FResult : longint;
    FWParam : Word;
    FExtraParam : string;
    FExtraParamList : TStringList;
    FRunning : Boolean;
    function ReadParams : Boolean;
    procedure RunTest; virtual; abstract;
    procedure DoProgress(const s : string);
    procedure SplitExtraParam;
    function StringToDocType(const s : string) : TDocTypes;
    procedure ChangeToolkitSettings; virtual;
    procedure ShowDebug(const s : string);
  public
    { Public declarations }
    procedure WMRunTest(var Message : TMessage); Message WM_RUNTEST;
  end;

var
  frmTestTemplate: TfrmTestTemplate;

implementation

{$R *.dfm}
uses
  CtkUtil04,
  ApiUtil;

type
  TDocTypeString = Record
    dtString : string[3];
    dtType   : TDocTypes;
  end;

const
  LastDocString = 9;
  DocStrings : Array[0..LastDocString] of TDocTypeString = (
                                                             (dtString:'SIN'; dtType: dtSIN),
                                                             (dtString:'SOR'; dtType: dtSOR),
                                                             (dtString:'SDN'; dtType: dtSDN),
                                                             (dtString:'PIN'; dtType: dtPIN),
                                                             (dtString:'POR'; dtType: dtPOR),
                                                             (dtString:'PDN'; dtType: dtPDN),
                                                             (dtString:'SRC'; dtType: dtSRC),
                                                             (dtString:'PPY'; dtType: dtPPY),
                                                             (dtString:'SRI'; dtType: dtSRI),
                                                             (dtString:'PPI'; dtType: dtPPI)
                                                           );



procedure TfrmTestTemplate.FormCreate(Sender: TObject);
begin
  FirstTime := True;
  FResult := 0;
  FWParam := E_SUCCESS;
  FExtraParamList := TStringList.Create;
  FRunning := False;
  ShowDebug('About to run');
end;

procedure TfrmTestTemplate.FormDestroy(Sender: TObject);
begin
  oToolkit := nil;
end;

function TfrmTestTemplate.ReadParams: Boolean;
begin
  if ParamCount > 0 then
    FMessageHandle := THandle(StrToInt(ParamStr(1))); //Find message handle first to enable error messages to be sent

  Result := ParamCount >= 3;
  if Result then
  begin
    FTestName := ParamStr(2);
    FDataPath := ParamStr(3);
    if ParamCount > 3 then
      FExtraParam := ParamStr(4)
    else
      FExtraParam := '';
  end;
end;


procedure TfrmTestTemplate.FormActivate(Sender: TObject);
var
  Res : Integer;
begin
  if FirstTime then
  begin
    FirstTime := False;
    oToolkit := CreateToolkitWithBackDoor;
    if ReadParams then
    begin
      FRunning := True;
      Caption := FTestName;
      oToolkit.Configuration.DataDirectory := FDataPath;
      ChangeToolkitSettings;
      FResult := oToolkit.OpenToolkit;
      if FResult = 0 then
      begin
        //Kick off the RunTest procedure
        PostMessage(Handle, WM_RUNTEST, 0, 0);
      end
      else
        FWParam := E_OPEN_TOOLKIT;

    end
    else
    begin
      FWParam := E_INVALID_PARAMS;
      FResult := 0;
    end;

    if FWParam <> E_SUCCESS then
       Close;
  end;
end;

procedure TfrmTestTemplate.DoProgress(const s: string);
begin
  lblProgress.Caption := s;
  lblProgress.Refresh;
  Application.ProcessMessages;
end;

procedure TfrmTestTemplate.WMRunTest(var Message: TMessage);
begin
  RunTest;
  FRunning := False;
  Close;
end;

procedure TfrmTestTemplate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FMessageHandle > 0 then
    PostMessage(FMessageHandle, WM_TESTPROGRESS, FWParam, FResult);
end;

procedure TfrmTestTemplate.SplitExtraParam;
begin
  FExtraParamList.CommaText := FExtraParam;
  ShowDebug('Param List Count = ' + IntToStr(FExtraParamList.Count));
end;

function TfrmTestTemplate.StringToDocType(const s: string): TDocTypes;
var
  i : integer;
begin
  Result := dtSIN;
  for i := 0 to LastDocString do
    if UpperCase(s) = DocStrings[i].dtString then
    begin
      Result := DocStrings[i].dtType;
      Break;
    end;
end;

procedure TfrmTestTemplate.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := (not FRunning) or
              (msgBox('Test is still running. Are you sure you want to close?', mtConfirmation,
                      [mbYes, mbNo], mbNo, 'Test running') = mrYes);
end;

procedure TfrmTestTemplate.ChangeToolkitSettings;
begin

end;

procedure TfrmTestTemplate.ShowDebug(const s: String);
begin
  if FileExists('c:\DebugTestApp.txt') then
    ShowMessage(s);
end;

end.
