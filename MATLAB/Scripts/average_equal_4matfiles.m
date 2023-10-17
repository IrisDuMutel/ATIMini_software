clear variables
close all

% This file averages TWO equivalent data logs

%%%% For extended files containing voltages and time vector
ft_path = '../LogFiles/20231011/FT/';
rpm_path = '../LogFiles/20231011/RPM/';
file1 = 'log_20231011_10inch_Rinf_test4.csv';
file2 = 'log_20231011_10inch_Rinf_test3.csv';
file3 = 'log_20231011_10inch_Rinf_test5.csv';
file4 = 'log_20231011_10inch_Rinf_test6.csv';

filename = "log_20231011_10inch_Rinf_average.mat";

save_file = strcat(ft_path,filename);
title_size = 6;
points_to_avg = 100;


filepath1 = strcat(ft_path,file1);
filepath2 = strcat(ft_path,file2);
filepath3 = strcat(ft_path,file3);
filepath4 = strcat(ft_path,file4);

filepath1_rpm = strcat(rpm_path,file1);
filepath2_rpm = strcat(rpm_path,file2);
filepath3_rpm = strcat(rpm_path,file3);
filepath4_rpm = strcat(rpm_path,file4);

test1 = readtable(filepath1);
test2 = readtable(filepath2);
test3 = readtable(filepath3);
test4 = readtable(filepath4);
% rpm1  = readtable(filepath1_rpm);
% rpm2  = readtable(filepath2_rpm);
% rpm3  = readtable(filepath3_rpm);
% rpm4  = readtable(filepath4_rpm);

sampl_f1 = test1{1,1};                                                      % Sampling frequency of the signal
sampl_f2 = test2{1,1};                                                      % Sampling frequency of the signal
sampl_f3 = test3{1,1};                                                      % Sampling frequency of the signal
sampl_f4 = test4{1,1};                                                      % Sampling frequency of the signal
Ts1 = 1/sampl_f1;
Ts2 = 1/sampl_f2;
Ts3 = 1/sampl_f3;
Ts4 = 1/sampl_f4;
temp1 = test1{1,4};                                                         % Temperature
temp2 = test2{1,4};
temp3 = test3{1,4};
temp4 = test4{1,4};
pres1 = test1{1,5};                                                         % Pressure
pres2 = test2{1,5};
pres3 = test3{1,5};
pres4 = test4{1,5};


step_dur_insecs = 15;                                                       % Step duration in seconds (as specified in the arduino file)
aver_points = 0.7;                                                          % Percentage of each step to be taken for average
step_duration = step_dur_insecs/Ts1;                                        % Actual number of data points that make a step
segment_points = aver_points*step_duration;                                 % Number of points used for aveaging
offset_points  = 250;                                                       % points to be ignored from last step backward
steps_per_stair = 6;                                                        % How many steps is each stair


offset    = 1000;  % 3000 is 20s (offset*Ts = seconds)
fx_column = 1;
fy_column = 2;
fz_column = 3;
mx_column = 4;
my_column = 5;
mz_column = 6;

time1 = [0*Ts1:Ts1:Ts1*(length(test1{:,2})-2)];
time2 = [0*Ts2:Ts2:Ts2*(length(test2{:,2})-2)];
time3 = [0*Ts3:Ts3:Ts3*(length(test3{:,2})-2)];
time4 = [0*Ts4:Ts4:Ts4*(length(test4{:,2})-2)];

Fx1 = (test1{2:end,fx_column});
Fy1 = (test1{2:end,fy_column});
Fz1 = (test1{2:end,fz_column});
Mx1 = (test1{2:end,mx_column});
My1 = (test1{2:end,my_column});
Mz1 = (test1{2:end,mz_column});
Fx2 = (test2{2:end,fx_column});
Fy2 = (test2{2:end,fy_column});
Fz2 = (test2{2:end,fz_column});
Mx2 = (test2{2:end,mx_column});
My2 = (test2{2:end,my_column});
Mz2 = (test2{2:end,mz_column});
Fx3 = (test3{2:end,fx_column});
Fy3 = (test3{2:end,fy_column});
Fz3 = (test3{2:end,fz_column});
Mx3 = (test3{2:end,mx_column});
My3 = (test3{2:end,my_column});
Mz3 = (test3{2:end,mz_column});
Fx4 = (test4{2:end,fx_column});
Fy4 = (test4{2:end,fy_column});
Fz4 = (test4{2:end,fz_column});
Mx4 = (test4{2:end,mx_column});
My4 = (test4{2:end,my_column});
Mz4 = (test4{2:end,mz_column});


%% FFT and filtering

wpass_fx = 0.5;
wpass_fy = 0.5;
wpass_fz = 0.2;
wpass_mx = 0.5;
wpass_my = 0.5;
wpass_mz = 0.5;

f_cutoff = 0.5;
f_sampling = sampl_f1;
w_n = f_cutoff/(f_sampling/2);  % Cutoff frequency

[b_5,a_5] = butter(5,w_n,'low');   % Create Butterworth filter of order 5

%%% Filtering
% filtered_Fx1 = lowpass(Fx1,wpass_fx,sampl_f1);
% filtered_Fy1 = lowpass(Fy1,wpass_fy,sampl_f1);
% filtered_Fz1 = lowpass(Fz1,wpass_fz,sampl_f1);
% filtered_Mx1 = lowpass(Mx1,wpass_mx,sampl_f1);
% filtered_My1 = lowpass(My1,wpass_my,sampl_f1);
% filtered_Mz1 = lowpass(Mz1,wpass_mz,sampl_f1);
% 
% filtered_Fx2 = lowpass(Fx2,wpass_fx,sampl_f1);
% filtered_Fy2 = lowpass(Fy2,wpass_fy,sampl_f1);
% filtered_Fz2 = lowpass(Fz2,wpass_fz,sampl_f1);
% filtered_Mx2 = lowpass(Mx2,wpass_mx,sampl_f1);
% filtered_My2 = lowpass(My2,wpass_my,sampl_f1);
% filtered_Mz2 = lowpass(Mz2,wpass_mz,sampl_f1);
% 
% filtered_Fx3 = lowpass(Fx3,wpass_fx,sampl_f1);
% filtered_Fy3 = lowpass(Fy3,wpass_fy,sampl_f1);
% filtered_Fz3 = lowpass(Fz3,wpass_fz,sampl_f1);
% filtered_Mx3 = lowpass(Mx3,wpass_mx,sampl_f1);
% filtered_My3 = lowpass(My3,wpass_my,sampl_f1);
% filtered_Mz3 = lowpass(Mz3,wpass_mz,sampl_f1);
% 
% filtered_Fx4 = lowpass(Fx4,wpass_fx,sampl_f1);
% filtered_Fy4 = lowpass(Fy4,wpass_fy,sampl_f1);
% filtered_Fz4 = lowpass(Fz4,wpass_fz,sampl_f1);
% filtered_Mx4 = lowpass(Mx4,wpass_mx,sampl_f1);
% filtered_My4 = lowpass(My4,wpass_my,sampl_f1);
% filtered_Mz4 = lowpass(Mz4,wpass_mz,sampl_f1);

filtered_Fx1 = filter(b_5, a_5,Fx1);
filtered_Fy1 = filter(b_5, a_5,Fy1);
filtered_Fz1 = filter(b_5, a_5,Fz1);
filtered_Mx1 = filter(b_5, a_5,Mx1);
filtered_My1 = filter(b_5, a_5,My1);
filtered_Mz1 = filter(b_5, a_5,Mz1);

filtered_Fx2 = filter(b_5, a_5,Fx2);
filtered_Fy2 = filter(b_5, a_5,Fy2);
filtered_Fz2 = filter(b_5, a_5,Fz2);
filtered_Mx2 = filter(b_5, a_5,Mx2);
filtered_My2 = filter(b_5, a_5,My2);
filtered_Mz2 = filter(b_5, a_5,Mz2);

filtered_Fx3 = filter(b_5, a_5,Fx3);
filtered_Fy3 = filter(b_5, a_5,Fy3);
filtered_Fz3 = filter(b_5, a_5,Fz3);
filtered_Mx3 = filter(b_5, a_5,Mx3);
filtered_My3 = filter(b_5, a_5,My3);
filtered_Mz3 = filter(b_5, a_5,Mz3);

filtered_Fx4 = filter(b_5, a_5,Fx4);
filtered_Fy4 = filter(b_5, a_5,Fy4);
filtered_Fz4 = filter(b_5, a_5,Fz4);
filtered_Mx4 = filter(b_5, a_5,Mx4);
filtered_My4 = filter(b_5, a_5,My4);
filtered_Mz4 = filter(b_5, a_5,Mz4);


%%% Offset removal
filtered_Fx1 = filtered_Fx1(1:end) - filtered_Fx1(offset);
filtered_Fy1 = filtered_Fy1(1:end) - filtered_Fy1(offset);
filtered_Fz1 = filtered_Fz1(1:end) - filtered_Fz1(offset);
filtered_Mx1 = filtered_Mx1(1:end) - filtered_Mx1(offset);
filtered_My1 = filtered_My1(1:end) - filtered_My1(offset);
filtered_Mz1 = filtered_Mz1(1:end) - filtered_Mz1(offset);

filtered_Fx2 = filtered_Fx2(1:end) - filtered_Fx2(offset);
filtered_Fy2 = filtered_Fy2(1:end) - filtered_Fy2(offset);
filtered_Fz2 = filtered_Fz2(1:end) - filtered_Fz2(offset);
filtered_Mx2 = filtered_Mx2(1:end) - filtered_Mx2(offset);
filtered_My2 = filtered_My2(1:end) - filtered_My2(offset);
filtered_Mz2 = filtered_Mz2(1:end) - filtered_Mz2(offset);

filtered_Fx3 = filtered_Fx3(1:end) - filtered_Fx3(offset);
filtered_Fy3 = filtered_Fy3(1:end) - filtered_Fy3(offset);
filtered_Fz3 = filtered_Fz3(1:end) - filtered_Fz3(offset);
filtered_Mx3 = filtered_Mx3(1:end) - filtered_Mx3(offset);
filtered_My3 = filtered_My3(1:end) - filtered_My3(offset);
filtered_Mz3 = filtered_Mz3(1:end) - filtered_Mz3(offset);

filtered_Fx4 = filtered_Fx4(1:end) - filtered_Fx4(offset);
filtered_Fy4 = filtered_Fy4(1:end) - filtered_Fy4(offset);
filtered_Fz4 = filtered_Fz4(1:end) - filtered_Fz4(offset);
filtered_Mx4 = filtered_Mx4(1:end) - filtered_Mx4(offset);
filtered_My4 = filtered_My4(1:end) - filtered_My4(offset);
filtered_Mz4 = filtered_Mz4(1:end) - filtered_Mz4(offset);


%%%% Data without base offsets (Check point that everything is fine)
% FORCES
figure()
subplot(3,1,1)
hold on
title(strcat(file1,' ---vs--- ',file2),'FontSize',title_size,'Interpreter','none')
plot(time1,filtered_Fx1,'linewidth',1.5)
plot(time2,filtered_Fx2,'linewidth',1.5)
plot(time3,filtered_Fx3,'linewidth',1.5)
plot(time4,filtered_Fx4,'linewidth',1.5)
ylim([-3 3])
grid on
ylabel('Fx [N]')
subplot(3,1,2)
hold on
plot(time1,filtered_Fy1,'linewidth',1.5)
plot(time2,filtered_Fy2,'linewidth',1.5)
plot(time3,filtered_Fy3,'linewidth',1.5)
plot(time4,filtered_Fy4,'linewidth',1.5)
ylim([-3 3])
grid on
ylabel('Fy [N]')
subplot(3,1,3)
hold on
plot(time1,filtered_Fz1,'linewidth',1.5)
plot(time2,filtered_Fz2,'linewidth',1.5)
plot(time3,filtered_Fz3,'linewidth',1.5)
plot(time4,filtered_Fz4,'linewidth',1.5)
grid on
ylabel('Fz [N]')
xlabel('Time [s]')
grid on

% TORQUES
figure()
subplot(3,1,1)
hold on
title(strcat(file1,' ---vs--- ',file2),'FontSize',title_size,'Interpreter','none')
plot(time1,filtered_Mx1,'linewidth',1.5)
plot(time2,filtered_Mx2,'linewidth',1.5)
plot(time3,filtered_Mx3,'linewidth',1.5)
plot(time4,filtered_Mx4,'linewidth',1.5)
ylim([-0.1 0.15])
grid on
ylabel('Mx [N·m]')
subplot(3,1,2)
hold on
plot(time1,filtered_My1,'linewidth',1.5)
plot(time2,filtered_My2,'linewidth',1.5)
plot(time3,filtered_My3,'linewidth',1.5)
plot(time4,filtered_My4,'linewidth',1.5)
ylim([-0.1 0.15])
grid on
ylabel('My [N·m]')
subplot(3,1,3)
hold on
plot(time1,filtered_Mz1,'linewidth',1.5)
plot(time2,filtered_Mz2,'linewidth',1.5)
plot(time3,filtered_Mz3,'linewidth',1.5)
plot(time4,filtered_Mz4,'linewidth',1.5)
ylim([-0.1 0.15])
grid on
ylabel('Mz [N·m]')
xlabel('Time [s]')
grid on


%% %%% Automatic point selection for multiple files

Fhtal1 = filtered_Fy1;
Mhtal1 = filtered_Mx1;
ti1    = time1;
Fhtal2 = filtered_Fy2;
Mhtal2 = filtered_Mx2;
ti2    = time2;
Fhtal3 = filtered_Fy3;
Mhtal3 = filtered_Mx3;
ti3    = time3;
Fhtal4 = filtered_Fy4;
Mhtal4 = filtered_Mx4;
ti4    = time4;

Fz1 = filtered_Fz1;
Fz2 = filtered_Fz2;
Fz3 = filtered_Fz3;
Fz4 = filtered_Fz4;

diff1 = 0;                                                                  % gradient initialization
diff2 = 0;                                                                  % gradient initialization
diff3 = 0;                                                                  % gradient initialization
diff4 = 0;                                                                  % gradient initialization

Force_z1 = [];
Force_z2 = [];
Force_z3 = [];
Force_z4 = [];

timing1  = [];
timing2  = [];
timing3  = [];
timing4  = [];

Force_z1_off = [];
Force_z2_off = [];
Force_z3_off = [];
Force_z4_off = [];

for i=1:1:length(Fz1)-1   
    diff1 = [diff1; (Fz1(i)-Fz1(i+1))/Ts1];                                 % compute the gradient at Ts1
end   
for i=1:1:length(Fz2)-1   
    diff2 = [diff2; (Fz2(i)-Fz2(i+1))/Ts2];                                 % compute the gradient at Ts2
end
for i=1:1:length(Fz3)-1   
    diff3 = [diff3; (Fz3(i)-Fz3(i+1))/Ts3];                                 % compute the gradient at Ts2
end
for i=1:1:length(Fz4)-1   
    diff4 = [diff4; (Fz4(i)-Fz4(i+1))/Ts4];                                 % compute the gradient at Ts2
end

figure()
title('Check that derivative selection is right')
hold on;grid on;
plot(time2/Ts1, filtered_Fz2,'linewidth',2)
plot(time2/Ts1, diff2)
legend('Filtered data', 'Derivative')
xlabel('Datapoints')
ylabel('Data value')

% [~,C1] = maxk(abs(diff1),10);                                               % get the 10 maximum values in the gradient
% [~,C2] = maxk(abs(diff2),10);
% [~,C3] = maxk(abs(diff3),10);
% [~,C4] = maxk(abs(diff4),10);
[A1,C1] = find(abs(diff1)>8);                                               % get the 10 maximum values in the gradient
[A2,C2] = find(abs(diff2)>8);
[A3,C3] = find(abs(diff3)>8);
[A4,C4] = find(abs(diff4)>8);

time_stamp1 = maxk(A1,1):-step_duration:1;                                  % adjust timestamp depending on step duration
time_stamp2 = maxk(A2,1):-step_duration:1;                                  % adjust timestamp depending on step duration
time_stamp3 = maxk(A3,1):-step_duration:1;                                  % adjust timestamp depending on step duration
time_stamp4 = maxk(A4,1):-step_duration:1;                                  % adjust timestamp depending on step duration


timestamp1 = [];
for i=1:1:length(time_stamp1)                                              % Create timestamp vector of smaller segments
    time_stamp1(i) = time_stamp1(i)-offset_points;
    ending = time_stamp1(i)-segment_points;
    timestamp1 = [timestamp1;time_stamp1(i);ending];
end


timestamp2 = [];
for i=1:1:length(time_stamp2)                                              % Create timestamp vector of smaller segments
    time_stamp2(i) = time_stamp2(i)-offset_points;
    ending = time_stamp2(i)-segment_points;
    timestamp2 = [timestamp2;time_stamp2(i);ending];
end

timestamp3 = [];
for i=1:1:length(time_stamp3)                                              % Create timestamp vector of smaller segments
    time_stamp3(i) = time_stamp3(i)-offset_points;
    ending = time_stamp3(i)-segment_points;
    timestamp3 = [timestamp3;time_stamp3(i);ending];
end

timestamp4 = [];
for i=1:1:length(time_stamp4)                                             % Create timestamp vector of smaller segments
    time_stamp4(i) = time_stamp4(i)-offset_points;
    ending = time_stamp4(i)-segment_points;
    timestamp4 = [timestamp4;time_stamp4(i);ending];
end

timestamp1 = sort(timestamp1);
timestamp2 = sort(timestamp2);
timestamp3 = sort(timestamp3);
timestamp4 = sort(timestamp4);

% Finding the average position in time
for i = 1:2:length(timestamp1)-1              
    timing1  = [timing1;mean(abs(timestamp1(i:i+1)))];    
end
% Compute the average of the force of points_to_avg centered in timing(i)
for i=1:length(timing1)
    Force_z1 = [Force_z1; mean(Fz1(timing1(i)-points_to_avg/2:timing1(i)+points_to_avg/2))] ;
end
% Finding offsets and removing them
D1 = find(Force_z1==Force_z1(end-steps_per_stair+1));                      
D1 = max(D1);
E1 = [D1:-steps_per_stair:1];
positions1 = sort(E1);
F_z_1 =[Fz1(1:timing1(positions1(1)))-Force_z1(positions1(1))];
for i = 1:length(positions1)-1
    F_z_1 = [F_z_1;Fz1(timing1(positions1(i))+1:timing1(positions1(i+1)))-Force_z1(positions1(i))];
end
F_z_1 = [F_z_1;Fz1(timing1(positions1(end))+1:end)-Force_z1(positions1(end))];
% We compute again the average values of the segments
for i = 1:length(timing1)             % Compute average of force in such timestamp
    Force_z1_off = [Force_z1_off;mean(F_z_1(timing1(i)-points_to_avg/2:timing1(i)+points_to_avg/2))];
end


% Finding the average position in time
for i = 1:2:length(timestamp2)-1              
    timing2  = [timing2;mean(abs(timestamp2(i:i+1)))];    
end
% Compute the average of the force of points_to_avg centered in timing(i)
for i=1:length(timing2)
    Force_z2 = [Force_z2; mean(Fz2(timing2(i)-points_to_avg/2:timing2(i)+points_to_avg/2))] ;
end
% Finding offsets and removing them
D2 = find(Force_z2==Force_z2(end-steps_per_stair+1));
D2 = max(D2);
E2 = [D2:-steps_per_stair:1];
positions2 = sort(E2);
F_z_2 =[Fz2(1:timing2(positions2(1)))-Force_z2(positions2(1))];
for i = 1:length(positions2)-1
    F_z_2 = [F_z_2;Fz2(timing2(positions2(i))+1:timing2(positions2(i+1)))-Force_z2(positions2(i))];
end
F_z_2 = [F_z_2;Fz2(timing2(positions2(end))+1:end)-Force_z2(positions2(end))];
% We compute again the average values of the segments
for i = 1:length(timing2)             % Compute average of force in such timestamp
    Force_z2_off = [Force_z2_off;mean(F_z_2(timing2(i)-points_to_avg/2:timing2(i)+points_to_avg/2))];
end



% Finding the average position in time
for i = 1:2:length(timestamp3)-1              
    timing3  = [timing3;mean(abs(timestamp3(i:i+1)))];    
end
% Compute the average of the force of points_to_avg centered in timing(i)
for i=1:length(timing3)
    Force_z3 = [Force_z3; mean(Fz3(timing3(i)-points_to_avg/2:timing3(i)+points_to_avg/2))] ;
end
% Finding offsets and removing them
D3 = find(Force_z3==Force_z3(end-steps_per_stair+1));
D3 = max(D3);
E3 = [D3:-steps_per_stair:1];
positions3 = sort(E3);
F_z_3 =[Fz3(1:timing3(positions3(1)))-Force_z3(positions3(1))];
for i = 1:length(positions3)-1
    F_z_3 = [F_z_3;Fz3(timing3(positions3(i))+1:timing3(positions3(i+1)))-Force_z3(positions3(i))];
end
F_z_3 = [F_z_3;Fz3(timing3(positions3(end))+1:end)-Force_z3(positions3(end))];
% We compute again the average values of the segments
for i = 1:length(timing3)             % Compute average of force in such timestamp
    Force_z3_off = [Force_z3_off;mean(F_z_3(timing3(i)-points_to_avg/2:timing3(i)+points_to_avg/2))];
end



% Finding the average position in time
for i = 1:2:length(timestamp4)-1              
    timing4  = [timing4;mean(abs(timestamp4(i:i+1)))];    
end
% Compute the average of the force of points_to_avg centered in timing(i)
for i=1:length(timing4)
    Force_z4 = [Force_z4; mean(Fz4(timing4(i)-points_to_avg/2:timing4(i)+points_to_avg/2))] ;
end
% Finding offsets and removing them
D4 = find(Force_z4==Force_z4(end-steps_per_stair+1));
D4 = max(D4);
E4 = [D4:-steps_per_stair:1];
positions4 = sort(E4);
F_z_4 =[Fz4(1:timing4(positions4(1)))-Force_z4(positions4(1))];
for i = 1:length(positions4)-1
    F_z_4 = [F_z_4;Fz4(timing4(positions4(i))+1:timing4(positions4(i+1)))-Force_z4(positions4(i))];
end
F_z_4 = [F_z_4;Fz4(timing4(positions4(end))+1:end)-Force_z4(positions4(end))];
% We compute again the average values of the segments
for i = 1:length(timing4)             % Compute average of force in such timestamp
    Force_z4_off = [Force_z4_off;mean(F_z_4(timing4(i)-points_to_avg/2:timing4(i)+points_to_avg/2))];
end


while length(Force_z1_off)<=11
    Force_z1_off = [0;Force_z1_off];
    timing1  = [points_to_avg+1;timing1];
end
while length(Force_z2_off)<=11
    Force_z2_off = [0;Force_z2_off];
    timing2  = [points_to_avg+1;timing2];
end
while length(Force_z3_off)<=11
    Force_z3_off = [0;Force_z3_off];
    timing3  = [points_to_avg+1;timing3];
end
while length(Force_z4_off)<=11
    Force_z4_off = [0;Force_z4_off];
    timing4  = [points_to_avg+1;timing4];
end

F_z1_off = Force_z1_off;
F_z2_off = Force_z2_off;
F_z3_off = Force_z3_off;
F_z4_off = Force_z4_off;

i=1;
while length(F_z1_off)>12
    F_z1_off(1) = [];
    i = i + 1;
end
i=1;
while length(F_z2_off)>12
    F_z2_off(1) = [];
    i = i + 1;
end
i=1;
while length(F_z3_off)>12
    F_z3_off(1) = [];
    i = i + 1;
end
i=1;
while length(F_z4_off)>12
    F_z4_off(1) = [];
    i = i + 1;
end



%%%%% H. Force %%%%%
Force_1 = [];
Force_2 = [];
Force_3 = [];
Force_4 = [];
Force_1_off = [];
Force_2_off = [];
Force_3_off = [];
Force_4_off = [];

for i=1:length(timing1)
    Force_1 = [Force_1; mean(Fhtal1(timing1(i)-points_to_avg/2:timing1(i)+points_to_avg/2))] ;
end
F_1 = Fhtal1(1:timing1(positions1(1)))-Force_1(positions1(1));
for i = 1:length(positions1)-1
    F_1 = [F_1;Fhtal1(timing1(positions1(i))+1:timing1(positions1(i+1)))-Force_1(positions1(i))];
end
F_1 = [F_1;Fhtal1(timing1(positions1(end))+1:end)-Force_1(positions1(end))];
% We compute again the average values of the segments
for i = 1:length(timing1)             % Compute average of force in such timestamp
    Force_1_off = [Force_1_off;mean(F_1(timing1(i)-points_to_avg/2:timing1(i)+points_to_avg/2))];
end


for i=1:length(timing2)
    Force_2 = [Force_2; mean(Fhtal2(timing2(i)-points_to_avg/2:timing2(i)+points_to_avg/2))] ;
end
F_2 =Fhtal2(1:timing2(positions2(1)))-Force_2(positions2(1));
for i = 1:length(positions2)-1
    F_2 = [F_2;Fhtal2(timing2(positions2(i))+1:timing2(positions2(i+1)))-Force_2(positions2(i))];
end
F_2 = [F_2;Fhtal2(timing2(positions2(end))+1:end)-Force_2(positions2(end))];
% We compute again the average values of the segments
for i = 1:length(timing2)             % Compute average of force in such timestamp
    Force_2_off = [Force_2_off;mean(F_2(timing2(i)-points_to_avg/2:timing2(i)+points_to_avg/2))];
end

for i=1:length(timing3)
    Force_3 = [Force_3; mean(Fhtal3(timing3(i)-points_to_avg/2:timing3(i)+points_to_avg/2))] ;
end
F_3 =Fhtal3(1:timing3(positions3(1)))-Force_3(positions3(1));
for i = 1:length(positions3)-1
    F_3 = [F_3;Fhtal3(timing3(positions3(i))+1:timing3(positions3(i+1)))-Force_3(positions3(i))];
end
F_3 = [F_3;Fhtal3(timing3(positions3(end))+1:end)-Force_3(positions3(end))];
% We compute again the average values of the segments
for i = 1:length(timing3)             % Compute average of force in such timestamp
    Force_3_off = [Force_3_off;mean(F_3(timing3(i)-points_to_avg/2:timing3(i)+points_to_avg/2))];
end

for i=1:length(timing4)
    Force_4 = [Force_4; mean(Fhtal4(timing4(i)-points_to_avg/2:timing4(i)+points_to_avg/2))] ;
end
F_4 =Fhtal4(1:timing4(positions4(1)))-Force_4(positions4(1));
for i = 1:length(positions4)-1
    F_4 = [F_4;Fhtal4(timing4(positions4(i))+1:timing4(positions4(i+1)))-Force_4(positions4(i))];
end
F_4 = [F_4;Fhtal4(timing4(positions4(end))+1:end)-Force_4(positions4(end))];
% We compute again the average values of the segments
for i = 1:length(timing4)             % Compute average of force in such timestamp
    Force_4_off = [Force_4_off;mean(F_4(timing4(i)-points_to_avg/2:timing4(i)+points_to_avg/2))];
end


while length(Force_1_off)<=11
    Force_1_off = [0;Force_1_off];
end
while length(Force_2_off)<=11
    Force_2_off = [0;Force_2_off];
end
while length(Force_3_off)<=11
    Force_3_off = [0;Force_3_off];
end
while length(Force_4_off)<=11
    Force_4_off = [0;Force_4_off];
end


%%%%% Torque %%%%%
Torque1 = [];
Torque2 = [];
Torque3 = [];
Torque4 = [];
Torque_1_off = [];
Torque_2_off = [];
Torque_3_off = [];
Torque_4_off = [];


for i = 1:length(timing1)
    Torque1 = [Torque1; mean(Mhtal1(timing1(i)-points_to_avg/2:timing1(i)+points_to_avg/2))];
end
M_x_1 = Mhtal1(1:timing1(positions1(1)))-Torque1(positions1(1));
for i = 1:length(positions1)-1
    M_x_1 = [M_x_1;Mhtal1(timing1(positions1(i))+1:timing1(positions1(i+1)))-Torque1(positions1(i))];
end
M_x_1 = [M_x_1;Mhtal1(timing1(positions1(end))+1:end)-Torque1(positions1(end))];
% We compute again the average values of the segments
for i = 1:length(timing1)             % Compute average of force in such timestamp
    Torque_1_off = [Torque_1_off;mean(M_x_1(timing1(i)-points_to_avg/2:timing1(i)+points_to_avg/2))];
end


for i = 1:length(timing2)
    Torque2 = [Torque2; mean(Mhtal2(timing2(i)-points_to_avg/2:timing2(i)+points_to_avg/2))];
end
M_x_2 = Mhtal2(1:timing2(positions2(1)))-Torque2(positions2(1));
for i = 1:length(positions2)-1
    M_x_2 = [M_x_2;Mhtal2(timing2(positions2(i))+1:timing2(positions2(i+1)))-Torque2(positions2(i))];
end
M_x_2 = [M_x_2;Mhtal2(timing2(positions2(end))+1:end)-Torque2(positions2(end))];
% We compute again the average values of the segments
for i = 1:length(timing2)             % Compute average of force in such timestamp
    Torque_2_off = [Torque_2_off;mean(M_x_2(timing2(i)-points_to_avg/2:timing2(i)+points_to_avg/2))];
end


for i = 1:length(timing3)
    Torque3 = [Torque3; mean(Mhtal3(timing3(i)-points_to_avg/2:timing3(i)+points_to_avg/2))];
end
M_x_3 = Mhtal3(1:timing3(positions3(1)))-Torque3(positions3(1));
for i = 1:length(positions2)-1
    M_x_3 = [M_x_3;Mhtal3(timing3(positions3(i))+1:timing3(positions3(i+1)))-Torque3(positions3(i))];
end
M_x_3 = [M_x_3;Mhtal3(timing3(positions3(end))+1:end)-Torque3(positions3(end))];
% We compute again the average values of the segments
for i = 1:length(timing3)             % Compute average of force in such timestamp
    Torque_3_off = [Torque_3_off;mean(M_x_3(timing3(i)-points_to_avg/2:timing3(i)+points_to_avg/2))];
end


for i = 1:length(timing4)
    Torque4 = [Torque4; mean(Mhtal4(timing4(i)-points_to_avg/2:timing4(i)+points_to_avg/2))];
end
M_x_4 = Mhtal4(1:timing4(positions4(1)))-Torque4(positions4(1));
for i = 1:length(positions4)-1
    M_x_4 = [M_x_4;Mhtal4(timing4(positions4(i))+1:timing4(positions4(i+1)))-Torque4(positions4(i))];
end
M_x_4 = [M_x_4;Mhtal4(timing4(positions4(end))+1:end)-Torque4(positions4(end))];
% We compute again the average values of the segments
for i = 1:length(timing4)             % Compute average of force in such timestamp
    Torque_4_off = [Torque_4_off;mean(M_x_4(timing4(i)-points_to_avg/2:timing4(i)+points_to_avg/2))];
end


while length(Torque_1_off)<=11
    Torque_1_off = [0;Torque_1_off];
end
while length(Torque_2_off)<=11
    Torque_2_off = [0;Torque_2_off];
end
while length(Torque_3_off)<=11
    Torque_3_off = [0;Torque_3_off];
end
while length(Torque_4_off)<=11
    Torque_4_off = [0;Torque_4_off];
end


auto.timestamp{1} = timestamp1;
auto.timestamp{2} = timestamp2;
auto.timestamp{3} = timestamp3;
auto.timestamp{4} = timestamp4;
auto.timing{1} = timing1;
auto.timing{2} = timing2;
auto.timing{3} = timing3;
auto.timing{4} = timing4;

myvars.Fy{1} = F_1;
myvars.Fy{2} = F_2;
myvars.Fy{3} = F_3;
myvars.Fy{4} = F_4;

myvars.Fz{1} = F_z_1;
myvars.Fz{2} = F_z_2;
myvars.Fz{3} = F_z_3;
myvars.Fz{4} = F_z_4;

myvars.Mx{1} = M_x_1;
myvars.Mx{2} = M_x_2;
myvars.Mx{3} = M_x_3;
myvars.Mx{4} = M_x_4;

myvars.t{1} = ti1';
myvars.t{2} = ti2';
myvars.t{3} = ti3';
myvars.t{4} = ti4';


%%% WE HAVE THE FOLLOWING VARIABLES AVAILABLE: %%%
%%% Horizontal Forces: Fy
%%% Horizontal Torques: Mx
%%% Force_z
%%% times
%%% These stucts contain the variables of each datafile


% Plot of Fz removing offsets and marking all levels average
figure()
hold on
plot(time1,diff1);
plot(time2,diff2);
plot(time3,diff3);
plot(time4,diff4);
plot(ti1,filtered_Fz1,'lineWidth',1.5)
plot(ti2,filtered_Fz2,'lineWidth',1.5)
plot(ti3,filtered_Fz3,'lineWidth',1.5)
plot(ti4,filtered_Fz4,'lineWidth',1.5)
plot(timestamp1*Ts1,ones(length(timestamp1),1),'x','lineWidth',2,'MarkerSize',8)
plot(timestamp2*Ts2,ones(length(timestamp2),1),'x','lineWidth',2,'MarkerSize',8)
plot(timestamp3*Ts3,ones(length(timestamp3),1),'x','lineWidth',2,'MarkerSize',8)
plot(timestamp4*Ts4,ones(length(timestamp4),1),'x','lineWidth',2,'MarkerSize',8)
grid on
plot(timing1*Ts1,Force_z1_off,'x','color','k','lineWidth',2,'MarkerSize',6)
plot(timing2*Ts2,Force_z2_off,'x','color','b','lineWidth',2,'MarkerSize',6)
plot(timing3*Ts3,Force_z3_off,'x','color','r','lineWidth',2,'MarkerSize',6)
plot(timing4*Ts4,Force_z4_off,'x','color','g','lineWidth',2,'MarkerSize',6)
ylabel('Fz no offsets [N] ')
legend("Data 1", "Data 2", "Data 3", "Data 4")
title("Interval selection and averaging")
xlabel('Time [s]')
hold off


figure()
hold on; grid on;
plot(ti1,filtered_Fy1,'lineWidth',1.5)
plot(ti2,filtered_Fy2,'lineWidth',1.5)
plot(ti3,filtered_Fy3,'lineWidth',1.5)
plot(ti4,filtered_Fy4,'lineWidth',1.5)
plot(timing1*Ts1,Force_1_off,'x','color','k','lineWidth',2,'MarkerSize',6)
plot(timing2*Ts2,Force_2_off,'x','color','b','lineWidth',2,'MarkerSize',6)
plot(timing3*Ts3,Force_3_off,'x','color','b','lineWidth',2,'MarkerSize',6)
plot(timing4*Ts4,Force_4_off,'x','color','b','lineWidth',2,'MarkerSize',6)
ylabel('Fy no offsets [N]')
legend("Data 1", "Data 2", "Data 3", "Data 4")
title("Interval selection and averaging")
xlabel('Time [s]')
hold off


figure()
hold on; grid on;
plot(ti1,filtered_Mx1,'lineWidth',1.5)
plot(ti2,filtered_Mx2,'lineWidth',1.5)
plot(ti3,filtered_Mx3,'lineWidth',1.5)
plot(ti4,filtered_Mx4,'lineWidth',1.5)
plot(timing1*Ts1,Torque_1_off,'x','color','k','lineWidth',2,'MarkerSize',6)
plot(timing2*Ts2,Torque_2_off,'x','color','b','lineWidth',2,'MarkerSize',6)
plot(timing3*Ts3,Torque_3_off,'x','color','b','lineWidth',2,'MarkerSize',6)
plot(timing4*Ts4,Torque_4_off,'x','color','b','lineWidth',2,'MarkerSize',6)
ylabel('Mx no offsets [Nm]')
legend("Data 1", "Data 2", "Data 3", "Data 4")
title("Interval selection and averaging")
xlabel('Time [s]')
hold off

%% Alignment of the tests

timestamps = zeros(1,length(auto.timestamp));
KJ = 1;
timelength = length(myvars.t{1});
for i = 1:length(auto.timestamp)
    timestamps(i) = auto.timestamp{i}(end);                                % Store all timestamp ends on one vector
    if length(myvars.t{i}) < timelength
        timelength = length(myvars.t{i});
        KJ = i;
    end
end

[~,KK] = mink(timestamps,1);                                                % Find the minimum of the ends, which is going to be the reference for the rest of the tests

reference_point = timestamps(KK);
for i=1:length(timestamps)                                                  % Obtain how many points need to be cut from the rest of the data, except for the reference
    timestamps(i) = timestamps(i)-reference_point;
    if timestamps(i) == 0
        timestamps(i) = 1;
    end
end


fn = fieldnames(myvars);
for k=1:numel(fn)-1
    for i = 1:length(timestamps)
        myvars.(fn{k}){i} = myvars.(fn{k}){i}(timestamps(i):end,:);
    end
end

for i = 1:length(timestamps)
    myvars.t{i} = myvars.t{i}(timestamps(i):end-1,:);
end

for j = 1:length(timestamps)
    myvars.t{j} = myvars.t{j} - myvars.t{j}(1,1);
end

% Finding shortest data vector
vector_lengths = zeros(1,length(timestamps));
for i =1:length(timestamps)
    vector_lengths(1,i) = length(myvars.Fy{i});
end
[~,KL] = maxk(vector_lengths,1);

% figure()
% hold on; grid on;
% plot(myvars.t{1},myvars.Fz{1},'linewidth',2)
% plot(myvars.t{2},myvars.Fz{2},'linewidth',2)
% plot(myvars.t{3},myvars.Fz{3},'linewidth',2)
% plot(myvars.t{4},myvars.Fz{4},'linewidth',2)


% Forcing equal lengths
for k=1:numel(fn)-1
    for i = 1:length(timestamps)
        myvars.(fn{k}){i} = [myvars.(fn{k}){i};zeros(vector_lengths(KL)-vector_lengths(i),1)];
    end
end 

for i = 1:length(timestamps)
    myvars.t{i} = [0:Ts1:(vector_lengths(KL)-1)*Ts1];
end


% Check alignment
figure()
subplot(3,1,1)
title("Alignment check")
hold on; grid on;
plot(myvars.t{1},myvars.Mx{1},'lineWidth',1.5)
plot(myvars.t{2},myvars.Mx{2},'lineWidth',1.5)
plot(myvars.t{3},myvars.Mx{3},'lineWidth',1.5)
plot(myvars.t{4},myvars.Mx{4},'lineWidth',1.5)
ylabel("M_x [N]")
subplot(3,1,2)
hold on; grid on;
plot(myvars.t{1},myvars.Fy{1},'lineWidth',1.5)
plot(myvars.t{2},myvars.Fy{2},'lineWidth',1.5)
plot(myvars.t{3},myvars.Fy{3},'lineWidth',1.5)
plot(myvars.t{4},myvars.Fy{4},'lineWidth',1.5)
ylabel("F_y [N]")
subplot(3,1,3)
hold on; grid on;
plot(myvars.t{1},myvars.Fz{1},'lineWidth',1.5)
plot(myvars.t{2},myvars.Fz{2},'lineWidth',1.5)
plot(myvars.t{3},myvars.Fz{3},'lineWidth',1.5)
plot(myvars.t{4},myvars.Fz{4},'lineWidth',1.5)
xlabel("Time [s]")
ylabel("F_z [N]")


%% Averaging the final result


myvars.tot_Fy = zeros(vector_lengths(KL),1);
 for i = 1:length(timestamps)
     myvars.tot_Fy = myvars.tot_Fy + myvars.Fy{i};
 end
 myvars.tot_Fy = myvars.tot_Fy/i;

 myvars.tot_Mx = zeros(vector_lengths(KL),1);
 for i = 1:length(timestamps)
     myvars.tot_Mx = myvars.tot_Mx + myvars.Mx{i};
 end
 myvars.tot_Mx = myvars.tot_Mx/i;

 myvars.tot_Fz = zeros(vector_lengths(KL),1);
 for i = 1:length(timestamps)
     myvars.tot_Fz = myvars.tot_Fz + myvars.Fz{i};
 end
 myvars.tot_Fz = myvars.tot_Fz/i;


%  %%% Find maximum points
F = myvars.tot_Fy;
M = myvars.tot_Mx;
ti = myvars.t{KJ};
Fz = myvars.tot_Fz;

Force_z_avg  = [];
Force_y_avg  = [];
Torque_x_avg = [];

timing    = auto.timing{KJ};
% Finding the average value of each segment and it's position in time
for i = 1:length(timing)              % Compute average of force in such timestamp
    Force_z_avg = [Force_z_avg;mean(Fz(timing(i)-points_to_avg/2:timing(i)+points_to_avg/2))];
end
for i = 1:length(timing)              % Compute average of force in such timestamp
    Force_y_avg = [Force_y_avg;mean(F(timing(i)-points_to_avg/2:timing(i)+points_to_avg/2))];
end
for i = 1:length(timing)              % Compute average of force in such timestamp
    Torque_x_avg = [Torque_x_avg;mean(M(timing(i)-points_to_avg/2:timing(i)+points_to_avg/2))];
end


 % Display mean
figure()
subplot(3,1,1)
title("Result of average")
hold on; grid on;
plot(myvars.t{KJ},myvars.tot_Mx,'lineWidth',1.5)
plot(timing*Ts1, Torque_x_avg, 'x', 'LineWidth',2,'MarkerSize',7)
ylabel("M_x avg [N]")
subplot(3,1,2)
hold on; grid on;
plot(myvars.t{KJ},myvars.tot_Fy,'lineWidth',1.5)
plot(timing*Ts1, Force_y_avg, 'x', 'LineWidth',2,'MarkerSize',7)
ylabel("F_y avg [N]")
subplot(3,1,3)
hold on; grid on;
plot(myvars.t{KJ},myvars.tot_Fz,'lineWidth',1.5)
plot(timing*Ts1, Force_z_avg, 'x', 'LineWidth',2,'MarkerSize',7)
xlabel("Time [s]")
ylabel("F_z avg [N]")
hold off

%% Saving the data into a csv file that can be later on used

result.files{1} = file1;
result.files{2} = file2;

result.time = myvars.t{KJ};
result.Fy = myvars.tot_Fy;
result.Fz = myvars.tot_Fz;
result.Mx = myvars.tot_Mx;

result.timing    = timing;
result.Fy_points = Force_y_avg;
result.Fz_points = Force_z_avg;
result.Mx_points = Torque_x_avg;

save(save_file, 'result');