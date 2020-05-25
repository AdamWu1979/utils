function [y] = resize(x, sy, method, extrapval)
%function [y] = resize(x, sy, method, extrapval)
% This function resizes a Nd input, `x`, to size, `sy`. It can be viewed as an
% Nd extension to imresize.m
%INPUTS:
% x, nd-array to be resized.
% sy (nd,), target size vector
%OPTIONAL:
% `method`, and `extrapval`, variable to be passed to `interpn`
%OUTPUTS:
% - y (sy), result nd-array

if isequal(size(x), sy), y = x; return; end
if nonEmptyVarChk('method'), method = 'linear'; end

sx = size(x);
if iscolumn(x), sx = sx(1); elseif isrow(x), sx = sx(2); else; end
[sx_c, sy_c] = deal(num2cell(sx), num2cell(sy));

coord_c = cell(numel(sx_c),1);
[coord_c(:)] = cellfun(@(sx,sy)linspace(1,sx,sy), sx_c, sy_c, 'Uni', false);

grid_c = cell(numel(sx_c),1);
[grid_c{:}] = ndgrid(coord_c{:});

if nonEmptyVarChk('extrapval'), y = interpn(x, grid_c{:}, method, extrapval);
else                          , y = interpn(x, grid_c{:}, method);
end

end
