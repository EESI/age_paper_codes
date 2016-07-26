function K = linear_kernel(u,v,varargin) 
%LINEAR_KERNEL Linear kernel for SVM functions

% Copyright 2004-2010 The MathWorks, Inc.
% $Revision: 1.1.22.1 $  $Date: 2011/12/27 15:39:38 $
K = (u*v');
