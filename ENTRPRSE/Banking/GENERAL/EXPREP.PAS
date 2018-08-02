unit ExpRep;

{ prutherford440 15:10 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmExportReport = class(TForm)
    Panel1: TPanel;
    ReportMemo: TMemo;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.DFM}





end.
