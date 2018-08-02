
Type

  {Temporary file for Transaction Conversion record structure, to be used until
  I incorporate it into exchdll.ini}


{TBatchConvRec = Record
  DocFrom    :  String[10];
  DocTo      :  String[10];
  DocToType  :  String[3];
  Status     :  SmallInt;
  Spare      :  Array[1..199] of Byte;
  LastChar   :  Char;
end;}

{TBatchB2BRec = Record
  bbMultipleSuppliers    :  WordBool;  //take suppliers from stock record
  bbIncludeNormalLines   :  WordBool;  //line types to include
  bbIncludeLabourLines   :  WordBool;
  bbIncludeMaterialLines :  WordBool;
  bbIncludeFreightLines  :  WordBool;
  bbIncludeDiscountLines :  WordBool;
  bbQtyMode              :  SmallInt; //0 - original order qty, 1 - qty delivered, 2 - max stock level, 3 - stock picked
  bbSuppCode             :  String[10]; //used if not suppliers from stock or if a stock code has no supplier
  bbAutoPick             :  WordBool; //Auto pick order when POR received
  Spare      :  Array[1..199] of Byte;
  LastChar   :  Char;
end;}

