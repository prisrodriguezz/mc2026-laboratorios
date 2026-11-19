
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

    % VECTORES DE RESULTADOS
    x = zeros(1,6);
    y = NaN(1,6);
    derivada = NaN(1,6);

    x(1) = x0;
    y(1) = y0;
    derivada(1) = f(x0,y0);

    tic;

    % =========================================
    % VALORES INICIALES CON RUNGE-KUTTA 2
    % =========================================

    printf("\nTABLA INICIAL - RUNGE KUTTA 2\n");
    printf("----------------------------------------\n");

    for i = 1:3

        k1 = f(x(i),y(i));

        k2 = f(x(i)+h,y(i)+h*k1);

        x(i+1) = x(i)+h;

        y(i+1) = y(i)+(h/2)*(k1+k2);

        derivada(i+1) = f(x(i+1),y(i+1));

    end

    printf("    x           y            y'\n");

    for i = 1:4
        printf("%8.4f    %12.8f    %12.8f\n", ...
               x(i),y(i),derivada(i));
    end

    % =========================================
    % METODO DE MILNE
    % =========================================

    printf("\n----------------------------------------\n");
    printf(" METODO DE MILNE\n");
    printf("----------------------------------------\n");

    for i = 4:5

        x(i+1) = x(i)+h;

        % FORMULA PREDICTORA DE MILNE
        y_pred = y(i-3)+(4*h/3)* ...
                 (2*derivada(i-2) ...
                 -derivada(i-1) ...
                 +2*derivada(i));

        printf("\nResultado para x = %.2f\n",x(i+1));
        printf("Valor predictor: %.8f\n",y_pred);

        % VERIFICAR EL PREDICTOR
        if ~isfinite(y_pred)

            printf("El predictor no es finito.\n");
            printf("No se puede continuar el metodo.\n");

            break;

        end

        % FORMULA CORRECTORA DE MILNE-SIMPSON
        y_ant = y_pred;
        error_est = Inf;
        iter = 0;
        convergio = false;
        y_corr = NaN;

        while iter < max_iter

            iter = iter+1;

            y_corr = y(i-1)+(h/3)* ...
                     (derivada(i-1) ...
                     +4*derivada(i) ...
                     +f(x(i+1),y_ant));

            % CONTROLAR RESULTADOS NO FINITOS
            if ~isfinite(y_corr)

                printf("Se obtuvo un valor no finito.\n");
                printf("Milne no converge en este punto.\n");

                break;

            end

            error_est = abs(y_corr-y_ant);

            if ~isfinite(error_est)

                printf("Error de correccion no definido.\n");
                break;

            end

            if error_est < tol

                convergio = true;
                break;

            end

            y_ant = y_corr;

        end

        % COMPROBAR CONVERGENCIA
        if ~convergio

            printf("No se obtuvo una solucion convergente.\n");
            printf("Correcciones realizadas: %d\n",iter);

            break;

        end

        % GUARDAR RESULTADO CORREGIDO
        y(i+1) = y_corr;

        derivada(i+1) = f(x(i+1),y(i+1));

        printf("Valor corregido: %.8f\n",y_corr);
        printf("Error de correccion: %.8f\n",error_est);
        printf("Cantidad de correcciones: %d\n",iter);

    end

    tiempo = toc;

    % =========================================
    % RESULTADOS FINALES
    % =========================================

    printf("\n========================================\n");
    printf(" TABLA FINAL DE RESULTADOS\n");
    printf("========================================\n");

    printf("    x           y            y'\n");

    for i = 1:6

        if isfinite(y(i)) && isfinite(derivada(i))

            printf("%8.4f    %12.8f    %12.8f\n", ...
                   x(i),y(i),derivada(i));

        else

            printf("%8.4f    Sin aproximacion valida\n",x(i));

        end

    end

    printf("\nRESULTADOS SOLICITADOS:\n");

    if isfinite(y(5))
        printf("y(0.8) = %.8f\n",y(5));
    else
        printf("y(0.8) = No se obtuvo aproximacion valida\n");
    end

    if isfinite(y(6))
        printf("y(1.0) = %.8f\n",y(6));
    else
        printf("y(1.0) = No se obtuvo aproximacion valida\n");
    end

    printf("\nTiempo de ejecucion: %.8f segundos\n",tiempo);

    printf("\nCONCLUSION:\n");
    printf("Se utilizaron los primeros cuatro valores obtenidos con RK2.\n");
    printf("Milne permitio continuar la aproximacion mediante\n");
    printf("un predictor y un corrector iterativo.\n");
    printf("Se verifico la convergencia de cada resultado.\n");

end
