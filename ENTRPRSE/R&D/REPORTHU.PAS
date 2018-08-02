unit ReportHU;


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,RpDevice,ReportU;


type
   tMemoDDRec  =  Class(TObject)
                    Public
                      DDKey  :  Str255;

                      DDMode :  Byte; {0 = Invoice, default}
                  end;


TMemoReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       Started  :  Boolean;
                       RepMemo  :  TStringList;

                       Function GetReportInput  :  Boolean; Virtual;

                     public
                       StatusTitle      :  Str255;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddMemoRep2ThreadMode(PDevRec    :  TSBSPrintSetupInfo;
                                SMemo      :  TStringList;
                                STit       :  Str255;
                                AOwner     :  TObject;
                                RMode      :  Byte);

Procedure AddMemoRep2Thread(PDevRec    :  TSBSPrintSetupInfo;
                            SMemo      :  TStringList;
                            STit       :  Str255;
                            AOwner     :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  RpDefine,
  TEditVal,
  ETDateU,
  ETStrU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,
  SysU1,
  SysU2,
  BTSupU1,
  ExThrd2U;




{ ========== TMemoReport methods =========== }

Constructor TMemoReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  RepMemo:=TStringList.Create;

  Started:=BOff;

  NoDeviceP:=BOn;

  HideRecCount:=BOn;
end;


Destructor TMemoReport.Destroy;


Begin

  RepMemo.Free;

  Inherited Destroy;
end;





Procedure TMemoReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of
      0  :  SetTab (MarginLeft, pjLeft, PageWidth, 4, 0, 0);

      1  :  Begin {Password list}
              SetTab (MarginLeft, pjRight, 12, 4, 0, 0);
              SetTab (NA, pjLeft, PageWidth-12, 4, 0, 0);
            end;
    end; {Case..}

  end; {With..}
end;






Procedure TMemoReport.RepPrintPageHeader;

Var
  n          :  Integer;
  LineText   :  Str255;
  EfChr      :  Char;

  DPtr       :  tMemoDDRec;



Begin
  With RepFiler1 do
  Begin
    RepSetTabs;


    If (CurrentPage=1) then
      DefLine(-2,1,PageWidth-MarginRight-1,-0.5);

    If (Not Started) then
    Begin
      Started:=BOn;


      With RepMemo do
        For n:=0 to Pred(Count) do
        Begin
          Case ReportMode of
            1   : Begin
                    LineText:=RepMemo[n];

                    EfChr:=LineText[1];

                    If (EfChr In [#0..#2]) then
                    Begin
                      Case EfChr of
                        #0  :  DefFont(0,[fsUnderline]);
                        #1  :  DefFont(1,[fsBold]);
                        #2  :  DefFont(5,[fsBold,fsUnderline]);
                      else
                        DefFont(Ord(EfChr),[fsBold,fsUnderline]);
                      end; {Case..}

                      RepMemo[n]:=Copy(LineText,2,Length(LineText)-1);
                    end;
                  end;

            else  DefFont(0,[fsBold]);

          end; {Case..}

          DPtr:=tMemoDDRec(Objects[n]);

          If (Assigned(DPtr)) then
          With DPtr do
          Begin
            Case DDMode of
              0  :  SendRepDrillDown(1,1,1,DDKey,InvF,InvOurRefK,0);
              1  :  SendRepDrillDown(1,1,1,DDKey,CustF,CustCodeK,0);
              9  :  SendRepDrillDown(1,1,1,DDKey,JDetlF,JDStkK,3);
            end; {Case..}

            DPtr.Free;
          end;

          SendLine(#9+RepMemo[n]);

          DefFont(0,[]);

          If (LinesLeft<5) then
            ThrowNewPage(5);

        end;


    end;

  end; {With..}
end; {Proc..}





Procedure TMemoReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);


end;



{ ======================= Customer Line ======================= }


Procedure TMemoReport.PrintReportLine;


Begin


end;






{ ======================= Customer Include ======================= }


Function TMemoReport.IncludeRecord  :  Boolean;


Begin
  Result:=BOff;

end; {Func..}






Function TMemoReport.GetReportInput  :  Boolean;


Begin
  Begin

    Case ReportMode of
      1  :  RFont.Size:=10;
      else  RFont.Size:=8;
    end; {case..}

    ROrient:=RPDefine.PoPortrait;
    RFnum:=SysF;
    RepKey:=NdxWeight;

    ThTitle:='Status Report';

    RepTitle:=StatusTitle;


    PageTitle:=RepTitle;
  end; {With..}

  Result:=BOn;
end;



Procedure TMemoReport.Process;


Begin


  Inherited Process;



end;


Procedure TMemoReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddMemoRep2ThreadMode(PDevRec    :  TSBSPrintSetupInfo;
                                SMemo      :  TStringList;
                                STit       :  Str255;
                                AOwner     :  TObject;
                                RMode      :  Byte);


Var
  EntTest  :  ^TMemoReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin

        If (Assigned(SMemo)) then
          RepMemo.Assign(SMemo);

        ReportMode:=RMode;

        StatusTitle:=STit;

        If (ReportMode=0) then
        Begin
          RDevRec:=PDevRec;
          {$IFNDEF SCHEDULER}
          RDevRec.Preview:=BOn;
          {$ENDIF}
        end
        else
          NoDeviceP:=BOff;



        If (Create_BackThread) and (Start) then
        Begin
          With BackThread do
            AddTask(EntTest,ThTitle);
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;


Procedure AddMemoRep2Thread(PDevRec    :  TSBSPrintSetupInfo;
                            SMemo      :  TStringList;
                            STit       :  Str255;
                            AOwner     :  TObject);



Begin
  AddMemoRep2ThreadMode(PDevRec,SMemo,STit,AOwner,0);

end;


Initialization



Finalization

end.



