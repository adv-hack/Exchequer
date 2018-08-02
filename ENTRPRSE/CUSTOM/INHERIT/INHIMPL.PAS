unit InhImpl;

interface

Uses InhAbstr;

Type
  {---------------------------------------------------------------------------}

  // Implementation of Abstract Object
  TCustomerSub = Class(TAbsCustomerSub01)
  Private
    F1 : cuStr4;
    F2 : cuStr4;
  Protected
    Function GetField1 : cuStr4; Override;

    Function GetField2 : cuStr4; Override;
    Procedure SetField2 (Value : cuStr4); Override;
  Public
    Constructor Create;
  End; { TCustomerSub }

  {---------------------------------------------------------------------------}

  // Implementation of Abstract Customer
  TCustomer = Class(TAbsCustomer03)
  Private
    F1 : cuStr4;
    F2 : cuStr4;

    FSubClass : TCustomerSub;
  Protected
    Function GetField1 : cuStr4; Override;
    Procedure SetField1 (Value : cuStr4); Override;

    Function GetField2 : cuStr4; Override;
    Procedure SetField2 (Value : cuStr4); Override;

    Function GetSubClass : TAbsCustomerSub; Override;
    Function GetSubClass01 : TAbsCustomerSub01; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; { TCustomer }

  {---------------------------------------------------------------------------}

  // Actual Implementation
  TEnterpriseSystem = Class(TAbsEnterpriseSystem03)
  Private
    FCustomer : TCustomer;
  Protected
    Function GetCustomer : TAbsCustomer; Override;
    Function GetCustomer01 : TAbsCustomer01; Override;
    Function GetCustomer02 : TAbsCustomer02; Override;
    Function GetCustomer03 : TAbsCustomer03; Override;
  Public
    Constructor Create;
    Destructor  Destroy; Override;
  End; { TEnterpriseSystem }

  {---------------------------------------------------------------------------}

implementation


{---------------------------------------------------------------------------}

Constructor TCustomerSub.Create;
Begin { Create }
  F1 := 'Fld1';
  F2 := 'Fld2';
End; { Create }

Function TCustomerSub.GetField1 : cuStr4;
Begin { GetField1 }
  Result := F1;
End; { GetField1 }

Function TCustomerSub.GetField2 : cuStr4;
Begin { GetField2 }
  Result := F2;
End; { GetField2 }

Procedure TCustomerSub.SetField2 (Value : cuStr4); 
Begin { SetField2 }
  F2 := Value;
End; { SetField2 }

{---------------------------------------------------------------------------}

Constructor TCustomer.Create;
Begin { Create }
  Inherited Create;

  F1 := 'Fld1';
  F2 := 'Fld2';

  FSubClass := TCustomerSub.Create;
End; { Create }

Destructor TCustomer.Destroy;
Begin { Destroy }
  FSubClass.Destroy;

  Inherited Destroy;
End; { Destroy }

Function TCustomer.GetField1 : cuStr4;
Begin { GetField1 }
  Result := F1;
End; { GetField1 }

Procedure TCustomer.SetField1 (Value : cuStr4);
Begin { SetField1 }
  F1 := Value;
End; { SetField1 }

Function TCustomer.GetField2 : cuStr4;
Begin { GetField2 }
  Result := F2;
End; { GetField2 }

Procedure TCustomer.SetField2 (Value : cuStr4);
Begin { SetField2 }
  F2 := Value;
End; { SetField2 }

Function TCustomer.GetSubClass : TAbsCustomerSub;
Begin { GetSubClass }
  Result := FSubClass;
End; { GetSubClass }

Function TCustomer.GetSubClass01 : TAbsCustomerSub01; 
Begin { GetSubClass01 }
  Result := FSubClass;
End; { GetSubClass01 }

{---------------------------------------------------------------------------}

Constructor TEnterpriseSystem.Create;
Begin { Create }
  Inherited Create;

  FCustomer := TCustomer.Create;
End; { Create }

Destructor TEnterpriseSystem.Destroy;
Begin { Destroy }
  FCustomer.Destroy;

  Inherited Destroy;
End; { Destroy }

// NOTE: Called if using TAbsEnterpriseSystem
Function TEnterpriseSystem.GetCustomer : TAbsCustomer;
Begin { GetCustomer }
  Result := FCustomer;
End; { GetCustomer }

// NOTE: Called if using TAbsEnterpriseSystem01
Function TEnterpriseSystem.GetCustomer01 : TAbsCustomer01;
Begin { GetCustomer01 }
  Result := FCustomer;
End; { GetCustomer01 }

// NOTE: Called if using TAbsEnterpriseSystem02
Function TEnterpriseSystem.GetCustomer02 : TAbsCustomer02;
Begin { GetCustomer02 }
  Result := FCustomer;
End; { GetCustomer02 }

// NOTE: Called if using TAbsEnterpriseSystem03
Function TEnterpriseSystem.GetCustomer03 : TAbsCustomer03;
Begin { GetCustomer03 }
  Result := FCustomer;
End; { GetCustomer03 }

{---------------------------------------------------------------------------}

end.
