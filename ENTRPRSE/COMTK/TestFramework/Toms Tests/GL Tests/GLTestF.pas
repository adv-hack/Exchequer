unit GLTestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls ,TESTFORMTEMPLATE, enterprise04_tlb;

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

{$R *.dfm}

procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin
  case StrToInt(FExtraParam) of
    30006 : oToolkit.Configuration.DefaultNominalCode := 2;
  end;
end;

procedure TfrmTestTemplate1.RunTest;
var
  GLItem : IGeneralLedger;
  searchKey : shortstring;
  funcRes : longint;
begin
   with oToolkit.GeneralLedger do
   begin
      Index := acIdxCode;
      searchKey := BuildCodeIndex(10010);
      funcRes := GetEqual(searchKey);

      {Ignored Errors: }

       if(StrToInt(FExtraParam) = 5) or (StrToInt(FExtraParam) = 30005) or (StrToInt(FExtraParam) = 30003) then
         GLItem := Add
        else
         GLItem := Update;

        if(Assigned(GLItem)) then
        begin
             with GLItem do
             begin
                case StrToInt(FExtraParam) of
                   5 : glCode := 10010;
                   30001 : glParent := 101;
                   30002 : glType := 2;
                   30003 : glCode := -1;
                   30005 : begin
                            glCode := 10101;
                            glParent := 121;
                           end;
                   30006 : glCarryFwd := 121121;
                end;

               fResult := GLItem.Save;
             end;
        end;
   end;
end;

end.
