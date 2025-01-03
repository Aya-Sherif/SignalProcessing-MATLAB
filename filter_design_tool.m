function h = filter_design_tool
    % User inputs
    N = input('Enter the filter length (odd number preferred): ');  % Filter length
    fc = input('Enter the normalized cutoff frequency (0 < fc < 0.5): '); % Cutoff frequency
    scale_type = input('Choose the scale for magnitude response (linear/log): ', 's');

    % Generate the ideal sinc filter (low-pass)
    n = -(N-1)/2:(N-1)/2;  % Symmetric indices
    h_ideal = sinc(2 * fc * n);  % Ideal sinc filter
    
    % Ask user to choose the window type
    disp('Choose a window type:');
    disp('1. Rectangular');
    disp('2. Blackman');
    disp('3. Chebyshev');
    disp('4. Kaiser');
    window_choice = input('Enter the number corresponding to the window type: ');

    % Apply the chosen window type
    switch window_choice
        case 1
            w = ones(1, N);  % Rectangular window
        case 2
            w = blackman(N)';  % Blackman window
        case 3
            ripple = 50;  % Chebyshev ripple in dB
            w = chebwin(N, ripple)';  % Chebyshev window
        case 4
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
