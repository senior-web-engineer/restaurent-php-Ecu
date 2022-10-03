function validar_coordenadas_copiado(entrada){
    validar_asci_copiado(entrada,"-.0123456789");
}
function validar_latlong_copiado(entrada) {
  validar_asci_copiado(entrada, "-,.0123456789");
}
function validar_soloNumeros_copiado(entrada){
    validar_asci_copiado(entrada,"0123456789");
}
function validar_soloNumeros_copiado_O(entrada){
    validar_asci_copiado(entrada,"+ 0123456789");
}
function validar_soloNumerosDecimales_copiado(entrada){
    validar_asci_copiado(entrada,".0123456789");
}
function validar_URL_copiado(entrada){
    validar_asci_copiado(entrada,"https://maps.google.com/maps?q=-0.2594863%2C-79.1698529&z=17&hl=es");
}
function validar_soloLetras_copiado(entrada){
    validar_asci_copiado(entrada," áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ");
}
function validar_soloLetras_copiado_coma(entrada){
    validar_asci_copiado(entrada," áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ,");
}
function validar_letras_numeros_copiado(entrada){
    validar_asci_copiado(entrada," áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789");
}
function validar_letrasNumeros_copiado(entrada){
    validar_asci_copiado(entrada,' áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789.,+-*/:;&%#$(""=_)');
}
function validar_letras_numeros_copiado_submenu(entrada){
    validar_asci_copiado(entrada," áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789,+&%*");
}
function validar_letras_numeros_copiado_submenu_desc(entrada){
    validar_asci_copiado(entrada," áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789:,+&%*");
}
function validar_letras_numeros_copiado_placa(entrada){
    validar_asci_copiado(entrada," abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789-");
}
function validar_letras_numeros_copiado_serie(entrada){
    validar_asci_copiado(entrada,"abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789");
}
function validar_letras_numeros_copiado_tienda(entrada){
    validar_asci_copiado(entrada," áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789-#'");
}
function validar_letras_numeros_copiado_sin_tilde(entrada){
    validar_asci_copiado(entrada," abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.");
}
function validar_soloLetras(e){
    return valida_codigo_asci(e," áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ");
}
function validar_soloLetras_coma(e){
    return valida_codigo_asci(e," áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ,");
}
function validar_soloNumeros(e){
    return valida_codigo_asci(e, "0123456789");
}
function validar_soloNumeros_O(e){
    return valida_codigo_asci(e, "+ 0123456789");
}
function validar_coordenadas(e){
    return valida_codigo_asci(e, "-.0123456789");
}
function validar_latlong(e) {
  return valida_codigo_asci(e, "-,.0123456789");
}
function validar_soloNumeros_decimales(e){
    return valida_codigo_asci(e, "0123456789.");
}
function validar_LetrasNumerosSubmenu(e){
    return valida_codigo_asci(e, " áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789,+&%*");
}
function validar_LetrasNumerosSubmenuDesc(e){
    return valida_codigo_asci(e, " áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789:',+&%*");
}
function validar_LetrasNumeros(e){
    return valida_codigo_asci(e, " áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789");
}
function validar_LetrasNumeros_Coma(e){
    return valida_codigo_asci(e, ' áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789.,+-*/:;&%#$(""=_)');
}
function validar_CaracteresPlaca(e){
    return valida_codigo_asci(e, " abcdefghijklmnñopqrstuvwxyABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789-");
}
function validar_CaracteresSerie(e){
    return valida_codigo_asci(e, "abcdefghijklmnñopqrstuvwxyABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789");
}
function validar_LetrasNumerosCaracteres(e){
    return valida_codigo_asci(e, " áéíóúabcdefghijklmnñopqrstuvwxyzÁÉÍÓÚABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789-#'");
}
function validar_LetrasNumeros_sintilde(e){
    return valida_codigo_asci(e, " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.");
}
function validar_asci_copiado(entrada,formato_valida){
    var val = document.getElementById(entrada).value;
    var texto=formato_valida;
    var tam = val.length;
    for(i=0;i<tam;i++){
        if(texto.indexOf(val.charAt(i), 0)==-1)
            document.getElementById(entrada).value='';
    }
}
function valida_codigo_asci(e,formato_valida)
{
    key = e.keyCode || e.which;
    tecla = String.fromCharCode(key);
    letras = formato_valida;
    especiales = [8,13];
    tecla_especial = false
    for(var i in especiales){
        if(key == especiales[i]){
            tecla_especial = true;
            break;
        } 
    }
    if(letras.indexOf(tecla)==-1 && !tecla_especial)
        return false;
    else
        return true;
}
function validar_decimales_copiado(entrada){
    var val = document.getElementById(entrada).value;
    var texto="0123456789.";
    var tam = val.length;
    for(i=0;i<tam;i++){
        if(texto.indexOf(val.charAt(i), 0)==-1)
            document.getElementById(entrada).value='';
    }
}
function funcion_validar_decimales(entrada,e)
{
    key = e.keyCode || e.which;
    tecla = String.fromCharCode(key);
    letras = "0123456789.";
    especiales = [8,13];
    tecla_especial = false
    for(var i in especiales){
        if(key == especiales[i]){
            tecla_especial = true;
            break;
        } 
    }
    if(letras.indexOf(tecla)==-1 && !tecla_especial) {
        return false;
    } else{
        var val = document.getElementById(entrada).value;
        var tam = val.length;
        var x=0;
        var contador=0;
        for(x=1;x<=tam;x++)
        {
            if(val.substring(x-1, x)=="."){
                contador=1;
            } 
        }
        if(contador==1 && tecla=="." )
            return false;
        else
            return true;
    } 
}
function compararFecha(fecha1,fecha2)
{
    var fechaSep = fecha1.split('-');
    var fechaSep2 = fecha2.split('-');
    var indicada = new Date(fechaSep[0],fechaSep[1]-1,fechaSep[2]);
    var indicada2 = new Date(fechaSep2[0],fechaSep2[1]-1,fechaSep2[2]);
    if(indicada >indicada2){
        return false;// al retornar falso indica que la fecha 1 es mayor que la fecha 2
    }else{
        return true;
    }			
 
}
