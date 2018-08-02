unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  CustWinU, CustAbsU, Classes;

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

var
  ButtonID : SmallInt; //Hook/Text ID for custom button that's being used. Public as it is used by LabelU


implementation

Uses
  Dialogs, SysUtils, ChainU, PISecure, PIMisc, APIUtil, Enterprise04_TLB, CtkUtil04, MathUtil, EnterpriseBeta_TLB;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

  sPlugInName = 'Convert Single POR To PIN Plug-In';
  sVersionNo = 'v7.0.11.001';

var
  PlugInEnabled : Boolean;
  MaxButtons : Byte;
  oToolkit : IToolkit;

//===========================================================================================================

//Procedure to show error message
procedure ShowError(const Msg : String);
begin
  msgBox(Msg, mtError, [mbOK], mbOK, sPlugInName);
end;

//===========================================================================================================

//Procedure to show information message
procedure ShowInfo(const Msg : String);
begin
  msgBox(Msg, mtInformation, [mbOK], mbOK, sPlugInName);
end;

//===========================================================================================================

//Function to return user id
function GetUserID(const EventData : TAbsEnterpriseSystem) : string;
begin
  //If we have access to the User Profile then use the User ID from there, otherwise use old UserName
  with EventData do
  begin
    if UserProfile.AccessRights <> NotAvailable then
      Result := UserProfile.upUserId
    else
      Result := UserName;
  end;
end; // GetUserID

//===========================================================================================================

//Opens/Closes the toolkit and sets data directory as needed
procedure HandleToolkit(HookID : Integer; const DataPath : string);
var
  Res : Integer;
begin
  if Assigned(oToolkit) then
  begin
    Case HookID of
      8 : oToolkit.CloseToolkit; //Company closed
      9,
     10 : begin //Initial or new company opened
            oToolkit.Configuration.DataDirectory := DataPath;
            Res := oToolkit.OpenToolkit;
            if Res <> 0 then
              ShowError('Error opening toolkit: ' + oToolkit.LastErrorString);
          end;
     end; //Case
  end;
end; //HandleToolkit

//===========================================================================================================

//Function to update PIN with user id
procedure UpdateTransaction(const PINRef : string; const UserID : string);
var
  Res : Integer;
  oTrans : ITransaction;
begin
  //Set UserID for audit notes
  (oToolkit.Configuration as IBetaConfig2).UserID := UserID;

  with oToolkit.Transaction do
  begin
    Try
      //Find transaction
      Res := GetEqual(BuildOurRefIndex(PINRef));

      //Did we find it?
      if Res <> 0 then
        raise Exception.Create(PINRef + ' not found.');

      //Try to update
      oTrans := Update;

      //Have we got a valid update object
      if not Assigned(oTrans) then
        raise Exception.Create('Unable to update transaction. It may be locked by another user');

      Try
        //Set user ID
        oTrans.thOperator := UserID;

        //Save the PIN
        Res := oTrans.Save(False);          

        //Did it save ok?
        if Res <> 0 then
          raise Exception.Create('Transaction save failed. ' + oToolkit.LastErrorString);
      Finally
        //Release update object
        oTrans := nil;
      End;

    Except
      on E:Exception do
        ShowError('Unable to set User Name on ' + PINRef + '.'#10#13 + E.Message);
    End;
  end;
end; // UpdateTransaction

//===========================================================================================================

//Converts the tranaaction and updates the PIN with the user id.
procedure ConvertTransaction(const OurRef : string; const UserId : string);
var
  Res : Integer;
  i   : Integer;
  SomethingToConvert : Boolean;
  PINRef : string;

  oConvert : ISingleConvert;
  oTrans : ITransaction;

  QtyDecimals : Byte;
begin
  with oToolkit.Transaction as ITransaction2 do
  begin
    //Find Transaction
    Res := GetEqual(BuildOurRefIndex(OurRef));

    if Res <> 0 then
    begin
      ShowError('Transaction ' + OurRef + ' not found.');
      EXIT;
    end;

    //Check for picked or w/o lines
    QtyDecimals := oToolkit.SystemSetup.ssQtyDecimals;
    SomethingToConvert := False;

    //Run through lines until we find either a picked or a written-off quantity
    for i := 1 to thLines.thLineCount do
      if not ZeroFloat(thLines[i].tlQtyPicked, QtyDecimals) or not ZeroFloat(thLines[i].tlQtyPickedWO, QtyDecimals) then
      begin
        SomethingToConvert := True;
        Break;
      end;

    if SomethingToConvert then //ok to go ahead
    begin
      //Get a single convert object
      oConvert := Convert(dtPIN);
      Try
        //Do conversion
        Res := oConvert.Execute;

        if Res = 0 then //completed sucessfully
        begin
          if oConvert.cvEndTransactionI = nil then //write off only
          begin
            PINRef := '';
            ShowInfo(OurRef + ' has been successfully posted.');
          end
          else //converted to PIN
          begin
            PINRef := oConvert.cvEndTransaction;
            ShowInfo(OurRef + ' has been successfully converted to ' + PINRef + '.');
          end;
        end  //Res = 0
        else
          ShowError('Conversion to PIN failed. ' + oToolkit.LastErrorString);
      Finally
        //Destroy conversion object
        oConvert := nil;
      End;

      if PINRef <> '' then //Set user id on newly created PIN
        UpdateTransaction(PINRef, UserID);

    end //If SomethingToConvert
    else
      ShowInfo('There are no received or written-off lines on this POR.')

  end; //With oToolkit.Transaction
end; // ConvertTransaction

//===========================================================================================================

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
var
  iPos : integer;
  slAboutText : TStringList;

  //Function to find unused custom button - returns Button ID or -1 if no buttons unused
  function FindFreeCustomButton : SmallInt;
  const
    ButtonIDs : Array[1..6] of SmallInt = (114, 124, 405, 415, 425, 435);
  var
    i : integer;
  begin
    Result := -1;
    with TAbsCustomHandlers01(CustomHandlers) do
    begin
      //Check version to see how many custom buttons we have
      if ClassVersion >= '7.0.058' then
        MaxButtons := 6
      else
        MaxButtons := 2;

      //Find first unused button
      for i := 1 to MaxButtons do
        if not HookPointEnabled(wiTransaction, ButtonIDs[i]) then
        begin
          Result := ButtonIDs[i];
          Break;
        end;
    end;
  end; // FindFreeCustomButton

begin
  CustomOn := True;

  //Check Plug-In Security
  PlugInEnabled := PICheckSecurity('EXCHRHCP2P0002891', 'bx6ft893ssab0b4a', sPlugInName
  , sVersionNo + ' (DLL)', stSystemOnly, ptDLL, DLLChain.ModuleName);

  //Find free custom button
  If PlugInEnabled Then
  begin
    ButtonID := FindFreeCustomButton;
    PlugInEnabled := ButtonID <> -1;

    if not PlugInEnabled then
      ShowError('Unable to allocate custom button. All are already in use.');
  end;

  //Create COM toolkit
  oToolkit := nil;
  if PlugInEnabled then
  begin
    Try
      oToolkit := CreateToolkitWithBackdoor;
      if not Assigned(oToolkit) then
        raise Exception.Create('Unknown Error');
    Except
      on E:Exception do
      begin
        PlugInEnabled := False;
        ShowError('Unable to create COM Toolkit.'#10#13 + E.Message);
      end;
    End;
  end;

  //Enable hook points
  if PlugInEnabled then
  With CustomHandlers Do Begin
    { Set About Message }
    slAboutText := TStringList.Create;
    Try
      PIMakeAboutText(sPlugInName, sVersionNo + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do
        AddAboutString(slAboutText[iPos]);
    Finally
      slAboutText.Free;
    End;

    // Enable custom button
    SetHandlerStatus(wiTransaction, ButtonID, EventEnabled);

    //Enable Open/Close company hook points
    SetHandlerStatus(wiMisc + 2, 10, EventEnabled);
    SetHandlerStatus(wiMisc + 2, 9, EventEnabled);
    SetHandlerStatus(wiMisc + 2, 8, EventEnabled);
  End; { With }

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End; // InitCustomHandler

//===========================================================================================================

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  //Release toolkit
  oToolkit := nil;
  { Put Shutdown Code Here }
End;

//===========================================================================================================

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Begin
  { Handle Hook Events here }
  with EventData do
  begin
    if (WinID = wiMisc + 2) and (HandlerID in [8, 9, 10]) then //Opening or closing company
      HandleToolkit(HandlerID, Setup.ssDataPath)
    else
    if (WinID = wiTransaction) and (HandlerID = ButtonID) then //Custom utton pressed
    begin
      //Is it a POR? If so then process it
      if Transaction.thInvDocHed = cuPOR then
        ConvertTransaction(Transaction.thOurRef, GetUserID(EventData))
      else
        ShowInfo('Invalid Transaction Type.'#10#13'The selected transaction is not a POR');
    end;
  end;
  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End; // ExecCustomHandler

end.
