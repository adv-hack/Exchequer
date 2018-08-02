unit TxtExport;

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  ComCtrls, ExtCtrls,eFuncInt,classes,contnrs,sysutils;

Const
  RecordInitialise = 0;
  LogFileInitialise = 1;
  OutputFileInitialise = 2;
  ToolKitInitialise = 3;
  SaveFileError = 4;


type
  //Function  GetTransRecord(Const SearchMode : SmallInt;LockRec : WordBool;var rec :TBatchTHRec;var invLines : TBatchLinesRec) : Boolean;

  TExportLine = Class(TStringList)
  public
    function AddItem(s : String;len : integer) : integer;overload;
    Function AddItem(S : String) : integer;overload;
  end;

  TExportError = procedure(sender : TObject;errorCode : integer) of object;

  TExport = class(TObject)
    fExportBuffer : TstringList;
    fFilesReady   : Boolean;
    fExportFile   : String;
    fOnError : TExportError;
    fPrintHeader : Boolean;
    fHeader : TstringList;
    fSorted : Boolean;
    fCSV : Boolean;
  protected
     procedure AddHeaderToBuffer; VIrtual;
     procedure SetSorted(value : Boolean);
  public
    Constructor Create;
    Destructor  Destroy; override;
    Procedure AddLine(Line : TExportLine);
    Procedure OutPutRecords; virtual;
    Property ExportFile : string read fExportFile write fExportFile;
    Property ExportBuffer: TStringList read fExportBuffer;
    Property Header : TStringList read fHeader write fHeader;
    Property PrintHeader : Boolean read fPrintHeader write fPrintHeader;
    Property CSV : Boolean read fCSv write fCSv default false;

    //event
    Property Sorted : Boolean read fSorted write SetSorted;
    Property OnError : TExportError read fOnError Write fOnError;
  end;

implementation


   function TExportLine.AddItem(s : String;len : integer) : integer;
   begin
     s := s + StringOfChar(' ',len - length(s));
     result := inherited add(s);
   end;

   Function TExportLine.AddItem(S : String) : integer;
   begin
     result := inherited add(s)
   end;

   Constructor TExport.Create;
   begin
     fExportBuffer := TStringList.create;
     fHeader := TStringList.create;
   end;

   Destructor TExport.Destroy;
   begin
     inherited;
     fExportBuffer.free;
     fHeader.free;
   end;

   procedure TExport.SetSorted(value : Boolean);
   begin
     fExportBuffer.Sorted := value;
   end;

   procedure TExport.AddLine(Line : TExportLine);
   var
     I : integer;
   begin
     //fExportRecord.add(s);
     if fCSV = true then  //csv file format
     begin
       line.CommaText := line.Text;
       ExportBuffer.Add(line.commatext);
     end
     else
     begin
       ExportBuffer.Add(line.text);
     end
   end;

   procedure TExport.AddHeaderToBuffer;
   var
    i : integer;
   begin
     if (fPrintHeader = true) and (fHeader.Count > 0) then
     begin
       //loop through the header and insert it into the buffer
       for i := 0 to fHeader.count-1 do
         fExportBuffer.Insert(i,fHeader[i]);
     end;
   end;

   Procedure TExport.OutPutRecords;
   begin
     try
       AddHeaderToBuffer;
       exportBuffer.SaveToFile(exportFile);
     except
       if assigned(fOnError) then fOnError(self,SaveFileError);
     end
   end;



end.
