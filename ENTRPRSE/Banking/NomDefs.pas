unit NomDefs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, Mask, TCustom, ExtCtrls, Enterprise04_TLB,
  EnterToTab;

type
  TNomDefaults = Record
    ndGLCode : longint;
    ndCC, ndDep : string[3];
    ndVatCode : Char;
    ndIncVat  : Char;
    ndVatAmount : Double;
    ndDescription : string[55];
  end;

  TfrmNomDefaults = class(TForm)
    Panel1: TPanel;
    SBSButton1: TSBSButton;
    btnCancel: TSBSButton;
    edtCC: Text8Pt;
    edtDep: Text8Pt;
    cbVatCode: TSBSComboBox;
    ceVatAmount: TCurrencyEdit;
    edtDescription: Text8Pt;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtGLDesc: Text8Pt;
    EnterToTab1: TEnterToTab;
    edtGLCode: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure cbVatCodeChange(Sender: TObject);
    procedure edtCCExit(Sender: TObject);
    procedure edtGLCodeExit(Sender: TObject);
    procedure cbVatCodeExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Toolkit : IToolkit;
    IncVatCode : Char;
  end;


  function GetJournalDefaults(const oToolkit : IToolkit; var NomDefaults : TNomDefaults; ShowCCDep : Boolean; AOwner : TComponent) : Boolean;



implementation

{$R *.dfm}
uses
  BankDetl, BtSupU2, TKPickList04, InvListU, EtStrU, GlobVar, GIRateU;

function GetJournalDefaults(const oToolkit : IToolkit; var NomDefaults : TNomDefaults; ShowCCDep : Boolean; AOwner : TComponent) : Boolean;
begin
  FillChar(NomDefaults, SizeOf(NomDefaults), 0);
  with TfrmNomDefaults.Create(AOwner) do
  Try
    Toolkit := oToolkit;
    edtCC.Enabled := ShowCCDep;
    edtDep.Enabled := ShowCCDep;
    ShowModal;
    Result := ModalResult = mrOK;
    if Result then
    begin
      NomDefaults.ndGLCode := StrToInt(edtGLCode.Text);
      NomDefaults.ndCC := edtCC.Text;
      NomDefaults.ndDep := edtDep.Text;
      if Trim(cbVATCode.Text) <> '' then
        NomDefaults.ndVatCode := cbVatCode.Text[1]
      else
        NomDefaults.ndVATCode := 'N';
      NomDefaults.ndIncVat := IncVatCode;
      NomDefaults.ndVatAmount := ceVatAmount.Value;
      NomDefaults.ndDescription := edtDescription.Text;
    end;
  Finally
    Free;
  End;

end;

procedure TfrmNomDefaults.FormCreate(Sender: TObject);
begin
  Build_DefaultCVAT(cbVatCode.Items,True,True,False,False);
  Build_DefaultCVAT(cbVatCode.ItemsL,True,True,False,True);
  cbVatCode.Items.Insert(0, 'N/A');
  cbVatCode.ItemsL.Insert(0, 'N/A');
  ceVatAmount.Enabled := False;
  cbVatCode.ItemIndex := 0;
end;

procedure TfrmNomDefaults.cbVatCodeChange(Sender: TObject);
begin
  ceVatAmount.Enabled := cbVatCode.ItemIndex > 0;
end;

procedure TfrmNomDefaults.edtCCExit(Sender: TObject);
var
  IsCC : Boolean;
  FoundCode : Str20;
begin

  if ActiveControl <> btnCancel then
  begin
    FoundCode:=Strip('B',[#32],(Sender as Text8pt).Text);
    if GetCCDep(Self.Owner,FoundCode,FoundCode,(Sender=edtCC),2) then
    begin
      if Sender is TExt8Pt then
        with Sender as TExt8Pt do
          Text := FoundCode;
    end
    else
      ActiveControl := Sender as TExt8pt;
  end;
{  with TfrmTKPickList.CreateWith(self, Toolkit) do begin
    // Set Form Properies
    IsCC := Sender = edtCC;
    if IsCC then
    begin
      plType := plCC;
      sFind := edtCC.Text;
    end
    else
    begin
      plType := plDept;
      sFind := edtDep.Text;
    end;
    iSearchCol := 0;
    mlList.Columns[1].IndexNo := 1;
    bRestrictList := TRUE;
    bAutoSelectIfOnlyOne := TRUE;
    bShowMessageIfEmpty := TRUE;

    // Show Form
    if showmodal = mrOK then
    begin
      // Get Selected CC
      with ctkDataSet.GetRecord as ICCDept2 do
      begin;
        if IsCC then
          edtCC.Text := cdCode
        else
          edtDep.Text := cdCode;
      end;
    end;{if
    release;

  end;{with}
end;

procedure TfrmNomDefaults.edtGLCodeExit(Sender: TObject);
var
  LGL : IGeneralLedger;
  FoundCode  :  ShortString;
  FoundNom   :  LongInt;
  Res : longint;
begin
  if ActiveControl <> btnCancel then
  begin
    FoundNom := 0;
    FoundCode := edtGLCode.Text;
    if GetNom(Self.Owner, FoundCode, FoundNom, 0) then
    begin
{    LGl := GetGLCode(Toolkit, StrToInt(edtGLCode.Text), False);
    if Assigned(LGl) then
    begin   }
      edtGLCode.Text := IntToStr(FoundNom);
      with Toolkit do
      begin
        Res := GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(FoundNom));
        if Res = 0 then
          edtGLDesc.Text := Trim(GeneralLedger.glName);
      end;
    end
    else
      Activecontrol := edtGLCode;
  end;
end;

procedure TfrmNomDefaults.cbVatCodeExit(Sender: TObject);
begin
  if cbVatCode.ItemIndex < 0 then
  begin
    cbVATCode.ItemIndex := 0;
    cbVATCode.Text := cbVatCode.Items[cbVatCode.ItemIndex];
    cbVATCode.Refresh;
    Application.ProcessMessages;
  end;
  if (ActiveControl <> btnCancel) and (cbVatCode.Items[cbVatCode.ItemIndex] = 'I') then
  begin
    IncVatCode := #0;
    GetIRate(Application.MainForm.ClientToScreen(ClientPos(Left+23,Top+23)),Color,Font,Application.MainForm,False,IncVatCode);
    if IncVatCode = #0 then
      ActiveControl := cbVatCode
    else
      cbVatCode.ItemIndex := cbVatCode.Items.IndexOf('M');
  end;
end;

end.
