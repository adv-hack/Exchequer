unit AccelLbl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TNotifyAccelEvent = procedure(Sender: TObject; AccChar: Char) of object;

  TSBSAccelLabel = class(TCustomLabel)
  private
    { Private declarations }
    FAccelChars : String;
    FOnAccel    : TNotifyAccelEvent;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure SetAccel(Value : String);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property Enabled;  { Inherited from somewhere }
    property AccelChars : String read FAccelChars write SetAccel;
    property OnAccel : TNotifyAccelEvent read FOnAccel write FOnAccel;
  end;

{procedure Register;}

implementation

{procedure Register;
begin
  RegisterComponents('sbs', [TSBSAccelLabel]);
end;}

constructor TSBSAccelLabel.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  Caption := 'Accel: ';
  ShowAccelChar := False;
end;

procedure TSBSAccelLabel.CMDialogChar(var Message: TCMDialogChar);
Var
  AccelStr : String;
  I        : Integer;
begin
  if Enabled And (Length(FAccelChars) > 0) Then
    For I := 1 To Length(FAccelChars) Do Begin
      AccelStr := '&' + FAccelChars[I];

      If IsAccel(Message.CharCode, AccelStr) then Begin
        Message.Result := 1;

        If Assigned (FOnAccel) Then
          FOnAccel (Self, FAccelChars[I]);

        Break;        { Exit for loop }
      End; { If }
    End; { For }
end;

procedure TSBSAccelLabel.SetAccel(Value : String);
begin
  If (Value <> FAccelChars) Then Begin
    FAccelChars := UpperCase (Value);
    Caption := 'Accel: ' + FAccelChars;
    Paint;
  End; { If }
end;

procedure TSBSAccelLabel.Paint;
begin
  If (csDesigning In ComponentState) Then
    Inherited Paint;
end;

end.
