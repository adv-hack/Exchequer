{*********************************************************}
{                                                         }
{       Borland Delphi Visual Component Library           }
{                                                         }
{       Copyright (c) 1995, 2001-2002 Borland Corporation }
{                                                         }
{*********************************************************}
unit ShellReg2005 platform;

interface

{$WARN UNIT_PLATFORM OFF}

procedure Register;

implementation

uses Classes, TypInfo, Controls, DesignIntf, ShellCtrls2005, ShellConsts2005, RootEdit2005;

procedure Register;
begin
//  GroupDescendentsWith(TShellChangeNotifier, Controls.TControl);
//  RegisterComponents(SPalletePage, [TShellTreeView, TShellComboBox, TShellListView, TShellChangeNotifier]);
//  RegisterPropertyEditor(TypeInfo(TRoot), TShellTreeView, SPropertyName, TRootProperty);
//  RegisterPropertyEditor(TypeInfo(TRoot), TShellComboBox, SPropertyName, TRootProperty);
//  RegisterPropertyEditor(TypeInfo(TRoot), TShellListView, SPropertyName, TRootProperty);
//  RegisterPropertyEditor(TypeInfo(TRoot), TShellChangeNotifier, SPropertyName, TRootProperty);
//  RegisterComponentEditor(TShellTreeView, TRootEditor);
//  RegisterComponentEditor(TShellListView, TRootEditor);
//  RegisterComponentEditor(TShellComboBox, TRootEditor);
//  RegisterComponentEditor(TShellChangeNotifier, TRootEditor);

  RegisterComponents('SBS', [TShellTreeView2005, TShellComboBox2005]);
  RegisterPropertyEditor(TypeInfo(TRoot2005), TShellTreeView2005, SPropertyName, TRootProperty2005);
  RegisterComponentEditor(TShellTreeView2005, TRootEditor2005);

  RegisterPropertyEditor(TypeInfo(TRoot2005), TShellComboBox2005, SPropertyName, TRootProperty2005);
  RegisterComponentEditor(TShellComboBox2005, TRootEditor2005);
end;

end.
