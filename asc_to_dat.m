
% note that when you add a percent sign everything after it is green - all green text is a
% comment. Matlab ignores it when it runs the script. It just allows you to
% make notes in your script.
%         -> spaces are ignored, you can use them to organize your code
% nb: matlab's editor will automatically format your spacing to help you keep
% track of your loops. If it starts to get messy, go text menu -> smart indent will clean it up
clear all; %good practice to clear out your workspace before you start!


    filetoread = 'S4a_20.asc';
    filetomake = 'S4a_20.dat';
    
    FID=fopen(filetoread, 'r'); %open filetoread, call it "FID"
    F2ID = fopen(filetomake, 'w'); %open filetomake, call it F2ID"
    
    %the line below makes column headers in the output file
    fprintf(F2ID, 'Trial\ttime\tx\ty\n');
    
    moreTrials = 1;
    displayOn = 0;
    currTrial = 0;
    %the main loop starts below, and ends at the end of the file (see matlab
    %book ch. 4)
    while moreTrials == 1 %as long as filerun is not null (i.e. 0) all the commands in this loop will keep looping
        line=fgetl(FID); %get the next line of data from FID, save it into a variable called "line"
        if line == -1 % if the end of the file has been reached, the fgetl function won't work anymore, so it will return -1.
            fclose(F2ID); %always close the file when you are done
            fclose(FID);
            moreTrials = 0; %leave the main loop
            break;
        end
        
        %This is our cue to shift new trial.  reset all variables
        if findstr(line, 'Trial')
            currTrial =     currTrial +1;
            displayOn = 1;
            % fprintf(F2ID, 'Trial\ttime\tx\ty\n');
            % now look for gaze samples
            moreSamples = 1;
            while moreSamples == 1 %as long as filerun is not null (i.e. 0) all the commands in this loop will keep looping
                line=fgetl(FID); %get the next line of data from FID, save it into a variable called "line"
                if findstr(line, 'TRIAL_OVER')
                    moreSamples = 0;
                end                
                %if ~isempty(line)
                cols = textscan(line, '%d %f %f %d %d');
                if isempty(cols{1})
                    test = 1;%do nothing
                else
                    %    if isinteger(cols{1})
                    try
                                    fprintf(F2ID, '%d\t%d\t%1.2f\t%1.2f\n',...
                                        currTrial,cols{1},cols{2},cols{3});
                    catch
                        test = 1;
                    end
                end

                    
            end
            
            
        end
        end
fclose('all');
