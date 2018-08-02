unit DebugU;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  DebugBox,GlobVar,VarConst;

type
  TDebugForm = class(TForm)
    DebugBox1: TDebugBox;

  private
    { Private declarations }
  public
    { Public declarations }

    Procedure Add(A  :  String);

    Procedure Clear(A  :  String);

    Procedure Switch(A  :  Boolean);

  end;

var
  DebugForm: TDebugForm;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}

Procedure TDebugForm.Add(A  :  String);

Begin

  DebugBox1.Add(A);

end;

Procedure TDebugForm.Clear(A  :  String);

Begin

  DebugBox1.Clear;

end;

Procedure TDebugForm.Switch(A  :  Boolean);

Begin
  DebugBox1.Visible:=A;
end;

end.



