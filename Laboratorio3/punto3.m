function punto3()

    clc;
    clear;
    close all;

    fprintf("=====================================================\n");
    fprintf(" PUNTO 3 - METODO DE ITERACION Y ACELERACION AITKEN\n");
    fprintf("=====================================================\n");

    % ==================================================
    % MODELO MATEMATICO
    % ==================================================
    %
    % A = 200 * ln(400 / (500 - x))
    % R(x) = 5*x - A
    %
    % Se desea obtener una utilidad neta:
    % R(x) = 1000
    %
    % Entonces:
    %
    % 5*x - 200*ln(400/(500-x)) = 1000
    %
    % Para aplicar el Metodo de Iteracion se despeja x:
    %
    % x = 200 + 40*ln(400/(500-x))
    %
    % Por lo tanto:
    %
    % g(x) = 200 + 40*ln(400/(500-x))


    % Funcion original f(x) = 0
    f = @(x) 5*x - 200*log(400/(500-x)) - 1000;

    % Funcion de iteracion x = g(x)
    g = @(x) 200 + 40*log(400/(500-x));

    % Derivada de g(x)
    dg = @(x) 40/(500-x);


    % ==================================================
    % DATOS DEL PROBLEMA
    % ==================================================

    x0 = 200;
    tolerancia = 1e-4;

    fprintf("\nPunto inicial: x0 = %.4f\n", x0);
    fprintf("Tolerancia: E < %.6f\n", tolerancia);


    % ==================================================
    % ANALISIS DE CONVERGENCIA
    % ==================================================

    fprintf("\n========================================\n");
    fprintf(" ANALISIS DE CONVERGENCIA\n");
    fprintf("========================================\n");

    derivada = abs(dg(x0));

    fprintf("|g'(%.4f)| = %.8f\n", x0, derivada);

    if derivada < 1

        fprintf("Se cumple |g'(x0)| < 1.\n");
        fprintf("El proceso iterativo es convergente.\n");

    else

        fprintf("No se cumple |g'(x0)| < 1.\n");
        fprintf("No se garantiza la convergencia.\n");
        return;

    end


    % ==================================================
    % GRAFICO
    % ==================================================

    figure;

    fplot(@(x) x, [150 250], "LineWidth", 1.5);
    hold on;

    fplot(g, [150 250], "LineWidth", 1.5);

    grid on;

    xlabel("Cantidad de unidades (x)");
    ylabel("y");

    title("Metodo de Iteracion - Punto 3");

    legend("y = x", "y = g(x)", "Location", "northwest");

    hold off;


    % ==================================================
    % METODO DE ITERACION
    % ==================================================

    fprintf("\n========================================\n");
    fprintf(" METODO DE ITERACION\n");
    fprintf("========================================\n");

    tic;

    x_anterior = x0;
    error = Inf;
    iter = 0;

    fprintf("\nIteracion\t x\t\t Error\n");
    fprintf("-----------------------------------------------\n");

    fprintf("0\t\t %.8f\t ---\n", x_anterior);


    while error >= tolerancia

        % Calcular la siguiente aproximacion
        x_nuevo = g(x_anterior);

        % Calcular el error
        error = abs(x_nuevo - x_anterior);

        % Aumentar cantidad de iteraciones
        iter = iter + 1;

        fprintf("%d\t\t %.8f\t %.8f\n", ...
                iter, x_nuevo, error);

        % La nueva aproximacion pasa a ser la anterior
        x_anterior = x_nuevo;

    end


    tiempo_iteracion = toc;

    raiz_iteracion = x_nuevo;


    % ==================================================
    % METODO DE ITERACION + ACELERACION DE AITKEN
    % ==================================================

    fprintf("\n========================================\n");
    fprintf(" ACELERACION DELTA CUADRADO DE AITKEN\n");
    fprintf("========================================\n");

    tic;

    % Primera aproximacion
    x_base = x0;

    error_aitken = Inf;
    iter_aitken = 0;

    fprintf("\nIteracion\t x0\t\t x1\t\t x2\t\t xA\t\t Error\n");

    fprintf("--------------------------------------------------------------------------------\n");


    while error_aitken >= tolerancia

        % Se calculan dos aproximaciones sucesivas
        % utilizando el Metodo de Iteracion

        x1 = g(x_base);

        x2 = g(x1);


        % Denominador de la formula de Aitken

        denominador = x2 - 2*x1 + x_base;


        % Verificar que el denominador no sea cero

        if abs(denominador) < eps

            fprintf("\nEl denominador de Aitken es demasiado pequeno.\n");
            break;

        end


        % Formula Delta-Cuadrado de Aitken

        x_acelerado = x2 - ((x2 - x1)^2 / denominador);


        % Calcular el error

        error_aitken = abs(x_acelerado - x_base);


        % Aumentar cantidad de aplicaciones de Aitken

        iter_aitken = iter_aitken + 1;


        fprintf("%d\t\t %.6f\t %.6f\t %.6f\t %.6f\t %.8f\n", ...
                iter_aitken, ...
                x_base, ...
                x1, ...
                x2, ...
                x_acelerado, ...
                error_aitken);


        % La aproximacion acelerada pasa a ser
        % el nuevo punto inicial

        x_base = x_acelerado;

    end


    tiempo_aitken = toc;

    raiz_aitken = x_acelerado;


    % ==================================================
    % RESULTADOS FINALES
    % ==================================================

    fprintf("\n=====================================================\n");
    fprintf(" RESULTADOS FINALES\n");
    fprintf("=====================================================\n");


    fprintf("\nMETODO DE ITERACION:\n");

    fprintf("Raiz aproximada: %.8f\n", raiz_iteracion);

    fprintf("Cantidad de iteraciones: %d\n", iter);

    fprintf("Error final: %.10f\n", error);

    fprintf("Tiempo de ejecucion: %.8f segundos\n", ...
            tiempo_iteracion);


    fprintf("\nMETODO DE ITERACION + AITKEN:\n");

    fprintf("Raiz aproximada: %.8f\n", raiz_aitken);

    fprintf("Cantidad de aplicaciones de Aitken: %d\n", ...
            iter_aitken);

    fprintf("Error final: %.10f\n", error_aitken);

    fprintf("Tiempo de ejecucion: %.8f segundos\n", ...
            tiempo_aitken);


    % ==================================================
    % VERIFICACION
    % ==================================================

    fprintf("\n========================================\n");
    fprintf(" VERIFICACION\n");
    fprintf("========================================\n");


    fprintf("f(x) utilizando Iteracion = %.10f\n", ...
            f(raiz_iteracion));

    fprintf("f(x) utilizando Aitken = %.10f\n", ...
            f(raiz_aitken));


    % Calcular el gasto en publicidad
    A = 200*log(400/(500-raiz_aitken));

    % Calcular la utilidad neta
    R = 5*raiz_aitken - A;


    fprintf("\nGasto en publicidad A = %.6f pesos\n", A);

    fprintf("Utilidad neta R(x) = %.6f pesos\n", R);


    fprintf("\n=====================================================\n");

    fprintf("La cantidad aproximada de unidades a vender es:\n");

    fprintf("x = %.6f unidades\n", raiz_aitken);

    fprintf("=====================================================\n");

end