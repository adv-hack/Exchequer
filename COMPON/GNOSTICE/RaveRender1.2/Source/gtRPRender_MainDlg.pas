{***************************************************************************}
{                                                                           }
{  Gnostice RaveRender                                                      }
{                                                                           }
{  Copyright © 2000-2003 Gnostice Information Technologies Private Limited  }
{  http://www.gnostice.com                                                  }
{                                                                           }
{***************************************************************************}

{$I gtDefines.Inc}
{$I gtRPDefines.Inc}

unit gtRPRender_MainDlg;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	RPRender, gtRPRender_Main, StdCtrls, ExtCtrls, ComCtrls, Buttons, ExtDlgs,
	ShellAPI, gtRPRender_Utils, gtRPRender_Consts, gtRPRender_DlgConsts;

type

{ TgtRPRenderMainDlg class }

	// Main gtRPRender dialog class. All gtRPRender dialogs derive
	// from TgtRPRenderMainDlg

	TgtRPRenderMainDlg = class(TForm)
		pcgtRPRender: TPageControl;
		tsBackground: TTabSheet;
		tsMain: TTabSheet;
		gbBackground: TGroupBox;
		lblBackgroundColor: TLabel;
		shpBackgroundColor: TShape;
		lblBackgroundImage: TLabel;
		pnlBackgroundImage: TPanel;
		imgBackgroundImage: TImage;
		lblBackgroundDisplayType: TLabel;
		cbBackgroundDisplayType: TComboBox;
		gbGeneral: TGroupBox;
		chkEmailAfterGenerate: TCheckBox;
		chkOpenAfterGenerate: TCheckBox;
		ColorDialog: TColorDialog;
		OpenPictureDialog: TOpenPictureDialog;
		btnSelectImage: TButton;
		btnOK: TButton;
		btnCancel: TButton;
    lblGnostice: TLabel;
		gbPageRange: TGroupBox;
		rbtnAll: TRadioButton;
		rbtnPages: TRadioButton;
		edPages: TEdit;
		lblPageExample: TLabel;
		btnClear: TButton;

		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure btnOKClick(Sender: TObject);
		procedure rbtnAllClick(Sender: TObject);
		procedure rbtnPagesClick(Sender: TObject);
		procedure btnSelectImageClick(Sender: TObject);
		procedure edPagesKeyPress(Sender: TObject; var Key: Char);
		procedure btnClearClick(Sender: TObject);
		procedure shpBackgroundColorMouseDown(Sender: TObject;
			Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
		procedure shpBackgroundColorMouseUp(Sender: TObject;
			Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
		procedure edScalingKeyPress(Sender: TObject; var Key: Char);
		procedure lblGnosticeClick(Sender: TObject);
	private
		FRenderObject: TgtRPRender;

	protected
		MousePoint: TPoint;

		procedure Localize; virtual;

	public
		property RenderObject: TgtRPRender read FRenderObject write FRenderObject;

	end;

	THackgtRPRender = class(TgtRPRender);

const

	PixelFormats: array[TPixelFormat] of string = (SPFDevice, SPF1bit, SPF4bit,
		SPF8bit, SPF15bit, SPF16bit, SPF24bit, SPF32bit, SPFCustom);


implementation

const
	BackgroundDisplayTypes: array[TgtRPBackgroundDisplayType] of string = (
		SBGDispTypTile, SBGDispTypTopLeft, SBGDispTypTopCenter,
		SBGDispTypTopRight,	SBGDispTypCenterLeft, SBGDispTypCenter,
		SBGDispTypCenterRight, SBGDispTypBottomLeft, SBGDispTypBottomCenter,
		SBGDispTypBottomRight);

{$R *.DFM}

{------------------------------------------------------------------------------}
{ TgtRPRenderMainDlg }
{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.FormCreate(Sender: TObject);
var
	I: TgtRPBackgroundDisplayType;
begin
	Localize;
	cbBackgroundDisplayType.Items.Clear;
	// Add Background display types to type selection ComboBox
	for I := Low(TgtRPBackgroundDisplayType) to High(
			TgtRPBackgroundDisplayType) do
		cbBackgroundDisplayType.Items.AddObject(BackgroundDisplayTypes[I],
			TObject(I));
	pcgtRPRender.ActivePage := tsMain;
	rbtnPagesClick(Sender);
{$IFDEF Registered}
	lblGnostice.Visible := False;
{$ENDIF}
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.FormShow(Sender: TObject);
begin
	with THackgtRPRender(RenderObject) do
	begin
		chkEmailAfterGenerate.checked := EmailAfterGenerate;
		chkOpenAfterGenerate.Checked := OpenAfterGenerate;
		rbtnPages.Checked := Pages <> '';
		if rbtnPages.Checked then
		begin
			edPages.Color := clWindow;
			edPages.Text := Pages;
		end;
		chkEmailAfterGenerate.Visible := Assigned(OnEmail);

		imgBackgroundImage.Picture := BackgroundImage;
		cbBackgroundDisplayType.ItemIndex := cbBackgroundDisplayType.Items.
			IndexOfObject(TObject(Ord(BackgroundImageDisplayType)));
		shpBackgroundColor.Brush.Color := BackgroundColor;
		if BackgroundImage.Graphic = nil then
		begin
			lblBackgroundDisplayType.Enabled := False;
			cbBackgroundDisplayType.Enabled := False;
			btnClear.Enabled := False;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.btnOKClick(Sender: TObject);
begin
	with THackgtRPRender(RenderObject) do
	begin
		OpenAfterGenerate := chkOpenAfterGenerate.Checked;
		EmailAfterGenerate := chkEmailAfterGenerate.Checked;

		BackgroundColor := shpBackgroundColor.Brush.Color;
		BackgroundImage := imgBackgroundImage.Picture;
		BackgroundImageDisplayType := TgtRPBackgroundDisplayType(
			cbBackgroundDisplayType.Items.Objects[
			cbBackgroundDisplayType.ItemIndex]);

		if rbtnPages.Checked then
		begin
			Pages := edPages.Text;
			if Pages = edPages.Text then
				ModalResult := mrOk;
		end
		else
			ModalResult := mrOk;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.rbtnAllClick(Sender: TObject);
begin
	edPages.Text := '';
	rbtnPagesClick(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.rbtnPagesClick(Sender: TObject);
begin
	edPages.Enabled := rbtnPages.Checked;
	if rbtnPages.Checked then
		edPages.Color := clWindow
	else
		edPages.Color := clInactiveBorder;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.btnSelectImageClick(Sender: TObject);
begin
	if OpenPictureDialog.Execute then
	begin
		imgBackgroundImage.Picture.LoadFromFile(OpenPictureDialog.FileName);
		btnClear.Enabled := True;
		lblBackgroundDisplayType.Enabled := True;
		cbBackgroundDisplayType.Enabled := True;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.edPagesKeyPress(Sender: TObject;
	var Key: Char);
begin
	if not(Key in ['0'..'9', #8, '-', ',']) then
		Key := #0;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.btnClearClick(Sender: TObject);
begin
	imgBackgroundImage.Picture.Graphic := nil;
	btnClear.Enabled := False;
	lblBackgroundDisplayType.Enabled := False;
	cbBackgroundDisplayType.Enabled := False;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.edScalingKeyPress(Sender: TObject;
	var Key: Char);
begin
	if not(Key in ['0'..'9', #8, '.']) then
		Key := #0;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.shpBackgroundColorMouseDown(
	Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
	Y: Integer);
begin
	MousePoint.x := X;
	MousePoint.y := Y;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.shpBackgroundColorMouseUp(Sender: TObject;
	Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	ColorDialog.Color := (Sender as TShape).Brush.Color;
	if (((X = MousePoint.x) and (Y = MousePoint.y)) and (Button = mbleft)) then
		if ColorDialog.Execute then
			(Sender as TShape).Brush.Color := ColorDialog.Color;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.lblGnosticeClick(Sender: TObject);
begin
	ShellExecute(Handle, nil, 'http://www.gnostice.com', nil, nil,
		SW_SHOWNORMAL);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMainDlg.Localize;
begin
	tsBackground.Caption := stsBackgroundCaption;
	tsMain.Caption := stsMainCaption;
	lblBackgroundColor.Caption := slblBackgroundColorCaption;
	lblBackgroundImage.Caption := slblBackgroundImageCaption;
	lblBackgroundDisplayType.Caption := slblBackgroundDisplayTypeCaption;
	btnSelectImage.Caption := sbtnSelectImageCaption;
	btnClear.Caption := sbtnClearCaption;
	chkEmailAfterGenerate.Caption := schkEmailAfterGenerateCaption;
	chkOpenAfterGenerate.Caption := schkOpenAfterGenerateCaption;
	gbPageRange.Caption := sgbPageRangeCaption;
	rbtnAll.Caption := srbtnAllCaption;
	rbtnPages.Caption := srbtnPagesCaption;
	lblPageExample.Caption := slblPageExampleCaption;
	btnOK.Caption := sbtnOKCaption;
	btnCancel.Caption := sbtnCancelCaption;

	shpBackgroundColor.Hint := sColorBoxHintPrefix + lblBackgroundColor.Caption;

	// Set control width after setting text
	rbtnAll.Width := (GetTextSize(Font, srbtnAllCaption).cx + cMinWidth);
	rbtnPages.Width := (GetTextSize(Font, srbtnPagesCaption).cx + cMinWidth);
	chkOpenAfterGenerate.Width := (GetTextSize(Font,
		schkOpenAfterGenerateCaption).cx + cMinWidth);
	chkEmailAfterGenerate.Width := (GetTextSize(Font,
		schkEmailAfterGenerateCaption).cx + cMinWidth);
end;

{------------------------------------------------------------------------------}

end.
  