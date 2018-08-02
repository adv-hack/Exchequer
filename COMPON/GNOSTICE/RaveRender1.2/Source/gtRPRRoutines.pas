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

unit gtRPRRoutines;

interface

uses
	Classes, RPRave, RPSystem, RPDefine, gtRPRender_Main, gtRPRender_PDF,
	gtRPRender_HTML, gtRPRender_RTF, gtRPRender_Excel, gtRPRender_Text,
	gtRPRender_GIF, gtRPRender_JPEG, gtRPRender_BMP, gtRPRender_EMF,
	gtRPRender_WMF;

// Render Object is locally created
procedure RenderToPDF(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean = False; ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False);
procedure RenderToHTML(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean = False; ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False);
procedure RenderToRTF(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean = False; ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False);
procedure RenderToExcel(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean = False; ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False);
procedure RenderToText(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean = False; ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False);
procedure RenderToGIF(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean = False; ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False);
procedure RenderToJPEG(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean = False; ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False);
procedure RenderToBMP(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean = False; ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False);
procedure RenderToEMF(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean = False; ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False);
procedure RenderToWMF(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean = False; ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False);

procedure RenderToPDFInStream(RPComponent: TRPComponent;
	AStream: TMemoryStream; ShowRenderSetup: Boolean = False;
	ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False); overload;

procedure RenderToRTFInStream(RPComponent: TRPComponent;
	AStream: TMemoryStream; ShowRenderSetup: Boolean = False;
	ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False); overload;

// User has to provide Render object
procedure RenderUsingRenderObject(gtRPRender: TgtRPRender;
	RPComponent: TRPComponent; AFileName: string;
	ShowPrepareStatus: Boolean = False);

procedure RenderToPDFInStream(gtRPRenderPDF: TgtRPRenderPDF;
	RPComponent: TRPComponent; AStream: TMemoryStream;
	ShowPrepareStatus: Boolean = False); overload;

procedure RenderToRTFInStream(gtRPRenderRTF: TgtRPRenderRTF;
	RPComponent: TRPComponent; AStream: TMemoryStream;
	ShowPrepareStatus: Boolean = False); overload;

implementation

procedure ExecuteReport(RPComponent: TRPComponent; AFileName: string;
	ShowPrepareStatus: Boolean);

{$IFDEF Rave50Up}
	procedure SetReportSystemProperties(ReportSystem: TRvSystem);
{$ELSE}
	procedure SetReportSystemProperties(ReportSystem: TReportSystem);
{$ENDIF}
	begin
		with ReportSystem do
		begin
			DefaultDest := rdFile;
			DoNativeOutput := False;
			OutputFileName := AFileName;
			SystemSetups := SystemSetups - [ssAllowSetup];
			if not ShowPrepareStatus then
				SystemOptions := SystemOptions - [soShowStatus];
		end;
	end;

begin
{$IFDEF Rave50Up}
	if RPComponent is TRvSystem then
{$ELSE}
	if RPComponent is TReportSystem then
{$ENDIF}
	begin
  {$IFDEF Rave50Up}
		SetReportSystemProperties(TRvSystem(RPComponent));
		TRvSystem(RPComponent).Execute;
  {$ELSE}
		SetReportSystemProperties(TReportSystem(RPComponent));
		TReportSystem(RPComponent).Execute;
  {$ENDIF}
	end
{$IFDEF Rave50Up}
	else if RPComponent is TRvProject then
		with RPComponent as TRvProject do
		begin
			if Engine is TRvSystem then
				SetReportSystemProperties(TRvSystem(Engine));
			Execute;
		end;
{$ELSE}
	else if RPComponent is TRaveProject then
		with RPComponent as TRaveProject do
		begin
			if Engine is TReportSystem then
				SetReportSystemProperties(TReportSystem(Engine));
			Execute;
		end;
{$ENDIF}
end;

{------------------------------------------------------------------------------}

procedure SetRenderObject(RPComponent: TRPComponent; gtRPRender: TgtRPRender);
begin
{$IFDEF Rave50Up}
	if RPComponent is TRvSystem then
		TRvSystem(RPComponent).RenderObject := gtRPRender
	else if RPComponent is TRvProject then
		with RPComponent as TRvProject do
			if Engine is TRvSystem then
				TRvSystem(Engine).RenderObject := gtRPRender;
{$ELSE}
	if RPComponent is TReportSystem then
		TReportSystem(RPComponent).RenderObject := gtRPRender
	else if RPComponent is TRaveProject then
		with RPComponent as TRaveProject do
			if Engine is TReportSystem then
				TReportSystem(Engine).RenderObject := gtRPRender;
{$ENDIF}
end;

{------------------------------------------------------------------------------}

procedure RenderToPDF(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean; ShowRenderProgress: Boolean;
	ShowPrepareStatus: Boolean);
var
	gtRPRenderPDF: TgtRPRenderPDF;
begin
	gtRPRenderPDF := TgtRPRenderPDF.Create(nil);
	try
		gtRPRenderPDF.ShowSetupDialog := ShowRenderSetup;
		gtRPRenderPDF.ShowProgress := ShowRenderProgress;
		gtRPRenderPDF.OutputToUserStream := False;
		gtRPRenderPDF.UserStream := nil;
		SetRenderObject(RPComponent, gtRPRenderPDF);
		ExecuteReport(RPComponent, AFileName, ShowPrepareStatus);
	finally
		gtRPRenderPDF.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure RenderToHTML(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean; ShowRenderProgress: Boolean;
	ShowPrepareStatus: Boolean); 
var
	gtRPRenderHTML: TgtRPRenderHTML;
begin
	gtRPRenderHTML := TgtRPRenderHTML.Create(nil);
	try
		gtRPRenderHTML.ShowSetupDialog := ShowRenderSetup;
		gtRPRenderHTML.ShowProgress := ShowRenderProgress;
		SetRenderObject(RPComponent, gtRPRenderHTML);
		ExecuteReport(RPComponent, AFileName, ShowPrepareStatus);
	finally
		gtRPRenderHTML.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure RenderToRTF(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean; ShowRenderProgress: Boolean;
	ShowPrepareStatus: Boolean); 
var
	gtRPRenderRTF: TgtRPRenderRTF;
begin
	gtRPRenderRTF := TgtRPRenderRTF.Create(nil);
	try
		gtRPRenderRTF.ShowSetupDialog := ShowRenderSetup;
		gtRPRenderRTF.ShowProgress := ShowRenderProgress;
		gtRPRenderRTF.OutputToUserStream := False;
		gtRPRenderRTF.UserStream := nil;
		SetRenderObject(RPComponent, gtRPRenderRTF);
		ExecuteReport(RPComponent, AFileName, ShowPrepareStatus);
	finally
		gtRPRenderRTF.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure RenderToExcel(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean; ShowRenderProgress: Boolean;
	ShowPrepareStatus: Boolean);
var
	gtRPRenderExcel: TgtRPRenderExcel;
begin
	gtRPRenderExcel := TgtRPRenderExcel.Create(nil);
	try
		gtRPRenderExcel.ShowSetupDialog := ShowRenderSetup;
		gtRPRenderExcel.ShowProgress := ShowRenderProgress;
		SetRenderObject(RPComponent, gtRPRenderExcel);
		ExecuteReport(RPComponent, AFileName, ShowPrepareStatus);
	finally
		gtRPRenderExcel.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure RenderToText(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean; ShowRenderProgress: Boolean;
	ShowPrepareStatus: Boolean);
var
	gtRPRenderText: TgtRPRenderText;
begin
	gtRPRenderText := TgtRPRenderText.Create(nil);
	try
		gtRPRenderText.ShowSetupDialog := ShowRenderSetup;
		gtRPRenderText.ShowProgress := ShowRenderProgress;
		SetRenderObject(RPComponent, gtRPRenderText);
		ExecuteReport(RPComponent, AFileName, ShowPrepareStatus);
	finally
		gtRPRenderText.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure RenderToGIF(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean; ShowRenderProgress: Boolean;
	ShowPrepareStatus: Boolean); overload;
var
	gtRPRenderGIF: TgtRPRenderGIF;
begin
	gtRPRenderGIF := TgtRPRenderGIF.Create(nil);
	try
		gtRPRenderGIF.ShowSetupDialog := ShowRenderSetup;
		gtRPRenderGIF.ShowProgress := ShowRenderProgress;
		SetRenderObject(RPComponent, gtRPRenderGIF);
		ExecuteReport(RPComponent, AFileName, ShowPrepareStatus);
	finally
		gtRPRenderGIF.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure RenderToJPEG(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean; ShowRenderProgress: Boolean;
	ShowPrepareStatus: Boolean);
var
	gtRPRenderJPEG: TgtRPRenderJPEG;
begin
	gtRPRenderJPEG := TgtRPRenderJPEG.Create(nil);
	try
		gtRPRenderJPEG.ShowSetupDialog := ShowRenderSetup;
		gtRPRenderJPEG.ShowProgress := ShowRenderProgress;
		SetRenderObject(RPComponent, gtRPRenderJPEG);
		ExecuteReport(RPComponent, AFileName, ShowPrepareStatus);
	finally
		gtRPRenderJPEG.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure RenderToBMP(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean; ShowRenderProgress: Boolean;
	ShowPrepareStatus: Boolean);
var
	gtRPRenderBMP: TgtRPRenderBMP;
begin
	gtRPRenderBMP := TgtRPRenderBMP.Create(nil);
	try
		gtRPRenderBMP.ShowSetupDialog := ShowRenderSetup;
		gtRPRenderBMP.ShowProgress := ShowRenderProgress;
		SetRenderObject(RPComponent, gtRPRenderBMP);
		ExecuteReport(RPComponent, AFileName, ShowPrepareStatus);
	finally
		gtRPRenderBMP.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure RenderToEMF(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean; ShowRenderProgress: Boolean;
	ShowPrepareStatus: Boolean);
var
	gtRPRenderEMF: TgtRPRenderEMF;
begin
	gtRPRenderEMF := TgtRPRenderEMF.Create(nil);
	try
		gtRPRenderEMF.ShowSetupDialog := ShowRenderSetup;
		gtRPRenderEMF.ShowProgress := ShowRenderProgress;
		SetRenderObject(RPComponent, gtRPRenderEMF);
		ExecuteReport(RPComponent, AFileName, ShowPrepareStatus);
	finally
		gtRPRenderEMF.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure RenderToWMF(RPComponent: TRPComponent; AFileName: string;
	ShowRenderSetup: Boolean; ShowRenderProgress: Boolean;
	ShowPrepareStatus: Boolean);
var
	gtRPRenderWMF: TgtRPRenderWMF;
begin
	gtRPRenderWMF := TgtRPRenderWMF.Create(nil);
	try
		gtRPRenderWMF.ShowSetupDialog := ShowRenderSetup;
		gtRPRenderWMF.ShowProgress := ShowRenderProgress;
		SetRenderObject(RPComponent, gtRPRenderWMF);
		ExecuteReport(RPComponent, AFileName, ShowPrepareStatus);
	finally
		gtRPRenderWMF.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure RenderToPDFInStream(RPComponent: TRPComponent;
	AStream: TMemoryStream;
	ShowRenderSetup: Boolean; ShowRenderProgress: Boolean;
	ShowPrepareStatus: Boolean); overload;
var
	gtRPRenderPDF: TgtRPRenderPDF;
begin
	gtRPRenderPDF := TgtRPRenderPDF.Create(nil);
	try
		gtRPRenderPDF.ShowSetupDialog := ShowRenderSetup;
		gtRPRenderPDF.ShowProgress := ShowRenderProgress;
		gtRPRenderPDF.OutputToUserStream := True;
		gtRPRenderPDF.UserStream := AStream;
		SetRenderObject(RPComponent, gtRPRenderPDF);
		ExecuteReport(RPComponent, 'Dummy.pdf', ShowPrepareStatus);
		AStream.Position := 0;
	finally
		gtRPRenderPDF.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure RenderToRTFInStream(RPComponent: TRPComponent;
	AStream: TMemoryStream; ShowRenderSetup: Boolean = False;
	ShowRenderProgress: Boolean = False;
	ShowPrepareStatus: Boolean = False); overload;
var
	gtRPRenderRTF: TgtRPRenderRTF;
begin
	gtRPRenderRTF := TgtRPRenderRTF.Create(nil);
	try
		gtRPRenderRTF.ShowSetupDialog := ShowRenderSetup;
		gtRPRenderRTF.ShowProgress := ShowRenderProgress;
		gtRPRenderRTF.OutputToUserStream := True;
		gtRPRenderRTF.UserStream := AStream;
		SetRenderObject(RPComponent, gtRPRenderRTF);
		ExecuteReport(RPComponent, 'Dummy.rtf', ShowPrepareStatus);
		AStream.Position := 0;
	finally
		gtRPRenderRTF.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure RenderUsingRenderObject(gtRPRender: TgtRPRender;
	RPComponent: TRPComponent; AFileName: string;
	ShowPrepareStatus: Boolean = False);
begin
	SetRenderObject(RPComponent, gtRPRender);
	ExecuteReport(RPComponent, AFileName, ShowPrepareStatus);
end;

{------------------------------------------------------------------------------}

procedure RenderToPDFInStream(gtRPRenderPDF: TgtRPRenderPDF;
	RPComponent: TRPComponent; AStream: TMemoryStream;
	ShowPrepareStatus: Boolean = False); overload;
begin
	gtRPRenderPDF.OutputToUserStream := True;
	gtRPRenderPDF.UserStream := AStream;
	SetRenderObject(RPComponent, gtRPRenderPDF);
	ExecuteReport(RPComponent, 'Dummy.pdf', ShowPrepareStatus);
end;

{------------------------------------------------------------------------------}

procedure RenderToRTFInStream(gtRPRenderRTF: TgtRPRenderRTF;
	RPComponent: TRPComponent; AStream: TMemoryStream;
	ShowPrepareStatus: Boolean = False); overload;
begin
	gtRPRenderRTF.OutputToUserStream := True;
	gtRPRenderRTF.UserStream := AStream;
	SetRenderObject(RPComponent, gtRPRenderRTF);
	ExecuteReport(RPComponent, 'Dummy.rtf', ShowPrepareStatus);
end;

{------------------------------------------------------------------------------}

end.
