MainPath = get_absolute_file_path("ssctmain.sci")




//// none documented part:

/*

.Click to see the source code</summary>

[source,scilab]
....
*/






Precisions = ["uchar", "schar", "char", "int8", "int16", "int32", "uint8", "uint16", "uint32", "short", "int", "long", "ushort", "uint", "ulong", "single", "float32", "float", "double", "float64"]; //MATLAB sintax, default is uchar
WriteModes = ["sync", "async"]; // MATLAB syntax, sync is default
PrintFormats = ["%c", "%d", "%i", "%e", "%E", "%f", "%g", "%G", "%o", "%s", "%u", "%x", "%X"];

ScanFormats = ["%d", "%i", "%o", "%u", "%x", "%X", "%f", "%e", "%E","% ""%g", "%G", "%c", "%s"];



// buffersize {1 to 10 milion}

WindowsComProperties = ["Port", "Baud", "Parity", "Data Bits", "Stop Bits", "Timeout", "XON/XOFF", "CTS handshaking", "DSR handshaking", "DSR sensitivity", "DTR circuit", "RTS circuit"]; // these are from cmd mode command


global DefinedPorts;
global OpenPorts;
global AvailablePorts;

//AvailablePorts = slist();

exec(MainPath + "slist.sci");

function reloadserialtoolbox()

    if exists("DefinedPorts", "a") == 1 & 1 < size(DefinedPorts)(1) then
        warning("Defined ports are: " + strcat(DefinedPorts(2:$, :), ", "));
    else
        global DefinedPorts;
        DefinedPorts = ["Ports"];
    end

    if exists("OpenPorts", "a") == 1 & 1 < size(OpenPorts)(1) then
        warning("Open ports are: " + strcat(OpenPorts(2:$, :), ", "));
    else
        global OpenPorts;
        OpenPorts = ["Port", "SerialName"]
    end

endfunction

reloadserialtoolbox()

function resetserialtoolbox()
    clear;
    clc;

    global OpenPorts
    global DefinedPorts

    // close all open ports
    for Port = OpenPorts(2:$, 1)
        row = find(OpenPorts == Port);
        sclose(Port);
        OpenPorts(row, :) = [];
    end

    // delete all defined ports
    // erase all the variables in the workspace with the serial object structure
    for Port = DefinedPorts(2:$)
        row = find(DefinedPorts == Port);
        DefinedPorts(row, :) = [];
    end

    // check if there are any open ports and warn
endfunction



function Available = isportavailable(SerialPort)
    if ~isvalidserialobject(SerialPort, Behaviour = "none") then
        Available = %f;
        return;
    else
        if typeof(SerialPort) == "st" then
            Port = SerialPort.Port;
        elseif typeof(SerialPort) == "string" then
            Port = SerialPort;
        end
        Available = ~isempty(find(slist() == Port));
        return;
    end

    //    AvailablePorts = slist();
    //    try
    //        if ~isempty(find(AvailablePorts == SerialPort)) then
    //            Available = %t
    //        else
    //            Available = %f
    //        end
    //        Available = return(~isempty(find(AvailablePorts == SerialPort.Port)));
    //    catch
    //        if type(SerialPort) ~= 10 then
    //            warning("SerialPort must be a string such as COM1 or a SerialObject. Available ports at the moment are: " + strcat(AvailablePorts, ", "));
    //            Available = return(%f)
    //        end
    //        if ~isempty(find(AvailablePorts == SerialPort)) then
    //            Available = %t
    //        else
    //            Available = %f
    //        end
    //        Available = return(~isempty(find(AvailablePorts == SerialPort)));
    //    end
    //    Available = %f
endfunction

function Defined = isportdefined(SerialPort)
    if ~isvalidserialobject(SerialPort, Behaviour = "warning") then
        Defined = %f;
        return;
    end
    //    AvailablePorts = slist();

    if typeof(SerialPort) == "st" then
        Port = SerialPort.Port;
    elseif typeof(SerialPort) == "string" then
        Port = SerialPort;
    end

    //    try
    //        Port = SerialPort.Port;
    //    catch
    //        if type(SerialPort) ~= 10 then
    //            warning("SerialPort must be a string or a SerialObject. Available ports at the moment are: " + strcat(AvailablePorts, ", "));
    //            Defined = return(%f)
    //        else
    //            Port = SerialPort;
    //        end
    //    end
    Defined = ~isempty(find(DefinedPorts == Port));
    return;
endfunction

function IsOpen = isportopen(SerialPort)

    isvalidserialobject(SerialPort, Behaviour = "warning");


    if typeof(SerialPort) == "st" then
        Port = SerialPort.Port;
    elseif typeof(SerialPort) == "string" then
        Port = SerialPort;
        //    else
        //        error("The SerialPort input must be a SerialObject")
    end



    if isempty(find(OpenPorts == Port)) then
        IsOpen = %f;
    else
        IsOpen = %t;
    end

endfunction



exec(MainPath + "serialobject.sci");

exec(MainPath + "sdefine.sci");





exec(MainPath + "sopen.sci");


Behaviours = ["none", "warning", "error"];

function Valid = isvalidserialobject(SerialPort, Behaviour)
    OutMessage = "The input variable is not a valid serial object or port"

    if ~exists("Behaviour", "local") then
        Behaviour = "none";
    end

    if isempty(find(Behaviours == Behaviour)) then
        error(Behaviour + " is not a valid behaviour. Valid values are: " + strcat(Behaviours, ", "));
    end

    if typeof(SerialPort) == "string" then
        if isempty(find(DefinedPorts == SerialPort)) & isempty(find(slist(PortList = "all") == SerialPort)) then
            Valid = %f;
            return;
        else
            Valid = %t;
            return;
        end

    elseif typeof(SerialPort) == "st" then
        try
            if isempty(find(DefinedPorts == SerialPort.Port)) & isempty(find(slist(PortList = "all") == SerialPort.Port)) then
                Valid = %f;
            else
                Valid = %t;
            end
        catch
            Valid = %f;
        end
    else
        Valid = %f;
    end
    if Valid == %f then
        if Behaviour == "warning" then
            warning(OutMessage);
        elseif Behaviour == "error" then
            error(OutMessage);
        end
    end
endfunction

function SerialName = getserialname(SerialPort)

    isvalidserialobject(SerialPort, Behaviour = "error");

    if typeof(SerialPort) == "st" then
        Port = SerialPort.Port;
    elseif typeof(SerialPort) == "string" then
        Port = SerialPort;
    end

    //    try
    row = find(OpenPorts == Port);
    if isempty(row) then
        if size(DefinedPorts)(1) == 1 then
            warning("There are no ports defined. Available ports are: " + strcat(slist(), ", "));
        elseif size(OpenPorts)(1) == 1 then
            warning("There are no ports open. Defined ports are: " + strcat(DefinedPorts(2:$, :), ", "));
        else
            warning(Port + " is not open. Open ports are: " + strcat(OpenPorts(2:$, :), ", "));
        end
        SerialName = "";
        return;
    end
    SerialName = OpenPorts(row, 2);
    //    catch
    //        error("The SerialPort input must be a SerialObject");
    //    end
endfunction


function [BytesAvailable, Status, Result] = sifno(SerialPort)

    BytesAvailable = [0, 0];
    Status = ""
    Result = isvalidserialobject(SerialPort, Behaviour = "warning");
    if ~Result then
        return;
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

    if isempty(SerialName) then
        //        row = find(OpenPorts == SerialPort.Port);
        //        if isempty(row) then
        //            if size(OpenPorts)(1) == 1 then
        //                warning("There are no ports open.");
        //                [Queue, Status] = return("", "");
        //            else
        //                warning(SerialPort.Port + " is not open. Open ports are: " + strcat(OpenPorts(2:$, :), ", "));
        //                [Queue, Status] = return("", "");
        //            end
        return;
    else
        //            SerialName = OpenPorts(row, 2);
        //            disp(SerialName)
        BytesAvailable = TCL_EvalStr("fconfigure " + SerialName + " -queue");
        Status = TCL_EvalStr("fconfigure " + SerialName + " -ttystatus");
    end
    //    catch
    //        error("The SerialPort input must be a defined SerialObject. Current objects are " + strcat(DefinedPorts, ", "));
    //    end
endfunction

exec(MainPath + "sget.sci");

exec(MainPath + "sput.sci");


//function [Buffer, Result, Count] = fscanf(SerialPort, Format, Size)
//    isvalidserialobject(SerialPort, Behaviour = "error");
//
//    if type(Size) ~= 8 | (ndims(Size) ~= 1 & ndims(Size) ~= 2) then
//        error("Size must be 1 or 1x2 of positive integers");
//    end
//
//
//endfunction

//function Result = swrite(SerialPort, BinaryData, Precision, Mode)
//
//    Result = isvalidserialobject(SerialPort, Behaviour = "warning");
//    if Result == %f then
//        return;
//    end
//
//    if ~exists("Precision","local") then
//        Precision = "uchar";
//    end
//
//    if isempty(find(Precisions == Precision)) then
//        error(string(Precision) + " is not a standard Precision. Available values are: " + strcat(Precisions, ", "));
//    end
//
//    if ~exists("Mode","local") then
//        Mode = "sync";
//    end
//
//    if isempty(find(WriteModes == Mode)) then
//        error(string(Mode) + " is not a standard Mode. Available values are: " + strcat(WriteModes, ", "));
//    end
//
//endfunction

// function Result = sprint(SerialPort, Message, Mode) // msprintf
//     Result = %f;
//     isvalidserialobject(SerialPort, Behaviour = "error")
//
//     if typeof(SerialPort) == "st" then
//         Port = SerialPort.Port;
//     elseif typeof(SerialPort) == "string" then
//         Port = SerialPort;
//     end
//
//     if ~isportopen(Port) then
//         error("The port " + Port + " is not Open. Open Ports are: " + OpenPorts);
//     end
//
//     SerialName = getserialname(SerialPort);
//     Result(1) = TCL_EvalStr("puts " + SerialName + " " + "{" + Message + "}") == "";
//     //    disp(isempty(Result1))
//     Result(2) = TCL_EvalStr("flush " + SerialName) == "";
//     Result = Result(1) & Result(2);
//
// endfunction

//CMD --> mode, type, copy, more, ping, cat, xcopy

function [Message, Result] = sread()

endfunction

function Result = sprint(SerialPort, Message)

    isvalidserialobject(SerialPort, Behaviour = "warning");

    if typeof(SerialPort) == "st" then
        Port = SerialPort.Port;
    elseif typeof(SerialPort) == "string" then
        Port = SerialPort;
    end

    if ~isportavailable(SerialPort) then
        error("The port " + Port + " is not available. Available ports are: " + strcat(slist(), ", "));
    end

    if getos() == "Windows" then
        Result = dos("echo " + Message + "> \\.\" + Port) // use unix instead of doc so it is compatible with ScicosLab, use "set /p x=" + Message + " <nul >\\.\" + Port to remove space, carriage return and line feed characters
    else
        error("this feature has not been implemented for this operating system");
    end
endfunction

function [Result] = sclose(SerialPort)
    Result = isvalidserialobject(SerialPort, Behaviour = "error");


    if typeof(SerialPort) == "st" then
        Port = SerialPort.Port;
        if isempty(SerialPort.SerialName) then
            SerialName = getserialname(SerialPort);
        else
            SerialName = SerialPort.SerialName;
        end
        // ResultSerialPort = SerialPort;
    elseif typeof(SerialPort) == "string" then
        Port = SerialPort;
        SerialName = getserialname(Port);
    end

    global OpenPorts;
    //    try


    if isempty(SerialName) then

        //        if isempty(row) then
        //            if isempty(strcat(OpenPorts(2:$, :), ", ")) then
        //                warning("There are no ports open.");
        //                Result = return(%f);
        //            else
        //            warning(SerialPort.Port + " is not open. Open ports are: " + strcat(OpenPorts(2:$, :), ", "));
        //                Result = return(%f);
        //            end
        Result = %f;
        return;
    else
        //            SerialName = OpenPorts(row, 2);
        Result = TCL_EvalStr("set closeresult [catch {close " + SerialName + "}]") == "0";
        row = find(OpenPorts == Port);
        OpenPorts(row, :) = [];

        //            ResultSerialPort = SerialPort;
        //            Result = TCL_GetVar("closeresult") == "0";
    end
    //    catch
    //        error("Failed opening port. The SerialPort input must be a SerialObject");
    //    end

endfunction

function Result = sdelete(SerialPort)
    Result = isvalidserialobject(SerialPort, Behaviour = "warning");

    if ~Result then
        return;
    end

    if typeof(SerialPort) == "st" then
        Port = SerialPort.Port;
    elseif typeof(SerialPort) == "string" then
        Port = SerialPort;
    end

    if isportopen(SerialPort) then
        warning("The port " + Port + " is already open. It will be closed automatically.");
        sclose(SerialPort);
    end

    global DefinedPorts;

    if ~isportdefined(SerialPort) then
        warning("The port " + Port + " is not defined");
        Result = %f;
        return;
    else
        row = find(DefinedPorts == Port);
        DefinedPorts(row) = [];
        Result = %t;
    end
endfunction


// TCL_EvalStr("set closeresult [catch {close file4ecbe600}]");

WhosExp = "/([\%\_\#\!\$\?a-zA-Z]+[\%\_\#\!\$\?a-zA-Z0-9]*)\s+(constant|polynomial|function|handle|string|boolean|list|rational|state\-space|sparse|boolean sparse|hypermat|st|ce|fptr|pointer|size implicit|library|int8|uint8|int16|uint16|int32|uint32|\_EObj|\_EVoid)\*?\s+((\d+)x(\d+)|\?)?\s+(\d+)/";

function FoundString = exportwhos()
    TempFile = TMPDIR + '/TempDiary.txt';
    clc;
    diary(TempFile)
    whos;
    diary(0)
    clc;

    TempID = mopen(TempFile, 'rt');
    TempInfo = fileinfo(TempFile)
    TempString = mgetstr(TempInfo(1), TempID);
    mclose(TempID);
    mdelete(TempFile);
    [start, final, match, FoundString] = regexp(TempString, WhosExp);
endfunction

function  StringOut = stdtostr(Expression)
    TempFile = TMPDIR + '/TempDiary.txt';
    clc
    diary(TempFile)
    execstr(Expression)
    diary(0)
    clc;

    TempID = mopen(TempFile, 'rt');
    TempInfo = fileinfo(TempFile)
    StringOut = mgetstr(TempInfo(1), TempID);
    mclose(TempID);
    mdelete(TempFile);
endfunction


function Properties = instrhelpserial()
    Properties = ""
endfunction

function OutTime = millis()
    TempTime = clock()
    //              TempTime(1) * 12 * 30 * 24 * 60 * 60 * 100 +..
    //              TempTime(2) * 30 * 24 * 60 * 60 * 100 +..
    //              TempTime(3) * 24 * 60 * 60 * 100 +..
    OutTime = TempTime(4) * 60 * 60 * 1000 +..
    TempTime(5) * 60 * 1000 +..
    TempTime(6) * 1000;
endfunction

function Check = isscilab()
    Check = length(zeros(2)) == 1;
endfunction

function [Interpreter, Version] = getinterpreter()
    GotString = getversion();
    if part(GotString, 1:6) == "scilab" then
        Interpreter = "Scilab"
        Version = tokens(getversion(), "-")(2);
        return;
    else
        Interpreter = "ScicosLab";
        Version = GotString;
        return;
    end
endfunction

VariableTypes = ["natural", "integer", "real", "rational", "irrational", "complex", "string", "boolean", "structure", "list"]

function Result = checkvariables(VariableList)

    if ~exists("VariableList","local") | typeof(VariableList) ~= "list" then
        Result = error("The VariableList input must be a Scilab list");
        return;
    else
    end

endfunction

// towards developing a GUI

//
//fignr = 1002;
//f = figure(fignr);
//f.menubar_visible = "off";
//f.toolbar_visible = "off";
//f.infobar_visible = "off";
////delmenu(fignr, 'File');
////delmenu(fignr, 'Edit');
////delmenu(fignr, 'Tools');
////delmenu(fignr, '?');
////toolbar(fignr, 'off');
////f.background = 1;
//f.figure_name="GUI";
//f.tag="mainWindow";






/*
....
====
<!--- */ // -->


/*
// to do
// instrfind --> https://nl.mathworks.com/help/matlab/ref/instrfind.html
// sdelete --> https://www.mathworks.com/help/matlab/ref/serial.delete.html
// sprint --> https://www.mathworks.com/help/matlab/ref/serial.sprint.html

// isvalid --> https://www.mathworks.com/help/matlab/ref/serial.isvalid.html

// Implement MATLAB's Arduino package --> https://nl.mathworks.com/hardware-support/arduino-matlab.html

// Using Powershell  Get-WMIObject Win32_SerialPort the Description property to see what devices is connected to each serial port

*/
