unit comdll1;
{$WARN SYMBOL_PLATFORM OFF}
interface

uses
  ActiveX, IntForm, Forms, Windows, Classes, SysUtils;

procedure InitializeBrowser(AHandle : THandle ); export;
procedure SetComObject(Value : IDispatch); export;
procedure FreeBrowser; export;
procedure UpdateBrowser; export;
procedure ShowModalBrowser(AHandle : THandle; ADispatch : IDispatch); export;
procedure ShowBrowser(AHandle : THandle; ADispatch : IDispatch); export;

var
  TheForm : TfrmToolkitInterface;
  OldHandle : HWnd;

implementation

procedure InitializeBrowser(AHandle : THandle );
begin
  OldHandle := Application.Handle;
  Application.Handle := AHandle;
end;

procedure SetComObject(Value : IDispatch);
begin
  if not Assigned(TheForm) then
    TheForm := TFrmToolkitInterface.Create(Application);
  if Assigned(TheForm) then
    TheForm.COMInterface := Value;
end;

procedure UpdateBrowser;
begin
  if Assigned(TheForm) then
  begin
    TheForm.UpdateDetails(True);
  end;
end;

procedure FreeBrowser;
begin
  if Assigned(TheForm) then
    TheForm.Free;
end;

procedure ShowModalBrowser(AHandle : THandle; ADispatch : IDispatch);
const
  sJW = 'c:\James.Waygood';
var
  oFile : TStringList;
  sOutputPath, sFilename : string;
  i : integer;
begin
  OldHandle := Application.Handle;
  Application.Handle := AHandle;

  if not Assigned(TheForm) then
    TheForm := TFrmToolkitInterface.Create(Application);

  if Assigned(TheForm) then
  begin
   Try
    TheForm.COMInterface := ADispatch;
    TheForm.UpdateDetails(False);
    TheForm.Left := 0;
    TheForm.Top := 0;

    //PR: 23/10/2009 Added functionality to allow JW to print direct to file for testing purposes.
    if FileExists(sJW) then
    begin
      oFile := TStringList.Create;
      Try
        oFile.LoadFromFile(sJW);
        if oFile.Count = 1 then
          sOutputPath := IncludeTrailingBackslash(oFile[0])
        else
          sOutputPath := 'c:\';
        sFilename := TheForm.Caption;
        i := Pos(' - ', sFilename);
        if i > 0 then
          sFilename := Copy(sFilename, 1, i - 1);
        sFilename := sFilename + '.txt';
//        TheForm.ShowParentGuid := True;
        TheForm.UpdateDetails(True);
        TheForm.SaveLog(sOutputPath + sFilename);
        TheForm.Close;
      Finally
        oFile.Free;
      End;
    end
    else
      TheForm.ShowModal;
   Finally
    TheForm.Free;
    TheForm := nil;
   End;
  end;
end;

procedure ShowBrowser(AHandle : THandle; ADispatch : IDispatch);
begin
  OldHandle := Application.Handle;
  Application.Handle := AHandle;

  if not Assigned(TheForm) then
    TheForm := TFrmToolkitInterface.Create(Application);

  if Assigned(TheForm) then
  begin
    TheForm.COMInterface := ADispatch;
    TheForm.Left := 0;
    TheForm.Top := 0;
    TheForm.UpdateDetails(True);
  end;
end;


Initialization
  {what}
  TheForm := nil;
  OldHandle := Application.Handle;

finalization
   Application.Handle := OldHandle;

end.
