{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPReg;

{$I RPVER.PAS}

interface

uses
  WinProcs,
  DB,
  Forms,
  Controls,
  Classes,
{$IFDEF LEVEL6}
  DesignIntf,
  DesignEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF}
  Dialogs,
  SysUtils,
  TypInfo,
  Registry,
  ShellAPI,
  RPSecFrm,
  RPCEdFrm,
  RPDefine,
  RPBase,
  RPCanvas,
  RPFiler,
  RPrinter,
  RPFPrint,
  RPreview,
  RPSystem,
  RPShell,
  RPLabel,
  RPTable,
  RPDBTabl,
  RPMemo,
  RPBars,
  RPDBUtil,
  RPSect,
  RVDefine,
  RVUtil,
  RPCon,
  RPConDS,
  RPConBDE,
  RPRave,
  RPExeFrm,
  RPRTFilr,
  RPHTFilr,
  RPTxFilr,
  RPRender_PDF,
  RPRender_HTML;

type
{*************************************************************************}
{                           class TColumnEditor                           }
{*************************************************************************}
  TColumnEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: integer); override;
    function GetVerb(Index: integer): string; override;
    function GetVerbCount: integer; override;
  end; { TColumnEditor }

{*************************************************************************}
{                        class TReportSectionProperty                     }
{*************************************************************************}
  TReportSectionProperty = class(TClassProperty)
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end; { TReportSectionProperty }

{*************************************************************************}
{                        class TReportShellProperty                       }
{*************************************************************************}
  TReportShellProperty = class(TComponentProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end; { TReportShellProperty }

{*************************************************************************}
{                        class TTablePrinterProperty                      }
{*************************************************************************}
  TTablePrinterProperty = class(TComponentProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end; { TTablePrinterProperty }

{*************************************************************************}
{                        class TReportEngineProperty                      }
{*************************************************************************}
  TReportEngineProperty = class(TComponentProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end; { TReportEngineProperty }

{*************************************************************************}
{                        class TFieldNameProperty                         }
{*************************************************************************}
  TFieldNameProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end; { TFieldNameProperty }

{*************************************************************************}
{                        class TMasterKeyProperty                         }
{*************************************************************************}
  TMasterKeyProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end; { TMasterKeyProperty }

{*************************************************************************}
{                           class TRaveProjectEditor                      }
{*************************************************************************}
  TRaveProjectEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: integer); override;
    function GetVerb(Index: integer): string; override;
    function GetVerbCount: integer; override;
  end; { TRaveProjectEditor }

{*************************************************************************}
{                        class TRaveProjectFileProperty                   }
{*************************************************************************}
  TRaveProjectFileProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end; { TRaveProjectFileProperty }

{*************************************************************************}
{                        class TRaveStoreRAVProperty                      }
{*************************************************************************}
  TRaveStoreRAVProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end; { TRaveStoreRAVProperty }

  procedure Register;

implementation

{$R RPREG.DCR}

{*************************************************************************}
{                           class TColumnEditor                           }
{*************************************************************************}

  procedure TColumnEditor.ExecuteVerb(Index: integer);

  begin { ExecuteVerb }
    ColumnEditor(Designer,Component as TTablePrinter);
  end;  { ExecuteVerb }

  function TColumnEditor.GetVerb(Index: integer): string;

  begin { GetVerb }
    Result := 'Table &Editor...';
  end;  { GetVerb }

  function TColumnEditor.GetVerbCount: integer;

  begin { GetVerbCount }
    Result := 1;
  end;  { GetVerbCount }

{*************************************************************************}
{                           class TRaveProjectEditor                      }
{*************************************************************************}

  procedure TRaveProjectEditor.ExecuteVerb(Index: integer);

  var
    DesignerPath: string;
    TempStr: string[1];

  begin { ExecuteVerb }
  { Get designer DLL filename }
    With TRegistry.Create do try
      With Component as TRaveProject do begin
        If ProjectFile <> '' then begin
          RootKey := HKEY_CURRENT_USER;
          If OpenKey(RegRoot,true) then begin
            WriteString('ActiveProject',ProjectFile);
          end; { if }
        end; { if }
      end;

      RootKey := HKEY_LOCAL_MACHINE;
      If OpenKey(RegRoot,true) then begin
        If ValueExists('DesignerPath') then begin
          DesignerPath := ReadString('DesignerPath') + '\RAVE.EXE' + #0;
        end else begin
          DesignerPath := 'C:\RPPRO3\RAVE.EXE' + #0;
        end; { else }
      end; { if }
    finally
      Free;
    end; { with }
    TempStr := #0;
    ShellExecute(0,nil,@DesignerPath[1],@TempStr[1],@TempStr[1],SW_SHOWMAXIMIZED);
  end;  { ExecuteVerb }

  function TRaveProjectEditor.GetVerb(Index: integer): string;

  begin { GetVerb }
    Result := 'Rave Visual &Designer...';
  end;  { GetVerb }

  function TRaveProjectEditor.GetVerbCount: integer;

  begin { GetVerbCount }
    Result := 1;
  end;  { GetVerbCount }

{*************************************************************************}
{                        class TRaveProjectFileProperty                   }
{*************************************************************************}

  function TRaveProjectFileProperty.GetAttributes: TPropertyAttributes;

  begin { GetAttributes }
    Result := [paDialog, paMultiSelect];
  end;  { GetAttributes }

  procedure TRaveProjectFileProperty.Edit;

  begin { Edit }
    With TOpenDialog.Create(Application) do try
      FileName := GetValue;
      Title := 'Select Rave Project File';
      Filter := 'Rave Project (*.rav)|*.rav';
      If Execute then begin
        SetValue(FileName);
        ShowOptionalDialog(nil,'WARNING',
        'The full path has been saved with the ProjectFile property.'#13 +
        'This may cause problems if your application''s project file'#13 +
        'is not deployed to this exact same location.','WarningProjectFileName');
      end; { if }
    finally
      Free;
    end; { with }
  end;  { Edit }

{*************************************************************************}
{                        class TRaveStoreRAVProperty                      }
{*************************************************************************}

  function TRaveStoreRAVProperty.GetAttributes: TPropertyAttributes;

  begin { GetAttributes }
    Result := [paDialog,paReadOnly];
  end;  { GetAttributes }

  function TRaveStoreRAVProperty.GetValue: string;

  begin { GetValue }
    With (GetComponent(0) as TRaveProject) do begin
      If RaveBlobDateTime < 1.0 then begin { Check for 0 value w/ buffer }
        Result := '(none)';
      end else begin
        Result := FormatDateTime('ddddd t',RaveBlobDateTime);
      end; { else }
    end; { with }
  end;  { GetValue }

  procedure TRaveStoreRAVProperty.Edit;

  begin { Edit }
    With TExeForm.Create(Application) do try
      RaveProject := (GetComponent(0) as TRaveProject);
      ShowModal;
      If RaveProjectModified then begin
        Modified;
      end; { if }
    finally
      Free;
    end; { with }
  end;  { Edit }

{*************************************************************************}
{                        class TReportSectionProperty                     }
{*************************************************************************}

  procedure TReportSectionProperty.Edit;

  var
    ReportSectionForm: TSectionEditForm;
    I1: integer;

  begin { Edit }
    ReportSectionForm := TSectionEditForm.Create(Application);
    With ReportSectionForm do begin
      try
        RS.Assign(TReportSection(GetOrdValue));
        Caption := 'Section Editor (' + TComponent(GetComponent(0)).Name + '.' +
         GetName + ')';
        ShowModal;
        If SaveSettings then begin
          For I1 := 0 to PropCount - 1 do begin
            TReportSection(GetOrdValueAt(I1)).Assign(RS);
          end; { for }
          Modified;
        end; { if }
      finally
        Free;
      end; { tryf }
    end; { with }
  end;  { Edit }

  function TReportSectionProperty.GetAttributes: TPropertyAttributes;

  begin { GetAttributes }
    Result := [paMultiSelect,paSubProperties,paDialog];
  end;  { GetAttributes }

{*************************************************************************}
{                        class TReportShellProperty                       }
{*************************************************************************}

  function TReportShellProperty.GetAttributes: TPropertyAttributes;

  begin { GetAttributes }
    Result := [paValueList,paSortList];
  end;  { GetAttributes }

  procedure TReportShellProperty.GetValues(Proc: TGetStrProc);

  var
    I1: integer;
    Component: TComponent;

  begin { GetValues }
    For I1 := 0 to Designer.GetRoot.ComponentCount - 1 do begin
      Component := Designer.GetRoot.Components[I1];
      If (Component is TDetailShell) and not (Component is TReportShell) and
       (Component <> GetComponent(0)) then begin
        Proc(Component.Name);
      end; { if }
    end; { for }
  end;  { GetValues }

{*************************************************************************}
{                        class TTablePrinterProperty                      }
{*************************************************************************}

  function TTablePrinterProperty.GetAttributes: TPropertyAttributes;

  begin { GetAttributes }
    Result := [paValueList,paSortList];
  end;  { GetAttributes }

  procedure TTablePrinterProperty.GetValues(Proc: TGetStrProc);

  var
    I1: integer;
    Component: TComponent;

  begin { GetValues }
    For I1 := 0 to Designer.GetRoot.ComponentCount - 1 do begin
      Component := Designer.GetRoot.Components[I1];
      If (Component is TTablePrinter) and (Component <> GetComponent(0)) then begin
        Proc(Component.Name);
      end; { if }
    end; { for }
  end;  { GetValues }

{*************************************************************************}
{                        class TReportEngineProperty                      }
{*************************************************************************}

  function TReportEngineProperty.GetAttributes: TPropertyAttributes;

  begin { GetAttributes }
    Result := [paValueList,paSortList];
  end;  { GetAttributes }

  procedure TReportEngineProperty.GetValues(Proc: TGetStrProc);

  var
    I1: integer;
    Component: TComponent;

  begin { GetValues }
    For I1 := 0 to Designer.GetRoot.ComponentCount - 1 do begin
      Component := Designer.GetRoot.Components[I1];
      If (Component is TReportSystem) or (Component is TReportPrinter) or
       (Component is TReportFiler) or (Component is TRTFFiler) or
       (Component is TTextFiler) or (Component is TRPHTMLFiler) then begin
        Proc(Component.Name);
      end; { if }
    end; { for }
  end;  { GetValues }

{*************************************************************************}
{                        class TFieldNameProperty                         }
{*************************************************************************}

  procedure LoadFieldNames(Proc: TGetStrProc;
                           DataSet: TDataSet);

  var
    I1: integer;
    FieldNames: TStrings;

  begin { LoadFieldNames }
    If Assigned(DataSet) then begin
      FieldNames := TStringList.Create;
      try
        DataSet.GetFieldNames(FieldNames);
        For I1 := 1 to FieldNames.Count do begin
          Proc(FieldNames[I1 - 1]);
        end; { for }
      finally
        FieldNames.Free;
      end; { tryf }
    end; { if }
  end;  { LoadFieldNames }

  function TFieldNameProperty.GetAttributes: TPropertyAttributes;

  begin { GetAttributes }
    Result := [paValueList,paSortList];
  end;  { GetAttributes }

  procedure TFieldNameProperty.GetValues(Proc: TGetStrProc);

  begin { GetValues }
    If GetComponent(0) is TDBTableColumn then begin
      If Pos('Lookup',GetName) <> 0 then begin
        LoadFieldNames(Proc,(GetComponent(0) as TDBTableColumn).LookupDataSet);
      end else begin
        LoadFieldNames(Proc,((GetComponent(0) as TDBTableColumn).TablePrinter as
         TDBTablePrinter).DataSet);
      end; { else }
    end else if GetComponent(0) is TDBTablePrinter then begin
      LoadFieldNames(Proc,(GetComponent(0) as TDBTablePrinter).DataSet);
    end; { else }
  end;  { GetValues }

{*************************************************************************}
{                         class TMasterKeyProperty                        }
{*************************************************************************}

  function TMasterKeyProperty.GetAttributes: TPropertyAttributes;

  begin { GetAttributes }
    Result := [paValueList,paSortList];
  end;  { GetAttributes }

  procedure TMasterKeyProperty.GetValues(Proc: TGetStrProc);

  var
    I1: integer;
    Component: TComponent;

  begin { GetValues }
    For I1 := 0 to Designer.GetRoot.ComponentCount - 1 do begin
      Component := Designer.GetRoot.Components[I1];
      If (Component is TDBTablePrinter) then begin
        With Component as TDBTablePrinter do begin
          If DetailTablePrinter = GetComponent(0) then begin
            LoadFieldNames(Proc,DataSet);
            Exit;
          end; { if }
        end; { if }
      end; { if }
    end; { for }
  end;  { GetValues }

  procedure Register;

  begin { Register }
    RegisterPropertyEditor(TypeInfo(TReportSection),nil,'',TReportSectionProperty);
    RegisterPropertyEditor(TypeInfo(TDetailShell),nil,'',TReportShellProperty);
    RegisterPropertyEditor(TypeInfo(TBaseShell),TTablePrinter,'DetailTablePrinter',
     TTablePrinterProperty);
    RegisterPropertyEditor(TypeInfo(TRPComponent),TBaseShell,'Engine',
     TReportEngineProperty);
    RegisterPropertyEditor(TypeInfo(TFieldName),TDBTableColumn,'FieldName',
     TFieldNameProperty);
    RegisterPropertyEditor(TypeInfo(TFieldName),TDBTableColumn,'LookupDisplay',
     TFieldNameProperty);
    RegisterPropertyEditor(TypeInfo(TFieldName),TDBTableColumn,'LookupKey',
     TFieldNameProperty);
    RegisterPropertyEditor(TypeInfo(TFieldName),TDBTablePrinter,'DetailKey',
     TFieldNameProperty);
    RegisterPropertyEditor(TypeInfo(TFieldName),TDBTablePrinter,'MasterKey',
     TMasterKeyProperty);

    RegisterClass(TTableColumn);
    RegisterClass(TDBTableColumn);
    RegisterClass(TTableSection);
    RegisterNoIcon([TTableColumn,TDBTableColumn,TTableSection]);
    RegisterComponentEditor(TTablePrinter,TColumnEditor);

    RegisterPropertyEditor(TypeInfo(string),TRaveProject,'ProjectFile',
     TRaveProjectFileProperty);
    RegisterPropertyEditor(TypeInfo(boolean),TRaveProject,'StoreRAV',
     TRaveStoreRAVProperty);
    RegisterPropertyEditor(TypeInfo(TRPComponent),TRaveProject,'Engine',
     TReportEngineProperty);
    RegisterComponentEditor(TRaveProject,TRaveProjectEditor);

    RegisterComponents('Report',[TReportPrinter,TReportFiler,TFilePrinter,
     TFilePreview,TReportSystem,TDetailShell,TMasterShell,TReportShell,
     TLabelShell,TDBTablePrinter,TTablePrinter,TRTFFiler,TRPHTMLFiler,TTextFiler,
     TRPCustomConnection,TRPDataSetConnection,TRPTableConnection,
     TRPQueryConnection,TRaveProject,TRPRenderPDF,TRPRenderHTML]);
  end;  { Register }


end.