unit UnallocateInputForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, Mask, bkgroup, EnterToTab;

type
  TUnallocateAllForm = class(TForm)
    SBSPanel4: TSBSBackGroup;
    OkCP1Btn: TButton;
    ClsCP1Btn: TButton;
    lblAccountRange: Label8;
    edtFromAccountCode: Text8Pt;
    lblAccountTo: Label8;
    edtToAccountCode: Text8Pt;
    EnterToTab1: TEnterToTab;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtFromAccountCodeExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FAccountType : Byte;
  public
    { Public declarations }
    constructor CreateEx(AOwner : TComponent; AccountType : Byte);
    procedure EnableDisableControls();
  end;

  procedure UnallocateAllTransactions(AccountType : Byte);

var
  UnallocateAllForm: TUnallocateAllForm;

implementation

uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  Event1U,
  InvListU,
  ReportU,
  ExWrap1U,
  SysU2,
  BTSupU2,
  PostingU,
  ConsumerUtils,
  ApiUtil;

procedure UnallocateAllTransactions(AccountType : Byte);
begin
  UnallocateAllForm := TUnallocateAllForm.CreateEx(Application.MainForm, AccountType);
end;

{$R *.dfm}

constructor TUnallocateAllForm.CreateEx(AOwner: TComponent; AccountType: Byte);
begin
  inherited Create(AOwner);
  FAccountType := AccountType;
  {$IFDEF SOP}
{  if Syss.ssEnableOrderPayments and (AccountType = CUSTOMER_TYPE) then
    Label1.Caption := 'Please note: previously revalued transactions and Order Payment transactions will not be revalued';}
  {$ENDIF}                            //TODO: Check text with Lou/DR
  ActiveControl := edtFromAccountCode;
end;

procedure TUnallocateAllForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TUnallocateAllForm.edtFromAccountCodeExit(Sender: TObject);
Var
  FoundCode  :  Str20;
  FoundOk, AltMod     :  Boolean;
begin
  try
    If (Sender is Text8pt) then
      With (Sender as Text8pt) do
      Begin
        AltMod:=Modified;

        FoundCode:=Strip('B',[#32],Text);
        //SS:16/08/2017:2017-R2:ABSEXCH-18988:Unallocate all Transactions - default to code to be same as from.
        If (AltMod) {and (ActiveControl<>ClsCP1Btn)}  and (FoundCode<>'') then
        Begin
          StillEdit:=BOn;

          if FAccountType = CONSUMER_TYPE then
            FoundCode := CONSUMER_PREFIX + FoundCode;

          FoundOk:=(GetCust(Application.MainForm,FoundCode,FoundCode,(FAccountType in [CUSTOMER_TYPE, CONSUMER_TYPE]),0));

          If (FoundOk) then
          Begin
            StillEdit:=BOff;
            Text:=FoundCode;
          end
          else
          Begin
            SetFocus;
          end; {If not found..}
        end;
      end; {with..}

      //SS:16/08/2017:2017-R2:ABSEXCH-18988:Unallocate all Transactions - default to code to be same as from.
      //AP:05/09/2017:2017-R2:ABSEXCH-19155:Unallocate all Transactions - default to code to be same as from.
      if (Sender = edtFromAccountCode) and (Length(FoundCode)=6) then
      begin
        edtToAccountCode.Text := FoundCode;
        edtToAccountCode.Enabled := True;
        edtToAccountCode.SetFocus;
      end else
      if (Sender = edtFromAccountCode) and (edtFromAccountCode.Text = EmptyStr) and (edtToAccountCode.Text <> EmptyStr)  then
      begin
        edtToAccountCode.Text := EmptyStr;
        edtToAccountCode.Enabled := False;
      end;
  finally
    EnableDisableControls;
  end;
end;

procedure TUnallocateAllForm.OkCP1BtnClick(Sender: TObject);
var
  lAccountStr : String;
begin
  //SS:16/08/2017:2017-R2:ABSEXCH-18988:Unallocate all Transactions - default to code to be same as from.
  lAccountStr := 'from : '+edtFromAccountCode.Text + ' to '+ edtToAccountCode.Text;
  if  msgBox('Please be aware that this action cannot be undone. Are you sure you wish to unallocate all transactions for the selected accounts, '+ lAccountStr+'?',
              mtConfirmation, [mbYes, mbNo], mbNo, 'Unallocate All Transactions') = mrYes then
    AddUnallocateTransactions2Thread(Application.MainForm, FAccountType,
                                     edtFromAccountCode.Text, edtToAccountCode.Text);
  PostMessage(Self.Handle, WM_CLOSE, 0, 0);
end;

procedure TUnallocateAllForm.ClsCP1BtnClick(Sender: TObject);
begin
  Close;
end;

//SS:16/08/2017:2017-R2:ABSEXCH-18988:Unallocate all Transactions - default to code to be same as from.
procedure TUnallocateAllForm.FormShow(Sender: TObject);
begin
  EnableDisableControls;
end;

//SS:16/08/2017:2017-R2:ABSEXCH-18988:Unallocate all Transactions - default to code to be same as from.
procedure TUnallocateAllForm.EnableDisableControls;
begin
  //AP:05/09/2017:2017-R2:ABSEXCH-19155:Unallocate all Transactions - reverse range should not be allowed.
  OkCP1Btn.Enabled := (Trim(edtFromAccountCode.Text) <> EmptyStr) and (Trim(edtToAccountCode.Text) <> EmptyStr) and (not(CompareText(Trim(edtFromAccountCode.Text),Trim(edtToAccountCode.Text))>0));
  edtToAccountCode.Enabled := Trim(edtFromAccountCode.Text) <> EmptyStr;
end;

end.
