
function punto4()

    clc;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 4 \n");
    printf("========================\n");

    % Ingreso de datos por teclado
    fprintf('\nIngrese los datos de la tabla.\n');

    x = input('Ingrese el vector x: ');
    y = input('Ingrese el vector f(x): ');

    x = x(:)';
    y = y(:)';

    n = length(x) - 1;

    % Validaciones
    if n ~= 5 || length(y) ~= length(x)
        error('Este ejercicio requiere 6 puntos y 5 subintervalos.');
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

    fprintf('\nPulsar "Enter" para aplicar Simpson...\n');
    pause;

    % =====================================================
    % SIMPSON 1/3
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf(" SIMPSON 1/3 - PRIMEROS DOS SUBINTERVALOS\n");
    printf("-------------------------------------------------------\n");

    tic;

    I_13 = (h / 3) * ...
        (y(1) + 4*y(2) + y(3));

    fprintf('Integral Simpson 1/3: %.8f\n', I_13);

    % =====================================================
    % SIMPSON 3/8
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf(" SIMPSON 3/8 - ULTIMOS TRES SUBINTERVALOS\n");
    printf("-------------------------------------------------------\n");

    I_38 = (3*h / 8) * ...
        (y(3) + 3*y(4) + 3*y(5) + y(6));

    fprintf('Integral Simpson 3/8: %.8f\n', I_38);

    I_total = I_13 + I_38;

    tiempo_simpson = toc;

    % =====================================================
    % COMPARACION CON TRAPECIOS
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf(" COMPARACION ENTRE METODOS\n");
    printf("-------------------------------------------------------\n");

    [I_trap, tiempo_trap] = metodo_trapecios(x, y);

    diferencia_abs = abs(I_total - I_trap);

    if I_total ~= 0
        diferencia_rel = ...
            (diferencia_abs / abs(I_total)) * 100;
    else
        diferencia_rel = NaN;
    end

    fprintf('\nTrapecios multiples: %.8f\n', I_trap);
    fprintf('Simpson combinado: %.8f\n', I_total);

    fprintf('\nDiferencia absoluta: %.8f\n', diferencia_abs);
    fprintf('Diferencia relativa: %.6f %%\n', diferencia_rel);

    % =====================================================
    % RESULTADOS FINALES
    % =====================================================

    printf("\n======================================================\n");
    printf("                 RESULTADOS FINALES                   \n");
    printf("======================================================\n");

    fprintf('SIMPSON 1/3: %.8f\n', I_13);
    fprintf('SIMPSON 3/8: %.8f\n', I_38);
    fprintf('INTEGRAL COMBINADA: %.8f\n', I_total);

    fprintf('\nTRAPECIOS: %.8f\n', I_trap);
    fprintf('DIFERENCIA ABSOLUTA: %.8f\n', diferencia_abs);
    fprintf('DIFERENCIA RELATIVA: %.6f %%\n', diferencia_rel);

    fprintf('\nTIEMPOS COMPUTACIONALES:\n');
    fprintf('Simpson combinado: %.8f segundos\n', tiempo_simpson);
    fprintf('Trapecios: %.8f segundos\n', tiempo_trap);

    printf("======================================================\n");

    fprintf('\nCONCLUSION:\n');
    fprintf('Se aplico la combinacion de Simpson 1/3 y 3/8\n');
    fprintf('para aproximar la integral definida.\n');
    fprintf('Se comparo el resultado con trapecios multiples.\n');
    fprintf('Ambos metodos proporcionaron valores cercanos.\n');
    fprintf('La diferencia no representa el error verdadero,\n');
    fprintf('ya que no se conoce el valor exacto de la integral.\n');

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
        (y(1) + 2*suma + y(n+1));

    tiempo = toc;

end
