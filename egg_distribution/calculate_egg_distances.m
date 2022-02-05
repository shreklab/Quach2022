function calculate_egg_distances(egg_dir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE_EGG_DISTANCES
% Semi-automated selection of eggs for calculating egg distances relative
% to a bacterial lawn. This script was used to generate data for Figures 2B 
% to 2D, S2I. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edited: 03 Feb 2022                     %
% by: Kathleen T Quach (kquach@salk.edu)  %
% MATLAB version: R2017b                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% READ IMAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assumes each image is 2048 x 2048 .tif input. Read read_egg_images.m for
% expected image filenames. 
%   B 	arena 	bacteria and egg contours visible
%   E 	arena 	only egg countours visible
%   G 	arena 	gfp
%   b 	lawn 	bacteria and egg contours visible
%   e  	lawn 	only egg contours visible
%   g 	lawn 	gfp

[B E G b e g] = read_egg_images(cd);

%%%% READ ZOOM VALUE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assumes arena_zoom.txt file with the microscope magn/zoom value when
% FOV is filled with the arena. A consistent mag/zoom value should be used
% during image acquisition. For ZEISS Axio Zoom.V16, 3/8" diameter arena, 
% we used mag % value displayed on HIP control unit.
arena_zoom = 15.6; % <==== ADJUST PARAMETER

% Assumes lawn_zoom.txt file with the microscope magn/zoom value when
% FOV is filled with the lawn. After filling the arena in the FOV, increase
% mag/zoom value until the FOV is filled with the entire lawn and closeby 
% clusters of eggs. 
lawn_zoom = textread('zoom.txt', '%f'); 

%%%% CHECK THAT BRIGHTFIELD AND GFP EGG IMAGES ARE ALIGNED %%%%%%%%%%%%%%%%
% Compare pixel location of an egg across lawn images:
% Click on the center of an egg in the GFP image (left) first. 
% Check if the mirrored crosshair in the brightfield image (right) is also 
% on the center of the egg. 
% If not, click on the center of the egg in the brightfield image. 
% Press ENTER (or any key) to end alignment of lawn images. 
figure('name', 'Click on an egg in the left image. If misaligned, click on the same egg in the right image.'),
imshowpair(g,b,'montage'); 
hold on
markup_0 = '0_align_lawns';
same_egg = eggmanid(gcf,'c+',markup_0); 
close all;
if numel(same_egg(:,1)) == 2 % If lawn images are misaligned
    lawn_shift = same_egg(1,:) - same_egg(2,:); % GFP - brightfield 
else
    lawn_shift = [0,0]; % No misalignment
end

%%%% AUTOMATICALLY DETECT BRIGHTFIELD EGGS ON LAWN %%%%%%%%%%%%%%%%%%%%%%%%
% Detect ellipses on b lawn images
b_ell = automatically_detect_brightfield_eggs(b,lawn_zoom,'r'); 
b_ell_num = numel(b_ell);
  
% Calculate centroids of b lawn ellipses
b_cen = NaN(numel(b_ell),2);
for i = 1:numel(b_ell)
    b_cen(i,:) = b_ell(i).Centroid;
end
    
% Detect ellipses on e lawn images
e_ell = automatically_detect_brightfield_eggs(e,lawn_zoom,'g'); 
e_ell_num = numel(e_ell);
    
% Calculate centroids of e lawn ellipses
e_cen = NaN(numel(e_ell),2);
for i = 1:numel(e_ell)
    e_cen(i,:) = e_ell(i).Centroid;
end
   
% Remove redundant ellipses
if size(e_cen,1) > 2 % Need at least 3 points for delaunay triangulation
    e_cen_del = delaunayn(e_cen); 
    [e_cen_match, e_cen_d] = dsearchn(e_cen,e_cen_del,b_cen);
    egg_width = lawn_zoom*.8;
    e_cen_match(find(e_cen_d  > egg_width)) = []; 
    e_cen(e_cen_match,:) = [];
    egg_lawn_auto = [b_cen;e_cen];
else 
    egg_lawn_auto = b_cen;
end

close all % Close all figures
    
%%%% MANUALLY SELECT BRIGHTFIELD EGGS ON LAWN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Manually remove false positives from automated detection. Press ENTER
% when done. You do not have to precisely click on falsely identified eggs. 
% Delaunay triangulation is used so that the egg closest to a click will be 
% selected.
figure('name','Click on falsely identified eggs.'),
imshow(b)
hold on
plot(egg_lawn_auto(:,1),egg_lawn_auto(:,2),'r+'); 
hold off
[fp fp_ind] = manually_unselect_brightfield_eggs(egg_lawn_auto,gcf,'co');
egg_lawn_auto(fp_ind,:) = [];
close all

% Manually select all remaining eggs
figure('name','Click on all remaining unmarked eggs.'),
imshow(b) 
hold on
plot(egg_lawn_auto(:,1),egg_lawn_auto(:,2),'r+');
hold off
egg_lawn_man = manually_select_eggs(gcf,'ro'); 
close all
egg_lawn = [egg_lawn_auto;egg_lawn_man];
egg_lawn_num = numel(egg_lawn(:,1));
    
save('workspace.mat'); % Save workspace after labor-intensive step
    
%%%% AUTOMATICALLY DETECT GFP-LABELED EGGS ON LAWN %%%%%%%%%%%%%%%%%%%%%%%%
% Temporarily shift egg coordinates to GFP image's frame of reference for 
% visualization. 
egg_lawn = bsxfun(@plus, egg_lawn, lawn_shift);

% Define background: 
%   Click any number of times on high luminance background, then press 
%   ENTER. A threshold value will be determined using the average luminance 
%   of clicked pixels. 
figure('name','Click on several spots of high luminance background. Press ENTER when done.'),

% Detect eggs
[gfp_lawn_auto, gfp_lawn_auto_ind] = automatically_detect_gfp_eggs(g,egg_lawn); 

%%%% MANUALLY SELECT GFP-LABELED EGGS ON LAWN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Manually select GFP-labeled eggs. Press ENTER when done. You do not have 
% to precisely click on falsely identified eggs. Delaunay triangulation is 
% used so that the egg closest to a click will be selected.
figure('name','Click on all remaining unmarked GFP.'),
imshow(g) % <---- change to d if scatter is a problem
hold on
plot(gfp_lawn_auto(:,1),gfp_lawn_auto(:,2),'go','markers',14);
hold off
[gfp_lawn_man,  gfp_lawn_man_ind] = manually_select_gfp_eggs(egg_lawn,gcf,'go');
gfp_lawn = [gfp_lawn_auto;gfp_lawn_man];
gfp_lawn_ind = [gfp_lawn_auto_ind;gfp_lawn_man_ind];
gfp_lawn_num = numel(gfp_lawn_ind);
	
% Revert egg coordinates to brightfield frame of reference for calculations
egg_lawn = bsxfun(@minus, egg_lawn, lawn_shift);
gfp_lawn = bsxfun(@minus, gfp_lawn, lawn_shift);
   
close all % Close all figures
save('workspace.mat'); % Save workspace after labor-intensive step
    
%%%% ALIGN LAWN AND ARENA IMAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detect egg contours on arena image
fudge = 1;
Eclone = E(:,:,1);
[~, thresh] = edge(Eclone, 'sobel');
edgeE = edge(Eclone,'sobel', thresh * fudge);
edgeE = double(edgeE);
edgeE_blur = double(imgaussfilt(edgeE,1));
edgeE_final = double(imcomplement(edgeE_blur));

if egg_lawn_num > 0 % If there are eggs on lawn 
    % Transform lawn eggs to arena frame of reference
    zoom_factor = arena_zoom / lawn_zoom;
    l_to_a_x = round(1024 + (egg_lawn(:,1)-1024) * zoom_factor);
    l_to_a_y = round(1024 + (egg_lawn(:,2)-1024) * zoom_factor);
    % Nudge arena egg contours until they align with plotted lawn eggs
    h = nudge_eggs(l_to_a_x, l_to_a_y, edgeE_final);
    uiwait(helpdlg(...
        'Click OK when done matching markers to contours.'))
    % New lawn egg coordinates in arena frame of reference
    egg_nudged = NaN(egg_lawn_num,2);
    egg_nudged(:,1) = get(h,'XData');
    egg_nudged(:,2) = get(h,'YData');
    gfp_nudged = egg_nudged(gfp_lawn_ind,:);
    close all % Close all Figures
elseif egg_lawn_num == 0 % If there are no eggs on lawn
    egg_nudged = [];
    gfp_nudged = [];
end 
    
%%%% MANUALLY SELECT GFP-LABELED EGGS ON ARENA %%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('name', 'Click on GFP eggs.'),
imshowpair(G,B,'montage') % <---- consider deconvolution
hold on
plot(gfp_nudged(:,1), gfp_nudged(:,2), 'go', 'markers', 4);   
plot(gfp_nudged(:,1)+2048, gfp_nudged(:,2), 'go', 'markers', 4);    
gfp_arena = manually_select_eggs(gcf,'go');
gfp = [gfp_nudged;gfp_arena];
close all

%%%% MANUALLY SELECT BRIGHTFIELD EGGS ON ARENA %%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('name','Click on remaining eggs.'),
imshowpair(G,B,'montage')  
hold on  
plot(egg_nudged(:,1), egg_nudged(:,2), 'ko', 'markers', 4);   
plot(egg_nudged(:,1)+2048, egg_nudged(:,2), 'ko', 'markers', 4); 
plot(gfp_arena(:,1), gfp_arena(:,2), 'go', 'markers', 4);   
plot(gfp_arena(:,1)+2048, gfp_arena(:,2), 'go', 'markers', 4);  
egg_arena = manually_select_eggs(gcf,'mo');
egg = [egg_nudged;egg_arena;gfp_arena];
egg_num = numel(egg(:,1));
close all

%%%% DEFINE ROIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define lawn ROI
lawn_instr = 'Hold down SHIFT, then adjust circle to contour of lawn. Press ENTER when done.';
circle_lawn = [816 816 408 408]; % <==== ADJUST PARAMETER
[lawn_center,lawn_radius,lawn_mask] = make_circle_ROI(B, circle_lawn, lawn_instr);
close all

% Define arena ROI
arena_instr = 'Hold down SHIFT,then adjust circle to contour of arena. Press ENTER when done.';
circle_arena = [10 10 2020 2020]; % <==== ADJUST PARAMETER
[arena_center,arena_radius,arena_mask] = make_circle_ROI(B, circle_arena, arena_instr);
close all 

%%%% CLASSIFY EGGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = delaunayn(egg);
gfp_ind = dsearchn(egg,d,gfp);
gfpno = false(egg_num,1);
gfpno(gfp_ind) = true; 

onoff = false(egg_num,1);
for i = 1 : egg_num
    onoff(i) = lawn_mask(egg(i,2),egg(i,1)); % mask coordinates are inverted
end 

egg_on = egg(onoff == 1,:); % Eggs on lawn
egg_off = egg(onoff == 0,:); % Eggs off lawn
egg_gfp = egg(gfpno == 1,:); % GFP-labeled eggs
egg_nogfp = egg(gfpno == 0,:); % Non-GFP-labeled eggs
egg_gfp_on = egg(gfpno == 1 & onoff == 1,:); % GFP-labeled eggs on lawn 
egg_gfp_off = egg(gfpno == 1 & onoff == 0, :); % GFP-labeled eggs off lawn 
egg_nogfp_on = egg(gfpno == 0 & onoff == 1, :); % non-GFP-labeled eggs on lawn 
egg_nogfp_off = egg(gfpno == 0 & onoff == 0, :); % non-GFP-labeled eggs off lawn 

   
%%%% CALCULATE DISTANCES OF EGGS FROM LAWN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
egg2center = NaN(egg_num,1); % Distance of eggs from center of lawn
egg2lawn = NaN(egg_num,1); % Distance of eggs from edge of lawn

for i = 1 : egg_num
egg2center(i) = norm(egg(i,:) - lawn_center);
    if onoff(i) == 0
        egg2lawn(i) = egg2center(i) - lawn_radius;
    else
        egg2lawn(i) = 0;
    end
end

% Distances of C. elegans eggs
egg2center_gfp = egg2center(gfpno == 1); 
egg2center_gfp_off = egg2center(gfpno == 1 & onoff == 0);
percent_gfp_off = (size(egg_gfp_off,1)/size(egg_gfp,1))*100;

%%%% OUTPUT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eggs_output_name = 'data.mat';
save(eggs_output_name,...
    'egg','gfpno','onoff','egg2center','egg2lawn',...
    'egg_on','egg_off','egg_gfp','egg_nogfp',...
    'egg_gfp_on','egg_gfp_off','egg_nogfp_on','egg_nogfp_off',...
    'egg2center_gfp','egg2center_gfp_off','percent_gfp_off',...
    'lawn_center','lawn_radius','arena_center','arena_radius');

save('workspace.mat');
    
end 
