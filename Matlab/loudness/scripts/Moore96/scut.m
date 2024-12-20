% scut.m - cuts rectangular portion of a signal's fourier transform.
%			  Fourier coefficients outside the passband specified by flow
%			  and fhigh are set to zero.
%
% Usage: cut = scut(in,flow,fhigh,fs)
%
% in     = input vector containing a signal's discrete fourier transform
% flow   = lower cutoff frequency in Hz
% fhigh  = upper cutoff frequency in Hz 
% fs     = sampling rate in Hz 
%
% cut    = output vector

function cut = scut(in,flow,fhigh,fs);

len = length(in);
flow = round(flow*lenK)6�rNUW�*�Y��q����OI��w�����1��u6��S{�i֭Ye<�f�\[��8l�+{vy�5/�|��p�D�YQ_��1�X���V�2�I��k����y�g��ٌ$���3�xqh�9�d*���ڴ�s%.22H/�������7��