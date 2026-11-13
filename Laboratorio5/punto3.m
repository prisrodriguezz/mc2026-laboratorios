
function punto3()

    clc;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 3 \n");
    printf("========================\n");

    % =====================================================
    % INGRESO DE DATOS
    % =====================================================

    fprintf('\nIngrese los datos de la tabla.\n');

    x = input('Ingrese el vector x: ');
    y = input('Ingrese el vector y: ');

    x = x(:)';
    y = y(:)';

    % Comprobar dimensiones con size()
    [filas_x, columnas_x] = size(x);
    [filas_y, columnas_y] = size(y);

    n = columnas_x;

    if filas_x ~= 1 || filas_y ~= 1 || ...
       columnas_x ~= columnas_y || n < 2
        error('Los vectores deben tener igual cantidad de datos (minimo 2).');
    end

    if any(~isfinite(x)) || any(~isfinite(y))
        error('Los datos deben ser numericos y finitos.');
    end

    if length(unique(x)) ~= n
        error('Los valores de x no pueden repetirse.');
    end

    fprintf('\nDatos tabulares cargados:\n');
    fprintf('     x          y\n');
    disp([x', y']);

    fprintf('\nCantidad de puntos: %d\n', n);

    % =====================================================
    % INCISO A
    % =====================================================

    fprintf('\nPulsar "Enter" para resolver el inciso a...\n');
    pause;

    printf("\n-------------------------------------------------------\n");
    printf("a. INTERPOLACION DE LAGRANGE\n");
    printf("-------------------------------------------------------\n");

    x_a = input('Ingrese el valor de x para el inciso a: ');

    if ~isscalar(x_a) || ~isfinite(x_a)
        error('El valor buscado debe ser un numero finito.');
    end

    [y_a, coef_a, tiempo_a] = metodo_lagrange(x, y, x_a);

    fprintf('\nPolinomio interpolante de grado maximo %d\n', n-1);
    fprintf('P(x) = sumatoria de y(i) * L(i,x)\n');

    fprintf('\nCoeficientes de Lagrange:\n');

    for i = 1:n
        fprintf('L%d = %.8f\n', i-1, coef_a(i));
    end

    fprintf('\nValor interpolado para x = %.4f: %.8f\n', x_a, y_a);
    fprintf('Tiempo: %.8f segundos\n', tiempo_a);

    % =====================================================
    % INCISO B
    % =====================================================

    fprintf('\nPulsar "Enter" para resolver el inciso b...\n');
    pause;

    printf("\n-------------------------------------------------------\n");
    printf("b. INTERPOLACION DE LAGRANGE\n");
    printf("-------------------------------------------------------\n");

    x_b = input('Ingrese el valor de x para el inciso b: ');

    if ~isscalar(x_b) || ~isfinite(x_b)
        error('El valor buscado debe ser un numero finito.');
    end

    [y_b, coef_b, tiempo_b] = metodo_lagrange(x, y, x_b);

    fprintf('\nCoeficientes de Lagrange:\n');

    for i = 1:n
        fprintf('L%d = %.8f\n', i-1, coef_b(i));
    end

    fprintf('\nValor interpolado para x = %.4f: %.8f\n', x_b, y_b);
    fprintf('Tiempo: %.8f segundos\n', tiempo_b);

    % =====================================================
    % PRUEBA ADICIONAL
    % =====================================================

    fprintf('\nPulsar "Enter" para una prueba adicional...\n');
    pause;

    printf("\n-------------------------------------------------------\n");
    printf(" PRUEBA ADICIONAL DE INTERPOLACION\n");
    printf("-------------------------------------------------------\n");

    x_prueba = input('Ingrese otro valor de x para interpolar: ');

    if ~isscalar(x_prueba) || ~isfinite(x_prueba)
        error('El valor de prueba debe ser un numero finito.');
    end

    [y_prueba, ~, tiempo_prueba] = ...
        metodo_lagrange(x, y, x_prueba);

    fprintf('\nValor interpolado para x = %.4f: %.8f\n', ...
            x_prueba, y_prueba);

    fprintf('Tiempo: %.8f segundos\n', tiempo_prueba);

    % =====================================================
    % RESULTADOS FINALES
    % =====================================================

    printf("\n======================================================\n");
    printf("                 RESULTADOS FINALES\n");
    printf("======================================================\n");

    fprintf('INCISO A - Lagrange (x = %.4f):\n', x_a);
    fprintf('- Valor interpolado: %.8f\n', y_a);

    fprintf('\nINCISO B - Lagrange (x = %.4f):\n', x_b);
    fprintf('- Valor interpolado: %.8f\n', y_b);

    fprintf('\nPRUEBA ADICIONAL (x = %.4f):\n', x_prueba);
    fprintf('- Valor interpolado: %.8f\n', y_prueba);

    fprintf('\nTIEMPOS COMPUTACIONALES:\n');
    fprintf('- Inciso A: %.8f segundos\n', tiempo_a);
    fprintf('- Inciso B: %.8f segundos\n', tiempo_b);
    fprintf('- Prueba:   %.8f segundos\n', tiempo_prueba);

    printf("======================================================\n");

    fprintf('\nCONCLUSION:\n');
    fprintf('Se aplico el metodo de Lagrange para estimar\n');
    fprintf('valores de la funcion a partir de datos tabulados.\n');
    fprintf('El algoritmo permite ingresar los datos por teclado\n');
    fprintf('y evaluar diferentes valores de x.\n');
    fprintf('El polinomio es de grado maximo %d.\n', n-1);
    fprintf('Sin un valor exacto de referencia no es posible\n');
    fprintf('determinar el error verdadero de interpolacion.\n');

end


% =========================================================
% FUNCION AUXILIAR - METODO DE LAGRANGE
% =========================================================

function [y_interp, coeficientes, tiempo] = ...
    metodo_lagrange(x, y, x_buscado)

    tic;

    n = length(x);

    y_interp = 0;
    coeficientes = zeros(1, n);

    for i = 1:n

        L_i = 1;

        for j = 1:n

            if i ~= j
                L_i = L_i * ...
                    (x_buscado - x(j)) / (x(i) - x(j));
            end

        end

        coeficientes(i) = L_i;

        y_interp = y_interp + y(i) * L_i;

    end

    tiempo = toc;

end
