{-----------------------------------------------------------------------------
 Unit Name: uDSRSettings
 Author:    vmoura
 Purpose:
 History:

  quick Loading dsr settings
-----------------------------------------------------------------------------}
Unit uDSRSettings;

Interface

Function _DSRGetDBServer: String;
function _DSRAutomaticDripFeed: Boolean;

Implementation

Uses uSystemConfig;

{-----------------------------------------------------------------------------
  Procedure: _DSRGetDBServer
  Author:    vmoura

   Load the database server
-----------------------------------------------------------------------------}
Function _DSRGetDBServer: String;
Var
  lSys: TSystemConf;
Begin
  lSys := TSystemConf.Create;
  Result := lSys.DBServer;
  lSys.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: _DSRAutomaticInDripFeed
  Author:    vmoura
-----------------------------------------------------------------------------}
function _DSRAutomaticDripFeed: Boolean;
Var
  lSys: TSystemConf;
Begin
  lSys := TSystemConf.Create;
  Result := lSys.AutomaticDripFeed;
  lSys.Free;
end;

End.

