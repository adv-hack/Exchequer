program SQLConnection;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows,
  ActiveX,
  crypto in 'crypto.pas',
  EncdDecd,
  Wcrypt2,
  FileProcess in 'FileProcess.pas',
  globals in 'globals.pas';

var
  fp   : TLoginFileProcessor;
  rVal : integer;
  
begin
  rVal := SQL_CONN_STRING_SUCCESS;

  // Create a file processor
  fp := TLoginFileProcessor.Create;

  // Parse the command line arguments
  if fp.ParseCommandLine then
  begin
    // Read the Configuration file
    if fp.ReadConfigFile then
    begin
      // Decode and Decrypt the Connection String
      fp.DecodeConnectionString;

      // Explode the connection string
      fp.ExplodeConnectionString;

      // Get the Data Source element
      fp.ExtractDataSource;

      // Get the Data Source protocol
      fp.ExtractCurrentProtocol;

      // Read the Default Protocol
      fp.ReadProtocolFile;

      // If the Default is set, then use it
      fp.UpdateDefaultProtocol;

      // Reassemble the Connection String
      fp.ReassembleConnectionString;

      // Test the new connection string.  If it works, we can go ahead and save
      //  both the connection string and the default protocol.
      if fp.TestConnectionString then
      begin
        // Encrypt and Encode the Connection string
        fp.EncryptConnectionString;

        // Save the Connection String back to the file
        fp.SaveConnectionString;

        // Save the default to its file (including the colon)
        fp.SaveDefaultProtocol;
      end
      else
      begin
        // The new connection string failed, so we don't save it.
        rVal := SQL_CONN_STRING_FAILED;
      end;
    end
    else
    begin
      rVal := SQL_CONN_OPEN_FILE_FAILED;
    end;
  end;

  fp.Free;

  // Return a code back to the calling program
  Halt(rVal);
end.
