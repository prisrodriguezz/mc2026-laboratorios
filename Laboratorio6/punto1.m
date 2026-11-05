function punto1()

    clc;
    clear;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 1 \n");
    printf("========================\n");

    % Definicion de los datos iniciales
    x = [12, 13, 14, 15, 16, 17];
    y = [0.96262, 0.94718, 0.93108, 0.92221, 0.91181, 0.90151];
    h = x(2) - x(1);
    n = length(x);

    fprintf('Se han cargado los datos de la tabla (x, y).\n');
    fprintf('Pulsar "Enter" para resolver utilizando formulas de Newton-Gregory...\n');
    pause;

    % ======================================================
    % a) CONSTRUIR TABLA DE DIFERENCIAS
    % ======================================================
    printf("\n\n-------------------------------------------------------\n");
    printf("a) TABLA DE DIFERENCIAS FINITAS\n");
    printf("-------------------------------------------------------\n");
    
    tic; % Iniciar medicion de tiempo
    
    D = tabla_diferencias(x, y);
    disp('Matriz de diferencias progresivas (columnas = orden de diferencia):');
    disp(D);

    % ======================================================
    % b) CALCULAR f'(12) CON NEWTON-GREGORY ASCENDENTE
    % ======================================================
    printf("\n-------------------------------------------------------\n");
    printf("b) CALCULAR f'(12) - FORMULA ASCENDENTE\n");
    printf("-------------------------------------------------------\n");
    
    % Al ser x=12 un nodo exacto, s=0. 
    % Utilizamos las diferencias de la primera fila: D(1,2) a D(1,6)
    df_12 = (1/h) * (D(1,2) - D(1,3)/2 + D(1,4)/3 - D(1,5)/4 + D(1,6)/5);
    fprintf("f'(12) = %.6f\n", df_12);

    % ======================================================
    % c) CALCULAR f'(12.4) Y EXPLICAR LA DIFERENCIA
    % ======================================================
    printf("\n-------------------------------------------------------\n");
    printf("c) CALCULAR f'(12.4) - FORMULA ASCENDENTE\n");
    printf("-------------------------------------------------------\n");
    
    % Calculo del parametro 's'
    xp = 12.4;
    s = (xp - x(1)) / h; 
    
    % Derivada evaluando los polinomios dependientes de 's'
    term1 = D(1,2);
    term2 = ((2*s - 1)/2) * D(1,3);
    term3 = ((3*s^2 - 6*s + 2)/6) * D(1,4);
    term4 = ((4*s^3 - 18*s^2 + 22*s - 6)/24) * D(1,5);
    term5 = ((5*s^4 - 40*s^3 + 105*s^2 - 100*s + 24)/120) * D(1,6);
    
    df_12_4 = (1/h) * (term1 + term2 + term3 + term4 + term5);
    
    fprintf("f'(12.4) = %.6f\n", df_12_4);
    fprintf("\n¿Cual es la diferencia en el uso de la formula?\n");
    fprintf("-> En el inciso (b), como x coincide con el nodo x0, el parametro 's' es 0,\n");
    fprintf("   lo que anula la mayoria de los terminos en la derivada del polinomio.\n");
    fprintf("-> En el inciso (c), al no ser un nodo exacto (s = 0.4), es obligatorio\n");
    fprintf("   derivar la formula interpolante completa respecto a 's' y evaluarla.\n");

    % ======================================================
    % d) CALCULAR f''(17) CON NEWTON-GREGORY DESCENDENTE
    % ======================================================
    printf("\n-------------------------------------------------------\n");
    printf("d) CALCULAR f''(17) - FORMULA DESCENDENTE\n");
    printf("-------------------------------------------------------\n");
    
    % Se utilizan las diferencias hacia atras, que corresponden a la diagonal 
    % inferior de la tabla de diferencias progresivas D.
    % D(n-2,3) = nabla^2 y_n
    % D(n-3,4) = nabla^3 y_n
    % D(n-4,5) = nabla^4 y_n
    % D(n-5,6) = nabla^5 y_n
    
    d2f_17 = (1/h^2) * (D(n-2,3) + D(n-3,4) + (11/12)*D(n-4,5) + (5/6)*D(n-5,6));
    fprintf("f''(17) = %.6f\n", d2f_17);
    
    tiempo_exec = toc; % Detener medicion de tiempo

    fprintf('\n======================================================\n');
    fprintf('                 RESUMEN EJECUCION                    \n');
    fprintf('======================================================\n');
    fprintf('- Tiempo total de calculos: %f segundos\n', tiempo_exec);
    fprintf('======================================================\n');

end

% =========================================================
% FUNCIONES AUXILIARES
% =========================================================

function D = tabla_diferencias(x, y)
    % Genera la tabla de diferencias divididas / progresivas
    n = length(x);
    D = zeros(n, n);
    D(:,1) = y'; % La primera columna es el vector y
    
    for j = 2:n
        for i = 1:(n-j+1)
            D(i,j) = D(i+1, j-1) - D(i, j-1);
        end
    end
end