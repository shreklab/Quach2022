function [unxy unind] = manually_unselect_brightfield_eggs(eggs,hfig, markertype)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MANUALLY_UNSELECT_BRIGHTFIELD_EGGS
% Manual unselection of automatically detected brightfield eggs. This 
% script was used to generate data for Figures 2B to 2D, S2I. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edited: 03 Feb 2022                     %
% by: Kathleen T Quach (kquach@salk.edu)  %
% MATLAB version: R2017b                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

uneggs_X = zeros(1,0);
uneggs_Y = zeros(1,0);
ind = zeros(1,0);
eggs_num = numel(eggs(:,1));
unind = [];

if eggs_num > 1      % When there is only 1 egg in FOV 
    d = delaunayn(eggs);    % Delaunay triangulation of egg positions
end

hfig;
hold on

k = 0;

    while 1
        [xi, yi, but] = ginput(1);      % Get a point from left-click
        if ~isequal(but, 1)             % Stop if not button 1 (left-click)
%             print(filename,'-dtiffn')   % Save figure as uncompressed .tif
            break
        end
        k = k + 1;
        
        if eggs_num > 1   % If there are more than 1 eggs
            % Find nearest marker to click position
            ind = dsearchn(eggs,d,[xi,yi]);    
            unind = [unind;ind];
            un_xi = eggs(ind,1);
            un_yi = eggs(ind,2);
            % Save marker as unselected egg
            uneggs_X(k) = un_xi;
            uneggs_Y(k) = un_yi;
        else % If there is only 1 egg  
            unind = [1,1];
            un_xi = eggs_X;
            un_yi = eggs_Y;
            uneggs_X = un_xi;
            uneggs_Y = un_yi;
        end
        % Plot new marker over existing marker
        plot(un_xi, un_yi, markertype,'markers',4); 
    end
    
    % Make sure that coordinates are integers
    uneggs_X = round(uneggs_X); 
    uneggs_Y = round(uneggs_Y);
    unxy = [uneggs_X',uneggs_Y'];

end
