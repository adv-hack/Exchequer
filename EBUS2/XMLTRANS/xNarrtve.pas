unit xnarrtve;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ComObj, Enterprise03_TLB, Classes, LogFile;

type
    TXmlNarrative = class(TLogAutoIntf, IXmlNarrative)
      private
        FLines : TStringList;
        FParent : TObject;
      protected
        function  Get_ntLine(Index: Integer): WideString; safecall;
        function  Get_ntLineCount: Integer; safecall;
        procedure Delete(Index: Integer); safecall;
        procedure Add(const Value: WideString); safecall;
      public
        constructor Create;
        destructor Destroy; override;
        property Lines : TStringList read FLines write FLines;
      end;





implementation

uses
  ComServ, SysUtils;

constructor TXmlNarrative.Create;
begin
  inherited Create(ComServer.TypeLib, IxmlNarrative);
  FLines := TStringList.Create;
end;

destructor TXmlNarrative.Destroy;
begin
  if Assigned(FLines) then
    FLines.Free;
  inherited Destroy;
end;

function  TXmlNarrative.Get_ntLine(Index: Integer): WideString; safecall;
begin
  if Assigned(FLines) and (FLines.Count > Index) then
    Result := FLines[Index]
  else
    Raise ERangeError.Create('Index out of range');
end;

function  TXmlNarrative.Get_ntLineCount: Integer; safecall;
begin
  if Assigned(FLines) then
    Result := FLines.Count;
end;

procedure TXmlNarrative.Delete(Index: Integer); safecall;
begin
  if Assigned(FLines) and (FLines.Count > Index) then
    FLines.Delete(Index)
  else
    Raise ERangeError.Create('Index out of range');
end;

procedure TXmlNarrative.Add(const Value: WideString); safecall;
begin
  if Assigned(FLines) then
    FLines.Add(Value);
end;


end.
