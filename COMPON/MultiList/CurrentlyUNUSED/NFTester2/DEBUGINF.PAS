unit debuginf;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BTSupU1, VarConst, CardProc, MPComms, BtrvU2;

type
  TFrmDebugInfo = class(TForm)
    memDebug: TMemo;
    btnClose: TButton;
    btnCopy: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
  private
    procedure FillDebugList;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;

{var
  FrmDebugInfo: TFrmDebugInfo;}

implementation

uses Comms;

{$R *.DFM}

procedure TFrmDebugInfo.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmDebugInfo.btnRefreshClick(Sender: TObject);
begin
  FillDebugList;
end;

procedure TFrmDebugInfo.FormShow(Sender: TObject);
begin
  FillDebugList;
end;

procedure TFrmDebugInfo.FillDebugList;
var
  MaxRec : TMaximumsRec;
begin
  memDebug.Clear;
  memDebug.Lines.Add('RunNo      : ' + IntToStr(Set_RunNo(FALSE) - 1));

  if bgCommsWorking then
    begin
      MaxRec := FrmComms.GetMaxGuests(1, TRUE);
      memDebug.Lines.Add('ABS        : ' + IntToStr(Get_NextTillNo(FALSE)) + '/' + IntToStr(StrToInt(MaxRec.Guests)));
    end
  else memDebug.Lines.Add('ABS        : (No Comms)');

  memDebug.Lines.Add('CustF      : ' + IntToStr(Used_Recs(F[CustF], CustF)));
  memDebug.Lines.Add('InvF       : ' + IntToStr(Used_Recs(F[InvF], InvF)));
  memDebug.Lines.Add('SysF       : ' + IntToStr(Used_Recs(F[SysF], SysF)));
  memDebug.Lines.Add('GroupF     : ' + IntToStr(Used_Recs(F[GroupF], GroupF)));
  memDebug.Lines.Add('ItemF      : ' + IntToStr(Used_Recs(F[ItemF], ItemF)));
  memDebug.Lines.Add('SalesDetF  : ' + IntToStr(Used_Recs(F[SalesDetF], SalesDetF)));
  memDebug.Lines.Add('TillSalesF : ' + IntToStr(Used_Recs(F[TillSalesF], TillSalesF)));
end;

procedure TFrmDebugInfo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,6,0);
  action := caFree;
end;

procedure TFrmDebugInfo.FormResize(Sender: TObject);
begin
  btnClose.Top := ClientHeight - 31;
  memDebug.Height := clientheight - 38;
  btnClose.left := ClientWidth - 80;
  btnCopy.Left := ClientWidth - 192;
  btnCopy.Top := ClientHeight - 31;
end;

procedure TFrmDebugInfo.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 206;
    ptMinTrackSize.Y := 173;
  end;{with}
  Message.Result := 0;
  inherited;
end;


procedure TFrmDebugInfo.FormCreate(Sender: TObject);
begin
  ClientWidth := 312;
  ClientHeight := 263;
end;

procedure TFrmDebugInfo.btnCopyClick(Sender: TObject);
begin
  memDebug.SelectAll;
  memDebug.CopyToClipboard;
end;

end.
