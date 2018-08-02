unit DatabaseDetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , AdminProc, SQLLogin, APIUtil, BespokeXML, Dialogs, MiscUtil, ExtCtrls
  , StdCtrls, ScriptDetails;

type
  TfrmDatabaseDetails = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    edCode: TEdit;
    edDesc: TEdit;
    edDatabase: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    btnCancel: TButton;
    btnOK: TButton;
    Label5: TLabel;
    lDBStatus: TLabel;
    btnCreateDelete: TButton;
    bev1: TBevel;
    Label4: TLabel;
    lbScripts: TListBox;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRunScripts: TButton;
    btnView: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edCodeExit(Sender: TObject);
    procedure btnRunScriptClick(Sender: TObject);
    procedure btnCreateDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure lbScriptsDblClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRunScriptsClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
  private
    procedure EnableDisable;
  public
    FormMode : TFormMode;
    DatabaseInfo : TDatabaseInfo;
  end;

{var
  frmDatabaseDetails: TfrmDatabaseDetails;}

implementation

{$R *.dfm}

procedure TfrmDatabaseDetails.FormShow(Sender: TObject);
var
  iPos : integer;
begin
  edCode.Text := DatabaseInfo.Code;
  edDesc.Text := DatabaseInfo.Description;
  edDatabase.Text := DatabaseInfo.Database;
//  frmDatabaseDetails.memCreate.Lines.Assign(frmDatabaseDetails.DatabaseInfo.CreationScript);

  For iPos := 0 to DatabaseInfo.Scripts.Count-1 do
  begin
    lbScripts.Items.Add(TScriptInfo(DatabaseInfo.Scripts.Objects[iPos]).Name);
  end;{for}
  if lbScripts.Items.Count > 0 then lbScripts.ItemIndex := 0;

  DatabaseInfo.GetStatus;

  EnableDisable;
end;

procedure TfrmDatabaseDetails.btnOKClick(Sender: TObject);

  function CheckCode(sCode : string) : boolean;
  begin{CheckCode}
    Result := (Length(sCode) = 16) and (StrToIntDef(Copy(sCode, 11, 6), -1) > 0);
  end;{CheckCode}

begin
  if (Trim(edCode.Text) = '') or (Trim(edDesc.Text) = '') or (Trim(edDatabase.Text) = '') then
  begin
    MsgBox('Please populate the fields with a valid value.', mtWarning, [mbOK], mbOK, 'Input Error');
  end
  else
  begin
    if not CheckCode(Trim(edCode.Text)) then
    begin
      MsgBox('Please populate the code field with a valid code.', mtWarning, [mbOK], mbOK, 'Input Error');
    end
    else
    begin
      ModalResult := mrOK;
    end;{if}
  end;{if}
end;

procedure TfrmDatabaseDetails.edCodeExit(Sender: TObject);
begin
  if (Trim(edDatabase.Text) = '') and (Trim(edCode.Text) <> '')
  then edDatabase.Text := 'ExchBespoke_' + edCode.Text;
end;

procedure TfrmDatabaseDetails.EnableDisable;
begin
  if FormMode <> fmAdd then lDBStatus.Caption := SQLStatusDescs[DatabaseInfo.Status];
  ColourControlForErrors(lDBStatus, DatabaseInfo.Status <> SQL_CREATED);
  if DatabaseInfo.Status = SQL_CREATED then btnCreateDelete.Caption := '&Delete';
  if DatabaseInfo.Status = SQL_NOT_CREATED then btnCreateDelete.Caption := '&Create';
  btnCreateDelete.Enabled := (FormMode <> fmAdd) and ((DatabaseInfo.Status = SQL_NOT_CREATED) or bLoggedIn);

  edCode.ReadOnly := not bLoggedIn;
  edDesc.ReadOnly := not bLoggedIn;
  edDatabase.ReadOnly := not bLoggedIn;

  btnAdd.enabled := (FormMode <> fmAdd) and bLoggedIn;
  btnEdit.enabled := btnAdd.enabled and (lbScripts.Items.Count > 0) and (lbScripts.ItemIndex >= 0) and bLoggedIn;
  btnDelete.enabled := btnEdit.enabled;
  btnView.enabled := (lbScripts.Items.Count > 0) and (lbScripts.ItemIndex >= 0);
  btnRunScripts.enabled := (DatabaseInfo.Status = SQL_NOT_CREATED) and (FormMode <> fmAdd) and btnEdit.enabled;

  btnOK.enabled := bLoggedIn;
//  btnCreateDelete.enabled := DatabaseInfo.Status = SQL_CREATED;
//  btnRunScript.enabled := DatabaseInfo.Status = SQL_NOT_CREATED;
end;

procedure TfrmDatabaseDetails.btnRunScriptClick(Sender: TObject);
begin
  DatabaseInfo.GetStatus;
  EnableDisable;
end;

procedure TfrmDatabaseDetails.btnCreateDeleteClick(Sender: TObject);
var
  SQLLoginDetails : TSQLLoginDetails;
begin
  if DatabaseInfo.Status = SQL_CREATED then
  begin
    // Delete
    if MsgBox('Are you sure you want to delete this database ?'#13#13
    + 'This could mean the loss of all your data, for this Plug-In.', mtWarning
    , [mbYes, mbNo], mbNo, 'Delete SQL Database') = mrYes then
    begin
      if GetSQLLoginDetails(SQLLoginDetails) then
      begin
        if DatabaseInfo.SQLDelete(SQLLoginDetails) = 0
        then MsgBox('Database Created Successfully.', mtInformation, [mbOK], mbOK, 'SQLDatabaseDelete');
      end;{if}
    end;{if}
  end;{if}

  if DatabaseInfo.Status = SQL_NOT_CREATED then
  begin
    // Create
    if GetSQLLoginDetails(SQLLoginDetails) then
    begin
      if DatabaseInfo.SQLCreate(SQLLoginDetails) = 0
      then MsgBox('Database Created Successfully.', mtInformation, [mbOK], mbOK, 'SQLDatabaseCreate');
    end;
  end;{if}

  DatabaseInfo.GetStatus;
  EnableDisable;
end;

procedure TfrmDatabaseDetails.btnEditClick(Sender: TObject);
begin
  if EditScript(TScriptInfo(DatabaseInfo.Scripts.Objects[lbScripts.ItemIndex]), lbScripts)
  then EnableDisable;
end;

procedure TfrmDatabaseDetails.lbScriptsDblClick(Sender: TObject);
begin
//  if btnEdit.Enabled then btnEdit.Click;
  btnView.Click;
end;

procedure TfrmDatabaseDetails.btnAddClick(Sender: TObject);
begin
  if AddScript(DatabaseInfo.Database, '', DatabaseInfo.Code, lbScripts, DatabaseInfo.Scripts)
  then EnableDisable;
end;

procedure TfrmDatabaseDetails.btnDeleteClick(Sender: TObject);
begin
  if DeleteScript(lbScripts.ItemIndex, lbScripts, DatabaseInfo.Scripts)
  then EnableDisable;
end;

procedure TfrmDatabaseDetails.btnRunScriptsClick(Sender: TObject);
var
  SQLLoginDetails : TSQLLoginDetails;
begin
  if GetSQLLoginDetails(SQLLoginDetails) then
  begin
    DatabaseInfo.RunScripts(SQLLoginDetails, TRUE);
    DatabaseInfo.GetStatus(TRUE);
    EnableDisable;
  end;{if}
end;

procedure TfrmDatabaseDetails.btnViewClick(Sender: TObject);
begin
  EditScript(TScriptInfo(DatabaseInfo.Scripts.Objects[lbScripts.ItemIndex]), lbScripts);
end;

end.
