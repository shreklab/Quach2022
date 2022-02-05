function [B_im, E_im, G_im, b_im, e_im, g_im] = ...
    eggRead(im_dir)
% EGGREAD   Reads a complete image set for an egg distribution assay plate
	%
	% EGGREAD() prompts UI for muliple selection of 6 images files 
	%
	% EGGREAD(DIR) reads 6 image files from directory DIR
	%
	% [B E G b e g] = EGGREAD() outputs 3 arena and 3 lawn image arrays
	%
	% EGGREAD assumes default filenames: 
	% 'arena_b.tif'
	% 'arena_e.tif'
	% 'arena_g.tif'
	% 'lawn_b.tif'
	% 'lawn_e.tif'
    % 'lawn_g.tif'
	% 'lawn_g_deconv.tif'

    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set default image filenames % 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Arena image filenames
	B_name = 'arena_b.tif'; 
	E_name = 'arena_e.tif';
	G_name = 'arena_g.tif';

	% Lawn image filenames
	b_name = 'lawn_b.tif';
	e_name = 'lawn_e.tif';
    g_name = 'lawn_g.tif';
%     d_name = 'lawn_g_deconv.tif';
   

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set default image format %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	im_form = '*.tif';

	%%%%%%%%%%%%%%%
	% Read images %
	%%%%%%%%%%%%%%%

	if nargin == 1

		% Navigate to input directory
		cd(im_dir);

		% Read arena images.
		B_im = imread('arena_b.tif');
		E_im = imread('arena_e.tif');
		G_im = imread('arena_g.tif');

		% Read lawn images
		b_im = imread('lawn_b.tif');
		e_im = imread('lawn_e.tif');
        g_im = imread('lawn_g.tif');
%         d_im = imread('lawn_g_deconv.tif');


	else
		% Prompt UI for multiple selection of images
		[im_name, im_dir] = uigetfile(...
		        im_form,'Select all images.',...
		        ['"',B_name,'" "',E_name,'" "',G_name,'" "',b_name,'" "',e_name,'" "',g_name,'"'],...% "',d_name,'"
		        'MultiSelect', 'on')

		% Navigate to directory
		cd(im_dir);

		% Read arena images. 
	    B_im = imread(im_name{1}); 
	    E_im = imread(im_name{2}); 
	    G = imread(im_name{3}); 

	    % Read lawn images
	    b_im = imread(im_name{4});
	    e_im = imread(im_name{5});
	    g_im = imread(im_name{6});
%         d_im = imread(im_name{7});

    end

end

%%%%%%%%%%
% End    %
% of     %
% script %
%%%%%%%%%%

%%%%%%%%%%%%%%%
% Updated     %
% 28 Dec 2018 %
%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
% Kathleen T Quach      %
% kthln.t.qch@gmail.com %
%%%%%%%%%%%%%%%%%%%%%%%%% 
    
