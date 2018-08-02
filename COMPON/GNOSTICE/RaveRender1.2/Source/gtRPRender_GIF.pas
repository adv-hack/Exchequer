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

unit gtRPRender_GIF;

interface

uses
	SysUtils, Windows, Messages, Classes, Graphics, Forms, Dialogs, StdCtrls,
	JPEG, Controls, gtRPRender_Graphic, gtRPRender_Utils, gtRPRender_Consts,
	RPRender
	{$IFDEF GIFByRx}
		, RxGIF
	{$ELSE}
		{$IFDEF GIFByAM}
			, GIFImage
		{$ENDIF}
	{$ENDIF};

type

{ TgtRPRenderGIF class }

	TgtRPRenderGIF = class(TgtRPRenderGraphic)
	private
		FMonochrome: Boolean;

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
		property Monochrome: Boolean read FMonochrome
			write FMonochrome default False;
	end;

implementation

uses gtRPRender_MainDlg, gtRPRender_GIFDlg;

{------------------------------------------------------------------------------}
{ TgtRPRenderGIF }
{------------------------------------------------------------------------------}

constructor TgtRPRenderGIF.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	DisplayName := SGIFDesc;
	FileExtension := '*.' + sGIFExt;
	FMonochrome := False;
end;

{------------------------------------------------------------------------------}

// Creates and shows setup dialog
function TgtRPRenderGIF.ShowSetupModal: Word;
begin
	with TgtRPRenderGIFDlg.Create(nil) do
	try
		RenderObject := Self;
		Application.ProcessMessages;
		Result := ShowModal;
	finally
		Free;
	end;
end;

{------------------------------------------------------------------------------}

// Renders GIF image to stream
procedure TgtRPRenderGIF.PageEnd;
var
	SaveFileName: string;
	GIF: TGraphic;
	BMP: TBitmap;
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

{$IFDEF GIFSupport}
	GIF := TGIFImage.Create;
{$ELSE}
	GIF := TJPEGImage.Create;
{$ENDIF}
	BMP := StorePage(FBitmap);
	try
		BMP.Monochrome := FMonochrome;
		GIF.Assign(BMP);
		GIF.SaveToStream(FOwnedStream);
	finally
		GIF.Free;
		BMP.Free;
	end;
	inherited PageEnd;
end;

{------------------------------------------------------------------------------}

// Create FileStream and begin render
{$IFDEF Rave50Up}

procedure TgtRPRenderGIF.RenderPage(PageNum: integer);
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

procedure TgtRPRenderGIF.PrintRender(NDRStream: TStream;
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
