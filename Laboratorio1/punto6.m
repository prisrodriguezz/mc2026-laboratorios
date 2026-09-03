clc;
clear;

digitos = input("Ingrese la cantidad de digitos decimales exactos: ");

% Cota de error (por redondeo)
tolerancia = 0.5*10^(-digitos);

suma = 0;
i = 0;
error = Inf;

printf("\nDesarrollo de la serie:\n");

tic;

while error >= tolerancia

    termino = ((-1)^i) / (2*i + 1);

    suma = suma + termino;

    pi_aprox = 4 * suma;

    error = abs(pi - pi_aprox);

    % Mostrar solo los primeros 10 terminos en forma de fraccion
    if i < 10

        if i == 0
            printf("Termino %d: Pi = 4 * (1)\n", i + 1);

        elseif mod(i,2) == 1
            printf("Termino %d: se agrega - 1/%d\n", ...
                   i + 1, 2*i + 1);

        else
            printf("Termino %d: se agrega + 1/%d\n", ...
                   i + 1, 2*i + 1);
        end

    end

    i = i + 1;

end

tiempo = toc;

printf("\nSerie utilizada:\n");
printf("Pi = 4 * (1 - 1/3 + 1/5 - 1/7 + 1/9 - ...)\n");

printf("\n--- RESULTADO FINAL ---\n");
printf("Cantidad de digitos: %d\n", digitos);
printf("Cantidad de terminos necesarios: %d\n", i);
printf("Pi aproximado: %.15f\n", pi_aprox);
printf("Pi de referencia: %.15f\n", pi);

printf("\n--- CRITERIO DE PARADA ---\n");
printf("Tolerancia fijada:              %.8e\n", tolerancia);
printf("Error absoluto final:           %.8e\n", error);
printf("Margen de parada (Tol - Error): %.8e\n", tolerancia - error);
printf("\nTiempo de ejecucion:            %.6f segundos\n", tiempo);