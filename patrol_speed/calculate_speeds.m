function calculate_speeds(tracks_mat, transitions_txt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE_SPEEDS
% Calculates translational and patrol speeds. This script was used to 
% generate data for Figures 5A to 5F, 6C to 6D, and S5C to S5F.         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edited: 03 Feb 2022                     %
% by: Kathleen T Quach (kquach@salk.edu)  %
% MATLAB version: R2017b                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             

%%%% LOAD WORM TRACK DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load data generated by manually_track.m
load(tracks_mat);

%%%% LOAD PATROL TRANSITIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Patrol transitions are in in the form of a text file, where each line is
% consists of the frame number and event type, separated by a space. Event
% types are 'cw' (patrol clockwise), 'ccw' (patrol counter-clockwise),
% 'end' (end of patrol period). The first and last lines should indicate
% the start and end of the patrol period to be analyzed. The patrol period
% is the longest period during which P. pacificus continuously remains on
% the lawn (no exit/re-entry). To accurately calculate angular distance, 
% new events ('cw' or 'ccw') must be added before P. pacificus traverses a
% full circle on the lawn boundary relative to its position in the
% previously recorded event. 
[when , event] = textread(transitions_txt,'%s %s');
when = str2double(when);
num_events = length(event);
patrol_frames = when(end) - when(1);

%%%% DEFINE LAWN AND ARENA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define lawn
lawn_instr = 'Hold down SHIFT, then adjust circle to contour of lawn. Press ENTER when done.';
circle_lawn = [360 360 380 380];
[lawn_center,lawn_radius,~] = make_circle_roi(vidFrame, circle_lawn, lawn_instr);
close all
% Define arena
arena_instr = 'Hold down SHIFT,then adjust circle to contour of arena. Press ENTER when done.';
circle_arena = [5 5 1060 1060];
[~,arena_radius,~] = make_circle_roi(vidFrame, circle_arena, arena_instr);
close all 

%%%% DEFINE CONVERSION FACTORS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define length of one frame in s
frame_to_s = 0.6; % <==== ADJUST PARAMETER
% Define radius of corral in mm
corral_radius = 3.175/2; % <==== ADJUST PARAMETER
% Convert pixels to mm
pxls_to_mm = corral_radius / arena_radius; 

%%%% CALCULATE PATROL SPEED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Patrol speed is the arc component of forward distance on the lawn
% boundary, divided by total time. 

% Calculate angular distance patrolled
arc_rads = [];
for j = 1:num_events
    if event(j) == "ccw"
        current_loc = trackedPoints(when(j), :);
        next_loc = trackedPoints(when(j+1), :);
        v1 = current_loc - lawn_center;
        v2 = next_loc - lawn_center;
        ar = calculate_arc_rads(v1,v2,'ccw');
        arc_rads = [arc_rads;ar];
    elseif event(j) == "cw"
        current_loc = trackedPoints(when(j), :);
        next_loc = trackedPoints(when(j+1), :);
        v1 = current_loc - lawn_center;
        v2 = next_loc - lawn_center;
        ar = calculate_arc_rads(v1,v2,'cw');
        arc_rads = [arc_rads;ar];
    end
end

total_arc_rads = sum(arc_rads); 
total_arc_length = total_arc_rads * lawn_radius* pxls_to_mm; 
patrol_minutes = patrol_frames * 0.6 / 60; 
patrol_mm_per_min = total_arc_length / patrol_minutes; 

%%%% CALCULATE TRANSLATIONAL SPEED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trimmed_trackedPoints = trackedPoints(when(1):when(end),:);
translational_pixels = sqrt(sum(abs(diff(trimmed_trackedPoints)).^2,2));
total_translational_pixels = sum(translational_pixels);
total_translational_mm = total_translational_pixels * pxls_to_mm;
translational_mm_per_min = total_translational_mm / patrol_minutes;
    
%%%% CALCULATE NORMALIZED PATROL SPEED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
norm_patrol_speed = patrol_mm_per_min / translational_mm_per_min;
     
%%%% OUTPUT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
speed_output_name = strcat(vid(1:16),'_speed.mat'); % Save data with video ID
save(speed_output_name,...
    'patrol_mm_per_min', 'translational_mm_per_min','norm_patrol_speed');
 
end
