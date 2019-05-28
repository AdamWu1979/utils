function kpcm = g2k(TxRx, g, dt, gam)
% function kpcm = g2k(TxRx, g, dt, gam)
% kTraj from Gradient, modified from Hao's g2k_hao().
% INPUT
%  TxRx, str,
%    Tx, k is assumed to end at the 0
%    Rx, k is assumed to start at the 0
%  g,   (Nt, Nd), G/cm
%  fov, (Nd,), cm
%  dt,  (1)  , optional, Sec
%  gam, (1)  , optional, Hz/Gauss
% OUTPUT
%  kpcm,(Nt, Nd), cycle/cm

[dt0, gam0] = envMR('get', 'dt','gam');
if ~nonEmptyVarChk('dt'),  dt  = dt0;  end % Sec
if ~nonEmptyVarChk('gam'), gam = gam0; end % Hz/Gauss

switch lower(TxRx)
  case 'tx' % transmit Traj
    kpcm = -flipud(cumsum(flipud(g),1) * dt * gam);
  case 'rx' % receive Traj
    kpcm = cumsum(g) * dt * gam;
end

end
