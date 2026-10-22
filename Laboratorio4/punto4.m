function punto4()
    clc;
    clear;

    printf('========================\n');
    printf(' RESOLUCION EJERCICIO 4\n');
    printf('========================\n');

    % Variables: x1 transistores, x2 resistores, x3 chips
    % Filas: cobre, zinc y vidrio
    A = [4.3, 3, 2;
         1,   3, 1;
         2,   1, 3];
    b = [960; 510; 610];

    fprintf('Matriz de coeficientes y suministros del ejemplo:\n');
    disp([A, b]);
    cambiar = input('Desea ingresar otros suministros? (1=Si, 0=No): ');
    if cambiar == 1
        b = input('Ingrese [cobre; zinc; vidrio], por ejemplo [960;510;610]: ');
        b = b(:);
    end
    if length(b) ~= 3
        error('Se requieren tres cantidades de materiales.');
    end

    fprintf('Pulse Enter para aplicar los cuatro metodos...\n');
    pause;

    [xg, tg] = eliminacion_gauss(A, b);
    [xj, tj] = gauss_jordan(A, b);
    [xl, tl] = descomposicion_lu(A, b);

    % Gauss-Seidel: se intenta una permutacion de filas con dominancia diagonal.
    [As, bs, dominante] = reordenar_filas(A, b);
    fprintf('\n-------------------------------------------------------\n');
    fprintf('METODO DE GAUSS-SEIDEL\n');
    fprintf('-------------------------------------------------------\n');
    if dominante
        fprintf('Matriz reordenada con dominancia diagonal:\n');
    else
        fprintf('Advertencia: no se logro dominancia diagonal estricta.\n');
        fprintf('La convergencia no esta garantizada; se verificara el residuo.\n');
    end
    disp([As, bs]);
    x0 = zeros(3,1);
    tol = 1e-6;
    max_iter = 1000;
    [xs, iter, err, ts, convergio] = gauss_seidel(As, bs, x0, tol, max_iter);

    fprintf('\n=======================================================\n');
    fprintf('                 RESULTADOS FINALES\n');
    fprintf('=======================================================\n');
    nombres = {'Transistores', 'Resistores', 'Chips'};
    fprintf('                    Gauss      Jordan       LU        Seidel\n');
    for i = 1:3
        fprintf('%-13s %10.4f %10.4f %10.4f %10.4f\n', ...
                nombres{i}, xg(i), xj(i), xl(i), xs(i));
    end
    fprintf('\nANALISIS:\n');
    fprintf('- Tiempo Gauss:        %.6f segundos\n', tg);
    fprintf('- Tiempo Gauss-Jordan: %.6f segundos\n', tj);
    fprintf('- Tiempo LU:           %.6f segundos\n', tl);
    fprintf('- Tiempo Gauss-Seidel: %.6f segundos\n', ts);
    fprintf('- Iteraciones Seidel:  %d\n', iter);
    fprintf('- Cambio maximo Seidel: %.2e\n', err);
    fprintf('- Residuo Gauss:       %.2e\n', norm(A*xg-b, inf));
    fprintf('- Residuo Jordan:      %.2e\n', norm(A*xj-b, inf));
    fprintf('- Residuo LU:          %.2e\n', norm(A*xl-b, inf));
    fprintf('- Residuo Seidel:      %.2e\n', norm(A*xs-b, inf));
    if convergio
        fprintf('- Gauss-Seidel alcanzo la tolerancia.\n');
    else
        fprintf('- Gauss-Seidel no alcanzo la tolerancia.\n');
    end
    if any(xg < 0)
        fprintf('ADVERTENCIA: la solucion contiene cantidades negativas.\n');
        fprintf('No representa una produccion fisicamente posible.\n');
    end
    if any(abs(xg-round(xg)) > 1e-8)
        fprintf('OBSERVACION: hay cantidades no enteras de componentes.\n');
    end
    fprintf('=======================================================\n');
end

% =========================================================
% FUNCIONES
% =========================================================
function [x, tiempo] = eliminacion_gauss(A, b)
    tic;
    n = length(b);
    Ab = [A, b];
    fprintf('\n--- ELIMINACION DE GAUSS ---\n');
    fprintf('Matriz ampliada inicial:\n'); disp(Ab);
    for k = 1:n-1
        [~, p] = max(abs(Ab(k:n,k)));
        p = p + k - 1;
        if abs(Ab(p,k)) < 1e-12, error('Sistema singular.'); end
        Ab([k,p],:) = Ab([p,k],:);
        for i = k+1:n
            factor = Ab(i,k)/Ab(k,k);
            Ab(i,:) = Ab(i,:) - factor*Ab(k,:);
        end
    end
    if abs(Ab(n,n)) < 1e-12, error('Sistema singular.'); end
    fprintf('Matriz triangular:\n'); disp(Ab);
    x = zeros(n,1);
    for i = n:-1:1
        x(i) = (Ab(i,n+1)-Ab(i,i+1:n)*x(i+1:n))/Ab(i,i);
    end
    tiempo = toc;
end

function [x, tiempo] = gauss_jordan(A, b)
    tic;
    n = length(b);
    Ab = [A,b];
    fprintf('\n--- GAUSS-JORDAN ---\n');
    for k = 1:n
        [~, p] = max(abs(Ab(k:n,k)));
        p = p+k-1;
        if abs(Ab(p,k)) < 1e-12, error('Sistema singular.'); end
        Ab([k,p],:) = Ab([p,k],:);
        Ab(k,:) = Ab(k,:)/Ab(k,k);
        for i = 1:n
            if i ~= k
                factor = Ab(i,k);
                Ab(i,:) = Ab(i,:) - factor*Ab(k,:);
            end
        end
    end
    fprintf('Matriz reducida:\n'); disp(Ab);
    x = Ab(:,n+1);
    tiempo = toc;
end

function [x, tiempo] = descomposicion_lu(A, b)
    tic;
    n = length(b);
    L = eye(n);
    U = A;
    P = eye(n);
    fprintf('\n--- DESCOMPOSICION LU ---\n');
    for k = 1:n-1
        [~, p] = max(abs(U(k:n,k)));
        p = p+k-1;
        if abs(U(p,k)) < 1e-12, error('Sistema singular.'); end
        U([k,p],:) = U([p,k],:);
        P([k,p],:) = P([p,k],:);
        if k > 1, L([k,p],1:k-1) = L([p,k],1:k-1); end
        for i = k+1:n
            L(i,k) = U(i,k)/U(k,k);
            U(i,:) = U(i,:) - L(i,k)*U(k,:);
        end
    end
    if abs(U(n,n)) < 1e-12, error('Sistema singular.'); end
    fprintf('Matriz L:\n'); disp(L);
    fprintf('Matriz U:\n'); disp(U);
    fprintf('Matriz de permutacion P (P*A=L*U):\n'); disp(P);
    bp = P*b;
    y = zeros(n,1);
    for i = 1:n
        y(i) = (bp(i)-L(i,1:i-1)*y(1:i-1))/L(i,i);
    end
    x = zeros(n,1);
    for i = n:-1:1
        x(i) = (y(i)-U(i,i+1:n)*x(i+1:n))/U(i,i);
    end
    tiempo = toc;
end

function [Ar, br, dominante] = reordenar_filas(A,b)
    n = size(A,1);
    Ar = A;
    br = b;
    dominante = false;
    perm = perms(1:n);
    for p = 1:size(perm,1)
        Ap = A(perm(p,:),:);
        if all(2*abs(diag(Ap)) > sum(abs(Ap),2))
            Ar = Ap;
            br = b(perm(p,:));
            dominante = true;
            return;
        end
    end
    % Sin dominancia estricta: se conserva el sistema original.
end

function [x, iter, err, tiempo, convergio] = gauss_seidel(A,b,x0,tol,max_iter)
    tic;
    n = length(b);
    x = x0;
    err = Inf;
    iter = 0;
    convergio = false;
    if any(abs(diag(A)) < 1e-12)
        fprintf('No es posible iterar: hay un cero en la diagonal.\n');
        tiempo = toc;
        return;
    end
    while iter < max_iter
        anterior = x;
        iter = iter+1;
        for i = 1:n
            suma = 0;
            for j = 1:n
                if j ~= i, suma = suma+A(i,j)*x(j); end
            end
            x(i) = (b(i)-suma)/A(i,i);
        end
        err = norm(x-anterior,inf);
        residuo = norm(A*x-b,inf);
        if ~all(isfinite(x)), break; end
        if err <= tol && residuo <= tol
            convergio = true;
            break;
        end
    end
    tiempo = toc;
end
