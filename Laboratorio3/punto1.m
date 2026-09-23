function punto1()

    clc;
    clear;

    printf("============================================\n");
    printf("    RESOLUCION PUNTO 1 - TANQUE ESFERICO\n");
    printf("============================================\n");

    % Definicion de los parametros
    R = 3;
    V = 30;

    % Evaluar la ecuacion f(h) = 0
    % Ecuacion original: V = pi * h^2 (3R - h) / 3
    % igualada a cero: pi * h^2 * (9 - h) / 3 - 30 = 0
    f = @(h) pi * (h.^2) .* (9 - h) / 3 - 30;         % Funcion  anonima 

    % =============================================
    % a. Evaluar graficamente utilizando 'fplot'
    % =============================================

    fprintf('Generando grafico de la funcion...\n');
    figure(1);
    fplot(f, [-2, 8]);
    grid on;
    title('Volumen del tanque: f(h) = \pi h^2 (9 - h) / 3 - 30');
    xlabel('Profundidad h (metros)');
    ylabel('f(h)');

    fprintf('Grafico generado. Observar donde la curva cruza el eje horizontal (y = 0)\n');
    fprintf('Pulsar "enter" para continuar con el Metodo de tanteos.\n')
    pause;

    % ==================================================
    % b. Separar las raices aplicando Metodo de tanteos
    % ==================================================

    printf("\n\n--------------------------------------------\n");
    printf("b. METODO DE TANTEO\n");
    printf("--------------------------------------------\n");

    a_tanteo = input('Ingrese el valor inicial para evaluar (ej. 0): ');
    b_tanteo = input('Ingrese el valor final para evaluar (ej. 4): ');
    inc = input('Ingrese el valor del incremento (ej. 0.5): ');

    % Obtenemos la lista de intervalos
    lista_intervalos = metodo_tanteo(f, a_tanteo, b_tanteo, inc);

    if isempty(lista_intervalos)
        fprintf('\nNo hay intervalos para analizar.\n');
        return;
    end

    % Se muestran los intervalos encontrados
    fprintf('\n------------------------------------------------------\n');
    fprintf(' SELECCION DE INTERVALO PARA LOS METODOS SIGUIENTES\n');
    fprintf('------------------------------------------------------\n');
    num_opciones = size(lista_intervalos, 1);
    
    for i = 1:num_opciones
        fprintf('  [%d] Intervalo: [%.2f, %.2f]\n', i, lista_intervalos(i, 1), lista_intervalos(i, 2));
    end
    
    opcion = input('Ingrese el numero de opcion del intervalo que desea utilizar: ');
    
    if opcion < 1 || opcion > num_opciones
        fprintf('Opcion invalida. Se seleccionara por defecto la primera opcion.\n');
        opcion = 1;
    end
    
    % Asignamos los limites elegidos para los puntos c y d
    a = lista_intervalos(opcion, 1);
    b = lista_intervalos(opcion, 2);
    
    fprintf('\nHas seleccionado el intervalo: [%.2f, %.2f]\n', a, b);
    fprintf('Pulsar "Enter" para continuar con los siguientes metodos...\n');
    pause;

    % ====================================================================
    % c y d. Aplicar metodo Int. Medio e Int. Lineal, analizar resultados
    % ====================================================================

    printf("\n\n-------------------------------------------------------\n");
    printf("c y d. METODO DE INTERVALO MEDIO E INTERPOLACION LINEAL\n");
    printf("-------------------------------------------------------\n");

    tol = 0.001; % Cota de error E < 0.001

    % Intervalo medio
    [raiz_im, iter_im, tiempo_im] = metodo_intervalo_medio(f, a, b, tol);

    % Interpolacion lineal
    [raiz_il, iter_il, tiempo_il] = metodo_interpolacion_lineal(f, a, b, tol);

    fprintf('======================================================\n');
    fprintf('                 RESULTADOS FINALES                   \n');
    fprintf('======================================================\n');
    fprintf('Intervalo analizado: [%.2f, %.2f]\n', a, b);
    fprintf('Cota de error utilizada: E < %.4f\n\n', tol);

    fprintf('METODO INTERVALO MEDIO:\n');
    fprintf('- Raiz aproximada (Profundidad h): %.5f metros\n', raiz_im);
    fprintf('- Iteraciones necesarias: %d\n', iter_im);
    fprintf('- Tiempo de ejecucion: %f segundos\n\n', tiempo_im);
    
    fprintf('METODO INTERPOLACION LINEAL:\n');
    fprintf('- Raiz aproximada (Profundidad h): %.5f metros\n', raiz_il);
    fprintf('- Iteraciones necesarias: %d\n', iter_il);
    fprintf('- Tiempo de ejecucion: %f segundos\n', tiempo_il);
    fprintf('======================================================\n');

end


% =========================================================
% FUNCIONES
% =========================================================

% Retorna una lista de intervalos
function intervalos = metodo_tanteo(f, a, b, inc)
    x1 = a;
    x2 = a + inc;
    intervalos = []; % Matriz vacia para ir guardando los intervalos

    fprintf('\nBusqueda por tanteo desde %.2f hasta %.2f con incremento de %.2f\n', a, b, inc);

    while x1 < b
        % Nos aseguramos de no pasar el limite superior
        if x2 > b
            x2 = b
        end

        if f(x1) * f(x2) < 0
            fprintf('--> Cambio de signo detectado en el intervalo [%.2f, %.2f]\n', x1, x2);
            
            % Agregamos el intervalo encontrado como una nueva fila en la matriz
            intervalos = [intervalos; x1, x2];

        elseif f(x1) == 0
            fprintf('--> Raiz exacta encontrada en x = %.2f\n', x1);
            intervalos = [intervalos; x1, x1];

        end

        x1 = x2;
        x2 = x2 + inc;
    end

    if isempty(intervalos) % isempty verifica si la lista esta vacia
        disp('No se encontraron raices en el intervalo dado con ese incremento.');
    end
end

function [raiz, iter, tiempo] = metodo_intervalo_medio(f, a, b, tol)
    tic; % Medicion del tiempo
    iter = 0;
    c_viejo = 0; % Para guardar la aprox. de la iteracion previa

    while true
        iter = iter + 1;

        % Calcular el punto medio actual
        c = (a + b) / 2;

        % Evaluar criterio de parada (se evalua a partir de la 2da iteracion)
        if iter > 1 && abs(c - c_viejo) < tol
            raiz = c;
            break;
        end

        % Si se encuentra la raiz exacta
        if f(c) == 0
            raiz = c;
            break;
        end

        % Seleccionar nuevo subintervalo (segun el cambio de signo)
        if f(a) * f(c) < 0
            b = c;
        else
            a = c;
        end

        c_viejo = c; % Se guarda la aprox. actual antes de pasar a la sig iteracion
    end
    
    tiempo = toc; % Guardar medicion del tiempo
end

function [raiz, iter, tiempo] = metodo_interpolacion_lineal(f, a, b, tol)
    tic;
    iter = 0;
    c_viejo = a;

    while true
        iter = iter + 1;

        % Formula de interpolacion lineal
        c = b - (f(b) * (a - b)) / (f(a) - f(b));

        % Criterio de parada
        if abs(c - c_viejo) < tol || f(c) == 0
            raiz = c;
            break;
        end

        c_viejo = c;

        % Reasignar intervalos
        if f(a) * f(c) < 0
            b = c;
        else
            a = c;
        end
    end

    tiempo = toc;
end