
% Interrupt Event - 10 Hz

function stopWhenExceedStatus(src, event)

global count; 
global data; 
global time;
global Operation_Time;
global sequnce_count;
global OT;
global MT;
global mt;
global MCU;
global data_L;
global data_R;
global start;

    if any(event.TimeStamps >= Operation_Time) % Condition Setting
        % Continuous acquisitions need to be stopped explicitly.
        src.stop();
    else
        count = count+1;    
        start=1;
        
        S1 = event.Data(1:10, 1);
        S2 = event.Data(1:10, 2);
        S3 = event.Data(1:10, 3);
        S4 = event.Data(1:10, 4);
        S5 = event.Data(1:10, 5);
        S6 = event.Data(1:10, 6);
        S7 = event.Data(1:10, 7);

        fprintf(MCU,'L');
        Receive_Data = fscanf(MCU);
        D_Size1 = size(Receive_Data);
    
        if(D_Size1(2) > 10)
            Receive_Data_split = strsplit(Receive_Data, ',');
         
            if (strcmp(Receive_Data_split(1),'s') && (strcmp(Receive_Data_split(12), 'e')))
                data_L(1:10, count) = str2double(Receive_Data_split(2:11)); % Extract Data Element
            end
        end

        % Data save
        Data(:,:,count) = event.Data;
        data(:,:,count) = Data(:,:,count);
        Time = event.TimeStamps; % 20 x 1
        mt = min(Time);
        
        OT = OT + (max(Time) - min(Time)) - (MT - mt);
        time(:,count) = Time;
    
        MT = max(Time);
        
%         Plotting_Data = [S1, S2, S3, S4, S5, S6, data_L(1:20, count), data_R(1:20, count)];
%         
%         % Plotting
%         plot(event.TimeStamps,Plotting_Data); 
%         grid on;
%         legend('Force[N]','Displacement[mm]','Temperature[degC]','Input voltage');
%         ylim([-10 10])
        
    end
end