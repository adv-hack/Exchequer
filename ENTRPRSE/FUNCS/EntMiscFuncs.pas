unit EntMiscFuncs;

interface

uses
  VarConst, BtSupU1;

//PR: 27/05/2011 Added function to return whether a given SerialBatch record belongs to a given transaction line. (ABSEXCH-11406)
function DoesSerialBelong(const sOurRef : string;
                          const AnId : IDetail;
                          const ASerial : SerialType) : Boolean;
implementation

function DoesSerialBelong(const sOurRef : string;
                          const AnId : IDetail;
                          const ASerial : SerialType) : Boolean;

  function IsOutDoc : Boolean;
  begin
    Result := CheckKey(sOurRef, ASerial.OutDoc, Length(sOurRef), False) and (ASerial.SoldLine = AnId.ABSLineNo);
  end;

  function IsOutOrderDoc : Boolean;
  begin
    Result := (AnId.IdDocHed In OrderSet+[WOR]) and
               CheckKey(sOurRef, ASerial.OutOrdDoc, Length(sOurRef), False) and (ASerial.OutOrdLine = AnId.ABSLineNo)
  end;

  function IsReturnDoc : Boolean;
  begin
    Result := CheckKey(sOurRef, ASerial.RetDoc, Length(sOurRef), False) and (ASerial.RetDocLine = AnId.ABSLineNo);
  end;

  function IsInDoc : Boolean;
  begin
    Result := CheckKey(sOurRef, ASerial.InDoc, Length(sOurRef), False) and (ASerial.BuyLine = AnId.ABSLineNo) and (Not ASerial.BatchChild);
  end;

  function IsInOrderDoc : Boolean;
  begin
    Result := (AnId.IdDocHed In OrderSet+[WOR]) and
               CheckKey(sOurRef, ASerial.InOrdDoc, Length(sOurRef), False) and (ASerial.InOrdLine = AnId.AbsLineNo)
               and (Not ASerial.BatchChild);
  end;

begin
  Result := IsOutDoc or IsOutOrderDoc or IsReturnDoc or
             IsInDoc or IsInOrderDoc;
end;



end.

