clc;
clear;

N = 200;
S = 0;
cantidad_pares = 0;
pares = [];

tic

% Algoritmo
for i = 1:N

    % Generar un numero entero aleatorio entre 1 y 100
    X = randi([1, 100]);

    % Verificar si el numero es par
    if mod(X, 2) == 0
        S = S + X;
        cantidad_pares = cantidad_pares + 1;

        % Guardar el numero par en el vector
        pares(end + 1) = X;
    endif

endfor

tiempo = toc;

% Mostrar resultados
fprintf("N = %d\n", N);
fprintf("Cantidad de numeros pares = %d\n", cantidad_pares);
fprintf("Suma de numeros pares = %.2f\n", S);
fprintf("Tiempo de ejecucion = %.9f segundos\n", tiempo);

% Mostrar los numeros que fueron sumados
fprintf("\nNumeros pares sumados:\n");
disp(pares);


%{
Conclusion:
Se observa que de los 200 numeros generados, solo se
consideran aquellos que cumplen la condicion de ser pares.
La suma obtenida corresponde a la suma de todos los valores
pares encontrados. La cantidad de numeros pares puede variar
en cada ejecucion debido a que los valores se generan
aleatoriamente.
%}
