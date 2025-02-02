clear all;
close all;
clc;

m = 4;
t = 2;

[g, h, n, p] = BCHGenerator(m, t); % Functions that are used by BCHGenerator : polynomem

%%%%%%%%%%%%%%%coding%%%%%%%%%%%%%
k = length(h)-1
% X = '0x235';
% % [hex_output, binary_output] = convolutional_encoder(h, n, k, X); % Functions that are used by convolutional_encoder : Codeur_H
% 
% %%%%%%%%%%%%%%decoding%%%%%%%%%%%%%%%%
% m=4;
% p=25;
% t=2;
% 
% X='0x022E35E2';
% L=30;%nombre de bits à decoder
% 
% [hex,AA] = Decodeur(m,p,t,k,X,L);

% Appel de la fonction de codage convolutionnel
% [hex_output, binary_output] = convolutional_encoder(h, n, k, X);

% % Probabilité d'erreur (par exemple, p = 0.1 pour 10 % d'erreurs)
% p = 0.1;
% % Simuler les erreurs sur le canal symétrique binaire
% [noisy_binary_output, noisy_hex_output] = noise(AA, p);
% % Afficher les résultats
% disp('Binary output without noise:');
% disp(AA);
% disp('Hexadecimal output without noise:');
% disp(hex);
% % Afficher les résultats
% disp('Binary output with noise:');
% disp(noisy_binary_output);
% disp('Hexadecimal output with noise:');
% disp(noisy_hex_output);


[FileName,PathName] = uigetfile("*.bin","Veuillez selectionner un Fichier .bin")
path = fullfile(PathName, FileName);
bin = readlines(path);
bin = [bin{:}]
length(bin)
% Convert the binary string into a numerical array
binaryArray = arrayfun(@(x) str2double(x), bin);


[hex_output, binary_output] = convolutional_encoder(h, n, k, binaryArray); % Functions that are used by convolutional_encoder : Codeur_H
L = length(binaryArray);
[hex,AA] = Decodeur(m,p,t,k,binaryArray,L);
disp(AA);
