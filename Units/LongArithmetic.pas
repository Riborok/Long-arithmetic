unit LongArithmetic;
{
 Large numbers calculator in different number systems.
 Important! For correct calculations, the numbers must be
 in the same number system and be equal to the formal variable NS
}

interface

Type
  TNumber = Array of SmallInt;
  TNumberAndSign = record
    Number: TNumber;
    isPositive: Boolean;
  end;
  TDivision = record
    Quotient, Remainder :TNumber;
  end;
  //TNumber - type for long numbers
  //TNumberAndSign - the type that stores a number and its sign as a boolean variable
  //TDivision - type for quotient and remainder after division

Const
  NSAlphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  //NSAlphabet - transfer between symbols and numbers




//Function to input a number in the number system NS (the number is written mirrored)
Function InputNum(NS: Byte): TNumber;

//Function to output a number (mirroring back)
Procedure OutputNum(Number: TNumber; isPositive: boolean);

//Function calculates the sum of two numbers in the number system NS
Function NumbersSum(FirstNum, SecondNum: TNumber; NS: Byte): TNumber;

{Function calculates the difference of two numbers in the number system NS.
Important! Returns the difference and its sign as a boolean variable.
If necessary, it is possible to return the result modulo, by writting
NumbersDifference(FirstNum, SecondNum: TNumber; NS: Byte).Number)}
Function NumbersDifference(FirstNum, SecondNum: TNumber; NS: Byte): TNumberAndSign;

//Function calculates the product of two numbers in the number system NS
Function NumbersProduct(FirstNum, SecondNum: TNumber; NS: Byte): TNumber;

//Function calculates quotient and remainder after division two numbers in the number system NS
Function NumbersDivision(Dividend, Divider: TNumber; NS: Byte): TDivision;

implementation

//Function to input a number in the number system NS (the number is written mirrored)
Function InputNum(NS: Byte): TNumber;
var
  Num: TNumber;
  i, Len: LongInt;
  str: string;
  IsCorrect: boolean;
  //Num - the resulting number
  //i - cycle counter
  //Len - number length
  //Str - number in string form
  //IsCorrect - flag to confirm the correctness of entering numbers
begin

  //Cycle with postcondition for entering correct data.
  Repeat

    //Initialize the IsCorrect
    IsCorrect:= True;

    //Read the entered number and check for correctness.
    Readln(str);

    //Find length of the first number
    Len:= length(str);

    //Else if length >1, the first digit cannot be 0
    if (Len > 1) and (str[1] = '0') then
    begin
      Writeln('Wrong input of number! The first digit of a number cannot be 0. Try again');
      IsCorrect:= False;
    end

    //Else writing a number to an array and checking for valid symbols
    else
    begin

      //Set the length of the number
      SetLength(Num, Len);

      //Write the first entered number in mirrored view to an array
      i:= Low(Num);
      while (i <= Len-1) and IsCorrect do
      begin

        //Transfer to numerical value (-1 because numbering in delphi starts from 1)
        Num[i]:= Pos(str[Len-i], NSAlphabet) - 1;

        //Checking for correct input in the number system
        //Num[i] will be <0 if the symbol is not in NSAlphabet
        if (Num[i] < 0) or (Num[i] >= NS) then
        begin
          Writeln('Wrong input of number! Namely, wrong input of symbols! See available symbols above! Try again');
          IsCorrect:= False;
        end;

        //Modernize i
        i:= i + 1;
      end;

    end;

  Until IsCorrect;

  //Return the result
  Result:= Num;
end;



//Function to output a number (mirroring back)
Procedure OutputNum(Number: TNumber; isPositive: boolean);
var
  i: LongInt;
  //i - cycle counter
begin

  //Check for minus
  if not isPositive then
    Write('-');

  //Write out the number, mirroring back
  for i := High(Number) downto Low(Number) do
    Write(NSAlphabet[Number[i]+1]);
end;



//Function returns true if the first number is greater than the second, otherwise false
Function PartFirstNumIsGreater (FirstNum, SecondNum: TNumber; CheckUpToElOfFirstNum: LongInt): Boolean;
Var
  i, j : LongInt;
  isTrue : Boolean;
  //i, j - cycle counter
  //isTrue - function result
begin

  //Assume it's true
  isTrue:= True;

  //Initialize j
  j:= High(SecondNum);

  //Starting from the last digits (in the mirrored it is first), compare them
  for i := High(FirstNum) downto CheckUpToElOfFirstNum do
  begin

    //If FirstNum > SecondNum, then it's true. Exiting the cycle
    if FirstNum[i] > SecondNum[j] then
      break

    //If SecondNum > FirstNum, then it's not true(false). Exiting the cycle
    else if SecondNum[j] > FirstNum[i] then
    begin
      isTrue:= not isTrue;
      break;
    end;

    j:= j - 1;
  end;

  //Return the result
  Result:= isTrue;
end;

//Function finds the largest size
Function LargerSize(Len1, Len2: LongInt): LongInt;
begin
  if Len1 > Len2 then
    Result:= Len1
  else
    Result:= Len2;
end;

//Function makes a suitable length for a smaller number
Function MakeSuitableLength(Num: TNumber; NewLen: LongInt): TNumber;
Var
  i, OldLen: LongInt;
  //i - cycle counter
  //OldLen - old length
begin

  //Initialize OldLen
  OldLen:= length(Num);

  //Set new array length
  SetLength(Num, NewLen);

  //Null to the last element
  for  i:= OldLen to NewLen-1 do
    Num[i]:= 0;

  //Return the result
  Result:= Num;
end;



//Function finds FirstTerm + SecondTerm
Function Plus(FirstTerm, SecondTerm: TNumber; StartElTerm: LongInt; NS: Byte): TNumber;
Var
  i, Len: LongInt;
  DigitsSum, Carry : Byte;
  //i - cycle counter
  //Len - length for Result
  //DigitsSum - sum of digits
  //Carry - ñarry to the next element
begin

  //Finds the largest size (length for Result)
  Len:= LargerSize(Length(FirstTerm), Length(SecondTerm));

  //Make a suitable length for a smaller number (if there is a smaller number)
  if Len <> Length(FirstTerm) then
    FirstTerm:= MakeSuitableLength(FirstTerm, Len)
  else if Len <> Length(SecondTerm) then
    SecondTerm:= MakeSuitableLength(SecondTerm, Len);

  //Resetting the Carry
  Carry:= 0;

  //Start adding digits separately in the cycle
  for i := StartElTerm to Len-1 do
  begin

    //Starting to add the last digits of the numbers (in the mirrored view it is first)
    //and add the carry (if there is).
    DigitsSum:= FirstTerm[i] + SecondTerm[i] + Carry;

    //DigitsSum mod NS is the last (in the mirrored it is first) digit of Result
    FirstTerm[i]:= DigitsSum mod NS;

    //DigitsSum div NS is the carry that will go to the next element
    Carry:= DigitsSum div NS;

    //If there is a carry on the last digit, then increase the size of Result by 1
    //and add a carry to the next element
    if (i = Len-1) and (Carry = 1) then
    begin
      Len:= Len + 1;
      SetLength(FirstTerm, Len);
      FirstTerm[i+1]:= Carry;
    end;

  end;

  //Return the result
  Result:= FirstTerm;
end;

//Function calculates the sum of two numbers in the number system NS
Function NumbersSum(FirstNum, SecondNum: TNumber; NS: Byte): TNumber;
begin
  Result:= Plus(FirstNum, SecondNum, Low(FirstNum), NS);
end;



//Function finds Reduced - Subtracted (Reduced >= Subtracted)
Function Minus(Reduced, Subtracted: TNumber; StartElReduced: LongInt; NS: Byte): TNumber;
Var
  i, j: LongInt;
  DigitsDifference, Carry: ShortInt;
  //i, j - cycle counter
  //DigitsDifference - the difference of digits
  //Carry - ñarry to the next element
begin

  //The length of the reduced and the subtrahend must be the same
  if Length(Reduced) - StartElReduced <> Length(Subtracted) then
    Subtracted:= MakeSuitableLength(Subtracted, Length(Reduced) - StartElReduced);

  //Resetting the Carry
  Carry:= 0;

  //Initial i
  i:= Low(Subtracted);

  //Start subtract digits separately in the cycle
  for j:= StartElReduced to High(Reduced) do
  begin

    //Starting to subtract the last digits of the numbers (in the mirrored view it is first)
    //and consider the carry (if there is).
    DigitsDifference:= Reduced[j] - Subtracted[i] + Carry;

    //If the difference is less than zero, then take 1 (for the current digit it is NS)
    //from the next digit
    if DigitsDifference < 0 then
    begin
      DigitsDifference:= DigitsDifference + NS;
      Carry:= -1;
    end
    //Else carry = 0
    else
      Carry:= 0;

    //Put the result in the residual array Result
    Reduced[j]:= DigitsDifference;

    //Modernize j
    i:= i + 1;
  end;

  //Looking for non-significant digits
  //(zeros at the end (in the mirrored view it is the beginning) of the number)
  i:= High(Reduced);
  while i >= StartElReduced do
  begin
    if Reduced[i] > 0 then
      break;
    Dec(i);
  end;

  //If the answer is 0, put the last index 0 (the length will be 1)
  if i < 0 then
    i:= 0;

  //Set length only with significant digits
  SetLength(Reduced, i+1);

  //Return the result
  Result:= Reduced;

end;

{Function calculates the difference of numbers.
Important! Returns the difference and its sign as a boolean variable.
If necessary, it is possible to return the result modulo, by writting
NumbersDifference(FirstNum, SecondNum: TNumber; NS: Byte).Number)}
Function NumbersDifference(FirstNum, SecondNum: TNumber; NS: Byte): TNumberAndSign;
begin

  //Determine which number is greater
  //and the corresponding find the difference of numbers and the sign
  if (Length(FirstNum) > Length(SecondNum)) or
     ((Length(FirstNum) = Length(SecondNum)) and PartFirstNumIsGreater(FirstNum, SecondNum, Low(FirstNum))) then
  begin
    Result.Number:= Minus(FirstNum, SecondNum, Low(FirstNum), NS);
    Result.isPositive:= True;
  end
  else
  begin
    Result.Number:= Minus(SecondNum, FirstNum, Low(SecondNum), NS);
    Result.isPositive:= False;
  end;

end;



//Function calculates the product of two numbers in the number system NS
Function NumbersProduct(FirstNum, SecondNum: TNumber; NS: Byte): TNumber;
var
  ProductResult : array of TNumber;
  i, j, PosElement: LongInt;
  DigigtsProd: Word;
  CarryProd: Byte;
  //ProductResult - a 2D array to calculate the product. 0 index stores the answer, and 1 intermediate calculations
  //i, j - cycle counter
  //PosElement - the current position of the element in the multiplication
  //DigigtsProd - product of the digits of the first and second number
  //CarryProd - ñarry the digit (if there is) to the next element (for DigigtsProd)
begin

  //Set approximate length for ProductResult
  SetLength(ProductResult, 2, length(FirstNum)+length(SecondNum));

  //Reset carry
  CarryProd:= 0;

  //Multiply the digits of the first number by the second number
  for i := Low(SecondNum) to High(SecondNum) do
  begin
    for j := Low(FirstNum) to High(FirstNum) do
    begin

      //Ñalculate at what position in the multiplication the element now
      PosElement:= j + i;

      //Starting to multiply the last digits of the numbers (in the mirrored view it is first)
      //and add the carry (if there is).
      DigigtsProd:= FirstNum[j] * SecondNum[i] + CarryProd;

      //The integer part of dividing by NS is the carry that will go to the next element
      CarryProd:= DigigtsProd div NS;

      //DigigtsSum mod NS is the digit in the ProductResult
      ProductResult[1, PosElement] := DigigtsProd mod NS;

    end;

    //If there is a carry on the last digit of the second number, then insert a carry to the next element
    if (CarryProd >= 1) then
    begin

      //ProductResult in the next element is equal to the carry, since this element is new for multiplied
      ProductResult[1, PosElement+1]:=CarryProd;

      //Carry is assigned 0 for the next iterations
      CarryProd:=0;
    end;

    //Add the current answer with the intermediate calculation (starting with i using the column multiplication method)
    ProductResult[0]:= Plus(ProductResult[0], ProductResult[1], i, NS);
  end;

  //If a digit is inserted after PosElement, increase PosElement
  if ProductResult[0, PosElement+1] > 0 then
    PosElement:= PosElement + 1;

  //If the product is 0, then the length will be 1.
  if ProductResult[0, PosElement] = 0 then
    SetLength(ProductResult[0], 1)

  //Else set the calculated length for ProductResult
  else
  SetLength(ProductResult[0], PosElement+1);

  //Return the result
  Result:= ProductResult[0];
end;



//Function calculates quotient and remainder after division two numbers in the number system NS
Function NumbersDivision(Dividend, Divider: TNumber; NS: Byte): TDivision;
var
  Quotient: TNumber;
  CurrElInQuotient, CurrPosInDividend, i, k : LongInt;
  ResultDiv : Byte;
  //Quotient - quotient of two numbers
  //CurrElInQuotient - the current element in the quotient
  //CurrPosInDividend - current position in the dividend (CurrPosInDividend..High(Dividend) - part of the dividend which will divide)
  //i, k - cycle counter
  //ResultDiv - the result of dividing a part of the dividend
begin

  //Set approximate length for Quotient
  SetLength(Quotient, length(Dividend));

  //Initialize the variables (considering that they are written in mirrored view)
  CurrElInQuotient:= -1; //-1 since at the beginning of the cycle will add 1
  CurrPosInDividend:= High(Dividend) - High(Divider) + 1; //+1 since at the beginning of the cycle will decrease by 1

  //In the first iteration, the part of the dividend must be greater than Divider
  if not PartFirstNumIsGreater(Dividend, Divider, CurrPosInDividend - 1) then
    CurrPosInDividend:= CurrPosInDividend - 1;

  //Result check: numerator remainder must be < denominator
  while (Length(Dividend) > Length(Divider)) or
        ((Length(Dividend) = Length(Divider)) and PartFirstNumIsGreater(Dividend, Divider, Low(Dividend))) do
  begin

    //Remove unnecessary zeros in the numerator (if there is)
    k:= 0;
    for i := High(Dividend) downto CurrPosInDividend do
    begin

      //If non-zero is found, exit the cycle
      if (Dividend[i] > 0) then
        break

      //Otherwise, find the amount of unnecessary zeros
      else
        k:= k + 1;
    end;

    //Reduce the length Dividend in accordance with the found unnecessary zeros
    SetLength(Dividend, length(Dividend)-k);

    //Also reduce CurrPosInDividend, if there is (one time less than CurrPosEl to maintain the logic of division into a column)
    //And for the new iteration take out the next digit
    if k > 0 then
      k:= k - 1;
    CurrPosInDividend:= CurrPosInDividend - 1 - k;

    //Initialize the variables
    CurrElInQuotient:= CurrElInQuotient+1;
    ResultDiv:= 0;

    //While the part of the dividend is greater than the divisor, find the result of the division
    while (Length(Dividend) - CurrPosInDividend > Length(Divider)) or
          ((Length(Dividend) - CurrPosInDividend = Length(Divider))
          and PartFirstNumIsGreater(Dividend, Divider, CurrPosInDividend)) do
    begin
      //Subtract find the result
      Dividend:= Minus(Dividend, Divider, CurrPosInDividend, NS);
      ResultDiv:= ResultDiv + 1;
    end;

    //Write the result of the current element in quotient
    Quotient[CurrElInQuotient]:= ResultDiv;
  end;

  //Ñount the final length of the quotient (ñonsidering division method)
  CurrElInQuotient:= CurrElInQuotient + CurrPosInDividend + 1;

  //If initially the divisor was greater than the dividend, set the length of the quotient 1
  if CurrElInQuotient <= 0 then
    CurrElInQuotient:= 1;

  //Set the length
  SetLength(Quotient, CurrElInQuotient);

  //Since in the division method the answer is written in the normal form, mirror it
  for i := Low(Quotient) to Length(Quotient) div 2 - 1 do
  begin
    Quotient[i]:= Quotient[i] xor Quotient[High(Quotient) - i];
    Quotient[High(Quotient) - i]:= Quotient[i] xor Quotient[High(Quotient) - i];
    Quotient[i]:= Quotient[i] xor Quotient[High(Quotient) - i];
  end;

  //Return the result
  Result.Quotient:= Quotient;
  Result.Remainder:= Dividend;
end;




end.
