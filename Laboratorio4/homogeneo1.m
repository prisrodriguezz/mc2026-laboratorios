function homogeneo1()
    clc;
    clear;
    printf('=====================================\n');
    printf(' SISTEMAS HOMOGENEOS - EJERCICIO 1\n');
    printf('=====================================\n');

    % Sistema: (A - lambda*I)*v = 0
    A = [3, 2, -1;
         1,-2,  3;
         2, 0,  4];
    cambiar = input('Desea ingresar otra matriz A? (1=Si, 0=No): ');
    if cambiar == 1
        A = input('Ingrese la matriz cuadrada A, por ejemplo [3 2 -1; 1 -2 3; 2 0 4]: ');
    elseif cambiar ~= 0
        error('Opcion no valida.');
    end
    n = size(A,1);
    if n < 2 || size(A,2) ~= n || ~isnumeric(A) || any(~isfinite(A(:)))
        error('A debe ser una matriz cuadrada de orden mayor o igual a 2.');
    end
    fprintf('Matriz A del sistema:\n');
    disp(A);
    fprintf('Pulse Enter para aplicar Faddeev-Leverrier...\n');
    pause;

    [coef, tiempo] = faddeev_leverrier(A);
    fprintf('\n-------------------------------------------------------\n');
    fprintf('METODO DE FADDEEV-LEVERRIER\n');
    fprintf('-------------------------------------------------------\n');
    fprintf('Coeficientes del polinomio caracteristico:\n');
    disp(coef);
    fprintf('Polinomio caracteristico (coeficientes de mayor a menor grado):\n');
    disp(coef);
    fprintf('P(lambda) = ');
    for j = 1:length(coef)
        grado = n-j+1;
        if j > 1, fprintf(' %+.6g', coef(j)); else, fprintf('%.6g', coef(j)); end
        if grado > 1, fprintf('*lambda^%d', grado);
        elseif grado == 1, fprintf('*lambda'); end
    end
    fprintf(' = 0\n');

    % Las raices del polinomio son los autovalores.
    autovalores = roots(coef);
    fprintf('\n=======================================================\n');
    fprintf('                 RESULTADOS FINALES\n');
    fprintf('=======================================================\n');
    for i = 1:length(autovalores)
        lambda = autovalores(i);
        fprintf('\nAutovalor %d: %.8f %+.8fi\n', i, real(lambda), imag(lambda));
        % Para cada autovalor: (A-lambda*I)*v=0.
        % null con tolerancia obtiene una base del espacio nulo.
        M = A-lambda*eye(size(A,1));
        v = null(M, 1e-6);
        if isempty(v)
            fprintf('No se pudo determinar el autovector con la tolerancia dada.\n');
        else
            v = v(:,1);
            fprintf('Autovector asociado (normalizado):\n');
            disp(v);
            fprintf('Residuo ||A*v-lambda*v||: %.2e\n', norm(A*v-lambda*v));
        end
    end
    fprintf('\nTiempo Faddeev-Leverrier: %.6f segundos\n', tiempo);
    fprintf('=======================================================\n');
end

% =========================================================
% FUNCIONES
% =========================================================
function [coef, tiempo] = faddeev_leverrier(A)
    tic;
    n = size(A,1);
    B = eye(n);
    coef = [1, zeros(1,n)];
    for k = 1:n
        producto = A*B;
        ck = -trace(producto)/k;
        coef(k+1) = ck;
        B = producto+ck*eye(n);
        fprintf('Paso %d: coeficiente c%d = %.8f\n', k, k, ck);
    end
    tiempo = toc;
end
