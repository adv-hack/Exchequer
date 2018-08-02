unit TestRead;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    StatusBar1: TStatusBar;
    lvPlugIns: TListView;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses oPlugLic;

procedure TForm1.FormActivate(Sender: TObject);
Var
  I, Res : LongInt;
begin
  OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName);
  If OpenDialog1.Execute Then
    With Memo1.Lines, TPlugInUtilityLicenceType.Create (True) Do
      Try
        Res := Open (OpenDialog1.FileName, True);
        If (Res = 0) Then Begin
          // Display Licence Details
          Add(Format('Licence Version: %d.%d', [MajorVersion, MinorVersion]));
          Add('Creation TimeStamp: ' + FormatDateTime ('HH:MM.SS DD/MM/YYYY', TimeStamp));
          Add('Checksum: ' + IntToStr(CheckSum));
          Add('');
          Add('Licencee: ' + Licencee);
          If Expired Then
            Add('Licence Expiry: *** EXPIRED ***')
          Else
            Add('Licence Expiry: ' + FormatDateTime ('HH:MM.SS DD/MM/YYYY', Expiry));
          Add('');
          Add('Licenced Plug-Ins: ' + IntToStr(PlugInCount));

          If (PlugInCount > 0) Then
            For I := 0 To Pred(PlugInCount) Do
              With PlugIn[I], lvPlugIns.Items.Add Do Begin
                Caption := piCode;
                SubItems.Add (piName);
                If (piExpiry = -1) Then
                  SubItems.Add ('*** EXPIRED ***')
                Else
                  SubItems.Add (FormatDateTime('DD/MM/YYYY', piExpiry));
                SubItems.Add (Format ('Full=%d,  30-Day=%d,  Users=%dx%d', [piFull, pi30Day, piUCount, piUCTotal]));
              End; { With lvPlugIns.Items.Add }
        End { If (Res = 0) }
        Else
          ShowMessage ('Open Licence returned an error ' + IntToStr(Res));
      Finally
        Free;
      End;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
end;

end.
