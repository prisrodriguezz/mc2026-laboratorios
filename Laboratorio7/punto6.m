
function punto6()

    clc;

    printf("========================================\n");
    printf(" EJERCICIO 6 - EULER MODIFICADO Y MILNE\n");
    printf("========================================\n");

    % DATOS DEL PROBLEMA
    f = @(x,y) 3*x + 3*y;

    % SOLUCION EXACTA
    exacta = @(x) (4/3)*exp(3*x)-x-(1/3);

    x0 = 0;
    xf = 0.3;
    y0 = 1;

    tol = 0.000001;
    max_iter = 100;

    pasos = [0.1, 0.05];

    % ==========================================
    % INCISO A - EULER MODIFICADO
    % ==========================================

    printf("\nINCISO A - METODO MODIFICADO DE EULER\n");

    for p = 1:2

        h = pasos(p);
        n = round((xf-x0)/h);

        x = zeros(1,n+1);
        y = zeros(1,n+1);

        x(1) = x0;
        y(1) = y0;

        printf("\n----------------------------------------\n");
        printf(" PASO h = %.2f\n",h);
        printf("----------------------------------------\n");

        tic;

        for i = 1:n

            x(i+1) = x0+i*h;

            % PREDICTOR DE EULER
            y_ant = y(i)+h*f(x(i),y(i));

            % CORRECTOR ITERATIVO
            error_est = Inf;
            iter = 0;

            while error_est >= tol && iter < max_iter

                iter = iter+1;

                y_nuevo = y(i)+(h/2)* ...
                          (f(x(i),y(i))+f(x(i+1),y_ant));

                error_est = abs(y_nuevo-y_ant);
                y_ant = y_nuevo;

            end

            if error_est >= tol
                error("Euler Modificado no alcanzo la tolerancia.");
            end

            y(i+1) = y_nuevo;

        end

        tiempo_euler = toc;

        % TABLA DE RESULTADOS Y ERRORES
        printf("\n    x        Aproximada       Exacta       Error Abs.    Error Rel. %%\n");

        for i = 1:n+1

            valor_exacto = exacta(x(i));
            error_abs = abs(valor_exacto-y(i));
            error_rel = (error_abs/abs(valor_exacto))*100;

            printf("%7.4f    %12.8f    %12.8f    %11.8f    %10.6f\n", ...
                   x(i),y(i),valor_exacto,error_abs,error_rel);

        end

        printf("\nTiempo de ejecucion: %.8f segundos\n",tiempo_euler);

        % GUARDAR RESULTADOS CON h = 0.05
        if p == 2
            x_milne = x;
            y_milne = y;
        end

    end

    % ==========================================
    % INCISO B - METODO DE MILNE
    % ==========================================

    printf("\n========================================\n");
    printf(" INCISO B - METODO DE MILNE\n");
    printf("========================================\n");

    h = 0.05;

    % MILNE UTILIZA LOS CUATRO PRIMEROS VALORES
    % OBTENIDOS CON EULER MODIFICADO

    derivada = zeros(1,length(x_milne));

    for i = 1:4
        derivada(i) = f(x_milne(i),y_milne(i));
    end

    tic;

    % CALCULAR y(0.20) E y(0.25)
    for i = 4:5

        x_milne(i+1) = x_milne(i)+h;

        % PREDICTOR DE MILNE
        y_pred = y_milne(i-3)+(4*h/3)* ...
                 (2*derivada(i-2) ...
                 -derivada(i-1) ...
                 +2*derivada(i));

        % CORRECTOR DE MILNE-SIMPSON
        y_ant = y_pred;
        error_est = Inf;
        iter = 0;

        while error_est >= tol && iter < max_iter

            iter = iter+1;

            y_corr = y_milne(i-1)+(h/3)* ...
                     (derivada(i-1) ...
                     +4*derivada(i) ...
                     +f(x_milne(i+1),y_ant));

            error_est = abs(y_corr-y_ant);
            y_ant = y_corr;

        end

        if error_est >= tol
            error("Milne no alcanzo la tolerancia.");
        end

        y_milne(i+1) = y_corr;
        derivada(i+1) = f(x_milne(i+1),y_milne(i+1));

        printf("\nResultado para x = %.2f\n",x_milne(i+1));
        printf("Predictor: %.8f\n",y_pred);
        printf("Corrector: %.8f\n",y_corr);
        printf("Correcciones: %d\n",iter);

    end

    tiempo_milne = toc;

    % ==========================================
    % INCISO C - CALCULO DE ERRORES
    % ==========================================

    printf("\n========================================\n");
    printf(" INCISO C - ERRORES DEL METODO DE MILNE\n");
    printf("========================================\n");

    printf("    x        Aproximada       Exacta       Error Abs.    Error Rel. %%\n");

    for i = 5:6

        valor_exacto = exacta(x_milne(i));
        error_abs = abs(valor_exacto-y_milne(i));
        error_rel = (error_abs/abs(valor_exacto))*100;

        printf("%7.4f    %12.8f    %12.8f    %11.8f    %10.6f\n", ...
               x_milne(i),y_milne(i),valor_exacto,error_abs,error_rel);

    end

    % ==========================================
    % RESULTADOS FINALES
    % ==========================================

    printf("\n========================================\n");
    printf(" RESULTADOS FINALES\n");
    printf("========================================\n");

    printf("Milne y(0.20) = %.8f\n",y_milne(5));
    printf("Milne y(0.25) = %.8f\n",y_milne(6));

    printf("\nValores exactos:\n");
    printf("y(0.20) = %.8f\n",exacta(0.20));
    printf("y(0.25) = %.8f\n",exacta(0.25));

    printf("\nTiempo de ejecucion Milne: %.8f segundos\n",tiempo_milne);

    printf("\nCONCLUSION:\n");
    printf("Euler Modificado permitio obtener los valores iniciales.\n");
    printf("El metodo de Milne utilizo esos valores para continuar\n");
    printf("la aproximacion en x = 0.20 y x = 0.25.\n");
    printf("La solucion exacta permitio calcular los errores reales.\n");
    printf("Se compararon dos tamanos de paso para Euler Modificado.\n");

end
