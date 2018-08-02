unit GlobExcH;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;


{ Global Exception Handler for reporting problems during setup }
Procedure GlobExceptHandler (Var Ex : Exception; Const AddInfo : ShortString = '');

implementation

{ Global Exception Handler for reporting problems during setup }
Procedure GlobExceptHandler (Var Ex : Exception; Const AddInfo : ShortString = '');
Begin { GlobExceptHandler }

  MessageDlg ('The following exception occured during the setup:' + #13#13 +
              Trim(Ex.Message + ' ' + AddInfo) + #13#13 + 'Please contact your Technical Support',
              mtError, [mbOk], 0);

End; { GlobExceptHandler }

end.
