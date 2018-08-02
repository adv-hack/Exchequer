{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPEDMS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RVDefine, RVClass, RVTool, RVPESys, RVUtil, RVCsStd, RVCsData, RVProj, StdCtrls,
  RPDefine;

type
  TDataMirrorEditor = class(TForm)
    GroupBox1: TGroupBox;
    DataMirrorLB: TListBox;
    SettingsGB: TGroupBox;
    OKBtn: TButton;
    CancelBtn: TButton;
    ValueLabel: TLabel;
    ValueEdit: TEdit;
    SectionLabel: TLabel;
    SectionCB: TComboBox;
    AddBtn: TButton;
    DeleteBtn: TButton;
    DefaultCB: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure DataMirrorLBClick(Sender: TObject);
    procedure ValueEditChange(Sender: TObject);
    procedure SectionCBChange(Sender: TObject);
    procedure DefaultCBClick(Sender: TObject);
  private
    FDataMirrorSection: TRaveDataMirrorSection;
    FDataMirrors: TRavePersistentList;
    SuspendChanging: boolean;
    procedure SetDataMirrors(Value: TRavePersistentList);
    function FindSectionIndex(SectionMirror: TRaveSection): integer;
    function DataMirrorStr(DataMirror: TRaveDataMirror): string;
    procedure AddItem(DataMirror: TRaveDataMirror);
    function Include(Value: TComponent;
                     Data: longint): boolean;
    procedure SetNewValue(DM: TRaveDataMirror);
  public
    property DataMirrors: TRavePersistentList read FDataMirrors write SetDataMirrors;
    property DataMirrorSection: TRaveDataMirrorSection read FDataMirrorSection
     write FDataMirrorSection;
  end;

var
  DataMirrorEditor: TDataMirrorEditor;

  procedure RaveRegister;

implementation

{$R *.DFM}

type
  TRaveDataMirrorPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    procedure Edit; override;
    function GetValue: string; override;
  end; { TRaveDataMirrorPropertyEditor }

  procedure RaveRegister;

  begin { RaveRegister }
  {TransOff}
    RegisterRavePropertyEditor(TypeInfo(TRavePersistentList),
     TRaveDataMirrorSection,'DataMirrors',TRaveDataMirrorPropertyEditor);
  {TransOn}
  end;  { RaveRegister }

(*****************************************************************************}
( class TRaveDataMirrorPropertyEditor
(*****************************************************************************)

  function TRaveDataMirrorPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poReadOnly,poEditor];
  end;  { GetOptions }

  function TRaveDataMirrorPropertyEditor.GetValue: string;

  begin { GetValue }
    Result := '(' + Trans('Data Mirrors') + ')';
  end;  { GetValue }

  procedure TRaveDataMirrorPropertyEditor.Edit;

  begin { Edit }
    With TDataMirrorEditor.Create(Application) do try
    { Init dialog contents }
      DataMirrorSection := Instance[0] as TRaveDataMirrorSection;
      DataMirrors := TObject(GetOrdValue(0)) as TRavePersistentList;
      If ShowModal = mrOK then begin
      { Copy from dialog contents }
        DataMirrorSection.DataMirrors := DataMirrors;
        Modified;
      end; { if }
    finally
      Free;
    end; { with }
  end;  { Edit }

(*****************************************************************************}
( class TDataMirrorEditor
(*****************************************************************************)

  procedure TDataMirrorEditor.FormCreate(Sender: TObject);

  begin
    FormTrans(self);
    PrepareToolWin(self);
    FDataMirrors := TRavePersistentList.Create;
  end;

  procedure TDataMirrorEditor.FormDestroy(Sender: TObject);

  begin
    SaveToolWin(self);
    ClearObjectList(FDataMirrors);
    FDataMirrors.Free;
  end;

  procedure TDataMirrorEditor.SetDataMirrors(Value: TRavePersistentList);

  var
    I1: integer;
    DM1: TRaveDataMirror;
    DM2: TRaveDataMirror;

  begin { SetDataMirrors }
    ClearObjectList(FDataMirrors);
    For I1 := 0 to Value.Count - 1 do begin
      DM1 := TRaveDataMirror(Value[I1]);
      DM2 := TRaveDataMirror.Create;
      DM2.DataValue := DM1.DataValue;
      DM2.IsDefault := DM1.IsDefault;
      DM2.SectionMirror := DM1.SectionMirror;
      FDataMirrors.Add(DM2);
    end; { for }
  end;  { SetDataMirrors }

  function TDataMirrorEditor.FindSectionIndex(SectionMirror: TRaveSection): integer;

  var
    I1: integer;

  begin { FindSectionIndex }
    Result := 0;
    For I1 := 0 to SectionCB.Items.Count - 1 do begin
      If SectionCB.Items.Objects[I1] = SectionMirror then begin
        Result := I1;
        Exit;
      end; { if }
    end; { for }
  end;  { FindSectionIndex }

  function TDataMirrorEditor.DataMirrorStr(DataMirror: TRaveDataMirror): string;

  begin { DataMirrorStr }
    If DataMirror.IsDefault then begin
      Result := {Trans-}'* ' + Trans('Default') + {Trans-}' * (' + SectionCB.Items[
       FindSectionIndex(DataMirror.SectionMirror)] + ')'
    end else begin
      Result := DataMirror.DataValue + {Trans-}' (' + SectionCB.Items[
       FindSectionIndex(DataMirror.SectionMirror)] + ')'
    end; { else }
  end;  { DataMirrorStr }

  procedure TDataMirrorEditor.AddItem(DataMirror: TRaveDataMirror);

  begin { AddItem }
    If not DataMirrorLB.Enabled then begin
      DataMirrorLB.Enabled := true;
      DeleteBtn.Enabled := true;
      ValueLabel.Enabled := true;
      ValueEdit.Enabled := true;
      DefaultCB.Enabled := true;
      SectionLabel.Enabled := true;
      SectionCB.Enabled := true;
    end; { if }
    DataMirrorLB.Items.AddObject(DataMirrorStr(DataMirror),DataMirror);
  end;  { AddItem }

  function TDataMirrorEditor.Include(Value: TComponent;
                                     Data: longint): boolean;

    function IsCircular(Mirror: TRaveControl): boolean;

    begin { IsCircular }
      Result := (Mirror = DataMirrorSection);
      If not Result and Assigned(Mirror.Mirror) then begin
        Result := IsCircular(Mirror.Mirror);
      end; { if }
    end;  { IsCircular }

  begin { Include }
    Result := (Value is TRaveSection) and (Value <> DataMirrorSection);
    If Result and Assigned(TRaveSection(Value).Mirror) then begin
      Result := not IsCircular(TRaveControl(Value).Mirror);
    end; { if }
  end;  { Include }

  procedure TDataMirrorEditor.FormShow(Sender: TObject);

  var
    I1: integer;

  begin
    RestoreToolWin(self);

  { Fill up SectionCB }
    GetComponentNames(Include,DataMirrorSection,0,SectionCB.Items);
    SectionCB.Items.InsertObject(0,'(' + Trans('none') + ')',nil);

  { Copy DataMirrors to DataMirrorLB }
    For I1 := 0 to DataMirrors.Count - 1 do begin
      AddItem(TRaveDataMirror(DataMirrors[I1]));
    end; { for }
    If DataMirrorLB.Items.Count > 0 then begin
      DataMirrorLB.ItemIndex := 0;
      DataMirrorLBClick(DataMirrorLB);
    end; { if }
    DataMirrors.Clear;
  end;

  procedure TDataMirrorEditor.OKBtnClick(Sender: TObject);

  var
    I1: integer;

  begin
  { Copy DataMirrorLB to DataMirrors }
    For I1 := 0 to DataMirrorLB.Items.Count - 1 do begin
      DataMirrors.Add(DataMirrorLB.Items.Objects[I1]);
    end; { for }
  end;

  procedure TDataMirrorEditor.CancelBtnClick(Sender: TObject);

  var
    I1: integer;

  begin
  { Delete DataMirror objects in DataMirrorLB }
    For I1 := 0 to DataMirrorLB.Items.Count - 1 do begin
      TRaveDataMirror(DataMirrorLB.Items.Objects[I1]).Free;
    end; { for }
  end;

  procedure TDataMirrorEditor.AddBtnClick(Sender: TObject);

  begin
    DataMirrorLB.Sorted := false;
    AddItem(TRaveDataMirror.Create);
    DataMirrorLB.ItemIndex := DataMirrorLB.Items.Count - 1;
    DataMirrorLBClick(DataMirrorLB);
    ValueEdit.SetFocus;
  end;

  procedure TDataMirrorEditor.DeleteBtnClick(Sender: TObject);

  var
    Idx: integer;

  begin
    Idx := DataMirrorLB.ItemIndex;
    If Idx >= 0 then begin
      SuspendChanging := true;
      TRaveDataMirror(DataMirrorLB.Items.Objects[Idx]).Free;
      DataMirrorLB.Items.Delete(Idx);
      If DataMirrorLB.Items.Count = 0 then begin
        DataMirrorLB.Enabled := false;
        DeleteBtn.Enabled := false;
        ValueLabel.Enabled := false;
        ValueEdit.Text := '';
        ValueEdit.Enabled := false;
        SectionLabel.Enabled := false;
        SectionCB.ItemIndex := -1;
        SectionCB.Enabled := false;
        DefaultCB.Checked := false;
        DefaultCB.Enabled := false;
        SuspendChanging := false;
      end else begin
        If Idx > 0 then begin
          DataMirrorLB.ItemIndex := Idx - 1;
        end else begin
          DataMirrorLB.ItemIndex := 0;
        end; { else }
        SuspendChanging := false;
        DataMirrorLBClick(DataMirrorLB);
      end; { else }
    end; { if }
  end;

  procedure TDataMirrorEditor.DataMirrorLBClick(Sender: TObject);

  begin
    If SuspendChanging then Exit;
    If DataMirrorLB.ItemIndex >= 0 then begin
      With TRaveDataMirror(DataMirrorLB.Items.Objects[DataMirrorLB.ItemIndex]) do begin
        SuspendChanging := true;
        ValueEdit.Text := DataValue;
        DefaultCB.Checked := IsDefault;
        SectionCB.ItemIndex := FindSectionIndex(SectionMirror);
        SuspendChanging := false;
      end; { with }
    end; { if }
  end;

  procedure TDataMirrorEditor.SetNewValue(DM: TRaveDataMirror);

  var
    I1: integer;

  begin { SetNewValue }
    DataMirrorLB.Sorted := false;
    DataMirrorLB.Items[DataMirrorLB.ItemIndex] := DataMirrorStr(DM);
    DataMirrorLB.Sorted := true; { Resort DataMirrorLB }
  { Find new ItemIndex }
    For I1 := 0 to DataMirrorLB.Items.Count - 1 do begin
      If DM = TRaveDataMirror(DataMirrorLB.Items.Objects[I1]) then begin
        If DataMirrorLB.ItemIndex <> I1 then begin
          DataMirrorLB.ItemIndex := I1;
        end; { if }
        Break;
      end; { if }
    end; { for }
  end;  { SetNewValue }

  procedure TDataMirrorEditor.ValueEditChange(Sender: TObject);

  var
    DM1: TRaveDataMirror;

  begin
    If SuspendChanging then Exit;
    DM1 := TObject(DataMirrorLB.Items.Objects[DataMirrorLB.ItemIndex]) as
     TRaveDataMirror;
    DM1.DataValue := ValueEdit.Text;
    SetNewValue(DM1);
  end;

  procedure TDataMirrorEditor.SectionCBChange(Sender: TObject);

  var
    DM1: TRaveDataMirror;

  begin
    If SuspendChanging then Exit;
    DM1 := TObject(DataMirrorLB.Items.Objects[DataMirrorLB.ItemIndex]) as
     TRaveDataMirror;
    DM1.SectionMirror := TObject(SectionCB.Items.Objects[SectionCB.ItemIndex]) as
     TRaveSection;
    SetNewValue(DM1);
  end;

  procedure TDataMirrorEditor.DefaultCBClick(Sender: TObject);

  var
    DM1: TRaveDataMirror;

  begin
    If SuspendChanging then Exit;
    DM1 := TObject(DataMirrorLB.Items.Objects[DataMirrorLB.ItemIndex]) as
     TRaveDataMirror;
    DM1.IsDefault := DefaultCB.Checked;
    SetNewValue(DM1);
  end;

initialization
  RegisterProc('RVCL',RaveRegister);
end.
