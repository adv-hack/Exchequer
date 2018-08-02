unit Counters;

interface

uses
  BaseCounterClasses, Enterprise04_TLB, Classes;



type
  TProgressProc = procedure (const sMsg : string) of object;

  TCounter = Class
  protected
    FToolkit : IToolkit;
    FCodeList : TStringList;
    FResultList : TStringList;
    FOnProgress : TProgressProc;
    procedure LoadCodeList; virtual; abstract;
    procedure SetBaseObject; virtual; abstract;
    procedure AddCount(const sCode : string; sSubObject : string; iCount : Integer);
  public
    constructor Create(const AToolkit : IToolkit);
    destructor Destroy; override;
    procedure Execute; virtual;
    property Toolkit : IToolkit read FToolkit write FToolkit;
    property ResultList : FResultList read FResultList write FResultList;
    property OnProgress : TProgressProc read FOnProgress write FOnProgress;
  end;

  



implementation

{ TCounter }

procedure TCounter.AddCount(const sCode: string; sSubObject: string;
  iCount: Integer);
begin
  FResultList.Add(sCode + ',' + sSubObject + ',' + IntToStr(iCount));
  if Assigned(FOnProgress) then
    FOnProgress(FResultList[FResultList.Count - 1]);
end;

constructor TCounter.Create(const AToolkit : IToolkit);
begin
  inherited Create;
  FCodeList := TStringList.Create;
  FToolkit := AToolkit;
end;

destructor TCounter.Destroy;
begin
  FCodeList.Free;
  inherited;
end;

procedure TCounter.Execute;
begin
  SetBaseObject;
  FCodeList.Clear;
  LoadCodeList;
end;

end.
 