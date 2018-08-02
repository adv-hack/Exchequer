unit ScriptDetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , SpecialPassword, SQLLogin, AdminProc, APIUtil, BespokeXML, Dialogs, MiscUtil
  , ExtCtrls, StdCtrls, BespokeFuncsInterface;

type
  TfrmScriptDetails = class(TForm)
    bev1: TBevel;
    btnCancel: TButton;
    btnOK: TButton;
    memScript: TMemo;
    bev2: TBevel;
    btnRunScript: TButton;
    Label1: TLabel;
    edName: TEdit;
    cbCreateDatabase: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnRunScriptClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    procedure EnableDisable;
  public
    FormMode : TFormMode;
    ScriptInfo : TScriptInfo;
  end;

  function AddScript(asParentDatabase, asParentTable, asParentCode : ANSIString; lbScripts : TListBox; slScripts : TStringList) : boolean;
  function EditScript(ScriptInfo : TScriptInfo; lbScripts : TListBox) : boolean;
  function DeleteScript(iIndex : integer; lbScripts : TListBox; slScripts : TStringList) : boolean;

{var
  frmScriptDetails: TfrmScriptDetails;}

implementation

uses DatabaseDetails;

{$R *.dfm}

procedure TfrmScriptDetails.FormShow(Sender: TObject);
begin
  edName.Text := ScriptInfo.Name;
  cbCreateDatabase.Checked := ScriptInfo.CreateDatabase;
  memScript.Lines.Assign(ScriptInfo.Script);
  EnableDisable;
end;

procedure TfrmScriptDetails.btnOKClick(Sender: TObject);
begin
  if (Trim(edName.Text) = '') then
  begin
    MsgBox('Please populate the Script Name with a valid value.', mtWarning, [mbOK], mbOK, 'Script Name');
  end
  else
  begin
    ModalResult := mrOK;
  end;{if}
end;

procedure TfrmScriptDetails.EnableDisable;
begin
//  btnRunScript.enabled := (TableInfo.Status = SQL_NOT_CREATED) and (FormMode <> fmAdd);
  edName.ReadOnly := not bLoggedIn;
  memScript.ReadOnly := not bLoggedIn;
  cbCreateDatabase.Enabled := bLoggedIn;
  btnRunScript.Enabled := bLoggedIn;
  btnOK.enabled := bLoggedIn;
end;

procedure TfrmScriptDetails.btnRunScriptClick(Sender: TObject);
var
  SQLLoginDetails : TSQLLoginDetails;
begin
  if GetSQLLoginDetails(SQLLoginDetails) then
  begin
    ScriptInfo.Script.Assign(memScript.Lines);
    ScriptInfo.RunScript(SQLLoginDetails, TRUE);
    EnableDisable;
  end;{if}
end;

procedure TfrmScriptDetails.FormResize(Sender: TObject);
begin
  edName.Width := ClientWidth - 129;
  bev1.Width := ClientWidth - 17;
  bev2.Width := ClientWidth - 17;
  memScript.Width := ClientWidth - 33;
  btnRunScript.Left := ClientWidth - 98;
  btnCancel.Left := ClientWidth - 90;
  btnOK.Left := ClientWidth - 178;

  bev1.Height := ClientHeight - 44;
  memScript.Height := ClientHeight - 172;
  btnRunScript.Top := ClientHeight - 69;
  btnOK.Top := ClientHeight - 29;
  btnCancel.Top := ClientHeight - 29;
end;

function AddScript(asParentDatabase, asParentTable, asParentCode : ANSIString; lbScripts : TListBox; slScripts : TStringList) : boolean;
var
  frmScriptDetails: TfrmScriptDetails;
  iResult : integer;
  ScriptInfo : TScriptInfo;
begin
  frmScriptDetails := TfrmScriptDetails.Create(nil);
  frmScriptDetails.FormMode := fmAdd;
  frmScriptDetails.ScriptInfo := TScriptInfo.Create;
  frmScriptDetails.ScriptInfo.ParentDatabase := asParentDatabase;
  frmScriptDetails.ScriptInfo.ParentTable := asParentTable;
  frmScriptDetails.ScriptInfo.ParentCode := asParentCode;
  if frmScriptDetails.ShowModal = mrOK then
  begin
    frmScriptDetails.ScriptInfo.Name := trim(frmScriptDetails.edName.Text);
    frmScriptDetails.ScriptInfo.Order := lbScripts.Count+1;
    frmScriptDetails.ScriptInfo.CreateDatabase := frmScriptDetails.cbCreateDatabase.checked;

    frmScriptDetails.ScriptInfo.Script.Assign(frmScriptDetails.memScript.Lines);
    iResult := frmScriptDetails.ScriptInfo.Add;

    if iResult = 0 then
    begin
      ScriptInfo := TScriptInfo.Create;
      ScriptInfo.CopyFrom(frmScriptDetails.ScriptInfo);

      lbScripts.Items.Add(ScriptInfo.Name);
      lbScripts.ItemIndex := lbScripts.Items.Count-1;

      slScripts.AddObject(IntToStr(lbScripts.Count-1), ScriptInfo);
    end
    else
    begin
      MsgBox('An error occurred when calling ScriptInfo.Add :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'ScriptInfo.Add Error');
    end;{if}
  end
  else
  begin
    frmScriptDetails.ScriptInfo.Free;
  end;{if}
  frmScriptDetails.Release;
  Result := iResult = 0;
end;

// if EditScript(TScriptInfo(TableInfo.Scripts[lbScripts.ItemIndex]), lbScripts);
// then EnableDisable;
function EditScript(ScriptInfo : TScriptInfo; lbScripts : TListBox) : boolean;
var
  asOriginalName : ANSIstring;
  iResult : integer;
  frmScriptDetails : TfrmScriptDetails;
begin
  frmScriptDetails := TfrmScriptDetails.Create(nil);
  frmScriptDetails.FormMode := fmEdit;
  frmScriptDetails.ScriptInfo := ScriptInfo;
  asOriginalName := frmScriptDetails.ScriptInfo.Name;
  if frmScriptDetails.ShowModal = mrOK then
  begin
    iResult := frmScriptDetails.ScriptInfo.Update(trim(frmScriptDetails.edName.Text)
    , TStringList(frmScriptDetails.memScript.Lines), frmScriptDetails.cbCreateDatabase.checked);

    if iResult = 0 then
    begin
      lbScripts.Items[lbScripts.ItemIndex] := frmScriptDetails.ScriptInfo.Name;
    end
    else
    begin
      MsgBox('An error occurred when calling ScriptInfo.Update :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'ScriptInfo.Update Error');
    end;{if}
  end;{if}
  frmScriptDetails.Release;
  Result := iResult = 0;
end;

function DeleteScript(iIndex : integer; lbScripts : TListBox; slScripts : TStringList) : boolean;
var
  iResult : integer;
begin
  if MsgBox('Are you sure you want to delete this script from the list ?'#13#13
  + 'Doing so may stop your Exchequer Plug-Ins from operating correctly.'#13#13
  + 'Note : This only deletes the script it does not affect the SQL Table/Database itself.'
  , mtWarning, [mbYes, mbNo], mbNo, 'Delete Script') = mrYes then
  begin
    iResult := TScriptInfo(slScripts.Objects[iIndex]).Delete;

    if iResult = 0 then
    begin
      TScriptInfo(slScripts.Objects[iIndex]).Free;
      slScripts.Delete(iIndex);

      lbScripts.Items.Objects[iIndex].Free;
      lbScripts.Items.Delete(iIndex);

      lbScripts.ItemIndex := 0;
    end
    else
    begin
      MsgBox('An error occurred when calling TScriptInfo.Delete :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'TScriptInfo.Delete Error');
    end;{if}
  end;{if}
  Result := iResult = 0;
end;




end.
