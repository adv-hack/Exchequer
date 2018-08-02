unit Recurse;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;

Type
  TListNodeType = (Control, PrintIf, Formula);

  TListNode = Class(TObject)
    lnNodeType  : TListNodeType;
    lnFieldCode : ShortString;
    lnFormula   : ShortString;
  End; { TListNode }

  TRecurseCheck = Class(TObject)
  Private
    History    : TList;
    ErrorShown : Boolean;
  Public
    Constructor Create;
    Destructor  Destroy; OverRide;

    Function  FormatFieldCode(Const FieldCode : ShortString) : ShortString;

    Function  StartCheck(Const FieldCode : String) : Boolean;
    Procedure EndCheck(Const FieldCode : String);
    Procedure ClearHistory;
    Procedure SetFormula(Const FType : Byte;Const Fmla : ShortString);

    Procedure RecurseError(Const NewCapt : ShortString);
  End; { TRecurseCheck }

implementation

Uses RecursEr;

{ Creates and Initialises an Instance of the Recursion Checker }
Constructor TRecurseCheck.Create;
Begin
  Inherited Create;

  ErrorShown := False;
  History := TList.Create;
End;

{ Shuts down the Recursion Checker }
Destructor TRecurseCheck.Destroy;
Begin
  { Delete all node info from list }
  If Assigned(History) Then ClearHistory;
  History.Free;

  Inherited Destroy;
End;

{ Adds a Control node to the checking list }
Function TRecurseCheck.StartCheck(Const FieldCode : String) : Boolean;
Var
  ListNode, TmpListNode : TListNode;
  I                     : SmallInt;
Begin
  { Create control node object }
  ListNode := TListNode.Create;
  With ListNode Do Begin
    lnNodeType := Control;
    lnFieldCode := FormatFieldCode(FieldCode);
  End; { With }

  { Check for previous instance of control node }
  Result := True;
  If (History.Count > 0) Then
    For I := Pred(History.Count) DownTo 0 Do Begin
      TmpListNode := TListNode(History.Items[I]);

      If (TmpListNode.lnNodeType = Control) Then
        Result := (TmpListNode.lnFieldCode <> ListNode.lnFieldCode);

      If (Not Result) Then Break;
    End; { For }

  If (Not Result) Then Begin
    { Error - Put your head between your legs and kiss your ass goodbye }
    RecurseError('');
  End { If }
  Else
    { OK - Add into list }
    History.Add (ListNode);
End;

{ Removes a Control node to the checking list }
Procedure TRecurseCheck.EndCheck(Const FieldCode : String);
Var
  ListNode     : TListNode;
  TmpFieldCode : ShortString;
Begin
  { Reformat Field Code }
  TmpFieldCode := FormatFieldCode(FieldCode);

  { Pass backwards through list removing entries until we come to the field }
  While (History.Count > 0) Do Begin
    ListNode := TListNode(History.Items[Pred(History.Count)]);

    With ListNode Do
      If (lnNodeType <> Control) Or (lnFieldCode = TmpFieldCode) Then Begin
        History.Delete (Pred(History.Count));
        ListNode.Destroy;
      End { If }
      Else
        Break;
  End; { While }
End;

{ Removes all History from the checking list }
Procedure TRecurseCheck.ClearHistory;
Var
  ListNode : TListNode;
Begin
  { Called at end of print process for a control }
  If Assigned(History) Then
    While (History.Count > 0) Do Begin
      ListNode := TListNode(History.Items[0]);

      History.Delete (0);
      ListNode.Destroy;
    End; { While }
End;

{ Adds a Formula node into the list }
Procedure TRecurseCheck.SetFormula(Const FType : Byte;Const Fmla : ShortString);
Var
  ListNode : TListNode;
Begin
  { Create control node object }
  ListNode := TListNode.Create;
  With ListNode Do Begin
    Case FType Of
      1 : lnNodeType := PrintIf;
      2 : lnNodeType := Formula;
    End; { Case }
    lnFieldCode := '';
    lnFormula := Fmla;
  End; { With }
  History.Add(ListNode);
End;

{ Displays the Recursion Error dialog }
Procedure TRecurseCheck.RecurseError(Const NewCapt : ShortString);
Var
  FormRecurseErr : TFormRecurseErr;
  ListNode       : TListNode;
  I              : SmallInt;
Begin
  If (Not ErrorShown) Then Begin
    FormRecurseErr := TFormRecurseErr.Create(Application.MainForm);
    Try
      If (Trim(NewCapt) <> '') Then FormRecurseErr.Caption := Trim(NewCapt);

      If (History.Count > 0) Then
        For I := 0 To Pred(History.Count) Do Begin
          ListNode := TListNode(History.Items[I]);

          With ListNode, FormRecurseErr Do
            With ListVw_Controls.Items.Add Do Begin
              Data := Nil;

              Caption := lnFieldCode;
              SubItems.Clear;
              Case lnNodeType Of
                Control    : SubItems.Add('');
                PrintIf    : SubItems.Add('Check Print If');
                Formula    : SubItems.Add('Calculate Formula');
              Else
                SubItems.Add('');
              End; { Case }
              SubItems.Add(lnFormula);
            End; { With }
        End; { For }

      FormRecurseErr.ShowModal;
    Finally
      FormRecurseErr.Free;
    End;
  End; { If }

  ErrorShown := True;
End;

{ Reformats the FieldCode to trimmed uppercase }
Function TRecurseCheck.FormatFieldCode(Const FieldCode : ShortString) : ShortString;
Begin
  Result := UpperCase(Trim(FieldCode));
End;

end.
