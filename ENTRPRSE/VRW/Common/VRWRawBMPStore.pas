unit VRWRawBMPStore;
{$IFNDEF KPI}
This unit should only compiled into the ExchOut.DLL project.
{$ENDIF}

{
  This is a copy of the code for the TRawBMPStore class, which is normally found
  in GlobalTypes.pas. It has been copied here so that the ExchOut.DLL project
  does not need to include GlobalTypes (which indirectly pulls in all the direct
  Btrieve access code, and causes errors when the DLL starts up because it is
  calling Open_System() without being properly set up).
}

interface

type
  TRawBMPStore = class(TObject)
    iBMPSize : Integer;
    pBMP : Pointer;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

// =============================================================================
// TRawBMPStore
// =============================================================================

constructor TRawBMPStore.Create;
begin
  inherited Create;
  iBMPSize := 0;
  pBMP     := nil;
end;

// -----------------------------------------------------------------------------

destructor TRawBMPStore.Destroy;
begin
  if (assigned(pBMP)) then
    FreeMem(pBMP);
  inherited Destroy;
end;

// -----------------------------------------------------------------------------

end.
