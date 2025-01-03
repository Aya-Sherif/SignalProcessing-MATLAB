function h = Loops_ls_wls_filter_design
    % User inputs
    N = input('Enter the filter length (odd number preferred): ');  % Filter length
    num_points = input('Enter the number of frequency response points: '); % Frequency response points
    method = input('Choose the design method (LS/WLS): ', 's');  % LS or WLS
    scale_type = input('Choose the scale for magnitude response (linear/log): ', 's'); % Linear or log scale
    
    % Desired frequency response
    f = linspace(0, 1, num_points);  % Normalized frequency [0, 1]
    
    % Ask user for the cutoff frequencies
    passband_cutoff = input('Enter the normalized passband cutoff frequency (0-1): ');
    stopband_cutoff = input('Enter the normalized stopband cutoff frequency (0-1): ');

    
    % Weights for WLS (if applicable)
    if strcmpi(method, 'WLS')
        w_pass = input('Enter the weight for the passband: ');  % Passband weight
        w_trans = input('Enter the weight for the transition band: ');  % Transition band weight
        w_stop = input('Enter the weight for the stopband: ');  % Stopband weight
        
        % Assign weights to different frequency bands
        weights = ones(size(f));
        weights(f < passband_cutoff) = w_pass;  % Passband
        weights(f >= passband_cutoff & f <= stopband_cutoff) = w_trans;  % Transition band
        weights(f > stopband_cutoff) = w_stop;  % Stopband
    else
        weights = ones(size(f));  % Equal weights for LS
    end
    
    % Design logic
    L = floor((N - 1) / 2);  % Filter half-length
    omega = linspace(0, pi, num_points);  % Frequency range for filter
    omega_c = passband_cutoff * pi;  % Normalized cutoff frequency
    H_d = ones(num_points, 1);  % Desired frequency response
    H_d(omega > omega_c) = 0;  % Apply cutoff

    % Initialize matrix F for design equation
    F = zeros(num_points, L + 1);

    for i = 1:num_points
        F(i, 1) = 1;
        for j = 2:L + 1
            F(i, j) = 2 * cos(omega(i) * (j - 1));  % Cosine basis
        end
    end

    % Solve for filter coefficients using the pseudo-inverse
    W = diag(weights);
    h = pinv(W * F) * (W * H_d);
    h_combined = [flip(h(2:end)); h];
    k=num_points;
    
    freq = linspace(0, pi, k);
    H = abs(freqz(h_combined, 1, freq));  % Frequency response of designed filter

    % Plot the magnitude spectrum and compare with theoretical response
    figure;
    if strcmpi(scale_type, 'log')
        plot(freq/pi, 20*log10(abs(H)), 'b');  % Log scale (dB) for filter response
        hold on;
        plot(omega/pi, 20*log10(abs(H_d)), 'r--');  % Log scale (dB) for theoretical response
        ylabel('Magnitude (dB)');
    else
        plot(freq/pi, abs(H), 'b');  % Linear scale for filter response
        hold on;
        plot(omega/pi, abs(H_d), 'r--');  % Linear scale for theoretical response
        ylabel('Magnitude');
    end
    xlabel('Normalized Frequency (\times\pi rad/sample)');
    title([method ' FIR Filter Design']);
    legend('Filter Frequency Response', 'Theoretical Response');
    grid on;

    

    return;
end
