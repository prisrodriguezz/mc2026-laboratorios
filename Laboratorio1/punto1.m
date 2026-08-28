clc;
clear;

N = input("Ingrese la cantidad de numeros: ");

S = 0;

% Iniciar medicion del tiempo
tic

% Algoritmo
for i = 1:N

    X = input(["Ingrese el numero ", num2str(i), ": "]);

    while X <= 0
        disp("El numero debe ser positivo");
        X = input(["Ingrese el numero ", num2str(i), ": "]);
    endwhile

    S = S + X;

endfor

% Finalizar medicion
tiempo = toc;

% Mostrar resultados
fprintf("N = %d\n", N);
fprintf("Iteraciones = %d\n", N);
fprintf("Suma obtenida = %.2f\n", S);
fprintf("Tiempo de ejecucion = %.9f segundos\n", tiempo);
