function radians = calculate_arc_rads(v1,v2,direction)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE_ARC_RADS
% Calculates angle between two vectors using video axes
% take into account that the axes for videos are flipped diagonally
%  (0,0)--------(inf,0)
%   |             |
%   |             |
%   |             |      
%   |             |
%   |             |
% (0,inf)------(inf,inf)

%This script was used to generate data for Figures 5A to 5F, 6C to 6D, and 
% S5C to S5F.         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edited: 03 Feb 2022                     %
% by: Kathleen T Quach (kquach@salk.edu)  %
% MATLAB version: R2017b                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

tf_ccw = strcmp(direction,'ccw');
tf_cw = strcmp(direction,'cw');

if tf_ccw == 1
    radians = 2*pi - mod(atan2( det([v1;v2]) , dot(v1,v2) ), 2*pi );
elseif tf_cw == 1
    radians = mod(atan2( det([v1;v2]) , dot(v1,v2) ), 2*pi ) ;
else
    radians = [];
%     msg = 'Direction can only be cw or ccw.'
%     error(msg)
end 