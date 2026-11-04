function ejercicio2()

    clc;
    clear;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 2 \n");
    printf("========================\n");

    % Definicion de vectores de datos (x: Año, y: Población en miles)
    x = [1940, 1950, 1960, 1970, 1980, 1990];
    y = [132.165, 151.326, 179.323, 203.302, 226.542, 249.633];
    
    x_buscado = 1965;
    valor_real = 189.703; % Dato de población real provisto por la guía

    fprintf('Datos censales cargados:\n');
    fprintf('Año (x) | Poblacion en miles (y)\n');
    disp([x', y']);
    
    fprintf('Pulsar "Enter" para aplicar el Metodo de Lagrange para x = %d...\n', x_buscado);
    pause;

    printf("\n\n-------------------------------------------------------\n");
    printf("a. INTERPOLACION MEDIANTE POLINOMIO DE LAGRANGE\n");
    printf("-------------------------------------------------------\n");
    
    % Llamada a la funcion para calcular la interpolacion de Lagrange
    [y_interp, tiempo_lagrange] = metodo_lagrange(x, y, x_buscado);
    
    fprintf('\n---> Calculo de coeficientes Lagrangiano completado.\n');
    
    fprintf('Pulsar "Enter" para ver el analisis de exactitud...\n');
    pause;
    
    printf("\n\n-------------------------------------------------------\n");
    printf("b. ANALISIS DE EXACTITUD\n");
    printf("-------------------------------------------------------\n");

    % Calculo de errores respecto al valor real de 1965
    error_abs = abs(valor_real - y_interp);
    error_rel = (error_abs / valor_real) * 100;

    fprintf('\n======================================================\n');
    fprintf('                 RESULTADOS FINALES                   \n');
    fprintf('======================================================\n');
    
    fprintf('VALOR ESTIMADO (Poblacion en %d):\n', x_buscado);
    fprintf('- Interpolacion (y): %10.5f miles de hab.\n', y_interp);
    fprintf('- Valor real:        %10.5f miles de hab.\n\n', valor_real);
    
    fprintf('ANALISIS:\n');
    fprintf('- Error Absoluto:       %f miles de hab.\n', error_abs);
    fprintf('- Error Relativo:       %f %%\n', error_rel);
    fprintf('- Tiempo computacional: %f segundos\n', tiempo_lagrange);
    fprintf('======================================================\n');

    fprintf('\nCONCLUSION:\n');
    fprintf('Al comparar el valor interpolado con la cifra real de 189.703 miles de\n');
    fprintf('habitantes, se observa un error relativo extremadamente bajo. Esto\n');
    fprintf('demuestra que el polinomio de Lagrange ofrece una alta exactitud para\n');
    fprintf('interpolar datos demograficos dentro de este rango de valores.\n');

end


% =========================================================
% FUNCIONES
% =========================================================

% Funcion para calcular interpolacion por el Metodo de Lagrange
function [y_interp, tiempo] = metodo_lagrange(x, y, x_buscado)
    tic; % Iniciar medicion de tiempo

    n = length(x);
    y_interp = 0;
    
    for i = 1:n
        L_i = 1; % Inicializacion del coeficiente Lagrangiano
        for j = 1:n
            if i ~= j
                % Productoria para el calculo de L_i
                L_i = L_i * (x_buscado - x(j)) / (x(i) - x(j));
            end
        end
        % Sumatoria final del polinomio
        y_interp = y_interp + y(i) * L_i;
    end

    tiempo = toc; % Detener medicion de tiempo
end