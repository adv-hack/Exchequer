{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPRender_PDF;

interface

uses
  {$IFDEF Linux}
  QGraphics, Types, NDGraphic,
  {$ELSE}
  Windows,
  Graphics,
  JPEG,
  {$ENDIF}
  Classes,
  SysUtils,
  RPRender,
  RPDefine;

const
  NUM_CHARS = 256;

type
  TFontWidthTable = array [0..NUM_CHARS-1] of smallint;
  TPDFFontStyles = (psNormal, psBold, psItalic, psBoldItalic);
  TPDFFontEncoding = (feMacRomanEncoding, feMacExpertEncoding, feWinAnsiEncoding,
                      fePDFDocEncoding, feStandardEncoding);
  TEllipsePts = record
    XA,XB,XC,XD,XE,
    YA,YB,YC,YD,YE: double
  end;
  TSmallArcRecord = record
    X1, X2, X3, X4: double;
    Y1, Y2, Y3, Y4: double;
  end;
  TSmallArcBuffer = array[1..4] of TSmallArcRecord;

const
  PDFVersion: string = '%PDF-1.3';
  DPI_MULTIPLIER = 72;
  FontNames: array[0..13] of string = (
    'Courier','CourierBold','CourierItalic','CourierBoldItalic',
    'Helvetica','HelveticaBold','HelveticaItalic','HelveticaBoldItalic',
    'TimesRoman','TimesRomanBold','TimesRomanItalic','TimesRomanBoldItalic',
    'Symbol','ZapfDingbats'
  );

  FontEncodingNames: array[feMacRomanEncoding..feStandardEncoding] of string = (
   'MacRomanEncoding','MacExpertEncoding', 'WinAnsiEncoding',
   'PDFDocEncoding', 'StandardEncoding');

  FontWidthsCourier: TFontWidthTable = (
    {   0 }  600,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  10 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  20 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  30 }    0,    0,  600,  600,  600,  600,  600,  600,  600,  600,
    {  40 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    {  50 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    {  60 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    {  70 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    {  80 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    {  90 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 100 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 110 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 120 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 130 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 140 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 150 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 160 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 170 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 180 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 190 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 200 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 210 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 220 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 230 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 240 }  600,  600,  600,  600,  600,  600,  600,  600,  600,  600,
    { 250 }  600,  600,  600,  600,  600,  600);

  FontWidthsHelvetica: TFontWidthTable = (
    {   0 }  278,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  10 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  20 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  30 }    0,    0,  278,  278,  355,  556,  556,  889,  667,  191,
    {  40 }  333,  333,  389,  584,  278,  333,  278,  278,  556,  556,
    {  50 }  556,  556,  556,  556,  556,  556,  556,  556,  278,  278,
    {  60 }  584,  584,  584,  556, 1015,  667,  667,  722,  722,  667,
    {  70 }  611,  778,  722,  278,  500,  667,  556,  833,  722,  778,
    {  80 }  667,  778,  722,  667,  611,  722,  667,  944,  667,  667,
    {  90 }  611,  278,  278,  278,  469,  556,  333,  556,  556,  500,
    { 100 }  556,  556,  278,  556,  556,  222,  222,  500,  222,  833,
    { 110 }  556,  556,  556,  556,  333,  500,  278,  556,  500,  722,
    { 120 }  500,  500,  500,  334,  260,  334,  584,  350,  558,  350,
    { 130 }  222,  556,  333, 1000,  556,  556,  333, 1000,  667,  333,
    { 140 } 1000,  350,  611,  350,  350,  222,  222,  333,  333,  350,
    { 150 }  556, 1000,  333, 1000,  500,  333,  944,  350,  500,  667,
    { 160 }  278,  333,  556,  556,  556,  556,  260,  556,  333,  737,
    { 170 }  370,  556,  584,  333,  737,  333,  333,  584,  333,  333,
    { 180 }  333,  556,  537,  278,  333,  333,  365,  556,  834,  834,
    { 190 }  834,  611,  667,  667,  667,  667,  667,  667, 1000,  722,
    { 200 }  667,  667,  667,  667,  278,  278,  278,  278,  722,  722,
    { 210 }  778,  778,  778,  778,  778,  584,  778,  722,  722,  722,
    { 220 }  722,  667,  667,  611,  556,  556,  556,  556,  556,  556,
    { 230 }  889,  500,  556,  556,  556,  556,  278,  278,  278,  278,
    { 240 }  556,  556,  556,  556,  556,  556,  556,  584,  611,  556,
    { 250 }  556,  556,  556,  500,  556,  500);

  FontWidthsHelveticaBold: TFontWidthTable = (
    {   0 }  278,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  10 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  20 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  30 }    0,    0,  278,  333,  474,  556,  556,  889,  722,  238,
    {  40 }  333,  333,  389,  584,  278,  333,  278,  278,  556,  556,
    {  50 }  556,  556,  556,  556,  556,  556,  556,  556,  333,  333,
    {  60 }  584,  584,  584,  611,  975,  722,  722,  722,  722,  667,
    {  70 }  611,  778,  722,  278,  556,  722,  611,  833,  722,  778,
    {  80 }  667,  778,  722,  667,  611,  722,  667,  944,  667,  667,
    {  90 }  611,  333,  278,  333,  584,  556,  333,  556,  611,  556,
    { 100 }  611,  556,  333,  611,  611,  278,  278,  556,  278,  889,
    { 110 }  611,  611,  611,  611,  389,  556,  333,  611,  556,  778,
    { 120 }  556,  556,  500,  389,  280,  389,  584,  350,  558,  350,
    { 130 }  278,  556,  500, 1000,  556,  556,  333, 1000,  667,  333,
    { 140 } 1000,  350,  611,  350,  350,  278,  278,  500,  500,  350,
    { 150 }  556, 1000,  333, 1000,  556,  333,  944,  350,  500,  667,
    { 160 }  278,  333,  556,  556,  556,  556,  280,  556,  333,  737,
    { 170 }  370,  556,  584,  333,  737,  333,  333,  584,  333,  333,
    { 180 }  333,  611,  556,  278,  333,  333,  365,  556,  834,  834,
    { 190 }  834,  611,  722,  722,  722,  722,  722,  722, 1000,  722,
    { 200 }  667,  667,  667,  667,  278,  278,  278,  278,  722,  722,
    { 210 }  778,  778,  778,  778,  778,  584,  778,  722,  722,  722,
    { 220 }  722,  667,  667,  611,  556,  556,  556,  556,  556,  556,
    { 230 }  889,  556,  556,  556,  556,  556,  278,  278,  278,  278,
    { 240 }  611,  611,  611,  611,  611,  611,  611,  584,  611,  611,
    { 250 }  611,  611,  611,  556,  611,  556);

  FontWidthsHelveticaOblique: TFontWidthTable = (
    {   0 }  278,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  10 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  20 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  30 }    0,    0,  278,  278,  355,  556,  556,  889,  667,  191,
    {  40 }  333,  333,  389,  584,  278,  333,  278,  278,  556,  556,
    {  50 }  556,  556,  556,  556,  556,  556,  556,  556,  278,  278,
    {  60 }  584,  584,  584,  556, 1015,  667,  667,  722,  722,  667,
    {  70 }  611,  778,  722,  278,  500,  667,  556,  833,  722,  778,
    {  80 }  667,  778,  722,  667,  611,  722,  667,  944,  667,  667,
    {  90 }  611,  278,  278,  278,  469,  556,  333,  556,  556,  500,
    { 100 }  556,  556,  278,  556,  556,  222,  222,  500,  222,  833,
    { 110 }  556,  556,  556,  556,  333,  500,  278,  556,  500,  722,
    { 120 }  500,  500,  500,  334,  260,  334,  584,  350,  558,  350,
    { 130 }  222,  556,  333, 1000,  556,  556,  333, 1000,  667,  333,
    { 140 } 1000,  350,  611,  350,  350,  222,  222,  333,  333,  350,
    { 150 }  556, 1000,  333, 1000,  500,  333,  944,  350,  500,  667,
    { 160 }  278,  333,  556,  556,  556,  556,  260,  556,  333,  737,
    { 170 }  370,  556,  584,  333,  737,  333,  333,  584,  333,  333,
    { 180 }  333,  556,  537,  278,  333,  333,  365,  556,  834,  834,
    { 190 }  834,  611,  667,  667,  667,  667,  667,  667, 1000,  722,
    { 200 }  667,  667,  667,  667,  278,  278,  278,  278,  722,  722,
    { 210 }  778,  778,  778,  778,  778,  584,  778,  722,  722,  722,
    { 220 }  722,  667,  667,  611,  556,  556,  556,  556,  556,  556,
    { 230 }  889,  500,  556,  556,  556,  556,  278,  278,  278,  278,
    { 240 }  556,  556,  556,  556,  556,  556,  556,  584,  611,  556,
    { 250 }  556,  556,  556,  500,  556,  500);

  FontWidthsHelveticaBoldOblique: TFontWidthTable = (
    {   0 }  278,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  10 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  20 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  30 }    0,    0,  278,  333,  474,  556,  556,  889,  722,  238,
    {  40 }  333,  333,  389,  584,  278,  333,  278,  278,  556,  556,
    {  50 }  556,  556,  556,  556,  556,  556,  556,  556,  333,  333,
    {  60 }  584,  584,  584,  611,  975,  722,  722,  722,  722,  667,
    {  70 }  611,  778,  722,  278,  556,  722,  611,  833,  722,  778,
    {  80 }  667,  778,  722,  667,  611,  722,  667,  944,  667,  667,
    {  90 }  611,  333,  278,  333,  584,  556,  333,  556,  611,  556,
    { 100 }  611,  556,  333,  611,  611,  278,  278,  556,  278,  889,
    { 110 }  611,  611,  611,  611,  389,  556,  333,  611,  556,  778,
    { 120 }  556,  556,  500,  389,  280,  389,  584,  350,  558,  350,
    { 130 }  278,  556,  500, 1000,  556,  556,  333, 1000,  667,  333,
    { 140 } 1000,  350,  611,  350,  350,  278,  278,  500,  500,  350,
    { 150 }  556, 1000,  333, 1000,  556,  333,  944,  350,  500,  667,
    { 160 }  278,  333,  556,  556,  556,  556,  280,  556,  333,  737,
    { 170 }  370,  556,  584,  333,  737,  333,  333,  584,  333,  333,
    { 180 }  333,  611,  556,  278,  333,  333,  365,  556,  834,  834,
    { 190 }  834,  611,  722,  722,  722,  722,  722,  722, 1000,  722,
    { 200 }  667,  667,  667,  667,  278,  278,  278,  278,  722,  722,
    { 210 }  778,  778,  778,  778,  778,  584,  778,  722,  722,  722,
    { 220 }  722,  667,  667,  611,  556,  556,  556,  556,  556,  556,
    { 230 }  889,  556,  556,  556,  556,  556,  278,  278,  278,  278,
    { 240 }  611,  611,  611,  611,  611,  611,  611,  584,  611,  611,
    { 250 }  611,  611,  611,  556,  611,  556);

  FontWidthsTimesRoman: TFontWidthTable = (
    {   0 }  250,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  10 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  20 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  30 }    0,    0,  250,  333,  408,  500,  500,  833,  778,  180,
    {  40 }  333,  333,  500,  564,  250,  333,  250,  278,  500,  500,
    {  50 }  500,  500,  500,  500,  500,  500,  500,  500,  278,  278,
    {  60 }  564,  564,  564,  444,  921,  722,  667,  667,  722,  611,
    {  70 }  556,  722,  722,  333,  389,  722,  611,  889,  722,  722,
    {  80 }  556,  722,  667,  556,  611,  722,  722,  944,  722,  722,
    {  90 }  611,  333,  278,  333,  469,  500,  333,  444,  500,  444,
    { 100 }  500,  444,  333,  500,  500,  278,  278,  500,  278,  778,
    { 110 }  500,  500,  500,  500,  333,  389,  278,  500,  500,  722,
    { 120 }  500,  500,  444,  480,  200,  480,  541,  350,  500,  350,
    { 130 }  333,  500,  444, 1000,  500,  500,  333, 1000,  556,  333,
    { 140 }  889,  350,  611,  350,  350,  333,  333,  444,  444,  350,
    { 150 }  500, 1000,  333,  980,  389,  333,  722,  350,  444,  722,
    { 160 }  250,  333,  500,  500,  500,  500,  200,  500,  333,  760,
    { 170 }  276,  500,  564,  333,  760,  333,  333,  564,  300,  300,
    { 180 }  333,  500,  453,  250,  333,  300,  310,  500,  750,  750,
    { 190 }  750,  444,  722,  722,  722,  722,  722,  722,  889,  667,
    { 200 }  611,  611,  611,  611,  333,  333,  333,  333,  722,  722,
    { 210 }  722,  722,  722,  722,  722,  564,  722,  722,  722,  722,
    { 220 }  722,  722,  556,  500,  444,  444,  444,  444,  444,  444,
    { 230 }  667,  444,  444,  444,  444,  444,  278,  278,  278,  278,
    { 240 }  500,  500,  500,  500,  500,  500,  500,  564,  500,  500,
    { 250 }  500,  500,  500,  500,  500,  500);

  FontWidthsTimesBold: TFontWidthTable = (
    {   0 }  250,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  10 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  20 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  30 }    0,    0,  250,  333,  555,  500,  500, 1000,  833,  278,
    {  40 }  333,  333,  500,  570,  250,  333,  250,  278,  500,  500,
    {  50 }  500,  500,  500,  500,  500,  500,  500,  500,  333,  333,
    {  60 }  570,  570,  570,  500,  930,  722,  667,  722,  722,  667,
    {  70 }  611,  778,  778,  389,  500,  778,  667,  944,  722,  778,
    {  80 }  611,  778,  722,  556,  667,  722,  722, 1000,  722,  722,
    {  90 }  667,  333,  278,  333,  581,  500,  333,  500,  556,  444,
    { 100 }  556,  444,  333,  500,  556,  278,  333,  556,  278,  833,
    { 110 }  556,  500,  556,  556,  444,  389,  333,  556,  500,  722,
    { 120 }  500,  500,  444,  394,  220,  394,  520,  350,  500,  350,
    { 130 }  333,  500,  500, 1000,  500,  500,  333, 1000,  556,  333,
    { 140 } 1000,  350,  667,  350,  350,  333,  333,  500,  500,  350,
    { 150 }  500, 1000,  333, 1000,  389,  333,  722,  350,  444,  722,
    { 160 }  250,  333,  500,  500,  500,  500,  220,  500,  333,  747,
    { 170 }  300,  500,  570,  333,  747,  333,  333,  570,  300,  300,
    { 180 }  333,  556,  540,  250,  333,  300,  330,  500,  750,  750,
    { 190 }  750,  500,  722,  722,  722,  722,  722,  722, 1000,  722,
    { 200 }  667,  667,  667,  667,  389,  389,  389,  389,  722,  722,
    { 210 }  778,  778,  778,  778,  778,  570,  778,  722,  722,  722,
    { 220 }  722,  722,  611,  556,  500,  500,  500,  500,  500,  500,
    { 230 }  722,  444,  444,  444,  444,  444,  278,  278,  278,  278,
    { 240 }  500,  556,  500,  500,  500,  500,  500,  570,  500,  556,
    { 250 }  556,  556,  556,  500,  556,  500);

  FontWidthsTimesItalic: TFontWidthTable = (
    {   0 }  250,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  10 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  20 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  30 }    0,    0,  250,  333,  420,  500,  500,  833,  778,  214,
    {  40 }  333,  333,  500,  675,  250,  333,  250,  278,  500,  500,
    {  50 }  500,  500,  500,  500,  500,  500,  500,  500,  333,  333,
    {  60 }  675,  675,  675,  500,  920,  611,  611,  667,  722,  611,
    {  70 }  611,  722,  722,  333,  444,  667,  556,  833,  667,  722,
    {  80 }  611,  722,  611,  500,  556,  722,  611,  833,  611,  556,
    {  90 }  556,  389,  278,  389,  422,  500,  333,  500,  500,  444,
    { 100 }  500,  444,  278,  500,  500,  278,  278,  444,  278,  722,
    { 110 }  500,  500,  500,  500,  389,  389,  278,  500,  444,  667,
    { 120 }  444,  444,  389,  400,  275,  400,  541,  350,  500,  350,
    { 130 }  333,  500,  556,  889,  500,  500,  333, 1000,  500,  333,
    { 140 }  944,  350,  556,  350,  350,  333,  333,  556,  556,  350,
    { 150 }  500,  889,  333,  980,  389,  333,  667,  350,  389,  556,
    { 160 }  250,  389,  500,  500,  500,  500,  275,  500,  333,  760,
    { 170 }  276,  500,  675,  333,  760,  333,  333,  675,  300,  300,
    { 180 }  333,  500,  523,  250,  333,  300,  310,  500,  750,  750,
    { 190 }  750,  500,  611,  611,  611,  611,  611,  611,  889,  667,
    { 200 }  611,  611,  611,  611,  333,  333,  333,  333,  722,  667,
    { 210 }  722,  722,  722,  722,  722,  675,  722,  722,  722,  722,
    { 220 }  722,  556,  611,  500,  500,  500,  500,  500,  500,  500,
    { 230 }  667,  444,  444,  444,  444,  444,  278,  278,  278,  278,
    { 240 }  500,  500,  500,  500,  500,  500,  500,  675,  500,  500,
    { 250 }  500,  500,  500,  444,  500,  444);

  FontWidthsTimesBoldItalic: TFontWidthTable = (
    {   0 }  250,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  10 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  20 }    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  30 }    0,    0,  250,  389,  555,  500,  500,  833,  778,  278,
    {  40 }  333,  333,  500,  570,  250,  333,  250,  278,  500,  500,
    {  50 }  500,  500,  500,  500,  500,  500,  500,  500,  333,  333,
    {  60 }  570,  570,  570,  500,  832,  667,  667,  667,  722,  667,
    {  70 }  667,  722,  778,  389,  500,  667,  611,  889,  722,  722,
    {  80 }  611,  722,  667,  556,  611,  722,  667,  889,  667,  611,
    {  90 }  611,  333,  278,  333,  570,  500,  333,  500,  500,  444,
    { 100 }  500,  444,  333,  500,  556,  278,  278,  500,  278,  778,
    { 110 }  556,  500,  500,  500,  389,  389,  278,  556,  444,  667,
    { 120 }  500,  444,  389,  348,  220,  348,  570,  350,  500,  350,
    { 130 }  333,  500,  500, 1000,  500,  500,  333, 1000,  556,  333,
    { 140 }  944,  350,  611,  350,  350,  333,  333,  500,  500,  350,
    { 150 }  500, 1000,  333, 1000,  389,  333,  722,  350,  389,  611,
    { 160 }  250,  389,  500,  500,  500,  500,  220,  500,  333,  747,
    { 170 }  266,  500,  606,  333,  747,  333,  333,  570,  300,  300,
    { 180 }  333,  576,  500,  250,  333,  300,  300,  500,  750,  750,
    { 190 }  750,  500,  667,  667,  667,  667,  667,  667,  944,  667,
    { 200 }  667,  667,  667,  667,  389,  389,  389,  389,  722,  722,
    { 210 }  722,  722,  722,  722,  722,  570,  722,  722,  722,  722,
    { 220 }  722,  611,  611,  500,  500,  500,  500,  500,  500,  500,
    { 230 }  722,  444,  444,  444,  444,  444,  278,  278,  278,  278,
    { 240 }  500,  556,  500,  500,  500,  500,  500,  570,  500,  556,
    { 250 }  556,  556,  556,  444,  500,  444);

  FontWidthsSymbol: TFontWidthTable = (
    // 12 Symbol --- This is in StandardEncoding
    {   0 }   250,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  10 }     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  20 }     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  30 }     0,    0,  250,  333,  713,  500,  549,  833,  778,  439,
    {  40 }   333,  333,  500,  549,  250,  549,  250,  278,  500,  500,
    {  50 }   500,  500,  500,  500,  500,  500,  500,  500,  278,  278,
    {  60 }   549,  549,  549,  444,  549,  722,  667,  722,  612,  611,
    {  70 }   763,  603,  722,  333,  631,  722,  686,  889,  722,  722,
    {  80 }   768,  741,  556,  592,  611,  690,  439,  768,  645,  795,
    {  90 }   611,  333,  863,  333,  658,  500,  500,  631,  549,  549,
    { 100 }   494,  439,  521,  411,  603,  329,  603,  549,  549,  576,
    { 110 }   521,  549,  549,  521,  549,  603,  439,  576,  713,  686,
    { 120 }   493,  686,  494,  480,  200,  480,  549,    0,    0,    0,
    { 130 }     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    { 140 }     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    { 150 }     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    { 160 }     0,  620,  247,  549,  167,  713,  500,  753,  753,  753,
    { 170 }   753, 1042,  987,  603,  987,  603,  400,  549,  411,  549,
    { 180 }   549,  713,  494,  460,  549,  549,  549,  549, 1000,  603,
    { 190 }  1000,  658,  823,  686,  795,  987,  768,  768,  823,  768,
    { 200 }   768,  713,  713,  713,  713,  713,  713,  713,  768,  713,
    { 210 }   790,  790,  890,  823,  549,  250,  713,  603,  603, 1042,
    { 220 }   987,  603,  987,  603,  494,  329,  790,  790,  786,  713,
    { 230 }   384,  384,  384,  384,  384,  384,  494,  494,  494,  494,
    { 240 }     0,  329,  274,  686,  686,  686,  384,  384,  384,  384,
    { 250 }   384,  384,  494,  494,  494,    0);

  FontWidthsZapfDingbats: TFontWidthTable = (
    // 13 ZapfDingbats --- This is in StandardEncoding
    {   0 }   250,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  10 }     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  20 }     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    {  30 }     0,    0,  278,  974,  961,  974,  980,  719,  789,  790,
    {  40 }   791,  690,  960,  939,  549,  855,  911,  933,  911,  945,
    {  50 }   974,  755,  846,  762,  761,  571,  677,  763,  760,  759,
    {  60 }   754,  494,  552,  537,  577,  692,  786,  788,  788,  790,
    {  70 }   793,  794,  816,  823,  789,  841,  823,  833,  816,  831,
    {  80 }   923,  744,  723,  749,  790,  792,  695,  776,  768,  792,
    {  90 }   759,  707,  708,  682,  701,  826,  815,  789,  789,  707,
    { 100 }   687,  696,  689,  786,  787,  713,  791,  785,  791,  873,
    { 110 }   761,  762,  762,  759,  759,  892,  892,  788,  784,  438,
    { 120 }   138,  277,  415,  392,  392,  668,  668,    0,    0,    0,
    { 130 }     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    { 140 }     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    { 150 }     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    { 160 }     0,  732,  544,  544,  910,  667,  760,  760,  776,  595,
    { 170 }   694,  626,  788,  788,  788,  788,  788,  788,  788,  788,
    { 180 }   788,  788,  788,  788,  788,  788,  788,  788,  788,  788,
    { 190 }   788,  788,  788,  788,  788,  788,  788,  788,  788,  788,
    { 200 }   788,  788,  788,  788,  788,  788,  788,  788,  788,  788,
    { 210 }   788,  788,  894,  838, 1016,  458,  748,  924,  748,  918,
    { 220 }   927,  928,  928,  834,  873,  828,  924,  924,  917,  930,
    { 230 }   931,  463,  883,  836,  836,  867,  867,  696,  696,  874,
    { 240 }     0,  874,  760,  946,  771,  865,  771,  888,  967,  888,
    { 250 }   831,  873,  927,  970,  918,    0);

type

  TRPPDFObject = class(TObject)
  protected
    FOwner: TObject; // PDFWriter
    FID: integer;
    FDataStream: TMemoryStream;

    procedure SetID(AValue: integer);
    function GetID: integer;

    procedure InitData; virtual; abstract;

  public
    constructor Create(AOwner: TObject); virtual;
    destructor Destroy; override;

    property DataStream: TMemoryStream read FDataStream;
    property Owner: TObject read FOwner;

  end;

  TRPPDFCatalog = class(TRPPDFObject)
  protected
    FShowOutlines: boolean;

  public
    procedure InitData; override;

    property ShowOutlines: boolean read FShowOutlines write FShowOutlines;
  end;

  TRPPDFPages = class(TRPPDFObject)
  protected
    FOpenPage: integer;
  public
    procedure InitData; override;
    function GetPageReferences: string;

    property OpenPage: integer read FOpenPage write FOpenPage;
  end;

  TRPPDFPageContent = class(TRPPDFObject)
  protected
    FPageStream: TMemoryStream;

  public
    constructor Create(AOwner: TObject); override;
    destructor Destroy; override;
    procedure InitData; override;

    property PageStream: TMemoryStream read FPageStream;
  end;

  TRPPDFPage = class(TRPPDFObject)
  protected
    FPageContent: TRPPDFPageContent;
    FPageWidth: double;
    FPageHeight: double;
    FTextColor: TColor;
    FLastTextColor: TColor;
    FLastTextColorDefined: boolean;
    FPenColor: TColor;
    FLastPenColor: TColor;
    FLastPenColorDefined: boolean;
    FLastPenWidth: double;
    FLastPenWidthDefined: boolean;
    FBrushColor: TColor;
    FLastBrushColor: TColor;
    FLastBrushColorDefined: boolean;

    property LastTextColorDefined: boolean read FLastTextColorDefined
                                           write FLastTextColorDefined;
    property LastPenColorDefined: boolean read FLastPenColorDefined
                                          write FLastPenColorDefined;
    property LastPenWidthDefined: boolean read FLastPenWidthDefined
                                          write FLastPenWidthDefined;
    property LastBrushColorDefined: boolean read FLastBrushColorDefined
                                            write FLastBrushColorDefined;
    function InchesToUnitsX(const AValue: double): double;
    function InchesToUnitsY(const AValue: double): double;
    function FormaTRPPDFText(const AValue: string): string;
    procedure ClosePath;
    // Rotate (x, y) by angle in degrees, and return output in (xrot, yrot).
    procedure RotateXYCoordinate(AX1, AY1, AAngle: double; var xRot, yRot: double);
    function DegreesToRadians(ADegrees: double): double;
    procedure SmallArc(AX1, AY1, AR1, MidTheta, HalfAngle: double; ccwcw: double;
                       AIndex: integer);
    procedure RadiusArc(const AX1, AY1, AR1, sAngle, eAngle: double);
    procedure AdjustRotationOffset(const ATextWidth: double;
                                   var AX, AY: double);

  public
    constructor Create(AOwner: TObject); override;
    destructor Destroy; override;
    procedure InitData; override;

    function GetRPPDFColor(Color: TColor; bAExpanded: boolean): string;
    function GetEllipsePts(const AX1, AY1, AX2, AY2: Double): TEllipsePts;

    procedure PrintTextColor;
    procedure PrintPenColor;
    procedure PrintBrushColor;
    procedure PrintLeft(const AX, AY: double; AText: string);
    procedure PrintCenter(const AX, AY: double; AText: string);
    procedure PrintRight(const AX, AY: double; AText: string);
    procedure TextRect(Rect: TRect; X1,Y1: double; S1: string);
    procedure MoveTo(const AX, AY: double);
    procedure LineTo(const AX, AY: double; DoClosePath: boolean);
    procedure Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4: Double; DoClosePath, AllowFill: boolean);
    procedure Rectangle(const AX1, AY1, AX2, AY2: Double; const IsClipping: boolean);
    procedure RoundRect(const AX1, AY1, AX2, AY2, AX3, AY3: Double);
    procedure CurveTo(const AX1, AY1, AX2, AY2, AX3, AY3: double);
    procedure Ellipse(const AX1, AY1, AX2, AY2: Double);
    procedure PrintJPG(const AX1, AY1, AX2, AY2: double; AName: string);
    procedure Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4: Double);

    property PageContent: TRPPDFPageContent read FPageContent;
    property PageWidth: double read FPageWidth write FPageWidth;
    property PageHeight: double read FPageHeight write FPageHeight;
    property TextColor: TColor read FTextColor write FTextColor;
    property LastTextColor: TColor read FLastTextColor write FLastTextColor;
    property PenColor: TColor read FPenColor write FPenColor;
    property LastPenColor: TColor read FLastPenColor write FLastPenColor;
    property LastPenWidth: double read FLastPenWidth write FLastPenWidth;
    property BrushColor: TColor read FBrushColor write FBrushColor;
    property LastBrushColor: TColor read FLastBrushColor write FLastBrushColor;
  end;

  TRPPDFOutlines = class(TRPPDFObject)
  protected

  public
    procedure InitData; override;
  end;

  TRPPDFProcSet = class(TRPPDFObject)
  protected

  public
    procedure InitData; override;
  end;

  TRPPDFFont = class(TRPPDFObject)
  protected
    FFontType: string;
    FObjectName: string;
    FFontName: string;
    FPDFFontName: string;

    property FontType: string read FFontType write FFontType;
    property ObjectName: string read FObjectName write FObjectName;
    property PDFFontName: string read FPDFFontName write FPDFFontName;
    property FontName: string read FFontName write FFontName;

  public
    FontWidths: TFontWidthTable;

    constructor Create(AOwner: TObject); override;

    function GetTextWidth(AFontSize: double; AText: string): double;
    procedure InitData; override;
  end;

  TRPPDFXObject = class(TRPPDFObject)
  private
    function GetImageHeight: integer;
    function GetImageWidth: integer;
  protected
    FImageStream: TStream;
    FObjectName: string;
    {$IFDEF Linux}
    FImage: TNDGraphic;
    {$ELSE}
    FImage: TJPEGImage;
    {$ENDIF}
    property ImageStream: TStream read FImageStream;

  public
    constructor Create(AOwner: TObject); override;
    destructor Destroy; override;
    procedure InitData; override;

    property ObjectName: string read FObjectName write FObjectName;
    property Width: integer read GetImageWidth;
    property Height: integer read GetImageHeight;
    {$IFDEF Linux}
    property Image: TNDGraphic read FImage write FImage;
    {$ELSE}
    property Image: TJPEGImage read FImage write FImage;
    {$ENDIF}
  end;

  TCompressEvent = procedure(    InStream: TStream;
                                 OutStream: TStream;
                             var CompressMethod: string) of object;

  TImageQualityRange = 1..100;

  TRPRenderPDF = class(TRPRenderStream)
  private
    function GetPageHeight: double;
    function GetPageWidth: double;
    procedure SetPageHeight(const AValue: double);
    procedure SetPageWidth(const AValue: double);
    function GetPenColor: TColor;
    procedure SetPenColor(const AValue: TColor);
    function GetBrushColor: TColor;
    procedure SetBrushColor(const AValue: TColor);
    function GetTextColor: TColor;
    function GetFont(AFontName: string; AFontStyles: TFontStyles): TRPPDFFont;
    function GetDoFill: boolean;
    function GetDoStroke: boolean;
  protected
    FDataStream: TMemoryStream;
    FOutlineList: TStringList;
    FPageList: TStringList;
    FXObjectList: TStringList;
    FFontList: TStringList;
    FXRefList: TStringList;

    FCatalogObject: TRPPDFCatalog;
    FPagesObject: TRPPDFPages;
    FOutlinesObject: TRPPDFOutlines;
    FCurrentPageObject: TRPPDFPage;
    FCurrentFontObject: TRPPDFFont;
    FProcSetObject: TRPPDFProcSet;

    XRefPos: LongInt;
    FOpenMode: string;
    FFontEncoding: TPDFFontEncoding;
    FFontSize: integer;
    FFontRotation: double;
    FUnderlineFont: boolean;
    FStrikeoutFont: boolean;
    FFrameMode : TFrameMode;
    FUseCompression: boolean;

    FirstNewPage: boolean;
    SmallArcData: TSmallArcBuffer;
    //
    FOnDecodeImage: TDecodeImageEvent;
    FOnCompress: TCompressEvent;
    FImageQuality: TImageQualityRange;
    FMetafileDPI: integer;
    //
    procedure NewPage;

//    function DateTimeToPDF(const Value: TDateTime): string;
    procedure SetTextColor(AColor: TColor);
    procedure SetGraphicColor(AStrokeColor: TColor; ABrushColor: TColor);
    function FormatEx(const AData: string; const AArgs: array of const): string;
    procedure PrintF(const AData: string; const AArgs: array of const); override;
    procedure PrintLnF(const AData: string; const AArgs: array of const); override;

    property PageWidth: double read GetPageWidth write SetPageWidth;
    property PageHeight: double read GetPageHeight write SetPageHeight;
    property FontRotation: double read FFontRotation write FFontRotation;
    property PenColor: TColor read GetPenColor write SetPenColor;
    property BrushColor: TColor read GetBrushColor write SetBrushColor;
    property DataStream: TMemoryStream read FDataStream;
    property TextColor: TColor read GetTextColor write SetTextColor;
    property CurrentFont: TRPPDFFont read FCurrentFontObject
                                   write FCurrentFontObject;
    property UnderlineFont: boolean read FUnderlineFont write FUnderlineFont;
    property StrikeoutFont: boolean read FStrikeoutFont write FStrikeoutFont;
    property FontSize: integer read FFontSize write FFontSize;
    property CurrentPage: TRPPDFPage read FCurrentPageObject
                                   write FCurrentPageObject;
    property PageList: TStringList read FPageList;
    property XObjectList: TStringList read FXObjectList;
    property FontList: TStringList read FFontList;
    property CatalogObject: TRPPDFCatalog read FCatalogObject;
    property OutlinesObject: TRPPDFOutlines read FOutlinesObject;
    property PagesObject: TRPPDFPages read FPagesObject;
    property ProcSetObject: TRPPDFProcSet read FProcSetObject;
    property XRefList: TStringList read FXRefList;
    property OutlineList: TStringList read FOutlineList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure PrintRender(NDRStream: TStream;
                          OutputFileName: TFileName); override;
    procedure CreatePDFObjects;
    procedure FreePDFObjects;
    // PDFWriter

    procedure PrintLeft(const AX, AY: double; AText: string);
    procedure PrintCenter(const AX, AY: double; AText: string);
    procedure PrintRight(const AX, AY: double; AText: string);

    procedure InitData;
    procedure FreeData;

    procedure SetIDs;
    procedure WriteHeader;
    procedure WriteCatalog;
    procedure WriteOutlinesObject;
    procedure WritePagesObject;
    procedure WritePages;
    procedure WriteProcSet;
    procedure WriteFonts;
    procedure WriteXObjects;
    procedure WriteXRef;
    procedure WriteTrailer;
    procedure WriteStartXRef;
    procedure WriteEof;

    procedure RegisterObject;
    procedure GenerateBook;
    //
    procedure FontChanged; override;
    procedure LeftText(const psText: String; const pfX, pfY: Double); override;
    procedure CenterText(const psText: String; const pfX, pfY: Double); override;
    procedure RightText(const psText: String; const pfX, pfY: Double); override;
    procedure TextRect(Rect: TRect; X1,Y1: double;S1: string); override;
    procedure PrintSpaces(const psText: string; const pfX, pfY, pfWidth: Double); override;
    procedure Arc(const AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4: Double); override;
    procedure PDFArc(const AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4: Double; ADoClosePath, AAllowFill: boolean);
    procedure Chord(const AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4: Double); override;
    procedure Rectangle(const pfX1, pfY1, pfX2, pfY2: Double); override;
    procedure PDFRectangle(const AX1, AY1, AX2, AY2: Double);
    procedure FillRect(const pRect: TRect); override;
    procedure RoundRect(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3: Double); override;
    procedure PDFRoundRect(const AX1, AY1, AX2, AY2, AX3, AY3: Double);
    procedure Ellipse(const pfX1, pfY1, pfX2, pfY2: Double); override;
    procedure PDFEllipse(const AX1, AY1, AX2, AY2: Double);
    procedure MoveTo(const pfX1, pfY1: Double); override;
    procedure PDFMoveTo(const AX, AY: double);
    procedure LineTo(const pfX1, pfY1: Double); override;
    procedure PDFLineTo(const AX, AY: double; ADoClosePath: boolean);
    procedure PrintBitmapRect(const X1, Y1, X2, Y2: Double; AGraphic:
      {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap); override;
    procedure PrintImageRect(X1,Y1,X2,Y2: double;ImageStream: TStream;ImageType: string); override;
    procedure PrintBitmap(const X1,Y1,ScaleX,ScaleY: Double; AGraphic:
      {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap); override;
    procedure StretchDraw(const Rect: TRect; AGraphic: TGraphic); override;
    procedure Draw(const pfX1, pfY1: Double; AGraphic: TGraphic); override;

    {$IFDEF ELS}

      procedure ExtTextRect(Rect : TRect;
                            Just : Byte;
                      const Text : string);

      procedure TextRect2(Rect : TRect;
                          X,Y  : double;
                          Just : Byte;
                    const Text : string);
    {$ENDIF}

    function AddJPG(const AImage: {$IFDEF Linux}TNDGraphic{$ELSE}TJPEGImage{$ENDIF}; AReuseJPG: boolean): string;
    procedure PrintJPG(const AX1, AY1, AX2, AY2: double; AName: string);
    procedure Pie(const AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4: Double); override;
    procedure PDFPie(const AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4: Double; ADoClosePath, AAllowFill: boolean);
    //
    procedure DocBegin; override;
    procedure DocEnd; override;
    procedure PageBegin; override;
    procedure PageEnd; override;
    //
    property DoStroke: boolean read GetDoStroke;
    property DoFill: boolean read GetDoFill;
  published
    property UseCompression: boolean read fUseCompression write fUseCompression default false;
    property OnCompress: TCompressEvent read FOnCompress write FOnCompress;
    property ImageQuality: TImageQualityRange read FImageQuality write FImageQuality;
    property MetafileDPI: integer read FMetafileDPI write FMetafileDPI;
    property FontEncoding: TPDFFontEncoding read FFontEncoding write FFontEncoding;
    property OnDecodeImage: TDecodeImageEvent read FOnDecodeImage write
     FOnDecodeImage;
  end;

implementation

{ TRPRenderPDF }

constructor TRPRenderPDF.Create(AOwner: TComponent);
begin
  inherited;
  FFontEncoding := feWinAnsiEncoding;
  DisplayName := 'Adobe Acrobat (PDF)';
  FileExtension := '*.pdf';
  FImageQuality := 90; { JPGImage Quality default }
  FMetaFileDPI := 300;
end;

destructor TRPRenderPDF.Destroy;
begin
  inherited;
end;

procedure TRPRenderPDF.PageBegin;
begin
  If FirstNewPage then begin
    FirstNewPage := false;
  end else begin
    NewPage;
  end;
  PageWidth := PaperWidth;
  PageHeight := PaperHeight;
end;

procedure TRPRenderPDF.PageEnd;
begin
end;

procedure TRPRenderPDF.LeftText(const psText: String; const pfX, pfY: Double);

begin
  PrintLeft(pfX, pfY, psText);
end;

procedure TRPRenderPDF.CenterText(const psText: string; const pfX, pfY: Double);
begin
  PrintCenter(pfX, pfY, psText);
end;

procedure TRPRenderPDF.RightText(const psText: string; const pfX, pfY: Double);
begin
  PrintRight(pfX, pfY, psText);
end;

procedure TRPRenderPDF.PrintSpaces(const psText: string; const pfX, pfY, pfWidth: Double);
begin
  {TODO This is temp}
  PrintLeft(pfX, pfY, psText);
end;

procedure TRPRenderPDF.TextRect(Rect: TRect; X1,Y1: double; S1: string);
begin
  CurrentPage.TextRect(Rect, X1, Y1, S1);
end;


procedure TRPRenderPDF.Rectangle(const pfX1, pfY1, pfX2, pfY2: Double);

begin
  PenColor := Converter.Pen.Color;
  BrushColor := Converter.Brush.Color;
  PDFRectangle(pfX1, pfY1, pfX2, pfY2);
end;

procedure TRPRenderPDF.MoveTo(const pfX1, pfY1: Double);
begin
  PDFMoveTo(pfX1, pfY1);
end;

procedure TRPRenderPDF.LineTo(const pfX1, pfY1: Double);

var
  BrushStyle: TBrushStyle;
  BrushColor: TColor;

begin
  PenColor := Converter.Pen.Color;
  BrushColor := Converter.Brush.Color;
  BrushStyle := Converter.Brush.Style;
  Converter.Brush.Style := bsClear;
  PDFLineTo(pfX1, pfY1, true);
  Converter.Brush.Style := BrushStyle;
  Converter.Brush.Color := BrushColor;
end;

procedure TRPRenderPDF.DocEnd;
begin { DocEnd }
  GenerateBook;
  DataStream.Position := 0;
  FOutputStream.CopyFrom(DataStream, DataStream.Size);

(*
    PrintLn(ObjectStart + '<<');
    PrintLn('/CreationDate (D:%s)', [DateTimeToPDF(Now)]);
    PrintLn('>>');
    PrintLn('endobj');
    PrintLn;
    fObjID_Info := ObjID;
*)

  FreePDFObjects;
end;  { DocEnd }

procedure TRPRenderPDF.DocBegin;
begin
  CreatePDFObjects;
end; { DocBegin }


(*
function TRPRenderPDF.DateTimeToPDF(const Value: TDateTime): string;

var
  sOrigShortDateFormat: string;
  sOrigLongTimeFormat: string;
  s1: string;

begin
  sOrigShortDateFormat := ShortDateFormat;
  sOrigLongTimeFormat := LongTimeFormat;

  ShortDateFormat := 'yyyy/mm/dd';
  LongTimeFormat := 'hh:mm:ss';

  s1 := DateTimeToStr(Value);

  Result := Copy(s1,1,4) + Copy(s1,6,2) + Copy(s1,9,2);
  Result := Result + Copy(s1,12,2) + Copy(s1,15,2) + Copy(s1, 18,2);

  LongTimeFormat := sOrigLongTimeFormat;
  ShortDateFormat := sOrigShortDateFormat;
end;
*)

procedure TRPRenderPDF.SetTextColor(AColor: TColor);

begin
  CurrentPage.TextColor := AColor;
end;

procedure TRPRenderPDF.SetGraphicColor(AStrokeColor: TColor;
                                      ABrushColor: TColor
                                      );
begin
  PenColor := AStrokeColor;
  BrushColor := ABrushColor;
end;

procedure TRPRenderPDF.Ellipse(const pfX1, pfY1, pfX2, pfY2: Double);

begin
  PenColor := Converter.Pen.Color;
  BrushColor := Converter.Brush.Color;
  PDFEllipse(pfX1, pfY1, pfX2, pfY2);
end;

procedure TRPRenderPDF.PrintBitmapRect(const X1, Y1, X2, Y2: Double;
  AGraphic: {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap);

var
  {$IFDEF Linux}
  JPGImage: TNDGraphic;
  {$ELSE}
  JPGImage: TJPEGImage;
  {$ENDIF}
  ImageName: string;

begin
  {$IFDEF Linux}
  JPGImage := TNDGraphic.Create;
  {$ELSE}
  JPGImage := TJPEGImage.Create;
  {$ENDIF}
  try
    JPGImage.CompressionQuality := 100;
    JPGImage.Assign(AGraphic);
    ImageName := AddJPG(JPGImage,Converter.ReuseGraphic);
  finally
    JPGImage.Free;
  end; { tryf }
  PrintJPG(X1, Y1, X2, Y2, ImageName);
end;

procedure TRPRenderPDF.PrintBitmap(const X1,Y1,ScaleX,ScaleY: Double;
  AGraphic: {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap);

var
  {$IFDEF Linux}
  JPGImage: TNDGraphic;
  {$ELSE}
  JPGImage: TJPEGImage;
  {$ENDIF}
  ImageName: string;
  X2, Y2: double;

begin
  {$IFDEF Linux}
  JPGImage := TNDGraphic.Create;
  {$ELSE}
  JPGImage := TJPEGImage.Create;
  {$ENDIF}
  try
    JPGImage.CompressionQuality := 100;
    JPGImage.Assign(AGraphic);
    ImageName := AddJPG(JPGImage,Converter.ReuseGraphic);
  finally
    JPGImage.Free;
  end; { tryf }
  X2 := X1 + ((AGraphic.Width / 72) * ScaleX);
  Y2 := Y1 + ((AGraphic.Height / 72) * ScaleY);
  PrintJPG(X1, Y1, X2, Y2, ImageName);
end;

procedure TRPRenderPDF.FontChanged;

begin
  If (CompareText(Converter.Font.Name, 'Courier') = 0) or
     (CompareText(Converter.Font.Name, 'Courier New') = 0) then begin
    CurrentFont := GetFont('Courier', Converter.Font.Style);
  end else if CompareText(Converter.Font.Name, 'Times New Roman') = 0 then begin
    CurrentFont := GetFont('TimesRoman', Converter.Font.Style);
  end else if CompareText(Converter.Font.Name, 'Symbol') = 0 then begin
    CurrentFont := GetFont('Symbol', Converter.Font.Style);
  end else if CompareText(Converter.Font.Name, 'ZapfDingbats') = 0 then begin
    CurrentFont := GetFont('ZapfDingbats', Converter.Font.Style);
  end else begin
    CurrentFont := GetFont('Helvetica', Converter.Font.Style);
  end; { else }

  If fsUnderline in Converter.Font.Style then begin
    UnderlineFont := true;
  end else begin
    UnderlineFont := false;
  end; { else }
  If fsStrikeout in Converter.Font.Style then begin
    StrikeoutFont := true;
  end else begin
    StrikeoutFont := false;
  end; { else }
  FontSize := Converter.Font.Size;
  TextColor := Converter.Font.Color;
  FontRotation := Converter.FontRotation;

end;

procedure TRPRenderPDF.NewPage;

var
  TextColor: TColor;
  PenColor: TColor;
  BrushColor: TColor;

begin
  TextColor := CurrentPage.TextColor;
  PenColor := CurrentPage.PenColor;
  BrushColor := CurrentPage.BrushColor;
  CurrentPage := TRPPDFPage.Create(self);
  CurrentPage.TextColor := TextColor;
  CurrentPage.PenColor := PenColor;
  CurrentPage.BrushColor := BrushColor;
  PageList.AddObject(FormatEx('P%d',[PageList.Count + 1]), CurrentPage);
end;

function TRPRenderPDF.GetPageHeight: double;
begin
  Result := CurrentPage.PageHeight;
end;

function TRPRenderPDF.GetPageWidth: double;
begin
  Result := CurrentPage.PageWidth;
end;

procedure TRPRenderPDF.SetPageHeight(const AValue: double);
begin
  CurrentPage.PageHeight := AValue;
end;

procedure TRPRenderPDF.SetPageWidth(const AValue: double);
begin
  CurrentPage.PageWidth := AValue;
end;

procedure TRPRenderPDF.PrintLeft(const AX, AY: double; AText: string);

begin
  CurrentPage.PrintLeft(AX, AY, AText);
end;

procedure TRPRenderPDF.PrintCenter(const AX, AY: double; AText: string);

begin
  CurrentPage.PrintCenter(AX, AY, AText);
end;

procedure TRPRenderPDF.PrintRight(const AX, AY: double; AText: string);

begin
  CurrentPage.PrintRight(AX, AY, AText);
end;

function TRPRenderPDF.GetPenColor: TColor;
begin
  Result := CurrentPage.PenColor;
end;

procedure TRPRenderPDF.SetPenColor(const AValue: TColor);
begin
  CurrentPage.PenColor := AValue;
end;

function TRPRenderPDF.GetBrushColor: TColor;
begin
  Result := CurrentPage.BrushColor;
end;

procedure TRPRenderPDF.SetBrushColor(const AValue: TColor);
begin
  CurrentPage.BrushColor := AValue;
end;

procedure TRPRenderPDF.PDFRectangle(const AX1, AY1, AX2, AY2: Double);
begin
  CurrentPage.Rectangle(AX1, AY1, AX2, AY2, false);
end;

procedure TRPRenderPDF.PDFMoveTo(const AX, AY: double);
begin
  CurrentPage.MoveTo(AX, AY);
end;

procedure TRPRenderPDF.PDFLineTo(const AX, AY: double; ADoClosePath: boolean);
begin
  CurrentPage.LineTo(AX, AY, ADoClosePath);
end;

procedure TRPRenderPDF.GenerateBook;
begin
  SetIDs;
  WriteHeader;
  WriteCatalog;
  WriteOutlinesObject;
  WritePagesObject;
  WritePages;
  WriteProcSet;
  WriteFonts;
  WriteXObjects;
  WriteXRef;
  WriteTrailer;
  WriteStartXRef;
  WriteEof;
end;

function TRPRenderPDF.GetTextColor: TColor;
begin
  Result := CurrentPage.TextColor;
end;

procedure TRPRenderPDF.PDFEllipse(const AX1, AY1, AX2, AY2: Double);
begin
  CurrentPage.Ellipse(AX1, AY1, AX2, AY2);
end;

function TRPRenderPDF.AddJPG(const AImage: {$IFDEF Linux}TNDGraphic{$ELSE}TJPEGImage{$ENDIF};
  AReuseJPG: boolean): string;

var
  XObject: TRPPDFXObject;

begin
  If AReuseJPG then begin
  end else begin
    XObject := TRPPDFXObject.Create(self);
    XObject.Image.CompressionQuality := 100;
    XObject.Image.Assign(AImage);
    Result := FormatEx('G%d',[XObjectList.Count + 1]);
    XObject.ObjectName := Result;
    XObjectList.AddObject(Result, XObject);
  end; { else }
end;

procedure TRPRenderPDF.PrintJPG(const AX1, AY1, AX2, AY2: double;
  AName: string);
begin
  CurrentPage.PrintJPG(AX1, AY1, AX2, AY2, AName);
end;

function TRPRenderPDF.GetFont(AFontName: string;
  AFontStyles: TFontStyles): TRPPDFFont;

var
  Offset: integer;
  i1: integer;

begin
  Offset := 0;
  for i1 := 0 to High(FontNames) do begin
    If CompareText(FontNames[i1],AFontName) = 0 then begin
      Offset := i1;
      Break;
    end; { if }
  end; { for }
  If Offset < 9 then begin // skip style attributes for symbol and ZipfDingbats
    If (fsBold in AFontStyles) and (fsItalic in AFontStyles) then begin
      Offset := Offset + Ord(psBoldItalic);
    end else if (fsItalic in AFontStyles) then begin
      Offset := Offset + Ord(psItalic);
    end else if (fsBold in AFontStyles) then begin
      Offset := Offset + Ord(psBold);
    end; { else }
  end; { if }
  Result := TRPPDFFont(FontList.Objects[Offset]);
end;

procedure TRPRenderPDF.SetIDs;

var
  CurrentID: integer;
  i1: integer;
  PDFPage: TRPPDFPage;
  PDFFont: TRPPDFFont;
  PDFXObject: TRPPDFXObject;

begin
 CurrentID := 1;
 CatalogObject.SetID(CurrentID);
 Inc(CurrentID);
 OutlinesObject.SetID(CurrentID);
 Inc(CurrentID);
 PagesObject.SetID(CurrentID);
 for i1 := 0 to PageList.Count - 1 do begin
   PDFPage := TRPPDFPage(PageList.Objects[i1]);
   Inc(CurrentID);
   PDFPage.SetID(CurrentID);
   Inc(CurrentID);
   PDFPage.PageContent.SetID(CurrentID);
 end; { for }
 Inc(CurrentID);
 ProcSetObject.SetID(CurrentID);
 for i1 := 0 to FontList.Count - 1 do begin
   PDFFont := TRPPDFFont(FontList.Objects[i1]);
   Inc(CurrentID);
   PDFFont.SetID(CurrentID);
 end; { for }
 for i1 := 0 to XObjectList.Count - 1 do begin
   PDFXObject := TRPPDFXObject(XObjectList.Objects[i1]);
   Inc(CurrentID);
   PDFXObject.SetID(CurrentID);
 end; { for }

end;

procedure TRPRenderPDF.WriteHeader;
begin
  ActiveStream := DataStream;
  PrintLn(PDFVersion);
  PrintLn('%âãÏÓ');
  PrintLn;
end;

procedure TRPRenderPDF.WriteCatalog;
begin
  RegisterObject;
  CatalogObject.InitData;
  DataStream.CopyFrom(CatalogObject.DataStream, CatalogObject.DataStream.Size);
end;

procedure TRPRenderPDF.WriteOutlinesObject;
begin
  RegisterObject;
  OutlinesObject.InitData;
  DataStream.CopyFrom(OutlinesObject.DataStream, OutlinesObject.DataStream.Size);
end;

procedure TRPRenderPDF.WritePagesObject;
begin
  RegisterObject;
  PagesObject.InitData;
  DataStream.CopyFrom(PagesObject.DataStream, PagesObject.DataStream.Size);
end;

procedure TRPRenderPDF.WritePages;

var
  i1: integer;
  PageObject: TRPPDFPage;
  ContentObject: TRPPDFPageContent;

begin
  for i1 := 0 to PageList.Count - 1 do begin
    RegisterObject;
    PageObject := TRPPDFPage(PageList.Objects[i1]);
    PageObject.InitData;
    DataStream.CopyFrom(PageObject.DataStream, PageObject.DataStream.Size);
    RegisterObject;
    ContentObject := PageObject.PageContent;
    ContentObject.InitData;
    DataStream.CopyFrom(ContentObject.DataStream, ContentObject.DataStream.Size);
  end; { for }
end;

procedure TRPRenderPDF.WriteProcSet;
begin
  RegisterObject;
  ProcSetObject.InitData;
  DataStream.CopyFrom(ProcSetObject.DataStream, ProcSetObject.DataStream.Size);
end;

procedure TRPRenderPDF.WriteFonts;

var
  i1: integer;
  FontObject: TRPPDFFont;

begin
  for i1 := 0 to FontList.Count - 1 do begin
    RegisterObject;
    FontObject := TRPPDFFont(FontList.Objects[i1]);
    FontObject.InitData;
    DataStream.CopyFrom(FontObject.DataStream, FontObject.DataStream.Size);
  end; { for }
end;

procedure TRPRenderPDF.WriteXObjects;

var
  i1: integer;
  XObject: TRPPDFXObject;

begin
  for i1 := 0 to XObjectList.Count - 1 do begin
    RegisterObject;
    XObject := TRPPDFXObject(XObjectList.Objects[i1]);
    XObject.InitData;
    DataStream.CopyFrom(XObject.DataStream, XObject.DataStream.Size);
  end; { for }
end;

procedure TRPRenderPDF.WriteXRef;

var
  i1: integer;
  XRefStr: string;

  function FormatXRef(AValue: longint): string;

  begin
    Result := FormatEx('%10.0d',[AValue]);

    while Pos(' ',Result) > 0 do begin
      Result[Pos(' ',Result)] := '0';
    end; { while }

  end;

begin
  XRefPos := DataStream.Position;

  ActiveStream := DataStream;
  PrintLn('xref');
  PrintLnF('0 %d',[XRefList.Count + 1]);
  PrintLn('0000000000 65535 f');
  for i1 := 1 to XRefList.Count do begin
    XRefStr := FormatXRef(Integer(XRefList.Objects[i1 - 1]));
    PrintLnF('%s 00000 n',[XRefStr]);
  end; { for }
  PrintLn;
end;

procedure TRPRenderPDF.WriteTrailer;
begin
  ActiveStream := DataStream;
  PrintLn('trailer');
  PrintLn('<<');
  PrintLnF('/Size %d',[XRefList.Count + 1]);
  PrintLnF('/Root %d 0 R', [CatalogObject.GetID]);
  PrintLn('>>');
  PrintLn;
end;

procedure TRPRenderPDF.WriteStartXRef;
begin
  ActiveStream := DataStream;
  PrintLn('startxref');
  PrintLnF('%d',[XRefPos]);
end;

procedure TRPRenderPDF.WriteEof;
begin
  ActiveStream := DataStream;
  PrintLn('%%EOF');
end;

procedure TRPRenderPDF.RegisterObject;
begin
  XRefList.AddObject(IntToStr(XRefList.Count + 1), TObject(DataStream.Position));
end;

function TRPRenderPDF.FormatEx(const AData: string;
                                  const AArgs: array of const): string;
var
  OrigSeparator: char;
begin
  OrigSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  Result := Format(AData, AArgs);
  DecimalSeparator := OrigSeparator;
end;

procedure TRPRenderPDF.PrintF(const AData: string;
                                 const AArgs: array of const);
begin
  Print(FormatEx(AData, AArgs));
end;

procedure TRPRenderPDF.PrintLnF(const AData: string;
                                   const AArgs: array of const);
begin
  PrintLn(FormatEx(AData, AArgs));
end;

procedure TRPRenderPDF.PDFRoundRect(const AX1, AY1, AX2, AY2, AX3,
  AY3: Double);
begin
  CurrentPage.RoundRect(AX1, AY1, AX2, AY2, AX3, AY3);
end;

procedure TRPRenderPDF.RoundRect(const pfX1, pfY1, pfX2, pfY2, pfX3,
  pfY3: Double);

begin
  PenColor := Converter.Pen.Color;
  BrushColor := Converter.Brush.Color;
  PDFRoundRect(pfX1, pfY1, pfX2, pfY2, pfX3, pfY3);
end;

procedure TRPRenderPDF.Arc(const AX1, AY1, AX2, AY2, AX3, AY3, AX4,
  AY4: Double);

var
  BrushStyle: TBrushStyle;

begin
  PenColor := Converter.Pen.Color;
  BrushColor := Converter.Brush.Color;
  BrushStyle := Converter.Brush.Style;
  Converter.Brush.Style := bsClear;
  PDFArc(AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4, true, false);
  Converter.Brush.Style := BrushStyle;
end;

procedure TRPRenderPDF.PDFArc(const AX1, AY1, AX2, AY2, AX3, AY3, AX4,
  AY4: Double; ADoClosePath, AAllowFill: boolean);
begin
  CurrentPage.Arc(AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4, ADoClosePath, AAllowFill);
end;

procedure TRPRenderPDF.Chord(const AX1, AY1, AX2, AY2, AX3, AY3, AX4,
  AY4: Double);

begin
  PenColor := Converter.Pen.Color;
  BrushColor := Converter.Brush.Color;
  PDFArc(AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4, true, true);
end;

function TRPRenderPDF.GetDoFill: boolean;
begin
  Result := bsClear <> Converter.Brush.Style;
end;

function TRPRenderPDF.GetDoStroke: boolean;
begin
  Result := psClear <> Converter.Pen.Style;
end;

procedure TRPRenderPDF.PDFPie(const AX1, AY1, AX2, AY2, AX3, AY3, AX4,
  AY4: Double; ADoClosePath, AAllowFill: boolean);
begin
  CurrentPage.Pie(AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4);
end;

procedure TRPRenderPDF.Pie(const AX1, AY1, AX2, AY2, AX3, AY3, AX4,
  AY4: Double);
begin
  PenColor := Converter.Pen.Color;
  BrushColor := Converter.Brush.Color;
  PDFPie(AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4, true, false);
end;

procedure TRPRenderPDF.FreeData;

var
  i1: integer;

begin
  FOwnedStream.Free;
  FOwnedStream := nil;

  FCatalogObject.Free;
  FCatalogObject := nil;
  FOutlinesObject.Free;
  FOutlinesObject := nil;
  FProcSetObject.Free;
  FProcSetObject := nil;
  CurrentFont := nil;
  for i1 := 0 to OutlineList.Count - 1 do begin
    OutlineList.Objects[i1].Free;
  end; { for }
  OutlineList.Clear;
  for i1 := 0 to PageList.Count - 1 do begin
    PageList.Objects[i1].Free;
  end; { for }
  PageList.Clear;
  for i1 := 0 to XObjectList.Count - 1 do begin
    XObjectList.Objects[i1].Free;
  end; { for }
  XObjectList.Clear;
  for i1 := 0 to FontList.Count - 1 do begin
    FontList.Objects[i1].Free;
  end; { for }
  FontList.Clear;
  FPagesObject.Free;
  FPagesObject := nil;
  // XRefList objects do not need to be freed
  XRefList.Clear;
end;

procedure TRPRenderPDF.InitData;
begin
  XRefPos := 0;

  FCatalogObject := TRPPDFCatalog.Create(self);
  FPagesObject := TRPPDFPages.Create(self);
  FCurrentPageObject := TRPPDFPage.Create(self);
  FPageList.AddObject('P1', FCurrentPageObject);

  FOutlinesObject := TRPPDFOutlines.Create(self);
  FProcSetObject := TRPPDFProcSet.Create(self);

  FOpenMode := 'Fit';

{ Courier Fonts }
  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'Courier';
  CurrentFont.PDFFontName := 'Courier';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsCourier;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'Courier';
  CurrentFont.PDFFontName := 'Courier-Bold';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsCourier;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'Courier';
  CurrentFont.PDFFontName := 'Courier-Oblique';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsCourier;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'Courier';
  CurrentFont.PDFFontName := 'Courier-BoldOblique';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsCourier;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

{ Helvetica Fonts }
  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'Helvetica';
  CurrentFont.PDFFontName := 'Helvetica';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsHelvetica;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'Helvetica';
  CurrentFont.PDFFontName := 'Helvetica-Bold';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsHelveticaBold;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'Helvetica';
  CurrentFont.PDFFontName := 'Helvetica-Oblique';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsHelveticaOblique;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'Helvetica';
  CurrentFont.PDFFontName := 'Helvetica-BoldOblique';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsHelveticaBoldOblique;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

{ Times-Roman Fonts }
  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'TimesRoman';
  CurrentFont.PDFFontName := 'Times-Roman';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsTimesRoman;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'TimesRoman';
  CurrentFont.PDFFontName := 'Times-Bold';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsTimesBold;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'TimesRoman';
  CurrentFont.PDFFontName := 'Times-Italic';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsTimesItalic;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'TimesRoman';
  CurrentFont.PDFFontName := 'Times-BoldItalic';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsTimesBoldItalic;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'Symbol';
  CurrentFont.PDFFontName := 'Symbol';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsSymbol;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

  CurrentFont := TRPPDFFont.Create(self);
  CurrentFont.FontName := 'ZapfDingbats';
  CurrentFont.PDFFontName := 'ZapfDingbats';
  CurrentFont.FontType := 'Type1';
  CurrentFont.FontWidths := FontWidthsZapfDingbats;
  FontList.AddObject(CurrentFont.ObjectName,CurrentFont);

  CurrentFont := GetFont('TimesRoman',[fsItalic]);

  FFontSize := 12;

  FirstNewPage := true;
end;

procedure TRPRenderPDF.FillRect(const pRect: TRect);

var
  PenStyle: TPenStyle;

begin
  PenColor := Converter.Pen.Color;
  PenStyle := Converter.Pen.Style;
  Converter.Pen.Style := psClear;
  BrushColor := Converter.Brush.Color;
  PDFRectangle(pRect.Left / 72,
               pRect.Top / 72,
               pRect.Right / 72,
               pRect.Bottom / 72);
  Converter.Pen.Style := PenStyle;
end;

procedure TRPRenderPDF.StretchDraw(const Rect: TRect; AGraphic: TGraphic);

var
  {$IFDEF Linux}
  JPGImage: TNDGraphic;
  {$ELSE}
  JPGImage: TJPEGImage;
  {$ENDIF}
  ImageName: string;
  Bitmap:
    {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap;
  Rect1: TRect;

begin
  {$IFDEF Linux}
  JPGImage := TNDGraphic.Create;
  {$ELSE}
  JPGImage := TJPEGImage.Create;
  {$ENDIF}
  JPGImage.CompressionQuality := ImageQuality;
  Bitmap := {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap.Create;
  try
    Rect1.Left := 0;
    Rect1.Top := 0;
    Rect1.Right := Rect.Right - Rect.Left;
    Rect1.Right := Round(Rect1.Right / DPI_MULTIPLIER * MetafileDPI);
    Rect1.Bottom := Rect.Bottom - Rect.Top;
    Rect1.Bottom := Round(Rect1.Bottom / DPI_MULTIPLIER * MetafileDPI);
    Bitmap.Width := Rect1.Right;
    Bitmap.Height := Rect1.Bottom;
    Bitmap.Canvas.StretchDraw(Rect1, AGraphic);
    JPGImage.Assign(Bitmap);
    JPGImage.Compress;
    ImageName := AddJPG(JPGImage,Converter.ReuseGraphic);

  finally
    JPGImage.Free;
    Bitmap.Free;
  end; { tryf }
  PrintJPG(Rect.Left / DPI_MULTIPLIER,
           Rect.Top / DPI_MULTIPLIER,
           Rect.Right / DPI_MULTIPLIER,
           Rect.Bottom / DPI_MULTIPLIER,
           ImageName);
end;

procedure TRPRenderPDF.Draw(const pfX1, pfY1: Double; AGraphic: TGraphic);
var
  {$IFDEF Linux}
  JPGImage: TNDGraphic;
  {$ELSE}
  JPGImage: TJPEGImage;
  {$ENDIF}
  ImageName: string;
  Bitmap: {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}
    .TBitmap;
  X2, Y2: double;
  Rect1: TRect;

begin
  {$IFDEF Linux}
  JPGImage := TNDGraphic.Create;
  {$ELSE}
  JPGImage := TJPEGImage.Create;
  {$ENDIF}
  JPGImage.CompressionQuality := ImageQuality;
  Bitmap := {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap.Create;
  try
    Bitmap.Width := AGraphic.Width;
    Bitmap.Height := AGraphic.Height;
    Rect1.Left := 0;
    Rect1.Top := 0;
    Rect1.Right := Bitmap.Width;
    Rect1.Bottom := Bitmap.Height;
    Bitmap.Canvas.StretchDraw(Rect1, AGraphic);
    JPGImage.Assign(Bitmap);
    ImageName := AddJPG(JPGImage,Converter.ReuseGraphic);
  finally
    JPGImage.Free;
    Bitmap.Free;
  end; { tryf }
  X2 := pfX1 + (AGraphic.Width / 72);
  Y2 := pfY1 + (AGraphic.Height / 72);
  PrintJPG(pfX1, pfY1, X2, Y2, ImageName);
end; { Draw }



{$IFDEF ELS}

procedure TRPRenderPDF.ExtTextRect(Rect : TRect;
                                   Just : Byte;
                             const Text : string);
var
  {$IFDEF Linux}
  JPGImage: TNDGraphic;
  {$ELSE}
  JPGImage: TJPEGImage;
  {$ENDIF}
  ImageName: string;
  Bitmap: {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}
    .TBitmap;
  X2, Y2: double;
  Flags  : Word;
  TheStr : PChar;

begin
  {$IFDEF Linux}
  JPGImage := TNDGraphic.Create;
  {$ELSE}
  JPGImage := TJPEGImage.Create;
  {$ENDIF}
  JPGImage.CompressionQuality := ImageQuality;
  Bitmap := {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap.Create;
  try
    Bitmap.Width := Rect.Right-Rect.Left;
    Bitmap.Height := Rect.Bottom-Rect.Top;

    X2 := Rect.Left+ (Bitmap.Width / 72);
    Y2 := Rect.Top+ (Bitmap.Height / 72);

    With Bitmap,Canvas do
    Begin
      TheStr := StrAlloc (Length (Text) + 1);
      StrPCopy (TheStr, Text);
      Flags := Just Or DT_VCENTER Or DT_EXPANDTABS Or DT_WORDBREAK Or DT_NOPREFIX ;
      DrawText (Canvas.Handle, TheStr, Length(TheStr), Rect, Flags);
      StrDispose (TheStr);

    end;

    JPGImage.Assign(Bitmap);
    ImageName := AddJPG(JPGImage,Converter.ReuseGraphic);
  finally
    JPGImage.Free;
    Bitmap.Free;
  end; { tryf }
  PrintJPG(Rect.Left, Rect.Top, X2, Y2, ImageName);
end; { Draw }



  procedure TRPRenderPDF.TextRect2(      Rect : TRect;
                                         X,Y  : double;
                                         Just : Byte;
                                   const Text : string);
  var
    RPRenderPDF: TRPRenderPDF;

  begin { TextRect }
    RPRenderPDF := TRPRenderPDF(Owner);
    RPRenderPDF.ActiveStream := PageContent.PageStream;
    RPRenderPDF.PrintLn(' q ');
    With Rect do
    begin
      RPRenderPDF.PenWidth := 0;
      Rectangle(Left / DPI_MULTIPLIER, Top / DPI_MULTIPLIER,
                Right / DPI_MULTIPLIER, Bottom / DPI_MULTIPLIER, true);
    end; { with }

    Case Just of
      DT_CENTER  :  PrintCenter(X, Y, Text);
      DT_RIGHT   :  PrintRight(X, Y, Text);
      else          PrintLeft(X, Y, Text);
    end; {Case..}

    RPRenderPDF.PrintLn(' Q ');
  End; { TextRect2 }


{$ENDIF}


procedure TRPRenderPDF.CreatePDFObjects;
begin
  FDataStream := TMemoryStream.Create;
  FOutlineList := TStringList.Create;
  FPageList:= TStringList.Create;
  FXObjectList := TStringList.Create;
  FFontList := TStringList.Create;
  FXRefList := TStringList.Create;

  InitData;
end;

procedure TRPRenderPDF.FreePDFObjects;
begin
  FreeData;
  FDataStream.Free;
  FDataStream := nil;
  FOutLineList.Free;
  FOutlineList := nil;
  FPageList.Free;
  FPageList := nil;
  FXObjectList.Free;
  FXObjectList := nil;
  FFontList.Free;
  FFontList := nil;
  FXRefList.Free;
  FXRefList := nil;
end;

procedure TRPRenderPDF.PrintImageRect(X1, Y1, X2, Y2: double;
  ImageStream: TStream; ImageType: string);
var
  Bitmap: {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}
    .TBitmap;
begin { PrintImageRect }
  If Assigned(FOnDecodeImage) then begin
    Bitmap :=
      {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}
      .TBitmap.Create;
    try
      FOnDecodeImage(self,ImageStream,ImageType,Bitmap);
      PrintBitmapRect(X1,Y1,X2,Y2,Bitmap);
    finally
      Bitmap.Free;
    end; { tryf }
  end; { if }
end;  { PrintImageRect }

procedure TRPRenderPDF.PrintRender(NDRStream: TStream;
                                   OutputFileName: TFileName);

var
  LExtension: string;

begin
  If Pos('.',OutputFileName) < 1 then begin
    LExtension := Copy(FileExtension, Pos('.',FileExtension),Length(FileExtension));
    If Pos(';',LExtension) > 0 then begin
      LExtension := Copy(LExtension, 0, Pos(';',LExtension) - 1);
    end; { if }

    OutputFileName := OutputFileName + LExtension;
  end; { if }
  InitFileStream(OutputFileName);
  With TRPConverter.Create(NDRStream, self) do try
    Generate;
  finally
    Free;
  end; { with }
end;

{ TRPPDFObject }

constructor TRPPDFObject.Create(AOwner: TObject);
begin
  FDataStream := TMemoryStream.Create;
  FOwner := AOwner;
end;

destructor TRPPDFObject.Destroy;
begin
  inherited;
  FDataStream.Free;
  FDataStream := nil;
end;

function TRPPDFObject.GetID: integer;
begin
  Result := FID;
end;

procedure TRPPDFObject.SetID(AValue: integer);
begin
  FID := AValue;
end;

{ TRPPDFCatalog }

procedure TRPPDFCatalog.InitData;

var
  OutlinesObject: TRPPDFObject;
  PagesObject: TRPPDFObject;
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  OutlinesObject := TRPRenderPDF(Owner).OutlinesObject;
  PagesObject := TRPRenderPDF(Owner).PagesObject;

  RPRenderPDF.ActiveStream := DataStream;
  RPRenderPDF.PrintLnF('%d 0 obj',[GetID]);
  RPRenderPDF.PrintLn('<<');
  RPRenderPDF.PrintLn('/Type /Catalog');
  RPRenderPDF.PrintLnF('/Outlines %d 0 R',[OutlinesObject.GetID]);
  RPRenderPDF.PrintLnF('/Pages %d 0 R',[PagesObject.GetID]);
  if (ShowOutlines) then begin
    RPRenderPDF.PrintLn('/PageMode /UseOutlines');
  end; { if }
//  if (TRPRenderPDF(Owner).OpenMode = 'Fit') then begin
//    RPRenderPDF.PrintLn('/OpenAction [ %d 0 R /%s ] ',
//                       [$page->_getID(), TRPRenderPDF(Owner).OpenMode]);
//  end else if (OpenMode = '') then begin
//    $result .= sprintf("/OpenAction [ %d 0 R /%s 0] \r\n",
//                       $page->_getID(), $openMode);
//  end; { else }
  RPRenderPDF.PrintLn('>>');
  RPRenderPDF.PrintLn('endobj');
  RPRenderPDF.PrintLn;
  RPRenderPDF.ActiveStream.Position := 0;
end;

{ TRPPDFPages }

function TRPPDFPages.GetPageReferences: string;

var
  i1: integer;
  PDFObject: TRPPDFObject;
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  for i1 := 0 to RPRenderPDF.PageList.Count - 1 do begin
    PDFObject := TRPPDFObject(RPRenderPDF.PageList.Objects[i1]);
    Result := Result + RPRenderPDF.FormatEx('%d 0 R ',[PDFObject.GetID]);
  end; { for }

  Result := Copy(Result, 1, Length(Result) - 1);

end;

procedure TRPPDFPages.InitData;

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := DataStream;
  RPRenderPDF.PrintLnF('%d 0 obj',[GetID]);
  RPRenderPDF.PrintLn('<<');
  RPRenderPDF.PrintLn('/Type /Pages');
  RPRenderPDF.PrintLnF('/Count %d',[RPRenderPDF.PageList.Count]);
  RPRenderPDF.PrintLnF('/Kids [ %s ] ', [GetPageReferences]);
  RPRenderPDF.PrintLn('>>');
  RPRenderPDF.PrintLn('endobj');
  RPRenderPDF.PrintLn;
  RPRenderPDF.ActiveStream.Position := 0;
end;

{ TRPPDFPageContent }

constructor TRPPDFPageContent.Create(AOwner: TObject);

var
  RPRenderPDF: TRPRenderPDF;

begin
  inherited Create(AOwner);
  FPageStream := TMemoryStream.Create;
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageStream;
  RPRenderPDF.PrintLn('2 J');
end;

destructor TRPPDFPageContent.Destroy;
begin
  inherited;
  FPageStream.Free;
end;

procedure TRPPDFPageContent.InitData;

var
  RPRenderPDF: TRPRenderPDF;
  CompressMethod: string;
  Stream: TStream;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := DataStream;
  With RPRenderPDF do begin
    PrintLnF('%d 0 obj',[GetID]);

    If UseCompression and Assigned(FOnCompress) then begin
      Stream := TMemoryStream.Create;
      try
        CompressMethod := 'FlateDecode';
        PageStream.Position := 0;
        FOnCompress(PageStream,Stream,CompressMethod);
(* Typical OnCompress method contents
  With TCompressionStream.Create(clMax, OutStream) do try
    CopyFrom(InStream, InStream.Size);
  finally
    Free;
  end; { with }
*)
        PrintLn('<<');
        PrintLnF('/Length %d', [Stream.Size]);
        PrintLn('/Filter [/' + CompressMethod + ']');
        PrintLn('>>');
        PrintLn('stream');
        Stream.Position := 0;
        ActiveStream.CopyFrom(Stream, Stream.Size);
      finally
        Stream.Free;
      end;
    end else begin
      PrintLnF('<< /Length %d >>',[PageStream.Size]);
      PrintLn('stream');
      PageStream.Position := 0;
      ActiveStream.CopyFrom(PageStream, PageStream.Size);
    end; { else }


(*
    UseCompression := RPRender.UseCompression;
    If UseCompression then begin
      Stream := TMemoryStream.Create;
      try
        CompressionStream := TCompressionStream.Create(clMax, Stream);
        try
          PageStream.Position := 0;
          CompressionStream.CopyFrom(PageStream, PageStream.Size);
        finally
          CompressionStream.Free;
        end;
        PrintLn('<<');
        PrintLn('/Length %d', [Stream.Size]);
        PrintLn('/Filter [/FlateDecode]');
        PrintLn('>>');
        PrintLn('stream');
        Stream.Position := 0;
        CopyFrom(Stream, Stream.Size);
      finally
        Stream.Free;
      end;
    end else begin
      PrintLnF('<< /Length %d >>',[PageStream.Size]);
      PrintLn('stream');
      PageStream.Position := 0;
      ActiveStream.CopyFrom(PageStream, PageStream.Size);
(*    end; { else } *)
    PrintLn('endstream');
    PrintLn('endobj');
    PrintLn;
    ActiveStream.Position := 0;
  end; { with }
end;

{ TRPPDFPage }

procedure TRPPDFPage.Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
  pfY4: Double; DoClosePath, AllowFill: boolean);

var
  RPRenderPDF: TRPRenderPDF;
  X1, Y1: double;
  XC, YC: double;
  A1, A2: double;
  R1: double;

  function VectorAngle(XC,YC: Double;
                       XT,YT: Double): Double;

  begin { VectorAngle }
    If XT > XC then begin
      Result := 360.0 - (ArcTan((YT - YC) / (XT - XC)) * 180.0 / Pi);
      If Result > 360.0 then begin
        Result := Result - 360.0;
      end; { if }
    end else if XT < XC then begin
      Result := 180.0 - (ArcTan((YT - YC) / (XT - XC)) * 180.0 / Pi);
    end else begin
      If YT < YC then begin
        Result := 90.0;
      end else begin
        Result := 270.0;
      end; { else }
    end; { else }
  end;  { VectorAngle }

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  With RPRenderPDF do begin
    PrintLn('[]0 d'); // %Reset dash pattern to a solid line
    If not LastPenWidthDefined or (RPRenderPDF.PenWidth <> LastPenWidth) then begin
      PrintLnF('%.4f w ', [RPRenderPDF.PenWidth * DPI_MULTIPLIER]); // %Set linewidth
      LastPenWidth := RPRenderPDF.PenWidth;
      LastPenWidthDefined := true;
    end;

    If not LastPenColorDefined or (PenColor <> LastPenColor) then begin
      PrintPenColor;
      LastPenColor := PenColor;
      LastPenColorDefined := true;
      LastTextColorDefined := false;
    end; { if }
    If not LastBrushColorDefined or (BrushColor <> LastBrushColor) then begin
      PrintBrushColor;
      LastBrushColor := BrushColor;
      LastBrushColorDefined := true;
    end; { if }

    PrintLn('% arc code');
    X1 := (pfX1 + pfX2)/ 2;
    Y1 := (pfY1 + pfY2) / 2;
    R1 := (pfX2 - pfX1) / 2;
    XC := (pfX1 + pfX2) / 2;
    YC := (pfY1 + pfY2) / 2;
    A1 := VectorAngle(XC,YC,pfX3,pfY3);
    A2 := VectorAngle(XC,YC,pfX4,pfY4);
    // TODO: Doesn't currently support elliptical arcs
    RadiusArc(X1, Y1, R1, A1, A2);
//    RadiusArc(X1, Y1, R1, 150, 45);
    If DoClosePath then begin
      If AllowFill then begin
        ClosePath;
      end else begin
        PrintLn('S');
      end; { else }
    end; { if }
  end; { with }
end;

procedure TRPPDFPage.ClosePath;

begin
  with TRPRenderPDF(Owner) do begin
    If DoStroke and DoFill then begin
      PrintLn('b');
    end else if DoFill then begin
      PrintLn('f');
    end else if DoStroke then begin
      PrintLn('S');
    end; { else }
  end;
end;

constructor TRPPDFPage.Create(AOwner: TObject);
begin
  inherited Create(AOwner);

  PageWidth := 8.5;
  PageHeight := 11.0;
  FPageContent := TRPPDFPageContent.Create(AOwner);
  FLastPenColorDefined := false;
  FPenColor := clBlack;
  FLastBrushColorDefined := false;
  FBrushColor := clWhite;
end;

procedure TRPPDFPage.CurveTo(const AX1, AY1, AX2, AY2, AX3, AY3: double);

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  With RPRenderPDF do begin
    PrintLnF('%.4f %.4f %.4f %.4f %.4f %.4f c',[
            InchesToUnitsX(AX1), InchesToUnitsY(AY1),
            InchesToUnitsX(AX2), InchesToUnitsY(AY2),
            InchesToUnitsX(AX3), InchesToUnitsY(AY3)]);
  end; { with }
end;

function TRPPDFPage.DegreesToRadians(ADegrees: double): double;
begin
  Result := ADegrees * System.Pi / 180;
end;

destructor TRPPDFPage.Destroy;
begin
  inherited;

  FPageContent.Free;
end;

procedure TRPPDFPage.Ellipse(const AX1, AY1, AX2, AY2: Double);

var
  RPRenderPDF: TRPRenderPDF;
  EllipsePts: TEllipsePts;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  With RPRenderPDF do begin
    PrintLn('[]0 d'); // %Reset dash pattern to a solid line
    PrintLnF('%.4f w ', [RPRenderPDF.PenWidth * DPI_MULTIPLIER]); // %Set linewidth

    If not LastPenColorDefined or (PenColor <> LastPenColor) then begin
      PrintPenColor;
      LastPenColor := PenColor;
      LastPenColorDefined := true;
      LastTextColorDefined := false;
    end; { if }
    If not LastBrushColorDefined or (BrushColor <> LastBrushColor) then begin
      PrintBrushColor;
      LastBrushColor := BrushColor;
      LastBrushColorDefined := true;
    end; { if }

    EllipsePts := GetEllipsePts(AX1, AY1, AX2, AY2);

    With EllipsePts do begin
      MoveTo(XC,YA);
      CurveTo(XD,YA,XE,YB,XE,YC);
      CurveTo(XE,YD,XD,YE,XC,YE);
      CurveTo(XB,YE,XA,YD,XA,YC);
      CurveTo(XA,YB,XB,YA,XC,YA);
    end; { with }
    ClosePath;
  end; { with }
end; { Ellipse }

function TRPPDFPage.FormaTRPPDFText(const AValue: string): string;

var
  s1: string;
  i1: integer;

begin
  s1 := AValue;
  for i1 := Length(s1) downto 1 do begin
    If (s1[i1] = '(') or (s1[i1] = ')') or (s1[i1] = '\') then begin
      Insert('\', s1, i1);
    end; { if }
  end; { for }
  Result := s1;
end;

function TRPPDFPage.GetEllipsePts(const AX1, AY1, AX2, AY2: Double): TEllipsePts;

var
  RPRenderPDF: TRPRenderPDF;
  Factor: double;
  Offset: double;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  With Result do begin
    case RPRenderPDF.FrameMode of
      fmInside: Offset := RPRenderPDF.PenWidth / 2;
      fmSplit: Offset := 0;
      fmOutside: Offset := -(RPRenderPDF.PenWidth / 2);
      else Offset := 0;
    end; { case }
    Factor := (4.0 / 3.0) * (Sqrt(2) - 1.0);
    //Factor := (Sqrt(2) - 1.0) / 3 * 4;
    If (AX1 + Offset) < (AX2 - Offset) then begin
      XA := AX1 + Offset;
    end else begin
      XA := AX2 - Offset;
    end; { else }
    XC := ((AX1 + Offset) + (AX2 - Offset)) / 2.0;
    If (AX1 + Offset) > (AX2 - Offset) then begin
      XE := AX1 + Offset;
    end else begin
      XE := AX2 - Offset;
    end; { else }
    XB := XC - Factor * (XC - XA);
    XD := XC + Factor * (XC - XA);

    If (AY1 + Offset) < (AY2 - Offset) then begin
      YA := AY1 + Offset;
    end else begin
      YA := AY2 - Offset;
    end; { else }
    YC := ((AY1 + Offset) + (AY2 - Offset)) / 2.0;
    If (AY1 + Offset) > (AY2 - Offset) then begin
      YE := AY1 + Offset;
    end else begin
      YE := AY2 - Offset;
    end; { else }
    YB := YC - Factor * (YC - YA);
    YD := YC + Factor * (YC - YA);
  end; { with }
end;

function TRPPDFPage.GetRPPDFColor(Color: TColor; bAExpanded: boolean): string;
var
  sColor: string;
  dRed: double;
  dGreen: double;
  dBlue: double;
  dMode: double;
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  sColor := IntToHex(Color, 8);
  dMode := StrToInt('$' + Copy(sColor, 1,2)) / 255;
  dBlue := StrToInt('$' + Copy(sColor, 3,2)) / 255;
  dGreen := StrToInt('$' + Copy(sColor, 5,2)) / 255;
  dRed := StrToInt('$' + Copy(sColor, 7, 2)) / 255;
  sColor := RPRenderPDF.FormatEx('%.3g %.3g %.3g', [dRed, dGreen, dBlue]);
  If bAExpanded then begin
    sColor := RPRenderPDF.FormatEx('%s %.3g', [sColor, dMode]);
  end; { if }
  Result := sColor;
end;

function TRPPDFPage.InchesToUnitsX(const AValue: double): double;
begin
  Result := AValue * DPI_MULTIPLIER;
end;

function TRPPDFPage.InchesToUnitsY(const AValue: double): double;
begin
  Result := (PageHeight - AValue) * DPI_MULTIPLIER;
end;

procedure TRPPDFPage.InitData;

var
  i1: integer;
  id: integer;
  PDFObject: TRPPDFObject;
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := DataStream;
  id := GetID;
  RPRenderPDF.PrintLnF('%d 0 obj',[id]);
  RPRenderPDF.PrintLn('<<');
  RPRenderPDF.PrintLn('/Type /Page');
  RPRenderPDF.PrintLnF('/Parent %d 0 R', [RPRenderPDF.PagesObject.GetID]);
  RPRenderPDF.PrintLn('/Resources <<');

  If RPRenderPDF.FontList.Count > 0 then begin
    RPRenderPDF.PrintLn('/Font <<');
    for i1 := 0 to RPRenderPDF.FontList.Count - 1 do begin
      PDFObject := TRPPDFObject(RPRenderPDF.FontList.Objects[i1]);
      RPRenderPDF.PrintLnF('/%s %d 0 R ',[TRPPDFFont(PDFObject).ObjectName, PDFObject.GetID]);
    end; { for }
    RPRenderPDF.PrintLn('>>');
  end; { if }

  If RPRenderPDF.XObjectList.Count > 0 then begin
    RPRenderPDF.PrintLn('/XObject <<');
    for i1 := 0 to RPRenderPDF.XObjectList.Count - 1 do begin
      PDFObject := TRPPDFObject(RPRenderPDF.XObjectList.Objects[i1]);
      RPRenderPDF.PrintLnF('/%s %d 0 R',[TRPPDFXObject(PDFObject).ObjectName, PDFObject.GetID]);
    end; { for }
    RPRenderPDF.PrintLn('>>');
  end; { if }
  RPRenderPDF.PrintLnF('/ProcSet %d 0 R', [RPRenderPDF.ProcSetObject.GetID]);

  RPRenderPDF.PrintLn('>>');
  RPRenderPDF.PrintLnF('/MediaBox [0 0 %.4f %.4f]',[PageWidth * DPI_MULTIPLIER,PageHeight * DPI_MULTIPLIER]);
  RPRenderPDF.PrintLnF('/Contents %d 0 R',[id + 1]);
  RPRenderPDF.PrintLn('>>');
  RPRenderPDF.PrintLn('endobj');
  RPRenderPDF.PrintLn;
  RPRenderPDF.ActiveStream.Position := 0;

end;

procedure TRPPDFPage.LineTo(const AX, AY: double; DoClosePath: boolean);

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  With RPRenderPDF do begin
    If not LastPenColorDefined or (PenColor <> LastPenColor) then begin
      PrintPenColor;
      LastPenColor := PenColor;
      LastPenColorDefined := true;
      LastTextColorDefined := false;
    end; { if }
    If not LastBrushColorDefined or (BrushColor <> LastBrushColor) then begin
      PrintBrushColor;
      LastBrushColor := BrushColor;
      LastBrushColorDefined := true;
      LastTextColorDefined := false;
    end; { if }
    //PrintLn('[]0 d %Reset dash pattern to a solid line');
    If not LastPenWidthDefined or (RPRenderPDF.PenWidth <> LastPenWidth) then begin
      PrintLnF('%.4f w ', [RPRenderPDF.PenWidth * DPI_MULTIPLIER]); // %Set linewidth
      LastPenWidth := RPRenderPDF.PenWidth;
      LastPenWidthDefined := true;
    end;
    PrintF('%.4f %.4f l ',[InchesToUnitsX(AX),InchesToUnitsY(AY)]);

    If DoClosePath then begin
      ClosePath;
    end; { if }
  end; { with }
end; { LineTo }

procedure TRPPDFPage.MoveTo(const AX, AY: double);

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  With RPRenderPDF do begin
    PrintLnF('%.4f %.4f m',[InchesToUnitsX(AX),InchesToUnitsY(AY)]);
  end; { with }
end;

procedure TRPPDFPage.Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
  pfY4: Double);
begin
  Arc(pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,pfY4, false, true);
  LineTo((pfX1 + pfX2) / 2.0, (pfY1 + pfY2) / 2.0, true);
end;

procedure TRPPDFPage.PrintBrushColor;

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  With RPRenderPDF do begin
    PrintLnF('%s rg',[GeTRPPDFColor(BrushColor, false)]);
  end; { with }
end;


procedure TRPPDFPage.AdjustRotationOffset(const ATextWidth: double;
                                            var AX, AY: double);

var
  RPRenderPDF: TRPRenderPDF;
  Rotation: double;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  Rotation := RPRenderPDF.FontRotation;

  If (Rotation > 0) and (Rotation <= 90) then begin
    AX := AX - (ATextWidth) * cos(Rotation * pi / 180);
    AY := AY + (ATextWidth) * sin(Rotation * pi / 180);
  end else if (Rotation > 90) and (Rotation <= 180) then begin
    AX := AX + (ATextWidth) * cos((180 - Rotation) * pi / 180);
    AY := AY + (ATextWidth) * sin((180 - Rotation) * pi / 180);
  end else if (Rotation > 180) and (Rotation <= 270) then begin
    AX := AX + (ATextWidth) * cos((Rotation - 180) * pi / 180);
    AY := AY - (ATextWidth) * sin((Rotation - 180) * pi / 180);
  end else if (Rotation > 270) and (Rotation < 360) then begin
    AX := AX - (ATextWidth) * cos((360 - Rotation) * pi / 180);
    AY := AY - (ATextWidth) * sin((360 - Rotation) * pi / 180);
  end else begin
    AX := AX - (ATextWidth);
    AY := AY;
  end; { else }

end;


procedure TRPPDFPage.PrintCenter(const AX, AY: double; AText: string);

var
  RPRenderPDF: TRPRenderPDF;
  TextWidth : double;
  CurrentFont: TRPPDFFont;
  X2,Y2: double;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  CurrentFont := RPRenderPDF.CurrentFont;
  TextWidth := CurrentFont.GetTextWidth(RPRenderPDF.FontSize, AText);
  X2 := AX;
  Y2 := AY;

  AdjustRotationOffset(TextWidth/2, X2, Y2);
  PrintLeft(X2, Y2, AText);
end;

procedure TRPPDFPage.TextRect(Rect: TRect; X1,Y1: double; S1: string);

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  RPRenderPDF.PrintLn(' q ');
  With Rect do begin
    RPRenderPDF.PenWidth := 0;
    Rectangle(Left / DPI_MULTIPLIER, Top / DPI_MULTIPLIER,
              Right / DPI_MULTIPLIER, Bottom / DPI_MULTIPLIER, true);
  end; { with }

  PrintLeft(X1, Y1, S1);
  RPRenderPDF.PrintLn(' Q ');
end;

procedure TRPPDFPage.PrintJPG(const AX1, AY1, AX2, AY2: double;
  AName: string);

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  With RPRenderPDF do begin
    PrintLn('q');
    PrintLnF('%.4f 0 0 %.4f %.4f %.4f cm',[
                              (AX2 - AX1) * DPI_MULTIPLIER,
                              (AY2 - AY1) * DPI_MULTIPLIER,
                              AX1 * DPI_MULTIPLIER,
                              (PageHeight - AY2) * DPI_MULTIPLIER]);
    PrintLnF('/%s Do',[AName]);
    PrintLn('Q');
  end; { with }
end;

procedure TRPPDFPage.PrintLeft(const AX, AY: double; AText: string);

var
  FontObjectName: string;
  Radians: double;
  CurrentFont: TRPPDFFont;
  RPRenderPDF: TRPRenderPDF;
  Offset: double;
  LineWidth: double;
  SaveLineWidth: double;
  x1: double;
  y1: double;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  CurrentFont := RPRenderPDF.CurrentFont;
  With RPRenderPDF do begin
    PrintLn('BT');
    If not LastTextColorDefined or (TextColor <> LastTextColor) then begin
      PrintTextColor;
      LastTextColor := TextColor;
      LastTextColorDefined := true;
      LastPenColorDefined := false;
      LastBrushColorDefined := false;
    end; { if }
    FontObjectName := CurrentFont.ObjectName;
    PrintLnF('/%s %.4d Tf',[FontObjectName,RPRenderPDF.FontSize]);

    If CompareText(CurrentFont.FontName,'Courier') = 0 then begin
      Offset := (RPRenderPDF.FontSize / DPI_MULTIPLIER) * 0.65;
    end else begin
      Offset := (RPRenderPDF.FontSize * 0.275) / DPI_MULTIPLIER;
    end; { else }
    PrintLnF('%.4f %.4f Td',[InchesToUnitsX(AX - Offset), InchesToUnitsY(AY)]);

    If FontRotation <> 0 then begin
      Radians := FontRotation * pi / 180;
      PrintLnF('%.4f %.4f %.4f %.4f %.4f %.4f Tm',[
              Cos(Radians),Sin(Radians),-Sin(Radians), Cos(Radians),
              InchesToUnitsX(AX),InchesToUnitsY(AY)]);
    end; { if }

    PrintLnF('( %s ) Tj',[FormaTRPPDFText(AText)]);
    PrintLn('ET');

  end; { with }

  If (RPRenderPDF.FontRotation = 0)
      and (RPRenderPDF.UnderlineFont
      or RPRenderPDF.StrikeoutFont) then begin
    SaveLineWidth := RPRenderPDF.PenWidth;
    x1 := AX + CurrentFont.GetTextWidth(RPRenderPDF.FontSize, AText);
    If RPRenderPDF.UnderlineFont then begin
      LineWidth := (RPRenderPDF.FontSize + 1) * 0.0014;
      RPRenderPDF.PenWidth := LineWidth;
      y1 := AY + (LineWidth * 1.5);
      MoveTo(AX, y1);
      LineTo(x1, y1, true);
    end; { if }
    If RPRenderPDF.StrikeoutFont then begin
      LineWidth := (RPRenderPDF.FontSize + 1) * 0.0006;
      RPRenderPDF.PenWidth := LineWidth;
      y1 := AY - (RPRenderPDF.FontSize / DPI_MULTIPLIER) * 0.22;
      MoveTo(AX, y1);
      LineTo(x1, y1, true);
    end; { if }
    RPRenderPDF.PenWidth := SaveLineWidth;
  end; { if }
end;

procedure TRPPDFPage.PrintPenColor;

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  With RPRenderPDF do begin
    PrintLnF('%s RG',[GeTRPPDFColor(PenColor, false)]);
  end; { with }
end;

procedure TRPPDFPage.PrintRight(const AX, AY: double; AText: string);

var
  RPRenderPDF: TRPRenderPDF;
  TextWidth : double;
  CurrentFont: TRPPDFFont;
  X2,Y2: double;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  CurrentFont := RPRenderPDF.CurrentFont;
  TextWidth := CurrentFont.GetTextWidth(RPRenderPDF.FontSize, AText);
  X2 := AX;
  Y2 := AY;
  
  AdjustRotationOffset(TextWidth, X2, Y2);
  PrintLeft(X2, Y2, AText);
end;

procedure TRPPDFPage.PrintTextColor;

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  With RPRenderPDF do begin
    PrintLnF('%s rg',[GeTRPPDFColor(TextColor, false)]);
  end; { with }
end;

procedure TRPPDFPage.RadiusArc(const AX1, AY1, AR1, sAngle, eAngle: double);

var
  RPRenderPDF: TRPRenderPDF;
  i1: integer;
  numArcs: integer;
  ccwcw: double;
  angleBump: double;
  halfBump: double;
  aSpan: double;
  curAngle: double;

begin
  if sAngle <> eAngle then begin
    numArcs := 1;
    ccwcw := 1.0;

    aSpan := eAngle - sAngle;
    if aSpan < 0 then begin
      aSpan := 360 + aSpan;
    end;

    if eAngle < sAngle then begin
      ccwcw := -1.0;
    end; { if }
    while Abs(aSpan) / numArcs > 90.0 do begin
      Inc(numArcs);
    end; { while }
    angleBump := aSpan / numArcs;
    halfBump := 0.5 * angleBump;
    curAngle := sAngle + halfBump;
    for i1 := 1 to numArcs do begin
      SmallArc(AX1,AY1,AR1,curAngle,halfBump, ccwcw, i1);
      curAngle := curAngle + angleBump;
    end;
    RPRenderPDF := TRPRenderPDF(Owner);
    with RPRenderPDF do begin
      if (eAngle - sAngle) < 0 then begin
        moveto(SmallArcData[numArcs].X1, SmallArcData[numArcs].Y1);
        for i1 := numArcs downto 1 do begin
          with SmallArcData[i1] do begin
            CurveTo(X2, Y2, X3, Y3, X4, Y4);
          end; { with }
        end; { for }
      end else begin
        moveto(SmallArcData[1].X1, SmallArcData[1].Y1);
        for i1 := 1 to numArcs do begin
          with SmallArcData[i1] do begin
            CurveTo(X2, Y2, X3, Y3, X4, Y4);
          end; { with }
        end; { for }
      end;
    end; { with }
  end;
end;

procedure TRPPDFPage.Rectangle(const AX1, AY1, AX2, AY2: Double;
  const IsClipping: boolean);

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  With RPRenderPDF do begin
    PrintLn('[]0 d'); // %Reset dash pattern to a solid line
    PrintLnF('%.4f w ', [RPRenderPDF.PenWidth * DPI_MULTIPLIER]); // %Set linewidth

    If not LastPenColorDefined or (PenColor <> LastPenColor) then begin
      PrintPenColor;
      LastPenColor := PenColor;
      LastPenColorDefined := true;
      LastTextColorDefined := false;
    end; { if }
    If not LastBrushColorDefined or (BrushColor <> LastBrushColor) then begin
      PrintBrushColor;
      LastBrushColor := BrushColor;
      LastBrushColorDefined := true;
    end; { if }
    PrintF('%.4f %.4f %.4f %.4f re ',[
                             InchesToUnitsX(AX1),
                             InchesToUnitsY(AY1),
                             InchesToUnitsX(AX2 - AX1),
                             InchesToUnitsY(AY2) -
                             InchesToUnitsY(AY1)
                             ]);
    If IsClipping then begin
      PrintLn('W n ');
    end; { if }
    ClosePath;
  end; { with }
end;

// Rotate (x, y) by angle in degrees, and return output in (xrot, yrot).
procedure TRPPDFPage.RotateXYCoordinate(AX1, AY1, AAngle: double; var xRot,
  yRot: double);

var
  Theta, rCos, rSin: double; //cos, sine of theta

begin
  Theta := DegreesToRadians(AAngle);
  rCos := Cos(Theta);
  rSin := Sin(Theta);
  xRot := (rCos * AX1) - (rSin * AY1);
  yRot := (rSin * AX1) + (rCos * AY1);
end;

procedure TRPPDFPage.RoundRect(const AX1, AY1, AX2, AY2, AX3, AY3: Double);

var
  RPRenderPDF: TRPRenderPDF;
  EllipsePts: TEllipsePts;
  RectLineWidth: double;
  RectLineHeight: double;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := PageContent.PageStream;
  With RPRenderPDF do begin
    PrintLn('[]0 d'); // %Reset dash pattern to a solid line
    PrintLnF('%.4f w ', [RPRenderPDF.PenWidth * DPI_MULTIPLIER]); // %Set linewidth

    If not LastPenColorDefined or (PenColor <> LastPenColor) then begin
      PrintPenColor;
      LastPenColor := PenColor;
      LastPenColorDefined := true;
      LastTextColorDefined := false;
    end; { if }
    If not LastBrushColorDefined or (BrushColor <> LastBrushColor) then begin
      PrintBrushColor;
      LastBrushColor := BrushColor;
      LastBrushColorDefined := true;
    end; { if }

    EllipsePts := GetEllipsePts(AX1, AY1, AX1 + AX3, AY1 + AY3);
    RectLineWidth := AX2 - AX1 - AX3;
    RectLineHeight := AY2 - AY1 - AY3;

    With EllipsePts do begin
      MoveTo(XC,YA);
      PDFLineTo(XC + RectLineWidth, YA, false);
      CurveTo(XD + RectLineWidth,YA,XE + RectLineWidth,YB,XE + RectLineWidth,YC);
      PDFLineTo(XE + RectLineWidth,YC + RectLineHeight, false);
      CurveTo(
        XE + RectLineWidth,
        YD + RectLineHeight,
        XD + RectLineWidth,
        YE + RectLineHeight,
        XC + RectLineWidth,
        YE + RectLineHeight
      );
      PDFLineTo(XC, YE + RectLineHeight, false);
      CurveTo(
        XB,
        YE + RectLineHeight,
        XA,
        YD + RectLineHeight,
        XA,
        YC + RectLineHeight
      );
      PDFLineTo(XA, YC, false);
      CurveTo(XA,YB,XB,YA,XC,YA);
    end; { with }
    ClosePath;
  end; { with }
end;

procedure TRPPDFPage.SmallArc(AX1, AY1, AR1, MidTheta, HalfAngle,
ccwcw: double; AIndex: integer);

var
  RPRenderPDF: TRPRenderPDF;
  vCos, vSin: double;
  x0, y0, x1, y1, x2, y2, x3, y3: double;
  HalfTheta: double;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  HalfTheta := DegreesToRadians(Abs(halfAngle));
  vCos := Cos(HalfTheta);
  vSin := Sin(HalfTheta);

  x0 := AR1 * vCos;
  y0 := -ccwcw * AR1 * vSin;
  x1 := AR1 * (4.0 - vCos) / 3.0;
  x2 := x1;
  y1 := AR1 * ccwcw * (1.0 - vCos) * (vCos - 3.0) / (3.0 * vSin);
  y2 := -y1;
  x3 := AR1 * vCos;
  y3 := ccwcw * AR1 * vSin;

  RotateXYCoordinate(x0,y0,MidTheta,x0,y0);
  RotateXYCoordinate(x1,y1,MidTheta,x1,y1);
  RotateXYCoordinate(x2,y2,MidTheta,x2,y2);
  RotateXYCoordinate(x3,y3,MidTheta,x3,y3);
  with RPRenderPDF do begin
    SmallArcData[AIndex].X1 := AX1 + x0;
    SmallArcData[AIndex].Y1 := AY1 - y0;
    SmallArcData[AIndex].X2 := AX1 + x1;
    SmallArcData[AIndex].Y2 := AY1 - y1;
    SmallArcData[AIndex].X3 := AX1 + x2;
    SmallArcData[AIndex].Y3 := AY1 - y2;
    SmallArcData[AIndex].X4 := AX1 + x3;
    SmallArcData[AIndex].Y4 := AY1 - y3;
  end; { with }
//MoveTo(AX1+x0,AY1-y0);
//CurveTo(AX1+x1,AY1-y1,AX1+x2,AY1-y2,AX1+x3,AY1-y3);
end;

{ TRPPDFOutlines }

procedure TRPPDFOutlines.InitData;

var
  RPRenderPDF: TRPRenderPDF;
  OutlineList: TStringList;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := DataStream;
  OutlineList := RPRenderPDF.OutlineList;
  RPRenderPDF.PrintLnF('%d 0 obj',[GetID]);
  RPRenderPDF.PrintLn('<<');
  RPRenderPDF.PrintLn('/Type /Outlines');
  RPRenderPDF.PrintLnF('/Count %d',[OutlineList.Count]);
  RPRenderPDF.PrintLn('>>');
  RPRenderPDF.PrintLn('endobj');
  RPRenderPDF.PrintLn;
  RPRenderPDF.ActiveStream.Position := 0;
end;

{ TRPPDFProcSet }

procedure TRPPDFProcSet.InitData;

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := DataStream;
  RPRenderPDF.PrintLnF('%d 0 obj',[GetID]);

  If RPRenderPDF.XObjectList.Count > 0 then begin
    RPRenderPDF.PrintLn('[/PDF /Text /ImageB /ImageC /ImageI]');
  end else begin
    RPRenderPDF.PrintLn('[/PDF /Text]');
  end; { else }

  RPRenderPDF.PrintLn('endobj');
  RPRenderPDF.PrintLn;
  RPRenderPDF.ActiveStream.Position := 0;
end;

{ TRPPDFFont }

constructor TRPPDFFont.Create(AOwner: TObject);

var
  RPRenderPDF: TRPRenderPDF;

begin
  inherited;
  RPRenderPDF := TRPRenderPDF(Owner);
  ObjectName := RPRenderPDF.FormatEx('F%d',[RPRenderPDF.FontList.Count + 1]);
end;

function TRPPDFFont.GetTextWidth(AFontSize: double; AText: string): double;
var
  i1: integer;

begin
  Result := 0;
  for i1 := 1 to Length(AText) do begin
    Result := Result + FontWidths[Ord(AText[i1])];
  end; { for }

  Result := (Result / 1000) * AFontSize / DPI_MULTIPLIER;
end;

procedure TRPPDFFont.InitData;

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := DataStream;
  With RPRenderPDF do begin
    PrintLnF('%d 0 obj',[GetID]);
    PrintLn('<<');
    PrintLn('/Type /Font');
    PrintLnF('/Subtype /%s',[FontType]);
    PrintLnF('/Name /%s',[ObjectName]);
    PrintLnF('/BaseFont /%s',[PDFFontName]);
    PrintLn('/Encoding /' + FontEncodingNames[FontEncoding]);
    PrintLn('>>');
    PrintLn('endobj');
    PrintLn;
    ActiveStream.Position := 0;
  end; { with }
end;

{ TRPPDFXObject }

constructor TRPPDFXObject.Create(AOwner: TObject);
begin
  inherited;
  FImageStream := TMemoryStream.Create;
  {$IFDEF Linux}
  FImage := TNDGraphic.Create;
  {$ELSE}
  FImage := TJPEGImage.Create;
  FImage.CompressionQuality := 100;
  {$ENDIF}
end;

destructor TRPPDFXObject.Destroy;
begin
  inherited;
  FImageStream.Free;
  FImage.Free;
end;

function TRPPDFXObject.GetImageHeight: integer;
begin
  Result := FImage.Height;
end;

function TRPPDFXObject.GetImageWidth: integer;
begin
  Result := FImage.Width;
end;

procedure TRPPDFXObject.InitData;

var
  RPRenderPDF: TRPRenderPDF;

begin
  RPRenderPDF := TRPRenderPDF(Owner);
  RPRenderPDF.ActiveStream := DataStream;
  With RPRenderPDF do begin
    Image.CompressionQuality := RPRenderPDF.ImageQuality;
    Image.SaveToStream(ImageStream);
    ImageStream.Position := 0;
    PrintLnF('%d 0 obj',[GetID]);
    PrintLn('<<');
    PrintLn('/Type /XObject');
    PrintLn('/Subtype /Image');
    PrintLnF('/Name /%s',[ObjectName]);
    PrintLnF('/Width %d /Height %d ',[Width,Height]);
    PrintLn('/BitsPerComponent 8');
    PrintLnF('/ColorSpace /DeviceRGB /Length %d /Filter [/DCTDecode ]',
                            [ImageStream.Size]);
    PrintLn('>>');
    PrintLn('stream');
    ActiveStream.CopyFrom(ImageStream, ImageStream.Size);
    PrintLn('endstream');

    PrintLn('>>');
    PrintLn('endobj');
    PrintLn;
    ActiveStream.Position := 0;
  end; { with }
end;

end.