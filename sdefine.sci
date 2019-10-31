////
/*
////

[.text-center]
This code is documented in AsciiDoc format
[.text-center]
Suggested viewer https://addons.mozilla.org/en-US/firefox/addon/asciidoctorjs-live-preview/[FireFox plugin Asciidoctor.js Live Preview]

=== sdefine()

Creates a serial port object (i.e. Scilab structure) given the required
link:#%20Properties[properties]


==== Syntax:

[source,scilab]
....
*/
function [SerialObject, Result] = sdefine(Port, BaudRate, DataBits, Parity, StopBits, FlowControl, Terminator, TimeOut, InputBufferSize, OutputBufferSize, ReadAsyncMode, ByteOrder, Tag, OverWrite)
/*
....

==== Description:

[.text-justify]
The `sdefine` function is an implementation of
https://nl.mathworks.com/help/matlab/ref/serial.html[MATLAB’s `serial`
function] which creates a serial port object. At the moment the `serial
object` is actually just a Scilab `struct` with no methods. The `Port`
property (a Scilab string) must be specified but the rest of the
properties are optional and the function can set them to their default
values if not specified.

[.text-justify]
While creating the object it will warn the user if the object is not a
valid serial object. Valid serial objects are the one recognized by the
operating system, including the `available` and `open` ones. It will
check if the port with the given name is already defined, returning `%f`
if that’s the case, Unless the `OverWrite` input has been set to `%t`.

[.text-justify]
On Windows the `Port` input is of the form `COMx` where `x` is a
positive integer.

==== Example:

[source,scilab]
....
s1 = sdefine("COM1")
....

[source,scilab]
....
s2 = sdefine(Port = 'COM2', BaudRate = 4800, Terminator = "cr")
....

[.text-justify]
Although it is possible to change the properties of the defined serial
objects using the dot `.` operator

[source,scilab]
....
s2.BaudRate = 9600;
....

[.text-justify]
it is not recommended at all, and should be avoided at all costs. you
may always redefine the objects setting the `OverWrite` input to `%t`
with the new properties. Otherwise, reading the information through the
`.` operator is fine.


==== Source Code:

.Click to see the source code
[%collapsible]
====

[source,scilab]
....
*/

    if argn(1) < 1 then
        warning("The SerialObject output argument must be present otherwise it can not be opned");
        Result = %f;
        return;
    end

    SerialObject = "UndefinedSerialObject";

    global DefinedPorts;
    global AvailablePorts;

    if ~exists("Port","local") then
        error("The Port must be specified");
    end

    if typeof(Port) ~= "string" then
        warning("Port must be a string. Available ports at the moment are: " + strcat(slist(slist = "all"), ", "));
        Result = %f;
        Return;
    end



    //    AvailablePorts = slist();

    //    if isempty(find(AvailablePorts == Port)) then
    if ~isportavailable(Port) then
        warning("The port " + string(Port) + " is not available at the moment. Available ports are: " + strcat(slist(), ", "));
    end

    // scilabcos compatible
    //    if size(strindex(strcat(unix_g("mode")), Port)) ~= [1, 1] then
    //        warning("The port " + Port + " is not available at the moment.");
    //        Result = %f;
    //        return;
    //    end

    if ~exists("OverWrite", "local") then
        OverWrite = %f;
    end

    if isportdefined(Port) then
        if OverWrite == %f then
            Result = %f;
            SerialObject = "UndefinedSerialObject";
            warning("The port is already defined. To over write it set OverWrite = %t ");
            return;
        else
            sdelete(Port);
        end
    end

    //    try
    //        if ~int(Port) == Port | Port < 0 then
    //            error("Port must be a positive integer value");
    //        end
    //    catch
    //        error("Port must be a positive integer (numeric) value");
    //    end



    //    if getos() == "Windows" then
    //        Port = "COM" + string(Port);
    //    else
    //        error("this feature has not been implemented for this operating system yet");
    //    end



    if ~exists("BaudRate","local") then
        BaudRate = 9600;
    end

    if isempty(find(StandardBaudRates == BaudRate)) then
        error(string(BaudRate) + " is not a standard baud rate. Available values are: " + strcat(string(StandardBaudRates), ", "));
    end

    if ~exists("Parity","local") then
        Parity = "none";
    end

    if isempty(find(StandardParities == Parity)) then
        error(string(Parity) + " is not a standard parity. Available values are: " + strcat(StandardParities, ", "));
    end

    if ~exists("DataBits","local") then
        DataBits = 8;
    end

    if isempty(find(StandardDataBits == DataBits)) then
        error(string(DataBits) + " is not a standard data bit. Available values are: " + strcat(string(StandardDataBits), ", "));
    end

    if ~exists("StopBits","local") then
        StopBits = 1;
    end

    if isempty(find(StandardStopBits == StopBits)) then
        error(string(StopBits) + " is not a standard StopBits. Available values are: " + strcat(string(StandardStopBits), ", "));
    end

    if ~exists("FlowControl","local") then
        FlowControl = "none";
    end

    if isempty(find(FlowControls == FlowControl)) then
        error(string(FlowControl) + " is not a standard FlowControl. Available values are: " + strcat(string(FlowControls), ", "));
    end

    if ~exists("Terminator","local") then
        Terminator = "binary";
    end

    if isempty(find(Terminators == Terminator)) then
        error(string(Terminator) + " is not a standard Terminator. Available values are: " + strcat(Terminators, ", "));
    end

    if ~exists("TimeOut","local") then
        TimeOut = 10;
    end

    // check integers

    //    try
    //        if ~int(TimeOut) == TimeOut | TimeOut < 0 then
    // if ~isscalar(TimeOut) | typeof(TimeOut) ~= "constant" | TimeOut < 0 then
    if typeof(TimeOut) ~= "constant" | TimeOut < 0 then
        error("TimeOut must be a positive integer value");
    end
    //    catch
    //        error("TimeOut must be a positive integer (numeric) value");
    //    end

    if ~exists("InputBufferSize","local") then
        InputBufferSize = 512;
    end

    if modulo(InputBufferSize, 1) | InputBufferSize < 0 then
        error("InputBufferSize must be a positive integer value");
    end

    if ~exists("OutputBufferSize","local") then
        OutputBufferSize = 512;
    elseif getos() ~= "Windows" then
        error("OutputBufferSize feature is only for Wondows");
    end

    if modulo(OutputBufferSize, 1) | OutputBufferSize < 0 then
        error("OutputBufferSize must be a positive integer value");
    end


    if ~exists("ReadAsyncMode","local") then
        ReadAsyncMode = "continuous";
    end

    if isempty(find(ReadAsyncModes == ReadAsyncMode)) then
        error(string(ReadAsyncMode) + " is not a standard ReadAsyncMode. Available values are: " + strcat(ReadAsyncModes, ", "));
    end

    if ~exists("ByteOrder","local") then
        ByteOrder = "littleEndian";
    end

    if isempty(find(ByteOrders == ByteOrder)) then
        error(string(ByteOrder) + " is not a standard ByteOrder. Available values are: " + strcat(ByteOrders, ", "));
    end

    //    SerialObject = 0;

    SerialObject = struct("Port", Port, "BaudRate", BaudRate, "DataBits", DataBits, "Parity", Parity, "StopBits", StopBits, "FlowControl", FlowControl, "Terminator", Terminator, "TimeOut", TimeOut, "InputBufferSize", InputBufferSize, "OutputBufferSize", OutputBufferSize, "Type", "serial", "Name", "Serial-" + Port, "SerialName", "");
    //    SerialObject = struct("Port", Port, "BaudRate", BaudRate, "DataBits", DataBits, "Parity", Parity, "StopBits", StopBits, "FlowControl", FlowControl, "Terminator", Terminator, "Type", "serial", "Name", "Serial-" + Port);
    DefinedPorts = cat(1, DefinedPorts, Port);
endfunction
/*
....

////


// MATLAB's serial object properties: instrhelp serial --> BaudRate, BreakInterruptFcn, ByteOrder, BytesAvailable, BytesAvailableFcn, BytesAvailableFcnCount, BytesAvailableFcnMode, BytesToOutput, DataBits, DataTerminalReady, ErrorFcn, FlowControl, InputBufferSize, Name, ObjectVisibility, OutputBufferSize, OutputEmptyFcn, Parity, PinStatus, PinStatusFcn, Port, ReadAsyncMode, RecordDetail, RecordMode, RecordName, RecordStatus, RequestToSend, Status, StopBits, Tag, Terminator, Timeout, TimerFcn, TimerPeriod, TransferStatus, Type, UserData, ValuesReceived, ValuesSent

// MATLAB serial object functions/methods --> https://www.mathworks.com/help/matlab/serial-port-devices.html
// MATLAB serial object properties attributes -- > https://nl.mathworks.com/help/matlab/matlab_external/property-reference.html

//Tcl fconfigure properties: mode {baud,parity,data,stop}, handshake, queue, timeout , ttycontrol , ttystatus, xchar , pollinterval , sysbuffer ,  lasterror
// --> http://noel.feld.cvut.cz/vyu/ocs/ActiveTcl8.4.2.0-html/tcl/TclCmd/fconfigure.htm

// PowerShell: BaseStream, BaudRate, BreakState, BytesToWrite, BytesToRead, CDHolding, CtsHolding, DataBits, DiscardNull, DsrHolding, DtrEnable, Encoding, Handshake, IsOpen, NewLine, Parity, ParityReplace, PortName, ReadBufferSize, ReadTimeout, ReceivedBytesThreshold, RtsEnable, StopBits, WriteBufferSize, WriteTimeout, Site, Container

// PowerShell  Get-WMIObject Win32_SerialPort :

// classes:
// CIM_SerialController
// Win32_SerialPort
// Win32_PnPEntity

// CMD / batch / mode : baud, parity, data, stop, to, xon, odsr, octs, dtr, rts, idsr


////


====
////
*/
////
