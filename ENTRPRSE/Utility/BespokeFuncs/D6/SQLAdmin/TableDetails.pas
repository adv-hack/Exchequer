unit TableDetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , SpecialPassword, SQLLogin, AdminProc, APIUtil, BespokeXML, Dialogs, MiscUtil
  , ExtCtrls, StdCtrls, BespokeFuncsInterface;

type
  TfrmTableDetails = class(TForm)
    bev1: TBevel;
    Label1: TLabel;
    edName: TEdit;
    Label3: TLabel;
    btnCancel: TButton;
    btnOK: TButton;
    Label4: TLabel;
    lParentDBase: TLabel;
    Label2: TLabel;
    lTableStatus: TLabel;
    bev2: TBevel;
    btnCreate: TButton;
    lbScripts: TListBox;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRunScripts: TButton;
    btnView: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnRunScriptsClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure lbScriptsDblClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
  private
    procedure EnableDisable;
  public
    FormMode : TFormMode;
    TableInfo : TTableInfo;
  end;

var
  frmTableDetails: TfrmTableDetails;

implementation

uses DatabaseDetails, ScriptDetails;

{$R *.dfm}

procedure TfrmTableDetails.FormShow(Sender: TObject);
var
  iPos : integer;
begin
  edName.Text := TableInfo.Name;
  lParentDBase.Caption := TableInfo.ParentDatabase;

  For iPos := 0 to TableInfo.Scripts.Count-1 do
  begin
    lbScripts.Items.Add(TScriptInfo(TableInfo.Scripts.Objects[iPos]).Name);
  end;{for}
  if lbScripts.Items.Count > 0 then lbScripts.ItemIndex := 0;

  TableInfo.GetStatus(formmode <> fmAdd);
  EnableDisable;
end;

procedure TfrmTableDetails.btnOKClick(Sender: TObject);

  function CheckCode(sCode : string) : boolean;
  begin{CheckCode}
    Result := (Length(sCode) = 16) and (StrToIntDef(Copy(sCode, 11, 6), -1) > 0);
  end;{CheckCode}

begin
  if (Trim(edName.Text) = '') then
  begin
    MsgBox('Please populate the fields with a valid value.', mtWarning, [mbOK], mbOK, 'Input Error');
  end
  else
  begin
    ModalResult := mrOK;
  end;{if}
end;

procedure TfrmTableDetails.EnableDisable;
begin
  if FormMode <> fmAdd then lTableStatus.Caption := SQLStatusDescs[TableInfo.Status];
  ColourControlForErrors(lTableStatus, TableInfo.Status <> SQL_CREATED);
  btnCreate.enabled := (TableInfo.Status = SQL_CREATED) and bLoggedIn and (FormMode <> fmAdd);

  btnAdd.enabled := (FormMode <> fmAdd) and bLoggedIn;
  btnEdit.enabled := btnAdd.enabled and (lbScripts.Items.Count > 0) and (lbScripts.ItemIndex >= 0) and bLoggedIn;
  btnDelete.enabled := btnEdit.enabled;
  btnView.enabled := (lbScripts.Items.Count > 0) and (lbScripts.ItemIndex >= 0);
  btnRunScripts.enabled := (TableInfo.Status = SQL_NOT_CREATED) and (FormMode <> fmAdd) and btnEdit.enabled;
  edName.ReadOnly := not bLoggedIn;

  btnOK.enabled := bLoggedIn;
end;

procedure TfrmTableDetails.btnRunScriptsClick(Sender: TObject);
var
  SQLLoginDetails : TSQLLoginDetails;
begin
  if GetSQLLoginDetails(SQLLoginDetails) then
  begin
    TableInfo.RunScripts(SQLLoginDetails, TRUE);
    TableInfo.GetStatus(TRUE);
    EnableDisable;
  end;{if}
end;

procedure TfrmTableDetails.btnEditClick(Sender: TObject);
{var
  asOriginalName : ANSIstring;
  iResult : integer;}
begin
  if EditScript(TScriptInfo(TableInfo.Scripts.Objects[lbScripts.ItemIndex]), lbScripts)
  then EnableDisable;
{
  frmScriptDetails := TfrmScriptDetails.Create(self);
  frmScriptDetails.FormMode := fmEdit;
  frmScriptDetails.ScriptInfo := TScriptInfo(TableInfo.Scripts[lbScripts.ItemIndex]);
  asOriginalName := frmScriptDetails.ScriptInfo.Name;
  if frmScriptDetails.ShowModal = mrOK then
  begin
    iResult := frmScriptDetails.ScriptInfo.Update(trim(frmScriptDetails.edName.Text), TStringList(frmScriptDetails.memScript.Lines));

    if iResult = 0 then
    begin
      lbScripts.Items[lbScripts.ItemIndex] := frmScriptDetails.ScriptInfo.Name;
      EnableDisable;
    end
    else
    begin
      MsgBox('An error occurred when calling ScriptInfo.Update :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'ScriptInfo.Update Error');
    end;{if}
{  end;{if}
//  frmScriptDetails.Release;
end;

procedure TfrmTableDetails.lbScriptsDblClick(Sender: TObject);
begin
//  if btnEdit.Enabled then btnEdit.Click;
  btnView.Click;
end;

procedure TfrmTableDetails.btnAddClick(Sender: TObject);
{var
//  asOriginalName : ANSIstring;
  iResult : integer;
  ScriptInfo : TScriptInfo;}
begin

  if AddScript(TableInfo.ParentDatabase, TableInfo.Name, TableInfo.ParentCode, lbScripts, TableInfo.Scripts)
  then EnableDisable;

{  frmScriptDetails := TfrmScriptDetails.Create(self);
  frmScriptDetails.FormMode := fmAdd;
  frmScriptDetails.ScriptInfo := TScriptInfo.Create;
  frmScriptDetails.ScriptInfo.ParentDatabase := TableInfo.ParentDatabase;
  frmScriptDetails.ScriptInfo.ParentTable := TableInfo.Name;
  frmScriptDetails.ScriptInfo.ParentCode := TableInfo.ParentCode;
  if frmScriptDetails.ShowModal = mrOK then
  begin
    frmScriptDetails.ScriptInfo.Name := trim(frmScriptDetails.edName.Text);

    frmScriptDetails.ScriptInfo.Script.Assign(frmScriptDetails.memScript.Lines);
    iResult := frmScriptDetails.ScriptInfo.Add;

    if iResult = 0 then
    begin
      ScriptInfo := TScriptInfo.Create;
      ScriptInfo.CopyFrom(frmScriptDetails.ScriptInfo);

      lbScripts.Items.Add(ScriptInfo.Name);
      lbScripts.ItemIndex := lbScripts.Items.Count-1;
      EnableDisable;

      TableInfo.Scripts.Add(ScriptInfo);
    end
    else
    begin
      MsgBox('An error occurred when calling ScriptInfo.Add :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'ScriptInfo.Add Error');
    end;{if}
{  end
  else
  begin
    frmScriptDetails.ScriptInfo.Free;
  end;{if}
//  frmScriptDetails.Release;
end;

procedure TfrmTableDetails.btnDeleteClick(Sender: TObject);
begin
  if DeleteScript(lbScripts.ItemIndex, lbScripts, TableInfo.Scripts)
  then EnableDisable;
{
  if MsgBox('Are you sure you want to delete this script from the list ?'#13#13
  + 'Doing so may stop your Exchequer Plug-Ins from operating correctly.'#13#13
  + 'Note : This only deletes the script it does not affect the SQL Table/Database itself.'
  , mtWarning, [mbYes, mbNo], mbNo, 'Delete Script') = mrYes then
  begin
    iResult := TScriptInfo(TableInfo.Scripts[lbScripts.ItemIndex]).Delete;

    if iResult = 0 then
    begin
      TScriptInfo(TableInfo.Scripts[lbScripts.ItemIndex]).Free;
      TableInfo.Scripts.Delete(lbScripts.ItemIndex);

      lbScripts.Items.Objects[lbScripts.ItemIndex].Free;
      lbScripts.Items.Delete(lbScripts.ItemIndex);

      lbScripts.ItemIndex := 0;

      EnableDisable;
    end
    else
    begin
      MsgBox('An error occurred when calling TScriptInfo.Delete :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'TScriptInfo.Delete Error');
    end;{if}
{  end;{if}
end;

procedure TfrmTableDetails.FormDestroy(Sender: TObject);
begin
//  ClearList(lbScripts.Items);
end;

procedure TfrmTableDetails.btnViewClick(Sender: TObject);
begin
  EditScript(TScriptInfo(TableInfo.Scripts.Objects[lbScripts.ItemIndex]), lbScripts);
end;

end.
