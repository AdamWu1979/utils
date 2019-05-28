
function cmap_co = colormapn(target, map_c)

if nargin == 0, test(); return; end

cmap_c = cell(1,numel(target));
for ii = 1:numel(map_c)
  if ~isempty(map_c{ii}), cmap_c{ii} = colormap(target(ii),map_c{ii}); end
end

if nargout > 0, cmap_co = cmap_c; end

end

function test()

subplot(121), imagesc(phantom); ax(1) = gca;
subplot(122), imagesc(phantom'); ax(2) = gca;

map_c = {'gray', 'hot'};
colormapn(ax, map_c);

end
