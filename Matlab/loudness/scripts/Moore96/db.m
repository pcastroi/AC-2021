function factor = db(dbvalue)
%	conversion from dB to factor: 10^(dbvalue/20)


factor = 10.^(dbvalue/20);
