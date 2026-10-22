function ejercicio3()

    clc;
    clear;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 3 \n");
    printf("========================\n");

    % Definicion de la matriz de coeficientes (A) y vector de terminos (b)
    A = [2, 3,  4;
         4, 5, 10;
         4, 8,  2];
         
    b = [6; 16; 2];

    fprintf('Sistema de ecuaciones cargado (Matriz A y vector b):\n');
    disp([A, b]);
    
    fprintf('Pulsar "Enter" para aplicar el Metodo de Descomposicion LU...\n');
    pause;

    printf("\n\n-------------------------------------------------------\n");
    printf("a. FACTORIZACION LU DE LA MATRIZ DE COEFICIENTES\n");
    printf("-------------------------------------------------------\n");
    
    % Llamada a la funcion para factorizar A en L y U
    [L, U, tiempo_lu] = metodo_descomposicion_LU(A);
    
    fprintf('\n---> Matriz Triangular Inferior (L):\n');
    disp(L);
    fprintf('\n---> Matriz Triangular Superior (U):\n');
    disp(U);
    
    fprintf('Pulsar "Enter" para resolver el sistema con estas matrices...\n');
    pause;
    
    printf("\n\n-------------------------------------------------------\n");
    printf("b. RESOLUCION DEL SISTEMA (Ly = b  ->  Ux = y)\n");
    printf("-------------------------------------------------------\n");

    % Llamada a la funcion para resolver el sistema usando L y U
    [x, y, tiempo_res] = resolver_LU(L, U, b);
    
    fprintf('\n---> Vector intermedio resuelto (y):\n');
    disp(y);

    fprintf('\n======================================================\n');
    fprintf('                 RESULTADOS FINALES                   \n');
    fprintf('======================================================\n');
    
    fprintf('VECTOR SOLUCION (x):\n');
    fprintf('- x1: %10.5f\n', x(1));
    fprintf('- x2: %10.5f\n', x(2));
    fprintf('- x3: %10.5f\n\n', x(3));
    
    fprintf('ANALISIS:\n');
    fprintf('- Tiempo factorizacion LU: %f segundos\n', tiempo_lu);
    fprintf('- Tiempo resolucion:       %f segundos\n', tiempo_res);
    fprintf('- Tiempo computacional:    %f segundos\n', tiempo_lu + tiempo_res);
    fprintf('======================================================\n');

end


% =========================================================
% FUNCIONES
% =========================================================

% Funcion para descomponer A = L * U
function [L, U, tiempo] = metodo_descomposicion_LU(A)
    tic; % Iniciar medicion de tiempo

    n = size(A, 1);
    L = eye(n); % Matriz identidad inicial para L (unos en la diagonal)
    U = zeros(n, n); % Matriz de ceros inicial para U
    
    for k = 1:n
        % Calcular la fila k de U
        for j = k:n
            suma = 0;
            for p = 1:k-1
                suma = suma + L(k,p) * U(p,j);
            end
            U(k,j) = A(k,j) - suma;
        end
        
        % Calcular la columna k de L
        for i = k+1:n
            suma = 0;
            for p = 1:k-1
                suma = suma + L(i,p) * U(p,k);
            end
            L(i,k) = (A(i,k) - suma) / U(k,k);
        end
    end

    tiempo = toc; % Detener medicion de tiempo
end

% Funcion para encontrar el vector x empleando sustituciones
function [x, y, tiempo] = resolver_LU(L, U, b)
    tic; % Iniciar medicion de tiempo
    n = length(b);
    
    % Resolver L*y = b (Sustitucion hacia adelante)
    y = zeros(n, 1);
    y(1) = b(1) / L(1,1);
    for i = 2:n
        suma = 0;
        for j = 1:i-1
            suma = suma + L(i,j) * y(j);
        end
        y(i) = (b(i) - suma) / L(i,i);
    end
    
    % Resolver U*x = y (Sustitucion hacia atras)
    x = zeros(n, 1);
    x(n) = y(n) / U(n,n);
    for i = n-1:-1:1
        suma = 0;
        for j = i+1:n
            suma = suma + U(i,j) * x(j);
        end
        x(i) = (y(i) - suma) / U(i,i);
    end

    tiempo = toc; % Detener medicion de tiempo
end