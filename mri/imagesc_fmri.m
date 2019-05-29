
function [h_o, ax_o, cb_o] = imagesc_fmri(imM, imF, th, cmap_c, mode)
%%function [h_o, ax_o, cb_o] = imagesc_fmri(imM, imF, th, cmap_c, mode)
% This function overlays a activity map, imF, onto a structural image, imM.
% It takes a (2,)-sized threshold, th, which acts as a mask-out interval, i.e.,
% activity level that is inside the interval [th(1), th(2)] will be transparent
% in the displayed figure.
% Notice that, this function cannot handle 3D image inputs. User needs to stitch
% 3D images together into 2D ones before passing in. Matlab's built-in `cat` may
% be useful for this purpose.
% The function contains a `test`, run `imagesc_fmri()` to demo it.
%INPUTS
% - imM (nMx, nMy), structural image, possibly high res.
% - imF (nFx, nFy), activity map, possibly different res. `imagescn` will resize
%     it to (nMx, nMy).
% - th (2,), threshold interval, $imF \in [th(1),th(2)]$ will be transparent.
%OPTIONAL
% - cmap_c (3,) cell, colormap, read `gen_cmap_c()` for more details.
% - mode (1,) colorbars location. Matlab is awkward at controlling location. A
%     better way here is use the default and export the figure to .svg format,
%     handle it with professional figure editors.
%OUTPUTS
% - h_o,  array of images handles
% - ax_o, array of axes handles of the stacked final figure
% - cb_o, array of colorbar handles of the stacked final figure
%
%% know issues
% 1. colorbars may trespass on other components or reach outside of the figure.
%    It's easier to handle this by saving as svg and edit w/ inkscape, etc.

if nargin == 0, test(); return; end

if ~nonEmptyVarChk('cmap_c'), cmap_c = gen_cmap_c(); end
if ~exist('mode',  'var'), mode = 0; end

assert(th(2) > th(1));
[mn, mp] = deal(imF <= th(1), imF >= th(2));
[imFn, imFp] = deal(imF.*mn./mn, imF.*mp./mp); % nan intentionally

[h, ax] = imagescn(imM, imFn, imFp);
[ax(1).XTick, ax(1).YTick] = deal([]); % ax ticks are linked together
colormapn(ax, cmap_c);

% by dflt, colorbarn puts the cb for img1 to the left
cb = colorbarn(ax);
cb(1).Visible = 'off';

fn_lim = @(x)[min(x(:)), max(x(:))];
[limn, limp] = deal(fn_lim(imFn), fn_lim(imFp));
[cb(2).Limits, cb(3).Limits] = deal(limn, limp);

switch mode
  case 0
    [base,  ht] = deal(ax(1).Position(2), ax(1).Position(4));
    [cb(2).Position(4), cb(3).Position(4)] = deal(ht*2/5);
    cb(3).Position(2) = base + ht*3/5;
  case 1
    cb(2).Location = 'westoutside'; % negative activity colorbar on the left
  otherwise, error('not supported mode');
end

if nargout > 0, h_o  = h;  end
if nargout > 1, ax_o = ax; end
if nargout > 2, cb_o = cb; end

end

function cmap_c = gen_cmap_c() % default cmap_c
cmap_fnc = jet;
cmap_fnc = imresize(cmap_fnc, [288, 3]); % 288 = 128 + 32 + 128
cmap_fnc(cmap_fnc<0) = 0;
cmap_fnc(cmap_fnc>1) = 1;

[cmapn, cmapp] = deal(cmap_fnc(1:128,:), cmap_fnc((128+32+1):end,:));

% {gray, cold_color, warm_color}
cmap_c = {gray, cmapn, cmapp};

end

%% test()
function test()
imM = phantom;
imF = rand(size(imM)) - 0.5; % shift to [-0.5,0.5]
th = [-0.45, 0.45];

figure
subplot(121)
[h, ax, cb] = imagesc_fmri(imM, imF, th, [], 0); title('display mode 0')
subplot(122)
[h, ax, cb] = imagesc_fmri(imM, imF, th, [], 1); title('display mode 1');

end

