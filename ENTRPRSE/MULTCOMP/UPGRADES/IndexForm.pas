unit IndexForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise01_TLB, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    lbCompanies: TListBox;
    Label1: TLabel;
    btnDeleteIndex: TButton;
    btnAddIndex: TButton;
    btnClose: TButton;
    StatusBar: TStatusBar;
    Edit1: TEdit;
    udIndex: TUpDown;
    Label2: TLabel;
    btnSelect: TButton;
    btnUnselect: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDeleteIndexClick(Sender: TObject);
    procedure btnAddIndexClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnUnselectClick(Sender: TObject);
  private
    { Private declarations }
    oToolkit : IToolkit;
    IndexToDelete : Integer;
    FErrorLog : TStringList;
    HasErrors : Boolean;
    StatusString : string;
    procedure DeleteIndex(WhichCompany : Integer);
    function GetCompanyDataPath(WhichCompany : Integer) : string;
    procedure LogError(ErrorNo : Integer);
    procedure ShowErrorLog(const ACaption : string);
    procedure SaveErrorLog;
    procedure AddIndex(WhichCompany : Integer);
    procedure SetAll(TurnOn : Boolean);
    procedure EnableButtons(Enable : Boolean);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  CtkUtil, APIUtil, IdxObj, BtrvU2, ErrorLogForm;

const
  DETAILS_FILE_NAME = 'TRANS\DETAILS.DAT';
  LOG_FILE_NAME = 'Index.log';

  //Position and size for JobCode Index
  IDX_POSITION = 203;
  IDX_LENGTH = 10;

  ADD_INDEX_NUMBER = 13;


procedure TForm1.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  //Initialise Error Log

  FErrorLog := TStringList.Create;
  HasErrors := False;

  //Create Toolkit
  oToolkit := CreateToolkitWithBackdoor;

  //Fill Company List
  if Assigned(oToolkit) then
  begin
    for i := 1 to oToolkit.Company.cmCount do
      with oToolkit.Company do
        lbCompanies.Items.Add(Trim(cmCompany[i].coName) + '  (' + cmCompany[i].coCode + ')');
  end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  oToolkit := nil;
  if HasErrors then
    SaveErrorLog;
  FErrorLog.Free;
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.btnDeleteIndexClick(Sender: TObject);
var
  i : Integer;
  WhichCo : Integer;
begin
  if lbCompanies.SelCount > 0 then
  begin
    IndexToDelete := udIndex.Position;

    for i := 0 to lbCompanies.Count - 1 do
    begin
      if lbCompanies.Selected[i] then
      begin
        WhichCo := i + 1; //companies array in toolkit is 1-based so increment company number here
        StatusString := 'Deleting Index No. ' + IntToStr(IndexToDelete) +
                                  ' for ' + oToolkit.Company.cmCompany[WhichCo].coCode;
        StatusBar.SimpleText := 'Please wait... ' + StatusString;

        FErrorLog.Add(' ');
        FErrorLog.Add(StatusString);
        FErrorLog.Add(StringOfChar('=', Length(StatusString)));
        FErrorLog.Add(' ');

        Screen.Cursor := crHourGlass;
        EnableButtons(False);
        Try
          DeleteIndex(WhichCo);
        //If an error occurred then don't process any further countries
        if HasErrors then
          Break;
        Finally
          EnableButtons(True);
          Screen.Cursor := crDefault;
        End;
      end; //lbCompanies.Selected[i]

    end; //for i := 0 to lbCompanies.Count - 1

    if HasErrors then
    begin
      StatusBar.SimpleText := 'Errors';
      ShowErrorLog('Delete Index');
    end
    else
    begin
      StatusBar.SimpleText := 'Process Complete';
      ShowMessage('Process complete');
    end;
  end //lbCompanies.SelCount > 0
  else
    msgBox('No companies selected', mtInformation, [mbOK], mbOK, 'Delete Index');
end;

procedure TForm1.DeleteIndex(WhichCompany: Integer);
var
  oIndex : TDropIndex;
  Res : Integer;
begin
  oIndex := TDropIndex.Create;
  Try
    oIndex.FileName := GetCompanyDataPath(WhichCompany) + DETAILS_FILE_NAME;
    Res := oIndex.DropIndex(IndexToDelete);
    LogError(Res);
  Finally
    oIndex.Free;
  End;
end;

function TForm1.GetCompanyDataPath(WhichCompany: Integer): string;
begin
  with oToolkit.Company do
    Result := Trim((cmCompany[WhichCompany] as ICompanyDetail2).coPath);
end;

procedure TForm1.LogError(ErrorNo: Integer);
var
  ErrorMessage : String;
begin
  Case ErrorNo of  //Specific drop/add index errors
     6 : ErrorMessage := 'Invalid Index Number (' + IntToStr(IndexToDelete) + ')';
    22 : ErrorMessage := 'Data Buffer Length';
    27 : ErrorMessage := 'Invalid Key Position';
    41 : ErrorMessage := 'Operation Not Allowed';
    45 : ErrorMessage := 'Inconsistent Key Flags';
    49 : ErrorMessage := 'Key Type Error';
    56 : ErrorMessage := 'Incomplete Index';
    else
     if ErrorNo > 1000 then //Open file errors
       ErrorMessage := 'Error ' + IntToStr(ErrorNo - 1000) + ' Opening File'
     else
     if ErrorNo <> 0 then
       ErrorMessage := 'Unknown Error (' + IntToStr(ErrorNo) + ')'
     else
       ErrorMessage := 'Index deleted successfully';
  end; //Case

  if ErrorNo > 0 then
    HasErrors := True;

  FErrorLog.Add(ErrorMessage);
end;

procedure TForm1.ShowErrorLog(const ACaption : string);
begin
  if msgBox('There were errors. Do you wish to see the error log?',
             mtInformation, [mbYes, mbNo], mbYes, ACaption) = mrYes then
  with TfrmErrorLog.Create(nil) do
  Try
    memErrorLog.Lines.AddStrings(FErrorLog);
    ShowModal;
  Finally
    Free;
  End;
end;

procedure TForm1.SaveErrorLog;
var
  Directory : string;
begin
  Directory := ExtractFilePath(Application.ExeName);
  FErrorLog.SaveToFile(Directory + LOG_FILE_NAME);
end;

procedure TForm1.AddIndex(WhichCompany: Integer);
var
  oIndex : TAddIndex;
  Res : Integer;
begin
  oIndex := TAddIndex.Create;
  Try
    //Set up index details
    oIndex.FileName := GetCompanyDataPath(WhichCompany) + DETAILS_FILE_NAME;
    oIndex.UseAltColSeq := True;
    oIndex.IndexNumber := ADD_INDEX_NUMBER;
    with OIndex.AddSegment do
    begin
      KeyPosition := IDX_POSITION;
      KeyLength := IDX_LENGTH;
      KeyFlags := DupMod + AltColSeq;
    end;

    //Create index
    Res := oIndex.Execute;
    LogError(Res);
  Finally
    oIndex.Free;
  End;
end;

procedure TForm1.btnAddIndexClick(Sender: TObject);
var
  i : Integer;
  WhichCo : Integer;
begin
  if lbCompanies.SelCount > 0 then
  begin
    for i := 0 to lbCompanies.Count - 1 do
    begin
      if lbCompanies.Selected[i] then
      begin
        WhichCo := i + 1; //companies array in toolkit is 1-based so increment company number here
        StatusString := 'Adding Index for ' + oToolkit.Company.cmCompany[WhichCo].coCode;
        StatusBar.SimpleText := 'Please wait... ' + StatusString;

        FErrorLog.Add(' ');
        FErrorLog.Add(StatusString);
        FErrorLog.Add(StringOfChar('=', Length(StatusString)));
        FErrorLog.Add(' ');

        Screen.Cursor := crHourGlass;
        EnableButtons(False);
        Try
          AddIndex(WhichCo);

          //If an error occurred then don't process any further countries
          if HasErrors then
            Break;
        Finally
          EnableButtons(True);
          Screen.Cursor := crDefault;
        End;
      end; //lbCompanies.Selected[i]
    end; //i := 0 to lbCompanies.Count

    if HasErrors then
    begin  //show error log
      StatusBar.SimpleText := 'Errors';
      ShowErrorLog('Add Index');
    end
    else
    begin
      StatusBar.SimpleText := 'Process Complete';
      ShowMessage('Process complete');
    end;
  end //lbCompanies.SelCount > 0
  else
    msgBox('No companies selected', mtInformation, [mbOK], mbOK, 'Add Index');
end;

procedure TForm1.SetAll(TurnOn: Boolean);
var
  i : Integer;
begin
  for i := 0 to lbCompanies.Count - 1 do
    lbCompanies.Selected[i] := TurnOn;
end;

procedure TForm1.btnSelectClick(Sender: TObject);
begin
  SetAll(True);
end;

procedure TForm1.btnUnselectClick(Sender: TObject);
begin
  SetAll(False);
end;

procedure TForm1.EnableButtons(Enable: Boolean);
begin
  btnDeleteIndex.Enabled := Enable;
  btnAddIndex.Enabled := Enable;
  btnClose.Enabled := Enable;
  btnSelect.Enabled := Enable;
  btnUnselect.Enabled := Enable;
end;

end.
