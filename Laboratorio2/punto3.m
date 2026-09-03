function punto3()

    clc;
    clear;

    % ==========================================
    % a. 133 + 0.921
    % ==========================================

    v_aprox = sumar(133, 0.921);
    v_exacto = 133 + 0.921;

    [error_abs, error_rel] = calcularErrores(v_exacto, v_aprox);

    fprintf("\na. 133 + 0.921\n");
    fprintf("Valor exacto:      %.5f\n", v_exacto);
    fprintf("Valor aproximado:  %.5f\n", v_aprox);
    fprintf("Error absoluto:    %.5f\n", error_abs);
    fprintf("Error relativo:    %.5f\n", error_rel);


    % ==========================================
    % b. 133 - 0.499
    % ==========================================

    v_aprox = restar(133, 0.499);
    v_exacto = 133 - 0.499;

    [error_abs, error_rel] = calcularErrores(v_exacto, v_aprox);

    fprintf("\nb. 133 - 0.499\n");
    fprintf("Valor exacto:      %.5f\n", v_exacto);
    fprintf("Valor aproximado:  %.5f\n", v_aprox);
    fprintf("Error absoluto:    %.5f\n", error_abs);
    fprintf("Error relativo:    %.5f\n", error_rel);


    % ==========================================
    % c. (121 - 119) - 0.327
    % ==========================================

    primero = restar(121, 119);
    v_aprox = restar(primero, 0.327);

    v_exacto = (121 - 119) - 0.327;

    [error_abs, error_rel] = calcularErrores(v_exacto, v_aprox);

    fprintf("\nc. (121 - 119) - 0.327\n");
    fprintf("Valor exacto:      %.5f\n", v_exacto);
    fprintf("Valor aproximado:  %.5f\n", v_aprox);
    fprintf("Error absoluto:    %.5f\n", error_abs);
    fprintf("Error relativo:    %.5f\n", error_rel);


    % ==========================================
    % d. (121 - 0.327) - 119
    % ==========================================

    primero = restar(121, 0.327);
    v_aprox = restar(primero, 119);

    v_exacto = (121 - 0.327) - 119;

    [error_abs, error_rel] = calcularErrores(v_exacto, v_aprox);

    fprintf("\nd. (121 - 0.327) - 119\n");
    fprintf("Valor exacto:      %.5f\n", v_exacto);
    fprintf("Valor aproximado:  %.5f\n", v_aprox);
    fprintf("Error absoluto:    %.5f\n", error_abs);
    fprintf("Error relativo:    %.5f\n", error_rel);


    % ==========================================
    % e. (2/9) * (9/7)
    % ==========================================

    resultado1 = dividir(2, 9);
    resultado2 = dividir(9, 7);

    v_aprox = multiplicar(resultado1, resultado2);

    v_exacto = (2 / 9) * (9 / 7);

    [error_abs, error_rel] = calcularErrores(v_exacto, v_aprox);

    fprintf("\ne. (2/9) * (9/7)\n");
    fprintf("Valor exacto:      %.5f\n", v_exacto);
    fprintf("Valor aproximado:  %.5f\n", v_aprox);
    fprintf("Error absoluto:    %.5f\n", error_abs);
    fprintf("Error relativo:    %.5f\n", error_rel);

endfunction



% ==========================================
% FUNCIONES
% ==========================================

function [mant, exp] = normalizar(x)

    if x == 0
        mant = 0;
        exp = 0;
        return;
    endif

    % Obtener exponente
    exp = floor(log10(abs(x))) + 1;

    % Obtener mantisa normalizada
    mant = x / 10^exp;

    % Truncar mantisa a 3 digitos
    mant = fix(mant * 1000) / 1000;

endfunction


function resultado = sumar(a, b)

    [mant_a, exp_a] = normalizar(a);
    [mant_b, exp_b] = normalizar(b);

    % Igualar exponentes
    if exp_a > exp_b
        mant_b = mant_b * 10^(exp_b - exp_a);
        exp_resultado = exp_a;

    elseif exp_b > exp_a
        mant_a = mant_a * 10^(exp_a - exp_b);
        exp_resultado = exp_b;

    else
        exp_resultado = exp_a;
    endif

    % Realizar suma
    mant_suma = mant_a + mant_b;

    % Truncar resultado a 3 digitos
    mant_suma = fix(mant_suma * 1000) / 1000;

    resultado = mant_suma * 10^exp_resultado;

endfunction


function resultado = restar(a, b)

    [mant_a, exp_a] = normalizar(a);
    [mant_b, exp_b] = normalizar(b);

    % Igualar exponentes
    if exp_a > exp_b
        mant_b = mant_b * 10^(exp_b - exp_a);
        exp_resultado = exp_a;

    elseif exp_b > exp_a
        mant_a = mant_a * 10^(exp_a - exp_b);
        exp_resultado = exp_b;

    else
        exp_resultado = exp_a;
    endif

    % Realizar resta
    mant_resta = mant_a - mant_b;

    % Truncar resultado
    mant_resta = fix(mant_resta * 1000) / 1000;

    % Normalizar nuevamente
    if mant_resta != 0

        exp_resta = floor(log10(abs(mant_resta))) + 1;

        mant_resta = mant_resta / 10^exp_resta;

        exp_resultado = exp_resultado + exp_resta;

        % Truncar nuevamente
        mant_resta = fix(mant_resta * 1000) / 1000;

    endif

    resultado = mant_resta * 10^exp_resultado;

endfunction


function resultado = multiplicar(a, b)

    [mant_a, exp_a] = normalizar(a);
    [mant_b, exp_b] = normalizar(b);

    % Multiplicar mantisas
    mant_mult = mant_a * mant_b;

    % Sumar exponentes
    exp_resultado = exp_a + exp_b;

    % Normalizar y truncar resultado
    [mant_resultado, exp_resultado_mant] = normalizar(mant_mult);

    exp_resultado = exp_resultado + exp_resultado_mant;

    resultado = mant_resultado * 10^exp_resultado;

endfunction


function resultado = dividir(a, b)

    [mant_a, exp_a] = normalizar(a);
    [mant_b, exp_b] = normalizar(b);

    % Dividir mantisas
    mant_div = mant_a / mant_b;

    % Restar exponentes
    exp_resultado = exp_a - exp_b;

    % Normalizar y truncar resultado
    [mant_resultado, exp_resultado_mant] = normalizar(mant_div);

    exp_resultado = exp_resultado + exp_resultado_mant;

    resultado = mant_resultado * 10^exp_resultado;

endfunction


function [error_abs, error_rel] = calcularErrores(v_exacto, v_aprox)

    error_abs = abs(v_exacto - v_aprox);

    error_rel = error_abs / abs(v_exacto);

endfunction