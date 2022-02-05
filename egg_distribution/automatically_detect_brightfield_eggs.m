function s = automatically_detect_brightfield_eggs(im_0,lawn_zoom,marker_0)
% EGGAUTOID   Identify egg-shaped objects in a bacterial lawn.
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTOMATICALLY_DETECT_BRIGHTFIELD_EGGS
% Automatic detection of brightfield eggs by using ellipse detection. This 
% script was used to generate data for Figures 2B to 2D, S2I. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edited: 03 Feb 2022                     %
% by: Kathleen T Quach (kquach@salk.edu)  %
% MATLAB version: R2017b                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
%%%% PRE-PROCESS IMAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Configure input to be 2-dimensional.
im = rgb2gray(im_0);
% Detect edges
im = edge(im, 'canny', .2);
% Fill in eggs
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
im = imdilate(im, [se90 se0]);
im = imfill(im, 'holes');
im = imclearborder(im,8);
dia = strel('diamond',1);
im = imerode(im,dia);
im = imerode(im,dia);

%%%% DETECT ELLIPSES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = regionprops(im, 'Orientation', 'MajorAxisLength', ...
'MinorAxisLength', 'Eccentricity', 'Centroid','Solidity', 'Area');
figure('name','Ellipses'),
imshow(im_0)
hold on 

phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);  
minmajaxlen = 0.8*lawn_zoom;
maxmajaxlen = 1.2*lawn_zoom;
minminaxlen = 0.8*(lawn_zoom/2);
maxminaxlen = 1.2*(lawn_zoom/2);
    
keep = [];
for k = 1:length(s)
    if ...
        s(k).Solidity < 1 & ... % < 1
        s(k).Eccentricity > .6 & ...
        s(k).Eccentricity < .9 & ...
        s(k).MajorAxisLength > minmajaxlen & ...
        s(k).MajorAxisLength < maxmajaxlen & ...
        s(k).MinorAxisLength > minminaxlen & ...
        s(k).MinorAxisLength < maxminaxlen 

        keep = [keep,k];

        xbar = s(k).Centroid(1);
        ybar = s(k).Centroid(2);

        a = s(k).MajorAxisLength/2;
        c = s(k).MinorAxisLength/2;

        theta = pi*s(k).Orientation/180;
        R = [ cos(theta)   sin(theta)
             -sin(theta)   cos(theta)];

        xy = [a*cosphi; c*sinphi];
        xy = R*xy;
        x = xy(1,:) + xbar;
        y = xy(2,:) + ybar;

        plot(x,y,marker_0,'LineWidth',.5);
    end
end
hold off

s = s(keep);
numel(s)
end


