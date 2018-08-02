unit GLTemplateF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, ComCtrls, TEditVal;

type
  TfrmSelectGLTemplate = class(TSetupTemplate)
    lstGLTemplates: TListBox;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    LocPosData  : Array [1..1] Of LongInt;
  public
    { Public declarations }
  end;


function SelectGLTemplate (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses Brand, CompUtil;

Const
  posScrlHOfs   = 1;

  // GL Template descriptions cross referenced to the Id Code using within the setup
  sTemplates : Array[0..13, 1..2] Of ShortString = (('A', 'Accountancy'),
                                                    ('B', 'Agriculture'),
                                                    ('C', 'Building/Construction'),
                                                    ('D', 'Charity'),
                                                    ('E', 'Garage'),
                                                    ('F', 'General'),
                                                    ('G', 'Hotels'),
                                                    ('H', 'SoleTrader/Partnership'),
                                                    ('I', 'Legal'),
                                                    ('J', 'Medical'),
                                                    ('K', 'Service'),
                                                    ('L', 'Transport'),
                                                    ('M', 'Wholesale/Distribution'),
                                                    ('N', 'Accounts Production (Limited Company - ELTD)'));




//=========================================================================

function SelectGLTemplate (var DLLParams: ParamRec): LongBool;
var
  frmSelectGLTemplate: TfrmSelectGLTemplate;
  DlgPN, GLType, WiseStr : String;
  oRadio                 : TRadioButton;
  I                      : SmallInt;
Begin // SelectGLTemplate
  Result := False;

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  // Get Installation Source directory for link to help & Lib\
  GetVariable(DLLParams, 'INST', WiseStr);
  Application.HelpFile := IncludeTrailingPathDelimiter(WiseStr) + 'SETUP.HLP';

  frmSelectGLTemplate := TfrmSelectGLTemplate.Create(Application);
  Try
    With frmSelectGLTemplate Do
    Begin
      // Load in the pre-existing value
      GetVariable(DLLParams,'V_GLTEMPLATE',GLType);

      // Load the list of templates and select the pre-existing value
      frmSelectGLTemplate.lstGLTemplates.Clear;
      For I := Low(sTemplates) To High(sTemplates) Do
      Begin
        frmSelectGLTemplate.lstGLTemplates.Items.Add (sTemplates[I, 2]);
        If (sTemplates[I, 1] = GLType) Then frmSelectGLTemplate.lstGLTemplates.ItemIndex := I;
      End; // For I

      If (frmSelectGLTemplate.lstGLTemplates.ItemIndex = -1) Then
        frmSelectGLTemplate.lstGLTemplates.ItemIndex := 0;

      ShowModal;

      Case ExitCode Of
        'B' : Begin { Back }
                { New Method - 3 character Id for each Dialog }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));
              End;
        'N' : Begin { Next }
                // Lookup the selected description in the list to get the code - note they may
                // not be in the same order as the array
                WiseStr := frmSelectGLTemplate.lstGLTemplates.Items[frmSelectGLTemplate.lstGLTemplates.ItemIndex];
                For I := Low(sTemplates) To High(sTemplates) Do
                Begin
                  If (sTemplates[I, 2] = WiseStr) Then
                  Begin
                    SetVariable(DLLParams,'V_GLTEMPLATE',sTemplates[I, 1]);
                    SetVariable(DLLParams,'V_GLTEMPLATENAME',WiseStr);
                    Break;
                  End; // If (sTemplates[I, 2] = frmSelectGLTemplate.lstGLTemplates.Text)
                End; // For I

                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
              End;
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; // With frmSelectGLTemplate
  Finally
    frmSelectGLTemplate.Free;
  End;
End; // SelectGLTemplate

//=========================================================================

procedure TfrmSelectGLTemplate.FormCreate(Sender: TObject);
begin
  inherited;

  { Generate postion data for dynamic resizing }
  LocPosData[posScrlHOfs] := Self.Height - lstGLTemplates.Height;
end;

//-------------------------------------------------------------------------

procedure TfrmSelectGLTemplate.FormResize(Sender: TObject);
begin
  inherited;

  { Generate postion data for dynamic resizing }
  lstGLTemplates.Height := Self.Height - LocPosData[posScrlHOfs];
end;

//-------------------------------------------------------------------------


end.

