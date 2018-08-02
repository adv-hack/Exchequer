unit BankList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uMultiList, StdCtrls, TCustom, ExtCtrls, BankDetl,
  EnterToTab, Enterprise01_TLB, ComObj, ActiveX, Menus, uSettings;

type
  TNotifyProc = procedure(Sender : TObject);

  TfrmBankList = class(TForm)
    Panel1: TPanel;
    pnlBanks: TPanel;
    pnlButtons: TPanel;
    btnClose: TSBSButton;
    btnEdit: TSBSButton;
    btnView: TSBSButton;
    btnDelete: TSBSButton;
    btnStatement: TSBSButton;
    mlBanks: TMultiList;
    btnAdd: TSBSButton;
    EnterToTab1: TEnterToTab;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    View1: TMenuItem;
    Delete1: TMenuItem;
    Statements1: TMenuItem;
    N1: TMenuItem;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure mlBanksRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormResize(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
  private
    { Private declarations }
    FOnFormClosed : TNotifyProc;
    FfrmBankDetails : TfrmBankDetails;
    FGLList, FProductList : TStringList;
    bRestore : Boolean;

    procedure DetailFormClosed(Sender : TObject; bResult : Boolean);
    procedure ShowDetails(const oBankAccount : IBankAccount; Mode : Byte);
    procedure LoadGLCodes;
    procedure LoadProducts;
    function GetSelected : Integer;
    procedure SaveAllSettings;
    procedure LoadAllSettings;

  public
    { Public declarations }
    procedure LoadList;
    procedure WMUpdateList(var Message : TMessage); message WM_UpdateList;
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    property OnFormClosed : TNotifyProc read FOnFormClosed write FOnFormClosed;
  end;

  function StartToolkit(const DataPath : string; FirstTime : Boolean = False) : Integer;
  procedure ShowEBankList(const DataPath, UserID : AnsiString); Export;

var
  frmBankList: TfrmBankList;

implementation

{$R *.dfm}
uses
  CtkUtil;

var
  oToolkit : IToolkit3;
  sDataPath : string;

procedure FormClosed(Sender : TObject);
begin
  frmBankList := nil;
end;

procedure ShowEBankList(const DataPath, UserID : AnsiString);
begin
  sMiscDirLocation := DataPath;

  oSettings.EXEName := ExtractFilename(GetModuleName(HInstance));

  StartToolkit(DataPath, DataPath <> sDataPath);
  sDataPath := DataPath;
  begin
    if frmBankList = nil then
    begin
      frmBankList := TfrmBankList.Create(Application.MainForm);
      frmBankList.OnFormClosed := FormClosed;
    end;

    frmBankList.LoadList;
    frmBankList.BringToFront;
  end;
end;

procedure TfrmBankList.FormCreate(Sender: TObject);
begin
  {For some reason when creating the object in Exchequer it is a lot larger. Hard-code to
  initial size here. TODO - add support for saving and restoring settings.}
  Height := 317;
  Width := 455;
  frmBankDetails := nil;
  FGLList := TStringList.Create;
  FProductList := TStringList.Create;
  LoadProducts;
  bRestore := False;
end;

procedure TfrmBankList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBankList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  if Assigned(FOnFormClosed) then
    FOnFormClosed(Self);
end;

procedure TfrmBankList.btnAddClick(Sender: TObject);
begin
  ShowDetails(oToolkit.Banking.BankAccount.Add, bdmAdd);
end;

procedure TfrmBankList.DetailFormClosed(Sender: TObject; bResult : Boolean);
begin
  FfrmBankDetails := nil;
end;

function StartToolkit(const DataPath : string; FirstTime : Boolean = False) : Integer;
begin
  Result := 0;
  if not Assigned(oToolkit) then
    oToolkit := CreateToolkitWithBackDoor as IToolkit3;


  if FirstTime then
  begin
    if oToolkit.Status = tkOpen then
      oToolkit.CloseToolkit;
    oToolkit.Configuration.DataDirectory := DataPath;
    Result := oToolkit.OpenToolkit;
    if Result <> 0 then
      raise Exception.Create('Error opening toolkit' + IntToStr(Result));
  end;
end;

procedure TfrmBankList.ShowDetails(const oBankAccount: IBankAccount; Mode : Byte);
begin
  if not Assigned(FfrmBankDetails) then
  begin
    FfrmBankDetails := TfrmBankDetails.Create(Application.MainForm);
    FfrmBankDetails.cbProduct.Items.AddStrings(FProductList);
    FfrmBankDetails.OnFormClosed := DetailFormClosed;
    FfrmBankDetails.PageControl1Change(FfrmBankDetails.PageControl1);
    FfrmBankDetails.ParentHandle := Self.Handle;
  end;

  FfrmBankDetails.BankAccount := oBankAccount;
  FfrmBankDetails.Toolkit := oToolkit;
  FfrmBankDetails.Mode := Mode;
  FfrmBankDetails.SetFields;
  FfrmBankDetails.BringToFront;

end;

procedure TfrmBankList.FormDestroy(Sender: TObject);
begin
  if Assigned(FGLList) then
    FGLList.Free;
  if Assigned(FProductList) then
    FProductList.Free;
end;

procedure TfrmBankList.LoadGLCodes;
var
  Res : longint;
begin
  with oToolkit.GeneralLedger do
  begin
    Index := glIdxCode;
    Res := GetFirst;
    while (Res = 0) do
    begin
      if glType = glTypeBalanceSheet then
        FGLList.Add(IntToStr(glCode));

      Res := GetNext;
    end;
  end;
end;

procedure TfrmBankList.btnViewClick(Sender: TObject);
begin
  if GetSelected = 0 then
    ShowDetails(oToolkit.Banking.BankAccount, bdmView);
end;

procedure TfrmBankList.btnEditClick(Sender: TObject);
begin
  if GetSelected = 0 then
    ShowDetails(oToolkit.Banking.BankAccount.Update, bdmEdit);
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
  mlBanks.ClearItems;
  with oToolkit.Banking do
  begin
    Res := BankAccount.GetFirst;

    while Res = 0 do
    begin
      mlBanks.DesignColumns[0].Items.Add(IntToStr(BankAccount.baGLCode));
      mlBanks.DesignColumns[1].Items.Add(BankAccount.baProductString);
      mlBanks.DesignColumns[2].Items.Add(BankAccount.baLastDate);

      Res := BankAccount.GetNext;
    end;

  end;
end;

procedure TfrmBankList.LoadProducts;
var
  ProductCount, i : Integer;
begin
  with oToolkit do
  begin
    ProductCount := Banking.BankProducts.bpCount;

    for i := 1 to ProductCount do
      FProductList.Add(Banking.BankProducts.bpName[i]);
  end;
end;

procedure TfrmBankList.WMUpdateList(var Message: TMessage);
begin
  LoadList;
end;

procedure TfrmBankList.mlBanksRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnEditClick(Self);
end;

procedure TfrmBankList.FormResize(Sender: TObject);
begin
  Panel1.Width := ClientWidth - 8;
  Panel1.Height := ClientHeight - 10;

  pnlButtons.Left := Panel1.Width - pnlButtons.Width - 4;
  pnlButtons.Height := Panel1.Height - 8;

  pnlBanks.Width := pnlButtons.Left - 8;
  pnlBanks.Height := pnlButtons.Height;
end;

procedure TfrmBankList.WMSysCommand(var Message: TMessage);
begin
  With Message do
    Case WParam of

      SC_Maximize  :  Begin
                        {Self.Height:=InitSize.Y;
                        Self.Width:=InitSize.X;}

                       { Self.ClientHeight:=InitSize.Y;
                        Self.ClientWidth:=InitSize.X;}

                        WParam:=0;
                      end;

    end; {Case..}

  Inherited;
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
end;

procedure TfrmBankList.LoadAllSettings;
begin
end;


Exports
  ShowEBankList;


Initialization
  oToolkit := nil;
  frmBankList := nil;
  sDataPath := '';

Finalization
  oToolkit := nil;

end.
