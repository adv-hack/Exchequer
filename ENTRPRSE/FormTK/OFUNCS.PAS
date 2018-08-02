unit oFuncs;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB;

type
  TEFFunctions = class(TAutoIntfObject, IEFFunctions)
  private
  protected
    // IEFFunctions
    function fnPadString(const StrKey: WideString; PadLen: Integer): WideString; safecall;
    function fnIntegerKey(IntVal: Integer): WideString; safecall;
    procedure fnDeleteTempFiles; safecall;
    function fnGetFormInfo(const FormName: WideString): IEFFormDefInfo; safecall;

    // Local methods
  public
    Constructor Create;
  End; { TEFFunctions }

implementation

uses ComServ, ETStrU, ETMiscU,
     BtKeys1U,    // Exchequer routines for building Search Keys
     oFormInf,    // Form Info object for fnGetFormInfo  (IEFFormDefInfo)
     DelTemp;     // Delete List for temporary files

//-----------------------------------------------------------------------------

Constructor TEFFunctions.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, IEFFunctions);
End; { Create }

//-----------------------------------------------------------------------------

function TEFFunctions.fnIntegerKey(IntVal: Integer): WideString;
begin
  Result := FullNomKey(IntVal);
end;

//-----------------------------------------------------------------------------

function TEFFunctions.fnPadString(const StrKey: WideString; PadLen: Integer): WideString;
begin
  Result := LJVar(StrKey, PadLen);
end;

//-----------------------------------------------------------------------------

procedure TEFFunctions.fnDeleteTempFiles;
begin
  // Delete any temporary files listed in the file list
  ClearDelList;
end;

//-----------------------------------------------------------------------------

function TEFFunctions.fnGetFormInfo(const FormName: WideString): IEFFormDefInfo;
begin
  Result := TEFFormDefInfo.Create (FormName);
end;

//-----------------------------------------------------------------------------

end.
