unit AuditNotes;

interface

uses
  VarConst, BtrvU2, ExWrap1U;

Type

  TAuditNoteOwnerType = (anAccount, anTransaction, anStock, anJob, anStockLocation);
  TAuditNoteFunction  = (anCreate, anEdit, anAnonymised);

  TAuditNote = Class
  private
    FDataRec : PassWordRec;
    FFileVar : ^FileVar;
    FClientID : Pointer;

    FStoreRecAddress : longint;
    FStoreIndex : Integer;
    function SavePosition : integer;
    function RestorePosition : integer;
    function GetNextLineNo : integer;
    function GetNoteTypeChar(OwnerType : TAuditNoteOwnerType) : Char;
    function GetNoteFuncString(AFunction : TAuditNoteFunction) : string;
    procedure SetStandardData;
    function StoreNote : Integer;
    function GetExtraDataString(OwnerType : TAuditNoteOwnerType) : String;
  public
    constructor Create(const User : string; NoteFile : Pointer; ClientID : Pointer = nil);
    function AddNote(OwnerType : TAuditNoteOwnerType;
               const OwnerCode : string;
                     AFunction : TAuditNoteFunction) : Integer; overload;
    function AddNote(OwnerType : TAuditNoteOwnerType;
                     const OwnerFolio : longint;
                     AFunction  : TAuditNoteFunction) : Integer; overload;
    function AddCustomAuditNote(OwnerType : TAuditNoteOwnerType;
                                const OwnerFolio : longint; const Text : string) : integer;
    //GS 02/11/2011 method for writing an audit note
    //- uses the MtExLocal Record Structure
    class procedure WriteAuditNote(TypeOfRecord: TAuditNoteOwnerType; TypeOfModification: TAuditNoteFunction; Data: TdMTExLocal); Overload;
    //- uses the ExLocal Record Structure
    class procedure WriteAuditNote(TypeOfRecord: TAuditNoteOwnerType; TypeOfModification: TAuditNoteFunction; Data: TdExLocal); Overload;
    //- uses the Global Record Structure
    class procedure WriteAuditNote(TypeOfRecord: TAuditNoteOwnerType; TypeOfModification: TAuditNoteFunction); Overload;
    // MH 20/05/2015 v7.0.14 ABSEXCH-16284: Added class procedure to simplify calling AddCustomAuditNote
    class procedure WriteCustomAuditNote(TypeOfRecord: TAuditNoteOwnerType; Text : String; Data: TdExLocal);
  end;


implementation

uses   //PR: 28/10/2011 Removed NoteU as it won't compile for OLE Server
  SysUtils, BtKeys1U, GlobVar, EtMiscU;

{ TAuditNote }
const
  S_MAXLONGINT_HEX = '7FFFFFFF';

function TAuditNote.AddNote(OwnerType: TAuditNoteOwnerType;
  const OwnerCode: string; AFunction: TAuditNoteFunction): Integer;
begin
  //Set fields which aren't context-dependant
  SetStandardData;

  // Set Key fields
  FDataRec.SubType := GetNoteTypeChar(OwnerType);
  with FDataRec.NotesRec do
  begin
    NoteFolio := FullNCode(OwnerCode);
    LineNo    := GetNextLineNo;

    //PR: 28/10/2011 Replaced NoteU.FullRNoteKey as NoteU won't compile for OLE Server
    NoteNo    := FullNCode(NoteFolio) + NType + Dec2Hex(LineNo);
  end;

  // Set text
  FDataRec.NotesRec.NoteLine := GetNoteFuncString(AFunction) + ' BY ' +
                                Trim(FDataRec.NotesRec.NoteUser) + GetExtraDataString(OwnerType) + ': ' +
                                FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);

  //Add note to file
  Result := StoreNote;
end;

function TAuditNote.AddCustomAuditNote(OwnerType: TAuditNoteOwnerType;
  const OwnerFolio: Integer; const Text : string): integer;
begin
  //Set fields which aren't context-dependant
  SetStandardData;

  // Set Key fields
  FDataRec.SubType := GetNoteTypeChar(OwnerType);
  with FDataRec.NotesRec do
  begin
    NoteFolio := FullNCode(FullNomKey(OwnerFolio));
    LineNo    := GetNextLineNo;

    //PR: 28/10/2011 Replaced NoteU.FullRNoteKey as NoteU won't compile for OLE Server
    NoteNo    := FullNCode(NoteFolio) + NType + Dec2Hex(LineNo);
  end;

  // Set text
  FDataRec.NotesRec.NoteLine := Text;

  //Add note to file
  Result := StoreNote;
end;

function TAuditNote.AddNote(OwnerType: TAuditNoteOwnerType;
  const OwnerFolio: Integer; AFunction: TAuditNoteFunction): Integer;
begin
  Result := AddNote(OwnerType, FullNomKey(OwnerFolio), AFunction);
end;

constructor TAuditNote.Create(const User: string; NoteFile,
  ClientID: Pointer);
begin
  inherited Create;

  FFileVar := NoteFile;
  FClientID := ClientID;

  FStoreRecAddress := -1;

  FillChar(FDataRec, SizeOf(FDataRec), 0);
  FDataRec.RecPFix := 'N';
  FDataRec.NotesRec.NType := '3';
  FDataRec.NotesRec.NoteUser := User;
end;

//Return the appropriate charactor for NotesType.NType
function TAuditNote.GetExtraDataString(
  OwnerType: TAuditNoteOwnerType): String;
begin
  Case OwnerType of
    anStockLocation : Result := ' (Stock Location record changed) ';
    else
      Result := '';
  end;
end;

function TAuditNote.GetNextLineNo: integer;
var
  KeyS : Str255;
  Res : Integer;
  TempRec : PasswordRec;
begin
  //Save position here - it will be restored after we add the new note.
  SavePosition;
  //PR: 28/10/2011 Replaced NoteU.FullRNoteKey as NoteU won't compile for OLE Server
  //PR: 08/12/2011 Replaced Dec2Hex(MaxLongInt) with S_MAXLONGINT_HEX constant (declared above) to avoid overflow
  //in EL's functions.
  with FDataRec.NotesRec do
    KeyS := FDataRec.RecPfix + FDataRec.SubType + FullNCode(NoteFolio) + NType + S_MAXLONGINT_HEX;

  Res := Find_RecCID(B_GetLessEq, FFileVar^, PwrdF, TempRec, PWK, KeyS, FClientId);
  if (Res = 0) and (TempRec.NotesRec.NType = FDataRec.NotesRec.NType) then
    Result := TempRec.NotesRec.LineNo + 1
  else
    Result := 1;

end;

function TAuditNote.GetNoteFuncString(
  AFunction: TAuditNoteFunction): string;
begin
  if AFunction = anCreate then
    Result := 'CREATED'
  else if AFunction = anAnonymised then
    Result := 'ANONYMISED'
  else
    Result := 'EDITED';
end;

//PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Changed to use array rather than case statement
function TAuditNote.GetNoteTypeChar(OwnerType: TAuditNoteOwnerType): Char;
const
  NoteChars : Array[anAccount..anStockLocation] of Char = ('A', 'D', 'S', 'J', 'S');
begin
  Result := NoteChars[OwnerType];
end;


function TAuditNote.RestorePosition: integer;
begin
  if FStoreRecAddress <> -1 then
    Result := Presrv_BTPosCId(PwrdF, FStoreIndex, FFileVar^, FStoreRecAddress, True, False, FClientID)
  else
    Result := 0; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
end;

function TAuditNote.SavePosition: integer;
begin
  FStoreIndex := GetPosKey;
  Result := Presrv_BTPosCId(PwrdF, FStoreIndex, FFileVar^, FStoreRecAddress, False, False, FClientID);
  if Result <> 0 then
    FStoreRecAddress := -1;
end;

procedure TAuditNote.SetStandardData;
begin
  FDataRec.NotesRec.NoteDate := FormatDateTime('yyyymmdd', SysUtils.Date);
end;

function TAuditNote.StoreNote: Integer;
begin
  //Add record using index of -1 to avoid changing position.
  Result := Add_RecCID(FFileVar^, PwrdF, FDataRec, -1, FClientID);

  //Restore position in file
  RestorePosition;
end;

//GS 02/11/2011 added a static method for centeralising the code for adding an audit note to a record
class procedure TAuditNote.WriteAuditNote(TypeOfRecord: TAuditNoteOwnerType;
TypeOfModification: TAuditNoteFunction; Data: TdMTExLocal);
var
  oAuditNote : TAuditNote;
  CustomerCode: String;
  FolioNumber: LongInt;
begin

  CustomerCode := '';
  FolioNumber := 0;

  //deterine the note record identifier by record type
  Case TypeOfRecord of
    anAccount:      begin
                      CustomerCode := Data.LCust.CustCode;
                    end;
    anTransaction:  begin
                      FolioNumber := Data.LInv.FolioNum;
                    end;
    anStock:        begin
                      FolioNumber := Data.LStock.StockFolio;
                    end;
    anJob:          begin
                      FolioNumber := Data.LJobRec.JobFolio;
                    end;
  end;//End Case

    //create an audit note object
    oAuditNote := TAuditNote.Create(EntryRec.Login, @Data.LocalF^[PwrdF], Data.ExClientId);

    try
      //write an audit note
      if TypeOfRecord = anAccount then
      begin
        //identify note record by customer code
        oAuditNote.AddNote(TypeOfRecord, CustomerCode, TypeOfModification);
      end
      else
      begin
        //identify note record by folio number
        oAuditNote.AddNote(TypeOfRecord, FolioNumber, TypeOfModification);
      end;
    finally
      //dispose of the notes object
      FreeAndNil(oAuditNote);
    end;

end;

//GS 02/11/2011 added a static method for centeralising the code for adding an audit note to a record
class procedure TAuditNote.WriteAuditNote(TypeOfRecord: TAuditNoteOwnerType;
TypeOfModification: TAuditNoteFunction; Data: TdExLocal);
var
  oAuditNote : TAuditNote;
  CustomerCode: String;
  FolioNumber: LongInt;
begin

  CustomerCode := '';
  FolioNumber := 0;

  //deterine the note record identifier by record type
  Case TypeOfRecord of
    anAccount:      begin
                      CustomerCode := Data.LCust.CustCode;
                    end;
    anTransaction:  begin
                      FolioNumber := Data.LInv.FolioNum;
                    end;
    anStock:        begin
                      FolioNumber := Data.LStock.StockFolio;
                    end;
    anJob:          begin
                      FolioNumber := Data.LJobRec.JobFolio;
                    end;
  end;//End Case

    //create an audit note object
    oAuditNote := TAuditNote.Create(EntryRec.Login, @F[PwrdF]);

    try
      //write an audit note
      if TypeOfRecord = anAccount then
      begin
        //identify note record by customer code
        oAuditNote.AddNote(TypeOfRecord, CustomerCode, TypeOfModification);
      end
      else
      begin
        //identify note record by folio number
        oAuditNote.AddNote(TypeOfRecord, FolioNumber, TypeOfModification);
      end;
    finally
      //dispose of the notes object
      FreeAndNil(oAuditNote);
    end;

end;

//-------------------------------------------------------------------------

// MH 20/05/2015 v7.0.14 ABSEXCH-16284: Added class procedure to simplify calling AddCustomAuditNote
Class Procedure TAuditNote.WriteCustomAuditNote(TypeOfRecord: TAuditNoteOwnerType; Text : String; Data: TdExLocal);
Var
  oAuditNote : TAuditNote;
  CustomerCode: String;
  FolioNumber: LongInt;
Begin // WriteCustomAuditNote
  CustomerCode := '';
  FolioNumber := 0;

  //deterine the note record identifier by record type
  Case TypeOfRecord of
    anAccount:      begin
                      CustomerCode := Data.LCust.CustCode;
                    end;
    anTransaction:  begin
                      FolioNumber := Data.LInv.FolioNum;
                    end;
    anStock:        begin
                      FolioNumber := Data.LStock.StockFolio;
                    end;
    anJob:          begin
                      FolioNumber := Data.LJobRec.JobFolio;
                    end;
  end;//End Case

  //create an audit note object
  oAuditNote := TAuditNote.Create(EntryRec.Login, @F[PwrdF]);
  Try
    // Append User and timestamp
    Text := Text + ' by ' + Trim(EntryRec.Login) + ': ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);

    If (TypeOfRecord = anAccount) Then
    Begin
      //identify note record by customer code
      Raise Exception.Create ('TAuditNote.WriteCustomAuditNote: Account Audit Notes Not Supported')
      // No way to test this variant at the point that WriteCustomAuditNote was written so no support
      // was added for Customer audit notes
    End // If (TypeOfRecord = anAccount)
    Else
      // Identify note record by folio number
      oAuditNote.AddCustomAuditNote(TypeOfRecord, FolioNumber, Text);
  Finally
    FreeAndNil(oAuditNote);
  End; // Try..Finally
End; // WriteCustomAuditNote

//-------------------------------------------------------------------------

//GS 02/11/2011 added a static method for centeralising the code for adding an audit note to a record
class procedure TAuditNote.WriteAuditNote(TypeOfRecord: TAuditNoteOwnerType;
TypeOfModification: TAuditNoteFunction);
var
  oAuditNote : TAuditNote;
  CustomerCode: String;
  FolioNumber: LongInt;
begin

  CustomerCode := '';
  FolioNumber := 0;

  //deterine the note record identifier by record type
  Case TypeOfRecord of
    anAccount:      begin
                      CustomerCode := Cust.CustCode;
                    end;
    anTransaction:  begin
                      FolioNumber := Inv.FolioNum;
                    end;
    anStock:        begin
                      FolioNumber := Stock.StockFolio;
                    end;
    anJob:          begin
                      FolioNumber := JobRec.JobFolio;
                    end;
  end;//End Case

    //create an audit note object
    oAuditNote := TAuditNote.Create(EntryRec.Login, @F[PwrdF]);

    try
      //write an audit note
      if TypeOfRecord = anAccount then
      begin
        //identify note record by customer code
        oAuditNote.AddNote(TypeOfRecord, CustomerCode, TypeOfModification);
      end
      else
      begin
        //identify note record by folio number
        oAuditNote.AddNote(TypeOfRecord, FolioNumber, TypeOfModification);
      end;
    finally
      //dispose of the notes object
      FreeAndNil(oAuditNote);
    end;

end;

end.
