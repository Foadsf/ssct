
////
/* SSCT GPL v3
////


[.text-center]
This code is documented in AsciiDoc format
[.text-center]
Suggested viewer https://addons.mozilla.org/en-US/firefox/addon/asciidoctorjs-live-preview/[FireFox plugin Asciidoctor.js Live Preview]


=== sopen()

Opens the serial port object to get ready for send and receive (same as
MATLAB `fopen`)

==== Syntax:

[source,scilab]
....
*/

// please use varargin and check input type

function [Result, ResultSerialPort, SerialName] = sopen(SerialPort, Access, Reopen)
/*
....
// ....
// [<Result>, <ResultSerialPort>, <SerialName>] = sopen(SerialPort, <Access = >, <Reopen = %t/%f>)
// ....

==== Parameters

[source,scilab]
....
*/
AccessArguments = ["r", "r+", "w", "w+", "a", "a+"];
/*
....

==== Description:

The `SerialPort` input must be a defined serial port object defined by
`serial` function otherwise it will return `%f` for `Result`. The list
of defined serial objects can be found using the
`slist(PortList = "defined")` command. The `Access` input can be
set to `"r"`, *`"r+"`*, `"w"`, `"w+"`, `"a"`, `"a+"`. The function will
make sure the specified port is a valid, defined and available serial
port. If the `Reopen` input has been set to `%t` the function will close
it and reestablish the connection.

=== Source Code:

.Click to see the source code
[%collapsible]
====

[source,scilab]
....
*/
    Result = isvalidserialobject(SerialPort, Behaviour = "warning");
    SerialName = "";
    ResultSerialPort = SerialPort;
    if Result == %f then
        return;
    end

    //    if typeof(SerialPort) ~= "st" then
    //        error("The SerialPort input must be a SerialObject")
    //    end

    global OpenPorts;

    if ~exists("Access","local") then
        Access = "r+";
    end

    if isempty(find(AccessArguments == Access)) then
        error(string(Access) + " is not a valid access argument. Available values are: " + strcat(AccessArguments, ", "));
    end

    if typeof(SerialPort) == "st" then
        Port = SerialPort.Port;
        //    elseif typeof(SerialPort) == "string" then
    else
        error("This feature is not implemented yet. The sopen SerialPort must be a serial port structure made through serial function.");
        //        Port = SerialPort;
    end

    //    try

    if ~exists("Reopen","local") then
        Reopen = %f;
    end

    if isportopen(SerialPort)  then
        if Reopen == %f then
            warning("The port " + Port + " is already open");
            SerialName = getserialname(Port);
            ResultSerialPort.SerialName = SerialName;
            Result = %f;
            return;
        else
            sclose(SerialPort);
            [Result, SerialName, ResultSerialPort]= sopen(SerialPort, Access);
            return;
        end
    end



    if ~isportdefined(SerialPort) then
        //            warning("The port is not defined. I will attemt to make one with the default properties");
        //            SerialPort = serial(Port);
        warning("The port " + Port + " is not defined. Defined Ports are: " + strcat(DefinedPorts, ", "));
        Result = %f;
        return;
    end



    if ~isportavailable(SerialPort) then
        warning("The port " + string(Port) + " is not available. Available ports are: " + strcat(slist(), ", "));
        Result = %f;
        return;
    end

    Digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

    if getos() == "Windows" then
        // if strtod(part(Port, $)) < 10 then
        // if size(str2code(part(Port, 4:length(Port)))) == [1, 1] then
        if ~isempty(find(part(Port, 4:length(Port)) == Digits)) then
            SerialName = TCL_EvalStr("set " + "Serial_" + Port +" [open " + Port + " " + Access + "]");
        else
            SerialName = TCL_EvalStr("set " + "Serial_" + Port +" [open " + "\\\\.\\" + Port + " " + Access + "]");
        end
    else
        error("this feature has not been implemented for this operating system yet");
    end



    //        SerialName = TCL_GetVar("Serial-" + Port);
    //        SerialPort.SerialName = SerialName;
    ResultSerialPort.SerialName = SerialName;
    OpenPorts = cat(1, OpenPorts, [Port, SerialName]);
    ////        SerialPort.SerialName = SerialName;
    Result(1) = TCL_EvalStr("fconfigure " + SerialName + " -mode " + string(SerialPort.BaudRate) + "," + part(SerialPort.Parity, 1) + "," + string(SerialPort.DataBits) + "," + string(SerialPort.StopBits)) == "";


    Result(2) = TCL_EvalStr("fconfigure " + SerialName + " -translation " + SerialPort.Terminator) == "";
    Result(3) = TCL_EvalStr("fconfigure " + SerialName + " -blocking 0") == ""; // this one has to do with sync and async I think
    Result(4) = TCL_EvalStr("fconfigure " + SerialName + " -timeout " + string(SerialPort.TimeOut * 100)) == "";

    if getos() == "Windows" then
        Result(5) = TCL_EvalStr("fconfigure " + SerialName + " -sysbuffer " + "{" + string(SerialPort.InputBufferSize) + " " + string(SerialPort.OutputBufferSize) + "}") == "";
    else
        Result(5) = TCL_EvalStr("fconfigure " + SerialName + " -sysbuffer " + string(SerialPort.InputBufferSize)) == "";
    end




    select SerialPort.FlowControl
    case "hardware" then
        if getos() == "Windows" then
            handshake = "dtrdsr";
        else
            handshake = "rtscts";
        end
    case "software" then
        handshake = "xonxoff";
    else
        handshake = "none";
    end
    Result(6) = TCL_EvalStr("fconfigure " + SerialName + " -handshake " + handshake) == "";

    //    catch
    //        error("Failed opening port. The SerialPort input must be a SerialObject");
    ////        sclose(SerialPort);
    //        TCL_EvalStr("set closeresult [catch {close " + SerialName + "}]");
    //    end
    Result = Result(1) & Result(2) & Result(3) & Result(4) & Result(5) & Result(6);
    if Result == %f then
        sclose(Port);
        wanting("Opening was not sucessful!")
        return;
    end
endfunction
/*
....
====
////
*/
////
