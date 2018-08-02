object Form1: TForm1
  Left = 15
  Top = 134
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 637
  ClientWidth = 1243
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblTableName: TLabel
    Left = 18
    Top = 77
    Width = 58
    Height = 13
    Caption = 'Table Name'
  end
  object Label2: TLabel
    Left = 20
    Top = 39
    Width = 55
    Height = 13
    Caption = 'Conn String'
  end
  object Label3: TLabel
    Left = 6
    Top = 15
    Width = 72
    Height = 13
    Caption = 'Company Code'
  end
  object Bevel1: TBevel
    Left = 5
    Top = 65
    Width = 847
    Height = 9
    Shape = bsTopLine
  end
  object lblColumnInfo: TLabel
    Left = 9
    Top = 617
    Width = 395
    Height = 13
    AutoSize = False
  end
  object ServerLbl: TLabel
    Left = 156
    Top = 16
    Width = 31
    Height = 13
    Caption = 'Server'
  end
  object DatabaseLbl: TLabel
    Left = 420
    Top = 16
    Width = 46
    Height = 13
    Caption = 'Database'
  end
  object edtTableName: TEdit
    Left = 83
    Top = 75
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'ExchqSS'
  end
  object btnGetColumns: TButton
    Left = 205
    Top = 75
    Width = 75
    Height = 22
    Caption = 'Get Columns'
    TabOrder = 3
    OnClick = btnGetColumnsClick
  end
  object edtCompanyCode: TEdit
    Left = 83
    Top = 14
    Width = 63
    Height = 21
    TabOrder = 0
    Text = 'MAIN01'
  end
  object btnGenerateCode: TButton
    Left = 755
    Top = 76
    Width = 482
    Height = 21
    Caption = 'Generate Code'
    TabOrder = 7
    OnClick = btnGenerateCodeClick
  end
  object memGeneratedCode: TMemo
    Left = 755
    Top = 100
    Width = 478
    Height = 506
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 8
  end
  object sgColumnInfo: TStringGrid
    Left = 7
    Top = 103
    Width = 354
    Height = 510
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    PopupMenu = PopupMenu1
    TabOrder = 4
  end
  object memDelphiRecord: TMemo
    Left = 366
    Top = 103
    Width = 383
    Height = 482
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      '   {002}      CustCode   : string[10];    (*  customer code *)'
      
        '   {012}      CustSupp   : Char;          {* Customer / Supplier' +
        ' Flag *}'
      '   {014}      Company    : string[45];    (*  Company Name *)'
      ''
      
        '   {060}      AreaCode   : String[4];     {* Free Type Sort Fiel' +
        'd *}'
      
        '   {065}      RepCode    : String[4];     {*   "   "    "     " ' +
        '  *}'
      
        '   {070}      RemitCode  : String[10];    {* Account Code of Rem' +
        'it Account *}'
      
        '   {081}      VATRegNo   : String[30];    {* VAT Registration No' +
        '.  *}'
      ''
      '   {112}      Addr[1]       : String[30]'
      '   {112}      Addr[2]       : String[30]'
      '   {112}      Addr[3]       : String[30]'
      '   {112}      Addr[4]       : String[30]'
      '   {112}      Addr[5]       : String[30]'
      ''
      
        '   {266}      DespAddr   : Boolean;       {* Seaparete Despatch ' +
        'Address *}'
      '   {268}      DAddr[1]       : String[30]'
      '   {268}      DAddr[2]       : String[30]'
      '   {268}      DAddr[3]       : String[30]'
      '   {268}      DAddr[4]       : String[30]'
      '   {268}      DAddr[5]       : String[30]'
      '   {423}      Contact    : String[25];    {* Contact Name *}'
      '   {449}      Phone      : string[30];    {* Phone No. *}'
      '              Fax        : string[30];    {* Phone No. *}'
      
        '              RefNo      : String[10];    {* Our Code with them ' +
        '*}'
      '              TradTerm   : Boolean;       {* Special Terms *}'
      '              STerms[1]     : Str80;'
      '              STerms[2]     : Str80;'
      ''
      '              {* Defaults *}'
      ''
      '              Currency   : Byte;'
      '              VATCode    : Char;'
      '              PayTerms   : SmallInt;'
      '              CreditLimit: Real;'
      '              Discount   : Real;'
      ''
      '              {* Anal *}'
      ''
      '              CreditStatus                          : SmallInt;'
      ''
      '              CustCC     : String[3];'
      ''
      '              CDiscCh    : Char;'
      '              OrdConsMode                          : Byte;'
      ''
      
        '              DefSetDDays: SmallInt;     {* Default Settlement d' +
        'iscount Number of Days *}'
      ''
      '              Spare5     : Array[1..2] of Byte;'
      ''
      '              Balance    : Real;'
      ''
      '              CustDep    : String[3];'
      ''
      
        '              EECMember  : Boolean;       {* VAT Inclusion for E' +
        'EC *}'
      ''
      
        '              NLineCount : LongInt;       {* Note Line Count    ' +
        '   *}'
      
        '              IncStat    : Boolean;       {* Include in Statemen' +
        't  *}'
      ''
      
        '              DefNomCode : LongInt;       {* Default Nominal Cod' +
        'e  *}'
      
        '              DefMLocStk : String[3];     {* Default Multi Loc S' +
        'tock *}'
      
        '              AccStatus  : Byte;          {* On Hold, Closed, Se' +
        'e notes *}'
      '              PayType    : Char;          {* [B]acs,[C]ash *}'
      '              BankSort   : String[15];     {* Bank Sort Code *}'
      
        '              BankAcc    : String[20];     {* Bank Account No. *' +
        '}'
      
        '              BankRef    : String[28];    {* Bank additional ref' +
        ', ie Build Soc.Acc *}'
      
        '              AvePay     : SmallInt;       {* Average payment pa' +
        'ttern *}'
      ''
      '              Phone2     : String[30];    {* Second Phone No. *}'
      
        '              DefCOSNom  : LongInt;       {* Override COS Nomina' +
        'l *}'
      
        '              DefCtrlNom : LongInt;       {* Override Default Ct' +
        'rl Nominal *}'
      
        '              LastUsed   : LongDate;      {* Date last updated *' +
        '}'
      
        '              UserDef1   : String[30];    {* User Definable stri' +
        'ngs *}'
      ''
      
        '              UserDef2   : String[30];    {* User Definable stri' +
        'ngs *}'
      
        '              SOPInvCode : String[10];    {* Ent SOP Invoice Cod' +
        'e *}'
      
        '              SOPAutoWOff: Boolean;       {* Auto write off Sale' +
        's Order *}'
      
        '              FDefPageNo : Byte;          {* Use form def page f' +
        'or forms *}'
      
        '              BOrdVal    : Double;        {* Heinz Book order va' +
        'lue *}'
      
        '              DirDeb     : Byte;          {* Current Direct Debi' +
        't Mode *}'
      
        '              CCDSDate   : LongDate;      {* Credit Card Start D' +
        'ate *}'
      
        '              CCDEDate   : LongDate;      {* Credit Card End Dat' +
        'e *}'
      
        '              CCDName    : String[50];    {* Name on Credit Card' +
        ' *}'
      '              CCDCardNo  : String[30];    {* Credit Card No. *}'
      
        '              CCDSARef   : String[4];     {* Credit Card Switch ' +
        'Ref *}'
      
        '              DefSetDisc : Double;        {* Default Settlement ' +
        'Discount *}'
      ''
      '              StatDMode: Byte;         '
      '              Spare2   : String[50];'
      
        '              EmlSndRdr: Boolean;       {* On next email transmn' +
        'ision, send reader & reset *}'
      
        '              ebusPwrd : String[20];    {* ebusiness module web ' +
        'password *}'
      
        '              PostCode : String[20];    {* Seperate postcode ** ' +
        'Add index *}'
      
        '              CustCode2: String[20];    {* Alternative look up c' +
        'ode, can be blank *}'
      
        '              AllowWeb : Byte;          {* Allow upload to Web *' +
        '}'
      
        '              EmlZipAtc: Byte;          {* Default Zip attacheme' +
        'nt 0=no, 1= pkzip, 2= edz *}'
      
        '              UserDef3 : String[30];    {* User Definable string' +
        's *}'
      
        '              UserDef4 : String[30];    {* User Definable string' +
        's *}'
      ''
      
        '              WebLiveCat                        :    String[20];' +
        '         {Web current catalogue entry}'
      
        '              WebPrevCat                        :    String[20];' +
        '         {Web previous catalogue entry}'
      ''
      
        '              TimeChange                        :  String[6];   ' +
        ' {* Time stamp for record Change *}'
      ''
      
        '              VATRetRegC                {* Country of VAT regist' +
        'ration *}                        : String[5];'
      
        '              SSDDelTerms                        : String[5];   ' +
        '  {*     "     Delivery Terms }'
      ''
      '              CVATIncFlg                        : Char;'
      ''
      '              SSDModeTr: Byte;'
      ''
      '              PrivateRec                        : Boolean;'
      ''
      '              LastOpo                        : String[10];'
      ''
      '              InvDMode : Byte;   {Invoice delivery mode}'
      
        '              EmlSndHTML                        : Boolean;{When ' +
        'sending XML, send HTML}'
      ''
      
        '              EmailAddr: String[100];    {* Email address for St' +
        'atment/ Remittance *}'
      ''
      
        '              SOPConsHO: Byte;           {* If Head office, cons' +
        'olidate committed value *}'
      
        '              DefTagNo : Byte;           {* Default Tag No for S' +
        'OP/WOP *}'
      ''
      
        '              // CJS 2011-09-29: ABSEXCH-11706 - New user-define' +
        'd fields'
      '              UserDef5  : String[30];'
      '              UserDef6  : String[30];'
      '              UserDef7  : String[30];'
      '              UserDef8  : String[30];'
      '              UserDef9  : String[30];'
      '              UserDef10 : String[30];')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 5
  end
  object Button1: TButton
    Left = 366
    Top = 589
    Width = 383
    Height = 25
    Caption = '<< Import Delphi Fields'
    TabOrder = 6
    OnClick = Button1Click
  end
  object edtConnectionString: TComboBox
    Left = 83
    Top = 36
    Width = 761
    Height = 21
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 1
    Text = 
      'Provider=SQLOLEDB.1;Data Source=L008743\;Initial Catalog=Exch70C' +
      'onv;User Id=ADM1005MAIN01036;Password=*mL17A9E8F048A48479F95FB8E' +
      'EB67;OLE DB Services=-2'
    Items.Strings = (
      
        'Provider=SQLOLEDB.1;Data Source=L008743\;Initial Catalog=Exch70C' +
        'onv;User Id=Exch70Conv_ADMIN;Password=*zN33D1F18FAB1E7458DB02B45' +
        'C4B2'
      
        'Provider=SQLOLEDB.1;Data Source=L008743\;Initial Catalog=Exch70C' +
        'onv;User Id=ADM1005MAIN01036;Password=*mL17A9E8F048A48479F95FB8E' +
        'EB67;OLE DB Services=-2')
  end
  object chkCompareQuery: TCheckBox
    Left = 1138
    Top = 611
    Width = 97
    Height = 17
    Caption = 'Compare Query'
    TabOrder = 10
  end
  object btnOneOff: TButton
    Left = 756
    Top = 609
    Width = 79
    Height = 22
    Caption = 'One Off'
    TabOrder = 9
    OnClick = btnOneOffClick
  end
  object chkInsertCode: TCheckBox
    Left = 1031
    Top = 612
    Width = 103
    Height = 17
    Caption = 'Gen Insert Code'
    Checked = True
    State = cbChecked
    TabOrder = 11
  end
  object ServerTxt: TEdit
    Left = 192
    Top = 12
    Width = 217
    Height = 21
    TabOrder = 12
    Text = 'P007613\IRISEXCHEQUER'
  end
  object DatabaseTxt: TEdit
    Left = 472
    Top = 12
    Width = 121
    Height = 21
    TabOrder = 13
    Text = 'EXCHEQUER'
  end
  object BuildConnectionStringBtn: TButton
    Left = 604
    Top = 12
    Width = 129
    Height = 21
    Caption = 'Build connection string'
    TabOrder = 14
    OnClick = BuildConnectionStringBtnClick
  end
  object PopupMenu1: TPopupMenu
    Left = 368
    Top = 120
    object mnuDeleteSQLColumns: TMenuItem
      Caption = 'Delete Table Columns'
      OnClick = mnuDeleteSQLColumnsClick
    end
  end
end
