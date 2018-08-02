{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPDBUtil;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, DB, RPDefine, RPMemo
  {$IFNDEF VER100}{$IFNDEF VER110}{$IFNDEF VER120}, DBTables{$ENDIF}{$ENDIF}{$ENDIF};

type
  TDBMemoBuf = class(TMemoBuf)
  protected
    procedure SetMemoField(Value: TMemoField);
    procedure SetRTFMemoField(Value: TMemoField);
  public
    property Field: TMemoField write SetMemoField;
    property RTFField: TMemoField write SetRTFMemoField;
  end; { TDBMemoBuf }

  procedure GraphicFieldToBitmap(GraphicField: TBlobField;
                                 Bitmap: TBitmap);

implementation

  procedure TDBMemoBuf.SetMemoField(Value: TMemoField);

  var
    Stream: TMemoryStream;

  begin { SetMemoField }
    Stream := TMemoryStream.Create; { Create temporary stream }
    try
      Value.SaveToStream(Stream); { Save memo to stream }
      SetData(Stream.Memory^,Stream.Size); { Set memo buffer data to stream }
    finally
      Stream.Free; { Free up temporary stream }
    end; { try }
  end;  { SetMemoField }

  procedure TDBMemoBuf.SetRTFMemoField(Value: TMemoField);

  begin { SetRTFMemoField }
    ReadRTF := true;
    SetMemoField(Value);
  end;  { SetRTFMemoField }

  procedure GraphicFieldToBitmap(GraphicField: TBlobField;
                                 Bitmap: TBitmap);

  begin { GraphicFieldToBitmap }
    Bitmap.Assign(GraphicField);
  end;  { GraphicFieldToBitmap }

end.
