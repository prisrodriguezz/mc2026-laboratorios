function homogeneo2()
    clc;
    clear;
    printf('=====================================\n');
    printf(' SISTEMAS HOMOGENEOS - EJERCICIO 2\n');
    printf('=====================================\n');

    % K*x = m*w^2*D*x, con D=diag(1,2,3).
    % lambda=m*w^2/k. Entonces A*x=lambda*x,
    % con A=D^(-1)*[2 -1 0; -1 2 -1; 0 -1 2].
    K = [2,-1, 0;
        -1, 2,-1;
         0,-1, 2];
    D = diag([1,2,3]);
    cambiar = input('Desea ingresar otros datos del sistema? (1=Si, 0=No): ');
    if cambiar == 1
        K = input('Ingrese la matriz K de 3x3: ');
        masas = input('Ingrese las 3 masas relativas [m1;m2;m3]: ');
        masas = masas(:);
        if ~isequal(size(K),[3,3]) || length(masas) ~= 3 || ...
           any(masas <= 0) || any(~isfinite(masas)) || any(~isfinite(K(:)))
            error('Se requiere K de 3x3 y tres masas positivas.');
        end
        D = diag(masas);
    elseif cambiar ~= 0
        error('Opcion no valida.');
    end
    A = D\K;

    fprintf('a. MATRIZ A DEL SISTEMA A*x = lambda*x:\n');
    disp(A);
    fprintf('Pulse Enter para calcular los valores propios...\n');
    pause;

    tic;
    [V, Lambda] = eig(A);
    tiempo_exacto = toc;
    [valores, orden] = sort(real(diag(Lambda)));
    V = V(:,orden);
    for j = 1:3
        V(:,j) = V(:,j)/norm(V(:,j),inf);
    end

    fprintf('\n-------------------------------------------------------\n');
    fprintf('b. AUTOVALORES Y AUTOVECTOR INTERMEDIO\n');
    fprintf('-------------------------------------------------------\n');
    for j = 1:3
        fprintf('Autovalor %d: %.10f\n', j, valores(j));
    end
    fprintf('Autovector correspondiente al valor intermedio:\n');
    disp(V(:,2));
    fprintf('Residuo intermedio: %.2e\n', norm(A*V(:,2)-valores(2)*V(:,2)));

    fprintf('\n-------------------------------------------------------\n');
    fprintf('c. METODO DE LAS POTENCIAS - 4 ITERACIONES\n');
    fprintf('-------------------------------------------------------\n');
    x0 = [1; 1; -0.5];
    if cambiar == 1
        x0 = input('Ingrese vector inicial de 3 componentes (ejemplo [1;1;-0.5]): ');
        x0 = x0(:);
        if length(x0) ~= 3 || any(~isfinite(x0)) || norm(x0,inf) == 0
            error('El vector inicial debe tener tres componentes y no ser nulo.');
        end
    end
    [lambda_aprox, x_aprox, tiempo_pot] = metodo_potencias(A,x0,4);

    lambda_exacto = valores(3);
    v_exacto = V(:,3);
    % El signo de un autovector es arbitrario; se alinea antes de comparar.
    if dot(x_aprox,v_exacto) < 0
        v_exacto = -v_exacto;
    end
    fprintf('\n=======================================================\n');
    fprintf('                 RESULTADOS FINALES\n');
    fprintf('=======================================================\n');
    fprintf('Autovalor maximo exacto: %.10f\n', lambda_exacto);
    fprintf('Autovalor tras 4 iteraciones: %.10f\n', lambda_aprox);
    fprintf('Error absoluto en lambda: %.4e\n', abs(lambda_exacto-lambda_aprox));
    fprintf('Error relativo en lambda: %.4f %%\n', ...
            100*abs(lambda_exacto-lambda_aprox)/abs(lambda_exacto));
    fprintf('Autovector exacto (escala maximo absoluto = 1):\n'); disp(v_exacto);
    fprintf('Autovector aproximado (misma escala):\n'); disp(x_aprox);
    fprintf('Error infinito del autovector: %.4e\n', norm(x_aprox-v_exacto,inf));
    fprintf('Residuo final: %.4e\n', norm(A*x_aprox-lambda_aprox*x_aprox,inf));
    fprintf('Tiempo calculo exacto: %.6f segundos\n', tiempo_exacto);
    fprintf('Tiempo metodo potencias: %.6f segundos\n', tiempo_pot);
    fprintf('=======================================================\n');
end

% =========================================================
% FUNCIONES
% =========================================================
function [lambda, x, tiempo] = metodo_potencias(A,x0,num_iter)
    tic;
    x = x0/norm(x0,inf);
    for k = 1:num_iter
        y = A*x;
        x = y/norm(y,inf);
        lambda = (x'*A*x)/(x'*x); % Cociente de Rayleigh
        fprintf('Iteracion %d: lambda=%.10f, vector=\n', k, lambda);
        disp(x);
    end
    tiempo = toc;
end
