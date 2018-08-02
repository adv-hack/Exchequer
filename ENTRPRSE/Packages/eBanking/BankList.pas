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
    procedure btnDeleteClick(Sender: TObject);
    procedure btnStatementClick(Sender: TObject);
    procedure mlBanksRowClick(Sender: TObject; RowIndex: Integer);
    procedure mlBanksKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mlBanksChangeSelection(Sender: TObject);
  private
    { Private declarations }
    FOnFormClosed : TNotifyProc;
    FfrmBankDetails : TfrmBankDetails;
    FProductList : TStringList;
    bRestore : Boolean;
    InitSize : TPoint;
    procedure DetailFormClosed(Sender : TObject);
    procedure ShowDetails(const oBankAccount : IBankAccount; Mode : Byte);
    procedure LoadProducts;
    function GetSelected : Integer;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
    procedure UpdateDetailsForm;
  public
    { Public declarations }
    procedure LoadList;
    procedure WMUpdateList(var Message : TMessage); message WM_UpdateList;
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    property OnFormClosed : TNotifyProc read FOnFormClosed write FOnFormClosed;
  end;

  function StartToolkit(const DataPath : string; FirstTime : Boolean = True) : Integer;
  procedure ShowEBankList(const DataPath, UserID : AnsiString); Export;

var
  frmBankList: TfrmBankList;

implementation

{$R *.dfm}
uses
  CtkUtil;

var
  oToolkit : IToolkit3;

procedure FormClosed(Sender : TObject);
begin
  frmBankList := nil;
end;

procedure ShowEBankList(const DataPath, UserID : AnsiString);
begin
  sMiscDirLocation := DataPath;

  oSettings.EXEName := ExtractFilename(GetModuleName(HInstance));

  if frmBankList = nil then
  begin
    StartToolkit(DataPath);
    frmBankList := TfrmBankList.Create(Application.MainForm);
    frmBankList.OnFormClosed := FormClosed;
    frmBankList.LoadList;
    frmBankList.mlBanks.Selected := 0;
  end;

  frmBankList.BringToFront;
end;

procedure TfrmBankList.FormCreate(Sender: TObject);
begin
  {For some reason when creating the form in Exchequer it is a lot larger. Hard-code to
  initial size here.}
  Height := 317;
  Width := 455;
  frmBankDetails := nil;
  FProductList := TStringList.Create;
  LoadProducts;
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
  if not bRestore then SaveAllSettings;
  if Assigned(FOnFormClosed) then
    FOnFormClosed(Self);
  Action := caFree;
  if Assigned(FfrmBankDetails) then
    FfrmBankDetails.Close;
end;

procedure TfrmBankList.btnAddClick(Sender: TObject);
begin
  ShowDetails(oToolkit.Banking.BankAccount.Add, bdmAdd);
end;

procedure TfrmBankList.DetailFormClosed(Sender: TObject);
begin
  FfrmBankDetails := nil;
end;

function StartToolkit(const DataPath : string; FirstTime : Boolean = True) : Integer;
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
//    FfrmBankDetails.pgDetailsChange(FfrmBankDetails.pgDetails);
    FfrmBankDetails.ParentHandle := Self.Handle;
    FfrmBankDetails.Toolkit := oToolkit;

    FfrmBankDetails.BankAccount := oBankAccount;
    FfrmBankDetails.Mode := Mode;
    FfrmBankDetails.SetFields;
  end
  else
  if (FfrmBankDetails.Mode = bdmView) and (Mode = bdmEdit) then
  begin
    FfrmBankDetails.BankAccount := oBankAccount;
    FfrmBankDetails.Mode := Mode;
    FfrmBankDetails.SetFields;
  end;
  FfrmBankDetails.BringToFront;
  FfrmBankDetails.ShowDelete;
end;

procedure TfrmBankList.FormDestroy(Sender: TObject);
begin
  if Assigned(FProductList) then
    FProductList.Free;
  if Assigned(oToolkit) then
  begin
    if oToolkit.Status = tkOpen then
      oToolkit.CloseToolkit;
    oToolkit := nil;
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
                        Self.Height:=InitSize.Y;
                        Self.Width:=InitSize.X;

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
    ShowDetails(oToolkit.Banking.BankAccount, bdmDelete);
end;

procedure TfrmBankList.btnStatementClick(Sender: TObject);
begin
  ShowDetails(oToolkit.Banking.BankAccount, bdmStatements);
end;

procedure TfrmBankList.mlBanksRowClick(Sender: TObject; RowIndex: Integer);
begin
//  UpdateDetailsForm;
end;


Exports
  ShowEBankList;

procedure TfrmBankList.mlBanksKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
{  if Key in [VK_UP, VK_DOWN] then
    UpdateDetailsForm;}
end;

procedure TfrmBankList.UpdateDetailsForm;
begin
  if Assigned(FfrmBankDetails) and (FfrmBankDetails.Mode = bdmView) then
    if GetSelected = 0 then
    begin
      FfrmBankDetails.BankAccount := oToolkit.Banking.BankAccount;
      FfrmBankDetails.SetFields;
    end;
end;

procedure TfrmBankList.mlBanksChangeSelection(Sender: TObject);
begin
  UpdateDetailsForm;
end;

Initialization
  oToolkit := nil;
  frmBankList := nil;

Finalization
//  oToolkit := nil;

end.
