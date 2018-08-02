{*********************************************************}
{*                   ADMDMDLG.PAS 4.03                   *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdMdmDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OOMisc, AdMdm, StdCtrls, Buttons, ExtCtrls
  {$IFDEF Delphi4}, ImgList{$ENDIF};

type
  TApdModemStatusDialog = class(TForm)
    gbxStatus: TGroupBox;
    btnCancel: TButton;
    btnDetail: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    lblStatus: TLabel;
    lblUsingDevice: TLabel;
    lblUsingPort: TLabel;
    lblElapsedTime: TLabel;
    gbxDetail: TGroupBox;
    memDetail: TMemo;
    ImageList1: TImageList;
    procedure btnDetailClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FModem: TAdCustomModem;
    procedure SetModem(const NewModem : TAdCustomModem);
  public
    { Public declarations }
    property Modem : TAdCustomModem
      read FModem write SetModem;
    procedure UpdateDisplay(
      const StatusStr, TimeStr, DetailStr : string;
      Action : TApdModemStatusAction);

  end;

var
  ApxModemStatusDialog: TApdModemStatusDialog;

implementation

{$R *.dfm}

procedure TApdModemStatusDialog.btnDetailClick(Sender: TObject);
begin
  if btnDetail.Tag = 0 then begin
    { show the whole dialog (include detail) }
    btnDetail.Tag := 1;
    gbxDetail.Visible := True;
    ClientHeight := gbxDetail.Top + gbxDetail.Height + 8 + btnCancel.Height;
  end else begin
    { show the small dialog (no detail) }
    btnDetail.Tag := 0;
    gbxDetail.Visible := False;
    ClientHeight := gbxStatus.Top + gbxStatus.Height + 8 + btnCancel.Height;
  end;
  btnDetail.Glyph := nil;
  ImageList1.GetBitmap(btnDetail.Tag, btnDetail.Glyph);
end;

procedure TApdModemStatusDialog.UpdateDisplay(
  const StatusStr, TimeStr, DetailStr : string;
  Action : TApdModemStatusAction);
  { this method is called periodically by the TApdModem component }
  { when the OnModemStatus, OnModemLog and a few other events are }
  { generated, or at other various places. }
begin
  case Action of
    msaStart : begin         { first time status display (clears everything) }
                 memDetail.Lines.Clear;
                 Show;
               end;
    msaClose : begin         { last time, cleans up }
                 Close;
               end;
    msaUpdate : begin        { normal updating }
                  lblStatus.Caption := StatusStr;
                  lblElapsedTime.Caption := 'Elapsed time: ' + TimeStr;
                  if DetailStr <> '' then
                    memDetail.Lines.Add(DetailStr);
                end;
    msaDetailReplace : begin { replaces last line of details }
                         lblStatus.Caption := StatusStr;
                         lblElapsedTime.Caption := 'Elapsed time: ' + TimeStr;
                         if DetailStr <> '' then
                           if memDetail.Lines.Count = 0 then
                             memDetail.Lines.Add(DetailStr)
                           else
                             memDetail.Lines[pred(memDetail.Lines.Count)] := DetailStr;
                      end;
    msaClear : begin         { clears all details and adds DetailStr }
                 memDetail.Lines.Clear;
                 if DetailStr <> '' then
                   memDetail.Lines.Add(DetailStr);
               end;
  end;
end;

procedure TApdModemStatusDialog.FormCreate(Sender: TObject);
var
  BMP : TBitmap;
begin
  { initialize the captions }
  btnDetail.Tag := 1;
  btnDetail.Click;
  BMP := nil;
  try
    BMP := TBitmap.Create;
    BMP.Width := btnDetail.Glyph.Width div 2;
    BMP.Height := btnDetail.Glyph.Height;
{    ImageList1.Width := btnDetail.Glyph.Width div 2;
    with btnDetail.Glyph do
      R := Rect(0, 0, Width div 2, Height);
    BMP.Canvas.CopyRect(R, btnDetail.Glyph.Canvas, R);
    ImageList1.Add(BMP, nil);
    with btnDetail.Glyph do
      R := Rect(Width div 2, 0, Width, Height);
    BMP.Canvas.CopyRect(R, btnDetail.Glyph.Canvas, R);
    ImageList1.Add(BMP, nil);}
  finally
    BMP.Free;
  end;

end;

procedure TApdModemStatusDialog.btnCancelClick(Sender: TObject);
begin
  if Assigned(FModem) then
    Postmessage(FModem.Handle, apw_CommandProcessed, apw_CancelCall, 0);
end;

procedure TApdModemStatusDialog.SetModem(const NewModem : TAdCustomModem);
begin
  FModem := NewModem;
  lblUsingDevice.Caption := FModem.SelectedDevice.Name;
  lblUsingPort.Caption := FModem.ComPort.Dispatcher.DeviceName;
end;


end.
