
function cb = colorbarn(ax)
% This function does not resize the axes to fit in colorbars. This compromise is
% due to unwanted behavior of built-in colorbar() function (up to 2017b). There,
% invoking multiple colorbars for .Position-linked (using linkprop()) multi-axes
% will shrink all axe.Position multiple times.

if nargin == 0, test(); return; end

cb = gobjects(1,numel(ax));

for ia = 1:numel(ax)
  pos = ax(ia).Position; % original position
  cb(ia) = colorbar(ax(ia));
  ax(ia).Position = pos; % reset to original position
end
cb(1).Location = 'westoutside'; % set colorbar of the 1st image to the left

end

function test()
subplot(121), imagesc(phantom);  ax(1) = gca;
subplot(122), imagesc(phantom'); ax(2) = gca;

cb = colorbarn(ax);

end

%% know issues
% 1. displayed colorbars may reach outside fig barriers or trespass on other
%    parts of the figure
