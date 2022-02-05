function [gfp_xy, gfp_ind] = automatically_detect_gfp_eggs(g, lawn_eggs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTOMATICALLY_DETECT_GFP_EGGS
% Automatic detection of GFP-labeled eggs by taking in user input about
% background and selecting eggs that surpass a luminance threshold. This 
% script was used to generate data for Figures 2B to 2D, S2I. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edited: 03 Feb 2022                     %
% by: Kathleen T Quach (kquach@salk.edu)  %
% MATLAB version: R2017b                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% SELECT BACKGROUND PIXELS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bkgrnd = impixel(g); % Prompt user to select pixels
close all
bkgrnd = bkgrnd(:,1);
mean_bkgrnd = mean(bkgrnd);

%%%% SET THRESHOLD LUMINANCE PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set threshold pixel intensity
thresh = mean_bkgrnd + 70; % <==== ADJUST PARAMETER
% Set threshold number of pixels in egg that exceed thresold pixel intensity
num_bright_pixels = 15; % <==== ADJUST PARAMETER

%%%% FIND EGGS THAT EXCEED THRESHOLD LUMINANCE %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coordinates of all eggs on lawn
x = lawn_eggs(:,1);
y = lawn_eggs(:,2);

sumlum = NaN(numel(x),1);
for i = 1:numel(x)
    % Circle with radius 10 pixels, centered at [x(i),y(i)] in 2048x2048 image
    [rr cc] = meshgrid(1:2048);
    C = sqrt((rr-x(i)).^2+(cc-y(i)).^2)<=10; 
    % Create egg mask 
    egg_roi = g(C);
    % Find pixels that exceed threshold pixel intensity 
    mask = egg_roi > thresh;
    % Count number of pixels that exceed threshold pixel intensity 
    sumlum(i) = sum(sum(egg_roi(mask)));
end

% Coordinates of eggs that exceed threshold luminance
gfp_ind = find(sumlum > num_bright_pixels );
gfp_xy = [x(gfp_ind),y(gfp_ind)];

end       

