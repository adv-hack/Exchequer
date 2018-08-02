unit BankIObj;
{As far as I can tell only the headers are different from the AIB format so we can descend
from the aib object then use the create method to populate the header records correctly}
interface

uses
  AibObj, CustAbsU;

type
  TBankIrExportObject = Class(TAibEftObj)
    constructor Create(const EventData : TAbsEnterpriseSystem);
  end;

var
  BankIrExportObject : TBankIrExportObject;

implementation

constructor TBankIrExportObject.Create(const EventData : TAbsEnterpriseSystem);
begin

  Inherited Create(EventData);
  with EventData do
  begin
    with VolHeader do
    begin
      Filler2[33] := ' '; {replace '.' with space}
    end;


    with FileHeader do
    begin
      Str2_Char(ZeroesAtFront(0,SizeOf(BlockLength)), BlockLength, SizeOf(BlockLength));
      Str2_Char(ZeroesAtFront(0,SizeOf(BeginExt)), BeginExt, SizeOf(BeginExt));
      Str2_Char(ZeroesAtFront(0,SizeOf(EndExt)), EndExt, SizeOf(EndExt));
      Str2_Char('0100', RecLength, SizeOf(RecLength)); {we don't want multiple date processing}
      RecAttrib := 'B';
      Filler5[17] := ' '; {replace '.' with space}
    end;

    with UserHeader do
    begin
      Str2_Char(ZeroesAtFront(0,SizeOf(ZFiller1)),ZFiller1,SizeOf(ZFiller1));
      Str2_Char('90', ReceiverID, SizeOf(ReceiverID));
      Str2_Char(ZeroesAtFront(0,SizeOf(ZFiller2)),ZFiller2,SizeOf(ZFiller2));
      Filler2[40] := ' '; {replace '.' with space}
    end;

    with UserTrailer do
    begin
      Filler1[36] := ' '; {replace '.' with space}
    end;

  end;
end;




end.
