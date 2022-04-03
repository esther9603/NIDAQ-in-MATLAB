function readData(src, ~)
global data_MCU;
global Operation_Time;
% Read the ASCII data from the serialport object.

data = readline(src);

Receive_Data_split=regexp(data,',','split');

src.UserData.Count = src.UserData.Count + 1;

data_MCU(1:51,1,src.UserData.Count) = Receive_Data_split(1:51);

if src.UserData.Count > Operation_Time*10
    configureCallback(src, "off");
    plot(1,1);
end
end