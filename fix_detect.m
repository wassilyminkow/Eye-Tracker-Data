function [ fix_sample_number,  fix_duration, fix_av_velocity] = fix_detect(time, XArr, YArr, velocity_to_degrees, minlength, screen_pixel_width, screen_cm_width, participant_distance, v_threshold, t_threshold)
%FIX_DETECT Fixation detection based on I-VT (velocity threshold) algorithm Salvucci and Goldberg [2000]
    % fix_sample_number ? array of fixation sample numbers
    % fix_duration ? array of fixation durations
    % fix_av_velocity ? array of average velocities

    % get visual angle and number of pixels per angle
    visual_angle = 2*atan(screen_cm_width/2*participant_distance); % visual angle
    pixels_per_angle = screen_pixel_width/visual_angle; % number of pixels per angle 
    pixels_per_degree = pixels_per_angle/visual_angle; %  

    % smoothing
    XArr = smooth(XArr,5,'moving');
    YArr = smooth(YArr,5,'moving');

    % get velocity from Euclidian distance; visual angle and number of pixels per angle 
    distance = zeros(length(XArr)-1, 1);
    velocity = zeros(length(XArr)-1,1);
    distance_angle = zeros(length(XArr)-1,1);
    degrees_per_second = zeros(length(XArr)-1,1);
    for i=2:length(XArr)
        if velocity_to_degrees == false
            distance(i-1) = sqrt((XArr(i-1)-YArr(i-1))^2 + (XArr(i)-YArr(i))^2)/1;
            velocity(i-1) = distance(i-1)/1;
        else 
            % pixels_per_angle/visual_angle = distance_i/distance_angle
            % distance_angle = visual_angle*distance_i/pixels_per_angle
            % degrees_per_ms = distance_angle/time(i)
            distance(i-1) = sqrt((XArr(i-1)-YArr(i-1))^2 + (XArr(i)-YArr(i))^2)/1;
            distance_angle(i-1) = visual_angle*distance(i-1)/pixels_per_angle;
            velocity(i-1) = distance_angle(i-1)/1;
        end
    end

    % set fix array
    fix = zeros(length(XArr)-1,1);
    for i=1:length(fix)

        if velocity(i) < v_threshold;
            fix(i) = 1;
        end
        
        % I assume that incriment in time is constant, time is equal to 1
        % ms
        if 1 > t_threshold;
            fix(i) = 1;
        end 
    end

    % calculate average velocity within cluster
    tally = 0;
    fix_counter = 1;
    av_counter = 0;
    av_speed = 0;
    for i=1:length(fix)
        if fix(i) == 1;
            tally = tally + 1;
            av_counter = 1 + av_counter;
            av_speed = velocity(i) + av_speed;
        else
            if tally > minlength
                disp('hello')
                fix_sample_number(fix_counter) = i;
                fix_duration(fix_counter) = tally;
                fix_av_velocity(fix_counter) = av_speed/av_counter;
                tally = 0;
                av_counter = 0;
                av_speed = 0;
                fix_counter = fix_counter + 1;
            end
            tally = 0;
        end
    end
end

