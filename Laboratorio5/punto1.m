function ejercicio1()

    clc;
    clear;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 1 \n");
    printf("========================\n");

    % Definicion de vectores de datos (x e y)
    x = [15, 25, 35, 45, 55, 65];
    y = [0.965926, 0.906308, 0.819152, 0.707107, 0.573576, 0.422618];

    fprintf('Datos tabulares cargados:\n');
    disp([x', y']);
    
    fprintf('Pulsar "Enter" para aplicar Newton-Gregory Ascendente (x = 17)...\n');
    pause;

    printf("\n\n-------------------------------------------------------\n");
    printf("a. NEWTON-GREGORY ASCENDENTE\n");
    printf("-------------------------------------------------------\n");
    
    x_asc = 17;
    [y_asc, D_asc, tiempo_asc] = newton_gregory_ascendente(x, y, x_asc);
    
    fprintf('\n---> Tabla de Diferencias Avanzadas:\n');
    disp(D_asc);
    
    fprintf('Pulsar "Enter" para aplicar Newton-Gregory Descendente (x = 60)...\n');
    pause;
    
    printf("\n\n-------------------------------------------------------\n");
    printf("b. NEWTON-GREGORY DESCENDENTE\n");
    printf("-------------------------------------------------------\n");

    x_desc = 60;
    [y_desc, D_desc, tiempo_desc] = newton_gregory_descendente(x, y, x_desc);
    
    fprintf('\n---> Tabla de Diferencias Atrasadas (Diagonal inferior):\n');
    disp(D_desc);

    fprintf('Pulsar "Enter" para aplicar Interpolacion Inversa (y = 0.90728517)...\n');
    pause;

    printf("\n\n-------------------------------------------------------\n");
    printf("c. INTERPOLACION INVERSA (LINEAL Y CUADRATICA)\n");
    printf("-------------------------------------------------------\n");

    y_inv = 0.90728517;
    [x_lin, tiempo_lin] = interpolacion_inversa_lineal(x, y, y_inv);
    [x_cuad, tiempo_cuad] = interpolacion_inversa_cuadratica(x, y, y_inv);

    fprintf('\n======================================================\n');
    fprintf('                 RESULTADOS FINALES                   \n');
    fprintf('======================================================\n');
    
    fprintf('INCISO A - N-G Ascendente (x = %d):\n', x_asc);
    fprintf('- Valor interpolado (y): %10.6f\n\n', y_asc);
    
    fprintf('INCISO B - N-G Descendente (x = %d):\n', x_desc);
    fprintf('- Valor interpolado (y): %10.6f\n\n', y_desc);

    fprintf('INCISO C - Interpolacion Inversa (y = %.8f):\n', y_inv);
    fprintf('- x (Lineal):     %10.6f\n', x_lin);
    fprintf('- x (Cuadratica): %10.6f\n\n', x_cuad);
    
    fprintf('ANALISIS (Tiempos computacionales):\n');
    fprintf('- Tiempo N-G Ascendente: %f segundos\n', tiempo_asc);
    fprintf('- Tiempo N-G Descendente:%f segundos\n', tiempo_desc);
    fprintf('- Tiempo Inversa Lineal: %f segundos\n', tiempo_lin);
    fprintf('- Tiempo Inversa Cuad:   %f segundos\n', tiempo_cuad);
    fprintf('======================================================\n');

end


% =========================================================
% FUNCIONES
% =========================================================

% Funcion para Newton-Gregory Ascendente
function [y_interp, D, tiempo] = newton_gregory_ascendente(x, y, x_buscado)
    tic; 

    n = length(x);
    h = x(2) - x(1);
    
    % Generar tabla de diferencias
    D = zeros(n, n);
    D(:,1) = y'; 
    for j = 2:n
        for i = 1:(n-j+1)
            D(i,j) = D(i+1, j-1) - D(i, j-1);
        end
    end
    
    % Aplicar formula
    u = (x_buscado - x(1)) / h;
    y_interp = D(1,1);
    
    termino_u = 1;
    factorial_k = 1;
    
    for k = 2:n
        termino_u = termino_u * (u - (k - 2));
        factorial_k = factorial_k * (k - 1);
        y_interp = y_interp + (termino_u / factorial_k) * D(1,k);
    end

    tiempo = toc;
end

% Funcion para Newton-Gregory Descendente
function [y_interp, D, tiempo] = newton_gregory_descendente(x, y, x_buscado)
    tic; 

    n = length(x);
    h = x(2) - x(1);
    
    % Generar tabla de diferencias atrasadas
    D = zeros(n, n);
    D(:,1) = y'; 
    for j = 2:n
        for i = j:n
            D(i,j) = D(i, j-1) - D(i-1, j-1);
        end
    end
    
    % Aplicar formula (desde el final hacia atras)
    u = (x_buscado - x(n)) / h;
    y_interp = D(n,1);
    
    termino_u = 1;
    factorial_k = 1;
    
    for k = 2:n
        termino_u = termino_u * (u + (k - 2));
        factorial_k = factorial_k * (k - 1);
        y_interp = y_interp + (termino_u / factorial_k) * D(n,k);
    end

    tiempo = toc; 
end

% Funcion para Interpolacion Inversa Lineal (Lagrange Grado 1)
function [x_interp, tiempo] = interpolacion_inversa_lineal(x, y, y_buscado)
    tic;
    
    % Buscar los 2 puntos mas cercanos al y_buscado
    % En este caso y_buscado (0.907...) esta entre y(1) y y(2)
    y_sub = [y(1), y(2)];
    x_sub = [x(1), x(2)];
    
    % Lagrange de grado 1 invirtiendo roles de x e y
    L0 = (y_buscado - y_sub(2)) / (y_sub(1) - y_sub(2));
    L1 = (y_buscado - y_sub(1)) / (y_sub(2) - y_sub(1));
    
    x_interp = L0 * x_sub(1) + L1 * x_sub(2);

    tiempo = toc;
end

% Funcion para Interpolacion Inversa Cuadratica (Lagrange Grado 2)
function [x_interp, tiempo] = interpolacion_inversa_cuadratica(x, y, y_buscado)
    tic;
    
    % Buscar los 3 puntos mas cercanos. Usamos indices 1, 2 y 3.
    y_sub = [y(1), y(2), y(3)];
    x_sub = [x(1), x(2), x(3)];
    
    % Lagrange de grado 2 invirtiendo roles de x e y
    L0 = ((y_buscado - y_sub(2))*(y_buscado - y_sub(3))) / ((y_sub(1) - y_sub(2))*(y_sub(1) - y_sub(3)));
    L1 = ((y_buscado - y_sub(1))*(y_buscado - y_sub(3))) / ((y_sub(2) - y_sub(1))*(y_sub(2) - y_sub(3)));
    L2 = ((y_buscado - y_sub(1))*(y_buscado - y_sub(2))) / ((y_sub(3) - y_sub(1))*(y_sub(3) - y_sub(2)));
    
    x_interp = L0 * x_sub(1) + L1 * x_sub(2) + L2 * x_sub(3);

    tiempo = toc;
end