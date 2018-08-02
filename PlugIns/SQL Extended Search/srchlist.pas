unit srchlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, DB, ADODB, ExtCtrls, StrUtils;

type
  TExtendedSearch = class(TForm)
    PageDetails: TPageControl;
    CustSuppTAB: TTabSheet;
    SearchTxtLbl: TLabel;
    SearchText: TEdit;
    CustSuppGrid: TListView;
    Label3: TLabel;
    ADODataConnection: TADOConnection;
    ADOQuery: TADOQuery;
    Panel1: TPanel;
    Desc1: TLabel;
    Desc2: TLabel;
    Desc3: TLabel;
    Desc4: TLabel;
    Desc5: TLabel;
    DescValue1: TLabel;
    DescValue2: TLabel;
    DescValue3: TLabel;
    DescValue4: TLabel;
    DescValue5: TLabel;
    Desc6: TLabel;
    DescValue6: TLabel;
    UnitStock: TLabel;
    UnitSale: TLabel;
    UnitPurchase: TLabel;
    UnitPurchaseVal: TLabel;
    UnitSaleVal: TLabel;
    UnitStockVal: TLabel;
    QtyStk: TLabel;
    QtyStkVal: TLabel;
    QtyOrd: TLabel;
    QtyOrdVal: TLabel;
    QtyPick: TLabel;
    QtyFree: TLabel;
    QtyFreeVal: TLabel;
    QtyPickVal: TLabel;
    Desc7: TLabel;
    DescValue7: TLabel;
    SearchBtn: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CustSuppGridEnter(Sender: TObject);
    procedure CustSuppGridExit(Sender: TObject);
    procedure CustSuppGridDblClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SearchBtnClick(Sender: TObject);
    procedure CustSuppGridChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure CustSuppGridCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
  private
    { Private declarations }
    procedure ClearGrid;
  public
    { Public declarations }
    SearchType,Parameter1,EnterpriseCoID:shortstring;
    InGrid:Boolean;
    HookBasedSearch:Boolean;
    IncludeConsumers: Boolean;

    procedure SetDescLbls(SrchType:shortstring);
    function IsThisAValidCode:Boolean;
    procedure SearchForData;
    function CheckStr(S : String) : String;
  end;

  function ExtLookupHook(Const ConnectionString, aConnectionPass, CompanyCode : WideString;
                         DataType, HookText :string;
                         IncludeConsumers: Boolean = false) : Shortstring;  // Called from Ent Hook Points (Handler)

var
  ExtendedSearch: TExtendedSearch;
  CodeSelected:Shortstring;

implementation

{$R *.dfm}

Uses oSettings;

type
  { Simple class to hold a string value, so that we can attach a string as the
    data property for list items }
  TStrWrapper = class(TObject)
  public
    Value: string;
    constructor Create(WithValue: string);
  end;

//=========================================================================

function ExtLookupHook(Const ConnectionString, aConnectionPass, CompanyCode : WideString;
                       DataType, HookText : string;
                       IncludeConsumers: Boolean) : Shortstring;
begin
  CodeSelected:='';
  ExtendedSearch:=TExtendedSearch.Create(Application);

  try
    ExtendedSearch.IncludeConsumers := IncludeConsumers;
    with ExtendedSearch do
      begin
        HookBasedSearch:=True;
        SearchType:=DataType;
        SetDescLbls(DataType);

        SearchText.Text:=HookText;

        // MH 24/03/2011: Added ConnectionString parameter so per company database configuration in .INI not necessary
        ADODataConnection.ConnectionString := ConnectionString;
        ADODataConnection.ConnectionTimeout := Settings.ConnectionTimeout;
        ADODataConnection.CommandTimeout := Settings.CommandTimeout;
        ADODataConnection.Open('', aConnectionPass);
        //ADODataConnection.Connected:=True;

        // MH 24/03/2011: Added CompanyCode parameter so not necessary to work out code from path in .INI file
        EnterpriseCoID := CompanyCode;

        // Setup window for search type
        SetDescLbls(SearchType);

        if IsThisAValidCode then // Does a quick query to see if only one record returned (code only); STOCK check only.
          CodeSelected:=HookText
        else
          begin
            HookText:=Trim(HookText);
            if SearchText.Text<>'' then
              SearchForData;
            if CustSuppGrid.Items.Count=0 then // Nothing found...
              ActiveControl:=SearchText;

            ShowModal;
          end;
      end;
  finally
    ExtendedSearch.ADODataConnection.Connected:=False;
    ExtendedSearch.Free;
  end;
  ExtLookupHook:=CodeSelected;
end;

{ TStrWrapper }
constructor TStrWrapper.Create(WithValue: string);
begin
  inherited Create;
  Value := WithValue;
end;

{ TExtendedSearch }
function TExtendedSearch.CheckStr(S : String) : String;
var
  IntLength:Integer;
  strTemp:string;
begin
  if Pos(Char(39), S) > 0 then  // Need double '' for a single ' with SQL Server
    begin
      strTemp:='';
      for IntLength:=1 to length(S) do
        begin
          if Copy(S,IntLength,1)=Char(39) then
            strTemp:=strTemp+#39+#39
          else
            strTemp:=strTemp+Copy(S,IntLength,1);
        end;
      S:=strTemp;
    end;
  Result := S;
end;

procedure TExtendedSearch.SetDescLbls(SrchType:shortstring);
begin
  if (SrchType='Customer') or (SrchType='Supplier') then
    begin
      Desc1.Caption:='Company';
      Desc2.Caption:='Address';
      Desc3.Caption:='';
      Desc4.Caption:='';
      Desc5.Caption:='';
      Desc6.Caption:='';
      Desc7.Caption:='Post Code';
      UnitStock.Visible:=False;
      UnitSale.Visible:=False;
      UnitPurchase.Visible:=False;
      UnitStockVal.Visible:=False;
      UnitSaleVal.Visible:=False;
      UnitPurchaseVal.Visible:=False;

      QtyStk.Visible:=False;
      QtyStkVal.Visible:=False;
      QtyOrd.Visible:=False;
      QtyOrdVal.Visible:=False;
      QtyPick.Visible:=False;
      QtyPickVal.Visible:=False;
      QtyFree.Visible:=False;
      QtyFreeVal.Visible:=False;
    end;

  if (SrchType='Stock') then
    begin
      Desc1.Caption:='Description';
      Desc2.Caption:='';
      Desc3.Caption:='';
      Desc4.Caption:='';
      Desc5.Caption:='';
      Desc6.Caption:='';
      Desc7.Caption:='';
      UnitStock.Visible:=True;
      UnitSale.Visible:=True;
      UnitPurchase.Visible:=True;
      UnitStockVal.Visible:=True;
      UnitSaleVal.Visible:=True;
      UnitPurchaseVal.Visible:=True;

      QtyStk.Visible:=True;
      QtyStkVal.Visible:=True;
      QtyOrd.Visible:=True;
      QtyOrdVal.Visible:=True;
      QtyPick.Visible:=True;
      QtyPickVal.Visible:=True;
      QtyFree.Visible:=True;
      QtyFreeVal.Visible:=True;
    end;

  if (SrchType='Job') then
    begin
      Desc1.Caption:='Description';
      Desc2.Caption:='Contact';
      Desc3.Caption:='Manager';
      Desc4.Caption:='Job Type';
      Desc5.Caption:='Customer';
      Desc6.Caption:='SOR Ref';
      Desc7.Caption:='';
      UnitStock.Visible:=False;
      UnitSale.Visible:=False;
      UnitPurchase.Visible:=False;
      UnitStockVal.Visible:=False;
      UnitSaleVal.Visible:=False;
      UnitPurchaseVal.Visible:=False;
      QtyStk.Visible:=False;
      QtyStkVal.Visible:=False;
      QtyOrd.Visible:=False;
      QtyOrdVal.Visible:=False;
      QtyPick.Visible:=False;
      QtyPickVal.Visible:=False;
      QtyFree.Visible:=False;
      QtyFreeVal.Visible:=False;
    end;
end;

procedure TExtendedSearch.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   ShiftPressed:Boolean;
   CTRLPressed:Boolean;
   AltPressed:Boolean;
begin
   ShiftPressed:=ssShift in Shift;
   CTRLPressed:=ssCTRL in Shift;
   AltPressed:=ssAlt in Shift;

   if not(InGrid) then
     begin
     if not(AltPressed) and (Parameter1<>'Dropdown List') then
       case key of
         vk_Return, vk_Down:
         begin SelectNext(ActiveControl as tWinControl, True, True);
           Parameter1:='Ignore';
           key:=1;
         end;
         vk_Up:
         begin
           SelectNext(ActiveControl as tWinControl, False, True);
           Parameter1:='Ignore';
           key:=1;
         end;
         vk_Escape:
         begin
           CodeSelected:='';
           Close;
           Parameter1:='Ignore';
           key:=1;
         end;
         else
           Parameter1:='';
       end
     end
   else
     begin
       case key of
         vk_Return:
           begin
             CustSuppGridDblClick(Sender);
             Key:=1;
             Parameter1:='';
           end;
         vk_Insert:
           begin
             Parameter1:='Ignore';
             key:=1;
           end;
         vk_Escape:
           begin
             CodeSelected:='';

             // CJS 2013-11-05 - MRD1.1.47 - Consumer Support
             ClearGrid;

             SearchText.SetFocus;
             Parameter1:='Ignore';
             key:=1;
           end;
         else
           Parameter1:=''
         end;
     end;
end;

procedure TExtendedSearch.CustSuppGridEnter(Sender: TObject);
begin
  InGrid:=True;
end;

procedure TExtendedSearch.CustSuppGridExit(Sender: TObject);
begin
  InGrid:=False;
end;

procedure TExtendedSearch.CustSuppGridDblClick(Sender: TObject);
begin
  if (CustSuppGrid.Items.Count>0) and (CustSuppGrid.Selected<> nil) then
    begin
      // CJS 2013-11-05 - MRD1.1.47 - Consumer Support
      if CustSuppGrid.Items[CustSuppGrid.Selected.Index].Data <> nil then
        CodeSelected := TStrWrapper(CustSuppGrid.Items[CustSuppGrid.Selected.Index].Data).Value
      else
        CodeSelected:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].Caption;

      // CJS 2013-11-05 - MRD1.1.47 - Consumer Support
      ClearGrid;
      
      Close;
    end;
end;

procedure TExtendedSearch.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if Parameter1='Ignore' then
     begin
       key:=#0;
       Parameter1:='';
     end
   else if Parameter1<>'Dropdown List' then
     Parameter1:='';
end;

procedure TExtendedSearch.SearchBtnClick(Sender: TObject);
begin
  SearchForData;
  if CustSuppGrid.Items.Count>0 then
    CustSuppGrid.SetFocus
  else
    SearchText.SetFocus;
end;

procedure TExtendedSearch.SearchForData;
var
  NewItem: TListItem;
  SearchList:TStringList;
  C:Integer;
  Tempstr:ShortString;
  IsConsumer: Boolean;

  function AddQryParameter(QryText:shortstring;QryPrm:shortstring;Operator:shortstring):shortstring;
  begin
    Result:='';
//..Use Uppercase version as the MS SQL can be case sensitive (in its DB config)
    if QryText<>'' then
      Result:=Operator+' UPPER('+QryPrm+') LIKE '+#39+'%'+UpperCase(QryText)+'%'+#39
  end;

begin
  SearchList:=TStringList.Create;
  TempStr:=Trim(SearchText.Text);

  // CJS 2013-11-05 - MRD1.1.47 - Consumer Support
  IsConsumer := False;
  if IncludeConsumers and (SearchType = 'Customer') and (Copy(TempStr, 1, 1) = '_') then
  begin
    IsConsumer := True;
    TempStr := Copy(TempStr, 2, Length(TempStr) - 1);
  end;

  while Pos(' ',TempStr)>0 do
    begin
      SearchList.Add(Copy(TempStr,1,Pos(' ',TempStr)-1));
      TempStr:=Copy(TempStr,Pos(' ',TempStr)+1,255);
    end;
  if TempStr<>'' then
    SearchList.Add(TempStr);

  ADOQuery.SQL.Clear;
  if (SearchType='Customer') or (SearchType='Supplier') then
    begin
      if (SearchType='Customer') then
      begin
        if IsConsumer then
          ADOQuery.SQL.Add('SELECT TOP '+IntToStr(Settings.MaxRowsReturned)+' acLongAcCode as Code,acCode as ShortCode,acCompany AS Desc1,acAddressLine1 AS Desc2,acAddressLine2 AS Desc3,acAddressLine3 AS Desc4,acAddressLine4 AS Desc5,acAddressLine5 AS Desc6, acPostCode as Desc7 FROM '+EnterpriseCoID+'.CUSTSUPP WHERE acSubType='+#39+'U'+#39)
        else
          ADOQuery.SQL.Add('SELECT TOP '+IntToStr(Settings.MaxRowsReturned)+' acCode as Code,acCompany AS Desc1,acAddressLine1 AS Desc2,acAddressLine2 AS Desc3,acAddressLine3 AS Desc4,acAddressLine4 AS Desc5,acAddressLine5 AS Desc6, acPostCode as Desc7 FROM '+EnterpriseCoID+'.CUSTSUPP WHERE acSubType='+#39+'C'+#39);
      end
      else
        ADOQuery.SQL.Add('SELECT TOP '+IntToStr(Settings.MaxRowsReturned)+' acCode as Code,acCompany AS Desc1,acAddressLine1 AS Desc2,acAddressLine2 AS Desc3,acAddressLine3 AS Desc4,acAddressLine4 AS Desc5,acAddressLine5 AS Desc6, acPostCode as Desc7 FROM '+EnterpriseCoID+'.CUSTSUPP WHERE acSubType='+#39+'S'+#39);

      // MH 23/04/2014 v7.0.14 ABSEXCH-16383: Exclude Closed Customer/Consumer/Supplier Accounts
      ADOQuery.SQL.Add('AND (acAccStatus <> 3)');

      for C:=1 to SearchList.Count do
        begin
          ADOQuery.SQL.Add('AND (');
          // CJS 2013-11-05 - MRD1.1.47 - Consumer Support
          if IsConsumer then
            ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acLongAcCode',''))
          else
            ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acCode',''));
          if Settings.CUCompany then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acCompany','OR'));
          if Settings.CUAddress1 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acAddressLine1','OR'));
          if Settings.CUAddress2 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acAddressLine2','OR'));
          if Settings.CUAddress3 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acAddressLine3','OR'));
          if Settings.CUAddress4 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acAddressLine4','OR'));
          if Settings.CUAddress5 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acAddressLine5','OR'));
          if Settings.CUPostCode then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acPostCode','OR'));
          if Settings.CUDelAddress1 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acDespAddressLine1','OR'));
          if Settings.CUDelAddress2 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acDespAddressLine2','OR'));
          if Settings.CUDelAddress3 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acDespAddressLine3','OR'));
          if Settings.CUDelAddress4 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acDespAddressLine4','OR'));
          if Settings.CUDelAddress5 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acDespAddressLine5','OR'));
          if Settings.CUContact then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acContact','OR'));
          if Settings.CUPhone1 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acPhone','OR'));
          if Settings.CUPhone2 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acFax','OR'));
          if Settings.CUPhone3 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acPhone2','OR'));
          if Settings.CUEMailID then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acEMailAddr','OR'));
          if Settings.CUTheirAccount then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acTheirAcc','OR'));
          if Settings.CUInvoiceTo then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acInvoiceTo','OR'));
          if Settings.CUAccType then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acAccType','OR'));
          if Settings.CUUser1 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acUserDef1','OR'));
          if Settings.CUUser2 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acUserDef2','OR'));
          if Settings.CUUser3 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acUserDef3','OR'));
          if Settings.CUUser4 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acUserDef4','OR'));

          // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
          if Settings.CUUser5 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acUserDef5','OR'));
          if Settings.CUUser6 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acUserDef6','OR'));
          if Settings.CUUser7 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acUserDef7','OR'));
          if Settings.CUUser8 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acUserDef8','OR'));
          if Settings.CUUser9 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acUserDef9','OR'));
          if Settings.CUUser10 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acUserDef10','OR'));
          if Settings.CUVATNo then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acVATRegNo','OR'));
          if Settings.CUArea then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'acArea','OR'));
          ADOQuery.SQL.Add(')');
        end;
    end;

  if SearchType='Stock' then
    begin
      ADOQuery.SQL.Add('SELECT TOP '+IntToStr(Settings.MaxRowsReturned)+' stCode AS Code,stDescLine1 AS Desc1,stDescLine2 AS Desc2,stDescLine3 AS Desc3,stDescLine4 AS Desc4,stDescLine5 AS Desc5,stDescLine6 AS Desc6,'''' AS Desc7,');
      ADOQuery.SQL.Add('stUnitOfStock,stUnitOfSale,stUnitOfPurch,stQtyInStock,stQtyOnOrder,stQtyAllocated+stQtyPicked AS stQtyPicked,stQtyInStock+stQtyOnOrder-stQtyAllocated-stQtyPicked as stQtyFree,stUserField1,stUserField2,stUserField3,stUserField4,stUserField5,');
      ADOQuery.SQL.Add('stUserField6,stUserField7,stUserField8,stUserField9,stUserField10,stSalesBand1Price,stSalesBand2Price,stSalesBand3Price,stSalesBand4Price,stSalesBand5Price,stSalesBand6Price,stSalesBand7Price,stSalesBand8Price,stNomCode1 FROM '+EnterpriseCoID+'.STOCK WHERE (stType=''D'' OR stType=''M'' OR stType=''P'')');
      for C:=1 to SearchList.Count do
        begin
          ADOQuery.SQL.Add('AND (');
          ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stCode',''));
          if Settings.STDesc1 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stDescLine1','OR'));
          if Settings.STDesc2 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stDescLine2','OR'));
          if Settings.STDesc3 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stDescLine3','OR'));
          if Settings.STDesc4 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stDescLine4','OR'));
          if Settings.STDesc5 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stDescLine5','OR'));
          if Settings.STDesc6 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stDescLine6','OR'));
          if Settings.STPrefSupp then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stSuppTemp','OR'));
          if Settings.STAltCode then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stAltCode','OR'));
          if Settings.STLocation then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stLocation','OR'));
          if Settings.STBarCode then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stBarCode','OR'));
          if Settings.STBinCode then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stBinLocation','OR'));
          if Settings.STUnitStock then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUnitOfStock','OR'));
          if Settings.STUnitPurchase then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUnitOfPurch','OR'));
          if Settings.STUnitSale then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUnitOfSale','OR'));
          if Settings.STUser1 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUserField1','OR'));
          if Settings.STUser2 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUserField2','OR'));
          if Settings.STUser3 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUserField3','OR'));
          if Settings.STUser4 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUserField4','OR'));

          // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
          if Settings.STUser5 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUserField5','OR'));
          if Settings.STUser6 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUserField6','OR'));
          if Settings.STUser7 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUserField7','OR'));
          if Settings.STUser8 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUserField8','OR'));
          if Settings.STUser9 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUserField9','OR'));
          if Settings.STUser10 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'stUserField10','OR'));
          ADOQuery.SQL.Add(')');
        end;
    end;

  if SearchType='Job' then
    begin
      ADOQuery.SQL.Add('SELECT TOP '+IntToStr(Settings.MaxRowsReturned)+' JobCode AS Code,JobDesc AS Desc1,Contact AS Desc2,JobMan AS Desc3,CustCode AS Desc4,JobType AS Desc5,SORRef AS Desc6,'''' AS Desc7 FROM '+EnterpriseCoID+'.JOBHEAD WHERE 1=1');
      for C:=1 to SearchList.Count do
        begin
          ADOQuery.SQL.Add('AND (');
          ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'JobCode',''));
          if Settings.JCDesc1 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'JobDesc','OR'));
          if Settings.JCJobContact then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'Contact','OR'));
          if Settings.JCJobManager then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'JobMan','OR'));
          if Settings.JCCustCode then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'CustCode','OR'));
          if Settings.JCAltCode then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'JobAltCode','OR'));
          if Settings.JCSORRef then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'SORRef','OR'));
          if Settings.JCUser1 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'UserDef1','OR'));
          if Settings.JCUser2 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'UserDef2','OR'));
          if Settings.JCUser3 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'UserDef3','OR'));
          if Settings.JCUser4 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'UserDef4','OR'));

          // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
          if Settings.JCUser5 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'UserDef5','OR'));
          if Settings.JCUser6 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'UserDef6','OR'));
          if Settings.JCUser7 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'UserDef7','OR'));
          if Settings.JCUser8 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'UserDef8','OR'));
          if Settings.JCUser9 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'UserDef9','OR'));
          if Settings.JCUser10 then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'UserDef10','OR'));

          if Settings.JCJobType then ADOQuery.SQL.Add(AddQryParameter(CheckStr(SearchList[C-1]),'JobType','OR'));
          ADOQuery.SQL.Add(')');
        end;
    end;


  try
    ADOQuery.SQL.Add('ORDER BY Code');
    ADOQuery.Open;
    // CJS 2013-11-05 - MRD1.1.47 - Consumer Support
    ClearGrid;

    CustSuppGrid.Items.BeginUpdate;
    while not ADOQuery.eof do
      begin
        NewItem:=CustSuppGrid.Items.Add;

        //..Define key in TListView for later..
        NewItem.Caption:=ADOQuery.FieldByName('Code').AsString;
        if IsConsumer then
          NewItem.Data := TStrWrapper.Create(Trim(ADOQuery.FieldByName('ShortCode').AsString));

        if (SearchType='Stock') and Settings.STAppendDesc then
          // MH 25/03/2011
          NewItem.SubItems.Add (Trim(ADOQuery.FieldByName('Desc1').AsString) + ' ' +
                                Trim(ADOQuery.FieldByName('Desc2').AsString) + ' ' +
                                Trim(ADOQuery.FieldByName('Desc3').AsString) + ' ' +
                                Trim(ADOQuery.FieldByName('Desc4').AsString) + ' ' +
                                Trim(ADOQuery.FieldByName('Desc5').AsString) + ' ' +
                                Trim(ADOQuery.FieldByName('Desc6').AsString))
        else
          NewItem.SubItems.Add (ADOQuery.FieldByName('Desc1').AsString);

        NewItem.SubItems.Add (ADOQuery.FieldByName('Desc1').AsString);
        NewItem.SubItems.Add (ADOQuery.FieldByName('Desc2').AsString);
        NewItem.SubItems.Add (ADOQuery.FieldByName('Desc3').AsString);
        NewItem.SubItems.Add (ADOQuery.FieldByName('Desc4').AsString);
        NewItem.SubItems.Add (ADOQuery.FieldByName('Desc5').AsString);
        NewItem.SubItems.Add (ADOQuery.FieldByName('Desc6').AsString);
        NewItem.SubItems.Add (ADOQuery.FieldByName('Desc7').AsString);
        if (SearchType='Stock') then
          begin
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUnitOfStock').AsString);
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUnitOfSale').AsString);
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUnitOfPurch').AsString);
            NewItem.SubItems.Add (FormatFloat('0.00',ADOQuery.FieldByName('stQtyInStock').Value));
            NewItem.SubItems.Add (FormatFloat('0.00',ADOQuery.FieldByName('stQtyOnOrder').Value));
            NewItem.SubItems.Add (FormatFloat('0.00',ADOQuery.FieldByName('stQtyPicked').Value));
            NewItem.SubItems.Add (FormatFloat('0.00',ADOQuery.FieldByName('stQtyFree').Value));
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUserField1').AsString);
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUserField2').AsString);
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUserField3').AsString);
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUserField4').AsString);

            // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUserField5').AsString);
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUserField6').AsString);
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUserField7').AsString);
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUserField8').AsString);
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUserField9').AsString);
            NewItem.SubItems.Add (ADOQuery.FieldByName('stUserField10').AsString);

            NewItem.SubItems.Add (FormatFloat('0.00',ADOQuery.FieldByName('stSalesBand1Price').Value));
            NewItem.SubItems.Add (FormatFloat('0.00',ADOQuery.FieldByName('stSalesBand2Price').Value));
            NewItem.SubItems.Add (FormatFloat('0.00',ADOQuery.FieldByName('stSalesBand3Price').Value));
            NewItem.SubItems.Add (FormatFloat('0.00',ADOQuery.FieldByName('stSalesBand4Price').Value));
            NewItem.SubItems.Add (FormatFloat('0.00',ADOQuery.FieldByName('stSalesBand5Price').Value));
            NewItem.SubItems.Add (FormatFloat('0.00',ADOQuery.FieldByName('stSalesBand6Price').Value));
            NewItem.SubItems.Add (FormatFloat('0.00',ADOQuery.FieldByName('stSalesBand7Price').Value));
            NewItem.SubItems.Add (FormatFloat('0.00',ADOQuery.FieldByName('stSalesBand8Price').Value));
            NewItem.SubItems.Add (FormatFloat('0',ADOQuery.FieldByName('stNomCode1').Value));
          end;
        ADOQuery.Next;
      end;
      CustSuppGrid.Items.EndUpdate;
      ADOQuery.Close;
  finally
    if CustSuppGrid.Items.Count=Settings.MaxRowsReturned then
      Caption:=' Extended search (Result limited to '+IntToStr(Settings.MaxRowsReturned)+' items returned)...'
    else
      Caption:=' Extended search ('+IntToStr(CustSuppGrid.Items.Count)+' items returned)...';
    Screen.Cursor:=crDefault;
  end;
  Screen.Cursor:=crDefault;

  if CustSuppGrid.Items.Count>0 then
    begin
      CustSuppGrid.Items[0].Selected:=True;
      CustSuppGrid.Items[0].Focused:=True;
      CustSuppGrid.Items[0].MakeVisible(False);
    end;

  SearchList.Free;
end;

procedure TExtendedSearch.CustSuppGridChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  if (CustSuppGrid.Items.Count>0) and (CustSuppGrid.Selected<> nil) then
    begin
      DescValue1.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[1];
      DescValue2.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[2];
      DescValue3.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[3];
      DescValue4.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[4];
      DescValue5.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[5];
      DescValue6.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[6];
      DescValue7.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[7];

      if (SearchType='Stock') then
        begin
          UnitStockVal.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[8];
          UnitSaleVal.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[9];
          UnitPurchaseVal.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[10];
          QtyStkVal.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[11];
          QtyOrdVal.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[12];
          QtyPickVal.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[13];
          QtyFreeVal.Caption:=CustSuppGrid.Items[CustSuppGrid.Selected.Index].SubItems[14];
        end;
    end;
end;


function TExtendedSearch.IsThisAValidCode:Boolean;
Var
  TryQuery : Boolean;
begin
  IsThisAValidCode:=False;
  TryQuery := False;

  ADOQuery.SQL.Clear;
  // MH 29/03/2011: Extended to apply to Customers, Suppliers and Jobs
  If (SearchType='Stock') Then
  Begin
    TryQuery := True;
    ADOQuery.SQL.Add('SELECT COUNT(stCode) AS RecsFound FROM '+EnterpriseCoID+'.STOCK WHERE (stType=''D'' OR stType=''M'' OR stType=''P'')');
    ADOQuery.SQL.Add('AND stCode='+#39+Trim(CheckStr(SearchText.Text))+#39);
  End // If (SearchType='Stock')
  Else If (SearchType = 'Customer') Or (SearchType = 'Supplier') Then
  Begin
    TryQuery := True;
    ADOQuery.SQL.Add('SELECT COUNT(acCode) AS RecsFound FROM '+EnterpriseCoID+'.CUSTSUPP WHERE (acCustSupp=''' + IfThen((SearchType = 'Customer'), 'C', 'S') + ''')');
    ADOQuery.SQL.Add('AND acCode='+#39+Trim(CheckStr(SearchText.Text))+#39);
  End // If (SearchType = 'Customer') Or (SearchType = 'Supplier')
  Else If (SearchType = 'Job') Then
  Begin
    TryQuery := False;
  End // If (SearchType = 'Job')
  Else
    Raise Exception.Create ('TExtendedSearch.IsThisAValidCode: Invalid Search Type (' + SearchType + ')');

  If TryQuery Then
  Begin
    try
      ADOQuery.Open;
      IsThisAValidCode:=(ADOQuery.FieldByName('RecsFound').Value=1);
      ADOQuery.Close;
    finally
      Screen.Cursor:=crDefault;
      ADOQuery.Close;
    end;
  End; // If TryQuery
end;

procedure TExtendedSearch.CustSuppGridCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if (SearchType='Stock') then
    begin
      try
        if (Settings.GLSalesColourRed <> '') and (Item.SubItems[27] = Settings.GLSalesColourRed) then
          CustSuppGrid.Canvas.Font.Color := clRed
        Else if (Settings.GLSalesColourBlue <> '') and (Item.SubItems[27] = Settings.GLSalesColourBlue) then
          CustSuppGrid.Canvas.Font.Color := clBlue;
      except
      end;
    end;
end;

procedure TExtendedSearch.ClearGrid;
var
  Entry: Integer;
begin
  CustSuppGrid.Items.BeginUpdate;
  for Entry := 0 to CustSuppGrid.Items.Count - 1 do
  begin
    if (CustSuppGrid.Items[Entry].Data <> nil) then
    begin
      TStrWrapper(CustSuppGrid.Items[Entry].Data).Free;
      CustSuppGrid.Items[Entry].Data := nil;
    end;
  end;
  CustSuppGrid.Clear;
  CustSuppGrid.Items.EndUpdate;
end;

end.
