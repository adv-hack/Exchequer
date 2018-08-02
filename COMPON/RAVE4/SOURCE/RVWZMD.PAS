{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVWzMD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RVData, RVUtil, RVProj, Buttons, StdCtrls, CheckLst, ExtCtrls,
  RVDirectDataView, RVDataField;

type
  TPages = (nbMasterDV, nbDetailDV, nbMasterFields, nbSortMasterFields,
            nbDetailFields, nbSortDetailFields, nbKeysPage, nbSortKeysPage,
            nbOptions, nbFonts);

  TRvWzMDForm = class(TForm)
    Panel11: TPanel;
    Image1: TImage;
    HeaderPanel: TPanel;
    ButtonPanel: TPanel;
    CancelBtn: TBitBtn;
    NextGenBtn: TBitBtn;
    BackBtn: TBitBtn;
    NB: TNotebook;
    Panel2: TPanel;
    MasterDVLB: TListBox;
    Panel1: TPanel;
    MasterFieldsCBL: TCheckListBox;
    MasterFieldsPnl: TPanel;
    SelectAllBtn: TBitBtn;
    SelectNoneBtn: TBitBtn;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LeftMarginEdit: TEdit;
    TopMarginEdit: TEdit;
    RightMarginEdit: TEdit;
    BottomMarginEdit: TEdit;
    GroupBox2: TGroupBox;
    RptTitleEdit: TEdit;
    ReportTitleCB: TCheckBox;
    Panel4: TPanel;
    TitlePanel: TPanel;
    Panel6: TPanel;
    TitleFontBtn: TBitBtn;
    CaptionPanel: TPanel;
    Panel8: TPanel;
    CaptionFontBtn: TBitBtn;
    BodyPanel: TPanel;
    Panel10: TPanel;
    BodyFontBtn: TBitBtn;
    Panel7: TPanel;
    Panel9: TPanel;
    Panel12: TPanel;
    MasterMoveUpSB: TSpeedButton;
    MasterMoveDownSB: TSpeedButton;
    SortMasterFieldsLB: TListBox;
    Panel13: TPanel;
    DetailFieldsCBL: TCheckListBox;
    DetailFieldsPnl: TPanel;
    AllBtn: TBitBtn;
    NoneBtn: TBitBtn;
    Panel15: TPanel;
    Panel16: TPanel;
    DetailMoveUpSB: TSpeedButton;
    DetailMoveDownSB: TSpeedButton;
    SortDetailFieldsLB: TListBox;
    DetailDVLB: TListBox;
    Panel5: TPanel;
    DetailKeyCBL: TCheckListBox;
    Panel14: TPanel;
    MasterKeyCBL: TCheckListBox;
    DetailKeyPanel: TPanel;
    MasterKeyPanel: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    MasterKeyUpSB: TSpeedButton;
    MasterKeyDownSB: TSpeedButton;
    DetailKeySortLB: TListBox;
    MasterKeySortLB: TListBox;
    DetailKeyUpSB: TSpeedButton;
    DetailKeyDownSB: TSpeedButton;
    DetailOffsetEdit: TEdit;
    Label1: TLabel;
    FontDlg: TFontDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NextGenBtnClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure AllBtnClick(Sender: TObject);
    procedure NoneBtnClick(Sender: TObject);
    procedure MasterFieldsCBLClick(Sender: TObject);
    procedure SortMasterFieldsLBClick(Sender: TObject);
    procedure SortDetailFieldsLBClick(Sender: TObject);
    procedure MasterMoveUpSBClick(Sender: TObject);
    procedure MasterMoveDownSBClick(Sender: TObject);
    procedure DetailMoveUpSBClick(Sender: TObject);
    procedure DetailMoveDownSBClick(Sender: TObject);
    procedure MasterKeyUpSBClick(Sender: TObject);
    procedure MasterKeyDownSBClick(Sender: TObject);
    procedure DetailKeyUpSBClick(Sender: TObject);
    procedure DetailKeyDownSBClick(Sender: TObject);
    procedure TitleFontBtnClick(Sender: TObject);
    procedure CaptionFontBtnClick(Sender: TObject);
    procedure BodyFontBtnClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  protected
    FCurrPage: TPages;
    FRegionName: string;
    procedure SetPage(const Value: TPages);
    procedure SetButtonState;
    procedure GenerateReport;
    procedure SetFields(CheckListBox: TCheckListBox; DataView: TRaveBaseDataView);
    procedure SetSortFields(CheckListBox: TCheckListBox;
      ListBox: TListBox);
    function FieldsChecked(CheckListBox: TCheckListBox): boolean;
    procedure SetSortButtonsState;
    function GetNumKeysSelected(CheckListBox: TCheckListBox):integer;
    property RegionName: string read FRegionName write FRegionName;
    function GetKeys(CheckListBox: TCheckListBox): string;
  public
    property CurrPage: TPages read FCurrPage write SetPage;
  end;

  procedure RaveRegister;

const
  Headers: array[TPages] of string = ({Trans+}'Select The Master Data View you wish to use',
                                      {Trans+}'Select The Detail Data View you wish to use',
                                      {Trans+}'Select The Master Fields you wish to use',
                                      {Trans+}'Arrange The Master Fields In The Order To Be Printed',
                                      {Trans+}'Select The Detail Fields you wish to use',
                                      {Trans+}'Arrange The Detail Fields In The Order To Be Printed',
                                      {Trans+}'Select The Fields To Use As Keys',
                                      {Trans+}'Arrange The Keys Appropriately',
                                      {Trans+}'Report Layout Options',
                                      {Trans+}'Select the desired fonts to use for this report');
  NextHints: array[TPages] of string = ({Trans+}'Move To Select Detail Data View Panel',
                                        {Trans+}'Move To Select Master Fields Panel',
                                        {Trans+}'Move To Arrange Master Fields Panel',
                                        {Trans+}'Move To Select Detail Fields Panel',
                                        {Trans+}'Move To Arrange Detail Fields Panel',
                                        {Trans+}'Move To Key Selection Page',
                                        {Trans+}'Move To Key Arranging Page',
                                        {Trans+}'Move To Options Panel',
                                        {Trans+}'Move To Font Panel',
                                        {Trans+}'Generate The Report');
  BackHints: array[TPages] of string = ('',{Trans+}'Move To Select Master Data View Panel',
                                           {Trans+}'Move To Select Detail Data View Panel',
                                           {Trans+}'Move To Select Master Fields Panel',
                                           {Trans+}'Move To Arrange Master Fields Panel',
                                           {Trans+}'Move To Select Detail Fields Panel',
                                           {Trans+}'Move To Arrange Detail Fields Panel',
                                           {Trans+}'Move To Select Keys Panel',
                                           {Trans+}'Move To Arrange Keys Panel',
                                           {Trans+}'Move To Report Layout Options Panel');
  NextGenCaptions: array[boolean] of string = ({Trans+}'&Next >',
                                               {Trans+}'&Generate');

var
  RvWzMDForm: TRvWzMDForm;

implementation

uses
  RVClass,
  RVCsData,
  RVCsDraw,
  RVCsRpt,
  RVCsStd,
  RPDefine,
  RVTool,
  RVToolEvents,
  RVWzSimp;

{$R *.DFM}

type
  TRaveWizardProjectEditor = class(TRaveProjectEditor,IRaveToolMenuEventHandler)
  public
   procedure AddToMenu(AddMenuItem: TAddMenuItemProc);
   procedure RunFromMenu(ID: integer);
   procedure RunSimpleWizard;
   procedure RunMasterDetailWizard;
  end; { TRaveWizardProjectEditor }

procedure RaveRegister;

begin { RaveRegister }
{TransOff}
  RegisterRaveProjectEditor(TRaveWizardProjectEditor);
{TransOn}
end;  { RaveRegister }

{ TRaveWizardProjectEditor }

procedure TRaveWizardProjectEditor.AddToMenu(AddMenuItem: TAddMenuItemProc);
begin
  AddMenuItem(self,Trans('Report Wizards'),1,0);
  AddMenuItem(self,Trans('Simple Table'),101,1);
  AddMenuItem(self,Trans('Master/Detail Report'),102,1);
end;

procedure TRaveWizardProjectEditor.RunFromMenu(ID: integer);
begin
  Case ID of
    -1,1: begin
    // MenuItem1 action (double-click default)
    end;
    101: begin
      RunSimpleWizard;
    end;
    102: begin
      RunMasterDetailWizard;
    end;
  end; { case }
end;

procedure TRaveWizardProjectEditor.RunSimpleWizard;
begin
  If ProjectManager.DataObjectList.Count > 0 then begin
    With TRvWzSimpleForm.Create(nil) do try
      ShowModal;
    finally
      Free;
    end; { with }
  end else begin
    ShowMessage(Trans('A Data View must be created before running this wizard.'));
  end; { else }
end;

procedure TRaveWizardProjectEditor.RunMasterDetailWizard;
begin
  If ProjectManager.DataObjectList.Count > 1 then begin
    With TRvWzMDForm.Create(nil) do try
      ShowModal;
    finally
      Free;
    end; { with }
  end else begin
    ShowMessage(Trans('At least two Data Views must be created before running this wizard.'));
  end; { else }
end;

{ TRvWzMDForm }

procedure TRvWzMDForm.FormCreate(Sender: TObject);
var
  I1: integer;
  DataView: TRaveBaseDataView;

begin
  FormTrans(self);
  PrepareToolWin(self);
  With ProjectManager do begin
    For I1 := 0 to DataObjectList.Count -1 do begin
      If TObject(DataObjectList[I1]) is TRaveBaseDataView then begin
        DataView := TRaveBaseDataView(DataObjectList.Items[I1]);
        MasterDVLB.Items.AddObject(DataView.Name, DataView);
      end; { if }
    end; { for }
    // the default ItemIndex = 0 but the listbox is not showing item 0
    // as being selected.  The next two lines corrects that problem.
    MasterDVLB.ItemIndex := 1;
    MasterDVLB.ItemIndex := 0;
  end; { with }

  CurrPage := nbMasterDV;
  HeaderPanel.Caption := Trans(Headers[CurrPage]);
end;

procedure TRvWzMDForm.FormDestroy(Sender: TObject);
begin
  SaveToolWin(self);
end;

procedure TRvWzMDForm.SetPage(const Value: TPages);
begin
  NB.PageIndex := Ord(Value);
  FCurrPage := Value;
end;

procedure TRvWzMDForm.FormShow(Sender: TObject);
begin
  RestoreToolWin(self);
  BackBtn.Hint := Trans(BackHints[CurrPage]);
  NextGenBtn.Hint := Trans(NextHints[CurrPage]);
end;

procedure TRvWzMDForm.SetFields(CheckListBox: TCheckListBox; DataView: TRaveBaseDataView);

var
  I1: integer;
  DataField: TRaveDataField;

begin
  CheckListBox.Items.Clear;
  For I1 := 0 to DataView.ChildCount-1 do begin
    DataField := TRaveDataField(DataView.Child[I1]);
    If (DataField.DataType <> dtBlob) and
     (DataField.DataType <> dtMemo) and
     (DataField.DataType <> dtGraphic) then begin
      CheckListBox.Items.AddObject(DataField.FullName,DataField);
    end; { if }
  end; { for }
end;

procedure TRvWzMDForm.SetSortFields(CheckListBox: TCheckListBox; ListBox: TListBox);

var
  I1: integer;
  DataField: TRaveDataField;

begin
  ListBox.Items.Clear;
  For I1 := 0 to CheckListBox.Items.Count-1 do begin
    If CheckListBox.Checked[I1] then begin
      DataField := TRaveDataField(CheckListBox.Items.Objects[I1]);
      ListBox.Items.AddObject(DataField.FullName,DataField);
    end; { if }
  end; { for }
end;

function TRvWzMDForm.GetKeys(CheckListBox: TCheckListBox): string;
var
  I1: integer;
  DataField: TRaveDataField;

begin
  Result := '';
  For I1 := 0 to CheckListBox.Items.Count-1 do begin
    If CheckListBox.Checked[I1] then begin
      DataField := TRaveDataField(CheckListBox.Items.Objects[I1]);
      If Result = '' then begin
        Result := DataField.FieldName;
      end else begin
        Result := Result + '+' + DataField.FieldName;
      end; { else }
    end; { if }
  end; { for }
end;

function TRvWzMDForm.FieldsChecked(CheckListBox: TCheckListBox) : boolean;

var
  I1: integer;

begin
  Result := false;
  For I1 := 0 to CheckListBox.Items.Count -1 do begin
    If CheckListBox.Checked[I1] then begin
      Result := true;
      Exit;
    end; { if }
  end; { for }
end;

procedure TRvWzMDForm.NextGenBtnClick(Sender: TObject);

var
  IsKeysPageActive: boolean;

begin
  If CurrPage <> High(CurrPage) then begin
    If CurrPage <> nbKeysPage then begin
      Inc(FCurrPage);
      CurrPage := FCurrPage;
      HeaderPanel.Caption := Trans(Headers[CurrPage]);
      IsKeysPageActive := false;
    end else begin
      IsKeysPageActive := true;
    end; { else }
    case CurrPage of
      nbDetailDV: begin
        DetailDVLB.Items.Clear;
        DetailDVLB.Items := MasterDVLB.Items;
        DetailDVLB.Items.Delete(MasterDVLB.ItemIndex);
        DetailDVLB.ItemIndex := 0;
      end; { nbDetailDV }
      nbMasterFields: begin
        SetFields(MasterFieldsCBL, TRaveBaseDataView(MasterDVLB.Items.Objects[MasterDVLB.ItemIndex]));
        MasterFieldsPnl.Caption := {Trans-}'DataView: ' + MasterDVLB.Items[MasterDVLB.ItemIndex];
      end; { nbMasterFields }
      nbSortMasterFields: begin
        SetSortFields(MasterFieldsCBL, SortMasterFieldsLB);
        SortMasterFieldsLB.ItemIndex := 0;
        If SortMasterFieldsLB.Items.Count <= 1 then begin
          NextGenBtnClick(NextGenBtn);
        end; { if }
      end; { nbSortMasterFields }
      nbDetailFields: begin
        SetFields(DetailFieldsCBL, TRaveBaseDataView(DetailDVLB.Items.Objects[DetailDVLB.ItemIndex]));
        DetailFieldsPnl.Caption := {Trans-}'DataView: ' + DetailDVLB.Items[DetailDVLB.ItemIndex];
      end; { nbDetailFields }
      nbSortDetailFields: begin
        SetSortFields(DetailFieldsCBL, SortDetailFieldsLB);
        SortDetailFieldsLB.ItemIndex := 0;
        If SortDetailFieldsLB.Items.Count <= 1 then begin
          NextGenBtnClick(NextGenBtn);
        end; { if }
      end; { nbSortDetailFields }
      nbKeysPage: begin
        If IsKeysPageActive then begin
          If (GetNumKeysSelected(MasterKeyCBL) <> GetNumKeysSelected(DetailKeyCBL)) or
             (GetNumKeysSelected(MasterKeyCBL) = 0) or
             (GetNumKeysSelected(DetailKeyCBL) = 0) then begin
            ShowMessage(Trans('A Master Key and Detail Key must be selected and the ' +
             'number of Master Keys Selected must equal the number of Detail Keys Selected.'));
          end else begin
            { Move To nbSortKeysPage and set fill in the data }
            Inc(FCurrPage);
            CurrPage := FCurrPage;
            HeaderPanel.Caption := Trans(Headers[CurrPage]);
            SetSortFields(MasterKeyCBL, MasterKeySortLB);
            MasterKeySortLB.ItemIndex := 0;
            SetSortFields(DetailKeyCBL, DetailKeySortLB);
            DetailKeySortLB.ItemIndex := 0;
            If (MasterKeySortLB.Items.Count <=1) and (DetailKeySortLB.Items.Count <= 1) then begin
              NextGenBtnClick(NextGenBtn);
            end; { if }
          end; { else }
        end else begin
          SetFields(MasterKeyCBL, TRaveBaseDataView(MasterDVLB.Items.Objects[
           MasterDVLB.ItemIndex]));
          MasterKeyPanel.Caption := Trans(Format({Trans+}'Master Keys Selected: %s',
           [IntToStr(GetNumKeysSelected(MasterKeyCBL))]));
          SetFields(DetailKeyCBL, TRaveBaseDataView(DetailDVLB.Items.Objects[
           DetailDVLB.ItemIndex]));
          DetailKeyPanel.Caption := Trans(Format({Trans+}'Detail Keys Selected: %s',
           [IntToStr(GetNumKeysSelected(DetailKeyCBL))]));
        end; { else }
      end; { nbKeyPage }
      nbSortKeysPage: begin { code for this page is called under the nbKeysPage }
      end; { nbSortKeysPage }
      nbFonts: begin
        TitlePanel.Caption := RptTitleEdit.Text;
      end; { nbFonts }
    end; { case }
    SetButtonState;
  end else begin
    GenerateReport;
    ModalResult := mrOk; // close the wizard
  end; { else }
end;

procedure TRvWzMDForm.BackBtnClick(Sender: TObject);
begin
  Dec(FCurrPage);
  case CurrPage of
    nbSortMasterFields: begin
      If SortMasterFieldsLB.Items.Count <= 1 then begin
        Dec(FCurrPage);
      end; { if }
    end; { nbSortMasterFields }
    nbSortDetailFields: begin
      If SortDetailFieldsLB.Items.Count <= 1 then begin
        Dec(FCurrPage);
      end; { if }
    end; { nbSortDetailFields }
    nbSortKeysPage: begin
      If (MasterKeySortLB.Items.Count <= 1) and (DetailKeySortLB.Items.Count <= 1) then begin
        Dec(FCurrPage);
      end; { if }
    end; { nbSortKeys }
  end; { case }
  CurrPage := FCurrPage;
  HeaderPanel.Caption := Trans(Headers[CurrPage]);
  SetButtonState;
end;

procedure TRvWzMDForm.SetButtonState;
begin
  BackBtn.Enabled := CurrPage <> Low(CurrPage);
  NextGenBtn.Hint := Trans(NextHints[CurrPage]);
  BackBtn.Hint := Trans(BackHints[CurrPage]);
  NextGenBtn.Caption := Trans(NextGenCaptions[High(CurrPage) = CurrPage]);
  case CurrPage of
    nbDetailDV: begin
    end; { nbDetailDV }
    nbMasterFields, nbSortMasterFields: begin
      NextGenBtn.Enabled := FieldsChecked(MasterFieldsCBL);
      SetSortButtonsState;
    end; { nbMasterFields }
    nbDetailFields, nbSortDetailFields: begin
      NextGenBtn.Enabled := FieldsChecked(DetailFieldsCBL);
      SetSortButtonsState;
    end; { nbDetailFields }
    nbKeysPage: begin
    end; { kbKeyPage }
    nbSortKeysPage: begin
      SetSortButtonsState;
    end; { nbSortKeysPage }
    nbFonts: begin
    end; { nbFonts }
  end; { case }
end;

procedure TRvWzMDForm.AllBtnClick(Sender: TObject);

var
  I1: integer;
  CheckListBox: TCheckListBox;

begin
  If CurrPage = nbMasterFields then begin
    CheckListBox := MasterFieldsCBL;
  end else begin
    CheckListBox := DetailFieldsCBL;
  end; { else }
  For I1 := 0 to CheckListBox.Items.Count -1 do begin
    CheckListBox.Checked[I1] := true;
  end; { for }
  SetButtonState;
end;

procedure TRvWzMDForm.NoneBtnClick(Sender: TObject);

var
  I1: integer;
  CheckListBox: TCheckListBox;

begin
  If CurrPage = nbMasterFields then begin
    CheckListBox := MasterFieldsCBL;
  end else begin
    CheckListBox := DetailFieldsCBL;
  end; { else }
  For I1 := 0 to CheckListBox.Items.Count -1 do begin
    CheckListBox.Checked[I1] := false;
  end; { for }
  SetButtonState;
end;

procedure TRvWzMDForm.MasterFieldsCBLClick(Sender: TObject);
begin
  If CurrPage = nbMasterFields then begin
    NextGenBtn.Enabled := FieldsChecked(MasterFieldsCBL);
  end else if CurrPage = nbDetailFields then begin
    NextGenBtn.Enabled := FieldsChecked(DetailFieldsCBL);
  end else begin
    MasterKeyPanel.Caption := Trans(Format({Trans+}'Master Keys Selected: %s',
     [IntToStr(GetNumKeysSelected(MasterKeyCBL))]));
    DetailKeyPanel.Caption := Trans(Format({Trans+}'Detail Keys Selected: %s',
     [IntToStr(GetNumKeysSelected(DetailKeyCBL))]));
  end; { else }
end;

procedure TRvWzMDForm.SetSortButtonsState;
begin { SetSortButtonsState }
  If CurrPage = nbSortMasterFields then begin
    MasterMoveUpSB.Enabled := SortMasterFieldsLB.ItemIndex > 0;
    MasterMoveDownSB.Enabled := (SortMasterFieldsLB.ItemIndex < SortMasterFieldsLB.Items.Count -1)
                                and (SortMasterFieldsLB.ItemIndex >= 0);
  end else if CurrPage = nbSortDetailFields then begin
    DetailMoveUpSB.Enabled := SortDetailFieldsLB.ItemIndex > 0;
    DetailMoveDownSB.Enabled := (SortDetailFieldsLB.ItemIndex < SortDetailFieldsLB.Items.Count -1)
                                and (SortDetailFieldsLB.ItemIndex >= 0);
  end else if CurrPage = nbSortKeysPage then begin
    MasterKeyUpSB.Enabled := MasterKeySortLB.ItemIndex > 0;
    MasterKeyDownSB.Enabled := (MasterKeySortLB.ItemIndex < MasterKeySortLB.Items.Count -1)
                                and (MasterKeySortLB.ItemIndex >= 0);
    DetailKeyUpSB.Enabled := DetailKeySortLB.ItemIndex > 0;
    DetailKeyDownSB.Enabled := (DetailKeySortLB.ItemIndex < DetailKeySortLB.Items.Count -1)
                                and (DetailKeySortLB.ItemIndex >= 0);
  end; { else }
end;  { SetSortButtonsState }

procedure TRvWzMDForm.SortMasterFieldsLBClick(Sender: TObject);
begin
  SetSortButtonsState;
end;

procedure TRvWzMDForm.SortDetailFieldsLBClick(Sender: TObject);
begin
  SetSortButtonsState;
end;

procedure TRvWzMDForm.MasterMoveUpSBClick(Sender: TObject);
begin
  SortMasterFieldsLB.Items.Exchange(SortMasterFieldsLB.ItemIndex, SortMasterFieldsLB.ItemIndex-1);
  SortMasterFieldsLB.ItemIndex := SortMasterFieldsLB.ItemIndex - 1;
  SetSortButtonsState;
end;

procedure TRvWzMDForm.MasterMoveDownSBClick(Sender: TObject);
begin
  SortMasterFieldsLB.Items.Exchange(SortMasterFieldsLB.ItemIndex, SortMasterFieldsLB.ItemIndex + 1);
  SortMasterFieldsLB.ItemIndex := SortMasterFieldsLB.ItemIndex + 1;
  SetSortButtonsState;
end;

procedure TRvWzMDForm.DetailMoveUpSBClick(Sender: TObject);
begin
  SortDetailFieldsLB.Items.Exchange(SortDetailFieldsLB.ItemIndex, SortDetailFieldsLB.ItemIndex-1);
  SortDetailFieldsLB.ItemIndex := SortDetailFieldsLB.ItemIndex - 1;
  SetSortButtonsState;
end;

procedure TRvWzMDForm.DetailMoveDownSBClick(Sender: TObject);
begin
  SortDetailFieldsLB.Items.Exchange(SortDetailFieldsLB.ItemIndex, SortDetailFieldsLB.ItemIndex + 1);
  SortDetailFieldsLB.ItemIndex := SortDetailFieldsLB.ItemIndex + 1;
  SetSortButtonsState;
end;

procedure TRvWzMDForm.MasterKeyUpSBClick(Sender: TObject);
begin
  MasterKeySortLB.Items.Exchange(MasterKeySortLB.ItemIndex, MasterKeySortLB.ItemIndex-1);
  MasterKeySortLB.ItemIndex := MasterKeySortLB.ItemIndex - 1;
  SetSortButtonsState;
end;

procedure TRvWzMDForm.MasterKeyDownSBClick(Sender: TObject);
begin
  MasterKeySortLB.Items.Exchange(MasterKeySortLB.ItemIndex, MasterKeySortLB.ItemIndex + 1);
  MasterKeySortLB.ItemIndex := MasterKeySortLB.ItemIndex + 1;
  SetSortButtonsState;
end;

procedure TRvWzMDForm.DetailKeyUpSBClick(Sender: TObject);
begin
  DetailKeySortLB.Items.Exchange(DetailKeySortLB.ItemIndex, DetailKeySortLB.ItemIndex-1);
  DetailKeySortLB.ItemIndex := DetailKeySortLB.ItemIndex - 1;
  SetSortButtonsState;
end;

procedure TRvWzMDForm.DetailKeyDownSBClick(Sender: TObject);
begin
  DetailKeySortLB.Items.Exchange(DetailKeySortLB.ItemIndex, DetailKeySortLB.ItemIndex + 1);
  DetailKeySortLB.ItemIndex := DetailKeySortLB.ItemIndex + 1;
  SetSortButtonsState;
end;

function TRvWzMDForm.GetNumKeysSelected(CheckListBox: TCheckListBox): integer;

var
  I1: integer;

begin
  Result := 0;
  For I1 := 0 to CheckListBox.Items.Count -1 do begin
    If CheckListBox.Checked[I1] then begin
      Inc(Result);
    end; { if }
  end; { for }
end;

procedure TRvWzMDForm.GenerateReport;

var
  RavePage: TRavePage;
  RaveRegion: TRaveRegion;
  TitleBand: TRaveBand;
  RaveBand: TRaveBand;
  MasterDataBand: TRaveDataBand;
  DetailDataBand: TRaveDataBand;
  RaveText: TRaveText;
  RaveDBText: TRaveDataText;
  I1: integer;
  CurrLeft: double;
  LeftOffset: double;
  TextList: TList;
  DataList: TList;
  DataFieldList: TList;
  TotalWidth: double;

begin
  With ProjectManager.NewReport do begin
    RavePage := Child[0] as TRavePage;
    RavePage.Name := {Trans-}'MainPage';

    { Set up region }
    RaveRegion := TRaveRegion.Create(RavePage);
    With RaveRegion do begin
      Parent := RavePage;
      RegionName := MasterDVLB.Items[MasterDVLB.ItemIndex] + {Trans-}'Region';
      RegionName := Trim(RegionName);
      RaveRegion.Left := StrToFloatDef(LeftMarginEdit.Text, 1.0);
      RaveRegion.Top := StrToFloatDef(TopMarginEdit.Text, 1.0);
      RaveRegion.Width := StrToFloatDef(RightMarginEdit.Text, 1.0);
      RaveRegion.Width := RavePage.PageWidth - RaveRegion.Width - RaveRegion.Left;
      RaveRegion.Height := StrToFloatDef(BottomMarginEdit.Text,1.0);
      RaveRegion.Height := RavePage.PageHeight - RaveRegion.Height - RaveRegion.Top;
      Name := RegionName;
      AddComponent(RaveRegion);  // Add Region to Tree View
    end; { with }

    If ReportTitleCB.Checked then begin { add title to report }
      TitleBand := RaveRegion.CreateChild(TRaveBand,
                   MasterDVLB.Items[MasterDVLB.ItemIndex] + {Trans-}'TitleBand') as TRaveBand;
      With TitleBand do begin
        With BandStyle do begin
          PrintLoc := PrintLoc + [plBodyHeader];
        end; { with }
      end; { with }

      With TitleBand.CreateChild(TRaveText,{Trans-}'TitleText') as TRaveText do begin
        Font.Assign(TitlePanel.Font);
        FontJustify := pjCenter;
        Text := RptTitleEdit.Text;
        Width := RaveRegion.Width;
      { Add spacing underneath title }
        TitleBand.Height := Height * 1.5;
      end; { with }

    end else begin
      TitleBand := nil
    end; { else }

    { Set up Band }
    RaveBand := RaveRegion.CreateChild(TRaveBand,
     MasterDVLB.Items[MasterDVLB.ItemIndex] + {Trans-}'Band') as TRaveBand;
    With RaveBand do begin
      With BandStyle do begin
        PrintLoc := PrintLoc + [plRowHeader];
        PrintOcc := PrintOcc + [poNewPage,poFirst];
      end; { with }
      Height := CaptionPanel.Font.Size / 60;
    end; { with }

    { Set up Data Band }
    MasterDataBand := RaveRegion.CreateChild(TRaveDataBand,
                    MasterDVLB.Items[MasterDVLB.ItemIndex] + {Trans-}'DataBand') as TRaveDataBand;
    With MasterDataBand do begin
      DataView := TRaveBaseDataView(MasterDVLB.Items.Objects[MasterDVLB.ItemIndex]);
      With BandStyle do begin
        PrintOcc := PrintOcc + [poNewPage,poFirst];
      end; { with }
      Height := BodyPanel.Font.Size / 60;
    end; { with }

    { Add HLine to Band }
    RaveBand.CreateChild(TRaveHLine,
            MasterDVLB.Items[MasterDVLB.ItemIndex] + {Trans-}'HLine',
            0.0, RaveBand.Height * 0.99, RaveRegion.Width);

    RaveBand.ControllerBand := MasterDataBand;
    If Assigned(TitleBand) then begin { add title to report }
      TitleBand.ControllerBand := MasterDataBand;
    end; { if }

    { Add Data Fields }
    TextList := TList.Create;
    DataList := TList.Create;
    DataFieldList := TList.Create;
    TotalWidth := 0.0;
    try
      For I1 := 0 to SortMasterFieldsLB.Items.Count-1 do begin
        RaveText := RaveBand.CreateChild(TRaveText) as TRaveText;
        With RaveText do begin  { define text components }
          Font.Assign(CaptionPanel.Font);
          Text := SortMasterFieldsLB.Items[I1];
          Height := Font.Size / 60;
          TextList.Add(RaveText);
        end; { with }
        RaveDBText := MasterDataBand.CreateChild(TRaveDataText) as TRaveDataText;
        With RaveDBText do begin { define dbtext components }
          Font.Assign(BodyPanel.Font);
          Height := Font.Size / 60;
          DataList.Add(RaveDBText);
          DataField := (SortMasterFieldsLB.Items.Objects[I1] as TRaveDataField).FieldName;
        end; { with }
        TotalWidth := TotalWidth + TRaveDataField(SortMasterFieldsLB.Items.Objects[I1]).Size;
        DataFieldList.Add(TRaveDataField(SortMasterFieldsLB.Items.Objects[I1]));
      end; { for }

      CurrLeft := 0.0;
      For I1 := 0 to TextList.Count -1 do begin { position components }
        RaveText := TRaveText(TextList[I1]);
        RaveText.Left := CurrLeft;
        RaveDBText := TRaveDataText(DataList[I1]);
        RaveText.Width := TRaveDataField(DataFieldList[I1]).Size / TotalWidth * RaveRegion.Width;
        RaveDBText.Left := CurrLeft;
        RaveDBText.Width := RaveText.Width;
        RaveDBText.DataView := TRaveBaseDataView(MasterDVLB.Items.Objects[MasterDVLB.ItemIndex]);
      //RaveDBText.DataField := RaveText.Text;
        CurrLeft := CurrLeft + RaveText.Width;
      end; { for }

    finally
      If Assigned(TextList) then TextList.Free;
      If Assigned(DataList) then DataList.Free;
      If Assigned(DataFieldList) then DataFieldList.Free;
    end; { tryf }

    // Setup Detail Information

    { Set up Band }
    RaveBand := RaveRegion.CreateChild(TRaveBand,
     DetailDVLB.Items[DetailDVLB.ItemIndex] + {Trans-}'Band') as TRaveBand;
    With RaveBand do begin
      With BandStyle do begin
        PrintLoc := PrintLoc + [plBodyHeader];
        PrintOcc := PrintOcc + [poNewPage,poFirst];
      end; { with }
      Height := CaptionPanel.Font.Size / 60;
    end; { with }

    { Set up Detail Data Band }
    DetailDataBand := RaveRegion.CreateChild(TRaveDataBand,
                    DetailDVLB.Items[DetailDVLB.ItemIndex] + {Trans-}'DataBand') as TRaveDataBand;
    With DetailDataBand do begin
      DataView := TRaveBaseDataView(DetailDVLB.Items.Objects[DetailDVLB.ItemIndex]);
      ControllerBand := MasterDataBand;
      MasterDataView := MasterDVLB.Items.Objects[MasterDVLB.ItemIndex] as TRaveBaseDataView;
      MasterKey := GetKeys(MasterKeyCBL);
      DetailKey := GetKeys(DetailKeyCBL);
      With BandStyle do begin
        PrintLoc := PrintLoc + [plDetail];
      end; { with }
      Height := BodyPanel.Font.Size / 60;
    end; { with }

    RaveBand.ControllerBand := DetailDataBand;


    LeftOffset := StrToFloatDef(DetailOffsetEdit.Text, 0.5);
    { Add HLine to Band }
    RaveBand.CreateChild(TRaveHLine,
            DetailDVLB.Items[DetailDVLB.ItemIndex] + {Trans-}'HLine',
            LeftOffset, RaveBand.Height * 0.99, RaveRegion.Width - LeftOffset);

    { Add Data Fields }
    TextList := TList.Create;
    DataList := TList.Create;
    DataFieldList := TList.Create;
    TotalWidth := 0.0;
    try
      For I1 := 0 to SortDetailFieldsLB.Items.Count-1 do begin
        RaveText := RaveBand.CreateChild(TRaveText) as TRaveText;
        With RaveText do begin  { define text components }
          Font.Assign(CaptionPanel.Font);
          Text := SortDetailFieldsLB.Items[I1];
          //Height := Font.Size / 60;
          TextList.Add(RaveText);
        end; { with }
        RaveDBText := DetailDataBand.CreateChild(TRaveDataText) as TRaveDataText;
        With RaveDBText do begin { define dbtext components }
          Font.Assign(BodyPanel.Font);
          DataList.Add(RaveDBText);
          DataField := (SortDetailFieldsLB.Items.Objects[I1] as TRaveDataField).FieldName;
        end; { with }
        TotalWidth := TotalWidth + TRaveDataField(SortDetailFieldsLB.Items.Objects[I1]).Size;
        DataFieldList.Add(TRaveDataField(SortDetailFieldsLB.Items.Objects[I1]));
      end; { for }

      CurrLeft := LeftOffset;
      For I1 := 0 to TextList.Count -1 do begin { position components }
        RaveText := TRaveText(TextList[I1]);
        RaveText.Left := CurrLeft;
        RaveDBText := TRaveDataText(DataList[I1]);
        RaveText.Width := TRaveDataField(DataFieldList[I1]).Size / TotalWidth * (RaveRegion.Width - LeftOffset);
        RaveDBText.Left := CurrLeft;
        RaveDBText.Width := RaveText.Width;
        RaveDBText.Height := BodyPanel.Font.Size / 60;
        RaveDBText.DataView := TRaveBaseDataView(DetailDVLB.Items.Objects[DetailDVLB.ItemIndex]);
      //RaveDBText.DataField := RaveText.Text;
        CurrLeft := CurrLeft + RaveText.Width;
      end; { for }

    finally
      If Assigned(TextList) then TextList.Free;
      If Assigned(DataList) then DataList.Free;
      If Assigned(DataFieldList) then DataFieldList.Free;
    end; { tryf }

  end; { with }
end;

procedure TRvWzMDForm.TitleFontBtnClick(Sender: TObject);
begin
  FontDlg.Font.Assign(TitlePanel.Font);
  If FontDlg.Execute then begin
    TitlePanel.Font.Assign(FontDlg.Font);
  end; { if }
end;

procedure TRvWzMDForm.CaptionFontBtnClick(Sender: TObject);
begin
  FontDlg.Font.Assign(CaptionPanel.Font);
  If FontDlg.Execute then begin
    CaptionPanel.Font.Assign(FontDlg.Font);
  end; { if }
end;

procedure TRvWzMDForm.BodyFontBtnClick(Sender: TObject);
begin
  FontDlg.Font.Assign(BodyPanel.Font);
  If FontDlg.Execute then begin
    BodyPanel.Font.Assign(FontDlg.Font);
  end; { if }
end;

procedure TRvWzMDForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #27 then begin { Escape }
    ModalResult := mrCancel;
  end; { if }
end;

initialization
  RegisterProc('RVCL',RaveRegister);
end.