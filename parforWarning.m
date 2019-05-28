function parforWarning(doWarning)
% One may unintentionally nest parfors and confused on performance bottleneck.
% This function checks if parfor is nested when called inside a parfor.
if ~exist('doWarning', 'var'), doWarning = true; end

if doWarning
  if isempty(gcp('nocreate'))
    callStack = dbstack;
    callerName = callStack(2).name;
    warning(['No parpool found for ', callerName...
             , ', if not expected, you may be nesting parfor.']);
  end
end

end

