unit WinMan;

(*
Window Manager Unit for Enterprise Customisation DLL
====================================================
This unit is used to store a list of all MDI Child type windows created
within the customisation hooks or menu customisation. When Enterprise
is closed the CloseCustomMenus function is called which in turn calls
the WinMan_CloseAllForms function. This then goes through the array and
closes and de-allocates all the forms, each form will process the
OnCloseQuery and OnDestroy events, the OnClose event is not called.
*)


interface

Uses Classes, Dialogs, Forms, Messages, SysUtils, Windows;


{ Called to register a form with the Window Manager }
Procedure WinMan_RegisterForm (TheForm : TForm);

{ Removes a registered from from the Window Manager }
Procedure WinMan_UnRegisterForm (Const FormHandle : HWnd);

{ Closes all Registered Forms }
Procedure WinMan_CloseAllForms;


implementation

Var
  FormsList  : TList;    { Stores a list of forms created within the customisation }
  ListLocked : Boolean;  { Controls write access to the list }


{ Called to register a form with the Window Manager }
Procedure WinMan_RegisterForm (TheForm : TForm);
Begin
(*
  If Assigned (FormsList) Then Begin
    { Wait until list is available }
    While ListLocked Do Application.ProcessMessages;

    { Add new form into list }
    ListLocked := True;
    FormsList.Add (TheForm);
    ListLocked := False;
  End; { If }
*)
End;


{ Removes a registered from from the Window Manager }
Procedure WinMan_UnRegisterForm (Const FormHandle : HWnd);
Var
  TmpForm : TForm;
  I       : Integer;
  GotIt   : Boolean;
Begin
(*
  If Assigned (FormsList) Then Begin
    { Check if it is in the list }
    GotIt := False;
    If (FormsList.Count > 0) Then
      For I := 0 To Pred(FormsList.Count) Do Begin
        { Get local handle to form }
        TmpForm := FormsList.Items[I];

        { Check to see if it the one we want }
        GotIt := (TmpForm.Handle = FormHandle);

        { Exit loop if it is }
        If GotIt Then Break;
      End; { For }

    If GotIt Then Begin
      { have to remove from list - Wait until list is available }
      While ListLocked Do Application.ProcessMessages;

      ListLocked := True;
      If (FormsList.Count > 0) Then
        For I := 0 To Pred(FormsList.Count) Do Begin
          TmpForm := FormsList.Items[I];

          If (TmpForm.Handle = FormHandle) Then Begin
            { Found specified form - Delete instance from list }
            FormsList.Delete(I);
            Break;
          End; { If }
        End; { For }
      ListLocked := False;
    End; { If }
  End; { If }
*)
End;


{ Closes all Registered Forms }
Procedure WinMan_CloseAllForms;
Var
  PrevForm : TForm;
  I        : Integer;
  Action   : TCloseAction;
Begin
(*
  { Wait until list is available }
  While ListLocked Do Application.ProcessMessages;

  { Free all the preview windows }
  ListLocked := True;
  While (FormsList.Count > 0) Do Begin
    Try
      PrevForm := FormsList.Items[0];

      FormsList.Delete(0);

      { Close and de-allocate form }
      PrevForm.Close;
      PrevForm.Free;
    Except
      { hide all errors }
    End;
  End; { While }
  ListLocked := False;
*)
End;


Initialization
  {ListLocked := True;
  FormsList := TList.Create;
  ListLocked := False;}
Finalization
  {If Assigned (FormsList) Then Begin
    FormsList.Free;
    FormsList := Nil;
  End; { If }
end.
