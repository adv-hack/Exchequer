unit paramf;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, EntLkup, {$IFDEF ELMAN}Enterprise01_TLB,{$ELSE}Enterprise04_TLB,{$ENDIF} Spin;

type
  TfrmParams = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    grpData: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    edtPFrom: TEdit;
    edtPTo: TEdit;
    cbPFrom: TComboBox;
    cbPTo: TComboBox;
    lblParam: TLabel;
    lblOffStart: TLabel;
    spnOffStart: TSpinEdit;
    lblOffEnd: TLabel;
    spnOffEnd: TSpinEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtPFromExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure cbPFromDblClick(Sender: TObject);
    procedure cbPFromChange(Sender: TObject);
  private
    { Private declarations }
    FDataType : Byte;
    FToolkit : IToolkit;
    FDataPath : AnsiString;
    FCustStr : String[20];
    FCurrList : TStringList;
    procedure GetCustSupp(Sender : TEdit; Which : TTraderType);
    procedure GetCCDep(Sender : TEdit; IsCC : Boolean);
    function P2Text(const s : string) : string;
    function Text2P(const s : string) : string;
  public
    { Public declarations }
    FromString, ToString : ShortString;
    procedure SetControls;
    property DataType : Byte read FDataType write FDataType;
    property oToolkit : IToolkit read FToolkit write FToolkit;
    property DataPath : AnsiString read FDataPath write FDataPath;
    property CurrencyList : TStringList write FCurrList;
  end;

var
  frmParams: TfrmParams;

function ParamTypeStr(DType : Byte) : String;

implementation

{$R *.DFM}
uses
  BtSupU2, EtDateU, DatePick;

function ParamTypeStr(DType : Byte) : String;
begin
  Case DType of
      1    : Result := 'Date';
      2    : Result := 'Period';
      3    : Result := 'Value';
      5    : Result := 'Currency';
      4    : Result := 'Text';
      6    : Result := 'Document Number';
      7    : Result := 'Customer Code';
      8    : Result := 'Supplier Code';
      9    : Result := 'Nominal Code';
      10   : Result := 'Stock Code';
      11   : Result := 'Cost Centre Code';
      12   : Result := 'Department Code';
      13   : Result := 'Location Code';
      17   : Result := 'Job Code';
    else
      Result := 'Unknown';
  end; //case
end;



procedure TfrmParams.SetControls;
begin
  grpData.Caption := ParamTypeStr(DataType) + '...';
  Case DataType of
    1, 2, 5  : begin
                 cbPFrom.Visible := True;
                 cbPTo.Visible := True;
                 if DataType = 5 then
                 begin
                   cbPFrom.Items.AddStrings(FCurrList);
                   cbPTo.Items.AddStrings(FCurrList);
                   cbPFrom.ItemIndex := StrToInt(FromString);
                   cbPTo.ItemIndex := StrToInt(ToString);
                 end;
                 if DataType in [1, 2] then
                 begin
                   cbPFrom.Text := FromString;
                   cbPTo.Text := ToString;
                   spnOffStart.Visible := True;
                   spnOffEnd.Visible := True;
                   lblOffStart.Visible := True;
                   lblOffEnd.Visible := True;
                   cbPFrom.Items.Clear;
                   cbPTo.Items.Clear;
                   AddDropDown(cbPFrom, DataType);
                   AddDropDown(cbPTo, DataType);

                   cbPFromChange(cbPFrom);
                   cbPFromChange(cbPTo);
                 end;
                 ActiveControl := cbPFrom;
               end;
    else
    begin
      grpData.Height := 89;
      ClientHeight := 158;
      edtPFrom.Visible := True;
      edtPTo.Visible := True;
      edtPFrom.Text := FromString;
      edtPTo.Text := ToString;
      ActiveControl := edtPFrom;
    end;
  end; //Case
end;

procedure TfrmParams.GetCustSupp(Sender : TEdit; Which : TTraderType);
var
  sCustomer : string[20];
begin
  if (ActiveControl <> btnCancel) and (ActiveControl <> nil) then begin
    sCustomer := Sender.Text;
    if DoGetCust(Self, IncludeTrailingBackslash(Trim(FDataPath))
    , sCustomer, sCustomer, Which, vmShowList, TRUE) then Sender.Text := sCustomer
    else ActiveControl := Sender;
  end;{if}
end;

procedure TfrmParams.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if cbPFrom.Visible then
  begin
    FromString := Text2P(cbPFrom.Text);
    ToString := Text2P(cbPTo.Text);
  end
  else
  begin
    FromString := edtPFrom.Text;
    ToString := edtPTo.Text;
  end;
end;

function TfrmParams.P2Text(const s : string) : string;
begin
  if DataType = 1 then
  begin
    if s = 'Today' then
      Result := s
    else
      Result := POutDate(s);
  end
  else
    Result := s;
end;

function TfrmParams.Text2P(const s : string) : string;
var
  s1 : string;

  procedure RemoveSeps(var st : string);
  var
   i : integer;
  begin
    i := 1;
    while i <= Length(st) do
    begin
      if st[i] = '/' then
        Delete(st, i, 1)
      else
        inc(i);
    end;
  end;

begin
  if DataType = 1 then
  begin
    if s = 'Today' then
      Result := s
    else
    begin
      s1 := s;
      RemoveSeps(s1);
      Result := Date2Store(s1);
    end;
  end
  else
    Result := s;
end;



procedure TfrmParams.edtPFromExit(Sender: TObject);
begin
  if (Sender is TEdit) or (Sender is TComboBox) then
  begin
    Case DataType of
      1, 2  : if ActiveControl <> btnCancel then
                if not ValidateComboExit(TComboBox(Sender), DataType) then
                begin
                  ActiveControl := TWinControl(Sender);
                  ModalResult := mrNone;
                end;
      7  :  GetCustSupp(TEdit(Sender), trdCustomer);
      8  :  GetCustSupp(TEdit(Sender), trdSupplier);
     11  :  GetCCDep(TEdit(Sender), True);
     12  :  GetCCDep(TEdit(Sender), False);
    end;
  end;
  if ActiveControl = btnOK then
    btnOK.Click;
end;

procedure TfrmParams.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);

end;

procedure TfrmParams.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TfrmParams.GetCCDep(Sender : TEdit; IsCC : Boolean);
var
  sCostCentre : string[20];
begin
  if (ActiveControl <> btnCancel) and (ActiveControl <> nil) then begin
    sCostCentre := Sender.Text;
    if DoGetCCDep(Self, IncludeTrailingBackslash(Trim(FDataPath))
    , sCostCentre, sCostCentre, IsCC, vmShowList, TRUE) then Sender.Text := sCostCentre
    else ActiveControl := Sender;
  end;{if}
end;




procedure TfrmParams.cbPFromDblClick(Sender: TObject);
begin
  if DataType = 1 then
    if Sender is TComboBox then
      with Sender as TComboBox do
        Text := SelectDate(Text);
end;




procedure TfrmParams.cbPFromChange(Sender: TObject);
begin
  if Sender = cbPFrom then
    SetLabel(cbPFrom, lblOffStart, DataType)
  else
  if Sender = cbPTo then
    SetLabel(cbPTo, lblOffEnd, DataType);

end;



end.
