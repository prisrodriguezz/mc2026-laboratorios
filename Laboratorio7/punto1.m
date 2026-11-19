function punto1()

    clc;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 1 \n");
    printf("========================\n");

    % =====================================================
    % DATOS PRE-CARGADOS (Ejercicio 1 de la Guía)
    % =====================================================
    f_str = 'x^2 + y^2';           % Ecuación diferencial y' = x^2 + y^2[cite: 2]
    x0    = 0;                     % Valor inicial x0[cite: 2]
    xf    = 0.6;                   % Valor final xf[cite: 2]
    y0    = 1;                     % Condición inicial y(0) = 1[cite: 2]
    h     = 0.2;                   % Tamaño de paso h[cite: 2]
    tol   = 0.001;                 % Tolerancia E para Euler Modificado[cite: 2]

    % Validaciones
    if isempty(strtrim(f_str))
        error('Debe ingresar una expresion valida para f(x,y).');
    end

    if any(~isfinite([x0, xf, y0, h, tol]))
        error('Los datos numericos deben ser reales y finitos.');
    end

    if h <= 0 || xf <= x0
        error('El paso h debe ser positivo y xf debe ser mayor que x0.');
    end

    if tol <= 0
        error('La tolerancia E debe ser estrictamente positiva.');
    end

    n_exacto = (xf - x0) / h;
    n = round(n_exacto);

    if abs(n_exacto - n) > 1e-8
        error('El intervalo [x0, xf] debe ser un multiplo exacto del paso h.');
    end

    % Definicion de la funcion anonima f(x,y)
    f = str2func(['@(x,y) ' f_str]);

    % Prueba rapida de evaluacion
    try
        f_test = f(x0, y0);
        if ~isfinite(f_test)
            error('La funcion evaluada en (x0, y0) no es finita.');
        end
    catch
        error('Error de sintaxis en la funcion f(x,y). Use operadores escalares como x^2 + y^2.');
    end

    fprintf('\nParametros cargados (Pre-cargados):\n');
    fprintf('Ecuacion diferencial: y'' = %s\n', f_str);
    fprintf('Condicion inicial: y(%.4f) = %.4f\n', x0, y0);
    fprintf('Intervalo: [%.4f ; %.4f]\n', x0, xf);
    fprintf('Cantidad de subintervalos (pasos): %d\n', n);
    fprintf('Paso h: %.4f\n', h);
    fprintf('Tolerancia E (Euler Modificado): %.6f\n', tol);

    fprintf('\nPulsar "Enter" para aplicar Metodo de Euler (Inciso 1.a)...\n');
    pause;

    % =====================================================
    % INCISO 1.a - METODO DE EULER
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf(" INCISO 1.a - METODO DE EULER SIMPLE\n");
    printf("-------------------------------------------------------\n");

    [x_eu, y_eu, tiempo_euler] = metodo_euler(f, x0, y0, h, n);

    fprintf('\nTabla de resultados - Euler Simple:\n');
    fprintf('    Paso         x_i            y_i\n');
    for i = 1:(n+1)
        fprintf('     %2d       %8.4f      %10.6f\n', i-1, x_eu(i), y_eu(i));
    end

    fprintf('\nPulsar "Enter" para aplicar Metodo Modificado de Euler (Inciso 1.b)...\n');
    pause;

    % =====================================================
    % INCISO 1.b - METODO MODIFICADO DE EULER
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf(" INCISO 1.b - METODO MODIFICADO DE EULER (E < %.4f)\n", tol);
    printf("-------------------------------------------------------\n");

    [x_mod, y_mod, iter_corr, tiempo_mod] = metodo_euler_modificado(f, x0, y0, h, n, tol);

    fprintf('\nTabla de resultados - Euler Modificado:\n');
    fprintf('    Paso         x_i            y_i        Iter. Corrector\n');
    for i = 1:(n+1)
        fprintf('     %2d       %8.4f      %10.6f           %2d\n', ...
            i-1, x_mod(i), y_mod(i), iter_corr(i));
    end

    % =====================================================
    % COMPARACION ENTRE METODOS
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf(" COMPARACION ENTRE METODOS\n");
    printf("-------------------------------------------------------\n");

    diferencia_abs = abs(y_mod(end) - y_eu(end));

    if y_mod(end) ~= 0
        diferencia_rel = (diferencia_abs / abs(y_mod(end))) * 100;
    else
        diferencia_rel = NaN;
    end

    fprintf('\nValor final en x = %.4f (Euler Simple):     %.8f\n', xf, y_eu(end));
    fprintf('Valor final en x = %.4f (Euler Modificado): %.8f\n', xf, y_mod(end));

    fprintf('\nDiferencia absoluta final: %.8f\n', diferencia_abs);
    fprintf('Diferencia relativa final: %.6f %%\n', diferencia_rel);

    % =====================================================
    % RESULTADOS FINALES
    % =====================================================

    printf("\n======================================================\n");
    printf("                 RESULTADOS FINALES                   \n");
    printf("======================================================\n");

    fprintf('     x          Euler Simple      Euler Modificado      Dif. Abs.\n');
    for i = 1:(n+1)
        fprintf(' %8.4f       %12.6f        %12.6f       %10.6f\n', ...
            x_eu(i), y_eu(i), y_mod(i), abs(y_mod(i) - y_eu(i)));
    end

    fprintf('\nTIEMPOS COMPUTACIONALES:\n');
    fprintf('Metodo de Euler: %.8f segundos\n', tiempo_euler);
    fprintf('Metodo Modificado de Euler: %.8f segundos\n', tiempo_mod);

end


% =========================================================
% FUNCION AUXILIAR 1 - METODO DE EULER
% =========================================================

function [x, y, tiempo] = metodo_euler(f, x0, y0, h, n)

    tic;

    x = zeros(1, n + 1);
    y = zeros(1, n + 1);

    x(1) = x0;
    y(1) = y0;

    for i = 1:n
        x(i+1) = x(i) + h;
        y(i+1) = y(i) + h * f(x(i), y(i));
    end

    tiempo = toc;

end


% =========================================================
% FUNCION AUXILIAR 2 - METODO MODIFICADO DE EULER
% =========================================================

function [x, y, iteraciones, tiempo] = metodo_euler_modificado(f, x0, y0, h, n, tol)

    tic;

    x = zeros(1, n + 1);
    y = zeros(1, n + 1);
    iteraciones = zeros(1, n + 1);

    x(1) = x0;
    y(1) = y0;

    for i = 1:n
        x(i+1) = x(i) + h;

        % Predictor (Euler)
        y_ant = y(i) + h * f(x(i), y(i));

        % Corrector iterativo
        iter = 0;
        error_est = tol + 1;

        while error_est >= tol
            iter = iter + 1;
            y_nuevo = y(i) + (h / 2) * (f(x(i), y(i)) + f(x(i+1), y_ant));
            error_est = abs(y_nuevo - y_ant);
            y_ant = y_nuevo;
        end

        y(i+1) = y_nuevo;
        iteraciones(i+1) = iter;
    end

    tiempo = toc;

end