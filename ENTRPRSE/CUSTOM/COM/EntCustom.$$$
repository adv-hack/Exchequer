unit EntCustom;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComObj, Enterprise_TLB, EnterpriseEvents;

Const
  ComponentVerNo = '5.70.034';

type
  TOnCloseProc = Procedure Of Object;
  TOnConnectProc = Procedure (ComCustomisation: ICOMCustomisation) Of Object;
  TOnHookProc = Procedure (EventData: ICOMEventData) Of Object;

  TEntCustom = class(TComponent)
  private
    { Private declarations }
    // About Text
    FAboutText        : TStrings;
    // Automatically Disconnect when OnClose event received
    FAutoDisconnect   : Boolean;
    // Connected Status
    FConnected        : Boolean;
    // COM Customisation Interface
    FEnterprise       : ICOMCustomisation;
    // COM Customisation Events Interface - using Binh Ly Component
    FEnterpriseEvents : TICOMCustomisationEvents;
    // Exchequer Closing Event
    FOnClose          : TOnCloseProc;
    // Successful Connection Event
    FOnConnect        : TOnConnectProc;
    // Hook Event
    FOnHook           : TOnHookProc;

    Procedure PublishAboutText;
    function GetUserProfile: ICOMUserProfile;
    function GetSystemSetup: ICOMSetup;
  protected
    { Protected declarations }
    Procedure EventOnHook (Sender : TObject; const EventData: ICOMEventData);
    procedure EventOnClose (Sender : TObject);

    Function GetClassVersion : ShortString;
    Function GetIntf : ICOMCustomisation;
    Procedure SetAboutText (Value : TStrings);

    Function GetVersion : String;
    Procedure SetVersion(Const Value: String);
  public
    { Public declarations }
    Constructor Create (AOwner : TComponent); OverRide;
    Destructor Destroy; OverRide;

    Procedure AddLabelCustomisation (WindowId : Integer;
                                     TextId   : Integer;
                                     Caption  : ShortString);
    procedure AddLabelCustomisationEx(      WindowId: Integer;
                                            TextId: Integer;
                                      const Caption: WideString;
                                      const FontName: WideString;
                                            FontSize: Integer;
                                            FontBold: WordBool = False;
                                            FontItalic: WordBool = False;
                                            FontUnderline: WordBool = False;
                                            FontStrikeOut: WordBool = False;
                                            FontColorRed: Integer = -1;
                                            FontColorGreen: Integer = -1;
                                            FontColorBlue: Integer = -1);
    Function  Connect : Boolean;
    Procedure Disconnect;
    function  MessageDlg(DialogType: TEntMsgDlgType; const Message: WideString; Buttons: Integer): TEntMsgDlgReturn;
    Procedure ReturnFocusToEnterprise;
    Procedure TransferFocusToClientForm (Const ClientForm : TForm);
  published
    { Published Properties - Property Inspector }
    Property AboutText : TStrings Read FAboutText Write SetAboutText;
    Property AutoDisconnect : Boolean Read FAutoDisconnect Write FAutoDisconnect Default True;
    Property Version : String Read GetVersion Write SetVersion;

    { Properties available in code }
    Property ClassVersion : ShortString Read GetClassVersion;
    Property Connected : Boolean Read FConnected;
    Property Intf : ICOMCustomisation Read GetIntf;
    property SystemSetup: ICOMSetup read GetSystemSetup;
    Property UserProfile : ICOMUserProfile Read GetUserProfile;

    { Published Events }
    Property OnClose : TOnCloseProc Read FOnClose Write FOnClose;
    Property OnConnect : TOnConnectProc Read FOnConnect Write FOnConnect;
    Property OnHook : TOnHookProc Read FOnHook Write FOnHook;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Exchequer', [TEntCustom]);
end;

{---------------------------------------------------------------------------}

Constructor TEntCustom.Create (AOwner : TComponent);
Begin { Create }
  Inherited Create (AOwner);

  FAutoDisconnect := True;
  FConnected := False;

  FAboutText := TStringList.Create;

  FEnterpriseEvents := TICOMCustomisationEvents.Create(Self);
  With FEnterpriseEvents Do Begin
    OnHook  := EventOnHook;
    OnClose := EventOnClose;
  End; { With FEnterpriseEvents }
End; { Create }

{--------------------------}

Destructor TEntCustom.Destroy;
Begin { Destroy }
  // Disconnect and current link
  If FConnected Then
    Disconnect;

  FEnterpriseEvents.Free;
  FEnterpriseEvents := Nil;

  FAboutText.Free;

  Inherited Destroy;
End; { Destroy }

{--------------------------}

Function TEntCustom.Connect : Boolean;
Begin { Connect }
  // Check not already connected to COM Customisation
  If (Not FConnected) Then Begin
    Try
      // Try to connect to an existing COM Customisation object
      FEnterprise := GetActiveOleObject ('Enterprise.COMCustomisation') As ICOMCustomisation;
    Except
      Try
        // Create new COM Customisation object
        FEnterprise := CreateOleObject ('Enterprise.COMCustomisation') As ICOMCustomisation;
      Except
        FEnterprise := Nil;
      End;
    End;

    If Assigned(FEnterprise) Then Begin
      // Setup Help|About text
      PublishAboutText;

      // Connect event sink to object
      FEnterpriseEvents.Connect (FEnterprise);

      FConnected := True;

      // Execute OnConnect event if defined
      If Assigned(FOnConnect) Then
        FOnConnect(FEnterprise);
    End; { If Assigned(FEnterprise) }

    Result := Assigned(FEnterprise) And FConnected;
  End { If (Not FConnected) }
  Else
    Result := True;
End; { Connect }

{--------------------------}

Procedure TEntCustom.Disconnect;
Begin { Disconnect }
  // Check we are connected to COM Customisation
  If FConnected Then Begin
    If Assigned(FEnterpriseEvents) Then
      // disconnect event sink from COM Object
      FEnterpriseEvents.Disconnect;

    // dereference COM Object
    FEnterprise := Nil;
  End; { If FConnected }
End; { Disconnect }

{--------------------------}

procedure TEntCustom.EventOnHook (Sender : TObject; const EventData: ICOMEventData);
Begin { EventOnHook }
  If Assigned (OnHook) Then
    FOnHook (EventData);
End; { EventOnHook }

{--------------------------}

procedure TEntCustom.EventOnClose (Sender : TObject);
Begin { EventOnClose }
  // Automatically Disconnect if option is enabled
  If FAutoDisconnect Then
    Disconnect;

  // Execute the OnClose event if defined
  If Assigned (OnClose) Then
    FOnClose;
End; {  }

{--------------------------}

Function TEntCustom.GetClassVersion : ShortString;
Begin { GetClassVersion }
  If Assigned(FEnterprise) Then
    Result := FEnterprise.ClassVersion
  Else
    Result := 'Not Available';
End; { GetClassVersion }

{--------------------------}

Procedure TEntCustom.SetAboutText (Value : TStrings);
Begin { SetAboutText }
  FAboutText.Assign (Value);
End; { SetAboutText }

{--------------------------}

Procedure TEntCustom.PublishAboutText;
Var
  I   : SmallInt;
Begin { PublishAboutText }
  If (FAboutText.Count > 0) Then
    For I := 0 To Pred(FAboutText.Count) Do
      FEnterprise.AddAboutString(FAboutText[I]);
End; { PublishAboutText }

{--------------------------}

Function TEntCustom.GetIntf : ICOMCustomisation;
Begin { GetInterface }
  Result := FEnterprise;
End; { GetInterface }

{--------------------------}

function TEntCustom.GetVersion: String;
begin
  Result := ComponentVerNo + ' (';

  {$IFDEF VER140}
    Result := Result + 'Delphi 6.01)';
  {$ELSE}
    {$IFDEF VER130}
      Result := Result + 'Delphi 5.0)';
    {$ELSE}
      {$IFDEF VER150}
        Result := Result + 'Delphi 7.1)';
      {$ELSE}
        Result := Result + 'Unknown);
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
end;

procedure TEntCustom.SetVersion(const Value: String);
begin
  // No action - version not read/write - Set needed to make it visible in the property inspector
end;

{--------------------------}

function TEntCustom.GetUserProfile: ICOMUserProfile;
begin
  With FEnterprise As ICOMCustomisation3 Do
    Result := UserProfile;
end;

{--------------------------}

function TEntCustom.GetSystemSetup: ICOMSetup;
begin
  Result := FEnterprise.SystemSetup;
end;

{--------------------------}

procedure TEntCustom.ReturnFocusToEnterprise;
begin
  SetForegroundWindow(FEnterprise.SysFunc.hwnd)
end;

{--------------------------}

procedure TEntCustom.TransferFocusToClientForm(const ClientForm: TForm);
begin
  FEnterprise.SysFunc.entActivateClient(ClientForm.Handle);
end;

{--------------------------}

function TEntCustom.MessageDlg(      DialogType : TEntMsgDlgType;
                               Const Message    : WideString;
                                     Buttons    : Integer): TEntMsgDlgReturn;
begin
  Result := FEnterprise.SysFunc.entMessageDlg(DialogType, Message, Buttons);
end;

{--------------------------}

procedure TEntCustom.AddLabelCustomisation(WindowId, TextId: Integer; Caption: ShortString);
begin
  With FEnterprise As ICOMCustomisation2 Do
    AddLabelCustomisation(WindowId, TextId, Caption);
end;

procedure TEntCustom.AddLabelCustomisationEx(      WindowId: Integer;
                                                   TextId: Integer;
                                             const Caption: WideString;
                                             const FontName: WideString;
                                                   FontSize: Integer;
                                                   FontBold: WordBool = False;
                                                   FontItalic: WordBool = False;
                                                   FontUnderline: WordBool = False;
                                                   FontStrikeOut: WordBool = False;
                                                   FontColorRed: Integer = -1;
                                                   FontColorGreen: Integer = -1;
                                                   FontColorBlue: Integer = -1);
begin
  With FEnterprise As ICOMCustomisation2 Do
    AddLabelCustomisationEx(WindowId, TextId, Caption, FontName, FontSize,
                            FontBold, FontItalic, FontUnderline, FontStrikeOut,
                            FontColorRed, FontColorGreen, FontColorBlue);
end;

end.
