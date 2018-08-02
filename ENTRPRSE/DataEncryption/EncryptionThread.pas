unit EncryptionThread;

interface

uses
  Classes, oBtrieveFile, Messages;

const
  WM_ENCRYPTION_THREAD_FINISHED = WM_USER + 1;

type
  TEncryptionThread = Class(TThread)
  protected
    FBtrieveFile : TBaseBtrieveFile;
    FOwnerHandle : THandle;
    FFilename : string;
    procedure Execute; override;
  public
    property OwnerHandle : THandle read FOwnerHandle write FOwnerHandle;
    property BtrieveFile : TBaseBtrieveFile read FBtrieveFile write FBtrieveFile;
  end;

implementation

uses
  SysUtils, Windows;

{ TEncryptionThread }

procedure TEncryptionThread.Execute;
var
  Res : Integer;
begin
  //Remove owner from file
  Res := FBtrieveFile.ClearOwner;
  Try
    if Res = 0 then
    begin
      Res := FBtrieveFile.SetOwner(v600Owner, 3);
    end
    else
      Res := Res + 20000; //Offset of 20,000 for ClearOwner
  Finally
    FBtrieveFile.CloseFile;
    FreeAndNil(FBtrieveFile);
    //Send result backto main form
    PostMessage(FOwnerHandle, WM_ENCRYPTION_THREAD_FINISHED, 0, Res);
  End;
end;

end.
