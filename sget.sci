Segments = ["all", "line", "char"];

function [OutData, Result] = sget(SerialPort, Segment, Size, Safe, Wait)

    OutData = "";
    Result = isvalidserialobject(SerialPort, Behaviour = "warning");
    if ~Result then
        return;
    end

    if ~exists("Segment","local") then
        Segment = "line";
    end

    if isempty(find(Segments == Segment)) then
        error(string(Segment) + " is not a valid Segment. Available values are: " + strcat(Segments, ", "));
    end

    if ~exists("Size","local") then
        Size = 1;
    end

    if typeof(Size) ~= "constant" | modulo(Size, 1) | Size <= 0 then
        error("Size must be a positive integer");
    end

    if ~exists("Wait","local") then
        Wait = 1;
    end

    if typeof(Wait) ~= "constant" | modulo(Wait, 1) | Wait <= 0 then
        error("Wait must be a positive integer");
    end

    if ~exists("Safe","local") then
        Safe = %t;
    end

    if typeof(Safe) ~= "boolean" then
        error("Safe input parameter must be a boolean");
    end

    if typeof(SerialPort) == "st" then
        Port = SerialPort.Port;
    elseif typeof(SerialPort) == "string" then
        Port = SerialPort;
    end

    if ~isportopen(SerialPort)  then
        if size(OpenPorts)(1) < 2 then
            warning("There are no open ports. Defined ports are: " + strcat(DefinedPorts(2:$), ","));
        else
            warning("The port is not open. Open ports are: " + strcat(OpenPorts(2:$, 1), ","));
        end
        Result = %f;
        return;
    else
        SerialName = getserialname(SerialPort);
    end

    TempData = "";
    //    try

    // if ~isempty(SerialName) then

    if Segment == "line" then
        while 0 < Size & isempty(TempData)
            TCL_EvalStr("gets " + SerialName + " ttybuf");
            TempData = TCL_GetVar("ttybuf");
            if ~isempty(TempData) | ~Safe then
                OutData = cat(1, OutData, TempData);

                Size = Size - 1;
                TempData = "";
            end
            sleep(Wait);

        end
    elseif Segment == "all" then

        while 0 < Size & isempty(TempData)
            TCL_EvalStr("set ttybuf [read " + SerialName + "]");
            TempData = TCL_GetVar("ttybuf");
            if ~isempty(TempData) | ~Safe then
                OutData = cat(1, OutData, TempData);
                Size = Size - 1;
                TempData = "";
            end
            sleep(Wait);
        end
    else
        while 0 < Size & isempty(TempData)
            TCL_EvalStr("set ttybuf [read " + SerialName + " 1]");
            TempData = TCL_GetVar("ttybuf");
            if ~isempty(TempData) | ~Safe then
                OutData = cat(1, OutData, TempData);
                Size = Size - 1;
                TempData = "";
            end
            sleep(Wait);
        end
    end



    //    else
    //        error("SerialName not found. there is soomething messed up!")
    //    end
    //    catch
    //        error("The SerialPort input must be a SerialObject.");
    //    end
    // OutData = tmpbuf;
endfunction
