
function punto3()

    clc;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 3 \n");
    printf("========================\n");

    % Ingreso de datos por teclado
    fprintf('\nIngrese los datos de la tabla.\n');

    x = input('Ingrese el vector x: ');
    y = input('Ingrese el vector f(x): ');

    % Validacion de datos
    x = x(:)';
    y = y(:)';

    n = length(x) - 1;

    if n < 1 || length(y) ~= length(x)
        error('Los vectores deben tener igual longitud y al menos dos puntos.');
    end

    if any(~isfinite(x)) || any(~isfinite(y))
        error('Los datos deben ser numericos y finitos.');
    end

    h = x(2) - x(1);

    if h <= 0 || any(abs(diff(x) - h) > 1e-8 * max(1, abs(h)))
        error('Los valores de x deben ser crecientes y equidistantes.');
    end

    fprintf('\nDatos tabulares cargados:\n');
    fprintf('      x          f(x)\n');
    disp([x', y']);

    fprintf('\nCantidad de subintervalos: %d\n', n);
    fprintf('Paso h: %.4f\n', h);

    fprintf('\nPulsar "Enter" para aplicar Trapecios...\n');
    pause;

    % =====================================================
    % INTEGRACION MEDIANTE TRAPECIOS MULTIPLES
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf(" INTEGRACION MEDIANTE TRAPECIOS MULTIPLES\n");
    printf("-------------------------------------------------------\n");

    [integral, tiempo] = metodo_trapecios(x, y);

    fprintf('\nIntervalo de integracion: [%.2f, %.2f]\n', ...
            x(1), x(end));

    fprintf('Integral aproximada: %.8f\n', integral);
    fprintf('Tiempo de ejecucion: %.8f segundos\n', tiempo);

    printf("\n======================================================\n");
    printf("                 RESULTADOS FINALES                   \n");
    printf("======================================================\n");

    fprintf('Metodo utilizado: Trapecios multiples\n');
    fprintf('Cantidad de subintervalos: %d\n', n);
    fprintf('Valor aproximado: %.8f\n', integral);
    fprintf('Tiempo computacional: %.8f segundos\n', tiempo);

    printf("======================================================\n");

    fprintf('\nCONCLUSION:\n');
    fprintf('Se aplico la regla de trapecios multiples para\n');
    fprintf('aproximar la integral definida en el intervalo dado.\n');
    fprintf('El metodo permite trabajar con %d subintervalos\n', n);
    fprintf('de igual amplitud.\n');

end


% =========================================================
% FUNCION AUXILIAR - TRAPECIOS MULTIPLES
% =========================================================

function [integral, tiempo] = metodo_trapecios(x, y)

    tic;

    n = length(x) - 1;
    h = x(2) - x(1);

    suma = 0;

    for i = 2:n
        suma = suma + y(i);
    end

    integral = (h / 2) * ...
        (y(1) + 2 * suma + y(n+1));

    tiempo = toc;

end
