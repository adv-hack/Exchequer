unit ElHooku;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ElEvDefs, ElVar, ElObjs, Enterprise_TLB;

procedure ProcessEvent(const EventData: ICOMEventData);

var
  ThisElert : TElertObject;
  ThisLine  : TEvent;


implementation

uses
  SysUtils;



function EventKey(const EventData: ICOMEventData) : ShortString;
var
  Account : ICOMCustomer;
begin
  if EventData.Supplier.AccessRights = arNotAvailable then
    Account := EventData.Customer
  else
    Account := EventData.Supplier;

  with EventData do
  begin
    Case EventData.WindowId  of
      AccWindow     :  begin
                         Result := Account.acCode;
                       end;
      TransWindow   :  begin
                         Result := Transaction.thOurRef;
                       end;
      StockWindow   :  begin
                         Result := Stock.stCode;
                       end;
      JobWindow     :  begin
                         Result := Job.jrJobCode;
                       end;
      else
        Result := '';
    end;// Case
    Result := Trim(Result);
    Account := nil;
  end; //with
end;



function FileNum(const EventData: ICOMEventData) : Byte;
var
  IsCust : Boolean;
begin
  IsCust := EventData.Supplier.AccessRights = arNotAvailable;
  Case EventData.WindowID of
    AccWindow     :  if IsCust then
                       Result := 1
                     else
                       Result := 2;
    TransWindow   :  Result := 3;
    StockWindow   :  Result := 6;
    JobWindow     :  Result := 22;
    else
      Result := 0;
  end;
end;

(* Old style ------------------------------
procedure ProcessEvent(const EventData: ICOMEventData);
var
  Res : SmallInt;
  WinID, HandID : longint;
begin
  Try
    WinID := EventData.WindowID;
    HandID := EventData.HandlerID;
    ThisElert.WindowID := WinID;
    ThisElert.HandlerID := HandID;
    ThisElert.Index := elIdxEvent;

    Res := ThisElert.GetEqual('');

    while (Res = 0) and
          (ThisElert.WindowID = WinID) and
          (ThisElert.HandlerID = HandID) do
    begin

      if ThisElert.Active and not ThisElert.Expired then
      begin
{        ThisLine.UserID := ThisElert.UserID;
        ThisLine.ElertName := ThisElert.ElertName;
        ThisLine.Index := ellIdxOutputType;

        Res := ThisLine.GetEqual('');

        while (Res = 0) and
              (ThisLine.ElertName = ThisElert.ElertName) and
              (ThisLine.UserID = ThisElert.UserID) do
        begin
          ThisElert.Instance := ThisLine.Instance;

          Res := ThisLine.GetNext;
        end;                      }

        ThisLine.UserID := ThisElert.UserID;
        ThisLine.ElertName := ThisElert.ElertName;
        ThisLine.Instance := {ThisElert.Instance + 1}0;

        ThisLine.Key := EventKey(EventData);

        ThisLine.FileNo := FileNum(EventData);

        ThisLine.Add;
      end; //if active & not expired

      Res := ThisElert.GetNext;

    end;
  Finally
{    ThisElert.Free;
    ThisLine.Free;}
  End;
end;  *)

procedure ProcessEvent(const EventData: ICOMEventData);
var
  WID, HID : longint;
begin
  WID := EventData.WindowID;
  HID := EventData.HandlerID;

  ThisElert.WindowID := WID;
  ThisElert.HandlerID := HID;
  ThisElert.Index := elIdxEvent;

  if (ThisElert.GetEqual('') = 0) and
     (ThisElert.WindowID = WID) and
     (ThisElert.HandlerID = HID) then
  begin
    ThisLine.UserID := SysUser;
    ThisLine.ElertName := SysElertName;
    ThisLine.Instance := 0;

    ThisLine.Key := EventKey(EventData);

    ThisLine.FileNo := FileNum(EventData);

    ThisLine.WinId := WID;
    ThisLine.HandID := HID;

    ThisLine.Add;
  end;
end;


end.
