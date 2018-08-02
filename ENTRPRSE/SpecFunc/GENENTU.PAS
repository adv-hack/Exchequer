unit GenEnTU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  InHU, StdCtrls, TEditVal, Mask, Animate, ExtCtrls, SBSPanel, bkgroup,
  ComCtrls, ProgU, GlobVar, Untils, SFHeaderU;

type
  TTestCust = class(TInHForm)
    StartBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
  private
    { Private declarations }

    Procedure WMCustGetRec(Var Message  :  TMessage);  Message WM_CustGetRec;

  public
    { Public declarations }
    ProgBar  :  TSFProgressBar;
    AutoMode,
    Aborted  :  Boolean;

    procedure SetCompInfo;

    procedure WriteToLog(LM  :  String);

    procedure WriteToLogFmt(LM     :  String;
                            LMode  :  Byte);



  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  BtrvU2,
  ETStrU,
  ETMiscU,
  LocalVar,
  PathUtil,
  ReMain;



{$R *.DFM}

procedure TTestCust.FormCreate(Sender: TObject);
begin
  inherited;

  Aborted:=BOff;


  MDI_SetFormCoord(TForm(Self));
end;



Procedure TTestCust.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

      0
         :  Begin

            end;

      99 :  Aborted:=BOn;

    end; {Case..}

  end; {With..}

  Inherited;

end;


procedure TTestCust.SetCompInfo;
begin


end;


procedure TTestCust.OkCP1BtnClick(Sender: TObject);
begin
  If (Sender=OKCP1Btn) then
  Begin
  end;

  inherited;

end;


procedure TTestCust.WriteToLog(LM  :  String);

Begin
  With TMainForm(Owner) do
  Begin
    WriteToLogFmt(LM,0);

  end;

end;




procedure TTestCust.WriteToLogFmt(LM     :  String;
                                  LMode  :  Byte);

Begin
  With TMainForm(Owner) do
  Begin
    WriteToOutput(LM,(LMode<>0));

    Case LMode of
      1  :  SetOutputStyle(osNormal);
      2  :  SetOutputStyle(osSubHeader);
      3  :  SetOutputEffect(9,clBlue,[fsBold],taLeftJustify);
      4  :  SetOutputStyle(osWarning);
    end;
  end;

end;



end.
