Unit halcn4ip;
{Here is a unit to allow Halcyon to be used with InfoPower. You also
need to have InfoPower 3.01 or later.  This can be downloaded from
the Woll2Woll website at http://www.woll2woll.com}

Interface
uses
  SysUtils, 
  WinTypes,
  WinProcs,
  Classes,
  wwtypes,
  {HalcnDb;}      {Use this for Halcyon 5}
  Halcn6Db;     {Use this for Halcyon 6}

Type
  TwwHalcyonDataSet =  class( THalcyonDataSet )
    Private
      FControlType    : TStrings;
      FPictureMasks   : TStrings;
      FUsePictureMask : boolean;
      FOnInvalidValue : TwwInvalidValueEvent;

      Function GetControlType : TStrings;
      Procedure SetControlType( sel : TStrings );
      Function GetPictureMasks : TStrings;
      Procedure SetPictureMasks( sel : TStrings );

    Protected
      Procedure DoBeforePost; Override; { For picture support }

    Public
      Constructor Create( AOwner : TComponent ); Override;
      Destructor Destroy; Override;

    Published
      Property ControlType : TStrings
        Read  GetControlType
        Write setControltype;
      Property PictureMasks: TStrings
        Read GetPictureMasks
        Write SetPictureMasks;
      Property ValidateWithMask : boolean
        Read FUsePictureMask
        Write FUsePictureMask;
      Property OnInvalidValue: TwwInvalidValueEvent
        Read FOnInvalidValue
        Write FOnInvalidValue;
  end;

Procedure Register;

implementation
uses
  wwcommon,
  dbconsts;


Constructor TwwHalcyonDataSet.create( AOwner : TComponent );
begin
  inherited Create( AOwner );
  FControlType    := TStringList.create;
  FPictureMasks   := TStringList.create;
  FUsePictureMask := True;
end;


Destructor TwwHalcyonDataSet.Destroy;
begin
  FControlType.Free;
  FPictureMasks.Free;
  FPictureMasks:= NIL;
  Inherited Destroy;
end;


Function TwwHalcyonDataSet.GetControltype : TStrings;
begin
  Result := FControlType;
end;


Procedure TwwHalcyonDataSet.SetControlType( sel : TStrings );
begin
  FControlType.Assign( sel );
end;


Function TwwHalcyonDataSet.GetPictureMasks : TStrings;
begin
  Result:= FPictureMasks
end;


Procedure TwwHalcyonDataSet.SetPictureMasks( sel : TStrings );
begin
  FPictureMasks.Assign( sel );
end;

Procedure TwwHalcyonDataSet.DoBeforePost;
begin
  Inherited DoBeforePost;
  if FUsePictureMask then
    wwValidatePictureFields( self, FOnInvalidValue );
end;


Procedure Register;
begin
  RegisterComponents('IP Access', [TwwHalcyonDataSet] );
end;


end.



