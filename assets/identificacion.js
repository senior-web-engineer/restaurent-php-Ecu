var NUMERO_DE_PROVINCIAS = 24;
var modulo;
var autoverificador = 0;
var digito_verificador_procesado = 0;
var residuo = 0;
var coeficiente = 0;
var sumatoria=0;
function verificador_identificativo(identificativo) {
    // NOTA: los substring comienzan desde 0 y siempre hay q poner un intervalo    
    var numero_caracteres = identificativo.length;
    if (numero_caracteres < 10 || (numero_caracteres > 10 && numero_caracteres < 13)) { // valido que sea tenga los 10 digitos de la cedula o los 13 del ruc
        return false;
    }
    var num_provincia = identificativo.substring(0, 2);  //obtengo el numero de provincias
    if (num_provincia == 0 || num_provincia > NUMERO_DE_PROVINCIAS) {
        return false;
    }
    var digitos_especiales = identificativo.substring(0, 10); // digitos especiales
    if (digitos_especiales=="0000000000" || digitos_especiales=="2222222222" || digitos_especiales=="0202020202" || digitos_especiales=="2424242424") {
        return false;
    }
    var tercer_digito = identificativo.substring(2, 3); // digito 3 permite clasificar a las personas
    if ((tercer_digito == 6 || tercer_digito == 9) && numero_caracteres != 13) { // si es 9 y 6 obligado debe tener 13 digitos
        return false;
    }
    var ultimos_caracteres = 0;
    if (numero_caracteres == 13) {
        ultimos_caracteres = identificativo.substring(10, 13); // obtengo los 3 ultimos caracteres
        if ((tercer_digito == 9 || (tercer_digito >= 0 && tercer_digito <= 5)) && ultimos_caracteres == 0) // valido que no sea 000
        {
            return false;
        }
        ultimos_caracteres = identificativo.substring(9, 13); // obtengo los 4 ultimos caracteres
        if (tercer_digito == 6 && ultimos_caracteres == 0) // valido que no sea 0000
        {
            return false;
        }
    }   
    sumatoria = 0;
    if (tercer_digito >= 0 && tercer_digito <= 5) {
        validar_persona_natural(identificativo); // persona natural
    } else if (tercer_digito == 9) {
        validar_persona_juridica_yextanjeros_sin_cedula(identificativo); //persona juridica
    } else {
        validar_persona_publica(identificativo);// persona publica
    }
    residuo = sumatoria % modulo;
    if (residuo == 0) {
        digito_verificador_procesado = 0;
    } else {
        digito_verificador_procesado = modulo - residuo;
    }
    if (digito_verificador_procesado == autoverificador) {
        return true;
    } else {
        return false;
    }
}
function validar_persona_natural(identificativo) {
    modulo = 10;
    autoverificador =identificativo.substring(9, 10); // digito 10 
    coeficiente = 2;//2.1.2.1.2.1.2.1.2
    for (var i = 1; i <= 9; i++) {
        var digito_identificativo = identificativo.substring(i - 1, i);
        var multiplicacion = coeficiente * digito_identificativo;
        if (multiplicacion > 9) { // si es mayor a 10 suma entre digitos
            var digito1 =multiplicacion.toString().substring(0, 1);
            var digito2 = multiplicacion.toString().substring(1, 2);
            sumatoria += (eval(digito1) + eval(digito2));  // sumo entre digitos si mayor o igual a 10
        } else {
            sumatoria += multiplicacion;
        }
        if (coeficiente == 2) {
            coeficiente = 1;
        } else {
            coeficiente = 2;
        }
    }
}
function validar_persona_juridica_yextanjeros_sin_cedula( identificativo) {
    modulo = 11;
    autoverificador = identificativo.substring(9, 10);// digito 10
    coeficiente = 4; //4.3.2.7.6.5.4.3.2
    for (var i = 1; i <= 9; i++) {
        var digito_identificativo = identificativo.substring(i - 1, i);// extraigo cada digito
        sumatoria += coeficiente * digito_identificativo;
        if (coeficiente == 2) {
            coeficiente = 7;
        } else {
            coeficiente -= 1;
        }
    }
}
function validar_persona_publica(identificativo) {
    modulo = 11;
    autoverificador = identificativo.substring(8, 9);// digito 9
    coeficiente = 3; //3.2.7.6.5.4.3.2
    for (var i = 1; i <= 8; i++) {
        var digito_identificativo = identificativo.substring(i - 1, i);// extraigo cada digito
        sumatoria += coeficiente * digito_identificativo;
        if (coeficiente == 2) {
            coeficiente = 7;
        } else {
            coeficiente -= 1;
        }
    }
}

