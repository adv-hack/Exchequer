unit t2xconfg;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Enterprise03_TLB, ComObj, LogFile;


type

  TXmlConfiguration = class(TLogAutoIntf, IXmlConfiguration, IXmlConfiguration2, IXmlConfiguration3)
  private
     FDefaultOutputDir : string;
     FXslUrl           : string;
     FTransferMode     : TxmlTransferMode;
  protected
    function  Get_DefaultOutputDirectory: WideString; safecall;
    procedure Set_DefaultOutputDirectory(const Value: WideString); safecall;
    function  Get_XslUrl: WideString; safecall;
    procedure Set_XslUrl(const Value: WideString); safecall;
    function Get_Debug: WordBool; safecall;
    procedure Set_Debug(Value: WordBool); safecall;
    function Get_TransferMode: TxmlTransferMode; safecall;
    procedure Set_TransferMode(Value: TxmlTransferMode); safecall;
  public
    constructor Create;
    destructor Destroy; override;
    property OutputDir : String read FDefaultOutPutDir;
    property TransferMode : TxmlTransferMode read FTransferMode;
  end;

implementation

uses
  ComServ;

constructor TXmlConfiguration.Create;
begin
  Inherited Create (ComServer.TypeLib, IXmlConfiguration2);
end;

destructor TXmlConfiguration.Destroy;
begin
  inherited Destroy;
end;

function  TXmlConfiguration.Get_DefaultOutputDirectory: WideString;
begin
  Result := FDefaultOutputDir;
end;

procedure TXmlConfiguration.Set_DefaultOutputDirectory(const Value: WideString);
begin
  FDefaultOutputDir := Value;
end;

function  TXmlConfiguration.Get_XslUrl: WideString;
begin
  Result := FXslUrl;
end;

procedure TXmlConfiguration.Set_XslUrl(const Value: WideString);
begin
  FXslUrl := Value;
end;




function TXmlConfiguration.Get_Debug: WordBool;
begin
  Result := LogFileOn;
end;

procedure TXmlConfiguration.Set_Debug(Value: WordBool);
begin
  if Value and not LogFileOn then
    InitLogFile;
  LogFileOn := Value;
end;

function TXmlConfiguration.Get_TransferMode: TxmlTransferMode;
begin
  Result := FTransferMode;
end;

procedure TXmlConfiguration.Set_TransferMode(Value: TxmlTransferMode);
begin
  FTransferMode := Value;
end;

end.
