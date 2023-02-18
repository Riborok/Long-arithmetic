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

  Writeln('Welcome to long arithmetic. Available opretors: +, -, *, div, mod (calculations occur in the base number system NS).');
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
