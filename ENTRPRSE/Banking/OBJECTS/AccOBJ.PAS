unit AccObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{As far as I can tell only the headers are different from the AIB format so we can descend
from the aib object then use the create method to populate the header records correctly}
interface

uses
  AibObj, Aib01, CustAbsU;

type
  TAccBankExportObject = Class(TAibEftObj)
  protected
    function GetIniFileName : string; override;
  public
    procedure SetHeader(const EventData : TAbsEnterpriseSystem); override;
  end;

var
  AccBankExportObject : TAccBankExportObject;

implementation

uses
  SysUtils;


function TAccBankExportObject.GetIniFileName: string;
begin
  EFTIniFile := DefaultAccIniFile;
end;

procedure TAccBankExportObject.SetHeader(
  const EventData: TAbsEnterpriseSystem);
var
  TempString, DateString : String;
  TempInt : longint;
begin
  GetEventData(EventData);
  inherited SetHeader(EventData);
  with EventData do
  begin
    with VolHeader do
    begin
      Filler2[33] := ' '; {replace '.' with space}
    end;


    with FileHeader do
    begin
      Str2_Char(ZerosAtFront(0,SizeOf(BlockLength)), BlockLength, SizeOf(BlockLength));
      Str2_Char(ZerosAtFront(0,SizeOf(BeginExt)), BeginExt, SizeOf(BeginExt));
      Str2_Char(ZerosAtFront(0,SizeOf(EndExt)), EndExt, SizeOf(EndExt));
      RecFmt := 'F';
      Str2_Char(' ' + JulianDateStr(FormatDateTime('yyyymmdd', Now)), accCrDate, SizeOf(accCrDate));
      Str2_Char(JulianDateStr(ProcControl.Pdate) + ' ', accExpDate, SizeOf(accExpDate));

      accRecAttrib := 'B';
      Filler5[17] := ' '; {replace '.' with space}
    end;

    with UserHeader do
    begin
      Str2_Char(ZerosAtFront(0,SizeOf(ZFiller1)),ZFiller1,SizeOf(ZFiller1));
      Str2_Char('90', ReceiverID, SizeOf(ReceiverID));
      Str2_Char(ZerosAtFront(0,SizeOf(ZFiller2)),ZFiller2,SizeOf(ZFiller2));
      Currency := '01';
      Filler2[40] := ' '; {replace '.' with space}
    end;

    with UserTrailer do
    begin
      Filler1[36] := ' '; {replace '.' with space}
    end;

  end;
end;

end.
