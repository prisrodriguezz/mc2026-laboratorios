
function punto4()

    clc;
    clear;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 4 \n");
    printf("========================\n");

    % Datos experimentales
    x = [102, 245, 327, 423, 565];
    y = [0.564642, 0.642218, 0.717356, 0.783327, 0.853329];

    x_buscado = 275;

    fprintf('Datos tabulares cargados:\n');
    fprintf('Temperatura | Densidad\n');
    disp([x', y']);

    fprintf('\nPulsar "Enter" para aplicar Lagrange...\n');
    pause;

    printf("\n-------------------------------------------------------\n");
    printf("a. INTERPOLACION MEDIANTE LAGRANGE\n");
    printf("-------------------------------------------------------\n");

    [y_lagrange, tiempo_lagrange] = metodo_lagrange(x, y, x_buscado);

    fprintf('\nTemperatura: %.2f\n', x_buscado);
    fprintf('Densidad interpolada: %.8f\n', y_lagrange);

    fprintf('\nPulsar "Enter" para aplicar interpolacion parabolica...\n');
    pause;

    printf("\n-------------------------------------------------------\n");
    printf("b. INTERPOLACION PARABOLICA PROGRESIVA\n");
    printf("-------------------------------------------------------\n");

    % Se utilizan los primeros tres puntos
    x_par = x(1:3);
    y_par = y(1:3);

    [y_parabolica, tiempo_parabolica] = ...
        interpolacion_parabolica(x_par, y_par, x_buscado);

    fprintf('\nPuntos utilizados:\n');
    disp([x_par', y_par']);

    fprintf('\nDensidad interpolada: %.8f\n', y_parabolica);

    % Diferencia entre las aproximaciones
    error_abs = abs(y_lagrange - y_parabolica);
    error_rel = (error_abs / abs(y_lagrange)) * 100;

    fprintf('\nEstimacion de discrepancia:\n');
    fprintf('Diferencia absoluta: %.8f\n', error_abs);
    fprintf('Diferencia relativa: %.6f %%\n', error_rel);

    fprintf('\nPulsar "Enter" para ver las conclusiones...\n');
    pause;

    printf("\n-------------------------------------------------------\n");
    printf("c. ANALISIS Y CONCLUSIONES\n");
    printf("-------------------------------------------------------\n");

    fprintf('\n======================================================\n');
    fprintf('                 RESULTADOS FINALES                   \n');
    fprintf('======================================================\n');

    fprintf('INCISO A - LAGRANGE:\n');
    fprintf('- Densidad: %.8f\n', y_lagrange);
    fprintf('- Tiempo: %.8f segundos\n', tiempo_lagrange);

    fprintf('\nINCISO B - PARABOLICA PROGRESIVA:\n');
    fprintf('- Densidad: %.8f\n', y_parabolica);
    fprintf('- Tiempo: %.8f segundos\n', tiempo_parabolica);

    fprintf('\nCOMPARACION:\n');
    fprintf('- Diferencia absoluta: %.8f\n', error_abs);
    fprintf('- Diferencia relativa: %.6f %%\n', error_rel);

    fprintf('======================================================\n');

    fprintf('\nCONCLUSION:\n');
    fprintf('Ambos metodos permiten estimar la densidad\n');
    fprintf('correspondiente a la temperatura de 275 grados.\n');
    fprintf('Lagrange utiliza los cinco puntos disponibles,\n');
    fprintf('mientras que la interpolacion parabolica utiliza tres.\n');
    fprintf('Los resultados son cercanos, aunque no identicos.\n');
    fprintf('La diferencia calculada no es el error verdadero,\n');
    fprintf('ya que no se conoce la densidad real para 275 grados.\n');

end


% =========================================================
% FUNCIONES
% =========================================================

% Metodo de interpolacion de Lagrange
function [y_interp, tiempo] = metodo_lagrange(x, y, x_buscado)

    tic;

    n = length(x);
    y_interp = 0;

    for i = 1:n

        L_i = 1;

        for j = 1:n

            if i ~= j
                L_i = L_i * (x_buscado - x(j)) / (x(i) - x(j));
            end

        end

        y_interp = y_interp + y(i) * L_i;

    end

    tiempo = toc;

end


% Interpolacion parabolica progresiva
% Mediante diferencias divididas de Newton
function [y_interp, tiempo] = interpolacion_parabolica(x, y, x_buscado)

    tic;

    % Primeras diferencias divididas
    d01 = (y(2) - y(1)) / (x(2) - x(1));
    d12 = (y(3) - y(2)) / (x(3) - x(2));

    % Segunda diferencia dividida
    d012 = (d12 - d01) / (x(3) - x(1));

    % Polinomio de segundo grado
    y_interp = y(1) + ...
        d01 * (x_buscado - x(1)) + ...
        d012 * (x_buscado - x(1)) * (x_buscado - x(2));

    tiempo = toc;

end
