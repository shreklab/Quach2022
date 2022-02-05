function eggs = manually_select_eggs(hfig,markertype)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MANUALLY_SELECT_EGGS
% Manual selection of eggs. This script was used to generate data for 
% Figures 2B to 2D, S2I. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edited: 03 Feb 2022                     %
% by: Kathleen T Quach (kquach@salk.edu)  %
% MATLAB version: R2017b                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eggs_X = zeros(1,0);
eggs_Y = zeros(1,0);

hfig;   
hold on;   

k = 0;
while 1 
    [xi, yi, but] = ginput(1); % Get a point from left-click      
    if ~isequal(but, 1) % Stop if not button 1 (left-click)           
        break
    end
    k = k + 1; 
    eggs_Y(k) = yi;

    if xi <= 2048 
        xi_2 = xi + 2048;
        eggs_X(k) = xi;
    else
        xi_2 = xi - 2048;
        eggs_X(k) = xi_2;
    end
    % Plot egg marker
    plot(xi, yi, markertype,'markers',4);	
    plot(xi_2,yi, markertype,'markers',4);
end

% Make sure that X-Y coordinates are integers
eggs_X = round(eggs_X);
eggs_Y = round(eggs_Y);

eggs = [eggs_X',eggs_Y'];

end