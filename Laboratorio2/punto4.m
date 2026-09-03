function punto4()

    clc;
    clear;

    % ==========================================
    % DATOS
    % ==========================================

    a = 1;
    b = 62.10;
    c = 1;

    x1_exacto = -0.01610723;
    x2_exacto = -62.08390;

    % ==========================================
    % a) FORMULA CUADRATICA CON REDONDEO A 4 CIFRAS
    % ==========================================

    b2 = redondear4(b * b);
    cuatro_ac = redondear4(4 * a * c);
    discriminante = redondear4(b2 - cuatro_ac);
    raiz_discriminante = redondear4(sqrt(discriminante));

    numerador_x1 = redondear4(-b + raiz_discriminante);
    denominador = redondear4(2 * a);
    x1_aprox = redondear4(numerador_x1 / denominador);

    numerador_x2 = redondear4(-b - raiz_discriminante);
    x2_aprox = redondear4(numerador_x2 / denominador);

    [error_abs_x1, error_rel_x1] = calcularErrores(x1_exacto, x1_aprox);
    [error_abs_x2, error_rel_x2] = calcularErrores(x2_exacto, x2_aprox);

    fprintf("\n==========================================\n");
    fprintf("PUNTO 4.a - FORMULA CUADRATICA\n");
    fprintf("==========================================\n");

    fprintf("\nb^2:                 %.10f\n", b2);
    fprintf("4ac:                 %.10f\n", cuatro_ac);
    fprintf("Discriminante:       %.10f\n", discriminante);
    fprintf("Raiz discriminante:  %.10f\n", raiz_discriminante);

    fprintf("\nRaiz x1\n");
    fprintf("Valor exacto:        %.8f\n", x1_exacto);
    fprintf("Valor aproximado:    %.8f\n", x1_aprox);
    fprintf("Error absoluto:      %.8f\n", error_abs_x1);
    fprintf("Error relativo:      %.8f\n", error_rel_x1);

    fprintf("\nRaiz x2\n");
    fprintf("Valor exacto:        %.8f\n", x2_exacto);
    fprintf("Valor aproximado:    %.8f\n", x2_aprox);
    fprintf("Error absoluto:      %.8f\n", error_abs_x2);
    fprintf("Error relativo:      %.8f\n", error_rel_x2);


    % ==========================================
    % b) FORMULAS RACIONALIZADAS
    % ==========================================

    denominador_x1_alt = redondear4(b + raiz_discriminante);
    numerador_alt = redondear4(-2 * c);
    x1_alt = redondear4(numerador_alt / denominador_x1_alt);

    denominador_x2_alt = redondear4(b - raiz_discriminante);
    x2_alt = redondear4(numerador_alt / denominador_x2_alt);

    [error_abs_x1_alt, error_rel_x1_alt] = calcularErrores(x1_exacto, x1_alt);
    [error_abs_x2_alt, error_rel_x2_alt] = calcularErrores(x2_exacto, x2_alt);

    fprintf("\n==========================================\n");
    fprintf("PUNTO 4.b - FORMULAS RACIONALIZADAS\n");
    fprintf("==========================================\n");

    fprintf("\nRaiz x1 racionalizada\n");
    fprintf("Valor exacto:        %.8f\n", x1_exacto);
    fprintf("Valor aproximado:    %.8f\n", x1_alt);
    fprintf("Error absoluto:      %.8f\n", error_abs_x1_alt);
    fprintf("Error relativo:      %.8f\n", error_rel_x1_alt);

    fprintf("\nRaiz x2 racionalizada\n");
    fprintf("Valor exacto:        %.8f\n", x2_exacto);
    fprintf("Valor aproximado:    %.8f\n", x2_alt);
    fprintf("Error absoluto:      %.8f\n", error_abs_x2_alt);
    fprintf("Error relativo:      %.8f\n", error_rel_x2_alt);

endfunction


% ==========================================
% REDONDEO A 4 CIFRAS SIGNIFICATIVAS
% ==========================================

function y = redondear4(x)

    if x == 0
        y = 0;
        return;
    endif

    exponente = floor(log10(abs(x)));
    factor = 10^(3 - exponente);

    y = round(x * factor) / factor;

endfunction


% ==========================================
% CALCULO DE ERRORES
% ==========================================

function [error_abs, error_rel] = calcularErrores(v_exacto, v_aprox)

    error_abs = abs(v_exacto - v_aprox);
    error_rel = error_abs / abs(v_exacto);

endfunction