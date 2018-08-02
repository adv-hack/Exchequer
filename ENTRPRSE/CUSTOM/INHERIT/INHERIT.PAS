unit Inherit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, InhAbstr, InhImpl, RPDefine, RPBase, RPCanvas, RPrinter;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Procedure DisplayClassInfo (Const OCustom : TAbsEnterpriseSystem); StdCall; External 'InhTest.Dll';

procedure TForm1.Button1Click(Sender: TObject);
Var
  OCustom : TEnterpriseSystem;

  Procedure PrintDebugStuff (OCustom : TAbsEnterpriseSystem03);
  Begin { PrintDebugStuff }
    With ListBox1, Items, OCustom Do Begin
      // TAbsEnterpriseSystem fields
      Add ('Customer.Field1:' + #9 + Customer.Field1);

      // TAbsEnterpriseSystem01 fields
      Add ('Customer.Field2:' + #9 + Customer.Field2);

      // TAbsEnterpriseSystem02 fields
      Add ('Customer.SubClass.Field1:' + #9 + Customer.SubClass.Field1);

      // TAbsEnterpriseSystem03 fields
      Add ('Customer.SubClass.Field2:' + #9 + Customer.SubClass.Field2);
    End; { With ListBox1, Items, OCustom }
  End; { PrintDebugStuff }

begin
  OCustom := TEnterpriseSystem.Create;
  DisplayClassInfo (OCustom);
  PrintDebugStuff (OCustom);
  OCustom.Destroy;
end;


end.
