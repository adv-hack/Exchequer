unit ifoption;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, SBSPanel, SBSList, ExtCtrls, BorBtns, ComCtrls, Menus,
  GlobType, bkgroup;

type
  TForm_IfOptions = class(TForm)
    Button_Save: TButton;
    Button_Cancel: TButton;
    Memo_If: TMemo;
    TabSheet1: TTabSheet;
    ListBox1: TListBox;
    TabSheet2: TTabSheet;
    ListBox2: TListBox;
    PageControl1: TPageControl;
    TabSh_FormFields: TTabSheet;
    List_FormFields: TListBox;
    TabSh_Commands: TTabSheet;
    List_Commands: TListBox;
    SBSBackGroup1: TSBSBackGroup;
    Label_Formula: Label8;
    Button_Validate: TButton;
    btnSelDbField: TButton;
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
    procedure btnSelDbFieldClick(Sender: TObject);
  private
    { Private declarations }
    RememberOpStr : String;
    Procedure LoadCommands;
    Function ValidIf(Const WantOk  : Boolean;
                     Const ProcErr : Boolean) : Boolean;
  public
    { Public declarations }
    Ok : Boolean;
    DbFile : SmallInt;
    Procedure LoadFormFields (Var Controls : TSBSList;Const Exclude : String10);
  end;

var
  Form_IfOptions: TForm_IfOptions;

Function IfDescr (Const IfRec : fdIfInfoType) : String; Export;
Procedure IfDialog (Var   IfRec     : fdIfInfoType;
                    Const ControlId : String10;
                    Var   Controls  : TSBSList); Export;

implementation

{$R *.DFM}

Uses PrntForm, GlobVar, VarConst, DataDict, FormUtil, Parser, SBSFuncs,
     SelFld2, Options;

Function IfDescr (Const IfRec : fdIfInfoType) : String;
Begin
  Result := 'Print If: ' + IfRec.fiIf;
End;

Procedure IfDialog (Var   IfRec     : fdIfInfoType;
                    Const ControlId : String10;
                    Var   Controls  : TSBSList);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);

  { Create options dialog }
  Form_IfOptions := TForm_IfOptions.Create (Application);
  Try
    { Display if }
    Form_IfOptions.Memo_If.Text :=IfRec.fiIf;
    Form_IfOptions.LoadFormFields (Controls, ControlId);

    CursorForDialog;
    Form_IfOptions.ShowModal;
    CursorFromDialog;

    If Form_IfOptions.Ok Then Begin
      IfRec.fiIf := Form_IfOptions.Memo_If.Text;
    End; { If }
  Finally
    Form_IfOptions.Release;
  End;

  RestoreCursor (PrevCur);
End;

procedure TForm_IfOptions.FormCreate(Sender: TObject);
begin
  Ok := False;
  RememberOpStr := '';

  DbFile := 0;

  LoadCommands;
  PageControl1.ActivePage := TabSh_FormFields;
end;

procedure TForm_IfOptions.FormDestroy(Sender: TObject);

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

Procedure TForm_IfOptions.LoadFormFields (Var Controls : TSBSList;Const Exclude : String10);
Var
  DefRec, LastTable : TFormDefListObjType;
  I, J              : Integer;
  Prefix            : String[4];
begin
  List_FormFields.Items.Clear;

  AddObjectToList (List_FormFields, Nil, 1, 'Page Fields:', '', '', 0, [Popup], Nil);
  AddObjectToList (List_FormFields, Nil, 2, 'PageNo', 'Current Page Number', 'PAGENO', 0, [Field], Nil);
  AddObjectToList (List_FormFields, Nil, 1, '', '', '', 0, [], Nil);

  If Assigned (Controls) Then Begin
    AddObjectToList (List_FormFields, Nil, 1, 'Formula Fields:', '', '', 0, [Popup], Nil);
    If (Controls.Count > 0) Then
      { Add any formula fields in }
      For I := 0 To (Controls.Count - 1) Do Begin
        DefRec := TFormDefListObjType(Controls.Items[I]);

        With DefRec.FormDef Do Begin
          If (fdFieldClass = fdcFormula) And (fdControlId <> Exclude) Then
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

    { Add any table fields in }
    For J := 1 To 3 Do Begin
      { Add Section Header }
      AddObjectToList (List_FormFields, Nil, 1, '', '', '', 0, [], Nil);
      Case J Of
        1 : Begin
              AddObjectToList (List_FormFields, Nil, 1, 'Table Columns (Current Row):', '', '', 0, [Popup], Nil);
              Prefix := 'TBC[';
            End;
        2 : Begin
              AddObjectToList (List_FormFields, Nil, 1, 'Table Columns (Running Total):', '', '', 0, [Popup], Nil);
              Prefix := 'TBT[';
            End;
        3 : Begin
              AddObjectToList (List_FormFields, Nil, 1, 'Table Columns (Previous Row):', '', '', 0, [Popup], Nil);
              Prefix := 'TBP[';
            End;
      End; { Case }

      { Add controls into section }
      If (Controls.Count > 0) Then Begin
        For I := 0 To (Controls.Count - 1) Do Begin
          DefRec := TFormDefListObjType(Controls.Items[I]);

          With DefRec.FormDef Do Begin
            Case fdFieldClass Of
              fdcTable      : LastTable := DefRec;
              fdcFieldCol   : With FieldCol Do
                                AddObjectToList (List_FormFields,
                                                 Nil,
                                                 2,
                                                 LastTable.FormDef.fdControlId + '.' + fdControlId,
                                                 fdTitle + '  (Field: ' + Trim(fdShortCode) + ')',
                                                 Prefix + fdControlId + ']',
                                                 0,
                                                 [Field],
                                                 Nil);
              fdcFormulaCol : If (fdControlId <> Exclude) Then
                                With FormulaCol Do
                                  AddObjectToList (List_FormFields,
                                                   Nil,
                                                   2,
                                                   LastTable.FormDef.fdControlId + '.' + fdControlId,
                                                   ffTitle + '  (' + Trim(Copy (ffFormula, 1, 40)) + ')',
                                                   Prefix + fdControlId + ']',
                                                   0,
                                                   [Field],
                                                   Nil);
            End; { Case }
          End; { With }
        End; { For }
      End; { If }
    End; { For }
  End; { If }
end;

Procedure TForm_IfOptions.LoadCommands;
begin
  List_Commands.Items.Clear;

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
  AddObjectToList (List_Commands, Nil, 1, 'Brackets:', '', '', 0, [Popup], Nil);
  AddObjectToList (List_Commands, Nil, 2, '(', 'Starts a sub-expression within the If statement', '(', 0, [Field], Nil);
  AddObjectToList (List_Commands, Nil, 2, ')', 'Finishes a sub-expression within the If statement', ')', 0, [Field], Nil);
end;

Function TForm_IfOptions.ValidIf(Const WantOk  : Boolean;
                                 Const ProcErr : Boolean) : Boolean;
Var
  Res         : Boolean;
  TheFormula  : String;
  ParserObj   : TParserObj;
begin
  { Create new instance of the parser object }
  ParserObj := TParserObj.Create;
  Try
    { Copy formula into string }
    TheFormula := Trim(Memo_If.Text);

    Form_PrintTest := TForm_PrintTest.Create (Self);
    Try
      { Set event links }
      ParserObj.GetDBFEvent := Form_PrintTest.GetDBFEvent;
      ParserObj.GetFMLEvent := Form_PrintTest.GetFMLEvent;
      ParserObj.GetTBCEvent := Form_PrintTest.GetTBCEvent;
      ParserObj.GetTBPEvent := Form_PrintTest.GetTBPEvent;
      ParserObj.GetTBTEvent := Form_PrintTest.GetTBTEvent;
      ParserObj.GetTRWEvent := Form_PrintTest.GetTRWEvent;
      ParserObj.GetDocSignEvent   := Form_PrintTest.GetDocSign;
      ParserObj.GetCustNoteEvent  := Form_PrintTest.GetCustNote;
      ParserObj.GetSuppNoteEvent  := Form_PrintTest.GetSuppNote;
      ParserObj.GetInvNoteEvent   := Form_PrintTest.GetInvNote;
      ParserObj.GetStockNoteEvent := Form_PrintTest.GetStockNote;
      ParserObj.GetPageNoEvent    := Form_PrintTest.GetPageNo;
      ParserObj.GetIdQtyEvent     := Form_PrintTest.GetIdQtyNo;

      Res := ParserObj.Evaluate_Expression (TheFormula, True);
    Finally
      Form_PrintTest.Release;
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
      If Memo_If.CanFocus Then Memo_If.SetFocus;

      { Check to see if we've got a position for the error }
      If (ParserObj.FormulaErrPos > 0) Then Begin
        Memo_If.SelStart := ParserObj.FormulaErrPos - 1;
        Memo_If.SelLength := 0;
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

procedure TForm_IfOptions.Button_ValidateClick(Sender: TObject);
begin
  { Return to memo for correction }
  ValidIf(True, True);
end;

procedure TForm_IfOptions.Button_SaveClick(Sender: TObject);
begin
  If ValidIf(False, True) Then Begin
    Ok := True;  { Add validation here }
    Close;
  End; { If }
end;

procedure TForm_IfOptions.Button_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

procedure TForm_IfOptions.DblClickOnList(Sender: TObject);
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
    With Memo_If Do Begin
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

        With Memo_If, ListRefObj do Begin
          If Assigned (ListRefObj.AddDialog) Then Begin
            ShowMessage ('Got Dialog');
          End { If }
          Else Begin
            TheFormula := Memo_If.Text;
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

            Memo_If.Text := TheFormula;
            If (CursorOffset > 0) Then
              SelStart := oSelStart + CursorOffset
            Else
              SelStart := oSelStart + Length(AddStr);
            If Memo_If.CanFocus Then Memo_If.SetFocus;
          End; { Else }
        End; { With }

        If ListRefObj.RememberOp Then
          RememberOpStr := ListRefObj.AddToFormula;
      End; { If }
    End; { If }
  End; { If }
end;

procedure TForm_IfOptions.CommandsPopupClick(Sender: TObject);
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

procedure TForm_IfOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_IfOptions.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TForm_IfOptions.btnSelDbFieldClick(Sender: TObject);
Var
  PrevCur     : TCursor;
  LObj        : ListReferenceObject;
begin
  CursorToHourglass (PrevCur);

  If (Not Assigned(Form_SelectField2)) Then
    Form_SelectField2 := TForm_SelectField2.Create (Application.MainForm);
  Try
    If (DbFileNo = -1) Then DbFileNo := TabNo_Trans;
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
      End; { If Assigned }
    End; { If }
  Finally
    {Form_SelectField.Free;}
  End;

  RestoreCursor (PrevCur);
end;

end.
