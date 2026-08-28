clc;
clear;

% Ecuacion obtenida del enunciado:
% 3x^2 + 2x - 1 = 0

a = 3;
b = 2;
c = -1;

% Calcular tiempo
tic

% Calcular discriminante
discriminante = b^2 - 4*a*c;

% Algoritmo
if discriminante > 0

    % Calcular las dos soluciones
    x1 = (-b + sqrt(discriminante)) / (2*a);
    x2 = (-b - sqrt(discriminante)) / (2*a);

elseif discriminante == 0

    % Calcular la unica solucion
    x1 = -b / (2*a);

else

    disp("No existen soluciones reales");

endif

tiempo = toc;

% Mostrar resultados
fprintf("Ecuacion: %.0fx^2 + %.0fx - %.0f = 0\n", a, b, c);
fprintf("Discriminante = %.0f\n", discriminante);

if discriminante > 0
    fprintf("\nx1 = %.10f\n", x1);
    fprintf("x2 = %.10f\n", x2);
endif

fprintf("Tiempo de ejecucion = %.9f segundos\n", tiempo);

%{
Conclusion:
A partir del enunciado se obtuvo la ecuación de segundo grado
3x^2 + 2x - 1 = 0. Al calcular el discriminante se obtuvo
un valor positivo, por lo que existen dos raices reales.
Los valores encontrados fueron x1 = 1/3 y x2 = -1, siendo
ambos los valores numericos que cumplen la condicion planteada.
%}
