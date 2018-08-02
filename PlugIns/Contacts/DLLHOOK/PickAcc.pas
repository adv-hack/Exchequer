unit PickAcc;

{ nfrewer440 08:54 01/09/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , COMObj, Enterprise01_TLB, Dialogs, StdCtrls, ComCtrls, VarConst, CTKUtil
  , uExDatasets, uComTKDataset, ExtCtrls, uMultiList, uDBMultiList, Menus
  , uSettingsSQL, DataModule, EnterpriseBeta_TLB;
//  {$IFNDEF PRE_571002_MULTILIST}
//    EnterpriseBeta_TLB;
//  {$ENDIF}


type
  TfrmPickAccount = class(TForm)
    pcAccounts: TPageControl;
    tsCustomers: TTabSheet;
    tsSuppliers: TTabSheet;
    btnRefresh: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    mlSuppliers: TDBMultiList;
    tkdsSuppliers: TComTKDataset;
    mlCustomers: TDBMultiList;
    tkdsCustomers: TComTKDataset;
    pmMain: TPopupMenu;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tkdsGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure mlCustomersRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlSuppliersRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    oToolkit : IToolkit;
    bRestore : boolean;
//    bAccountsListLoaded : boolean;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
    procedure FillAccountsList;
    function GetAddressfor(Cust : IAccount) : string;
  public
    bShowAll : boolean;
  end;

//var
//  sDataPath : string;


implementation

{$R *.dfm}

procedure TfrmPickAccount.FormShow(Sender: TObject);
begin
//  if not bAccountsListLoaded then btnRefreshClick(self);
end;

procedure TfrmPickAccount.btnRefreshClick(Sender: TObject);
begin
  FillAccountsList;
end;

procedure TfrmPickAccount.FormCreate(Sender: TObject);
begin
  screen.cursor := crhourglass;
  application.ProcessMessages;

  bRestore := FALSE;
  bShowAll := FALSE;

  LoadAllSettings;

  oToolkit := OpenToolkit(asCompanyPath, TRUE);

  {$IFDEF PRE_571002_MULTILIST}
    tkdsSuppliers.ToolkitObject := oToolkit.Supplier as IBtrieveFunctions2;
    tkdsCustomers.ToolkitObject := oToolkit.Customer as IBtrieveFunctions2;
  {$ELSE}
    tkdsSuppliers.ToolkitObject := oToolkit.Supplier as IDatabaseFunctions;
    tkdsCustomers.ToolkitObject := oToolkit.Customer as IDatabaseFunctions;
  {$ENDIF}

  mlSuppliers.Active := TRUE;
  mlCustomers.Active := TRUE;

//  bAccountsListLoaded := FALSE;
  pcAccounts.ActivePage := tsCustomers;

  screen.cursor := crDefault;
end;

function TfrmPickAccount.GetAddressfor(Cust : IAccount) : string;
// Creates address string
var
  iLine : integer;
begin
  Result := '';
  for iLine := 1 to 5 do begin
    if Trim(Cust.acAddress.Lines[iLine]) <> ''
    then begin
      if Result = '' then Result := Cust.acAddress.Lines[iLine]
      else Result := Result + ', ' + Cust.acAddress.Lines[iLine];
    end;{if}
  end;{for}
end;{GetAddressfor}

procedure TfrmPickAccount.FillAccountsList;
var
  FuncRes : LongInt;

  procedure AddAllAccounts(Account : IAccount; TheListView : TListView);
  // Adds all the Accounts in the given IAccount to the list
  begin{AddAllAccounts}
    with Account, TheListView do begin
      index := acIdxCode;
      FuncRes := GetFirst;
      TheListView.Items.BeginUpdate; {v6.30.041 - ABSEXCH-9490}
      while (FuncRes = 0) do begin
        with items.add do begin
          caption := acCode;
          subitems.add(Trim(acCompany));
          SubItems.Add(GetAddressfor(Account));
        end;{with}
        FuncRes := GetNext;
      end;{while}
      TheListView.Items.EndUpdate; {v6.30.041 - ABSEXCH-9490}
    end;{with}
  end;{AddAllAccounts}

  procedure Select1stItemInList(TheListView : TListView);
  begin{Select1stItemInList}
    with TheListView.Items do begin
      if Count > 0 then begin
        item[0].Focused := TRUE;
        item[0].Selected := TRUE;
      end;{if}
    end;{with}
  end;{Select1stItemInList}

begin
(*  Screen.Cursor := crHourglass;

  try
    if Assigned(oToolkit) then begin
      with oToolkit do begin
//        lvCustomers.items.clear;
//        lvSuppliers.items.clear;

//        AddAllAccounts(Customer, lvCustomers);
//        AddAllAccounts(Supplier, lvSuppliers);

//        bAccountsListLoaded := TRUE;

      end;{with}
    end{if}
    else showmessage('Cannot create COM Toolkit');*)

//    Select1stItemInList(lvCustomers);
//    Select1stItemInList(lvSuppliers);

    if pcAccounts.ActivePage = tsCustomers then btnOK.Enabled := mlCustomers.itemsCount > 0
    else btnOK.Enabled := mlSuppliers.itemsCount > 0;

{  finally
    Screen.Cursor := crDefault;
  end;{try}

end;


{procedure TfrmPickAccount.FormDestroy(Sender: TObject);
begin
//  frmPickAccount := nil;
end;}

procedure TfrmPickAccount.FormDestroy(Sender: TObject);
begin
  oToolkit.CloseToolkit;
  oToolkit := nil;
end;

procedure TfrmPickAccount.tkdsGetFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
begin
  with ID as IAccount do begin
    case FieldName[1] of
      'C' : FieldValue := acCode;
      'N' : FieldValue := acCompany;
      'A' : FieldValue := GetAddressfor(ID as IAccount);
    end;
  end;
end;

procedure TfrmPickAccount.mlCustomersRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  if mlCustomers.Selected >= 0 then  ModalResult := mrOK;
end;

procedure TfrmPickAccount.mlSuppliersRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  if mlSuppliers.Selected >= 0 then  ModalResult := mrOK;
end;

procedure TfrmPickAccount.Properties1Click(Sender: TObject);
var
  mlList : TMultiList;
begin
  if pcAccounts.ActivePage = tsCustomers then
  begin
    mlList := mlCustomers;
  end else
  begin
    mlList := mlSuppliers;
  end;{if}

  case oSettings.Edit(mlList, Self.Name, nil) of
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      oSettings.RestoreListDefaults(mlList, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmPickAccount.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TfrmPickAccount.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadList(mlCustomers, Self.Name);
  oSettings.LoadList(mlSuppliers, Self.Name);
end;

procedure TfrmPickAccount.SaveAllSettings;
begin
  oSettings.SaveList(mlCustomers, Self.Name);
  oSettings.SaveList(mlSuppliers, Self.Name);

  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmPickAccount.Button1Click(Sender: TObject);
begin
  bShowAll := TRUE;
end;

end.
