function punto2()

    clc;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 2 \n");
    printf("========================\n");

    % =====================================================
    % DATOS PRE-CARGADOS (Ejercicio 2 de la Guía)
    % =====================================================
    gamma = 3;          % Tasa de nacimiento
    tau   = 0.1;        % Tasa de mortalidad
    t0    = 0;          % Tiempo inicial
    tf    = 2;          % Tiempo final
    P0    = 5;          % Población inicial P(0) = 5
    h1    = 0.5;        % Primer tamaño de paso
    h2    = 0.25;       % Segundo tamaño de paso

    % Validaciones
    if any(~isfinite([gamma, tau, t0, tf, P0, h1, h2]))
        error('Todos los parametros deben ser numericos y finitos.');
    end

    if h1 <= 0 || h2 <= 0 || tf <= t0
        error('Los pasos h1, h2 deben ser positivos y tf mayor que t0.');
    end

    n1_exacto = (tf - t0) / h1;
    n2_exacto = (tf - t0) / h2;
    n1 = round(n1_exacto);
    n2 = round(n2_exacto);

    if abs(n1_exacto - n1) > 1e-8 || abs(n2_exacto - n2) > 1e-8
        error('El intervalo [t0, tf] debe ser multiplo exacto de ambos pasos h.');
    end

    % Definicion de la EDO P'(t) y de la solucion exacta P(t)
    f_edo   = @(t, P) gamma * P - tau * (P ^ 2);
    P_exact = @(t) gamma ./ (tau + ((gamma / P0) - tau) .* exp(-gamma .* t));

    fprintf('\nParametros cargados (Pre-cargados):\n');
    fprintf('Ecuacion diferencial: P''(t) = %.2f*P(t) - %.2f*P(t)^2\n', gamma, tau);
    fprintf('Condicion inicial: P(%.2f) = %.2f\n', t0, P0);
    fprintf('Intervalo: [%.2f ; %.2f]\n', t0, tf);
    fprintf('Paso h1 = %.2f (%d subintervalos) | Paso h2 = %.2f (%d subintervalos)\n', ...
        h1, n1, h2, n2);

    fprintf('\nPulsar "Enter" para aplicar Metodo de Euler con h = %.2f y h = %.2f (Inciso 2.a)...\n', h1, h2);
    pause;

    % =====================================================
    % INCISO 2.a - METODO DE EULER (h = 0.5 y h = 0.25)
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf(" INCISO 2.a - METODO DE EULER (h1 = %.2f vs h2 = %.2f)\n", h1, h2);
    printf("-------------------------------------------------------\n");

    [t1, P_eu1, tiempo_h1] = metodo_euler(f_edo, t0, P0, h1, n1);
    [t2, P_eu2, tiempo_h2] = metodo_euler(f_edo, t0, P0, h2, n2);

    fprintf('\nTabla de resultados - Euler con h = %.2f:\n', h1);
    fprintf('    Paso         t_i           P_i (h=0.5)\n');
    for i = 1:(n1+1)
        fprintf('     %2d       %8.4f        %10.6f\n', i-1, t1(i), P_eu1(i));
    end

    fprintf('\nTabla de resultados - Euler con h = %.2f:\n', h2);
    fprintf('    Paso         t_i           P_i (h=0.25)\n');
    for i = 1:(n2+1)
        fprintf('     %2d       %8.4f        %10.6f\n', i-1, t2(i), P_eu2(i));
    end

    fprintf('\nPulsar "Enter" para comparar contra la Solucion Exacta (Inciso 2.b)...\n');
    pause;

    % =====================================================
    % INCISO 2.b - COMPARACION CON SOLUCION EXACTA
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf(" INCISO 2.b - COMPARACION CON LA SOLUCION EXACTA\n");
    printf("-------------------------------------------------------\n");

    tic;
    P_ex2 = P_exact(t2);
    tiempo_exacta = toc;

    err_abs_h2 = abs(P_ex2 - P_eu2);
    err_rel_h2 = (err_abs_h2 ./ abs(P_ex2)) * 100;

    fprintf('\nComparacion detallada en malla fina (h = %.2f):\n', h2);
    fprintf('     t         Exacta P(t)     Euler (h=0.25)     Error Abs.     Error Rel. (%%)\n');
    for i = 1:(n2+1)
        fprintf(' %8.4f     %11.6f       %11.6f       %10.6f       %9.4f %%\n', ...
            t2(i), P_ex2(i), P_eu2(i), err_abs_h2(i), err_rel_h2(i));
    end

    % =====================================================
    % RESULTADOS FINALES (NODOS COMUNES)
    % =====================================================

    printf("\n===========================================================================\n");
    printf("                RESULTADOS FINALES EN NODOS COMUNES (dt = 0.5)             \n");
    printf("===========================================================================\n");

    fprintf('     t         Exacta P(t)    Euler (h=0.5)   Err.Rel(0.5)   Euler (h=0.25)  Err.Rel(0.25)\n');
    for i = 1:(n1+1)
        idx_fino = 2*i - 1; % Indice equivalente en la malla de h = 0.25
        er1 = (abs(P_ex2(idx_fino) - P_eu1(i)) / abs(P_ex2(idx_fino))) * 100;
        er2 = err_rel_h2(idx_fino);
        fprintf(' %8.4f     %11.6f     %11.6f      %8.4f %%     %11.6f      %8.4f %%\n', ...
            t1(i), P_ex2(idx_fino), P_eu1(i), er1, P_eu2(idx_fino), er2);
    end

    fprintf('\nTIEMPOS COMPUTACIONALES:\n');
    fprintf('Metodo de Euler (h = 0.50):  %.8f segundos\n', tiempo_h1);
    fprintf('Metodo de Euler (h = 0.25):  %.8f segundos\n', tiempo_h2);
    fprintf('Evaluacion Solucion Exacta:  %.8f segundos\n', tiempo_exacta);

end


% =========================================================
% FUNCION AUXILIAR - METODO DE EULER
% =========================================================

function [t, P, tiempo] = metodo_euler(f, t0, P0, h, n)

    tic;

    t = zeros(1, n + 1);
    P = zeros(1, n + 1);

    t(1) = t0;
    P(1) = P0;

    for i = 1:n
        t(i+1) = t(i) + h;
        P(i+1) = P(i) + h * f(t(i), P(i));
    end

    tiempo = toc;

end