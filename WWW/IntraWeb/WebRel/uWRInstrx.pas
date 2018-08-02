unit uWRInstrx;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWLayoutMgr, IWTemplateProcessorHTML,
  Classes, Controls, IWControl, IWCompButton;

type
  TfrmInstructions = class(TIWAppForm)
    bnInstrx: TIWButton;
    IWTemplateProcessor: TIWTemplateProcessorHTML;
    procedure bnInstrxClick(Sender: TObject);
  end;

implementation

{$R *.dfm}

uses uWRServer;

//******************************************************************************

procedure TfrmInstructions.bnInstrxClick(Sender: TObject);
begin
  Release;
end;

//******************************************************************************

end.