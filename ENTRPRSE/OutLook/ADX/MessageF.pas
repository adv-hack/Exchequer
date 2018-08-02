unit MessageF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;


Const
  WM_WindowRegister = WM_USER + 1;


type
  TMessageEvent = Procedure (var Message: TMessage) Of Object;

  TfrmOCXMessaging = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FOnMessage : TMessageEvent;
    procedure WMWindowRegister(var Message: TMessage); message WM_WindowRegister;
  public
    { Public declarations }
    Property OnMessage : TMessageEvent Read FOnMessage Write FOnMessage;
  end;

implementation

{$R *.dfm}

Uses KPIManagerU;

procedure TfrmOCXMessaging.FormCreate(Sender: TObject);
begin
  FOnMessage := NIL;
end;
                           
//-------------------------------------------------------------------------

procedure TfrmOCXMessaging.WMWindowRegister(var Message: TMessage);
Begin // WMWindowRegister
  // Pass message to SectionManager to be passed onto the appropriate destination
  If Assigned(FOnMessage) Then
  Begin
    FOnMessage (Message);
  End; // If Assigned(FOnMessage)
End; // WMWindowRegister

//-------------------------------------------------------------------------

end.
