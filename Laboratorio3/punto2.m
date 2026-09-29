function punto2 ()

    clc;
    clear;

    fprintf("============================================\n");
    fprintf("    RESOLUCION PUNTO 2 - PUNTO DE EQUILIBRIO\n");
    fprintf("============================================\n");

    % Definicion de la funcion y sus derivadas
    % P(x) = 8x + 0.3x^2 - 0.0013x^3 - 372
    f   = @(x) 8.*x + 0.3.*(x.^2) - 0.0013.*(x.^3) - 372;
    df  = @(x) 8 + 0.6.*x - 0.0039.*(x.^2);     % Primera derivada P'(x)
    d2f = @(x) 0.6 - 0.0078.*x;                 % Segunda derivada P''(x)

    % =============================================
    % a. Evaluar graficamente utilizando 'fplot'
    % =============================================

    fprintf('\nITEM 2.a: Generando grafico de la funcion...\n');
    figure(1);
    fplot(f, [0, 300]); % Rango amplio para visualizar ambas raices (cerca de 25 y 250)
    grid on;
    title('Utilidad: P(x) = 8x + 0.3x^2 - 0.0013x^3 - 372');
    xlabel('Cantidad de impresoras (x)');
    ylabel('Utilidad P(x)');

    fprintf('Grafico generado. Observar donde la curva cruza el eje horizontal (y = 0)\n');
    fprintf('Pulsar "Enter" para continuar con el item b.\n');
    pause;

    % ==================================================
    % b. Fourier y Newton Raphson
    % ==================================================

    fprintf("\n======================================================\n");
    fprintf(" ITEM 2.b: ANALISIS DE INTERVALOS Y NEWTON RAPHSON\n");
    fprintf("======================================================\n");

    continuar = 's';
    
    while lower(continuar) == 's'
        fprintf('\n---------------- CONDICION DE FOURIER ------------------\n');
        
        % Ingreso de datos por teclado
        a = input('Ingrese el limite inferior del intervalo (a): ');
        b = input('Ingrese el limite superior del intervalo (b): ');
        tol = input('Ingrese la cota de error deseada (ej. 0.001): ');
        
        % 1. Analizar convergencia (Fourier)
        x0 = evaluar_fourier(f, df, d2f, a, b);
        
        % Si Fourier falla, se asigna 'a' para intentar correr el algoritmo igual
        if isnan(x0)
            fprintf('\nADVERTENCIA: No se cumplen las condiciones de Fourier. El metodo podria no converger.\n');
            x0 = a; 
            fprintf('Se intentara utilizar x0 = %.2f por defecto.\n', x0);
        end
        
        % 2. Aplicar Newton Raphson
        fprintf('\n>>> Aplicar Metodo de Newton Raphson con x0 = %.2f\n', x0);
        [raiz, iter, tiempo] = metodo_newton_raphson(f, df, x0, tol);
        
        % 3. Mostrar resultados
        fprintf('\n======================================================\n');
        fprintf('                 RESULTADOS FINALES                   \n');
        fprintf('======================================================\n');
        fprintf('Intervalo analizado: [%.2f, %.2f]\n', a, b);
        fprintf('Punto inicial utilizado (x0): %.2f\n', x0);
        fprintf('Cota de error utilizada: E < %.4f\n\n', tol);

        fprintf('METODO NEWTON RAPHSON:\n');
        fprintf('- Raiz aproximada (Impresoras a producir): %.5f\n', raiz);
        fprintf('- Iteraciones necesarias: %d\n', iter);
        fprintf('- Tiempo de ejecucion: %f segundos\n', tiempo);
        fprintf('======================================================\n');
        
        % Preguntar si se desea continuar
        fprintf('\n------------------------------------------------------\n');
        continuar = input('¿Desea analizar otro intervalo o aplicar otra cota de error? (s/n): ', 's');
    end

end

% =========================================================
% FUNCIONES
% =========================================================

% Analizar convergencia
function x0 = evaluar_fourier(f, df, d2f, a, b)
    fprintf('\n\nEvaluando el intervalo [%.2f, %.2f]:\n', a, b);
    
    % Verificar que se cumpla f(a) * f(b) < 0 (La función cruza el eje x)
    if f(a) * f(b) < 0
        fprintf(' 1. f(a) * f(b) < 0      -> CUMPLE (Existe al menos una raíz)\n');
    else
        fprintf(' 1. f(a) * f(b) < 0      -> NO CUMPLE\n');
    end
    
    % Verificar que f'(x) no cambia de signo en el intervalo
    if df(a) * df(b) > 0
        fprintf(' 2. f''(x) constante de signo -> CUMPLE (Funcion monotona)\n');
    else
        fprintf(' 2. f''(x) constante de signo -> NO CUMPLE\n');
    end
    
    % Verificar que f''(x) no cambia de signo en el intervalo
    if d2f(a) * d2f(b) > 0
        fprintf(' 3. f''''(x) constante de signo -> CUMPLE (Concavidad constante)\n');
    else
        fprintf(' 3. f''''(x) constante de signo -> NO CUMPLE\n');
    end
    
    % Eleccion del punto inicial x0 tal que f(x0) * f''(x0) > 0
    x0 = NaN;
    if f(a) * d2f(a) > 0
        x0 = a;
        fprintf(' 4. f(x0) * f''''(x0) > 0  -> CUMPLE en el extremo x0 = %.2f\n', a);
    elseif f(b) * d2f(b) > 0
        x0 = b;
        fprintf(' 4. f(x0) * f''''(x0) > 0  -> CUMPLE utilizando el extremo x0 = %.2f\n', b);
    else
        fprintf(' 4. f(x0) * f''''(x0) > 0  -> NO CUMPLE para ninguno de los extremos.\n');
    end
end


function [raiz, iter, tiempo] = metodo_newton_raphson(f, df, x0, tol)
    tic; % Medicion de tiempo
    iter = 0;
    x_viejo = x0;
    
    while true
        iter = iter + 1;
        
        % Formula iterativa de Newton Raphson
        x_nuevo = x_viejo - f(x_viejo) / df(x_viejo);
        
        % Criterio de parada
        if abs(x_nuevo - x_viejo) < tol || f(x_nuevo) == 0
            raiz = x_nuevo;
            break;
        end
        
        x_viejo = x_nuevo;
    end
    
    tiempo = toc;
end