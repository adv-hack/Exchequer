unit DemoF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses COMObj, CTKUtils, Enterprise01_TLB;

procedure TForm1.Button1Click(Sender: TObject);
Var
  oToolkit        : IToolkit;
  I1, I2, I3, Res : LongInt;
begin
  // Calculate backdoor password for COM Toolkit
  If CalcCTKPword (Application.ExeName, I1, I2, I3) Then Begin
    // Create COM Toolkit
    oToolkit := CreateOLEObject ('Enterprise01.Toolkit') as IToolkit;
    With oToolkit Do Begin
      // Set backdoor password
      Configuration.SetDebugMode(I1, I2, I3);

      // Open COM Toolkit
      Res := OpenToolkit;
      If (Res = 0) Then Begin
        ShowMessage ('COM Toolkit opened successfully'#13 +
                     'Version: ' + Version + #13 +
                     'Enterprise Dir: ' + Configuration.EnterpriseDirectory + #13 +
                     'Data Dir: ' + Configuration.DataDirectory + #13 +
                     'TK Release Code: ' + IntToStr(Ord(SystemSetup.ssReleaseCodes.rcToolkitDLL)));
        CloseToolkit;
      End { If (Res = 0) }
      Else
        // Error opening COM Toolkit
        ShowMessage ('OpenToolkit caused an error ' + IntToStr(Res) + #13#13 + LastErrorString);
    End; { With oToolkit }

    // Remove reference and destroy COM Toolkit instance
    oToolkit := NIL;
  End { If CalcCTKPword (I1, I2, I3) }
  Else
    // Error calculating the backdoor password - display Error Number returned in Param1
    ShowMessage ('Unable to initialise the Enterprise Link (' + IntToStr(I1) + ')');
end;

end.
