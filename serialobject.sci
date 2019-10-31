
////
/*
////



== Serial Object Properties:

[.text-center]
This code is documented in AsciiDoc format
[.text-center]
Suggested viewer https://addons.mozilla.org/en-US/firefox/addon/asciidoctorjs-live-preview/[FireFox plugin Asciidoctor.js Live Preview]

SSCT serial object has been developed to be mostly compatible with
https://nl.mathworks.com/help/matlab/matlab_external/property-reference.html[MATLAB’s
serial object properties], but when possible/needed go beyond that.
// You may run the `instrhelpserial` function to see all the current properties
and their accepted and default values.
Default values have been specified with bold font.

// === Port

=== BaudRate

Accepted values are `110`, `300`, `600`, `1200`, `2400`, `4800`,
*`9600`*, `14400`, `19200`, `38400`, `57600`, `115200`, `128000` and
`256000` bits per second. This property is also limited by the
`MaximumBaudRate` (PowerShell syntax) provided by the operating system
and the underlying hardware.

[source,scilab]
....
*/
StandardBaudRates = [110, 300, 600, 1200, 2400, 4800, 9600, 14400, 19200, 38400, 57600, 115200, 128000, 256000]; //bits per second. 9600 is the default
/*
....

==== DataBits

Accepted values are 5, 6, 7 and *8*

[source,scilab]
....
*/
StandardDataBits = [5, 6, 7, 8]; // 8 is the default
/*
....

==== Parity

*`"none"`*, `"odd"`, `"even"`, `"mark"` and `"space"`

[source,scilab]
....
*/
StandardParities = ["none", "odd", "even", "mark" "space"]; // none is the default
/*
....

==== StopBits

*`1`* and `2` . Please consider that MATLAB also accepts `1.5` which is
not compatible with Tcl and this toolbox.

[source,scilab]
....
*/
StandardStopBits = [1, 2]; //1 is the default. MATLAB also accepts 1.5
/*
....


==== Terminator

Accepted values are `"auto"`, *`"binary"`*, `"cr"`, `"crlf"`, `"lf"`.
Please consider that this is Tcl syntax not MATLAB’s.

[source,scilab]
....
*/
Terminators = ["auto", "binary", "cr", "crlf", "lf", "platform"]; // this is Tcl syntax. binary is the default. MATLAB accepts 0 to 127 ASCII or  CR (carriage return), LF (linefeed),  CR/LF or LF/CR
/*
....

==== FlowControl

[source,scilab]
....
*/
FlowControls = ["none", "hardware", "software"]; // default is none. Tcl syntax:  rtscts (dtrdsr for Windows)  for hardware and xonxoff for software
/*
....


==== Buffering

[source,scilab]
....
*/
Bufferings = ["full", "line", "none"]; // this is Tcl syntax. full is default
/*
....

==== ReadAsyncMode

[source,scilab]
....
*/
ReadAsyncModes = ["manual", "continuous"]; //MATLAB syntax, probably the blocking option in Tcl
/*
....

==== ByteOrder

[source,scilab]
....
*/
ByteOrders = ["bigEndian", "littleEndian"];
/*
....
