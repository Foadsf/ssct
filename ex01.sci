////
/*
////

.Click to see the source code
[%collapsible]
====

[source,scilab]
....
*/
s7 = sdefine(Port = "COM7", BaudRate = 9600, Parity = 'none', DataBits = 8, StopBits = 1, OverWrite = %t); // Assuming COM7 is the port you got from above command
sopen(SerialPort = s7, Access = 'r');



pData = [];
pTime = [];
nData = csvTextScan(part(sget(s7), 1:$-1), ',');
pData = [pData, nData(2)];
pTime = [pTime, nData(1)];
plot(pTime, pData);

while %t
    drawlater();
    nData = csvTextScan(part(sget(s7), 1:$-1), ',');
    pData = [pData, nData(2)];
    pTime = [pTime, nData(1)];
    clf();
    plot(pTime, pData);
    drawnow();
    sleep(1000);
end



sclose(s7);
sdelete(s7);

/*
....
====
////
*/
////


////
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
////
