{-----------------------------------------------------------------------------
 Unit Name : uDSRVAT100
 Author    : Phil Rogers
 Purpose   : Handles VAT 100 XML files.
 History   : Based on uDSRCIS by vmoura
-----------------------------------------------------------------------------}
unit uDSRVAT100;

interface

uses
  Classes, Sysutils, Windows;

type
  {VAT 100 returns}
  TDSRVAT100 = class(TThread)
  private
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  uDSRSettings, uAdoDSR, uConsts, uCommon, uSystemConfig, uInterfaces;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura, Arr. Phil Rogers
-----------------------------------------------------------------------------}
constructor TDSRVAT100.Create;
begin
  inherited Create(True); // Create suspended.
  FreeOnTerminate := True;
  Priority := tpLower;
end;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura, Arr. Phil Rogers
-----------------------------------------------------------------------------}
destructor TDSRVAT100.Destroy;
begin
  inherited Destroy;
end;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura, Arr. Phil Rogers
-----------------------------------------------------------------------------}
procedure TDSRVAT100.Execute;
var
  lComp     : TCompany;   // company object
  lOut      : OleVariant; // companies stored
  lcoIndex  : integer;    // index when looping through companies
  lTotal    : integer;
  lPackId   : Integer;
  lDb       : TADODSR;    // database
  lOldFile  : string;
  lNewFile  : String;
  lPack     : TPackageInfo;
begin
  // Create a connection to the database server
  lDb := nil;
  try
    lDb := TADODSR.Create(_DSRGetDBServer);
  except
    on e: Exception do
      _LogMSG('TDSRVAT100.Execute :- Error connecting the Database. Error: ' +
        e.message)
  end; {try}

  // Only continue processing if we have a connection.
  if Assigned(lDb) and lDB.Connected then
  try
    // Get companies from db
    lOut := lDB.GetCompanies;

    // Get the count of companies
    lTotal := _GetOlevariantArraySize(lOut);

    // Loop through the companies.
    if lTotal > 0 then
    begin
      for lcoIndex := 0 to lTotal - 1 do
      begin
        // Create a company object}
        lComp := _CreateCompanyObj(lOut[lcoIndex]);
        if lComp <> nil then
        begin
          {double check if company exists and is active}
          if lComp.Active and _DirExists(lComp.Directory) and not Terminated then
          begin
            // If VAT 100 return xml exists, create a temp entry that will be picked
            //  up later by the producer/sender thread
            lOldFile := _GetVAT100File(IncludeTrailingPathDelimiter(lComp.Directory) + cVAT100XMLDIR);

            lNewFile := ExtractFilePath(lOldFile) + '\' + cVAT100RETFILEPROCESS; // Standard filename

            // Check if the old file exists
            if (lOldFile <> '') and (_FileSize(lOldFile) > 0) then
            begin
              lPackId := 0;
              lPack := lDb.GetExportPackage(lComp.Id, cVAT100EXPORT);

              if lPack <> nil then
                lPackId := lPack.Id;

              // Copy the old file to avoid threads processing the file again
              if CopyFile(pChar(lOldFile), pChar(lNewFile), False) then
                _DelFile(lOldFile)
              else
                MoveFile(pChar(lOldFile), pChar(lNewFile));

              if _FileSize(lNewFile) > 0 then
                _DelFile(lOldFile);

              // Update the outbox in the database. (Messages look like emails)
              lDb.UpdateOutBox(_CreateGuid,          // guid
                               lComp.Id,             // company id
                               cVAT100RETURNSUBJECT, // message subject:
                               lComp.Desc,           // from: company description
                               cVAT100RECIPIENT,     // to: ggw gateway
                               lPackId,              // pack_id
                               1,                    // total
                               '',                   // param 1
                               '',                   // param 2
                               cPENDING,             // pending message
                               Ord(rmVAT100),        // type of message (VAT 100)
                               dbDoAdd);             // add to database
            end; {if _FileSize(lComp.Directory + '') > 0 then}
          end; {If lComp.Active And _DirExists(lComp.Directory) Then}

          // Dispose of the company object
          FreeAndNil(lComp);
        end; {if lComp <> nil then}
      end; {for lCont:= 0 to lTotal - 1 do}
    end; // if number of companies > 0.
  except
    on e: Exception Do
    begin
      _LogMSG('TDSRVAT100.Execute :- Error processing VAT 100 XML files. Error: ' + e.Message);
      if Assigned(lDb) and lDb.Connected then
        lDb.UpdateIceLog('TDSRVAT100.Execute', 'Error processing VAT 100 XML files. Error: ' +
          e.Message);
    end; {begin}
  end; {if fDB.Connected then}

  if Assigned(lDb) then
    FreeAndNil(lDb);

  Terminate;
end;

end.

