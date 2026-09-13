function punto5()
    clc;
    clear;

    % Valor de x
    x = 4.71;

    % Valor exacto de f(x)
    exacto = x^3 - 6*x^2 + 3*x - 0.149;

    printf("============================================\n");
    printf("PUNTO 5\n");
    printf("============================================\n");

    printf("F. original: f(x) = x^3 - 6x^2 + 3x - 0.149\n\n");

    printf("Valor de x = %.2f\n", x);
    printf("Valor exacto = %.6f\n\n", exacto);


    % =====================================================
    % 5.a - FORMA ORIGINAL
    % =====================================================

    % --- 3 digitos truncados ---
    x2_t = truncar3(x*x);
    x3_t = truncar3(x2_t*x);
    seisx2_t = truncar3(6*x2_t);
    tresx_t = truncar3(3*x);

    resultado_t = truncar3(x3_t - seisx2_t);
    resultado_t = truncar3(resultado_t + tresx_t);
    resultado_t = truncar3(resultado_t - 0.149);

    ea_t = error_absoluto(exacto, resultado_t);
    er_t = error_relativo(exacto, resultado_t);

    printf("============================================\n");
    printf("5.a - Truncamiento\n");
    printf("============================================\n");
    printf("x^2 = %g\n", x2_t);
    printf("x^3 = %g\n", x3_t);
    printf("6x^2 = %g\n", seisx2_t);
    printf("3x = %g\n", tresx_t);
    printf("f(x) = %.1f\n", resultado_t);
    printf("Error absoluto = %.6f\n", ea_t);
    printf("Error relativo = %.6f\n\n", er_t);


    % --- 3 digitos redondeados ---
    x2_r = redondear3(x*x);
    x3_r = redondear3(x2_r*x);
    seisx2_r = redondear3(6*x2_r);
    tresx_r = redondear3(3*x);

    resultado_r = redondear3(x3_r - seisx2_r);
    resultado_r = redondear3(resultado_r + tresx_r);
    resultado_r = redondear3(resultado_r - 0.149);

    ea_r = error_absoluto(exacto, resultado_r);
    er_r = error_relativo(exacto, resultado_r);

    printf("============================================\n");
    printf("5.a - Redondeamiento\n");
    printf("============================================\n");
    printf("x^2 = %g\n", x2_r);
    printf("x^3 = %g\n", x3_r);
    printf("6x^2 = %g\n", seisx2_r);
    printf("3x = %g\n", tresx_r);
    printf("f(x) = %.1f\n", resultado_r);
    printf("Error absoluto = %.6f\n", ea_r);
    printf("Error relativo = %.6f\n\n", er_r);


    % =====================================================
    % 5.b - FORMA ANIDADA
    % =====================================================

    printf("############################################\n");
    printf("5b. Reescritura de la funcion: Forma anidada\n");
    printf("f(x) = x^3 - 6x^2 + 3x - 0.149\n");
    printf("f(x) = x(x(x - 6) + 3) - 0.149\n");
    printf("############################################\n\n");

    % --- 3 digitos truncados ---
    paso1_t = truncar3(x - 6);
    paso2_t = truncar3(paso1_t * x);
    paso3_t = truncar3(paso2_t + 3);
    paso4_t = truncar3(paso3_t * x);

    resultado_anidado_t = truncar3(paso4_t - 0.149);

    ea_anidado_t = error_absoluto(exacto, resultado_anidado_t);
    er_anidado_t = error_relativo(exacto, resultado_anidado_t);

    printf("============================================\n");
    printf("5.b - Anidada - Truncamiento\n");
    printf("============================================\n");
    printf("f(x) = %.1f\n", resultado_anidado_t);
    printf("Error absoluto = %.6f\n", ea_anidado_t);
    printf("Error relativo = %.6f\n\n", er_anidado_t);


    % --- 3 digitos redondeados ---
    paso1_r = redondear3(x - 6);
    paso2_r = redondear3(paso1_r * x);
    paso3_r = redondear3(paso2_r + 3);
    paso4_r = redondear3(paso3_r * x);

    resultado_anidado_r = redondear3(paso4_r - 0.149);

    ea_anidado_r = error_absoluto(exacto, resultado_anidado_r);
    er_anidado_r = error_relativo(exacto, resultado_anidado_r);

    printf("============================================\n");
    printf("5.b - Anidada - Redondeamiento\n");
    printf("============================================\n");
    printf("f(x) = %.1f\n", resultado_anidado_r);
    printf("Error absoluto = %.6f\n", ea_anidado_r);
    printf("Error relativo = %.6f\n", er_anidado_r);

endfunction


% =========================================================
% FUNCIONES
% =========================================================

% Trunca a 3 digitos
function y = truncar3(x)
    if x == 0
        y = 0;
        return;
    endif
    n = floor(log10(abs(x)));
    factor = 10^(3 - 1 - n);
    y = fix(x * factor) / factor;
endfunction

% Redondea a 3 digitos
function y = redondear3(x)
    if x == 0
        y = 0;
        return;
    endif
    n = floor(log10(abs(x)));
    factor = 10^(3 - 1 - n);
    y = round(x * factor) / factor;
endfunction

% Calculo de errores
function error = error_absoluto(exacto, aproximado)
    error = abs(exacto - aproximado);
endfunction

function error = error_relativo(exacto, aproximado)
    error = abs(exacto - aproximado) / abs(exacto);
endfunction