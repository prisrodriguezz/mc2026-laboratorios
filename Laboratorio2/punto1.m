function punto1()

    clc;
    clear;

    % ==========================================
    % a. p = pi ; p* = 22/7
    % ==========================================

    p = pi;
    p_aprox = 22/7;

    [error_abs, error_rel] = calcularErrores(p, p_aprox);

    fprintf("\na. p = pi ; p* = 22/7\n");
    fprintf("Valor verdadero:   %.15f\n", p);
    fprintf("Valor aproximado:  %.15f\n", p_aprox);
    fprintf("Error absoluto:    %.15f\n", error_abs);
    fprintf("Error relativo:    %.15f\n", error_rel);


    % ==========================================
    % b. p = pi ; p* = 3.1416
    % ==========================================

    p = pi;
    p_aprox = 3.1416;

    [error_abs, error_rel] = calcularErrores(p, p_aprox);

    fprintf("\nb. p = pi ; p* = 3.1416\n");
    fprintf("Valor verdadero:   %.15f\n", p);
    fprintf("Valor aproximado:  %.15f\n", p_aprox);
    fprintf("Error absoluto:    %.15f\n", error_abs);
    fprintf("Error relativo:    %.15f\n", error_rel);


    % ==========================================
    % c. p = e ; p* = 2.718
    % ==========================================

    p = exp(1);
    p_aprox = 2.718;

    [error_abs, error_rel] = calcularErrores(p, p_aprox);

    fprintf("\nc. p = e ; p* = 2.718\n");
    fprintf("Valor verdadero:   %.15f\n", p);
    fprintf("Valor aproximado:  %.15f\n", p_aprox);
    fprintf("Error absoluto:    %.15f\n", error_abs);
    fprintf("Error relativo:    %.15f\n", error_rel);


    % ==========================================
    % d. p = sqrt(2) ; p* = 1.414
    % ==========================================

    p = sqrt(2);
    p_aprox = 1.414;

    [error_abs, error_rel] = calcularErrores(p, p_aprox);

    fprintf("\nd. p = sqrt(2) ; p* = 1.414\n");
    fprintf("Valor verdadero:   %.15f\n", p);
    fprintf("Valor aproximado:  %.15f\n", p_aprox);
    fprintf("Error absoluto:    %.15f\n", error_abs);
    fprintf("Error relativo:    %.15f\n", error_rel);


    % ==========================================
    % e. p = e^10 ; p* = 22000
    % ==========================================

    p = exp(10);
    p_aprox = 22000;

    [error_abs, error_rel] = calcularErrores(p, p_aprox);

    fprintf("\ne. p = e^10 ; p* = 22000\n");
    fprintf("Valor verdadero:   %.15f\n", p);
    fprintf("Valor aproximado:  %.15f\n", p_aprox);
    fprintf("Error absoluto:    %.15f\n", error_abs);
    fprintf("Error relativo:    %.15f\n", error_rel);


    % ==========================================
    % f. p = 8! ; p* = 39900
    % ==========================================

    p = factorial(8);
    p_aprox = 39900;

    [error_abs, error_rel] = calcularErrores(p, p_aprox);

    fprintf("\nf. p = 8! ; p* = 39900\n");
    fprintf("Valor verdadero:   %.15f\n", p);
    fprintf("Valor aproximado:  %.15f\n", p_aprox);
    fprintf("Error absoluto:    %.15f\n", error_abs);
    fprintf("Error relativo:    %.15f\n", error_rel);

endfunction


% ==========================================
% FUNCIONES
% ==========================================

function [error_abs, error_rel] = calcularErrores(v_exacto, v_aprox)

    % Error absoluto
    error_abs = abs(v_exacto - v_aprox);

    % Error relativo
    error_rel = error_abs / abs(v_exacto);

endfunction