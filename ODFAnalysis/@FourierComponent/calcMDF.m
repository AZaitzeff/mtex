function mdf = calcMDF(odf1,odf2,varargin)
% calculate the uncorrelated misorientation distribution function (MDF) from one or two ODF

% get bandwidth
L = min([odf1.bandwidth,odf2.bandwidth]);

% compute Fourier coefficients of mdf
f_hat = [odf1.f_hat(1) * odf2.f_hat(1); zeros(deg2dim(L+1)-1,1)];
for l = 1:L
  ind = deg2dim(l)+1:deg2dim(l+1);
  f_hat(ind) = reshape(odf2.f_hat(ind),2*l+1,2*l+1) * ...
    reshape(odf1.f_hat(ind),2*l+1,2*l+1)' ./ (2*l+1);
end

% construct mdf
mdf = FourierODF(f_hat,odf2.CS,odf1.CS);

end

function testing
cs1 = crystalSymmetry('321');
cs2 = crystalSymmetry('432');

odf2 = unimodalODF(orientation.copper(cs1));
odf1 = unimodalODF(orientation.copper2(cs2));
mdf1 = calcMDF(odf2,odf1,'kernelMethod')

mdf2 = calcMDF(odf2,odf1)
figure(1);plotSection(mdf1,'sigma')
figure(2);plotSection(mdf2,'sigma')

end