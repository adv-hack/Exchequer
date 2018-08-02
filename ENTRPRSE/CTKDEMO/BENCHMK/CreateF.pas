unit CreateF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise01_TLB, StdCtrls;

type
  TForm1 = class(TForm)
    memResults: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Z1,Z2,Z3:Integer;

implementation

{$R *.dfm}

Uses PerfUtil, COMObj;

procedure TForm1.Button1Click(Sender: TObject);
Var
  I : SmallInt;
  oToolkit : IToolkit;
  StartCreateTime, EndCreateTime, EndNILCreateTime : Int64;
begin
  For I := 1 To 10 Do
  Begin
    StartCreateTime := RDTSC;
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
    EndCreateTime := RDTSC;
    oToolkit := NIL;
    EndNILCreateTime := RDTSC;

    MemResults.Lines.Add (Format('Create, %d, NIL, %d', [EndCreateTime - StartCreateTime, EndNILCreateTime - EndCreateTime]));
  End; // For I
end;

end.

398807160   216
32769996    288
537893124   588
611588424   288
534537900   300
41100120    288
44208408    288
529365072   288
632648556   288
519484620   288
67390344    876
99405000    852
96752532    876
95068164    864
93898188    600
94828224    600
95694828    876
86265216    288
52612464    288
52320792    288
67177728    912
476853984   876
672948660   852
93966972    876
92518476    936
92942832    876
93150336    864
92908500    888
92891952    864
92629896    576
67609836    912
95295480    876
477566664   936
667530000   876
91828368    864
84323376    288
50590536    288
99181848    288
72319128    288
60440736    288
66486048    876
479465724   876
669218004   876
74647488    288
517850448   288
629819388   288
54973428    288
61727916    288
71919684    288
62402772    288
67911396    852
96175344    876
478192932   876
670921656   876
670391220   288
92095872    288
510069384   288
695787360   288
Create, 71564952, NIL, 288
Create, -510741900, NIL, 288
Create, 68981328, NIL, 876
Create, -473114508, NIL, 876
Create, 672080412, NIL, 864
Create, 89953488, NIL, 288
Create, 56170092, NIL, 288
Create, 630097608, NIL, 288
Create, -518127612, NIL, 288
Create, 653432976, NIL, 288
Create, 64381152, NIL, 288
Create, 70771332, NIL, 288
