unit InhAbstr;

interface

Type
  cuStr4 = String[4];

  {---------------------------------------------------------------------------}

  // Base Abstract Object
  TAbsCustomerSub = Class(TObject)
  Protected
    Function GetField1 : cuStr4; Virtual; Abstract;
  Public
    Property Field1 : cuStr4 Read GetField1;
  End; { TAbsCustomerSub }

  // Descendant Object
  TAbsCustomerSub01 = Class(TAbsCustomerSub)
  Protected
    Function GetField2 : cuStr4; Virtual; Abstract;
    Procedure SetField2 (Value : cuStr4); Virtual; Abstract;
  Public
    Property Field2 : cuStr4 Read GetField2 Write SetField2;
  End; { TAbsCustomerSub01 }

  {---------------------------------------------------------------------------}

  // Base Abstract Object
  TAbsCustomer = Class(TObject)
  Protected
    Function GetField1 : cuStr4; Virtual; Abstract;
    Procedure SetField1 (Value : cuStr4); Virtual; Abstract;
  Public
    Property Field1 : cuStr4 Read GetField1 Write SetField1;
  End; { TAbsCustomer }

  // Descendant Object
  TAbsCustomer01 = Class(TAbsCustomer)
  Protected
    Function GetField2 : cuStr4; Virtual; Abstract;
    Procedure SetField2 (Value : cuStr4); Virtual; Abstract;
  Public
    Property Field2 : cuStr4 Read GetField2 Write SetField2;
  End; { TAbsCustomer01 }

  // Descendant Object
  TAbsCustomer02 = Class(TAbsCustomer01)
  Protected
    Function GetSubClass : TAbsCustomerSub; Virtual; Abstract;
  Public
    Property SubClass : TAbsCustomerSub Read GetSubClass;
  End; { TAbsCustomer02 }

  // Descendant Object
  TAbsCustomer03 = Class(TAbsCustomer02)
  Protected
    Function GetSubClass01 : TAbsCustomerSub01; Virtual; Abstract;
  Public
    Property SubClass : TAbsCustomerSub01 Read GetSubClass01;
  End; { TAbsCustomer03 }

  {---------------------------------------------------------------------------}

  // Abstract Definition
  TAbsEnterpriseSystem = Class(TObject)
  Protected
    Function GetCustomer : TAbsCustomer; Virtual; Abstract;
  Public
    Property Customer : TAbsCustomer Read GetCustomer;     { Customer Details }
  End; { TAbsEnterpriseSystem01 }

  // Descendant Object
  TAbsEnterpriseSystem01 = Class(TAbsEnterpriseSystem)
  Protected
    Function GetCustomer01 : TAbsCustomer01; Virtual; Abstract;
  Public
    Property Customer : TAbsCustomer01 Read GetCustomer01;     { Customer Details }
  End; { TAbsEnterpriseSystem01 }

  // Descendant Object
  TAbsEnterpriseSystem02 = Class(TAbsEnterpriseSystem01)
  Protected
    Function GetCustomer02 : TAbsCustomer02; Virtual; Abstract;
  Public
    Property Customer : TAbsCustomer02 Read GetCustomer02;     { Customer Details }
  End; { TAbsEnterpriseSystem02 }

  // Descendant Object
  TAbsEnterpriseSystem03 = Class(TAbsEnterpriseSystem02)
  Protected
    Function GetCustomer03 : TAbsCustomer03; Virtual; Abstract;
  Public
    Property Customer : TAbsCustomer03 Read GetCustomer03;     { Customer Details }
  End; { TAbsEnterpriseSystem03 }

  {---------------------------------------------------------------------------}


implementation

end.
