
Const
  ClockInF  =     NoExFiles+1; {From Ex.Files}

  ClNofKeys =     1;

  ECodeRateK=     0;

  ClNofSegs =     2;


  {Entry Type Constants}
  Hours = 'H';
  Adjustments = 'A';
  Salary = 'S';
  PSP = 'P';
  SMP = 'M';


Type
    { ================ Temp.File for Employee's code Index  ================ }



    ClockInType  = Record
                      EmplCode      :  String[10]; {Employee Code}
                      Rate          :  Integer;    {Rate}
                      NoHour        :  Real;       {hundreds of hours }
                      AccountGroup  :  string[25];
                      AnalysisString:  String[100];
                      Period        :  String[2];
                      TypeOfEntry   :  Char;
                      Factor        :  real;
                      Payment       :  Real;
                      Deduction     :  Real;
                      AmntAgstDec   :  Real;

                      Value         :  array[1..3] of string;


                     {TSHNo     :  String[10];
                      StockCode :  String[10];}
                  end;

    ClockIn_FileDef   =   Record
                             RecLen,
                             PageSize,
                             NumIndex  :  SmallInt;
                             NotUsed   :  LongInt;
                             Variable  :  SmallInt;
                             Reserved  :  array[1..4] of Char;
                             KeyBuff   :  array[1..ClNofSegs] of KeySpec;
                             AltColt   :  AltColtSeq;
                           end;

{---------------------------------------------------------}

