

  With SSTreeGrpAry[1] do
  Begin
    tCaption:='Account Records';

  end;


  With SSTreeGrpAry[10] do
  Begin
    tCaption:='Customer';
    CaptionLink:='000001 000002 000011 000012';

    IsChild:=1;

  end;

  With SSTreeGrpAry[20] do
  Begin
    tCaption:='Supplier';
    IsChild:=1;
    CaptionLink:='001051 001052 001053 001054';
  end;

  With SSTreeGrpAry[30] do
  Begin
    tCaption:='Financials';
    IsChild:=0;

  end;

  With SSTreeGrpAry[35] do
  Begin
    tCaption:='Line Types';
    IsChild:=1;

    CaptionLink:='000007 000008 000009 000010';
    HideLink:='000001 000002 000003 000004';

  end;


  With SSTreeGrpAry[40] do
  Begin
    tCaption:='Sale Transactions';
    IsChild:=1;
  end;

  With SSTreeGrpAry[45] do
  Begin
    tCaption:='Invoice Type. (SIN,SCR,SJI,SJC,SRI,SRF)';
    IsChild:=2;

    CaptionLink:='X 000003 000004 000013 000014';
    HideLink:='X 000000 000005 000006 000007';
  end;

  With SSTreeGrpAry[60] do
  Begin
    tCaption:='Data Entry Lines';
    IsChild:=3;

    CaptionLink:='000017 000018 000019 000020';
    HideLink:='000008 000009 000010 000011';

  end;

  With SSTreeGrpAry[65] do
  Begin
    tCaption:='Receipt Type. (SRC)';
    IsChild:=2;

    CaptionLink:='X 001003 001004 001005 001006';
    HideLink:=CaptionLink;

  end;

  With SSTreeGrpAry[70] do
  Begin
    tCaption:='Data Entry Lines';
    IsChild:=3;

    CaptionLink:='001007 001008 001009 001010';
    HideLink:=CaptionLink;

  end;

  With SSTreeGrpAry[75] do
  Begin
    tCaption:='Quotations (SQU)';
    IsChild:=2;

    CaptionLink:='X 002025 002026 002027 002028';
    HideLink:=CaptionLink;

  end;

  With SSTreeGrpAry[80] do
  Begin
    tCaption:='Data Entry Lines';
    IsChild:=3;

    CaptionLink:='002029 002030 002031 002032';
    HideLink:=CaptionLink;

  end;


  With SSTreeGrpAry[85] do
  Begin
    tCaption:='Order & Delivery Note. (SOR,SDN)';
    IsChild:=2;

    CaptionLink:='X 001011 001012 001013 001014';
    HideLink:=CaptionLink;

    {$IFNDEF SOP}
      Exclude:=BOn;
    {$ENDIF}

  end;


  With SSTreeGrpAry[90] do
  Begin
    tCaption:='Data Entry Lines';
    IsChild:=3;

    {$IFNDEF SOP}
      Exclude:=BOn;
    {$ENDIF}

    CaptionLink:='001015 001016 001017 001018';
    HideLink:=CaptionLink;

  end;



  With SSTreeGrpAry[95] do
  Begin
    tCaption:='Purchase Transactions';
    IsChild:=1;
  end;

  With SSTreeGrpAry[100] do
  Begin
    tCaption:='Invoice Type. (PIN,PCR,PJI,PJC,PPI,PRF)';
    IsChild:=2;
    CaptionLink:='X 001019 001020 001021 001022';
    HideLink:=CaptionLink;

  end;


  With SSTreeGrpAry[110] do
  Begin
    tCaption:='Data Entry Lines';
    IsChild:=3;

    CaptionLink:='001023 001024 001025 001026';
    HideLink:=CaptionLink;

  end;

  With SSTreeGrpAry[120] do
  Begin
    tCaption:='Payment Type. (PPY)';
    IsChild:=2;

    CaptionLink:='X 001027 001028 001029 001030';
    HideLink:=CaptionLink;
  end;

  With SSTreeGrpAry[130] do
  Begin
    tCaption:='Data Entry Lines';
    IsChild:=3;

    CaptionLink:='001031 001032 001033 001034';
    HideLink:=CaptionLink;

  end;


  With SSTreeGrpAry[135] do
  Begin
    tCaption:='Quotations (PQU)';
    IsChild:=2;

    CaptionLink:='X 002033 002034 002035 002036';
    HideLink:=CaptionLink;

  end;

  With SSTreeGrpAry[140] do
  Begin
    tCaption:='Data Entry Lines';
    IsChild:=3;

    CaptionLink:='002037 002038 002039 002040';
    HideLink:=CaptionLink;

  end;


  With SSTreeGrpAry[145] do
  Begin
    tCaption:='Order & Delivery Note. (POR,PDN)';
    IsChild:=2;

    CaptionLink:='X 001035 001036 001037 001038';
    HideLink:=CaptionLink;

    {$IFNDEF SOP}
      Exclude:=BOn;
    {$ENDIF}

  end;

  With SSTreeGrpAry[150] do
  Begin
    tCaption:='Data Entry Lines';
    IsChild:=3;

    {$IFNDEF SOP}
      Exclude:=BOn;
    {$ENDIF}

    CaptionLink:='001039 001040 001041 001042';
    HideLink:=CaptionLink;

  end;

  With SSTreeGrpAry[155] do
  Begin
    tCaption:='Nominal Journal. (NOM)';
    IsChild:=1;

    CaptionLink:='X 001043 001044 001045 001046';
    HideLink:=CaptionLink;

  end;

  With SSTreeGrpAry[157] do
  Begin
    tCaption:='Data Entry Lines';
    IsChild:=2;

    CaptionLink:='001047 001048 001049 001050';
    HideLink:=CaptionLink;

  end;


  With SSTreeGrpAry[160] do
  Begin
    tCaption:='Stock Control';
    IsChild:=0;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

  end;


  With SSTreeGrpAry[170] do
  Begin
    tCaption:='Stock Record';
    IsChild:=1;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

    CaptionLink:='000005 000006 000015 000016';

  end;

  With SSTreeGrpAry[180] do
  Begin
    tCaption:='Stock Adjustment. (ADJ)';
    IsChild:=1;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

    CaptionLink:='X 002001 002002 002003 002004';
    HideLink:=CaptionLink;


  end;

  With SSTreeGrpAry[190] do
  Begin
    tCaption:='Data Entry Lines';
    IsChild:=2;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

    CaptionLink:='002005 002006 002007 002008';
    HideLink:=CaptionLink;


  end;


  With SSTreeGrpAry[200] do
  Begin
    tCaption:='Works Order. (WOR)';
    IsChild:=1;

    Exclude:=Not WOPOn;

    CaptionLink:='X 002009 002010 002011 002012';
    HideLink:=CaptionLink;


  end;

  With SSTreeGrpAry[210] do
  Begin
    tCaption:='Data Entry Lines';
    IsChild:=2;

    Exclude:=Not WOPOn;

    CaptionLink:='002013 002014 002015 002016';
    HideLink:=CaptionLink;


  end;


  With SSTreeGrpAry[220] do
  Begin
    tCaption:='Sales/Purchase Order Processing';
    IsChild:=0;

    {$IFNDEF SOP}
      Exclude:=BOn;
    {$ENDIF}

  end;


  SSTreeGrpAry[230]:=SSTreeGrpAry[85];

  With SSTreeGrpAry[230] do
  Begin
    IsChild:=1;

  end;

  SSTreeGrpAry[240]:=SSTreeGrpAry[90];

  With SSTreeGrpAry[240] do
  Begin
    IsChild:=2;

  end;


  SSTreeGrpAry[250]:=SSTreeGrpAry[145];

  With SSTreeGrpAry[250] do
  Begin
    IsChild:=1;

  end;

  SSTreeGrpAry[260]:=SSTreeGrpAry[150];

  With SSTreeGrpAry[260] do
  Begin
    IsChild:=2;
  end;

  With SSTreeGrpAry[270] do
  Begin
    tCaption:='Job Costing';
    IsChild:=0;

    Exclude:=Not JBCostOn;
  end;


  With SSTreeGrpAry[280] do
  Begin
    tCaption:='Job Record';
    IsChild:=1;

    Exclude:=Not JBCostOn;

    CaptionLink:='000021 000022 001001 001002';

  end;

  With SSTreeGrpAry[285] do
  Begin
    tCaption:='Employee Record';
    IsChild:=1;

    Exclude:=Not JBCostOn;

    CaptionLink:='002041 002042 002043 002044';

  end;


  With SSTreeGrpAry[290] do
  Begin
    tCaption:='Timesheet';
    IsChild:=1;

    Exclude:=Not JBCostOn;

    CaptionLink:='X 002017 002018 002019 002020';
    HideLink:=CaptionLink;

  end;

  With SSTreeGrpAry[300] do
  Begin
    tCaption:='Data Entry Lines';
    IsChild:=2;

    Exclude:=Not JBCostOn;

    CaptionLink:='002021 002022 002023 002024';
    HideLink:=CaptionLink;

  end;


