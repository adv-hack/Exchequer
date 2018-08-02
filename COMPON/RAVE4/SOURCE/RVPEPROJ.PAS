{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPEProj;

interface

  procedure RaveRegister;

implementation

uses
  Classes, Dialogs, SysUtils, RVClass, RVTool, RVProj, Windows, RVDefine,
  RPDefine, RVSecurity, RVPESys;

type
  TRaveCategoryPropertyEditor = class(TRaveStringPropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
  public
    procedure GetValues(ValueList: TStrings); override;
  end; { TRaveCategoryPropertyEditor }

  TRavePagePropertyEditor = class(TRaveComponentPropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    function GetValue: string; override;
    procedure SetValue(Value: string); override;
  public
    procedure GetValues(ValueList: TStrings); override;
  end; { TRavePagePropertyEditor }

  TRaveSecurityPropertyEditor = class(TRaveComponentPropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    function GetValue: string; override;
    procedure SetValue(Value: string); override;
  public
    procedure GetValues(ValueList: TStrings); override;
  end; { TRaveSecurityPropertyEditor }

  TRavePaperSizePropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    procedure SetValue(Value: string); override;
    function GetValue: string; override;
  public
    procedure GetValues(ValueList: TStrings); override;
  end; { TRavePaperSizePropertyEditor }

  TRaveBinPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    procedure SetValue(Value: string); override;
    function GetValue: string; override;
  public
    procedure GetValues(ValueList: TStrings); override;
  end; { TRaveBinPropertyEditor }

  procedure RaveRegister;

  begin { RaveRegister }
  {TransOff}
    RegisterRavePropertyEditor(TypeInfo(string),TRaveReport,'Category',
     TRaveCategoryPropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(TRavePage),TRaveReport,'FirstPage',
     TRavePagePropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(TRavePaperSize),nil,'PaperSize',
     TRavePaperSizePropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(TRaveBin),nil,'Bin',
     TRaveBinPropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(TRaveBaseSecurity),nil,'SecurityControl',
     TRaveSecurityPropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(string),TRaveProjectManager,'AdminPassword',
     TRavePasswordPropertyEditor);
  {TransOn}
  end;  { RaveRegister }

(*****************************************************************************}
( class TRaveCategoryPropertyEditor
(*****************************************************************************)

  function TRaveCategoryPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poListing];
  end;  { GetOptions }

  procedure TRaveCategoryPropertyEditor.GetValues(ValueList: TStrings);

  begin { GetValues }
    ValueList.Clear;
    ValueList.Assign(ProjectManager.Categories);
  end;  { GetValues }

(*****************************************************************************}
( class TRavePagePropertyEditor
(*****************************************************************************)

  function TRavePagePropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poListing];
  end;  { GetOptions }

  procedure TRavePagePropertyEditor.GetValues(ValueList: TStrings);

  var
    I1: integer;

  begin { GetValues }
    ValueList.Clear;
  { Get list of pages used by this report }
    With Instance[0] as TRaveReport do begin
      For I1 := 0 to ChildCount - 1 do begin
        If Child[I1] is TRavePage then begin
          ValueList.Add(TRavePage(Child[I1]).Name);
        end; { if }
      end; { for }
    end; { with }
  end;  { GetValues }

  function TRavePagePropertyEditor.GetValue: string;

  begin { GetValue }
    If GetOrdValue(0) = 0 then begin
      Result := '';
    end else begin
      Result := TRavePage(GetOrdValue(0)).Name;
    end; { else }
  end;  { GetValue }

  procedure TRavePagePropertyEditor.SetValue(Value: string);

  var
    Value1: TRaveComponent;
    I1: integer;

  begin { SetValue }
    Value1 := nil;
    If Value <> '' then begin
      With Instance[0] as TRaveReport do begin
        For I1 := 0 to ChildCount - 1 do begin
          If (Child[I1] is TRavePage) and (CompareText(TRavePage(Child[I1]).
           Name,Value) = 0) then begin
            Value1 := TRavePage(Child[I1]);
          end; { if }
        end; { for }
      end; { with }
      If not Assigned(Value1) then begin
        MessageDlg(Trans(Format({Trans+}'"%s" is not a valid entry.',[Value])),
         mtError,[mbOk],0);
        Exit;
      end; { else }
    end; { if }
    SetOrdValue(longint(Value1));
  end;  { SetValue }

(*****************************************************************************}
( class TRaveSecurityPropertyEditor
(*****************************************************************************)

  function TRaveSecurityPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poListing];
  end;  { GetOptions }

  procedure TRaveSecurityPropertyEditor.GetValues(ValueList: TStrings);

  var
    I1: integer;
    DataObjList: TList;

  begin { GetValues }
    ValueList.Clear;
  { Get list of pages used by this report }
    DataObjList := TRaveProjectManager(Instance[0].Project).DataObjectList;
    For I1 := 0 to DataObjList.Count - 1 do begin
      If TObject(DataObjList[I1]) is TRaveBaseSecurity then begin
        ValueList.Add(TRaveBaseSecurity(DataObjList[I1]).Name);
      end; { if }
    end; { for }
  end;  { GetValues }

  function TRaveSecurityPropertyEditor.GetValue: string;

  begin { GetValue }
    If GetOrdValue(0) = 0 then begin
      Result := '';
    end else begin
      Result := TRaveBaseSecurity(GetOrdValue(0)).Name;
    end; { else }
  end;  { GetValue }

  procedure TRaveSecurityPropertyEditor.SetValue(Value: string);

  var
    Value1: TRaveComponent;
    I1: integer;
    DataObjList: TList;

  begin { SetValue }
    Value1 := nil;
    If Value <> '' then begin
      DataObjList := TRaveProjectManager(Instance[0].Project).DataObjectList;
      For I1 := 0 to DataObjList.Count - 1 do begin
        If (TObject(DataObjList[I1]) is TRaveBaseSecurity) and
         AnsiSameText(TRaveBaseSecurity(DataObjList[I1]).Name,Value) then begin
          Value1 := TRaveBaseSecurity(DataObjList[I1]);
        end; { if }
      end; { for }
      If not Assigned(Value1) then begin
        MessageDlg(Trans(Format({Trans+}'"%s" is not a valid entry.',[Value])),
         mtError,[mbOk],0);
        Exit;
      end; { else }
    end; { if }
    SetOrdValue(longint(Value1));
  end;  { SetValue }

(*****************************************************************************}
( class TRavePaperSizePropertyEditor
(*****************************************************************************)

  function TRavePaperSizePropertyEditor.GetOptions: TPropertyOptionsSet;

  begin
    Result := [poMultiSelect,poListing,poNoSort,poReadOnly];
  end;

  function TRavePaperSizePropertyEditor.GetValue: string;

  var
    I1: integer;
    I2: integer;

  begin { GetValue }
    Result := '';
    I1 := 1;
    I2 := GetOrdValue(0);
    While I1 <= PaperSizeNameCnt do begin
      If PaperSizeName[I1].PaperSize = I2 then begin
        Result := PaperSizeName[I1].Name;
        Break;
      end; { if }
      Inc(I1);
    end; { while }
  end;  { GetValue }

  procedure TRavePaperSizePropertyEditor.GetValues(ValueList: TStrings);

  var
    I1: integer;

  begin { GetValues }
    ValueList.Clear;
    For I1 := 1 to PaperSizeNameCnt do begin
      ValueList.Add(PaperSizeName[I1].Name);
    end; { for }
  end;  { GetValues }

  procedure TRavePaperSizePropertyEditor.SetValue(Value: string);

  var
    I1: integer;

  begin { SetValue }
    I1 := 1;
    While I1 <= PaperSizeNameCnt do begin
      If CompareText(Value,PaperSizeName[I1].Name) = 0 then begin
        SetOrdValue(PaperSizeName[I1].PaperSize);
        Exit;
      end; { if }
      Inc(I1);
    end; { while }
  end;  { SetValue }

(*****************************************************************************}
( class TRaveBinPropertyEditor
(*****************************************************************************)

  function TRaveBinPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poMultiSelect,poListing,poNoSort,poReadOnly];
  end;  { GetOptions }

  function TRaveBinPropertyEditor.GetValue: string;

  var
    I1: integer;
    I2: integer;

  begin { GetValue }
    Result := '';
    I1 := 1;
    I2 := GetOrdValue(0);
    While I1 <= RaveBinNameCnt do begin
      If RaveBinName[I1].RaveBin = I2 then begin
        Result := RaveBinName[I1].Name;
        Break;
      end; { if }
      Inc(I1);
    end; { while }
  end;  { GetValue }

  procedure TRaveBinPropertyEditor.GetValues(ValueList: TStrings);

  var
    I1: integer;

  begin { GetValues }
    ValueList.Clear;
    For I1 := 1 to RaveBinNameCnt do begin
      ValueList.Add(RaveBinName[I1].Name);
    end; { for }
  end;  { GetValues }

  procedure TRaveBinPropertyEditor.SetValue(Value: string);

  var
    I1: integer;

  begin { SetValue }
    I1 := 1;
    While I1 <= RaveBinNameCnt do begin
      If CompareText(Value,RaveBinName[I1].Name) = 0 then begin
        SetOrdValue(RaveBinName[I1].RaveBin);
        Exit;
      end; { if }
      Inc(I1);
    end; { while }
  end;  { SetValue }

initialization
  RegisterProc('RVCL',RaveRegister);
end.
