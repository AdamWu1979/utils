
function [h_o, ax_o, cb_o] = imagesc_fmri(imM, imF, th, cmap_c, mode)

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

%% know issues
% 1. colorbars may trespass on other components or reach outside of the figure

