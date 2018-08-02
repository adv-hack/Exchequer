unit ProgressF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmProgressInfo = class(TForm)
    lblStageDesc: TLabel;
    lblStageProgress: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  //------------------------------

  //
  TProgressDialog = Class(TObject)
  Private
    ProgressInfoF : TfrmProgressInfo;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure StartStage (Const StageDesc : ShortString);
    Procedure FinishStage;
    Procedure UpdateStageProgress (Const StageProgress : ShortString);
  End; // TProgressDialog

//------------------------------

Function ProgressDialog : TProgressDialog;

implementation

{$R *.dfm}

Var
  oProgressDialog : TProgressDialog;

//=========================================================================

Function ProgressDialog : TProgressDialog;
Begin // ProgressDialog
  If (Not Assigned(oProgressDialog)) Then
    oProgressDialog := TProgressDialog.Create;

  Result := oProgressDialog;
End; // ProgressDialog

//=========================================================================

Constructor TProgressDialog.Create;
Begin // Create
  Inherited Create;
  ProgressInfoF := TfrmProgressInfo.Create(NIL);
End; // Create

Destructor TProgressDialog.Destroy;
Begin // Destroy
  ProgressInfoF.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TProgressDialog.StartStage (Const StageDesc : ShortString);
Begin // StartStage
  ProgressInfoF.lblStageDesc.Caption := StageDesc;
  ProgressInfoF.lblStageProgress.Caption := '';
  ProgressInfoF.Visible := True;
  Application.ProcessMessages;

//Sleep(500);
End; // StartStage

//-------------------------------------------------------------------------

Procedure TProgressDialog.FinishStage;
Begin // FinishStage
  ProgressInfoF.Visible := False;
  Application.ProcessMessages;
End; // FinishStage

//-------------------------------------------------------------------------

Procedure TProgressDialog.UpdateStageProgress (Const StageProgress : ShortString);
Begin // UpdateStageProgress
  ProgressInfoF.lblStageProgress.Caption := StageProgress;
  Application.ProcessMessages;
//Sleep(50);
End; // UpdateStageProgress

//=========================================================================

Initialization
  oProgressDialog := NIL;
Finalization
  If Assigned(oProgressDialog) Then
    FreeAndNIL(oProgressDialog);
end.
