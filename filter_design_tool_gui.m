function h = filter_design_tool_gui(N, fc, scale_type, window_choice)
    % Generate the ideal sinc filter (low-pass)
    n = -(N-1)/2:(N-1)/2;  % Symmetric indices
    h_ideal = sinc(2 * fc * n);  % Ideal sinc filter
    
    % Apply the chosen window type
    switch window_choice
        case 'Rectangular'
            w = ones(1, N);  % Rectangular window
        case 'Blachman'
            w = blackman(N)';  % Blackman window
        case 'Chebyshev'
            ripple = 50;  % Chebyshev ripple in dB
            w = chebwin(N, ripple)';  % Chebyshev window
        case 'Kaiser'
            beta = 5;  % Kaiser beta parameter
            w = kaiser(N, beta)';  % Kaiser window
        otherwise
            error('Invalid window choice. Please select a valid window type.');
    end
    
    % Windowed sinc filter
    h = h_ideal .* w;
    
    % Frequency response
    [H, f] = freqz(h, 1, 1024, 'whole');
    
    %____
    % Adjust the frequency vector to include negative frequencies
    f = f - pi; % Shift frequencies from [0, 2π] to [-π, π]
    H = fftshift(H); % Shift the frequency response for proper alignment
    %___

    % Plotting
    figure;
    if strcmp(scale_type, 'log')
        plot(f/pi, 20*log10(abs(H)));  % Log scale (dB)
        ylabel('Magnitude (dB)');
    else
        plot(f/pi, abs(H));  % Linear scale
        ylabel('Magnitude');
    end
    xlabel('Normalized Frequency (\times\pi rad/sample)');
    title('Windowed FIR Filter');
    grid on;
    
    % Return the filter coefficients (h)
end
