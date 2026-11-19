
function punto4()

    clc;

    printf("========================================\n");
    printf(" EJERCICIO 4 - METODO DE EULER\n");
    printf("========================================\n");

    % DATOS DEL PROBLEMA
    k = 0.06;
    y0 = 3;
    h = 0.5;
    t0 = 0;

    printf("\nDatos del problema:\n");
    printf("Constante k: %.4f\n", k);
    printf("Altura inicial: %.4f metros\n", y0);
    printf("Paso h: %.4f minutos\n", h);

    % ECUACION DIFERENCIAL
    f = @(t,y) -k * sqrt(y);

    % INICIALIZACION
    t = t0;
    y = y0;
    iter = 0;

    printf("\n----------------------------------------\n");
    printf(" TABLA DE RESULTADOS - EULER\n");
    printf("----------------------------------------\n");

    printf("Iteracion     Tiempo       Altura       Derivada\n");
    printf("%5d       %8.4f     %9.6f    %10.6f\n", ...
           iter, t, y, f(t,y));

    tic;

    while y > 0

        % METODO DE EULER
        pendiente = f(t,y);
        y_nuevo = y + h * pendiente;
        t_nuevo = t + h;

        iter = iter + 1;

        % EVITAR ALTURAS NEGATIVAS
        if y_nuevo <= 0
            break;
        end

        t = t_nuevo;
        y = y_nuevo;

        printf("%5d       %8.4f     %9.6f    %10.6f\n", ...
               iter, t, y, f(t,y));

    end

    tiempo_ejecucion = toc;

    % ESTIMACION DEL INSTANTE DE VACIADO
    % Se interpola dentro del ultimo paso de Euler.
    tiempo_vaciado = t + y / (-pendiente);

    printf("\n========================================\n");
    printf(" RESULTADOS FINALES\n");
    printf("========================================\n");

    printf("Ultima altura positiva: %.8f metros\n", y);
    printf("Ultimo tiempo positivo: %.4f minutos\n", t);
    printf("Primer nodo de Euler con altura no positiva: %.4f minutos\n", t_nuevo);
    printf("Tiempo estimado de vaciado: %.6f minutos\n", tiempo_vaciado);
    printf("Iteraciones realizadas: %d\n", iter);
    printf("Tiempo de ejecucion: %.8f segundos\n", tiempo_ejecucion);

    printf("\nCONCLUSION:\n");
    printf("El nivel de agua disminuye progresivamente.\n");
    printf("La velocidad de vaciado disminuye cuando baja la altura.\n");
    printf("Euler aproxima el comportamiento mediante pasos de 0.5 minutos.\n");

end
