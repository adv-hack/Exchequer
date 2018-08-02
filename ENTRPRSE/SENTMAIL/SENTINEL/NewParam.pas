unit NewParam;

interface

uses
  VRWReportIF, RptEngDll, ComCtrls, Classes, Enterprise01_TLB;


  function LoadNewReportParams(const RepName, UserID, DataPath : ShortString; const lvParams : TListView;
                               const FCurrencyList : TStringList; const FToolkit : IToolkit) : Integer; //Return no of params
  function RangeFilterSet(const RangeFilter: IVRWRangeFilter) : Boolean;
  function ReverseVRWDate(const s : ShortString) : ShortString;

var
  oReport : IVRWReport3;


implementation

uses
  SysUtils, ApiUtil, Dialogs, EtDateU;

  //VRW dates are in ddmmyyyy format rather than Exchequer yyyymmdd - function to reverse datestring.
  function ReverseVRWDate(const s : ShortString) : ShortString;
  begin
    Result := Copy(s, 5, 4) + Copy(s, 3, 2) + Copy(s, 1, 2);
  end;

  function RangeFilterSet(const RangeFilter: IVRWRangeFilter) : Boolean;
  begin
    Result := (Trim(RangeFilter.rfDescription) <> '') or
              (Trim(RangeFilter.rfFromValue) <> '') or
              (Trim(RangeFilter.rfToValue) <> '');
  end;

  //PR: 06/03/2012 ABSEXCH-11836 Function to insert '/' into Perio string of ppyyyy
  function FormatPeriod(const s : ShortString) : ShortString;
  begin
    Result := Copy(s, 1, 2) + '/' + Copy(s, 3, 4);
  end;


  function LoadNewReportParams(const RepName, UserID, DataPath : ShortString; const lvParams : TListView;
                               const FCurrencyList : TStringList; const FToolkit : IToolkit) : Integer;
  var
    i, Res : Integer;
    ParamList : TList;
    MemStream : TMemoryStream;
//    RangeFilter: IVRWRangeFilter;
    RangeFilter : IVRWRangeFilter;
    Input : IVRWInputField;
    Control: IVRWControl;

    procedure AddFilter;
    var
      j : integer;
      s1 : string;
    begin
      with lvParams.Items.Add do
      begin
        Caption := IntToStr(lvParams.Items.Count);
        SubItems.Add(RangeFilter.rfDescription);
        if RangeFilter.rfType = 1 then //Date
        begin
          SubItems.Add(POutDate(ReverseVRWDate(RangeFilter.rfFromValue)));
          SubItems.Add(POutDate(ReverseVRWDate(RangeFilter.rfToValue)));
        end
        else //PR: 06/05/2011 Added proper handling for currency
        if RangeFilter.rfType = 5 then //Currency
        begin
           if FCurrencyList.Count = 0 then
           begin
             FToolkit.OpenToolkit;
             for j := 0 to 89 do
             begin
              s1 := Trim(FToolkit.SystemSetup.ssCurrency[j].scSymbol);
              if (Length(s1) > 0) and (s1[1] = #156) then
                s1 := '£';
              FCurrencyList.Add( s1 +
                              ' - ' +  Trim(FToolkit.SystemSetup.ssCurrency[j].scDesc));
             end;
             FToolkit.CloseToolkit;
           end;

           SubItems.Add(FCurrencyList[Ord(RangeFilter.rfFromValue[1])]);
           SubItems.Add(FCurrencyList[Ord(RangeFilter.rfToValue[1])]);
        end
        else //PR: 06/03/2012 ABSEXCH-11836 Format period correctly before adding it.
        if RangeFilter.rfType = 2 then
        begin
          SubItems.Add(FormatPeriod(RangeFilter.rfFromValue));
          SubItems.Add(FormatPeriod(RangeFilter.rfToValue));
        end
        else
        begin
          SubItems.Add(RangeFilter.rfFromValue);
          SubItems.Add(RangeFilter.rfToValue);
        end;
        SubItems.Add(IntToStr(RangeFilter.rfType));
        SubItems.Add(RangeFilter.rfName);
      end;
    end;

    //PR: 03/06/2010 Allow handling of Input Fields
    procedure AddInput;
    var
      j : integer;
      s1 : string;
    begin
      with lvParams.Items.Add do
      begin
        Caption := IntToStr(lvParams.Items.Count);
        SubItems.Add(Input.rfDescription);
        if Input.rfType = 1 then //Date
        begin
          SubItems.Add(POutDate(ReverseVRWDate(Input.rfFromValue)));
          SubItems.Add(POutDate(ReverseVRWDate(Input.rfToValue)));
        end
        else //PR: 06/05/2011 Added proper handling for currency
        if Input.rfType = 5 then //Currency
        begin
           if FCurrencyList.Count = 0 then
           begin
             FToolkit.OpenToolkit;
             for j := 0 to 89 do
             begin
              s1 := Trim(FToolkit.SystemSetup.ssCurrency[j].scSymbol);
              if (Length(s1) > 0) and (s1[1] = #156) then
                s1 := '£';
              FCurrencyList.Add( s1 +
                              ' - ' +  Trim(FToolkit.SystemSetup.ssCurrency[j].scDesc));
             end;
             FToolkit.CloseToolkit;
           end;

           SubItems.Add(FCurrencyList[Ord(Input.rfFromValue[1])]);
           SubItems.Add(FCurrencyList[Ord(Input.rfToValue[1])]);
        end
        else //PR: 06/03/2012 ABSEXCH-11836 Format period correctly before adding it.
        if Input.rfType = 2 then
        begin
          SubItems.Add(FormatPeriod(Input.rfFromValue));
          SubItems.Add(FormatPeriod(Input.rfToValue));
        end
        else
        begin
          SubItems.Add(Input.rfFromValue);
          SubItems.Add(Input.rfToValue);
        end;
        SubItems.Add(IntToStr(Input.rfType));
        SubItems.Add(Input.rfName);
      end;
    end;

  begin
    Result := 0;
    i := 0;
    lvParams.Items.Clear;
    oReport := GetVRWReport as IVRWReport3;
    Try
      oReport.vrDataPath := DataPath;
      Try
        oReport.Read(DataPath + 'Reports\' + RepName + '.erf');
      Except
        on E:EFOpenError do
          msgBox('It was not possible to read the report file '#10#10 +
                      '     ' + QuotedStr(DataPath + 'Reports\' + RepName + '.erf'), mtWarning, [mbOK], mbOK, 'File not found');
      End;

//      if Res = 0 then
//      begin
        RangeFilter := oReport.vrRangeFilter;
        if RangeFilterSet(RangeFilter) then
          AddFilter;

       for i := 0 to oReport.vrControls.clCount - 1 do
       begin

         Control := oReport.vrControls.clItems[i];

        { Only field controls can have a range filter }
        if Supports(Control, IVRWFieldControl) then
        with Control as IVRWFieldControl do
          { Does this control have a Range Filter? }
          if RangeFilterSet(vcRangeFilter) then
          begin
            RangeFilter := vcRangeFilter;
            AddFilter;
          end;
       end;

      //PR: 03/06/2010 Allow handling of Input Fields
       for i := 0 to oReport.vrInputFields.rfCount - 1 do
       begin
         Input := oReport.vrInputFields.rfItems[i];
         AddInput;
       end;
    Finally
      Result := lvParams.Items.Count;
      oReport := nil;
    End;
  end;

end.
