unit eventfnc;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ElEvDefs, ElVar, ElObjs, ElEvent_TLB;

function ProcessEvent(WID, HID : integer; DType : TEventDataType; AKey : string) : integer;

var
  ThisElert : TElertObject;
  ThisLine  : TEvent;


implementation

uses
  SysUtils, CustWinU;




function ProcessEvent(WID, HID : integer; DType : TEventDataType; AKey : string) : integer;


  function FileNum : Byte;
  var
    IsCust : Boolean;
  begin
    IsCust := DType = edtCustomer;
    Case WID of
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

begin

  ThisElert := TElertObject.Create;
  ThisLine := TEvent.Create;
  Result := 0;
  Try
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

      ThisLine.Key := AKey;

      ThisLine.FileNo := FileNum;

      if ThisLine.FileNo = 0 then
        Result := 1001;

      ThisLine.WinId := WID;
      ThisLine.HandID := HID;

      if Result = 0 then
        Result := ThisLine.Add;
    end;
  Finally
    ThisElert.Free;
    ThisLine.Free;
  End;
end;


end.
