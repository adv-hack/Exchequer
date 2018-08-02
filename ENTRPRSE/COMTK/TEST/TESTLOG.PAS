unit TestLog;

{ prutherford440 09:55 04/12/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ComCtrls, Graphics, Forms, Classes, Controls;

type
  TRichLog = Class
   private
     FRichEdit,
     FDetails : TRichEdit;
     FLogFile : TFileStream;
     FAutoScroll : Boolean;
     FErrorCount : integer;
     FDetailsFileName : string;
     FLogFileOpen, FFirstWrite : Boolean;
     procedure DoReport(const s : string; Indent : integer; AStyle : TFontStyles;
                        AColor : TColor; DetailOnly : Boolean = False);
   protected
     procedure SetDetailsLog(const Value : string);
   public
     constructor Create(AParent : TComponent);
     destructor Destroy; override;
     procedure Report(const s : string; Indent : integer = 0);
     procedure ReportBold(const s : string; Indent : integer = 0);
     procedure ReportBoldU(const s : string; Indent : integer = 0);
     procedure ReportError(const s : string; Indent : integer = 0);
     procedure ReportDetailsOnly(const s : string; Indent : integer = 0);
     procedure ReportDetailsOnlyBold(const s : string; Indent : integer = 0);
     procedure Line;
     procedure DetailLine;
     procedure AddStrings(Strings : TStrings);
     procedure Scroll(Value : integer);
     function ShowErrorCount(const Msg : string) : string;
     procedure WriteDetailLog;
     property RichEdit : TRichEdit read FRichEdit write FRichEdit;
     property AutoScroll : Boolean read FAutoScroll write FAutoScroll;
     property ErrorCount : integer read FErrorCount write FErrorCount;
     property DetailsLog : string read FDetailsFileName write SetDetailsLog;

   end;


implementation

uses
  Windows, Messages, SysUtils;

constructor TRichLog.Create(AParent : TComponent);
begin
  Inherited Create;
  FRichEdit := nil;
  FDetails := nil;
  FDetails := TRichEdit.Create(AParent);
  FDetails.Parent := TWinControl(AParent);
  FDetails.Width := 553;
  FDetails.Font.Name := 'Courier New';
  FDetails.Font.Size := 10;
  FDetails.Visible := False;
  FAutoScroll := False;
  FErrorCount := 0;
  FLogFile := nil;
  FLogFileOpen := False;
  FFirstWrite := True;
end;

destructor TRichLog.Destroy;
begin
  WriteDetailLog; //To finish
  if Assigned(FDetails) then
  begin
    //FDetails.Lines.SaveToFile(FDetailsFileName);
    FDetails.Free;
  end;
  if Assigned(FLogFile) then
     FLogFile.Free;
  inherited Destroy;
end;


procedure TRichLog.DoReport(const s : string; Indent : integer; AStyle : TFontStyles;
                     AColor : TColor; DetailOnly : Boolean = False);
var
  Id : string;
  OldStyle : TFontStyles;
  OldColor : TColor;

  procedure DoRep(Ed : TRichEdit);
  begin
    if Assigned(Ed) then
    begin
      Id := '';
      if Indent > 0 then
        Id := StringOfChar(' ', Indent * 3);
      with Ed do
      begin
        OldStyle := SelAttributes.Style;
        OldColor := SelAttributes.Color;

        SelAttributes.Style := AStyle;
        SelAttributes.Color := AColor;

        Lines.Add(Id + s);
        Application.ProcessMessages;
        SelAttributes.Style := OldStyle;
        SelAttributes.Color := OldColor;
      end; //With
    end; //If Asssigned(Ed)
  end;{proc}

begin
  if not DetailOnly then
  begin
    DoRep(FRichEdit);
    if FAutoScroll then
      Scroll(SB_LINEDOWN);
  end;
  DoRep(FDetails);
end;

procedure TRichLog.Report(const s : string; Indent : integer = 0);
begin
  DoReport(s, Indent, [], clBlack);
end;

procedure TRichLog.ReportBold(const s : string; Indent : integer = 0);
begin
  DoReport(s, Indent, [fsBold], clBlack);
end;

procedure TRichLog.ReportBoldU(const s : string; Indent : integer = 0);
begin
  DoReport(s, Indent, [fsBold, fsUnderline], clBlack);
end;

procedure TRichLog.ReportError(const s : string; Indent : integer = 0);
begin
  inc(FErrorCount);
  DoReport(s, Indent, [fsBold], clRed);
end;

procedure TRichLog.Line;
begin
  DoReport(' ', 0, [], clBlack);
end;

procedure TRichLog.DetailLine;
begin
  DoReport(' ', 0, [], clBlack, True);
end;

procedure TRichLog.AddStrings(Strings : TStrings);
begin
  if Assigned(FRichEdit) then
    FRichEdit.Lines.AddStrings(Strings);
end;

procedure TRichLog.Scroll(Value : integer);
begin
  PostMessage(FRichEdit.Handle, EM_SCROLL, Value, 0);
end;

function TRichLog.ShowErrorCount(const Msg : string) : string;
begin
  if FErrorCount = 0 then
    Result := 'No errors or warnings'
  else
  if FErrorCount = 1 then
    Result := '1 error or warning'
  else
    Result := IntToStr(FErrorCount) + ' errors or warnings';
  ReportBold( Result + ' during ' + Msg);
  FErrorCount := 0;
  Line;
end;

procedure TRichLog.ReportDetailsOnly(const s : string; Indent : integer = 0);
begin
  DoReport(s, Indent, [], clBlack, True);
end;

procedure TRichLog.ReportDetailsOnlyBold(const s : string; Indent : integer = 0);
begin
  DoReport(s, Indent, [fsBold], clBlack, True);
end;

procedure TRichLog.SetDetailsLog(const Value : string);
var
  IORes : integer;
begin
  FDetailsFileName := Value;
  Try
    FLogFile := TFileStream.Create(Value, fmCreate or fmShareExclusive);
    FLogFileOpen := True;
  Except
    FLogFileOpen := False;
    Raise;
  End;
end;

procedure TRichLog.WriteDetailLog;
{Originally thought of storing all the details in a richedit then saving it
on closedown.  Problem is that details might get too big.  Instead, create
a file stream at startup and write details to it at intervals then clear details edit}
const
  BytesToLose = 141;
var
  i : integer;
  TempStream : TMemoryStream;
begin
  if FLogFileOpen then
  begin
    TempStream := TMemoryStream.Create;
    Try
      FDetails.Lines.SaveToStream(TempStream);
      if FFirstWrite then
      begin
        FFirstWrite := False;
        FLogFile.Seek(0, soFromEnd);
        TempStream.Seek(0, soFromBeginning);
        FLogFile.CopyFrom(TempStream, TempStream.Size);
      end
      else
      begin //Need to delete last chars from log + rtf header from tempstream
        FLogFile.Seek(-5, soFromEnd);
        TempStream.Seek(BytesToLose, soFromBeginning);
        FLogFile.CopyFrom(TempStream, TempStream.Size - BytesToLose);
      end;
      FDetails.Lines.Clear;
    Finally
      TempStream.Free;
    End;
  end;
end;


end.
