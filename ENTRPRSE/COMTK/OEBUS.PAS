unit oEBus;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, MiscFunc;

type
  TEBusiness = class(TAutoIntfObject, IEBusiness)
  private
    // Note: All properties protected to allow descendants access

    // eBusiness Daybook
    FDayBookO  : Pointer;
    FDayBookI  : Pointer;

    // Main Toolkit object
    FToolkit   : TObject;
  protected
    // IJobCosting

    // Local methods
    Procedure InitObjects;
  public
    Constructor Create (Const Toolkit : TObject);
    Destructor Destroy; override;
  end; { TEBusiness }

implementation

uses ComServ;

{-------------------------------------------------------------------------------------------------}

constructor TEBusiness.Create(const Toolkit: TObject);
begin
  Inherited Create (ComServer.TypeLib, IEBusiness);

  // ensure all sub-objects initialised correctly
  InitObjects;

  // record handle to Toolkit object
  FToolkit := Toolkit;
end;

{-----------------------------------------}

destructor TEBusiness.Destroy;
begin
  { Destroy sub-ojects }
  InitObjects;

  inherited;
end;

{-----------------------------------------}

Procedure TEBusiness.InitObjects;
Begin { InitObjects }
  // eBusiness Daybook
  FDayBookO  := NIL;
  FDayBookI  := NIL;

  // Main Toolkit object
  FToolkit := Nil;
End; { InitObjects }

end.
