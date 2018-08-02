// Implementation of the Hook Point object which keeps track of enabled hook points
unit oHookPnt;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

Uses Classes, SysUtils, Windows, EnterpriseTrade_TLB;

Const
  // Number of Window Id's supported by the Customisation System - can be extended at will but
  // should be kept to the minimum necessary to minimise memory usage.
  MaxWindowId = 7;
  // Number of Handler Id's supported per Window Id by the Customisation System - can be extended
  // at will but should be kept to the minimum necessary to minimise memory usage.
  MaxHandlerId = 200;

Type
  // Array stores the hook point status flags.
  // NOTE 1: Can't do an array of TTradeWindowIds as the Delphi Compiler doesn't like the COM Enumerated Type.
  // NOTE 2: Not using a Packed Array as it would kill performance even though it would save memory.
  // NOTE 3: Not using {$ALIGN 8} to imporove performance as it would x8 the memory used!
  // NOTE 4: Two used by TTradeCustomisation and another Two per Plug-In
  // Current Size = 6 * 200 = 1200 bytes per array
  THookPointArray = Array [1..MaxWindowId, 1..MaxHandlerId] Of Boolean;

  THookPointStatus = Class(TObject)
  Private
    // Array stores the hook point status flags.
    FHookPointStatus : ^THookPointArray;

    function GetHookPoints(WindowId: TTradeWindowIds; HandlerId: Integer): TTradeHookStatus;
    procedure SetHookPoints(WindowId: TTradeWindowIds; HandlerId: Integer; const Value: TTradeHookStatus);
  Protected
    function WindowIdToArrayId (WindowId: TTradeWindowIds) : Integer;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Property StatusArray[WindowId: TTradeWindowIds; HandlerId: Integer] : TTradeHookStatus Read GetHookPoints Write SetHookPoints;
  End;

implementation

Uses Dialogs;

//---------------------------------------------------------------------------

Constructor THookPointStatus.Create;
Begin { Create }
  Inherited;

  // Initialise the Hook Point Status Array
  New (FHookPointStatus);
  FillChar (FHookPointStatus^, SizeOf(FHookPointStatus^), #0);
End; { Create }

//----------------------------------------

Destructor THookPointStatus.Destroy;
Begin { Destroy }
  // De-Allocate the memory for the Hook Point Status Array
  Dispose (FHookPointStatus);

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

// Converts a Type Library WindowId into the internal array index representing that window.
// Not just using the Ord(TTradeWindowIds) as this method is safer, less chance of cockups.
function THookPointStatus.WindowIdToArrayId (WindowId: TTradeWindowIds) : Integer;
Begin { WindowIdToArrayId }
  // NOTE: Ensure MaxWindowId is updated appropriately when adding new WindowIds into this list
  Result := WindowId;
{  Case WindowId Of
    twiSystem          : Result := 1;
    twiLogin           : Result := 2;
    twiTransaction     : Result := 3;
    twiTransactionLine : Result := 4;
    twiNonStock : Result := 4;
    twiSerialNumbers   : Result := 5;
    twiTender          : Result := 6;
  Else
    Raise Exception.Create ('THookPointStatus.WindowIdToArrayId: Unhandled WindowId (' + IntToStr(Ord(WindowId)) + ')');
  End; { Case WindowId }

  // Safety Check - Ensure returned Array Index is within valid range
  If (Result < 1) Or (Result > MaxWindowId) Then
    Raise Exception.Create ('THookPointStatus.WindowIdToArrayId: Max WindowId Exceeded (' + IntToStr(Ord(WindowId)) + ')');
End; { WindowIdToArrayId }

//---------------------------------------------------------------------------

function THookPointStatus.GetHookPoints(WindowId: TTradeWindowIds; HandlerId: Integer): TTradeHookStatus;
begin
  // Check HandlerId is valid before continuing
  If (HandlerId < 1) Or (HandlerId > MaxHandlerId) then
    Raise Exception.Create ('THookPointStatus.GetHookPoints: Max HandlerId Exceeded (' + IntToStr(HandlerId) + ')');

  // Return the setting from the array converted from Boolean to the TLB Enumerated Type
  if FHookPointStatus^[WindowIdToArrayId(WindowId), HandlerId] Then
    Result := thsEnabled
  Else
    Result := thsDisabled;
end;

//----------------------------------------

procedure THookPointStatus.SetHookPoints(WindowId: TTradeWindowIds; HandlerId: Integer; const Value: TTradeHookStatus);
begin
  // Check HandlerId is valid before continuing
  If (HandlerId < 1) Or (HandlerId > MaxHandlerId) then
    Raise Exception.Create ('THookPointStatus.SetHookPoints: Max HandlerId Exceeded (' + IntToStr(HandlerId) + ')');

  // Check Value is valid before continuing
  If (Value = thsEnabledOther) Then
    Raise Exception.Create ('THookPointStatus.SetHookPoints: The Hook Point Status cannot be set to thsEnabledOther');

  // Set the array element representing the WindowId/HandlerId
  FHookPointStatus^[WindowIdToArrayId(WindowId), HandlerId] := (Value = thsEnabled);
end;

//---------------------------------------------------------------------------

end.
