delete(lh)
delete(s)
delete(instrfindall);

%%
clc;
clear;
close all; 

%%
%%%%%%%%%%%%%%%%%%%%%%% Initialize parameter %%%%%%%%%%%%%%%%%%%%%%%
global count; global NI_data; global time; 
global Timer_cnt; global Output_Voltage; global Output_Data;
global Operation_Time; global Threshold; global NI_INPUT;
global NI_INPUT_cnt; global Training_Flag; 
global sequence_count; global OT; global time;
global MT; global mt; global start;
global MCU; global data_MCU;
global MCU_Initial_Flag;
global S_Data;

Training_Flag = 0;
NI_INPUT_cnt = 0;
NI_INPUT = 0;
Operation_Time = 15; % time 
Output_Data = 0;
Output_Voltage = 0;
Timer_cnt = 0;
firstflag = 0;
count = 0;
start = 0;

count_flag = 0;
PF = 0;

%% 
%%%%%%%%%%%%%%%%%%%%%%% Initial setting %%%%%%%%%%%%%%%%%%%%%%%
s = daq.createSession('ni');
s.Rate = 500; %data acquisiting frequency (ex. 500 means 500Hz)
addAnalogInputChannel(s,'Dev2', 0:6, 'Voltage'); %s, Device#, used channel#, ctrl Method
s.IsNotifyWhenDataAvailableExceedsAuto = true;
lh = addlistener(s,'DataAvailable',@ stopWhenExceedStatus); %follows the function name stopWhenExceedStatus
s.IsContinuous = true;

%Serial communication WITH MCU 
serialportlist("available")
MCU = serialport("COM14",115200);
MCU.UserData = struct("Data",[],"Count",1);
configureTerminator(MCU,"CR/LF");
flush(MCU);
configureCallback(MCU,"terminator",@readData);
disp('mcu open')
s.startBackground(); % starting DAQ in the background

f=1;
start = 1;

while s.IsRunning
    if(start==1)
    %%% put the code while acquisiting data from DAQ %%%
    end
end      

fprintf('%d data scans \n', s.ScansAcquired);
delete(lh)
delete(s)
delete(instrfindall);

%%
% Arranging data 
close all;
S1 = 0; S2 = 0; S3 = 0; S4 = 0; S5 = 0; S6 = 0;
Time_Data = 0; Sensor_data = 0; Disp_data=0; P_R = 0;

%calibration data for nano17 (model FT28742, FT28734, FT11602)
% C=...
%     [-0.01161 0.00811 -0.02361 -3.38789 -0.08339 3.37865;...
%     -0.06204 3.93750 0.07139 -2.01980 0.04302 -1.91736;...
%     3.69516 -0.01892 3.77562 -0.18134 3.373858 -0.07134;...
%     -0.85385 24.03730 21.02695 -13.26790 -20.80709 -11.28005;...
%     -24.00375 0.04741 12.11920 20.24382 12.46801 -20.86853;...
%     0.19742 14.14102 -0.01204 13.58553 -0.73209 14.33131]; %FT28742

% C=...
%     [-0.01068, -0.03318, 0.02918, -1.70678, 0.03097, 1.66496;...
%     -0.04307, 2.02885, 0.02612, -1.01815, -0.03778, -0.92625;...
    %     1.89834, -0.00533, 1.94421, 0.01500, 1.84782, 0.09471;...
%     0.01345, 12.37895, 10.79659, -6.09067, -10.51735, -6.17541;...
%     -12.13144, 0.21960, 6.30576, 10.49989, 5.65297, -9.86387;...
%     -0.11444, 7.12299, 0.10986, 7.18181, 0.13613, 6.93965]; %FT28734

% C=...
%     [-0.13680,  -1.33456,  -0.07761, -39.51445,   0.67626,  37.41149;...
%     1.56260,  43.49709,  -0.19070, -24.09076,  -0.49327, -20.12753;...
%     22.01734,  -0.62909,  22.69247,  -0.94210,  20.98593,  -0.58028;...
%     1.17132,   0.33880,  38.74220,  -1.69684, -36.46326,   0.83952;...
%     -44.08915,   1.23456,  23.05122,  -0.32998,  19.61677,  -1.10075;...
%     0.76714,  22.02458,   0.25159,  22.88448,   0.42424,  21.03761]; %FT11602
 
SIZE = 50;V %buffer size 
for i = 2:Operation_Time*10 - 5 
    % dividing sensor data in to arrays 
    % if S1 - S6 are force  sensor data (nano17), S7 is data from laser displacement sensor ... 
    S1 = vertcat(S1, NI_data(1:SIZE, 1, i)); 
    S2 = vertcat(S2, NI_data(1:SIZE, 2, i));
    S3 = vertcat(S3, NI_data(1:SIZE, 3, i));
    S4 = vertcat(S4, NI_data(1:SIZE, 4, i));
    S5 = vertcat(S5, NI_data(1:SIZE, 5, i));
    S6 = vertcat(S6, NI_data(1:SIZE, 6, i));
    S7 = vertcat(S7, NI_data(1:SIZE, 7, i));

    Time_Data = vertcat(Time_Data, time(1:SIZE,i));
    
    Sensor_data = vertcat(Sensor_data,data_MCU(1:SIZE,i)); % sensor data from MCU 
    
    S = [S1 S2 S3 S4 S5 S6]';
    for i= 1: length(Sensor_data)
        t(i) = i/600;
    end
    CS = C *S; % calibrating force sensor 
end

for i= 1: 5
    CS(i,1:end) = CS(i,1:end) - CS(i,2);
end

disp =  S7*2; % output voltage implies 1/2 of the displacement

%%
% Plotting graph and fitting data 
% delete first 3 data from data error
Curve_nano = -(CS(3,2:Operation_Time*500 - 300)' + CS(3,2)); %nano17 F_z
Curve_Fitting_nano_z = Curve_nano - min(Curve_nano);
Curve_Fitting_nano_y = CS(2,2:Operation_Time*500 - 300)' + CS(3,2); %nano 17 F_y
Curve_Fitting_baro = Sensor_data(2:Operation_Time*500 - 300); %barometer
Curve_disp= disp(2:Operation_Time*500 - 300)'; %laser
Curve_Fitting_disp = -(Curve_disp - max(Curve_disp))';
time = t(2:Operation_Time*500 - 300);

figure(1)
plot (time, Curve_nano)
title('nano17 data in time');

figure(2)
plot (time, Curve_Fitting_baro)
title('barometer data in time');

figure(3)
plot (Curve_nano, Curve_Fitting_baro)
title('nano17 - barometer');