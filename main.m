clear all;

% Assigment 1

% read data from sample data 
fileID = fopen('S4a_20.dat');
C_text = textscan(fileID,'%s',4,'Delimiter','	'); % header
C_data0 = textscan(fileID,'%d %d %f %f'); % columns as cells 

% subset data for input
time = C_data0{2};
XArr = C_data0{3};
YArr = C_data0{4};

% function input
velocity_to_degrees = true; 
minlength = 2;
screen_pixel_width = 1440;
screen_cm_width = 50;
participant_distance = 85;
v_threshold = 1; % As soon as I use deg/ms
t_threshold = 5; 

% run custom function
[ fix_sample_number,  fix_duration, fix_av_velocity] = fix_detect(time, XArr, YArr, velocity_to_degrees, minlength, screen_pixel_width, screen_cm_width, participant_distance, v_threshold, t_threshold)
