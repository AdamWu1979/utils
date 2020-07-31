
function [h_o, ax_o] = imagescn(varargin)
%function [axn] = imagescn(img1, img2, ..., imgn)
% This function intends to create axes-bundle that superimposes multiple images
% at the same position. All axes, except the first one, has properties .Visible
% and .HandleVisibility set to 'off', ensuring ax_o(1)'s visibility won't be
% obstructed, and gca can catch the first axis, to which axes-bundle information
% has saved into by setappdata(). In this way, the location this superimposed-
% image can be reused ram-safely (e.g., subplot).
%INPUTS
% - img_c, image_cell, displayed by imagesc(), nan<->transparent for 
%OUTPUTS
% - ho,  array of images handles
% - axo, array of axes handles of img_x respectively
%
if nargin == 0; test(); return; end

%% prep
img_c = varargin; % unnecesary copy but better readability (variable name)
naxes = numel(img_c);

%% resize images to same size
s = [max(cellfun(@(x)size(x,1),img_c)), max(cellfun(@(x)size(x,2),img_c))];
img_c = cellfun(@(x)imresize(x, s), img_c, 'UniformOutput', false);

%% Create and link two axes
[ax, h] = deal(gobjects(1,naxes));
ax(1) = gca;

axBundle_reset(ax(1));

h(1) = imagesc(ax(1), img_c{1}); % handle for this is not used
ax(1).Visible = 'on';
ax(1).DeleteFcn = @axBundle_delete;
set(h(1), 'AlphaData', ~isnan(img_c{1}));

for ia = 2:naxes % the images are implicitly ordered from button to top
  ax(ia) = axes;
  h(ia) = imagesc(ax(ia), img_c{ia});
  set(h(ia), 'AlphaData', ~isnan(img_c{ia}));
  [ax(ia).Visible, ax(ia).HandleVisibility] = deal('off');
end
axBundle_set(ax);

% % link the axes persistently (linkprop then setappdata)
% hlink = linkprop(ax, {'Position','XTick','YTick','XLim','YLim','ZLim','Title'});
% setappdata(ax(1), 'axLink', hlink);

t = title([]);
t.Visible = 'on'; % need to set this explicitly

if nargout > 0, h_o  = h;  end
if nargout > 1, ax_o = ax; end

end

function axBundle_set(ax)
hlink = linkprop(ax, {'Position','XTick','YTick'});
setappdata(ax(1), 'axBundle', hlink);
end

function axBundle_reset(ax)
if isappdata(ax, 'axBundle')
  hlink = getappdata(ax, 'axBundle');
  rmappdata(ax, 'axBundle');
  
  axBundle = hlink.Targets;
  hlink.removetarget(axBundle);
  delete(hlink);
  
  delete(axBundle(2:end));
  cla(ax, 'reset');
end
end

function axBundle_delete(ax1,~)
axBundle_reset(ax1);
end

%% how to use
function test()
z1 = phantom;
z2 = rand(size(z1)); % arbitrarily sized
z2(z2<0.8) = nan; % nan will be transparent

figure
[h, ax] = imagescn(z1,z2);
title('imagescn demo');

end

%% know issues
% 1. 'axis equal' will mess the axes postions which were supposed to be sync'ed
%    by linkprop()

