function [circleCenter,radius,newMask] = make_circle_ROI(image,circle,figureTitle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAKE_CIRCLE_ROI
% Create circular ROI. This script was used to generate data for Figures 2B
% to 2D, S2I. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edited: 03 Feb 2022                     %
% by: Kathleen T Quach (kquach@salk.edu)  %
% MATLAB version: R2017b                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name',figureTitle,'NumberTitle','off');
h_im = imshow(image);

% Create a temporary circle.
tempPosition = circle; 
tempEllipse = imellipse(gca, tempPosition);

% Record adjusted circle upon keypress.
pause;  
newPosition = getPosition(tempEllipse);
newEllipse = imellipse(gca,newPosition);

% Create an ROI mask from circle. 
newMask = createMask(newEllipse,h_im);
imshow(newMask);

% Calculate the center and radius of the ROI. 
radius = mean([newPosition(3)/2,newPosition(4)/2]);
circleCenter = newPosition(1:2) + [radius,radius];

end

%%%%%%%%%%%%%
% end       %
% of        %
% script    %
%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kathleen T Quach              %
% kthln.t.qch@gmail.com         %
% last edited 19 October 2016   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%