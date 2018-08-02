unit SchCustm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComObj, ExSchedulerEvents, ExScheduler_TLB;

Const
  ComponentVerNo = '5.70.034';

type
  TOnProgressProc = Procedure (const sMessage : WideString; iPercent : Integer) Of Object;

  TExSchedCustom = class(TComponent)
  private
    // Connected Status
    FConnected        : Boolean;
    // COM Customisation Interface
    FScheduledTask       : IScheduledTask;
    // COM Customisation Events Interface - using Binh Ly Component
    FExSchedulerEvents : TIScheduledTaskEvents;
    // Hook Event
    FOnProgress           : TOnProgressProc;

  protected
    { Protected declarations }
    Procedure EventOnProgress (const sMessage : WideString; iPercent : Integer);

    Function GetIntf : IScheduledTask;

    Function GetVersion : String;
  public
    { Public declarations }
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; OverRide;

    Function  Connect : Boolean;
    Procedure Disconnect;
    Property Version : String Read GetVersion;

    { Properties available in code }
    Property Connected : Boolean Read FConnected;
    Property Intf : IScheduledTask Read GetIntf;
    Property OnProgress : TOnProgressProc Read FOnProgress Write FOnProgress;
    property ScheduledTask : IScheduledTask read FScheduledTask write FScheduledTask;
  end;

implementation

{---------------------------------------------------------------------------}

Constructor TExSchedCustom.Create(AOwner : TComponent);
Begin { Create }
  Inherited Create(AOwner);

  FConnected := False;

  FExSchedulerEvents := TIScheduledTaskEvents.Create(Self);
  With FExSchedulerEvents Do Begin
    OnProgress  := EventOnProgress;
  End; { With FEnterpriseEvents }
End; { Create }

{--------------------------}

Destructor TExSchedCustom.Destroy;
Begin { Destroy }
  // Disconnect and current link
  If FConnected Then
    Disconnect;

  FExSchedulerEvents.Free;
  FExSchedulerEvents := Nil;


  Inherited Destroy;
End; { Destroy }

{--------------------------}

Function TExSchedCustom.Connect : Boolean;
Begin { Connect }
  // Check not already connected to COM Customisation
  If (Not FConnected) Then Begin

    If Assigned(FScheduledTask) Then Begin
      FExSchedulerEvents.Connect (FScheduledTask);

      FConnected := True;

    End; { If Assigned(FEnterprise) }

    Result := Assigned(FScheduledTask) And FConnected;
  End { If (Not FConnected) }
  Else
    Result := True;
End; { Connect }

{--------------------------}

Procedure TExSchedCustom.Disconnect;
Begin { Disconnect }
  // Check we are connected to COM Customisation
  If FConnected Then Begin
    If Assigned(FExSchedulerEvents) Then
      // disconnect event sink from COM Object
      FExSchedulerEvents.Disconnect;

    // dereference COM Object
    FScheduledTask := Nil;
  End; { If FConnected }
End; { Disconnect }

{--------------------------}

procedure TExSchedCustom.EventOnProgress (const sMessage : WideString; iPercent : Integer);
Begin { EventOnHook }
  If Assigned (FOnProgress) Then
    FOnProgress (sMessage, iPercent);
End; { EventOnHook }

{--------------------------}



Function TExSchedCustom.GetIntf : IScheduledTask;
Begin { GetInterface }
  Result := FScheduledTask;
End; { GetInterface }

{--------------------------}

function TExSchedCustom.GetVersion: String;
begin
//  Result := ComponentVerNo + ' (';

end;

end.
