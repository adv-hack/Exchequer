unit BankList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uMultiList, StdCtrls, TCustom, ExtCtrls, BankDetl,
  EnterToTab, Enterprise04_TLB, ComObj, ActiveX, Menus, uSettings,
  uExDatasets, uComTKDataset, uDBMultiList, EnterpriseBeta_TLB;

type
  TNotifyProc = procedure(Sender : TObject);

  TfrmBankList = class(TForm)
    Panel1: TPanel;
    pnlBanks: TPanel;
    pnlButtons: TPanel;
    btnClose: TSBSButton;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    View1: TMenuItem;
    Delete1: TMenuItem;
    Statements1: TMenuItem;
    N1: TMenuItem;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    N2: TMenuItem;
    EnterToTab1: TEnterToTab;
    ScrollBox1: TScrollBox;
    btnAdd: TSBSButton;
    btnEdit: TSBSButton;
    btnView: TSBSButton;
    btnDelete: TSBSButton;
    btnStatement: TSBSButton;
    mlBanks: TDBMultiList;
    ctkBanks: TComTKDataset;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure mlBanksRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormResize(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnStatementClick(Sender: TObject);
    procedure mlBanksChangeSelection(Sender: TObject);
    procedure ctkBanksGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure mlBanksColumnClick(Sender: TObject; ColIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FOnFormClosed : TNotifyProc;
    bRestore : Boolean;
    InitSize : TPoint;
    procedure DetailFormClosed(Sender : TObject);
    function GetSelected : Integer;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
    procedure UpdateDetailsForm;
  public
    { Public declarations }
    procedure LoadList;
    procedure WMUpdateList(var Message : TMessage); message WM_UpdateList;
    property OnFormClosed : TNotifyProc read FOnFormClosed write FOnFormClosed;
  end;

  function StartToolkit(var AToolkit : IToolkit3; const DataPath : string; FirstTime : Boolean = True) : Integer;
  procedure ShowEBankList;
  procedure ShowBankDetails(const oBankAccount : IBankAccount; Mode : Byte; OnClosed : TNotifyEvent;
                          AHandle : THandle; const AToolkit : IToolkit3;
                           StatFolio : Longint = 0; StatDate : string = '');

var
  frmBankList: TfrmBankList;

implementation

{$R *.dfm}
uses
  CtkUtil04, VarConst, GlobVar, EtDateU, ReconObj, EtStrU, BtKeys1U;

var
  oToolkit : IToolkit3;
  ProductList : TStringList;

procedure FormClosed(Sender : TObject);
begin
  frmBankList := nil;
end;

procedure LoadProducts(const AToolkit : IToolkit3);
const
  BPExcludeSet = [16, 18];
var
  ProductCount, i : Integer;
begin
  with AToolkit do
  begin
    ProductCount := Banking.BankProducts.bpCount;
    ProductList.Sorted := True;
    for i := 1 to ProductCount do
      if not (i in BPExcludeSet) then
        ProductList.AddObject(Banking.BankProducts.bpName[i], TObject(i));
  end;
end;


procedure ShowEBankList;
begin
  //User id = Trim(UserProfile^.Login)
  sMiscDirLocation := SetDrive;

  oSettings.EXEName := ExtractFilename(GetModuleName(HInstance));

  if frmBankList = nil then
  begin
    StartToolkit(oToolkit, SetDrive);
    frmBankList := TfrmBankList.Create(Application.MainForm);
    frmBankList.OnFormClosed := FormClosed;
    frmBankList.ctkBanks.ToolkitObject := oToolkit.Banking.BankAccount as IDatabaseFunctions;
    frmBankList.mlBanks.Active := True;
    //frmBankList.LoadList;
    frmBankList.mlBanks.Selected := 0;
  end;

  frmBankList.BringToFront;
end;

procedure TfrmBankList.FormCreate(Sender: TObject);
begin
  oSettings.EXEName := ExtractFilename(GetModuleName(HInstance));
  oSettings.UserName := GetUserID;
  {For some reason when creating the form in Exchequer it is a lot larger. Hard-code to
  initial size here.}
  Height := 311;
  Width := 449;
  frmBankDetails := nil;
  bRestore := False;
  LoadAllSettings;
  InitSize.X := Width;
  InitSize.Y := Height;
end;

procedure TfrmBankList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBankList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
{  if Assigned(oToolkit) then
    oToolkit := nil;}
  if not bRestore then SaveAllSettings;
  if Assigned(frmbankdetails) then
    frmbankdetails.btnCloseClick(frmbankdetails);
  if Assigned(FOnFormClosed) then
    FOnFormClosed(Self);
  Action := caFree;
end;

procedure TfrmBankList.btnAddClick(Sender: TObject);
begin
  ShowBankDetails(oToolkit.Banking.BankAccount.Add, bdmAdd, DetailFormClosed, Self.Handle, oToolkit);
end;

procedure TfrmBankList.DetailFormClosed(Sender: TObject);
begin
  frmbankdetails := nil;
end;

function StartToolkit(var AToolkit : IToolkit3; const DataPath : string; FirstTime : Boolean = True) : Integer;
begin
  Result := 0;
  if not Assigned(AToolkit) then
    AToolkit := CreateToolkitWithBackDoor as IToolkit3;


  if FirstTime then
  begin
    if AToolkit.Status = tkOpen then
      AToolkit.CloseToolkit;
    AToolkit.Configuration.DataDirectory := DataPath;
    AToolkit.Configuration.AllowTransactionEditing := True;
    AToolkit.Configuration.OverwriteTransactionNumbers := True;
    Result := AToolkit.OpenToolkit;
    if Result <> 0 then
      raise Exception.Create('Error opening toolkit' + IntToStr(Result));
  end;
end;

procedure ShowBankDetails(const oBankAccount: IBankAccount; Mode : Byte; OnClosed : TNotifyEvent;
                          AHandle : THandle; const AToolkit : IToolkit3;
                           StatFolio : longint = 0; StatDate : string = '');
begin
  if not Assigned(frmbankdetails) then
  begin
    ProductList := TStringList.Create;
    LoadProducts(AToolkit);
    frmbankdetails := TfrmBankDetails.Create(Application.MainForm);
    frmbankdetails.cbProduct.Items.AddStrings(ProductList);
    frmbankdetails.OnFormClosed := OnClosed;
//    frmbankdetails.pgDetailsChange(frmbankdetails.pgDetails);
    frmbankdetails.ParentHandle := AHandle;
    frmbankdetails.Toolkit := AToolkit;

    frmbankdetails.BankAccount := oBankAccount;
    frmbankdetails.Mode := Mode;
    frmbankdetails.SetFields;
  end
  else
  if (frmbankdetails.Mode in [bdmView, bdmStatements]) and (Mode = bdmEdit) then
  begin
    frmbankdetails.Mode := Mode;
    frmbankdetails.BankAccount := frmbankdetails.BankAccount.Update;
    frmbankdetails.SetFields;
  end;
  frmbankdetails.BringToFront;
  frmbankdetails.ShowDelete;
  frmBankDetails.SetCurrentStatement(StatDate, StatFolio);
end;

procedure TfrmBankList.btnViewClick(Sender: TObject);
begin
  if GetSelected = 0 then
    ShowBankDetails(oToolkit.Banking.BankAccount, bdmView, DetailFormClosed, Self.Handle, oToolkit);
end;

procedure TfrmBankList.btnEditClick(Sender: TObject);
begin
  if GetSelected = 0 then
    ShowBankDetails(oToolkit.Banking.BankAccount.Update,
                     bdmEdit, DetailFormClosed, Self.Handle, oToolkit);
end;

function TfrmBankList.GetSelected: Integer;
var
  s : string;
begin
  with oToolkit.Banking do
  begin
    if mlBanks.Selected >= 0 then
    begin
      s := BankAccount.BuildGLCodeIndex(StrToInt(mlBanks.DesignColumns[0].items[mlBanks.Selected]));
      Result := BankAccount.GetEqual(s);
      if Result <> 0 then
        ShowMessage('Unable to select Bank Account Record. Btrieve error ' + IntToStr(Result));
    end
    else
      Result := 1;
  end;
end;

procedure TfrmBankList.LoadList;
var
  Res : Integer;
begin
  mlBanks.RefreshDB;
end;

procedure TfrmBankList.WMUpdateList(var Message: TMessage);
var
  KeyS : Str255;
begin
  LoadList;
  if Message.LParam <> 0 then
  begin
    KeyS := FullNomKey(Message.LParam);
    mlBanks.SearchColumn(0, True, KeyS);
  end;
end;

procedure TfrmBankList.mlBanksRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnViewClick(Self);
end;

procedure TfrmBankList.FormResize(Sender: TObject);
begin
  Panel1.Width := ClientWidth - 8;
  Panel1.Height := ClientHeight - 10;

  pnlButtons.Left := Panel1.Width - pnlButtons.Width - 4;
  pnlButtons.Height := Panel1.Height - 8;

  ScrollBox1.Height := pnlButtons.Height - ScrollBox1.Top - 2;

  pnlBanks.Width := pnlButtons.Left - 8;
  pnlBanks.Height := pnlButtons.Height;
end;

procedure TfrmBankList.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlBanks, Self.Name, nil) of
{    mrOK : oSettings.ColorFieldsFrom(cmbCompany, Self);}
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      oSettings.RestoreListDefaults(mlBanks, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}

end;

procedure TfrmBankList.SaveAllSettings;
begin
  oSettings.SaveList(mlBanks, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmBankList.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadList(mlBanks, Self.Name);
end;

procedure TfrmBankList.btnDeleteClick(Sender: TObject);
begin
  if GetSelected = 0 then
  begin
    ShowBankDetails(oToolkit.Banking.BankAccount, bdmDelete,
                     DetailFormClosed, Self.Handle, oToolkit);
    mlBanks.RefreshDB;
  end;
end;

procedure TfrmBankList.btnStatementClick(Sender: TObject);
begin
  if GetSelected = 0 then
    ShowBankDetails(oToolkit.Banking.BankAccount, bdmStatements,
                        DetailFormClosed, Self.Handle, oToolkit);
end;

procedure TfrmBankList.UpdateDetailsForm;
begin
  if Assigned(frmbankdetails) and (frmbankdetails.Mode in [bdmView, bdmStatements]) then
    if GetSelected = 0 then
    begin
      frmbankdetails.BankAccount := oToolkit.Banking.BankAccount;
      frmbankdetails.SetFields;
    end;
end;

procedure TfrmBankList.mlBanksChangeSelection(Sender: TObject);
begin
  UpdateDetailsForm;
end;

procedure TfrmBankList.ctkBanksGetFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
begin
  with ID as IBankAccount do
  begin
    Case FieldName[1] of
      'C' : FieldValue := IntToStr(baGLCode);
      'D' : FieldValue := baProductString;
      'L' : if Trim(baLastDate) = '' then
              FieldValue := ''
            else
              FieldValue := POutDate(baLastDate);
    end;

  end;

end;

procedure TfrmBankList.mlBanksColumnClick(Sender: TObject;
  ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  mlBanks.HelpContext := 1950 + ColIndex;
end;

Initialization
  oToolkit := nil;
  frmBankList := nil;

Finalization
  oToolkit := nil;
  if Assigned(ProductList) then
    ProductList.Free;

end.
