function reshaped = unwrap_signals(raw_data, w_len)
    % raw_data: Input data matrix with size N x (7 * w_len), 
    % where N is the number of windows, and w_len is the length of each window
    % w_len: Length of each window
    
    % Number of windows (N) and total number of columns in raw data
    [N, total_cols] = size(raw_data);
    
    % We want to ignore the last 200 columns (IC labels)
    n_cols = total_cols - w_len; % ignore label for initial contacts
    data_without_IC_labels = raw_data(:, 1:n_cols);
    % Now, reshape the data to have N windows, each with w_len rows and 6 columns
    % We will ignore the last column of the data which contains the IC label
    
    % Derive the number of channels
    num_channels = n_cols / w_len; 
    
    % Check if n_cols is divisible by w_len
    if mod(n_cols, w_len) ~= 0
        error('Number of columns must be a multiple of window length w_len');
    end

    % Pre-allocate the reshaped matrix
    reshaped = zeros(N * w_len, num_channels);
    
    % Loop through each channel and re-arrange the data
    for channel = 1:num_channels
        % Extract the corresponding columns for the current channel
        start_idx = (channel - 1) * w_len + 1;
        end_idx = channel * w_len;
        
        % Reshape the data column-wise
        reshaped(:, channel) = reshape(data_without_IC_labels(:, start_idx:end_idx)', [], 1);
    end
    
    % Note that the data is organized as follows:
    % - Column 1: acc_x (1: w_len)
    % - Column 2: acc_y (w_len+1 : 2 * w_len)
    % - Column 3: acc_z (2 * w_len + 1 : 3 * w_len)
    % - Column 4: gyr_x (3 * w_len + 1 : 4 * w_len)
    % - Column 5: gyr_y (4 * w_len + 1 : 5 * w_len)
    % - Column 6: gyr_z (5 * w_len + 1 : 6 * w_len)
    
    % The function will output the data in the shape of N * w_len * 6, where N is
    % the number of windows, w_len is the number of samples per window, and 6 corresponds to
    % the 6 channels of interest: acc_x, acc_y, acc_z, gyr_x, gyr_y, gyr_z.
    
    % The output will be in a 2D array where:
    % - First dimension: number of samples in the walking bout (N*w_len)
    % - Second dimension: 6 channels (acc and gyr signals)
end
