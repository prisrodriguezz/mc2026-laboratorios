
function punto4()

    clc;

    printf("========================\n");
    printf(" RESOLUCION EJERCICIO 4 \n");
    printf("========================\n");

    % =====================================================
    % INGRESO DE DATOS
    % =====================================================

    fprintf('\nIngrese los datos experimentales.\n');

    x = input('Ingrese el vector de temperaturas: ');
    y = input('Ingrese el vector de densidades: ');

    % Convertir los vectores a filas
    x = x(:)';
    y = y(:)';

    % Determinar dimensiones
    [~, nx] = size(x);
    [~, ny] = size(y);

    % Validar los datos ingresados
    if nx ~= ny || nx < 4
        error('Se requieren al menos 4 puntos y vectores de igual longitud.');
    end

    if ~isnumeric(x) || ~isnumeric(y) || ...
       ~isreal(x) || ~isreal(y) || ...
       any(~isfinite(x)) || any(~isfinite(y))
        error('Todos los datos deben ser numeros reales y finitos.');
    end

    if any(diff(x) <= 0)
        error('Las temperaturas deben ser distintas y crecientes.');
    end

    x_buscado = input('Ingrese la temperatura a interpolar: ');

    if ~isnumeric(x_buscado) || ~isreal(x_buscado) || ...
       ~isscalar(x_buscado) || ~isfinite(x_buscado)
        error('La temperatura buscada debe ser un numero real finito.');
    end

    fprintf('\nDatos tabulares cargados:\n');
    fprintf('Temperatura | Densidad\n');
    disp([x', y']);

    fprintf('\nCantidad de puntos: %d\n', nx);

    % =====================================================
    % INCISO A - METODO DE LAGRANGE
    % =====================================================

    fprintf('\nPulsar "Enter" para aplicar Lagrange...\n');
    pause;

    printf("\n-------------------------------------------------------\n");
    printf("a. INTERPOLACION MEDIANTE LAGRANGE\n");
    printf("-------------------------------------------------------\n");

    [y_lagrange, tiempo_lagrange] = ...
        metodo_lagrange(x, y, x_buscado);

    fprintf('\nTemperatura: %.2f\n', x_buscado);
    fprintf('Densidad interpolada: %.8f\n', y_lagrange);
    fprintf('Tiempo: %.8f segundos\n', tiempo_lagrange);

    % =====================================================
    % INCISO B - INTERPOLACION PARABOLICA PROGRESIVA
    % =====================================================

    fprintf('\nPulsar "Enter" para aplicar interpolacion parabolica...\n');
    pause;

    printf("\n-------------------------------------------------------\n");
    printf("b. INTERPOLACION PARABOLICA PROGRESIVA\n");
    printf("-------------------------------------------------------\n");

    % Seleccionamos los primeros tres puntos
    x_par = x(1:3);
    y_par = y(1:3);

    [y_parabolica, tiempo_parabolica] = ...
        interpolacion_parabolica(x_par, y_par, x_buscado);

    fprintf('\nPuntos utilizados:\n');
    disp([x_par', y_par']);

    fprintf('\nDensidad interpolada: %.8f\n', y_parabolica);
    fprintf('Tiempo: %.8f segundos\n', tiempo_parabolica);

    % =====================================================
    % COMPARACION DE LOS METODOS
    % =====================================================

    diferencia_abs = abs(y_lagrange - y_parabolica);

    if y_lagrange ~= 0
        diferencia_rel = ...
            (diferencia_abs / abs(y_lagrange)) * 100;
    else
        diferencia_rel = NaN;
    end

    fprintf('\nComparacion entre ambos metodos:\n');
    fprintf('Diferencia absoluta: %.8f\n', diferencia_abs);
    fprintf('Diferencia relativa: %.6f %%\n', diferencia_rel);

    % =====================================================
    % ESTIMACION DEL ERROR
    % =====================================================

    % Primer termino omitido del polinomio cuadratico
    error_estimado = estimar_error( ...
        x(1:4), y(1:4), x_buscado);

    fprintf('\nEstimacion del error de interpolacion:\n');
    fprintf('Primer termino omitido: %.8f\n', error_estimado);

    % =====================================================
    % PRUEBA ADICIONAL - POLINOMIO CUBICO
    % =====================================================

    fprintf('\nPulsar "Enter" para comparar con cuatro puntos...\n');
    pause;

    printf("\n-------------------------------------------------------\n");
    printf(" PRUEBA ADICIONAL - POLINOMIO CUBICO DE NEWTON\n");
    printf("-------------------------------------------------------\n");

    % Incorporar un cuarto punto mediante el termino cubico
    termino_cubico = termino_newton_3( ...
        x(1:4), y(1:4), x_buscado);

    y_cubica = y_parabolica + termino_cubico;

    diferencia_grados = abs(y_cubica - y_parabolica);

    fprintf('\nParabolica (3 puntos): %.8f\n', y_parabolica);
    fprintf('Cubica (4 puntos):     %.8f\n', y_cubica);
    fprintf('Diferencia absoluta:   %.8f\n', diferencia_grados);

    % =====================================================
    % INCISO C - RESULTADOS Y CONCLUSIONES
    % =====================================================

    fprintf('\nPulsar "Enter" para ver las conclusiones...\n');
    pause;

    printf("\n======================================================\n");
    printf("                 RESULTADOS FINALES\n");
    printf("======================================================\n");

    fprintf('\nINCISO A - LAGRANGE:\n');
    fprintf('- Densidad: %.8f\n', y_lagrange);
    fprintf('- Tiempo: %.8f segundos\n', tiempo_lagrange);

    fprintf('\nINCISO B - PARABOLICA PROGRESIVA:\n');
    fprintf('- Densidad: %.8f\n', y_parabolica);
    fprintf('- Tiempo: %.8f segundos\n', tiempo_parabolica);

    fprintf('\nCOMPARACION ENTRE METODOS:\n');
    fprintf('- Diferencia absoluta: %.8f\n', diferencia_abs);
    fprintf('- Diferencia relativa: %.6f %%\n', diferencia_rel);

    fprintf('\nESTIMACION DEL ERROR:\n');
    fprintf('- Primer termino omitido: %.8f\n', error_estimado);

    fprintf('\nPRUEBA ADICIONAL CON CUATRO PUNTOS:\n');
    fprintf('- Aproximacion cubica: %.8f\n', y_cubica);
    fprintf('- Cambio respecto a parabolica: %.8f\n', diferencia_grados);

    printf("======================================================\n");

    fprintf('\nCONCLUSION:\n');
    fprintf('Ambos metodos permiten estimar la densidad\n');
    fprintf('correspondiente a la temperatura solicitada.\n');
    fprintf('Lagrange utiliza todos los puntos disponibles,\n');
    fprintf('mientras que la parabolica utiliza tres.\n');
    fprintf('Se compararon las aproximaciones y el efecto\n');
    fprintf('de incorporar un cuarto punto al polinomio de Newton.\n');
    fprintf('El primer termino omitido no representa\n');
    fprintf('necesariamente el error verdadero de interpolacion.\n');

end


% =========================================================
% FUNCION AUXILIAR - METODO DE LAGRANGE
% =========================================================

function [y_interp, tiempo] = metodo_lagrange(x, y, x_buscado)

    tic;

    n = length(x);
    y_interp = 0;

    for i = 1:n

        L_i = 1;

        for j = 1:n

            if i ~= j
                L_i = L_i * ...
                    (x_buscado - x(j)) / (x(i) - x(j));
            end

        end

        y_interp = y_interp + y(i) * L_i;

    end

    tiempo = toc;

end


% =========================================================
% FUNCION AUXILIAR - INTERPOLACION PARABOLICA
% =========================================================

function [y_interp, tiempo] = ...
    interpolacion_parabolica(x, y, x_buscado)

    tic;

    % Primeras diferencias divididas
    d01 = (y(2) - y(1)) / (x(2) - x(1));
    d12 = (y(3) - y(2)) / (x(3) - x(2));

    % Segunda diferencia dividida
    d012 = (d12 - d01) / (x(3) - x(1));

    % Polinomio de segundo grado
    y_interp = y(1) + ...
        d01 * (x_buscado - x(1)) + ...
        d012 * (x_buscado - x(1)) * ...
        (x_buscado - x(2));

    tiempo = toc;

end


% =========================================================
% FUNCION AUXILIAR - TERMINO CUBICO DE NEWTON
% =========================================================

function termino = termino_newton_3(x, y, x_buscado)

    % Primeras diferencias divididas
    d01 = (y(2) - y(1)) / (x(2) - x(1));
    d12 = (y(3) - y(2)) / (x(3) - x(2));
    d23 = (y(4) - y(3)) / (x(4) - x(3));

    % Segundas diferencias divididas
    d012 = (d12 - d01) / (x(3) - x(1));
    d123 = (d23 - d12) / (x(4) - x(2));

    % Tercera diferencia dividida
    d0123 = (d123 - d012) / (x(4) - x(1));

    % Termino de tercer grado
    termino = d0123 * ...
        (x_buscado - x(1)) * ...
        (x_buscado - x(2)) * ...
        (x_buscado - x(3));

end


% =========================================================
% FUNCION AUXILIAR - ESTIMACION DEL ERROR
% =========================================================

function error_estimado = estimar_error(x, y, x_buscado)

    termino = termino_newton_3(x, y, x_buscado);

    error_estimado = abs(termino);

end
