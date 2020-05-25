function [phs_c, phs] = phs4Shift(shifts, type, typeVal, varargin)
% function res = phs4Shift(x, shifts)
%   call as phsShift(x, [sx1, sy1, ... ; sx2, sy2, ...; ...])
%   generate linear phases for Nd phase shifts
%INPUTS:
% - shifts (ns, ndim): shift along each dimension
% - {type, typeVal} pair
%   - {{1, 'd', 'dims'}, (ndim,)};        typeVal a.u.
%     input is dims, to-be-shifted array's size
%   - {{2, 'm', 'mask'}, ([nd])};         typeVal boolean
%     input is mask, mask where to apply phs-shift (in frq-domain)
%   - {{3, 'l', 'locs'}, (nk, (1+)ndim)}  typeVal cycle/fov/nPixel
%     input is normalized (m)locs, locations to apply phs-shift (in frq-domain)
%OPTIONALS:
% - doExp (T/f): return exponential phase rather than radian phase
% - doFFTShift (t/F): for non-locs shift only, fftshift 0-phase or not
%Output:
% - phs_c:
%   - {1, ndim}, non-locs shifts, dim-separated lin-phs, Nd+1 dim has size ns
%   - {0,}, type == 3, forced empty cell output
% - phs:
%   - ([nd], ns), non-locs combined phases, nd-by-ns (exponential/radian)
%   - (nloc, ns), locs combined phases
%
% see also, doShift

import attr.*

if nargin == 0, test(); return; end
[opt.doExp, opt.doFFTShift] = deal(true, true);
[opt, ~] = attrParser(opt, varargin); % set optional variables

if opt.doExp, [fn_comb, fn_phs] = deal(@times, @(x)exp(1i*x));
else,         [fn_comb, fn_phs] = deal(@plus,  @(x)x);
end

switch lower(type)
  case {1, 'd', 'dims'}
    [dims, m] = deal(typeVal, true);
  case {2, 'm', 'mask'}
    [dims, m] = deal(size(typeVal), typeVal);
  case {3, 'l', 'locs'} % location should be normalized to [-0.5, 0.5]
    m = typeVal(:,1);
    if isequal(~~m, m), locs = typeVal(:,2:end); % if column 1 is a mask
    else,               [m, locs] = deal(~~m, typeVal);
    end
    
    if ~isreal(locs), locs = [real(locs), imag(locs)]; end % complex assume 2D
    
    phs_c = {};
    phs = fn_phs(2*pi * (locs(:,1:size(shifts,2))*-shifts'));
    phs = bsxfun(@times, phs, m); % masking
    
    return
  otherwise, error('not supported');
end

dodims = any(shifts,1); % dim along which shifts
[Nd, Nd1] = deal(numel(dims), numel(dodims));

if opt.doFFTShift, cSub = ctrSub(dims); else, cSub = ones(size(dims)); end

phs_c = cell(1, Nd);
if opt.doExp, [phs, phs_c(:)] = deal(1, {1});
else,         [phs, phs_c(:)] = deal(0, {0});
end

% for mask case, indices are reshaped along the corresponding dimension
fn_inds = @(id)shiftdim( (((1:dims(id))-cSub(id))/dims(id)), -(id-2) );

for id = 1:Nd1 % for-loop is usually faster than cellfun
  if dodims(id)
    phraw = wrapToPi(2*pi * fn_inds(id)); % phraw in radians
    phraw = bsxfun(@times, phraw, shiftdim( -shifts(:,id), -Nd));
    phs_c{id} = fn_phs(phraw);
  end
end

if nargout == 2
  for id = 1:Nd1, if dodims(id), phs = bsxfun(fn_comb,phs,phs_c{id}); end, end
  phs = bsxfun(@times, phs, m); % masking
end

end

%% test
function test()

P = phantom;
P = cat(3, P, rot90(P), rot90(P,2));
P(5,5,:) = max(P(:)); % a marker visualizing the shifts

shifts = [10, 0; 0, 10];

kP = mfft3(P);
ndim = size(P);
mask = true(ndim);
locs = mask2mlocn(mask);

[phsExp_c,~] = phs4Shift(shifts, 'dims',ndim, 'doExp',1,'doFFTShift',1);
[~, phsExp1] = phs4Shift(shifts, 'mask',mask, 'doExp',1,'doFFTShift',1);
[~, phsExp2] = phs4Shift(shifts, 'locs',locs, 'doExp',1);

kP1 = kP;
for ii = 1:numel(phsExp_c)
  kP1 = bsxfun(@times, kP1, phsExp_c{ii});
end

kP2 = bsxfun(@times, kP, phsExp1);
kP3 = bsxfun(@times, kP, reshape(phsExp2, size(phsExp1)));

figure, im(real(mifft3(kP1)));
figure, im(real(mifft3(kP2)));
figure, im(real(mifft3(kP3)));
end
