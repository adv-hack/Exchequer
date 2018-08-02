unit tableopt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, ComCtrls, GlobType, SBSList,
  Mask, BorBtns, TablFunc;

type
  TForm_TableOptions = class(TForm)
    PageControl1: TPageControl;
    TabSh_Display: TTabSheet;
    TabSh_Columns: TTabSheet;
    ListVw_Columns: TListView;
    Button_Add: TButton;
    Button_Edit: TButton;
    Button_Delete: TButton;
    Button_MoveUp: TButton;
    Button_MoveDown: TButton;
    FontDialog1: TFontDialog;
    Image_Table: TImage;
    Button_Font: TButton;
    ColorDialog1: TColorDialog;
    Check_General: TBorCheck;
    List_Elements: TListBox;
    Label87: Label8;
    Label_Width: Label8;
    Label_Colour: Label8;
    Panel_Colour: TPanel;
    Combo_Width: TSBSComboBox;
    Button_Save: TButton;
    Button_Cancel: TButton;
    Button_Save2: TButton;
    Button_Cancel2: TButton;
    TabSh_Misc: TTabSheet;
    SBSPanel3: TSBSPanel;
    Label_If: Label8;
    Button_If: TButton;
    Button_Save3: TButton;
    Button_Cancel3: TButton;
    lblColContents: Label8;
    btnColPrintIf: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_AddClick(Sender: TObject);
    Procedure AddField;
    Procedure AddFormula;
    procedure Button_EditClick(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
    procedure Button_MoveUpClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    Procedure PaintTable(Sender: TObject);
    procedure Check_Left_TblClick(Sender: TObject);
    procedure Panel_ColourDblClick(Sender: TObject);
    procedure Combo_WidthChange(Sender: TObject);
    procedure List_ElementsClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ListVw_ColumnsClick(Sender: TObject);
    procedure Button_FontClick(Sender: TObject);
    procedure Button_IfClick(Sender: TObject);
    procedure ListVw_ColumnsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListVw_ColumnsEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure btnColPrintIfClick(Sender: TObject);
  private
    { Private declarations }
    TableObj : TableObject;
    Function  EditField (Var ListObj : TFormDefListObjType; Const Edit : Boolean) : Boolean;
    Function  EditFormula (Var   ListObj : TFormDefListObjType;
                           Const Edit    : Boolean) : Boolean;
    Procedure SetListItem (ListObj  : TFormDefListObjType; ListItem : TListItem);
    Procedure SetColControlId (Var   ColObj : TFormDefListObjType;
                               Const Prefix : String10);
  public
    { Public declarations }
    Controls : TSBSList;
    Ok       : Boolean;
    TableId  : String10;
    Procedure SetTable (Const Table : fdTableRecType);
    Function GetTable : fdTableRecType;
    Procedure LoadColumns (Var ColumnList : TSBSList);
    Procedure DownLoadColumns (Var ColumnList : TSBSList);
    procedure ClearIfList;
  end;

var
  Form_TableOptions: TForm_TableOptions;

implementation

{$R *.DFM}

Uses EtStrU, FormUtil, VarRPosU, dbFldCol, coltype, frmlacol,
     Options, IfOption, DataDict, SelFld2;

procedure TForm_TableOptions.FormCreate(Sender: TObject);
begin
  Ok := False;

  TableObj := TableObject.Create;
  PageControl1.ActivePage := TabSh_Columns;
end;

procedure TForm_TableOptions.FormDestroy(Sender: TObject);
Var
  ListObj : TFormDefListObjType;
begin
  { Free objects in list }
  While (ListVw_Columns.Items.Count > 0) Do Begin
    { Get copy of column object, delete from viewlist and add to sbslist }
    ListObj := TFormDefListObjType(ListVw_Columns.Items.Item[0].Data);

    { not necessary cos of cleariflist }
    {If (IfControls.IndexOf (ListVw_Columns.Items.Item[0].Data) >= 0) Then Begin
      IfControls.Delete (IfControls.IndexOf (ListVw_Columns.Items.Item[0].Data));
    End; { If }

    ListVw_Columns.Items.Delete(0);
    ListObj.Free;
  End; { While }

  TableObj.Free;
end;

procedure TForm_TableOptions.ClearIfList;
Var
  I : SmallInt;
Begin
  I := 0;

  If (ListVw_Columns.Items.Count > 0) Then
    Repeat
      If (IfControls.IndexOf (ListVw_Columns.Items.Item[I].Data) >= 0) Then
        IfControls.Delete(IfControls.IndexOf (ListVw_Columns.Items.Item[I].Data))
      Else
        Inc (I);
    Until (I > (ListVw_Columns.Items.Count - 1));
End;

procedure TForm_TableOptions.Button_SaveClick(Sender: TObject);
begin
  If (ListVw_Columns.Items.Count > 0) Then Begin
    Ok := True;
    Close;
  End { If }
  Else Begin
    MessageDlg('At least one column must be added to the table.',
               mtInformation,
               [mbOk],
               0);
    PageControl1.ActivePage := TabSh_Columns;
    If Button_Add.CanFocus Then Button_Add.SetFocus;
    Button_AddClick(Sender);
  End; { If }
end;

procedure TForm_TableOptions.Button_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

Procedure TForm_TableOptions.SetTable (Const Table : fdTableRecType);
begin
  TableObj.SetTableRec(Table);
  TableObj.AddElementsToList (List_Elements);
  List_ElementsClick(Self);

  PaintTable (Self);
end;

Function TForm_TableOptions.GetTable : fdTableRecType;
begin
  Result := TableObj.GetTableRec;
end;

Procedure TForm_TableOptions.LoadColumns (Var ColumnList : TSBSList);
Var
  ListObj : TFormDefListObjType;
  I       : Integer;
begin
  If (ColumnList.Count > 0) Then
    For I := 0 To (ColumnList.Count - 1) Do Begin
      { Get Object and add to the viewlist }
      ListObj := TFormDefListObjType.Create;
      ListObj.FormDef := TFormDefListObjType(ColumnList.Items[I]).FormDef;
      SetListItem (ListObj, ListVw_Columns.Items.Add);
    End; { For } 
end;

Procedure TForm_TableOptions.DownLoadColumns (Var ColumnList : TSBSList);
Var
  ListObj : TFormDefListObjType;
begin
  { Empty existing columns from list }
  While (ColumnList.Count > 0) Do Begin
    { Get copy of column object, remove from list, and free memory }
    ListObj := TFormDefListObjType(ColumnList.Items[0]);
    ColumnList.Delete (0);
    ListObj.Free;
  End; { While }

  { Add current columns into list }
  While (ListVw_Columns.Items.Count > 0) Do Begin
    { Get copy of column object, delete from viewlist and add to sbslist }
    ListObj := TFormDefListObjType.Create;
    ListObj.FormDef := TFormDefListObjType(ListVw_Columns.Items.Item[0].Data).FormDef;

    If (IfControls.IndexOf (ListVw_Columns.Items.Item[0].Data) >= 0) Then
      IfControls.Delete(IfControls.IndexOf (ListVw_Columns.Items.Item[0].Data));

    ListVw_Columns.Items.Delete(0);
    ColumnList.Add (ListObj);
  End; { While }
End;

procedure TForm_TableOptions.Button_AddClick(Sender: TObject);
Var
  PrevCur : TCursor;
  FldType : Byte;
begin
  CursorToHourglass (PrevCur);

  Form_FieldType := TForm_FieldType.Create(Self);
  Try
    CursorForDialog;
    Form_FieldType.ShowModal;
    CursorFromDialog;

    FldType := Form_FieldType.Status;
  Finally
    Form_FieldType.Release;
  End;

  Case FldType Of
    { Cancelled }
    0 : ;

    { Database Field }
    1 : AddField;

    { Formula }
    2 : AddFormula;
  End; { If }

  RestoreCursor (PrevCur);
end;

Procedure TForm_TableOptions.SetColControlId (Var   ColObj : TFormDefListObjType;
                                              Const Prefix : String10);
Var
  ListObj  : TFormDefListObjType;
  CId      : String10;
  Found    : Boolean;
  IdNo, I  : Integer;
begin
  IdNo := 0;
  Repeat
    Inc(IdNo);
    CId := Prefix + IntToStr(IdNo);

    { Run throught the other controls to check its unique }
    Found := (ListVw_Columns.Items.Count > 0);
    If Found Then Begin
      Found := False;

      For I := 0 To (ListVw_Columns.Items.Count - 1) Do
        If (Not Found) Then
          Found := (TFormDefListObjType(ListVw_Columns.Items.Item[I].Data).FormDef.fdControlId = CId);
    End; { If }
  Until (Not Found);

  ColObj.FormDef.fdControlId := CId;
end;

Procedure TForm_TableOptions.AddField;
Var
  ListObj, ListObj2 : TFormDefListObjType;
begin
  ListObj := TFormDefListObjType.Create;
  FillChar (ListObj.FormDef, SizeOf (ListObj.FormDef), #0);
  ListObj.FormDef.fdRepClass   := fdrColumn;
  ListObj.FormDef.fdFieldOrder := 0;               { Creation Order of controls }
  ListObj.FormDef.fdFieldClass := fdcFieldCol;
  SetColControlId (ListObj, 'FieldCol');
  ListObj.FormDef.FieldCol.fdTitle     := '';
  ListObj.FormDef.FieldCol.fdWidth     := 40;
  ListObj.FormDef.FieldCol.fdShortCode := '';
  ListObj.FormDef.FieldCol.fdFieldLen  := 0;
  ListObj.FormDef.FieldCol.fdAlign     := taLeftJustify;
  ListObj.FormDef.FieldCol.fdDecs      := 2;
  ListObj.FormDef.FieldCol.fdWantSep   := True;

  { Set font }
  If (ListVw_Columns.Items.Count > 0) Then Begin
    { Default to first columns font }
    ListObj2 := TFormDefListObjType(ListVw_Columns.Items.Item[0].Data);
    With ListObj2.FormDef Do
      Case fdFieldClass Of
        fdcFieldCol   : ListObj.FormDef.FieldCol.fdColFont := FieldCol.fdColFont;
        fdcFormulaCol : ListObj.FormDef.FieldCol.fdColFont := FormulaCol.ffColFont;
      Else
        FontToRec (SystemInfo.DefaultFont, ListObj.FormDef.FieldCol.fdColFont);
      End; { Case }
  End { If }
  Else
    { default to forms default font }
    FontToRec (SystemInfo.DefaultFont, ListObj.FormDef.FieldCol.fdColFont);

  If EditField (ListObj, False) Then Begin
    SetListItem (ListObj, ListVw_Columns.Items.Add);

    { add into 'if' control list }
    IfControls.Add (ListObj);
  End; { If }
end;

Procedure TForm_TableOptions.AddFormula;
Var
  ListObj, ListObj2 : TFormDefListObjType;
begin
  ListObj := TFormDefListObjType.Create;
  FillChar (ListObj.FormDef, SizeOf (ListObj.FormDef), #0);
  ListObj.FormDef.fdRepClass   := fdrColumn;
  ListObj.FormDef.fdFieldOrder := 0;               { Creation Order of controls }
  ListObj.FormDef.fdFieldClass := fdcFormulaCol;
  SetColControlId (ListObj, 'FormCol');
  ListObj.FormDef.FormulaCol.ffTitle   := '';
  ListObj.FormDef.FormulaCol.ffWidth   := 40;
  ListObj.FormDef.FormulaCol.ffAlign   := taLeftJustify;
  ListObj.FormDef.FormulaCol.ffWantSep := True;
  ListObj.FormDef.FormulaCol.ffFormula := '';
  ListObj.FormDef.FormulaCol.ffDecs    := 2;

  { Set font }
  If (ListVw_Columns.Items.Count > 0) Then Begin
    { Default to first columns font }
    ListObj2 := TFormDefListObjType(ListVw_Columns.Items.Item[0].Data);
    With ListObj2.FormDef Do
      Case fdFieldClass Of
        fdcFieldCol   : ListObj.FormDef.FormulaCol.ffColFont := FieldCol.fdColFont;
        fdcFormulaCol : ListObj.FormDef.FormulaCol.ffColFont := FormulaCol.ffColFont;
      Else
        FontToRec (SystemInfo.DefaultFont, ListObj.FormDef.FormulaCol.ffColFont);
      End; { Case }
  End { If }
  Else
    { default to forms default font }
    FontToRec (SystemInfo.DefaultFont, ListObj.FormDef.FormulaCol.ffColFont);

  If EditFormula (ListObj, False) Then Begin
    SetListItem (ListObj, ListVw_Columns.Items.Add);

    { add into 'if' control list }
    IfControls.Add (ListObj);
  End; { If }
end;

Function TForm_TableOptions.EditFormula (Var   ListObj : TFormDefListObjType;
                                         Const Edit    : Boolean) : Boolean;
Var
  TabCont         : TFormDefListObjType;
  PrevCur         : TCursor;
  ErrCode, Idx, I : Integer;
  TmpFDef         : FormDefRecType;
begin
  CursorToHourglass (PrevCur);

  Result := False;

  Form_AddFormulaCol := TForm_AddFormulaCol.Create(Self);
  Try
    Form_AddFormulaCol.SetForm (Edit);

    With ListObj.FormDef, FormulaCol Do Begin
      { Initialise to current column values }
      Form_AddFormulaCol.Text_Title.Text := ffTitle;
      Form_AddFormulaCol.CcyVal_Width.Value := ffWidth;
      Form_AddFormulaCol.SetAlign (ffAlign);
      Form_AddFormulaCol.Check_ColSep.Checked := ffWantSep;
      Form_AddFormulaCol.Ccy_Decs.Value := ffDecs;
      Form_AddFormulaCol.Check_HideCol.Checked := ffHidden;
      Form_AddFormulaCol.BorChk_BlankZero.Checked := ffBlankIfZero;

      FontRecToFont (Form_AddFormulaCol.Label_Font.Font, ffColFont);
      Form_AddFormulaCol.Memo_Formula.Text := ffFormula;

      Form_AddFormulaCol.Label_If.Caption := IfDescr (ffIf);
    End; { If }

    { Add the controls - excludes any table controls }
    Form_AddFormulaCol.LoadFormFields (Controls);
    Form_AddFormulaCol.SetTableObj (TableId);

    { Walk Through the columns list adding the controls }
    Form_AddFormulaCol.AddSectionTitle(0, TableId);
    For Idx := 1 To 3 Do Begin
      Form_AddFormulaCol.AddSectionTitle(Idx, TableId);

      If (ListVw_Columns.Items.Count > 0) Then
        For I := 0 To (ListVw_Columns.Items.Count - 1) Do Begin
          TabCont := ListVw_Columns.Items.Item[I].Data;

          If (ListObj.FormDef.fdControlId <> TabCont.FormDef.fdControlId) Then
            Form_AddFormulaCol.AddTableControl (Idx, TabCont);
        End; { For }
    End; { For }

    { Barcode support }
    With ListObj.FormDef Do Begin
      Form_AddFormulaCol.Combo_Type.ItemIndex := Ord(FormulaCol.ffBarCode);
      Form_AddFormulaCol.Combo_TypeChange(Application);
      Case FormulaCol.ffBarCode Of
        bcCode39  : Begin
                      Form_AddFormulaCol.Chk_Extend.Checked := (FormulaCol.ffBCFlag1 = 1);
                      Form_AddFormulaCol.Chk_CheckChar.Checked := (FormulaCol.ffBCFlag2 = 1);
                    End;
        bcCode128 : Begin
                      Form_AddFormulaCol.Chk_FNC1.Checked := (FormulaCol.ffBCFlag1 = 1);
                      Form_AddFormulaCol.Chk_FNC2.Checked := (FormulaCol.ffBCFlag2 = 1);
                      Form_AddFormulaCol.Chk_FNC3.Checked := (FormulaCol.ffBCFlag3 = 1);
                    End;
        bcInter25 : Begin
                      Form_AddFormulaCol.Chk_CheckChar.Checked := (FormulaCol.ffBCFlag1 = 1);
                    End;
        bcCodaBar : Begin
                      Form_AddFormulaCol.Chk_CheckChar.Checked := (FormulaCol.ffBCFlag1 = 1);
                      If (FormulaCol.ffBCFlag2 In [0..3]) Then
                        Form_AddFormulaCol.Combo_Start.ItemIndex := FormulaCol.ffBCFlag2
                      Else
                       Form_AddFormulaCol.Combo_Start.ItemIndex := 0;
                      If (FormulaCol.ffBCFlag3 In [0..3]) Then
                        Form_AddFormulaCol.Combo_Stop.ItemIndex := FormulaCol.ffBCFlag3
                      Else
                        Form_AddFormulaCol.Combo_Stop.ItemIndex := 0;
                    End;
      End; { Case }
    End; { With }

    TmpFDef := IfControlDef;
    IfControlDef := ListObj.FormDef;
    CursorForDialog;
    Form_AddFormulaCol.ShowModal;
    CursorFromDialog;
    ListObj.FormDef := IfControlDef;
    IfControlDef := TmpFDef;

    If Form_AddFormulaCol.Ok Then Begin
      With ListObj, FormDef, FormulaCol Do Begin
        fdRepClass   := fdrColumn;
        fdFieldOrder := 0;               { Creation Order of controls }
        fdFieldClass := fdcFormulaCol;

        ffTitle := Form_AddFormulaCol.Text_Title.Text;
        ffWidth := Round (Form_AddFormulaCol.CcyVal_Width.Value);
        ffAlign     := Form_AddFormulaCol.GetAlign;
        ffWantSep   := Form_AddFormulaCol.Check_ColSep.Checked;
        FontToRec (Form_AddFormulaCol.Label_Font.Font, ffColFont);
        ffFormula := Form_AddFormulaCol.Memo_Formula.Text;
        ffDecs := Round(Form_AddFormulaCol.Ccy_Decs.Value);
        ffHidden := Form_AddFormulaCol.Check_HideCol.Checked;
        ffBlankIfZero := Form_AddFormulaCol.BorChk_BlankZero.Checked;

        { Barcode support }
        If (Form_AddFormulaCol.Combo_Type.ItemIndex >= 0) Then
          ffBarCode := fdBarCodeType(Form_AddFormulaCol.Combo_Type.ItemIndex)
        Else
          ffBarCode := bcNone;
        Case ffBarCode Of
          bcCode39  : Begin
                        If Form_AddFormulaCol.Chk_Extend.Checked Then
                          ffBCFlag1 := 1
                        Else
                          ffBCFlag1 := 0;
                        If Form_AddFormulaCol.Chk_CheckChar.Checked Then
                          ffBCFlag2 := 1
                        Else
                          ffBCFlag2 := 0;
                      End;
          bcCode128 : Begin
                        If Form_AddFormulaCol.Chk_FNC1.Checked Then
                          ffBCFlag1 := 1
                        Else
                          ffBCFlag1 := 0;
                        If Form_AddFormulaCol.Chk_FNC2.Checked Then
                          ffBCFlag2 := 1
                        Else
                          ffBCFlag2 := 0;
                        If Form_AddFormulaCol.Chk_FNC3.Checked Then
                          ffBCFlag3 := 1
                        Else
                          ffBCFlag3 := 0;
                      End;
          bcInter25 : Begin
                        If Form_AddFormulaCol.Chk_CheckChar.Checked Then
                          ffBCFlag1 := 1
                        Else
                          ffBCFlag1 := 0;
                      End;
          bcCodaBar : Begin
                        If Form_AddFormulaCol.Chk_CheckChar.Checked Then
                          ffBCFlag1 := 1
                        Else
                          ffBCFlag1 := 0;
                        If (Form_AddFormulaCol.Combo_Start.ItemIndex In [0..3]) Then
                          ffBCFlag2 := Form_AddFormulaCol.Combo_Start.ItemIndex
                        Else
                          ffBCFlag2 := 0;
                        If (Form_AddFormulaCol.Combo_Stop.ItemIndex In [0..3]) Then
                          ffBCFlag3 := Form_AddFormulaCol.Combo_Stop.ItemIndex
                        Else
                          ffBCFlag3 := 0;
                      End;
        End; { Case }
      End; { With }
    End; { If }

    Result := Form_AddFormulaCol.Ok;
  Finally
    Form_AddFormulaCol.Release;
  End;

  RestoreCursor (PrevCur);
end;

Function TForm_TableOptions.EditField (Var   ListObj : TFormDefListObjType;
                                       Const Edit    : Boolean) : Boolean;
Var
  PrevCur : TCursor;
  ErrCode : Integer;
  TmpFDef : FormDefRecType;
begin
  CursorToHourglass (PrevCur);

  Result := False;

  Form_AddFieldCol := TForm_AddFieldCol.Create(Self);
  Try
    Form_AddFieldCol.SetForm (Edit);

    { display fields }
    With ListObj.FormDef.FieldCol Do Begin
      { Initialise to current column values }
      Form_AddFieldCol.Text_Title.Text := fdTitle;
      Form_AddFieldCol.SetShortCode (fdShortCode);
      Form_AddFieldCol.SetAlign (fdAlign);
      Form_AddFieldCol.Check_ColSep.Checked := fdWantSep;
      Form_AddFieldCol.Check_HideCol.Checked := fdHidden;
      Form_AddFieldCol.CcyVal_Width.Value := fdWidth;
      Form_AddFieldCol.Ccy_Decs.Value := fdDecs;
      Form_AddFieldCol.BorChk_BlankZero.Checked := fdBlankIfZero;

      FontRecToFont (Form_AddFieldCol.Label_Font.Font, fdColFont);

      Form_AddFieldCol.Label_If.Caption := IfDescr (fdIf);
    End; { If }

    TmpFDef := IfControlDef;
    IfControlDef := ListObj.FormDef;
    CursorForDialog;
    Form_AddFieldCol.ShowModal;
    CursorFromDialog;
    ListObj.FormDef := IfControlDef;
    IfControlDef := TmpFDef;

    If Form_AddFieldCol.Ok Then Begin
      { cant re-init cos it'll overwrite the control id }
      With ListObj, FormDef, FieldCol Do Begin
        fdRepClass   := fdrColumn;
        fdFieldOrder := 0;               { Creation Order of controls }
        fdFieldClass := fdcFieldCol;

        fdTitle     := Form_AddFieldCol.Text_Title.Text;
        fdWidth     := Round(Form_AddFieldCol.CcyVal_Width.Value);
        fdShortCode := Form_AddFieldCol.GetShortCode;
        fdFieldLen  := Form_AddFieldCol.GetFieldLen;
        fdAlign     := Form_AddFieldCol.GetAlign;
        fdWantSep   := Form_AddFieldCol.Check_ColSep.Checked;
        fdHidden    := Form_AddFieldCol.Check_HideCol.Checked;
        fdDecs      := Round(Form_AddFieldCol.Ccy_Decs.Value);
        fdBlankIfZero := Form_AddFieldCol.BorChk_BlankZero.Checked;

        FontToRec (Form_AddFieldCol.Label_Font.Font, fdColFont);
      End; { With }
    End;

    Result := Form_AddFieldCol.Ok;
  Finally
    Form_AddFieldCol.Release;
  End;

  RestoreCursor (PrevCur);
end;

procedure TForm_TableOptions.Button_EditClick(Sender: TObject);
Var
  ListObj : TFormDefListObjType;
  Upd     : Boolean;
begin
  { Get object from list }
  If Not Assigned (ListVw_Columns.Selected) Then Begin
    { This causes the line to be selected if they click in a column other than the first }
    ListVw_ColumnsClick(Sender);
  End; { If }

  If Assigned (ListVw_Columns.Selected) Then Begin
    ListObj := ListVw_Columns.Selected.Data;

    Upd := False;
    Case ListObj.FormDef.fdFieldClass Of
      fdcFieldCol   : Begin
                        Upd := EditField (ListObj, True);
                      End;
      fdcFormulaCol : Begin
                        Upd := EditFormula (ListObj, True);
                      End;
    End; { Case }

    If Upd Then Begin
      SetListItem (ListObj, ListVw_Columns.Selected);

      { update ifoptions list }
      If (IfControls.IndexOf(ListObj) > -1) Then
        IfControls.Items[IfControls.IndexOf(ListObj)] := ListObj;
    End; { If }
  End; { If }
end;

Procedure TForm_TableOptions.SetListItem (ListObj  : TFormDefListObjType;
                                          ListItem : TListItem);
begin
  With ListObj.FormDef, ListItem Do Begin
    Data := ListObj;

    Case fdFieldClass Of
      fdcFieldCol   : With FieldCol Do Begin
                        Caption := fdTitle;
                        SubItems.Clear;
                        SubItems.Add('Field');
                        SubItems.Add(IntToStr(fdWidth));
                        If fdHidden Then SubItems.Add('H') Else SubItems.Add('');
                        SubItems.Add(Trim(fdIf.fiIf));
                      End; { With }
      fdcFormulaCol : With FormulaCol Do Begin
                        Caption := ffTitle;
                        SubItems.Clear;
                        SubItems.Add('Formula');
                        SubItems.Add(IntToStr(ffWidth));
                        If ffHidden Then SubItems.Add('H') Else SubItems.Add('');
                        SubItems.Add(Trim(ffIf.fiIf));
                      End; { With }
    End; { Case }
  End; { With }
end;

procedure TForm_TableOptions.Button_DeleteClick(Sender: TObject);
Var
  ListObj : TFormDefListObjType;
begin
  { Get object from list }
  If Assigned (ListVw_Columns.Selected) Then Begin
    { Delete from list and ifoptions list }
    ListObj := ListVw_Columns.Selected.Data;
    If (IfControls.IndexOf(ListObj) > -1) Then IfControls.Delete (IfControls.IndexOf(ListObj));
    ListObj.Free;
    ListVw_Columns.Selected.Delete;
  End; { If }
end;

procedure TForm_TableOptions.Button_MoveUpClick(Sender: TObject);
Var
  ListObj1, ListObj2                   : TFormDefListObjType;
  TopIndex, BotIndex, Index, MoveIndex : Integer;
begin
  { Get object from list }
  If Assigned (ListVw_Columns.Selected) Then Begin
    Index := ListVw_Columns.Items.IndexOf (ListVw_Columns.Selected);

    TopIndex := -1;
    BotIndex := -1;
    If (Sender = Button_MoveUp) Then Begin
      { Move current column up 1 }
      If (Index > 0) Then Begin
        TopIndex  := Index - 1;
        BotIndex  := Index;
        MoveIndex := TopIndex;
      End { If }
    End { If }
    Else
      { Move Current column down 1 }
      If (Index < (ListVw_Columns.Items.Count - 1)) Then Begin
        TopIndex := Index;
        BotIndex := Index + 1;
        MoveIndex := BotIndex;
      End; { If }

    If (TopIndex >= 0) And (BotIndex >= 0) Then Begin
      With ListVw_Columns.Items Do Begin
        { Take copy of current }
        ListObj1 := Item[TopIndex].Data;
        ListObj2 := Item[BotIndex].Data;

        SetListItem (ListObj2, Item[TopIndex]);
        SetListItem (ListObj1, Item[BotIndex]);
      End; { With }

      { reposition on original row (now moved) }
      ListVw_Columns.Selected := ListVw_Columns.Items.Item[MoveIndex];
      ListVw_Columns.ItemFocused := ListVw_Columns.Items.Item[MoveIndex];
    End; { If }
  End; { If }
end;

Procedure TForm_TableOptions.PaintTable(Sender: TObject);
Var
  tWidth, ColLeft, TmpVar, I,
  tLeft, tTop, tRight, tBottom, RowsTop, HeaderHeight : Integer;
  ColWidths                                           : Array [1..5] Of Integer;
  ColAlign                                            : Array [1..5] Of TAlignment;

  Function FontHeight : Integer;
  var
    TheRect: TRect;
  begin { FontHeight }
    TheRect := Rect (1, 1, 2, 2);
    DrawText (Image_Table.Canvas.Handle, 'M', 1, TheRect, (DT_CALCRECT Or DT_SINGLELINE));
    Result := (TheRect.Bottom - TheRect.Top);
  End;  { FontHeight }

  Procedure SetBrush (Const BrushColor : TColor;Const BrushStyle : TBrushStyle);
  begin
    With Image_Table.Canvas Do Begin
      Brush.Color := BrushColor;
      Brush.Style := BrushStyle;
    End; { With }
  end;

  Procedure SetCanvasPen (Const PenWidth : Integer; Const PenColor : TColor);
  begin
    With Image_Table.Canvas Do Begin
      Pen.Width := PenWidth;
      Pen.Color := PenColor;
      Pen.Mode  := pmCopy;
      Pen.Style := psSolid;
    End; { With }
  end;

  Procedure DoCols;
  Var
    TheRect  : TRect;
    Flags    : Word;
    I        : Integer;
    ColTitle : String;
  begin
    For I := Low (ColWidths) To High (ColWidths) Do Begin
      ColTitle := 'Col' + IntToStr (I);

      TheRect := Rect (ColLeft + 2,
                       tTop + 3,
                       (ColLeft + ColWidths[I] - 2),
                       (tTop + HeaderHeight - 2));

      { Calc Flags }
      Flags := DT_VCENTER Or DT_SINGLELINE;
      Case ColAlign[I] Of
        taLeftJustify  : Flags := Flags Or DT_LEFT;
        taRightJustify : Flags := Flags Or DT_RIGHT;
        taCenter       : Flags := Flags Or DT_CENTER;
      Else
        Flags := Flags Or DT_LEFT;
      End; { Case }
      {DrawText (Image_Table.Canvas.Handle, PCHAR(ColTitle), Length (ColTitle), TheRect, Flags);}
      CanvasDrawText (Image_Table.Canvas, ColTitle, TheRect, Flags);

      ColLeft := ColLeft + ColWidths[I];
    End; { For }
  end;


  Procedure PrintRows;
  Var
    TheRect : TRect;
    Flags   : Word;
    Row, RowTop  : Integer;
    Finito  : Boolean;
    Caption : String;
  begin
    Row := 0;
    RowTop := RowsTop;
    Finito := False;
    While ((RowTop + 3) < tBottom) And (Not Finito) Do Begin
      Inc (Row);
      Caption := 'Row' + IntToStr (Row);

      TheRect := Rect (ColLeft + 2,
                       RowTop + 1,
                       (ColLeft + ColWidths[1] - 2),
                       (RowTop + FontHeight + 2));

      If (TheRect.Bottom < tBottom) Then Begin
        { Calc Flags }
        Flags := DT_VCENTER Or DT_SINGLELINE;
        Case ColAlign[1] Of
          taLeftJustify  : Flags := Flags Or DT_LEFT;
          taRightJustify : Flags := Flags Or DT_RIGHT;
          taCenter       : Flags := Flags Or DT_CENTER;
        Else
          Flags := Flags Or DT_LEFT;
        End; { Case }

        {DrawText (Image_Table.Canvas.Handle, PCHAR(Caption), Length (Caption), TheRect, Flags);}
        CanvasDrawText (Image_Table.Canvas, Caption, TheRect, Flags);

        RowTop := RowTop + (TheRect.Bottom - TheRect.Top);

        {If (Row In [3..5]) Then Begin}
          { Draw row separating line }
          TableObj.DrawLine (Image_Table.Canvas, Tbl_RowSepLine, tLeft + 1, RowTop, tRight - 1, RowTop);
          RowTop := RowTop + TableObj.PenWidth[Tbl_RowSepLine];
        {End; { If }
      End { If }
      Else
        Finito := True;
    End; { While }
  end;

begin
  With Image_Table.Canvas, TableObj Do Begin
    tLeft   := Trunc(Image_Table.Width * 0.1);
    tTop    := Trunc(Image_Table.Height * 0.1);
    tBottom := Trunc(Image_Table.Height * 0.9);
    tRight  := Trunc(Image_Table.Width * 0.9);
    tWidth  := tRight - tLeft;

    ColWidths[1] := Trunc (tWidth * 0.15);
    ColWidths[2] := Trunc (tWidth * 0.25);
    ColWidths[3] := Trunc (tWidth * 0.20);
    ColWidths[4] := Trunc (tWidth * 0.10);
    ColWidths[5] := tWidth - ColWidths[1] - ColWidths[2] - ColWidths[3] - ColWidths[4];
    ColAlign[1] := taLeftJustify;
    ColAlign[2] := taCenter;
    ColAlign[3] := taRightJustify;
    ColAlign[4] := taLeftJustify;
    ColAlign[5] := taRightJustify;

    { Fill Background }
    SetCanvasPen (1, clBlack);
    SetBrush (clWhite, bsSolid);
    Rectangle (Image_Table.ClientRect.Left,
               Image_Table.ClientRect.Top,
               Image_Table.ClientRect.Right,
               Image_Table.ClientRect.Bottom);

    SetCanvasPen (1, clBtnFace);
    SetBrush (clBtnFace, bsClear);
    FontRecToFont (Image_Table.Canvas.Font, Font(Hdr));
    HeaderHeight := FontHeight(Image_Table.Canvas, Hdr, False) + 4;

    RowsTop := tTop;
    If Enabled[Hdr] Then Begin
      RowsTop := RowsTop + HeaderHeight;

      TmpVar := tLeft;
      For I := Low(ColWidthS) To High(ColWidths) Do Begin
        TmpVar := TmpVar + ColWidths[I];
        DrawLine (Image_Table.Canvas, Hdr_ColSepLine, TmpVar, tTop, TmpVar, RowsTop)
      End; { For }

      DrawLine (Image_Table.Canvas, Hdr_LeftLine,   tLeft,  tTop, tLeft,  RowsTop);
      DrawLine (Image_Table.Canvas, Hdr_RightLine,  tRight, tTop, tRight, RowsTop);
      DrawLine (Image_Table.Canvas, Hdr_TopLine,    tLeft,  tTop, tRight, tTop);
    End; { If }

    { Draw Columns separators }
    TmpVar := tLeft;
    For I := Low(ColWidthS) To High(ColWidths) Do Begin
      TmpVar := TmpVar + ColWidths[I];
      DrawLine (Image_Table.Canvas, Tbl_ColSepLine, TmpVar, RowsTop, TmpVar, tBottom);
    End; { For }

    { Draw row separators }
    ColLeft := tLeft;
    PrintRows;

    DrawLine (Image_Table.Canvas, Tbl_LeftLine,  tLeft,  RowsTop, tLeft,  tBottom);
    DrawLine (Image_Table.Canvas, Tbl_RightLine, tRight, RowsTop, tRight, tBottom);
    DrawLine (Image_Table.Canvas, Tbl_BottomLine,tLeft,  tBottom, tRight, tBottom);
    DrawLine (Image_Table.Canvas, Tbl_TopLine,   tLeft,  RowsTop, tRight, RowsTop);

    If Enabled[Hdr] Then Begin
      ColLeft := tLeft;
      DoCols;
    End; { If }
  End; { With }
end;

procedure TForm_TableOptions.Check_Left_TblClick(Sender: TObject);
begin
  TableObj.Enabled[ElementTypes(List_Elements.ItemIndex)] := Check_General.Checked;

  PaintTable(Sender);
end;

procedure TForm_TableOptions.Panel_ColourDblClick(Sender: TObject);
begin
  ColorDialog1.Color := TPanel(Sender).Color;
  ColorDialog1.Execute;
  TPanel(Sender).Color := ColorDialog1.Color;

  TableObj.PenColour[ElementTypes(List_Elements.ItemIndex)] := ColorDialog1.Color;

  PaintTable(Sender);
end;

procedure TForm_TableOptions.Combo_WidthChange(Sender: TObject);
begin
  TableObj.PenWidth [ElementTypes(List_Elements.ItemIndex)] := Combo_Width.ItemIndex + 1;

  PaintTable(Sender);
end;

procedure TForm_TableOptions.List_ElementsClick(Sender: TObject);
Var
  ElemRec : ElementRecType;
begin
  If (List_Elements.ItemIndex >= 0) Then Begin
    { load elements }
    ElemRec := TableObj.GetElementRec (ElementTypes(List_Elements.ItemIndex));

    With ElemRec Do Begin
      Check_General.Visible := elFields[1];
      Label_Width.Visible   := elFields[2];
      Combo_Width.Visible   := elFields[2];
      Label_Colour.Visible  := elFields[3];
      Panel_Colour.Visible  := elFields[3];
      Button_Font.Visible   := elFields[4];
      If elFields[1] Then Check_General.Checked := elEnabled;
      If elFields[2] Then Combo_Width.ItemIndex := elLineWidth - 1 ;
      If elFields[3] Then Panel_Colour.Color := elColour;
    End; { With }
  End; { If }
end;

procedure TForm_TableOptions.PageControl1Change(Sender: TObject);
begin
  { Reset Save and Cancel buttons }
  If (PageControl1.ActivePage = TabSh_Display) Then Begin
    {Button_Save2.Default := True;}
    Button_Cancel2.Cancel := True;
  End; { If }
  If (PageControl1.ActivePage = TabSh_Columns) Then Begin
    {Button_Save.Default := True;}
    Button_Cancel.Cancel := True;
  End; { If }
  If (PageControl1.ActivePage = TabSh_Misc) Then Begin
    {Button_Save.Default := True;}
    Button_Cancel3.Cancel := True;
  End; { If }
end;

procedure TForm_TableOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_TableOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TForm_TableOptions.ListVw_ColumnsClick(Sender: TObject);
Var
  CurPos  : TPoint;
  Tmp     : TListItem;
begin
  If (Not Assigned(ListVw_Columns.Selected)) And (ListVw_Columns.ViewStyle = vsReport) Then Begin
    { Try to highlight a match }
    GetCursorPos (CurPos);
    CurPos := ListVw_Columns.ScreenToClient(CurPos);
    CurPos.X := 10;
    Tmp := ListVw_Columns.GetItemAt(CurPos.X, CurPos.Y);
    If Assigned (Tmp) Then Begin
      ListVw_Columns.Selected := Tmp;
      ListVw_Columns.ItemFocused := Tmp;
    End; { If }
  End; { If }
end;

procedure TForm_TableOptions.Button_FontClick(Sender: TObject);
Var
  TheFont : fdFontDefType;
begin
  TheFont := TableObj.Font (ElementTypes(List_Elements.ItemIndex));
  FontRecToFont (FontDialog1.Font, TheFont);

  If FontDialog1.Execute Then Begin
    FontToRec (FontDialog1.Font, TheFont);
    TableObj.SetFont (ElementTypes(List_Elements.ItemIndex), TheFont);
    PaintTable(Sender);
  End; { If }
end;

procedure TForm_TableOptions.Button_IfClick(Sender: TObject);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);
  DLLIfOptions(Label_If);
  RestoreCursor (PrevCur);
end;

procedure TForm_TableOptions.ListVw_ColumnsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
Var
  ListObj : TFormDefListObjType;
begin
  If Assigned(ListVw_Columns.Selected) Then Begin
    ListObj := ListVw_Columns.Selected.Data;

    With ListObj.FormDef Do Begin
      lblColContents.Caption := Trim(fdControlId) + ': ';

      Case fdFieldClass Of
        fdcFieldCol   : lblColContents.Caption := lblColContents.Caption + Trim(FieldCol.fdShortCode);
        fdcFormulaCol : lblColContents.Caption := lblColContents.Caption + Trim(Copy (FormulaCol.ffFormula, 1, 45));
      End; { Case }
    End; { With }
  End; { If }
end;

procedure TForm_TableOptions.ListVw_ColumnsEditing(Sender: TObject;
  Item: TListItem; var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

procedure TForm_TableOptions.btnColPrintIfClick(Sender: TObject);
Var
  TmpGlobThing : FormDefRecType;
  ListObj      : TFormDefListObjType;
  PrevCur      : TCursor;
begin
  If Assigned (ListVw_Columns.Selected) Then Begin
    CursorToHourglass (PrevCur);

    { Replace Table's info with column info for IF Dialog }
    TmpGlobThing := IfControlDef;
    ListObj := ListVw_Columns.Selected.Data;
    IfControlDef := ListObj.FormDef;

    { IF Dialog }
    DLLIfOptions(Nil);

    { Save changes and restore Table record }
    ListObj.FormDef := IfControlDef;
    IfControlDef := TmpGlobThing;

    { Update list }
    SetListItem (ListObj, ListVw_Columns.Selected);

    RestoreCursor (PrevCur);
  End; { If }
end;

end.
