clear all;
close all;
clc;

hexStr = '1234567890ABCDEF1234567890ABCDEFbaaaaaaaaaaaa';  % More than 16 hex characters
decValue = customHex2Dec(hexStr);
disp(decValue);