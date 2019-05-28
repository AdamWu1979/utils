function isInside = isParfor()
% function isInside = isParfor()
% Check if parpool is not enabled
% Procedures within a parfor loop is not able to interact through cmd
% window, which may cause process to halt and the parfor won't terminate
isInside = ~isempty(getCurrentTask());
end

