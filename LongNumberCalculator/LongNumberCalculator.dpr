Program LongNumberCalculator;
{Long number calculator}

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  LongArithmetic in '..\Units\LongArithmetic.pas';

Var
  Num1: TNumberAndSign;
  Num2: TNumber;
  Operation : String;
  NS: Byte;
  flag: boolean;
  //Num1 - array of digits of the first number (further the result of the two previous numbers)
  //Num2 - array of digits of the second numbers
  //Operation - the chosen operation
  //NS - number system
  //flag - flag to confirm the correctness of entering numbers



Function InputNS(MaxNS: Byte): Byte;
Var
  i, EnteredNS: Byte;
  IsCorrect: Boolean;
Begin
  Writeln('Enter number system (maximum number system is ',MaxNS,', minimal is 2)');
  //Cycle with postcondition for entering correct data.
  Repeat

    //Initialize the IsCorrect
    IsCorrect:= True;

    //Validating the correct input data type
    Try
      Readln(EnteredNS);
    Except
      Writeln('Wrong input of number system! It must be an integer. Try again');
      IsCorrect:= False;
    End;

    //Validate Range
    if ((EnteredNS > MaxNS) or (EnteredNS < 2)) and IsCorrect then
    begin
      Writeln('Wrong input of number system! It must be >=2 and <=',MaxNS,'. Try again');
      IsCorrect:= False;
    end;

  Until IsCorrect;

  //Declaring available symbols and their value
  Writeln;
  Writeln('Available symbols on the ',EnteredNS,'th number system and their number system:');
  for i := 0 to (EnteredNS - 1) do
    Writeln('Symbol ', NSAlphabet[i+1],' Value = ',i);
  Writeln;

  Result:= EnteredNS;
End;



Begin

  Writeln('Welcome to long arithmetic. Available opretors: +, -, *, div, mod. When you want to get an answer enter =. To complete the process, enter !');

  Writeln('Numbers must be non-negative and integer');

  //Input number system
  NS:= InputNS(Length(NSAlphabet));

  //Entering the first number (it is initially positive)
  //(further this number will store the result of operations)
  Num1.Number:= InputNum(NS);
  Num1.isPositive:= True;

  //Do operations until '!'
  repeat

    //Cycle with postcondition for entering correct data.
    repeat
      Readln(Operation);
      flag:= False;

      //If the first number is positive, then add the two numbers.
      //Else subtract the first from the second number
      if Operation = '+' then
      begin
        Num2:= InputNum(NS);
        if Num1.isPositive then
          Num1.Number:= NumbersSum(Num1.Number, Num2, NS)
        else
          Num1:= NumbersDifference(Num2, Num1.Number, NS);
      end

      //If the first number is positive, then subtract the second from the first.
      //Else add two numbers (the sign of the result will remain -)
      else if Operation = '-' then
      begin
        Num2:= InputNum(NS);
        if Num1.isPositive then
          Num1:= NumbersDifference(Num1.Number, Num2, NS)
        else
          Num1.Number:= NumbersSum(Num1.Number, Num2, NS);
      end

      //Multiplying two numbers
      else if Operation = '*' then
      begin
        Num2:= InputNum(NS);
        Num1.Number:= NumbersProduct(Num1.Number, Num2, NS);
      end

      //Find the integer quotient after division (check not to divide by 0)
      else if Operation = 'div' then
      begin
        Num2:= InputNum(NS);
        if Num2[High(Num2)] = 0 then
        begin
          flag:= True;
          Writeln('Cant divide by zero! Enter operator and number again');
        end
        else
          Num1.Number:= NumbersDivision(Num1.Number, Num2, NS).Quotient;
      end

      //Find the remainder after division (check not to divide by 0)
      else if Operation = 'mod' then
      begin
        Num2:= InputNum(NS);
        if Num2[High(Num2)] = 0 then
        begin
          flag:= True;
          Writeln('Cant divide by zero! Enter operator and number again');
        end
        else
          Num1.Number:= NumbersDivision(Num1.Number, Num2, NS).Remainder;
      end

      //Write out the current result
      else if Operation = '=' then
      begin
        OutputNum(Num1.Number, Num1.isPositive);
        Writeln;
      end

      //Invalid input
      else if Operation <> '!' then
      begin
        flag:= True;
        Writeln('Invalid operator entered. Try again');
      end;

    until not flag;

  until Operation = '!' ;

  Writeln('Process completed');

  Readln;
End.
