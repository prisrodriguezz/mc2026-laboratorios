function punto2_integracion()

    clc;
    clear;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 2 \n");
    printf("========================\n");

    % Definicion de los datos de la tabla
    t = [0, 0.1, 0.2, 0.3, 0.4, 0.5];
    y = [0.0, 0.15, 0.3, 0.55, 0.73, 0.81];
    
    n = length(t) - 1; % Numero de subintervalos
    h = t(2) - t(1);   % Paso

    fprintf('Se han cargado los datos de la tabla (t, i).\n');
    fprintf('Intervalos detectados: %d\n', n);
    fprintf('Paso (h): %.1f\n', h);
    fprintf('Pulsar "Enter" para calcular la integral...\n');
    pause;
    
    tic; % Iniciar medicion de tiempo

    % ======================================================
    % 1) CALCULO CON REGLA DE LOS TRAPECIOS (COMO REFERENCIA)
    % ======================================================
    printf("\n-------------------------------------------------------\n");
    printf("1) APROXIMACION CON REGLA DE TRAPECIOS MULTIPLE\n");
    printf("-------------------------------------------------------\n");
    
    % Formula: h/2 * (y0 + 2*sum(yi) + yn)
    suma_intermedia = sum(y(2:end-1));
    I_trap = (h / 2) * (y(1) + 2 * suma_intermedia + y(end));
    
    fprintf("Integral (Trapecios) = %.6f\n", I_trap);

    % ======================================================
    % 2) CALCULO COMBINANDO SIMPSON 1/3 Y SIMPSON 3/8 (OPTIMO)
    % ======================================================
    printf("\n-------------------------------------------------------\n");
    printf("2) METODO COMBINADO: SIMPSON 1/3 + SIMPSON 3/8\n");
    printf("-------------------------------------------------------\n");
    
    % Tramo 1: Simpson 1/3 para los primeros 2 subintervalos (indices 1 al 3)
    % Formula: (h/3) * (y0 + 4y1 + y2)
    I_simp_13 = (h / 3) * (y(1) + 4 * y(2) + y(3));
    fprintf("-> Sub-integral Simpson 1/3 (t=0 a t=0.2): %.6f\n", I_simp_13);
    
    % Tramo 2: Simpson 3/8 para los 3 subintervalos restantes (indices 3 al 6)
    % Formula: (3h/8) * (y2 + 3y3 + 3y4 + y5)
    I_simp_38 = (3 * h / 8) * (y(3) + 3 * y(4) + 3 * y(5) + y(6));
    fprintf("-> Sub-integral Simpson 3/8 (t=0.2 a t=0.5): %.6f\n", I_simp_38);
    
    % Integral Total
    I_total = I_simp_13 + I_simp_38;
    fprintf("Integral Total Combinada = %.6f\n", I_total);
    
    tiempo_exec = toc;

    fprintf('\n========================================\n');
    fprintf('                 RESULTADOS               \n');
    fprintf('==========================================\n');
    fprintf('- Valor final de la integral: %.6f\n', I_total);
    fprintf('- Tiempo de ejecucion: %f segundos\n', tiempo_exec);
    fprintf('==========================================\n');

end