unit CustomU;

{ Menu Customisation Unit - Allows standard Exchequer menus to be modified }

interface

Uses Forms, Menus;

Type

  {$I CustMenu.Pas }

Procedure CustomMenus (EntInfo : ptrEntCustomInfo); Export;
Procedure CloseCustomMenus; Export;

implementation

Var
  OldApp      : TApplication;

{ Called by the FormCreate of the applications main form }
Procedure CustomMenus (EntInfo : ptrEntCustomInfo);
Begin
  { link in to the EXE's application instance }
  OldApp := Application;
  Application := EntInfo^.AppInst;

  { Customise menus here }

End;

{ Called by Exchequer during shutdown }
Procedure CloseCustomMenus;
Begin

  { Deallocate memory here }

  If Assigned (OldApp) Then Begin
    Application := OldApp;
    OldApp := Nil;
  End; { If }
End;


Initialization
  OldApp := Nil;
end.
