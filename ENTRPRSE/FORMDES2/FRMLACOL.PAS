unit Frmlacol;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, SBSPanel, SBSList, ExtCtrls, BorBtns, ComCtrls, Menus,
  GlobType, Mask, bkgroup;

type
  TForm_AddFormulaCol = class(TForm)
    Button_Save: TButton;
    Button_Cancel: TButton;
    Popup_Commands: TPopupMenu;
    PageControl2: TPageControl;
    TabSh_Formula: TTabSheet;
    TabSh_Column: TTabSheet;
    Panel_Font: TSBSPanel;
    Label_Font: Label8;
    Button_SelectFont: TButton;
    FontDialog1: TFontDialog;
    Combo_Align: TSBSComboBox;
    Ccy_Decs: TCurrencyEdit;
    PageControl1: TPageControl;
    TabSh_FormFields: TTabSheet;
    List_FormFields: TListBox;
    TabSh_Commands: TTabSheet;
    List_Commands: TListBox;
    Memo_Formula: TMemo;
    Text_Title: Text8Pt;
    CcyVal_Width: TCurrencyEdit;
    Check_ColSep: TBorCheck;
    Check_HideCol: TBorCheck;
    BorChk_BlankZero: TBorCheck;
    SBSPanel3: TSBSPanel;
    Label_If: Label8;
    Button_If: TButton;
    Label_Formula: Label8;
    Label85: Label8;
    Label86: Label8;
    Label88: Label8;
    Label82: Label8;
    Label87: Label8;
    SBSBackGroup2: TSBSBackGroup;
    Button_Validate: TButton;
    btrDbField: TButton;
    lblResType: Label8;
    Label84: Label8;
    TabSh_BarCode: TTabSheet;
    SBSBackGroup1: TSBSBackGroup;
    Label83: Label8;
    Combo_Type: TSBSComboBox;
    ListPan: TPanel;
    FNCPan: TPanel;
    Chk_FNC1: TBorCheck;
    Chk_FNC2: TBorCheck;
    Chk_FNC3: TBorCheck;
    ExtPan: TPanel;
    Chk_Extend: TBorCheck;
    CheckPan: TPanel;
    Chk_CheckChar: TBorCheck;
    StrtPan: TPanel;
    LblStart: Label8;
    LblStop: Label8;
    Combo_Stop: TSBSComboBox;
    Combo_Start: TSBSComboBox;
    Panel1: TPanel;
    Label81: Label8;
    procedure FormCreate(Sender: TObject);
    procedure Button_ValidateClick(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_SelectFontClick(Sender: TObject);
    procedure DblClickOnList(Sender: TObject);
    procedure CommandsPopupClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button_IfClick(Sender: TObject);
    procedure btrDbFieldClick(Sender: TObject);
    procedure Memo_FormulaChange(Sender: TObject);
    procedure Combo_TypeChange(Sender: TObject);
  private
    { Private declarations }
    WarnedBlank   : Boolean;
    RememberOpStr : String;
    LastTable     : TFormDefListObjType;
    Procedure LoadCommands;
    Function ValidFormula(Const WantOk  : Boolean;
                          Const ProcErr : Boolean) : Boolean;
  public
    { Public declarations }
    Ok : Boolean;
    Procedure SetTableObj (Const ControlId : String10);
    Procedure LoadFormFields (Var Controls : TSBSList);
    Procedure AddSectionTitle(Const Idx : Byte;Const TableId : String10);
    Procedure AddTableControl (Const Idx : Byte;TabCont : TFormDefListObjType);
    Procedure SetAlign (Const fdAlign : TAlignment);
    Function  GetAlign : TAlignment;
    Procedure SetForm (Const Edit : Boolean);
  end;

var
  Form_AddFormulaCol: TForm_AddFormulaCol;

implementation

{$R *.DFM}

Uses GlobVar, VarConst, DataDict, FormUtil, Parser, SBSFuncs,
     Options, SelFld2;

procedure TForm_AddFormulaCol.FormCreate(Sender: TObject);
begin
  WarnedBlank := False;
  Ok := False;
  RememberOpStr := '';

  LoadCommands;

  { set the correct default pages on the tab controls }
  PageControl1.ActivePage := TabSh_FormFields;
  PageControl2.ActivePage := TabSh_Formula;

  { Default to left justified }
  Combo_Align.ItemIndex := 0;
end;

procedure TForm_AddFormulaCol.FormDestroy(Sender: TObject);

  Procedure FreeListObjs (Var TheList : TListBox);
  Var
    ListRefObj : ListReferenceObject;
    I          : Integer;
  Begin { FreeListObjs }
    If (TheList.Items.Count > 0) Then
      For I := 0 To (TheList.Items.Count - 1) Do Begin
        ListRefObj := ListReferenceObject(TheList.Items.Objects[I]);
        ListRefObj.Free;
      End; { For }
  End;  { FreeListObjs }

begin
  { Free all the objects in the lists }
  FreeListObjs (List_FormFields);
  FreeListObjs (List_Commands);
end;

{ Sets the handle for the table control - if not already set}
Procedure TForm_AddFormulaCol.SetTableObj (Const ControlId : String10);
Begin
  If Not Assigned (LastTable) Then Begin
    LastTable := TFormDefListObjType.Create;
    LastTable.FormDef.fdControlId := ControlId;
  End; { If }
End;

{ Adds in the formulae on the form - ignores table controls }
Procedure TForm_AddFormulaCol.LoadFormFields (Var Controls : TSBSList);
Var
  DefRec{, LastTable} : TFormDefListObjType;
  I                 : Integer;
begin
  List_FormFields.Items.Clear;

  If Assigned (Controls) Then Begin
    AddObjectToList (List_FormFields, Nil, 1, 'Formula Fields:', '', '', 0, [Popup], Nil);
    If (Controls.Count > 0) Then
      { Add any formula fields in }
      For I := 0 To (Controls.Count - 1) Do Begin
        DefRec := TFormDefListObjType(Controls.Items[I]);

        With DefRec.FormDef Do Begin
          If (fdFieldClass = fdcFormula) Then
            AddObjectToList (List_FormFields,
                             Nil,
                             2,
                             DefRec.FormDef.fdControlId,
                             Trim(Copy (Formula.ffFormula, 1, 60)),
                             'FML[' + DefRec.FormDef.fdControlId + ']',
                             0,
                             [Field],
                             Nil);
        End; { With }
      End; { For }

    { Take copy of table handle }
    If (Controls.Count > 0) Then Begin
      For I := 0 To (Controls.Count - 1) Do Begin
        DefRec := TFormDefListObjType(Controls.Items[I]);

        If (DefRec.FormDef.fdFieldClass = fdcTable ) Then
          LastTable := DefRec;
      End; { For }
    End; { If }
  End; { If }
end;

Procedure TForm_AddFormulaCol.AddSectionTitle(Const Idx : Byte;Const TableId : String10);
Begin
  AddObjectToList (List_FormFields, Nil, 1, '', '', '', 0, [], Nil);
  Case Idx Of
    0 : Begin
          AddObjectToList (List_FormFields, Nil, 1, 'Table Rows:', '', '', 0, [Popup], Nil);
          AddObjectToList (List_FormFields, Nil, 2, TableId + '.RowNo',
                                                    'Current Row Number',
                                                    'TRW[' + TableId + ']',
                                                    0,
                                                    [Field],
                                                    Nil);
        End;
    1 : AddObjectToList (List_FormFields, Nil, 1, 'Table Columns (Current Row):', '', '', 0, [Popup], Nil);
    2 : AddObjectToList (List_FormFields, Nil, 1, 'Table Columns (Running Total):', '', '', 0, [Popup], Nil);
    3 : AddObjectToList (List_FormFields, Nil, 1, 'Table Columns (Previous Row):', '', '', 0, [Popup], Nil);
  End; { Case }
End;

Procedure TForm_AddFormulaCol.AddTableControl (Const Idx : Byte;TabCont : TFormDefListObjType);
Var
  Prefix : String[4];
Begin
  With TabCont.FormDef Do Begin
    Case Idx Of
      1 : Prefix := 'TBC[';
      2 : Prefix := 'TBT[';
      3 : Prefix := 'TBP[';
    End; { Case }

    Case fdFieldClass Of
      fdcFieldCol   : With FieldCol Do Begin
                        AddObjectToList (List_FormFields,
                                         Nil,
                                         2,
                                         LastTable.FormDef.fdControlId + '.' + fdControlId,
                                         fdTitle + '  (Field: ' + Trim(fdShortCode) + ')',
                                         Prefix + fdControlId + ']',
                                         0,
                                         [Field],
                                         Nil);
                      End;
      fdcFormulaCol : With FormulaCol Do Begin
                        AddObjectToList (List_FormFields,
                                         Nil,
                                         2,
                                         LastTable.FormDef.fdControlId + '.' + fdControlId,
                                         ffTitle + '  (' + Trim(Copy (ffFormula, 1, 40)) + ')',
                                         Prefix + fdControlId + ']',
                                         0,
                                         [Field],
                                         Nil);
                      End;
    End; { Case }
  End; { With }
end;

Procedure TForm_AddFormulaCol.LoadCommands;
begin
  List_Commands.Items.Clear;

  AddObjectToList (List_Commands, Popup_Commands, 1, 'Mathematical Operators:', '', '', 0, [Popup], Nil);
  AddObjectToList (List_Commands, Nil, 2, '+',    'Add', '', 0, [Field, Remember], Nil);
  AddObjectToList (List_Commands, Nil, 2, '-',    'Subtract', '', 0, [Field, Remember], Nil);
  AddObjectToList (List_Commands, Nil, 2, '/',    'Divide By', '', 0, [Field, Remember], Nil);
  AddObjectToList (List_Commands, Nil, 2, '*',    'Multiply', '', 0, [Field, Remember], Nil);
  AddObjectToList (List_Commands, Nil, 2, '^',    'Calculates the exponential value of number', '', 0, [Field, NoRemember], Nil);
  AddObjectToList (List_Commands, Nil, 2, '(',    '', '', 0, [Field, NoRemember], Nil);
  AddObjectToList (List_Commands, Nil, 2, ')',    '', '', 0, [Field], Nil);

  AddObjectToList (List_Commands, Nil, 1, '', '', '', 0, [], Nil);
  AddObjectToList (List_Commands, Popup_Commands, 1, 'Mathematical Functions:', '', '', 0, [Popup], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'ABS(number)',  'Calculates the positive value of number', 'ABS()', 4, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'EXP(number)',  'Calculates the exponential value of number', 'EXP()', 4, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'LN(number)',  'Calculates the natural logarithm of number', 'LN()', 3, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'ROUND(number)',  'Rounds number to zero decimal places', 'ROUND()', 6, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'SQR(integer)',  'Calculates the square of integer', 'SQR()', 4, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'SQRT(integer)', 'Calculates the square root of integer', 'SQRT()', 5, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'TRUNC(number)', 'Truncates number to zero decimal places', 'TRUNC()', 6, [Field], Nil);

  AddObjectToList (List_Commands, Nil, 1, '', '', '', 0, [], Nil);
  AddObjectToList (List_Commands, Popup_Commands, 1, 'Notes Functions:', '', '', 0, [Popup], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'GCUSTNOT[number]', 'Gets the specified general note line for the current Customer', 'GCUSTNOT[]', 9, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'GSUPPNOT[number]', 'Gets the specified general note line for the current Supplier', 'GSUPPNOT[]', 9, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'GINVNOT[number]',  'Gets the specified general note line for the current Invoice', 'GINVNOT[]', 8, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'GSERNOT[number]',  'Gets the specified general note line for the current Serial/Batch Number', 'GSERNOT[]', 8, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'GSTKNOT[number]',  'Gets the specified general note line for the current Stock Item', 'GSTKNOT[]', 8, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'GJOBNOT[number]',  'Gets the specified general note line for the current Job', 'GJOBNOT[]', 8, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'DCUSTNOT[number]', 'Gets the specified dated note line for the current Customer', 'DCUSTNOT[]', 9, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'DSUPPNOT[number]', 'Gets the specified dated note line for the current Supplier', 'DSUPPNOT[]', 9, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'DINVNOT[number]',  'Gets the specified dated note line for the current Invoice', 'DINVNOT[]', 8, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'DSERNOT[number]',  'Gets the specified dated note line for the current Serial/Batch Number', 'DSERNOT[]', 8, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'DSTKNOT[number]',  'Gets the specified dated note line for the current Stock Item', 'DSTKNOT[]', 8, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'DJOBNOT[number]',  'Gets the specified dated note line for the current Job', 'DJOBNOT[]', 8, [Field], Nil);

  AddObjectToList (List_Commands, Nil, 1, '', '', '', 0, [], Nil);
  AddObjectToList (List_Commands, Popup_Commands, 1, 'Currency & Rate Functions:', '', '', 0, [Popup], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'CCYAGE[see Help]',  'Gets the Currency Ageing totals. see Help for more info', 'CCYAGE[,0]', 7, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'CCYNAME[see Help]', 'Gets the Name of a specified currency', 'CCYNAME[]', 8, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'CCYSYMB[see Help]', 'Gets the Printer Symbol of a specified currency', 'CCYSYMB[]', 8, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'RTCOMP[see Help]',  'Gets the Company Rate for a specified currency', 'RTCOMP[]', 7, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'RTDAILY[see Help]', 'Gets the Daily Rate for a specified currency', 'RTDAILY[]', 8, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'RTFLOAT[see Help]', 'Gets the Floating Rate for a specified currency', 'RTFLOAT[]', 8, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'RTINVRT[see Help]', 'Gets the Invert Rate Flag for a specified currency', 'RTINVRT[]', 8, [Field], Nil);

  AddObjectToList (List_Commands, Nil, 1, '', '', '', 0, [], Nil);
  AddObjectToList (List_Commands, Popup_Commands, 1, 'Miscellaneous Functions:', '', '', 0, [Popup], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'FMTDATE[see Help]','Gets and formats the specified date. see Help for more info', 'FMTDATE[,0,D,1]', 8, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'IDQTY',            'Gets the number of items in the current invoice line', 'IDQTY', 5, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'DOCSIGN(number)',  'Signs the number according to the current invoice document type', 'DOCSIGN()', 8, [Field], Nil);
  // MH 18/02/2014 v7.0.9 ABSEXCH-15081: Added missing function into function list
  AddObjectToList (List_Commands, Nil, 2, 'LOADROLE[see Help]', 'Gets the Contact for a specified Role Description and Account Code', 'LOADROLE[,]', 9, [Field], Nil);
end;

Function TForm_AddFormulaCol.ValidFormula(Const WantOk  : Boolean;
                                           Const ProcErr : Boolean) : Boolean;
Var
  ResStr, TheFormula : String;
  ParserObj          : TParserObj;
  IVType             : Byte;
begin
  { Create new instance of the parser object }
  ParserObj := TParserObj.Create;

  { Copy formula into string }
  TheFormula := Trim(Memo_Formula.Text);

  ResStr := ParserObj.SetFormula(TheFormula, 2, IVType, True);

  {If Debug Then
    ShowMessage ('Form: ' + TheFormula + CRLF +
                 'ResStr: ' + ResStr + CRLF +
                 'Status: ' + IIF (ParserObj.FormulaErr, 'Error', 'Ok') + CRLF +
                 'ErrPos: ' + IntToStr(ParserObj.FormulaErrPos) + CRLF +
                 'ErrType: ' + IntToStr(Ord(ParserObj.FormulaErrType)));}

  Result := (ResStr <> ErrStr) And (Not ParserObj.FormulaErr);

  { Check to see if any error should be processed }
  If ProcErr And (Not Result) Then Begin
    { An error has occured }
    If Memo_Formula.CanFocus Then Memo_Formula.SetFocus;

    { Check to see if we've got a position for the error }
    If (ParserObj.FormulaErrPos > 0) Then Begin
      Memo_Formula.SelStart := ParserObj.FormulaErrPos - 1;
      Memo_Formula.SelLength := 0;
    End; { If }

    { Display error msg }
    TheFormula := ParserObj.FormulaErrStr;
    If (Trim (TheFormula) <> '') Then
      MessageDlg (TheFormula, mtInformation, [mbOk], 0);
  End; { If }

  If Result And WantOk Then
    { Display AOK message }
    MessageDlg ('The Formula is valid', mtInformation, [mbOk], 0);

  { Free the parser }
  ParserObj.Free;
end;

procedure TForm_AddFormulaCol.Button_ValidateClick(Sender: TObject);
begin
  { Return to memo for correction }
  ValidFormula(True, True);
end;

procedure TForm_AddFormulaCol.Button_SaveClick(Sender: TObject);
begin
  If ValidFormula(False, True) Then Begin
    If (Not WarnedBlank) And (Trim(Text_Title.Text) = '') Then Begin
      { Give warning that the column title is blank }
      WarnedBlank := True;
      PageControl2.ActivePage := TabSh_Column;
      If Text_Title.CanFocus Then Text_Title.SetFocus;
      MessageDlg ('Warning: The column title is blank', mtInformation, [mbOk], 0);
    End { If }
    Else Begin
      Ok := True;  { Add validation here }
      Close;
    End; { Else }
  End; { If }
end;

procedure TForm_AddFormulaCol.Button_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

procedure TForm_AddFormulaCol.Button_SelectFontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(Label_Font.Font);
  FontDialog1.Execute;
  Label_Font.Font.Assign(FontDialog1.Font);
end;

procedure TForm_AddFormulaCol.DblClickOnList(Sender: TObject);
Var
  ListRefObj            : ListReferenceObject;
  TheList               : TListBox;
  TheFormula, AddStr    : String;
  oSelStart, oSelLength : Integer;

  { Returns true if cursor is positioned to add a parameter }
  Function IsParam : Boolean;
  Var
    cStart, cEnd : Integer;
    Char1, Char2 : Char;
  begin
    With Memo_Formula Do Begin
      Char1 := #0;
      Char2 := #0;

      cStart := SelStart;
      cEnd := cStart + SelLength;
      If (cStart = cEnd) Then Inc(cEnd);

      If (cStart > 0) And (cStart <= Length (TheFormula)) Then
        Char1 := TheFormula[cStart];
      If (cEnd > 0) And (cEnd <= Length (TheFormula)) Then
        Char2 := TheFormula[cEnd];

      Result := (Char1 = '(') And (Char2 = ')');
    End; { With }
  end;

begin
  If Sender Is TListbox Then Begin
    { Get copy of list }
    TheList := TListBox(Sender);

    If (TheList.ItemIndex > -1) Then Begin
      ListRefObj := ListReferenceObject(TheList.Items.Objects[TheList.ItemIndex]);

      If (ListRefObj.IsField) Then Begin
        If ListRefObj.RememberOp Then RememberOpStr := '';

        With Memo_Formula, ListRefObj do Begin
          If Assigned (ListRefObj.AddDialog) Then Begin
            ShowMessage ('Got Dialog');
          End { If }
          Else Begin
            TheFormula := Memo_Formula.Text;
            oSelStart := SelStart;
            oSelLength := SelLength;
            If (Not DisableRemem) And (Not IsParam) Then
              AddStr := AddToFormula + RememberOpStr
            Else
              AddStr := AddToFormula;
            If (Length (SelText) = 0) Then
              { Insert AddToFormula at SelStart }
              Insert (AddStr, TheFormula, SelStart + 1)
            Else Begin
              { Overwrite selected text }
              Delete (TheFormula, SelStart + 1, SelLength);
              Insert (AddStr, TheFormula, SelStart + 1);
            End; { If }

            Memo_Formula.Text := TheFormula;
            If (CursorOffset > 0) Then
              SelStart := oSelStart + CursorOffset
            Else
              SelStart := oSelStart + Length(AddStr);
            If Memo_Formula.CanFocus Then Memo_Formula.SetFocus;
          End; { Else }
        End; { With }

        If ListRefObj.RememberOp Then
          RememberOpStr := ListRefObj.AddToFormula;
      End; { If }
    End; { If }
  End; { If }
end;

procedure TForm_AddFormulaCol.CommandsPopupClick(Sender: TObject);
Var
  MenuItem : TMenuItem;
  Idx      : Integer;
begin
  If Sender Is TMenuItem Then Begin
    { Get a proper copy of the menu item }
    MenuItem := TMenuItem (Sender);

    { Try to find a matching string in the commands list }
    Idx := List_Commands.Items.IndexOf (MenuItem.Caption);

    { Position on item if it was found }
    If (Idx > -1) Then
      List_Commands.ItemIndex := Idx;
  End; { If }
end;

procedure TForm_AddFormulaCol.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_AddFormulaCol.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

Procedure TForm_AddFormulaCol.SetAlign (Const fdAlign : TAlignment);
begin
  Case fdAlign Of
    taLeftJustify  : Combo_Align.ItemIndex := 0;
    taCenter       : Combo_Align.ItemIndex := 1;
    taRightJustify : Combo_Align.ItemIndex := 2;
  Else
    Combo_Align.ItemIndex := 0;
  End; { Case }
end;

Function TForm_AddFormulaCol.GetAlign : TAlignment;
begin
  Case Combo_Align.ItemIndex Of
    0 : Result := taLeftJustify;
    1 : Result := taCenter;
    2 : Result := taRightJustify;
  Else
    Result := taLeftJustify;
  End; { Case }
end;

Procedure TForm_AddFormulaCol.SetForm (Const Edit : Boolean);
begin
  If Edit Then Begin
    { Editing }
    Caption := 'Edit Formula Column';
  End { If }
  Else Begin
    { Adding }
    Caption := 'Add Formula Column';
  End; { Else }
end;


procedure TForm_AddFormulaCol.Button_IfClick(Sender: TObject);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);
  DLLIfOptions(Label_If);
  RestoreCursor (PrevCur);
end;

procedure TForm_AddFormulaCol.btrDbFieldClick(Sender: TObject);
Var
  PrevCur     : TCursor;
  LObj        : ListReferenceObject;
begin
  CursorToHourglass (PrevCur);

  If (Not Assigned(Form_SelectField2)) Then
    Form_SelectField2 := TForm_SelectField2.Create (Application.MainForm);

  Try
    If (DbFileNo = -1) Then DbFileNo := TabNo_Lines;
    Form_SelectField2.SetShortCode ('', DbFileNo);

    CursorForDialog;
    Form_SelectField2.ShowModal;
    CursorFromDialog;

    If Form_SelectField2.Ok Then Begin
      { Copy field details }
      DbFileNo := Form_SelectField2.PageControl1.ActivePage.Tag;

      If Assigned(Form_SelectField2.ActiveList) Then Begin
        LObj := ListReferenceObject.Create;
        With LObj Do Begin
          IsField      := True;
          RememberOp   := False;
          DisableRemem := False;
          AddToFormula := 'DBF[' + Trim(Form_SelectField2.ShortCode) + ']';
          CursorOffset := 0;
          AddDialog    := Nil;
        End; { With LObj }

        With Form_SelectField2, ActiveList Do Begin
          Items.Objects[ItemIndex] := LObj;

          DblClickOnList(ActiveList);

          Items.Objects[ItemIndex] := Nil;
          LObj.Destroy;
        End; { With }
      End; { If Assigned... }
    End; { If }
  Finally
    {Form_SelectField2.Free;}
  End;

  RestoreCursor (PrevCur);
end;

procedure TForm_AddFormulaCol.Memo_FormulaChange(Sender: TObject);
begin
  If (Length(Trim(Memo_Formula.Text)) > 0) Then
    If (Trim(Memo_Formula.Text)[1] = '"') Then
      lblResType.Caption := 'Character String'
    Else
      lblResType.Caption := 'Number'
  Else
    lblResType.Caption := 'Number';
end;

procedure TForm_AddFormulaCol.Combo_TypeChange(Sender: TObject);
begin
  If (Combo_Type.ItemIndex >= 0) Then Begin
    { FNC 1 - 3 }
    FNCPan.Visible := False;{(Combo_Type.ItemIndex = Ord(bcCode128));}
    { Set Code 128 settings to match default }
    If (Combo_Type.ItemIndex = Ord(bcCode128)) Then Begin
      Chk_FNC1.Checked := False;
      Chk_FNC2.Checked := False;
      Chk_FNC3.Checked := False;
    End; { If }

    { Extended Character Set }
    ExtPan.Visible := (Combo_Type.ItemIndex = Ord(bcCode39));

    { Check Character }
    CheckPan.Visible := (Combo_Type.ItemIndex In [Ord(bcCode39),
                                                  Ord(bcInter25){,
                                                  Ord(bcCodaBar)}]);

    { Start & Stop Codes }
    StrtPan.Visible := False;{(Combo_Type.ItemIndex = Ord(bcCodaBar));}
    If StrtPan.Visible Then Begin
      { Make sure an item is selected }
      If (Combo_Start.ItemIndex = -1) Then Combo_Start.ItemIndex := 0;
      If (Combo_Stop.ItemIndex = -1) Then Combo_Stop.ItemIndex := 0;
    End; { If }

    { Set Codabar settings to match default }
    If (Combo_Type.ItemIndex = Ord(bcCodaBar)) Then Begin
      Chk_CheckChar.Checked := True;
      Combo_Start.ItemIndex := 0;
      Combo_Stop.ItemIndex := 1;
    End; { If }

    {ListPan.Visible := FNCPan.Visible Or ExtPan.Visible Or CheckPan.Visible Or
                       CheckPan.Visible;}
  End { If }
  Else Begin
    Combo_Type.ItemIndex := 0;
    Combo_TypeChange(Sender);
  End; { Else }
end;

end.
