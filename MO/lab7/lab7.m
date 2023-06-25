clear;
close all;
clc;

r = 5 * 2;
q = (-1) * 2;
A = 2;
B = 7;
x0 = 50;
N = 6;

eps = 0.01;

p0_init = [-10, 10];

[x, u, J] = opt_dyn(r, q, A, B, N, x0, p0_init, eps) % sekcja 5