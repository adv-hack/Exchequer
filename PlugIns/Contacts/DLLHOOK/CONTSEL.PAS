unit ContSel;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , ComCtrls, StdCtrls, TCustom, ExtCtrls, ContDet, APIUtil, VarConst, PickAcc
  , uSettingsSQL, uMultiList, uDBMultiList, uExDatasets, uBtrieveDataset, Menus
  , DataModule, ADODB, Company;

type
  TContactInfo = Class
    ContactRec : TContactRecType;
  end;

  TContFormMode = (fmSelect, fmAdmin, fmSelectEmail);

  TfrmSelectContact = class(TForm)
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    btnNew: TSBSButton;
    btnRestore: TSBSButton;
    btnView: TButton;
    btnFind: TButton;
    btnPickAccount: TButton;
    mlContacts: TMultiList;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    pmMain: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Find1: TMenuItem;
    N2: TMenuItem;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    N1: TMenuItem;
    View1: TMenuItem;
    PickAccount1: TMenuItem;
    procedure btnNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnRestoreClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure lvContactsKeyPress(Sender: TObject; var Key: Char);
    procedure lvContactsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvContactsDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnPickAccountClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mlContactsChangeSelection(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure mlContactsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure Properties1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    constructor CreateWithMode(AOwner: TComponent; TheFormMode : TContFormMode);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    OpenStatus : SmallInt;
    bAllContacts, bRestore : boolean;
    FormMode : TContFormMode;
    procedure GreyInOut;
    function EditContact : integer;
//    function DeleteContact  : Smallint;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
  public
    { Public declarations }
//    CompanyCode,
    AccountCode,
    AccountName : ShortString;
    function LoadContacts : integer;
  end;

  procedure ShowContactAdmin(const {ACompanyCode,}
                                   AnAccountCode,
                                   AnAccountName : shortString); export;

//Show dialog listing all contacts for ACompany company code and AnAccount
//account code.  If OK button clicked the return contact code of selected
//contact, else return an empty string;

var
  frmSelectContact: TfrmSelectContact;

implementation

{$R *.DFM}
uses
  Enterprise01_TLB, GlobVar, BtrvU2, ETStrU, ContProc, MiscUtil;


function TfrmSelectContact.LoadContacts : integer;
var
  LStatus : smallint;
  KeyS : Str255;
  Stat : smallint;
  ContactInfo : TContactInfo;
  qContacts : TADOQuery;

  function CheckRecord : boolean;
  begin{CheckRecord}
    {NF: multi-company bug fixed in {.036}
    Result := ((AccountCode = '') and CheckIndex(ContactRec.coCompany, asCompanyCode))
    or (CheckIndex(ContactRec.coCompany, asCompanyCode) and CheckIndex(ContactRec.coAccount, AccountCode));
  end;{CheckRecord}

begin
  // clear list
  screen.cursor := crHourglass; {v6.30.041 - ABSEXCH-9491}
  mlContacts.ClearItems;

  if Assigned(SQLDataModule) then
  begin
    qContacts := SQLDataModule.SQLGetContacts(AccountCode);
    qContacts.First;

    mlContacts.BeginUpdate; {v6.30.041 - ABSEXCH-9490}

    while not qContacts.Eof do
    begin

      // Add Contact to list
      ContactInfo := TContactInfo.Create;
      PopulateContactRec(ContactRec, qContacts);
      ContactInfo.ContactRec := ContactRec;
      with ContactRec do
      begin
        mlContacts.DesignColumns[0].items.AddObject(Trim(qContacts.FieldByName('coTitle').AsString) + ' '
        + Trim(qContacts.FieldByName('coFirstName').AsString) + ' '
        + Trim(qContacts.FieldByName('coSurname').AsString), ContactInfo);
        mlContacts.DesignColumns[1].items.Add(Trim(qContacts.FieldByName('coPosition').AsString));
        mlContacts.DesignColumns[2].items.Add(GetAddressStringSQL(qContacts));
        mlContacts.DesignColumns[3].items.Add(Trim(qContacts.FieldByName('coCode').AsString));
        mlContacts.DesignColumns[4].items.Add(Trim(qContacts.FieldByName('coContactNo').AsString));
        mlContacts.DesignColumns[5].items.Add(Trim(qContacts.FieldByName('coFaxNumber').AsString));
        mlContacts.DesignColumns[6].items.Add(Trim(qContacts.FieldByName('coEmailAddr').AsString));
        mlContacts.DesignColumns[7].items.Add(Trim(qContacts.FieldByName('coAccount').AsString));
      end;{with}

      qContacts.Next;
    end;{while}

    mlContacts.EndUpdate; {v6.30.041 - ABSEXCH-9490}

    qContacts.Close;
    qContacts := nil;
  end
  else
  begin
    // Get first record required
    KeyS := BuildCodeIndex(asCompanyCode, AccountCode, '');
    LStatus := Find_Rec(B_GetGEq, F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx, KeyS);

    if (LStatus = 0) and (not CheckRecord) then LStatus := 9;
    Stat := LStatus;

    mlContacts.BeginUpdate; {v6.30.041 - ABSEXCH-9490}

    while LStatus = 0 do
    begin
      // Add Contact to list
      ContactInfo := TContactInfo.Create;
      ContactInfo.ContactRec := ContactRec;
      with ContactRec do
      begin
        mlContacts.DesignColumns[0].items.AddObject(Trim(coTitle) + ' '
        + Trim(coFirstName) + ' ' + Trim(coSurname), ContactInfo);
        mlContacts.DesignColumns[1].items.Add(Trim(coPosition));
        mlContacts.DesignColumns[2].items.Add(GetAddressString(ContactRec));
        mlContacts.DesignColumns[3].items.Add(Trim(coCode));
        mlContacts.DesignColumns[4].items.Add(Trim(coContactNo));
        mlContacts.DesignColumns[5].items.Add(Trim(coFaxNumber));
        mlContacts.DesignColumns[6].items.Add(Trim(coEmailAddr));
        mlContacts.DesignColumns[7].items.Add(Trim(coAccount));
      end;{with}

      // Get Next record required
      LStatus := Find_Rec(B_GetNext, F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx, KeyS);
      if (LStatus = 0) and (not CheckRecord) then LStatus := 9;

      Application.ProcessMessages;
    end;{while}

    mlContacts.EndUpdate; {v6.30.041 - ABSEXCH-9490}

    if (LStatus <> 0) and (LStatus <> 9)
    then ShowMessage('Error: ' + intToStr(Stat));
  end;{if}

  // Select first item in the list
  if mlContacts.ItemsCount > 0
  then mlContacts.Selected := 0;

  GreyInOut;

  Result := mlContacts.ItemsCount;
  screen.cursor := crDefault;{v6.30.041 - ABSEXCH-9491}
end;


procedure TfrmSelectContact.btnNewClick(Sender: TObject);
var
  LStatus : smallint;
  UniqueContact : Boolean;
  frmContactDetails: TfrmContactDetails;
begin
  UniqueContact := False;
  FillChar(ContactRec, SizeOf(ContactRec), #0);

  frmContactDetails := TfrmContactDetails.Create(application);
  with frmContactDetails do
  begin
   Try
      bFind := FALSE;
      bAllowEdits := TRUE;
      ShowModal;
      if ModalResult = mrOK then
      begin
       Try
        edtCode.Text := NextContactCode(asCompanyCode, edtSurname.Text);
        DetailsToRec(asCompanyCode,  AccountCode, frmContactDetails);
        LStatus := Add_rec(F[ContactF],ContactF,RecPtr[ContactF]^,0);

        if LStatus <> 0 then
           ShowMessage('Error: ' + IntToStr(LStatus))
        else
        begin
          ShowMessage('Contact added');
          LoadContacts;
        end;
       Except
        Raise;
       End;
      end; {if OK}
   Finally
    Free;
   End;
  end; {with TfrmContactDetails}
end;

procedure TfrmSelectContact.FormCreate(Sender: TObject);
begin
{  ClientHeight := 318;
  ClientWidth := 571;}

  bRestore := FALSE;
  LoadAllSettings;

  OpenStatus := 0;

  {$IFDEF EXSQL}
    if not TableExists(FileNames[ContactF]) then
  {$ELSE}
    if not FileExists(FileNames[ContactF]) then
  {$ENDIF}
    begin
      OpenStatus := Make_File(F[ContactF],FileNames[ContactF], FileSpecOfs[ContactF]^,FileSpecLen[ContactF]);
    end;{if}
  {...}

  if OpenStatus = 0 then
  begin
    if not bSQL then
    begin
      // Pervasive
      OpenStatus := Open_File(F[ContactF], FileNames[ContactF], 0);
    end;{if}
  end;{if}
end;

procedure TfrmSelectContact.btnViewClick(Sender: TObject);
begin
//  if Assigned(lvContacts.Selected)
  if mlContacts.Selected >= 0 then
//  then frmContactDetails.FillContactDetails(Company, AccountCode, TContactInfo(lvContacts.Selected.Data).ContactRec.coCode, FALSE);
  begin
    with TContactInfo(mlContacts.DesignColumns[0].items.Objects[mlContacts.Selected]).ContactRec do
    begin
      FillContactDetails(coCompany, coAccount, coCode, FALSE);
    end;{with}
  end;{if}
end;

procedure TfrmSelectContact.GreyInOut;
begin
//  btnView.Enabled := lvContacts.selected <> nil;
//  btnOK.Enabled := lvContacts.selected <> nil;
//  btnView.Enabled := mlContacts.selected >= 0;
//  btnOK.Enabled := mlContacts.selected >= 0;

  btnView.Enabled := mlContacts.selected >= 0;
  btnRestore.Enabled := (FormMode = fmSelect);
  btnCancel.Enabled := (FormMode in [fmSelect, fmSelectEmail]);
  btnOK.Enabled := (mlContacts.selected >= 0) or (FormMode = fmAdmin);

  btnAdd.Enabled := (FormMode = fmAdmin) and (AccountCode <> '');
  btnEdit.Enabled := (FormMode = fmAdmin) and btnView.Enabled;
  btnDelete.Enabled := btnEdit.Enabled;

  Add1.Enabled := btnAdd.Enabled;
  Edit1.Enabled := btnEdit.Enabled;
  Delete1.Enabled := btnDelete.Enabled;
  View1.Enabled := btnView.Enabled;
end;

procedure TfrmSelectContact.btnRestoreClick(Sender: TObject);
begin
  if MsgBox('This will restore the delivery address from the customer / supplier record into this transaction.'
  + #13#13 + 'Are you sure that you want to do this ?',mtConfirmation,[mbYes,mbNo],mbNo,'Restore Address') = mrYes
  then ModalResult := mrRetry;
end;

procedure TfrmSelectContact.btnFindClick(Sender: TObject);
var
  ListRec  : TContactRecType;
  iLine : integer;
  bFound : boolean;
  frmContactDetails: TfrmContactDetails;

  function CheckRecord : boolean;
  var
    bFound : boolean;

    function CheckField(sFind,sValue : string) : boolean;
    begin
      sFind := UpperCase(Trim(sFind));
      sValue := UpperCase(Trim(sValue));
      Result := FALSE;
      if (sFind <> '') then begin
        if (sFind = copy(sValue,1,length(sFind))) then begin
          Result := TRUE;
          bFound := TRUE;
        end;{if}
      end;{if}
    end;{CheckField}

  begin
    bFound := FALSE;
    with ContactRec do begin
      if not CheckField(coTitle,ListRec.coTitle) then
        if not CheckField(coSalutation,ListRec.coSalutation) then
          if not CheckField(coFirstName,ListRec.coFirstName) then
            if not CheckField(coSurname,ListRec.coSurname) then
              if not CheckField(coPosition,ListRec.coPosition) then
                if not CheckField(coContactNo,ListRec.coContactNo) then
                  if not CheckField(coFaxNumber,ListRec.coFaxNumber) then
                    if not CheckField(coAddress1,ListRec.coAddress1) then
                      if not CheckField(coAddress2,ListRec.coAddress2) then
                        if not CheckField(coAddress3,ListRec.coAddress3) then
                          if not CheckField(coAddress4,ListRec.coAddress4) then
                            if not CheckField(coPostCode,ListRec.coPostCode) then
                              if not CheckField(coEmailAddr,ListRec.coEmailAddr) then
    end;{with}
    Result := bFound;
  end;{CheckRecord}

begin
  FillChar(ContactRec, SizeOf(ContactRec), #0);

  frmContactDetails := TfrmContactDetails.Create(application);
  with frmContactDetails do
  begin
    Try
      Caption := 'Find Contact';
      bAllowEdits := TRUE;
      bFind := TRUE;
      ShowModal;
      if ModalResult = mrOK then begin
        DetailsToRec(asCompanyCode,  AccountCode, frmContactDetails);
        bFound := FALSE;
//        For iLine := 0 to lvContacts.Items.Count - 1 do begin
        For iLine := 0 to mlContacts.ItemsCount - 1 do begin
//          ListRec := TContactInfo(lvContacts.Items[iLine].Data).ContactRec;
          ListRec := TContactInfo(mlContacts.DesignColumns[0].items.Objects[iLine]).ContactRec;
          if CheckRecord then begin
            bFound := TRUE;
//            lvContacts.Selected := lvContacts.Items[iLine];
//            lvContacts.ItemFocused := lvContacts.Items[iLine];
            mlContacts.Selected := iLine;
            Break;
          end;{if}
        end;{for}
//        if bFound then lvContacts.SetFocus
        if bFound then mlContacts.SetFocus
        else MsgBox('No matching contact could be found.',mtInformation,[mbOK],mbOK,'Find Contact');
      end;{if}
   Finally
    Free;
   End;
  end; {with TfrmContactDetails}
end;

procedure TfrmSelectContact.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 400;
    ptMinTrackSize.Y := 278;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TfrmSelectContact.lvContactsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then ModalResult := mrOK;
end;

procedure TfrmSelectContact.lvContactsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
//  btnView.Enabled := lvContacts.selected <> nil;
//  btnOK.Enabled := lvContacts.selected <> nil;
//  btnView.Enabled := mlContacts.selected >= 0;
//  btnOK.Enabled := mlContacts.selected >= 0;
end;

procedure TfrmSelectContact.lvContactsDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmSelectContact.FormShow(Sender: TObject);
begin
   if trim(AccountCode) = '' then
   begin
     bAllContacts := TRUE;
     Caption := 'All Contacts';
     GreyInOut;
   end else
   begin
     bAllContacts := FALSE;
     Caption := 'Contacts for ' + AccountCode + ' - ' + AccountName;
   end;
//  bdsContacts.SearchKey := LJVar(Company, 6) + LJVar(AccountCode, 10);
//  mlContacts.Active := TRUE;
end;

procedure TfrmSelectContact.btnPickAccountClick(Sender: TObject);
var
  frmPickAccount: TfrmPickAccount;
begin
  frmPickAccount := TfrmPickAccount.create(application);

  if frmPickAccount.Showmodal = mrOK then begin

    if frmPickAccount.bShowAll then
    begin
      AccountCode := '';
      AccountName := '';
    end else
    begin
      if frmPickAccount.pcAccounts.ActivePage = frmPickAccount.tsCustomers then
      begin
        AccountCode := (frmPickAccount.tkdsCustomers.GetRecord as IAccount).acCode;
        AccountName := (frmPickAccount.tkdsCustomers.GetRecord as IAccount).acCompany;
      end else
      begin
        AccountCode := (frmPickAccount.tkdsSuppliers.GetRecord as IAccount).acCode;
        AccountName := (frmPickAccount.tkdsSuppliers.GetRecord as IAccount).acCompany;
      end;{if}
    end;{if}

    LoadContacts;
    Caption := 'Contacts for ' + AccountCode + ' - ' + AccountName;
  end;{if}
  frmPickAccount.Release;
end;

procedure TfrmSelectContact.FormResize(Sender: TObject);
begin
  // NF: 22/03/2010 - v6.30.042 - ABSEXCH-9672
  // for Windows 7
  mlContacts.Height := ClientHeight - 15;
  mlContacts.Width := ClientWidth - 100;
  btnAdd.Left := ClientWidth - 85;
  btnEdit.Left := btnAdd.Left;
  btnDelete.Left := btnAdd.Left;
  btnView.Left := btnAdd.Left;
  btnFind.Left := btnAdd.Left;
  btnPickAccount.Left := btnAdd.Left;
  btnRestore.Left := btnAdd.Left;
  btnCancel.Left := btnAdd.Left;
  btnOK.Left := btnAdd.Left;
end;

procedure TfrmSelectContact.mlContactsChangeSelection(Sender: TObject);
begin
  GreyInOut;
end;

//==================== Exported function =======================================

procedure ShowContactAdmin(const {ACompanyCode,}
                                 AnAccountCode,
                                 AnAccountName : shortString);
var
  frmSelectContact: TfrmSelectContact;

begin
  if bSQL then
  begin
    // MS-SQL
    SQLDataModule := TSQLDataModule.Create(nil);
    SQLDataModule.Connect;
  end
  else
  begin
    // Pervasive
    asCompanyCode := GetCompanyCode_PVSV(asCompanyPath);
  end;{if}

  frmSelectContact := TfrmSelectContact.CreateWithMode(Application, fmAdmin);
  with frmSelectContact do
  begin
    Try
//      FormMode := fmAdmin;
//      CompanyCode := asCompanyCode;
      AccountCode := AnAccountCode;
      AccountName := AnAccountName;
      LoadContacts;
      ShowModal;
    Finally
      Free;
    End;
  end;

  if Assigned(SQLDataModule) then
  begin
    SQLDataModule.Disconnect;
    SQLDataModule := nil;
  end;{if}
end;


procedure TfrmSelectContact.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;

//  if FormMode = fmAdmin then
//  begin
//    if OpenStatus = 0 then Close_File(F[ContactF]);
//  end;{if}
end;

procedure TfrmSelectContact.btnAddClick(Sender: TObject);
var
  LStatus : smallint;
  UniqueContact : Boolean;
  frmContactDetails: TfrmContactDetails;
begin
  UniqueContact := False;
  FillChar(ContactRec, SizeOf(ContactRec), #0);

  frmContactDetails := TfrmContactDetails.Create(application);
  Try
    with frmContactDetails do
    begin
      Caption := 'Add New Contact';
      bAllowEdits := TRUE;
      bFind := FALSE;
      ShowModal;
      if ModalResult = mrOK then
      begin
        Try
          edtCode.Text := NextContactCode(asCompanyCode, edtSurname.Text);
          DetailsToRec(asCompanyCode, AccountCode, frmContactDetails);
          if bSQL then
          begin
            // MS-SQL
            SQLDataModule.SQLAddContact(ContactRec);
            LoadContacts;
          end
          else
          begin
            // Pervasive
//            edtCode.Text := NextContactCode(asCompanyCode, edtSurname.Text);
//            DetailsToRec(asCompanyCode,  AccountCode, frmContactDetails);
            LStatus := Add_rec(F[ContactF],ContactF,RecPtr[ContactF]^,0);
            if LStatus = 0 then LoadContacts
            else ShowMessage('Add_Rec Error: ' + IntToStr(LStatus));
          end;{if}
        Except
          Raise;
        End;{try}
      end; {if OK}
    end; {with frmContactDetails}
  Finally
    frmContactDetails.Release;
  End;{try}
  mlContacts.SetFocus;
end;

procedure TfrmSelectContact.btnEditClick(Sender: TObject);
var
  OK : Boolean;
  LStatus : integer;
  iPrevSelected : integer;
begin
//  iPrevSelected := mlContacts.Selected;
  if (mlContacts.Selected >= 0) then
  begin
    if bSQL then
    begin
      // MS-SQL
      LStatus := EditContact;
//ShowMessage(IntToStr(LStatus));
    end
    else
    begin
      // Pervasive
      OK := False;
      While not OK do
      begin
        LStatus := EditContact;
        OK := LStatus = 0;
        if OK then
        begin
  //        ShowMessage(IntToStr(mlContacts.Selected));
        end else
        begin
          if LStatus = 84 then
            OK := MessageDlg('Record is locked by another user.  Retry?', mtInformation,
                              [mbYes, mbNo], 0) = mrNo
          else
          begin
            ShowMessage('Error ' + IntToStr(LStatus) + ' encountered'#13#13'Changes not saved');
            OK := True;
          end;
        end; {not OK}
      end; {while}
    end;{if}
  end;{if}
  mlContacts.SetFocus;
//  MultiList.Selected := MultiList.DesignColumns[3].Items.IndexOf();
end;

procedure TfrmSelectContact.btnDeleteClick(Sender: TObject);

  function DeleteContactPVSV  : Smallint;
  var
    LStatus : smallInt;
    KeyS : Str255;
  begin{DeleteContactPVSV}
    with mlContacts do
    begin
      if Selected >= 0 then
      begin
        KeyS := BuildCodeIndex(asCompanyCode, mlContacts.DesignColumns[7].items[mlContacts.Selected]
        , mlContacts.DesignColumns[3].items[mlContacts.Selected]);
        LStatus := Find_Rec(B_GetEq, F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx, KeyS);
        if LStatus = 0 then
        begin
          // Delete the record
          LStatus := Delete_rec(F[ContactF],ContactF,CoCodeIdx);
          if LStatus = 0 then LoadContacts;
        end;{if}
        Result := LStatus;
      end
      else
      begin
        Result := 32767;
      end;{if}
    end;{with}
  end;{DeleteContactPVSV}

var
  OK : Boolean;
  LStatus : SmallInt;
  sContactCode{, AName, ACode} : shortstring;
  ThisItem : integer;
begin
  OK := False;
  ThisItem := mlContacts.Selected;
  if ThisItem >= 0 then
  begin
    if MessageDlg('Are you sure you want to delete contact ' +
               Trim(mlContacts.DesignColumns[3].items[ThisItem]) + ' - ' +
               Trim(mlContacts.DesignColumns[0].items[ThisItem]) + '?', mtConfirmation,
               [mbYes,mbNo], 0) = mrYes then
    begin
      if bSQL then
      begin
        // MS-SQL
        sContactCode := TContactInfo(mlContacts.DesignColumns[0].items.Objects[ThisItem]).ContactRec.coCode;
        if SQLDataModule.SQLContactExists(sContactCode) then
        begin
          SQLDataModule.SQLDeleteContact(sContactCode);
          LoadContacts;
        end;{if}
      end
      else
      begin
        // Pervasive
        While not OK do
        begin
          LStatus := DeleteContactPVSV;
          OK := LStatus = 0;
          if not OK then
          begin
            if LStatus = 84 then
            begin
              OK := MessageDlg('Record is locked by another user.  Retry?', mtInformation, [mbYes, mbNo], 0) = mrNo;
            end
            else
            begin
              ShowMessage('Error ' + IntToStr(LStatus) + ' encountered'#13#13'Contact not deleted');
              OK := True;
            end;{if}
          end;{if}
        end; {while}
      end;{if}
    end; {if mrYes}
  end; {if Assigned}
end;

function TfrmSelectContact.EditContact : integer;
var
  iPos : integer;
  sCode : string;
begin
  if mlContacts.Selected >= 0 then
    begin
//      Result := frmContactDetails.FillContactDetails(Company, AccountCode, lvContacts.Selected.SubItems[2], TRUE);

      with TContactInfo(mlContacts.DesignColumns[0].items.Objects[mlContacts.Selected]).ContactRec do
      begin
        Result := FillContactDetails(coCompany, coAccount, coCode, TRUE);
        case Result of
          0, 999 : begin
            sCode := Trim(coCode);
            LoadContacts;

            mlContacts.Selected := mlContacts.DesignColumns[3].Items.IndexOf(sCode);

{            For iPos := 0 to mlContacts.ItemsCount - 1 do begin
              if (Trim(coCode) = sCode) then begin
                mlContacts.Selected := iPos;
              end;{if}
{            end;{for}
          end;

          -1 : Result := 0;
        end;{case}
      end;{with}
    end
  else Result := 32767;
end;

procedure TfrmSelectContact.mlContactsRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  case FormMode of
    fmAdmin : if btnEdit.Enabled then btnEditClick(btnEdit);
    fmSelect, fmSelectEmail : if btnOK.Enabled then btnOKClick(btnOK);
  end;{case}
end;

procedure TfrmSelectContact.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlContacts, Self.Name, nil) of
{    mrOK : oSettings.ColorFieldsFrom(cmbCompany, Self);}
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      oSettings.RestoreListDefaults(mlContacts, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmSelectContact.LoadAllSettings;
begin
//  sMiscDirLocation := GetEnterpriseDirectory;
  oSettings.LoadForm(Self);
//  oSettings.LoadParentToControl(Self.Name, Self.Name, cmbCompany);
//  oSettings.ColorFieldsFrom(cmbCompany, Self);
  oSettings.LoadList(mlContacts, Self.Name);
end;

procedure TfrmSelectContact.SaveAllSettings;
begin
//  oSettings.SaveParentFromControl(cmbCompany, Self.Name);
  oSettings.SaveList(mlContacts, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmSelectContact.Button1Click(Sender: TObject);
var
  LStatus : smallint;
  KeyS : Str255;
  Stat : smallint;
  ContactInfo : TContactInfo;
begin
//  lvContacts.Items.Clear;
//  ClearList(mlContacts.DesignColumns[0].items);
  mlContacts.ClearItems;

  KeyS := BuildCodeIndex(asCompanyCode, AccountCode, '');
  LStatus :=Find_Rec(B_GetFirst, F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx, KeyS);

  if LStatus = 0 then
{   if not CheckIndex(ContactRec.coCompany, Company) or
     not CheckIndex(ContactRec.coAccount, AccountCode) then
       LStatus := 9;}


{  Result := LStatus = 0;}
  Stat := LStatus;

  while LStatus = 0 do
  begin
    with {lvContacts.Items.Add,} ContactRec do
    begin
      ContactInfo := TContactInfo.Create;
      ContactInfo.ContactRec := ContactRec;
{      Caption := Trim(coTitle) + ' ' + Trim(coFirstName) + ' ' + Trim(coSurname);
      SubItems.Add(Trim(coPosition));
      SubItems.Add(GetAddressString(ContactRec));
      SubItems.Add(Trim(coContactNo));
      SubItems.Add(Trim(coFaxNumber));
      SubItems.Add(Trim(coEmailAddr));}

      mlContacts.DesignColumns[0].items.AddObject(Trim(coTitle) + ' '
      + Trim(coFirstName) + ' ' + Trim(coSurname), ContactInfo);
      mlContacts.DesignColumns[1].items.Add(Trim(coPosition));
      mlContacts.DesignColumns[2].items.Add(GetAddressString(ContactRec));
      mlContacts.DesignColumns[3].items.Add(Trim(coCode));
      mlContacts.DesignColumns[4].items.Add(Trim(coContactNo));
      mlContacts.DesignColumns[5].items.Add(Trim(coFaxNumber));
      mlContacts.DesignColumns[6].items.Add(Trim(coEmailAddr));
      mlContacts.DesignColumns[7].items.Add(Trim(coAccount));
    end;

    LStatus := Find_Rec(B_GetNext, F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx, KeyS);

{    if LStatus = 0 then
      if not CheckIndex(ContactRec.coCompany, Company) or
         not CheckIndex(ContactRec.coAccount, AccountCode) then
        LStatus := 9;}

    Application.ProcessMessages;
  end;

{  if lvContacts.Items.Count > 0 then begin
    lvContacts.Selected := lvContacts.Items[0];
    lvContacts.ItemFocused := lvContacts.Items[0];
  end;{if}

  if mlContacts.ItemsCount > 0 then begin
    mlContacts.Selected := 0;
  end;{if}

  GreyInOut;

  if (LStatus <> 0) and (LStatus <> 9) then
    ShowMessage('Error: ' + intToStr(Stat));

//  Result := lvContacts.Items.Count;
end;

procedure TfrmSelectContact.btnOKClick(Sender: TObject);
begin
  case FormMode of
    fmAdmin : ModalResult := mrOK;

    fmSelect : begin
      if mlContacts.Selected >= 0 then ModalResult := mrOK;
    end;{if}

    fmSelectEmail : begin
      if mlContacts.Selected >= 0 then
      begin
        if Trim(TContactInfo(mlContacts.DesignColumns[0].items.Objects[mlContacts.Selected]).ContactRec.coEmailAddr)
        = '' then
        begin
          MsgBox('The contact you have selected, does not have an email addess.'
          ,mtInformation,[mbOK], mbOK, 'No Email Address');
        end else
        begin
          ModalResult := mrOK;
        end;{if}
      end;{if}
    end;{if}
  end;
end;

constructor TfrmSelectContact.CreateWithMode(AOwner: TComponent; TheFormMode: TContFormMode);
begin
  inherited create(AOwner);
  FormMode := TheFormMode;
end;

procedure TfrmSelectContact.FormDestroy(Sender: TObject);
begin
  if (OpenStatus = 0) and (not Assigned(SQLDataModule)) then
  begin
    Close_File(F[ContactF]);
  end;{if}
end;

end.
