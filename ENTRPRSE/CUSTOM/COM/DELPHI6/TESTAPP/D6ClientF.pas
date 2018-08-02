unit D6ClientF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise_TLB, EntCustom;

type
  TForm1 = class(TForm)
    EntCustom1: TEntCustom;
    procedure EntCustom1Connect(ComCustomisation: ICOMCustomisation);
    procedure EntCustom1Close;
    procedure FormCreate(Sender: TObject);
    procedure EntCustom1Hook(EventData: ICOMEventData);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.EntCustom1Connect(ComCustomisation: ICOMCustomisation);
begin
  ComCustomisation.EnableHook (wiAccount, 31);
end;

procedure TForm1.EntCustom1Close;
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  EntCustom1.Connect;
end;

procedure TForm1.EntCustom1Hook(EventData: ICOMEventData);
Var
  UserFld : ShortString;
begin
  With EventData Do Begin
    If (WindowId = wiAccount) And (HandlerId = 31) Then Begin
      { User has tabbed out of Customer User Field 1 }
      UserFld := UpperCase(Trim(Customer.acUserDef1));

      { Check against pre-defined valid values }
      If (UserFld = 'A') Or (UserFld = 'ALPHA') Then
        Customer.acUserDef1 := 'Alpha'
      Else
        If (UserFld = 'B') Or (UserFld = 'BRAVO') Then
          Customer.acUserDef1 := 'Bravo'
        Else
          If (UserFld = 'C') Or (UserFld = 'CHARLIE') Then
            Customer.acUserDef1 := 'Charlie'
          Else
            { Invalid value }
            ValidStatus := False;
    End; { If (WindowId = wiAccount) And (HandlerId = 31) }
  End; { With EnterpriseSystem }
end;

end.
