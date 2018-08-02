unit INVLISPR;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, GlobVar, VarConst,
     BtrvU2;

type
  RtRecType = record
                Default  :  Byte;

                PossSet  :  Set of Byte;
              end;



Function GetCust(AOWner :  TComponent;
                 Want   :  Str20;
             Var Found  :  Str20;
                 IsCust :  Boolean;
                 Mode   :  Integer)  :  Boolean;

Function GetStock(AOWner :  TComponent;
                  Want   :  Str20;
              Var Found  :  Str20;
                  Mode   :  Integer)  :  Boolean;

Function GetJobMisc(AOWner :  TComponent;
                    Want   :  Str20;
                Var Found  :  Str20;
                    JAMode,
                    Mode   :  Integer)  :  Boolean;

    Function GetRtRelate(Many2One  :  Boolean;
                         TL,CatL   :  Byte)  :  RtRecType;

Function GetNom(AOWner :  TComponent;
                 Want   :  Str20;
             Var Found  :  LongInt;
                 Mode   :  Integer)  :  Boolean;




implementation

Uses BtSupU1;

Function GetCust(AOWner :  TComponent;
                 Want   :  Str20;
             Var Found  :  Str20;
                 IsCust :  Boolean;
                 Mode   :  Integer)  :  Boolean;
Begin { GetCust }
  Result := Global_GetMainRec (CustF, Want);
End; { GetCust }

Function GetNom(AOWner :  TComponent;
                 Want   :  Str20;
             Var Found  :  LongInt;
                 Mode   :  Integer)  :  Boolean;
Begin { GetCust }
  Result := Global_GetMainRec (NomF, Want);
End; { GetCust }


Function GetStock(AOWner :  TComponent;
                  Want   :  Str20;
              Var Found  :  Str20;
                  Mode   :  Integer)  :  Boolean;
Begin { GetStock }
  Result := Global_GetMainRec (StockF, Want);
End; { GetStock }

Function GetJobMisc(AOWner :  TComponent;
                    Want   :  Str20;
                Var Found  :  Str20;
                    JAMode,
                    Mode   :  Integer)  :  Boolean;
var
  KeyS : Str255;
Begin { GetJobMisc }
  KeyS := JARCode + JAACode + Want;
  Result := Global_GetMainRec (JMiscF, KeyS);
End; { GetJobMisc } 

Function GetRtRelate(Many2One  :  Boolean;
                              TL,CatL   :  Byte)  :  RtRecType;


Begin
  FillChar(Result,SizeOf(Result),0);

  With Result do
  Case Many2One of

    BOff  :  Begin
               Case TL of
                 1  :  Begin  {Revenue = Revenue,Receipts,Sales Ret,Purch Ret,Deductions Sales Apps, Purc Apps}
                         PossSet:=[1,7,9,10,14,15,16,17];
                         Default:=2;
                       end;
                 2  :  Begin  {Overheads = Disbursments, Non Rec Disb, Overheads,WIP, OverHeads 2}
                         PossSet:=[3,4,6,8,13];
                         Default:=8;
                       end;
                 3  :  Begin  {Materials= Disbursments, Non Rec Disb,,Materials, WIP, Materials 2}
                         PossSet:=[3,4,5,8,12];
                         Default:=6;
                       end;
                 else  Begin  {Labour = Disbursments, Non Rec Disb,Labour , WIP, Sub contrcat labour}
                         PossSet:=[2,3,4,8,11];
                         Default:=2;
                       end;

               end; {Case..}

             end;

    BOn  :  Begin
               Case CatL of
                 1  :  Begin  {Revenue = Revenue}
                         PossSet:=[1];
                         Default:=1;
                       end;
                 2,11
                    :  Begin  {Labour= Labour}
                         PossSet:=[4];
                         Default:=4;
                       end;
                 3  :  Begin  {Disbursments = Overheads,Materials,Labour}
                         PossSet:=[2,3,4];
                         Default:=3;
                       end;
                 4  :  Begin  {Non Rec Disb= Overheads,Materials,Labour}
                         PossSet:=[2,3,4];
                         Default:=2;
                       end;
                 5,12
                    :  Begin  {Materials=Materials}
                         PossSet:=[3];
                         Default:=3;
                       end;
                 6,13
                    :  Begin  {Overheads=Overheads}
                         PossSet:=[2];
                         Default:=2;
                       end;
                 7  :  Begin  {Receipts=Revenue}
                         PossSet:=[1];
                         Default:=1;
                       end;

                 8  :  Begin  {WIP=Overheads, Materials,Labour}
                         PossSet:=[2,3,4];
                         Default:=3;
                       end;

                 9  :  Begin  {Sales Ret=Revenue}
                         PossSet:=[1];
                         Default:=1;
                       end;

                 else  Begin  {Purch Ret, Deductions, Apps =Revenue}
                         PossSet:=[1];
                         Default:=1;
                       end;

               end; {Case..}

             end;
  end; {Case..}
end;


end.
