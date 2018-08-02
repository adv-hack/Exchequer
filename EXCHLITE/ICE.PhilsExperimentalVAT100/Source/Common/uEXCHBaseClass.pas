{-----------------------------------------------------------------------------
 Unit Name: uEXCHBaseClass
 Author:    vmoura
 Purpose:
 History:

   Base class to exchequer dll functionalities.

   Descend from this class if you need to access the DLL Toolkit.
-----------------------------------------------------------------------------}

Unit uEXCHBaseClass;

Interface

Uses Classes, Windows, Sysutils,
{  USEDLLU, }
  uConsts, uBaseClass;

{$I ice.inc}

Type
  _EXCH = Class(_Base)
  Private
  Protected
//    Function InitDll(const pCompPath: String): Boolean; Virtual;
//    Function CloseDll: Boolean; Virtual;
  Public
    Constructor Create; Reintroduce;
  Published
  End;

implementation

{ _EXCH }

(*
{-----------------------------------------------------------------------------
  Procedure: CloseDll
  Author:    vmoura
  Arguments: None
  Result:    Boolean
-----------------------------------------------------------------------------}
Function _EXCH.CloseDll: Boolean;
Begin
  Result := EX_CLOSEDLL = 0;
End;
*)
Constructor _EXCH.Create;
Begin
  Inherited Create;
End;

{-----------------------------------------------------------------------------
  Procedure: InitDll
  Author:    vmoura
  Arguments: None
  Result:    Boolean
-----------------------------------------------------------------------------}
(*
function _EXCH.InitDll(const pCompPath: String): Boolean;
var
  lRes: Smallint;
begin
  // Try to initialize the DLL data path
  lRes := EX_INITDLLPATH(pChar(pCompPath), True);

  If lRes = 0 Then
  begin
    lRes := EX_INITDLL;
    If lRes <> 0 Then
      DoLogMessage('_EXCH.InitDll', cEXCHLOADINGDLLERROR, 'Error: ' +
        inttostr(lRes));

    Result := lRes = 0;
  end
  Else
  Begin
    Result := False;
    DoLogMessage('_EXCH.InitDll', 0, 'Error Initdllpath: ' + inttostr(lRes))
  End;
End;
*)
End.

