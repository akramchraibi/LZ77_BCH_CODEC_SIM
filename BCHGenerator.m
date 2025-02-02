function [g, h,gString,hString, n,p] = BCHGenerator(m, t)
    % BCHGenerator generates the BCH generator polynomial and check polynomial.
    % Input:
    %   m - The degree of the finite field GF(2^m)
    %   t - Error correction capability of the BCH code
    % Output:
    %   g - The generator polynomial
    %   h - The check polynomial
    %   n
    %   k
    
    % Primitive polynomial for GF(2^m)
    n = 2^m - 1; % Length of the BCH code
    p = primpoly(m, 'max')'; % Primitive polynomial
   

    % Determine the generator polynom   ial g based on t
    if t == 2
        m1 = polynomem(2, m, p);
        m3 = polynomem(8, m, p);
        g = conv(m1, m3);
    elseif t == 1
        m1 = polynomem(2, m, p);
        g = m1;
    else
        m1 = polynomem(2, m, p);
        m3 = polynomem(8, m, p);
        m5 = polynomem(11, m, p);
        g = conv(m1, conv(m3, m5));
    end

    % Remove leading zeros from g
    j = find(g ~= 0, 1, 'first');
    g = g(j:end);

    % Calculate the check polynomial h = (D^n + 1) / g
    h = deconv(gf([1 zeros(1, n - 1) 1]), g);

    % Convert polynomials to string representations
    gString = "";
    for i = 1:length(g)
        if g(i) ~= 0
            if i == length(g)
                term = "1";
            elseif i == length(g) - 1
                term = "D";
            else
                term = "D^" + (length(g) - i);
            end
            if gString == ""
                gString = term;
            else
                gString = term + "+" + gString;
            end
        end
    end

    hString = "";
    for i = 1:length(h)
        if h(i) ~= 0
            if i == length(h)
                term = "1";
            elseif i == length(h) - 1
                term = "D";
            else
                term = "D^" + (length(h) - i);
            end
            if hString == ""
                hString = term;
            else
                hString = term + "+" + hString;
            end
        end
    end

    % Display the results
    disp("g = " + gString);
    disp("h = " + hString);
    k = n - length(g)+1;
end
