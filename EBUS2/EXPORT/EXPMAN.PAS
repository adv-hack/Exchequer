unit expman;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StrUtil, StdCtrls
  , ExpWiz, CheckLst, ImgList, ComCtrls, Menus, DragStk, DragCust, BtrvU2, eBusUtil, APIUtil
  , eBusVar;

type
  TExportInfo = Class
    sExportCode : string20;
    ExportRec : TEBusExport;
  end;

  TFrmExportManager = class(TForm)
    btnAdd: TButton;
    cmbCompanies: TComboBox;
    Label1: TLabel;
    btnEdit: TButton;
    btnDelete: TButton;
    lvExports: TListView;
    btnClose: TButton;
    ImageList1: TImageList;
    btnRunExport: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Setup1: TMenuItem;
    CSVMappings1: TMenuItem;
    SystemSetup1: TMenuItem;
    btnActivate: TButton;
    btnCopy: TButton;
    ExportMenu: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    Activate1: TMenuItem;
    RunExport1: TMenuItem;
    CopyExport1: TMenuItem;
    N2: TMenuItem;
    ViewFTPLogFile1: TMenuItem;
    ImageList2: TImageList;
    procedure Button1Click(Sender: TObject);
    procedure ShowWizard(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CSVMappings1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmbCompaniesChange(Sender: TObject);
    procedure lvExportsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure Exit1Click(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRunExportClick(Sender: TObject);
    procedure btnActivateClick(Sender: TObject);
    procedure SystemSetup1Click(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure ExportMenuPopup(Sender: TObject);
    procedure ViewFTPLogFile1Click(Sender: TObject);
  private
    procedure FillLists;
  public
    { Public declarations }
  end;

(*
  TDuplicateFiles = class
    private
      FileList : TStringList;
      fDuplicateFileCount : integer;
      function GetDuplicatedFiles: boolean;
    public
      constructor Create;
      destructor  Destroy; override;
      procedure   Add(const FileName : string; FileDesc : string = '');
      property    DuplicatedFiles : boolean read GetDuplicatedFiles;
      property    DuplicateFileCount : integer read fDuplicateFileCount;
  end;
*)
var
  sCompanyCode : shortstring;

implementation

{$R *.DFM}

uses
  Export, eBusBtrv, eBusCnst, RunExp, MiscUtil, CopyExp, FTPLog;

{type
  TDupFileInfo = class
    private
      fFileDesc : string;
      fDupID    : integer;
      procedure SetDupID(const Value: integer);
      procedure SetFileDesc(const Value: string);
    public
      constructor Create(const Description : string; DuplicateID : integer; Obj : TObject);
      property FileDesc : string read fFileDesc write SetFileDesc;
      property DupID : integer read fDupId write SetDupID;
  end;}

procedure TFrmExportManager.Button1Click(Sender: TObject);
begin
{  with TEBusBtrieveParams.Create(TRUE) do begin
    OpenFile;
    if FindRecord <> 0 then begin
      BlankRecord;
      ParamsSettings.EntCSVMapFileDir := 'x:\ebus2\export\mapfiles\';
      AddRecord;
    end;{if}
{    CloseFile;
  end;{with}

{ with TEbusBtrieveCompany.Create(TRUE) do begin
   try
     openfile;
     CompanyCode := 'INTE01';
     FindRecord;
     DeleteRecord;

     CompanyCode := 'INTE02';
     FindRecord;
     DeleteRecord;
     CloseFile;
   finally
     free;
   end;{try}
{ end;{with}
end;

procedure TFrmExportManager.ShowWizard(Sender: TObject);
var
  frmExportWizard : TfrmExportWizard;
  FormMode : TFormActivate;
  sExportCode : string20;
  iPos : integer;
begin
  FormMode := actShow;
  if (Sender = btnAdd) or (Sender = Add1) then
    begin
      FormMode := actAdd;
      sExportCode := '';
    end
  else begin
    if lvExports.Selected <> nil then begin
      FormMode := actEdit;
      sExportCode := TExportInfo(lvExports.Selected.Data).sExportCode;
    end;{if}
  end;{if}

  if (FormMode = actAdd) or (lvExports.Selected <> nil) then begin
    frmExportWizard := TfrmExportWizard.CreateWithMode(FormMode, sExportCode);
    try
      if frmExportWizard.ShowModal = mrOK then begin
{        TExportInfo(lvExports.Selected.Data) :=

        ExportInfo.ExportRec := ExportSettings;
        Data := ExportInfo;

        if (ExptActive = 1) then SubItems.Add('Yes')
        else SubItems.Add('No');

        if ExptLastExportAt = 0 then SubItems.Add('N/A')
        else SubItems.Add(DateToStr(ExptLastExportAt) + ' - ' + TimeToStr(ExptLastExportAt));}
        cmbCompaniesChange(nil);

        {find and focus item in list}
        with lvExports do begin
          For iPos := 0 to Items.Count - 1 do begin
            if trim(TExportInfo(items[iPos].Data).sExportCode) = trim(frmExportWizard.sExportCode)
            then begin
              items[iPos].selected := TRUE;
              items[iPos].Focused := TRUE;
            end;{if}
          end;{for}
        end;{with}
      end;{if}
    finally
      frmExportWizard.Release;
    end;{try}
  end;{if}
end;

procedure TFrmExportManager.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmExportManager.FormCreate(Sender: TObject);
begin
  FillLists;
end;

procedure TFrmExportManager.CSVMappings1Click(Sender: TObject);
begin
  frmeBisExport.ShowCSVMappings;
end;

procedure TFrmExportManager.Button5Click(Sender: TObject);
begin
{ with TEbusBtrieveCompany.Create(TRUE) do begin
   try
     openfile;
     blankrecord;
     CompanyCode := 'INTE01';
     AddRecord;

     blankrecord;
     CompanyCode := 'INTE02';
     AddRecord;
     CloseFile;
   finally
     free;
   end;
 end;{with}
end;

procedure TFrmExportManager.FormDestroy(Sender: TObject);
begin
  ClearList(cmbCompanies.Items);
  lvExports.Items.Clear;
end;

procedure TFrmExportManager.cmbCompaniesChange(Sender: TObject);
var
  iStatus : integer;
  NewItem : TListItem;
  ExportInfo : TExportInfo;
begin
  sCompanyCode := TCompanyInfo(cmbCompanies.Items.Objects[cmbCompanies.ItemIndex]).CompanyRec.CompCode;

  lvExports.Items.Clear;

  with TEBusBtrieveExport.Create(TRUE) do begin
    OpenFile;
    CompanyCode := sCompanyCode;
    iStatus := FindRecord(B_GetFirst);
    while (iStatus = 0) do begin
      with NewItem, ExportSettings do begin
        NewItem := lvExports.Items.Add;
        Caption := ExptDescription;
        ImageIndex := ExptActive;

        ExportInfo := TExportInfo.Create;
        ExportInfo.sExportCode := ExportCode;
        ExportInfo.ExportRec := ExportSettings;
        Data := ExportInfo;

        if (ExptActive = 1) then SubItems.Add('Yes')
        else SubItems.Add('No');

        if ExptLastExportAt = 0 then SubItems.Add('N/A')
        else SubItems.Add(DateToStr(ExptLastExportAt) + ' - ' + TimeToStr(ExptLastExportAt));
      end;{with}

      iStatus := FindRecord(B_GetNext);
    end;{while}
    CloseFile;
  end;{with}

  if lvExports.Items.Count > 0 then begin
    lvExports.Selected := lvExports.Items.Item[0];
    lvExports.ItemFocused := lvExports.Items.Item[0];
  end;{if}
end;

procedure TFrmExportManager.lvExportsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  btnAdd.Enabled := cmbCompanies.Items.Count > 0;
  btnEdit.Enabled := lvExports.Selected <> nil;
  btnDelete.Enabled := lvExports.Selected <> nil;
  btnActivate.Enabled := lvExports.Selected <> nil;
  btnRunExport.Enabled := lvExports.Selected <> nil;
  btnCopy.Enabled := lvExports.Selected <> nil;

  if (Item <> nil) and (Item.SubItems.Count > 0) then begin
    if Item.SubItems[0] = 'Yes' then
      begin
        btnActivate.Caption := 'Dea&ctivate';
        Activate1.Caption := 'Dea&ctivate';
      end
    else begin
      btnActivate.Caption := 'A&ctivate';
      Activate1.Caption := 'A&ctivate';
    end;{if}
  end;{if}
end;

procedure TFrmExportManager.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmExportManager.btnDeleteClick(Sender: TObject);
begin
  if MsgBox('Are you sure you want to delete this export ?',mtConfirmation,[mbYes,mbNo]
  ,mbNo,'Delete Export') = mrYes then begin
    with TEBusBtrieveExport.Create(TRUE) do begin
      OpenFile;
      CompanyCode := sCompanyCode;
      ExportCode := TExportInfo(lvExports.Selected.Data).sExportCode;
      if (FindRecord = 0) then DeleteRecord;
      CloseFile;
      Free;
    end;{with}

    with TEBusBtrieveFile.Create(TRUE) do begin
      OpenFile;
      CompanyCode := sCompanyCode;
      ExportCode := TExportInfo(lvExports.Selected.Data).sExportCode;
      if (FindRecord = 0) then DeleteRecord;
      CloseFile;
      Free;
    end;{with}

    {refresh list}
    cmbCompaniesChange(nil);
  end;{if}
end;

procedure TFrmExportManager.btnRunExportClick(Sender: TObject);
begin
  if MsgBox('Are you sure you want to run this export now ?',mtConfirmation,[mbYes,mbNo],mbNo
  ,'Run Export') = mrYes then begin
    RunExport(sCompanyCode, TExportInfo(lvExports.Selected.Data).sExportCode
    , TExportInfo(lvExports.Selected.Data).ExportRec, TRUE);

    {update last exported time}
    with TEBusBtrieveExport.Create(TRUE) do begin
      OpenFile;
      CompanyCode := sCompanyCode;
      ExportCode := TExportInfo(lvExports.Selected.Data).sExportCode;
      if (FindRecord = 0) then begin
        ExportSettings.ExptLastExportAt := Now;
        UpdateRecord;
      end;{if}
      CloseFile;
      Free;
    end;{with}

    {refresh list}
    cmbCompaniesChange(nil);
  end;{if}
end;

procedure TFrmExportManager.btnActivateClick(Sender: TObject);
var
  iNewActive : byte;
begin
  if MsgBox('Are you sure you want to ' + RemoveAllChars(btnActivate.Caption, '&') + ' this export ?'
  ,mtConfirmation,[mbYes,mbNo],mbNo,RemoveAllChars(btnActivate.Caption, '&') + ' Export') = mrYes then begin
    if lvExports.Selected.SubItems[0] = 'Yes' then
      begin
        {Deactivate Export}
        lvExports.Selected.SubItems[0] := 'No';
        btnActivate.Caption := 'A&ctivate';
        Activate1.Caption := 'A&ctivate';
        iNewActive := 0;
      end
    else begin
      {Activate Export}
      lvExports.Selected.SubItems[0] := 'Yes';
      btnActivate.Caption := 'Dea&ctivate';
      Activate1.Caption := 'Dea&ctivate';
      iNewActive := 1;
    end;{if}

    with TEBusBtrieveExport.Create(TRUE) do begin
      OpenFile;
      CompanyCode := sCompanyCode;
      ExportCode := TExportInfo(lvExports.Selected.Data).sExportCode;
      if (FindRecord = 0) then begin
        ExportSettings.ExptActive := iNewActive;
        UpdateRecord;
      end;{if}
      CloseFile;
    end;{with}
    lvExports.Selected.ImageIndex := iNewActive;
  end;{if}
end;

procedure TFrmExportManager.SystemSetup1Click(Sender: TObject);
begin
  ShowEBusSetup;
  if frmeBisExport.bClosing then frmeBisExport.Close
  else FillLists;
end;

procedure TFrmExportManager.FillLists;
begin
  ClearList(cmbCompanies.Items);
  FillCompanyList(TStringList(cmbCompanies.Items), fmActive);
  if cmbCompanies.Items.Count > 0 then begin
    cmbCompanies.ItemIndex := 0;
    cmbCompaniesChange(nil);
    if cmbCompanies.Items.Count = 1 then cmbCompanies.Enabled := FALSE; 
  end;{if}
  lvExportsChange(nil, nil, ctText);
end;

procedure TFrmExportManager.btnCopyClick(Sender: TObject);
var
  OldExport, NewExport : TEBusBtrieveExport;
  NewFile, OldFile : TEBusBtrieveFile;
  sExportCode : string;
begin
  with TFrmCopyExport.Create(self) do begin
    try
      lDescription.Caption := lvExports.Selected.Caption;
      edDescription.Text := lvExports.Selected.Caption + ' #2';
      if (ShowModal = mrOK) and (MsgBox('Are you sure you want to make a copy of this export ?'
      , mtConfirmation, [mbYes,mbNo], mbNo, 'Copy Export') = mrYes) then begin
        {copy export}

        OldExport := TEBusBtrieveExport.Create(TRUE);
        with OldExport do begin
          OpenFile;
          CompanyCode := sCompanyCode;
          ExportCode := TExportInfo(lvExports.Selected.Data).sExportCode;

          if (FindRecord = 0) then begin
            NewExport := TEBusBtrieveExport.Create(TRUE);
            with NewExport do begin
              OpenFile;
              BlankRecord;
              CompanyCode := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec.CompCode;
              sExportCode := GetExportCode;
              ExportCode := sExportCode;
              ExportSettings := OldExport.ExportSettings;
              NewExport.ExportSettings.ExptDescription := edDescription.Text;
              NewExport.ExportSettings.ExptLastExportAt := 0;
              AddRecord;
              CloseFile;
              Free;
            end;{with}
          end;{if}

          CloseFile;
          Free;
        end;{with}


        OldFile := TEBusBtrieveFile.Create(TRUE);
        with OldFile do begin
          OpenFile;
          CompanyCode := sCompanyCode;
          ExportCode := TExportInfo(lvExports.Selected.Data).sExportCode;

          if (FindRecord = 0) then begin
            NewFile := TEBusBtrieveFile.Create(TRUE);
            with NewFile do begin
              OpenFile;
              BlankRecord;
              CompanyCode := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec.CompCode;
              ExportCode := sExportCode;
              FileSettings := OldFile.FileSettings;
              AddRecord;
              CloseFile;
              Free;
            end;{with}
          end;{if}

          CloseFile;
          Free;
        end;{with}

        if (sCompanyCode = TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec.CompCode)
        then cmbCompaniesChange(nil);
      end;{if}
    finally
      release;
    end;{try}
  end;{with}
end;

procedure TFrmExportManager.ExportMenuPopup(Sender: TObject);
begin
  Edit1.Enabled := lvExports.Selected <> nil;
  Delete1.Enabled := lvExports.Selected <> nil;
  Activate1.Enabled := lvExports.Selected <> nil;
  RunExport1.Enabled := lvExports.Selected <> nil;
  CopyExport1.Enabled := lvExports.Selected <> nil;
end;

{ TDuplicateFiles

procedure TDuplicateFiles.Add(const FileName: string; FileDesc: string = '');
var
  DupFileInfo : TDupFileInfo;
  FoundIndex,
  DuplicateID : integer;
begin
  // Normalise all the file names
  FileName := ExtractShortPathName(IncludeTrailingBackslash(UpperCase(FileName)));

  with FileList do
  begin
    DupFileInfo := TDupFileInfo.Create(FileDesc, -1);
    if Find(FileName, FoundIndex) then
    begin
      inc(fDuplicateFileCount);
      DuplicateID := (Objects[FoundIndex] as TDupFileInfo).DupID;
      if DuplicateID <> -1 then
        // This file had previous duplicates, keep the duplicate ID
        DupFileInfo.DupID := DuplicateID
      else
      begin // No previous duplicates, update both duplicate IDs
        (Objects[FoundIndex] as TDupFileInfo).DupID := fDuplicateFileCount;
        DupFileInfo.DupID := fDuplicateFileCount;
      end;
    end;
    AddObject(FileName, DupFileInfo);
  end;
end;

procedure TDuplicateFiles.FindDuplicates( : boolean;
// Notes : This method is for ease of use in the Export Wizard
//         The whole class could be expanded to offer more "user friendly" functionality.
begin
  if DuplicatedFiles then





end;

constructor TDuplicateFiles.Create;
begin
  inherited Create;
  FileList := TStringList.Create;
  FileList.Sorted := true;
  FileList.Duplicates := dupAccept;
  fDuplicateFileCount := 0;
end;

destructor TDuplicateFiles.Destroy;
begin
  FileList.Clear;
  FileList.Free;
  inherited Destroy;
end;

function TDuplicateFiles.GetDuplicatedFiles: boolean;
begin
  Result := DuplicateFileCount > 0;
end;}

{ TDupFileInfo
constructor TDupFileInfo.Create(const Description : string; DuplicateID : integer);
begin
  inherited Create;
  DupID := DuplicateID;
  FileDesc := Description;
end;

procedure TDupFileInfo.SetDupID(const Value: integer);
begin
  fDupId := Value;
end;

procedure TDupFileInfo.SetFileDesc(const Value: string);
begin
  fFileDesc := Value;
end;}

procedure TFrmExportManager.ViewFTPLogFile1Click(Sender: TObject);
begin
  with TFrmFTPLog.Create(application) do begin
    try
      ShowModal;
    finally
      Free;
    end;{try}
  end;{with}
end;

end.
