unit CmnEarnie32; //common earnie 32 routines (for tp and delphi)

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Const
  Hours = 'H';
  Adjustments = 'A';
  Salary = 'S';
  PSP = 'P';
  
type
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


   Procedure SetValue(var ClckRecord : ClockInType);

implementation

Procedure SetValue(var ClckRecord : ClockInType);
begin

 with ClckRecord do
 case TypeOfEntry of

  Hours :       begin
                  str(NoHour*10:10,value[1]);  {hours * 10}
                  str(Rate:10,Value[2]);{existing rate Number}
                  Str(Factor:10,Value[3]);{factor number}

                end;

  Adjustments : begin
                  str(Payment/Deduction:10,value[1]);
                  str(Payment/AmntAgstDec:10,value[2]);
                  Value[3] := '';

                end;

  Salary      : begin
                  (*
                  Value[1] :=
                  Value[2] :=
                  Value[3] :=
                  *)
                end;

  PSP         : begin
                  (*
                  Value[1] :=
                  Value[2] :=
                  Value[3] :=

                end;

  SMP         : begin
                  (*
                  Value[1] :=
                  Value[2] :=
                  Value[3] :=
                  *)
                end;

 end;

end;

end.
 