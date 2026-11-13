
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

    % =====================================================
    % INCISO A - INTERPOLACION DE LAGRANGE
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf("a. INTERPOLACION MEDIANTE LAGRANGE\n");
    printf("-------------------------------------------------------\n");

    [y_lagrange, tiempo_lagrange] = ...
        metodo_lagrange(x, y, x_buscado);

    fprintf('\nTemperatura: %.2f\n', x_buscado);
    fprintf('Densidad interpolada: %.8f\n', y_lagrange);

    fprintf('\nPulsar "Enter" para aplicar interpolacion parabolica...\n');
    pause;

    % =====================================================
    % INCISO B - INTERPOLACION PARABOLICA PROGRESIVA
    % =====================================================

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

    fprintf('\nComparacion entre ambos metodos:\n');
    fprintf('Diferencia absoluta: %.8f\n', error_abs);
    fprintf('Diferencia relativa: %.6f %%\n', error_rel);

    % Estimacion del error de interpolacion parabolica
    % mediante el primer termino omitido de Newton

    error_estimado = estimar_error( ...
        x(1:4), y(1:4), x_buscado);

    fprintf('\nEstimacion del error de interpolacion:\n');
    fprintf('Error estimado: %.8f\n', error_estimado);

    fprintf('\nPulsar "Enter" para ver las conclusiones...\n');
    pause;

    % =====================================================
    % INCISO C - ANALISIS Y CONCLUSIONES
    % =====================================================

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

    fprintf('\nCOMPARACION ENTRE METODOS:\n');
    fprintf('- Diferencia absoluta: %.8f\n', error_abs);
    fprintf('- Diferencia relativa: %.6f %%\n', error_rel);

    fprintf('\nESTIMACION DEL ERROR:\n');
    fprintf('- Primer termino omitido: %.8f\n', error_estimado);

    fprintf('======================================================\n');

    fprintf('\nCONCLUSION:\n');
    fprintf('Ambos metodos permiten estimar la densidad\n');
    fprintf('correspondiente a una temperatura de 275 grados.\n');
    fprintf('Lagrange utiliza los cinco puntos disponibles,\n');
    fprintf('mientras que la interpolacion parabolica utiliza tres.\n');
    fprintf('Los resultados son cercanos, aunque no identicos.\n');
    fprintf('La estimacion del error se obtuvo mediante\n');
    fprintf('el primer termino omitido del polinomio de Newton.\n');
    fprintf('Este valor no representa necesariamente el error real,\n');
    fprintf('ya que no se conoce la densidad exacta a 275 grados.\n');

end


% =========================================================
% FUNCIONES AUXILIARES
% =========================================================


% =========================================================
% METODO DE INTERPOLACION DE LAGRANGE
% =========================================================

function [y_interp, tiempo] = metodo_lagrange(x, y, x_buscado)

    tic;

    n = length(x);
    y_interp = 0;

    for i = 1:n

        L_i = 1;

        for j = 1:n

            if i ~= j
                L_i = L_i * ...
                    (x_buscado - x(j)) / (x(i) - x(j));
            end

        end

        y_interp = y_interp + y(i) * L_i;

    end

    tiempo = toc;

end


% =========================================================
% INTERPOLACION PARABOLICA PROGRESIVA
% Diferencias divididas de Newton
% =========================================================

function [y_interp, tiempo] = interpolacion_parabolica(x, y, x_buscado)

    tic;

    % Primeras diferencias divididas
    d01 = (y(2) - y(1)) / (x(2) - x(1));
    d12 = (y(3) - y(2)) / (x(3) - x(2));

    % Segunda diferencia dividida
    d012 = (d12 - d01) / (x(3) - x(1));

    % Polinomio interpolante de segundo grado
    y_interp = y(1) + ...
        d01 * (x_buscado - x(1)) + ...
        d012 * (x_buscado - x(1)) * ...
        (x_buscado - x(2));

    tiempo = toc;

end


% =========================================================
% ESTIMACION DEL ERROR DE INTERPOLACION
% Primer termino omitido del polinomio de Newton
% =========================================================

function error_estimado = estimar_error(x, y, x_buscado)

    % Primeras diferencias divididas
    d01 = (y(2) - y(1)) / (x(2) - x(1));
    d12 = (y(3) - y(2)) / (x(3) - x(2));
    d23 = (y(4) - y(3)) / (x(4) - x(3));

    % Segundas diferencias divididas
    d012 = (d12 - d01) / (x(3) - x(1));
    d123 = (d23 - d12) / (x(4) - x(2));

    % Tercera diferencia dividida
    d0123 = (d123 - d012) / (x(4) - x(1));

    % Primer termino omitido del polinomio cuadratico
    error_estimado = abs(d0123 * ...
        (x_buscado - x(1)) * ...
        (x_buscado - x(2)) * ...
        (x_buscado - x(3)));

end
