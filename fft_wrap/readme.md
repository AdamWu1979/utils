# 2D and 3D (i)fft's with (i)fftshift's

Just to make daily 2D/3D Fourier transform operations handy.\
(i)fft3 intentionally does not do fftshifting by itself, trying to be consistent
with Matlab's built-in (i)fft2.

For fftshifting incorporated Fourier transform operations, check out `../mri`.

This directory also contains functions enhancing (Fourier) shifting operations:\
`doShift.m`:\
returns a (non-integer) circshifted version of the input nd-array.
`phs4Shift.m`:\
returns a linear phase to be applied in one domain that can result in a wanted
`shift` in the other domain after (inverse) FT.

