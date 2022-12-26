unit LongArithmetic;
{
 Large numbers calculator in different number systems.

 The unit works with a recorder that stores the value of a number and its sign
 (in the form of a boolean variable). All operations correspond to the logic of signs.

 Important! For correct calculations, the numbers must be
 in the same number system and be equal to the formal variable NS.
}

interface

Type
  TNumber = Array of SmallInt;
  TNumberAndSign = record
    Number: TNumber;
    isPositive: Boolean;
  end;
  TDivision = record
    Quotient, Remainder :TNumberAndSign;
  end;
  //TNumber - type for long numbers
  //TNumberAndSign - the type that stores a number and its sign as a boolean variable
  //TDivision - type for quotient and remainder after division

Const
  NSAlphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  //NSAlphabet - transfer between symbols and numbers




//Function to input a number in the number system NS (the number is written mirrored)
Function InputNum(NS: Byte): TNumberAndSign;

//Function to output a number (mirroring back)
Procedure OutputNum(Number: TNumberAndSign);

//Function calculates the sum of two numbers in the number system NS
Function NumbersSum(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;

//Function calculates the difference of two numbers in the number system NS
Function NumbersDifference(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;

//Function calculates the product of two numbers in the number system NS
Function NumbersProduct(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;

//Function calculates quotient and remainder after division two numbers in the number system NS
//Division by zero is not provided in the unit!
Function NumbersDivision(Dividend, Divider: TNumberAndSign; NS: Byte): TDivision;

implementation

//Function to input a number in the number system NS (the number is written mirrored)
Function InputNum(NS: Byte): TNumberAndSign;
var
  i, Len: LongInt;
  str: string;
  IsCorrect: boolean;
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

    //Determine the sign of a number
    if str[1] = '-' then
    begin
      Result.isPositive:= False;

      //Since the first sybmol is a minus, reduce the length
      Len:= Len - 1;
    end
    else
      Result.isPositive:= True;

    //Else if length > 1 or the number is written with a minus, the first digit cannot be 0
    if (((Len > 1) or not Result.isPositive) and (str[length(str) - Len + 1] = '0')) then
    begin
      Writeln('Wrong input of number! The first digit of a number cannot be 0. Try again');
      IsCorrect:= False;
    end

    //Else writing a number to an array and checking for valid symbols
    else
    begin

      //Set the length of the number
      SetLength(Result.Number, Len);

      //Write the first entered number in mirrored view to an array
      i:= Low(Result.Number);
      while (i <= High(Result.Number)) and IsCorrect do
      begin

        //Transfer to numerical value (-1 because numbering in delphi starts from 1)
        Result.Number[i]:= Pos(str[length(str)-i], NSAlphabet) - 1;

        //Checking for correct input in the number system
        //Num[i] will be <0 if the symbol is not in NSAlphabet
        if (Result.Number[i] < 0) or (Result.Number[i] >= NS) then
        begin
          Writeln('Wrong input of number! Namely, wrong input of symbols! See available symbols above! Try again');
          IsCorrect:= False;
        end;

        //Modernize i
        i:= i + 1;
      end;

    end;

  Until IsCorrect;

end;



//Function to output a number (mirroring back)
Procedure OutputNum(Number: TNumberAndSign);
var
  i: LongInt;
  //i - cycle counter
begin

  //Check for minus
  if not Number.isPositive then
    Write('-');

  //Write out the number, mirroring back
  for i := High(Number.Number) downto Low(Number.Number) do
    Write(NSAlphabet[Number.Number[i]+1]);
end;



//Function returns true if the first number is greater than the second, otherwise false
Function PartFirstNumIsGreater (FirstNum, SecondNum: TNumber; CheckUpToElOfFirstNum: LongInt): Boolean;
Var
  i, j : LongInt;
  //i, j - cycle counter
begin

  //Assume it's true
  Result:= True;

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
      Result:= not Result;
      break;
    end;

    j:= j - 1;
  end;

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



//Function finds FirstTerm + SecondTerm (starting from StartElFisrtTerm in the FirstTerm). The answer is written in the FirstTerm
Function Plus(FirstTerm, SecondTerm: TNumber; StartElFisrtTerm: LongInt; NS: Byte): TNumber;
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
  for i := StartElFisrtTerm to Len-1 do
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
Function NumbersSum(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;
begin

  //Determine the operation:
  //if two numbers have the same sign, then find the sum. The sign is determined by the first number
  if FirstNum.isPositive = SecondNum.isPositive then
  begin
    Result.isPositive:= FirstNum.isPositive;
    Result.Number:= Plus(FirstNum.Number, SecondNum.Number, Low(FirstNum.Number), NS);
  end

  //Else find a negative number and using the NumbersDifference function find their difference and sign
  else
  begin
    if not SecondNum.isPositive then
    begin
      SecondNum.isPositive:= True;
      Result:= NumbersDifference(FirstNum, SecondNum, NS);
    end
    else
    begin
      FirstNum.isPositive:= True;
      Result:= NumbersDifference(SecondNum, FirstNum, NS);
    end;
  end;
end;



//Function finds Reduced - Subtracted (starting from StartElReduced in the Reduced). The answer is written in the Reduced
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

//Function calculates the difference of two numbers in the number system NS
Function NumbersDifference(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;
begin

  //Determine the operation:
  //If two numbers have different signs, then add them. The sign is determined by the first number
  if FirstNum.isPositive xor SecondNum.isPositive then
  begin
    Result.isPositive:= FirstNum.isPositive;
    Result.Number:= Plus(FirstNum.Number, SecondNum.Number, Low(FirstNum.Number), NS);
  end

  //Else find a larger number and also determine the sign by the first number
  else
  begin
    if (Length(FirstNum.Number) > Length(SecondNum.Number)) or
       ((Length(FirstNum.Number) = Length(SecondNum.Number))
       and PartFirstNumIsGreater(FirstNum.Number, SecondNum.Number, Low(FirstNum.Number))) then
    begin
      Result.Number:= Minus(FirstNum.Number, SecondNum.Number, Low(FirstNum.Number), NS);
      Result.isPositive:= FirstNum.isPositive;
    end
    else
    begin
      Result.Number:= Minus(SecondNum.Number, FirstNum.Number, Low(SecondNum.Number), NS);
      Result.isPositive:= not FirstNum.isPositive;
    end;
  end;

  //If the answer is 0, then the sign will be a plus
  if Result.Number[High(Result.Number)] = 0 then
    Result.isPositive:= True;

end;



//Function calculates the product of two numbers in the number system NS
Function NumbersProduct(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;
var
  IntermediateCalc : TNumber;
  i, j, PosElement: LongInt;
  DigigtsProd: Word;
  CarryProd: Byte;
  //IntermediateCalc - intermediate calculations
  //i, j - cycle counter
  //PosElement - the current position of the element in the multiplication
  //DigigtsProd - product of the digits of the first and second number
  //CarryProd - ñarry the digit (if there is) to the next element (for DigigtsProd)
begin

  //Set the lengths
  SetLength(IntermediateCalc, length(FirstNum.Number)+length(SecondNum.Number));
  SetLength(Result.Number, length(FirstNum.Number)+length(SecondNum.Number));

  //Resetting the answer
  FillChar(Result.Number, SizeOf(Result.Number), 0);

  //Reset carry
  CarryProd:= 0;

  //Multiply the digits of the first number by the second number
  for i := Low(SecondNum.Number) to High(SecondNum.Number) do
  begin
    for j := Low(FirstNum.Number) to High(FirstNum.Number) do
    begin

      //Ñalculate at what position in the multiplication the element now
      PosElement:= j + i;

      //Starting to multiply the last digits of the numbers (in the mirrored view it is first)
      //and add the carry (if there is).
      DigigtsProd:= FirstNum.Number[j] * SecondNum.Number[i] + CarryProd;

      //The integer part of dividing by NS is the carry that will go to the next element
      CarryProd:= DigigtsProd div NS;

      //DigigtsSum mod NS is the digit in the ProductResult
      IntermediateCalc[PosElement] := DigigtsProd mod NS;

    end;

    //If there is a carry on the last digit of the second number, then insert a carry to the next element
    if (CarryProd >= 1) then
    begin

      //ProductResult in the next element is equal to the carry, since this element is new for multiplied
      IntermediateCalc[PosElement+1]:=CarryProd;

      //Carry is assigned 0 for the next iterations
      CarryProd:=0;
    end;

    //Add the current answer with the intermediate calculation (starting with i using the column multiplication method)
    Result.Number:= Plus(Result.Number, IntermediateCalc, i, NS);
  end;

  //If a digit is inserted after PosElement, increase PosElement
  if Result.Number[PosElement+1] > 0 then
    PosElement:= PosElement + 1;

  //If the product is 0, then the length will be 1.
  if Result.Number[PosElement] = 0 then
    SetLength(Result.Number, 1)

  //Else set the calculated length for Result
  else
  SetLength(Result.Number, PosElement+1);

  //Determine the sign. If the answer is 0, then the sign will be a plus
  if Result.Number[High(Result.Number)] = 0 then
    Result.isPositive:= True
  else
    Result.isPositive:= not (FirstNum.isPositive xor SecondNum.isPositive);
end;



//Function calculates quotient and remainder after division two numbers in the number system NS
//Division by zero is not provided in the unit!
Function NumbersDivision(Dividend, Divider: TNumberAndSign; NS: Byte): TDivision;
var
  CurrElInQuotient, CurrPosInDividend, i: LongInt;
  ResultDiv : Byte;
  //CurrElInQuotient - the current element in the quotient
  //CurrPosInDividend - current position in the dividend (CurrPosInDividend..High(Dividend) - part of the dividend which will divide)
  //i - cycle counter
  //ResultDiv - the result of dividing a part of the dividend
begin

  //Set approximate length for Quotient
  SetLength(Result.Quotient.Number, length(Dividend.Number));

  //Initialize the variables (considering that they are written in mirrored view)
  CurrElInQuotient:= -1; //-1 since at the beginning of the cycle will add 1
  CurrPosInDividend:= High(Dividend.Number) - High(Divider.Number) + 1; //+1 since at the beginning of the cycle will decrease by 1

  //In the first iteration, the part of the dividend must be greater than Divider
  if not PartFirstNumIsGreater(Dividend.Number, Divider.Number, CurrPosInDividend - 1) then
    CurrPosInDividend:= CurrPosInDividend - 1;

  //Result check: numerator remainder must be < denominator
  while (Length(Dividend.Number) > Length(Divider.Number)) or
        ((Length(Dividend.Number) = Length(Divider.Number))
        and PartFirstNumIsGreater(Dividend.Number, Divider.Number, Low(Dividend.Number))) do
  begin

    //Reduce CurrPosInDividend for the new iteration take out the next digit
    CurrPosInDividend:= CurrPosInDividend - 1;

    //Initialize the variables
    CurrElInQuotient:= CurrElInQuotient+1;
    ResultDiv:= 0;

    //If the current position in the dividend is the last element and that last element is 0, decrease the length by one
    if (CurrPosInDividend = High(Dividend.Number)) and (Dividend.Number[High(Dividend.Number)] = 0) then
      SetLength(Dividend.Number, length(Dividend.Number)-1)

    //Else while the part of the dividend is greater than the divisor, find the result of the division
    else
      while (Length(Dividend.Number) - CurrPosInDividend > Length(Divider.Number)) or
            ((Length(Dividend.Number) - CurrPosInDividend = Length(Divider.Number))
            and PartFirstNumIsGreater(Dividend.Number, Divider.Number, CurrPosInDividend)) do
      begin
        //Subtract find the result
        Dividend.Number:= Minus(Dividend.Number, Divider.Number, CurrPosInDividend, NS);
        ResultDiv:= ResultDiv + 1;
      end;

    //Write the result of the current element in quotient
    Result.Quotient.Number[CurrElInQuotient]:= ResultDiv;
  end;

  //Ñount the final length of the quotient (ñonsidering division method)
  CurrElInQuotient:= CurrElInQuotient + CurrPosInDividend + 1;

  //If initially the divisor was greater than the dividend, set the length of the quotient 1
  if CurrElInQuotient <= 0 then
    CurrElInQuotient:= 1;

  //Set the length
  SetLength(Result.Quotient.Number, CurrElInQuotient);

  //Since in the division method the answer is written in the normal form, mirror it
  for i := Low(Result.Quotient.Number) to Length(Result.Quotient.Number) div 2 - 1 do
  begin
    Result.Quotient.Number[i]:= Result.Quotient.Number[i] xor Result.Quotient.Number[High(Result.Quotient.Number) - i];
    Result.Quotient.Number[High(Result.Quotient.Number) - i]:= Result.Quotient.Number[i] xor Result.Quotient.Number[High(Result.Quotient.Number) - i];
    Result.Quotient.Number[i]:= Result.Quotient.Number[i] xor Result.Quotient.Number[High(Result.Quotient.Number) - i];
  end;

  //Return the remainder
  Result.Remainder.Number:= Dividend.Number;

  {Determine the signs}

  //If the answer is 0, then the sign will be a plus
  if Result.Quotient.Number[High(Result.Quotient.Number)] = 0 then
    Result.Quotient.isPositive:= True
  else
    Result.Quotient.isPositive:= not (Dividend.isPositive xor Divider.isPositive);

  //If the answer is 0, then the sign will be a plus
  if Result.Remainder.Number[High(Result.Remainder.Number)] = 0 then
    Result.Remainder.isPositive:= True
  else
    Result.Remainder.isPositive:= not (Dividend.isPositive xor Divider.isPositive);

end;




end.
