unit FDConvrt;

interface

uses
  AdFaxCvt;

function ConvertFCPToAPF(FileName        : string;
                         PageNumber      : Integer;
                         PageCount       : Integer;
                   const Sender          : string;
                   const Recipient       : string;
                   const PageTitle       : string;
                   const StationID       : string;
                         OnConvertStatus : TFaxStatusEvent) : Boolean;
  {-Converts an FCP file created by TFaxDesigner to an APF file. The APF file
    will have the same name as the FCP file but with extension 'APF'. Returns
    True if successful.

    PageNumber, PageCount, Sender, Recipient, PageTitle, and StationID will be
    substituted for replacement tags $N, $P, $F, $R, $S, and $I if they are
    present within any of the FCP file's text fields.

    If it is desired to display the progress of the conversion operation, pass
    in a TFaxStatusEvent event handler as the OnConvertStatus parameter. This
    will be called regularly during the conversion process.}

implementation

uses Classes, Graphics, Forms, Dialogs, SysUtils, FaxField;

function ConvertFCPToAPF(FileName        : string;
                         PageNumber      : Integer;
                         PageCount       : Integer;
                   const Sender          : string;
                   const Recipient       : string;
                   const PageTitle       : string;
                   const StationID       : string;
                         OnConvertStatus : TFaxStatusEvent) : Boolean;
  {-Converts an FCP file created by TFaxDesigner to an APF file. The APF file
    will have the same name as the FCP file but with extension 'APF'. Returns
    True if successful.

    PageNumber, PageCount, Sender, Recipient, PageTitle, and StationID will be
    substituted for replacement tags $N, $P, $F, $R, $S, and $I if they are
    present within any of the FCP file's text fields.

    If it is desired to display the progress of the conversion operation, pass
    in a TFaxStatusEvent event handler as the OnConvertStatus parameter. This
    will be called regularly during the conversion process.}
var
  Posn         : Integer;
  Form         : TForm;
  FaxDesigner  : TFaxDesigner;
  Stream       : TFileStream;
  Bitmap       : TBitmap;
  FaxConverter : TApdFaxConverter;
begin
  Result := False;
  try
    Form   := TForm.Create(nil);  {Create a form to be the FaxDesigner's parent}
    Bitmap := TBitmap.Create;
    try
      {Form needs to be "visible", but we don't want the user to actually see it}
      Form.Height := 0;
      Form.Width  := 0;
      Form.Left   := -200;

      FaxDesigner  := TFaxDesigner.Create(nil);
      try
        FaxDesigner.Parent := Form;
        Form.Show;
        Stream := TFileStream.Create(FileName, fmOpenRead or fmShareExclusive);
        try
          FaxDesigner.Read(Stream);
        finally
          Stream.Free;
        end;

        Posn := Pos('.', FileName);
        if Posn > 0 then
          Delete(FileName, Posn, Length(FileName) - Posn + 1);

        with FaxDesigner do begin
          {Set FaxPanel properties for substitution of replacement tags}
          FaxPanel.PageCount  := PageCount;
          FaxPanel.PageNumber := PageNumber;
          FaxPanel.Sender     := Sender;
          FaxPanel.Recipient  := Recipient;
          FaxPanel.PageTitle  := PageTitle;
          FaxPanel.StationID  := StationID;

          Bitmap.Width  := FaxPanel.DrawWidth;
          Bitmap.Height := FaxPanel.DrawHeight;
          FaxPanel.Draw(Bitmap.Canvas);
        end;
      finally
        FaxDesigner.Free;
      end;

      FaxConverter := TApdFaxConverter.Create(nil);
      try
        with FaxConverter do begin
          LeftMargin := 20;
          Options    := [coDoubleWidth, coYield];
          OnStatus   := OnConvertStatus;
          FaxConverter.OutFileName := FileName + '.apf';
          FaxConverter.ConvertBitmapToFile(Bitmap);
        end;
      finally
        FaxConverter.Free;
      end;

      Result := True;
    finally
      Bitmap.Free;
      Form.Free;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;  { ConvertFCPToAPF }

end.
