function g = k2g(TxRx, kpcm, dt, gam)
% Gradient from kTraj, modified from Hao's k2g_hao().
% INPUT
% - TxRx, str,
%     Tx, k is assumed to end at the 0, output g(end,:) == 0
%     Rx, k is assumed to start at the 0, output g(1,:) == 0
% - kpcm (Nt, Nd) cycle/cm
%OPTIONAL
% - dt,  (1,), Sec
% - gam, (1,), Hz/G
% OUTPUT
% - g (Nt, Nd), G/cm

[dt0, gam0] = envMR('get', 'dt','gam');
if ~nonEmptyVarChk('dt'),  dt  = dt0;  end % Sec
if ~nonEmptyVarChk('gam'), gam = gam0; end % Hz/Gauss

g = diff(kpcm,1,1)/gam/dt;

switch lower(TxRx)
  case 'tx'
    if all(kpcm(end,:) < 1.2*g(end,:))
      g = [g; kpcm(end,:)];
    else
      warning('Tx: k (kpcm) should end with 0');
      g = [g; zeros(1, size(g,2))];
    end
  case 'rx'
    if all(kpcm(1,:) < 1.2*g(1,:)) % 1.2 was chosen to allow a bit overrun
      g = [kpcm(1,:); g];
    else
      warning('Rx: k (kpcm) should start near 0');
      g = [zeros(1, size(g,2)); g];
    end
  otherwise
    error('Transmit (tx) or Receive (rx)???');
end

end
