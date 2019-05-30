function dsc = diceCoeff(A, B)
%function dsc = diceCoeff(A, B)
% Compute Dice coefficient of two size-matched binary nd-array, A, B.

if nargin == 0, test(); return; end

[A, B] = deal(~~A, ~~B); % ensuring binary
numer = 2*nnz(A & B);
denom = nnz(A) + nnz(B);

dsc = numer/denom;

end

function test()
nd = [4, 4, 4];

% create two random binary nd-arrays
A = rand(nd) > 0.3;
B = rand(nd) > 0.2;

dsc = diceCoeff(A, B);

end
