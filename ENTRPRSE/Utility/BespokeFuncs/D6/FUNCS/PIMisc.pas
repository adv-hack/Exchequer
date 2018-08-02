unit PIMisc;

interface
uses
  classes;

  procedure PIMakeAboutText(sName, sVersionNo : string; AboutText : TStrings);

implementation
uses
  SysUtils, StrUtil;

procedure PIMakeAboutText(sName, sVersionNo : string; AboutText : TStrings);
// Creates the standard Exchequer text to go in the about box.
begin
  {Adds the text into the supplied string list}
  AboutText.Add('Name : ' + sName);
  AboutText.Add('Version : ' + sVersionNo);
  AboutText.Add('Author : IRIS Enterprise Software');
  AboutText.Add('Support : Contact your IRIS Exchequer helpline number');
  AboutText.Add(GetCopyrightMessage);
  AboutText.Add('');
  AboutText.Add(StringOfChar('-',79));
  AboutText.Add('');
end;


end.
 