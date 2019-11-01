
////
/* SSCT GPL v3
////

// please use varargin and check input type
function Result = sput(SerialPort, Message, Segment, Safe, Wait)
    Result = isvalidserialobject(SerialPort, Behaviour = "warning");
    if ~Result then
        return;
    end

    if ~exists("Message","local") | typeof(Message) ~= "string" then
        warning("Message input is required");
        Result = %f;
        return;
    end

    if ~exists("Segment","local") then
        Segment = "line";
    end

    if isempty(find(Segments == Segment)) then
        error(string(Segment) + " is not a valid Segment. Available values are: " + strcat(Segments, ", "));
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

    SerialName = getserialname(SerialPort);
    Result(1) = TCL_EvalStr("puts " + string(SerialName) + " " + "{" + Message + "}") == "";
    //    disp(isempty(Result1))
    Result(2) = TCL_EvalStr("flush " + string(SerialName)) == "";
    Result = Result(1) & Result(2);
endfunction
