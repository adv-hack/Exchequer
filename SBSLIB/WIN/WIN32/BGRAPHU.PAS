unit Bgraphu;


{**************************************************************}
{                                                              }
{           ====----> Bar Graph Controller <----===            }
{                                                              }
{                      Created : 04/07/95                      }
{                                                              }
{                                                              }
{                                                              }
{               Copyright (C) 1995 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, VBXCtrl, Gauge, Buttons, ExtCtrls,GlobVar;

type
  TBarGraph = class(TForm)
    Panel1: TPanel;
    AbortBtn: TBitBtn;
    BiGauge1: TBiGauge;
    Label2: TLabel;
    Label1: TLabel;
    Image1: TImage;
    procedure AbortBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    StopProcess  :  Boolean;

    Procedure InitBar(PurgeNow  :  LongInt;
                      BarTit    :  Str80);

    Procedure ShowBar(PurgeNow  :  LongInt;
                      Mess      :  Str80);

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  AltDlgs,
  ETStrU,
  ETMiscU;

{$R *.DFM}



Procedure TBarGraph.InitBar(PurgeNow  :  LongInt;
                            BarTit    :  Str80);


Begin
  BiGauge1.Max:=PurgeNow;
  BiGauge1.Value:=0;

  StopProcess:=BOff;

  Caption:=BarTit;

end;



Procedure TBarGraph.ShowBar(PurgeNow  :  LongInt;
                            Mess      :  Str80);

Var
  Pc  :  LongInt;

Begin
  BiGauge1.Value:=PurgeNow;

  Pc:=Round(DivWChk(PurgeNow,BiGauge1.Max)*100);

  Label2.Caption:=Form_Int(Pc,0)+'%';

  If (Label1.Caption<>Mess) then
    Label1.Caption:=Mess;

end;


procedure TBarGraph.AbortBtnClick(Sender: TObject);

Var
  mbRet  :  Word;

begin
  If (Not StopProcess) then
  Begin
    mbRet:=AltMessageDlg('Please confirm you wish to abort.',mtConfirmation,[mbYes,mbNo],0);

    StopProcess:=(MbRet=MrYes);

    If (StopProcess) then
      Label1.Caption:='Aborting. Please wait.';

  end;
end;

end.



