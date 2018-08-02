{-----------------------------------------------------------------------------
 Unit Name: uExMail
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
unit uExMail;

interface

uses Windows, Sysutils, Classes,
  uMailBase
  ;

type

  TExMail = Class
  private
    fIncoming: TEmailBase;
    fOutgoing: TEmailBase;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Incoming: TEmailBase read fIncoming write fIncoming;
    property Outgoing: TEmailBase read fOutgoing write fOutgoing; 
  end;


implementation

{ TExMail }

constructor TExMail.Create;
begin

end;

destructor TExMail.Destroy;
begin

  inherited;
end;

end.
