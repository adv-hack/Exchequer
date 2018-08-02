{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPEDTxt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, RVUtil, RVData, RVProj, RPDefine, RVClass,
  RVDataField;

type
  TDataTextEditor = class(TForm)
    GroupBox1: TGroupBox;
    DataTextMemo: TMemo;
    PlusBtn: TSpeedButton;
    AmperBtn: TSpeedButton;
    GroupBox2: TGroupBox;
    DataViewCB: TComboBox;
    Label1: TLabel;
    DataFieldCB: TComboBox;
    InsertFieldBtn: TButton;
    GroupBox3: TGroupBox;
    VariableCB: TComboBox;
    InsertVarBtn: TButton;
    GroupBox4: TGroupBox;
    ParamCB: TComboBox;
    InsertParamBtn: TButton;
    OKBtn: TButton;
    CancelBtn: TButton;
    DataViewGB: TGroupBox;
    DefaultRB: TRadioButton;
    SelectedRB: TRadioButton;
    GroupBox5: TGroupBox;
    InsertPIVarBtn: TButton;
    PIVarCB: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DataViewCBChange(Sender: TObject);
    procedure VariableCBChange(Sender: TObject);
    procedure ParamCBChange(Sender: TObject);
    procedure InsertFieldBtnClick(Sender: TObject);
    procedure InsertVarBtnClick(Sender: TObject);
    procedure InsertParamBtnClick(Sender: TObject);
    procedure PlusBtnClick(Sender: TObject);
    procedure AmperBtnClick(Sender: TObject);
    procedure DataFieldCBChange(Sender: TObject);
    procedure DefaultRBClick(Sender: TObject);
    procedure SelectedRBClick(Sender: TObject);
    procedure RBEnter(Sender: TObject);
    procedure InsertPIVarBtnClick(Sender: TObject);
    procedure PIVarCBChange(Sender: TObject);
  private
    FDataView: TRaveBaseDataView;
    FDataInst: TRaveComponent;
    function GetDataText: string;
    procedure SetDataText(Value: string);
    procedure InitDataFieldCB;
  public
    property DataText: string read GetDataText write SetDataText;
    property DataView: TRaveBaseDataView read FDataView write FDataView;
    property DataInst: TRaveComponent read FDataInst write FDataInst;
  end;

var
  DataTextEditor: TDataTextEditor;

implementation

{$R *.DFM}

(*****************************************************************************}
( class TDataTextEditor
(*****************************************************************************)

procedure TDataTextEditor.FormCreate(Sender: TObject);

begin
{TransOff}
  FormTrans(self);
  PrepareToolWin(self);
  VariableCB.Items.Add('CurrentPage');
  VariableCB.Items.Add('RelativePage');
  VariableCB.Items.Add('TotalPages');
  VariableCB.Items.Add('DateShort');
  VariableCB.Items.Add('DateLong');
  VariableCB.Items.Add('DateUS');
  VariableCB.Items.Add('DateInter');
  VariableCB.Items.Add('TimeShort');
  VariableCB.Items.Add('TimeLong');
  VariableCB.Items.Add('TimeAMPM');
  VariableCB.Items.Add('Time24');
  VariableCB.Items.Add('PrinterName');
  VariableCB.Items.Add('DriverName');
  VariableCB.Items.Add('PortName');
{TransOn}
end;

procedure TDataTextEditor.FormDestroy(Sender: TObject);

begin
  SaveToolWin(self);
end;

procedure TDataTextEditor.FormShow(Sender: TObject);

var
  I1: integer;
  TempDataView: TRaveBaseDataView;

  procedure AddValues(StrList: TStrings;
                      ListCB: TComboBox;
                      InsertBtn: TButton);

  var
    I1: integer;

  begin { AddValues }
    For I1 := 0 to (StrList.Count - 1) do begin
      ListCB.Items.Add(StrList[I1]);
      If not ListCB.Enabled then begin
        ListCB.Enabled := true;
        InsertBtn.Enabled := true;
        ListCB.ItemIndex := 0;
      end; { if }
    end; { for }
  end;  { AddValues }

begin
  RestoreToolWin(self);

{ Fill up Data Field Items }
  If Assigned(DataView) then begin
    DefaultRB.Caption := Trans('Default') + {Trans-}':     (' + DataView.Name + ')';
    DefaultRB.Checked := true;
  end else begin
    DefaultRB.Enabled := false;
    SelectedRB.Checked := true;
  end; { else }
  For I1 := 0 to ProjectManager.DataObjectList.Count - 1 do begin
    If TObject(ProjectManager.DataObjectList[I1]) is TRaveBaseDataView then begin
      TempDataView := TRaveBaseDataView(ProjectManager.DataObjectList[I1]);
      DataViewCB.Items.AddObject(TempDataView.Name,TempDataView);
    end; { if }
  end; { for }
  DataViewCB.ItemIndex := 0;
  InitDataFieldCB;

{ Initialize components }
  VariableCB.ItemIndex := 0;

{ Initialize Parameters and PIVars }
  AddValues(ProjectManager.Parameters,ParamCB,InsertParamBtn);
  AddValues(ProjectManager.PIVars,PIVarCB,InsertPIVarBtn);
  If Assigned(DataInst.Page) then begin
    If not DataInst.Page.Global then begin
      AddValues((DataInst.Page.Parent as TRaveReport).Parameters,ParamCB,InsertParamBtn);
      AddValues((DataInst.Page.Parent as TRaveReport).PIVars,PIVarCB,InsertPIVarBtn);
    end; { if }
    AddValues(DataInst.Page.Parameters,ParamCB,InsertParamBtn);
    AddValues(DataInst.Page.PIVars,PIVarCB,InsertPIVarBtn);
  end; { if }  
  For I1 := 0 to (ProjectManager.GlobalPageList.Count - 1) do begin
    AddValues(TRavePage(ProjectManager.GlobalPageList[I1]).Parameters,ParamCB,InsertParamBtn);
    AddValues(TRavePage(ProjectManager.GlobalPageList[I1]).PIVars,PIVarCB,InsertPIVarBtn);
  end; { for }
end;

function TDataTextEditor.GetDataText: string;

begin { GetDataText }
  Result := DataTextMemo.Text;
end;  { GetDataText }

procedure TDataTextEditor.SetDataText(Value: string);

begin { SetDataText }
  DataTextMemo.Text := Value;
  DataTextMemo.SelStart := DataTextMemo.GetTextLen;
  DataTextMemo.SelLength := 0;
end;  { SetDataText }

procedure TDataTextEditor.InitDataFieldCB;

var
  I1: integer;
  TempDataView: TRaveBaseDataView;
  DataField: TRaveDataField;

begin { InitDataFieldCB }
{ Initialize DataFieldCB }
  DataFieldCB.Clear;
  If DefaultRB.Checked then begin
    TempDataView := DataView;
  end else begin
    If (DataViewCB.Items.Count < 1) or (DataViewCB.ItemIndex < 0) then begin
      Exit;
    end; { if }
    If DataViewCB.ItemIndex >= 0 then begin
      TempDataView := TRaveBaseDataView(DataViewCB.Items.Objects[DataViewCB.ItemIndex]);
    end else begin
      TempDataView := nil;
    end; { else }
  end; { else }
  If Assigned(TempDataView) then begin
    For I1 := 0 to TempDataView.ChildCount - 1 do begin
      DataField := TRaveDataField(TempDataView.Child[I1]);
      If DataField.FullName = StripJoinChars(DataField.FieldName) then begin
        DataFieldCB.Items.AddObject(DataField.FieldName,DataField);
      end else begin
        DataFieldCB.Items.AddObject(DataField.FullName + {Trans-}' (' +
         StripJoinChars(DataField.FieldName) + ')',DataField);
      end; { else }
    end; { for }
    DataFieldCB.ItemIndex := 0;
  end; { if }
end;  { InitDataFieldCB }

procedure TDataTextEditor.DataViewCBChange(Sender: TObject);

begin
  InitDataFieldCB;
  SelectedRBClick(SelectedRB);
  DataTextMemo.SetFocus;
end;

procedure TDataTextEditor.VariableCBChange(Sender: TObject);

begin
  DataTextMemo.SetFocus;
end;

procedure TDataTextEditor.ParamCBChange(Sender: TObject);

begin
  DataTextMemo.SetFocus;
end;

procedure TDataTextEditor.InsertFieldBtnClick(Sender: TObject);

begin
  If DataFieldCB.ItemIndex >= 0 then begin
    If DefaultRB.Checked then begin
      DataTextMemo.SelText :=
       TRaveDataField(DataFieldCB.Items.Objects[DataFieldCB.ItemIndex]).FieldName;
    end else begin
      DataTextMemo.SelText := DataViewCB.Text + '.' +
       TRaveDataField(DataFieldCB.Items.Objects[DataFieldCB.ItemIndex]).FieldName;
    end; { else }
    DataTextMemo.SetFocus;
  end; { if }
end;

procedure TDataTextEditor.InsertVarBtnClick(Sender: TObject);

begin
  DataTextMemo.SelText := {Trans-}'Report.' + VariableCB.Text;
  DataTextMemo.SetFocus;
end;

procedure TDataTextEditor.InsertParamBtnClick(Sender: TObject);

begin
  DataTextMemo.SelText := {Trans-}'Param.' + AddJoinChars(ParamCB.Text);
  DataTextMemo.SetFocus;
end;

procedure TDataTextEditor.PlusBtnClick(Sender: TObject);

begin
  DataTextMemo.SelText := {Trans-}' + ';
  DataTextMemo.SetFocus;
end;

procedure TDataTextEditor.AmperBtnClick(Sender: TObject);

begin
  DataTextMemo.SelText := {Trans-}' & ';
  DataTextMemo.SetFocus;
end;

procedure TDataTextEditor.DataFieldCBChange(Sender: TObject);

begin
  DataTextMemo.SetFocus;
end;

procedure TDataTextEditor.DefaultRBClick(Sender: TObject);

begin
  If not DefaultRB.Checked then begin
    DefaultRB.Checked := true;
    InitDataFieldCB;
  end; { if }
end;

procedure TDataTextEditor.SelectedRBClick(Sender: TObject);

begin
  If not SelectedRB.Checked then begin
    SelectedRB.Checked := true;
    InitDataFieldCB;
  end; { if }
end;

procedure TDataTextEditor.RBEnter(Sender: TObject);

begin
  TRadioButton(Sender).OnClick(Sender);
  DataTextMemo.SetFocus;
end;

procedure TDataTextEditor.InsertPIVarBtnClick(Sender: TObject);

begin
  DataTextMemo.SelText := {Trans-}'PIVar.' + AddJoinChars(PIVarCB.Text);
  DataTextMemo.SetFocus;
end;

procedure TDataTextEditor.PIVarCBChange(Sender: TObject);

begin
  DataTextMemo.SetFocus;
end;

end.
