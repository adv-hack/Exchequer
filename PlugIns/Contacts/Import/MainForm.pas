unit MainForm;

interface

uses
  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , SecCodes, Dialogs, Enterprise01_TLB, StdCtrls, VarConst, BtrvU2, StrUtil
  , Globvar, ComObj, FileUtil, ETStrU, ExtCtrls;

const
  {$IFDEF EX600}
    sVersionNo = '006';
  {$ELSE}
    sVersionNo = 'v5.71.004';
  {$ENDIF}

type
  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

  TfrmMain = class(TForm)
    edFilename: TEdit;
    Label1: TLabel;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    btnImport: TButton;
    Bevel1: TBevel;
    btnCancel: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    function StartToolkit(sCompanyCode : string) : boolean;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    oToolkit : IToolkit;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  with OpenDialog1 do
  begin
    Filename := edFilename.Text;
    if execute then edFilename.Text := Filename;
  end;{with}
end;

procedure TfrmMain.btnImportClick(Sender: TObject);
var
  iImported : integer;

  procedure AddContact(TheContactRec : TContactRecType);
  var
    iResult, iStatus : integer;

    function GetCode : string;
    var
      iNo, iStatus : integer;
      KeyS : Str255;
    begin{GetCode}
      iNo := 1;
      repeat
        Result := LJVar(Copy(TheContactRec.coSurname,1,16) + PadString(psLeft, IntToStr(iNo), '0', 4), 20);
        KeyS := BuildCodeIndex(TheContactRec.coCompany, TheContactRec.coAccount, Result);
        iStatus := Find_Rec(B_GetEq, F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx, KeyS);
        if iStatus = 0 then Inc(iNo);
      until iStatus <> 0
    end;{GetCode}

  begin{AddContact}
    TheContactRec.coCode := GetCode;
    TheContactRec.coDate := DateToStr8(SysUtils.Date);

    if (not Assigned(oToolkit)) then
    begin
      if (not StartToolkit(TheContactRec.coCompany)) then exit;
    end;{if}

    if oToolkit.Status = tkOpen then
    begin
      iResult := oToolkit.Customer.GetEqual(oToolkit.Customer.BuildCodeIndex(TheContactRec.coAccount));
      if iResult <> 0 then
      begin
        iResult := oToolkit.Supplier.GetEqual(oToolkit.Supplier.BuildCodeIndex(TheContactRec.coAccount));
        if iResult <> 0 then
        begin
          ShowMessage('Could Not find customer / supplier Code : ' + TheContactRec.coAccount);
          exit;
        end;{if}
      end;{if}


      // close toolkit
{      If Assigned(oToolkit) Then
      Begin
        // Close COM Toolkit and remove reference
        oToolkit.CloseToolkit;
        oToolkit := NIL;
      End; { If Assigned(oToolkit) }

      ContactRec := TheContactRec;
      iStatus := Add_rec(F[ContactF],ContactF,RecPtr[ContactF]^,0);
      if iStatus = 0 then inc(iImported)
      else ShowMessage('Add_rec Error : ' + IntToStr(iStatus));
    end;{if}
  end;{AddContact}

  function StrToContactRec(sString : string) : TContactRecType;

    procedure AddField(iFieldNo : integer; sField : string);
    begin
      with Result do begin
        case iFieldNo of
          1 : coCompany := LJVar(sField, 6);
          2 : coAccount := LJVar(sField, 10);
      //    coCode       : String[20];    // Unique Contact Code
          3 : coTitle := LJVar(sField, 10);
          4 : coFirstName := LJVar(sField, 30);
          5 : coSurname := LJVar(sField, 30);
          6 : coPosition := LJVar(sField, 30);
          7 : coSalutation := LJVar(sField, 20);
          8 : coContactNo := LJVar(sField, 30);
          9 : coFaxNumber := LJVar(sField, 30);
          10 : coEmailAddr := LJVar(sField, 100);
          11 : coAddress1 := LJVar(sField, 35);
          12 : coAddress2 := LJVar(sField, 35);
          13 : coAddress3 := LJVar(sField, 35);
          14 : coAddress4 := LJVar(sField, 35);
          15 : coPostCode := LJVar(sField, 10);
        end;{case}
      end;{with}
    end;

  var
    QuoteMode, iFieldNo, iPos : integer;
    sField : string;
  const
    QM_OutsideQuotes = 0;
    QM_InsideQuotes = 1;

  begin
    FillChar(Result, SizeOf(Result), #0);

    // initialise
    iFieldNo := 1;
    sField := '';
    QuoteMode := QM_OutsideQuotes;

    // go through each character in the string
    for iPos := 1 to Length(sString) do
    begin

      // change quote mode
      if sString[iPos] = '"' then
      begin
        if QuoteMode = QM_OutsideQuotes then QuoteMode := QM_InsideQuotes
        else QuoteMode := QM_OutsideQuotes;
      end
      else begin
        // next field
        if (sString[iPos] = ',') and (QuoteMode = QM_OutsideQuotes) then
        begin
          AddField(iFieldNo, sField);
          sField := '';
          inc(iFieldNo);
        end
        else begin
          sField := sField + sString[iPos]
        end;
      end;{if}

    end;{for}

    // add last field
    AddField(iFieldNo, sField);
  end;

var
  slContacts : TStringList;
  AContactRec : TContactRecType;
  iStatus, iPos : integer;

begin
  Cursor := crHourglass;

  iImported := 0;

  if not FileExists(edFileName.Text) then
  begin
    ShowMessage('File does not exist : ' + edFileName.Text);
    exit;
  end;{if}

  {$IFDEF EXSQL}
    if not TableExists(FileNames[ContactF]) then
  {$ELSE}
    if not FileExists(FileNames[ContactF]) then
  {$ENDIF}
    begin
      iStatus := Make_File(F[ContactF],FileNames[ContactF], FileSpecOfs[ContactF]^,FileSpecLen[ContactF]);
      if iStatus <> 0 then
      begin
        ShowMessage('Make_File (' + FileNames[ContactF] + ') Error : ' + IntToStr(iStatus));
        exit;
      end;{if}
    end;{if}
  {...}

  iStatus := Open_File(F[ContactF], FileNames[ContactF], 0);
  if iStatus <> 0 then
  begin
    ShowMessage('Open_File (' + FileNames[ContactF] + ') Error : ' + IntToStr(iStatus));
    exit;
  end;{if}

  slContacts := TStringList.Create;
  slContacts.LoadFromFile(edFileName.Text);
  oToolkit := nil;

  For iPos := 0 to slContacts.Count -1 do
  begin
    AddContact(StrToContactRec(slContacts[iPos]));
    application.processmessages;
  end;{for}

  // close toolkit
  If Assigned(oToolkit) Then
  Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }

  slContacts.Free;

  Close_File(F[ContactF]);

  Cursor := crDefault;

  ShowMessage('Extended Contacts Import finished.'#13#13'No Of Contacts imported : ' + IntToStr(iImported));
end;

function TfrmMain.StartToolkit(sCompanyCode : string) : boolean;
var
  a, b, c : LongInt;
  FuncRes : integer;
  CompanyRec : TCompanyRec;

  function GetCompanyRecFromCode(sCompanyCode : string): TCompanyRec;
  var
    iPos : integer;
  begin{GetCompanyRecFromCode}
    FillChar(Result, SizeOf(Result), #0);
    For iPos := 1 to oToolkit.Company.cmCount do
    begin
      if Trim(oToolkit.Company.cmCompany[iPos].coCode) = Trim(sCompanyCode) then
      begin
        Result.Path := Trim(oToolkit.Company.cmCompany[iPos].coPath);
        Result.Name := Trim(oToolkit.Company.cmCompany[iPos].coName);
        Result.Code := Trim(oToolkit.Company.cmCompany[iPos].coCode);
      end;{if}
    end;{for}
  end;{GetCompanyRecFromCode}

begin{StartToolkit}
  Result := TRUE;
  if not assigned(oToolkit) then
  begin
    // Create COM Toolkit object
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) Then Begin
      With oToolkit Do Begin
        EncodeOpCode(97, a, b, c);
        oToolkit.Configuration.SetDebugMode(a, b, c);

  //      oToolkit.Configuration.OverwriteTransactionNumbers := TRUE;
  //      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;
  //      oToolkit.Configuration.AutoSetTransCurrencyRates := FALSE;

        // Open Default Company

        CompanyRec := GetCompanyRecFromCode(sCompanyCode);

        if CompanyRec.Code = '' then
        begin
          ShowMessage ('Could Not Find Company Code : ' + sCompanyCode);
          Result := FALSE;
        end else
        begin

          oToolkit.Configuration.DataDirectory := CompanyRec.Path;
          FuncRes := OpenToolkit;

          // Check it opened OK
          If (FuncRes = 0) then {DoUpdates}
          else begin
            // Error opening Toolkit - display error
            ShowMessage ('The following error occurred opening the Toolkit:-'#13#13
            + QuotedStr(oToolkit.LastErrorString));
            Result := FALSE;
          end;{if}
        end;{if}
      end; { With OToolkit }
    end else
    begin
      // Failed to create COM Object
      ShowMessage ('Cannot create COM Toolkit instance');
      Result := FALSE;
    end;{if}
  end;{if}

  if not Result then
  begin
    // close toolkit
    If Assigned(oToolkit) Then
    Begin
      // Close COM Toolkit and remove reference
      oToolkit.CloseToolkit;
      oToolkit := NIL;
    End; { If Assigned(oToolkit) }
  end;{if}
  
end;{StartToolkit}


procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := 'Extended Contacts Importer - build ' + sVersionNo;
end;

end.
