function [noisy_binary_output, noisy_hex_output] = noise(binary_output, p)
    % Introduire des erreurs dans le signal binaire avec une probabilité p

    % Convertir binary_output en type double si nécessaire
    binary_output = double(binary_output);

    % Taille de la séquence binaire
    N = length(binary_output);

    % Générer un vecteur aléatoire de la même taille que la séquence binaire
    error_vector = rand(1, N) < p;  % 1 si erreur, 0 sinon (probabilité p)

    % Convertir error_vector en type double
    error_vector = double(error_vector);

    % Inverser les bits là où error_vector est 1
    noisy_binary_output = mod(binary_output + error_vector, 2);

    % Convertir la séquence binaire bruitée en chaîne de caractères
    binary_str = sprintf('%d', noisy_binary_output);
    
    % Convertir la chaîne binaire en hexadécimal
    v = str2num(binary_str(:))'; % Convertir en tableau numérique
    noisy_hex_output = binaryVectorToHex(v);
end