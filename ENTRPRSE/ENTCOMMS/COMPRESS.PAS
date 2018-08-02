unit Compress;

{ prutherford440 10:08 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CommsInt, AbArcTyp, AbZBrows, AbZipper, AbZipKit, AbBase, AbBrowse, AbUtils;

type
  TfrmPKZIP = class(TForm)
    AbZipKit1: TAbZipKit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


{Function ECBUILDZIP(Const Info : CompressInfoType) : SmallInt; Export; StdCall;}
Function ECZIPGETFILELIST(sFileName : shortstring; var slFiles : TStringList) : smallint; Export; StdCall;
Function ECEXTRACTFILES(sFileName, sMask, sDir : shortstring) : smallint; Export; StdCall;

implementation

{$R *.DFM}

{ 0=OK, 1=no files to compress, 2=failed to delete existing .ZIP file}
(*
Function ecBuildZip (Const Info : CompressInfoType) : SmallInt;
Var
  frmPKZIP : TfrmPKZIP;
  I : SmallInt;
Begin { ecBuildZip }
  Result := 0;

  With Info Do Begin
    If (coFileList.Count > 0) Then Begin
      If coOverwriteExisting And FileExists(coZipFile) Then Begin
        If Not SysUtils.DeleteFile (coZipFile) Then Begin
          { Failed to delete existing .ZIP file }
          Result := 2;
        End; { If }
      End; { If }

      If (Result = 0) Then Begin
        frmPKZIP := TfrmPKZIP.Create(Application);
        Try
          With frmPKZIP.AbZipKit1 Do Begin
            // HM 01/11/01: Added as Abbrevia 3.0 crashes when zipping to EDZ
            //              as it can't determine the compression method to use
            ForceType := True;
            ArchiveType := atZip;

            { Set Destination .ZIP file }
            FileName := coZipFile;

            { Set miscellaneous options }
            DOSMode := coDOSPaths;
            StoreOptions := [];
            If coRecurse Then StoreOptions := StoreOptions + [soRecurse];
            If coRemoveDots Then StoreOptions := StoreOptions + [soRemoveDots];
            If coStripDrive Then StoreOptions := StoreOptions + [soStripDrive];
            If coStripPath Then StoreOptions := StoreOptions + [soStripPath];

            { Add files into compression list }
            For I := 0 To Pred(coFileList.Count) Do Begin
              { Check file exists }
              If FileExists (coFileList[I]) Then Begin
                AddFiles (coFileList[I], 0);
              End; { If }
            End; { For }

            Save;
          End; { With }
        Finally
          frmPKZIP.Free;
        End;
      End; { If }
    End { If }
    Else Begin
      { No files to compress }
      Result := 1;
    End; { Else }
  End; { With Info }
End; { ecBuildZip }
*)
Function ecExtractfiles(sFileName, sMask, sDir : shortstring) : smallint;
Var
  frmUnzip : TfrmPKZIP;
begin
  try
    frmUnzip := TfrmPKZIP.Create(Application);

    with frmUnzip.AbZipKit1 do begin
      Filename := sFileName;
      BaseDirectory := sDir;
      ExtractFiles(sMask);
    end;{with}

  finally
    frmUnzip.Free;
  end;{try}
  Result := 0;
end;

Function ecZipGetFileList(sFileName : shortstring; var slFiles : TStringList) : smallint;
Var
  frmUnzip : TfrmPKZIP;
  iPos : integer;
begin
  try
    frmUnzip := TfrmPKZIP.Create(Application);

    with frmUnzip.AbZipKit1 do begin
      Filename := sFileName;
      For iPos := 0 to Count - 1 do begin
        slFiles.Add(Items[iPos].Filename);
      end;{for}
    end;{with}

  finally
    frmUnzip.Free;
  end;{try}
  Result := 0;
end;

end.
