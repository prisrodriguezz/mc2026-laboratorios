function punto3()

    clc;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 3 \n");
    printf("========================\n");

    % =====================================================
    % DATOS PRE-CARGADOS (Ejercicio 1 y 3 de la Guía)
    % =====================================================
    f_str = 'x^2 + y^2';           % Ecuación diferencial y' = x^2 + y^2[cite: 2, 3]
    x0    = 0;                     % Valor inicial x0[cite: 2, 3]
    xf    = 0.6;                   % Valor final xf[cite: 2, 3]
    y0    = 1;                     % Condición inicial y(0) = 1[cite: 2, 3]
    h     = 0.2;                   % Tamaño de paso h[cite: 2, 3]
    tol   = 0.001;                 % Tolerancia de referencia del inciso 1.b[cite: 2, 3]

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

    n_exacto = (xf - x0) / h;
    n = round(n_exacto);

    if abs(n_exacto - n) > 1e-8
        error('El intervalo [x0, xf] debe ser un multiplo exacto del paso h.');
    end

    % Definicion de la funcion anonima f(x,y)
    f = str2func(['@(x,y) ' f_str]);

    fprintf('\nParametros cargados (Pre-cargados):\n');
    fprintf('Ecuacion diferencial: y'' = %s\n', f_str);
    fprintf('Condicion inicial: y(%.4f) = %.4f\n', x0, y0);
    fprintf('Intervalo: [%.4f ; %.4f]\n', x0, xf);
    fprintf('Cantidad de subintervalos (pasos): %d\n', n);
    fprintf('Paso h: %.4f\n', h);

    fprintf('\nPulsar "Enter" para aplicar Runge-Kutta de 2do Orden (Inciso 3.a)...\n');
    pause;

    % =====================================================
    % INCISO 3.a - METODO DE RUNGE-KUTTA DE 2DO ORDEN (RK2)
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf(" INCISO 3.a - RUNGE-KUTTA DE 2DO ORDEN (METODO DE HEUN)\n");
    printf("-------------------------------------------------------\n");

    [x_rk2, y_rk2, tiempo_rk2] = metodo_rk2(f, x0, y0, h, n);

    fprintf('\nTabla de resultados - Runge-Kutta 2do Orden:\n');
    fprintf('    Paso         x_i          y_i (RK2)\n');
    for i = 1:(n+1)
        fprintf('     %2d       %8.4f      %10.6f\n', i-1, x_rk2(i), y_rk2(i));
    end

    fprintf('\nPulsar "Enter" para aplicar Runge-Kutta de 4to Orden (Inciso 3.b)...\n');
    pause;

    % =====================================================
    % INCISO 3.b - METODO DE RUNGE-KUTTA DE 4TO ORDEN (RK4)
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf(" INCISO 3.b - RUNGE-KUTTA DE 4TO ORDEN (CLASICO)\n");
    printf("-------------------------------------------------------\n");

    [x_rk4, y_rk4, tiempo_rk4] = metodo_rk4(f, x0, y0, h, n);

    fprintf('\nTabla de resultados - Runge-Kutta 4to Orden:\n');
    fprintf('    Paso         x_i          y_i (RK4)\n');
    for i = 1:(n+1)
        fprintf('     %2d       %8.4f      %10.6f\n', i-1, x_rk4(i), y_rk4(i));
    end

    fprintf('\nPulsar "Enter" para comparar 3.a (RK2) vs 1.b (Euler Modificado)...\n');
    pause;

    % =====================================================
    % INCISO 3.c - COMPARACION ENTRE 3.a (RK2) Y 1.b (EULER MOD.)
    % =====================================================

    printf("\n-------------------------------------------------------\n");
    printf(" COMPARACION: RK2 (3.a) vs EULER MODIFICADO (1.b)\n");
    printf("-------------------------------------------------------\n");

    % Se calcula Euler Modificado del punto 1.b para contrastar directamente
    [~, y_mod, ~] = metodo_euler_modificado(f, x0, y0, h, n, tol);

    dif_abs_1b = abs(y_mod(end) - y_rk2(end));
    dif_rel_1b = (dif_abs_1b / abs(y_mod(end))) * 100;

    % Error estimado tomando RK4 como solucion de referencia de alta precision
    err_rk2_ref = abs(y_rk4(end) - y_rk2(end));
    err_mod_ref = abs(y_rk4(end) - y_mod(end));

    fprintf('\nValor final en x = %.4f (RK2 - Inciso 3.a):          %.8f\n', xf, y_rk2(end));
    fprintf('Valor final en x = %.4f (Euler Mod. - Inciso 1.b):   %.8f\n', xf, y_mod(end));
    fprintf('Valor final en x = %.4f (RK4 - Inciso 3.b):          %.8f\n', xf, y_rk4(end));

    fprintf('\nDiferencia absoluta entre RK2 (3.a) y Euler Mod (1.b): %.8f\n', dif_abs_1b);
    fprintf('Diferencia relativa entre RK2 (3.a) y Euler Mod (1.b): %.6f %%\n', dif_rel_1b);

    % =====================================================
    % RESULTADOS FINALES
    % =====================================================

    printf("\n===========================================================================\n");
    printf("                          RESULTADOS FINALES                               \n");
    printf("===========================================================================\n");

    fprintf('     x        Euler Mod (1.b)     RK2 (3.a)       RK4 (3.b)     Dif |1.b - 3.a|\n');
    for i = 1:(n+1)
        fprintf(' %8.4f      %11.6f      %11.6f     %11.6f       %10.6f\n', ...
            x_rk2(i), y_mod(i), y_rk2(i), y_rk4(i), abs(y_mod(i) - y_rk2(i)));
    end

    fprintf('\nERRORES ESTIMADOS EN x = %.2f (tomando RK4 como referencia):\n', xf);
    fprintf('Error estimado RK2 (3.a):           %.8f (%.4f %%)\n', ...
        err_rk2_ref, (err_rk2_ref / abs(y_rk4(end))) * 100);
    fprintf('Error estimado Euler Mod (1.b):     %.8f (%.4f %%)\n', ...
        err_mod_ref, (err_mod_ref / abs(y_rk4(end))) * 100);

    fprintf('\nTIEMPOS COMPUTACIONALES:\n');
    fprintf('Runge-Kutta 2do Orden (RK2): %.8f segundos\n', tiempo_rk2);
    fprintf('Runge-Kutta 4to Orden (RK4): %.8f segundos\n', tiempo_rk4);

end


% =========================================================
% FUNCION AUXILIAR 1 - RUNGE-KUTTA DE 2DO ORDEN (HEUN)
% =========================================================

function [x, y, tiempo] = metodo_rk2(f, x0, y0, h, n)

    tic;

    x = zeros(1, n + 1);
    y = zeros(1, n + 1);

    x(1) = x0;
    y(1) = y0;

    for i = 1:n
        k1 = f(x(i), y(i));
        k2 = f(x(i) + h, y(i) + h * k1);

        x(i+1) = x(i) + h;
        y(i+1) = y(i) + (h / 2) * (k1 + k2);
    end

    tiempo = toc;

end


% =========================================================
% FUNCION AUXILIAR 2 - RUNGE-KUTTA DE 4TO ORDEN (CLASICO)
% =========================================================

function [x, y, tiempo] = metodo_rk4(f, x0, y0, h, n)

    tic;

    x = zeros(1, n + 1);
    y = zeros(1, n + 1);

    x(1) = x0;
    y(1) = y0;

    for i = 1:n
        k1 = f(x(i), y(i));
        k2 = f(x(i) + h/2, y(i) + (h/2) * k1);
        k3 = f(x(i) + h/2, y(i) + (h/2) * k2);
        k4 = f(x(i) + h, y(i) + h * k3);

        x(i+1) = x(i) + h;
        y(i+1) = y(i) + (h / 6) * (k1 + 2*k2 + 2*k3 + k4);
    end

    tiempo = toc;

end


% =========================================================
% FUNCION AUXILIAR 3 - EULER MODIFICADO (REFERENCIA 1.b)
% =========================================================

function [x, y, tiempo] = metodo_euler_modificado(f, x0, y0, h, n, tol)

    tic;

    x = zeros(1, n + 1);
    y = zeros(1, n + 1);

    x(1) = x0;
    y(1) = y0;

    for i = 1:n
        x(i+1) = x(i) + h;
        y_ant = y(i) + h * f(x(i), y(i));

        error_est = tol + 1;
        while error_est >= tol
            y_nuevo = y(i) + (h / 2) * (f(x(i), y(i)) + f(x(i+1), y_ant));
            error_est = abs(y_nuevo - y_ant);
            y_ant = y_nuevo;
        end

        y(i+1) = y_nuevo;
    end

    tiempo = toc;

end