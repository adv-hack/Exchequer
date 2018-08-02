unit Test;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleServer, SpeechLib_TLB, StdCtrls, Activex ;

type
  TForm1 = class(TForm)
    edtText: TEdit;
    btnSpeak: TButton;
    SpVoice1: TSpVoice;
    edtOutput: TEdit;
    SpSharedRecoContext1: TSpSharedRecoContext;
    procedure btnSpeakClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpSharedRecoContext1Recognition(Sender: TObject;
      StreamNumber: Integer; StreamPosition: OleVariant;
      RecognitionType: TOleEnum; var Result: OleVariant);
  private
    { Private declarations }
    SPRGrammer: ISpeechRecoGrammar;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnSpeakClick(Sender: TObject);
begin
  SpVoice1.Speak(edtText.Text, SVSFDefault);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SpSharedRecoContext1.EventInterests := SREAllEvents;
  SPRGrammer := SpSharedRecoContext1.CreateGrammar(0);
  SPRGrammer.DictationSetState(SGDSActive);
end;

procedure TForm1.SpSharedRecoContext1Recognition(Sender: TObject;
  StreamNumber: Integer; StreamPosition: OleVariant;
  RecognitionType: TOleEnum; var Result: OleVariant);
var
  SRResult: ISpeechRecoResult;
begin
  SRResult := IDispatch(Result) as ISpeechRecoResult;
  edtOutput.Text := SRResult.PhraseInfo.GetText(0,-1,True);
end;

end.
