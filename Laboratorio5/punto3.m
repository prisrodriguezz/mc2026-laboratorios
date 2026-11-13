
function punto3()

    clc;
    clear;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 3 \n");
    printf("========================\n");

    % Definicion de vectores de datos (x e y)
    x = [0, 0.4, 0.75, 1.5, 2.0];
    y = [1, 1.63246, 1.86603, 2.22474, 2.41421];

    fprintf('Datos tabulares cargados:\n');
    fprintf('     x          y\n');
    disp([x', y']);

    fprintf('Pulsar "Enter" para aplicar Lagrange...\n');
    pause;

    printf("\n-------------------------------------------------------\n");
    printf("a. INTERPOLACION DE LAGRANGE PARA x = 1\n");
    printf("-------------------------------------------------------\n");

    x_a = 1;

    [y_a, coef_a, tiempo_a] = metodo_lagrange(x, y, x_a);

    fprintf('\nPolinomio interpolante de grado %d\n', length(x)-1);
    fprintf('P(x) = sumatoria de y(i) * L(i,x)\n');

    fprintf('\nCoeficientes de Lagrange:\n');
    for i = 1:length(x)
        fprintf('L%d = %.8f\n', i-1, coef_a(i));
    end

    fprintf('\nValor interpolado: %.8f\n', y_a);

    fprintf('\nPulsar "Enter" para resolver el inciso b...\n');
    pause;

    printf("\n-------------------------------------------------------\n");
    printf("b. INTERPOLACION DE LAGRANGE PARA x = 0.45\n");
    printf("-------------------------------------------------------\n");

    x_b = 0.45;

    [y_b, coef_b, tiempo_b] = metodo_lagrange(x, y, x_b);

    fprintf('\nCoeficientes de Lagrange:\n');
    for i = 1:length(x)
        fprintf('L%d = %.8f\n', i-1, coef_b(i));
    end

    fprintf('\nValor interpolado: %.8f\n', y_b);

    printf("\n======================================================\n");
    printf("                 RESULTADOS FINALES                   \n");
    printf("======================================================\n");

    fprintf('INCISO A - Lagrange (x = %.2f):\n', x_a);
    fprintf('- Valor interpolado (y): %.8f\n', y_a);

    fprintf('\nINCISO B - Lagrange (x = %.2f):\n', x_b);
    fprintf('- Valor interpolado (y): %.8f\n', y_b);

    fprintf('\nANALISIS (Tiempos computacionales):\n');
    fprintf('- Tiempo inciso A: %.8f segundos\n', tiempo_a);
    fprintf('- Tiempo inciso B: %.8f segundos\n', tiempo_b);

    fprintf('======================================================\n');

    fprintf('\nCONCLUSION:\n');
    fprintf('Se aplico el metodo de interpolacion de Lagrange\n');
    fprintf('para estimar los valores correspondientes a\n');
    fprintf('x = 1 y x = 0.45 utilizando los cinco puntos.\n');
    fprintf('El polinomio obtenido es de grado maximo 4.\n');

end


% =========================================================
% FUNCIONES
% =========================================================

function [y_interp, coeficientes, tiempo] = metodo_lagrange(x, y, x_buscado)

    tic;

    n = length(x);
    y_interp = 0;
    coeficientes = zeros(1, n);

    for i = 1:n

        L_i = 1;

        for j = 1:n

            if i ~= j
                L_i = L_i * (x_buscado - x(j)) / (x(i) - x(j));
            end

        end

        coeficientes(i) = L_i;

        % Sumatoria final del polinomio
        y_interp = y_interp + y(i) * L_i;

    end

    tiempo = toc;

end
