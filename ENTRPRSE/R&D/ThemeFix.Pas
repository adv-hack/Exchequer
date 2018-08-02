Unit ThemeFix;

Interface

Uses Forms, ThemeMgr;

// MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
Procedure ApplyThemeFix (FixForm : TForm);

Implementation

Procedure ApplyThemeFix (FixForm : TForm);
Var
  ThemeManager : TThemeManager;
Begin // ApplyThemeFix
  // Theming should already be fixed for windows owned by the MainForm, so filter those out
  // as Theming a window twice might have side effects
  If (FixForm.Owner <> Application.MainForm) Then
  Begin
    // Dynamically find the ThemeManager component on EParentU - to reference EParentU in the
    // Uses clause causes the load order to break things - User Count Security for example...
    ThemeManager := Application.MainForm.FindComponent('ThemeManager1') As TThemeManager;
    If Assigned(ThemeManager) Then
      ThemeManager.CollectForms(FixForm);
  End; // If (FixForm.Owner <> Application.MainForm)
End; // ApplyThemeFix

End.