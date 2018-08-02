unit AutoEOD;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StrUtil,
  StdCtrls, ExtCtrls, VarConst, EOD, NeilProc, CardProc, Progress, ComCtrls, APIUtil;

type
  TFrmAutoEOD = class(TForm)
    btnCancel: TButton;
    Panel1: TPanel;
    lAEODTime: TLabel;
    Label2: TLabel;
    timEOD: TTimer;
    Label3: TLabel;
    lTime: TLabel;
    Label4: TLabel;
    lDate: TLabel;
    lbDatesDone: TListBox;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    ProgressBar1: TProgressBar;
    Label5: TLabel;
    lStatus: TLabel;
    Label6: TLabel;
    lName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure timEODTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    slDatesDone : TStringList;
    iStartRunNo, iEndRunNo : integer;
    procedure AppActivate(Sender: TObject);
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TFrmAutoEOD.FormCreate(Sender: TObject);
begin
  slDatesDone := TStringList.Create;
  iStartRunNo := 2147483647;
  iEndRunNo := -1;
  lAEODTime.Caption := 'An End of Day will be executed daily at ' + Syss.EODTime;
  timEOD.Enabled := TRUE;
  Application.OnActivate := AppActivate;
end;

procedure TFrmAutoEOD.AppActivate(Sender: TObject);
begin
  if WindowState = wsMinimized then WindowState := wsNormal;
end;

procedure TFrmAutoEOD.timEODTimer(Sender: TObject);
var
  sCompareTime, sNewTime, sNewDate : string;
  wHour, wMin, wSec, wMSec : Word;
  iCurrRunNo, iRunNo : integer;
begin
  timEOD.Enabled := FALSE;

  sNewTime := TimeToStr(Now);
  if lTime.Caption <> sNewTime then lTime.Caption := sNewTime;

  sNewDate := DateToStr(Now);
  if lDate.Caption <> sNewDate then lDate.Caption := sNewDate;

  {Do End of Day ?}
  DecodeTime(Now,wHour, wMin, wSec, wMSec);
  sCompareTime := PadString(psLeft,IntToStr(wHour),'0',2) + '.' + PadString(psLeft,IntToStr(wMin),'0',2);
  if (sCompareTime = Syss.EODTime) and (slDatesDone.IndexOf(sNewDate) = -1) then begin
    btnCancel.Enabled := FALSE;
    {Do EOD}
    iCurrRunNo := EndOfDay(iRunNo, TRUE, self);
    if iCurrRunNo <> -1 then begin
      if iCurrRunNo < iStartRunNo then iStartRunNo := iCurrRunNo;
      iEndRunNo := iCurrRunNo;

      {Update List of Done Dates}
      slDatesDone.Add(sNewDate);
      lbDatesDone.Items := slDatesDone;
    end;{if}
    btnCancel.Enabled := TRUE;
  end;{if}
  timEOD.Enabled := TRUE;
end;

procedure TFrmAutoEOD.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmAutoEOD.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not btnCancel.Enabled then CanClose := FALSE
  else begin
    timEOD.Enabled := FALSE;
    CanClose := MsgBox('This will cancel the Automatic End of Day.' + CHR(13) + CHR(13)
    + 'Are you sure you want to do this ?',mtConfirmation,[mbYes,mbNo],mbNo,'Automatic End of Day') = mrYes;

    if CanClose then
      begin
        if (iStartRunNo <> 2147483647) and (iEndRunNo <> -1) then {$IFNDEF CARDTK}PrintEODReports(iStartRunNo, iEndRunNo, TRUE, TRUE){$ENDIF};
      end
    else timEODTimer(Self);
  end;{if}
end;

procedure TFrmAutoEOD.FormDestroy(Sender: TObject);
begin
  slDatesDone.Free;
  Application.OnActivate := nil;
end;

procedure TFrmAutoEOD.FormActivate(Sender: TObject);
begin
  Refresh;
  timEODTimer(Self);
end;

end.
