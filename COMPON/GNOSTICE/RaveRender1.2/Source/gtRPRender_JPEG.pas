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

unit gtRPRender_JPEG;

interface

uses
	SysUtils, Windows, Messages, Classes, Graphics, Forms, Dialogs, StdCtrls,
	Controls, gtRPRender_Graphic, jpeg, gtRPRender_Utils,	gtRPRender_Consts,
	RPRender;

type

{ TgtRPRenderJPEG class }

	TgtRPRenderJPEG = class(TgtRPRenderGraphic)
	private
		FGrayscale: Boolean;
		FProgressiveEncoding: Boolean;
		FQuality: TJPEGQualityRange;

	public
		constructor Create(AOwner: TComponent); override;

		function ShowSetupModal: Word; override;

		procedure PageEnd; override;
  {$IFDEF Rave50Up}
    procedure RenderPage(PageNum: integer); override;
  {$ELSE}
		procedure PrintRender(NDRStream: TStream;
			OutputFileName: TFileName); override;
  {$ENDIF}

	published
		property Grayscale: Boolean  read FGrayscale  write FGrayscale
			default False;
		property ProgressiveEncoding: Boolean read FProgressiveEncoding
			write FProgressiveEncoding default True;
		property Quality: TJPEGQualityRange read FQuality write FQuality
			default High(TJPEGQualityRange);
	end;

implementation

uses gtRPRender_MainDlg, gtRPRender_JPEGDlg;

{------------------------------------------------------------------------------}
{ TgtRPRenderJPEG }
{------------------------------------------------------------------------------}

constructor TgtRPRenderJPEG.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	DisplayName := sJPEGDesc;
	FGrayScale := False;
	FileExtension := '*.jpeg;*.' + sJPEGExt;
	FProgressiveEncoding := True;
	FQuality := High(TJPEGQualityRange);
end;

{------------------------------------------------------------------------------}

// Creates and shows setup dialog
function TgtRPRenderJPEG.ShowSetupModal: Word;
begin
	with TgtRPRenderJPEGDlg.Create(nil) do
	try
		RenderObject := Self;
		Application.ProcessMessages;
		Result := ShowModal;
	finally
		Free;
	end;
end;

{------------------------------------------------------------------------------}

// Renders JPEG image to stream
procedure TgtRPRenderJPEG.PageEnd;
var
	SaveFileName: string;
	BMP: TBitmap;
	JPEG: TJPEGImage;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	SaveFileName := FOutputFileName;
	if FCurrentPageNo > 1 then
	begin
		SaveFileName := (ExtractFilePath(FOutputFileName) +
			MakeFileName(FOutputFileName, GetFileExtension, FCurrentPageNo));

		if Assigned(OnMakeReportFileName) then
			OnMakeReportFileName(Self, SaveFileName, Converter.PageNo);
		ReportFileNames.Add(SaveFileName);

		FOwnedStream := TFileStream.Create(ReportFileNames[FCurrentPageNo - 1],
			fmCreate);
	end;

	JPEG := TJPEGImage.Create;
	BMP := StorePage(FBitmap);
	try
		JPEG.Grayscale := FGrayscale;
		JPEG.ProgressiveEncoding := FProgressiveEncoding;
		JPEG.CompressionQuality := FQuality;

		JPEG.Assign(BMP);
		JPEG.SaveToStream(FOwnedStream);
		BMP.Free;
	finally
		JPEG.Free;
	end;
	inherited PageEnd;
end;

{------------------------------------------------------------------------------}

// Create FileStream and begin render
{$IFDEF Rave50Up}
procedure TgtRPRenderJPEG.RenderPage(PageNum: integer);
begin
	inherited Renderpage(PageNum);
	if not FExportCanceled then
	begin
		try
			InitFileStream(ReportFileNames.Strings[0]);
		except
			CancelExport;
			DoErrorMessage(sCreateFileError);
			Exit;
		end;
		with TRPConverter.Create(NDRStream, Self) do
			try
				Generate;
			finally
				Free;
			end;
	end;
end;

{$ELSE}

procedure TgtRPRenderJPEG.PrintRender(NDRStream: TStream;
	OutputFileName: TFileName);
begin
	inherited PrintRender(NDRStream, OutputFileName);

	if not FExportCanceled then
	begin
		try
			InitFileStream(ReportFileNames.Strings[0]);
		except
			CancelExport;
			DoErrorMessage(sCreateFileError);
			Exit;
		end;
		with TRPConverter.Create(NDRStream, Self) do
			try
				Generate;
			finally
				Free;
			end;
	end;
end;

{$ENDIF}
{------------------------------------------------------------------------------}

end.
