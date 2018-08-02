unit Frmlacol;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, SBSPanel, SBSList, ExtCtrls, BorBtns, ComCtrls, Menus,
  GlobType, Mask, bkgroup;

type
  string10 = String[10];

  TForm_AddFormulaCol = class(TForm)
    Button_Save: TButton;
    Button_Cancel: TButton;
    Popup_Commands: TPopupMenu;
    FontDialog1: TFontDialog;
    Panel1: TPanel;
    List_Commands: TListBox;
    Label_Formula: Label8;
    Memo_Formula: TMemo;
    btrDbField: TButton;
    Button_Validate: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button_ValidateClick(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure DblClickOnList(Sender: TObject);
    procedure CommandsPopupClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btrDbFieldClick(Sender: TObject);
  private
    { Private declarations }
    WarnedBlank   : Boolean;
    RememberOpStr : String;
    LastTable     : TFormDefListObjType;
    FIsCondition : Boolean;
    Procedure LoadCommands;
    Function ValidFormula(Const WantOk  : Boolean;
                          Const ProcErr : Boolean) : Boolean;
  public
    { Public declarations }
    Ok : Boolean;
    FileNumber : SmallInt;
    Procedure SetTableObj (Const ControlId : String10);
    Procedure LoadFormFields (Var Controls : TSBSList);
    Procedure AddSectionTitle(Const Idx : Byte;Const TableId : String10);
    Procedure AddTableControl (Const Idx : Byte;TabCont : TFormDefListObjType);
    Procedure SetAlign (Const fdAlign : TAlignment);
    Function  GetAlign : TAlignment;
    Procedure SetForm (Const IsCondition : Boolean);
  end;

var
  Form_AddFormulaCol: TForm_AddFormulaCol;
  DBFileNo     : SmallInt;

implementation

{$R *.DFM}

Uses GlobVar, VarConst, DataDict, FormUtil, Parser, SBSFuncs,
    { Options,} SelFld2, ThingU;

procedure TForm_AddFormulaCol.FormCreate(Sender: TObject);
begin
  WarnedBlank := False;
  Ok := False;
  RememberOpStr := '';

//  LoadCommands;

  { set the correct default pages on the tab controls }
  //PageControl1.ActivePage := TabSh_FormFields;
  //PageControl2.ActivePage := TabSh_Formula;

  { Default to left justified }
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
  //FreeListObjs (List_FormFields);
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
(*  List_FormFields.Items.Clear;

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
  End; { If } *)
end;

Procedure TForm_AddFormulaCol.AddSectionTitle(Const Idx : Byte;Const TableId : String10);
Begin
(*  AddObjectToList (List_FormFields, Nil, 1, '', '', '', 0, [], Nil);
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
*)
End;

Procedure TForm_AddFormulaCol.AddTableControl (Const Idx : Byte;TabCont : TFormDefListObjType);
Var
  Prefix : String[4];
Begin
(*  With TabCont.FormDef Do Begin
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
*)
end;

Procedure TForm_AddFormulaCol.LoadCommands;
begin
  List_Commands.Items.Clear;

  if FIsCondition then
  begin
  AddObjectToList (List_Commands, Nil, 1, 'Comparison Operators:',   '', '', 0, [Popup], Nil);
  AddObjectToList (List_Commands, Nil, 2, '=',    'is equal to',     ' = ', 0, [Field, NoTrim], Nil);
  AddObjectToList (List_Commands, Nil, 2, '<>',   'is not equal to', ' <> ', 0, [Field, NoTrim], Nil);
  AddObjectToList (List_Commands, Nil, 2, '>',    'is greater than', ' > ', 0, [Field, NoTrim], Nil);
  AddObjectToList (List_Commands, Nil, 2, '<',    'is less than', ' < ', 0, [Field, NoTrim], Nil);
  AddObjectToList (List_Commands, Nil, 2, '>=',   'is greater than or equal to', ' >= ', 0, [Field, NoTrim], Nil);
  AddObjectToList (List_Commands, Nil, 2, '<=',   'is less than or equal to', ' <= ', 0, [Field, NoTrim], Nil);

  AddObjectToList (List_Commands, Nil, 1, '', '', '', 0, [], Nil);
  AddObjectToList (List_Commands, Nil, 1, 'Boolean Operators:', '', '', 0, [Popup], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'AND',  '', ' AND ', 0, [Field, NoTrim], Nil);
  AddObjectToList (List_Commands, Nil, 2, 'OR',   '', ' OR ', 0, [Field, NoTrim], Nil);
  
  AddObjectToList (List_Commands, Nil, 1, '', '', '', 0, [], Nil);
  end;

  AddObjectToList (List_Commands, Nil, 1, 'Brackets:', '', '', 0, [Popup], Nil);
  AddObjectToList (List_Commands, Nil, 2, '(', 'Starts a sub-expression within the condition', '(', 0, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, ')', 'Finishes a sub-expression within the condition', ')', 0, [Field], Nil);
(*  AddObjectToList (List_Commands, Nil, 2, '{', 'Starts a formula within the condition', '(', 0, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, '}', 'Finishes a formula within the condition', ')', 0, [Field], Nil); *)
  AddObjectToList (List_Commands, Nil, 1, '', '', '', 0, [], Nil);


  AddObjectToList (List_Commands, Popup_Commands, 1, 'Mathematical Operators:', '', '', 0, [Popup], Nil);
  AddObjectToList (List_Commands, Nil, 2, '+',    'Add', '', 0, [Field, Remember], Nil);
  AddObjectToList (List_Commands, Nil, 2, '-',    'Subtract', '', 0, [Field, Remember], Nil);
  AddObjectToList (List_Commands, Nil, 2, '/',    'Divide By', '', 0, [Field, Remember], Nil);
  AddObjectToList (List_Commands, Nil, 2, '*',    'Multiply', '', 0, [Field, Remember], Nil);
  AddObjectToList (List_Commands, Nil, 2, '^',    'Calculates the exponential value of number', '', 0, [Field, NoRemember], Nil);
//  AddObjectToList (List_Commands, Nil, 2, '(',    '', '', 0, [Field, NoRemember], Nil);
//  AddObjectToList (List_Commands, Nil, 2, ')',    '', '', 0, [Field], Nil);

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
end;

Function TForm_AddFormulaCol.ValidFormula(Const WantOk  : Boolean;
                                           Const ProcErr : Boolean) : Boolean;

  function RemoveEOLs(const s : AnsiString) : AnsiString;
  var
    i : integer;
  begin
    i := 1;
    Result := s;
    while (i < Length(Result)) do
    begin
      if Result[i] in [#10, #13] then
      begin
        Delete(Result, i, 1);
      end
      else
        inc(i);
    end;
  end;
(*Var
  ResStr, TheFormula : String;
  ParserObj          : TParserObj;
  IVType             : Byte;
begin
  { Create new instance of the parser object }
  ParserObj := TParserObj.Create;

  { Copy formula into string }
  TheFormula := Trim(Memo_Formula.Text);

{  ResStr := ParserObj.SetFormula(TheFormula, 2, IVType, True);}
   Result := ParserObj.Evaluate_Expression (TheFormula, True);
  {If Debug Then
    ShowMessage ('Form: ' + TheFormula + CRLF +
                 'ResStr: ' + ResStr + CRLF +
                 'Status: ' + IIF (ParserObj.FormulaErr, 'Error', 'Ok') + CRLF +
                 'ErrPos: ' + IntToStr(ParserObj.FormulaErrPos) + CRLF +
                 'ErrType: ' + IntToStr(Ord(ParserObj.FormulaErrType)));}

//  Result := (ResStr <> ErrStr) And (Not ParserObj.FormulaErr);

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
*)
Var
  Res         : Boolean;
  TheFormula  : Str200;
  ParserObj   : TParserObj;
  TheThing  : TThing;
begin
  { Create new instance of the parser object }
  ParserObj := TParserObj.Create;
  Try
    { Copy formula into string }
    TheFormula := RemoveEOLs(Trim(Memo_Formula.Text));

    TheThing := TThing.Create;
    Try
      { Set event links }
      TheThing.DrivingFile := FileNumber;
      TheThing.TestMode := True;
      ParserObj.GetDBFEvent := TheThing.GetDBFEvent;
      ParserObj.GetFMLEvent := TheThing.GetFMLEvent;
      ParserObj.GetTBCEvent := TheThing.GetTBCEvent;
      ParserObj.GetTBPEvent := TheThing.GetTBPEvent;
      ParserObj.GetTBTEvent := TheThing.GetTBTEvent;
      ParserObj.GetTRWEvent := TheThing.GetTRWEvent;
      ParserObj.GetFmtDateEvent := TheThing.FormatDate;
{      ParserObj.GetDocSignEvent   := TheThing.GetDocSign;
      ParserObj.GetCustNoteEvent  := TheThing.GetCustNote;
      ParserObj.GetSuppNoteEvent  := TheThing.GetSuppNote;
      ParserObj.GetInvNoteEvent   := TheThing.GetInvNote;
      ParserObj.GetStockNoteEvent := TheThing.GetStockNote;
      ParserObj.GetPageNoEvent    := TheThing.GetPageNo;
      ParserObj.GetIdQtyEvent     := TheThing.GetIdQtyNo;}
      ParserObj.ReplaceExpressions(TheFormula, True);
      Res := ParserObj.Evaluate_Expression (TheFormula, ProcErr);
    Finally
      TheThing.Free;
    End;

    {If Debug Then
      ShowMessage ('Form: ' + TheFormula + CRLF +
                   'Res: ' + IIF (Res, 'True', 'False') + CRLF +
                   'Status: ' + IIF (ParserObj.FormulaErr, 'Error', 'Ok') + CRLF +
                   'ErrPos: ' + IntToStr(ParserObj.FormulaErrPos) + CRLF +
                   'ErrType: ' + IntToStr(Ord(ParserObj.FormulaErrType)));}

    Result := (Not ParserObj.FormulaErr);

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
      MessageDlg ('The Expression is valid', mtInformation, [mbOk], 0);
  Finally
    { Free the parser }
    ParserObj.Free;
  End;
end;

procedure TForm_AddFormulaCol.Button_ValidateClick(Sender: TObject);
begin
  { Return to memo for correction }
  ValidFormula(True, {False}True);
end;

procedure TForm_AddFormulaCol.Button_SaveClick(Sender: TObject);
begin
  If not FIscondition or ValidFormula(False, True) Then Begin
      Ok := True;  { Add validation here }
      Close;
  End; { If }
end;

procedure TForm_AddFormulaCol.Button_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
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
(*  Case fdAlign Of
    taLeftJustify  : Combo_Align.ItemIndex := 0;
    taCenter       : Combo_Align.ItemIndex := 1;
    taRightJustify : Combo_Align.ItemIndex := 2;
  Else
    Combo_Align.ItemIndex := 0;
  End; { Case }
*)
end;

Function TForm_AddFormulaCol.GetAlign : TAlignment;
begin
(*  Case Combo_Align.ItemIndex Of
    0 : Result := taLeftJustify;
    1 : Result := taCenter;
    2 : Result := taRightJustify;
  Else
    Result := taLeftJustify;
  End; { Case }
*)
end;

Procedure TForm_AddFormulaCol.SetForm (Const IsCondition : Boolean);
begin
  FIsCondition := IsCondition;
  Button_Validate.Visible := IsCondition;
  If IsCondition Then
  Begin
    Caption := 'Edit Condition';
    Label_Formula.Caption := 'Condition';
    btrDbField.Left := 336;
  End { If }
  Else
  Begin
    Caption := 'Edit Message';
    Label_Formula.Caption := 'Message';
    btrDbField.Left := Button_Validate.Left;
  End; { Else }
  LoadCommands;
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
    If (DbFileNo = -1) Then DbFileNo := 1;
    Form_SelectField2.SetShortCode (Form_SelectField2.SC, 1);
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




end.
