{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RvWzSimp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, CheckLst, RVProj, RVData, RVClass, RVUtil, RPDefine,
  RVDirectDataView, RVDataField;

type
  TPages = (nbDataView, nbFields, nbSortFields, nbOptions, nbFonts);

  TRvWzSimpleForm = class(TForm)
    NB: TNotebook;
    ButtonPanel: TPanel;
    CancelBtn: TBitBtn;
    NextGenBtn: TBitBtn;
    BackBtn: TBitBtn;
    Panel2: TPanel;
    DataViewLB: TListBox;
    Panel1: TPanel;
    FieldsCBL: TCheckListBox;
    Panel3: TPanel;
    Panel4: TPanel;
    TitlePanel: TPanel;
    Panel6: TPanel;
    CaptionPanel: TPanel;
    Panel8: TPanel;
    BodyPanel: TPanel;
    Panel10: TPanel;
    TitleFontBtn: TBitBtn;
    CaptionFontBtn: TBitBtn;
    BodyFontBtn: TBitBtn;
    FontDlg: TFontDialog;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    LeftMarginEdit: TEdit;
    TopMarginEdit: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    RightMarginEdit: TEdit;
    BottomMarginEdit: TEdit;
    Label5: TLabel;
    GroupBox2: TGroupBox;
    RptTitleEdit: TEdit;
    ReportTitleCB: TCheckBox;
    Panel5: TPanel;
    SelectAllBtn: TBitBtn;
    SelectNoneBtn: TBitBtn;
    Panel7: TPanel;
    Panel9: TPanel;
    MoveUpSB: TSpeedButton;
    MoveDownSB: TSpeedButton;
    SortFieldsLB: TListBox;
    Panel11: TPanel;
    HeaderPanel: TPanel;
    Image1: TImage;
    procedure NextGenBtnClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure SelectAllBtnClick(Sender: TObject);
    procedure SelectNoneBtnClick(Sender: TObject);
    procedure FieldsCBLClick(Sender: TObject);
    procedure GenerateReport;
    procedure MoveUpSBClick(Sender: TObject);
    procedure MoveDownSBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TitleFontBtnClick(Sender: TObject);
    procedure CaptionFontBtnClick(Sender: TObject);
    procedure BodyFontBtnClick(Sender: TObject);
    procedure SortFieldsLBClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FCurrPage: TPages;
    FRegionName: string;
    procedure SetPage(Page: TPages);
    procedure SetFields(DataView: TRaveBaseDataView);
    procedure SetSortFields;
    procedure SetButtonState;
    function FieldsChecked: boolean;
    property RegionName: string read FRegionName write FRegionName;
  public
    { Public declarations }
    property CurrPage: TPages read FCurrPage write SetPage;
  end;

const
  Headers: array[TPages] of string = ({Trans+}'Select The Data View you wish to use for this report',
                                      {Trans+}'Select The Fields you wish to use for this report',
                                      {Trans+}'Arrange Fields In The Order You Wish Them Printed',
                                      {Trans+}'Report Layout Options',
                                      {Trans+}'Select the desired fonts to use for this report');
  NextHints: array[TPages] of string = ({Trans+}'Move To Select Fields Panel',
                                        {Trans+}'Move To Arrange Fields Panel',
                                        {Trans+}'Move To Options Panel',
                                        {Trans+}'Move To Font Panel',
                                        {Trans+}'Generate The Report');
  BackHints: array[TPages] of string = ('',
                                        {Trans+}'Move To Data View Panel',
                                        {Trans+}'Move To Select Fields Panel',
                                        {Trans+}'Move To Arrange Fields Panel',
                                        {Trans+}'Move To Options Panel');
  NextGenCaptions: array[boolean] of string = ({Trans+}'&Next >',
                                               {Trans+}'&Generate');

var
  RvWzSimpleForm: TRvWzSimpleForm;

implementation

uses
  RvCsRpt, RVCsData, RVCsStd, RVCsDraw;

{$R *.DFM}

{ TRvWzSimpleForm }

procedure TRvWzSimpleForm.FormCreate(Sender: TObject);

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
        DataViewLB.Items.AddObject(DataView.Name, DataView);
      end; { if }
    end; { for }
    // the default ItemIndex = 0 but the listbox is not showing item 0
    // as being selected.  The next two lines corrects that problem.
    DataViewLB.ItemIndex := 1;
    DataViewLB.ItemIndex := 0;
  end; { with }

  CurrPage := nbDataView;
  HeaderPanel.Caption := Trans(Headers[CurrPage]);
end;

procedure TRvWzSimpleForm.FormDestroy(Sender: TObject);
begin
  SaveToolWin(self);
end;

procedure TRvWzSimpleForm.FormShow(Sender: TObject);
begin
  RestoreToolWin(self);
  BackBtn.Hint := Trans(BackHints[CurrPage]);
  NextGenBtn.Hint := Trans(NextHints[CurrPage]);
end;

procedure TRvWzSimpleForm.SetPage(Page: TPages);
begin
  NB.PageIndex := Ord(Page);
  FCurrPage := Page;
end;

procedure TRvWzSimpleForm.NextGenBtnClick(Sender: TObject);
begin
  If CurrPage <> High(CurrPage) then begin
    Inc(FCurrPage);
    CurrPage := FCurrPage;
    HeaderPanel.Caption := Trans(Headers[CurrPage]);
    NextGenBtn.Caption := Trans(NextGenCaptions[High(CurrPage) = CurrPage]);
    case CurrPage of
      nbFields: begin
        SetFields(TRaveBaseDataView(DataViewLB.Items.Objects[DataViewLB.ItemIndex]));
        FieldsCBL.ItemIndex := -1;
      end; { nbFields }
      nbSortFields: begin
        SetSortFields;
        SortFieldsLB.ItemIndex := 0;
        If SortFieldsLB.Items.Count <= 1 then begin
          NextGenBtnClick(NextGenBtn);
        end; { if }
      end; { nbFields }
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

procedure TRvWzSimpleForm.BackBtnClick(Sender: TObject);
begin
  If CurrPage <> Low(CurrPage) then begin
    Dec(FCurrPage);
    If (FCurrPage = nbSortFields) and (SortFieldsLB.Items.Count <= 1) then begin
      Dec(FCurrPage);
    end; { if }
    CurrPage := FCurrPage;
  end;
  HeaderPanel.Caption := Trans(Headers[CurrPage]);
  NextGenBtn.Caption := Trans(NextGenCaptions[High(CurrPage) = CurrPage]);
  SetButtonState;
end;

procedure TRvWzSimpleForm.SetFields(DataView: TRaveBaseDataView);

var
  I1: integer;
  DataField: TRaveDataField;

begin
  FieldsCBL.Items.Clear;
  For I1 := 0 to DataView.ChildCount-1 do begin
    DataField := TRaveDataField(DataView.Child[I1]);
    If (DataField.DataType <> dtBlob) and
       (DataField.DataType <> dtMemo) and
       (DataField.DataType <> dtGraphic) then begin
      FieldsCBL.Items.AddObject(DataField.FullName, DataField);
    end; { if }
  end; { for }
  NextGenBtn.Enabled := false;
end;

procedure TRvWzSimpleForm.SetSortFields;

var
  I1: integer;
  DataField: TRaveDataField;

begin
  SortFieldsLB.Items.Clear;
  For I1 := 0 to FieldsCBL.Items.Count-1 do begin
    If FieldsCBL.Checked[I1] then begin
      DataField := TRaveDataField(FieldsCBL.Items.Objects[I1]);
      SortFieldsLB.Items.AddObject(DataField.FullName, DataField);
    end; { if }
  end; { for }
  SetButtonState;
end;

procedure TRvWzSimpleForm.SelectAllBtnClick(Sender: TObject);

var
  I1: integer;

begin
  For I1 := 0 to FieldsCBL.Items.Count -1 do begin
    FieldsCBL.Checked[I1] := true;
  end; { for }
  NextGenBtn.Enabled := true;
end;

procedure TRvWzSimpleForm.SelectNoneBtnClick(Sender: TObject);

var
  I1: integer;

begin
  For I1 := 0 to FieldsCBL.Items.Count -1 do begin
    FieldsCBL.Checked[I1] := false;
  end; { for }
  NextGenBtn.Enabled := false;
end;

procedure TRvWzSimpleForm.SetButtonState;
begin
  BackBtn.Enabled := Low(CurrPage) <> CurrPage;
  BackBtn.Hint := Trans(BackHints[CurrPage]);
  NextGenBtn.Hint := Trans(NextHints[CurrPage]);
  case CurrPage of
    nbDataView: begin
      NextGenBtn.Enabled := true;
    end; { nbDataView }
    nbFields: begin
      NextGenBtn.Enabled := FieldsChecked;
      MoveUpSB.Enabled := false;
      MoveDownSB.Enabled := false;
    end; { nbFields }
    nbSortFields: begin
      MoveUpSB.Enabled := SortFieldsLB.ItemIndex > 0;
      MoveDownSB.Enabled := (SortFieldsLB.ItemIndex < SortFieldsLB.Items.Count -1) and
                            (SortFieldsLB.ItemIndex >= 0);
    end; { nbSortFields }
    nbOptions: begin
      RegionName := DataViewLB.Items[DataViewLB.ItemIndex] + {Trans-}'Region';
    end; { nbOptions }
  end; { case }
end;

procedure TRvWzSimpleForm.FieldsCBLClick(Sender: TObject);
begin
  NextGenBtn.Enabled := FieldsChecked;
end;

function TRvWzSimpleForm.FieldsChecked: boolean;

var
  I1: integer;

begin
  Result := false;
  For I1 := 0 to FieldsCBL.Items.Count -1 do begin
    If FieldsCBL.Checked[I1] then begin
      Result := true;
      Exit;
    end; { if }
  end; { for }
end;

procedure TRvWzSimpleForm.GenerateReport;

var
  RavePage: TRavePage;
  RaveRegion: TRaveRegion;
  TitleBand: TRaveBand;
  RaveBand: TRaveBand;
  RaveDataBand: TRaveDataBand;
  RaveText: TRaveText;
  RaveDBText: TRaveDataText;
  I1: integer;
  CurrLeft: double;
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
                   DataViewLB.Items[DataViewLB.ItemIndex] + {Trans-}'TitleBand') as TRaveBand;
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
     DataViewLB.Items[DataViewLB.ItemIndex] + {Trans-}'Band') as TRaveBand;
    With RaveBand do begin
      With BandStyle do begin
        PrintLoc := PrintLoc + [plBodyHeader];
        PrintOcc := PrintOcc + [poNewPage];
      end; { with }
      Height := CaptionPanel.Font.Size / 60;
    end; { with }

    { Set up Data Band }
    RaveDataBand := RaveRegion.CreateChild(TRaveDataBand,
                    DataViewLB.Items[DataViewLB.ItemIndex] + {Trans-}'DataBand') as TRaveDataBand;
    With RaveDataBand do begin
      DataView := TRaveBaseDataView(DataViewLB.Items.Objects[DataViewLB.ItemIndex]);
      Height := BodyPanel.Font.Size / 60;
    end; { with }

    { Add HLine to Band }
    RaveBand.CreateChild(TRaveHLine,
            DataViewLB.Items[DataViewLB.ItemIndex] + {Trans-}'HLine',
            0.0, RaveBand.Height * 0.99, RaveRegion.Width);

    RaveBand.ControllerBand := RaveDataBand;
    If Assigned(TitleBand) then begin { add title to report }
      TitleBand.ControllerBand := RaveDataBand;
    end; { if }

    { Add Data Fields }
    TextList := TList.Create;
    DataList := TList.Create;
    DataFieldList := TList.Create;
    TotalWidth := 0.0;
    try
      For I1 := 0 to SortFieldsLB.Items.Count-1 do begin
        RaveText := RaveBand.CreateChild(TRaveText) as TRaveText;
        With RaveText do begin  { define text components }
          Text := SortFieldsLB.Items[I1];
          Font.Assign(CaptionPanel.Font);
          //Height := Font.Size / 60;
          TextList.Add(RaveText);
        end; { with }
        RaveDBText := RaveDataBand.CreateChild(TRaveDataText) as TRaveDataText;
        With RaveDBText do begin { define dbtext components }
          Font.Assign(BodyPanel.Font);
          DataList.Add(RaveDBText);
          DataField := (SortFieldsLB.Items.Objects[I1] as TRaveDataField).FieldName;
        end; { with }
        TotalWidth := TotalWidth + TRaveDataField(SortFieldsLB.Items.Objects[I1]).Size;
        DataFieldList.Add(TRaveDataField(SortFieldsLB.Items.Objects[I1]));
      end; { for }

      CurrLeft := 0.0;
      For I1 := 0 to TextList.Count -1 do begin { position components }
        RaveText := TRaveText(TextList[I1]);
        RaveText.Left := CurrLeft;
        RaveDBText := TRaveDataText(DataList[I1]);
        RaveText.Width := TRaveDataField(DataFieldList[I1]).Size / TotalWidth * RaveRegion.Width;
        RaveDBText.Left := CurrLeft;
        RaveDBText.Height := BodyPanel.Font.Size / 60;
        RaveDBText.Width := RaveText.Width;
        RaveDBText.DataView := TRaveBaseDataView(DataViewLB.Items.Objects[DataViewLB.ItemIndex]);
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

procedure TRvWzSimpleForm.MoveUpSBClick(Sender: TObject);

begin
  SortFieldsLB.Items.Exchange(SortFieldsLB.ItemIndex, SortFieldsLB.ItemIndex-1);
  SortFieldsLB.ItemIndex := SortFieldsLB.ItemIndex - 1;
  MoveUpSB.Enabled := SortFieldsLB.ItemIndex > 0;
  MoveDownSB.Enabled := SortFieldsLB.ItemIndex < SortFieldsLB.Items.Count - 1;
end;

procedure TRvWzSimpleForm.MoveDownSBClick(Sender: TObject);

begin
  SortFieldsLB.Items.Exchange(SortFieldsLB.ItemIndex, SortFieldsLB.ItemIndex + 1);
  SortFieldsLB.ItemIndex := SortFieldsLB.ItemIndex + 1;
  MoveUpSB.Enabled := SortFieldsLB.ItemIndex > 0;
  MoveDownSB.Enabled := SortFieldsLB.ItemIndex < SortFieldsLB.Items.Count - 1;
end;

procedure TRvWzSimpleForm.TitleFontBtnClick(Sender: TObject);
begin
  FontDlg.Font.Assign(TitlePanel.Font);
  If FontDlg.Execute then begin
    TitlePanel.Font.Assign(FontDlg.Font);
  end; { if }
end;

procedure TRvWzSimpleForm.CaptionFontBtnClick(Sender: TObject);
begin
  FontDlg.Font.Assign(CaptionPanel.Font);
  If FontDlg.Execute then begin
    CaptionPanel.Font.Assign(FontDlg.Font);
  end; { if }
end;

procedure TRvWzSimpleForm.BodyFontBtnClick(Sender: TObject);
begin
  FontDlg.Font.Assign(BodyPanel.Font);
  If FontDlg.Execute then begin
    BodyPanel.Font.Assign(FontDlg.Font);
  end; { if }
end;

procedure TRvWzSimpleForm.SortFieldsLBClick(Sender: TObject);
begin
  SetButtonState;
end;

procedure TRvWzSimpleForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #27 then begin { Escape }
    ModalResult := mrCancel;
  end; { if }
end;

end.