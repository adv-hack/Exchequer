unit zlines;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU,   ZLine;

type
  TCOMTransactionLines = class(TAutoIntfObject, ICOMTransactionLines)
  private
    FEntSysObj : TEnterpriseSystem;

    {FCurrLineO : TCOMTransactionLine;
    FCurrLineI : ICOMTransactionLine;}
  protected
    procedure AddNewLine; safecall;
    function  Get_thLineCount: Integer; safecall;
    function  Get_thLine(Index: Integer): ICOMTransactionLine; safecall;
    function  Get_thCurrentLine: ICOMTransactionLine; safecall;
  public
    Constructor Create;

    Procedure InitLines(EntSysObj : TEnterpriseSystem);
  End; { TCOMTransactionLines }

implementation

uses ComServ, CustIntU;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMTransactionLines.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMTransactionLines);

End; { Create }

{-----------------------------------------}

Procedure TCOMTransactionLines.InitLines(EntSysObj : TEnterpriseSystem);
Begin { InitGLCode }
  FEntSysObj := EntSysObj;


End; { InitGLCode }

{-----------------------------------------}

procedure TCOMTransactionLines.AddNewLine;
Begin { AddNewLine }
  FEntSysObj.Transaction.thLines.AddNewLine;
End; { AddNewLine }

{-----------------------------------------}

function TCOMTransactionLines.Get_thLineCount: Integer;
Begin { AddNewLine }
  Result := FEntSysObj.Transaction.thLines.thLineCount;
End; { AddNewLine }

{-----------------------------------------}

function TCOMTransactionLines.Get_thLine(Index: Integer): ICOMTransactionLine;
Var
  FTransLineO : TCOMTransactionLine;
Begin { AddNewLine }
  // Create new interface each time as contents may change
  FTransLineO := TCOMTransactionLine.Create;
  FTransLineO.InitLine(FEntSysObj, FEntSysObj.Transaction.thLines.thLine[Index]);

  Result := FTransLineO;
End; { AddNewLine }

{-----------------------------------------}

function TCOMTransactionLines.Get_thCurrentLine: ICOMTransactionLine;
Var
  FTransLineO : TCOMTransactionLine;
Begin { AddNewLine }
  // Create new interface each time as contents may change
  FTransLineO := TCOMTransactionLine.Create;
  FTransLineO.InitLine(FEntSysObj, FEntSysObj.Transaction.thLines.thCurrentLine);

  Result := FTransLineO;
End; { AddNewLine }

{-----------------------------------------}

end.

