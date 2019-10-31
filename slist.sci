////
/*
////

[.text-center]
This code is documented in AsciiDoc format
[.text-center]
Suggested viewer https://addons.mozilla.org/en-US/firefox/addon/asciidoctorjs-live-preview/[FireFox plugin Asciidoctor.js Live Preview]



== slist()

Lists the valid, available, open or defined serial ports / objects (similar to the https://nl.mathworks.com/help/matlab/ref/seriallist.html[seriallist] of MATLAB)

=== Parameters:

* *Verbose*: Boolean
* *PortList*: One of the values (default *`"available"`*)

[source,scilab]
....
*/
PortLists = ["all", "available", "open", "defined"];
/*
....

=== Syntax:

[source,scilab]
....
*/
function SerialList = slist(Verbose, PortList)
/*
....


== Description:

[.text-justify]
The `Verbose` input is set to `%f` by default returning a vector of
strings. If set to `%t` it will export a matrix including more elaborate
details about the specified `PortList`. The `PortList` option can be
`"all"` for showing the valid ports available or open, `"available"` for
showing the ports are free to be opened, `"open"` for all the already
opened ports and `"defined"` for showing all the ports which are already
defined.

== Example:


....
--> slist
 ans  =

!COM6  COM7  !
....

=== Source Code:

.Click to see the source code
[%collapsible]
====

[source,scilab]
....
*/
WindowsPSProperties = ["DeviceID", "Description", "MaxBaudRate", "ProviderType"];
WindowsComExp = "/(COM[1-9]\d*)[^.]+?Baud.+?([1-9]\d*)[^.]+?Parity.+?(\w+)[^.]+?Data Bits.+?(\d)[^.]+?Stop Bits.+?(1|1\.5|2)[^.]+?Timeout.+?(ON|OFF)[^.]+?XON\/XOFF.+?(ON|OFF)[^.]+?CTS handshaking.+?(ON|OFF)[^.]+?DSR handshaking.+?(ON|OFF)[^.]+?DSR sensitivity.+?(ON|OFF)[^.]+?DTR circuit.+?(ON|OFF)[^.]+?RTS circuit.+?(ON|OFF)/"; // this is to extract information from cmd mode command

    global DefinedPorts;
    global OpenPorts;
    global AvailablePorts;

    if ~exists("Verbose","local") then
        Verbose = %f;
    end

    if type(Verbose) ~= 4 then
        error("The Verbose must be Boolean type %t or %f");
    end

    if ~exists("PortList","local") then
        PortList = "available";
    end

    if isempty(find(PortLists == PortList)) then
        error("Supported options for PortList are: " + strcat(PortLists, ", "));
    end

    if PortList == "defined" then
        SerialList = return(DefinedPorts(2:$)');
    end

    if PortList == "open" then
        SerialList = return(OpenPorts(2:$, 1)');
    end

    [OS, Version] = getos();

    if OS == "Windows" then
        if PortList == "all" then
            if Verbose == %f then
                //                SerialList = powershell("[System.IO.Ports.SerialPort]::getportnames()")'; //--> This solution considers the ports opned by powershell as available while there are in fact opened internally as explained [here](https://superuser.com/questions/1412117/list-all-the-serial-ports-available-and-busy-on-any-of-windows-terminals)
                if getinterpreter() == "scilab" then
                    [output, bOK] = powershell("Get-WMIObject Win32_SerialPort | Select-Object DeviceID");
                    [start, final, match, foundString] = regexp(strcat(output), '/(COM\d+)/');
                    SerialList = foundString';
                else
                    outputString = unix_g("cmd /V:ON /C '"set '"var='" & (For /F '"tokens=1 Delims= '" %s In (''WMIC Path Win32_SerialPort Get DeviceID^|FindStr '"COM[0-9]*'"'') do @IF DEFINED var (@set '"var=!var!,%s'") else (set '"var=%s'")) & @echo !var!'""); //"
                    SerialList = tokens(outputString, [",", " "])';
                    return;
                end
            else
                if getinterpreter() == "scilab" then
                    SerialList = powershell(" Get-WMIObject Win32_SerialPort | Select-Object DeviceID, Description, MaxBaudRate, ProviderType")(2:$-2);
                else
                    SerialList = unix_g("WMIC Path Win32_SerialPort Get DeviceID, Description, MaxBaudRate, ProviderType"); // cmd / batch alternative
                    return;
                end
            end
        elseif PortList == "available" then
            if Verbose == %f then
                if getinterpreter() == "scilab" then
                    [rep, stat] = dos("mode");
                    //[rep, stat] = unix_g("mode"); //unix_g, unix, host are scicoslab compatible
                    [start, final, match, foundString] = regexp(strcat(rep), '/(COM\d+)/'); // using strindex instead of regexp to make it ScosLab compatible
                    SerialList = foundString';
                else
                    outputString = unix_g("cmd /V:ON /C '"set '"var='" & (For /F '"tokens=4 Delims=: '" %s In (''Mode^|FindStr '"COM[0-9]*'"'') do @IF DEFINED var (@set '"var=!var!,%s'") else (set '"var=%s'")) & @echo !var!'""); //"
                    SerialList = tokens(outputString, [",", " "])';
                    return;
                end
            else
                if getinterpreter() == "scilab" then
                    [rep, stat] = dos("mode");
                    [start, final, match, foundString] = regexp(strcat(rep), WindowsComExp);
                    SerialList = cat(1, WindowsComProperties, foundString);
                    return;
                else
                    [rep, stat] = unix_g("mode");
                    [start, final, match, foundString] = regexp(strcat(rep), WindowsComExp);
                    SerialList = cat(1, WindowsComProperties, foundString);
                    return;
                end
            end
        end
    elseif OS == "Darwin" then
        if PortList == "all" then
            if Verbose == %f then
                SerialList = unix_g("ls /dev/{tty,cu}.* | grep tty | sed -n -E "'s/\/dev\/tty\.(.+)/\1/p"'")' //"
            end
        end
        // error("this feature has not been implemented for this operating system yet");
    else
        error("this feature has not been implemented for this operating system yet");
        //    elseif getos() == "Linux" then
        //    elseif  then
        //        [rep, stat] = unix_g("dmesg | grep tty");
        //        [rep, stat] = unix_g("ls /dev/ttyACM*"); // alternatively
        //        setserial -bg /dev/ttyS*
        //        stty
    end
endfunction
/*
....


====


////
<!--- */ // -->
////
