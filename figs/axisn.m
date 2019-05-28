
function axisn(ax, varargin)

for ia = 1:numel(ax)
  axis(ax(ia), varargin{:});
end

end
