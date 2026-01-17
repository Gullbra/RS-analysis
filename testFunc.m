function result = testFunc(inputArg1, inputArg2)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here

    arguments (Input)
        inputArg1 int32
        inputArg2 int32
    end
    
    arguments (Output)
        result int32
    end

   result = inputArg1 + inputArg2;
end