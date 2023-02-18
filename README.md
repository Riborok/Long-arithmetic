# Unit for working with integer long numbers in different number systems. 
## As an example, implemented a program for calculating long numbers in different NS
#### Language: Delphi
#
[Check LongArithmetic unit](#longarithmetic-unit)
-
[Check Long number calculator ](#long-number-calculator)
-
---

## LongArithmetic unit
#

### Available functions and procedures for working with long numbers: InputNum, OutputNum, NumbersSum, NumbersDifference, NumbersProduct, NumbersDiv, NumbersMod, NSConvert.

## Type: 
#### >TNumber - dynamic array stores the value of a number
#### >TNumberAndSign - record type, stores the value of a number as a TNumber and the sign of the number as a boolean variable
#### >TDivision - record type, stores the quotient and the remainder as TNumber

#

## Functions and Procedures:

#### 1) Function InputNum(NS: Byte): TNumberAndSign
#### ⠀⠀The number system NS is passed to the function, in which the number should be
#### ⠀⠀written. A TNumberAndSign type variable is returned (value and sign of the number)
#### ⠀⠀When entering a number, the correctness of the data is checked. If you need to write
#### ⠀⠀number not in NS, then enter $(the number system in which the number is written),
#### ⠀⠀then a space and the number itself.

#### 2) Procedure OutputNum(Number: TNumberAndSign)
#### ⠀⠀A number of type TNumberAndSign is passed to the procedure. The sign of the number
#### ⠀⠀and its value are displayed on the screen.

#### 3) Function NumbersSum(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign
#### ⠀⠀Two numbers of type TNumberAndSign and the number system are passed to the
#### ⠀⠀function. Returns the sum of type TNumberAndSign.

#### 4) Function NumbersDifference(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign
#### ⠀⠀Two numbers of type TNumberAndSign and the number system are passed to the 
#### ⠀⠀function. Returns the difference of type TNumberAndSign.

#### 5) NumbersProduct(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign
#### ⠀⠀Two numbers of type TNumberAndSign and the number system are passed to the 
#### ⠀⠀function. Returns the product of type TNumberAndSign.

#### 6) Function NumbersDiv(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign
#### ⠀⠀Two numbers of type TNumberAndSign and the number system are passed to the 
#### ⠀⠀function. Returns the incomplete quotient of the division of type TNumberAndSign.
#### ⠀⠀Division by zero is not provided in the unit!

#### 7) Function NumbersMod(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign
#### ⠀⠀Two numbers of type TNumberAndSign and the number system are passed to the
#### ⠀⠀function. Returns the remainder of the division of type TNumberAndSign. 
#### ⠀⠀Division by zero is not provided in the unit!

#### 8) Function NSConvert(Number: TNumber; OldNS, NewNS: Byte): TNumber
#### ⠀⠀A number of type TNumber, number system OldNS (in which the number  
#### ⠀⠀resides) and number system NewNS (to which the number is to be converted) are  
#### ⠀⠀passed to the function. Returns the number of type TNumber in the number system
#### ⠀⠀NewNS.
#


### Code for LongArithmetic unit:
``` pascal
unit LongArithmetic;
{
 Long numbers calculator in different number systems.

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
    Quotient, Remainder :TNumber;
  end;
  //TNumber - type for long numbers
  //TNumberAndSign - the type that stores a number and its sign as a boolean variable
  //TDivision - type for quotient and remainder after division

Const
  NSAlphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  //NSAlphabet - transfer between symbols and numbers



//Function to input a number in the number system NS (the number is written mirrored)
//NS is the number system in which the result should be. If the number is not written in NS,
//then enter $(the number system in which the number is written), then a space and the number itself
Function InputNum(NS: Byte): TNumberAndSign;

//Function to output a number (mirroring back)
Procedure OutputNum(Number: TNumberAndSign);

//Function calculates the sum of two numbers in the number system NS
Function NumbersSum(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;

//Function calculates the difference of two numbers in the number system NS
Function NumbersDifference(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;

//Function calculates the product of two numbers in the number system NS
Function NumbersProduct(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;

//Function calculates the incomplete quotient after dividing two numbers (the remainder is discarded)
//Division by zero is not provided in the unit!
Function NumbersDiv(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;

//Function calculates the remainder after dividing two numbers
//Division by zero is not provided in the unit!
Function NumbersMod(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;

//Function converts a number from OldNS to NewNS
Function NSConvert(Number: TNumber; OldNS, NewNS: Byte): TNumber;

implementation

//Function to input a number in the number system NS (the number is written mirrored)
//NS is the number system in which the result should be. If the number is not written in NS,
//then enter $(the number system in which the number is written), then a space and the number itself
Function InputNum(NS: Byte): TNumberAndSign;
var
  NumberNS: byte;
  i, Len, ErrorCode: LongInt;
  str: string;
  IsCorrect: boolean;
  //NumberNS - number system of a number
  //i - cycle counter
  //Len - number length
  //ErrorCode - is there an error in the val
  //Str - number in string form
  //IsCorrect - flag to confirm the correctness of entering numbers
begin

  //Cycle with postcondition for entering correct data.
  Repeat

    //Initialize the variables
    IsCorrect:= True;
    NumberNS:= NS;

    //Read the entered number and check for correctness.
    Readln(str);

    //Checking for the presence of $. If there is, it means that the number is not written in NS
    if str[1] = '$' then
    begin

      //Valid number systems have 2 or 1 digits (beginning with the second sybmols, because the first has a $)
      i:= 3;
      repeat
        i:= i - 1;
        //Attempt to write the selected string to a NumberNS
        val(Copy(str, 2, i), NumberNS, ErrorCode);
      until (i = 1) or (ErrorCode = 0);

      //Checking for the correctness of entering a NumberNS. If correct, remove these symbols from the string,
      //there must be a space in i+2 (because i is the length of the NumberNS and $ is stored in the 1st element)
      if (ErrorCode = 0) and (str[i+2] = ' ') then
        Delete(str, 1, i+2)
      else
      begin
        Writeln('Actions with $ are incorrectly written');
        isCorrect:= False;
      end;
    end;

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
        if (Result.Number[i] < 0) or (Result.Number[i] >= NumberNS) then
        begin
          Writeln('Wrong input of number! Namely, wrong input of symbols! See available symbols above! Try again');
          IsCorrect:= False;
        end;

        //Modernize i
        i:= i + 1;
      end;

    end;

  Until IsCorrect;

  //Checking for a mismatch between NS and NumberNS. If there is, we translate the number from NumberNS to NS
  if NS <> NumberNS then
    Result.Number:= NSConvert(Result.Number, NumberNS, NS);

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
  //Carry - сarry to the next element
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
  //Carry - сarry to the next element
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



//Function finds FirstMultiplier * SecondMultiplier
Function Multiplication(FirstMultiplier, SecondMultiplier: TNumber; NS: Byte): TNumber;
var
  IntermediateCalc : TNumber;
  i, j, PosElement: LongInt;
  DigigtsProd: Word;
  CarryProd: Byte;
  //IntermediateCalc - intermediate calculations
  //i, j - cycle counter
  //PosElement - the current position of the element in the multiplication
  //DigigtsProd - product of the digits of the first and second number
  //CarryProd - сarry the digit (if there is) to the next element (for DigigtsProd)
begin

  //Set the lengths
  SetLength(IntermediateCalc, length(FirstMultiplier)+length(SecondMultiplier));
  SetLength(Result, length(FirstMultiplier)+length(SecondMultiplier));

  //Resetting the answer
  FillChar(Result[0], SizeOf(Result[0]) * length(Result), 0);

  //Reset carry
  CarryProd:= 0;

  //Multiply the digits of the first number by the second number
  for i := Low(SecondMultiplier) to High(SecondMultiplier) do
  begin
    for j := Low(FirstMultiplier) to High(FirstMultiplier) do
    begin

      //Сalculate at what position in the multiplication the element now
      PosElement:= j + i;

      //Starting to multiply the last digits of the numbers (in the mirrored view it is first)
      //and add the carry (if there is).
      DigigtsProd:= FirstMultiplier[j] * SecondMultiplier[i] + CarryProd;

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
    Result:= Plus(Result, IntermediateCalc, i, NS);
  end;

  //If a digit is inserted after PosElement, increase PosElement
  if Result[PosElement+1] > 0 then
    PosElement:= PosElement + 1;

  //If the product is 0, then the length will be 1.
  if Result[PosElement] = 0 then
    SetLength(Result, 1)

  //Else set the calculated length for Result
  else
    SetLength(Result, PosElement+1);

  //Delete the used array
  SetLength(IntermediateCalc, 0);
end;

//Function calculates the product of two numbers in the number system NS
Function NumbersProduct(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;
begin

  //Finding the product of two numbers
  Result.Number:= Multiplication(FirstNum.Number, SecondNum.Number, NS);

  //Determine the sign. If the answer is 0, then the sign will be a plus
  if Result.Number[High(Result.Number)] = 0 then
    Result.isPositive:= True
  else
    Result.isPositive:= not (FirstNum.isPositive xor SecondNum.isPositive);
end;



//Function finds Dividend / Subtracted (quotient and remainder)
//Division by zero is not provided in the unit!
Function Division(Dividend, Divider: TNumber; NS: Byte): TDivision;
var
  CurrElInQuotient, CurrPosInDividend, i: LongInt;
  //CurrElInQuotient - the current element in the quotient
  //CurrPosInDividend - current position in the dividend (CurrPosInDividend..High(Dividend) - part of the dividend which will divide)
  //i - cycle counter
begin

  //Set approximate length for Quotient
  SetLength(Result.Quotient, length(Dividend));

  //Resetting the answer
  FillChar(Result.Quotient[0], SizeOf(Result.Quotient[0]) * length(Result.Quotient), 0);

  //Initialize the variables (considering that they are written in mirrored view)
  CurrElInQuotient:= -1; //-1 since at the beginning of the cycle will add 1
  CurrPosInDividend:= High(Dividend) - High(Divider) + 1; //+1 since at the beginning of the cycle will decrease by 1

  //In the first iteration, the part of the dividend must be greater than Divider
  if not PartFirstNumIsGreater(Dividend, Divider, CurrPosInDividend - 1) then
    CurrPosInDividend:= CurrPosInDividend - 1;

  //Result check: numerator remainder must be < denominator
  while (Length(Dividend) > Length(Divider)) or
        ((Length(Dividend) = Length(Divider))
        and PartFirstNumIsGreater(Dividend, Divider, Low(Dividend))) do
  begin

    //Reduce CurrPosInDividend for the new iteration take out the next digit
    CurrPosInDividend:= CurrPosInDividend - 1;

    //Initialize the variables
    CurrElInQuotient:= CurrElInQuotient + 1;

    //If the current position in the dividend is the last element and that last element is 0, decrease the length by one
    if (CurrPosInDividend = High(Dividend)) and (Dividend[High(Dividend)] = 0) then
      SetLength(Dividend, length(Dividend) - 1)

    //Else while the part of the dividend is greater than the divisor, find the result of the division
    else
      while (Length(Dividend) - CurrPosInDividend > Length(Divider)) or
            ((Length(Dividend) - CurrPosInDividend = Length(Divider))
            and PartFirstNumIsGreater(Dividend, Divider, CurrPosInDividend)) do
      begin
        //Subtract find the result
        Dividend:= Minus(Dividend, Divider, CurrPosInDividend, NS);
        Result.Quotient[CurrElInQuotient]:= Result.Quotient[CurrElInQuotient] + 1;
      end;

  end;

  //Сount the final length of the quotient (сonsidering division method)
  CurrElInQuotient:= CurrElInQuotient + CurrPosInDividend + 1;

  //If initially the divisor was greater than the dividend, set the length of the quotient 1
  if CurrElInQuotient <= 0 then
    CurrElInQuotient:= 1;

  //Set the length
  SetLength(Result.Quotient, CurrElInQuotient);

  //Since in the division method the answer is written in the normal form, mirror it
  for i := Low(Result.Quotient) to Length(Result.Quotient) div 2 - 1 do
  begin
    Result.Quotient[i]:= Result.Quotient[i] xor Result.Quotient[High(Result.Quotient) - i];
    Result.Quotient[High(Result.Quotient) - i]:= Result.Quotient[i] xor Result.Quotient[High(Result.Quotient) - i];
    Result.Quotient[i]:= Result.Quotient[i] xor Result.Quotient[High(Result.Quotient) - i];
  end;

  //Return the remainder
  Result.Remainder:= Dividend;

end;

//Function calculates the incomplete quotient after dividing two numbers (the remainder is discarded)
//Division by zero is not provided in the unit!
Function NumbersDiv(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;
begin

  //Finding the quotient after the remainder
  Result.Number:= Division(FirstNum.Number, SecondNum.Number, NS).Quotient;

  //Determine the signs. If the answer is 0, then the sign will be a plus
  if Result.Number[High(Result.Number)] = 0 then
    Result.isPositive:= True
  else
    Result.isPositive:= not (FirstNum.isPositive xor SecondNum.isPositive);

end;

//Function calculates the remainder after dividing two numbers
//Division by zero is not provided in the unit!
Function NumbersMod(FirstNum, SecondNum: TNumberAndSign; NS: Byte): TNumberAndSign;
begin

  //Сheck: number1 mod number2 will be equal to some remainder if number1 is greater than number2
  if (Length(FirstNum.Number) > Length(SecondNum.Number)) or
      ((Length(FirstNum.Number) = Length(SecondNum.Number))
      and PartFirstNumIsGreater(FirstNum.Number, SecondNum.Number, Low(FirstNum.Number))) then
  begin
    //Finding the remainder after the remainder
    Result.Number:= Division(FirstNum.Number, SecondNum.Number, NS).Remainder;

    //Determine the signs. If the answer is 0, then the sign will be a plus
    if Result.Number[High(Result.Number)] = 0 then
      Result.isPositive:= True
    else
      Result.isPositive:= not (FirstNum.isPositive xor SecondNum.isPositive);
  end

  //Else the result will be number1 (value and sign)
  else
    Result:= FirstNum;

end;



//Function converts using Gorner's scheme translate the simple part (from several symbols of the old number system to one symbol in the new)
Function GornerConvert(Number: TNumber; OldNS: Byte): SmallInt;
var
  OldNSPow: SmallInt;
  i: LongInt;
  //OldNSPow - power of the old number system
  //i - cycle counter
begin

  //Initializing the variables
  Result:= 0;
  OldNSPow:= 1;

  //Conver according to the Gorner's scheme
  for i := Low(Number) to High(Number) do
  begin
    Result:= Result + Number[i]*OldNSPow;
    OldNSPow:= OldNSPow * OldNS;
  end;

end;

//Function converts a number from OldNS to NewNS
Function NSConvert(Number: TNumber; OldNS, NewNS: Byte): TNumber;
Var
  NewNSArray: TNumber;
  ResDivision : TDivision;
  i: LongInt;
  //NewNSArray - the value of the NewNS, converted into the number system OldNS and written as an array
  //ResDivision - result of division (quotient and remainder) of a number by a NewNSArray
  //i - cycle counter
begin

  {Note! When translating from one number system to another, the result is written in mirror form}

  //Check which is more: old or new (because the converts is slightly different)
  if NewNS < OldNS then
  begin

    //Set array NewNSArray
    SetLength(NewNSArray, 1);
    NewNSArray[0]:= NewNS;

    //Setting the maximum lengths of arrays
    SetLength(Result, length(Number)*6);

    //Convert number from OldNS to NewNS
    i:= Low(Result);
    while (Length(Number) > Length(NewNSArray)) or ((Length(Number) = Length(NewNSArray)) and PartFirstNumIsGreater(Number, NewNSArray, Low(Number))) do
    begin

      //Dividing the numbers
      ResDivision:= Division(Number, NewNSArray, OldNS);

      //Write the remainder to the result
      Result[i]:= ResDivision.Remainder[0];

      //Assign a residual value
      Number:= ResDivision.Quotient;

      //Modernize i
      i:= i + 1;
    end;

    //At the end (when Number < NewNSArray), the remainder will be the last value of the number
    Result[i]:= Number[0];

  end
  else
  begin

    //Setting the maximum lengths of arrays
    SetLength(NewNSArray, 6);

    //Converting the value of the NewNS to the number system OldNS
    i:= Low(NewNSArray);
    while NewNS >= OldNS do
    begin
      NewNSArray[i]:= NewNS mod OldNS;
      NewNS:= NewNS div OldNS;
      i:= i + 1;
    end;

    //At the end there is a remainder, which will be the last element. Setting the length
    NewNSArray[i]:= NewNS;
    SetLength(NewNSArray, i + 1);

    //Setting the maximum lengths of arrays
    SetLength(Result, length(Number));

    //Convert number from OldNS to NewNS
    i:= Low(Result);
    while (Length(Number) > Length(NewNSArray)) or ((Length(Number) = Length(NewNSArray)) and PartFirstNumIsGreater(Number, NewNSArray, Low(Number))) do
    begin

      //Dividing the numbers
      ResDivision:= Division(Number, NewNSArray, OldNS);

      //Write the remainder to the result. The number is still represented in the old number system (using division,
      //the program is divided into separate elements), so convert it to the new system using Gorner's scheme
      Result[i]:= GornerConvert(ResDivision.Remainder, OldNS);

      //Assign a residual value
      Number:= ResDivision.Quotient;

      //Modernize i
      i:= i + 1;
    end;

    //When Number < NewNSArray, the remainder of a number will be the last value of the number. Convert it to the new system using Gorner's scheme
    Result[i]:= GornerConvert(Number, OldNS);

  end;

  //Set the length
  SetLength(Result, i+1);

  //Delete the used arrays
  SetLength(NewNSArray, 0);
  SetLength(ResDivision.Quotient, 0);
  SetLength(ResDivision.Remainder, 0);
end;

end.
```

---

## Long number calculator 
#

### Available operators: +, -, *, div, mod (calculations occur in the base number system NS).
### To change the base number system NS enter ~$. To reset the answer enter clr. To get the answer enter =. To complete the process enter !

### Entered numbers must correspond to the base number system NS. If need to write number not in the base number system, then enter $(the number system in which the number is written), then a space and the number itself. 
#

### Code for long number calculator: 
``` pascal
Program LongNumberCalculator;
{Long number calculator}

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  LongArithmetic in '..\Units\LongArithmetic.pas';

Var
  Num1, Num2: TNumberAndSign;
  ChosenOperator : String;
  OldNS, BaseNS: Byte;
  flag: boolean;
  //Num1 - array of digits of the first number (further the result of the two previous numbers)
  //Num2 - array of digits of the second numbers
  //Operation - the chosen operation
  //BaseNS - base number system
  //OldNS - previous base number system
  //flag - flag to confirm the correctness of entering numbers



Function InputNS: Byte;
Var
  i: Byte;
  IsCorrect: Boolean;
Begin
  //Cycle with postcondition for entering correct data.
  Repeat

    //Initialize the IsCorrect
    IsCorrect:= True;

    //Validating the correct input data type
    Try
      Readln(Result);
    Except
      Writeln('Wrong input of number system! It must be an integer. Try again');
      IsCorrect:= False;
    End;

    //Validate Range
    if ((Result > Length(NSAlphabet)) or (Result < 2)) and IsCorrect then
    begin
      Writeln('Wrong input of number system! It must be >=2 and <=',Length(NSAlphabet),'. Try again');
      IsCorrect:= False;
    end;

  Until IsCorrect;

  //Declaring available symbols and their value
  Writeln;
  Writeln('Available symbols on the ',Result,'th number system and their number system:');
  for i := 0 to Result - 1 do
    Writeln('Symbol ', NSAlphabet[i+1],' Value = ',i);
  Writeln;
  if Result <> High(NSAlphabet) then
  begin
    Writeln('Other characters up to the ',High(NSAlphabet),'th system');
    for i := Result to High(NSAlphabet) - 1 do
      Writeln('Symbol ', NSAlphabet[i+1],' Value = ',i);
    Writeln;
  end;
End;



Begin

  Writeln('Welcome to the long arithmetic. Available operators: +, -, *, div, mod (calculations occur in the base number system NS).');
  Writeln('To change the base number system NS enter ~$. To reset the answer enter clr. To get the answer enter =. To complete the process enter !');
  Writeln('Warning! Numbers must be integers');
  Writeln;

  Writeln('Enter the base number system (which will be used for calculations and to output the result). Minimal is 2, maximum number system is ',Length(NSAlphabet));
  Writeln('If you want to change the base number system, then when entering the operator, enter ~$. (The answer will also be converted into the new base number system)');

  //Input number system
  BaseNS:= InputNS;
  Writeln('If you need to write number not in the base number system, then enter $(the number system in which the number is written), then a space and the number itself.');
  Writeln('For example: $2 1101');
  Writeln;

  //Entering the first number (it is initially positive)
  //(further this number will store the result of operations)
  Num1:= InputNum(BaseNS);

  //Do operations until '!'
  repeat

    //Cycle with postcondition for entering correct data.
    repeat
      Readln(ChosenOperator);
      ChosenOperator:= AnsiLowerCase(ChosenOperator);
      flag:= False;

      //If the first number is positive, then add the two numbers.
      //Else subtract the first from the second number
      if ChosenOperator = '+' then
      begin
        Num2:= InputNum(BaseNS);
        Num1:= NumbersSum(Num1, Num2, BaseNS)
      end

      //If the first number is positive, then subtract the second from the first.
      //Else add two numbers (the sign of the result will remain -)
      else if ChosenOperator = '-' then
      begin
        Num2:= InputNum(BaseNS);
        Num1:= NumbersDifference(Num1, Num2, BaseNS)
      end

      //Multiplying two numbers
      else if ChosenOperator = '*' then
      begin
        Num2:= InputNum(BaseNS);
        Num1:= NumbersProduct(Num1, Num2, BaseNS);
      end

      //Find the integer quotient after division (check not to divide by 0)
      else if ChosenOperator = 'div' then
      begin
        Num2:= InputNum(BaseNS);
        if Num2.Number[High(Num2.Number)] = 0 then
        begin
          flag:= True;
          Writeln('Cant divide by zero! Enter operator and number again');
        end
        else
          Num1:= NumbersDiv(Num1, Num2, BaseNS);
      end

      //Find the remainder after division (check not to divide by 0)
      else if ChosenOperator = 'mod' then
      begin
        Num2:= InputNum(BaseNS);
        if Num2.Number[High(Num2.Number)] = 0 then
        begin
          flag:= True;
          Writeln('Cant divide by zero! Enter operator and number again');
        end
        else
          Num1:= NumbersMod(Num1, Num2, BaseNS);
      end

      //Write out the current result
      else if ChosenOperator = '=' then
      begin
        OutputNum(Num1);
        Writeln;
      end

      //Change base number system
      else if ChosenOperator = '~$' then
      begin
        OldNS:= BaseNS;
        Writeln('Enter a new base number system');
        BaseNS:= InputNS;
        if OldNS <> BaseNS then
          Num1.Number:= NSConvert(Num1.Number, OldNS, BaseNS);
      end

      //Resetting the answer
      else if ChosenOperator = 'clr' then
      begin
        SetLength(Num1.Number, 1);
        Num1.Number[0]:= 0;
        Num1.isPositive:= True;
      end

      //Invalid input
      else if ChosenOperator <> '!' then
      begin
        flag:= True;
        Writeln('Invalid operator entered. Try again');
      end;

    until not flag;

  until ChosenOperator = '!' ;

  //Delete the used arrays
  SetLength(Num1.Number, 0);
  SetLength(Num2.Number, 0);
  SetLength(ChosenOperator, 0);

  Writeln('Process completed');

  Readln;
End.
```