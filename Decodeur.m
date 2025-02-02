function [hex, AA, correctedBits] = Decodeur(m, p, t, deg_de_h, X, K)
    % Input validation
    if m > 16
        error('Parameter m must be <= 16 for Galois Field operations');
    end

    % Initialize parameters
    n = 2^m-1;
    correctedBits = 0;  % Counter for corrected bits

    % Define alpha based on p value
    if p == 25
        alpha = [12;6;3;13;10;5;14;7;15;11;9;8;4;2;1];
    else
        alpha = [9;13;15;4;7;10;5;11;12;6;3;8;4;2;1];
    end

    % Convert hex input to binary
    FF = [];
    A = X;
    N = K - length(A);

    % Left pad with zeros if needed
    A = [zeros(1, N), A];

    % Convert to consistent binary format
    AA = zeros(1, length(A));
    for i = 1:length(A)
        AA(i) = double(A(i));
    end
    A = AA;

    % Create Galois Field elements
    try
        L = gf(alpha, m, p);
        Hx = H(L, t);
    catch ME
        error('Error in Galois Field creation: %s', ME.message);
    end

    % Process each sequence
    for j = 1:K/n
        % Extract current sequence
        B = A(1, 1 + (j - 1) * n:n + (j - 1) * n);
        B = gf(B, m, p);

        % Calculate syndrome
        S = B * Hx;
        Syndrome_alpha_a_la_puissance = position(S, alpha);

        % Calculate Sm and Sv matrices
        [Sm, Sv] = Smv(S, t);

        % Check if Sm is all zeros
        if all(Sm(:) == gf(0, m, p))
            % If Sm is all zeros, the sequence is correct
            Sg1 = gf([], m, p);  % Empty error locator polynomial
            F = [];
            Positions_erreurs = [];
        else
            ppp = 0;  % Counter for iterations
            maxIterations = 100;  % Maximum iterations before aborting

            while det(Sm) == gf(0, m, p) && size(Sm, 1) > 1 && size(Sm, 2) > 1 && ppp < maxIterations
                Sm = Sm(1:end-1, 1:end-1);  % Reduce Sm
                Sv = Sv(1:end-1);  % Reduce Sv
                ppp = ppp + 1;
            end

            % Check if maximum iterations were reached
            if ppp >= maxIterations
                error('Maximum iteration limit reached while reducing Sm and Sv.');
            end

            % Now solve for Sg1 if a valid Sm matrix remains
            if all(Sm(:) ~= gf(0, m, p))  % Check that Sm is not all zeros
                Sg1 = Sm \ Sv;  % Solve for error locator polynomial
            else
                % Handle case where no solution is found for Sm
                Sg1 = gf([], m, p);  % Empty error locator polynomial
                F = [];
                Positions_erreurs = [];
            end

            % Solve for Sg1
            Sg1 = Sm \ Sv;
            F = position(Sg1, alpha);

            % Add padding for removed terms
            for iiiii = 1:ppp
                F = [F, 404];
            end
        end

        % Find error positions if Sg1 is not empty
        if ~isempty(Sg1)
            d1 = roots([gf(1, m, p); Sg1]);
            Positions_erreurs = position(d1, alpha);

            % Correct errors
            for kkk = 1:length(Positions_erreurs)
                pos = length(B) - Positions_erreurs(kkk);
                if B(pos) == gf(1, m, p)
                    B(pos) = gf(0, m, p);
                else
                    B(pos) = gf(1, m, p);
                end
                correctedBits = correctedBits + 1;  % Increment corrected bits count
            end
        end

        % Convert B back to regular array before extracting elements
        B_array = double(B.x);
        % Add decoded sequence to FF
        FF = [FF, B_array(1:deg_de_h)];
    end

    % Convert final output to binary format
    AA = [];
    for i = 1:length(FF)
        if FF(i) == 1
            AA = [AA, 1];
        else
            AA = [AA, 0];
        end
    end
    hex = binaryVectorToHex(AA);
end
