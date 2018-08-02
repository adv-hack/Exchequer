unit options;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses {ShareMem,} SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls, ExtCtrls, SBSPanel, GlobVar, GlobType, SBSList;

Var
  { Fields stored heare incase the If button is called from one of the options windows }
  { NOTE: This will only work while only one options dialog can be displayed at a time }
  IfControlDef : FormDefRecType;
  IfControls   : TSBSList;
  DBFileNo     : SmallInt;

Function DbFieldOptions (Var ControlDef : FormDefRecType;
                         Var Controls   : TSBSList) : Boolean; Export;
Function DbTableOptions (Var ControlDef : FormDefRecType;
                         Var ColumnList : TSBSList;
                         Var ControlList : TSBSList) : Boolean; Export;
Function FormulaOptions (Var ControlDef : FormDefRecType;
                         Var Controls   : TSBSList) : Boolean; Export;
procedure DLLIfOptions(IfLabel: TObject);

implementation

Uses BtrvU2, BTSupU1, VarConst, FormFile, DbFldOpt, FormUtil, TableOpt,
     FrmlaOpt, IfOption, DataDict;

{ Executes the If dialog for any drag control - only used by bitmaps }
procedure DLLIfOptions(IfLabel: TObject);
Var
  PrevCur : TCursor;
  NewCap  : ShortString;
begin
  CursorToHourglass (PrevCur);

  { Do the options thing }
  NewCap := '';
  With IfControlDef Do
    Case fdFieldClass Of
      fdcDbfield    : Begin
                        IfDialog (DbField.fdIf, fdControlId, IfControls);
                        NewCap := IfDescr (DbField.fdIf);
                      End;
      fdcTable      : Begin
                        IfDialog (Table.frIf, fdControlId, IfControls);
                        NewCap := IfDescr (Table.frIf);
                      End;
      fdcFieldCol   : Begin
                        IfDialog (FieldCol.fdIf, fdControlId, IfControls);
                        NewCap := IfDescr (FieldCol.fdIf);
                      End;
      fdcFormulaCol : Begin
                        IfDialog (FormulaCol.ffIf, fdControlId, IfControls);
                        NewCap := IfDescr (FormulaCol.ffIf);
                      End;
      fdcFormula    : Begin
                        IfDialog (Formula.ffIf, fdControlId, IfControls);
                        NewCap := IfDescr (Formula.ffIf);
                      End;
    End; { Case }

  If Assigned (IfLabel) Then
    With IfLabel As TLabel Do
      Caption := NewCap;

  RestoreCursor (PrevCur);
end;


Function DbFieldOptions (Var ControlDef : FormDefRecType;
                         Var Controls   : TSBSList) : Boolean;
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);

  IfControlDef := ControlDef;
  IfControls   := Controls;

  Result := False;

  If (ControlDef.fdFieldClass = fdcDbField) Then
    With ControlDef, DbField Do Begin
      { Create options dialog }
      Form_DbFldOpt := TForm_DbFldOpt.Create (Application);
      Try
        FontRecToFont (Form_DbFldOpt.Label_Font.Font, fdFont);
        Form_DbFldOpt.SetShortCode(fdShortCode);
        Form_DbFldOpt.Ccy_Decs.Value := fdDecs;
        Form_DbFldOpt.SetAlign (fdAlign);
        Form_DbFldOpt.BorChk_BlankZero.Checked := fdBlankIfZero;

        Form_DbFldOpt.Label_If.Caption := IfDescr (fdIf);

        CursorForDialog;
        Form_DbFldOpt.ShowModal;
        CursorFromDialog;

        If Form_DbFldOpt.Ok Then Begin
          fdShortCode := Form_DbFldOpt.GetShortCode;
          fdFieldLen := Form_DbFldOpt.GetFieldLen;
          FontToRec (Form_DbFldOpt.Label_Font.Font, fdFont);
          fdDecs := Round(Form_DbFldOpt.Ccy_Decs.Value);
          fdAlign := Form_DbFldOpt.GetAlign;
          fdBlankIfZero := Form_DbFldOpt.BorChk_BlankZero.Checked;
          fdIf := IfControlDef.DbField.fdIf
        End; { If }

        Result := Form_DbFldOpt.Ok;
      Finally
        Form_DbFldOpt.Release;
      End;
    End; { With }

  RestoreCursor (PrevCur);
end;

Function DbTableOptions (Var ControlDef  : FormDefRecType;
                         Var ColumnList  : TSBSList;
                         Var ControlList : TSBSList) : Boolean;
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);

  IfControlDef := ControlDef;
  IfControls   := ControlList;

  Result := False;

  If (ControlDef.fdFieldClass = fdcTable) Then
    With ControlDef Do Begin
      { Create options dialog }
      Form_TableOptions := TForm_TableOptions.Create (Application);
      Try
        Form_TableOptions.TableId := fdControlId;
        Form_TableOptions.SetTable(Table);
        Form_TableOptions.LoadColumns (ColumnList);
        Form_TableOptions.Controls := ControlList;

        Form_TableOptions.Label_If.Caption := IfDescr (Table.frIf);

        CursorForDialog;
        Form_TableOptions.ShowModal;
        CursorFromDialog;

        If Form_TableOptions.Ok Then Begin
          Table := Form_TableOptions.GetTable;
          Form_TableOptions.DownLoadColumns (ColumnList);
          Table.frIf := IfControlDef.Table.frIf;
        End; { If }

        Form_TableOptions.ClearIfList;

        Result := Form_TableOptions.Ok;
      Finally
        Form_TableOptions.Release;
      End;
    End; { With }

  RestoreCursor (PrevCur);
End;

Function FormulaOptions (Var ControlDef : FormDefRecType;
                         Var Controls   : TSBSList) : Boolean;
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);

  IfControlDef := ControlDef;
  IfControls   := Controls;

  Result := False;

  If (ControlDef.fdFieldClass = fdcFormula) Then
    With ControlDef, Formula Do Begin
      { Create options dialog }
      Form_FormulaOptions := TForm_FormulaOptions.Create (Application);
      Try
        FontRecToFont (Form_FormulaOptions.Label_Font.Font, ffFont);
        Form_FormulaOptions.Memo_Formula.Text := ffFormula;
        Form_FormulaOptions.LoadFormFields (Controls, fdControlId);
        Form_FormulaOptions.Ccy_Decs.Value := ffDecs;
        Form_FormulaOptions.SetAlign (ffAlign);
        Form_FormulaOptions.BorChk_BlankZero.Checked := ffBlankIfZero;
        Form_FormulaOptions.Check_Hide.Checked := ffHidden;

        Form_FormulaOptions.Label_If.Caption := IfDescr (Formula.ffIf);

        { Barcode support }
        Form_FormulaOptions.Combo_Type.ItemIndex := Ord(Formula.ffBarCode);
        Form_FormulaOptions.Combo_TypeChange(Application);
        Case Formula.ffBarCode Of
          bcCode39  : Begin
                        Form_FormulaOptions.Chk_Extend.Checked := (Formula.ffBCFlag1 = 1);
                        Form_FormulaOptions.Chk_CheckChar.Checked := (Formula.ffBCFlag2 = 1);
                      End;
          bcCode128 : Begin
                        Form_FormulaOptions.Chk_FNC1.Checked := (Formula.ffBCFlag1 = 1);
                        Form_FormulaOptions.Chk_FNC2.Checked := (Formula.ffBCFlag2 = 1);
                        Form_FormulaOptions.Chk_FNC3.Checked := (Formula.ffBCFlag3 = 1);
                      End;
          bcInter25 : Begin
                        Form_FormulaOptions.Chk_CheckChar.Checked := (Formula.ffBCFlag1 = 1);
                      End;
          bcCodaBar : Begin
                        Form_FormulaOptions.Chk_CheckChar.Checked := (Formula.ffBCFlag1 = 1);
                        If (Formula.ffBCFlag2 In [0..3]) Then
                          Form_FormulaOptions.Combo_Start.ItemIndex := Formula.ffBCFlag2
                        Else
                         Form_FormulaOptions.Combo_Start.ItemIndex := 0;
                        If (Formula.ffBCFlag3 In [0..3]) Then
                          Form_FormulaOptions.Combo_Stop.ItemIndex := Formula.ffBCFlag3
                        Else
                          Form_FormulaOptions.Combo_Stop.ItemIndex := 0;
                      End;
        End; { Case }

        CursorForDialog;
        Form_FormulaOptions.ShowModal;
        CursorFromDialog;

        If Form_FormulaOptions.Ok Then Begin
          FontToRec (Form_FormulaOptions.Label_Font.Font, ffFont);
          ffFormula := Form_FormulaOptions.Memo_Formula.Text;
          ffDecs := Round(Form_FormulaOptions.Ccy_Decs.Value);
          ffAlign := Form_FormulaOptions.GetAlign;
          ffBlankIfZero := Form_FormulaOptions.BorChk_BlankZero.Checked;
          ffIf := IfControlDef.Formula.ffIf;
          ffHidden := Form_FormulaOptions.Check_Hide.Checked;

          { Barcode support }
          If (Form_FormulaOptions.Combo_Type.ItemIndex >= 0) Then
            Formula.ffBarCode := fdBarCodeType(Form_FormulaOptions.Combo_Type.ItemIndex)
          Else
            Formula.ffBarCode := bcNone;
          Case Formula.ffBarCode Of
            bcCode39  : Begin
                          If Form_FormulaOptions.Chk_Extend.Checked Then
                            Formula.ffBCFlag1 := 1
                          Else
                            Formula.ffBCFlag1 := 0;
                          If Form_FormulaOptions.Chk_CheckChar.Checked Then
                            Formula.ffBCFlag2 := 1
                          Else
                            Formula.ffBCFlag2 := 0;
                        End;
            bcCode128 : Begin
                          If Form_FormulaOptions.Chk_FNC1.Checked Then
                            Formula.ffBCFlag1 := 1
                          Else
                            Formula.ffBCFlag1 := 0;
                          If Form_FormulaOptions.Chk_FNC2.Checked Then
                            Formula.ffBCFlag2 := 1
                          Else
                            Formula.ffBCFlag2 := 0;
                          If Form_FormulaOptions.Chk_FNC3.Checked Then
                            Formula.ffBCFlag3 := 1
                          Else
                            Formula.ffBCFlag3 := 0;
                        End;
            bcInter25 : Begin
                          If Form_FormulaOptions.Chk_CheckChar.Checked Then
                            Formula.ffBCFlag1 := 1
                          Else
                            Formula.ffBCFlag1 := 0;
                        End;
            bcCodaBar : Begin
                          If Form_FormulaOptions.Chk_CheckChar.Checked Then
                            Formula.ffBCFlag1 := 1
                          Else
                            Formula.ffBCFlag1 := 0;
                          If (Form_FormulaOptions.Combo_Start.ItemIndex In [0..3]) Then
                            Formula.ffBCFlag2 := Form_FormulaOptions.Combo_Start.ItemIndex
                          Else
                            Formula.ffBCFlag2 := 0;
                          If (Form_FormulaOptions.Combo_Stop.ItemIndex In [0..3]) Then
                            Formula.ffBCFlag3 := Form_FormulaOptions.Combo_Stop.ItemIndex
                          Else
                            Formula.ffBCFlag3 := 0;
                        End;
          End; { Case }
        End; { If }

        Result := Form_FormulaOptions.Ok;
      Finally
        Form_FormulaOptions.Release;
      End;
    End; { With }

  RestoreCursor (PrevCur);
End;


Initialization
  DBFileNo := -1;
end.
