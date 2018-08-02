unit JobTestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, enterprise04_tlb, StdCtrls;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
  public
    { Public declarations }
  protected
      procedure RunTest; override;
      procedure ChangeToolkitSettings; override;
  end;
var
  frmTestTemplate1: TfrmTestTemplate1;

implementation
uses
 strUtils;
{$R *.dfm}

procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin
  case StrToInt(FExtraParam) of
    30006 : oToolkit.Configuration.DefaultNominalCode := 2;
  end;
end;

procedure TfrmTestTemplate1.RunTest;
var
  jobItem : IJob;
  searchKey : shortstring;
  funcRes : longint;
  jType : IJobType2;
begin
   with oToolkit.JobCosting.Job do
   begin
      Index := acIdxCode;
      searchKey := BuildCodeIndex('BRID - PH1');
      funcRes := GetEqual(searchKey);

      {Ignored Errors: 30012}

       if(funcRes = 0) or (StrToInt(FExtraParam) = 30003) or (StrToInt(
         FExtraParam) = 30006) then
       begin
        if(StrToInt(FExtraParam) = 30003) or (StrToInt(FExtraParam) = 30006)
          or (StrToInt(FExtraParam) = 5) then
         jobItem := Add
        else
         jobItem := Update;

          if(Assigned(jobItem)) then
          begin
               with jobItem do
               begin
                  case StrToInt(FExtraParam) of
                         5 : jrCode := 'TAI-IN1';
                     30001 : jrType := 2;
                     30002 : jrParent := 'NotAParent';
                     30006 : begin
                               jrCode := 'Job123456';
                               jrAcCode := 'ABAP01';
                               jrParent := 'NotAParenttneraPAtoN';
                               jrType := 0;
                             end;
                     30008 : jrAcCode := 'NotAParent';
                     30009 : jrStartDate := 'NotAParent';
                     30010 : jrEndDate := 'NotAParent';
                     30011 : jrRevisedEndDate := 'NotAParent';
                  end;

                 fResult := jobItem.Save;
               end;
          end;
       end;
   end;

   with oToolkit.JobCosting.JobType do
   begin
     if(Assigned(jType)) then
      begin
           with jType as JobType2 do
           begin
              case StrToInt(FExtraParam) of
                     5 : jtCode := '0';
                 30001 : jtCode := '';
              end;

             fResult := jType.Save;
           end;
      end;
   end;
end;
end.
