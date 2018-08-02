unit CheckSORf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise04_TLB, TESTFORMTEMPLATE, StdCtrls, TestConst;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.RunTest;
var
  sDocTypeFrom, sDocTypeTo : string;
  sAction  : string;
  DocType : TDocTypes;
begin
  //Expected parameters in ExtraParam = DocFrom,DocTo,Action - eg SOR,SDN,Check. If less than 3 parameters don't run - return error.
  SplitExtraParam;
  if FExtraParamList.Count = 3 then
  begin
    sDocTypeFrom := FExtraParamList[0];

    sDocTypeTo := FExtraParamList[1];
    DocType := StringToDocType(sDocTypeTo);

    sAction := UpperCase(FExtraParamList[2]);
    with oToolkit.Transaction as ITransaction2 do
    begin
      //Find the transaction we want to convert
      Index := thIdxOurRef;
      FResult := GetLessThanOrEqual(BuildOurRefIndex(sDocTypeFrom + 'ZZZZZZ'));

      if FResult = 0 then
      begin
        with Convert(DocType) do
        begin
          if sAction = 'CHECK' then
            FResult := Check
          else
            FResult := Execute;

        end; //with Convert
      end;
    end; // with oToolkit.Transaction
  end //3 parameters
  else
   FWParam := E_INVALID_PARAMS;
end;

end.
