program DictionaryEditor;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

uses
  Forms,
  FieldList in 'FieldList.pas' {frmFieldList},
  DictRecord in 'DictRecord.pas',
  FieldDetails in 'FieldDetails.pas' {frmFieldDetails},
  DictionaryProc in 'DictionaryProc.pas',
  Progress in 'Progress.pas' {frmProgress},
  BTFiles in 'BTFiles.pas',
  SetFromXL in 'SetFromXL.pas' {frmSetFieldFromXL},
  Range in 'Range.pas' {frmRange};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFieldList, frmFieldList);
  Application.Run;
end.
