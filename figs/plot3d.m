function plot3d(x)
% plot3 wrapper
import attr.*

C = colororder;
colororder([C(1,:); C(3,:); C(2,:); C(4:end, :)]); % Michigan color order

argpair_ind = find(cellfun(@ischar, varargin), 1, 'first');

if isempty(argpair_ind), dat_c = varargin;
else,                    dat_c = varargin(1:argpair_ind-1);
end
varargin = varargin(argpair_ind:end);

arg.doProj = true;

[arg, varargin] = attrParser(arg, varargin);

washold = ishold();
if ~washold, cla; end

hold on
p_c = cell(1, numel(dat_c));

p_c{1} = plot3(dat_c{1}(:,1), dat_c{1}(:,2), dat_c{1}(:,3), varargin{:});
[xl, yl, zl] = deal(xlim(), ylim(), zlim());

for ii = 2:numel(dat_c)
  p_c{ii} = plot3(dat_c{ii}(:,1), dat_c{ii}(:,2), dat_c{ii}(:,3), varargin{:});
  
  [xl, yl, zl] = deal(min(xl, xlim()), min(yl, ylim()), min(zl, zlim()));
end

dummy = ones(size(dat_c{1}(:,1)));
if arg.doProj
  for ii = 1:numel(dat_c)
    color = [p_c{ii}.Color, 0.7];
    lw = p_c{ii}.LineWidth/2;

    plot3(xl(1)*dummy,    dat_c{ii}(:,2), dat_c{ii}(:,3), ...
      'Color',color, 'LineWidth',lw, 'LineStyle',':');

    plot3(dat_c{ii}(:,1), yl(1)*dummy,    dat_c{ii}(:,3), ...
      'Color',color, 'LineWidth',lw, 'LineStyle',':');

    plot3(dat_c{ii}(:,1), dat_c{ii}(:,2), zl(1)*dummy,    ...
      'Color',color, 'LineWidth',lw, 'LineStyle',':');
  end
end

hold off

if washold; hold on; end

end
