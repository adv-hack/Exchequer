unit oCard;

Interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, EPOSCnst, StdVcl;

type

  TTradeTCMSetupCreditCard = class(TAutoIntfObject, ITradeTCMSetupCreditCard)
  private
    lsDescription : String;
    liGLCode : Integer;
  protected
    function Get_ccDescription: WideString; safecall;
    function Get_ccGLCode: Integer; safecall;
  public
    Constructor Create(sDescription : String; iGLCode : Integer);
    Destructor Destroy; override;
  End; { TTradeTCMSetupCreditCard }

implementation

uses ComServ;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeTCMSetupCreditCard.Create(sDescription : String; iGLCode : Integer);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeTCMSetupCreditCard);
  lsDescription := sDescription;
  liGLCode := iGLCode;
End; { Create }

Destructor TTradeTCMSetupCreditCard.Destroy;
Begin { Destroy }
  Inherited;
End; { Destroy }


function TTradeTCMSetupCreditCard.Get_ccDescription: WideString;
begin
  Result := lsDescription;
end;

function TTradeTCMSetupCreditCard.Get_ccGLCode: Integer;
begin
  Result := liGLCode;
end;

end.
