unit DownProg;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, VarConst, SaleItem, NeilProc;

type
  TFrmDownloadItems = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    lStatus: TLabel;
    Label2: TLabel;
    lName: TLabel;
    ProgressBar1: TProgressBar;
    WaitForOpen: TTimer;
    procedure WaitForOpenTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    iSGroup, iEGroup, iSDept, iEDept, iSPlu, iEPlu : LongInt;
    bEOD : boolean;
    Procedure DoDownLoad;
  public
    Procedure SetParams(Const SGroup, EGroup, SDept, EDept, SPlu, EPlu : LongInt; isEOD : Boolean = FALSE);
  end;

implementation

uses Comms;

{$R *.DFM}


{ Downloads all the groups, depts, and PLU's }

Procedure TFrmDownloadItems.SetParams(Const SGroup, EGroup, SDept, EDept, SPlu
, EPlu : LongInt; isEOD : Boolean = FALSE);
begin
  iSGroup := SGroup;
  iEGroup := EGroup;
  iSDept := SDept;
  iEDept := EDept;
  iSPlu := SPlu;
  iEPlu := EPlu;
  bEOD := isEOD;
end;


procedure TFrmDownloadItems.WaitForOpenTimer(Sender: TObject);
begin
  WaitForOpen.Enabled := FALSE;
  DoDownLoad;
  Close;
end;

procedure TFrmDownloadItems.FormShow(Sender: TObject);
begin
  WaitForOpen.Enabled := TRUE;
end;

end.
