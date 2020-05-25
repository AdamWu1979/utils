function [m, h] = drawMask(P, varargin)
%function [m, h] = drawMask(P, varargin)
%INPUTS
% - P (nx, ny) real, the imaged based on which the mask is prescribed
%OPTIONAL
% - method str, {'poly','rect','circ','ellipse','free'}, way to prescribe mask;
%     dflt 'circ';
% - crange (2,), caxis(crange) used for presenting P
% - cmap  str, dflt 'gray', colormap for imagesc the P.
% - alapha (1,), dflt 0.3, alpha value for transparent mask display
% - pos, position vector, definition varies, check specific methods, e.g. impoly
% - isNewFigure [t/F]; Create a new figure for the procedure
% - isInteractive [t/F]; Allow tuning mask w/ mouse, double click inside to exit
%OUTPUTS
% - m (nx, ny), mask
% - h obj, object corresponding to 'method' prescribed

import attr.*

if nargin == 0; test(); return; end

arg.method = 'circ';
arg.crange = [min(P(:)), max(P(:))];
arg.cmap   = 'gray';
arg.alpha  = 0.3;
arg.pos    = [];
arg.isNewFigure = false;
arg.isInteractive = false;

arg = attrParser(arg, varargin);

[pos, method, crange, cmap, alpha, isNewFigure, isInteractive]=getattrs(arg ...
  , {'pos','method','crange','cmap','alpha','isNewFigure','isInteractive'});

if ~~isNewFigure, figure; end

hp = imagesc(P);
axis equal;
colormap(cmap);
caxis(crange);

grid on; % display grid to show transparentness.

% drawpolygon, etc. introduced in Matlab 2018b has inconsistent pos prescription
% ways. Hence this function stick w/ old style.
switch lower(method)
  case 'poly',              h = impoly(gca, pos);
  case 'rect',              h = imrect(gca, pos);
  case {'circ', 'ellipse'}, h = imellipse(gca, pos);
  case 'free',              h = imfreehand(gca, pos);
  otherwise, error('unknown method');
end

% double click inside hand prescribed roi to exist 'isInteractive'
if ~~isInteractive, wait(h); end

m = createMask(h);
AlphaData = double(m);
AlphaData(~m) = alpha;
hp.AlphaData = AlphaData;

if nargout < 2, delete(h); end

drawnow
end

%%
function test()

imMaskHand(phantom, 'isInteractive',1, 'method','rect','isNewFigure',1);
disp('imMaskHand.test() passed');
end
