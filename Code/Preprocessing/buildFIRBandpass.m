function [b, a] = buildFIRBandpass(order, fc1, fc2, fs, beta)
    arguments
        order (1,1) {mustBeInteger, mustBePositive}
        fc1   (1,1) {mustBePositive}
        fc2   (1,1) {mustBePositive}
        fs    (1,1) {mustBePositive}
        beta  (1,1) double = 5
    end
    if fc1 >= fc2, error('Fc1 must be < Fc2.'); end
    if fc2 >= fs/2, error('Fc2 must be < fs/2 (Nyquist).'); end

    Wn = [fc1 fc2] / (fs/2);                                      % 归一化
    b  = fir1(order, Wn, 'bandpass', kaiser(order+1, beta), 'scale');
    a  = 1;


end
