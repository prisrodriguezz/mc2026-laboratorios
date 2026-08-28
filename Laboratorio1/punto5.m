clc;
clear;

N = input("Ingrese la cantidad de N: ");

S = 1;

% Factorial de 0
factorial = 1;

% Construccion de las cadenas de texto para mostrar la serie
cadena_factorial = "e = 1";

tic

for i = 1:N

    factorial = factorial * i;
    S = S + 1 / factorial;

    % Agregar termino en formato factorial (1/1!, 1/2!, ...)
    cadena_factorial = sprintf("%s + 1/%d!", cadena_factorial, i);

endfor

tiempo = toc;

% Valor de referencia de e
e_exacto = exp(1);

% Calcular errores
error_absoluto = abs(e_exacto - S);
error_relativo = error_absoluto / abs(e_exacto);

% Resultados
fprintf("\n--- DESARROLLO DE LA SERIE ---\n");
fprintf("%s\n", cadena_factorial);

fprintf("\n--- RESULTADOS ---\n");
fprintf("Cantidad de sumandos: %d\n", N);
fprintf("Aproximacion de e = %.15f\n", S);
fprintf("Valor de referencia = %.15f\n", e_exacto);

fprintf("\nError absoluto = %.15e\n", error_absoluto);
fprintf("Error relativo = %.15e\n", error_relativo);

fprintf("\nTiempo de ejecucion = %.9f segundos\n", tiempo);


%{
Conclusion:
Se observa que al aumentar la cantidad de sumandos N,
la aproximacion obtenida para el numero 'e' se acerca cada
vez mas a su valor de referencia. Esto se refleja en la
disminucion del error absoluto y del error relativo.
Por lo tanto, una mayor cantidad de términos permite obtener una
mayor precision en el calculo de 'e'.
%}
