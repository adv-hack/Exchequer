{-----------------------------------------------------------------------------
 Unit Name: uDBUpdate
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDBUpdate;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvGlowButton, ExtCtrls, AdvPanel, StdCtrls, AdvEdit, AdvEdBtn,
  AdvFileNameEdit, DB, ADODB;

Type
  TfrmDBUpdate = Class(TForm)
    advPanel: TAdvPanel;
    btnOk: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    edtSql: TAdvFileNameEdit;
    ADOCon: TADOConnection;
    adoCommand: TADOCommand;
    Procedure btnCancelClick(Sender: TObject);
    Procedure btnOkClick(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
  Private
  Public
  End;

Var
  frmDBUpdate: TfrmDBUpdate;

Implementation

Uses uCommon;

{$R *.dfm}

Procedure TfrmDBUpdate.btnCancelClick(Sender: TObject);
Begin
  Close;
End;

Procedure TfrmDBUpdate.btnOkClick(Sender: TObject);
const
  cADOCONNECTION =
  // 08/07/2013.  PKR.  Changed during rebranding.
//    'Data Source=%s\IRISSOFTWARE;Provider=SQLOLEDB.1;Persist Security Info=True;';
    'Data Source=%s\EXCHEQUER;Provider=SQLOLEDB.1;Persist Security Info=True;';

Var
  lStr: TStringlist;
Begin
  If (edtSql.Text <> '') or (_FileSize(edtSql.Text) = 0) Then
  Begin
    If ADOCon.Connected Then
      ADOCon.Close;

    ADOCon.ConnectionString := Format(cADOCONNECTION, [_GetComputerName]);
    Try
      ADOCon.Open;
    Except
      On E: exception Do
        MessageDlg('An exception has occurred:' + #13#13 + E.Message, mtError,
          [mbok], 0);
    End; {try}

    If ADOCon.Connected Then
    Begin
      lStr := TStringlist.Create;
      lStr.LoadFromFile(edtSql.Text);
      if lStr.Count > 0 then
      begin
        adoCommand.CommandText := lStr.Text;
        try
          adoCommand.Execute;
        except
          On E: exception Do
            MessageDlg('An exception has occurred:' + #13#13 + E.Message, mtError,
              [mbok], 0);
        end;
      end; {if lStr.Count > 0 then}

      lStr.Free;
    End; {if ADOCon.Connected then}
  End
  else
    MessageDlg('Invalid filename or file does not exist.!', mtError, [mbok], 0);
End;

Procedure TfrmDBUpdate.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  AdoCon.Close;
End;

End.

