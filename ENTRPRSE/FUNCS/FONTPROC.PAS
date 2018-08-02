unit FontProc;

interface
uses
  Classes, Graphics, SysUtils, Windows;

  function BuildFontSizeList(slSizes : TStringList; FontName : string) : integer;
  function GetFontStyleIndexFrom(AFont : TFont) : integer;
  function GetFontStyleFromIndex(iIndex : integer): TFontStyles;

implementation

function EnumFontSizes(var EnumLogFont: TEnumLogFont;
  PTextMetric: PNewTextMetric; FontType: Integer; Data: LPARAM): Integer;
  export; stdcall;
var s: String;
    i,v,v2: Integer;
begin

//  ShowMessage('EnumLogFont.elfLogFont.lfWeight / lfItalic : ' + IntToStr(EnumLogFont.elfLogFont.lfWeight)
//  + ' / ' + IntToStr(EnumLogFont.elfLogFont.lfItalic));
//  ShowMessage('PTextMetric.tmItalic : ' + IntToStr(PTextMetric.tmItalic));

  if (FontType and TRUETYPE_FONTTYPE)<>0 then begin
    TStringList(Data).Add('8');
    TStringList(Data).Add('9');
    TStringList(Data).Add('10');
    TStringList(Data).Add('11');
    TStringList(Data).Add('12');
    TStringList(Data).Add('14');
    TStringList(Data).Add('16');
    TStringList(Data).Add('18');
    TStringList(Data).Add('20');
    TStringList(Data).Add('22');
    TStringList(Data).Add('24');
    TStringList(Data).Add('26');
    TStringList(Data).Add('28');
    TStringList(Data).Add('36');
    TStringList(Data).Add('48');
    TStringList(Data).Add('72');
    Result := 0;
    end
  else begin
    v := Round((EnumLogFont.elfLogFont.lfHeight-PTextMetric.tmInternalLeading)*72 /
      Ord(TStringList(Data).QuoteChar));
    s := IntToStr(v);
    Result := 1;
    for i := 0 to TStringList(Data).Count-1 do begin
      v2 := StrToInt(TStringList(Data)[i]);
      if v2=v then
        exit;
      if v2>v then begin
        TStringList(Data).Insert(i,s);
        exit;
      end;
    end;
    TStringList(Data).Add(s);
  end;
end;

function BuildFontSizeList(slSizes : TStringList; FontName : string) : integer;
var
  DC: HDC;
//  OC: TNotifyEvent;
begin
  Result := -1; //PR: 21/06/2016 v2016 R2 ABSEXCH-17390 Default result to avoid warning message
  with slSizes do begin
    DC := GetDC(0);
    BeginUpdate;
    try
      Clear;
      if FontName <> '' then begin
        QuoteChar := Char(GetDeviceCaps(DC, LOGPIXELSY));
        EnumFontFamilies(DC, PChar(FontName), @EnumFontSizes, Longint(slSizes));
//        OC := OnClick;
//        OnClick := nil;
        Result := IndexOf(Text);
        if Result = -1 then Result := 0;
//        cmbSize.OnChange(cmbSize);
//        OnClick := OC;
//        if Assigned(OnClick) then
//          OnClick(cmbSize);
      end;
    finally
      EndUpdate;
      ReleaseDC(0, DC);
    end;
  end;{with}
end;

function GetFontStyleIndexFrom(AFont : TFont) : integer;
begin{GetFontStyleIndexFrom}
  if fsItalic in AFont.Style then
  begin
    if fsBold in AFont.Style then Result := 3
    else Result := 1;
  end else begin
    if fsBold in AFont.Style then Result := 2
    else Result := 0;
  end;{if}
end;{GetFontStyleIndexFrom}

function GetFontStyleFromIndex(iIndex : integer): TFontStyles;
begin
  Case iIndex of
    0 : Result := [];
    1 : Result := [fsItalic];
    2 : Result := [fsBold];
    3 : Result := [fsBold, fsItalic];
  end;{case}
end;


end.
