function punto3()

    clc;
    clear;

    fprintf("=====================================================\n");
    fprintf(" PUNTO 3 - METODO DE ITERACION Y ACELERACION AITKEN\n");
    fprintf("=====================================================\n");

    % Funcion original:
    % R(x) = 5x - A
    % A = 200 * ln(400/(500-x))
    % Se desea R(x) = 1000

    f = @(x) 5*x - 200*log(400/(500-x)) - 1000;

    % Despeje para el metodo de iteracion:
    % x = 200 + 40*ln(400/(500-x))

    g = @(x) 200 + 40*log(400/(500-x));

    % Derivada de g(x) para analizar convergencia
    dg = @(x) 40/(500-x);

    % Datos del problema
    x0 = 200;
    tol = 1e-4;

    fprintf("\nPunto inicial: x0 = %.4f\n", x0);
    fprintf("Tolerancia: E < %.6f\n", tol);

    % ==================================================
    % ANALISIS DE CONVERGENCIA
    % ==================================================

    fprintf("\n========================================\n");
    fprintf(" ANALISIS DE CONVERGENCIA\n");
    fprintf("========================================\n");

    fprintf("|g'(x0)| = %.6f\n", abs(dg(x0)));

    if abs(dg(x0)) < 1
        fprintf("Se cumple |g'(x0)| < 1.\n");
        fprintf("El metodo de iteracion converge.\n");
    else
        fprintf("No se cumple |g'(x0)| < 1.\n");
        fprintf("El metodo podria no converger.\n");
    end


    % ==================================================
    % METODO DE ITERACION
    % ==================================================

    fprintf("\n========================================\n");
    fprintf(" METODO DE ITERACION\n");
    fprintf("========================================\n");

    tic;

    x_anterior = x0;
    iter = 0;
    error = Inf;

    fprintf("\nIteracion\t x\t\t Error\n");
    fprintf("0\t\t %.8f\t ---\n", x_anterior);

    while error >= tol

        iter = iter + 1;

        x_nuevo = g(x_anterior);

        error = abs(x_nuevo - x_anterior);

        fprintf("%d\t\t %.8f\t %.8f\n", ...
                iter, x_nuevo, error);

        x_anterior = x_nuevo;

    end

    tiempo_iteracion = toc;
    raiz_iteracion = x_nuevo;


    % ==================================================
    % METODO DE ITERACION + AITKEN
    % ==================================================

    fprintf("\n========================================\n");
    fprintf(" ACELERACION DELTA CUADRADO DE AITKEN\n");
    fprintf("========================================\n");

    tic;

    x_base = x0;
    x_acelerado_anterior = x0;

    iter_aitken = 0;
    error_aitken = Inf;

    fprintf("\nIteracion\t x0\t\t x1\t\t x2\t\t xA\n");

    while error_aitken >= tol

        iter_aitken = iter_aitken + 1;

        % Dos iteraciones normales
        x1 = g(x_base);
        x2 = g(x1);

        % Denominador de la formula de Aitken
        denominador = x2 - 2*x1 + x_base;

        % Formula Delta-cuadrado de Aitken
        x_acelerado = x_base - ...
            ((x1 - x_base)^2 / denominador);

        fprintf("%d\t %.8f\t %.8f\t %.8f\t %.8f\n", ...
                iter_aitken, x_base, x1, x2, x_acelerado);

        % Criterio de parada
        error_aitken = abs(x_acelerado - x_acelerado_anterior);

        % La aproximacion acelerada pasa a ser
        % el nuevo punto inicial
        x_acelerado_anterior = x_acelerado;
        x_base = x_acelerado;

    end

    tiempo_aitken = toc;


    % ==================================================
    % RESULTADOS FINALES
    % ==================================================

    fprintf("\n=====================================================\n");
    fprintf(" RESULTADOS FINALES\n");
    fprintf("=====================================================\n");

    fprintf("\nMETODO DE ITERACION:\n");
    fprintf("Raiz aproximada: %.8f\n", raiz_iteracion);
    fprintf("Iteraciones: %d\n", iter);
    fprintf("Error final: %.8f\n", error);
    fprintf("Tiempo: %f segundos\n", tiempo_iteracion);

    fprintf("\nMETODO CON ACELERACION DE AITKEN:\n");
    fprintf("Raiz aproximada: %.8f\n", x_acelerado);
    fprintf("Iteraciones de Aitken: %d\n", iter_aitken);
    fprintf("Error final: %.8f\n", error_aitken);
    fprintf("Tiempo: %f segundos\n", tiempo_aitken);

    fprintf("\nVerificacion:\n");
    fprintf("f(x) = %.10f\n", f(x_acelerado));

    fprintf("\nLa cantidad aproximada de unidades es x = %.5f\n", ...
            x_acelerado);

    fprintf("=====================================================\n");

end