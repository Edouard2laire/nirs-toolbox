function [y,zf,tapIndex] = dfsymmetricfirfilter(q,b,x,zi,tapIndex)
% DFSYMMETRICFIRFILTER Filter for DFILT.DFSYMFIR class in double precision mode

%   Author(s): V.Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

x = quantizeinput(q,x);
[y,zf,tapIndex] = dfsymmetricfirfilter(b,x,zi,tapIndex);