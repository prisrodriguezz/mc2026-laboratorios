clc;
clear;

% Ingresar cantidad de terminos
N = input("Ingrese la cantidad de terminos:");

% Vector para almacenar la sucesion
F = zeros(1, N);

% Primeros terminos
F(1) = 0;

if N >= 2
    F(2) = 1;
endif

% Medir tiempo
tic

% Algoritmo
for i = 3:N
    F(i) = F(i-1) + F(i-2);
endfor

tiempo = toc;

% Mostrar la sucesion
fprintf("\nSucesion de Fibonacci:\n");

for i = 1:N
    fprintf("F(%d) = %.0f\n", i-1, F(i));
endfor

% Mostrar resultados
fprintf("\nCantidad de terminos: %d\n", N);
fprintf("Tiempo de ejecucion: %.9f segundos\n", tiempo);


%{
Conclusion:
Se obtuvieron correctamente los primeros 200 terminos de la
sucesion de Fibonacci. Cada termino se calcula a partir de los
dos anteriores y el algoritmo recorre la sucesion una sola vez.
Por lo tanto, la cantidad de operaciones crece proporcionalmente con N.
%}
