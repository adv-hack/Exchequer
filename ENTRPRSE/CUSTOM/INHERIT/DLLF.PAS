unit DllF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, InhAbstr;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


Procedure DisplayClassInfo (Const OCustom : TAbsEnterpriseSystem03); Export; StdCall;

implementation

{$R *.DFM}

Procedure DisplayClassInfo (Const OCustom : TAbsEnterpriseSystem03);
var
  Form1: TForm1;
Begin { DisplayClassInfo }
  Form1 := TForm1.Create(Application);
  Try
    With Form1.ListBox1.Items, OCustom Do Begin
      // TAbsEnterpriseSystem fields
      Add ('Customer.Field1:' + #9 + Customer.Field1);

      // TAbsEnterpriseSystem01 fields
      Add ('Customer.Field2:' + #9 + Customer.Field2);
      Customer.Field2 := 'Df2*';

      // TAbsEnterpriseSystem02 fields
      Add ('Customer.SubClass.Field1:' + #9 + Customer.SubClass.Field1);

      // TAbsEnterpriseSystem03 fields
      Add ('Customer.SubClass.Field2:' + #9 + Customer.SubClass.Field2);
      Customer.SubClass.Field2 := 'Df2*';
    End; { With }

    Form1.ShowModal;
  Finally
    Form1.Destroy;
  End;
End; { DisplayClassInfo }

end.
