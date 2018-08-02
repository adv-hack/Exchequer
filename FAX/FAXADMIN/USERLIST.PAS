unit UserList;

{ nfrewer440 10:19 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, FaxUtils, Inifiles, StrUtil, UserDet, Menus, APIUtil, FileUtil;

type
  TfrmUserList = class(TForm)
    lvUsers: TListView;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnClose: TButton;
    PopupMenu1: TPopupMenu;
    Edit1: TMenuItem;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvUsersChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    slUserSettings, slUsers : TStringList;
    frmUserDetails: TfrmUserDetails;
    bChanged : boolean;
    procedure CreateIniFile;
    procedure CheckColWidths;
  public
    { Public declarations }
  end;

{var
  frmUserList: TfrmUserList;}

implementation

{$R *.DFM}

procedure TfrmUserList.FormCreate(Sender: TObject);
var
  IniFileName : string;
  iPos, iPos2 : integer;
  NewItem: TListItem;
begin
  bChanged := FALSE;
  slUsers := TStringList.Create;
  if SetIniFileName(IniFileName) then begin
    with TIniFile.Create(IniFileName) do begin
      try
        ReadSections(slUsers);
        slUsers.Sorted := TRUE;
        for iPos := 0 to slUsers.Count - 1 do begin
          slUserSettings := TStringList.Create;

          ReadSectionValues(slUsers[iPos], slUserSettings);
          for iPos2 := 0 to 1 - slUserSettings.Count do slUserSettings.Add('');

          slUsers.Objects[iPos] := slUserSettings;

          slUserSettings[0] := RemoveAllBeforeChar('=',slUserSettings[0]);
          slUserSettings[1] := RemoveAllBeforeChar('=',slUserSettings[1]);

          NewItem := lvUsers.Items.Add;
          with NewItem do begin
            Caption := slUsers[iPos];
            SubItems.Add(slUserSettings[0]);
            SubItems.Add(slUserSettings[1]);
          end;{with}
          CheckColWidths;
        end;{for}
        slUsers.Sorted := FALSE;
      finally
        Free;
      end;{try}
    end;{with}
  end;{if}

  if lvUsers.Items.Count > 0 then lvUsers.Selected := lvUsers.Items[0];
end;

procedure TfrmUserList.FormDestroy(Sender: TObject);
var
  iPos : integer;
begin
  for iPos := 0 to slUsers.Count - 1 do begin
    slUsers.Objects[iPos].Free;
  end;{for}
  slUsers.Free;
end;

procedure TfrmUserList.lvUsersChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  {buttons}
  btnEdit.Enabled := lvUsers.SelCount > 0;
  btnDelete.Enabled := lvUsers.SelCount > 0;

  {popup menu}
  edit1.Enabled := lvUsers.SelCount > 0;
  Delete1.Enabled := lvUsers.SelCount > 0;
end;

procedure TfrmUserList.btnAddClick(Sender: TObject);
var
  NewItem: TListItem;
begin
  try
    frmUserDetails := TfrmUserDetails.Create(Self);
    with frmUserDetails do begin
      SetFields('','','');
      if ShowModal = mrOK then begin
        if slUsers.IndexOf(edUserName.Text) = -1 then
          begin
            bChanged := TRUE; {Set Flag}

            {update list view}
            NewItem := lvUsers.Items.Add;
            with NewItem do begin
              Caption := edUserName.Text;
              SubItems.Add(edSenderName.Text);
              SubItems.Add(edEmailAddress.Text);
            end;{with}
            CheckColWidths;

            {update StringList}
            slUserSettings := TStringList.Create;
            slUserSettings.Add(edSenderName.Text);
            slUserSettings.Add(edEmailAddress.Text);
            slUsers.AddObject(edUserName.Text,slUserSettings);
          end
        else MsgBox('You cannot add a user with the same ''Login Name'' as an existing user.'
        ,mtError,[mbOK],mbOK,'Duplicate Name');
      end;{if}
    end;{with}
  finally
    frmUserDetails.Release;
  end;{try}
end;

procedure TfrmUserList.btnEditClick(Sender: TObject);
var
  sPrevUserName, sUserName : string;
  iPos : integer;
begin
  if lvUsers.SelCount > 0 then begin
    try
      frmUserDetails := TfrmUserDetails.Create(Self);
      with frmUserDetails do begin
        sPrevUserName := lvUsers.Selected.Caption;
        SetFields(sPrevUserName,lvUsers.Selected.SubItems[0],lvUsers.Selected.SubItems[1]);
        if ShowModal = mrOK then begin
          if (sPrevUserName <> edUserName.Text)
          and (slUsers.IndexOf(edUserName.Text) <> -1) then
            begin
              MsgBox('You cannot change the ''Login Name'' to the same as an existing user.',mtError,[mbOK],mbOK,'Duplicate Name');
            end
          else begin
            bChanged := TRUE; {Set Flag}

            sUserName := lvUsers.Selected.Caption; {Save UserName}

            {update list view}
            lvUsers.Selected.Caption := edUserName.Text;
            lvUsers.Selected.SubItems[0] := edSenderName.Text;
            lvUsers.Selected.SubItems[1] := edEmailAddress.Text;

            {update StringList}
            iPos := slUsers.IndexOf(sUserName);
            slUsers[ipos] := edUserName.Text;
            TStringList(slUsers.Objects[ipos])[0] := edSenderName.Text;
            TStringList(slUsers.Objects[ipos])[1] := edEmailAddress.Text;
          end;{if}
        end;{if}
      end;{with}
    finally
      frmUserDetails.Release;
    end;{try}
  end;{if}
end;

procedure TfrmUserList.btnDeleteClick(Sender: TObject);
var
  iPos : integer;
begin
  if MsgBox('Are you sure you wish to delete this user ?',mtConfirmation,[mbYes,mbNo],mbNo
  ,'Delete User') = mrYes then begin

    bChanged := TRUE; {Set Flag}

    {update StringList}
    iPos := slUsers.IndexOf(lvUsers.Selected.Caption);
    slUsers.Objects[ipos].Free;
    slUsers.Delete(ipos);

    {update list view}
    lvUsers.Selected.Delete;
    CheckColWidths;
  end;{if}
end;

procedure TfrmUserList.CreateIniFile;
var
  sIniFileName : string;
  iPos : integer;
  IniFile : TIniFile;
begin
  screen.cursor := crHourglass;
  if SetIniFileName(sIniFileName) then DeleteFile(sIniFileName);
  IniFile := TIniFile.Create(sIniFileName);
  IniFile.UpdateFile;
  with IniFile do begin
    slUsers.Sorted := TRUE;
    for iPos := 0 to slUsers.Count - 1 do begin
      AddLineToFile('[' + slUsers[iPos] + ']', sIniFileName);
      AddLineToFile('SenderName=' + TStringList(slUsers.Objects[iPos])[0], sIniFileName);
      AddLineToFile('SenderEmail=' + TStringList(slUsers.Objects[iPos])[1], sIniFileName);
      AddLineToFile(CHR(13), sIniFileName);
    end;{for}
    slUsers.Sorted := FALSE;

    UpdateFile;
    Free;
  end;{with}
  bChanged := FALSE;
  screen.cursor := crDefault;
end;

procedure TfrmUserList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmUserList.btnSaveClick(Sender: TObject);
begin
  CreateIniFile;
end;

procedure TfrmUserList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  CreateIniFile;
end;

procedure TfrmUserList.CheckColWidths;
begin
  if lvUsers.Items.Count > 15 then lvUsers.Columns[2].Width := 184
  else lvUsers.Columns[2].Width := 200;
end;

end.
