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

unit gtRPRender_Reg;

interface

procedure Register;

implementation

uses
	Classes, TypInfo,
  {$IFDEF gtDelphi6Up}
		DesignIntf, DesignEditors,
	{$ELSE}
		DsgnIntf,
	{$ENDIF}
	gtRPRender_PDF, gtRPRender_HTML, gtRPRender_RTF,
	gtRPRender_Excel, gtRPRender_Text,
	gtRPRender_GIF, gtRPRender_JPEG, gtRPRender_BMP,
	gtRPRender_EMF, gtRPRender_WMF;

procedure Register;
begin
	RegisterComponents('Gnostice RaveRender', [TgtRPRenderPDF, TgtRPRenderHTML,
		TgtRPRenderRTF, TgtRPRenderExcel, TgtRPRenderText, TgtRPRenderGIF,
		TgtRPRenderJPEG, TgtRPRenderBMP, TgtRPRenderEMF, TgtRPRenderWMF]);
end;

end.
