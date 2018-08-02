unit LicUtil;

interface

const
  luLicenced = 0; //Full or 30 day
  luNotLicenced = 1;
  luError = 2;

function GetModuleLicence(iModuleIndex : Byte; sPath : string = '') : SmallInt;
procedure ShowNotLicencedMessage(sModName : string);
procedure ShowLicenceErrorMessage(sModName : string);
function GetTCMEnterpriseDirectory : string;

implementation

uses
  LicRec, EntLic, VarFPosU, sysUtils, Dialogs, FileUtil, Forms,
  {$IFDEF EXSQL}
  SQLUtils,
  {$ENDIF}
  Inifiles;

function GetModuleLicence(iModuleIndex : Byte; sPath : string = '') : SmallInt;
var
  LicenceRec : EntLicenceRecType;
  SavedExMainCoPath : string;
begin
  SavedExMainCoPath := ExMainCoPath^;

  Try
{At the moment this takes the Exchequer dir from the exe path - needs updating to
 deal with local program files}

{    case iModuleIndex of
      modTrade : ExMainCoPath^ := GetTCMEnterpriseDirectory;
      else ExMainCoPath^ := UpperCase(GetEnterpriseDirectory);
    end;{case}

    if sPath = '' then ExMainCoPath^ := UpperCase(GetEnterpriseDirectory)
    else ExMainCoPath^ := sPath;

    // NF: Fix 4 TCM 13/11/03
    if Uppercase(Copy(ExMainCoPath^,Length(ExMainCoPath^) - 6, 7)) = '\TRADE\'
    then ExMainCoPath^ := Copy(ExMainCoPath^,1,Length(ExMainCoPath^) - 6);

//ShowMessage('ExMainCoPath^ :' + ExMainCoPath^);

    FillChar(LicenceRec, SizeOf(LicenceRec), #0);

    if ReadEntLic(EntLicFName, LicenceRec) then
    begin
      if LicenceRec.licModules[iModuleIndex] in [1, 2] then
        Result := luLicenced
      else
        Result := luNotlicenced;
    end
    else
      Result := luError;
  Except
    Result := luError;
  End;
  ExMainCoPath^ := SavedExMainCoPath;
end;

procedure ShowNotLicencedMessage(sModName : string);
begin
  ShowMessage('The ' + sModName + ' module is not licenced.'#10#10 +
              'Please contact your Exchequer dealer for licencing details.');
end;

procedure ShowLicenceErrorMessage(sModName : string);
begin
  MessageDlg('There was an error checking the security for the ' + sModName + ' module.'#10#10 +
              'Please contact your Exchequer support line.', mtError, [mbOK], 0);
end;

function GetTCMEnterpriseDirectory : string;
var
  EntDir, DataDir : string;
  iPos : integer;

  function RemoveTradeFrom(sPath : string): string;
  begin
    iPos := Pos('\TRADE\',sPath);
    if (iPos > 0) and (iPos = length(sPath) - 6)
    then delete(sPath,iPos + 1, length(sPath));
    Result := sPath;
  end;

begin
  EntDir := ExtractFilePath(Application.ExeName);
  DataDir := Entdir;

  // Check for Local Program Files
  If FileExists (ExtractFilePath(Application.ExeName) + 'ENTWREPL.INI') Then
    begin
      With TIniFile.Create (ExtractFilePath (Application.ExeName) + 'ENTWREPL.INI') Do begin
        Try
          DataDir := UpperCase(IncludeTrailingBackslash(ReadString ('UpdateEngine', 'NetworkDir', EntDir)));

          If FileExists (DataDir + 'TCMSETUP.EXE') Then begin
            {valid TCM Master Dir}
            DataDir := RemoveTradeFrom(DataDir);
          end;{if}

{$IFDEF EXSQL}
          // MH 21/09/07: Modified to use ValidSystem as a more acccurate check
          //If Not SQLUtils.TableExists (DataDir + 'COMPANY.DAT') Then
          If Not ValidSystem(DataDir) Then
{$ELSE}
          If Not FileExists (DataDir + 'COMPANY.DAT') Then
{$ENDIF}
            DataDir := EntDir;
        Finally
          Free;
        End;
      end;{with}
      Result := DataDir;
    end
  else Result := RemoveTradeFrom(DataDir);
end;


end.
