function ejercicio2()

    clc;
    clear;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 2 \n");
    printf("========================\n");

    % Sistema de ecuaciones original
    A = [0.1,  7.0,  -0.3;
         3.0, -0.1,  -0.2;
         0.3, -0.2, -10.3];
         
    b = [-19.30; 7.85; -19.30];

    % Vector inicial y parametros de tolerancia
    x0 = [1; 1; 1]; % Solucion inicial 
    tol = 1e-4; % Tolerancia del error
    max_iter = 100; % Limite de iteraciones

    fprintf('Matriz Original del Sistema:\n');
    disp([A, b]);

    fprintf('Analizando convergencia y pivoteando si es necesario...\n');
    
    % Reordenar la matriz para asegurar diagonal dominante
    [A_dom, b_dom] = asegurar_convergencia(A, b);
    
    fprintf('Matriz Diagonalmente Dominante para Gauss-Seidel:\n');
    disp([A_dom, b_dom]);

    fprintf('Pulsar "Enter" para resolver utilizando el Metodo de Gauss-Seidel...\n');
    pause;

    printf("\n\n-------------------------------------------------------\n");
    printf("a. METODO DE GAUSS-SEIDEL\n");
    printf("-------------------------------------------------------\n");

    % Llamada a la funcion del metodo de Gauss-Seidel
    [x, iter, error_aprox, tiempo] = metodo_gauss_seidel(A_dom, b_dom, x0, tol, max_iter);

    fprintf('\n======================================================\n');
    fprintf('                 RESULTADOS FINALES                   \n');
    fprintf('======================================================\n');
    
    fprintf('VECTOR SOLUCION:\n');
    fprintf('- x1: %10.5f\n', x(1));
    fprintf('- x2: %10.5f\n', x(2));
    fprintf('- x3: %10.5f\n\n', x(3));
    
    fprintf('ANALISIS:\n');
    fprintf('- Iteraciones realizadas: %d\n', iter);
    fprintf('- Error aproximado final: %.2e\n', error_aprox);
    fprintf('- Tiempo de ejecucion:    %f segundos\n', tiempo);
    fprintf('======================================================\n');

end


% =========================================================
% FUNCIONES
% =========================================================

% Funcion para asegurar que la matriz sea estrictamente diagonal dominante
function [A_dom, b_dom] = asegurar_convergencia(A, b)
    n = length(b);
    A_dom = zeros(n, n);
    b_dom = zeros(n, 1);
    
    for i = 1:n
        % Buscamos la fila donde la variable i sea la dominante
        for j = 1:n
            suma_resto = sum(abs(A(j,:))) - abs(A(j,i));
            if abs(A(j,i)) > suma_resto
                A_dom(i,:) = A(j,:);
                b_dom(i) = b(j);
                break;
            end
        end
    end
end

% Funcion del Metodo de Gauss-Seidel
function [x, iter, error_aprox, tiempo] = metodo_gauss_seidel(A, b, x0, tol, max_iter)
    tic; % Iniciar medicion de tiempo

    n = length(b);
    x = x0;
    iter = 0;
    error_aprox = 100;
    
    while error_aprox > tol && iter < max_iter
        x_old = x;
        iter = iter + 1;
        
        for i = 1:n
            suma = 0;
            for j = 1:n
                if j ~= i
                    suma = suma + A(i,j) * x(j);
                end
            end
            x(i) = (b(i) - suma) / A(i,i);
        end
        
        % Calcular el error relativo porcentual maximo
        error_aprox = max(abs((x - x_old) ./ x)) * 100;
    end

    tiempo = toc; % Detener medicion de tiempo
end