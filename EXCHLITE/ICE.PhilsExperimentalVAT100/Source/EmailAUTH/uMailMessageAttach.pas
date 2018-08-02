unit uMailMessageAttach;

interface

uses Windows, Sysutils, Classes
  ;

type

  TMailAttachment = class
  private
    fOriginalName: String;
    fFileName: String;
    fDeleteFileName: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property FileName: String read fFileName write fFileName;
    property OriginalName: String read fOriginalName write fOriginalName;
  end;


implementation

{ TMailAttachment }

constructor TMailAttachment.Create;
begin

end;

destructor TMailAttachment.Destroy;
begin
  inherited;
end;

end.
