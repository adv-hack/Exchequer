unit TillList;

{ nfrewer440 16:26 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Tillname, {NeilProc, }ComCtrls, CentData, MiscUtil;

type
  TFrmTillList = class(TForm)
    btnEdit: TButton;
    btnDelete: TButton;
    btnClose: TButton;
    btnAdd: TButton;
    lvTills: TListView;
    edName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvTillsClick(Sender: TObject);
    procedure lvTillsDblClick(Sender: TObject);
    procedure lvTillsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    oCentTillInfo : TCentralTillInfo;
    oTillInfo : TTillInfo;
    FormMode : TFormMode;
    procedure UpdateList;
//    procedure ChangeMode;
    function AddItem(iNo : integer; sName, sCompany : string) : TListItem;
    procedure EnableDisable;
  public
    { Public declarations }
  end;

var
  FrmTillList: TFrmTillList;

implementation
uses
  APIUtil, EPOSComn, EPOSCnst;

{$R *.DFM}

procedure TFrmTillList.FormCreate(Sender: TObject);
begin
  // NF: 27/04/2007 Removed as file is not SQL compatible
//  btnAdd.Enabled := (sBtrvFilename = 'TRADEC00.DAT');
//  btnEdit.Enabled := (sBtrvFilename = 'TRADEC00.DAT');
//  btnDelete.Enabled := (sBtrvFilename = 'TRADEC00.DAT');
  EnableDisable;

  oCentTillInfo := TCentralTillInfo.Load(0);

  oTillInfo := TTillInfo.Load(TRUE);
  if oTillInfo.LastErrorNo = 0 then UpdateList
  else PostMessage(Self.Handle,WM_Close,0,0);{on startup, close form on BT error}

end;

procedure TFrmTillList.FormDestroy(Sender: TObject);
begin
  oTillInfo.Unload;
  oCentTillInfo.Unload;
end;

procedure TFrmTillList.UpdateList;
var
  iPos : integer;
begin
  For iPos := 0 to oTillInfo.Names.Count - 1
  do AddItem(iPos + 1, oTillInfo.Names[iPos], TTillObject(oTillInfo.Names.Objects[iPos]).CompanyCode);

  if lvTills.Items.Count > 0 then begin
    lvTills.Selected := lvTills.Items[0];
    lvTills.ItemFocused := lvTills.Items[0];
  end;{if}

  lvTillsClick(lvTills);
end;

function TFrmTillList.AddItem(iNo : integer; sName, sCompany : string) : TListItem;
begin
  if sName <> '' then
  begin
    Result := lvTills.Items.Add;
    Result.caption := IntToStr(iNo);
    Result.SubItems.Add(sName);
    Result.SubItems.Add(sCompany);

    with oCentTillInfo do begin
      GetTillInfo(iNo);
      if LastErrorNo = 0 then Result.SubItems.Add('Yes')
      else Result.SubItems.Add('No');
    end;{with}
  end;{with}
end;


procedure TFrmTillList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTillList.btnEditClick(Sender: TObject);
begin
  if btnEdit.Enabled then begin
    if FormMode = fmView then
    begin
      if (lvTills.Selected <> nil) then begin
        FormMode := fmEdit;
        EnableDisable;
        btnAdd.Caption := '&OK';
        btnEdit.Caption := '&Cancel';
        ActiveControl := edName;
      end;{if}
    end else
    begin
      FormMode := fmView;
      EnableDisable;
      btnAdd.Caption := '&Add';
      btnEdit.Caption := '&Edit';
      lvTillsClick(lvTills);
    end;{if}
  end;{if}
end;

procedure TFrmTillList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  iTillNo, iPos : integer;
  oTill : TTillObject;
begin
  if oTillInfo.LastErrorNo = 0 then begin

    if not btnClose.Enabled then begin
      if MsgBox('You are currently editing a till name.' + #13#13
      + 'Do you wish to save the changes that you have made ?',mtConfirmation,[mbYes,mbNo],mbYes
      ,'Save Till Name') = mrYes then btnEditClick(btnEdit);
    end;{if}

    // Save edits to the list

//    ClearList(oTillInfo.Names);
//    oTillInfo.Companies.Clear;
    For iPos := 0 to oTillInfo.Names.Count -1 do
    begin
      // blank any attached objects properties
      TTillObject(oTillInfo.Names.Objects[iPos]).CompanyCode := '';

      // Blank names
      oTillInfo.Names[iPos] := '';
    end;

    // Update List
    For iPos := 0 to lvTills.Items.Count - 1 do
    begin
      iTillNo := StrToIntDef(lvTills.Items[iPos].Caption, 0);
      oTill := TTillObject(oTillInfo.Names.Objects[iTillNo -1]);
      oTill.CompanyCode := lvTills.Items[iPos].SubItems[1];
      oTillInfo.Names[iTillNo -1] := lvTills.Items[iPos].SubItems[0];
//      oTillInfo.Companies.Add(lvTills.Items[iPos].SubItems[1]);
    end;{for}
    oTillInfo.SaveListEdits;

  end;{if}
end;

procedure TFrmTillList.btnDeleteClick(Sender: TObject);
var
  iPrevItemIndex : integer;
begin
  if lvTills.items.count > 0 then begin
    if MsgBox('You are about to delete a till from your till list (' +
    lvTills.Items[lvTills.itemindex].SubItems[0] + ').' + #13#13
    + 'Are you sure you want to do this ?',mtConfirmation,[mbYes,mbNo],mbYes
    ,'Delete Till') = mrYes then begin
      with lvTills do begin
        iPrevItemIndex := ItemIndex;
        items.Delete(lvTills.itemindex);
        if iPrevItemIndex >= items.count then iPrevItemIndex := items.count -1;
        ItemIndex := iPrevItemIndex;
      end;{with}
    end;{if}
  end;{if}
end;

procedure TFrmTillList.btnAddClick(Sender: TObject);
begin
  if FormMode = fmView then
  begin
    {go into Add mode}
    FormMode := fmAdd;
    EnableDisable;
    btnAdd.Caption := '&OK';
    btnEdit.Caption := '&Cancel';
    edName.Text := '';
    ActiveControl := edName;
  end else
  begin
    {save}
    if Trim(edName.Text) <> '' then begin
      btnAdd.Caption := '&Add';
      btnEdit.Caption := '&Edit';
      Case FormMode of
//        fmAdd : lvTills.Selected := AddItem(lvTills.Items.Count + 1, edName.Text, '');
        fmAdd : lvTills.Selected := AddItem(oTillInfo.GetNextTillNo, edName.Text, '');
        fmEdit : lvTills.Selected.SubItems[0] := edName.Text;
      end;{case}
      FormMode := fmView;
      EnableDisable;
    end;{if}
  end;{if}
end;

{procedure TFrmTillList.ChangeMode;
begin
  edName.Enabled := not edName.Enabled;
  lvTills.Enabled := not lvTills.Enabled;
  btnDelete.Enabled := not btnDelete.Enabled;
  btnClose.Enabled := not btnClose.Enabled;
end;}

procedure TFrmTillList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  If (Key = VK_F1) and (Not (ssAlt In Shift)) then Application.HelpCommand(HELP_Finder,0);
end;

procedure TFrmTillList.lvTillsClick(Sender: TObject);
begin
  if (lvTills.Selected <> nil) then edName.Text := lvTills.Selected.SubItems[0];
end;

procedure TFrmTillList.lvTillsDblClick(Sender: TObject);
begin
  btnEditClick(btnEdit);
end;

procedure TFrmTillList.EnableDisable;
begin
  edName.Enabled := FormMode <> fmView;
  lvTills.Enabled := FormMode = fmView;
  btnDelete.Enabled := not btnDelete.Enabled;

  btnAdd.Enabled := bRunningFromCentral or (FormMode <> fmView);
  btnEdit.Enabled := (bRunningFromCentral and (lvTills.Selected <> nil)) or (FormMode <> fmView);
  btnDelete.Enabled := (bRunningFromCentral and (lvTills.Selected <> nil)) and (FormMode = fmView);
  btnClose.Enabled := FormMode = fmView;
end;

procedure TFrmTillList.lvTillsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  EnableDisable;
end;

end.
