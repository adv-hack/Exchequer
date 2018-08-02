{*********************************************************}
{*                     CVTPROG.PAS                       *}
{*     Copyright (c) TurboPower Software 1997,98         *}
{*                 All rights reserved.                  *}
{*********************************************************}

unit Cvtprog;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, AdFaxCvt, AdExcept, AdMeter, OoMisc;

type
  TCvtProgressForm = class(TForm)
    Label1: TLabel;
    CancelBtn: TBitBtn;
    ConvertList: TListBox;
    FaxConverter: TApdFaxConverter;
    procedure FaxConverterStatus(F: TObject; Starting, Ending: Boolean;
      PagesConverted, LinesConverted: Integer; BytesConverted,
      BytesToConvert: Longint; var Abort: Boolean);
    procedure FormShow(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    CancelClicked : Boolean;
    Shown         : Boolean;
    CvtGauge      : TApdMeter;

  public
    { Public declarations }
    UseEnhancedText : Boolean;
    { methods }
    procedure ConvertFiles(var Msg : TMessage); message wm_User + 1;
      {-Convert the input list of files to APF files}
    constructor Create(AComponent : TComponent); override;
  end;

var
  CvtProgressForm: TCvtProgressForm;

implementation

{$R *.DFM}

constructor TCvtProgressForm.Create(AComponent : TComponent);
begin
	inherited Create(AComponent);
  CvtGauge        := TApdMeter.Create(Self);
  CvtGauge.Parent := Self;
  CvtGauge.Left   := 16;
  CvtGauge.Top    := 272;
  CvtGauge.Width  := 273;
  CvtGauge.Height := 20;
end;

procedure TCvtProgressForm.ConvertFiles(var Msg : TMessage);
var
  I : Word;
  Ext : String;
begin
  CancelClicked := False;

  for I := 0 to Pred(ConvertList.Items.Count) do begin
    ConvertList.ItemIndex := I;
    Ext := ExtractFileExt(ConvertList.Items[I]);
    if Ext = '.bmp' then
      FaxConverter.InputDocumentType := idBmp
    else if Ext = '.dcx' then
      FaxConverter.InputDocumentType := idDcx
    else if Ext = '.pcx' then
      FaxConverter.InputDocumentType := idPcx
    else if Ext = '.txt' then begin
      if UseEnhancedText then
        FaxConverter.InputDocumentType := idTextEx
      else
        FaxConverter.InputDocumentType := idText;
    end else if Ext = '.tif' then
      FaxConverter.InputDocumentType := idTiff
    else
      Continue;
    FaxConverter.DocumentFile := ConvertList.Items[I];

    try
      FaxConverter.ConvertToFile;
    except
      on EConvertAbort do begin end;
      on E : Exception do begin
        MessageDlg('Error: ' + E.Message, mtError, [mbOK], 0);
      end;
    end;

    if CancelClicked then
      Break;
  end;

  if not CancelClicked then
    ModalResult := mrOK;
end;

procedure TCvtProgressForm.FaxConverterStatus(F: TObject; Starting,
  Ending: Boolean; PagesConverted, LinesConverted: Integer; BytesConverted,
  BytesToConvert: Longint; var Abort: Boolean);
begin
  Abort := CancelClicked;

  if Abort then
    ModalResult := mrCancel;

  if (BytesToConvert <> 0) then
    CvtGauge.Position := (BytesConverted * 100) div BytesToConvert;
end;

procedure TCvtProgressForm.FormShow(Sender: TObject);
begin
  if not Shown then begin
    Shown := True;
    PostMessage(Handle, wm_User + 1, 0, 0);
  end;
end;

procedure TCvtProgressForm.CancelBtnClick(Sender: TObject);
begin
  CancelClicked := True;
end;

procedure TCvtProgressForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Shown := False;
end;

end.
