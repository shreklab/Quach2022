function [gfpxy gfpind] = manually_select_gfp_eggs(eggs,hfig, markertype)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MANUALLY_SELECT_GFP_EGGS
% Manual selection of GFP-labeled eggs. This script was used to generate 
% data for Figures 2B to 2D, S2I. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edited: 03 Feb 2022                     %
% by: Kathleen T Quach (kquach@salk.edu)  %
% MATLAB version: R2017b                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gfpeggs_X = zeros(1,0);
gfpeggs_Y = zeros(1,0);
ind = zeros(1,0);
eggs_num = numel(eggs(:,1));
gfpind = [];

if eggs_num > 1      % When there is only 1 egg in FOV 
    d = delaunayn(eggs);    % Delaunay triangulation of egg positions
end


hfig;
hold on
plot(eggs(:,1), eggs(:,2),'ko','markers',12);%

k = 0;

    while 1
        [xi, yi, but] = ginput(1);      % Get a point from left-click
        if ~isequal(but, 1)             % Stop if not button 1 (left-click)
%             print(filename,'-dtiffn')   % Save figure as uncompressed .tif
            break
        end
        k = k + 1;
        
        if eggs_num > 1   % When there are more than 1 eggs in FOV
            % Find nearest marker to click position
            ind = dsearchn(eggs,d,[xi,yi]);    
            gfpind = [gfpind;ind];
            gfp_xi = eggs(ind,1);
            gfp_yi = eggs(ind,2);
            
            % Save marker as GFP-labelled egg
            gfpeggs_X(k) = gfp_xi;
            gfpeggs_Y(k) = gfp_yi;
            
        else                    % When there is only 1 egg in FOV 
            gfpind = [1,1];
            gfp_xi = eggs_X;
            gfp_yi = eggs_Y;
            gfpeggs_X = gfp_xi;
            gfpeggs_Y = gfp_yi;
        end
        % Plot gfp marker over existing cyan marker
        plot(gfp_xi, gfp_yi, markertype,'markers',4); 
    end
    
    % Make sure that X-Y coordinates are integers
    gfpeggs_X = round(gfpeggs_X); 
    gfpeggs_Y = round(gfpeggs_Y);

    gfpxy = [gfpeggs_X',gfpeggs_Y'];

end