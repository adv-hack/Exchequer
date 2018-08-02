unit oExpire;

interface

const
  S_AUTHORISE_NAME = 'EXPAHOOK';
  S_AUTHORISE_ID = 'EXCHAUTHWF000002';

  function ExpirePlugIn(VerNo     :  String;
                        CompDir   :  String;
                        PlugIn    :  string;
                    Var RErrStr   :  String)  :  Integer; STDCALL; Export;


implementation

uses oCompany, GlobVar, SQLUtils, VAOUtil, VarConst, SysUtils, StrUtil, EtStrU, Windows;

type
  //Class to handle expiring a DLL plugin and removing it from EntCustm.ini
  TExpire = Class
  private
    FErrStr : string;
    FExchequerDir : string;
    procedure RemovePlugIn(const PlugInName : string);
  public
    function ExpirePlugIn(const DataDir : string; const PlugInID : string) : Integer;
    property ErrorString : string read FErrStr write FErrStr;
  end;

function ExpirePlugIn(VerNo     :  String;
                      CompDir   :  String;
                      PlugIn    :  string;
                  Var RErrStr   :  String)  :  Integer;
var
  Expire : TExpire;
begin
  Expire := TExpire.Create;
  with Expire do
  Try
    Result := Expire.ExpirePlugIn(CompDir, PlugIn);
    RErrStr := Expire.ErrorString;
  Finally
    Expire.Free;
  End;
end;


function TExpire.ExpirePlugIn(const DataDir : string; const PlugInID: string): Integer;
var
  Res      : Integer;
  KeyS     : Str255;
  Company  : TCompanyFile;
  MCMDir   : String;
begin
  Result := 0;

  //GEUpgrade functions are called once for each company, so as we only need to perform this once, we'll run it when
  //we get to the main Exchequer folder
  if SQLUtils.ValidSystem(DataDir) then
  begin
    FExchequerDir := IncludeTrailingBackslash(DataDir);
    Company := TCompanyFile.Create;

    //Open mcm table
    Result := Company.OpenFile(FExchequerDir + 'COMPANY.DAT');

    if SQLUtils.UsingSql and (Result <> 0) then
    begin //for MS-SQL systems, OpenFile calls OpenCompany which will return an error + 11000
      Result := Result - 11000;
      FErrStr := SQLUtils.GetSQLErrorInformation(Result);
    end;

    if Result = 0 then
    begin
      //Find record for plugin
      KeyS := cmPlugInSecurity + PlugInID + StringOfChar(#0, 100 - Length(PlugInId));
      Company.Index := CompPathK;
      Result := Company.GetEqual(KeyS);

      //Check if there's a record and it's not already expired
      if (Result = 0) and (Company.hkSysRelStatus <> 0) then
      begin
        //Set expiry date to zero and status to zero (Expired)
        Company.hkExpiryDate := 0;
        Company.hkSysRelStatus := 0;

        //Save record
        Result := Company.Update;

        if Result = 0 then
          //Remove plugin from EntCustm.ini
          RemovePlugIn(S_AUTHORISE_NAME)
        else
          FErrStr := 'Unable to store licence record. Error ' + IntToStr(Result);
      end
      else //If no record found then we don't need to do anything so return 0
      if Result in [4, 9] then
        Result := 0;
    end;
  end;
end;

//Removes the plug-in from EntCustm.ini
procedure TExpire.RemovePlugIn(const PlugInName : string);
var
  pPluginPath, pDLLPath, pEntPath : PChar;
  _RemovePlugIn  : Function(pEnterpriseDir, pPlugInPath : PChar) : SmallInt; StdCall;
  _MyGSRHandle : THandle;
begin
  pEntPath := StrAlloc(255);
  Try
    pDLLPath := StrAlloc(255);
    StrPCopy(pEntPath, FExchequerDir);
    StrPCopy(pDLLPath, FExchequerDir + 'ENTSETUP.DLL');
    _MyGSRHandle := LoadLibrary(pDLLPath);
    StrDispose(pDLLPath);

    Try
      If (_MyGSRHandle > HInstance_Error) Then Begin

        pPluginPath := StrAlloc(255);
        StrPCopy(pPluginPath, PlugInName);

        _RemovePlugIn := GetProcAddress(_MyGSRHandle, 'RemoveDLLPlugIn');

        If Assigned(_RemovePlugIn) then Begin
          _RemovePlugIn(pEntPath, pPluginPath);
        End; { If }
        StrDispose(pPlugInPath);

        { Unload library }
        FreeLibrary(_MyGSRHandle);
        _MyGSRHandle:=0;
      End; { If }
    Except
      FreeLibrary(_MyGSRHandle);
      _MyGSRHandle:=0;

      _RemovePlugIn := Nil;
    End;
  Finally
    StrDispose(pEntPath);
  End;
end;

end.
