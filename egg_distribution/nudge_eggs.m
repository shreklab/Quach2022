function [h] = eggnudge(lawn_X,lawn_Y,img)
% EGGNUDGE   Nudges egg positions to correct for XY shift across magnifications.

    h_fig = figure;
    imshow(img)
    hold on
    h = plot(lawn_X,lawn_Y,'co','markers',4);

    set(h_fig,'keypressfcn', @nudge);

function [X,Y] = nudge(H,E)

    switch E.Key
        case 'rightarrow'
            X = get(h,'XData') + 1;  % Translate 1 pix to right
            set(h,'XData',X);
        case 'leftarrow'
            X = get(h,'XData') - 1;  % Translate 1 pix to left
            set(h,'XData',X);
        case 'uparrow'
            Y = get(h,'YData') - 1;  % Translate 1 pix up
            set (h, 'YData', Y);      
        case 'downarrow'
            Y = get(h,'YData') + 1;  % Translate 1 pix up
            set(h,'YData',Y);

        case 'return'
        otherwise
    end % switch E.key
        
end % function nudge
    
end % function eggnudge   


%%%%%%%%%%%%%
% end       %
% of        %
% script    %
%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%
% edited        %
% 01 Apr 2017   %
%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
% Kathleen T Quach      %
% kthln.t.qch@gmail.com %
%%%%%%%%%%%%%%%%%%%%%%%%% 