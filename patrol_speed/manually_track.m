function manually_track
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MANUALLY_TRACK
% Manually track worm mouth positions in a video. This script was used to 
% generate data for Figures 5A to 5F, 6C to 6D, and S5C to S5F.         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edited: 03 Feb 2022                     %
% by: Kathleen T Quach (kquach@salk.edu)  %
% MATLAB version: R2017b                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% LOAD VIDEO INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tmp = dir('*.avi'); % Loads all video clips in a directory
videoList = {tmp.name}';   
for i = 1:length(videoList)
    vid = videoList{i}
    v = VideoReader(vid); % read video
    
%%%% MANUALLY TRACK WORM POSITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select P. pacificus mouth in each frame. 
trackedPoints = [];
frameNum = 0; 
% Get mouse click positions for entire video clip
while hasFrame(v) 
    frameNum = frameNum+1 % Advance to next frame
    vidFrame = readFrame(v);
    imshow(vidFrame) % Display current frame
    [xi, yi, but] = ginput(1); % Get mouse click input
    trackedPoints = [trackedPoints;xi,yi]; 
end 
disp(trackedPoints) % Display xy-coordinates in the command window 
save(strcat(vid(1:16),'_workspace.mat')) % Save everything
close % Close current figure  

%%%% PLOT WORM TRACKS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vidFrame = read(v,1);
figure
imshow(vidFrame)
hold on
gca
x = trackedPoints(:,1);
y = trackedPoints(:,2); 
N = size(trackedPoints,1); % number of colors. Assumed to be greater than size of x
cmap = jet(N); % colormap, with N colors
linewidth = 1.5; % desired linewidth
hold on
for n = 1:N-1
    plot(x([n n+1]), y([n n+1]), 'color', cmap(n,:), 'linewidth', linewidth);
end
saveas(gcf,strcat(vid(1:16),'_tracks.png')) % Save plot with video ID
close % close current figure

%%%% OUTPUT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tracks_output_name = strcat(vid(1:16),'_tracks.mat'); % Save data with video ID
save(tracks_output_name,...
    'trackedPoints','frameNum','vid','vidFrame');

end
end
