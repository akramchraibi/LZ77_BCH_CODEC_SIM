function dec = customHex2Dec(hexStr)
    % Initialize the decimal result as 0 using vpa (variable precision arithmetic)
    dec = vpa(0);
    
    % Check the length of the hex string
    len = length(hexStr);
    
    % Divide the hex string into chunks of up to 16 characters
    chunkSize = 16;
    numChunks = ceil(len / chunkSize);
    
    for i = 1:numChunks
        % Get the current chunk (from the rightmost part of the string)
        startIdx = max(1, len - (i * chunkSize) + 1);
        endIdx = len - (i - 1) * chunkSize;
        chunk = hexStr(startIdx:endIdx);
        
        % Convert the current chunk to decimal
        chunkValue = vpa(hex2dec(chunk));
        
        % Shift the chunk to its correct position in the full number
        % Each chunk represents 16 hex digits (64 bits), so we shift accordingly
        dec = dec + chunkValue * vpa(16)^((i - 1) * chunkSize);
    end
end