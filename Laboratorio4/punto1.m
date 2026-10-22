function punto1()

    clc;
    clear;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 1 \n");
    printf("========================\n");

    % Definicion de la matriz de coeficientes (A) y vector de terminos independientes (b)
    % Las filas representan: Carbohidratos, Proteinas, Vitaminas, Celulosa
    A = [80, 15, 35, 60;
         28, 72, 57, 25;
         20, 20, 12, 20;
         50, 10, 20, 60];
         
    b = [230; 180; 80; 160];

    % Costo de cada alimento por kg
    costos = [18, 5, 7, 20];

    fprintf('Se ha cargado el sistema de ecuaciones nutricionales.\n');
    fprintf('Pulsar "Enter" para resolver utilizando el Metodo de Eliminacion de Gauss...\n');
    pause;

    printf("\n\n-------------------------------------------------------\n");
    printf("a y b. METODO DE ELIMINACION DE GAUSS Y CALCULO DE COSTO\n");
    printf("-------------------------------------------------------\n");

    % Llamada a la funcion del metodo de Gauss
    [x, tiempo_gauss] = metodo_eliminacion_gauss(A, b);

    % Calculo del costo total
    costo_total = sum(costos(:) .* x(:));

    fprintf('\n======================================================\n');
    fprintf('                 RESULTADOS FINALES                   \n');
    fprintf('======================================================\n');
    
    fprintf('CANTIDADES REQUERIDAS:\n');
    fprintf('- Maiz (x1):        %.3f kg\n', x(1));
    fprintf('- Desperdicio (x2): %.3f kg\n', x(2));
    fprintf('- Alfalfa (x3):     %.3f kg\n', x(3));
    fprintf('- Cebada (x4):      %.3f kg\n\n', x(4));
    
    fprintf('ANALISIS:\n');
    fprintf('- Costo total de la mezcla: $%.2f\n', costo_total);
    fprintf('- Tiempo de ejecucion:      %f segundos\n', tiempo_gauss);
    fprintf('======================================================\n');

end


% =========================================================
% FUNCIONES
% =========================================================

function [x, tiempo] = metodo_eliminacion_gauss(A, b)
    tic; % Iniciar medicion de tiempo

    n = length(b);
    Ab = [A, b]; % Construir matriz aumentada

    % --- MOSTRAR MATRIZ AMPLIADA INICIAL ---
    fprintf('\n---> Matriz Ampliada Inicial:\n');
    disp(Ab);
    
    % Eliminacion hacia adelante
    for k = 1:n-1
        for i = k+1:n
            % Factor multiplicador
            factor = Ab(i,k) / Ab(k,k);
            % Actualizacion de la fila
            Ab(i,:) = Ab(i,:) - factor * Ab(k,:);
        end
    end

    % --- MOSTRAR MATRIZ TRIANGULADA ---
    fprintf('\n---> Matriz Ampliada Triangular (Previa a la sustitucion inversa):\n');
    disp(Ab);
    
    % Sustitucion hacia atras
    x = zeros(n,1);
    x(n) = Ab(n,n+1) / Ab(n,n);
    
    for i = n-1:-1:1
        suma = Ab(i, i+1:n) * x(i+1:n);
        x(i) = (Ab(i,n+1) - suma) / Ab(i,i);
    end

    tiempo = toc; % Detener medicion de tiempo
end