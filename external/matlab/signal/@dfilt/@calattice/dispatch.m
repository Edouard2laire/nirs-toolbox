function Hd = dispatch(this)
%DISPATCH   Returns the LWDFILT.

%   Author(s): J. Schickler
%   Copyright 2004 The MathWorks, Inc.

[b, a] = cl2tf(this.Allpass1, this.Allpass2, this.Beta);

Hd = lwdfilt.tf(b, a);

[b, a] = cl2tf(this.refAllpass1, this.refAllpass2, this.refBeta);

set(Hd, 'refnum', b, ...
    'refden', a);

% [EOF]