unit TStdImpFileClass;

{******************************************************************************}
{  TStdImpFile is responsible for reading individual records from a standard   }
{  fixed-length record import file and for delivering individual fields from   }
{  each record.                                                                }
{  The layout of each file is determined by the meta-data definition of the    }
{  Exchequer records it contains. Each file can be a mixture of different      }
{  Exchequer record types.                                                     }
{  Typically a TMaps object will be used to cycle through all the fields of the}
{  map when reading Std Import files, because the whole of one map defines     }
{  not only the whole of the target Exchequer record but, with an additional   }
{  calculation, also the whole of the source Std Import file record.           }
{  TMaps provides the StdOffset of the current FieldDef as long as the Field   }
{  Defs have been processed in sequence.                                       }
{  For the current field def, TMaps also provides StdWidth which is the width  }
{  the field would occupy in a Std Import file.                                }
{  To retrieve the value of a field from a Std Import file, the caller must    }
{  provide the StdOffset and StdWidth.                                         }
{  Because of the meta-data and the way TMaps manipulates it there are more    }
{  lines of comments in this introduction then there are lines of code !       }
{******************************************************************************}

interface

uses GlobalTypes;

type
  TStdImpFile = class(TObject)
  private
{* internal fields *}
    FCurrentRecord: TImportFileRec;
    FRecordCount: integer;
    FStdImportFile: file of TImportFileRec;
{* property fields *}
{* procedural methods *}
{* getters and setters *}
    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
    procedure SetSysMsg(const Value: string);
  public
    constructor create(ImportFileName: string);
    destructor  destroy; override;
    function  FirstRecord: string;
    function  FieldValue(StdOffset: integer; StdWidth: integer): string;
    function  ReadRecord(ARecordNo: integer): string;
    property  RecordCount: integer read FRecordCount;
    property  SysMsg: string read GetSysMsg;
    property  SysMsgSet: boolean read GetSysMsgSet;
  end;

implementation

uses TErrors;

{ TStdImpFile }

constructor TStdImpFile.create(ImportFileName: string);
begin
  inherited create;
  AssignFile(FStdImportFile, ImportFileName);
  Reset(FStdImportFile);
  FRecordCount := FileSize(FStdImportFile);
end;

destructor TStdImpFile.destroy;
begin
  CloseFile(FStdImportFile);
  inherited destroy;
end;

{* Procedural Methods *}

function TStdImpFile.FieldValue(StdOffset, StdWidth: integer): string;
// From the current record return the number of characters specified in StdWidth
// starting at offset StdOffset.
begin
//  SetLength(result, StdWidth + 1); // allow for the null-terminator
  SetLength(result, StdWidth); // what null-terminator !!!??? Plank !
  move(FCurrentRecord.AsArray[StdOffset], result[1], StdWidth);
end;

function TStdImpFile.FirstRecord: string;
begin
  reset(FStdImportFile);
  read(FStdImportFile, FCurrentRecord);
  result := FCurrentRecord.RecordType;
end;

function TStdImpFile.ReadRecord(ARecordNo: integer): string;
begin
  if ARecordNo = 1 then
    result := FirstRecord
  else begin
    read(FStdImportFile, FCurrentRecord);
    result := FCurrentRecord.RecordType;
  end;
end;

{* getters and setters *}

function TStdImpFile.GetSysMsg: string;
begin
  result := TErrors.SysMsg;
end;

function TStdImpFile.GetSysMsgSet: boolean;
begin
  result := TErrors.SysMsgSet;
end;

procedure TStdImpFile.SetSysMsg(const Value: string);
begin
  TErrors.SetSysMsg(Value);
end;

end.
