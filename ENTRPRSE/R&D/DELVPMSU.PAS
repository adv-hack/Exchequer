unit DelvPMsU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Gauges,  BTSupU1,
  BTSupU3,SBSComp2;

type

  TTestPrnMsg = class(TForm)
    TestCP1Btn: TButton;
    SBSPanel3: TSBSPanel;
    Label1: Label8;
    Label2: Label8;
    CanCP1Btn: TButton;
    OKCp1Btn: TButton;
    procedure FormCreate(Sender: TObject);

    private

      procedure ShutDown;


    public
      { Public declarations }

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  GlobVar,
  VarConst,

  BTSupU2;

{$R *.DFM}




procedure TTestPrnMsg.ShutDown;

Begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;



procedure TTestPrnMsg.FormCreate(Sender: TObject);
begin
  ClientHeight:=131;
  ClientWidth:=337;

  Left:=Round((Screen.Width/2)-(Width/2));
  Top:=Round((Screen.Height/2)-(Height/2));

  Caption:='Paper Change!';
end;

end.
