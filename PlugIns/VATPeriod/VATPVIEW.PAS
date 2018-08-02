unit VatPView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, VatPrSet, Menus;

type

  TfrmPeriodList = class(TForm)
    Panel1: TPanel;
    lvPeriods: TListView;
    btnEdit: TButton;
    btnAdd: TButton;
    Button2: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Tools1: TMenuItem;
    CopyPeriodTable1: TMenuItem;
    Period1: TMenuItem;
    AddatEnd1: TMenuItem;
    Edit1: TMenuItem;
    N2: TMenuItem;
    CloseCurrentPeriod2: TMenuItem;
    lblCurrentPeriod: TLabel;
    Label1: TLabel;
    btnInsert: TButton;
    SetCurrentPeriod1: TMenuItem;
    Insert1: TMenuItem;
    Options1: TMenuItem;
    Autofill1: TMenuItem;
    edtCurrentPeriod: TEdit;
    Button1: TButton;
    procedure btnEditClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure lvPeriodsAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure CopyPeriodTable1Click(Sender: TObject);
    procedure CloseCurrentPeriod2Click(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure SetCurrentPeriod1Click(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure Autofill1Click(Sender: TObject);
  private
    { Private declarations }
    FIndex : integer;
    FCurrentPIndex : integer;
    ShowPeriod : Boolean;
    procedure ShowSetPeriodDialog(Mode : TDialogMode);
    function GetNextYear : Integer;
    function GetNextPeriod : Integer;
    function GetPrevYear : Integer;
    function GetPrevPeriod : Integer;
    procedure SetListIndex(OffSet: integer = 0);
  public
    { Public declarations }
    procedure LoadList;
  end;

var
  frmPeriodList: TfrmPeriodList;

implementation

{$R *.dfm}
Uses
  VatPrObj, ETDateU, VatPrVar, DateUtils, CopyTab, VatPOpts;

procedure TfrmPeriodList.LoadList;
begin
  VatPeriod.GetList(lvPeriods, FCurrentPIndex);
  if (FIndex <> -1) and (FIndex < lvPeriods.Items.Count) then
    lvPeriods.ItemIndex := FIndex;

  if (ShowPeriod) and(FCurrentPIndex <> -1) and (FCurrentPIndex < lvPeriods.Items.Count) then
  begin
    lvPeriods.Items[FCurrentPIndex].MakeVisible(False);
    ShowPeriod := False;
  end;
end;

function TfrmPeriodList.GetNextYear : Integer;
var
  y, m, d : word;
  i : integer;
  dt : TDateTime;
  s : string;
begin
  i := lvPeriods.Items.Count;

  if i > 0 then
    Result := StrToInt(lvPeriods.Items[i-1].SubItems[0])
  else
  begin
    DecodeDate(Date, y, m, d);
    Result := y;
  end;
end;

function TfrmPeriodList.GetNextPeriod : Integer;
var
  i : integer;
  dt : TDateTime;
  s : string;
begin
  i := lvPeriods.Items.Count;

  if i > 0 then
    Result := StrToInt(lvPeriods.Items[i-1].Caption)
  else
    Result := 1;

  inc(Result);
  if Result > VatPeriod.MaxPeriods then
    Result := 1;
end;

function TfrmPeriodList.GetPrevYear : Integer;
var
  y, m, d : word;
  i : integer;
  dt : TDateTime;
  s : string;
begin
  i := lvPeriods.Items.Count;

  if i > 0 then
    Result := StrToInt(lvPeriods.Items[0].SubItems[0])
  else
  begin
    DecodeDate(Date, y, m, d);
    Result := y;
  end;
end;

function TfrmPeriodList.GetPrevPeriod : Integer;
var
  i : integer;
  dt : TDateTime;
  s : string;
begin
  i := lvPeriods.Items.Count;

  if i > 0 then
    Result := StrToInt(lvPeriods.Items[0].Caption)
  else
    Result := 1;

  Dec(Result);
  if Result < 1 then
    Result := VatPeriod.MaxPeriods;
end;

procedure TfrmPeriodList.ShowSetPeriodDialog(Mode : TDialogMode);
var
  FirstOne  : Boolean;
  lStartDate : TDate;
  y, m, d   : Word;
  Res : integer;
  s : string;
  Offset : integer;
  LastStart, LastEnd : TDate;
begin
  Offset := 12 div VatPeriod.MaxPeriods;
  FirstOne := lvPeriods.Items.Count = 0;
  if (Mode <> dmEdit) or Assigned(lvPeriods.Selected) then
  with TfrmVatPerSet.Create(nil) do
  Try
    LoadPeriods;
    AccessMode := Mode;
    Case Mode of
      dmAdd :  begin
                ListIndex := lvPeriods.Items.Count;
                if not FirstOne then
                begin
                  LastStart := StrToDate(lvPeriods.Items[lvPeriods.Items.Count - 1].SubItems[1]);
                  LastEnd := StrToDate(lvPeriods.Items[lvPeriods.Items.Count - 1].SubItems[2]);
                  OffSet := DaysBetween(LastStart, LastEnd);
                  cbPeriod.ItemIndex := Pred(GetNextPeriod);
                  CurrentYear := GetNextYear;
                  if cbPeriod.ItemIndex = 0 then
                    CurrentYear := CurrentYear + 1;
                  lStartDate := StrToDate(lvPeriods.Items[lvPeriods.Items.Count - 1].SubItems[2]) + 1;
                  dtpStartDate.Date := lStartDate;
                  dtpEndDate.Date := IncDay(lStartDate, Offset) - 1;
                end
                else
                begin
                  {Adding first period so allow period and year to be edited}
                  DecodeDate(Date, y, m, d);
                  CurrentYear := y;
                 { Dec(m);
                  if m < 0 then
                    m := VatPeriod.MaxPeriods - 1;}
                  cbPeriod.ItemIndex := 0;
                  cbYear.Enabled := True;
                  cbPeriod.Enabled := True;
                  dtpStartDate.Date := EncodeDate(y, 1, 1);
                  dtpEndDate.Date := IncDay(dtpStartDate.Date, Offset) - 1;
                end;
                Res := 0;
                ListIndex := lvPeriods.Items.Count;
                dtpStartDate.Enabled := FirstOne;
               end;
      dmInsert: begin
                  ListIndex := -1;
                  cbPeriod.ItemIndex := Pred(GetPrevPeriod);
                  CurrentYear := GetPrevYear;
                  if cbPeriod.ItemIndex = VatPeriod.MaxPeriods - 1 then
                    CurrentYear := CurrentYear - 1;
                  lStartDate := StrToDate(lvPeriods.Items[0].SubItems[1]);
                  dtpEndDate.Date := lStartDate - 1;
                  dtpStartDate.Date := IncMonth(lStartDate, -Offset);
                  dtpStartDate.Enabled := True;
                end;
      dmEdit : begin
                 //Find selected record
                 VatPeriod.Index := 0;
                 Res := VatPeriod.GetEqual(lvPeriods.Selected.SubItems[0]+
                                           lvPeriods.Selected.Caption, True);

                 cbPeriod.ItemIndex := Pred(StrtoInt(lvPeriods.Selected.Caption));
                 CurrentYear := StrToInt(lvPeriods.Selected.SubItems[0]);
                 EndDate := lvPeriods.Selected.SubItems[2];
                 StartDate := lvPeriods.Selected.SubItems[1];
                 ListIndex := lvPeriods.Selected.Index;
                 dtpStartDate.Enabled := ListIndex = 0;
               end;
    end;//case
    if Res = 0 then
    begin
      LoadYears;
      LView := lvPeriods;
      ShowModal;

  //    if ModalResult = mrOK then
      if OKPressed then
      begin
        if Mode in [dmAdd, dmInsert] then
        begin
          VatPeriod.Period := cbYear.Text + cbPeriod.Text;
          VatPeriod.StartDate := FormatDateTime('YYYYMMDD', dtpStartDate.Date);
          VatPeriod.EndDate := FormatDateTime('YYYYMMDD', dtpEndDate.Date);
          if Mode = dmAdd then
            Res := VatPeriod.Add
          else
            Res := VatPeriod.Insert; //insert needs to update next start date

          if Res <> 0 then
            ShowMessage('Error adding period record: ' + IntToStr(Res));
          if FirstOne then
          begin
            VatPeriod.CurrentPeriod := cbYear.Text + cbPeriod.Text;
          end;
        end
        else
        if Mode = dmEdit then
        begin
          VatPeriod.StartDate := FormatDateTime('YYYYMMDD', dtpStartDate.Date);
          VatPeriod.EndDate := FormatDateTime('YYYYMMDD', dtpEndDate.Date);
          Res := VatPeriod.Save;
          if FIndex = FCurrentPIndex then
            VatPeriod.CurrentPeriod := VatPeriod.Period;
        end;
        LoadList;
      end;
    end;
  Finally
    Free;
  End;
end;

procedure TfrmPeriodList.btnEditClick(Sender: TObject);
begin
  SetListIndex;
  ShowSetPeriodDialog(dmEdit);
  lvPeriods.SetFocus;
end;

procedure TfrmPeriodList.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPeriodList.lvPeriodsAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  with Sender as TListView do
  begin
    if Item.SubItems.Count > 0 then
    begin
      if Item.SubItems[0] + Item.Caption = VatPeriod.CurrentPeriodString then
      begin
        Canvas.Font.Color := VatPeriod.CurrColor;
//        lblCurrentPeriod.Caption := Item.Caption + '/' + Item.SubItems[0];
        edtCurrentPeriod.Text := Item.Caption + '/' + Item.SubItems[0];
        FCurrentPIndex := Item.Index;
      end
      else
        Canvas.Font.Color := VatPeriod.TextColor;
    end;
  end;
  DefaultDraw := True;
end;

procedure TfrmPeriodList.CopyPeriodTable1Click(Sender: TObject);
begin
  with TfrmCopyTable.Create(nil) do
  Try
    ShowModal;
  Finally
    Free;
  End;
end;

procedure TfrmPeriodList.CloseCurrentPeriod2Click(Sender: TObject);
begin
  if FCurrentPIndex < lvPeriods.Items.Count -1 then
  begin
    if MessageDlg('Please confirm you wish to close the current VAT Period',
                  mtConfirmation, mbYesNoCancel, 0) = mrYes then
    begin
      SetListIndex;
      VatPeriod.EndDate := FormatDateTime('YYYYMMDD', StrToDate(lvPeriods.Items[FCurrentPIndex + 1].SubItems[2]));
      VatPeriod.CloseCurrentPeriod;
      ShowPeriod := True;
      LoadList;
    end;
  end
  else
    MessageDlg('The Current Period cannot be closed until future periods have been added.', mtWarning, [mbOK], 0);
end;

procedure TfrmPeriodList.btnInsertClick(Sender: TObject);
begin
  if lvPeriods.Items.Count > 0 then
  begin
    SetListIndex(1);
    ShowSetPeriodDialog(dmInsert);
    lvPeriods.SetFocus;
  end
  else
    btnAddClick(Sender);
end;

procedure TfrmPeriodList.SetCurrentPeriod1Click(Sender: TObject);
begin
  if Assigned(lvPeriods.Selected) then
  begin
    VatPeriod.EndDate := FormatDateTime('YYYYMMDD', StrToDate(lvPeriods.Selected.SubItems[2]));
    VatPeriod.CurrentPeriod := lvPeriods.Selected.SubItems[0] + lvPeriods.Selected.Caption;
    LoadList;
  end
  else
    ShowMessage('No period selected');
end;

procedure TfrmPeriodList.btnAddClick(Sender: TObject);
begin
  SetListIndex;
  ShowSetPeriodDialog(dmAdd);
  lvPeriods.SetFocus;
end;

procedure TfrmPeriodList.FormCreate(Sender: TObject);
begin
  FIndex := -1;
//  Label1.Font.Color := VatPeriod.CurrColor;
//  lblCurrentPeriod.Font.Color := VatPeriod.CurrColor;
  edtCurrentPeriod.Font.Color := VatPeriod.CurrColor;
  edtCurrentPeriod.Color := VatPeriod.BackColor;
  lvPeriods.Color := VatPeriod.BackColor;
  lvPeriods.Font.Color := VatPeriod.TextColor;
  ShowPeriod := True;
end;

procedure TfrmPeriodList.SetListIndex(OffSet : integer = 0);
begin
  if Assigned(lvPeriods.Selected) then
    FIndex := lvPeriods.ItemIndex + Offset
  else
    FIndex := -1;
end;

procedure TfrmPeriodList.Options1Click(Sender: TObject);
var
  Res : integer;
begin
  Res := VatPeriod.GetOptsRec;
  if Res = 0 then
  begin
    with TfrmOptions.Create(nil) do
    Try
      spPeriods.Value := VatPeriod.MaxPeriods;
      chkAutoFill.Checked := VatPeriod.UseAutoFillInPostingHook;
      colBack.Selected := VatPeriod.BackColor;
      colText.Selected := VatPeriod.TextColor;
      colCurr.Selected := VatPeriod.CurrColor;
      ShowModal;

      if ModalResult = mrOK then
      begin
        VatPeriod.MaxPeriods := spPeriods.Value;
        VatPeriod.UseAutoFillInPostingHook := chkAutoFill.Checked;
        VatPeriod.BackColor := colBack.Selected;
        VatPeriod.TextColor := colText.Selected;
        VatPeriod.CurrColor := colCurr.Selected;

        Res := VatPeriod.SaveOptsRec;
        if Res = 0 then
        begin
          lvPeriods.Color := VatPeriod.BackColor;
          lvPeriods.Font.Color := VatPeriod.TextColor;
          edtCurrentPeriod.Font.Color := VatPeriod.CurrColor;
          edtCurrentPeriod.Color := VatPeriod.BackColor;
          LoadList;
        end;
        BtrvErr(Res, 'storing Options record');
      end;
    Finally
      Free;
    End;
  end;
  BtrvErr(Res, 'loading Options record');
end;

procedure TfrmPeriodList.Autofill1Click(Sender: TObject);
var
  i : integer;
begin
  i := lvPeriods.Items.Count - 1;
  if i >= 0 then
  begin
    VatPeriod.Autofill(lvPeriods.Items[i].SubItems[2]);
    LoadList;
  end;
end;

end.
