unit oDbfMain;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, EnterpriseDBF_TLB, StdVcl, Classes;

const
  sDBFVersion = 'v6.01.002';

type
  TDBFWriter = class(TAutoObject, IDBFWriter)
  private
    FFileName, FIndexFileName : WideString;
    FList : TStringList;
    FFieldCount : integer;
  protected
    function CreateFile(const FileDef: WideString): Smallint; safecall;
    function Get_Filename: WideString; safecall;
    procedure AddRec; safecall;
    procedure CloseFile; safecall;
    procedure Set_Filename(const Value: WideString); safecall;
    procedure Clear; safecall;
    procedure SetFieldValue(FieldNo: Integer; const Value: WideString);
      safecall;
    procedure SaveRec; safecall;
    procedure AddIndex(const FieldName: WideString; IsDescending: WordBool);
      safecall;
    function Get_Version: WideString; safecall;
    { Protected declarations }
  public
    procedure Initialize; override;
    destructor Destroy; override;

  end;

implementation

uses ComServ, DbfMod, SysUtils, Halcn6db;

procedure TDBFWriter.Initialize;
begin
  inherited Initialize;
  dmDbf := TdmDbf.Create(nil);
  FList := TSTringList.Create;
  FFieldCount := 0;
end;

destructor TDBFWriter.Destroy;
begin
  //PR: 03/06/2009 Need to check that these haven't already been freed
  if Assigned(dmDbf) then
    FreeAndNil(dmDbf);
  if Assigned(FList) then
    FreeAndNil(Flist);
  inherited Destroy;
end;

function TDBFWriter.CreateFile(const FileDef: WideString): Smallint;
begin
  Result := 0;
  Try
    dmDbf.dsCreate.CreateFields.CommaText := FileDef;
    FFieldCount := dmDbf.dsCreate.CreateFields.Count;
  Except
    Result := 1000;
  End;
  dmDbf.dsTable.TableName := FFilename;
  if not dmDbf.dsCreate.Execute then
    Result := 1002
  else
    dmDbf.dsTable.Open;
end;

function TDBFWriter.Get_Filename: WideString;
begin
  Result := FFileName;
end;

procedure TDBFWriter.AddRec;
begin
  Clear;
  dmDbf.dsTable.Append;
end;

procedure TDBFWriter.SetFieldValue(FieldNo: Integer;
  const Value: WideString);
begin
  if FieldNo <= FList.Count then
    FList[FieldNo - 1]  := Value;
end;

procedure TDBFWriter.CloseFile;
begin
   dmDbf.dsTable.Close;
end;

procedure TDBFWriter.Set_Filename(const Value: WideString);
begin
  FFileName := Value;
  FIndexFileName := ChangeFileExt(ExtractFileName(FFileName), '.mdx');
end;

procedure TDBFWriter.Clear;
var
  i : integer;
begin
  FList.Clear;
  for i := 1 to FFieldCount do
    FList.Add(' ');
end;


procedure TDBFWriter.SaveRec;
var
  i : integer;
begin
  for i := 0 to FList.Count - 1 do
    dmDBF.dsTable.FieldPutN(i + 1, FList[i]);
  dmDBF.dsTable.Post;
end;

procedure TDBFWriter.AddIndex(const FieldName: WideString;
  IsDescending: WordBool);
var
  ADirection : tgsSortStatus;
begin
  if IsDescending then
    ADirection := Descending
  else
    ADirection := Ascending;

  dmDbf.dsTable.IndexOn(FIndexFileName, FieldName, FieldName, '', Duplicates, ADirection);

  dmDbf.dsTable.IndexIsProduction(True);
end;

function TDBFWriter.Get_Version: WideString;
begin
  Result := sDBFVersion;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TDBFWriter, Class_DBFWriter,
    ciMultiInstance, tmApartment);
end.
