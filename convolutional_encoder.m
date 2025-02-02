function [hex_output, binary_output] = convolutional_encoder(h, n, k, X)
    % Convert h to a binary vector if it's not already
    if isa(h, 'gf')
        h = double(h.x);
    elseif islogical(h)
        h = double(h);
    end
    
    % Convert hex input to binary if it's a string starting with '0x'
    % if ischar(X) || isstring(X)
        % if startsWith(X, '0x')
            % X = X(3:end); % Remove '0x' prefix
        % end
        % X = hex2dec(X);  % Convert to decimal
        % X = dec2bin(X) - '0'; % Convert to binary array
        X = double(X);   % Ensure double type
    % end
    
    % Pad X with zeros if needed
    N = length(X);
    while mod(N,k) ~= 0
        X = [0 X];
        N = length(X);
    end
    
    % Initialize matrices
    X1 = zeros(N/k, k);
    binary_output = [];
    
    % Process each sequence
    for i = 1:N/k
        for j = 1:k
            X1(i,j) = X(j+(i-1)*k);
        end
        binary_output = [binary_output Codeur_H(X1(i,:), h, n, k, 0)];
    end
    
    % Convert binary sequence to string then to hex
    binary_str = sprintf('%d', binary_output);
    v = str2num(binary_str(:))'; % Convert to numeric array
    hex_output = binaryVectorToHex(v);
end

function S = Codeur_H(X, h, n, k, a)
    % Convert inputs to Galois field elements
    h = gf(h,1);  % Changed from gf(h,2) to gf(h,1)
    X = gf([0 X zeros(1,n-k)],1);  % Changed from gf(...,2) to gf(...,1)
    c = gf([zeros(1,n+1)],1);      % Changed from gf(...,2) to gf(...,1)
    C = [c];
    
    for i = 1:k-1
        C = [C;c];
    end
    
    A = [X(1)];
    for i = 1:k
        A = [A,C(i,1)];
    end
    A = [A,X(1)];
    
    for i = 2:k+1
        C(1,i) = X(i);
        for j = 2:k
            C(j,i) = C(j-1,i-1);
        end
        B = [X(i)];
        for j = 1:k
            B = [B C(j,i)];
        end
        B = [B X(i)];
        A = [A;B];
    end
    
    for i = k+2:n+1
        C(1,i) = h(2)*C(1,i-1);
        for j = 2:k
            C(1,i) = C(1,i)+h(j+1)*C(j,i-1);
        end
        B = [X(i) C(1,i)];
        for j = 2:k
            C(j,i) = C(j-1,i-1);
            B = [B C(j,i)];
        end
        B = [B C(1,i)];
        A = [A;B];
    end
    
    A = A.x;
    a = [];
    for i = 2:n+1
        a = [a A(i,end)];
    end
    S = a;
end