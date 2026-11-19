
function punto5()

    clc;

    printf("========================================\n");
    printf(" EJERCICIO 5 - METODO DE MILNE\n");
    printf("========================================\n");

    % DATOS DEL PROBLEMA
    f = @(x,y) x^2 + y^2;

    x0 = 0;
    y0 = 1;
    h = 0.2;
    tol = 0.001;
    max_iter = 100;

    % ARREGLOS PARA GUARDAR RESULTADOS
    x = zeros(1,6);
    y = zeros(1,6);
    derivada = zeros(1,6);

    x(1) = x0;
    y(1) = y0;
    derivada(1) = f(x0,y0);

    tic;

    % ==========================================
    % VALORES INICIALES CON RUNGE-KUTTA 2
    % ==========================================

    for i = 1:3

        k1 = f(x(i),y(i));
        k2 = f(x(i)+h,y(i)+h*k1);

        x(i+1) = x(i)+h;
        y(i+1) = y(i)+(h/2)*(k1+k2);

        derivada(i+1) = f(x(i+1),y(i+1));

    end

    printf("\n----------------------------------------\n");
    printf(" TABLA INICIAL - RUNGE KUTTA 2\n");
    printf("----------------------------------------\n");

    printf("    x          y             y'\n");

    for i = 1:4
        printf("%8.4f    %12.8f    %12.8f\n", ...
               x(i),y(i),derivada(i));
    end

    % ==========================================
    % METODO DE MILNE
    % ==========================================

    printf("\n----------------------------------------\n");
    printf(" METODO DE MILNE\n");
    printf("----------------------------------------\n");

    for i = 4:5

        x(i+1) = x(i)+h;

        % FORMULA PREDICTORA DE MILNE
        y_pred = y(i-3) + (4*h/3) * ...
                 (2*derivada(i-2) ...
                 - derivada(i-1) ...
                 + 2*derivada(i));

        % FORMULA CORRECTORA DE MILNE-SIMPSON
        y_ant = y_pred;
        error_est = Inf;
        iter = 0;

        while error_est >= tol && iter < max_iter

            iter = iter+1;

            y_corr = y(i-1) + (h/3) * ...
                     (derivada(i-1) ...
                     + 4*derivada(i) ...
                     + f(x(i+1),y_ant));

            error_est = abs(y_corr-y_ant);
            y_ant = y_corr;

        end

        if error_est >= tol
            error("Milne no alcanzo la tolerancia.");
        end

        y(i+1) = y_corr;
        derivada(i+1) = f(x(i+1),y(i+1));

        printf("\nResultado para x = %.2f\n",x(i+1));
        printf("Valor predictor: %.8f\n",y_pred);
        printf("Valor corregido: %.8f\n",y_corr);
        printf("Error ultima correccion: %.8f\n",error_est);
        printf("Cantidad de correcciones: %d\n",iter);

    end

    tiempo = toc;

    % ==========================================
    % RESULTADOS FINALES
    % ==========================================

    printf("\n========================================\n");
    printf(" TABLA FINAL DE RESULTADOS\n");
    printf("========================================\n");

    printf("    x          y             y'\n");

    for i = 1:6
        printf("%8.4f    %12.8f    %12.8f\n", ...
               x(i),y(i),derivada(i));
    end

    printf("\nRESULTADOS SOLICITADOS:\n");
    printf("y(0.8) = %.8f\n",y(5));
    printf("y(1.0) = %.8f\n",y(6));

    printf("\nTiempo de ejecucion: %.8f segundos\n",tiempo);

    printf("\nCONCLUSION:\n");
    printf("Se utilizaron los primeros cuatro valores obtenidos con RK2.\n");
    printf("Milne permitio continuar la aproximacion mediante\n");
    printf("un predictor y un corrector iterativo.\n");

end
